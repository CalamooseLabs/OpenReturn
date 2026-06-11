# Architecture & Development Reference

## Layer Overview

```
src/
  database/      → Database (base) / IRS990Database / ScoreDatabase
                   IRS990/repositories/  → query/command mixins
                   IRS990/sql/{setup,populate,migrations}/
                   Score/sql/{setup,populate,migrations}/
  parser/        → Parser (base) / IRS990Parser
  router/        → Router (base) / UploadRouter / OrgRouter / FilingRouter / ScoreRouter
  server/        → Server (wraps HTTPServer, wires routers to routes)
  scoring/       → ScoringEngine
  unzipper/      → Unzipper (ZIP file iterator)
  sources.py     → URL detection, ZIP-link discovery, downloads (for URL ingest)
  db.py          → Database init/migrate CLI commands
  ingest.py      → Bulk ZIP ingestion CLI (local directory or URL)
  models.py      → Scoring model registration CLI
  keys.py        → API key management CLI
  main.py        → Server entry point
```

Each layer has a base class in its package `__init__.py` and a concrete implementation in a subpackage. For example, `database/__init__.py` exports `Database`; `database/IRS990/` contains `IRS990Database`.

---

## Database Layer

### `Database` (`src/database/base.py`)

SQLite connection manager. Opens (or creates) a `.db` file and runs setup/populate scripts on init.

- `_run_dir(subdir, sql_dir)` — executes every `*.sql` in `src/database/<sql_dir>/<subdir>/` in **sorted filename order**. `__init__` runs `sql/setup/` then `sql/populate/`. SQL assets must live under the `sql/` tree of the subpackage that uses them. Numeric filename prefixes (`00_`, `10_`, …) make load order deterministic and dependency-safe.
- `begin_bulk_load()` / `end_bulk_load()` — toggle WAL mode, a 512 MB page cache, and a 10 GB mmap for high-throughput ingest. Call these around large batch operations.
- `populate_guard` — optional table name; when set, the `sql/populate/` files only run if that table is empty (used for performance-sensitive subclasses).

### `IRS990Database` (`src/database/IRS990/irs990.py`)

Extends `Database`. Loads `sql/setup/*.sql` (schema + `api_key` table) then `sql/populate/*.sql` on **every startup**. `populate/` is split by form — `00_reference` (states, forms, parts, and the core 990/EZ/PF/T structure), then `10_form_990`, `20_form_990ez`, `30_form_990pf`, `40_form_990t`, `50_return_header` — each loaded in sorted order. The `INSERT OR IGNORE` statements cover all five supported form types (990, 990-EZ, 990-N, 990-PF, 990-T), their parts/sections/lines/fields, states, and data types. First-run startup is slow (~seconds) because all rows are new; subsequent startups are fast because `INSERT OR IGNORE` skips existing rows instantly. FK enforcement is on, so file order matters: `50_return_header` depends on part 14 from `10_form_990`.

The class itself is thin — its query/command methods come from the repository mixins in `src/database/IRS990/repositories/` (`ApiKeyRepository`, `FilingRepository`, `IngestRepository`, `MetadataRepository`, `MigrationRepository`, `OrganizationRepository`, `ReportedDataRepository`), composed via multiple inheritance so the public interface stays flat. `__init__` wires the `_field_meta` cache and `_key_cache` the mixins rely on.

Key methods (defined in the mixin shown, called as `db.<method>`):

| Method | Purpose |
|--------|---------|
| `get_xpath_index()` | Returns `{xml_path: field_id}` — maps parsed XPath strings to DB field IDs |
| `get_supported_forms()` | Returns the set of form codes stored in the DB (`{'990', '990EZ', ...}`) |
| `create_filing(ein, year, form_code, ...)` | Inserts a filing row and returns its UUID |
| `upsert_organization(ein, name)` | Insert-or-update organization record |
| `store_reported_data(filing_id, values)` | Bulk insert `{field_id: value}` pairs |
| `get_filing_data_by_ein_year(ein, year)` | Returns filing metadata + all field values |
| `get_historical_values(ein)` | Returns `{xml_path: [float, ...]}` oldest-to-newest across all filings |
| `get_ingested_sources()` / `record_ingested_zip(...)` | Read/write the `ingested_zip` table so URL ingest skips archives already loaded (`IngestRepository`) |
| `list_organizations(search, limit, offset, favorites_only)` | Paginated org list with optional name substring match; `favorites_only` restricts to favorited orgs |
| `set_favorite(ein, is_favorite)` | Sets the org's `is_favorite` flag and bumps `updated_at`; returns False if the EIN doesn't exist |
| `create_api_key(name, rate_limit)` | SHA-256 hashes the raw key, stores hash; returns raw key once |
| `validate_api_key(raw_key)` | Checks hash against DB; caches result in memory for the process lifetime |
| `revoke_api_key(key_id)` | Marks key inactive and clears the in-memory cache |

**Non-obvious**: field metadata (`_field_meta`) is loaded into memory at init. The API key validation cache is per-process, not TTL-based — it is only invalidated on revoke. Schema migration for the `rate_limit` column runs on every startup for databases created before the column was added.

