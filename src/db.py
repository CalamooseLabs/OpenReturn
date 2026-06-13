import sys
from pathlib import Path

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


def _db_targets(path: str) -> list[Path]:
    """The database file plus its WAL/SHM sidecars."""
    return [Path(path), Path(path + '-wal'), Path(path + '-shm')]


def cmd_reset(args) -> int:
    """Delete the database files (main + WAL + SHM) after confirmation.

    A later ``init``/``serve`` recreates a fresh schema and seed data. Refuses
    while a background ingest is running — it holds the DB open and is mid
    bulk-load, so deleting the files out from under it would corrupt state. This
    guard is NOT bypassable by --yes (which only skips the typed prompt); stop
    the ingest first.
    """
    import daemon

    path = getattr(args, 'db', None) or 'OpenReturn.db'
    targets = [t for t in _db_targets(path) if t.exists()]
    if not targets:
        print(f"\n{_DIM}Nothing to delete — {path} does not exist.{_R}\n")
        return 0

    skip_prompt = getattr(args, 'yes', False)

    running = daemon.running_daemon()
    if running:
        print(f"\n{_RED}A background ingest is running (PID {running.get('pid')}).{_R}",
              file=sys.stderr)
        print(f"  Stop it first: {_CYN}openreturn ingest --stop{_R}\n", file=sys.stderr)
        return 1

    total = sum(t.stat().st_size for t in targets)
    name = Path(path).name
    print(f"\n{_B}{_RED}This will permanently delete:{_R}")
    for t in targets:
        print(f"  {t}  {_DIM}({t.stat().st_size:,} bytes){_R}")
    print(f"  {_DIM}total {total:,} bytes{_R}")

    if not skip_prompt:
        resp = input(f"\nType {_CYN}{name}{_R} to confirm: ")
        if resp.strip() != name:
            print(f"{_YLW}Aborted — nothing deleted.{_R}\n")
            return 1

    for t in targets:
        try:
            t.unlink()
        except OSError as exc:
            print(f"{_RED}Failed to delete {t}: {exc}{_R}", file=sys.stderr)
            return 1

    print(f"\n{_B}{_GRN}Deleted {len(targets)} file(s){_R}  {_DIM}({total:,} bytes freed){_R}\n")
    return 0
