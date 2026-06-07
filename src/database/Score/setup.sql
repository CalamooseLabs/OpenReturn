PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS score_model (
  model_id INTEGER PRIMARY KEY AUTOINCREMENT,
  version INTEGER NOT NULL UNIQUE,
  description TEXT,
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
  UNIQUE (score_id, factor_id)
);

CREATE INDEX IF NOT EXISTS idx_org_score_filing ON organization_score (filing_id);

CREATE INDEX IF NOT EXISTS idx_org_score_model ON organization_score (model_id);

CREATE INDEX IF NOT EXISTS idx_score_factor_value_score ON organization_score_factor (score_id);
