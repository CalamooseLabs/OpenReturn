from database.base import Database


class FollowDatabase(Database):
  """Per-user organization follows / watchlist (reached as ``db.follows``).

  A ``Database`` subclass sharing the coordinator's connection. Following is a
  **user** action (a session principal with a ``user_id``); a program (API key) has
  no personal watchlist. EINs are normalized via ``db.orgs`` and validated against
  the organization table, and every change is audited.
  """

  def __init__(self, db) -> None:
    self._db = db
    super().__init__("Follow", "Follow", connection=db.connection, cursor=db.cursor)

  @staticmethod
  def _user_id(actor) -> int | None:
    return actor.user_id if (actor is not None and getattr(actor, 'kind', None) == 'user') else None

  def follow_org(self, org_ein: str, *, actor=None) -> bool:
    """Follow an org (idempotent). Raises ValueError if there is no acting user or
    the org does not exist. Returns True once the follow exists."""
    user_id = self._user_id(actor)
    if user_id is None:
      raise ValueError("a user session is required to follow an organization")
    ein = self._db.orgs.try_normalize_ein(org_ein)
    if not self.cursor.execute("SELECT 1 FROM organization WHERE ein = ?", (ein,)).fetchone():
      raise ValueError(f"organization {ein} not found")
    self.cursor.execute(
      "INSERT OR IGNORE INTO follow (user_id, org_ein, followed_by) VALUES (?, ?, ?)",
      (user_id, ein, actor.label))
    if self.cursor.rowcount > 0:
      self._db.audit.record(actor, 'create', 'follow', ein, {'user_id': user_id}, commit=False)
    self.connection.commit()
    return True

  def unfollow_org(self, org_ein: str, *, actor=None) -> bool:
    """Unfollow an org. Returns True if a follow was removed (False if not following
    or no acting user)."""
    user_id = self._user_id(actor)
    if user_id is None:
      return False
    ein = self._db.orgs.try_normalize_ein(org_ein)
    self.cursor.execute("DELETE FROM follow WHERE user_id = ? AND org_ein = ?", (user_id, ein))
    removed = self.cursor.rowcount > 0
    if removed:
      self._db.audit.record(actor, 'delete', 'follow', ein, {'user_id': user_id}, commit=False)
    self.connection.commit()
    return removed

  def is_following(self, user_id: int | None, org_ein: str) -> bool:
    if user_id is None:
      return False
    ein = self._db.orgs.try_normalize_ein(org_ein)
    return self.cursor.execute(
      "SELECT 1 FROM follow WHERE user_id = ? AND org_ein = ?", (user_id, ein)).fetchone() is not None

  def followed_eins(self, user_id: int | None, eins) -> set[str]:
    """The subset of ``eins`` the user follows — for annotating a page of org rows
    with a ``following`` flag in one query."""
    eins = list(eins)
    if user_id is None or not eins:
      return set()
    qs = ",".join("?" * len(eins))
    rows = self.cursor.execute(
      f"SELECT org_ein FROM follow WHERE user_id = ? AND org_ein IN ({qs})",
      (user_id, *eins)).fetchall()
    return {r[0] for r in rows}

  def follower_count(self, org_ein: str) -> int:
    ein = self._db.orgs.try_normalize_ein(org_ein)
    return self.cursor.execute(
      "SELECT COUNT(*) FROM follow WHERE org_ein = ?", (ein,)).fetchone()[0]

  def list_followed(self, user_id: int | None, *, org_type: str | None = None) -> list[dict]:
    """The orgs a user follows (newest first), optionally filtered to one
    ``org_type`` (e.g. 'foundation'). Each row carries the org's name + cached
    classification so a watchlist renders without a per-row detail fetch."""
    if user_id is None:
      return []
    clause, params = "", [user_id]
    if org_type:
      clause = " AND o.org_type = ?"
      params.append(org_type)
    rows = self.cursor.execute(
      "SELECT o.ein, o.name, o.org_type, o.is_grantmaker, f.followed_at "
      "FROM follow f JOIN organization o ON o.ein = f.org_ein "
      f"WHERE f.user_id = ?{clause} ORDER BY f.followed_at DESC, o.name", params).fetchall()
    return [{"ein": r[0], "name": r[1], "org_type": r[2], "is_grantmaker": bool(r[3]),
             "followed_at": r[4], "following": True} for r in rows]
