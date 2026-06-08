from console import _B, _R, _DIM, _GRN, _RED, _YLW, _CYN
from database.IRS990 import IRS990Database


def _open_db(args) -> IRS990Database:
    path = getattr(args, 'db', None)
    return IRS990Database(path=path)


def cmd_init(args) -> int:
    """Initialize the database schema and seed data."""
    db = _open_db(args)
    form_count = db.cursor.execute("SELECT COUNT(*) FROM form").fetchone()[0]
    field_count = db.cursor.execute("SELECT COUNT(*) FROM field").fetchone()[0]
    db.close()
    print(f"\n{_B}{_GRN}Database initialized{_R}")
    print(f"  {_DIM}Forms:  {form_count}{_R}")
    print(f"  {_DIM}Fields: {field_count}{_R}\n")
    return 0


def cmd_migrate(args) -> int:
    """Apply pending database migrations."""
    db = _open_db(args)

    available  = db.list_available_migrations()
    applied    = db.get_applied_migrations()
    pending    = [(name, path) for name, path in available if name not in applied]

    if getattr(args, 'list', False):
        print()
        for name, _ in available:
            status = f"{_GRN}applied{_R}" if name in applied else f"{_YLW}pending{_R}"
            print(f"  {status}  {name}")
        print()
        db.close()
        return 0

    if not pending:
        print(f"\n{_DIM}No pending migrations.{_R}\n")
        db.close()
        return 0

    print(f"\n{_B}Applying {len(pending)} migration(s)…{_R}\n")
    for name, path in pending:
        print(f"  {_CYN}→{_R} {name}", end="", flush=True)
        try:
            db.apply_migration(name, path.read_text())
            print(f"  {_GRN}done{_R}")
        except Exception as exc:
            print(f"  {_RED}FAILED{_R}: {exc}")
            db.close()
            return 1

    print(f"\n{_B}{_GRN}All migrations applied.{_R}\n")
    db.close()
    return 0
