class OrganizationRepository:
  """Organization lookups and upserts."""

  def list_organizations(self, search: str | None = None,
                         limit: int = 50, offset: int = 0) -> dict:
    params: list = []
    where = ""
    if search:
      safe = search.replace("\\", "\\\\").replace("%", "\\%").replace("_", "\\_")
      where = "WHERE name LIKE ? ESCAPE '\\'"
      params.append(f"%{safe}%")
    total = self.cursor.execute(
      f"SELECT COUNT(*) FROM organization {where}", params
    ).fetchone()[0]
    rows = self.cursor.execute(
      f"SELECT ein, name, created_at, updated_at FROM organization {where} ORDER BY name LIMIT ? OFFSET ?",
      [*params, limit, offset]
    ).fetchall()
    return {
      "total": total, "limit": limit, "offset": offset,
      "organizations": [
        {"ein": r[0], "name": r[1], "created_at": r[2], "updated_at": r[3]}
        for r in rows
      ],
    }

  def get_organization(self, ein: str) -> dict | None:
    row = self.cursor.execute(
      "SELECT ein, name, created_at, updated_at FROM organization WHERE ein = ?", (ein,)
    ).fetchone()
    if not row:
      return None
    return {"ein": row[0], "name": row[1], "created_at": row[2], "updated_at": row[3]}

  def upsert_organization(self, ein: str, name: str) -> None:
    self.cursor.execute(
      "INSERT OR IGNORE INTO organization (ein, name) VALUES (?, ?)",
      (ein, name)
    )
