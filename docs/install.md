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

The `openreturn ingest` subcommand processes IRS TEOS ZIP archives and loads all 990 XML filings into the database.

```bash
# Ingest a directory of ZIPs (parallel workers by default)
python3 src/cli.py ingest /path/to/zip-dir/

# Limit worker count
python3 src/cli.py ingest --workers 8 /path/to/zip-dir/

# Sequential (one file at a time)
python3 src/cli.py ingest --workers 1 /path/to/zip-dir/
```

The ingest process:
1. Opens each ZIP and lists `.xml` member files
2. Parses each XML: extracts EIN, name, tax year, form code, and all recognized XPath field values
3. Upserts organization, creates filing record, stores field values
4. Skips unsupported form types (anything other than 990, 990EZ, 990PF, 990T)
5. Deduplicates: if a filing for the same EIN + year already exists the ingested data lands under the existing UUID

Progress is shown per-ZIP with a bar and counts of stored/skipped/errored files.

## Database Encryption (optional)

If a `DB_SECRET_KEY` is set, the database will be encrypted with AES-256 via SQLCipher. Create a `.env` file in the working directory:

```bash
DB_SECRET_KEY=your-secret-passphrase
```

`openreturn` reads `.env` on startup with `setdefault` semantics (existing env vars are never overridden). Requires `sqlcipher3` to be installed — without it, a warning is printed and the database remains unencrypted.

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
