CREATE TABLE IF NOT EXISTS api_key (
    key_id       INTEGER PRIMARY KEY AUTOINCREMENT,
    name         TEXT    NOT NULL,
    key_hash     TEXT    NOT NULL UNIQUE,
    created_at   TEXT    NOT NULL DEFAULT (datetime('now')),
    last_used_at TEXT,
    active       INTEGER NOT NULL DEFAULT 1,
    rate_limit   INTEGER NOT NULL DEFAULT -1
);
