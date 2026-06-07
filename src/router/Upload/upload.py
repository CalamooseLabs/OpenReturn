import io
import os
import subprocess
import zipfile
from concurrent.futures import ProcessPoolExecutor, as_completed
from typing import Any
from http.client import HTTPMessage
from pathlib import Path

from router import Router
from database.IRS990 import IRS990Database
from parser.IRS990 import IRS990Parser

# ---------------------------------------------------------------------------
# Module-level worker state — set once per worker process via _worker_init.
# These must be module-level (not class attributes) for pickling.
# ---------------------------------------------------------------------------

_xpath_index:     dict[str, int] = {}
_supported_forms: set[str]       = set()
_zip_cache:       dict[str, zipfile.ZipFile] = {}

_EIN_PATH  = "ReturnHeader/Filer/EIN"
_NAME_PATH = "ReturnHeader/Filer/BusinessName/BusinessNameLine1Txt"
_YEAR_PATH = "ReturnHeader/TaxYr"
_FORM_PATH = "ReturnHeader/ReturnTypeCd"


def _worker_init(xpath_index: dict, supported_forms: set) -> None:
  global _xpath_index, _supported_forms
  _xpath_index     = xpath_index
  _supported_forms = supported_forms


def _parse_xml_task(task: tuple) -> dict:
  """Parse a single XML filing. No DB access. Designed to run in worker processes."""
  zip_path_str, filename, zip_filename = task
  try:
    if zip_path_str not in _zip_cache:
      _zip_cache[zip_path_str] = zipfile.ZipFile(zip_path_str, 'r')
    try:
      xml_bytes = _zip_cache[zip_path_str].read(filename)
    except NotImplementedError:
      proc = subprocess.run(
        ['unzip', '-p', '--', zip_path_str, filename], capture_output=True
      )
      xml_bytes = proc.stdout
    parser    = IRS990Parser(xml_bytes.decode('utf-8'))
    ein       = parser.getElem(_EIN_PATH)
    name      = parser.getElem(_NAME_PATH)
    year      = parser.getElem(_YEAR_PATH)
    form_code = parser.getElem(_FORM_PATH)

    if not all([ein, name, year, form_code]):
      missing = [k for k, v in {"EIN": ein, "name": name, "year": year, "form": form_code}.items() if not v]
      return {"file": filename, "zip_filename": zip_filename,
              "status": "error", "reason": f"missing header fields: {missing}"}

    if form_code not in _supported_forms:
      return {"file": filename, "zip_filename": zip_filename,
              "status": "skipped", "reason": f"unsupported form type: {form_code}"}

    values: dict[int, str] = {}
    for xpath, field_id in _xpath_index.items():
      value = parser.getElem(xpath)
      if value is not None:
        values[field_id] = value

    return {
      "file":         filename,
      "zip_filename": zip_filename,
      "status":       "parsed",
      "ein":          ein,
      "name":         name,
      "year":         int(year),
      "form_code":    form_code,
      "values":       values,
    }
  except Exception as exc:
    return {"file": filename, "zip_filename": zip_filename,
            "status": "error", "reason": str(exc)}


# ---------------------------------------------------------------------------
# Router
# ---------------------------------------------------------------------------

