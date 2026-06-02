import uuid
from database import Database

class IRS990Database(Database):
  def __init__(self, name="IRS990") -> None:
    super().__init__(name, "IRS990", populate_guard="form")

  def get_xpath_index(self) -> dict[str, int]:
    res = self.cursor.execute(
      "SELECT xml_path, field_id FROM field WHERE xml_path IS NOT NULL"
    )
    return {row[0]: row[1] for row in res.fetchall()}

  def list_organizations(self) -> list[dict]:
    rows = self.cursor.execute(
      "SELECT ein, name, created_at, updated_at FROM organization ORDER BY name"
    ).fetchall()
    return [{"ein": r[0], "name": r[1], "created_at": r[2], "updated_at": r[3]} for r in rows]

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
    self.connection.commit()

  def list_filings(self, ein: str) -> list[dict]:
    rows = self.cursor.execute(
      """
      SELECT uuid, year, form_code, created_at, object_id, xml_source_url
      FROM filing WHERE organization_id = ? ORDER BY year DESC
      """,
      (ein,)
    ).fetchall()
    return [
      {"filing_id": r[0], "year": r[1], "form_code": r[2],
       "created_at": r[3], "object_id": r[4], "xml_source_url": r[5]}
      for r in rows
    ]

  def get_filing(self, filing_id: str) -> dict | None:
    row = self.cursor.execute(
      """
      SELECT uuid, year, organization_id, form_code, created_at, object_id, xml_source_url
      FROM filing WHERE uuid = ?
      """,
      (filing_id,)
    ).fetchone()
    if not row:
      return None
    return {
      "filing_id": row[0], "year": row[1], "ein": row[2], "form_code": row[3],
      "created_at": row[4], "object_id": row[5], "xml_source_url": row[6]
    }

  def create_filing(self, ein: str, year: int, form_code: str) -> str:
    filing_id = str(uuid.uuid4())
    self.cursor.execute(
      "INSERT INTO filing (uuid, year, organization_id, form_code) VALUES (?, ?, ?, ?)",
      (filing_id, year, ein, form_code)
    )
    self.connection.commit()
    return filing_id

  def get_reported_data(self, filing_id: str) -> list[dict]:
    rows = self.cursor.execute(
      """
      SELECT f.xml_path, rd.raw_value, rd.field_id
      FROM reported_data rd
      JOIN field f ON f.field_id = rd.field_id
      WHERE rd.filing_id = ?
      ORDER BY rd.field_id
      """,
      (filing_id,)
    ).fetchall()
    return [{"xml_path": r[0], "raw_value": r[1], "field_id": r[2]} for r in rows]

  def store_reported_data(self, filing_id: str, values: dict[int, str]) -> None:
    self.cursor.executemany(
      "INSERT OR IGNORE INTO reported_data (filing_id, field_id, raw_value) VALUES (?, ?, ?)",
      [(filing_id, field_id, value) for field_id, value in values.items()]
    )
    self.connection.commit()
