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


def escape_like(value: str) -> str:
    """Escape LIKE wildcards so a user-supplied substring matches literally.

    Use with ``column LIKE ? ESCAPE '\\'`` and wrap the result in ``%…%``.
    Without this a pattern containing ``%`` or ``_`` would match more rows than
    intended — which matters for the destructive purge path (e.g. ``2023_1``
    must not also match ``2023X1``).
    """
    return value.replace("\\", "\\\\").replace("%", "\\%").replace("_", "\\_")


def _resolve_db_key() -> str | None:
    """Resolve the SQLCipher key from the environment.

    ``DB_SECRET_KEY`` holds the key directly. ``DB_SECRET_KEY_FILE`` names a file
    whose contents are the key (trailing whitespace stripped) — the form used
    for runtime secrets that should never sit in an environment variable or the
    Nix store (agenix, sops-nix, systemd credentials, Docker/Compose secrets).
    The direct variable wins when both are set. Returns None when neither yields
    a non-empty key.
    """
    key = os.environ.get('DB_SECRET_KEY')
    if key:
        return key
    key_file = os.environ.get('DB_SECRET_KEY_FILE')
    if key_file:
        try:
            with open(key_file) as fh:
                return fh.read().strip() or None
        except OSError as exc:
            print(
                f"Warning: DB_SECRET_KEY_FILE ({key_file}) could not be read: {exc}",
                file=sys.stderr,
            )
    return None


def _open_connection(db_path: str) -> sqlite3.Connection:
    key = _resolve_db_key()
    if key:
        if _HAS_CIPHER:
            conn = _sqlcipher.connect(db_path)
            # PRAGMA takes no bind params; escape single quotes so a key
            # containing one can't break (or inject into) the statement.
            safe = key.replace("'", "''")
            conn.execute(f"PRAGMA key='{safe}'")
            return conn
        print(
            "Warning: a database key is set but sqlcipher3 is not installed — "
            "database will not be encrypted.",
            file=sys.stderr,
        )
    return sqlite3.connect(db_path)


class Database:
  """A SQLite-backed concern with its own ``sql/setup`` + ``sql/populate`` tree.

  Two construction modes:

  * **Owner** (``connection`` omitted): opens its own connection to ``path`` /
    ``{name}.db`` and applies the connection-level PRAGMAs once. Used by the
    ``OpenReturnDB`` coordinator.
  * **Shared** (``connection`` supplied): adopts the coordinator's connection
    instead of opening one, so each concern can be its own ``Database`` subclass
    while all of them live in a single file — which is what keeps the
    cross-concern foreign keys + cascades (e.g. ``organization_score`` →
    ``filing``) enforceable, since SQLite only checks FKs within one file.

  ``sql_dir`` selects the owning subpackage under ``src/database/`` (e.g.
  ``"Organization"``); pass ``None`` to skip loading any sql tree (the
  coordinator owns no tables of its own).
  """

  def __init__(self, name, sql_dir: str | None = None, populate_guard: str | None = None,
               path: str | None = None, connection=None, cursor=None) -> None:
    self.name = name
    if connection is not None:
      self.connection = connection
    else:
      self.connection = _open_connection(path if path is not None else f"{name}.db")
      self._configure_connection()
    # Shared-connection concerns reuse the coordinator's single cursor (passed
    # in) rather than opening their own — a second cursor mid-statement makes a
    # commit() on another raise "SQL statements in progress" during bulk ingest.
    self.cursor = cursor if cursor is not None else self.connection.cursor()

    if sql_dir is not None:
      self._run_dir("sql/setup", sql_dir)
      if populate_guard is None or not self._table_has_rows(populate_guard):
        self._run_dir("sql/populate", sql_dir)

  def _configure_connection(self) -> None:
    """Connection-level PRAGMAs, applied once by the owner of the connection.
    ``foreign_keys`` is connection-scoped (resets per connection) so it lives
    here rather than in the schema SQL. ``page_size`` is left at the 4096
    default — a ``page_size=8192`` set after ``journal_mode=WAL`` is a silent
    no-op anyway, so the on-disk format is unchanged."""
    self.connection.execute("PRAGMA journal_mode=WAL")
    self.connection.execute("PRAGMA synchronous=NORMAL")
    self.connection.execute("PRAGMA cache_size=-524288")   # 512 MB
    self.connection.execute("PRAGMA temp_store=MEMORY")
    self.connection.execute("PRAGMA mmap_size=10737418240")  # 10 GB
    self.connection.execute("PRAGMA foreign_keys=ON")

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
    owning subpackage (e.g. "Schema", "Organization", "Score").
    """
    directory = Path(__file__).parent / sql_dir / subdir
    for script in sorted(directory.glob("*.sql")):
      self.cursor.executescript(script.read_text())
    self.connection.commit()