class UploadRouter(Router):

  _BATCH_SIZE = 1000
  _CHUNK      = 8    # in-flight tasks per worker slot

  def __init__(self, prefix: str = '/upload', db: IRS990Database = None,
               secure_by_default: bool = False, workers: int | None = None):
    base_path = Path(__file__).parent
    super().__init__(prefix, str(base_path / "views"), secure_by_default=secure_by_default)
    self.db      = db
    self.workers = workers if workers is not None else (os.cpu_count() or 4)
    self.xpath_index    = db.get_xpath_index()
    self.supported_forms = db.get_supported_forms()
    self._register_routes()

  def _process_xml(self, xml_content: str, filename: str, zip_filename: str | None = None) -> dict:
    """Process a single XML filing (parse + DB write). Used by the HTTP upload endpoint."""
    parser = IRS990Parser(xml_content)

    ein       = parser.getElem(_EIN_PATH)
    name      = parser.getElem(_NAME_PATH)
    year      = parser.getElem(_YEAR_PATH)
    form_code = parser.getElem(_FORM_PATH)

    if not all([ein, name, year, form_code]):
      missing = [k for k, v in {"EIN": ein, "name": name, "year": year, "form": form_code}.items() if not v]
      return {"file": filename, "status": "error", "reason": f"missing header fields: {missing}"}

    if form_code not in self.supported_forms:
      return {"file": filename, "status": "skipped", "reason": f"unsupported form type: {form_code}"}

    self.db.upsert_organization(ein, name)
    filing_id = self.db.create_filing(ein, int(year), form_code,
                                      xml_filename=filename, zip_filename=zip_filename)

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

  def _store_parsed(self, parsed: dict, results: list) -> str:
    """Write a parsed filing dict to the DB and append to results. Returns status."""
    self.db.upsert_organization(parsed["ein"], parsed["name"])
    filing_id = self.db.create_filing(
      parsed["ein"], parsed["year"], parsed["form_code"],
      xml_filename=parsed["file"], zip_filename=parsed["zip_filename"],
    )
    self.db.store_reported_data(filing_id, parsed["values"])
    results.append({
      "file":          parsed["file"],
      "status":        "stored",
      "filing_id":     filing_id,
      "ein":           parsed["ein"],
      "year":          str(parsed["year"]),
      "form":          parsed["form_code"],
      "fields_stored": len(parsed["values"]),
    })
    return "stored"

  def process_zip_dir(self, dir_path: Path) -> list[dict]:
    results   = []
    zips      = sorted(dir_path.glob('*.zip'))
    chunk_sz  = self.workers * self._CHUNK

    with ProcessPoolExecutor(
      max_workers=self.workers,
      initializer=_worker_init,
      initargs=(self.xpath_index, self.supported_forms),
    ) as pool:
      for zip_idx, zip_path in enumerate(zips, 1):
        try:
          with zipfile.ZipFile(zip_path, 'r') as zf:
            xml_names = [n for n in zf.namelist() if not n.endswith('/') and n.endswith('.xml')]
            total = len(xml_names)
            print(f"[{zip_idx}/{len(zips)}] {zip_path.name}  ({total} XMLs)")
            uncommitted = 0

            for start in range(0, total, chunk_sz):
              chunk   = xml_names[start:start + chunk_sz]
              futures = {}

              for name in chunk:
                try:
                  try:
                    xml_bytes = zf.read(name)
                  except NotImplementedError:
                    r = subprocess.run(
                      ['unzip', '-p', '--', str(zip_path), name], capture_output=True
                    )
                    xml_bytes = r.stdout
                  futures[pool.submit(_parse_xml_task, (xml_bytes, name, zip_path.name))] = name
                except Exception as e:
                  results.append({"file": name, "status": "error", "reason": str(e)})

              for fut in as_completed(futures):
                parsed = fut.result()
                if parsed.get("status") == "parsed":
                  try:
                    self._store_parsed(parsed, results)
                    uncommitted += 1
                    if uncommitted >= self._BATCH_SIZE:
                      self.db.commit()
                      uncommitted = 0
                  except Exception as e:
                    results.append({"file": parsed["file"], "status": "error", "reason": str(e)})
                else:
                  results.append(parsed)

            self.db.commit()

        except zipfile.BadZipFile:
          results.append({"file": str(zip_path.name), "status": "error", "reason": "invalid ZIP file"})

    return results

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

      if 'boundary=' not in content_type:
        return {"error": "multipart/form-data missing boundary parameter"}
      boundary = content_type.split('boundary=')[1].encode()
      parts = body.split(b'--' + boundary)

      for part in parts:
        if b'filename=' not in part or b'.zip' not in part:
          continue

        header_end = part.find(b'\r\n\r\n')
        if header_end == -1:
          continue

        headers_raw = part[:header_end].decode('utf-8', errors='replace')
        zip_filename = None
        for line in headers_raw.splitlines():
          if 'filename=' in line:
            zip_filename = line.split('filename=')[-1].strip().strip('"')
            break

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
                  results.append(self._process_xml(f.read().decode('utf-8'), name, zip_filename=zip_filename))
                except Exception as e:
                  results.append({"file": name, "status": "error", "reason": str(e)})

            self.db.commit()
            stored = sum(1 for r in results if r.get("status") == "stored")
            errors = sum(1 for r in results if r.get("status") == "error")
            return {"status": "complete", "stored": stored, "errors": errors, "results": results}

        except zipfile.BadZipFile:
          return {"error": "Invalid ZIP file"}

      return {"error": "No ZIP file found in upload"}
