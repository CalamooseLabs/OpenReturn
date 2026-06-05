#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3

import argparse
import sys
from pathlib import Path

from database.Score import ScoreDatabase

_B    = '\033[1m'
_R    = '\033[0m'
_DIM  = '\033[2m'
_CYAN = '\033[36m'
_GRN  = '\033[32m'
_RED  = '\033[31m'
_YLW  = '\033[33m'


def _require_db() -> ScoreDatabase:
    if not Path('IRS990.db').exists():
        print("IRS990.db not found — run openreturn-keys from the server's data directory.", file=sys.stderr)
        sys.exit(1)
    return ScoreDatabase()


def cmd_create(args) -> int:
    db = _require_db()
    key_id, raw = db.create_api_key(args.name)
    db.close()
    print(f"\n{_B}{_GRN}API key created{_R}")
    print(f"  ID:     {key_id}")
    print(f"  Name:   {args.name}")
    print(f"  Key:    {_CYAN}{raw}{_R}")
    print(f"  Header: {_DIM}Authorization: Bearer {raw}{_R}")
    print(f"\n  {_YLW}This key will not be shown again.{_R}\n")
    return 0


def cmd_list(args) -> int:
    db = _require_db()
    keys = db.list_api_keys()
    db.close()
    if not keys:
        print("No API keys found.")
        return 0
    id_w, name_w, created_w, used_w = 6, 24, 20, 20
    header = f"  {'ID':<{id_w}}  {'Name':<{name_w}}  {'Created':<{created_w}}  {'Last Used':<{used_w}}  Status"
    sep    = f"  {'─'*id_w}  {'─'*name_w}  {'─'*created_w}  {'─'*used_w}  ──────"
    print(f"\n{header}\n{sep}")
    for k in keys:
        status = f"{_GRN}active{_R}" if k['active'] else f"{_RED}revoked{_R}"
        last   = k['last_used_at'] or '—'
        print(f"  {k['key_id']:<{id_w}}  {k['name']:<{name_w}}  {k['created_at']:<{created_w}}  {last:<{used_w}}  {status}")
    print()
    return 0


def cmd_revoke(args) -> int:
    db = _require_db()
    ok = db.revoke_api_key(args.key_id)
    db.close()
    if ok:
        print(f"Key {args.key_id} revoked.")
        return 0
    print(f"Key {args.key_id} not found.", file=sys.stderr)
    return 1


def main() -> int:
    parser = argparse.ArgumentParser(
        prog='openreturn-keys',
        description='Manage API keys for the OpenReturn server.',
    )
    sub = parser.add_subparsers(dest='cmd', required=True)

    p_create = sub.add_parser('create', help='Generate and store a new API key')
    p_create.add_argument('name', help='Human-readable label (e.g. "Dashboard", "CI pipeline")')

    sub.add_parser('list', help='List all API keys')

    p_revoke = sub.add_parser('revoke', help='Revoke a key by ID')
    p_revoke.add_argument('key_id', type=int, help='Key ID (from openreturn-keys list)')

    args = parser.parse_args()
    dispatch = {'create': cmd_create, 'list': cmd_list, 'revoke': cmd_revoke}
    return dispatch[args.cmd](args)


if __name__ == '__main__':
    sys.exit(main())
