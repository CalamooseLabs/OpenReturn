-- Shared record of gifts the team gave TO an organization (reached as ``db.giving``).
-- This is hand-entered "giving data" (a gift we made), distinct from the grant
-- graph parsed from 990 filings: it captures the relationship "we gave them $X in
-- year Y". Team-wide (every user sees it); each gift records who entered it and
-- when. The org side cascades; the author side SETs NULL on user deletion.

CREATE TABLE IF NOT EXISTS giving (
  gift_id            INTEGER PRIMARY KEY AUTOINCREMENT,
  org_ein            CHARACTER(10) NOT NULL REFERENCES organization (ein) ON DELETE CASCADE,
  amount             REAL NOT NULL,
  fiscal_year        INTEGER,
  gift_date          TEXT,
  purpose            TEXT,
  created_by_user_id INTEGER REFERENCES app_user (user_id) ON DELETE SET NULL,
  created_by_label   TEXT,
  created_at         TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_giving_org ON giving (org_ein, fiscal_year);
