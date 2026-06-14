class MetadataRepository:
  """Schema-derived metadata: the field-meta cache, XPath index, supported
  forms, and the ingest-time index drop/restore helpers used during bulk load.
  """

  def __init__(self, db) -> None:
    self._db = db
    self.cursor = db.cursor
    self.connection = db.connection

  def _build_field_meta_cache(self) -> dict[int, dict]:
    rows = self.cursor.execute("""
      SELECT fi.field_id, fi.xml_path, fi.sub_letter, fi.column_code, fi.box_label,
             l.line_number, l.line_label, l.data_type,
             s.section_code, s.section_name,
             p.part_number, p.part_name
      FROM field fi
      JOIN line l ON l.line_id = fi.line_id
      JOIN section s ON s.section_id = l.section_id
      JOIN part p ON p.part_id = s.part_id
    """).fetchall()
    return {r[0]: {
      "field_id":    r[0],
      "xml_path":    r[1],
      "sub_letter":  r[2],
      "column_code": r[3],
      "box_label":   r[4],
      "line":    {"number": r[5],  "label": r[6],  "data_type": r[7]},
      "section": {"code":   r[8],  "name":  r[9]},
      "part":    {"number": r[10], "name":  r[11]},
    } for r in rows}

  _INGEST_INDEXES = [
    ("idx_reported_data_filing", "reported_data (filing_id)"),
    ("idx_reported_data_field",  "reported_data (field_id)"),
    ("idx_filing_org",           "filing (organization_id)"),
  ]

  def drop_ingest_indexes(self) -> None:
    for name, _ in self._INGEST_INDEXES:
      self.cursor.execute(f"DROP INDEX IF EXISTS {name}")
    self.connection.commit()

  def restore_ingest_indexes(self) -> None:
    for name, cols in self._INGEST_INDEXES:
      self.cursor.execute(f"CREATE INDEX IF NOT EXISTS {name} ON {cols}")
    self.connection.commit()

  def get_field_source(self, xml_path: str) -> dict | None:
    """Resolve an ``xml_path`` to its full schema location — form, part, section,
    line, and field attributes — so a scoring-model input can be traced back to
    where the value is grabbed. Returns None if the path is not in the schema.

    Unlike the ``_field_meta`` cache (keyed on field_id, no form), this joins all
    the way up to ``form``. When the same path maps to more than one field row the
    highest field_id wins, matching ``get_xpath_index`` (a last-wins dict over
    rowid order) — so the source shown is the same field the stored value was
    resolved under, not a different one that happens to share the path.
    """
    row = self.cursor.execute(
      """
      SELECT fi.field_id, fi.xml_path, fi.sub_letter, fi.column_code, fi.box_label,
             fi.data_type,
             l.line_number, l.line_label, l.data_type,
             s.section_code, s.section_name,
             p.part_number, p.part_name,
             f.code, f.name
      FROM field fi
      JOIN line l    ON l.line_id    = fi.line_id
      JOIN section s ON s.section_id = l.section_id
      JOIN part p    ON p.part_id    = s.part_id
      JOIN form f    ON f.code       = p.form_code
      WHERE fi.xml_path = ?
      ORDER BY fi.field_id DESC
      LIMIT 1
      """,
      (xml_path,),
    ).fetchone()
    if row is None:
      return None
    return {
      "field_id":    row[0],
      "xml_path":    row[1],
      "sub_letter":  row[2],
      "column_code": row[3],
      "box_label":   row[4],
      "data_type":   row[5],
      "line":    {"number": row[6],  "label": row[7],  "data_type": row[8]},
      "section": {"code":   row[9],  "name":  row[10]},
      "part":    {"number": row[11], "name":  row[12]},
      "form":    {"code":   row[13], "name":  row[14]},
    }

  def get_supported_forms(self) -> set[str]:
    rows = self.cursor.execute(
      "SELECT code FROM form WHERE supported = 1"
    ).fetchall()
    return {row[0] for row in rows}

  def get_xpath_index(self) -> dict[str, int]:
    res = self.cursor.execute(
      "SELECT xml_path, field_id FROM field WHERE xml_path IS NOT NULL"
    )
    return {row[0]: row[1] for row in res.fetchall()}
