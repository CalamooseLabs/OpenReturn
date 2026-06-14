-- Tracks ZIP archives that have already been ingested so the URL-based ingest
-- path can skip work it has already done. ``source`` is the canonical id: the
-- download URL for remote archives. Recorded only after a ZIP finishes, so an
-- interrupted run re-does just the in-flight archive on the next pass.

CREATE TABLE IF NOT EXISTS ingested_zip (
  source         TEXT PRIMARY KEY,
  url            TEXT,
  filename       TEXT NOT NULL,
  etag           TEXT,
  last_modified  TEXT,
  content_length INTEGER,
  filings_stored INTEGER NOT NULL DEFAULT 0,
  ingested_at    DATETIME DEFAULT CURRENT_TIMESTAMP
);
