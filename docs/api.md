# OpenReturn API

## Overview

OpenReturn exposes a JSON REST API for querying IRS Form 990 filings, organizations, and financial health scores.

**Base URL:** `http://<host>:<port>` (default `http://localhost:8080`)

All responses are `application/json` unless a `format` parameter requests an alternate representation.

---

## OpenAPI Specification

The full API is described by a machine-readable **OpenAPI 3.1** document committed at [`openapi.json`](../openapi.json) in the repository root — point code generators, Postman, or `editor.swagger.io` at the raw file. Regenerate it after changing routes:

```bash
openreturn openapi                 # print to stdout
openreturn openapi -o openapi.json # write the committed file
openreturn openapi --compact       # minified
```

The sections below are the human-readable reference; the OpenAPI document is the source of truth for integrators. A test asserts it covers exactly the registered routes and that the committed `openapi.json` is up to date, so it can't drift.

---

## Authentication

When the server is started with `--auth`, every route is permission-gated. There
are two kinds of caller, both sending their key in either header (both accepted):

```
Authorization: Bearer <key>
X-API-Key: <key>
```

- **Users** log in at **`POST /auth/login`** with a username + password and get a
  **session key**. `GET /auth/me` reports the caller; `POST /auth/logout` revokes
  the session. User accounts are created/reset with the `openreturn users` CLI —
  there is no HTTP route to create a user or reset a password.
- **Programs** (e.g. the frontend) use an **[API key](api-keys.md)** bound to a
  role (default `service`, a restricted read-only role).

Each route requires one permission (e.g. `org:write`). Access is allowed when the
caller's roles grant it, else **403**; a missing/invalid key is **401**. See
**[Access Control](access-control.md)** for roles, permissions, sessions, and the
`openreturn users` CLI.

### Auth endpoints

| Method & path | Auth | Body / result |
|---------------|------|---------------|
| `POST /auth/login` | public | `{username, password}` → `{session_key, expires_at, user}` |
| `POST /auth/logout` | session | revokes the caller's session → `{logged_out}` |
| `GET /auth/me` | any principal | `{kind, label, permissions, user}` |

---

## Rate Limiting

Each key can have an optional per-minute request limit set at creation time. When the limit is exceeded the server returns `429` with a `Retry-After: 60` header. Keys created without a limit (`-1`) have no ceiling.

---

## Error Responses

All errors return JSON with a single `error` field:

```json
{ "error": "description of the problem" }
```

| Status | Meaning |
|--------|---------|
| 400 | Bad request (malformed body or missing required fields) |
| 401 | Missing or invalid API key |
| 404 | Route or resource not found |
| 413 | Request body exceeds 50 MB |
| 429 | Rate limit exceeded |
| 500 | Internal server error |

---

## Organizations

### `GET /organizations`

List organizations with optional name search and pagination.

**Query parameters**

| Param | Type | Default | Description |
|-------|------|---------|-------------|
| `search` | string | — | Case-insensitive substring match on organization name |
| `type` | string | — | Filter by `org_type`: `foundation` / `nonprofit` / `other` (see [Foundations & Grants](foundations.md)) |
| `grantmaker` | boolean | — | Truthy → only grantmaking orgs (`is_grantmaker`) |
| `sector` | string | — | Filter by sector (NTEE major-group code; see `/organizations/sectors`) |
| `limit` | integer | `50` | Results per page (max 500) |
| `offset` | integer | `0` | Number of results to skip |
| `favorite` | boolean | `false` | When truthy (`1`/`true`/`yes`), return only favorited organizations |

**Response**

```json
{
  "total": 376920,
  "limit": 50,
  "offset": 0,
  "organizations": [
    {
      "ein": "010234567",
      "name": "ACME NONPROFIT INC",
      "is_favorite": false,
      "org_type": "nonprofit",
      "is_grantmaker": false,
      "sector_code": "E",
      "sector_name": "Health Care",
      "following": false,
      "created_at": "2025-01-15 10:23:45",
      "updated_at": "2025-01-15 10:23:45",
      "address": {"street": "1 MAIN ST", "city": "AUSTIN", "state": "TX", "zip": "78701",
                  "county_fips": "48453", "county_name": "Travis"}
    }
  ]
}
```

