# OpenReturn API

## Overview

OpenReturn exposes a JSON REST API for querying IRS Form 990 filings, organizations, and financial health scores.

**Base URL:** `http://<host>:<port>` (default `http://localhost:8080`)

All responses are `application/json` unless a `format` parameter requests an alternate representation.

---

## Authentication

When the server is started with `--auth`, every route requires a valid API key.
Pass the key in either header — both are accepted:

```
Authorization: Bearer <key>
X-API-Key: <key>
```

Keys are managed with the `openreturn-keys` CLI:

```bash
openreturn-keys create "my-app"          # create and print a new key
openreturn-keys list                     # list all keys
openreturn-keys revoke <key_id>          # deactivate a key
```

A `401` is returned if the key is missing or invalid.

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
| `limit` | integer | `50` | Results per page (max 500) |
| `offset` | integer | `0` | Number of results to skip |

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
      "created_at": "2025-01-15 10:23:45",
      "updated_at": "2025-01-15 10:23:45"
    }
  ]
}
```

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
  "created_at": "2025-01-15 10:23:45",
  "updated_at": "2025-01-15 10:23:45"
}
```

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

### `POST /organizations`

Upsert an organization (insert if EIN is new, no-op if it already exists).

**Request body**

```json
{ "ein": "010234567", "name": "ACME NONPROFIT INC" }
```

**Response** — the current organization record (same shape as `GET /organizations/detail`).

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

Alternate formats return `text/plain` (markdown), `text/html`, or `application/xml` with the same data in a tabular layout.

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
      "scored_at": "2025-06-01 14:00:00"
    }
  ]
}
```

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
  "factors": [
    {
      "name": "Revenue Growth",
      "weight": 0.25,
      "raw_value": 0.12,
      "weighted_value": 18.6
    }
  ]
}
```

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
      "formula_description": "Year-over-year revenue growth rate"
    }
  ]
}
```

---

### `POST /scores/calculate`

**Recommended.** Automatically look up all field values for the given EIN + year, compute every factor using the scoring model, persist the result, and return the full score detail.

**Request body**

```json
{ "ein": "010234567", "year": 2023, "model_version": 1 }
```

`model_version` defaults to `1` if omitted.

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
