PRAGMA foreign_keys = ON;

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

CREATE TABLE IF NOT EXISTS score_model (
  model_id INTEGER PRIMARY KEY AUTOINCREMENT,
  version INTEGER NOT NULL UNIQUE,
  description TEXT,
  model_type TEXT REFERENCES model_type (code),
  -- 'computed' = factors evaluated from formulas; 'manual' = factors graded by a
  -- person (a value + comment supplied via the grading API). A model is wholly
  -- one or the other.
  scoring_mode TEXT NOT NULL DEFAULT 'computed',
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

CREATE TABLE IF NOT EXISTS organization_score (
  score_id INTEGER PRIMARY KEY AUTOINCREMENT,
  filing_id CHARACTER(36) NOT NULL REFERENCES filing (uuid),
  model_id INTEGER NOT NULL REFERENCES score_model (model_id),
  total_score REAL,
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
  UNIQUE (score_id, factor_id)
);

CREATE INDEX IF NOT EXISTS idx_org_score_filing ON organization_score (filing_id);

CREATE INDEX IF NOT EXISTS idx_org_score_model ON organization_score (model_id);

CREATE INDEX IF NOT EXISTS idx_score_factor_value_score ON organization_score_factor (score_id);
