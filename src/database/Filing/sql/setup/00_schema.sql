-- A single Form 990 filing. The integer filing_id (rowid) is the internal key
-- that reported_data references; filing.uuid is the public / API identifier.

CREATE TABLE IF NOT EXISTS filing (
  filing_id INTEGER PRIMARY KEY,
  uuid CHARACTER(36) NOT NULL UNIQUE,
  year SMALLINT NOT NULL,
  organization_id CHARACTER(10),
  form_code TEXT NOT NULL REFERENCES form (code),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  object_id TEXT UNIQUE,
  xml_source_url TEXT,
  xml_filename TEXT,
  zip_filename TEXT,
  FOREIGN KEY (organization_id) REFERENCES organization (ein),
  UNIQUE (organization_id, year, form_code)
);

CREATE INDEX IF NOT EXISTS idx_filing_org ON filing (organization_id);
