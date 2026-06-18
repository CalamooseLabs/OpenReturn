import io
import os
import subprocess
import sys
import xml.etree.ElementTree as ET
import zipfile
from concurrent.futures import ProcessPoolExecutor, as_completed
from typing import Any
from http.client import HTTPMessage
from pathlib import Path
from urllib.parse import urlparse

from router import Router
from database import OpenReturnDB
from parser.IRS990 import IRS990Parser
from parser.groups import extract_groups
from unzipper import MemberReader

# ---------------------------------------------------------------------------
# Module-level worker state — set once per worker process via _worker_init.
# These must be module-level (not class attributes) for pickling.
# Workers receive already-read XML bytes, so they do no ZIP/disk I/O.
# ---------------------------------------------------------------------------

_xpath_index:     dict[str, int] = {}
_supported_forms: set[str]       = set()

_NS_PFX = '{http://www.irs.gov/efile}'

# Default discovery source for the "grab from IRS" admin feature — the IRS Form
# 990 series downloads index page (its ZIP archives live on apps.irs.gov).
_IRS_DOWNLOADS_URL = "https://www.irs.gov/charities-non-profits/form-990-series-downloads"

_EIN_PATH  = "ReturnHeader/Filer/EIN"
_NAME_PATH = "ReturnHeader/Filer/BusinessName/BusinessNameLine1Txt"
_YEAR_PATH = "ReturnHeader/TaxYr"
_FORM_PATH = "ReturnHeader/ReturnTypeCd"
_STREET_PATH = "ReturnHeader/Filer/USAddress/AddressLine1Txt"
_CITY_PATH   = "ReturnHeader/Filer/USAddress/CityNm"
_STATE_PATH  = "ReturnHeader/Filer/USAddress/StateAbbreviationCd"
_ZIP_PATH    = "ReturnHeader/Filer/USAddress/ZIPCd"


def _address_from(get) -> dict | None:
  """Build the filer-address dict from a path/element getter (``dict.get`` for
  the worker, ``parser.getElem`` for the HTTP path). None when no field is set."""
  addr = {"street": get(_STREET_PATH), "city": get(_CITY_PATH),
          "state": get(_STATE_PATH), "zip": get(_ZIP_PATH)}
  return addr if any(addr.values()) else None


def _worker_init(xpath_index: dict, supported_forms: set) -> None:
  global _xpath_index, _supported_forms
  _xpath_index     = xpath_index
  _supported_forms = supported_forms


def _walk(elem, parent: str, out: dict) -> None:
  """Record {path: text} for every element with a non-blank text value.

  Paths mirror the XPath-index keys (e.g. 'ReturnData/IRS990/...'). First
  occurrence wins (``setdefault``) to match ElementTree's ``find`` semantics
  for repeated elements."""
  tag = elem.tag
  if tag.startswith(_NS_PFX):
    tag = tag[len(_NS_PFX):]
  path = f"{parent}/{tag}" if parent else tag
  if elem.text and elem.text.strip():
    out.setdefault(path, elem.text)
  for child in elem:
    _walk(child, path, out)


def _header_issue(ein, name, year, form_code, supported_forms,
                  filename: str, zip_filename: str | None = None) -> dict | None:
  """Validate the four required header fields and the form-supported check.

  Returns an error/skipped result dict if the filing should not be stored,
  or None if the header is valid. ``zip_filename`` is included in the result
  only when provided (the parallel path carries it; the HTTP path does not).
  """
  extra = {"zip_filename": zip_filename} if zip_filename is not None else {}
  if not all([ein, name, year, form_code]):
    missing = [k for k, v in {"EIN": ein, "name": name, "year": year, "form": form_code}.items() if not v]
    return {"file": filename, **extra, "status": "error",
            "reason": f"missing header fields: {missing}"}
  if form_code not in supported_forms:
    return {"file": filename, **extra, "status": "skipped",
            "reason": f"unsupported form type: {form_code}"}
  return None


