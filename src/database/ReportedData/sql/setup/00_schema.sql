-- Per-filing extracted field values. By far the largest table (~190M rows at
-- full corpus): reported_data.filing_id references the filing's INTEGER rowid,
-- not its 36-char uuid, so each row carries an 8-byte FK instead — which shrinks
-- the DB and speeds inserts and the index rebuild.

CREATE TABLE IF NOT EXISTS reported_data (
  value_id INTEGER PRIMARY KEY AUTOINCREMENT,
  filing_id INTEGER NOT NULL REFERENCES filing (filing_id) ON DELETE CASCADE,
  field_id INTEGER NOT NULL REFERENCES field (field_id),
  raw_value TEXT,
  UNIQUE (filing_id, field_id)
);

CREATE INDEX IF NOT EXISTS idx_reported_data_filing ON reported_data (filing_id);

CREATE INDEX IF NOT EXISTS idx_reported_data_field ON reported_data (field_id);
