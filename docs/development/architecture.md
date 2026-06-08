# Architecture & Development Reference

## Layer Overview

```
src/
  database/      → Database (base) / IRS990Database / ScoreDatabase
  parser/        → Parser (base) / IRS990Parser
  router/        → Router (base) / UploadRouter / OrgRouter / FilingRouter / ScoreRouter
  server/        → Server (wraps HTTPServer, wires routers to routes)
  scoring/       → ScoringEngine
  unzipper/      → Unzipper (ZIP file iterator)
  ingest.py      → Bulk ZIP ingestion CLI
  models.py      → Scoring model registration CLI
  keys.py        → API key management CLI
  main.py        → Server entry point
```

Each layer has a base class in its package `__init__.py` and a concrete implementation in a subpackage. For example, `database/__init__.py` exports `Database`; `database/IRS990/` contains `IRS990Database`.

---

## Database Layer

### `Database` (`src/database/base.py`)

SQLite connection manager. Opens (or creates) a `.db` file and runs setup/populate scripts on init.

- `_run_script(path)` — executes a SQL file relative to the **subclass's** `__file__`, not the project root. SQL assets must live alongside the subpackage that uses them.
- `begin_bulk_load()` / `end_bulk_load()` — toggle WAL mode, a 512 MB page cache, and a 10 GB mmap for high-throughput ingest. Call these around large batch operations.
- `populate_guard` — a flag used by subclasses to make `populate.sql` idempotent (`INSERT OR IGNORE`).

### `IRS990Database` (`src/database/IRS990/irs990.py`)

Extends `Database`. Runs `setup.sql` (schema) then `populate.sql` (~3900 `INSERT OR IGNORE` statements covering all form fields, parts, sections, and states) on first instantiation. Subsequent startups skip the inserts because the rows already exist — but the SQL still executes, so **first-run startup is slow** (~seconds) if the database file doesn't exist yet.

Key methods:

| Method | Purpose |
|--------|---------|
| `get_xpath_index()` | Returns `{xml_path: field_id}` — maps parsed XPath strings to DB field IDs |
| `get_supported_forms()` | Returns the set of form codes stored in the DB (`{'990', '990EZ', ...}`) |
| `create_filing(ein, year, form_code, ...)` | Inserts a filing row and returns its UUID |
| `upsert_organization(ein, name)` | Insert-or-update organization record |
| `store_reported_data(filing_id, values)` | Bulk insert `{field_id: value}` pairs |
| `get_filing_data_by_ein_year(ein, year)` | Returns filing metadata + all field values |
| `get_historical_values(ein)` | Returns `{xml_path: [float, ...]}` oldest-to-newest across all filings |
| `list_organizations(search, limit, offset)` | Paginated org list with optional name substring match |
| `create_api_key(name, rate_limit)` | SHA-256 hashes the raw key, stores hash; returns raw key once |
| `validate_api_key(raw_key)` | Checks hash against DB; caches result in memory for the process lifetime |
| `revoke_api_key(key_id)` | Marks key inactive and clears the in-memory cache |

**Non-obvious**: field metadata (`_field_meta`) is loaded into memory at init. The API key validation cache is per-process, not TTL-based — it is only invalidated on revoke. Schema migration for the `rate_limit` column runs on every startup for databases created before the column was added.

### `ScoreDatabase` (`src/database/Score/score.py`)

Extends `IRS990Database`. Adds scoring tables (`score_model`, `score_factor`, `organization_score`, `score_factor_value`).

Key methods:

| Method | Purpose |
|--------|---------|
| `get_factors(model_version)` | Returns all factor definitions for a model version |
| `create_score(filing_id, model_version)` | Creates a bare score row; returns `score_id` |
| `store_factor_values(score_id, results)` | Bulk insert `{factor_id: (raw, weighted)}` |
| `finalize_score(score_id, total)` | Sets the `total_score` field |
| `get_score(score_id)` | Returns score + per-factor breakdown |
| `compare_scores(ein, year)` | All model version scores for a given EIN + year |

---

## Parser Layer

### `Parser` (`src/parser/base.py`)

Generic XML DOM walker. Parses a file with `xml.etree.ElementTree`.

- `getElem(path)` — builds a namespaced XPath query from a `/`-delimited path string and returns the element's text. Tracks call counts per path in `foundElements` to cycle through repeated elements.
- `tree(depth, tagStrip)` — recursive DOM-to-dict conversion.

**Critical gotcha**: `foundElements` is a **class-level dict**, shared across all `Parser` instances in a process. It must be explicitly reset between parses (the ingest pipeline calls `Parser.foundElements.clear()` between files). Failing to do so causes wrong results when processing multiple XML files sequentially.

### `IRS990Parser` (`src/parser/IRS990/irs990.py`)

Extends `Parser` with the IRS namespace (`http://www.irs.gov/efile`).

- `cleanTags()` — CamelCase tag names split into space-separated words.
- `dict()` — `tree()` with namespace stripping.
- `supportedForms` — `{'990', '990PF', '990T'}`. Defined but not enforced at parse time; the ingest layer checks `get_supported_forms()` from the DB instead.

