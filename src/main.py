#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3

import argparse
import sys
from pathlib import Path

from console import _B, _R, _DIM, _CYN, _GRN, _YLW, _MAG, _RED
from database.Score import ScoreDatabase
from router.Upload import UploadRouter
from router.Org import OrgRouter
from router.Filing import FilingRouter
from router.Score import ScoreRouter
from server import Server

# Tables populated by populate.sql — shown as row counts only
_REFERENCE_TABLES = {
  'form', 'part', 'section', 'line', 'field',
  'state', 'data_type', 'organization_type',
  'score_model', 'score_factor',
}

# User data tables — show counts and recent rows
_USER_TABLES: dict[str, list[str]] = {
  'organization':             ['ein', 'name', 'created_at'],
  'filing':                   ['uuid', 'year', 'organization_id', 'form_code', 'created_at'],
  'reported_data':            ['value_id', 'filing_id', 'field_id', 'raw_value'],
  'organization_score':       ['score_id', 'filing_id', 'model_id', 'total_score', 'scored_at'],
  'organization_score_factor':['value_id', 'score_id', 'factor_id', 'raw_value', 'weighted_value'],
}


def _dump_db(db: ScoreDatabase) -> None:
  cur = db.cursor
  cur.execute("SELECT name FROM sqlite_master WHERE type='table' ORDER BY name")
  all_tables = {row[0] for row in cur.fetchall()}

  print(f"\n{_B}Database snapshot{_R}  {_CYN}IRS990.db{_R}")
  print(f"{_DIM}{'─' * 52}{_R}")

  # Reference tables — counts only
  ref = sorted(all_tables & _REFERENCE_TABLES)
  if ref:
    print(f"\n  {_DIM}Reference tables{_R}")
    for t in ref:
      count = cur.execute(f"SELECT COUNT(*) FROM {t}").fetchone()[0]
      color = _GRN if count > 0 else _YLW
      print(f"    {t:<32}  {color}{count:>6} rows{_R}")

  # User data tables — counts + preview rows
  print(f"\n  {_DIM}User data{_R}")
  for t, cols in _USER_TABLES.items():
    if t not in all_tables:
      continue
    count = cur.execute(f"SELECT COUNT(*) FROM {t}").fetchone()[0]
    color = _GRN if count > 0 else _DIM
    print(f"\n    {_B}{t}{_R}  {color}{count} rows{_R}")

    if count == 0:
      continue

    col_list = ', '.join(cols)
    rows = cur.execute(
      f"SELECT {col_list} FROM {t} ORDER BY rowid DESC LIMIT 5"
    ).fetchall()

    # header
    header = '  '.join(f"{_MAG}{c:<18}{_R}" for c in cols)
    print(f"      {header}")
    print(f"      {_DIM}{'  '.join('─' * 18 for _ in cols)}{_R}")

    for row in reversed(rows):
      cells = []
      for val in row:
        s = str(val) if val is not None else _DIM + 'NULL' + _R
        if len(s) > 18:
          s = s[:15] + '…'
        cells.append(f"{s:<18}")
      print(f"      {'  '.join(cells)}")

    if count > 5:
      print(f"      {_DIM}… {count - 5} more rows{_R}")

  print(f"\n{_DIM}{'─' * 52}{_R}\n")


def main() -> int:
    parser = argparse.ArgumentParser(description='OpenReturn — IRS 990 API server')
    parser.add_argument('--debug',   action='store_true', help='Verbose request/response logging')
    parser.add_argument('--testing', action='store_true', help='Clear database, optionally ingest --zip-dir, then dump state')
    parser.add_argument('--zip-dir', help='Directory of ZIP files to ingest on startup (use with --testing)')
    parser.add_argument('--host',    default='localhost',  help='Bind host (default: localhost)')
    parser.add_argument('--port',    type=int, default=8080, help='Bind port (default: 8080)')
    parser.add_argument('--auth',    action='store_true', help='Require API key authentication (manage keys with openreturn-keys)')
    args = parser.parse_args()

    if args.testing:
      Path("IRS990.db").unlink(missing_ok=True)

    db = ScoreDatabase()
    upload_router = UploadRouter(db=db, secure_by_default=True)

    if args.testing:
      if args.zip_dir:
        zip_dir = Path(args.zip_dir)
        print(f"\n{_B}Ingesting ZIPs from{_R}  {_CYN}{zip_dir}{_R}")
        print(f"{_DIM}{'─' * 52}{_R}")
        results = upload_router.process_zip_dir(zip_dir)
        counts = {"stored": 0, "skipped": 0, "error": 0}
        for r in results:
          status = r.get("status", "error")
          counts[status] = counts.get(status, 0) + 1
          color = _GRN if status == "stored" else (_YLW if status == "skipped" else _RED)
          print(f"  {color}{status:<8}{_R}  {r.get('file', '')}  {_DIM}{r.get('reason', r.get('ein', ''))}{_R}")
        print(f"\n  stored={_GRN}{counts['stored']}{_R}  skipped={_YLW}{counts['skipped']}{_R}  errors={_RED}{counts['error']}{_R}")
        print(f"{_DIM}{'─' * 52}{_R}")
      _dump_db(db)

    app = Server(
        host=args.host, port=args.port, debug=args.debug,
        key_validator=db.validate_api_key if args.auth else None,
    )
    app.include_router(upload_router)
    app.include_router(OrgRouter(db=db, secure_by_default=True))
    app.include_router(FilingRouter(db=db, secure_by_default=True))
    app.include_router(ScoreRouter(db=db, secure_by_default=True))
    app.run()

    db.close()
    return 0


if __name__ == "__main__":  # pragma: no cover
    sys.exit(main())
