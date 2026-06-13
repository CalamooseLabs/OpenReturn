#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3

"""`openreturn status` — a one-shot health snapshot.

Reports database file size, row counts, encryption state, migration status, a
liveness probe of the API server, and any background ingest. It opens the
database with a *raw* connection (not ``ScoreDatabase``) so it never runs the
schema/seed setup or creates the file as a side effect, and every query is
guarded so a missing table or a database locked by a running ingest degrades to
a note rather than a crash.
"""

import argparse
import json
import shutil
import socket
import subprocess
import sys
from pathlib import Path

import daemon
from console import _B, _R, _DIM, _CYN, _GRN, _YLW, _RED

# SQLite (and SQLCipher plaintext) databases begin with this 16-byte string.
# An encrypted SQLCipher file does not, which is how we tell the two apart
# without holding the key.
_SQLITE_MAGIC = b"SQLite format 3\x00"

_COUNT_TABLES = [
    ("organizations", "organization"),
    ("filings", "filing"),
    ("reported values", "reported_data"),
    ("scores", "organization_score"),
    ("ingested archives", "ingested_zip"),
]


def _db_path(args) -> str:
    return getattr(args, "db", None) or "OpenReturn.db"


def _fmt_bytes(n: int) -> str:
    f = float(n)
    for unit in ("B", "KiB", "MiB", "GiB", "TiB"):
        if f < 1024 or unit == "TiB":
            return f"{f:.0f} {unit}" if unit == "B" else f"{f:.1f} {unit}"
        f /= 1024
    return f"{f:.1f} TiB"  # pragma: no cover — unreachable, loop returns first


def _file_sizes(db_path: str) -> dict:
    parts = {}
    for label, suffix in (("main", ""), ("wal", "-wal"), ("shm", "-shm")):
        p = Path(db_path + suffix)
        parts[label] = p.stat().st_size if p.exists() else 0
    parts["total"] = sum(v for k, v in parts.items() if k != "total")
    return parts


def _encryption(db_path: str) -> dict:
    """Resolve the configured key + whether the on-disk file looks encrypted."""
    from database.base import _resolve_db_key, _HAS_CIPHER

    key = _resolve_db_key()
    source = None
    import os
    if os.environ.get("DB_SECRET_KEY"):
        source = "DB_SECRET_KEY"
    elif os.environ.get("DB_SECRET_KEY_FILE"):
        source = "DB_SECRET_KEY_FILE"

    looks_encrypted = None
    p = Path(db_path)
    if p.exists() and p.stat().st_size >= 16:
        try:
            with open(p, "rb") as fh:
                looks_encrypted = fh.read(16) != _SQLITE_MAGIC
        except OSError:  # pragma: no cover
            looks_encrypted = None

    return {
        "key_configured": key is not None,
        "key_source": source,
        "sqlcipher_available": _HAS_CIPHER,
        "looks_encrypted": looks_encrypted,
    }


def _counts(db_path: str) -> dict:
    """Row counts via a raw connection. Returns {"locked": True} if the DB is
    held by an exclusive lock (an ingest in progress), or {} on other errors."""
    from database.base import _open_connection

    conn = _open_connection(db_path)
    try:
        cur = conn.cursor()
        out: dict[str, int] = {}
        for label, table in _COUNT_TABLES:
            try:
                out[label] = cur.execute(f"SELECT COUNT(*) FROM {table}").fetchone()[0]
            except Exception as exc:  # noqa: BLE001
                if "locked" in str(exc).lower():
                    return {"locked": True}
                # table absent (uninitialized DB) — skip this count
        return out
    finally:
        conn.close()


def _migrations(db_path: str) -> dict:
    from database.IRS990 import IRS990Database
    from database.base import _open_connection

    available = [name for name, _ in IRS990Database.list_available_migrations()]
    conn = _open_connection(db_path)
    try:
        try:
            applied = {r[0] for r in conn.execute("SELECT name FROM migration").fetchall()}
        except Exception:  # noqa: BLE001 — no migration table / locked
            applied = set()
    finally:
        conn.close()
    pending = [n for n in available if n not in applied]
    return {"applied": len(available) - len(pending), "pending": len(pending),
            "pending_names": pending}


def _probe_server(host: str, port: int, timeout: float = 0.5) -> bool:
    # Accept IPv6 in URL notation ([::1]) as well as bare (::1).
    host = host.strip("[]")
    try:
        with socket.create_connection((host, port), timeout=timeout):
            return True
    except OSError:
        return False


def _systemd_state(unit: str = "openreturn.service") -> str | None:
    if not shutil.which("systemctl"):
        return None
    try:
        out = subprocess.run(
            ["systemctl", "is-active", unit],
            capture_output=True, text=True, timeout=2,
        )
        return out.stdout.strip() or out.stderr.strip() or None
    except Exception:  # noqa: BLE001 — best effort
        return None


