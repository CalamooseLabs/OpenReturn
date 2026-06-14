#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3

"""`openreturn score` — pre-compute and store scores for computed models.

Scores every non-manual model across the requested organizations' filings,
recomputing all of an org's years (so models with time-spanning factors reflect
the org's full history). Manual models are graded, not computed, and are
skipped. A full rebuild (``--rebuild``) is corpus-scale; ``--org`` limits it.
"""

import sys
from pathlib import Path


def cmd_score(args) -> int:
    db_path = getattr(args, 'db', None) or 'OpenReturn.db'
    if not Path(db_path).exists():
        print(f"Database not found: {db_path} — run an ingest first.", file=sys.stderr)
        return 1

    orgs = getattr(args, 'org', None)
    if not orgs and not getattr(args, 'rebuild', False):
        print("Specify --rebuild to (re)score every organization, or --org EIN to "
              "limit to specific ones.", file=sys.stderr)
        return 2

    from database import OpenReturnDB
    from scoring import ScoringEngine
    from console import _B, _R, _DIM, _GRN, _CYN

    db = OpenReturnDB(path=db_path)
    try:
        eng = ScoringEngine(db)
        versions = getattr(args, 'version', None)
        eins = orgs if orgs else None

        def progress(done: int, total: int, scores: int) -> None:
            pct = (100 * done / total) if total else 100.0
            print(f"\r  {_GRN}{done:,}/{total:,}{_R} orgs  {_DIM}{scores:,} scores{_R}  "
                  f"{pct:5.1f}%", end='', flush=True)

        scope  = f"{len(eins)} org(s)" if eins else "all organizations"
        vscope = f"model version(s) {versions}" if versions else "all computed models"
        print(f"{_B}Scoring{_R}  {_CYN}{scope}{_R}  {_DIM}({vscope}){_R}")

        result = eng.rebuild(model_versions=versions, eins=eins, progress=progress)
        print()
        if result['models'] == 0:
            print(f"  {_DIM}no computed models to score{_R}")
        else:
            print(f"  {_GRN}{result['scores']:,}{_R} scores across "
                  f"{_GRN}{result['orgs']:,}{_R} orgs × {result['models']} model(s)")
        return 0
    finally:
        db.close()


if __name__ == '__main__':  # pragma: no cover
    import argparse
    ap = argparse.ArgumentParser(prog='openreturn-score',
                                 description='Pre-compute and store scores for computed models.')
    ap.add_argument('--db', default=None)
    ap.add_argument('--rebuild', action='store_true')
    ap.add_argument('--org', action='append', metavar='EIN')
    ap.add_argument('--version', type=int, action='append', metavar='V')
    sys.exit(cmd_score(ap.parse_args()))
