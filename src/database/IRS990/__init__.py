import sqlite3
from database import Database

class IRS990Database(Database):
  def __init__(self, name="IRS990") -> None:
    super().__init__(name, "IRS990")

  def get_xpath_index(self) -> dict[str, int]:
    res = self.cursor.execute(
      "SELECT xml_path, field_id FROM field WHERE xml_path IS NOT NULL"
    )
    return {row[0]: row[1] for row in res.fetchall()}

  def create_filing(self, ein: str):
    pass

  # {
  #   "name": "EIN",
  #   "dbcolumn": "ein",
  #   "path": "ReturnHeader/Filer/EIN",
  #   "tablename": "organization"
  # },
  # {
  #   "name": "Business Name",
  #   "dbcolumn": "name",
  #   "path": "ReturnHeader/Filer/BusinessName/BusinessNameLine1Txt",
  #   "tablename": "organization"
  # },
  # {
  #   "name": "Tax Year",
  #   "dbcolumn": "year",
  #   "path": "ReturnHeader/TaxYr",
  #   "tablename": "tax_return"
  # },
  # {
  #   "name": "Return Type",
  #   "dbcolumn": "code",
  #   "path": "ReturnHeader/ReturnTypeCd",
  #   "tablename": "form_type"
  # },
