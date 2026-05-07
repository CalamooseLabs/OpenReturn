import sqlite3

class Database:
  def __init__(self, name="IRS990") -> None:
    self.name = name
    self.connection = sqlite3.connect(f"{name}.db")
    self.cursor = self.connection.cursor()

    with open(f'./database/{name}/setup.sql', 'r') as sql_file:
      sql_script = sql_file.read()

    self.cursor.executescript(sql_script)
    self.connection.commit()
    self.cursor = self.connection.cursor()

  def close(self):
    if self.connection:
      self.connection.close()
