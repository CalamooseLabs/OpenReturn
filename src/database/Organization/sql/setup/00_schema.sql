-- Organizations and their supporting address / lookup tables.

CREATE TABLE IF NOT EXISTS state (code CHARACTER(2) PRIMARY KEY, name TEXT NOT NULL);

CREATE TABLE IF NOT EXISTS organization_type (code TEXT PRIMARY KEY, description TEXT);

-- Sector vocabulary for organizations (assignable; the 990 carries no sector code).
-- Seeded with the NTEE major groups (the ~26 first-letter categories); `parent_code`
-- lets a deployment later group them into custom higher-level buckets without a
-- schema change. Seeded in setup (INSERT OR IGNORE, every startup) so legacy DBs get
-- the vocabulary too (the model_type precedent).
CREATE TABLE IF NOT EXISTS sector (
  code        TEXT PRIMARY KEY,
  name        TEXT NOT NULL,
  parent_code TEXT REFERENCES sector (code)
);

INSERT OR IGNORE INTO sector (code, name) VALUES
  ('A', 'Arts, Culture & Humanities'),
  ('B', 'Education'),
  ('C', 'Environment'),
  ('D', 'Animal-Related'),
  ('E', 'Health Care'),
  ('F', 'Mental Health & Crisis Intervention'),
  ('G', 'Voluntary Health Associations & Medical Disciplines'),
  ('H', 'Medical Research'),
  ('I', 'Crime & Legal-Related'),
  ('J', 'Employment'),
  ('K', 'Food, Agriculture & Nutrition'),
  ('L', 'Housing & Shelter'),
  ('M', 'Public Safety, Disaster Preparedness & Relief'),
  ('N', 'Recreation & Sports'),
  ('O', 'Youth Development'),
  ('P', 'Human Services'),
  ('Q', 'International, Foreign Affairs & National Security'),
  ('R', 'Civil Rights, Social Action & Advocacy'),
  ('S', 'Community Improvement & Capacity Building'),
  ('T', 'Philanthropy, Voluntarism & Grantmaking Foundations'),
  ('U', 'Science & Technology'),
  ('V', 'Social Science'),
  ('W', 'Public & Societal Benefit'),
  ('X', 'Religion-Related'),
  ('Y', 'Mutual & Membership Benefit'),
  ('Z', 'Unknown');

-- ZIP -> county crosswalk (deduces county from the filer ZIP; the 990 has no county).
-- Ships EMPTY — populated by `openreturn counties import <HUD file>`. A multi-county
-- ZIP keeps a row per county, the dominant one (highest residential share) flagged.
CREATE TABLE IF NOT EXISTS zip_county (
  zipcode     TEXT NOT NULL,
  county_fips TEXT NOT NULL,
  county_name TEXT,
  state_code  CHARACTER(2),
  dominant    INTEGER NOT NULL DEFAULT 0,
  PRIMARY KEY (zipcode, county_fips)
);
CREATE INDEX IF NOT EXISTS idx_zip_county_zip ON zip_county (zipcode);

-- Filer mailing address (one per org, parsed from the return-header USAddress).
-- Normalized into its own table — the organization references it via
-- business_address_id. Columns are nullable so a partial address still stores;
-- state_code is a 2-letter USPS code (the `state` table is the canonical list
-- the state-search dropdown is drawn from). No state FK here: a malformed code
-- in a single filing must not fail an address insert (and orphan the org link)
-- during a multi-million-row bulk ingest.
-- Shared address store. The PK `uuid` is a deterministic OWNER key, not a
-- content hash: 'org:<ein>'-style for an org filer address (one per org) and
-- 'ap:<filing_id>:<group>:<occ>' for a party appearance (graph layer). Owner-keyed
-- (not content-deduped) so INSERT OR IGNORE re-ingest is idempotent without a
-- write-hot content index or false-merge hazard. US rows use street/city/
-- state_code/zipcode; FOREIGN rows use province/country_code/foreign_postal.
-- Legacy filer-address rows are keyed by the bare EIN (see upsert_organization /
-- the bulk flush) — still unique, still idempotent.
CREATE TABLE IF NOT EXISTS address (
  uuid CHARACTER(36) PRIMARY KEY,
  street TEXT,
  city TEXT,
  state_code CHARACTER(2),
  zipcode TEXT,
  address_kind TEXT,
  street2 TEXT,
  province TEXT,
  country_code TEXT,
  foreign_postal TEXT,
  -- County deduced from the ZIP (see zip_county); NULL until `counties import` runs.
  county_fips TEXT,
  county_name TEXT
);

-- business_address_id is the org's PHYSICAL address (uuid = the bare EIN, the
-- as-filed filer address); mailing_address_id is a second, editable address
-- (uuid = 'mail:<ein>'). website / main_email are user-editable contact fields;
-- created_by / updated_by record the actor label (full detail in audit_log).
CREATE TABLE IF NOT EXISTS organization (
  ein CHARACTER(10) PRIMARY KEY,
  name TEXT NOT NULL,
  business_address_id CHARACTER(36),
  mailing_address_id CHARACTER(36),
  website TEXT,
  main_email TEXT,
  is_favorite INTEGER NOT NULL DEFAULT 0,
  -- Derived classification (cached; refreshed by classify_organizations at ingest):
  -- 'foundation' (ever filed 990-PF), 'nonprofit' (990/990-EZ/990-N), 'other'
  -- (e.g. 990-T only), or NULL (unknown / no IRS form). is_grantmaker is orthogonal:
  -- 1 for ANY org that has grant_edge rows (incl. Schedule-I grantmaking charities).
  org_type TEXT,
  is_grantmaker INTEGER NOT NULL DEFAULT 0,
  -- Assignable sector (NTEE major group; see the sector table). NULL until set.
  sector_code TEXT REFERENCES sector (code),
  created_by TEXT,
  updated_by TEXT,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (business_address_id) REFERENCES address (uuid),
  FOREIGN KEY (mailing_address_id) REFERENCES address (uuid)
);

CREATE INDEX IF NOT EXISTS idx_organization_name ON organization (name);

CREATE INDEX IF NOT EXISTS idx_organization_favorite ON organization (is_favorite);
-- NOTE: idx_organization_org_type is created in OrganizationDatabase._migrate_schema,
-- not here — it must run AFTER the org_type column is ALTER-added to a legacy table.

CREATE INDEX IF NOT EXISTS idx_address_state ON address (state_code);

CREATE INDEX IF NOT EXISTS idx_address_city ON address (city);
