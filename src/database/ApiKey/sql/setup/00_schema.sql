-- API keys for authenticating *programs* (e.g. the frontend). rate_limit -1
-- means unlimited. role_id grants the key a (typically restricted) role from the
-- User concern's RBAC tables; NULL is treated as the built-in 'service' role.
-- The User concern is instantiated before ApiKey so the `role` FK target exists.

CREATE TABLE IF NOT EXISTS api_key (
    key_id       INTEGER PRIMARY KEY AUTOINCREMENT,
    name         TEXT    NOT NULL,
    key_hash     TEXT    NOT NULL UNIQUE,
    created_at   TEXT    NOT NULL DEFAULT (datetime('now')),
    last_used_at TEXT,
    active       INTEGER NOT NULL DEFAULT 1,
    rate_limit   INTEGER NOT NULL DEFAULT -1,
    role_id      INTEGER REFERENCES role (role_id)
);
