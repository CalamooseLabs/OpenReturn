-- Shared, team-wide notes / updates on an organization (reached as ``db.notes``).
-- Unlike per-user follows, every logged-in user sees the same feed; each note
-- records who posted it (author_label + author_user_id) and when. The org side
-- cascades so deleting an org cleans up its notes; the author side SETs NULL so a
-- deleted user account leaves the note (with its preserved author_label) intact.

CREATE TABLE IF NOT EXISTS org_note (
  note_id        INTEGER PRIMARY KEY AUTOINCREMENT,
  org_ein        CHARACTER(10) NOT NULL REFERENCES organization (ein) ON DELETE CASCADE,
  body           TEXT NOT NULL,
  author_user_id INTEGER REFERENCES app_user (user_id) ON DELETE SET NULL,
  author_label   TEXT,
  created_at     TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_org_note_org ON org_note (org_ein, created_at);
