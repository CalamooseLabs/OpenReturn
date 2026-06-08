# OpenReturn

IRS Form 990 parser and API backend. Ingests ZIP archives of Form 990 XML filings (990, 990-EZ, 990-N, 990-PF, 990-T), extracts field values via XPath, stores them in SQLite, and exposes a REST API for querying organizations, filings, and financial health scores.

## Quick Start

```bash
nix develop              # enter dev environment (requires Nix with flakes)
python3 src/main.py      # start server on localhost:8080
```

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
