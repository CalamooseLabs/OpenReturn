#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3

"""`openreturn resolve` — cluster graph appearances into canonical party nodes.

The ingest stores every officer/grantee/related-org as a raw ``party_appearance``
(name + EIN + address as filed). This step clusters those appearances into
deduplicated ``party`` nodes — the graph's people and external-org nodes — by a
deterministic, conservative key (exact normalized name, plus EIN for orgs) and
backfills ``party_appearance.resolved_party_id``. Re-runnable and idempotent; a
missed match leaves a singleton node rather than a wrong merge. See
``docs/development/graph-model.md``.
"""

import sys
from pathlib import Path


def cmd_resolve(args) -> int:
    db_path = getattr(args, 'db', None) or 'OpenReturn.db'
    if not Path(db_path).exists():
        print(f"Database not found: {db_path} — run an ingest first.", file=sys.stderr)
        return 1

    from database import OpenReturnDB
    from console import _B, _R, _DIM, _GRN, _CYN

    version = getattr(args, 'version', None) or 1
    db = OpenReturnDB(path=db_path)
    try:
        print(f"{_B}Resolving graph appearances{_R}  {_CYN}resolver v{version}{_R}")
        result = db.appearances.resolve(resolver_version=version)
        if result['appearances'] == 0:
            print(f"  {_DIM}no appearances to resolve — run an ingest first{_R}")
        else:
            print(f"  {_GRN}{result['parties_created']:,}{_R} new party node(s) from "
                  f"{_GRN}{result['appearances']:,}{_R} appearance(s)")
        return 0
    finally:
        db.close()


if __name__ == '__main__':  # pragma: no cover
    import argparse
    ap = argparse.ArgumentParser(prog='openreturn-resolve',
                                 description='Cluster graph appearances into party nodes.')
    ap.add_argument('--db', default=None)
    ap.add_argument('--version', type=int, default=1)
    sys.exit(cmd_resolve(ap.parse_args()))
