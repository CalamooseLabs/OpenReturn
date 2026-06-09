from pathlib import Path


class MigrationRepository:
  """Discovery and application of versioned SQL migrations.

  Migration files live in ``IRS990/sql/migrations/*.sql`` and are applied
  once each; the ``migration`` table (created in setup) records applied names.
  """

  @staticmethod
  def list_available_migrations() -> list[tuple[str, Path]]:
    """Returns [(name, path), ...] for all migration SQL files, sorted by name."""
    d = Path(__file__).parent.parent / "sql" / "migrations"
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
