#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3

"""OCR of 990 PDFs into confidence-scored financial observations.

The OCR engine is the bundled ``tesseract`` binary (plus ``pdftoppm`` from poppler
to rasterize PDF pages) — invoked via subprocess, so the Python side stays
stdlib-only. Tesseract's TSV output gives a **per-word confidence**, which becomes
the per-reading confidence on each observation. Mapping recognized amounts to
canonical concepts is a best-effort, label-proximity heuristic (a 990 PDF's layout
varies), so low-confidence readings should be reviewed — they are never silently
trusted over a higher-confidence source (canonical selection stays manual).
"""

import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

# Known 990 line labels → canonical concept code. Best-effort and intentionally
# small; extend as real PDFs are seen. Matching is case-insensitive substring.
_LABEL_CONCEPTS: list[tuple[str, str]] = [
    ("total revenue", "cy_rev"),
    ("total expenses", "cy_exp"),
    ("total functional expenses", "total_exp"),
    ("program service expenses", "prog"),
    ("management and general", "admin"),
    ("fundraising expenses", "fund"),
    ("total contributions", "contrib"),
    ("contributions and grants", "contrib"),
    ("total assets", "assets"),
    ("total liabilities", "liabilities"),
    ("net assets or fund balances", "equity"),
]

_AMOUNT = re.compile(r"-?\$?\(?[\d,]{1,15}(?:\.\d+)?\)?$")


def ocr_available() -> bool:
    """True when both required binaries are on PATH (bundled by the Nix build)."""
    return bool(shutil.which("tesseract") and shutil.which("pdftoppm"))


def _pdf_to_pngs(pdf_path: str, outdir: str) -> list[str]:
    subprocess.run(["pdftoppm", "-png", "-r", "300", pdf_path, str(Path(outdir) / "page")],
                   check=True, capture_output=True)
    return sorted(str(p) for p in Path(outdir).glob("page*.png"))


def parse_tsv(tsv: str) -> list[dict]:
    """Parse tesseract TSV into word rows: {text, conf (0..1), line, left}. Skips
    the header, blank words, and conf < 0 (tesseract's 'no word' marker)."""
    words = []
    for row in tsv.splitlines()[1:]:
        cols = row.split("\t")
        if len(cols) < 12:
            continue
        try:
            conf = float(cols[10])
        except ValueError:
            continue
        text = cols[11].strip()
        if conf < 0 or not text:
            continue
        # line key is (page, block, par, line) — NOT word_num — so words on the
        # same physical line group together.
        words.append({"text": text, "conf": conf / 100.0,
                      "line": tuple(cols[1:5]), "left": int(cols[6]) if cols[6].isdigit() else 0})
    return words


def _amount_to_float(token: str):
    t = token.replace("$", "").replace(",", "").strip()
    neg = t.startswith("(") and t.endswith(")")
    t = t.strip("()")
    try:
        v = float(t)
    except ValueError:
        return None
    return -v if neg else v


def extract_concepts(words: list[dict]) -> dict[str, dict]:
    """Best-effort {concept: {value, confidence}} from OCR words: group by line,
    and for a line whose text contains a known label take the right-most amount
    token as the value, with confidence = the min word-confidence over the label +
    amount tokens. First match per concept wins."""
    lines: dict[tuple, list[dict]] = {}
    for w in words:
        lines.setdefault(w["line"], []).append(w)
    out: dict[str, dict] = {}
    for line_words in lines.values():
        line_words.sort(key=lambda w: w["left"])
        text = " ".join(w["text"] for w in line_words).lower()
        for label, concept in _LABEL_CONCEPTS:
            if concept in out or label not in text:
                continue
            amounts = [(w, _amount_to_float(w["text"])) for w in line_words
                       if _AMOUNT.match(w["text"]) and _amount_to_float(w["text"]) is not None]
            if not amounts:
                continue
            amt_word, value = amounts[-1]       # right-most amount on the line
            # Confidence = min over the words that justify this reading: the tokens
            # that make up the matched label, plus the chosen amount token — NOT
            # the whole line, whose unrelated words shouldn't drag confidence down.
            label_tokens = set(label.split())
            relevant = [lw["conf"] for lw in line_words
                        if lw is amt_word or lw["text"].lower().strip(":.$,") in label_tokens]
            conf = min(relevant) if relevant else amt_word["conf"]
            out[concept] = {"value": value, "confidence": round(conf, 4)}
    return out


