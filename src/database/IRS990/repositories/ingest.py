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

  @staticmethod
  def _zip_row(r) -> dict:
    return {"source": r[0], "url": r[1], "filename": r[2], "etag": r[3],
            "last_modified": r[4], "content_length": r[5], "filings_stored": r[6],
            "ingested_at": r[7]}

  _ZIP_COLS = ("source, url, filename, etag, last_modified, "
               "content_length, filings_stored, ingested_at")

  def list_ingested_zips(self) -> list[dict]:
    rows = self.cursor.execute(
      f"SELECT {self._ZIP_COLS} FROM ingested_zip ORDER BY ingested_at, source"
    ).fetchall()
    return [self._zip_row(r) for r in rows]

  def count_ingested_zips(self) -> int:
    return self.cursor.execute("SELECT COUNT(*) FROM ingested_zip").fetchone()[0]

  def find_ingested_zips(self, pattern: str) -> list[dict]:
    """Records whose ``source`` or ``filename`` contains ``pattern`` (case-
    insensitive substring). Backs the ``--forget``/``--purge`` ingest flags so a
    user can target archives without typing a full download URL."""
    from database.base import escape_like
    like = f"%{escape_like(pattern)}%"
    rows = self.cursor.execute(
      f"SELECT {self._ZIP_COLS} FROM ingested_zip "
      "WHERE source LIKE ? ESCAPE '\\' OR filename LIKE ? ESCAPE '\\' "
      "ORDER BY ingested_at, source",
      (like, like),
    ).fetchall()
    return [self._zip_row(r) for r in rows]

  def forget_ingested_zips(self, sources: list[str]) -> int:
    """Delete the ``ingested_zip`` records for the given exact ``source`` values
    (the table's primary key) and return how many rows were removed. This drops
    only the 'already ingested' marker so the archive is re-ingested on the next
    URL run; the stored filing data is untouched (see purge for that)."""
    if not sources:
      return 0
    placeholders = ",".join("?" * len(sources))
    self.cursor.execute(
      f"DELETE FROM ingested_zip WHERE source IN ({placeholders})", sources
    )
    self.connection.commit()
    return self.cursor.rowcount

  def forget_all_ingested_zips(self) -> int:
    """Delete every ``ingested_zip`` record. Returns the number removed."""
    self.cursor.execute("DELETE FROM ingested_zip")
    self.connection.commit()
    return self.cursor.rowcount
