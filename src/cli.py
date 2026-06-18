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

    # ── db analyze ─────────────────────────────────────────────────────────────
    analyze_p = sub.add_parser('analyze', help='Rebuild query-planner statistics (ANALYZE + optimize)')
    analyze_p.add_argument('--db', default=None, help='Path to OpenReturn.db (defaults to ./OpenReturn.db)')

    # ── serve ────────────────────────────────────────────────────────────────
    serve_p = sub.add_parser('serve', help='Start the API server')
    serve_p.add_argument('--debug',   action='store_true', help='Verbose request/response logging')
    serve_p.add_argument('--testing', action='store_true',
                         help='Clear database, optionally ingest --zip-dir, then dump state')
    serve_p.add_argument('--zip-dir', help='Directory of ZIP files to ingest on startup (use with --testing)')
    serve_p.add_argument('--host',    default='localhost', help='Bind host (default: localhost)')
    serve_p.add_argument('--port',    type=int, default=8080, help='Bind port (default: 8080)')
    serve_p.add_argument('--auth',    action='store_true', help='Require API key authentication')
    serve_p.add_argument('--cors-origin', action='append', dest='cors_origin', metavar='ORIGIN',
                         help='Allowed CORS origin (repeatable). Default: any origin (*). '
                              'Auth is header-based, so * is safe.')
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
    ingest_p.add_argument('--schedule', metavar='WHEN', default=None,
                          help='Delay the ingest until WHEN (+30m / HH:MM / YYYY-MM-DD HH:MM); pair with --background')
    ingest_p.add_argument('--restart-server', dest='restart_server', action='store_true',
                          help='Stop the running server before ingesting and restart it afterward (not for systemd)')
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
    ingest_p.add_argument('--no-score', dest='no_score', action='store_true',
                          help='Skip the post-ingest scoring step (otherwise computed-model '
                               'scores for touched organizations are (re)computed at the end)')

    # ── openapi ──────────────────────────────────────────────────────────────
    openapi_p = sub.add_parser('openapi', help='Print the OpenAPI 3.1 spec (also served at /openapi.json)')
    openapi_p.add_argument('--output', '-o', default=None, help='Write to a file instead of stdout')
    openapi_p.add_argument('--base-url', dest='base_url', default=None, help='servers[0].url in the spec')
    openapi_p.add_argument('--compact', action='store_true', help='Minified JSON')

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
    k_create.add_argument('--role', default='service', metavar='ROLE',
                          help='Role granting the key its permissions (default: service — restricted read-only)')

    keys_sub.add_parser('list', help='List all API keys')

    k_revoke = keys_sub.add_parser('revoke', help='Revoke a key by ID')
    k_revoke.add_argument('key_id', type=int, help='Key ID (from openreturn keys list)')

    # ── users ──────────────────────────────────────────────────────────────────
    users_p = sub.add_parser('users', help='Manage user accounts, roles, and permissions')
    users_sub = users_p.add_subparsers(dest='users_cmd', required=True)

    u_create = users_sub.add_parser('create', help='Create a user account')
    u_create.add_argument('username')
    u_create.add_argument('--role', action='append', metavar='ROLE',
                          help='Role to assign (repeatable: --role editor --role ...)')
    u_create.add_argument('--password', default=None,
                          help='Set this password (default: generate a temporary one and print it)')
    u_create.add_argument('--password-file', dest='password_file', default=None,
                          help='Read the password from this file (for deploys/secrets)')
    u_create.add_argument('--skip-existing', dest='skip_existing', action='store_true',
                          help='Exit 0 without changes if the user already exists (idempotent bootstrap)')

    u_setpw = users_sub.add_parser('set-password', help='Set a user password (prompts securely)')
    u_setpw.add_argument('username')

    u_resetpw = users_sub.add_parser('reset-password', help='Generate a new temporary password')
    u_resetpw.add_argument('username')

    users_sub.add_parser('list', help='List user accounts')

    u_act = users_sub.add_parser('activate', help='Reactivate a user account')
    u_act.add_argument('username')
    u_deact = users_sub.add_parser('deactivate', help='Deactivate a user (revokes their sessions)')
    u_deact.add_argument('username')

    u_assign = users_sub.add_parser('assign-role', help='Assign a role to a user')
    u_assign.add_argument('username')
    u_assign.add_argument('role')
    u_revrole = users_sub.add_parser('revoke-role', help='Revoke a role from a user')
    u_revrole.add_argument('username')
    u_revrole.add_argument('role')

    users_sub.add_parser('roles', help='List roles and their permissions')

    u_grant = users_sub.add_parser('grant', help='Grant a permission to a role')
    u_grant.add_argument('role')
    u_grant.add_argument('permission')
    u_revperm = users_sub.add_parser('revoke', help='Revoke a permission from a role')
    u_revperm.add_argument('role')
    u_revperm.add_argument('permission')

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

    # ── score ──────────────────────────────────────────────────────────────────
    score_p = sub.add_parser('score',
                             help='Pre-compute and store scores for computed (non-manual) models')
    score_p.add_argument('--db', default=None, help='Path to OpenReturn.db (defaults to ./OpenReturn.db)')
    score_p.add_argument('--rebuild', action='store_true',
                         help='(Re)score every organization (required for a full recompute)')
    score_p.add_argument('--org', action='append', metavar='EIN',
                         help='Limit to specific organization EIN(s); repeatable')
    score_p.add_argument('--version', type=str, action='append', metavar='V',
                         help='Limit to specific model version(s); repeatable (default: all computed)')

    # ── ocr ────────────────────────────────────────────────────────────────────
    ocr_p = sub.add_parser('ocr', help='OCR a 990 PDF into confidence-scored financial observations')
    ocr_p.add_argument('file', help='Path to the 990 PDF')
    ocr_p.add_argument('--ein', required=True, help='Organization EIN')
    ocr_p.add_argument('--year', type=int, required=True, help='Fiscal year')

    # ── financials ───────────────────────────────────────────────────────────
    fin_p = sub.add_parser('financials', help='Derive/import unified financial observations')
    fin_sub = fin_p.add_subparsers(dest='financials_cmd', required=True)
    f_rebuild = fin_sub.add_parser('rebuild', help='Derive 990 observations into the canonical layer')
    f_rebuild.add_argument('--org', action='append', metavar='EIN',
                           help='Limit to specific organization EIN(s); repeatable')
    fin_sub.add_parser('backfill-values',
                       help='One-time backfill of denormalized canonical values (resumable)')
    f_import = fin_sub.add_parser('import', help='Import financial observations from a JSON file')
    f_import.add_argument('file', help='JSON: an object (or list) with {ein, fiscal_year, source, values}')
    f_import.add_argument('--ein', default=None, help='Default EIN for records that omit it')
    f_import.add_argument('--year', type=int, default=None, help='Default fiscal year')
    f_import.add_argument('--source', default='audited_statement', help='Default source code')

    resolve_p = sub.add_parser('resolve',
                               help='Cluster graph appearances into canonical party nodes')
    resolve_p.add_argument('--db', default=None, help='Path to OpenReturn.db (defaults to ./OpenReturn.db)')
    resolve_p.add_argument('--version', type=int, default=1, metavar='V',
                           help='Resolver version to stamp on created party nodes (default: 1)')

    classify_p = sub.add_parser('classify',
                                help='(Re)derive each org\'s foundation/nonprofit type + grantmaker flag')
    classify_p.add_argument('--db', default=None, help='Path to OpenReturn.db (defaults to ./OpenReturn.db)')

    counties_p = sub.add_parser('counties', help='Deduce org counties from a ZIP→county crosswalk')
    counties_sub = counties_p.add_subparsers(dest='counties_cmd', required=True)
    c_import = counties_sub.add_parser('import', help='Import a ZIP→county crosswalk CSV (e.g. HUD) + derive')
    c_import.add_argument('file', help='Path to the crosswalk CSV')
    c_import.add_argument('--db', default=None, help='Path to OpenReturn.db (defaults to ./OpenReturn.db)')
    c_derive = counties_sub.add_parser('derive', help='Re-derive counties from the imported crosswalk')
    c_derive.add_argument('--db', default=None, help='Path to OpenReturn.db (defaults to ./OpenReturn.db)')

    templates_p = sub.add_parser('templates', help='Browse the model-template catalog (prefill guides)')
    templates_sub = templates_p.add_subparsers(dest='templates_cmd', required=True)
    templates_sub.add_parser('list', help='List the model templates in the catalog')
    t_show = templates_sub.add_parser('show', help='Print a template\'s TOML (to edit + register)')
    t_show.add_argument('code', help='Template code (filename stem, e.g. 10-operating-ratios)')

    args = parser.parse_args()

    if args.command == 'init':
        from db import cmd_init
        return cmd_init(args) or 0

    if args.command == 'analyze':
        from db import cmd_analyze
        return cmd_analyze(args) or 0

    if args.command == 'migrate':
        from db import cmd_migrate
        return cmd_migrate(args) or 0

    if args.command == 'serve':
        from main import cmd_serve
        return cmd_serve(args)

    if args.command == 'ingest':
        from ingest import cmd_ingest
        return cmd_ingest(args)

    if args.command == 'openapi':
        from openapi import cmd_openapi
        return cmd_openapi(args)

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

    if args.command == 'users':
        import users as _users
        dispatch = {
            'create':         _users.cmd_create,
            'set-password':   _users.cmd_set_password,
            'reset-password': _users.cmd_reset_password,
            'list':           _users.cmd_list,
            'activate':       _users.cmd_activate,
            'deactivate':     _users.cmd_deactivate,
            'assign-role':    _users.cmd_assign_role,
            'revoke-role':    _users.cmd_revoke_role,
            'roles':          _users.cmd_roles,
            'grant':          _users.cmd_grant,
            'revoke':         _users.cmd_revoke,
        }
        return dispatch[args.users_cmd](args) or 0

    if args.command == 'models':
        from models import cmd_register, cmd_list as _models_list
        if args.models_cmd == 'register':
            return cmd_register(args) or 0
        return _models_list(args) or 0

    if args.command == 'score':
        from scores import cmd_score
        return cmd_score(args)

    if args.command == 'ocr':
        from ocr import cmd_ocr
        return cmd_ocr(args)

    if args.command == 'financials':
        import financials as _fin
        return {'rebuild': _fin.cmd_rebuild, 'import': _fin.cmd_import,
                'backfill-values': _fin.cmd_backfill_values}[args.financials_cmd](args) or 0

    if args.command == 'resolve':
        from resolve import cmd_resolve
        return cmd_resolve(args)

    if args.command == 'classify':
        from classify import cmd_classify
        return cmd_classify(args)

    if args.command == 'templates':
        import templates as _templates
        if args.templates_cmd == 'show':
            return _templates.cmd_show(args)
        return _templates.cmd_list(args)

    if args.command == 'counties':
        import counties as _counties
        if args.counties_cmd == 'import':
            return _counties.cmd_import(args)
        return _counties.cmd_derive(args)


if __name__ == '__main__':  # pragma: no cover
    sys.exit(main())