**Filing keys**: `filing` has an integer `filing_id` PRIMARY KEY (rowid) and a separate `uuid UNIQUE`. **`uuid` is the public/API identifier** (filing responses, `FilingRouter`/`ScoreRouter` lookups, and `organization_score.filing_id` all use it). The large `reported_data` table references the integer `filing_id` instead — an 8-byte int rather than a 36-char uuid on ~190M rows roughly halves the DB and speeds bulk inserts and the index rebuild. `store_reported_data`/`get_reported_data` take the public uuid and resolve it to the integer internally; the bulk ingest path assigns integer ids directly.

### `ScoreDatabase` (`src/database/Score/score.py`)

Extends `IRS990Database`. Loads its own `Score/sql/setup/*.sql` and `Score/sql/populate/*.sql` (after the inherited IRS990 schema) and adds scoring tables (`score_model`, `score_factor`, `organization_score`, `score_factor_value`).

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
- `supportedForms` — `{'990', '990EZ', '990N', '990PF', '990T'}`. Defined but not enforced at parse time; the ingest layer checks `get_supported_forms()` from the DB instead.

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

`UploadRouter` handles ZIP file upload and ingestion via `ProcessPoolExecutor`. It also exposes `process_zip_dir(path)` (used by `main.py`'s testing mode). The XPath index and supported-form set live as module-level globals (`_xpath_index`, `_supported_forms`) initialized by `_worker_init` in each worker process. Workers receive already-read XML **bytes** and do no disk/ZIP I/O; `unzipper.MemberReader` (in the main process) reads members, extracting Deflate64 archives once with `unzip` rather than per-file.

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

`openreturn-ingest` / `python3 src/ingest.py` processes ZIP archives from a local directory **or an `http(s)://` URL**. `cmd_ingest` dispatches on `sources.is_url`: a path goes to `_cmd_ingest_dir` (pre-scan all ZIPs → bulk-load → loop), a URL to `_cmd_ingest_url`. Both share the per-ZIP processors (`_process_zip_seq` / `_process_zip_par`) and run-level state (`_Ctx`), so the bulk-load session, worker pool, and index drop/rebuild are identical across the two paths.

**URL sources** (`src/sources.py`, stdlib `urllib` + `html.parser` only): a direct `.zip` URL is fetched as-is; any other URL is parsed as HTML and every `<a href>` whose path ends in `.zip` is kept — so on the IRS Form 990 downloads page the `apps.irs.gov` data archives are selected while CSV index files and `www.irs.gov` navigation links are ignored. Each discovered archive is downloaded to a cache dir, scanned, ingested, recorded in `ingested_zip`, then deleted (`--keep-downloads`/`--cache-dir` opt out). Archives already in `ingested_zip` are skipped unless `--force`; `--list` prints discovered URLs with their ingest status and exits. This is download→ingest→delete **per archive**, so peak disk stays bounded and an interrupted run resumes by re-doing only the in-flight archive.

**Sequential mode** (`--workers 1`): reads + processes each XML in the main process via `UploadRouter._process_xml` (full `IRS990Parser`). Simple, low-memory, easy to debug.

**Parallel mode** (`--workers N`, default = CPU count): the main process reads XML bytes (`MemberReader`) and submits them to a `ProcessPoolExecutor` in batches via `_parse_xml_batch`. Each worker (`_worker_init` once) parses bytes with a single tree-walk + XPath-index intersection and returns plain dicts. Results are collected with `as_completed`; the main process buffers and bulk-writes.

**Deduplication**: filing rows get client-assigned integer `filing_id`s (counter seeded past `MAX(filing_id)`). `_resolve_ids()` joins a temp table of the current flush's keys against `filing` to detect when an (EIN, year, form_code) triple already exists, and remaps the client id to the existing one; remaps accumulate in a per-ZIP `id_remap` applied to each batch's `reported_data`.

**Batch commits**: `_flush_zip()` writes a buffered batch and commits; it flushes per ZIP or mid-ZIP once buffered `reported_data` rows reach `_DATA_ROWS_PER_FLUSH` (500k). Indexes on `reported_data`/`filing` are dropped during the load (`drop_ingest_indexes`) and rebuilt at the end.

---

## CLI Tools

All commands are dispatched through `src/cli.py` (the unified `openreturn` binary). Each subcommand delegates to a dedicated module.

| Subcommand | Dispatch module | Purpose |
|------------|----------------|---------|
| `openreturn init` | `src/db.py` → `cmd_init` | Initialize database schema and seed data |
| `openreturn migrate` | `src/db.py` → `cmd_migrate` | Apply pending schema migrations |
| `openreturn serve` | `src/main.py` → `cmd_serve` | Start the API server |
| `openreturn ingest` | `src/ingest.py` → `cmd_ingest` | Bulk-ingest ZIP archives |
| `openreturn keys` | `src/keys.py` | Manage API keys |
| `openreturn models` | `src/models.py` | Register and list scoring models |

`cmd_init` opens the database (triggering the `sql/populate/` files on first run via `populate_guard="form"`), prints form/field counts, and closes. `cmd_migrate` discovers `.sql` files in `src/database/IRS990/sql/migrations/`, compares against the `migration` tracking table, and applies anything pending in filename order.
