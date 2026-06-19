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

# Per-FORM line-label → canonical concept maps. The SAME printed label means
# different concepts across forms (a 990-PF's "total assets" is pf_total_assets,
# NOT the 990 `assets`), so detect_form() picks the map before extraction. Each
# list is intentionally small; extend as real PDFs are seen. Matching is
# case-insensitive substring; within a physical line the first entry whose concept
# isn't filled yet wins. "total functional expenses" is listed before "total
# expenses" for clarity (neither is a substring of the other, so order is safe).
_LABELS_990: list[tuple[str, str]] = [
    ("total revenue", "cy_rev"),
    ("total functional expenses", "total_exp"),
    ("total expenses", "cy_exp"),
    ("program service expenses", "prog"),
    ("management and general", "admin"),
    ("fundraising expenses", "fund"),
    ("total contributions", "contrib"),
    ("contributions and grants", "contrib"),
    ("investment income", "invest_inc"),
    ("grants and similar amounts paid", "cy_grants"),
    ("total assets", "assets"),
    ("total liabilities", "liabilities"),
    ("net assets or fund balances", "equity"),
]

# Form 990-PF (private foundation): distinct concept codes. PF financial rows are
# multi-column (Revenue&Expenses / Net investment income / Adjusted net income /
# Disbursements for charitable purposes), so column selection is imprecise here —
# PF extraction is PRELIMINARY (no real PF sample yet). Values are confidence-
# scored and canonical selection stays manual, so nothing auto-trusts these.
_LABELS_990PF: list[tuple[str, str]] = [
    ("total expenses and disbursements", "pf_total_exp"),
    ("disbursements for charitable purposes", "pf_charitable_disb"),
    ("contributions, gifts, grants paid", "pf_grants_paid"),
    ("contributions, gifts, and grants paid", "pf_grants_paid"),
    ("total assets", "pf_total_assets"),
    ("net assets or fund balances", "pf_net_assets"),
]

# 990-EZ reuses the 990 concept codes with near-identical line labels.
_FORM_LABELS: dict[str, list[tuple[str, str]]] = {
    "990": _LABELS_990,
    "990EZ": _LABELS_990,
    "990PF": _LABELS_990PF,
}

# Per-reading confidence below this is flagged for human review (the OCR layout
# heuristic is best-effort; canonical selection is manual regardless).
_REVIEW_THRESHOLD = 0.80

_AMOUNT = re.compile(r"-?\$?\(?[\d,]{1,15}(?:\.\d+)?\)?$")

# Concepts that are a ROW TOTAL on a multi-column row. The Part IX "Total
# functional expenses" row is laid out [Total(A), Program(B), Management(C),
# Fundraising(D)] (often preceded by the line number "25"), so the right-most
# amount is the fundraising column and the left-most is the line number — neither
# is the total. The grand total is column (A), which by construction is the
# LARGEST amount on the row (it is the sum of B+C+D). Single-/two-amount lines
# (e.g. Part I's prior/current-year pair) are unaffected by this rule.
_ROW_TOTAL_CONCEPTS = frozenset({"total_exp"})


def ocr_available() -> bool:
    """True when both required binaries are on PATH (bundled by the Nix build)."""
    return bool(shutil.which("tesseract") and shutil.which("pdftoppm"))


def _pdf_to_pngs(pdf_path: str, outdir: str) -> list[str]:
    subprocess.run(["pdftoppm", "-png", "-r", "300", pdf_path, str(Path(outdir) / "page")],
                   check=True, capture_output=True)
    return sorted(str(p) for p in Path(outdir).glob("page*.png"))


def parse_tsv(tsv: str, page: int = 0) -> list[dict]:
    """Parse tesseract TSV into word rows: {text, conf (0..1), line, left}. Skips
    the header, blank words, and conf < 0 (tesseract's 'no word' marker).

    `page` is the source-image index: tesseract OCRs each PDF page as a separate
    image and resets its TSV ``page`` column to 1 every time, so the per-image
    (block,par,line) coordinates collide across physical pages. Prepending the
    image index keeps each physical line's key unique — otherwise `extract_concepts`
    would merge words from different pages that happen to share line coordinates."""
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
        # line key is (image, page, block, par, line) — NOT word_num — so words on
        # the same physical line group together, kept distinct across pages.
        words.append({"text": text, "conf": conf / 100.0,
                      "line": (page, *cols[1:5]), "left": int(cols[6]) if cols[6].isdigit() else 0})
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