def _parse_xml_task(task: tuple) -> dict:
  """Parse a single XML filing from raw bytes. No DB or disk access — the
  main process reads the bytes and passes them in, so this is pure CPU work
  safe to run in worker processes.

  Extraction is a single recursive walk of the tree building {path: text},
  then a dict intersection with the XPath index — far cheaper than one
  ElementTree.find() per mapped path (thousands of root-relative searches)."""
  xml_bytes, filename, zip_filename = task
  try:
    root = ET.fromstring(xml_bytes)

    paths: dict[str, str] = {}
    for child in root:
      _walk(child, '', paths)

    ein       = paths.get(_EIN_PATH)
    name      = paths.get(_NAME_PATH)
    year      = paths.get(_YEAR_PATH)
    form_code = paths.get(_FORM_PATH)

    issue = _header_issue(ein, name, year, form_code, _supported_forms, filename, zip_filename)
    if issue is not None:
      return issue

    values = {_xpath_index[p]: v for p, v in paths.items() if p in _xpath_index}

    return {
      "file":         filename,
      "zip_filename": zip_filename,
      "status":       "parsed",
      "ein":          ein,
      "name":         name,
      "address":      _address_from(paths.get),
      "year":         int(year),
      "form_code":    form_code,
      "values":       values,
      "groups":       extract_groups(root),
    }
  except Exception as exc:
    return {"file": filename, "zip_filename": zip_filename,
            "status": "error", "reason": str(exc)}


def _parse_xml_batch(batch: list) -> list:
  """Parse a batch of filings in one worker task. Batching amortizes the
  per-task IPC cost (pickling bytes in, results out) now that per-filing
  parsing is cheap. Returns one result dict per input task."""
  return [_parse_xml_task(task) for task in batch]


# ---------------------------------------------------------------------------
# Router
# ---------------------------------------------------------------------------

