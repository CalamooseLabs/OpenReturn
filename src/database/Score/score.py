from database.IRS990 import IRS990Database

class ScoreDatabase(IRS990Database):
  def __init__(self, name="IRS990") -> None:
    super().__init__(name)
    self._run_script("setup.sql", "Score")
    if not self._table_has_rows("score_model"):
      self._run_script("populate.sql", "Score")

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
      SELECT sf.factor_id, sf.name, sf.weight, sf.formula_description
      FROM score_factor sf
      JOIN score_model sm ON sm.model_id = sf.model_id
      WHERE sm.version = ?
      ORDER BY sf.factor_id
      """,
      (model_version,)
    ).fetchall()
    return [
      {"factor_id": r[0], "name": r[1], "weight": r[2], "formula_description": r[3]}
      for r in rows
    ]

  def create_score(self, ein: str, model_version: int = 1) -> int:
    model_id = self.get_model_id(model_version)
    self.cursor.execute(
      "INSERT INTO organization_score (organization_id, model_id) VALUES (?, ?)",
      (ein, model_id)
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
      SELECT os.score_id, sm.version, os.total_score, os.scored_at
      FROM organization_score os
      JOIN score_model sm ON sm.model_id = os.model_id
      WHERE os.organization_id = ?
      ORDER BY os.scored_at DESC
      """,
      (ein,)
    ).fetchall()
    return [
      {"score_id": r[0], "model_version": r[1], "total_score": r[2], "scored_at": r[3]}
      for r in rows
    ]

  def get_score(self, score_id: int) -> dict | None:
    row = self.cursor.execute(
      """
      SELECT os.score_id, os.organization_id, sm.version, os.total_score, os.scored_at
      FROM organization_score os
      JOIN score_model sm ON sm.model_id = os.model_id
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
      "organization_id": row[1],
      "model_version": row[2],
      "total_score": row[3],
      "scored_at": row[4],
      "factors": [
        {"name": f[0], "weight": f[1], "raw_value": f[2], "weighted_value": f[3]}
        for f in factors
      ],
    }
