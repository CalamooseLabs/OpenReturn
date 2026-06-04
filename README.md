# OpenReturn

IRS Form 990 parser and API backend. Ingests ZIP archives of Form 990 XML filings (990, 990-EZ, 990-N, 990-PF, 990-T), extracts field values via XPath, stores them in SQLite, and exposes a REST API for querying organizations, filings, reported data, and financial scores.

## NixOS

OpenReturn ships a NixOS module. Add the flake as an input and enable the service:

```nix
# flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    openreturn.url = "github:your-org/OpenReturn";
    openreturn.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, openreturn, ... }: {
    nixosConfigurations.myhost = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        openreturn.nixosModules.default
        {
          services.openreturn = {
            enable = true;
            host = "0.0.0.0";
            port = 8080;
          };
        }
      ];
    };
  };
}
```

### Module options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `enable` | bool | `false` | Enable the service |
| `package` | package | flake default | Override the openreturn package |
| `host` | string | `"localhost"` | Bind address |
| `port` | port | `8080` | Bind port |
| `debug` | bool | `false` | Verbose request/response logging |
| `dataDir` | string | `"/var/lib/openreturn"` | Directory where `IRS990.db` is stored |
| `user` | string | `"openreturn"` | Service user |
| `group` | string | `"openreturn"` | Service group |

The service runs as a dedicated system user with a hardened systemd unit (`NoNewPrivileges`, `PrivateTmp`, `ProtectSystem = strict`). The database file is written to `dataDir`, which is managed by systemd's `StateDirectory`.

> **Note:** The flake is currently hardcoded to `x86_64-linux`. Other platforms require modifying `flake.nix`.

## Running

```bash
# Enter dev environment
nix develop

# Start the server (default: localhost:8080)
python3 src/main.py

# Options
python3 src/main.py --host 0.0.0.0 --port 9000 --debug
python3 src/main.py --testing --zip-dir /path/to/zips   # ingest ZIPs, dump DB state, exit
```

## Routes

### Upload — `POST /upload`

| Method | Path | Description |
|--------|------|-------------|
| `GET` | `/upload` | Upload form (HTML) |
| `POST` | `/upload` | Upload a ZIP of Form 990 XMLs (`multipart/form-data`) |

### Organizations — `GET /irs990/organizations`

| Method | Path | Params | Description |
|--------|------|--------|-------------|
| `GET` | `/irs990/organizations` | — | List all organizations |
| `GET` | `/irs990/organizations/detail` | `ein` | Get organization by EIN |
| `GET` | `/irs990/organizations/full` | `ein` | Organization + all filings with links |
| `POST` | `/irs990/organizations` | body: `{ein, name}` | Create or update organization |

### Filings — `/irs990/filings`

| Method | Path | Params | Description |
|--------|------|--------|-------------|
| `GET` | `/irs990/filings` | `ein` | List filings for an organization |
| `GET` | `/irs990/filings/detail` | `filing_id` | Get filing metadata |
| `GET` | `/irs990/filings/data` | `filing_id`, `format`\* | Get all reported field values for a filing |
| `GET` | `/irs990/filings/lookup` | `ein`, `year`, `format`\* | Get filing data by EIN + tax year |
| `POST` | `/irs990/filings` | body: `{ein, year, form_code}` | Create filing |
| `POST` | `/irs990/filings/data` | body: `{filing_id, values: {field_id: value}}` | Store reported field values |

\* `format`: `json` (default), `md`, or `html`

### Scores — `/scores`

| Method | Path | Params | Description |
|--------|------|--------|-------------|
| `GET` | `/scores` | `ein` | List all scores for an organization |
| `GET` | `/scores/filing` | `filing_id` | Get score for a specific filing |
| `GET` | `/scores/detail` | `score_id` | Get score with full factor breakdown |
| `GET` | `/scores/lookup` | `ein`, `year` | Get score by EIN + tax year |
| `GET` | `/scores/factors` | `version` (default: 1) | List scoring factors for a model version |
| `POST` | `/scores` | body: `{filing_id, model_version?}` | Create a score record |
| `POST` | `/scores/factors` | body: `{score_id, values: [{factor_id, raw_value, weighted_value}]}` | Store factor values |
| `POST` | `/scores/finalize` | body: `{score_id, total_score}` | Set the final score |
| `POST` | `/scores/calculate` | body: `{ein, year, model_version?}` | Full pipeline: parse reported data → compute score |