def gather(args) -> dict:
    db_path = _db_path(args)
    exists = Path(db_path).exists()
    report: dict = {
        "database": {"path": db_path, "exists": exists},
        "server": {
            "host": args.host, "port": args.port,
            "listening": _probe_server(args.host, args.port),
            "systemd": _systemd_state(),
        },
        "background_ingest": daemon.running_daemon(),
    }
    if exists:
        report["database"]["sizes"] = _file_sizes(db_path)
        report["database"]["encryption"] = _encryption(db_path)
        report["data"] = _counts(db_path)
        report["migrations"] = _migrations(db_path)
    return report


# ── Rendering ────────────────────────────────────────────────────────────────

def _print_human(rep: dict) -> None:
    db = rep["database"]
    print(f"\n{_B}OpenReturn status{_R}")
    print(f"{_DIM}{'─' * 52}{_R}")

    print(f"\n{_B}Database{_R}  {_CYN}{db['path']}{_R}")
    if not db["exists"]:
        print(f"  {_YLW}not initialized{_R} — run {_CYN}openreturn init{_R}")
    else:
        s = db["sizes"]
        print(f"  {'size':<14}{_GRN}{_fmt_bytes(s['total'])}{_R}  "
              f"{_DIM}(main {_fmt_bytes(s['main'])} · wal {_fmt_bytes(s['wal'])} · "
              f"shm {_fmt_bytes(s['shm'])}){_R}")
        enc = db["encryption"]
        if enc["key_configured"]:
            if enc["sqlcipher_available"]:
                tail = "" if enc["looks_encrypted"] else f"  {_YLW}(file is plaintext!){_R}"
                state = f"{_GRN}on{_R}  {_DIM}(SQLCipher, key from {enc['key_source']}){_R}{tail}"
            else:
                state = f"{_RED}key set but sqlcipher3 missing — unencrypted{_R}"
        else:
            state = f"{_DIM}off{_R}"
        print(f"  {'encryption':<14}{state}")

    if rep.get("data") is not None:
        print(f"\n{_B}Data{_R}")
        data = rep["data"]
        if data.get("locked"):
            print(f"  {_YLW}database locked — an ingest is in progress{_R}")
        elif not data:
            print(f"  {_DIM}no tables yet{_R}")
        else:
            for label, _ in _COUNT_TABLES:
                if label in data:
                    print(f"  {label:<18}{_CYN}{data[label]:,}{_R}")

    if rep.get("migrations"):
        m = rep["migrations"]
        extra = f"  {_DIM}({', '.join(m['pending_names'])}){_R}" if m["pending_names"] else ""
        pc = _YLW if m["pending"] else _DIM
        print(f"\n{_B}Migrations{_R}  {_GRN}{m['applied']} applied{_R} · "
              f"{pc}{m['pending']} pending{_R}{extra}")

    srv = rep["server"]
    state = f"{_GRN}listening{_R}" if srv["listening"] else f"{_DIM}not responding{_R}"
    print(f"\n{_B}Server{_R}  {_CYN}http://{srv['host']}:{srv['port']}{_R}  {state}")
    if srv["systemd"]:
        sc = _GRN if srv["systemd"] == "active" else _YLW
        print(f"  {'systemd':<14}openreturn.service: {sc}{srv['systemd']}{_R}")

    bg = rep["background_ingest"]
    print(f"\n{_B}Background ingest{_R}")
    if bg:
        print(f"  {_GRN}running{_R}  PID {bg.get('pid')}  "
              f"{_DIM}since {bg.get('started_at', '?')}{_R}")
        print(f"  {'source':<14}{_CYN}{bg.get('source', '?')}{_R}")
        print(f"  {'log':<14}{bg.get('log', daemon.DEFAULT_LOG)}")
        print(f"  {_DIM}stop with: openreturn ingest --stop{_R}")
    else:
        print(f"  {_DIM}none running{_R}")
    print(f"\n{_DIM}{'─' * 52}{_R}\n")


def cmd_status(args) -> int:
    rep = gather(args)
    if getattr(args, "as_json", False):
        print(json.dumps(rep, indent=2))
    else:
        _print_human(rep)
    return 0


def main() -> int:
    ap = argparse.ArgumentParser(
        prog="openreturn-status",
        description="Show OpenReturn database, server, and background-ingest status.",
    )
    ap.add_argument("--db", default=None, help="Path to OpenReturn.db (default: ./OpenReturn.db)")
    ap.add_argument("--host", default="localhost", help="Server host to probe (default: localhost)")
    ap.add_argument("--port", type=int, default=8080, help="Server port to probe (default: 8080)")
    ap.add_argument("--json", action="store_true", dest="as_json", help="Emit machine-readable JSON")
    return cmd_status(ap.parse_args())


if __name__ == "__main__":  # pragma: no cover
    sys.exit(main())
