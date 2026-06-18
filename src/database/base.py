import os
import sqlite3
import sys
import threading
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


def _open_connection(db_path: str, *, check_same_thread: bool = True) -> sqlite3.Connection:
    # ``check_same_thread=False`` is used for the threaded server's per-thread
    # connections: each is still only *used* by its creating worker thread, but the
    # coordinator's close() (on the main thread) must be able to close them at
    # shutdown — stdlib sqlite3 raises ProgrammingError on a cross-thread close
    # otherwise, leaking the connection.
    key = _resolve_db_key()
    if key:
        if _HAS_CIPHER:
            conn = _sqlcipher.connect(db_path, check_same_thread=check_same_thread)
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
    return sqlite3.connect(db_path, check_same_thread=check_same_thread)


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
      # SHARED concern: the `connection`/`cursor` properties delegate to
      # ``self._db`` (the coordinator), which every concern subclass sets BEFORE
      # calling super().__init__. Routing through the coordinator means its
      # per-thread connection logic applies uniformly to every concern. The
      # passed connection/cursor are vestigial (kept for signature compatibility).
      self._shared = True
    else:
      # OWNER (the coordinator): open the connection and set up per-thread routing.
      self._shared = False
      self._path = path if path is not None else f"{name}.db"
      self._main_connection = _open_connection(self._path)
      self._configure_connection(self._main_connection)
      self._main_cursor = self._main_connection.cursor()
      self._main_thread = threading.get_ident()
      self._tls = threading.local()
      self._threadlocal = False
      self._closed = False
      self._thread_conns: list = []
      self._thread_conns_lock = threading.Lock()

    if sql_dir is not None:
      self._run_dir("sql/setup", sql_dir)
      if populate_guard is None or not self._table_has_rows(populate_guard):
        self._run_dir("sql/populate", sql_dir)

  # Connection / cursor are PROPERTIES so the multi-threaded HTTP server can use a
  # separate SQLite connection per request thread (WAL allows concurrent readers,
  # so one slow query no longer blocks every other request on a single shared
  # cursor). A shared concern delegates to the coordinator; the coordinator routes
  # to the calling thread's connection when thread-local mode is on.
  @property
  def connection(self):
    if self._shared:
      return self._db.connection
    if self._threadlocal and threading.get_ident() != self._main_thread:
      self._ensure_thread_connection()
      return self._tls.connection
    return self._main_connection

  @property
  def cursor(self):
    if self._shared:
      return self._db.cursor
    if self._threadlocal and threading.get_ident() != self._main_thread:
      self._ensure_thread_connection()
      return self._tls.cursor
    return self._main_cursor

  def _ensure_thread_connection(self) -> None:
    """Open this worker thread's own connection on first use. The server reuses a
    BOUNDED pool of worker threads (see server.py), so the number of per-thread
    connections is capped at the pool size and reused across requests — not one
    per request. ``check_same_thread=False`` lets close() release them from the
    main thread at shutdown. A generous ``busy_timeout`` makes a writer wait for
    the WAL write lock (e.g. behind a long /upload commit) rather than failing the
    request with "database is locked". A smaller per-connection page cache keeps
    N connections from each reserving the main connection's 512 MB — the shared
    10 GB mmap already provides the bulk of the cache across all connections."""
    if getattr(self._tls, "connection", None) is not None:
      return
    conn = _open_connection(self._path, check_same_thread=False)
    self._configure_connection(conn, cache_mb=64)
    conn.execute("PRAGMA busy_timeout=30000")
    self._tls.connection = conn
    self._tls.cursor = conn.cursor()
    with self._thread_conns_lock:
      self._thread_conns.append(conn)

  def enable_threadlocal(self) -> None:
    """Route DB access through one connection per thread (for the multi-threaded
    server). A no-op for in-memory DBs — a per-thread ``:memory:`` connection
    would be a separate, empty database — and for shared concerns."""
    if not self._shared and self._path != ":memory:":
      self._threadlocal = True

  def _configure_connection(self, conn=None, *, cache_mb: int = 512) -> None:
    """Connection-level PRAGMAs, applied to ``conn`` (the owner's main connection
    by default, or a freshly opened per-thread connection). ``foreign_keys`` is
    connection-scoped (resets per connection) so it lives here rather than in the
    schema SQL. ``page_size`` is left at the 4096 default — a ``page_size=8192``
    set after ``journal_mode=WAL`` is a silent no-op anyway. ``cache_mb`` sizes the
    private page cache; per-thread connections pass a smaller value since the
    shared mmap region covers most reads."""
    conn = conn if conn is not None else self._main_connection
    conn.execute("PRAGMA journal_mode=WAL")
    conn.execute("PRAGMA synchronous=NORMAL")
    conn.execute(f"PRAGMA cache_size={-cache_mb * 1024}")   # negative => KiB
    conn.execute("PRAGMA temp_store=MEMORY")
    conn.execute("PRAGMA mmap_size=10737418240")  # 10 GB
    conn.execute("PRAGMA foreign_keys=ON")

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
    # A shared concern doesn't own the connection — the coordinator closes it.
    if self._shared or self._closed:
      return
    self._closed = True
    for closeable in (self._main_cursor, self._main_connection):
      try:
        closeable.close()
      except sqlite3.Error:
        pass
    with self._thread_conns_lock:
      for conn in self._thread_conns:
        try:
          conn.close()
        except sqlite3.Error:
          pass
      self._thread_conns.clear()

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
