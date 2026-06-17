"""Model templates — a read-only catalog of scoring-model definitions that PREFILL
a model builder (they are guides, not installable/active models). The bundled
``*.toml`` files in this package are the catalog; the frontend lists them and
fetches one to seed its editor, then the operator creates the model from it
(`POST /admin/models` / `openreturn models register`). Grow the catalog by adding
a `.toml` here.

A template's ``code`` is its filename stem. The TOML is the same format
``openreturn models register`` accepts (`[model]` + `[[factor]]`), so a template
round-trips straight into a model.
"""

import sys
from pathlib import Path

try:
    import tomllib
except ImportError:  # pragma: no cover — Python 3.11+ required (also enforced in models.py)
    print("Error: Python 3.11+ is required for templates (tomllib not found).", file=sys.stderr)
    raise

_DIR = Path(__file__).parent


def _load(path: Path) -> dict:
    with open(path, 'rb') as fh:
        return tomllib.load(fh)


def template_codes() -> list[str]:
    """Catalog codes (filename stems), sorted — version order for the bundled stack."""
    return sorted(p.stem for p in _DIR.glob('*.toml'))


def _summary(code: str, data: dict) -> dict:
    m = data.get('model', {})
    return {"code": code, "name": m.get('description') or code,
            "description": m.get('description'), "kind": m.get('kind', 'model'),
            "type": m.get('type'), "version": m.get('version'),
            "factor_count": len(data.get('factor', []))}


def list_templates() -> list[dict]:
    """Catalog summaries (code / name / kind / type / version / factor_count) for a
    picker. Use :func:`get_template` for the full prefill definition."""
    return [_summary(p.stem, _load(p)) for p in sorted(_DIR.glob('*.toml'))]


def get_template(code: str) -> dict | None:
    """The full parsed definition (`{model, factor}`) for ``code`` — what a builder
    prefills with — or None if no such template."""
    path = _DIR / f"{code}.toml"
    if not path.is_file() or path.parent != _DIR:   # guard against path escapes
        return None
    return _load(path)


def get_template_toml(code: str) -> str | None:
    """The raw TOML text of a template (for the CLI / copy-paste), or None."""
    path = _DIR / f"{code}.toml"
    if not path.is_file() or path.parent != _DIR:
        return None
    return path.read_text()


# ── CLI ──────────────────────────────────────────────────────────────────────

def cmd_list(args) -> int:
    from console import _B, _R, _DIM, _CYN
    rows = list_templates()
    if not rows:
        print("No templates in the catalog.")
        return 0
    print(f"\n{_B}Model templates{_R}  {_DIM}(prefill a model, then create it){_R}\n")
    for t in rows:
        print(f"  {_CYN}{t['code']:<28}{_R} {_DIM}{t['kind']:<15}{_R} {t['description'] or ''}")
    print(f"\n  {_DIM}openreturn templates show <code>  → the TOML to register / edit{_R}\n")
    return 0


def cmd_show(args) -> int:
    toml = get_template_toml(args.code)
    if toml is None:
        print(f"No such template: {args.code}", file=sys.stderr)
        return 1
    print(toml)
    return 0
