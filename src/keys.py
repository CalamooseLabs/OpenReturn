#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3

import argparse
import sys
from pathlib import Path

from console import _B, _R, _DIM, _CYN, _GRN, _RED, _YLW
from database import OpenReturnDB


def _require_db() -> OpenReturnDB:
    if not Path('OpenReturn.db').exists():
        print("OpenReturn.db not found — run openreturn-keys from the server's data directory.", file=sys.stderr)
        sys.exit(1)
    return OpenReturnDB()


def cmd_create(args) -> int:
    db = _require_db()
    key_id, raw = db.keys.create_api_key(args.name, rate_limit=args.rate_limit)
    db.close()
    limit_str = "unlimited" if args.rate_limit == -1 else f"{args.rate_limit} req/min"
    print(f"\n{_B}{_GRN}API key created{_R}")
    print(f"  ID:     {key_id}")
    print(f"  Name:   {args.name}")
    print(f"  Limit:  {limit_str}")
    print(f"  Key:    {_CYN}{raw}{_R}")
    print(f"  Header: {_DIM}Authorization: Bearer {raw}{_R}")
    print(f"\n  {_YLW}This key will not be shown again.{_R}\n")
    return 0


def cmd_list(args) -> int:
    db = _require_db()
    keys = db.keys.list_api_keys()
    db.close()
    if not keys:
        print("No API keys found.")
        return 0
    id_w, name_w, created_w, used_w, limit_w = 6, 24, 20, 20, 10
    header = (f"  {'ID':<{id_w}}  {'Name':<{name_w}}  {'Created':<{created_w}}"
              f"  {'Last Used':<{used_w}}  {'Limit':<{limit_w}}  Status")
    sep    = (f"  {'─'*id_w}  {'─'*name_w}  {'─'*created_w}"
              f"  {'─'*used_w}  {'─'*limit_w}  ──────")
    print(f"\n{header}\n{sep}")
    for k in keys:
        status = f"{_GRN}active{_R}" if k['active'] else f"{_RED}revoked{_R}"
        last   = k['last_used_at'] or '—'
        limit  = '∞' if k['rate_limit'] == -1 else f"{k['rate_limit']}/min"
        print(f"  {k['key_id']:<{id_w}}  {k['name']:<{name_w}}  {k['created_at']:<{created_w}}"
              f"  {last:<{used_w}}  {limit:<{limit_w}}  {status}")
    print()
    return 0


def cmd_revoke(args) -> int:
    db = _require_db()
    ok = db.keys.revoke_api_key(args.key_id)
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
    p_create.add_argument('--rate-limit', type=int, default=-1, dest='rate_limit',
                          metavar='N', help='Max requests per minute (-1 = unlimited, default)')

    sub.add_parser('list', help='List all API keys')

    p_revoke = sub.add_parser('revoke', help='Revoke a key by ID')
    p_revoke.add_argument('key_id', type=int, help='Key ID (from openreturn-keys list)')

    args = parser.parse_args()
    dispatch = {'create': cmd_create, 'list': cmd_list, 'revoke': cmd_revoke}
    return dispatch[args.cmd](args)


if __name__ == '__main__':  # pragma: no cover
    sys.exit(main())
