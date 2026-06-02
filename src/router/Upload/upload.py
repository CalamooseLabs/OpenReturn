import zipfile
import io
from typing import Any
from http.client import HTTPMessage
from pathlib import Path

from router import Router
from database.IRS990 import IRS990Database
from parser.IRS990 import IRS990Parser


class UploadRouter(Router):
  _EIN_PATH   = "ReturnHeader/Filer/EIN"
  _NAME_PATH  = "ReturnHeader/Filer/BusinessName/BusinessNameLine1Txt"
  _YEAR_PATH  = "ReturnHeader/TaxYr"
  _FORM_PATH  = "ReturnHeader/ReturnTypeCd"

  def __init__(self, prefix: str = '/upload', db: IRS990Database = None):
    base_path = Path(__file__).parent
    super().__init__(prefix, str(base_path / "views"))
    self.db = db
    self.xpath_index = db.get_xpath_index()
    self._register_routes()

  def _process_xml(self, xml_content: str, filename: str) -> dict:
    parser = IRS990Parser(xml_content)

    ein       = parser.getElem(self._EIN_PATH)
    name      = parser.getElem(self._NAME_PATH)
    year      = parser.getElem(self._YEAR_PATH)
    form_code = parser.getElem(self._FORM_PATH)

    if not all([ein, name, year, form_code]):
      missing = [k for k, v in {"EIN": ein, "name": name, "year": year, "form": form_code}.items() if not v]
      return {"file": filename, "status": "error", "reason": f"missing header fields: {missing}"}

    self.db.upsert_organization(ein, name)
    filing_id = self.db.create_filing(ein, int(year), form_code)

    values: dict[int, str] = {}
    for xpath, field_id in self.xpath_index.items():
      value = parser.getElem(xpath)
      if value is not None:
        values[field_id] = value

    self.db.store_reported_data(filing_id, values)

    return {
      "file": filename,
      "status": "stored",
      "filing_id": filing_id,
      "ein": ein,
      "year": year,
      "form": form_code,
      "fields_stored": len(values),
    }

  def _register_routes(self):
    @self.get('')
    def upload_form(query_params: dict[str, list[str]], body: Any, headers: HTTPMessage):
      return self.render_template('upload.html', prefix=self.prefix)

    @self.post('')
    def handle_upload(query_params: dict[str, list[str]], body: Any, headers: HTTPMessage):
      if not isinstance(body, bytes):
        return {"error": "Invalid upload"}

      content_type = headers.get('Content-Type', '')
      if 'multipart/form-data' not in content_type:
        return {"error": "Expected multipart/form-data"}

      boundary = content_type.split('boundary=')[1].encode()
      parts = body.split(b'--' + boundary)

      for part in parts:
        if b'filename=' not in part or b'.zip' not in part:
          continue

        header_end = part.find(b'\r\n\r\n')
        if header_end == -1:
          continue

        file_data = part[header_end + 4:]
        if file_data.endswith(b'\r\n'):
          file_data = file_data[:-2]

        try:
          with zipfile.ZipFile(io.BytesIO(file_data), 'r') as zf:
            results = []
            for name in zf.namelist():
              if name.endswith('/') or not name.endswith('.xml'):
                continue
              with zf.open(name) as f:
                try:
                  results.append(self._process_xml(f.read().decode('utf-8'), name))
                except Exception as e:
                  results.append({"file": name, "status": "error", "reason": str(e)})

            stored = sum(1 for r in results if r.get("status") == "stored")
            errors = sum(1 for r in results if r.get("status") == "error")
            return {"status": "complete", "stored": stored, "errors": errors, "results": results}

        except zipfile.BadZipFile:
          return {"error": "Invalid ZIP file"}

      return {"error": "No ZIP file found in upload"}
