#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3

"""`openreturn counties` — deduce each org's county from its filer ZIP.

The 990 carries no county, so county is deduced offline from a bundled-empty
ZIP→county crosswalk. `counties import <file>` loads a crosswalk CSV (e.g. the
public HUD USPS ZIP-COUNTY file, https://www.huduser.gov/portal/datasets/usps_crosswalk.html)
— keeping the *dominant* county per ZIP (highest residential share) — then derives
county for every org. `counties derive` re-derives without re-importing. County is a
best-effort deduction: a ZIP straddling a county line is approximated by its dominant
county.

The import is column-flexible (header-driven, case-insensitive). It recognizes:
  ZIP / ZIPCODE / ZIP5            → zipcode
  COUNTY / COUNTY_FIPS / FIPS     → 5-digit county FIPS
  RES_RATIO / RESIDENTIAL_RATIO   → residential share (picks the dominant county)
  USPS_ZIP_PREF_STATE / STATE...  → state code (optional)
  COUNTY_NAME / COUNTYNAME / NAME → county name (optional; HUD has none → left NULL)
"""

import csv
import sys
from pathlib import Path

_ZIP_KEYS   = ('zip', 'zipcode', 'zip5', 'zip_code')
_FIPS_KEYS  = ('county', 'county_fips', 'fips', 'geoid')
_RES_KEYS   = ('res_ratio', 'residential_ratio', 'res_rat')
_STATE_KEYS = ('usps_zip_pref_state', 'state', 'state_code', 'stusps')
_NAME_KEYS  = ('county_name', 'countyname', 'name', 'namelsad')


def _pick(headers_lower: dict, keys) -> str | None:
    """Return the actual header for the first matching candidate key (or None)."""
    for k in keys:
        if k in headers_lower:
            return headers_lower[k]
    return None


def parse_crosswalk(path: str) -> list[tuple]:
    """Parse a ZIP→county crosswalk CSV into (zipcode, county_fips, county_name,
    state_code, dominant) rows — one dominant row per ZIP (max residential ratio),
    plus the non-dominant rows flagged 0. Raises ValueError if the ZIP/FIPS columns
    aren't found."""
    with open(path, newline='') as fh:
        reader = csv.DictReader(fh)
        headers_lower = {h.lower().strip(): h for h in (reader.fieldnames or [])}
        zip_h = _pick(headers_lower, _ZIP_KEYS)
        fips_h = _pick(headers_lower, _FIPS_KEYS)
        if not zip_h or not fips_h:
            raise ValueError("crosswalk must have a ZIP column and a county FIPS column "
                             f"(saw headers: {list(headers_lower.values())})")
        res_h, state_h, name_h = (_pick(headers_lower, _RES_KEYS),
                                  _pick(headers_lower, _STATE_KEYS),
                                  _pick(headers_lower, _NAME_KEYS))
        by_zip: dict[str, list[dict]] = {}
        for r in reader:
            z = (r.get(zip_h) or '').strip().replace('-', '')[:5]
            fips = (r.get(fips_h) or '').strip()
            if not z or not fips:
                continue
            try:
                res = float(r.get(res_h)) if res_h and r.get(res_h) not in (None, '') else 0.0
            except ValueError:
                res = 0.0
            by_zip.setdefault(z, []).append({
                "fips": fips, "name": (r.get(name_h) or '').strip() or None if name_h else None,
                "state": (r.get(state_h) or '').strip().upper() or None if state_h else None,
                "res": res})
    rows = []
    for z, cands in by_zip.items():
        cands.sort(key=lambda c: c["res"], reverse=True)   # dominant = highest res share
        for i, c in enumerate(cands):
            rows.append((z, c["fips"], c["name"], c["state"], 1 if i == 0 else 0))
    return rows


def _require_db(db_path):
    if not Path(db_path).exists():
        print(f"Database not found: {db_path} — run an ingest first.", file=sys.stderr)
        return None
    from database import OpenReturnDB
    return OpenReturnDB(path=db_path)


def cmd_import(args) -> int:
    db_path = getattr(args, 'db', None) or 'OpenReturn.db'
    if not Path(args.file).exists():
        print(f"Crosswalk file not found: {args.file}", file=sys.stderr)
        return 1
    db = _require_db(db_path)
    if db is None:
        return 1
    from console import _B, _R, _DIM, _GRN, _CYN
    try:
        rows = parse_crosswalk(args.file)
    except ValueError as e:
        print(f"{e}", file=sys.stderr)
        db.close()
        return 1
    n = db.orgs.import_zip_county(rows)
    derived = db.orgs.derive_counties()
    db.close()
    zips = len({r[0] for r in rows})
    print(f"\n{_B}{_GRN}Imported{_R} {_CYN}{n:,}{_R} crosswalk row(s) "
          f"covering {_CYN}{zips:,}{_R} ZIP(s) {_DIM}from {Path(args.file).name}{_R}")
    print(f"  derived county for {_GRN}{derived['updated']:,}{_R} address(es)\n")
    return 0


def cmd_derive(args) -> int:
    db = _require_db(getattr(args, 'db', None) or 'OpenReturn.db')
    if db is None:
        return 1
    from console import _GRN, _R, _DIM
    have = db.cursor.execute("SELECT COUNT(*) FROM zip_county").fetchone()[0]
    res = db.orgs.derive_counties()
    db.close()
    if not have:
        print("ZIP→county crosswalk is empty — run `openreturn counties import <file>` first.")
        return 0
    print(f"  {_GRN}{res['updated']:,}{_R} address(es) updated {_DIM}(from {have:,} crosswalk rows){_R}")
    return 0


if __name__ == '__main__':  # pragma: no cover
    import argparse
    ap = argparse.ArgumentParser(prog='openreturn-counties')
    sub = ap.add_subparsers(dest='cmd', required=True)
    imp = sub.add_parser('import')
    imp.add_argument('file')
    imp.add_argument('--db', default=None)
    der = sub.add_parser('derive')
    der.add_argument('--db', default=None)
    a = ap.parse_args()
    sys.exit(cmd_import(a) if a.cmd == 'import' else cmd_derive(a))
