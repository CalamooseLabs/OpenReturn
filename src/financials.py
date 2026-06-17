#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3

"""`openreturn financials` — derive/import unified financial observations.

``rebuild`` mirrors stored 990 values into the canonical observation layer (the
one-time backfill, also run automatically during scoring). ``import`` loads
non-990 financials (e.g. audited statements) from a JSON file as observations.
"""

import json
import sys
from pathlib import Path

from console import _B, _R, _GRN, _CYN, _RED, _DIM
from database import OpenReturnDB


def _require_db() -> OpenReturnDB:
    if not Path('OpenReturn.db').exists():
        print("OpenReturn.db not found — run openreturn financials from the data directory.",
              file=sys.stderr)
        sys.exit(1)
    return OpenReturnDB()


def cmd_rebuild(args) -> int:
    db = _require_db()
    res = db.financials.rebuild(eins=(args.org or None))
    db.close()
    print(f"\n{_B}{_GRN}Derived{_R} {res['observations']:,} 990 observations across "
          f"{res['orgs']:,} org(s).\n")
    return 0


def cmd_backfill_values(args) -> int:
    """Backfill the denormalized financial_canonical.value for rows created before
    the column existed (so scoring reads canonical without joining
    financial_observation). This normally runs AUTOMATICALLY the first time the
    upgraded database is opened (marker-gated in _migrate_columns); this command
    forces/repeats it (resumable + idempotent, safe to re-run)."""
    db = _require_db()

    def progress(done: int, total: int) -> None:
        pct = (100 * done / total) if total else 100.0
        print(f"\r  {_GRN}{done:,}/{total:,}{_R} rows  {pct:5.1f}%", end='', flush=True)

    print(f"{_B}Backfilling{_R} financial_canonical.value {_DIM}(resumable){_R}")
    filled = db.financials.backfill_canonical_values(progress=progress)
    db.close()
    print(f"\n  {_GRN}{filled:,}{_R} canonical values filled.\n")
    return 0


def cmd_import(args) -> int:
    """Import financial observations from a JSON file: either one object
    {ein, fiscal_year, source?, confidence?, values:{concept:number}} or a list
    of them. --ein/--year/--source fill in any missing fields."""
    db = _require_db()
    try:
        with open(args.file) as fh:
            payload = json.load(fh)
    except (OSError, json.JSONDecodeError) as e:
        db.close()
        print(f"{_RED}could not read {args.file}: {e}{_R}", file=sys.stderr)
        return 1
    records = payload if isinstance(payload, list) else [payload]
    total = 0
    for rec in records:
        ein = rec.get('ein') or args.ein
        year = rec.get('fiscal_year') or args.year
        source = rec.get('source') or args.source
        if not (ein and year and rec.get('values')):
            db.close()
            print(f"{_RED}each record needs ein, fiscal_year, and values{_R}", file=sys.stderr)
            return 1
        try:
            out = db.financials.record_observations(
                ein, int(year), source, rec['values'], confidence=rec.get('confidence'),
                kind='import', note=rec.get('note'))
        except (ValueError, TypeError) as e:
            db.close()
            print(f"{_RED}{e}{_R}", file=sys.stderr)
            return 1
        total += out['recorded']
        print(f"  {_CYN}{ein}{_R} {year} {_DIM}({source}){_R}  {out['recorded']} observations")
    db.close()
    print(f"\n{_B}{_GRN}Imported{_R} {total:,} observations.\n")
    return 0
