import sqlite3
from pathlib import Path

class Database:
  def __init__(self, name="IRS990") -> None:
    self.name = name
    self.connection = sqlite3.connect(f"{name}.db")
    self.cursor = self.connection.cursor()

    base_path = Path(__file__).parent
    file_path = base_path / f"{name}/setup.sql"

    with open(file_path, 'r') as sql_file:
      sql_script = sql_file.read()

    self.cursor.executescript(sql_script)
    self.connection.commit()
    self.cursor = self.connection.cursor()

  def close(self):
    if self.connection:
      self.connection.close()
