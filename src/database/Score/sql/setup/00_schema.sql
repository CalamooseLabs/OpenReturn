-- Model categories. Seeded here (in setup, INSERT OR IGNORE) rather than in
-- populate so the rows exist on every startup — populate only runs on a fresh
-- DB (guarded on score_model), which would skip seeding this on upgrades.
CREATE TABLE IF NOT EXISTS model_type (
  code        TEXT PRIMARY KEY,
  name        TEXT NOT NULL,
  description TEXT
);

INSERT OR IGNORE INTO model_type (code, name, description) VALUES
  ('financial',           'Financial Health',    'Quantitative financial ratios computed from 990 data'),
  ('governance',          'Governance',          'Board composition, policies, and oversight'),
  ('whole_person',        'Whole-Person',        'Holistic organizational and staff well-being'),
  ('christ_centeredness', 'Christ-Centeredness',  'Mission and faith alignment');

-- How a model is composed (orthogonal to model_type/scoring_mode). Seeded here in
-- setup (INSERT OR IGNORE) for the same reason as model_type — the rows must exist
-- on every startup, and populate only runs on a fresh DB.
--   'model'           — factors are formulas over 990 fields (the original kind).
--   'composite'       — factors weight other *models'* final scores (model:<v>).
--   'super_composite' — factors weight *composites'* final scores (model:<v>).
CREATE TABLE IF NOT EXISTS model_kind (
  code        TEXT PRIMARY KEY,
  name        TEXT NOT NULL,
  description TEXT
);

INSERT OR IGNORE INTO model_kind (code, name, description) VALUES
  ('model',           'Model',           'Factors are formulas over 990 field data'),
  ('composite',       'Composite',       'Factors weight the final scores of base models'),
  ('super_composite', 'Super Composite', 'Factors weight the final scores of composites');

CREATE TABLE IF NOT EXISTS score_model (
  model_id INTEGER PRIMARY KEY AUTOINCREMENT,
  -- A version is an opaque STRING identifier (e.g. '1', '1.1', '2026.06.14') —
  -- see models.valid_version. Stored verbatim; the engine keys model dicts and
  -- the 'model:<version>' child-ref token on it.
  version TEXT NOT NULL UNIQUE,
  description TEXT,
  model_type TEXT REFERENCES model_type (code),
  -- 'computed' = factors evaluated from formulas; 'manual' = factors graded by a
  -- person (a value + comment supplied via the grading API). A model is wholly
  -- one or the other.
  scoring_mode TEXT NOT NULL DEFAULT 'computed',
  -- 'model' (base), 'composite', or 'super_composite' — see model_kind above. A
  -- composite/super_composite scores by weighting other models' totals (its
  -- factors take model:<version> inputs); a base model reads 990 fields.
  model_kind TEXT NOT NULL DEFAULT 'model' REFERENCES model_kind (code),
  -- Which org types this model scores: 'nonprofit' (990/990EZ/990N filers — i.e.
  -- everything that is NOT a 990-PF foundation), 'foundation' (990-PF filers), or
  -- 'both'. The batch scorer only applies a model to an org whose type matches, so
  -- foundations are scored separately from nonprofits.
  applies_to TEXT NOT NULL DEFAULT 'both',
  -- Default missing-data fallback for this model's factor inputs when a year is
  -- missing a value (a per-input `missing=` overrides it). NULL/'none' = no fill
  -- (the historical behavior). See scoring/models.md for the strategy set.
  missing_data TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS score_factor (
  factor_id INTEGER PRIMARY KEY AUTOINCREMENT,
  model_id INTEGER NOT NULL REFERENCES score_model (model_id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  weight REAL NOT NULL,
  formula_type TEXT NOT NULL DEFAULT 'ratio',
  inputs TEXT NOT NULL DEFAULT '[]',
  direction TEXT NOT NULL DEFAULT 'higher',
  benchmark_lo REAL NOT NULL DEFAULT 0.0,
  benchmark_hi REAL NOT NULL DEFAULT 1.0,
  -- For manual factors: how the grader's entered value maps to [0,1] —
  -- 'benchmark' (normalize via benchmark_lo/hi + direction, like computed),
  -- 'normalized' (value already in [0,1]), or 'percent' (0–100 ÷ 100).
  -- NULL for computed factors.
  manual_scale TEXT,
  formula_description TEXT,
  UNIQUE (model_id, name)
);

-- filing_id is the INTEGER filing.filing_id (rowid), consistent with
-- reported_data — not the 36-char uuid. ON DELETE CASCADE means a filing delete
-- removes its scores automatically (no manual delete-scores-first ordering). The
-- public uuid is recovered by joining filing for API responses.
CREATE TABLE IF NOT EXISTS organization_score (
  score_id INTEGER PRIMARY KEY AUTOINCREMENT,
  filing_id INTEGER NOT NULL REFERENCES filing (filing_id) ON DELETE CASCADE,
  model_id INTEGER NOT NULL REFERENCES score_model (model_id),
  total_score REAL,
  -- 1 when at least one of this score's factor inputs was filled from another
  -- year (a missing-data fallback). Real scores stay 0.
  imputed INTEGER NOT NULL DEFAULT 0,
  scored_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE (filing_id, model_id)
);

CREATE TABLE IF NOT EXISTS organization_score_factor (
  value_id INTEGER PRIMARY KEY AUTOINCREMENT,
  score_id INTEGER NOT NULL REFERENCES organization_score (score_id) ON DELETE CASCADE,
  factor_id INTEGER NOT NULL REFERENCES score_factor (factor_id),
  raw_value REAL,
  weighted_value REAL,
  comment TEXT,
  -- Missing-data provenance: imputed=1 if any of this factor's inputs were filled
  -- from another year; source_year is the donor year (NULL for a constant fill or
  -- when not imputed).
  imputed INTEGER NOT NULL DEFAULT 0,
  source_year INTEGER,
  UNIQUE (score_id, factor_id)
);

CREATE INDEX IF NOT EXISTS idx_org_score_filing ON organization_score (filing_id);

CREATE INDEX IF NOT EXISTS idx_org_score_model ON organization_score (model_id);

CREATE INDEX IF NOT EXISTS idx_score_factor_value_score ON organization_score_factor (score_id);
