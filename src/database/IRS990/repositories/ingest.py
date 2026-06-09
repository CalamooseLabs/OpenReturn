class IngestRepository:
  """Records which source ZIP archives have already been ingested.

  The URL-based ingest path consults ``get_ingested_sources`` to skip archives
  it has already loaded, and calls ``record_ingested_zip`` once each archive
  finishes. The ``ingested_zip`` table is keyed on ``source`` — the canonical
  identifier of the archive (its download URL for remote ingests).
  """

  def get_ingested_sources(self) -> set[str]:
    return {row[0] for row in self.cursor.execute("SELECT source FROM ingested_zip").fetchall()}

  def record_ingested_zip(self, source: str, *, url: str | None = None,
                          filename: str = "", etag: str | None = None,
                          last_modified: str | None = None,
                          content_length: int | None = None,
                          filings_stored: int = 0) -> None:
    """Upsert the ingest record for ``source``. INSERT OR REPLACE so a forced
    re-ingest refreshes the stored metadata, counts, and timestamp."""
    self.cursor.execute(
      """
      INSERT OR REPLACE INTO ingested_zip
        (source, url, filename, etag, last_modified, content_length, filings_stored, ingested_at)
      VALUES (?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)
      """,
      (source, url, filename, etag, last_modified, content_length, filings_stored),
    )
    self.connection.commit()

  def list_ingested_zips(self) -> list[dict]:
    rows = self.cursor.execute(
      """
      SELECT source, url, filename, etag, last_modified, content_length, filings_stored, ingested_at
      FROM ingested_zip ORDER BY ingested_at, source
      """
    ).fetchall()
    return [
      {"source": r[0], "url": r[1], "filename": r[2], "etag": r[3],
       "last_modified": r[4], "content_length": r[5], "filings_stored": r[6],
       "ingested_at": r[7]}
      for r in rows
    ]
