-- Lists of organizations. A list is either:
--   kind='static' — explicit membership in org_list_member; or
--   kind='smart'  — membership computed from `definition` (JSON, e.g.
--                   {"tags": ["prospect"], "match": "any"}) by joining org_tag.
-- visibility='private' (only the owner may read/edit) or 'public' (any reader).
-- owner_user_id is the creating user (NULL for a program-created public list).

CREATE TABLE IF NOT EXISTS org_list (
  list_id       INTEGER PRIMARY KEY AUTOINCREMENT,
  name          TEXT    NOT NULL,
  -- ON DELETE SET NULL (not CASCADE): hard-deleting a user converts their lists
  -- into program/system-owned (NULL owner) rather than vaporizing shared lists.
  owner_user_id INTEGER REFERENCES app_user (user_id) ON DELETE SET NULL,
  visibility    TEXT    NOT NULL DEFAULT 'private',
  kind          TEXT    NOT NULL DEFAULT 'static',
  definition    TEXT,
  created_by    TEXT,
  created_at    TEXT    NOT NULL DEFAULT (datetime('now')),
  updated_at    TEXT    NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS org_list_member (
  list_id  INTEGER       NOT NULL REFERENCES org_list (list_id) ON DELETE CASCADE,
  org_ein  CHARACTER(10) NOT NULL REFERENCES organization (ein) ON DELETE CASCADE,
  added_by TEXT,
  added_at TEXT          NOT NULL DEFAULT (datetime('now')),
  PRIMARY KEY (list_id, org_ein)
);

CREATE INDEX IF NOT EXISTS idx_org_list_owner ON org_list (owner_user_id);
