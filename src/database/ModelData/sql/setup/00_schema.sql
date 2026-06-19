-- Per-(org, model, year) annotations a steward adds on the org profile (reached
-- as ``db.model_data``): free-form NOTES and arbitrary custom DATA FIELDS scoped
-- to a specific scoring model + fiscal year. These complement (a) the org-level
-- Updates feed (org_note), (b) the financial concept values that drive computed
-- scores (financial_observation), and (c) manual factor grades (organization_score_factor).
-- model_version is a soft TEXT ref to score_model.version (a model may be archived;
-- no FK). The org side cascades; the author side SETs NULL on user deletion.

CREATE TABLE IF NOT EXISTS model_year_note (
  note_id        INTEGER PRIMARY KEY AUTOINCREMENT,
  org_ein        CHARACTER(10) NOT NULL REFERENCES organization (ein) ON DELETE CASCADE,
  model_version  TEXT NOT NULL,
  fiscal_year    INTEGER NOT NULL,
  body           TEXT NOT NULL,
  author_user_id INTEGER REFERENCES app_user (user_id) ON DELETE SET NULL,
  author_label   TEXT,
  created_at     TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_model_year_note
  ON model_year_note (org_ein, model_version, fiscal_year);

CREATE TABLE IF NOT EXISTS model_year_field (
  field_id           INTEGER PRIMARY KEY AUTOINCREMENT,
  org_ein            CHARACTER(10) NOT NULL REFERENCES organization (ein) ON DELETE CASCADE,
  model_version      TEXT NOT NULL,
  fiscal_year        INTEGER NOT NULL,
  label              TEXT NOT NULL,
  value              TEXT,
  created_by_user_id INTEGER REFERENCES app_user (user_id) ON DELETE SET NULL,
  created_by_label   TEXT,
  created_at         TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_model_year_field
  ON model_year_field (org_ein, model_version, fiscal_year);
