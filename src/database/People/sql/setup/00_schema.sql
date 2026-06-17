-- Editable people and their organization memberships (the user-managed CRM
-- layer). Distinct from the immutable as-filed 990 graph (party/party_appearance);
-- these are records users create and edit. org_person links a person to an
-- organization with a role/title and optional dates.

CREATE TABLE IF NOT EXISTS person (
  person_id  INTEGER PRIMARY KEY AUTOINCREMENT,
  full_name  TEXT    NOT NULL,
  email      TEXT,
  phone      TEXT,
  title      TEXT,
  notes      TEXT,
  created_by TEXT,
  created_at TEXT    NOT NULL DEFAULT (datetime('now')),
  updated_by TEXT,
  updated_at TEXT    NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS org_person (
  membership_id INTEGER PRIMARY KEY AUTOINCREMENT,
  person_id  INTEGER       NOT NULL REFERENCES person (person_id) ON DELETE CASCADE,
  org_ein    CHARACTER(10) NOT NULL REFERENCES organization (ein) ON DELETE CASCADE,
  role_title TEXT,
  is_primary INTEGER NOT NULL DEFAULT 0,
  start_date TEXT,
  end_date   TEXT,
  created_by TEXT,
  created_at TEXT    NOT NULL DEFAULT (datetime('now')),
  UNIQUE (person_id, org_ein)
);

CREATE INDEX IF NOT EXISTS idx_org_person_org    ON org_person (org_ein);
CREATE INDEX IF NOT EXISTS idx_org_person_person ON org_person (person_id);
