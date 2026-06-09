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
| `tests/test_database.py` | `src/database/IRS990/irs990.py` + `src/database/IRS990/repositories/`, `src/database/Score/score.py` |
| `tests/test_expanded_forms.py` | `src/database/IRS990/sql/populate/*.sql` (990-EZ/N/PF/T schema) |
| `tests/test_db_commands.py` | `src/db.py` |
| `tests/test_cli.py` | `src/ingest.py` (directory **and** URL paths) |
| `tests/test_sources.py` | `src/sources.py` |
| `tests/test_upload_worker.py` | `src/router/Upload/upload.py` |
| `tests/test_org_router.py` | `src/router/Org/org.py` |
| `tests/test_filing_router.py` | `src/router/Filing/filing.py` |
| `tests/test_score_router.py` | `src/router/Score/score.py` |
| `tests/test_api_keys.py` | `src/keys.py` |
| `tests/test_server.py` | `src/server/server.py` |

## Notes on Parallel Ingest Coverage

`src/ingest.py` and `src/router/Upload/upload.py` spawn worker processes via `ProcessPoolExecutor`. Subprocess workers cannot be tracked by the coverage tool. Coverage for the main-process loop (submit, `as_completed`, result dispatch) is achieved by patching `ProcessPoolExecutor` and `as_completed` in tests; worker functions (`_worker_init`, `_parse_xml_task`, `_parse_xml_batch`) are tested directly in-process in `test_upload_worker.py`.

## Notes on URL Ingest Coverage

The URL ingest path (`_cmd_ingest_url` / `_ingest_one_remote`) is tested in `tests/test_cli.py` (`TestIngestUrl`) by patching `ingest.sources.discover_zip_urls` and `ingest.sources.download_zip` so no network I/O happens — the download stand-in writes a real (or deliberately corrupt) ZIP into the cache dir. Tests use a **file-backed** `ScoreDatabase` in a temp dir (rather than `:memory:`) so the `ingested_zip` records can be re-opened and asserted after the run closes the connection — exercising the skip/`--force` resume behavior. `src/sources.py` itself is unit-tested in `tests/test_sources.py` by patching `sources.urlopen` with a fake response object.

## Test Patterns

**In-memory database**: Most database tests use `IRS990Database(path=":memory:")` to avoid touching the filesystem.

**Mock DB for engine tests**: `ScoringEngine` is initialized with `db=MagicMock()` so individual formula and normalization methods can be tested without any database layer.

**Module-level state**: `upload.py` uses module globals (`_xpath_index`, `_supported_forms`) set per worker process. Tests call `upload_mod._worker_init(...)` in `setUp` to populate them. (Workers no longer cache ZIP handles — they receive already-read bytes — so there is no `_zip_cache` to reset.)
