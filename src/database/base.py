import sqlite3
from pathlib import Path

class Database:
  def __init__(self, name, sql_dir, populate_guard: str | None = None, path: str | None = None) -> None:
    self.name = name
    self.connection = sqlite3.connect(path if path is not None else f"{name}.db")
    self.cursor = self.connection.cursor()

    self._run_script("setup.sql", sql_dir)
    if populate_guard is None or not self._table_has_rows(populate_guard):
      self._run_script("populate.sql", sql_dir)

  def _table_has_rows(self, table: str) -> bool:
    return self.cursor.execute(
      f"SELECT 1 FROM {table} LIMIT 1"
    ).fetchone() is not None

  def close(self):
    if self.cursor:
      self.cursor.close()
    if self.connection:
      self.connection.close()

  def _run_script(self, script: str, sql_dir: str) -> None:
    file_path = Path(__file__).parent / sql_dir / script
    self.cursor.executescript(file_path.read_text())
    self.connection.commit()
