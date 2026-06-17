-- Append-only audit trail: who changed what, when. A standalone concern (no hard
-- FKs — the actor may be a user, an API-key program, or the CLI, and the entity
-- id is a natural key such as an EIN). changes is an optional JSON summary.

CREATE TABLE IF NOT EXISTS audit_log (
  log_id      INTEGER PRIMARY KEY AUTOINCREMENT,
  actor_kind  TEXT    NOT NULL,            -- 'user' | 'program' | 'cli'
  actor_id    INTEGER,                     -- user_id / key_id / NULL (cli)
  actor_label TEXT,                        -- username / key name / os user
  action      TEXT    NOT NULL,            -- 'create' | 'update' | 'delete'
  entity_type TEXT    NOT NULL,            -- 'organization' | 'person' | 'org_person' | 'tag' | 'list' | ...
  entity_id   TEXT,                        -- natural id (ein, person_id, list_id, ...)
  changes     TEXT,                        -- optional JSON (e.g. changed fields)
  created_at  TEXT    NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_audit_entity ON audit_log (entity_type, entity_id);
CREATE INDEX IF NOT EXISTS idx_audit_actor  ON audit_log (actor_kind, actor_id);
CREATE INDEX IF NOT EXISTS idx_audit_time   ON audit_log (created_at);
