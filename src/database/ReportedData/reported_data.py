from database.base import Database


class ReportedDataDatabase(Database):
  """Read/write of per-filing reported field values (reached as
  ``db.reported_data``).

  A ``Database`` subclass sharing the coordinator's connection.
  ``get_reported_data`` joins each stored value against the facade's
  ``_field_meta`` cache (built once by ``OpenReturnDB`` via the schema concern).
  """

  def __init__(self, db) -> None:
    self._db = db
    super().__init__("ReportedData", "ReportedData", connection=db.connection, cursor=db.cursor)

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

  def get_org_scoring_data(self, ein: str, paths) -> tuple[list[dict], dict, dict]:
    """One-org bulk load for batch scoring. Returns
    ``(filings, vals_by_uuid, historical)`` from two queries:

    - ``filings``: every filing for the org as ``{filing_id(uuid), year, form_code}``
      (year-ascending) — so even filings with no scoring-relevant values still
      get scored (their factors resolve to None → 0).
    - ``vals_by_uuid``: ``{filing_uuid: {xml_path: float}}`` limited to ``paths``
      (the handful of fields scoring formulas read).
    - ``historical``: ``{xml_path: [float oldest→newest]}`` across the org — the
      series the historical formulas operate on (so adding a year reshapes it).
    """
    frows = self.cursor.execute(
      "SELECT uuid, year, form_code FROM filing WHERE organization_id = ? ORDER BY year ASC",
      (ein,)
    ).fetchall()
    filings = [{"filing_id": r[0], "year": r[1], "form_code": r[2]} for r in frows]

    paths = list(paths)
    vals_by_uuid: dict[str, dict[str, float]] = {}
    historical: dict[str, list[float]] = {}
    if filings and paths:
      qmarks = ",".join("?" * len(paths))
      vrows = self.cursor.execute(
        f"""
        SELECT f.uuid, fi.xml_path, rd.raw_value
        FROM filing f
        JOIN reported_data rd ON rd.filing_id = f.filing_id
        JOIN field fi ON fi.field_id = rd.field_id
        WHERE f.organization_id = ? AND fi.xml_path IN ({qmarks})
        ORDER BY f.year ASC
        """,
        (ein, *paths)
      ).fetchall()
      for uuid_, path, raw in vrows:
        if raw is None:
          continue
        try:
          val = float(raw)
        except (ValueError, TypeError):
          continue
        vals_by_uuid.setdefault(uuid_, {})[path] = val
        historical.setdefault(path, []).append(val)
    return filings, vals_by_uuid, historical

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
