-- Per-user follow / watchlist: a user (app_user) tracks an organization. A
-- first-class watchlist (distinct from Lists) so "following" is a simple per-user
-- flag on an org and grant-activity alerts can hang off it later. Both sides
-- cascade so deleting a user or org cleans up its follows.

CREATE TABLE IF NOT EXISTS follow (
  user_id     INTEGER       NOT NULL REFERENCES app_user (user_id) ON DELETE CASCADE,
  org_ein     CHARACTER(10) NOT NULL REFERENCES organization (ein) ON DELETE CASCADE,
  followed_by TEXT,
  followed_at TEXT          NOT NULL DEFAULT (datetime('now')),
  PRIMARY KEY (user_id, org_ein)
);

CREATE INDEX IF NOT EXISTS idx_follow_org ON follow (org_ein);
