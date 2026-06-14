-- Organizations and their supporting address / lookup tables.

CREATE TABLE IF NOT EXISTS state (code CHARACTER(2) PRIMARY KEY, name TEXT NOT NULL);

CREATE TABLE IF NOT EXISTS organization_type (code TEXT PRIMARY KEY, description TEXT);

-- Filer mailing address (one per org, parsed from the return-header USAddress).
-- Normalized into its own table — the organization references it via
-- business_address_id. Columns are nullable so a partial address still stores;
-- state_code is a 2-letter USPS code (the `state` table is the canonical list
-- the state-search dropdown is drawn from). No state FK here: a malformed code
-- in a single filing must not fail an address insert (and orphan the org link)
-- during a multi-million-row bulk ingest.
CREATE TABLE IF NOT EXISTS address (
  uuid CHARACTER(36) PRIMARY KEY,
  street TEXT,
  city TEXT,
  state_code CHARACTER(2),
  zipcode TEXT
);

CREATE TABLE IF NOT EXISTS organization (
  ein CHARACTER(10) PRIMARY KEY,
  name TEXT NOT NULL,
  business_address_id CHARACTER(36),
  is_favorite INTEGER NOT NULL DEFAULT 0,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (business_address_id) REFERENCES address (uuid)
);

CREATE INDEX IF NOT EXISTS idx_organization_name ON organization (name);

CREATE INDEX IF NOT EXISTS idx_organization_favorite ON organization (is_favorite);

CREATE INDEX IF NOT EXISTS idx_address_state ON address (state_code);

CREATE INDEX IF NOT EXISTS idx_address_city ON address (city);
