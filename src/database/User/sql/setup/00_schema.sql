-- User accounts, roles, permissions, and login sessions.
--
-- RBAC is permission-based: a role grants a set of permission codes; a user (or
-- an API key) holds roles; a route requires a permission code. user->role and
-- role->permission are editable at runtime (CLI). Table is `app_user`, not
-- `user`, to avoid SQL-keyword friction.

CREATE TABLE IF NOT EXISTS app_user (
  user_id       INTEGER PRIMARY KEY AUTOINCREMENT,
  username      TEXT    NOT NULL UNIQUE,
  password_hash TEXT    NOT NULL,           -- encoded scrypt (see src/auth.py)
  is_active     INTEGER NOT NULL DEFAULT 1,
  created_at    TEXT    NOT NULL DEFAULT (datetime('now')),
  updated_at    TEXT    NOT NULL DEFAULT (datetime('now')),
  last_login_at TEXT
);

CREATE TABLE IF NOT EXISTS role (
  role_id     INTEGER PRIMARY KEY AUTOINCREMENT,
  code        TEXT    NOT NULL UNIQUE,
  name        TEXT    NOT NULL,
  description TEXT,
  is_builtin  INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS permission (
  permission_id INTEGER PRIMARY KEY AUTOINCREMENT,
  code          TEXT    NOT NULL UNIQUE,     -- e.g. 'org:write'
  description   TEXT
);

CREATE TABLE IF NOT EXISTS role_permission (
  role_id       INTEGER NOT NULL REFERENCES role (role_id) ON DELETE CASCADE,
  permission_id INTEGER NOT NULL REFERENCES permission (permission_id) ON DELETE CASCADE,
  PRIMARY KEY (role_id, permission_id)
);

CREATE TABLE IF NOT EXISTS user_role (
  user_id INTEGER NOT NULL REFERENCES app_user (user_id) ON DELETE CASCADE,
  role_id INTEGER NOT NULL REFERENCES role (role_id) ON DELETE CASCADE,
  PRIMARY KEY (user_id, role_id)
);

-- session_id is the sha256 of the raw session token (the raw token is shown to
-- the client once and never stored). expires_at is an absolute timestamp.
CREATE TABLE IF NOT EXISTS session (
  session_id   TEXT    PRIMARY KEY,
  user_id      INTEGER NOT NULL REFERENCES app_user (user_id) ON DELETE CASCADE,
  created_at   TEXT    NOT NULL DEFAULT (datetime('now')),
  expires_at   TEXT    NOT NULL,
  last_used_at TEXT
);

CREATE INDEX IF NOT EXISTS idx_session_user ON session (user_id);
