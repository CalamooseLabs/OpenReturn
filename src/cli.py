import argparse
import os
import sys


def _load_env(path: str = '.env') -> None:
    try:
        with open(path) as f:
            for line in f:
                line = line.strip()
                if not line or line.startswith('#') or '=' not in line:
                    continue
                key, _, val = line.partition('=')
                os.environ.setdefault(key.strip(), val.strip())
    except FileNotFoundError:
        pass


def main() -> int:
    _load_env()

    parser = argparse.ArgumentParser(prog='openreturn', description='OpenReturn — IRS 990 API server')
    sub = parser.add_subparsers(dest='command', required=True)

    # ── init ─────────────────────────────────────────────────────────────────
    init_p = sub.add_parser('init', help='Initialize the database schema and seed data')
    init_p.add_argument('--db', default=None, help='Path to OpenReturn.db (defaults to ./OpenReturn.db)')

    # ── migrate ──────────────────────────────────────────────────────────────
    migrate_p = sub.add_parser('migrate', help='Apply pending database migrations')
    migrate_p.add_argument('--db', default=None, help='Path to OpenReturn.db (defaults to ./OpenReturn.db)')
    migrate_p.add_argument('--list', action='store_true', help='List migrations and their status without applying')

    # ── serve ────────────────────────────────────────────────────────────────
    serve_p = sub.add_parser('serve', help='Start the API server')
    serve_p.add_argument('--debug',   action='store_true', help='Verbose request/response logging')
    serve_p.add_argument('--testing', action='store_true',
                         help='Clear database, optionally ingest --zip-dir, then dump state')
    serve_p.add_argument('--zip-dir', help='Directory of ZIP files to ingest on startup (use with --testing)')
    serve_p.add_argument('--host',    default='localhost', help='Bind host (default: localhost)')
    serve_p.add_argument('--port',    type=int, default=8080, help='Bind port (default: 8080)')
    serve_p.add_argument('--auth',    action='store_true', help='Require API key authentication')
    serve_p.add_argument('--workers', type=int, default=None,
                         help='Parallel XML parser processes for --zip-dir ingestion (default: CPU count)')

    # ── ingest ───────────────────────────────────────────────────────────────
    # NOTE: keep these flags in sync with ingest.py:_add_ingest_arguments — they
    # are declared inline here to avoid importing the ingest module at parse time.
    ingest_p = sub.add_parser('ingest', help='Bulk-ingest 990 ZIP files, or manage ingested archives')
    ingest_p.add_argument('directory', nargs='?', default=None,
                          help='Path to a directory of .zip files, or an http(s):// URL to a '
                               'ZIP or to the IRS Form 990 series downloads page. Optional when '
                               'using a management flag (--ingested / --forget / --purge / --stop).')
    ingest_p.add_argument('--workers', type=int, default=os.cpu_count() or 4,
                          help='Parallel XML parser processes (default: CPU count)')
    ingest_p.add_argument('--profile', action='store_true',
                          help='Print a per-phase wall-clock breakdown of the parallel ingest')
    ingest_p.add_argument('--force', action='store_true',
                          help='(URL sources) re-ingest archives even if already recorded as processed')
    ingest_p.add_argument('--keep-downloads', dest='keep_downloads', action='store_true',
                          help='(URL sources) keep downloaded ZIPs instead of deleting after ingest')
    ingest_p.add_argument('--cache-dir', dest='cache_dir', default=None,
                          help='(URL sources) directory to download ZIPs into (default: a temp dir, removed after)')
    ingest_p.add_argument('--list', dest='list_sources', action='store_true',
                          help='(URL sources) list discovered ZIP URLs and whether each is already ingested, then exit')
    ingest_p.add_argument('--background', '-b', action='store_true',
                          help='Run the ingest detached in the background (logs to a file; survives logout)')
    ingest_p.add_argument('--log', default=None,
                          help='Log file for --background (default: ingest.log in the working directory)')
    ingest_p.add_argument('--stop', action='store_true',
                          help='Stop a running background ingest (finishes the current archive first), then exit')
    ingest_p.add_argument('--ingested', action='store_true',
                          help='List archives recorded as already ingested, then exit')
    ingest_p.add_argument('--forget', metavar='PATTERN', default=None,
                          help='Forget ingested-archive records matching PATTERN (re-ingestable; data kept), then exit')
    ingest_p.add_argument('--forget-all', dest='forget_all', action='store_true',
                          help='Forget every ingested-archive record (data kept), then exit')
    ingest_p.add_argument('--purge', metavar='PATTERN', default=None,
                          help='Delete stored filings whose zip filename matches PATTERN, plus their '
                               'reported values and scores (and forget matching records), then exit')
    ingest_p.add_argument('--purge-all', dest='purge_all', action='store_true',
                          help='Delete ALL stored filings, reported values, and scores, then exit')
    ingest_p.add_argument('--yes', '-y', action='store_true',
                          help='Skip the confirmation prompt for --purge / --purge-all')

    # ── status ─────────────────────────────────────────────────────────────────
    status_p = sub.add_parser('status', help='Show database size, row counts, server and background-ingest status')
    status_p.add_argument('--db', default=None, help='Path to OpenReturn.db (defaults to ./OpenReturn.db)')
    status_p.add_argument('--host', default='localhost', help='Server host to probe (default: localhost)')
    status_p.add_argument('--port', type=int, default=8080, help='Server port to probe (default: 8080)')
    status_p.add_argument('--json', action='store_true', dest='as_json', help='Emit machine-readable JSON')

    # ── reset ──────────────────────────────────────────────────────────────────
    reset_p = sub.add_parser('reset', help='Delete the database files (main + WAL + SHM) after confirmation')
    reset_p.add_argument('--db', default=None, help='Path to OpenReturn.db (defaults to ./OpenReturn.db)')
    reset_p.add_argument('--yes', '-y', action='store_true', help='Skip the confirmation prompt')

    # ── keys ─────────────────────────────────────────────────────────────────
    keys_p = sub.add_parser('keys', help='Manage API keys')
    keys_sub = keys_p.add_subparsers(dest='keys_cmd', required=True)

    k_create = keys_sub.add_parser('create', help='Generate and store a new API key')
    k_create.add_argument('name', help='Human-readable label (e.g. "Dashboard", "CI pipeline")')
    k_create.add_argument('--rate-limit', type=int, default=-1, dest='rate_limit', metavar='N',
                          help='Max requests per minute (-1 = unlimited, default)')

    keys_sub.add_parser('list', help='List all API keys')

    k_revoke = keys_sub.add_parser('revoke', help='Revoke a key by ID')
    k_revoke.add_argument('key_id', type=int, help='Key ID (from openreturn keys list)')

    # ── models ───────────────────────────────────────────────────────────────
    models_p = sub.add_parser('models', help='Manage scoring models')
    models_sub = models_p.add_subparsers(dest='models_cmd', required=True)

    m_reg = models_sub.add_parser('register', help='Register a scoring model from a TOML file')
    m_reg.add_argument('file', help='Path to the TOML model definition')
    m_reg.add_argument('--dry-run', action='store_true', dest='dry_run',
                       help='Validate without writing to the database')
    m_reg.add_argument('--skip-existing', action='store_true', dest='skip_existing',
                       help='Exit successfully if this model version is already registered')
    m_reg.add_argument('--db', default=None,
                       help='Path to OpenReturn.db (defaults to ./OpenReturn.db)')

    m_list = models_sub.add_parser('list', help='List registered scoring models')
    m_list.add_argument('--db', default=None,
                        help='Path to OpenReturn.db (defaults to ./OpenReturn.db)')

    args = parser.parse_args()

    if args.command == 'init':
        from db import cmd_init
        return cmd_init(args) or 0

    if args.command == 'migrate':
        from db import cmd_migrate
        return cmd_migrate(args) or 0

    if args.command == 'serve':
        from main import cmd_serve
        return cmd_serve(args)

    if args.command == 'ingest':
        from ingest import cmd_ingest
        return cmd_ingest(args)

    if args.command == 'status':
        from status import cmd_status
        return cmd_status(args)

    if args.command == 'reset':
        from db import cmd_reset
        return cmd_reset(args) or 0

    if args.command == 'keys':
        from keys import cmd_create, cmd_list as _keys_list, cmd_revoke
        dispatch = {'create': cmd_create, 'list': _keys_list, 'revoke': cmd_revoke}
        return dispatch[args.keys_cmd](args) or 0

    if args.command == 'models':
        from models import cmd_register, cmd_list as _models_list
        if args.models_cmd == 'register':
            return cmd_register(args) or 0
        return _models_list(args) or 0


if __name__ == '__main__':  # pragma: no cover
    sys.exit(main())
