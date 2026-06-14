-- Records which versioned SQL migrations (Migration/sql/migrations/*.sql) have
-- been applied, so each runs at most once.

CREATE TABLE IF NOT EXISTS migration (
  name       TEXT PRIMARY KEY,
  applied_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