Every organization record carries an `address` object (the filer's return-header
mailing address, normalized into a separate table) or `null` if none was captured.
`org_type` (`foundation`/`nonprofit`/`other`/`null`) and `is_grantmaker` are the
derived classification (see [Foundations & Grants](foundations.md)); `following` is
true when the calling user follows the org (false for non-user callers).
`sector_code`/`sector_name` are the org's assigned [sector](#get-organizationssectors)
(NTEE major group, `null` until set); the address `county_fips`/`county_name` are
deduced from the filer ZIP (`null` until a crosswalk is imported — see
[`GET /organizations/counties`](#get-organizationscounties)).

---

### `GET /organizations/search`

Search organizations. Name matching is strict (case-insensitive substring) or
**fuzzy** (typo-tolerant, trigram-ranked) via `fuzzy=1`; EIN is a forward-looking
prefix; state and city are **exact** filter selections (dropdown-style). All
supplied filters combine with AND; at least one of `q`/`ein`/`state`/`city` is required.

**Query parameters**

| Param | Type | Default | Description |
|-------|------|---------|-------------|
| `q` | string | — | Name query — substring (strict) or typo-tolerant (when `fuzzy=1`) |
| `fuzzy` | boolean | `false` | Truthy → typo-tolerant trigram name match, ranked by relevance |
| `ein` | string | — | EIN forward-looking prefix (`1234` → `123456789…`) |
| `state` | string | — | Exact 2-letter USPS state code |
| `city` | string | — | Exact city, case-insensitive |
| `county` | string | — | Exact 5-digit county FIPS (see `/organizations/counties`) |
| `type` | string | — | Exact `org_type`: `foundation` / `nonprofit` / `other` |
| `grantmaker` | boolean | — | Truthy → only grantmaking orgs |
| `sector` | string | — | Exact sector (NTEE major-group code; see `/organizations/sectors`) |
| `favorite` | boolean | `false` | Truthy → only favorited organizations |
| `limit` | integer | `50` | Results per page (max 500) |
| `offset` | integer | `0` | Number of results to skip |

At least one of `q`/`ein`/`state`/`city`/`county`/`type`/`grantmaker`/`sector` is required.

**Response** — same shape as `GET /organizations`, plus a `"mode"` of `"strict"` or `"fuzzy"`.

---

### `GET /organizations/states`

The states present in stored filer addresses (for the state-search dropdown):
`{"states": [{"code": "TX", "name": "Texas"}, …]}`.

---

### `GET /organizations/cities`

The cities present in stored filer addresses, optionally within one state
(param `state`) — for the city-search dropdown: `{"cities": ["Austin", "Dallas", …]}`.

---

### `GET /organizations/sectors`

The sector vocabulary (the [NTEE major groups](https://nccs.urban.org/publication/irs-activity-codes),
seeded on every startup) for the sector dropdown / assignment UI:

```json
{"sectors": [{"code": "A", "name": "Arts, Culture & Humanities", "parent_code": null},
             {"code": "B", "name": "Education", "parent_code": null}, …]}
```

`parent_code` is reserved for grouping the majors into custom buckets (always `null`
in the shipped seed). A sector is assigned to an org via
[`POST /organizations`](#post-organizations) / [`/organizations/edit`](#post-organizationsedit)
(`sector_code`); the 990 e-file XML carries no NTEE code, so sector is assignable, not parsed.

---

### `GET /organizations/counties`

The counties present in stored filer addresses (deduced from the filer ZIP),
optionally within one state (param `state`) — for the county-search dropdown:

```json
{"counties": [{"fips": "48453", "name": "Travis", "state": "TX"}, …]}
```

County is **deduced offline** from a ZIP→county crosswalk, so the list is empty
until an operator imports one with `openreturn counties import <file>` (e.g. the
public [HUD USPS ZIP-COUNTY crosswalk](https://www.huduser.gov/portal/datasets/usps_crosswalk.html);
`openreturn counties derive` re-derives without re-importing). The 990 carries no
county; a ZIP that straddles a county line is approximated by its **dominant**
(highest-residential-share) county.

---

### `GET /organizations/detail`

Fetch a single organization by EIN.

**Query parameters**

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| `ein` | string | yes | 9-digit Employer Identification Number |

**Response**

```json
{
  "ein": "010234567",
  "name": "ACME NONPROFIT INC",
  "is_favorite": false,
  "website": "https://acme.org",
  "main_email": "info@acme.org",
  "sector_code": "E",
  "sector_name": "Health Care",
  "created_by": "alice",
  "updated_by": "alice",
  "created_at": "2025-01-15 10:23:45",
  "updated_at": "2025-01-15 10:23:45",
  "address": {"street": "1 MAIN ST", "city": "AUSTIN", "state": "TX", "zip": "78701",
              "county_fips": "48453", "county_name": "Travis"},
  "mailing_address": {"street": "PO BOX 5", "city": "AUSTIN", "state": "TX", "zip": "78702"}
}
```

`address` is the physical (as-filed filer) address; `mailing_address` is the
editable mailing address. `website`/`main_email`/`mailing_address` are `null`
until set via [`POST /organizations`](#post-organizations) or
[`/organizations/edit`](#post-organizationsedit). `sector_code`/`sector_name` are
the assigned [sector](#get-organizationssectors) (`null` until set); the address
`county_fips`/`county_name` are deduced from the filer ZIP (`null` until a crosswalk
is imported). `created_by`/`updated_by` name the actor of the last create/edit.

---

### `GET /organizations/full`

Fetch an organization together with all its filing metadata and convenience links.

**Query parameters**

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| `ein` | string | yes | 9-digit EIN |

**Response**

```json
{
  "ein": "010234567",
  "name": "ACME NONPROFIT INC",
  "is_favorite": false,
  "in_portfolio": false,
  "mission": "To advance literacy across the region.",
  "created_at": "2025-01-15 10:23:45",
  "updated_at": "2025-01-15 10:23:45",
  "filings": [
    {
      "filing_id": "550e8400-e29b-41d4-a716-446655440000",
      "year": 2023,
      "form_code": "990",
      "created_at": "2025-01-15 10:23:45",
      "object_id": null,
      "xml_source_url": null,
      "xml_filename": "202312345678901234_public.xml",
      "zip_filename": "2024_TEOS_XML_01A.zip",
      "links": {
        "detail": "/filings/detail?filing_id=550e8400-e29b-41d4-a716-446655440000",
        "data":   "/filings/data?filing_id=550e8400-e29b-41d4-a716-446655440000",
        "lookup": "/filings/lookup?ein=010234567&year=2023"
      }
    }
  ]
}
```

---

### `GET /organizations/grants`

Grants an organization **made** (the foundation → nonprofits view, the default) or
**received** (its funders), built on the grant graph. See
[Foundations & Grants](foundations.md).

**Query parameters**

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| `ein` | string | yes | 9-digit EIN |
| `direction` | string | no | `made` (default) or `received` |

**Response**

```json
{
  "ein": "364348917",
  "direction": "made",
  "summary": {"grant_count": 2, "total_amount": 30000.0, "counterparties": 2,
              "by_year": [{"year": 2023, "amount": 30000.0}]},
  "grants": [
    {"year": 2023, "recipient": "ACME NONPROFIT INC", "recipient_ein": "010234567",
     "grant_kind": "PF_PAID", "cash_amount": 25000.0, "noncash_amount": 0.0,
     "amount": 25000.0, "purpose": "General support", "foundation_status": null,
     "resolved_party_id": 42}
  ]
}
```

For `direction=received`, each grant carries `grantor_ein` / `grantor` instead of
the recipient fields. **Note:** 990-PF grants carry no recipient EIN in the e-file
XML, so a foundation→nonprofit link for PF grants appears only after
`openreturn resolve`; Schedule-I grants link immediately.

`mission` (on `/organizations/full`) is the organization's latest filed mission /
activity description (from `MissionDesc` / `ActivityOrMissionDesc` / `Desc`), or
`null` if no filing carries one. `in_portfolio` is the shared (team-wide) portfolio
flag (see [`POST /organizations/portfolio`](#post-organizationsportfolio)).

---

### `GET /organizations/personnel`

Officers, directors, trustees, and key employees as filed on the organization's most
recent 990 (Part VII Section A). This is graph-derived (auto-populated from filings)
and complements the manually-curated [People directory](#people). Empty until a 990
with personnel has been ingested for the org.

**Query parameters**

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| `ein` | string | yes | 9-digit EIN |

**Response**

```json
{
  "ein": "010234567",
  "year": 2023,
  "personnel": [
    {"name": "Jane Doe", "title": "President", "is_officer": true,
     "is_director_trustee": false, "is_key_employee": false, "is_highest_comp": false,
     "is_former": false, "avg_hours_org": 40.0,
     "reportable_comp_org": 120000.0, "reportable_comp_related": null,
     "other_comp": 5000.0, "resolved_party_id": 42}
  ]
}
```

---

### `POST /organizations`

Create an organization. Requires `org:write`. The EIN must be 9 digits (a hyphen
is allowed) and must not already exist. The change is recorded in the audit trail.

**Request body** (only `ein` and `name` are required)

```json
{
  "ein": "36-4348917",
  "name": "Administer Justice",
  "website": "https://administerjustice.org",
  "main_email": "info@administerjustice.org",
  "sector_code": "I",
  "address":         { "street": "1 Tyler Creek", "city": "Elgin", "state": "IL", "zip": "60120" },
  "mailing_address": { "street": "PO Box 12", "city": "Elgin", "state": "IL", "zip": "60121" }
}
```

`address` is the organization's **physical** address; `mailing_address` is a
separate editable address. Both are optional and accept `{street, city, state,
zip}` (plus `street2`). `sector_code` is optional and validated against the
[sector](#get-organizationssectors) vocabulary (an unknown code is rejected; an
empty string clears it).

**Response** — the created organization (see [`GET /organizations/detail`](#get-organizationsdetail)),
which now also carries `website`, `main_email`, `mailing_address`, and
`created_by`/`updated_by`.

---

### `POST /organizations/edit`

Edit an existing organization. Requires `org:write`. Only the fields present in
the body are changed; `ein` selects the organization. Audited.

```json
{ "ein": "364348917", "main_email": "hello@administerjustice.org" }
```

**Response** — the updated organization, or `{"error": …}` if the EIN is unknown.

---

### `POST /organizations/favorite`

Mark an organization as favorited (or unfavorited). The organization must already exist.

**Request body**

```json
{ "ein": "010234567", "is_favorite": true }
```

`is_favorite` accepts a JSON boolean; the strings `"1"`/`"true"`/`"yes"` (and `1`) are also coerced to true, anything else to false.

**Response** — the updated organization record (same shape as `GET /organizations/detail`), or `{"error": "organization not found: <ein>"}` if no organization has that EIN.

---

### `POST /organizations/portfolio`

Requires `org:write`. Add or remove an organization from the **shared, team-wide
portfolio** — the set of (typically nonprofit) orgs the team is actively tracking.
Unlike the per-user [follow watchlist](#follows), the portfolio is a single shared
flag every user sees. (The UI surfaces "Follow" on foundations and "Add to
portfolio" on nonprofits.)

**Request body**

```json
{ "ein": "010234567", "in_portfolio": true }
```

`in_portfolio` is coerced the same way as `is_favorite`. **Response** — the updated
organization record, or `{"error": "organization not found: <ein>"}`.

---

## Filings

### `GET /filings`

List all filings for an organization.

**Query parameters**

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| `ein` | string | yes | 9-digit EIN |

**Response**

```json
{
  "filings": [
    {
      "filing_id": "550e8400-e29b-41d4-a716-446655440000",
      "year": 2023,
      "form_code": "990",
      "created_at": "2025-01-15 10:23:45",
      "object_id": null,
      "xml_source_url": null,
      "xml_filename": "202312345678901234_public.xml",
      "zip_filename": "2024_TEOS_XML_01A.zip"
    }
  ]
}
```

---

### `GET /filings/detail`

Fetch filing metadata by filing UUID.

**Query parameters**

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| `filing_id` | UUID string | yes | Filing UUID |

**Response**

```json
{
  "filing_id": "550e8400-e29b-41d4-a716-446655440000",
  "year": 2023,
  "ein": "010234567",
  "form_code": "990",
  "created_at": "2025-01-15 10:23:45",
  "object_id": null,
  "xml_source_url": null,
  "xml_filename": "202312345678901234_public.xml",
  "zip_filename": "2024_TEOS_XML_01A.zip"
}
```

---

### `GET /filings/data`

Fetch all reported field values for a filing, with full line/section/part metadata.

**Query parameters**

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| `filing_id` | UUID string | yes | Filing UUID |
| `format` | string | no | Response format: `json` (default), `md`, `html`, `xml` |

**Response (JSON)**

```json
{
  "filing_id": "550e8400-e29b-41d4-a716-446655440000",
  "ein": "010234567",
  "year": 2023,
  "form_code": "990",
  "xml_filename": "202312345678901234_public.xml",
  "zip_filename": "2024_TEOS_XML_01A.zip",
  "fields": [
    {
      "field_id": 42,
      "value": "1500000",
      "xml_path": "ReturnData/IRS990/TotalRevenueGrp/TotalRevenueColumnAmt",
      "sub_letter": null,
      "column_code": "A",
      "box_label": "Total revenue",
      "line":    { "number": "12", "label": "Total revenue", "data_type": "USD" },
      "section": { "code": "NONE", "name": null },
      "part":    { "number": "I",  "name": "Summary" }
    }
  ]
}
```

Alternate formats render the same data as a table: `format=md` returns a Markdown table and `format=html` an HTML table (both served with the default `text/html` content type), while `format=xml` returns an XML document with the `application/xml` content type. An unrecognized `format` falls back to the JSON object.

---

### `GET /filings/lookup`

Fetch all reported field values by EIN + tax year (combines the filing lookup and data fetch in one call).

**Query parameters**

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| `ein` | string | yes | 9-digit EIN |
| `year` | integer | yes | Tax year (e.g. `2023`) |
| `format` | string | no | Same options as `/filings/data` |

**Response** — same shape as `GET /filings/data`.

---

### `POST /filings`

Create a new filing record (metadata only — no reported data).

**Request body**

```json
{ "ein": "010234567", "year": 2023, "form_code": "990" }
```

**Response**

```json
{ "filing_id": "550e8400-e29b-41d4-a716-446655440000" }
```

---

### `POST /filings/data`

Store reported field values for an existing filing.

**Request body**

```json
{
  "filing_id": "550e8400-e29b-41d4-a716-446655440000",
  "values": {
    "42": "1500000",
    "57": "250000"
  }
}
```

`values` maps `field_id` (string key) to raw string value. Existing values for the same `(filing_id, field_id)` pair are silently ignored (`INSERT OR IGNORE`).

**Response**

```json
{ "filing_id": "550e8400-e29b-41d4-a716-446655440000", "fields_stored": 2 }
```

---

## Scores

Scores represent a financial health assessment of a filing under a specific scoring model. The typical flow is:

1. `POST /scores/calculate` — fully automated: looks up fields, computes all factors, persists and returns the score in one call.
2. Or manually: `POST /scores` → `POST /scores/factors` → `POST /scores/finalize`.

---

### `GET /scores`

List all scores for an organization across all years and model versions.

**Query parameters**

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| `ein` | string | yes | 9-digit EIN |

**Response**

```json
{
  "ein": "010234567",
  "scores": [
    {
      "score_id": 1,
      "model_version": 1,
      "filing_id": "550e8400-e29b-41d4-a716-446655440000",
      "year": 2023,
      "total_score": 72.4,
      "scored_at": "2025-06-01 14:00:00",
      "imputed": false,
      "model_type": "financial",
      "model_kind": "model"
    }
  ]
}
```

`imputed` is `true` when the score used a [missing-data fallback](scoring/models.md#missing-data-fallbacks-completing-a-multi-year-history) (one or more inputs filled from another year). Each row also carries its model's `model_type` (category) and `model_kind` (`model`/`composite`/`super_composite`) so a client can group scores by dimension/pillar without a separate model lookup.

---

### `GET /scores/history`

One model's full year-by-year score series for an org, oldest→newest — the multi-year ("five-year history") view. Years missing data are filled per the model's fallback strategy and flagged.

**Query parameters**

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| `ein` | string | yes | 9-digit EIN |
| `version` | integer | no | Model version (default `1`) |

**Response**

```json
{
  "ein": "010234567",
  "model_version": 20,
  "history": [
    {"year": 2020, "total_score": 0.81, "imputed": false, "score_id": 11, "source_year": null},
    {"year": 2021, "total_score": 0.81, "imputed": true,  "score_id": 12, "source_year": 2020},
    {"year": 2022, "total_score": 0.87, "imputed": false, "score_id": 13, "source_year": null}
  ]
}
```

For an `imputed` year, `source_year` is the donor year its filled factors were carried from. The series spans the org's earliest data year through its latest; years before the earliest are never fabricated.

---

### `GET /scores/leaderboard`

Rank organizations by a model's score — globally or within a subset. Ranks each org's **latest scored** year for the model (or a fixed `year`); ties share a rank. Works for base, composite, and super-composite models.

**Query parameters**

| Param | Type | Default | Description |
|-------|------|---------|-------------|
| `model` | integer | `1` | Model version to rank by |
| `year` | integer | — | Rank a fixed tax year (default: each org's latest scored year) |
| `sector` | string | — | Subset: NTEE sector code |
| `state` / `city` / `county` | string | — | Subset: region (county is a FIPS code) |
| `type` | string | — | Subset: `org_type` |
| `list` | integer | — | Subset: members of an org list (`list_id`) |
| `grantmaker` | boolean | — | Subset: grantmakers only |
| `limit` / `offset` | integer | `50` / `0` | Pagination |

**Response** — `{model_version, year, total, limit, offset, leaderboard: [{rank, ein, name, total_score, year}]}`. The subset filters compose with AND; the rank is computed **within the subset**.

---

### `GET /scores/ranking`

One organization's rank for a model across dimensions — global plus its **own** sector / state / city / county — for an org page.

**Query parameters**

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| `ein` | string | yes | 9-digit EIN |
| `model` | integer | no | Model version (default `1`) |
| `year` | integer | no | Fixed tax year (default: latest scored) |

**Response** — `{ein, model_version, year, dimensions: {global, sector, state, city, county}}` where each dimension is `{rank, of, percentile, total_score}` (`rank`/`percentile` null if the org isn't ranked in that subset).

---

### `GET /scores/filing`

Fetch the most recent score for a specific filing.

**Query parameters**

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| `filing_id` | UUID string | yes | Filing UUID |

**Response** — same shape as `GET /scores/detail`.

---

### `GET /scores/detail`

Fetch a score including per-factor breakdown.

**Query parameters**

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| `score_id` | integer | yes | Score ID |

**Response**

```json
{
  "score_id": 1,
  "ein": "010234567",
  "model_version": 1,
  "filing_id": "550e8400-e29b-41d4-a716-446655440000",
  "year": 2023,
  "total_score": 72.4,
  "scored_at": "2025-06-01 14:00:00",
  "model_type": "financial",
  "scoring_mode": "computed",
  "model_kind": "model",
  "imputed": false,
  "factors": [
    {
      "factor_id": 1,
      "name": "Revenue Growth",
      "weight": 0.25,
      "raw_value": 0.12,
      "weighted_value": 18.6,
      "comment": null,
      "manual_scale": null,
      "imputed": false,
      "source_year": null
    }
  ]
}
```

For a **manual** model, `scoring_mode` is `"manual"`, each factor's `manual_scale` is set, and `comment` holds the grader's note (see [`POST /scores/grade`](#post-scoresgrade)). `model_kind` is `model` (base), `composite`, or `super_composite`; for a composite each factor's `raw_value` is a child model's score and the factor name names the child (see [Scoring Models → Model Kinds](scoring/models.md#model-kinds-composites)). The score-level and per-factor `imputed` flags (and a factor's donor `source_year`) mark values filled by a [missing-data fallback](scoring/models.md#missing-data-fallbacks-completing-a-multi-year-history).

---

### `GET /scores/lookup`

Fetch the most recent score for an EIN + tax year combination.

**Query parameters**

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| `ein` | string | yes | 9-digit EIN |
| `year` | integer | yes | Tax year |

**Response** — same shape as `GET /scores/detail`.

---

### `GET /scores/compare`

Fetch scores for all registered model versions for a given EIN + tax year.

**Query parameters**

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| `ein` | string | yes | 9-digit EIN |
| `year` | integer | yes | Tax year |

**Response**

```json
{
  "ein": "010234567",
  "year": 2023,
  "scores": [
    { "score_id": 1, "model_version": 1, "total_score": 72.4, "scored_at": "2025-06-01 14:00:00" },
    { "score_id": 2, "model_version": 2, "total_score": 68.1, "scored_at": "2025-06-07 09:15:00" }
  ]
}
```

---

### `GET /scores/debug`

Trace a scoring-model evaluation against a filing, factor by factor — the formula, the formula with this filing's numbers substituted in, every variable, and, for each field input, exactly where the value is grabbed from (form, part, section, line, column, box label, `xml_path`, `field_id`). This is **read-only**: it computes everything in-memory and persists nothing. The numbers it shows are identical to what `POST /scores/calculate` would compute and store.

**Query parameters**

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| `ein` | string | yes* | 9-digit EIN (with `year`) |
| `year` | integer | yes* | Tax year (with `ein`) |
| `filing_id` | string | yes* | Filing UUID — an alternative to `ein` + `year` |
| `version` | integer | no | Model version (default `1`) |

\* Provide either `filing_id`, or both `ein` and `year`.

**Response**

`factors` are returned in **evaluation order** (dependencies first). Each factor carries `variables` (resolved inputs with their source), `formula` (`expression` symbolic + `substituted` with numbers + `raw_value`), and `normalization` (how the raw value maps to `[0, 1]` and is weighted).

```json
{
  "ein": "010234567",
  "year": 2023,
  "filing_id": "550e8400-e29b-41d4-a716-446655440000",
  "form_code": "990",
  "model_version": 1,
  "total_score": 0.7332,
  "evaluation_order": ["Program Expense", "Admin Expense", "..."],
  "factors": [
    {
      "factor_id": 1,
      "name": "Program Expense",
      "formula_type": "ratio",
      "weight": 0.05,
      "formula_description": "Average Program Expenses ÷ Average Total Expenses",
      "inputs": ["prog", "total_exp"],
      "variables": [
        {
          "key": "prog",
          "kind": "field",
          "xml_path": "ReturnData/IRS990/TotalFunctionalExpensesGrp/ProgramServicesAmt",
          "value": 812000.0,
          "raw_value": "812000",
          "present": true,
          "source": {
            "field_id": 284,
            "xml_path": "ReturnData/IRS990/TotalFunctionalExpensesGrp/ProgramServicesAmt",
            "sub_letter": null,
            "column_code": "B",
            "box_label": "Total functional expenses — Program",
            "data_type": "CURRENCY",
            "line":    { "number": "25", "label": "Total functional expenses", "data_type": "CURRENCY" },
            "section": { "code": "NONE", "name": null },
            "part":    { "number": "IX", "name": "Statement of Functional Expenses" },
            "form":    { "code": "990", "name": "990" }
          }
        },
        {
          "key": "total_exp",
          "kind": "field",
          "xml_path": "ReturnData/IRS990/TotalFunctionalExpensesGrp/TotalAmt",
          "value": 950000.0,
          "raw_value": "950000",
          "present": true,
          "source": { "field_id": 283, "column_code": "A", "box_label": "Total functional expenses — Total",
                      "line": { "number": "25", "label": "Total functional expenses", "data_type": "CURRENCY" },
                      "part": { "number": "IX", "name": "Statement of Functional Expenses" },
                      "form": { "code": "990", "name": "990" } }
        }
      ],
      "formula": {
        "type": "ratio",
        "expression": "prog / total_exp",
        "substituted": "812000 / 950000",
        "raw_value": 0.8547368421052631,
        "computable": true,
        "note": null
      },
      "normalization": {
        "direction": "higher",
        "benchmark_lo": 0.6,
        "benchmark_hi": 0.85,
        "expression": "clamp01((raw - lo) / (hi - lo))",
        "substituted": "clamp01((0.854737 - 0.6) / 0.25)",
        "normalized": 1.0
      },
      "raw_value": 0.8547368421052631,
      "normalized": 1.0,
      "weighted_value": 0.05
    }
  ]
}
```

**Variable kinds**

| `kind` | Fields | Meaning |
|--------|--------|---------|
| `field` | `xml_path`, `value`, `raw_value`, `present`, `source` (+ `series` for historical formulas) | A Form 990 field key; `source` traces it to form/part/section/line. `present` is `false` when the filing has no value for it (`value` is then `null`). |
| `literal` | `value` | A numeric literal from the model (e.g. a `clamp` bound). |
| `factor` | `references`, `value` | A `factor:<name>` reference; `value` is that factor's raw computed value. |
| `model` | `references`, `value` | A `model:<version>` reference (composite / super-composite); `value` is that child model's `total_score` for this filing. |
| `unknown` | `note` | The key is not a known field, literal, factor, or model reference. |

For a composite/super-composite the top-level `model_kind` is `composite`/`super_composite`; each factor's variables are `model` references to the children being blended.

When a formula can't be computed (a required input is missing, or a denominator is zero), `formula.computable` is `false`, `formula.note` explains why, `raw_value` is `null`, and `normalized`/`weighted_value` are `0.0` — the walkthrough still shows the substituted formula (with `None` where the value is missing) so you can see exactly which input was unavailable.

---

### `GET /scores/factors`

Return the factor definitions for a scoring model version.

**Query parameters**

| Param | Type | Default | Description |
|-------|------|---------|-------------|
| `version` | integer | `1` | Model version number |

**Response**

```json
{
  "model_version": 1,
  "model_type": "financial",
  "scoring_mode": "computed",
  "model_kind": "model",
  "factors": [
    {
      "factor_id": 1,
      "name": "Revenue Growth",
      "weight": 0.25,
      "formula_type": "ratio",
      "inputs": ["total_revenue_current", "total_revenue_prior"],
      "direction": "higher",
      "benchmark_lo": 0.0,
      "benchmark_hi": 0.2,
      "formula_description": "Year-over-year revenue growth rate",
      "manual_scale": null
    }
  ]
}
```

For a **manual** model, `scoring_mode` is `"manual"` and each factor carries a non-null `manual_scale` (`benchmark` / `normalized` / `percent`) instead of a formula; `formula_description` is the grader's guidance. See [Scoring Models → Manual Models](scoring/models.md#manual-graded-models). `model_kind` is `model`/`composite`/`super_composite`; a composite's factor `inputs` are `model:<version>` references to its child models.

---

### `GET /scores/types`

List the available model categories (the seeded `model_type` codes).

**Response**

```json
{
  "types": [
    { "code": "christ_centeredness", "name": "Christ-Centeredness", "description": "Mission and faith alignment" },
    { "code": "financial",  "name": "Financial Health", "description": "Quantitative financial ratios computed from 990 data" },
    { "code": "governance", "name": "Governance", "description": "Board composition, policies, and oversight" },
    { "code": "whole_person", "name": "Whole-Person", "description": "Holistic organizational and staff well-being" }
  ]
}
```

---

### `GET /scores/kinds`

List the available model **kinds** (the seeded `model_kind` codes) — how a model is composed.

**Response**

```json
{
  "kinds": [
    { "code": "composite", "name": "Composite", "description": "Factors weight the final scores of base models" },
    { "code": "model", "name": "Model", "description": "Factors are formulas over 990 field data" },
    { "code": "super_composite", "name": "Super Composite", "description": "Factors weight the final scores of composites" }
  ]
}
```

See [Scoring Models → Model Kinds](scoring/models.md#model-kinds-composites) for how composites and super-composites are defined and scored.

---

### `POST /scores/calculate`

**Recommended.** Automatically look up all field values for the given EIN + year, compute every factor using the scoring model, persist the result, and return the full score detail.

**Request body**

```json
{ "ein": "010234567", "year": 2023, "model_version": 1 }
```

`model_version` defaults to `1` if omitted. A **manual** model is rejected (`{"error": "… is manual — grade its factors via POST /scores/grade …"}`); grade it instead of computing it.

**Response** — same shape as `GET /scores/detail`.

---

### `POST /scores`

Create a bare score record. Use this only if computing factor values externally.

**Request body**

```json
{ "filing_id": "550e8400-e29b-41d4-a716-446655440000", "model_version": 1 }
```

**Response**

```json
{ "score_id": 1, "filing_id": "550e8400-e29b-41d4-a716-446655440000", "model_version": 1 }
```

---

### `POST /scores/factors`

Store computed per-factor values against an existing score.

**Request body**

```json
{
  "score_id": 1,
  "values": [
    { "factor_id": 1, "raw_value": 0.12, "weighted_value": 18.6 },
    { "factor_id": 2, "raw_value": 0.85, "weighted_value": 21.25 }
  ]
}
```

**Response**

```json
{ "score_id": 1, "factors_stored": 2 }
```

---

### `POST /scores/finalize`

Set the total score on an existing score record.

**Request body**

```json
{ "score_id": 1, "total_score": 72.4 }
```

**Response**

```json
{ "score_id": 1, "total_score": 72.4 }
```

---

### `POST /scores/grade`

Record a grader's value and optional comment for one factor of a **manual** model, then recompute and return the score. Create the score first with `POST /scores` (using the manual model's version). Repeatable — each call upserts that factor and recomputes `total_score` from all graded factors.

**Request body**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `score_id` | integer | yes | The score to grade (from `POST /scores`) |
| `factor_id` | integer | yes | A factor of that score's model |
| `value` | number | yes | The grader's value, on the factor's `scale` (e.g. 0–100 for `percent`) |
| `comment` | string | no | The grader's explanation, stored with the factor |

```json
{ "score_id": 12, "factor_id": 30, "value": 80, "comment": "2 insiders of 9" }
```

**Response** — the updated score (same shape as `GET /scores/detail`); each factor includes its `raw_value`, `comment`, and `weighted_value`. Errors with `{"error": …}` if the score is for a computed model, or the factor isn't part of the model.

---

## People

User-managed people and their organization memberships — editable records,
distinct from the read-only people in the 990 graph. Reads require `person:read`;
all mutations require `person:write` and are audited.

### `GET /people`

List people. With `?ein=<EIN>` returns the people who belong to that organization
(each with their membership role); otherwise a paged list (`?search=`, `?limit=`,
`?offset=`).

### `GET /people/detail?person_id=<id>`

A person with their `memberships` (each carrying `org_ein`, `org_name`,
`role_title`, `is_primary`, `start_date`, `end_date`).

### `POST /people`

Create a person. Body: `{full_name, email?, phone?, title?, notes?}` → the created `Person`.

### `POST /people/edit`

Edit a person. Body: `{person_id, ...changed fields}` (only present fields change).

### `POST /people/delete`

Body: `{person_id}` → `{deleted: bool}` (cascades the person's memberships).

### `POST /people/membership`

Link a person to an organization (upsert on person+org). Body:
`{person_id, ein, role_title?, is_primary?, start_date?, end_date?}` → the
`Membership`. Errors if the person or organization does not exist.

### `POST /people/membership/remove`

Body: `{person_id, ein}` → `{removed: bool}`.

---

## Tags

Named labels applied to organizations. Reads require `tag:read`; applying/removing
requires `tag:write` (audited). Tag names are unique case-insensitively.

| Method & path | Body / params | Result |
|---------------|---------------|--------|
| `GET /tags` | `?ein=` (optional) | all tags + org counts, or one org's tag names |
| `GET /tags/organizations` | `?tag=<name>` | `{tag, eins}` — orgs carrying the tag |
| `POST /tags` | `{ein, tag}` | applies the tag → `{ein, tags}` |
| `POST /tags/remove` | `{ein, tag}` | `{removed}` |

---

## Lists

Lists of organizations, each **private** (only the owner reads/edits) or
**public**, and **static** (explicit members) or **smart** (members derived from
a tag query). Reads require `list:read`; mutations require `list:write` and are
owner-scoped for private lists. A program (API key) can read public lists but
owns no private ones.

| Method & path | Body / params | Result |
|---------------|---------------|--------|
| `GET /lists` | — | lists the caller can see (public + own) |
| `GET /lists/detail` | `?list_id=` | the list + its resolved `organizations` |
| `POST /lists` | `{name, visibility?, kind?, definition?}` | creates a list |
| `POST /lists/edit` | `{list_id, ...changed}` | edit (owner only) |
| `POST /lists/delete` | `{list_id}` | `{deleted}` (owner only) |
| `POST /lists/members/add` | `{list_id, ein}` | add to a **static** list |
| `POST /lists/members/remove` | `{list_id, ein}` | remove from a static list |

A **smart** list sets `kind: "smart"` and a `definition` such as
`{"tags": ["prospect", "midwest"], "match": "any"}` (`"any"` = at least one tag,
`"all"` = every tag); its membership is computed live from the tags, so
`/lists/members/*` is rejected for smart lists.

---

## Financials

The unified, multi-source financial layer the scoring models read from — see
**[Financial Data](financials.md)** for the model. Reads require `data:read`,
writes `data:write` (audited).

| Method & path | Does |
|---------------|------|
| `GET /financials/concepts` · `/financials/sources` | the concept catalog (= scoring keys) · the source list |
| `GET /financials?ein=&year=` | every fact: all observations, the canonical pick, conflict flag |
| `GET /financials/conflicts?ein=` | facts where sources disagree and none is chosen yet |
| `POST /financials/observations` | `{ein, fiscal_year, source, values:{concept:number}, confidence?}` — record a source |
| `POST /financials/canonical` | `{ein, fiscal_year, concept, observation_id}` — choose the value models use |

---

## Follows

A per-user **watchlist** for tracking organizations (e.g. foundations) — see
**[Foundations & Grants](foundations.md)**. Following is a user action: a program
(API key) caller has no watchlist. `GET` requires `follow:read`; follow/unfollow
require `follow:write`.

| Method & path | Does |
|---------------|------|
| `GET /follows` | the caller's followed orgs (optional `?type=foundation`) |
| `POST /follows/follow` | `{ein}` — follow an org (idempotent) |
| `POST /follows/unfollow` | `{ein}` — unfollow |

The `following` flag on organization responses reflects this per-user state.

---

## Notes

**Shared, team-wide notes / updates** on an organization (an activity log). Unlike
the per-user follow watchlist, every logged-in user sees the same feed, and each
note records its author (`author_label` + `author_user_id`) and `created_at`
timestamp. `GET` requires `note:read`; posting/removing require `note:write`.

| Method & path | Does |
|---------------|------|
| `GET /notes?ein=` | the org's notes, newest first |
| `POST /notes` | `{ein, body}` — post a note (author taken from the session) |
| `POST /notes/delete` | `{note_id}` — remove a note |

```json
{ "ein": "010234567",
  "notes": [ {"note_id": 7, "body": "Met with the ED.", "author_user_id": 3,
              "author_label": "alice", "created_at": "2026-06-19 14:02:11"} ] }
```

---

## Giving

A **shared record of gifts the team gave** to an organization — hand-entered
"giving data" (the relationship *we gave them $X in year Y*), distinct from the
990 grant graph. Team-wide; each gift records who entered it and when. `GET`
requires `giving:read`; recording/removing require `giving:write`.

| Method & path | Does |
|---------------|------|
| `GET /giving?ein=` | the org's recorded gifts + a by-year summary |
| `POST /giving` | `{ein, amount, fiscal_year?, gift_date?, purpose?}` — record a gift |
| `POST /giving/delete` | `{gift_id}` — remove a gift |

```json
{ "ein": "010234567",
  "gifts": [ {"gift_id": 4, "amount": 2500.0, "fiscal_year": 2023, "gift_date": null,
              "purpose": "General support", "created_by_label": "alice",
              "created_at": "2026-06-19 14:05:00"} ],
  "summary": {"gift_count": 1, "total_amount": 2500.0,
              "by_year": [{"year": 2023, "amount": 2500.0}]} }
```

---

## Model data

Per-**(organization, model, year)** annotations a steward adds from the org
profile: free-form **notes** and arbitrary **custom data fields**, scoped to one
scoring model + fiscal year. Distinct from the org-level [Notes](#notes) feed and
from the financial values / manual grades that feed scores. `GET` requires
`model_data:read`; add/remove require `model_data:write`.

| Method & path | Does |
|---------------|------|
| `GET /model-data?ein=&version=&year=` | notes + custom fields for one org/model/year |
| `POST /model-data/note` | `{ein, version, year, body}` — add a note |
| `POST /model-data/note/delete` | `{note_id}` — remove a note |
| `POST /model-data/field` | `{ein, version, year, label, value?}` — add a custom field |
| `POST /model-data/field/delete` | `{field_id}` — remove a custom field |

```json
{ "ein": "010234567", "model_version": "20", "fiscal_year": 2023,
  "notes":  [ {"note_id": 3, "body": "2023 reflects the new board policy.",
               "author_label": "alice", "created_at": "2026-06-19 15:00:00"} ],
  "fields": [ {"field_id": 5, "label": "Site visit score", "value": "4/5",
               "created_by_label": "alice", "created_at": "2026-06-19 15:01:00"} ] }
```

---

## Admin

User, role, and permission administration over HTTP. **Every route requires the
`user:admin` permission** and is audited. See [Access Control](access-control.md#admin-http-api)
for the full table; the routes are `/admin/users` (+ `/reset-password`,
`/activate`, `/deactivate`, `/assign-role`, `/revoke-role`), `/admin/roles` (+
`/delete`, `/grant`, `/revoke`), and `/admin/permissions`. Creating a user
returns a one-time `temporary_password` when none is supplied.

The admin surface also builds **scoring models** (the model builder):

| Method & path | Does |
|---------------|------|
| `GET /admin/models` | list registered models (so a composite can see its candidate children) |
| `POST /admin/models` | create a model from `{definition, dry_run?, skip_existing?}` — `definition` is a `{model, factor}` model definition (e.g. a [template](#templates), edited). `dry_run` validates without writing; audited |

---

## Templates

A read-only catalog of **model templates** — guides that prefill the model builder
(you create the model from one; templates aren't active). Reads require `score:read`.
See [Scoring Models → Templates](scoring/models.md#templates--the-model-builder) and
the [Frontend Guide](frontend.md).

| Method & path | Does |
|---------------|------|
| `GET /templates` | list the catalog: `code` / `name` / `kind` / `type` / `version` / `factor_count` |
| `GET /templates/detail?code=` | the full `{model, factor}` definition to prefill the builder |

Build a model from a template: `GET /templates/detail?code=…` → edit → `POST /admin/models`.
