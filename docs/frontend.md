# Frontend Integration Guide

How to build a frontend (or AI-scaffolded client) against the OpenReturn API: the
data model, the auth flow, the call recipes for common screens, the conventions
(errors, pagination, permissions), and how to generate a typed client. The full
per-endpoint reference is the [API Reference](api.md); this page is the *how to use
it* layer.

## Start here: the contract is self-serving

The running server publishes its own contract and health — **no auth required**:

| Endpoint | Returns |
|----------|---------|
| `GET /openapi.json` | the live OpenAPI 3.1 spec (`servers[0].url` is the host you reached it on) |
| `GET /health` | `{ "status": "ok", "version": "…" }` — liveness probe |
| `GET /version` | `{ "name": "openreturn", "version": "…" }` |

**CORS** is enabled: a browser SPA can call the API cross-origin. Auth is
header-based (not cookies), so the default allowed origin is `*`; a deployment may
restrict it (`--cors-origin` / the NixOS `corsOrigins` option). Preflight `OPTIONS`
is answered automatically.

### Generate a typed client

Point any OpenAPI generator at the committed `openapi.json` (or the live
`/openapi.json`). For TypeScript:

```bash
npx openapi-typescript http://localhost:8080/openapi.json -o src/api/openreturn.d.ts
# or from the committed file:
npx openapi-typescript ./openapi.json -o src/api/openreturn.d.ts
```

Then a fetch wrapper that injects the auth header (below) gives you typed requests
and responses. The spec is the single source of truth — it is regenerated and
route-coverage-tested on every change, so it never drifts from the server.

## Authentication

Two kinds of caller authenticate with the **same header** — `Authorization: Bearer
<token>` (or `X-API-Key: <token>`):

- **Users** log in for a **session key**; carry it on every request.
- **Programs** (e.g. your server-side BFF) use a **role-bound API key**.

```
POST /auth/login   { "username": "...", "password": "..." }
                 → { "session_key": "…", "expires_at": "…", "user": {…}, "principal": {…} }
# then on every request:
Authorization: Bearer <session_key>

GET  /auth/me      → the current principal (who am I + my permissions)
POST /auth/logout  → end the session
```

