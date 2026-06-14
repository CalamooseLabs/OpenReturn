# Testing

## Running Tests

```bash
# All tests
PYTHONPATH=src python3 -m unittest discover tests

# Single test class or method
PYTHONPATH=src python3 -m unittest tests.test_scoring_engine.TestComputeFactorRatio
PYTHONPATH=src python3 -m unittest tests.test_scoring_engine.TestComputeFactorRatio.test_program_expense_normal
```

## Coverage

Coverage requires the dev shell (`nix develop`):

```bash
# Run with coverage instrumentation
nix develop --command python3 -m coverage run --source=src -m unittest discover tests

# Summary (skip files with 100% coverage)
nix develop --command python3 -m coverage report --skip-covered

# Show missing lines for a specific file
nix develop --command python3 -m coverage report -m src/scoring/engine.py
```

The project maintains **100% statement coverage**. PRs that reduce coverage should include new tests.

## Test File Structure

| Test file | Source file(s) |
|-----------|---------------|
| `tests/test_scoring_engine.py` | `src/scoring/engine.py` |
| `tests/test_models.py` | `src/models.py` |
| `tests/test_database.py` | `src/database/IRS990/irs990.py` + `src/database/IRS990/repositories/` |
| `tests/test_score_database.py` | `src/database/Score/score.py` |
| `tests/test_expanded_forms.py` | `src/database/IRS990/sql/populate/*.sql` (990-EZ/N/PF/T schema) |
| `tests/test_db_commands.py` | `src/db.py` (`init`, `migrate`, `reset`) |
| `tests/test_cli.py` | `src/ingest.py` (directory **and** URL paths) |
| `tests/test_ingest_manage.py` | `src/ingest.py` (forget/purge/list management flags) + `src/database/Score/score.py` purge + `src/database/IRS990/repositories/ingest.py` |
| `tests/test_status.py` | `src/status.py` |
| `tests/test_daemon.py` | `src/daemon.py` (double-fork, pidfile, cooperative stop) |
| `tests/test_openreturn_cli.py` | `src/cli.py` (unified dispatch, incl. `status`/`reset`/ingest mgmt flags) |
| `tests/test_sources.py` | `src/sources.py` |
| `tests/test_upload_worker.py` | `src/router/Upload/upload.py` |
| `tests/test_org_router.py` | `src/router/Org/org.py` |
| `tests/test_filing_router.py` | `src/router/Filing/filing.py` |
| `tests/test_score_router.py` | `src/router/Score/score.py` |
| `tests/test_score_debug.py` | `src/scoring/engine.py` (`debug()` walkthrough) + `GET /scores/debug` + `get_field_source` |
| `tests/test_model_types.py` | model types + manual scoring: `src/models.py` (manual TOML), `src/scoring/engine.py` (`_normalize_manual`/`grade`), `src/database/Score/score.py` |
| `tests/test_openapi.py` | `src/openapi.py` (spec + route-coverage + committed `openapi.json` sync) |
| `tests/test_build_wiki.py` | `tools/build_wiki.py` (docs/ → wiki page rendering + link rewriting) |
| `tests/test_api_keys.py` | `src/keys.py` |
| `tests/test_server_auth.py` | `src/server/server.py` (auth/rate-limit paths) |
| `tests/test_server_coverage.py` | `src/server/server.py` (request handling, formats, errors) |
| `tests/test_serve_instance.py` | `src/main.py` `cmd_serve` (single-instance guard, server.pid) |
| `tests/test_ingest_schedule.py` | `src/ingest.py` `--schedule` / `--restart-server` helpers |

## Notes on Parallel Ingest Coverage

`src/ingest.py` and `src/router/Upload/upload.py` spawn worker processes via `ProcessPoolExecutor`. Subprocess workers cannot be tracked by the coverage tool. Coverage for the main-process loop (submit, `as_completed`, result dispatch) is achieved by patching `ProcessPoolExecutor` and `as_completed` in tests; worker functions (`_worker_init`, `_parse_xml_task`, `_parse_xml_batch`) are tested directly in-process in `test_upload_worker.py`.

## Notes on URL Ingest Coverage

The URL ingest path (`_cmd_ingest_url` / `_ingest_one_remote`) is tested in `tests/test_cli.py` (`TestIngestUrl`) by patching `ingest.sources.discover_zip_urls` and `ingest.sources.download_zip` so no network I/O happens — the download stand-in writes a real (or deliberately corrupt) ZIP into the cache dir. Tests use a **file-backed** `ScoreDatabase` in a temp dir (rather than `:memory:`) so the `ingested_zip` records can be re-opened and asserted after the run closes the connection — exercising the skip/`--force` resume behavior. `src/sources.py` itself is unit-tested in `tests/test_sources.py` by patching `sources.urlopen` with a fake response object.

## Test Patterns

**In-memory database**: Most database tests use `IRS990Database(path=":memory:")` to avoid touching the filesystem.

**Mock DB for engine tests**: `ScoringEngine` is initialized with `db=MagicMock()` so individual formula and normalization methods can be tested without any database layer.

**Module-level state**: `upload.py` uses module globals (`_xpath_index`, `_supported_forms`) set per worker process. Tests call `upload_mod._worker_init(...)` in `setUp` to populate them. (Workers no longer cache ZIP handles — they receive already-read bytes — so there is no `_zip_cache` to reset.)
