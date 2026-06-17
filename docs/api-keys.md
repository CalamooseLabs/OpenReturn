# API Keys

When the server is started with `--auth` (or `services.openreturn.auth = true` in NixOS), all routes require authentication. API keys authenticate **programs** (e.g. the frontend); **users** log in for a session key instead (see [Access Control](access-control.md)).

## Roles

Each key is bound to a **role** that grants its permissions (`--role`, default `service` — a restricted read-only role). Use a richer role only when a program genuinely needs to write:

```bash
openreturn keys create "Dashboard"                 # service (restricted read-only)
openreturn keys create "import-bot" --role editor  # can write
```

`openreturn users roles` lists the available roles and their permissions. See [Access Control](access-control.md) for the role/permission model.

## Managing Keys

Keys are managed with the `openreturn keys` subcommand, run from the directory where `OpenReturn.db` lives:

```bash
# Create a key (unlimited rate, service role, by default)
openreturn keys create "Dashboard"

# Create a key with a per-minute rate limit and a role
openreturn keys create "CI pipeline" --rate-limit 60 --role service

# List all keys (shows each key's role)
openreturn keys list

# Revoke a key by ID (shown in the list)
openreturn keys revoke 3
```

The `create` command prints the raw key exactly once — it is not recoverable after that. Store it immediately.

## Sending Requests

Include the key in any request using either header — both are accepted:

```
Authorization: Bearer <key>
X-API-Key: <key>
```

A `401 Unauthorized` is returned if the key is missing, invalid, or revoked.

## Rate Limiting

Each key can have an optional per-minute request limit set at creation time. Rate limiting uses a fixed 60-second window.

When the limit is exceeded the server returns:

```
429 Too Many Requests
Retry-After: 60
```

A rate limit of `-1` (the default) means unlimited.

## How Keys Are Stored

Keys are stored as SHA-256 hashes in the database. The raw key is never persisted after creation. Validation results are cached in memory for the duration of the server process; the cache is cleared when a key is revoked so the next request re-validates against the database.
