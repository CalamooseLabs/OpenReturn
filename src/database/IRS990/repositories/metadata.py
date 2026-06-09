class MetadataRepository:
  """Schema-derived metadata: the field-meta cache, XPath index, supported
  forms, and the ingest-time index drop/restore helpers used during bulk load.
  """

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
