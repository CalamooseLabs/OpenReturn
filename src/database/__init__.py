import sqlite3
from pathlib import Path

class Database:
  def __init__(self, name, dir) -> None:
    self.name = name
    self.connection = sqlite3.connect(f"{name}.db")
    self.cursor = self.connection.cursor()

    self.__run_script("setup.sql", dir)
    self.__run_script("populate.sql", dir)
    self.cursor = self.connection.cursor()

  def close(self):
    if self.cursor:
      self.cursor.close()
    if self.connection:
      self.connection.close()

  def __run_script(self, script: str, dir: str):
    pdir = f"{dir}/" if dir != "" else ""

    base_path = Path(__file__).parent
    file_path = base_path / f"{pdir}{script}"
    sql_script = ""

    with open(file_path, 'r') as sql_file:
      sql_script = sql_file.read()

    self.cursor.executescript(sql_script)
    self.connection.commit()
