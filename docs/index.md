# OpenReturn Documentation

**OpenReturn** is an IRS Form 990 parser and JSON REST API. It ingests Form 990 XML filings (990, 990-EZ, 990-N, 990-PF, 990-T), extracts field values via XPath into SQLite, and serves organizations, filings, and financial-health scores over HTTP.

New here? Install with **[Installation & Setup](install.md)**, load data with **[Ingest & Upload](ingest.md)**, then explore the **[API Reference](api.md)**. The machine-readable [OpenAPI 3.1 spec](../openapi.json) is the source of truth for integrators.

| Doc | Contents |
|-----|----------|
| [Installation & Setup](install.md) | Dev environment, running locally, building, ingest CLI |
| [Ingest & Upload](ingest.md) | How bulk ingest works, upload endpoint, server impact, after-hours guidance |
| [NixOS Module](nixos.md) | Deploying as a NixOS service, module options, restart behavior |
| [API Reference](api.md) | Full REST endpoint docs with request/response shapes |
| [API Keys](api-keys.md) | Key management CLI, rate limiting, auth headers |
| [Scoring Models](scoring/models.md) | TOML format, all formula types, input keys, normalization |
| [Testing](development/testing.md) | Running tests, coverage, test file structure |
| [Architecture](development/architecture.md) | Layer design, class deep-dives, non-obvious internals |
