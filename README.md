# OpenReturn

IRS Form 990 parser and API backend. Ingests ZIP archives of Form 990 XML filings (990, 990-EZ, 990-N, 990-PF, 990-T), extracts field values via XPath, stores them in SQLite, and exposes a REST API for querying organizations, filings, and financial health scores.

## Quick Start

```bash
nix develop              # enter dev environment (requires Nix with flakes)
python3 src/cli.py serve # start server on localhost:8080
```

The running server publishes an OpenAPI 3.1 spec at `/openapi.json` and interactive docs at `/docs` (or run `openreturn openapi` to dump the spec).

## Documentation

| Doc | Contents |
|-----|----------|
| [Installation & Setup](docs/install.md) | Dev environment, running locally, ingest CLI, building |
| [Ingest & Upload](docs/ingest.md) | How bulk ingest works, upload endpoint, server impact, after-hours guidance |
| [NixOS Module](docs/nixos.md) | Deploying as a NixOS service, module options |
| [API Reference](docs/api.md) | Full REST endpoint documentation |
| [API Keys](docs/api-keys.md) | Key management CLI, rate limiting |
| [Scoring Models](docs/scoring/models.md) | TOML format, formula types, input keys |
| [Testing](docs/development/testing.md) | Running tests, coverage |
| [Architecture](docs/development/architecture.md) | Class design, internals, non-obvious details |

The docs include mermaid diagrams (architecture, DB schema, ingest/scoring workflows) that render on GitHub. They also publish as a **GitHub wiki**: `python3 tools/build_wiki.py` renders `docs/` into wiki pages, and `tools/publish_wiki.sh <repo>.wiki.git` pushes them. `docs/` stays the single source of truth — don't hand-edit the wiki.