def ocr_pdf(pdf_path: str) -> dict:
    """OCR a 990 PDF → {pages, concepts: {concept: {value, confidence}}}. Raises
    RuntimeError if the OCR binaries are unavailable."""
    if not ocr_available():
        raise RuntimeError("OCR requires the 'tesseract' and 'pdftoppm' binaries "
                           "(bundled in the Nix build / dev shell).")
    words: list[dict] = []
    with tempfile.TemporaryDirectory() as td:
        pages = _pdf_to_pngs(pdf_path, td)
        for png in pages:
            tsv = subprocess.run(["tesseract", png, "stdout", "tsv"],
                                 check=True, capture_output=True, text=True).stdout
            words.extend(parse_tsv(tsv))
    return {"pages": len(set(w["line"][0] for w in words)) or 0,
            "concepts": extract_concepts(words)}


def record_ocr(db, ein: str, fiscal_year: int, result: dict, *, filename=None, actor=None) -> dict:
    """Store an OCR result as ocr_990_pdf observations (one per concept, carrying
    its confidence). Canonical selection stays manual, so these never override a
    higher-trust source automatically."""
    values = {c: v["value"] for c, v in result["concepts"].items()}
    if not values:
        return {"recorded": 0, "observations": []}
    # Record each concept with its own confidence by writing per-concept (the
    # per-document confidence arg is uniform, so set each observation's directly).
    out = db.financials.record_observations(
        ein, fiscal_year, "ocr_990_pdf", values, kind="ocr", filename=filename, actor=actor)
    for obs in out.get("observations", []):
        conf = result["concepts"].get(obs["concept_code"], {}).get("confidence")
        if conf is not None:
            db.cursor.execute(
                "UPDATE financial_observation SET confidence = ? WHERE observation_id = ?",
                (conf, obs["observation_id"]))
    db.connection.commit()
    return out


# ── CLI ────────────────────────────────────────────────────────────────────────

def cmd_ocr(args) -> int:
    from console import _B, _R, _GRN, _CYN, _RED, _DIM
    if not ocr_available():
        print(f"{_RED}OCR unavailable: 'tesseract' and 'pdftoppm' must be on PATH "
              f"(use the Nix dev shell / build).{_R}", file=sys.stderr)
        return 1
    if not Path("OpenReturn.db").exists():
        print("OpenReturn.db not found — run from the data directory.", file=sys.stderr)
        return 1
    from database import OpenReturnDB
    try:
        result = ocr_pdf(args.file)
    except (RuntimeError, subprocess.CalledProcessError) as e:
        print(f"{_RED}OCR failed: {e}{_R}", file=sys.stderr)
        return 1
    db = OpenReturnDB()
    db.cursor.execute("INSERT OR IGNORE INTO organization (ein, name) VALUES (?, ?)",
                      (args.ein, args.ein))
    out = record_ocr(db, args.ein, args.year, result, filename=Path(args.file).name)
    db.close()
    print(f"\n{_B}{_GRN}OCR'd{_R} {Path(args.file).name}  {_DIM}({result['pages']} page(s)){_R}")
    for concept, v in result["concepts"].items():
        print(f"  {_CYN}{concept:<12}{_R} {v['value']:>15,.0f}  {_DIM}conf {v['confidence']:.2f}{_R}")
    print(f"\n  recorded {out['recorded']} observation(s) (source ocr_990_pdf) "
          f"for {args.ein} {args.year}.\n")
    return 0
