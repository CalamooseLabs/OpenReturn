from database.base import Database


class NoteDatabase(Database):
  """Shared, team-wide organization notes / updates (reached as ``db.notes``).

  A ``Database`` subclass sharing the coordinator's connection. Notes are NOT
  per-user: every logged-in user sees the same feed for an org, and each note
  records its author (label + user_id) and timestamp. EINs are normalized via
  ``db.orgs`` and validated against the organization table; every change is audited.
  """

  def __init__(self, db) -> None:
    self._db = db
    super().__init__("Note", "Note", connection=db.connection, cursor=db.cursor)

  def list_notes(self, org_ein: str) -> list[dict]:
    """An org's notes, newest first (body, author, timestamp)."""
    ein = self._db.orgs.try_normalize_ein(org_ein)
    rows = self.cursor.execute(
      "SELECT note_id, body, author_user_id, author_label, created_at "
      "FROM org_note WHERE org_ein = ? ORDER BY created_at DESC, note_id DESC", (ein,)).fetchall()
    return [{"note_id": r[0], "body": r[1], "author_user_id": r[2],
             "author_label": r[3], "created_at": r[4]} for r in rows]

  def add_note(self, org_ein: str, body: str, *, actor=None) -> dict:
    """Post a note on an org. Raises ValueError on an empty body or unknown org.
    Records the author from ``actor`` (a user session, or a program/CLI label)."""
    body = (body or "").strip()
    if not body:
      raise ValueError("note body is required")
    ein = self._db.orgs.try_normalize_ein(org_ein)
    if not self.cursor.execute("SELECT 1 FROM organization WHERE ein = ?", (ein,)).fetchone():
      raise ValueError(f"organization {ein} not found")
    user_id = actor.user_id if (actor is not None and getattr(actor, 'kind', None) == 'user') else None
    label = actor.label if actor is not None else None
    self.cursor.execute(
      "INSERT INTO org_note (org_ein, body, author_user_id, author_label) VALUES (?, ?, ?, ?)",
      (ein, body, user_id, label))
    note_id = self.cursor.lastrowid
    self._db.audit.record(actor, 'create', 'org_note', note_id, {'org_ein': ein}, commit=False)
    self.connection.commit()
    row = self.cursor.execute(
      "SELECT note_id, body, author_user_id, author_label, created_at "
      "FROM org_note WHERE note_id = ?", (note_id,)).fetchone()
    return {"note_id": row[0], "body": row[1], "author_user_id": row[2],
            "author_label": row[3], "created_at": row[4]}

  def delete_note(self, note_id: int, *, actor=None) -> bool:
    """Remove a note by id. Returns True if a row was deleted."""
    self.cursor.execute("DELETE FROM org_note WHERE note_id = ?", (note_id,))
    removed = self.cursor.rowcount > 0
    if removed:
      self._db.audit.record(actor, 'delete', 'org_note', note_id, None, commit=False)
    self.connection.commit()
    return removed
