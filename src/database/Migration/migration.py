from pathlib import Path

from database.base import Database


class MigrationDatabase(Database):
  """Discovery and application of versioned SQL migrations (reached as
  ``db.migrations``).

  A ``Database`` subclass sharing the coordinator's connection. Migration files
  live in ``Migration/sql/migrations/*.sql`` and are applied once each; the
  ``migration`` table records applied names. ``list_available_migrations`` stays
  a staticmethod so callers (e.g. status) can list migrations without opening
  the database.
  """

  def __init__(self, db) -> None:
    self._db = db
    super().__init__("Migration", "Migration", connection=db.connection, cursor=db.cursor)

  @staticmethod
  def list_available_migrations() -> list[tuple[str, Path]]:
    """Returns [(name, path), ...] for all migration SQL files, sorted by name."""
    d = Path(__file__).parent / "sql" / "migrations"
    if not d.exists():
      return []
    return sorted(
      [(p.stem, p) for p in d.glob("*.sql")],
      key=lambda x: x[0],
    )

  def get_applied_migrations(self) -> set[str]:
    return {row[0] for row in self.cursor.execute("SELECT name FROM migration").fetchall()}

  def apply_migration(self, name: str, sql: str) -> None:
    self.cursor.executescript(sql)
    self.cursor.execute(
      "INSERT OR IGNORE INTO migration (name) VALUES (?)", (name,)
    )
    self.connection.commit()
