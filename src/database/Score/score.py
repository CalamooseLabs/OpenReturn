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
      # Missing-data fallback (see scoring/models.md): model-level default policy +
      # per-score / per-factor imputation provenance.
      "ALTER TABLE score_model ADD COLUMN missing_data TEXT",
      # Per-type applicability (nonprofit / foundation / both). Default 'both' keeps
      # legacy models scoring every org; the shipped stack is scoped via its templates.
      "ALTER TABLE score_model ADD COLUMN applies_to TEXT NOT NULL DEFAULT 'both'",
      "ALTER TABLE organization_score ADD COLUMN imputed INTEGER NOT NULL DEFAULT 0",
      "ALTER TABLE organization_score_factor ADD COLUMN imputed INTEGER NOT NULL DEFAULT 0",
      "ALTER TABLE organization_score_factor ADD COLUMN source_year INTEGER",
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
      "COALESCE(model_kind, 'model'), created_at, missing_data, "
      "COALESCE(applies_to, 'both') "
      "FROM score_model WHERE version = ?",
      (version,)
    ).fetchone()
    if not row:
      return None
    return {"version": row[0], "description": row[1], "model_type": row[2],
            "scoring_mode": row[3] or "computed", "model_kind": row[4] or "model",
            "created_at": row[5], "missing_data": row[6], "applies_to": row[7]}

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
      "COALESCE(model_kind, 'model'), created_at, COALESCE(applies_to, 'both') "
      "FROM score_model ORDER BY version"
    ).fetchall()
    return [{"version": r[0], "description": r[1], "model_type": r[2],
             "scoring_mode": r[3] or "computed", "model_kind": r[4] or "model",
             "created_at": r[5], "applies_to": r[6]} for r in rows]

  def list_computed_models(self) -> list[dict]:
    """Versions + model_ids + kind of every non-manual model — the set batch
    scoring pre-computes, plus the kind so the engine can order base models before
    composites before super-composites. (A model with no factors is still listed;
    the engine skips it.)"""
    rows = self.cursor.execute(
      "SELECT version, model_id, COALESCE(model_kind, 'model'), missing_data, "
      "COALESCE(applies_to, 'both') "
      "FROM score_model WHERE COALESCE(scoring_mode, 'computed') != 'manual' "
      "ORDER BY version"
    ).fetchall()
    return [{"version": r[0], "model_id": r[1], "model_kind": r[2],
             "missing_data": r[3], "applies_to": r[4]} for r in rows]

  def replace_org_scores(self, ein: str, model_ids: list[int], results: list) -> None:
    """Batch (re)write of one org's computed scores. Deletes the org's existing
    scores for ``model_ids`` (factors cascade) then inserts the supplied results
    — used by the batch/recompute path so a fresh history reshapes every year's
    score. ``results`` is a list of
    ``(filing_id, model_id, total_score, factors[, imputed])`` where ``filing_id``
    is the **integer** filing.filing_id (the scoring engine carries it through from
    get_org_scoring_data / ensure_year_anchor_filing_id, so no uuid→id lookup is
    needed) and each factor
    is ``(factor_id, raw, weighted[, imputed, source_year])``; the optional
    imputation fields default to not-imputed (a real score). The delete is org-wide
    per model, so stale imputed rows from a prior run are cleaned up automatically.
    Does NOT commit — the batch driver commits per chunk of orgs. Scores for
    models outside ``model_ids`` (e.g. manual) are left untouched."""
    if model_ids:
      qmarks = ",".join("?" * len(model_ids))
      self.cursor.execute(
        f"DELETE FROM organization_score WHERE model_id IN ({qmarks}) "
        f"AND filing_id IN (SELECT filing_id FROM filing WHERE organization_id = ?)",
        (*model_ids, ein))
    for entry in results:
      filing_id, model_id, total, factors = entry[0], entry[1], entry[2], entry[3]
      imputed = entry[4] if len(entry) > 4 else 0
      # results carry the integer filing_id directly — no uuid→id subquery.
      self.cursor.execute(
        "INSERT INTO organization_score (filing_id, model_id, total_score, imputed) "
        "VALUES (?, ?, ?, ?)",
        (filing_id, model_id, total, 1 if imputed else 0))
      score_id = self.cursor.lastrowid
      if factors:
        self.cursor.executemany(
          "INSERT INTO organization_score_factor "
          "(score_id, factor_id, raw_value, weighted_value, imputed, source_year) "
          "VALUES (?, ?, ?, ?, ?, ?)",
          [(score_id, f[0], f[1], f[2],
            1 if (len(f) > 3 and f[3]) else 0,
            f[4] if len(f) > 4 else None) for f in factors])

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

  def store_factor_values(self, score_id: int, values: dict) -> None:
    """Store per-factor results. ``values`` maps factor_id → ``(raw, weighted)`` or
    ``(raw, weighted, imputed, source_year)`` (the latter carrying missing-data
    provenance; the short form defaults to not-imputed)."""
    self.cursor.executemany(
      """
      INSERT OR REPLACE INTO organization_score_factor
        (score_id, factor_id, raw_value, weighted_value, imputed, source_year)
      VALUES (?, ?, ?, ?, ?, ?)
      """,
      [(score_id, fid, t[0], t[1],
        1 if (len(t) > 2 and t[2]) else 0, t[3] if len(t) > 3 else None)
       for fid, t in values.items()]
    )
    self.connection.commit()

  def finalize_score(self, score_id: int, total_score: float, imputed: bool = False) -> None:
    self.cursor.execute(
      "UPDATE organization_score SET total_score = ?, imputed = ? WHERE score_id = ?",
      (total_score, 1 if imputed else 0, score_id)
    )
    self.connection.commit()

  def list_scores(self, ein: str) -> list[dict]:
    rows = self.cursor.execute(
      """
      SELECT os.score_id, sm.version, f.uuid, f.year, os.total_score, os.scored_at,
             os.imputed, sm.model_type, sm.model_kind
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
       "total_score": r[4], "scored_at": r[5], "imputed": bool(r[6]),
       "model_type": r[7], "model_kind": r[8]}
      for r in rows
    ]

  def list_score_history(self, ein: str, model_version: int) -> list[dict]:
    """One model's full score series for an org, oldest→newest — the MinistryWatch-
    style multi-year view. Each year carries ``imputed`` and, for an imputed year,
    the donor ``source_year`` of its filled factors (the earliest such donor)."""
    rows = self.cursor.execute(
      """
      SELECT f.year, os.total_score, os.imputed, os.score_id,
             MIN(osf.source_year)
      FROM organization_score os
      JOIN score_model sm ON sm.model_id = os.model_id
      JOIN filing f ON f.filing_id = os.filing_id
      LEFT JOIN organization_score_factor osf
        ON osf.score_id = os.score_id AND osf.source_year IS NOT NULL
      WHERE f.organization_id = ? AND sm.version = ?
      GROUP BY os.score_id
      ORDER BY f.year ASC
      """,
      (ein, model_version)
    ).fetchall()
    return [
      {"year": r[0], "total_score": r[1], "imputed": bool(r[2]),
       "score_id": r[3], "source_year": r[4]}
      for r in rows
    ]

  # ── ranking (query-time; no stored ranks) ────────────────────────────────
  # Rank orgs by a model's latest scored total_score, globally or within a subset
  # (sector / state / city / county / list / org_type / grantmaker). One window-fn
  # leaderboard + a COUNT-greater primitive for a single org's place in a subset.

  @staticmethod
  def _rank_subset(*, sector=None, state=None, city=None, county=None,
                   org_type=None, grantmaker=None, list_id=None):
    """Build (clauses, params) for the subset predicate, on the `sub` CTE aliases
    (o.* / a.* / l.ein). Mirrors OrganizationDatabase.search_organizations filters."""
    cl, p = [], []
    pairs = [
      (sector, "o.sector_code = ?", sector),
      (state, "a.state_code = ?", str(state).strip().upper() if state else None),
      (city, "a.city = ? COLLATE NOCASE", str(city).strip() if city else None),
      (county, "a.county_fips = ?", county),
      (org_type, "o.org_type = ?", org_type),
      (grantmaker is not None, "o.is_grantmaker = ?", 1 if grantmaker else 0),
      (list_id is not None,
       "EXISTS (SELECT 1 FROM org_list_member ml WHERE ml.org_ein = l.ein AND ml.list_id = ?)",
       list_id),
    ]
    for present, clause, param in pairs:
      if present:
        cl.append(clause)
        p.append(param)
    return cl, p

  def _rank_cte(self, model_version, year, clauses, params):
    """The `WITH latest, sub` prefix: `latest` = one row per org (the newest scored
    filing for the model, or a fixed year), `sub` = that set filtered to the subset.
    Returns (cte_sql, params)."""
    inner_year, iparams = "", [model_version]
    if year is not None:
      inner_year = " AND f.year = ?"
      iparams.append(year)
    subset = (" AND " + " AND ".join(clauses)) if clauses else ""
    cte = (
      "WITH latest AS ("
      " SELECT os.total_score AS total_score, f.organization_id AS ein, f.year AS year,"
      " ROW_NUMBER() OVER (PARTITION BY f.organization_id"
      "   ORDER BY f.year DESC, os.scored_at DESC) AS rn"
      " FROM organization_score os"
      " JOIN filing f ON f.filing_id = os.filing_id"
      " JOIN score_model sm ON sm.model_id = os.model_id"
      f" WHERE sm.version = ? AND os.total_score IS NOT NULL{inner_year}"
      "), sub AS ("
      " SELECT l.ein AS ein, o.name AS name, l.total_score AS total_score, l.year AS year"
      " FROM latest l"
      " JOIN organization o ON o.ein = l.ein"
      " LEFT JOIN address a ON a.uuid = o.business_address_id"
      f" WHERE l.rn = 1{subset}"
      ") ")
    return cte, [*iparams, *params]

  def rank_leaderboard(self, model_version: int = 1, *, year=None,
                       limit: int = 50, offset: int = 0, **subset) -> dict:
    """Rank orgs by ``model_version``'s latest scored total_score (or a fixed
    ``year``), within the optional subset. Ties share a rank (RANK()); pagination is
    deterministic (secondary sort by ein). Returns the page + the subset ``total``."""
    cl, p = self._rank_subset(**subset)
    cte, params = self._rank_cte(model_version, year, cl, p)
    limit, offset = max(1, min(limit, 500)), max(offset, 0)
    rows = self.cursor.execute(
      cte + "SELECT ein, name, total_score, year, "
            "RANK() OVER (ORDER BY total_score DESC) AS rank "
            "FROM sub ORDER BY total_score DESC, ein LIMIT ? OFFSET ?",
      [*params, limit, offset]).fetchall()
    total = self.cursor.execute(cte + "SELECT COUNT(*) FROM sub", params).fetchone()[0]
    return {"model_version": model_version, "year": year, "total": total,
            "limit": limit, "offset": offset,
            "leaderboard": [{"rank": r[4], "ein": r[0], "name": r[1],
                             "total_score": r[2], "year": r[3]} for r in rows]}

  def rank_org(self, ein: str, model_version: int = 1, *, year=None, **subset) -> dict:
    """One org's rank within a subset for a model — the COUNT-greater primitive:
    ``rank = 1 + (# scores strictly greater within the subset)``, with the subset size
    and percentile. ``rank``/``percentile`` are None when the org isn't in the subset
    (e.g. unscored, or filtered out)."""
    cl, p = self._rank_subset(**subset)
    cte, params = self._rank_cte(model_version, year, cl, p)
    ein = self._db.orgs.try_normalize_ein(ein)
    my, of = self.cursor.execute(
      cte + "SELECT (SELECT total_score FROM sub WHERE ein = ?), (SELECT COUNT(*) FROM sub)",
      [*params, ein]).fetchone()
    if my is None:
      return {"ein": ein, "rank": None, "of": of, "percentile": None, "total_score": None}
    rank = self.cursor.execute(
      cte + "SELECT 1 + COUNT(*) FROM sub WHERE total_score > ?", [*params, my]).fetchone()[0]
    pct = round(100.0 * (of - rank) / (of - 1), 1) if of > 1 else 100.0
    return {"ein": ein, "rank": rank, "of": of, "percentile": pct, "total_score": my}

  def rank_org_dimensions(self, ein: str, model_version: int = 1, *, year=None) -> dict | None:
    """An org's rank for a model across **its own org_type (overall) + sector /
    state / city / county**, all *within that org_type* — one call for an org-detail
    page. None if the org doesn't exist.

    Rankings are **within-type**: a foundation ranks only against foundations, a
    nonprofit only against nonprofits (the ``global`` dimension is "overall within
    your type"). This both implements the foundation/nonprofit separation and lets
    the page resolve all five dimensions from a SINGLE materialization of the model's
    latest-score-per-org set (a temp table), instead of re-running the windowed
    leaderboard CTE ~10x — which made the page hang at full-corpus scale."""
    ein = self._db.orgs.try_normalize_ein(ein)
    org = self._db.orgs.get_organization(ein)
    if org is None:
      return None
    addr = org.get('address') or {}
    org_type = org.get('org_type')

    cur = self.cursor
    cur.execute("DROP TABLE IF EXISTS _rank_set")
    inner_year, params = "", [model_version]
    if year is not None:
      inner_year = " AND f.year = ?"
      params.append(year)
    # Latest scored row per org for this model, with the ranking dimensions
    # denormalized — built once, then every COUNT below hits this small temp table.
    cur.execute(
      "CREATE TEMP TABLE _rank_set AS "
      "WITH latest AS ("
      " SELECT os.total_score AS total_score, f.organization_id AS ein,"
      " ROW_NUMBER() OVER (PARTITION BY f.organization_id"
      "   ORDER BY f.year DESC, os.scored_at DESC) AS rn"
      " FROM organization_score os"
      " JOIN filing f ON f.filing_id = os.filing_id"
      " JOIN score_model sm ON sm.model_id = os.model_id"
      f" WHERE sm.version = ? AND os.total_score IS NOT NULL{inner_year}"
      ") SELECT l.ein AS ein, l.total_score AS total_score, o.org_type AS org_type,"
      " o.sector_code AS sector, a.state_code AS state, a.city AS city,"
      " a.county_fips AS county"
      " FROM latest l JOIN organization o ON o.ein = l.ein"
      " LEFT JOIN address a ON a.uuid = o.business_address_id"
      " WHERE l.rn = 1", params)
    cur.execute("CREATE INDEX ix_rank_set ON _rank_set (org_type, total_score)")
    try:
      row = cur.execute("SELECT total_score FROM _rank_set WHERE ein = ?", (ein,)).fetchone()
      my = row[0] if row else None
      # org_type is always part of the predicate → every dimension is within-type.
      type_clause, type_args = (("org_type = ?", [org_type]) if org_type is not None
                                else ("org_type IS NULL", []))

      def _rank(extra_clause: str | None = None, extra_args: list | None = None) -> dict:
        clauses = [type_clause] + ([extra_clause] if extra_clause else [])
        args = [*type_args, *(extra_args or [])]
        where = " AND ".join(clauses)
        of = cur.execute(f"SELECT COUNT(*) FROM _rank_set WHERE {where}", args).fetchone()[0]
        if my is None:
          return {"ein": ein, "rank": None, "of": of, "percentile": None, "total_score": None}
        rank = cur.execute(
          f"SELECT 1 + COUNT(*) FROM _rank_set WHERE {where} AND total_score > ?",
          [*args, my]).fetchone()[0]
        pct = round(100.0 * (of - rank) / (of - 1), 1) if of > 1 else 100.0
        return {"ein": ein, "rank": rank, "of": of, "percentile": pct, "total_score": my}

      dims = {"global": _rank()}
      if org.get('sector_code'):
        dims["sector"] = _rank("sector = ?", [org['sector_code']])
      if addr.get('state'):
        dims["state"] = _rank("state = ?", [str(addr['state']).strip().upper()])
      if addr.get('city'):
        dims["city"] = _rank("city = ? COLLATE NOCASE", [str(addr['city']).strip()])
      if addr.get('county_fips'):
        dims["county"] = _rank("county = ?", [addr['county_fips']])
      return {"ein": ein, "model_version": model_version, "year": year,
              "org_type": org_type, "dimensions": dims}
    finally:
      cur.execute("DROP TABLE IF EXISTS _rank_set")

  def compare_scores(self, ein: str, year: int) -> list[dict]:
    """Return scores for all model versions for the given EIN + tax year."""
    rows = self.cursor.execute(
      """
      SELECT os.score_id, sm.version, os.total_score, os.scored_at, os.imputed
      FROM organization_score os
      JOIN score_model sm ON sm.model_id = os.model_id
      JOIN filing f ON f.filing_id = os.filing_id
      WHERE f.organization_id = ? AND f.year = ?
      ORDER BY sm.version
      """,
      (ein, year)
    ).fetchall()
    return [
      {"score_id": r[0], "model_version": r[1], "total_score": r[2], "scored_at": r[3],
       "imputed": bool(r[4])}
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
             COALESCE(sm.model_kind, 'model'), os.imputed
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
             sf.factor_id, sf.manual_scale, osf.imputed, osf.source_year
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
      "imputed": bool(row[10]),
      "factors": [
        {"factor_id": f[5], "name": f[0], "weight": f[1], "raw_value": f[2],
         "weighted_value": f[3], "comment": f[4], "manual_scale": f[6],
         "imputed": bool(f[7]), "source_year": f[8]}
        for f in factors
      ],
    }
