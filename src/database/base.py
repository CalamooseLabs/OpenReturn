import os
import sqlite3
import sys
from pathlib import Path

try:
    import sqlcipher3 as _sqlcipher  # pragma: no cover
    _HAS_CIPHER = True               # pragma: no cover
except ImportError:
    _sqlcipher = None
    _HAS_CIPHER = False


def _open_connection(db_path: str) -> sqlite3.Connection:
    key = os.environ.get('DB_SECRET_KEY')
    if key:
        if _HAS_CIPHER:
            conn = _sqlcipher.connect(db_path)
            conn.execute(f"PRAGMA key='{key}'")
            return conn
        print(
            "Warning: DB_SECRET_KEY is set but sqlcipher3 is not installed — "
            "database will not be encrypted.",
            file=sys.stderr,
        )
    return sqlite3.connect(db_path)


class Database:
  def __init__(self, name, sql_dir, populate_guard: str | None = None, path: str | None = None) -> None:
    self.name = name
    self.connection = _open_connection(path if path is not None else f"{name}.db")
    self.cursor = self.connection.cursor()
    self.connection.execute("PRAGMA journal_mode=WAL")
    self.connection.execute("PRAGMA synchronous=NORMAL")
    self.connection.execute("PRAGMA cache_size=-524288")   # 512 MB
    self.connection.execute("PRAGMA temp_store=MEMORY")
    self.connection.execute("PRAGMA mmap_size=10737418240")  # 10 GB

    self._run_dir("sql/setup", sql_dir)
    if populate_guard is None or not self._table_has_rows(populate_guard):
      self._run_dir("sql/populate", sql_dir)

  def _table_has_rows(self, table: str) -> bool:
    return self.cursor.execute(
      f"SELECT 1 FROM {table} LIMIT 1"
    ).fetchone() is not None

  def commit(self) -> None:
    self.connection.commit()

  def begin_bulk_load(self) -> None:
    self.connection.execute("PRAGMA synchronous=OFF")
    self.connection.execute("PRAGMA wal_autocheckpoint=16000")  # checkpoint every ~128 MB
    self.connection.execute("PRAGMA locking_mode=EXCLUSIVE")

  def end_bulk_load(self) -> None:
    self.connection.execute("PRAGMA locking_mode=NORMAL")
    self.connection.execute("PRAGMA wal_autocheckpoint=1000")  # restore default
    self.connection.execute("PRAGMA synchronous=NORMAL")
    self.connection.execute("PRAGMA optimize")
    self.connection.execute("PRAGMA wal_checkpoint(TRUNCATE)")
    self.connection.commit()

  def close(self):
    if self.cursor:
      self.cursor.close()
    if self.connection:
      self.connection.close()

  def _run_dir(self, subdir: str, sql_dir: str) -> None:
    """Execute every *.sql file in <sql_dir>/<subdir> in sorted filename order.

    Files are named with numeric prefixes (00_, 10_, …) so load order is
    deterministic and dependency-safe (parts before sections before lines).
    Resolves to src/database/<sql_dir>/<subdir>/ — sql_dir selects the
    owning subpackage (e.g. "IRS990", "Score").
    """
    directory = Path(__file__).parent / sql_dir / subdir
    for script in sorted(directory.glob("*.sql")):
      self.cursor.executescript(script.read_text())
    self.connection.commit()
