class OrganizationRepository:
  """Organization lookups, upserts, and favorite flagging.

  A repository composed onto ``OpenReturnDB``: it shares the facade's single
  SQLite connection (``db.cursor``/``db.connection``) and reaches sibling
  repositories via ``self._db`` when a query spans concerns.
  """

  def __init__(self, db) -> None:
    self._db = db
    self.cursor = db.cursor
    self.connection = db.connection

  def list_organizations(self, search: str | None = None,
                         limit: int = 50, offset: int = 0,
                         favorites_only: bool = False) -> dict:
    params: list = []
    clauses: list[str] = []
    if search:
      safe = search.replace("\\", "\\\\").replace("%", "\\%").replace("_", "\\_")
      clauses.append("name LIKE ? ESCAPE '\\'")
      params.append(f"%{safe}%")
    if favorites_only:
      clauses.append("is_favorite = 1")
    where = ("WHERE " + " AND ".join(clauses)) if clauses else ""
    total = self.cursor.execute(
      f"SELECT COUNT(*) FROM organization {where}", params
    ).fetchone()[0]
    rows = self.cursor.execute(
      f"SELECT ein, name, is_favorite, created_at, updated_at FROM organization {where} "
      "ORDER BY name LIMIT ? OFFSET ?",
      [*params, limit, offset]
    ).fetchall()
    return {
      "total": total, "limit": limit, "offset": offset,
      "organizations": [
        {"ein": r[0], "name": r[1], "is_favorite": bool(r[2]),
         "created_at": r[3], "updated_at": r[4]}
        for r in rows
      ],
    }

  def get_organization(self, ein: str) -> dict | None:
    row = self.cursor.execute(
      "SELECT ein, name, is_favorite, created_at, updated_at FROM organization WHERE ein = ?",
      (ein,)
    ).fetchone()
    if not row:
      return None
    return {"ein": row[0], "name": row[1], "is_favorite": bool(row[2]),
            "created_at": row[3], "updated_at": row[4]}

  def upsert_organization(self, ein: str, name: str) -> None:
    self.cursor.execute(
      "INSERT OR IGNORE INTO organization (ein, name) VALUES (?, ?)",
      (ein, name)
    )

  def set_favorite(self, ein: str, is_favorite: bool) -> bool:
    """Mark an organization as favorited (or not) and bump ``updated_at``.

    Returns True if an organization with that EIN exists (and was updated),
    False if no such organization is present."""
    self.cursor.execute(
      "UPDATE organization SET is_favorite = ?, updated_at = CURRENT_TIMESTAMP "
      "WHERE ein = ?",
      (1 if is_favorite else 0, ein)
    )
    self.connection.commit()
    return self.cursor.rowcount > 0
