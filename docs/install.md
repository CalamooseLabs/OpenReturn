# Installation & Setup

## Prerequisites

- [Nix](https://nixos.org/download/) with flakes enabled
- `x86_64-linux` — the flake is hardcoded to this platform; other architectures require modifying `flake.nix`

## Development Environment

```bash
# Load dev shell (first time or after flake.lock changes)
nix flake update && direnv reload

# Or just drop into the shell directly
nix develop
```

All commands below assume the dev shell is active.

## Database Initialization and Migrations

Before starting the server for the first time, initialize the database:

```bash
# Create OpenReturn.db with the full schema and seed data (990/990EZ/990N/990PF/990T)
python3 src/cli.py init

# Apply any pending schema migrations (safe to run on every deploy)
python3 src/cli.py migrate

# List migration status without applying
python3 src/cli.py migrate --list
```

Both commands default to `./OpenReturn.db` and accept an explicit path:

```bash
python3 src/cli.py init    --db /var/lib/openreturn/OpenReturn.db
python3 src/cli.py migrate --db /var/lib/openreturn/OpenReturn.db
```

`init` is idempotent — it skips inserts if the database already exists and is populated. `migrate` tracks applied migrations in a `migration` table and never re-runs the same migration.

## Running the Server

```bash
# Default: localhost:8080
python3 src/cli.py serve

# Options
python3 src/cli.py serve --host 0.0.0.0 --port 9000
python3 src/cli.py serve --debug          # verbose per-request logging (ANSI colored)
python3 src/cli.py serve --auth           # require a valid API key on all routes

# Testing mode: ingest ZIPs, print DB state, exit (no persistent server)
python3 src/cli.py serve --testing --zip-dir /path/to/zips
```

## Ingesting Form 990 ZIPs

The `openreturn ingest` subcommand processes IRS TEOS ZIP archives and loads all 990 XML filings into the database. The source is a **local directory** of `.zip` files or an **`http(s)://` URL** (a direct `.zip` link or the IRS Form 990 downloads page).

```bash
# Ingest a directory of ZIPs (parallel workers by default)
python3 src/cli.py ingest /path/to/zip-dir/

# Limit worker count
python3 src/cli.py ingest --workers 8 /path/to/zip-dir/

# Sequential (one file at a time)
python3 src/cli.py ingest --workers 1 /path/to/zip-dir/

# Print a per-phase wall-clock breakdown (read / insert / resolve / …)
python3 src/cli.py ingest --profile /path/to/zip-dir/

# Ingest straight from the IRS — discovers every .zip on the page, skips ones
# already ingested, downloads/ingests/deletes each in turn
python3 src/cli.py ingest https://www.irs.gov/charities-non-profits/form-990-series-downloads

# Dry run: list discovered archives and which are already ingested
python3 src/cli.py ingest --list https://www.irs.gov/charities-non-profits/form-990-series-downloads
```

For URL sources: `--force` re-ingests archives already recorded as processed, `--cache-dir DIR` downloads into a directory you control, and `--keep-downloads` retains the `.zip` files instead of deleting them after ingest. See [ingest.md](ingest.md#ingesting-from-a-url) for details.

The ingest process:
1. Opens each ZIP and lists `.xml` member files
2. Parses each XML: extracts EIN, name, tax year, form code, and all recognized XPath field values
3. Upserts organization, creates filing record, stores field values
4. Skips unsupported form types (anything other than 990, 990EZ, 990PF, 990T)
5. Deduplicates: if a filing for the same EIN + year already exists the ingested data lands under the existing UUID

Progress is shown per-ZIP with a bar and counts of stored/skipped/errored files.

## Database Encryption (optional)

If an encryption key is provided, the database is encrypted with AES-256 via SQLCipher. The key can be supplied two ways:

- **`DB_SECRET_KEY`** — the key directly. Create a `.env` file in the working directory:

  ```bash
  DB_SECRET_KEY=your-secret-passphrase
  ```

  `openreturn` reads `.env` on startup with `setdefault` semantics (existing env vars are never overridden).

- **`DB_SECRET_KEY_FILE`** — a path to a file whose contents are the key (trailing whitespace stripped). Use this for runtime secrets that should never sit in an environment variable or config file — systemd credentials, Docker/Compose secrets, agenix/sops-nix, etc. If both are set, `DB_SECRET_KEY` wins.

The `nix build` package bundles the `sqlcipher3` binding, so encryption works out of the box; in a bare Python environment without `sqlcipher3` a warning is printed and the database remains unencrypted. The key must stay stable — SQLCipher cannot open a database created with a different key.

On NixOS, set the key declaratively via `services.openreturn.database.secretKeyFile` (recommended) or `database.secretKey`; see [nixos.md](nixos.md#database-encryption).

## Building the Package

```bash
nix build
# Produces result/bin/openreturn — the unified CLI
```

## Linting & Formatting

```bash
ruff check src/
ruff format src/
```
