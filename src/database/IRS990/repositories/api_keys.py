import hashlib
import secrets


class ApiKeyRepository:
  """Create, validate, list and revoke API keys.

  Validation results are cached in ``self._key_cache`` (set up by
  ``IRS990Database.__init__``) and cleared on revoke.
  """

  def create_api_key(self, name: str, rate_limit: int = -1) -> tuple[int, str]:
    raw = secrets.token_urlsafe(32)
    key_hash = hashlib.sha256(raw.encode()).hexdigest()
    self.cursor.execute(
      "INSERT INTO api_key (name, key_hash, rate_limit) VALUES (?, ?, ?)",
      (name, key_hash, rate_limit)
    )
    self.connection.commit()
    return self.cursor.lastrowid, raw

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
      "SELECT key_id, name, created_at, last_used_at, active, rate_limit FROM api_key ORDER BY key_id"
    ).fetchall()
    return [
      {"key_id": r[0], "name": r[1], "created_at": r[2], "last_used_at": r[3],
       "active": bool(r[4]), "rate_limit": r[5]}
      for r in rows
    ]

  def revoke_api_key(self, key_id: int) -> bool:
    self.cursor.execute("UPDATE api_key SET active = 0 WHERE key_id = ?", (key_id,))
    self.connection.commit()
    self._key_cache.clear()
    return self.cursor.rowcount > 0
