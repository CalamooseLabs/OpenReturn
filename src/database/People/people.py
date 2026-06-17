from database.base import Database, escape_like


class PeopleDatabase(Database):
  """Editable people and their organization memberships (reached as ``db.people``).

  User-managed CRM records, separate from the immutable as-filed 990 graph
  (``db.appearances``). Mutations are attributed to the acting principal via
  ``db.audit``. Memberships link a person to an organization (by EIN) with a
  role/title and optional dates.
  """

  def __init__(self, db) -> None:
    self._db = db
    super().__init__("People", "People", connection=db.connection, cursor=db.cursor)

  # ── people ────────────────────────────────────────────────────────────────

  @staticmethod
  def _person_row(r) -> dict:
    return {"person_id": r[0], "full_name": r[1], "email": r[2], "phone": r[3],
            "title": r[4], "notes": r[5], "created_by": r[6], "created_at": r[7],
            "updated_by": r[8], "updated_at": r[9]}

  _PERSON_COLS = ("person_id, full_name, email, phone, title, notes, "
                  "created_by, created_at, updated_by, updated_at")

  def get_person(self, person_id: int) -> dict | None:
    row = self.cursor.execute(
      f"SELECT {self._PERSON_COLS} FROM person WHERE person_id = ?", (person_id,)).fetchone()
    if not row:
      return None
    person = self._person_row(row)
    person["memberships"] = self.list_person_orgs(person_id)
    return person

  def list_people(self, search: str | None = None, limit: int = 50, offset: int = 0) -> dict:
    where, params = "", []
    if search:
      where = "WHERE full_name LIKE ? ESCAPE '\\' OR email LIKE ? ESCAPE '\\'"
      like = f"%{escape_like(search)}%"
      params = [like, like]
    total = self.cursor.execute(
      f"SELECT COUNT(*) FROM person {where}", params).fetchone()[0]
    rows = self.cursor.execute(
      f"SELECT {self._PERSON_COLS} FROM person {where} ORDER BY full_name LIMIT ? OFFSET ?",
      [*params, max(1, min(limit, 500)), max(offset, 0)]).fetchall()
    return {"total": total, "limit": limit, "offset": offset,
            "people": [self._person_row(r) for r in rows]}

  def create_person(self, full_name: str, *, email=None, phone=None, title=None,
                    notes=None, actor=None) -> dict:
    if not full_name or not str(full_name).strip():
      raise ValueError("full_name is required")
    label = actor.label if actor is not None else None
    self.cursor.execute(
      "INSERT INTO person (full_name, email, phone, title, notes, created_by, updated_by) "
      "VALUES (?, ?, ?, ?, ?, ?, ?)",
      (full_name, email, phone, title, notes, label, label))
    person_id = self.cursor.lastrowid
    self._db.audit.record(actor, 'create', 'person', person_id,
                          {'full_name': full_name}, commit=False)
    self.connection.commit()
    return self.get_person(person_id)

  def update_person(self, person_id: int, fields: dict, *, actor=None) -> dict | None:
    if not self.cursor.execute(
        "SELECT 1 FROM person WHERE person_id = ?", (person_id,)).fetchone():
      return None
    sets, params = [], []
    for col in ('full_name', 'email', 'phone', 'title', 'notes'):
      if col in fields:
        sets.append(f"{col} = ?")
        params.append(fields[col])
    sets.append("updated_by = ?")
    params.append(actor.label if actor is not None else None)
    sets.append("updated_at = datetime('now')")
    self.cursor.execute(
      f"UPDATE person SET {', '.join(sets)} WHERE person_id = ?", [*params, person_id])
    self._db.audit.record(actor, 'update', 'person', person_id,
                          {'fields': sorted(fields.keys())}, commit=False)
    self.connection.commit()
    return self.get_person(person_id)

  def delete_person(self, person_id: int, *, actor=None) -> bool:
    self.cursor.execute("DELETE FROM person WHERE person_id = ?", (person_id,))
    deleted = self.cursor.rowcount > 0
    if deleted:
      self._db.audit.record(actor, 'delete', 'person', person_id, commit=False)
    self.connection.commit()
    return deleted

  # ── memberships ─────────────────────────────────────────────────────────────

  def add_membership(self, person_id: int, org_ein: str, *, role_title=None,
                     is_primary=False, start_date=None, end_date=None, actor=None) -> dict:
    """Link a person to an organization (upsert on (person, org)). Raises
    ValueError if the person or organization does not exist."""
    org_ein = self._db.orgs.try_normalize_ein(org_ein)
    if not self.cursor.execute(
        "SELECT 1 FROM person WHERE person_id = ?", (person_id,)).fetchone():
      raise ValueError(f"person {person_id} not found")
    if not self.cursor.execute(
        "SELECT 1 FROM organization WHERE ein = ?", (org_ein,)).fetchone():
      raise ValueError(f"organization {org_ein} not found")
    label = actor.label if actor is not None else None
    self.cursor.execute(
      "INSERT INTO org_person (person_id, org_ein, role_title, is_primary, "
      "start_date, end_date, created_by) VALUES (?, ?, ?, ?, ?, ?, ?) "
      "ON CONFLICT(person_id, org_ein) DO UPDATE SET role_title = excluded.role_title, "
      "is_primary = excluded.is_primary, start_date = excluded.start_date, "
      "end_date = excluded.end_date",
      (person_id, org_ein, role_title, 1 if is_primary else 0, start_date, end_date, label))
    self._db.audit.record(actor, 'update', 'org_person', f"{person_id}:{org_ein}",
                          {'role_title': role_title}, commit=False)
    self.connection.commit()
    row = self.cursor.execute(
      "SELECT membership_id, person_id, org_ein, role_title, is_primary, start_date, end_date "
      "FROM org_person WHERE person_id = ? AND org_ein = ?", (person_id, org_ein)).fetchone()
    return self._membership_row(row)

  def remove_membership(self, person_id: int, org_ein: str, *, actor=None) -> bool:
    org_ein = self._db.orgs.try_normalize_ein(org_ein)
    self.cursor.execute(
      "DELETE FROM org_person WHERE person_id = ? AND org_ein = ?", (person_id, org_ein))
    removed = self.cursor.rowcount > 0
    if removed:
      self._db.audit.record(actor, 'delete', 'org_person', f"{person_id}:{org_ein}", commit=False)
    self.connection.commit()
    return removed

  @staticmethod
  def _membership_row(r) -> dict:
    return {"membership_id": r[0], "person_id": r[1], "org_ein": r[2],
            "role_title": r[3], "is_primary": bool(r[4]),
            "start_date": r[5], "end_date": r[6]}

  def list_person_orgs(self, person_id: int) -> list[dict]:
    """Organizations a person belongs to (membership + org name)."""
    rows = self.cursor.execute(
      "SELECT op.membership_id, op.person_id, op.org_ein, op.role_title, op.is_primary, "
      "op.start_date, op.end_date, o.name FROM org_person op "
      "JOIN organization o ON o.ein = op.org_ein WHERE op.person_id = ? "
      "ORDER BY op.is_primary DESC, o.name", (person_id,)).fetchall()
    return [{**self._membership_row(r), "org_name": r[7]} for r in rows]

  def list_org_people(self, org_ein: str) -> list[dict]:
    """People who belong to an organization (membership + person details)."""
    rows = self.cursor.execute(
      "SELECT op.membership_id, op.person_id, op.org_ein, op.role_title, op.is_primary, "
      "op.start_date, op.end_date, p.full_name, p.email, p.phone, p.title "
      "FROM org_person op JOIN person p ON p.person_id = op.person_id "
      "WHERE op.org_ein = ? ORDER BY op.is_primary DESC, p.full_name", (org_ein,)).fetchall()
    return [{**self._membership_row(r), "full_name": r[7], "email": r[8],
             "phone": r[9], "title": r[10]} for r in rows]
