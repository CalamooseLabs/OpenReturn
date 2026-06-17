#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3

"""`openreturn users` — manage user accounts, roles, and permissions.

User creation and password resets are intentionally CLI-only (never exposed over
HTTP). Every mutation is recorded in the audit log with actor_kind='cli'.
"""

import getpass
import sys
from pathlib import Path

from auth import generate_token
from console import _B, _R, _DIM, _CYN, _GRN, _RED, _YLW
from database import OpenReturnDB


def _require_db() -> OpenReturnDB:
    if not Path('OpenReturn.db').exists():
        print("OpenReturn.db not found — run openreturn users from the server's data directory.",
              file=sys.stderr)
        sys.exit(1)
    return OpenReturnDB()


def _resolve_password(args) -> tuple[str, bool]:
    """(password, generated?). --password-file wins, then --password, else a
    generated temporary password."""
    path = getattr(args, 'password_file', None)
    if path:
        with open(path) as fh:
            return fh.read().strip(), False
    if args.password:
        return args.password, False
    return generate_token(), True


def cmd_create(args) -> int:
    db = _require_db()
    if getattr(args, 'skip_existing', False) and db.users.get_user(args.username) is not None:
        db.close()
        print(f"User '{args.username}' already exists; skipping.")
        return 0
    password, generated = _resolve_password(args)
    try:
        user_id = db.users.create_user(args.username, password, roles=args.role or [])
    except ValueError as e:
        db.close()
        print(f"{_RED}{e}{_R}", file=sys.stderr)
        return 1
    db.audit.record(None, 'create', 'user', args.username, {'roles': args.role or []})
    db.close()
    print(f"\n{_B}{_GRN}User created{_R}")
    print(f"  ID:       {user_id}")
    print(f"  Username: {args.username}")
    print(f"  Roles:    {', '.join(args.role) if args.role else '(none)'}")
    if generated:
        print(f"  Password: {_CYN}{password}{_R}")
        print(f"\n  {_YLW}This password will not be shown again — share it securely.{_R}\n")
    return 0


def cmd_set_password(args) -> int:
    db = _require_db()
    if db.users.get_user(args.username) is None:
        db.close()
        print(f"{_RED}user '{args.username}' not found{_R}", file=sys.stderr)
        return 1
    pw1 = getpass.getpass('New password: ')
    pw2 = getpass.getpass('Confirm: ')
    if not pw1:
        db.close()
        print(f"{_RED}password cannot be empty{_R}", file=sys.stderr)
        return 1
    if pw1 != pw2:
        db.close()
        print(f"{_RED}passwords do not match{_R}", file=sys.stderr)
        return 1
    db.users.set_password(args.username, pw1)
    db.audit.record(None, 'update', 'user', args.username, {'password': 'set'})
    db.close()
    print("Password updated (existing sessions revoked).")
    return 0


def cmd_reset_password(args) -> int:
    db = _require_db()
    temp = db.users.reset_password(args.username)
    if temp is None:
        db.close()
        print(f"{_RED}user '{args.username}' not found{_R}", file=sys.stderr)
        return 1
    db.audit.record(None, 'update', 'user', args.username, {'password': 'reset'})
    db.close()
    print(f"\n  Temporary password for {_B}{args.username}{_R}: {_CYN}{temp}{_R}")
    print(f"  {_YLW}Shown once; existing sessions were revoked.{_R}\n")
    return 0


def cmd_list(args) -> int:
    db = _require_db()
    users = db.users.list_users()
    db.close()
    if not users:
        print("No users.")
        return 0
    for u in users:
        status = f"{_GRN}active{_R}" if u['is_active'] else f"{_RED}inactive{_R}"
        roles = ', '.join(u['roles']) or '—'
        print(f"  {u['username']:<24}  [{roles}]  {status}  "
              f"{_DIM}last login: {u['last_login_at'] or '—'}{_R}")
    return 0


def _set_active(args, active: bool) -> int:
    db = _require_db()
    try:
        ok = db.users.set_active(args.username, active)
    except ValueError as e:
        db.close()
        print(f"{_RED}{e}{_R}", file=sys.stderr)
        return 1
    if ok:
        db.audit.record(None, 'update', 'user', args.username,
                        {'is_active': active})
    db.close()
    if not ok:
        print(f"{_RED}user '{args.username}' not found{_R}", file=sys.stderr)
        return 1
    print(f"User '{args.username}' {'activated' if active else 'deactivated'}.")
    return 0


def cmd_activate(args) -> int:
    return _set_active(args, True)


def cmd_deactivate(args) -> int:
    return _set_active(args, False)


def cmd_assign_role(args) -> int:
    db = _require_db()
    ok = db.users.assign_role(args.username, args.role)
    if ok:
        db.audit.record(None, 'update', 'user', args.username, {'assign_role': args.role})
    db.close()
    if not ok:
        print(f"{_RED}user or role not found{_R}", file=sys.stderr)
        return 1
    print(f"Assigned role '{args.role}' to {args.username}.")
    return 0


def cmd_revoke_role(args) -> int:
    db = _require_db()
    try:
        ok = db.users.revoke_role(args.username, args.role)
    except ValueError as e:
        db.close()
        print(f"{_RED}{e}{_R}", file=sys.stderr)
        return 1
    if ok:
        db.audit.record(None, 'update', 'user', args.username, {'revoke_role': args.role})
    db.close()
    if not ok:
        print(f"{_RED}user/role not found or role not assigned{_R}", file=sys.stderr)
        return 1
    print(f"Revoked role '{args.role}' from {args.username}.")
    return 0


def cmd_roles(args) -> int:
    db = _require_db()
    roles = db.users.list_roles()
    db.close()
    for r in roles:
        print(f"\n  {_B}{r['code']}{_R}  {_DIM}{r['name']}{_R}")
        if r['description']:
            print(f"    {r['description']}")
        print(f"    {_CYN}{', '.join(r['permissions']) or '(no permissions)'}{_R}")
    print()
    return 0


def cmd_grant(args) -> int:
    db = _require_db()
    ok = db.users.grant_permission(args.role, args.permission)
    if ok:
        db.audit.record(None, 'update', 'role', args.role, {'grant': args.permission})
    db.close()
    if not ok:
        print(f"{_RED}role or permission not found{_R}", file=sys.stderr)
        return 1
    print(f"Granted '{args.permission}' to role '{args.role}'.")
    return 0


def cmd_revoke(args) -> int:
    db = _require_db()
    try:
        ok = db.users.revoke_permission(args.role, args.permission)
    except ValueError as e:
        db.close()
        print(f"{_RED}{e}{_R}", file=sys.stderr)
        return 1
    if ok:
        db.audit.record(None, 'update', 'role', args.role, {'revoke': args.permission})
    db.close()
    if not ok:
        print(f"{_RED}role/permission not found or not granted{_R}", file=sys.stderr)
        return 1
    print(f"Revoked '{args.permission}' from role '{args.role}'.")
    return 0
