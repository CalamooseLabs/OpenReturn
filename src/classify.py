#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3

"""`openreturn classify` — (re)derive each org's foundation/nonprofit type.

Caches a classification on every organization from the forms it has filed and its
grant activity: ``org_type`` is 'foundation' (ever filed a 990-PF), 'nonprofit'
(990/990-EZ/990-N), 'other' (e.g. 990-T only), or NULL (unknown); ``is_grantmaker``
is set for any org that has grant edges (incl. Schedule-I grantmaking charities).
The ingest finalize refreshes touched orgs automatically; run this for a one-time
backfill or after editing filings directly. Re-runnable and idempotent.
"""

import sys
from pathlib import Path


def cmd_classify(args) -> int:
    db_path = getattr(args, 'db', None) or 'OpenReturn.db'
    if not Path(db_path).exists():
        print(f"Database not found: {db_path} — run an ingest first.", file=sys.stderr)
        return 1

    from database import OpenReturnDB
    from console import _B, _R, _DIM, _GRN, _CYN

    db = OpenReturnDB(path=db_path)
    try:
        print(f"{_B}Classifying organizations{_R}  {_DIM}(foundation / nonprofit / grantmaker){_R}")
        result = db.orgs.classify_organizations()
        counts = {r[0]: r[1] for r in db.cursor.execute(
            "SELECT COALESCE(org_type, 'unknown'), COUNT(*) FROM organization GROUP BY org_type"
        ).fetchall()}
        gm = db.cursor.execute(
            "SELECT COUNT(*) FROM organization WHERE is_grantmaker = 1").fetchone()[0]
        print(f"  {_GRN}{result['classified']:,}{_R} org(s) classified")
        for t in ('foundation', 'nonprofit', 'other', 'unknown'):
            if counts.get(t):
                print(f"    {_CYN}{t:<11}{_R} {counts[t]:,}")
        print(f"    {_CYN}{'grantmaker':<11}{_R} {gm:,}")
        return 0
    finally:
        db.close()


if __name__ == '__main__':  # pragma: no cover
    import argparse
    ap = argparse.ArgumentParser(prog='openreturn-classify',
                                 description='Derive org foundation/nonprofit classification.')
    ap.add_argument('--db', default=None)
    sys.exit(cmd_classify(ap.parse_args()))
