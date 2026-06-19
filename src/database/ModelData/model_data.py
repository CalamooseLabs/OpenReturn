from database.base import Database


class ModelDataDatabase(Database):
  """Per-(org, model, year) annotations: free-form notes + custom data fields
  (reached as ``db.model_data``).

  A ``Database`` subclass sharing the coordinator's connection. Lets a steward
  attach written context and arbitrary key/value data to a specific scoring model
  and fiscal year for an org — complementing the org-level Updates feed, the
  financial values that drive computed scores, and manual factor grades. EINs are
  normalized + validated via ``db.orgs``; every change is audited. ``model_version``
  is a soft TEXT reference (no FK; a model may be archived).
  """

  def __init__(self, db) -> None:
    self._db = db
    super().__init__("ModelData", "ModelData", connection=db.connection, cursor=db.cursor)

  def _norm(self, org_ein, model_version, fiscal_year):
    ein = self._db.orgs.try_normalize_ein(org_ein)
    if not str(model_version or "").strip():
      raise ValueError("model_version is required")
    try:
      year = int(fiscal_year)
    except (ValueError, TypeError):
      raise ValueError("fiscal_year must be an integer")
    return ein, str(model_version).strip(), year

  def _require_org(self, ein: str) -> None:
    if not self.cursor.execute("SELECT 1 FROM organization WHERE ein = ?", (ein,)).fetchone():
      raise ValueError(f"organization {ein} not found")

  # ── notes ────────────────────────────────────────────────────────────────
  def list_notes(self, org_ein: str, model_version: str, fiscal_year) -> list[dict]:
    ein, version, year = self._norm(org_ein, model_version, fiscal_year)
    rows = self.cursor.execute(
      "SELECT note_id, body, author_user_id, author_label, created_at "
      "FROM model_year_note WHERE org_ein = ? AND model_version = ? AND fiscal_year = ? "
      "ORDER BY created_at DESC, note_id DESC", (ein, version, year)).fetchall()
    return [{"note_id": r[0], "body": r[1], "author_user_id": r[2],
             "author_label": r[3], "created_at": r[4]} for r in rows]

  def add_note(self, org_ein: str, model_version: str, fiscal_year, body: str, *, actor=None) -> dict:
    ein, version, year = self._norm(org_ein, model_version, fiscal_year)
    body = (body or "").strip()
    if not body:
      raise ValueError("note body is required")
    self._require_org(ein)
    uid = actor.user_id if (actor is not None and getattr(actor, 'kind', None) == 'user') else None
    label = actor.label if actor is not None else None
    self.cursor.execute(
      "INSERT INTO model_year_note (org_ein, model_version, fiscal_year, body, "
      "author_user_id, author_label) VALUES (?, ?, ?, ?, ?, ?)",
      (ein, version, year, body, uid, label))
    nid = self.cursor.lastrowid
    self._db.audit.record(actor, 'create', 'model_year_note', nid,
                          {'org_ein': ein, 'model_version': version, 'fiscal_year': year},
                          commit=False)
    self.connection.commit()
    return {"note_id": nid, "body": body, "author_user_id": uid,
            "author_label": label}

  def delete_note(self, note_id: int, *, actor=None) -> bool:
    self.cursor.execute("DELETE FROM model_year_note WHERE note_id = ?", (note_id,))
    removed = self.cursor.rowcount > 0
    if removed:
      self._db.audit.record(actor, 'delete', 'model_year_note', note_id, None, commit=False)
    self.connection.commit()
    return removed

  # ── custom fields ──────────────────────────────────────────────────────────
  def list_fields(self, org_ein: str, model_version: str, fiscal_year) -> list[dict]:
    ein, version, year = self._norm(org_ein, model_version, fiscal_year)
    rows = self.cursor.execute(
      "SELECT field_id, label, value, created_by_user_id, created_by_label, created_at "
      "FROM model_year_field WHERE org_ein = ? AND model_version = ? AND fiscal_year = ? "
      "ORDER BY label, field_id", (ein, version, year)).fetchall()
    return [{"field_id": r[0], "label": r[1], "value": r[2],
             "created_by_user_id": r[3], "created_by_label": r[4], "created_at": r[5]}
            for r in rows]

  def add_field(self, org_ein: str, model_version: str, fiscal_year,
                label: str, value: str | None, *, actor=None) -> dict:
    ein, version, year = self._norm(org_ein, model_version, fiscal_year)
    label = (label or "").strip()
    if not label:
      raise ValueError("field label is required")
    self._require_org(ein)
    uid = actor.user_id if (actor is not None and getattr(actor, 'kind', None) == 'user') else None
    alabel = actor.label if actor is not None else None
    self.cursor.execute(
      "INSERT INTO model_year_field (org_ein, model_version, fiscal_year, label, value, "
      "created_by_user_id, created_by_label) VALUES (?, ?, ?, ?, ?, ?, ?)",
      (ein, version, year, label, (value or None), uid, alabel))
    fid = self.cursor.lastrowid
    self._db.audit.record(actor, 'create', 'model_year_field', fid,
                          {'org_ein': ein, 'model_version': version, 'fiscal_year': year,
                           'label': label}, commit=False)
    self.connection.commit()
    return {"field_id": fid, "label": label, "value": (value or None),
            "created_by_label": alabel}

  def delete_field(self, field_id: int, *, actor=None) -> bool:
    self.cursor.execute("DELETE FROM model_year_field WHERE field_id = ?", (field_id,))
    removed = self.cursor.rowcount > 0
    if removed:
      self._db.audit.record(actor, 'delete', 'model_year_field', field_id, None, commit=False)
    self.connection.commit()
    return removed

  def get(self, org_ein: str, model_version: str, fiscal_year) -> dict:
    """Both notes + custom fields for one (org, model, year) — the modal's read."""
    ein, version, year = self._norm(org_ein, model_version, fiscal_year)
    return {"ein": ein, "model_version": version, "fiscal_year": year,
            "notes": self.list_notes(ein, version, year),
            "fields": self.list_fields(ein, version, year)}
