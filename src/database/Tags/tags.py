from database.base import Database


class TagsDatabase(Database):
  """Organization tags (reached as ``db.tags``). A tag is a named label applied
  to organizations; the Lists concern resolves smart lists by tag. Mutations are
  attributed to the acting principal via ``db.audit``."""

  def __init__(self, db) -> None:
    self._db = db
    super().__init__("Tags", "Tags", connection=db.connection, cursor=db.cursor)

  def list_tags(self) -> list[dict]:
    """All tags with how many organizations carry each."""
    rows = self.cursor.execute(
      "SELECT t.tag_id, t.name, COUNT(ot.org_ein) FROM tag t "
      "LEFT JOIN org_tag ot ON ot.tag_id = t.tag_id "
      "GROUP BY t.tag_id, t.name ORDER BY t.name").fetchall()
    return [{"tag_id": r[0], "name": r[1], "org_count": r[2]} for r in rows]

  def org_tags(self, org_ein: str) -> list[str]:
    rows = self.cursor.execute(
      "SELECT t.name FROM org_tag ot JOIN tag t ON t.tag_id = ot.tag_id "
      "WHERE ot.org_ein = ? ORDER BY t.name", (org_ein,)).fetchall()
    return [r[0] for r in rows]

  def _get_or_create_tag(self, name: str, label: str | None) -> int:
    row = self.cursor.execute("SELECT tag_id FROM tag WHERE name = ?", (name,)).fetchone()
    if row:
      return row[0]
    self.cursor.execute("INSERT INTO tag (name, created_by) VALUES (?, ?)", (name, label))
    return self.cursor.lastrowid

  def apply_tag(self, org_ein: str, name: str, *, actor=None) -> dict:
    """Apply a tag to an organization (creating the tag if new). Raises
    ValueError if the org does not exist or the tag name is blank."""
    name = (name or "").strip()
    if not name:
      raise ValueError("tag name is required")
    org_ein = self._db.orgs.try_normalize_ein(org_ein)
    if not self.cursor.execute(
        "SELECT 1 FROM organization WHERE ein = ?", (org_ein,)).fetchone():
      raise ValueError(f"organization {org_ein} not found")
    label = actor.label if actor is not None else None
    tag_id = self._get_or_create_tag(name, label)
    self.cursor.execute(
      "INSERT OR IGNORE INTO org_tag (org_ein, tag_id, created_by) VALUES (?, ?, ?)",
      (org_ein, tag_id, label))
    if self.cursor.rowcount > 0:   # only log when the tag was newly applied
      self._db.audit.record(actor, 'create', 'org_tag', f"{org_ein}:{name}", commit=False)
    self.connection.commit()
    return {"ein": org_ein, "tags": self.org_tags(org_ein)}

  def remove_tag(self, org_ein: str, name: str, *, actor=None) -> bool:
    org_ein = self._db.orgs.try_normalize_ein(org_ein)
    self.cursor.execute(
      "DELETE FROM org_tag WHERE org_ein = ? AND tag_id = "
      "(SELECT tag_id FROM tag WHERE name = ?)", (org_ein, (name or "").strip()))
    removed = self.cursor.rowcount > 0
    if removed:
      self._db.audit.record(actor, 'delete', 'org_tag', f"{org_ein}:{name}", commit=False)
    self.connection.commit()
    return removed

  def orgs_with_tags(self, names: list[str], match: str = "any") -> list[str]:
    """EINs of organizations carrying the given tags. ``match='any'`` (default) =
    at least one tag; ``match='all'`` = every tag. Used to resolve smart lists."""
    names = [n.strip() for n in (names or []) if n and n.strip()]
    if not names:
      return []
    qmarks = ",".join("?" * len(names))
    if match == "all":
      rows = self.cursor.execute(
        f"SELECT ot.org_ein FROM org_tag ot JOIN tag t ON t.tag_id = ot.tag_id "
        f"WHERE t.name IN ({qmarks}) GROUP BY ot.org_ein "
        f"HAVING COUNT(DISTINCT t.name) = ? ORDER BY ot.org_ein",
        (*names, len(set(n.lower() for n in names)))).fetchall()
    else:
      rows = self.cursor.execute(
        f"SELECT DISTINCT ot.org_ein FROM org_tag ot JOIN tag t ON t.tag_id = ot.tag_id "
        f"WHERE t.name IN ({qmarks}) ORDER BY ot.org_ein", names).fetchall()
    return [r[0] for r in rows]