When the server runs **without `--auth`** every route is open (dev mode). With
`--auth`, a protected route returns **401** (no/invalid token), **403** (authenticated
but missing the route's permission), or **429** (rate-limited). See
[Access Control](access-control.md).

## Conventions

- **Errors**: a non-2xx body is always `{ "error": "<message>" }`. A
  *successful-status* response may still carry an `error` key for soft validation
  failures (e.g. a bad query param) — check for `error` before using a result. See
  [Error Responses](api.md#error-responses).
- **Pagination**: list endpoints take `limit` (default 50, max 500) + `offset` and
  return `{ total, limit, offset, organizations: […] }` (or the relevant array).
- **EINs**: 9 digits; a hyphen is accepted on input and normalized.
- **`following`**: org responses include this per-user boolean (false for a
  program/no-auth caller) so you can render Follow vs Following.

## Vocabularies (enumerations)

Rather than hard-code these, fetch them (they're stable but discoverable):

| Vocabulary | Values | Source endpoint |
|------------|--------|-----------------|
| Org type | `foundation` / `nonprofit` / `other` / `null` | on every org (`org_type`) — see [Foundations & Grants](foundations.md) |
| Sector | NTEE major groups `A`–`Z` (`{code, name, parent_code}`) | `GET /organizations/sectors` (assigned via `sector_code`) |
| State / City / County | as present in filer addresses | `GET /organizations/states` · `/cities?state=` · `/counties?state=` |
| Model kind | `model` / `composite` / `super_composite` | `GET /scores/kinds` |
| Model type | `financial` / `governance` / … | `GET /scores/types` |
| Scoring mode | `computed` / `manual` | on each model |
| Financial source | `irs_990_xml` / `audited_statement` / `manual_990` / `ocr_990_pdf` / `irs_regrab` | `GET /financials/sources` |
| Missing-data strategy | `none` / `newest` / `oldest` / `closest_older` / `closest_newer` / `value:<x>` | [Scoring Models](scoring/models.md#missing-data-fallbacks-completing-a-multi-year-history) |
| Roles / permissions | (deployment-defined) | `openreturn users roles` (CLI) / [Access Control](access-control.md) |

## Screen → calls recipes

**Organization dashboard** (one org):
1. `GET /organizations/full?ein=…` — name, contacts, addresses, filings, `org_type`,
   `is_grantmaker`, `following`.
2. `GET /scores/history?ein=…&version=30` — the multi-year Overall Score series
   (years flagged `imputed` carry a `source_year`).
3. `GET /financials?ein=…&year=…` — the canonical financial facts (+ conflicts).
4. `GET /organizations/grants?ein=…&direction=made` (or `received`) — grant activity.
5. `POST /follows/follow { ein }` — add to the user's watchlist.

**Multi-year history table** (MinistryWatch-style): `GET /scores/history?ein=&version=`
returns one row per year with `total_score` + `imputed` + `source_year`. Render
imputed years as "estimated". Compare models with `GET /scores/compare?ein=&year=`.

**Foundation explorer**: `GET /organizations/search?type=foundation&state=TX` →
for a chosen foundation, `GET /organizations/grants?ein=…&direction=made` shows which
nonprofits it funds. (990-PF grantee EINs link only after `openreturn resolve`.)
Follow foundations and list them with `GET /follows?type=foundation`.

**Discovery / prospecting**: `GET /organizations/similar?ein=…` (ranked peers) and
`GET /organizations/network?ein=…` (co-funding graph reach).

**Browse by sector & region**: populate dropdowns from `GET /organizations/sectors`,
`/organizations/states`, `/organizations/cities?state=`, and
`/organizations/counties?state=`, then filter:
`GET /organizations/search?sector=E&state=TX&county=48453`. Assign a sector with
`POST /organizations/edit { ein, sector_code }` (`org:write`). County is deduced
from the filer ZIP and is blank until an operator runs
`openreturn counties import <HUD crosswalk>`.

**Leaderboards & rankings**: `GET /scores/leaderboard?model=30&limit=50` is a ranked,
paginated page; add any subset filter to rank *within* it —
`?sector=E`, `?state=TX`, `?county=48453`, `?type=foundation`, `?list=<id>`,
`?grantmaker=1` — or `?year=2023` to rank a fixed year instead of each org's latest.
For one org's standing on its page, `GET /scores/ranking?ein=…&model=30` returns its
rank in global + its own sector / state / city / county at once (each
`{rank, of, percentile}`). Works the same for base, composite, and super-composite
models. See [Scoring Models → Ranking](scoring/models.md#ranking-leaderboards).

**Conflict-resolution UI** (data stewardship): `GET /financials/conflicts?ein=…`
lists facts where sources disagree; `POST /financials/canonical { ein, fiscal_year,
concept, observation_id }` picks the value the models use.

**Model builder** (requires `user:admin`): `GET /templates` lists the prefill
catalog; `GET /templates/detail?code=…` returns a `{model, factor}` definition to
seed the editor; `GET /admin/models` shows existing models (a composite picks
children from these); `POST /admin/models { definition, dry_run? }` validates
(`dry_run`) and creates. See [Scoring Models → Templates](scoring/models.md#templates--the-model-builder).

**Admin panel** (requires `user:admin`): `GET/POST /admin/users`, `/admin/roles`,
`/admin/permissions` — see [Access Control](access-control.md).

**Ingest / grab-from-IRS** (requires `upload:write`): `GET /upload/ingested` shows
what's been grabbed and ingested (the URL ledger + a `filing`-table archive
summary + whether an ingest is live); `POST /upload/discover { url? }` previews the
`.zip` archives at a URL (default the IRS downloads page); `POST /upload/grab
{ url, force? }` starts a detached background ingest of that URL. The grab briefly
restarts the API server to take the DB lock, so tolerate a short "API not
responding" window and poll `/upload/ingested`. See
[Ingest → Grabbing from the IRS website](ingest.md#grabbing-from-the-irs-website-admin).

## Permissions by area

Each route declares the permission it needs; the built-in roles bundle them. A
quick map (full detail in [Access Control](access-control.md)):

| Area | Read | Write |
|------|------|-------|
| Organizations / search / grants | `org:read` | `org:write` |
| Filings | `filing:read` | `filing:write` |
| Scores / history | `score:read` | `score:write` |
| Templates (catalog) | `score:read` | — |
| Model builder (create models) | — | `user:admin` |
| Financial data | `data:read` | `data:write` |
| People · Tags · Lists | `*:read` | `*:write` |
| Follows (watchlist) | `follow:read` | `follow:write` |
| Admin (users/roles/perms) | — | `user:admin` |
| Upload (ZIP / PDF) · grab-from-IRS (`/upload/ingested` · `/upload/discover` · `/upload/grab`) | — | `upload:write` |

A typical read-only frontend uses a `viewer` user (all reads + manage their own
watchlist); a server-side integration uses a `service` API key (restricted reads).
