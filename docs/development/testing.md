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
| `tests/test_database.py` | `src/database/openreturn.py` + the per-concern subclasses (`Schema/`, `Organization/`, `Filing/`, `ReportedData/`, `ApiKey/`, `Ingest/`, `Migration/`) |
| `tests/test_score_database.py` | `src/database/Score/score.py` |
| `tests/test_scoring_search.py` | post-ingest scoring hook + `src/scores.py` CLI + batch `ScoringEngine.rebuild` + `db.orgs` search/address |
| `tests/test_expanded_forms.py` | `src/database/Schema/sql/populate/*.sql` (990-EZ/N/PF/T schema) |
| `tests/test_db_commands.py` | `src/db.py` (`init`, `migrate`, `reset`, `analyze`) |
| `tests/test_threading.py` | `src/database/base.py` (per-thread connections) + `src/server/server.py` (`PooledHTTPServer` bounds + closes connections) |
| `tests/test_ranking.py` | `src/database/Score/score.py` ranking (live window + the `org_score_latest` cache fast-path, cache↔fallback equivalence) |
| `tests/test_cli.py` | `src/ingest.py` (directory **and** URL paths) |
| `tests/test_ingest_manage.py` | `src/ingest.py` (forget/purge/list management flags) + `src/database/Score/score.py` purge + `src/database/Ingest/ingest.py` |
| `tests/test_status.py` | `src/status.py` |
| `tests/test_daemon.py` | `src/daemon.py` (double-fork, pidfile, cooperative stop) |
| `tests/test_openreturn_cli.py` | `src/cli.py` (unified dispatch, incl. `status`/`reset`/ingest mgmt flags) |
| `tests/test_sources.py` | `src/sources.py` |
| `tests/test_upload_worker.py` | `src/router/Upload/upload.py` |
| `tests/test_upload_router.py` | `src/router/Upload/upload.py` (the `/upload/ingested`, `/upload/discover`, `/upload/grab` IRS-grab routes) |
| `tests/test_org_router.py` | `src/router/Org/org.py` |
| `tests/test_filing_router.py` | `src/router/Filing/filing.py` (incl. `archives_summary`) |
| `tests/test_score_router.py` | `src/router/Score/score.py` |
| `tests/test_score_debug.py` | `src/scoring/engine.py` (`debug()` walkthrough) + `GET /scores/debug` + `get_field_source` |
| `tests/test_model_types.py` | model types + manual scoring: `src/models.py` (manual TOML), `src/scoring/engine.py` (`_normalize_manual`/`grade`), `src/database/Score/score.py` |
| `tests/test_sector.py` | sector classification: `src/database/Organization/organization.py` (NTEE seed, `sector_code` on create/update, `sector`/search filter, `list_sectors`) + the `/organizations/sectors` route |
| `tests/test_counties.py` | county deduction: `src/counties.py` (`parse_crosswalk` + the `counties import/derive` CLI) and `src/database/Organization/organization.py` (`import_zip_county`/`derive_counties`, county search + `list_counties`) |
| `tests/test_ranking.py` | query-time ranking: `src/database/Score/score.py` (`rank_leaderboard`/`rank_org`/`rank_org_dimensions`, the subset-rank invariant) + the `/scores/leaderboard` + `/scores/ranking` routes |
| `tests/test_foundations.py` | foundation/nonprofit classification: `src/database/Organization/organization.py` (`classify_organizations`, `org_type`/`is_grantmaker`, type/grantmaker search filters), `src/database/Appearance/appearance.py` (`grants_made`/`grants_received`), and the `/organizations/grants` route + `following` flag |
| `tests/test_follow.py` | per-user watchlist: `src/database/Follow/follow.py` (follow/unfollow/list/`followed_eins`/cascade) + `src/router/Follow/follow.py` + the seeded `follow:*` permissions |
| `tests/test_missing_data.py` | missing-data fallbacks: `src/scoring/engine.py` (`parse_inputs`, `_pick_donor_year`, `_resolve_input_filled`, two-pass `score_org` fill + composite propagation, `calculate`/`debug` fill) + `src/database/Score/score.py` (`list_score_history`, imputed/source_year columns) + `src/models.py` per-input/`missing_data` validation |
| `tests/test_model_kinds.py` | model kinds (model/composite/super_composite): `src/models.py` (kind validation + cross-model registration), `src/scoring/engine.py` (`model:<version>` resolution, dependency ordering, composite scoring), `src/database/Score/score.py` (`list_model_kinds`/`model_kind`), `GET /scores/kinds`, and the bundled template catalog (`src/templates/*.toml`) |
| `tests/test_templates.py` | model-template catalog: `src/templates/` loader + `openreturn templates` CLI, `src/router/Templates/templates.py` (read routes), and the template→`register_model` round-trip |
| `tests/test_openapi.py` | `src/openapi.py` (spec + route-coverage + committed `openapi.json` sync) |
| `tests/test_api_keys.py` | `src/keys.py` + `src/database/ApiKey/api_key.py` (key roles) |
| `tests/test_users.py` | auth core: `src/auth.py` (scrypt/tokens/Principal), `src/database/User/user.py` (accounts/roles/permissions/sessions/`authenticate`), `src/router/Auth/auth.py` (login/logout/me), and the `openreturn users` CLI (`src/users.py`) |
| `tests/test_org_crud.py` | editable orgs: `src/database/Organization/organization.py` (`normalize_ein`/`create_org`/`update_org`, physical+mailing address) + `src/database/Audit/audit.py` (audit entries) |
| `tests/test_people.py` | People concern: `src/database/People/people.py` (person CRUD + org membership upsert/cascade) and `src/router/People/people.py` (routes + permissions) |
| `tests/test_tags_lists.py` | Tags + Lists: `src/database/Tags/tags.py` (apply/remove, `orgs_with_tags` any/all), `src/database/Lists/lists.py` (static + smart-by-tag, private/public owner scoping), and the `/tags` + `/lists` routers |
| `tests/test_admin.py` | admin HTTP management: `src/database/User/user.py` (`create_role`/`delete_role`/`create_permission`) and `src/router/Admin/admin.py` (`/admin/*`, all `user:admin`, audited) |
| `tests/test_financials.py` | unified financial layer: `src/database/Financials/financials.py` (concepts seeded from `_PATHS`, 990 derivation + score equality, conflict + manual canonical, non-990 scoring) and `src/router/Financials/financials.py` |
| `tests/test_ocr.py` | `src/ocr.py` — tesseract TSV parsing, label→concept extraction with per-reading confidence, and recording OCR observations (`ocr_990_pdf`); the live test skips when the OCR binaries are absent |
| `tests/test_server_auth.py` | `src/server/server.py` (auth/rate-limit paths) |
| `tests/test_server_coverage.py` | `src/server/server.py` (request handling, formats, errors) |
| `tests/test_serve_instance.py` | `src/main.py` `cmd_serve` (single-instance guard, server.pid) |
| `tests/test_ingest_schedule.py` | `src/ingest.py` `--schedule` / `--restart-server` helpers |
| `tests/test_build_wiki.py` | `tools/build_wiki.py` (docs/ → GitHub wiki transform: slugify, link rewrite/validate, H1 strip, sidebar/footer) |
| `tests/test_graph_layer.py` | `src/parser/groups.py` (repeating-group extraction) + `src/database/Appearance/appearance.py` (store/resolve/read of people/grant/related-org edges) + `src/ingest.py` bulk-graph flush (`buffer_graph`/`_flush_graph`/`_resolve_appearance_ids`) + `src/resolve.py` (`openreturn resolve`) + `ScoreDatabase._migrate_filing_key` (legacy score-key migration) + `OrganizationDatabase._migrate_schema` (address foreign-column ALTER) |