class UploadRouter(Router):

  _BATCH_SIZE = 1000
  _CHUNK      = 8    # in-flight tasks per worker slot

  def __init__(self, prefix: str = '/upload', db: OpenReturnDB = None,
               secure_by_default: bool = False, workers: int | None = None):
    base_path = Path(__file__).parent
    super().__init__(prefix, str(base_path / "views"), secure_by_default=secure_by_default)
    self.db      = db
    self.workers = workers if workers is not None else (os.cpu_count() or 4)
    self.xpath_index    = db.meta.get_xpath_index()
    self.supported_forms = db.meta.get_supported_forms()
    self._register_routes()

  def _process_xml(self, xml_content: str, filename: str, zip_filename: str | None = None) -> dict:
    """Process a single XML filing (parse + DB write). Used by the HTTP upload endpoint."""
    parser = IRS990Parser(xml_content)

    # Collect every mapped value in one pass, then read the header + address from
    # the collected set. getElem is stateful (it cycles through repeated elements
    # per path), so querying any present path a second time would IndexError —
    # the header/address fields live in the xpath index, so re-querying them is
    # exactly that double-call. ``at`` reads from ``values`` for indexed paths and
    # only calls getElem (once) for paths the index does not cover.
    values: dict[int, str] = {}
    for xpath, field_id in self.xpath_index.items():
      value = parser.getElem(xpath)
      if value is not None:
        values[field_id] = value

    def at(path: str):
      field_id = self.xpath_index.get(path)
      return values.get(field_id) if field_id is not None else parser.getElem(path)

    ein       = at(_EIN_PATH)
    name      = at(_NAME_PATH)
    year      = at(_YEAR_PATH)
    form_code = at(_FORM_PATH)

    issue = _header_issue(ein, name, year, form_code, self.supported_forms, filename)
    if issue is not None:
      return issue

    self.db.orgs.upsert_organization(ein, name, _address_from(at))
    filing_id = self.db.filings.create_filing(ein, int(year), form_code,
                                      xml_filename=filename, zip_filename=zip_filename)

    self.db.reported_data.store_reported_data(filing_id, values)
    self.db.appearances.store_filing_graph(filing_id, extract_groups(parser.root))

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
    self.db.orgs.upsert_organization(parsed["ein"], parsed["name"], parsed.get("address"))
    filing_id = self.db.filings.create_filing(
      parsed["ein"], parsed["year"], parsed["form_code"],
      xml_filename=parsed["file"], zip_filename=parsed["zip_filename"],
    )
    self.db.reported_data.store_reported_data(filing_id, parsed["values"])
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
          with MemberReader(zip_path) as reader:
            xml_names = [n for n in reader.namelist() if not n.endswith('/') and n.endswith('.xml')]
            total = len(xml_names)
            print(f"[{zip_idx}/{len(zips)}] {zip_path.name}  ({total} XMLs)")
            uncommitted = 0

            for start in range(0, total, chunk_sz):
              chunk   = xml_names[start:start + chunk_sz]
              futures = {}

              for name in chunk:
                try:
                  xml_bytes = reader.read(name)
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
    @self.get('', permission='upload:write')
    def upload_form(query_params: dict[str, list[str]], body: Any, headers: HTTPMessage):
      return self.render_template('upload.html', prefix=self.prefix)

    @self.post('', permission='upload:write')
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

    @self.post('/pdf', permission='upload:write')
    def handle_pdf_upload(query_params: dict[str, list[str]], body: Any, headers: HTTPMessage):
      """OCR a 990 PDF into confidence-scored financial observations. Query params
      ein and year identify the org-year (a PDF doesn't reliably self-identify).
      Body: multipart/form-data with the PDF file."""
      import ocr as ocr_mod
      if not ocr_mod.ocr_available():
        return {"error": "OCR engine unavailable on this server (tesseract/pdftoppm)"}
      # OCR writes via normal INSERTs and must not compete with a bulk ingest for
      # the exclusive DB lock — refuse while a background ingest is running.
      import daemon
      if daemon.running_daemon():
        return {"error": "A bulk ingest is running; OCR is unavailable until it finishes."}
      ein = self._qp(query_params, 'ein')
      year, yerr = self._qp_int_or_error(query_params, 'year', field='year')
      if not ein or year is None:
        return yerr or {"error": "ein and year query params are required"}
      if not isinstance(body, bytes):
        return {"error": "Invalid upload"}
      content_type = headers.get('Content-Type', '')
      if 'boundary=' not in content_type:
        return {"error": "Expected multipart/form-data with a boundary"}
      boundary = content_type.split('boundary=')[1].encode()
      for part in body.split(b'--' + boundary):
        if b'filename=' not in part or b'.pdf' not in part.lower():
          continue
        header_end = part.find(b'\r\n\r\n')
        if header_end == -1:
          continue
        filename = next((ln.split('filename=')[-1].strip().strip('"')
                         for ln in part[:header_end].decode('utf-8', 'replace').splitlines()
                         if 'filename=' in ln), 'upload.pdf')
        pdf_data = part[header_end + 4:]
        if pdf_data.endswith(b'\r\n'):
          pdf_data = pdf_data[:-2]
        import tempfile
        with tempfile.NamedTemporaryFile(suffix='.pdf', delete=True) as tmp:
          tmp.write(pdf_data)
          tmp.flush()
          try:
            result = ocr_mod.ocr_pdf(tmp.name)
          except Exception as e:
            return {"error": f"OCR failed: {e}"}
        self.db.orgs.upsert_organization(ein, ein)
        out = ocr_mod.record_ocr(self.db, ein, year, result, filename=filename,
                                 actor=self._principal(headers))
        return {"status": "complete", "ein": ein, "year": year, "filename": filename,
                "pages": result["pages"], "recorded": out["recorded"],
                "concepts": result["concepts"]}
      return {"error": "No PDF file found in upload"}

    # ── Grab from the IRS website ────────────────────────────────────────────
    # List / discover / trigger a bulk ingest straight from irs.gov, so an admin
    # can pull a year of filings without shell access. The actual ingest runs as
    # a detached background process (it needs the exclusive DB lock), so these
    # routes only *start* it and report status.

    @self.get('/ingested', permission='upload:write')
    def list_ingested(query_params: dict[str, list[str]], body: Any, headers: HTTPMessage):
      """What has been grabbed and ingested. Two views: ``grabbed`` — archives
      pulled from a URL (the ``ingested_zip`` ledger, with provenance + counts);
      ``archives`` — every source ZIP seen in the filing table (covers local-dir
      and uploaded archives too). Plus whether a background ingest is live now."""
      import daemon
      grabbed = self.db.ingest.list_ingested_zips()
      grabbed.reverse()  # newest first
      running = daemon.running_daemon()
      return {
        "grabbed":          grabbed,
        "grabbed_count":    len(grabbed),
        "archives":         self.db.filings.archives_summary(),
        "ingest_running":   bool(running),
        "ingest":           running,
        "default_source":   _IRS_DOWNLOADS_URL,
      }

    @self.post('/discover', permission='upload:write')
    def discover_archives(query_params: dict[str, list[str]], body: Any, headers: HTTPMessage):
      """Dry run: list the ZIP archives reachable at a URL (a direct ``.zip`` or
      an index page such as the IRS downloads page), each flagged with whether it
      has already been ingested. No DB writes, no downloads."""
      import sources
      url = (body or {}).get('url') if isinstance(body, dict) else None
      url = (url or self._qp(query_params, 'url') or _IRS_DOWNLOADS_URL).strip()
      if not sources.is_url(url):
        return {"error": "Provide an http(s):// URL (a .zip archive or an index page)."}
      try:
        urls = sources.discover_zip_urls(url)
      except Exception as exc:  # noqa: BLE001 — surface the fetch/parse failure
        return {"error": f"Could not read {url}: {exc}"}
      already = self.db.ingest.get_ingested_sources()
      archives = [
        {"url": u, "filename": os.path.basename(urlparse(u).path) or u,
         "ingested": u in already}
        for u in urls
      ]
      return {"source": url, "count": len(archives),
              "new": sum(1 for a in archives if not a["ingested"]), "archives": archives}

    @self.post('/grab', permission='upload:write')
    def grab_from_irs(query_params: dict[str, list[str]], body: Any, headers: HTTPMessage):
      """Start a detached background ingest of ``url`` (a direct ``.zip`` or an
      index page). Returns immediately; poll ``GET /upload/ingested`` for progress.

      The ingest needs the exclusive DB lock, so the launched job uses
      ``--restart-server``: it briefly stops and restarts this API server around
      the load. Refused when the server is systemd-managed (use the CLI there) or
      when a background ingest is already running.

      Optional ``schedule`` in the body delays the start to a given time
      (``HH:MM`` clock, ``+2h`` relative, or ``YYYY-MM-DD HH:MM`` absolute);
      omitted / empty / ``"now"`` runs immediately."""
      import daemon
      import ingest as ingest_mod
      import sources
      url = (body or {}).get('url') if isinstance(body, dict) else None
      url = (url or self._qp(query_params, 'url') or "").strip()
      force = bool((body or {}).get('force')) if isinstance(body, dict) else False
      schedule = ((body or {}).get('schedule') if isinstance(body, dict) else None) or ""
      schedule = schedule.strip()
      if schedule.lower() == "now":
        schedule = ""
      if not sources.is_url(url):
        return {"error": "Provide an http(s):// URL to grab."}
      if daemon.running_daemon():
        return {"error": "A background ingest is already running. Wait for it to finish."}
      if ingest_mod._systemd_active():
        return {"error": "This server is managed by systemd; trigger ingest from the CLI "
                         "(openreturn ingest <url>) so it can coordinate with systemctl."}
      # A user-supplied schedule (clock time / relative / absolute) is validated up
      # front so a bad value fails the request instead of the detached job.
      if schedule:
        try:
          ingest_mod._parse_schedule(schedule)
        except ValueError as e:
          return {"error": f"invalid schedule: {e}"}

      cli = Path(__file__).parents[2] / "cli.py"
      # The schedule gives this HTTP response (and the launching process) time to
      # return before the job stops the server to take the DB lock. A user-supplied
      # schedule replaces the +12s grace (a future "01:00" already implies a delay).
      sched_arg = schedule or "+12s"
      cmd = [sys.executable, str(cli), "ingest", "--background",
             "--restart-server", "--schedule", sched_arg, url]
      if force:
        cmd.insert(cmd.index(url), "--force")
      actor = self._principal(headers)
      try:
        proc = subprocess.run(cmd, cwd=os.getcwd(), capture_output=True,
                              text=True, timeout=30)
      except subprocess.TimeoutExpired:
        return {"error": "Timed out launching the background ingest."}
      if proc.returncode != 0:
        return {"error": "Failed to start background ingest.",
                "detail": (proc.stderr or proc.stdout or "").strip()[-500:]}
      self.db.audit.record(actor, "ingest.grab", "ingest", url,
                           {"force": force, "schedule": schedule or "now"})
      return {"status": "started", "source": url, "force": force,
              "schedule": schedule or "now",
              "note": "The API server will briefly restart to load this archive. "
                      "Poll GET /upload/ingested for progress."}