def detect_form(words: list[dict]) -> str:
    """Best-effort 990 / 990-EZ / 990-PF detection from the FIRST page's text (the
    form title), so extract_concepts can pick the right label→concept map. Keyed on
    the form TITLE — note a standard 990's subtitle reads "(except private
    foundations)", so we must match "return of private foundation" (the PF title),
    NOT the bare phrase "private foundation". Defaults to '990'."""
    first = [w["text"] for w in words if w["line"][0] == 0] or [w["text"] for w in words]
    text = " ".join(first).lower()
    if "return of private foundation" in text or "form 990-pf" in text:
        return "990PF"
    if "short form return" in text or "form 990-ez" in text:
        return "990EZ"
    return "990"


def extract_concepts(words: list[dict], form: str = "990") -> dict[str, dict]:
    """Best-effort {concept: {value, confidence, review}} from OCR words: group by
    line, and for a line whose text contains a known label (for the given form)
    take the right-most amount token as the value — except a multi-column row total
    (_ROW_TOTAL_CONCEPTS) takes the largest amount. Confidence = the min
    word-confidence over the label + amount tokens; `review` flags it below
    _REVIEW_THRESHOLD. First match per concept wins."""
    labels = _FORM_LABELS.get(form, _LABELS_990)
    lines: dict[tuple, list[dict]] = {}
    for w in words:
        lines.setdefault(w["line"], []).append(w)
    out: dict[str, dict] = {}
    for line_words in lines.values():
        line_words.sort(key=lambda w: w["left"])
        text = " ".join(w["text"] for w in line_words).lower()
        for label, concept in labels:
            if concept in out or label not in text:
                continue
            amounts = [(w, _amount_to_float(w["text"])) for w in line_words
                       if _AMOUNT.match(w["text"]) and _amount_to_float(w["text"]) is not None]
            if not amounts:
                continue
            # Right-most amount by default (Part I current-year column); but a row
            # total on a multi-column functional-expense row is column (A), the
            # largest amount on the line (the line number / component columns are
            # all smaller).
            if concept in _ROW_TOTAL_CONCEPTS and len(amounts) >= 3:
                amt_word, value = max(amounts, key=lambda a: a[1])
            else:
                amt_word, value = amounts[-1]
            # Confidence = min over the words that justify this reading: the tokens
            # that make up the matched label, plus the chosen amount token — NOT
            # the whole line, whose unrelated words shouldn't drag confidence down.
            label_tokens = set(label.split())
            relevant = [lw["conf"] for lw in line_words
                        if lw is amt_word or lw["text"].lower().strip(":.$,") in label_tokens]
            conf = round(min(relevant) if relevant else amt_word["conf"], 4)
            out[concept] = {"value": value, "confidence": conf,
                            "review": conf < _REVIEW_THRESHOLD}
    return out


def ocr_pdf(pdf_path: str) -> dict:
    """OCR a 990 PDF → {pages, form, concepts: {concept: {value, confidence,
    review}}}. The form (990 / 990-EZ / 990-PF) is detected from the first page and
    selects the label→concept map. Raises RuntimeError if the OCR binaries are
    unavailable."""
    if not ocr_available():
        raise RuntimeError("OCR requires the 'tesseract' and 'pdftoppm' binaries "
                           "(bundled in the Nix build / dev shell).")
    words: list[dict] = []
    with tempfile.TemporaryDirectory() as td:
        pages = _pdf_to_pngs(pdf_path, td)
        for i, png in enumerate(pages):
            tsv = subprocess.run(["tesseract", png, "stdout", "tsv"],
                                 check=True, capture_output=True, text=True).stdout
            words.extend(parse_tsv(tsv, page=i))
    form = detect_form(words)
    return {"pages": len(pages), "form": form,
            "concepts": extract_concepts(words, form=form)}


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
    print(f"\n{_B}{_GRN}OCR'd{_R} {Path(args.file).name}  "
          f"{_DIM}({result['pages']} page(s) · detected {result.get('form', '990')}){_R}")
    review = 0
    for concept, v in result["concepts"].items():
        flag = f"  {_RED}⚠ review{_R}" if v.get("review") else ""
        if v.get("review"):
            review += 1
        print(f"  {_CYN}{concept:<12}{_R} {v['value']:>15,.0f}  "
              f"{_DIM}conf {v['confidence']:.2f}{_R}{flag}")
    print(f"\n  recorded {out['recorded']} observation(s) (source ocr_990_pdf) "
          f"for {args.ein} {args.year}.")
    if review:
        print(f"  {_RED}{review} reading(s) below {_REVIEW_THRESHOLD:.0%} confidence "
              f"— review before trusting.{_R}")
    print()
    return 0
