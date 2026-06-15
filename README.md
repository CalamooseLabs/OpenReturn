# OpenReturn

IRS Form 990 parser and API backend. Ingests ZIP archives of Form 990 XML filings (990, 990-EZ, 990-N, 990-PF, 990-T), extracts field values via XPath, stores them in SQLite, and exposes a REST API for querying organizations, filings, and financial health scores.

## Quick Start

```bash
nix develop              # enter dev environment (requires Nix with flakes)
python3 src/cli.py serve # start server on localhost:8080
```

A machine-readable **OpenAPI 3.1** spec is committed at [`openapi.json`](openapi.json) (regenerate with `openreturn openapi -o openapi.json`).

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

The docs render on GitHub as-is, including the mermaid diagrams (architecture, database schema, ingest/scoring workflows). They are also published to the project's **[Wiki](https://github.com/CalamooseLabs/OpenReturn/wiki)** (a separate `…​.wiki.git` repo). `docs/` stays the single source of truth — don't hand-edit the wiki.

The dev-shell command `publish-wiki [<repo>.wiki.git]` runs `tools/build_wiki.py`, which transforms the repo-friendly docs into a wiki: it flattens the nested pages into the wiki's flat namespace, rewrites the relative `.md` links to wiki page slugs, drops the redundant per-page title (the wiki shows the filename as the title), generates `_Sidebar.md`/`_Footer.md` navigation, validates every internal link and anchor, and pushes.
