import uuid


class FilingRepository:
  """Filing lookups, creation, and the combined filing+reported-data fetch.

  ``get_filing_data_by_ein_year`` calls ``self.get_reported_data`` from
  ReportedDataRepository — both are flattened onto IRS990Database.
  """

  def list_filings(self, ein: str) -> list[dict]:
    rows = self.cursor.execute(
      """
      SELECT uuid, year, form_code, created_at, object_id, xml_source_url, xml_filename, zip_filename
      FROM filing WHERE organization_id = ? ORDER BY year DESC
      """,
      (ein,)
    ).fetchall()
    return [
      {"filing_id": r[0], "year": r[1], "form_code": r[2], "created_at": r[3],
       "object_id": r[4], "xml_source_url": r[5], "xml_filename": r[6], "zip_filename": r[7]}
      for r in rows
    ]

  def get_filing(self, filing_id: str) -> dict | None:
    row = self.cursor.execute(
      """
      SELECT uuid, year, organization_id, form_code, created_at, object_id,
             xml_source_url, xml_filename, zip_filename
      FROM filing WHERE uuid = ?
      """,
      (filing_id,)
    ).fetchone()
    if not row:
      return None
    return {
      "filing_id": row[0], "year": row[1], "ein": row[2], "form_code": row[3],
      "created_at": row[4], "object_id": row[5], "xml_source_url": row[6],
      "xml_filename": row[7], "zip_filename": row[8],
    }

  def create_filing(self, ein: str, year: int, form_code: str,
                    xml_filename: str | None = None, zip_filename: str | None = None) -> str:
    """Insert a filing (or find the existing one for this EIN/year/form) and
    return its public uuid. The integer filing_id (rowid) is internal; methods
    that touch reported_data resolve uuid → filing_id themselves."""
    filing_id = str(uuid.uuid4())
    self.cursor.execute(
      """
      INSERT OR IGNORE INTO filing (uuid, year, organization_id, form_code, xml_filename, zip_filename)
      VALUES (?, ?, ?, ?, ?, ?)
      """,
      (filing_id, year, ein, form_code, xml_filename, zip_filename)
    )
    if self.cursor.rowcount == 0:
      row = self.cursor.execute(
        "SELECT uuid FROM filing WHERE organization_id = ? AND year = ? AND form_code = ?",
        (ein, year, form_code)
      ).fetchone()
      return row[0]
    return filing_id

  def get_filing_data_by_ein_year(self, ein: str, year: int) -> dict | None:
    row = self.cursor.execute(
      """
      SELECT uuid, form_code, xml_filename, zip_filename
      FROM filing WHERE organization_id = ? AND year = ?
      """,
      (ein, year)
    ).fetchone()
    if not row:
      return None
    filing_id, form_code, xml_filename, zip_filename = row
    return {
      "filing_id":    filing_id,
      "ein":          ein,
      "year":         year,
      "form_code":    form_code,
      "xml_filename": xml_filename,
      "zip_filename": zip_filename,
      "fields":       self.get_reported_data(filing_id),
    }
