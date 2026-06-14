class ReportedDataRepository:
  """Read/write of per-filing reported field values.

  ``get_reported_data`` joins each stored value against the facade's
  ``_field_meta`` cache (built once by ``OpenReturnDB`` via the metadata repo).
  """

  def __init__(self, db) -> None:
    self._db = db
    self.cursor = db.cursor
    self.connection = db.connection

  def get_reported_data(self, filing_uuid: str) -> list[dict]:
    """filing_uuid is the public filing uuid; the join resolves it to the
    integer reported_data.filing_id."""
    field_meta = self._db._field_meta
    rows = self.cursor.execute(
      "SELECT rd.field_id, rd.raw_value FROM reported_data rd "
      "JOIN filing f ON f.filing_id = rd.filing_id WHERE f.uuid = ?", (filing_uuid,)
    ).fetchall()
    result = [
      {**field_meta[fid], "value": val}
      for fid, val in rows if fid in field_meta
    ]
    result.sort(key=lambda f: (
      f["part"]["number"]    or "",
      f["section"]["code"]   or "",
      f["line"]["number"]    or "",
      f["sub_letter"]        or "",
      f["column_code"]       or "",
    ))
    return result

  def get_historical_values(self, ein: str) -> dict[str, list[float]]:
    """Returns {xml_path: [values ordered oldest-to-newest]} across all filings for the org."""
    rows = self.cursor.execute("""
      SELECT fi.xml_path, rd.raw_value
      FROM reported_data rd
      JOIN field fi ON fi.field_id = rd.field_id
      JOIN filing f  ON f.filing_id = rd.filing_id
      WHERE f.organization_id = ?
        AND fi.xml_path IS NOT NULL
      ORDER BY fi.xml_path, f.year ASC
    """, (ein,)).fetchall()
    result: dict[str, list[float]] = {}
    for path, raw in rows:
      if raw is not None:
        try:
          result.setdefault(path, []).append(float(raw))
        except (ValueError, TypeError):
          pass
    return result

  def store_reported_data(self, filing_uuid: str, values: dict[int, str]) -> None:
    """filing_uuid is the public filing uuid; it is resolved to the integer
    filing_id once, then used for all rows. (The bulk ingest path assigns
    integer ids directly and does not go through here.)"""
    row = self.cursor.execute(
      "SELECT filing_id FROM filing WHERE uuid = ?", (filing_uuid,)
    ).fetchone()
    if row is None:
      return
    fid = row[0]
    self.cursor.executemany(
      "INSERT OR IGNORE INTO reported_data (filing_id, field_id, raw_value) VALUES (?, ?, ?)",
      [(fid, field_id, value) for field_id, value in values.items()]
    )