## Notes on Parallel Ingest Coverage

`src/ingest.py` and `src/router/Upload/upload.py` spawn worker processes via `ProcessPoolExecutor`. Subprocess workers cannot be tracked by the coverage tool. Coverage for the main-process loop (submit, `as_completed`, result dispatch) is achieved by patching `ProcessPoolExecutor` and `as_completed` in tests; worker functions (`_worker_init`, `_parse_xml_task`, `_parse_xml_batch`) are tested directly in-process in `test_upload_worker.py`.

## Notes on URL Ingest Coverage

The URL ingest path (`_cmd_ingest_url` / `_ingest_one_remote`) is tested in `tests/test_cli.py` (`TestIngestUrl`) by patching `ingest.sources.discover_zip_urls` and `ingest.sources.download_zip` so no network I/O happens — the download stand-in writes a real (or deliberately corrupt) ZIP into the cache dir. Tests use a **file-backed** `ScoreDatabase` in a temp dir (rather than `:memory:`) so the `ingested_zip` records can be re-opened and asserted after the run closes the connection — exercising the skip/`--force` resume behavior. `src/sources.py` itself is unit-tested in `tests/test_sources.py` by patching `sources.urlopen` with a fake response object.

## Test Patterns

**In-memory database**: Most database tests use `OpenReturnDB(path=":memory:")` to avoid touching the filesystem.

**Mock DB for engine tests**: `ScoringEngine` is initialized with `db=MagicMock()` so individual formula and normalization methods can be tested without any database layer.

**Module-level state**: `upload.py` uses module globals (`_xpath_index`, `_supported_forms`) set per worker process. Tests call `upload_mod._worker_init(...)` in `setUp` to populate them. (Workers no longer cache ZIP handles — they receive already-read bytes — so there is no `_zip_cache` to reset.)
