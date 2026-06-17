import hashlib
import secrets

from database.base import Database


class ApiKeyDatabase(Database):
  """Create, validate, list and revoke API keys (reached as ``db.keys``).

  A ``Database`` subclass sharing the coordinator's connection. A standalone
  concern — no FKs to the rest of the schema. Validation results are cached in
  ``self._key_cache`` and cleared on revoke.
  """

  def __init__(self, db) -> None:
    self._db = db
    super().__init__("ApiKey", "ApiKey", connection=db.connection, cursor=db.cursor)
    self._key_cache: dict[str, int | None] = {}
    self._migrate_columns()

  def _migrate_columns(self) -> None:
    """Add columns to databases created before they existed (fresh DBs get them
    from sql/setup). Each ALTER is ignored only when the column already exists.
    role_id is added as a nullable FK (SQLite requires ALTER-added FK columns to
    default NULL); NULL is treated as the built-in 'service' role at resolve time."""
    for ddl in (
      "ALTER TABLE api_key ADD COLUMN rate_limit INTEGER NOT NULL DEFAULT -1",
      "ALTER TABLE api_key ADD COLUMN role_id INTEGER REFERENCES role (role_id)",
    ):
      try:
        self.cursor.execute(ddl)
        self.connection.commit()  # pragma: no cover — only on pre-migration DBs
      except Exception as exc:
        if 'duplicate column' not in str(exc).lower():
          raise

  def create_api_key(self, name: str, rate_limit: int = -1,
                     role: str = 'service') -> tuple[int, str]:
    """Create an API key bound to a role (default the restricted 'service' role).
    An unknown role leaves role_id NULL, which also resolves to 'service'."""
    raw = secrets.token_urlsafe(32)
    key_hash = hashlib.sha256(raw.encode()).hexdigest()
    role_row = self.cursor.execute(
      "SELECT role_id FROM role WHERE code = ?", (role,)).fetchone()
    self.cursor.execute(
      "INSERT INTO api_key (name, key_hash, rate_limit, role_id) VALUES (?, ?, ?, ?)",
      (name, key_hash, rate_limit, role_row[0] if role_row else None)
    )
    self.connection.commit()
    return self.cursor.lastrowid, raw

  def get_active_key(self, raw: str) -> dict | None:
    """Resolve a raw token to an active key's ``{key_id, name, rate_limit,
    role_code}`` (role_code defaults to 'service' when unset), or None. Bumps
    ``last_used_at``. Used by ``db.users.authenticate`` for the program path."""
    key_hash = hashlib.sha256(raw.encode()).hexdigest()
    row = self.cursor.execute(
      "SELECT k.key_id, k.name, k.rate_limit, COALESCE(r.code, 'service') "
      "FROM api_key k LEFT JOIN role r ON r.role_id = k.role_id "
      "WHERE k.key_hash = ? AND k.active = 1", (key_hash,)
    ).fetchone()
    if not row:
      return None
    self.cursor.execute(
      "UPDATE api_key SET last_used_at = datetime('now') WHERE key_id = ?", (row[0],))
    self.connection.commit()
    return {"key_id": row[0], "name": row[1], "rate_limit": row[2], "role_code": row[3]}

  def validate_api_key(self, raw: str) -> int | None:
    """
    Returns the rate limit for a valid active key (-1 = no limit),
    or None if the key is invalid or revoked.
    Results are cached in memory per server session; cache is cleared on revoke.
    """
    key_hash = hashlib.sha256(raw.encode()).hexdigest()
    if key_hash in self._key_cache:
      return self._key_cache[key_hash]
    row = self.cursor.execute(
      "SELECT key_id, rate_limit FROM api_key WHERE key_hash = ? AND active = 1", (key_hash,)
    ).fetchone()
    result = row[1] if row else None
    self._key_cache[key_hash] = result
    if row:
      self.cursor.execute(
        "UPDATE api_key SET last_used_at = datetime('now') WHERE key_id = ?", (row[0],)
      )
      self.connection.commit()
    return result

  def list_api_keys(self) -> list[dict]:
    rows = self.cursor.execute(
      "SELECT k.key_id, k.name, k.created_at, k.last_used_at, k.active, k.rate_limit, "
      "COALESCE(r.code, 'service') FROM api_key k "
      "LEFT JOIN role r ON r.role_id = k.role_id ORDER BY k.key_id"
    ).fetchall()
    return [
      {"key_id": r[0], "name": r[1], "created_at": r[2], "last_used_at": r[3],
       "active": bool(r[4]), "rate_limit": r[5], "role": r[6]}
      for r in rows
    ]

  def revoke_api_key(self, key_id: int) -> bool:
    self.cursor.execute("UPDATE api_key SET active = 0 WHERE key_id = ?", (key_id,))
    self.connection.commit()
    self._key_cache.clear()
    return self.cursor.rowcount > 0
