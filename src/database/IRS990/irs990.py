import hashlib
import secrets
import uuid
from database import Database

_RICH_FIELDS_SQL = """
  SELECT
    rd.raw_value,
    fi.field_id,
    fi.xml_path,
    fi.sub_letter,
    fi.column_code,
    fi.box_label,
    l.line_number,
    l.line_label,
    l.data_type,
    s.section_code,
    s.section_name,
    p.part_number,
    p.part_name
  FROM reported_data rd
  JOIN field fi ON fi.field_id = rd.field_id
  JOIN line l ON l.line_id = fi.line_id
  JOIN section s ON s.section_id = l.section_id
  JOIN part p ON p.part_id = s.part_id
  WHERE rd.filing_id = ?
  ORDER BY p.part_number, s.section_code, l.line_number, fi.sub_letter, fi.column_code
"""

def _build_field(r: tuple) -> dict:
  return {
    "field_id":   r[1],
    "value":      r[0],
    "xml_path":   r[2],
    "sub_letter": r[3],
    "column_code": r[4],
    "box_label":  r[5],
    "line":    {"number": r[6], "label": r[7], "data_type": r[8]},
    "section": {"code": r[9], "name": r[10]},
    "part":    {"number": r[11], "name": r[12]},
  }


class IRS990Database(Database):
  def __init__(self, name="IRS990", path: str | None = None) -> None:
    super().__init__(name, "IRS990", populate_guard="form", path=path)
    self._run_script("setup_api_keys.sql", "IRS990")
    try:
      self.cursor.execute(
        "ALTER TABLE api_key ADD COLUMN rate_limit INTEGER NOT NULL DEFAULT -1"
      )
      self.connection.commit()  # pragma: no cover — only runs on pre-migration DBs
    except Exception:
      pass  # column already exists (fresh DB has it from setup_api_keys.sql)

  # --- API keys ---

  def create_api_key(self, name: str, rate_limit: int = -1) -> tuple[int, str]:
    raw = secrets.token_urlsafe(32)
    key_hash = hashlib.sha256(raw.encode()).hexdigest()
    self.cursor.execute(
      "INSERT INTO api_key (name, key_hash, rate_limit) VALUES (?, ?, ?)",
      (name, key_hash, rate_limit)
    )
    self.connection.commit()
    return self.cursor.lastrowid, raw

  def validate_api_key(self, raw: str) -> int | None:
    """
    Returns the rate limit for a valid active key (-1 = no limit),
    or None if the key is invalid or revoked.
    """
    key_hash = hashlib.sha256(raw.encode()).hexdigest()
    row = self.cursor.execute(
      "SELECT key_id, rate_limit FROM api_key WHERE key_hash = ? AND active = 1", (key_hash,)
    ).fetchone()
    if row:
      self.cursor.execute(
        "UPDATE api_key SET last_used_at = datetime('now') WHERE key_id = ?", (row[0],)
      )
      self.connection.commit()
      return row[1]
    return None

  def list_api_keys(self) -> list[dict]:
    rows = self.cursor.execute(
      "SELECT key_id, name, created_at, last_used_at, active, rate_limit FROM api_key ORDER BY key_id"
    ).fetchall()
    return [
      {"key_id": r[0], "name": r[1], "created_at": r[2], "last_used_at": r[3],
       "active": bool(r[4]), "rate_limit": r[5]}
      for r in rows
    ]

  def revoke_api_key(self, key_id: int) -> bool:
    self.cursor.execute("UPDATE api_key SET active = 0 WHERE key_id = ?", (key_id,))
    self.connection.commit()
    return self.cursor.rowcount > 0

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
    filing_id = str(uuid.uuid4())
    self.cursor.execute(
      """
      INSERT INTO filing (uuid, year, organization_id, form_code, xml_filename, zip_filename)
      VALUES (?, ?, ?, ?, ?, ?)
      """,
      (filing_id, year, ein, form_code, xml_filename, zip_filename)
    )
    self.connection.commit()
    return filing_id

  def get_reported_data(self, filing_id: str) -> list[dict]:
    rows = self.cursor.execute(_RICH_FIELDS_SQL, (filing_id,)).fetchall()
    return [_build_field(r) for r in rows]

  def store_reported_data(self, filing_id: str, values: dict[int, str]) -> None:
    self.cursor.executemany(
      "INSERT OR IGNORE INTO reported_data (filing_id, field_id, raw_value) VALUES (?, ?, ?)",
      [(filing_id, field_id, value) for field_id, value in values.items()]
    )
    self.connection.commit()

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
