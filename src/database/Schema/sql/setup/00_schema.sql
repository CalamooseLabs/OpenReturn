-- Form schema metadata: the form → part → section → line → field hierarchy that
-- describes every value the parser can extract, plus the data_type lookup.

CREATE TABLE IF NOT EXISTS data_type (code TEXT PRIMARY KEY, description TEXT);

CREATE TABLE IF NOT EXISTS form (
  code TEXT PRIMARY KEY,
  name TEXT NOT NULL UNIQUE,
  description TEXT,
  supported INTEGER NOT NULL DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS part (
  part_id INTEGER PRIMARY KEY AUTOINCREMENT,
  form_code TEXT NOT NULL REFERENCES form (code) ON DELETE CASCADE,
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

CREATE INDEX IF NOT EXISTS idx_part_form ON part (form_code);

CREATE INDEX IF NOT EXISTS idx_section_part ON section (part_id);

CREATE INDEX IF NOT EXISTS idx_line_section ON line (section_id);

CREATE INDEX IF NOT EXISTS idx_field_line ON field (line_id);

CREATE INDEX IF NOT EXISTS idx_field_xml_path ON field (xml_path);
