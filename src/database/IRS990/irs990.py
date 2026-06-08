import hashlib
import secrets
import uuid
from database import Database


class IRS990Database(Database):
  def __init__(self, name="OpenReturn", path: str | None = None) -> None:
    super().__init__(name, "IRS990", populate_guard="form", path=path)
    self._run_script("setup_api_keys.sql", "IRS990")
    try:
      self.cursor.execute(
        "ALTER TABLE api_key ADD COLUMN rate_limit INTEGER NOT NULL DEFAULT -1"
      )
      self.connection.commit()  # pragma: no cover — only runs on pre-migration DBs
    except Exception:
      pass  # column already exists (fresh DB has it from setup_api_keys.sql)
    self._field_meta: dict[int, dict] = self._build_field_meta_cache()
    self._key_cache:  dict[str, int | None] = {}

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
    Results are cached in memory per server session; cache is cleared on revoke.
    """
    key_hash = hashlib.sha256(raw.encode()).hexdigest()
    if key_hash in self._key_cache:
      return self._key_cache[key_hash]
    row = self.cursor.execute(
      "SELECT key_id, rate_limit FROM api_key WHERE key_hash = ? AND active = 1", (key_hash,)
    ).fetchone()
    result = row[1] if row else None
    self._key_cache[key_hash] = result
    if row:
      self.cursor.execute(
        "UPDATE api_key SET last_used_at = datetime('now') WHERE key_id = ?", (row[0],)
      )
      self.connection.commit()
    return result

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
    self._key_cache.clear()
    return self.cursor.rowcount > 0

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

  def list_organizations(self, search: str | None = None,
                         limit: int = 50, offset: int = 0) -> dict:
    params: list = []
    where = ""
    if search:
      safe = search.replace("\\", "\\\\").replace("%", "\\%").replace("_", "\\_")
      where = "WHERE name LIKE ? ESCAPE '\\'"
      params.append(f"%{safe}%")
    total = self.cursor.execute(
      f"SELECT COUNT(*) FROM organization {where}", params
    ).fetchone()[0]
    rows = self.cursor.execute(
      f"SELECT ein, name, created_at, updated_at FROM organization {where} ORDER BY name LIMIT ? OFFSET ?",
      [*params, limit, offset]
    ).fetchall()
    return {
      "total": total, "limit": limit, "offset": offset,
      "organizations": [
        {"ein": r[0], "name": r[1], "created_at": r[2], "updated_at": r[3]}
        for r in rows
      ],
    }

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

  def get_reported_data(self, filing_id: str) -> list[dict]:
    rows = self.cursor.execute(
      "SELECT field_id, raw_value FROM reported_data WHERE filing_id = ?", (filing_id,)
    ).fetchall()
    result = [
      {**self._field_meta[fid], "value": val}
      for fid, val in rows if fid in self._field_meta
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
      JOIN filing f  ON f.uuid = rd.filing_id
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

  def store_reported_data(self, filing_id: str, values: dict[int, str]) -> None:
    self.cursor.executemany(
      "INSERT OR IGNORE INTO reported_data (filing_id, field_id, raw_value) VALUES (?, ?, ?)",
      [(filing_id, field_id, value) for field_id, value in values.items()]
    )

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
