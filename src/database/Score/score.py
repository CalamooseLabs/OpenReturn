from database.IRS990 import IRS990Database


class ScoreDatabase(IRS990Database):
  def __init__(self, name="OpenReturn", path: str | None = None) -> None:
    super().__init__(name, path=path)
    self._run_dir("sql/setup", "Score")
    if not self._table_has_rows("score_model"):
      self._run_dir("sql/populate", "Score")

  def get_model_id(self, version: int = 1) -> int:
    row = self.cursor.execute(
      "SELECT model_id FROM score_model WHERE version = ?", (version,)
    ).fetchone()
    if not row:
      raise ValueError(f"Score model version {version} not found")
    return row[0]

  def get_factors(self, model_version: int = 1) -> list[dict]:
    rows = self.cursor.execute(
      """
      SELECT sf.factor_id, sf.name, sf.weight, sf.formula_type, sf.inputs,
             sf.direction, sf.benchmark_lo, sf.benchmark_hi, sf.formula_description
      FROM score_factor sf
      JOIN score_model sm ON sm.model_id = sf.model_id
      WHERE sm.version = ?
      ORDER BY sf.factor_id
      """,
      (model_version,)
    ).fetchall()
    return [
      {
        "factor_id":          r[0],
        "name":               r[1],
        "weight":             r[2],
        "formula_type":       r[3],
        "inputs":             r[4],
        "direction":          r[5],
        "benchmark_lo":       r[6],
        "benchmark_hi":       r[7],
        "formula_description":r[8],
      }
      for r in rows
    ]

  def create_score(self, filing_id: str, model_version: int = 1) -> int:
    model_id = self.get_model_id(model_version)
    self.cursor.execute(
      "INSERT INTO organization_score (filing_id, model_id) VALUES (?, ?)",
      (filing_id, model_id)
    )
    self.connection.commit()
    return self.cursor.lastrowid

  def store_factor_values(self, score_id: int, values: dict[int, tuple[float, float]]) -> None:
    """Store per-factor results. values maps factor_id → (raw_value, weighted_value)."""
    self.cursor.executemany(
      """
      INSERT OR REPLACE INTO organization_score_factor
        (score_id, factor_id, raw_value, weighted_value)
      VALUES (?, ?, ?, ?)
      """,
      [(score_id, fid, raw, weighted) for fid, (raw, weighted) in values.items()]
    )
    self.connection.commit()

  def finalize_score(self, score_id: int, total_score: float) -> None:
    self.cursor.execute(
      "UPDATE organization_score SET total_score = ? WHERE score_id = ?",
      (total_score, score_id)
    )
    self.connection.commit()

  def list_scores(self, ein: str) -> list[dict]:
    rows = self.cursor.execute(
      """
      SELECT os.score_id, sm.version, f.uuid, f.year, os.total_score, os.scored_at
      FROM organization_score os
      JOIN score_model sm ON sm.model_id = os.model_id
      JOIN filing f ON f.uuid = os.filing_id
      WHERE f.organization_id = ?
      ORDER BY f.year DESC, os.scored_at DESC
      """,
      (ein,)
    ).fetchall()
    return [
      {"score_id": r[0], "model_version": r[1], "filing_id": r[2], "year": r[3],
       "total_score": r[4], "scored_at": r[5]}
      for r in rows
    ]

  def compare_scores(self, ein: str, year: int) -> list[dict]:
    """Return scores for all model versions for the given EIN + tax year."""
    rows = self.cursor.execute(
      """
      SELECT os.score_id, sm.version, os.total_score, os.scored_at
      FROM organization_score os
      JOIN score_model sm ON sm.model_id = os.model_id
      JOIN filing f ON f.uuid = os.filing_id
      WHERE f.organization_id = ? AND f.year = ?
      ORDER BY sm.version
      """,
      (ein, year)
    ).fetchall()
    return [
      {"score_id": r[0], "model_version": r[1], "total_score": r[2], "scored_at": r[3]}
      for r in rows
    ]

  def get_score_by_filing(self, filing_id: str) -> dict | None:
    row = self.cursor.execute(
      "SELECT score_id FROM organization_score WHERE filing_id = ? ORDER BY scored_at DESC LIMIT 1",
      (filing_id,)
    ).fetchone()
    if not row:
      return None
    return self.get_score(row[0])

  def get_score_by_ein_year(self, ein: str, year: int) -> dict | None:
    row = self.cursor.execute(
      """
      SELECT os.score_id
      FROM organization_score os
      JOIN filing f ON f.uuid = os.filing_id
      WHERE f.organization_id = ? AND f.year = ?
      ORDER BY os.scored_at DESC LIMIT 1
      """,
      (ein, year)
    ).fetchone()
    if not row:
      return None
    return self.get_score(row[0])

  # ── ingest data management (purge) ──────────────────────────────────────
  # These delete stored filing data and live here (rather than on a filing
  # mixin) because removing a filing must also remove its scores:
  # organization_score.filing_id references filing.uuid with NO ON DELETE
  # CASCADE, so the scores are deleted first; reported_data DOES cascade off
  # filing.filing_id, so it goes automatically when the filing rows are deleted.

  _PURGE_WHERE = "zip_filename IS NOT NULL AND zip_filename LIKE ? ESCAPE '\\'"

  @staticmethod
  def _purge_like(pattern: str) -> str:
    from database.base import escape_like
    return f"%{escape_like(pattern)}%"

  def find_zip_filenames(self, pattern: str) -> list[tuple[str, int]]:
    """(zip_filename, filing_count) for archives whose ``zip_filename`` contains
    ``pattern`` (case-insensitive). Used to preview a purge before deleting."""
    rows = self.cursor.execute(
      f"SELECT zip_filename, COUNT(*) FROM filing WHERE {self._PURGE_WHERE} "
      "GROUP BY zip_filename ORDER BY zip_filename",
      (self._purge_like(pattern),),
    ).fetchall()
    return [(r[0], r[1]) for r in rows]

  def _purge_counts(self, where: str, params: tuple) -> dict:
    f = self.cursor.execute(
      f"SELECT COUNT(*) FROM filing WHERE {where}", params).fetchone()[0]
    v = self.cursor.execute(
      f"SELECT COUNT(*) FROM reported_data WHERE filing_id IN "
      f"(SELECT filing_id FROM filing WHERE {where})", params).fetchone()[0]
    s = self.cursor.execute(
      f"SELECT COUNT(*) FROM organization_score WHERE filing_id IN "
      f"(SELECT uuid FROM filing WHERE {where})", params).fetchone()[0]
    return {"filings": f, "values": v, "scores": s}

  def _purge(self, where: str, params: tuple) -> dict:
    counts = self._purge_counts(where, params)
    self.cursor.execute(
      f"DELETE FROM organization_score WHERE filing_id IN "
      f"(SELECT uuid FROM filing WHERE {where})", params)
    self.cursor.execute(f"DELETE FROM filing WHERE {where}", params)  # reported_data cascades
    self.connection.commit()
    return counts

  def delete_filings_by_zip(self, pattern: str) -> dict:
    """Delete every filing whose ``zip_filename`` matches ``pattern`` (substring),
    plus its reported_data (cascade) and scores. Returns counts removed."""
    return self._purge(self._PURGE_WHERE, (self._purge_like(pattern),))

  def delete_all_filings(self) -> dict:
    """Delete all filings, reported_data, and scores (schema, seed/reference
    data, API keys, and organizations are kept). Returns counts removed."""
    return self._purge("1=1", ())

  def get_score(self, score_id: int) -> dict | None:
    row = self.cursor.execute(
      """
      SELECT os.score_id, f.organization_id, sm.version, f.uuid, f.year, os.total_score, os.scored_at
      FROM organization_score os
      JOIN score_model sm ON sm.model_id = os.model_id
      JOIN filing f ON f.uuid = os.filing_id
      WHERE os.score_id = ?
      """,
      (score_id,)
    ).fetchone()
    if not row:
      return None
    factors = self.cursor.execute(
      """
      SELECT sf.name, sf.weight, osf.raw_value, osf.weighted_value
      FROM organization_score_factor osf
      JOIN score_factor sf ON sf.factor_id = osf.factor_id
      WHERE osf.score_id = ?
      ORDER BY sf.factor_id
      """,
      (score_id,)
    ).fetchall()
    return {
      "score_id": row[0],
      "ein": row[1],
      "model_version": row[2],
      "filing_id": row[3],
      "year": row[4],
      "total_score": row[5],
      "scored_at": row[6],
      "factors": [
        {"name": f[0], "weight": f[1], "raw_value": f[2], "weighted_value": f[3]}
        for f in factors
      ],
    }
