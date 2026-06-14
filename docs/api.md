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

When the server is started with `--auth`, every route requires a valid API key.
Pass the key in either header — both are accepted:

```
Authorization: Bearer <key>
X-API-Key: <key>
```

Keys are managed with the `openreturn keys` CLI:

```bash
openreturn keys create "my-app"          # create and print a new key
openreturn keys list                     # list all keys
openreturn keys revoke <key_id>          # deactivate a key
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
  "is_favorite": false,
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
  "is_favorite": false,
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

### `POST /organizations/favorite`

Mark an organization as favorited (or unfavorited). The organization must already exist.

**Request body**

```json
{ "ein": "010234567", "is_favorite": true }
```

`is_favorite` accepts a JSON boolean; the strings `"1"`/`"true"`/`"yes"` (and `1`) are also coerced to true, anything else to false.

**Response** — the updated organization record (same shape as `GET /organizations/detail`), or `{"error": "organization not found: <ein>"}` if no organization has that EIN.

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
  "model_type": "financial",
  "scoring_mode": "computed",
  "factors": [
    {
      "factor_id": 1,
      "name": "Revenue Growth",
      "weight": 0.25,
      "raw_value": 0.12,
      "weighted_value": 18.6,
      "comment": null,
      "manual_scale": null
    }
  ]
}
```

For a **manual** model, `scoring_mode` is `"manual"`, each factor's `manual_scale` is set, and `comment` holds the grader's note (see [`POST /scores/grade`](#post-scoresgrade)).

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
| `unknown` | `note` | The key is not a known field, literal, or factor reference. |

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

For a **manual** model, `scoring_mode` is `"manual"` and each factor carries a non-null `manual_scale` (`benchmark` / `normalized` / `percent`) instead of a formula; `formula_description` is the grader's guidance. See [Scoring Models → Manual Models](scoring/models.md#manual-graded-models).

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
