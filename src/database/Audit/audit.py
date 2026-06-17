import json

from database.base import Database


class AuditDatabase(Database):
  """Append-only audit trail of who edits what (reached as ``db.audit``).

  Mutating operations call ``record(...)`` with the acting ``Principal`` (or None
  for the CLI). A standalone concern with no FKs — the actor and entity ids are
  recorded as values, not relations, so the log survives deletes.
  """

  def __init__(self, db) -> None:
    self._db = db
    super().__init__("Audit", "Audit", connection=db.connection, cursor=db.cursor)

  def record(self, actor, action: str, entity_type: str, entity_id=None,
             changes=None, *, commit: bool = True) -> None:
    """Append one audit entry. ``actor`` is an auth ``Principal`` (a user or a
    program), or None for a CLI/system action. ``changes`` is any JSON-able value
    (e.g. the set of changed fields)."""
    if actor is None:
      kind, actor_id, label = "cli", None, None
    else:
      kind, actor_id, label = actor.kind, actor.actor_id, actor.label
    self.cursor.execute(
      "INSERT INTO audit_log (actor_kind, actor_id, actor_label, action, "
      "entity_type, entity_id, changes) VALUES (?, ?, ?, ?, ?, ?, ?)",
      (kind, actor_id, label, action, entity_type,
       str(entity_id) if entity_id is not None else None,
       json.dumps(changes) if changes is not None else None))
    if commit:
      self.connection.commit()

  def list_log(self, entity_type: str | None = None, entity_id=None,
               limit: int = 100) -> list[dict]:
    where, params = [], []
    if entity_type is not None:
      where.append("entity_type = ?")
      params.append(entity_type)
    if entity_id is not None:
      where.append("entity_id = ?")
      params.append(str(entity_id))
    clause = (" WHERE " + " AND ".join(where)) if where else ""
    rows = self.cursor.execute(
      "SELECT log_id, actor_kind, actor_id, actor_label, action, entity_type, "
      f"entity_id, changes, created_at FROM audit_log{clause} "
      "ORDER BY log_id DESC LIMIT ?", (*params, limit)).fetchall()
    return [
      {"log_id": r[0], "actor_kind": r[1], "actor_id": r[2], "actor_label": r[3],
       "action": r[4], "entity_type": r[5], "entity_id": r[6],
       "changes": json.loads(r[7]) if r[7] else None, "created_at": r[8]}
      for r in rows
    ]
