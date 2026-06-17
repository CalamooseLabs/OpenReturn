-- Org tags: a named label (`tag`) applied to organizations (`org_tag`). Tag
-- names are unique case-insensitively. Smart lists (Lists concern) resolve their
-- membership by joining org_tag.

CREATE TABLE IF NOT EXISTS tag (
  tag_id     INTEGER PRIMARY KEY AUTOINCREMENT,
  name       TEXT    NOT NULL UNIQUE COLLATE NOCASE,
  created_by TEXT,
  created_at TEXT    NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS org_tag (
  org_ein    CHARACTER(10) NOT NULL REFERENCES organization (ein) ON DELETE CASCADE,
  tag_id     INTEGER       NOT NULL REFERENCES tag (tag_id) ON DELETE CASCADE,
  created_by TEXT,
  created_at TEXT          NOT NULL DEFAULT (datetime('now')),
  PRIMARY KEY (org_ein, tag_id)
);

CREATE INDEX IF NOT EXISTS idx_org_tag_tag ON org_tag (tag_id);