---

## Router Layer

### `Router` (`src/router/base.py`)

Route registry with decorator-based registration. Each router has a URL prefix and an optional template directory.

```python
class MyRouter(Router):
    def __init__(self, db):
        super().__init__(prefix='/my-prefix',
                         template_dir=str(Path(__file__).parent / 'views'))
        self._db = db
        self._register_routes()

    def _register_routes(self):
        @self.get('')           # handles GET /my-prefix
        def index(query_params, body, headers):
            return {'key': 'value'}   # dict → JSON; str → HTML

        @self.post('/create', secured=True)   # requires auth when server has --auth
        def create(query_params, body, headers):
            return self.render_template('form.html', key='value')
```

- `render_template(name, **kwargs)` — naive `{{key}}` string substitution; templates are cached on first read. Not Jinja2 — no filters, conditionals, or loops.
- Handlers receive `(query_params: dict, body: dict|None, headers: dict)`. Return a `dict` for JSON or any other value for an HTML string response.

### Concrete Routers

| Class | Prefix | Source |
|-------|--------|--------|
| `UploadRouter` | `/upload` | `src/router/Upload/upload.py` |
| `OrgRouter` | `/organizations` | `src/router/Org/org.py` |
| `FilingRouter` | `/filings` | `src/router/Filing/filing.py` |
| `ScoreRouter` | `/scores` | `src/router/Score/score.py` |

`UploadRouter` handles ZIP file upload and ingestion via `ProcessPoolExecutor`. It also exposes `process_zip_dir(path)` used by the ingest CLI. The parser, ZIP cache, and XPath index all live as module-level globals (`_xpath_index`, `_xpath_compiled`, `_zip_cache`, `_supported_forms`) initialized by `_worker_init` in each worker process.

---

## Server (`src/server/server.py`)

Wraps Python's `http.server.HTTPServer`. Wires routers to routes via `include_router()`.

- `include_router(router)` — merges a router's route table into the server's global dispatch table.
- `_create_handler()` — returns a `RequestHandler` class (closure) that handles auth, rate limiting, body parsing, routing, and response serialization.
- Auth checks `Authorization: Bearer <key>` and `X-API-Key: <key>` headers when `--auth` is active.
- Rate limiter uses a sliding window (60 s) keyed by the raw API key value (not the hash).
- Request bodies up to 50 MB are accepted; larger bodies return 413.
- JSON bodies are auto-parsed; `multipart/form-data` is passed as raw bytes.
- Debug mode (`--debug`) logs every request and response with ANSI color.

---

## Scoring Engine (`src/scoring/engine.py`)

`ScoringEngine(db)` computes a financial health score for a single filing.

`calculate(ein, year, model_version)` — the main entry point:

1. Fetches the filing's field values from the DB
2. Loads the factor definitions for the model version
3. Topologically sorts factors to resolve `factor:<name>` dependencies
4. Pre-fetches historical values from the DB if any factor uses a historical formula type
5. Computes each factor's raw value via `_compute_factor()`
6. Normalizes each raw value to `[0, 1]` via `_normalize()`
7. Multiplies by weight and accumulates the total
8. Persists all factor values and the total score
9. Returns the full score record

`_topo_sort(factors)` — Kahn-style DFS that raises `ValueError` on circular or missing `factor:<name>` references.

`_resolve_input(key, vals, computed)` — resolves a single input key in priority order: `factor:<name>` → numeric literal string → field key shorthand → `None`.

See [Scoring Models](../scoring/models.md) for the full list of formula types and input keys.

---

## Ingest CLI (`src/ingest.py`)

`openreturn-ingest` / `python3 src/ingest.py` processes one or more ZIP archives.

**Sequential mode** (`--workers 1`, default): processes each XML in the main process using `UploadRouter.process_zip_dir()`.

**Parallel mode** (`--workers N`): delegates to `ProcessPoolExecutor`. Each worker calls `_worker_init` once (loads XPath index and supported forms into module globals), then processes XML files via `_parse_xml_task`. Results are collected with `as_completed` and written to the DB in the main process.

**Deduplication**: `_resolve_uuids()` creates a temporary table `_key_resolve` and joins it against `filing` to detect when a (EIN, year, form_code) triple already exists. If a match is found, the pre-assigned UUID is remapped to the existing UUID so all `store_reported_data` calls land under the correct row.

**Batch commits**: `_flush_zip()` accumulates inserts and calls `db.commit()` every `_BATCH_SIZE` rows (default 500) to avoid holding large transactions.

---

## CLI Tools

| Binary | Source | Purpose |
|--------|--------|---------|
| `openreturn` | `src/main.py` | Start the API server |
| `openreturn-ingest` | `src/ingest.py` | Bulk-ingest ZIP archives |
| `openreturn-keys` | `src/keys.py` | Manage API keys |
| `openreturn-models` | `src/models.py` | Register and list scoring models |
