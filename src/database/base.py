import sqlite3
from pathlib import Path

class Database:
  def __init__(self, name, sql_dir, populate_guard: str | None = None) -> None:
    self.name = name
    self.connection = sqlite3.connect(f"{name}.db")
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

  def _run_script(self, script: str, sql_dir: str):
    pdir = f"{sql_dir}/" if sql_dir != "" else ""

    base_path = Path(__file__).parent
    file_path = base_path / f"{pdir}{script}"

    with open(file_path, 'r') as sql_file:
      sql_script = sql_file.read()

    self.cursor.executescript(sql_script)
    self.connection.commit()
