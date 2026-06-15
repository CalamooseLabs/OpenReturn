from database.base import Database


class ScoreDatabase(Database):
  """Scoring models, factors, and per-filing scores (computed and manual),
  reached as ``db.scores``.

  A ``Database`` subclass sharing the coordinator's connection; it owns the
  scoring schema (``Score/sql``) and joins to the ``filing`` table directly. The
  purge helpers also touch ``reported_data``/``organization_score`` (deleting
  scores before filings, since organization_score has no FK cascade).
  """

  def __init__(self, db) -> None:
    self._db = db
    super().__init__("Score", "Score", populate_guard="score_model",
                     connection=db.connection, cursor=db.cursor)
    self._migrate_columns()

  def _migrate_columns(self) -> None:
    """Add the model-type / manual-scoring columns to databases created before
    they existed (fresh DBs get them from sql/setup). Each ALTER is independent
    and ignored only when the column already exists."""
    for ddl in (
      "ALTER TABLE score_model ADD COLUMN model_type TEXT REFERENCES model_type (code)",
      "ALTER TABLE score_model ADD COLUMN scoring_mode TEXT NOT NULL DEFAULT 'computed'",
      # FK columns added via ALTER must default NULL (SQLite restriction), so
      # model_kind is nullable here and backfilled to 'model' below; fresh DBs get
      # it NOT NULL DEFAULT 'model' from sql/setup.
      "ALTER TABLE score_model ADD COLUMN model_kind TEXT REFERENCES model_kind (code)",
      "ALTER TABLE score_factor ADD COLUMN manual_scale TEXT",
      "ALTER TABLE organization_score_factor ADD COLUMN comment TEXT",
    ):
      try:
        self.cursor.execute(ddl)
      except Exception as exc:
        # Expected when the column already exists; re-raise anything else so a
        # genuine migration failure isn't silently swallowed (string match keeps
        # this binding-agnostic across sqlite3 / sqlcipher3).
        if 'duplicate column' not in str(exc).lower():
          raise
    # Backfill pre-existing models as financial/computed/base-model (the only kind
    # before these columns existed).
    try:
      self.cursor.execute(
        "UPDATE score_model SET model_type = 'financial' WHERE model_type IS NULL")
    except Exception:  # pragma: no cover — column guaranteed present above
      pass
    try:
      self.cursor.execute(
        "UPDATE score_model SET model_kind = 'model' WHERE model_kind IS NULL")
    except Exception:  # pragma: no cover — column guaranteed present above
      pass
    self.connection.commit()
    self._migrate_filing_key()

  def _migrate_filing_key(self) -> None:
    """Rebuild a legacy ``organization_score`` whose ``filing_id`` is the 36-char
    filing uuid into the integer ``filing.filing_id`` (with ON DELETE CASCADE),
    converting the values via a join on ``filing.uuid``. Fresh DBs already have
    the integer column (from sql/setup) and skip this. Mirrors the table-rebuild
    pattern in OrganizationDatabase._migrate_schema."""
    info = self.cursor.execute("PRAGMA table_info(organization_score)").fetchall()
    col = next((c for c in info if c[1] == 'filing_id'), None)
    if col is None or 'INT' in (col[2] or '').upper():
      return  # already integer (fresh DB) or table absent
    self.cursor.execute(
      "CREATE TABLE organization_score_new ("
      "score_id INTEGER PRIMARY KEY AUTOINCREMENT, "
      "filing_id INTEGER NOT NULL REFERENCES filing (filing_id) ON DELETE CASCADE, "
      "model_id INTEGER NOT NULL REFERENCES score_model (model_id), "
      "total_score REAL, scored_at DATETIME DEFAULT CURRENT_TIMESTAMP, "
      "UNIQUE (filing_id, model_id))")
    # Convert uuid → integer filing_id; scores whose filing is gone are dropped.
    self.cursor.execute(
      "INSERT INTO organization_score_new (score_id, filing_id, model_id, total_score, scored_at) "
      "SELECT os.score_id, f.filing_id, os.model_id, os.total_score, os.scored_at "
      "FROM organization_score os JOIN filing f ON f.uuid = os.filing_id")
    self.cursor.execute("DROP TABLE organization_score")
    self.cursor.execute("ALTER TABLE organization_score_new RENAME TO organization_score")
    self.cursor.execute("CREATE INDEX IF NOT EXISTS idx_org_score_filing ON organization_score (filing_id)")
    self.cursor.execute("CREATE INDEX IF NOT EXISTS idx_org_score_model ON organization_score (model_id)")
    self.connection.commit()

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
             sf.direction, sf.benchmark_lo, sf.benchmark_hi, sf.formula_description,
             sf.manual_scale
      FROM score_factor sf
      JOIN score_model sm ON sm.model_id = sf.model_id
      WHERE sm.version = ?
      ORDER BY sf.factor_id
      """,
      (model_version,)
    ).fetchall()
    return [self._factor_row(r) for r in rows]

  @staticmethod
  def _factor_row(r) -> dict:
    return {
      "factor_id":          r[0],
      "name":               r[1],
      "weight":             r[2],
      "formula_type":       r[3],
      "inputs":             r[4],
      "direction":          r[5],
      "benchmark_lo":       r[6],
      "benchmark_hi":       r[7],
      "formula_description":r[8],
      "manual_scale":       r[9],
    }

  def get_factor(self, factor_id: int) -> dict | None:
    row = self.cursor.execute(
      """
      SELECT factor_id, name, weight, formula_type, inputs, direction,
             benchmark_lo, benchmark_hi, formula_description, manual_scale
      FROM score_factor WHERE factor_id = ?
      """,
      (factor_id,)
    ).fetchone()
    return self._factor_row(row) if row else None

  def get_model(self, version: int = 1) -> dict | None:
    """Model header — version, description, category type, scoring mode, and kind."""
    row = self.cursor.execute(
      "SELECT version, description, model_type, scoring_mode, "
      "COALESCE(model_kind, 'model'), created_at "
      "FROM score_model WHERE version = ?",
      (version,)
    ).fetchone()
    if not row:
      return None
    return {"version": row[0], "description": row[1], "model_type": row[2],
            "scoring_mode": row[3] or "computed", "model_kind": row[4] or "model",
            "created_at": row[5]}

  def list_model_types(self) -> list[dict]:
    rows = self.cursor.execute(
      "SELECT code, name, description FROM model_type ORDER BY code"
    ).fetchall()
    return [{"code": r[0], "name": r[1], "description": r[2]} for r in rows]

  def list_model_kinds(self) -> list[dict]:
    rows = self.cursor.execute(
      "SELECT code, name, description FROM model_kind ORDER BY code"
    ).fetchall()
    return [{"code": r[0], "name": r[1], "description": r[2]} for r in rows]

  def list_models(self) -> list[dict]:
    rows = self.cursor.execute(
      "SELECT version, description, model_type, scoring_mode, "
      "COALESCE(model_kind, 'model'), created_at "
      "FROM score_model ORDER BY version"
    ).fetchall()
    return [{"version": r[0], "description": r[1], "model_type": r[2],
             "scoring_mode": r[3] or "computed", "model_kind": r[4] or "model",
             "created_at": r[5]} for r in rows]

  def list_computed_models(self) -> list[dict]:
    """Versions + model_ids + kind of every non-manual model — the set batch
    scoring pre-computes, plus the kind so the engine can order base models before
    composites before super-composites. (A model with no factors is still listed;
    the engine skips it.)"""
    rows = self.cursor.execute(
      "SELECT version, model_id, COALESCE(model_kind, 'model') FROM score_model "
      "WHERE COALESCE(scoring_mode, 'computed') != 'manual' ORDER BY version"
    ).fetchall()
    return [{"version": r[0], "model_id": r[1], "model_kind": r[2]} for r in rows]

  def replace_org_scores(self, ein: str, model_ids: list[int], results: list) -> None:
    """Batch (re)write of one org's computed scores. Deletes the org's existing
    scores for ``model_ids`` (factors cascade) then inserts the supplied results
    — used by the batch/recompute path so a fresh history reshapes every year's
    score. ``results`` is a list of
    ``(filing_uuid, model_id, total_score, [(factor_id, raw, weighted), …])``.
    Does NOT commit — the batch driver commits per chunk of orgs. Scores for
    models outside ``model_ids`` (e.g. manual) are left untouched."""
    if model_ids:
      qmarks = ",".join("?" * len(model_ids))
      self.cursor.execute(
        f"DELETE FROM organization_score WHERE model_id IN ({qmarks}) "
        f"AND filing_id IN (SELECT filing_id FROM filing WHERE organization_id = ?)",
        (*model_ids, ein))
    for filing_uuid, model_id, total, factors in results:
      # results carry the public uuid; resolve to the integer filing_id.
      self.cursor.execute(
        "INSERT INTO organization_score (filing_id, model_id, total_score) "
        "VALUES ((SELECT filing_id FROM filing WHERE uuid = ?), ?, ?)",
        (filing_uuid, model_id, total))
      score_id = self.cursor.lastrowid
      if factors:
        self.cursor.executemany(
          "INSERT INTO organization_score_factor "
          "(score_id, factor_id, raw_value, weighted_value) VALUES (?, ?, ?, ?)",
          [(score_id, fid, raw, weighted) for fid, raw, weighted in factors])

  def all_eins(self) -> list[str]:
    """Every organization EIN (for a full score rebuild). Materialized as a list
    rather than a live cursor: the batch driver commits per chunk of orgs, and a
    commit while an outer cursor is mid-iteration raises 'SQL statements in
    progress'. ~850k 10-char EINs is a few tens of MB — acceptable."""
    return [r[0] for r in self.cursor.execute("SELECT ein FROM organization ORDER BY ein").fetchall()]

  def grade_factor(self, score_id: int, factor_id: int, raw_value: float | None,
                   weighted_value: float | None, comment: str | None = None) -> None:
    """Upsert a single (manually graded) factor result — the grader's value, its
    weighted contribution, and an optional comment/explanation."""
    self.cursor.execute(
      """
      INSERT OR REPLACE INTO organization_score_factor
        (score_id, factor_id, raw_value, weighted_value, comment)
      VALUES (?, ?, ?, ?, ?)
      """,
      (score_id, factor_id, raw_value, weighted_value, comment)
    )
    self.connection.commit()

  def sum_weighted(self, score_id: int) -> float:
    row = self.cursor.execute(
      "SELECT COALESCE(SUM(weighted_value), 0.0) FROM organization_score_factor "
      "WHERE score_id = ?",
      (score_id,)
    ).fetchone()
    return row[0] if row else 0.0

  def create_score(self, filing_id: str, model_version: int = 1) -> int:
    """``filing_id`` is the public filing uuid; resolved to the integer
    filing.filing_id that organization_score stores."""
    model_id = self.get_model_id(model_version)
    self.cursor.execute(
      "INSERT INTO organization_score (filing_id, model_id) "
      "VALUES ((SELECT filing_id FROM filing WHERE uuid = ?), ?)",
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
      JOIN filing f ON f.filing_id = os.filing_id
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
      JOIN filing f ON f.filing_id = os.filing_id
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
    """``filing_id`` is the public filing uuid; resolved to the integer key."""
    row = self.cursor.execute(
      "SELECT score_id FROM organization_score "
      "WHERE filing_id = (SELECT filing_id FROM filing WHERE uuid = ?) "
      "ORDER BY scored_at DESC LIMIT 1",
      (filing_id,)
    ).fetchone()
    if not row:
      return None
    return self.get_score(row[0])

  def get_score_id_for(self, ein: str, year: int, model_version: int) -> int | None:
    """Most-recent score_id for an EIN + year under a specific model version."""
    row = self.cursor.execute(
      """
      SELECT os.score_id
      FROM organization_score os
      JOIN filing f ON f.filing_id = os.filing_id
      JOIN score_model sm ON sm.model_id = os.model_id
      WHERE f.organization_id = ? AND f.year = ? AND sm.version = ?
      ORDER BY os.scored_at DESC LIMIT 1
      """,
      (ein, year, model_version)
    ).fetchone()
    return row[0] if row else None

  def get_score_by_ein_year(self, ein: str, year: int) -> dict | None:
    row = self.cursor.execute(
      """
      SELECT os.score_id
      FROM organization_score os
      JOIN filing f ON f.filing_id = os.filing_id
      WHERE f.organization_id = ? AND f.year = ?
      ORDER BY os.scored_at DESC LIMIT 1
      """,
      (ein, year)
    ).fetchone()
    if not row:
      return None
    return self.get_score(row[0])

  # ── ingest data management (purge) ──────────────────────────────────────
  # These delete stored filing data and live here (rather than on the filing
  # concern) because they also count/remove scores. Both organization_score and
  # reported_data now reference filing.filing_id with ON DELETE CASCADE, so
  # deleting the filing rows removes both automatically — no manual ordering.

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
      f"(SELECT filing_id FROM filing WHERE {where})", params).fetchone()[0]
    return {"filings": f, "values": v, "scores": s}

  def _purge(self, where: str, params: tuple) -> dict:
    counts = self._purge_counts(where, params)
    # reported_data AND organization_score both cascade off filing.filing_id.
    self.cursor.execute(f"DELETE FROM filing WHERE {where}", params)
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
      SELECT os.score_id, f.organization_id, sm.version, f.uuid, f.year,
             os.total_score, os.scored_at, sm.model_type, sm.scoring_mode,
             COALESCE(sm.model_kind, 'model')
      FROM organization_score os
      JOIN score_model sm ON sm.model_id = os.model_id
      JOIN filing f ON f.filing_id = os.filing_id
      WHERE os.score_id = ?
      """,
      (score_id,)
    ).fetchone()
    if not row:
      return None
    factors = self.cursor.execute(
      """
      SELECT sf.name, sf.weight, osf.raw_value, osf.weighted_value, osf.comment,
             sf.factor_id, sf.manual_scale
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
      "model_type": row[7],
      "scoring_mode": row[8] or "computed",
      "model_kind": row[9] or "model",
      "factors": [
        {"factor_id": f[5], "name": f[0], "weight": f[1], "raw_value": f[2],
         "weighted_value": f[3], "comment": f[4], "manual_scale": f[6]}
        for f in factors
      ],
    }
