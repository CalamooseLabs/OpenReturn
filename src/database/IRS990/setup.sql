PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS organization (
  ein CHARACTER(10) PRIMARY KEY,
  name TEXT NOT NULL,
  business_address_id CHARACTER(36),
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (business_address_id) REFERENCES address (uuid)
);

CREATE TABLE IF NOT EXISTS address (
  uuid CHARACTER(36) PRIMARY KEY,
  street TEXT NOT NULL,
  city TEXT NOT NULL,
  state_code CHARACTER(2) NOT NULL,
  zipcode CHARACTER(5) NOT NULL,
  FOREIGN KEY (state_code) REFERENCES state (code)
);

DROP TABLE IF EXISTS state;

CREATE TABLE state (code CHARACTER(2) PRIMARY KEY, name TEXT NOT NULL);

CREATE TABLE IF NOT EXISTS organization_type (code TEXT PRIMARY KEY, description TEXT);

CREATE TABLE IF NOT EXISTS data_type (code TEXT PRIMARY KEY, description TEXT);

CREATE TABLE IF NOT EXISTS form (
  code TEXT PRIMARY KEY,
  name TEXT NOT NULL UNIQUE,
  description TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS part (
  part_id INTEGER PRIMARY KEY AUTOINCREMENT,
  form_code INTEGER NOT NULL REFERENCES form (code) ON DELETE CASCADE,
  part_number TEXT NOT NULL,
  part_name TEXT NOT NULL,
  UNIQUE (form_code, part_number)
);

CREATE TABLE IF NOT EXISTS section (
  section_id INTEGER PRIMARY KEY AUTOINCREMENT,
  part_id INTEGER NOT NULL REFERENCES part (part_id) ON DELETE CASCADE,
  section_code TEXT NOT NULL DEFAULT 'NONE',
  section_name TEXT,
  UNIQUE (part_id, section_code)
);

CREATE TABLE IF NOT EXISTS line (
  line_id INTEGER PRIMARY KEY AUTOINCREMENT,
  section_id INTEGER NOT NULL REFERENCES section (section_id) ON DELETE CASCADE,
  line_number TEXT NOT NULL,
  line_label TEXT,
  data_type TEXT REFERENCES data_type (code),
  UNIQUE (section_id, line_number)
);

CREATE TABLE IF NOT EXISTS field (
  field_id INTEGER PRIMARY KEY AUTOINCREMENT,
  line_id INTEGER NOT NULL REFERENCES line (line_id) ON DELETE CASCADE,
  sub_letter TEXT,
  column_code TEXT,
  box_label TEXT,
  data_type TEXT REFERENCES data_type (code),
  xml_path TEXT,
  UNIQUE (line_id, sub_letter, column_code)
);

CREATE TABLE IF NOT EXISTS filing (
  uuid CHARACTER(36) PRIMARY KEY,
  year SMALLINT NOT NULL,
  organization_id CHARACTER(10),
  form_code INTEGER NOT NULL REFERENCES form (code),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  object_id TEXT UNIQUE,
  xml_source_url TEXT,
  FOREIGN KEY (organization_id) REFERENCES organization (ein)
);

CREATE TABLE IF NOT EXISTS reported_data (
  value_id INTEGER PRIMARY KEY AUTOINCREMENT,
  filing_id CHARACTER(36) NOT NULL REFERENCES filing (uuid) ON DELETE CASCADE,
  field_id INTEGER NOT NULL REFERENCES field (field_id),
  raw_value TEXT,
  UNIQUE (filing_id, field_id)
);

CREATE INDEX IF NOT EXISTS idx_part_form ON part (form_code);

CREATE INDEX IF NOT EXISTS idx_section_part ON section (part_id);

CREATE INDEX IF NOT EXISTS idx_line_section ON line (section_id);

CREATE INDEX IF NOT EXISTS idx_field_line ON field (line_id);

CREATE INDEX IF NOT EXISTS idx_field_xml_path ON field (xml_path);

CREATE INDEX IF NOT EXISTS idx_reported_data_filing ON reported_data (filing_id);

CREATE INDEX IF NOT EXISTS idx_reported_data_field ON reported_data (field_id);
