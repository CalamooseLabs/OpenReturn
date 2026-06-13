"""OpenAPI 3.1 description of the OpenReturn REST API.

``build_spec()`` returns the spec as a plain dict so it can be served live
(``GET /openapi.json`` via ``DocsRouter``), dumped from the CLI
(``openreturn openapi``), or fed to a code generator. The spec is hand-authored
here rather than introspected from handlers (the routers carry no schema
metadata); ``tests/test_openapi.py`` asserts it covers exactly the routes the
app registers, so it cannot silently drift.

Error model note: most application-level errors are returned as **HTTP 200**
with an ``{"error": "..."}`` body (the handlers return a dict), so each data
operation's 200 response is `oneOf` the resource or an Error. Transport-level
statuses (401/404/413/429/500) come from the server itself.
"""

import json
from importlib.metadata import version as _pkg_version, PackageNotFoundError

OPENAPI_VERSION = "3.1.0"

_DESCRIPTION = (
    "REST API for IRS Form 990 filings, organizations, and financial-health / "
    "qualitative scores.\n\n"
    "**Authentication** is optional per deployment: when the server runs with "
    "`--auth`, every data route requires an API key sent as `Authorization: "
    "Bearer <key>` or `X-API-Key: <key>` (a 401 is returned otherwise, and a 429 "
    "if a per-key rate limit is exceeded). The discovery routes (`/openapi.json`, "
    "`/docs`) are always public.\n\n"
    "**Errors**: validation and not-found conditions are returned as HTTP 200 with "
    "an `{\"error\": \"...\"}` body. 401/404/413/429/500 are produced by the server."
)

_REF = "#/components/schemas/"


def _err_or(schema: dict) -> dict:
    return {"oneOf": [schema, {"$ref": _REF + "Error"}]}


def _q(name: str, typ: str = "string", required: bool = False, desc: str = "",
       default=None, enum=None) -> dict:
    schema: dict = {"type": typ}
    if default is not None:
        schema["default"] = default
    if enum is not None:
        schema["enum"] = enum
    return {"name": name, "in": "query", "required": required,
            "description": desc, "schema": schema}


def _json_resp(schema: dict, desc: str = "OK — the resource, or `{\"error\": …}` "
               "on an application error") -> dict:
    return {"description": desc,
            "content": {"application/json": {"schema": schema}}}


def _responses(ok_schema: dict, *, secured: bool = True, body_limit: bool = False,
               extra_200_desc: str | None = None) -> dict:
    r = {"200": _json_resp(_err_or(ok_schema),
                           extra_200_desc or "OK — the resource, or `{\"error\": …}` "
                           "on an application error")}
    if secured:
        r["401"] = {"$ref": "#/components/responses/Unauthorized"}
        r["429"] = {"$ref": "#/components/responses/RateLimited"}
    if body_limit:
        r["413"] = {"$ref": "#/components/responses/PayloadTooLarge"}
    r["500"] = {"$ref": "#/components/responses/ServerError"}
    return r


def _body(schema: dict, *, content_type: str = "application/json", required: bool = True) -> dict:
    return {"required": required, "content": {content_type: {"schema": schema}}}


def _ref(name: str) -> dict:
    return {"$ref": _REF + name}


def _app_version() -> str:
    try:
        return _pkg_version("openreturn")
    except PackageNotFoundError:  # pragma: no cover — running from source
        return "dev"


# ── Component schemas ────────────────────────────────────────────────────────

def _schemas() -> dict:
    return {
        "Error": {
            "type": "object", "required": ["error"],
            "properties": {"error": {"type": "string"}},
        },
        "Organization": {
            "type": "object",
            "properties": {
                "ein": {"type": "string", "description": "9-digit EIN"},
                "name": {"type": "string"},
                "is_favorite": {"type": "boolean"},
                "created_at": {"type": "string"},
                "updated_at": {"type": "string"},
            },
        },
        "OrganizationList": {
            "type": "object",
            "properties": {
                "total": {"type": "integer"},
                "limit": {"type": "integer"},
                "offset": {"type": "integer"},
                "organizations": {"type": "array", "items": _ref("Organization")},
            },
        },
        "Filing": {
            "type": "object",
            "properties": {
                "filing_id": {"type": "string", "description": "Filing UUID"},
                "year": {"type": "integer"},
                "ein": {"type": "string"},
                "form_code": {"type": "string"},
                "created_at": {"type": "string"},
                "object_id": {"type": ["string", "null"]},
                "xml_source_url": {"type": ["string", "null"]},
                "xml_filename": {"type": ["string", "null"]},
                "zip_filename": {"type": ["string", "null"]},
            },
        },
        "Field": {
            "type": "object",
            "description": "A reported field value with its 990 schema location.",
            "properties": {
                "field_id": {"type": "integer"},
                "value": {"type": ["string", "null"]},
                "xml_path": {"type": ["string", "null"]},
                "sub_letter": {"type": ["string", "null"]},
                "column_code": {"type": ["string", "null"]},
                "box_label": {"type": ["string", "null"]},
                "line": {"type": "object"},
                "section": {"type": "object"},
                "part": {"type": "object"},
            },
        },
        "FilingData": {
            "type": "object",
            "properties": {
                "filing_id": {"type": "string"},
                "ein": {"type": "string"},
                "year": {"type": "integer"},
                "form_code": {"type": "string"},
                "xml_filename": {"type": ["string", "null"]},
                "zip_filename": {"type": ["string", "null"]},
                "fields": {"type": "array", "items": _ref("Field")},
            },
        },
        "ScoreFactorResult": {
            "type": "object",
            "properties": {
                "factor_id": {"type": "integer"},
                "name": {"type": "string"},
                "weight": {"type": "number"},
                "raw_value": {"type": ["number", "null"]},
                "weighted_value": {"type": ["number", "null"]},
                "comment": {"type": ["string", "null"],
                            "description": "Grader comment (manual models)"},
                "manual_scale": {"type": ["string", "null"],
                                 "enum": ["benchmark", "normalized", "percent", None]},
            },
        },
        "Score": {
            "type": "object",
            "properties": {
                "score_id": {"type": "integer"},
                "ein": {"type": "string"},
                "model_version": {"type": "integer"},
                "filing_id": {"type": "string"},
                "year": {"type": "integer"},
                "total_score": {"type": ["number", "null"]},
                "scored_at": {"type": "string"},
                "model_type": {"type": ["string", "null"]},
                "scoring_mode": {"type": "string", "enum": ["computed", "manual"]},
                "factors": {"type": "array", "items": _ref("ScoreFactorResult")},
            },
        },
        "FactorDefinition": {
            "type": "object",
            "properties": {
                "factor_id": {"type": "integer"},
                "name": {"type": "string"},
                "weight": {"type": "number"},
                "formula_type": {"type": ["string", "null"]},
                "inputs": {"type": ["string", "null"],
                           "description": "JSON-encoded list of input keys"},
                "direction": {"type": ["string", "null"], "enum": ["higher", "lower", None]},
                "benchmark_lo": {"type": ["number", "null"]},
                "benchmark_hi": {"type": ["number", "null"]},
                "formula_description": {"type": ["string", "null"]},
                "manual_scale": {"type": ["string", "null"],
                                 "enum": ["benchmark", "normalized", "percent", None]},
            },
        },
        "ModelFactors": {
            "type": "object",
            "properties": {
                "model_version": {"type": "integer"},
                "model_type": {"type": ["string", "null"]},
                "scoring_mode": {"type": "string", "enum": ["computed", "manual"]},
                "factors": {"type": "array", "items": _ref("FactorDefinition")},
            },
        },
        "ModelType": {
            "type": "object",
            "properties": {
                "code": {"type": "string"},
                "name": {"type": "string"},
                "description": {"type": ["string", "null"]},
            },
        },
        "UploadResult": {
            "type": "object",
            "properties": {
                "status": {"type": "string", "example": "complete"},
                "stored": {"type": "integer"},
                "errors": {"type": "integer"},
                "results": {"type": "array", "items": {"type": "object"}},
            },
        },
        "ScoreDebug": {
            "type": "object",
            "description": "Read-only walkthrough of a model evaluation against a filing "
                           "(formula, substituted numbers, variables + source, normalization).",
            "properties": {
                "ein": {"type": "string"},
                "year": {"type": "integer"},
                "filing_id": {"type": "string"},
                "form_code": {"type": ["string", "null"]},
                "model_version": {"type": "integer"},
                "model_type": {"type": ["string", "null"]},
                "scoring_mode": {"type": "string", "enum": ["computed", "manual"]},
                "total_score": {"type": "number"},
                "factors": {"type": "array", "items": {"type": "object"}},
            },
        },
    }


def _responses_components() -> dict:
    err = {"content": {"application/json": {"schema": _ref("Error")}}}
    return {
        "Unauthorized": {"description": "Missing or invalid API key (only when the "
                                        "server runs with --auth).", **err},
        "RateLimited": {"description": "Per-key rate limit exceeded; a `Retry-After` "
                                       "header is sent.", **err},
        "NotFound": {"description": "Route not found.", **err},
        "PayloadTooLarge": {"description": "Request body exceeds 50 MB.", **err},
        "ServerError": {"description": "Internal server error."},
    }


# ── Paths ────────────────────────────────────────────────────────────────────

def _paths() -> dict:
    return {
        # ── Organizations ────────────────────────────────────────────────────
        "/organizations": {
            "get": {
                "tags": ["Organizations"], "summary": "List organizations",
                "parameters": [
                    _q("search", desc="Case-insensitive substring match on name"),
                    _q("limit", "integer", default=50, desc="Results per page (max 500)"),
                    _q("offset", "integer", default=0, desc="Results to skip"),
                    _q("favorite", "boolean", default=False,
                       desc="Truthy → only favorited organizations"),
                ],
                "responses": _responses(_ref("OrganizationList")),
            },
            "post": {
                "tags": ["Organizations"],
                "summary": "Upsert an organization (insert if EIN is new)",
                "requestBody": _body({
                    "type": "object", "required": ["ein", "name"],
                    "properties": {"ein": {"type": "string"}, "name": {"type": "string"}},
                }),
                "responses": _responses(_ref("Organization")),
            },
        },
        "/organizations/detail": {
            "get": {
                "tags": ["Organizations"], "summary": "Fetch one organization by EIN",
                "parameters": [_q("ein", required=True, desc="9-digit EIN")],
                "responses": _responses(_ref("Organization")),
            },
        },
        "/organizations/full": {
            "get": {
                "tags": ["Organizations"],
                "summary": "Organization with its filings and convenience links",
                "parameters": [_q("ein", required=True)],
                "responses": _responses({
                    "allOf": [
                        _ref("Organization"),
                        {"type": "object", "properties": {
                            "filings": {"type": "array", "items": {"allOf": [
                                _ref("Filing"),
                                {"type": "object", "properties": {
                                    "links": {"type": "object",
                                              "description": "detail / data / lookup URLs"}}},
                            ]}}}},
                    ],
                }),
            },
        },
        "/organizations/favorite": {
            "post": {
                "tags": ["Organizations"], "summary": "Mark an organization (un)favorited",
                "requestBody": _body({
                    "type": "object", "required": ["ein", "is_favorite"],
                    "properties": {"ein": {"type": "string"},
                                   "is_favorite": {"type": "boolean"}},
                }),
                "responses": _responses(_ref("Organization")),
            },
        },
        # ── Filings ──────────────────────────────────────────────────────────
        "/filings": {
            "get": {
                "tags": ["Filings"], "summary": "List an organization's filings",
                "parameters": [_q("ein", required=True)],
                "responses": _responses({
                    "type": "object",
                    "properties": {"filings": {"type": "array", "items": _ref("Filing")}},
                }),
            },
            "post": {
                "tags": ["Filings"], "summary": "Create a filing (or find the existing one)",
                "requestBody": _body({
                    "type": "object", "required": ["ein", "year", "form_code"],
                    "properties": {
                        "ein": {"type": "string"}, "year": {"type": "integer"},
                        "form_code": {"type": "string"},
                    },
                }),
                "responses": _responses({
                    "type": "object",
                    "properties": {"filing_id": {"type": "string"}}}),
            },
        },
        "/filings/detail": {
            "get": {
                "tags": ["Filings"], "summary": "Fetch filing metadata by UUID",
                "parameters": [_q("filing_id", required=True, desc="Filing UUID")],
                "responses": _responses(_ref("Filing")),
            },
        },
        "/filings/data": {
            "get": {
                "tags": ["Filings"],
                "summary": "All reported field values for a filing",
                "parameters": [
                    _q("filing_id", required=True, desc="Filing UUID"),
                    _q("format", default="json", enum=["json", "md", "html", "xml"],
                       desc="json (default) → FilingData; md/html → text table; xml → document"),
                ],
                "responses": {
                    "200": {
                        "description": "JSON FilingData (or an error), or a rendered table.",
                        "content": {
                            "application/json": {"schema": _err_or(_ref("FilingData"))},
                            "text/html": {"schema": {"type": "string"}},
                            "application/xml": {"schema": {"type": "string"}},
                        },
                    },
                    "401": {"$ref": "#/components/responses/Unauthorized"},
                    "429": {"$ref": "#/components/responses/RateLimited"},
                    "500": {"$ref": "#/components/responses/ServerError"},
                },
            },
            "post": {
                "tags": ["Filings"], "summary": "Store reported field values for a filing",
                "requestBody": _body({
                    "type": "object", "required": ["filing_id", "values"],
                    "properties": {
                        "filing_id": {"type": "string"},
                        "values": {"type": "object",
                                   "description": "Map of field_id → raw value",
                                   "additionalProperties": {"type": "string"}},
                    },
                }),
                "responses": _responses({
                    "type": "object",
                    "properties": {"filing_id": {"type": "string"},
                                   "fields_stored": {"type": "integer"}}}),
            },
        },
        "/filings/lookup": {
            "get": {
                "tags": ["Filings"],
                "summary": "Filing data by EIN + tax year (lookup + data in one call)",
                "parameters": [
                    _q("ein", required=True), _q("year", "integer", required=True),
                    _q("format", default="json", enum=["json", "md", "html", "xml"]),
                ],
                "responses": {
                    "200": {
                        "description": "FilingData (or error), or a rendered table.",
                        "content": {
                            "application/json": {"schema": _err_or(_ref("FilingData"))},
                            "text/html": {"schema": {"type": "string"}},
                            "application/xml": {"schema": {"type": "string"}},
                        },
                    },
                    "401": {"$ref": "#/components/responses/Unauthorized"},
                    "429": {"$ref": "#/components/responses/RateLimited"},
                    "500": {"$ref": "#/components/responses/ServerError"},
                },
            },
        },
        # ── Scores ───────────────────────────────────────────────────────────
        "/scores": {
            "get": {
                "tags": ["Scores"], "summary": "List all scores for an organization",
                "parameters": [_q("ein", required=True)],
                "responses": _responses({
                    "type": "object",
                    "properties": {"ein": {"type": "string"},
                                   "scores": {"type": "array", "items": {"type": "object"}}}}),
            },
            "post": {
                "tags": ["Scores"], "summary": "Create a bare score record",
                "requestBody": _body({
                    "type": "object", "required": ["filing_id"],
                    "properties": {"filing_id": {"type": "string"},
                                   "model_version": {"type": "integer", "default": 1}},
                }),
                "responses": _responses({
                    "type": "object",
                    "properties": {"score_id": {"type": "integer"},
                                   "filing_id": {"type": "string"},
                                   "model_version": {"type": "integer"}}}),
            },
        },
        "/scores/filing": {
            "get": {
                "tags": ["Scores"], "summary": "Latest score for a filing UUID",
                "parameters": [_q("filing_id", required=True)],
                "responses": _responses(_ref("Score")),
            },
        },
        "/scores/detail": {
            "get": {
                "tags": ["Scores"], "summary": "A score with its per-factor breakdown",
                "parameters": [_q("score_id", "integer", required=True)],
                "responses": _responses(_ref("Score")),
            },
        },
        "/scores/lookup": {
            "get": {
                "tags": ["Scores"], "summary": "Latest score for an EIN + tax year",
                "parameters": [_q("ein", required=True), _q("year", "integer", required=True)],
                "responses": _responses(_ref("Score")),
            },
        },
        "/scores/compare": {
            "get": {
                "tags": ["Scores"],
                "summary": "Scores across all model versions for an EIN + year",
                "parameters": [_q("ein", required=True), _q("year", "integer", required=True)],
                "responses": _responses({
                    "type": "object",
                    "properties": {"ein": {"type": "string"}, "year": {"type": "integer"},
                                   "scores": {"type": "array", "items": {"type": "object"}}}}),
            },
        },
        "/scores/factors": {
            "get": {
                "tags": ["Scores"], "summary": "Factor definitions for a model version",
                "parameters": [_q("version", "integer", default=1)],
                "responses": _responses(_ref("ModelFactors")),
            },
        },
        "/scores/types": {
            "get": {
                "tags": ["Scores"], "summary": "Available model categories",
                "responses": _responses({
                    "type": "object",
                    "properties": {"types": {"type": "array", "items": _ref("ModelType")}}}),
            },
        },
        "/scores/debug": {
            "get": {
                "tags": ["Scores"],
                "summary": "Trace a model evaluation (formula → numbers → source field)",
                "parameters": [
                    _q("ein", desc="With year — the filing to trace"),
                    _q("year", "integer"),
                    _q("filing_id", desc="Filing UUID — alternative to ein+year"),
                    _q("version", "integer", default=1),
                ],
                "responses": _responses(_ref("ScoreDebug")),
            },
        },
        "/scores/calculate": {
            "post": {
                "tags": ["Scores"],
                "summary": "Compute, persist, and return a score (computed models)",
                "requestBody": _body({
                    "type": "object", "required": ["ein", "year"],
                    "properties": {"ein": {"type": "string"}, "year": {"type": "integer"},
                                   "model_version": {"type": "integer", "default": 1}},
                }),
                "responses": _responses(_ref("Score")),
            },
        },
        "/scores/factors_store": {},  # placeholder removed below
        "/scores/finalize": {
            "post": {
                "tags": ["Scores"], "summary": "Set the total on a score record",
                "requestBody": _body({
                    "type": "object", "required": ["score_id", "total_score"],
                    "properties": {"score_id": {"type": "integer"},
                                   "total_score": {"type": "number"}},
                }),
                "responses": _responses({
                    "type": "object",
                    "properties": {"score_id": {"type": "integer"},
                                   "total_score": {"type": "number"}}}),
            },
        },
        "/scores/grade": {
            "post": {
                "tags": ["Scores"],
                "summary": "Grade one factor of a manual model (value + comment)",
                "requestBody": _body({
                    "type": "object", "required": ["score_id", "factor_id", "value"],
                    "properties": {
                        "score_id": {"type": "integer"},
                        "factor_id": {"type": "integer"},
                        "value": {"type": "number",
                                  "description": "On the factor's scale (e.g. 0–100 for percent)"},
                        "comment": {"type": "string"},
                    },
                }),
                "responses": _responses(_ref("Score")),
            },
        },
        # ── Upload ───────────────────────────────────────────────────────────
        "/upload": {
            "get": {
                "tags": ["Upload"], "summary": "Browser upload form (HTML)",
                "responses": {
                    "200": {"description": "An HTML upload form.",
                            "content": {"text/html": {"schema": {"type": "string"}}}},
                    "401": {"$ref": "#/components/responses/Unauthorized"},
                },
            },
            "post": {
                "tags": ["Upload"],
                "summary": "Upload a ZIP of 990 XML filings (multipart/form-data)",
                "requestBody": _body({
                    "type": "object",
                    "properties": {"file": {"type": "string", "format": "binary"}},
                }, content_type="multipart/form-data"),
                "responses": _responses(_ref("UploadResult"), body_limit=True),
            },
        },
        # ── Meta / discovery ──────────────────────────────────────────────────
        "/openapi.json": {
            "get": {
                "tags": ["Meta"], "summary": "This OpenAPI document",
                "security": [],
                "responses": {"200": {"description": "The OpenAPI 3.1 spec.",
                                       "content": {"application/json": {"schema": {"type": "object"}}}}},
            },
        },
        "/docs": {
            "get": {
                "tags": ["Meta"], "summary": "Interactive API docs (Redoc)",
                "security": [],
                "responses": {"200": {"description": "An HTML documentation page.",
                                       "content": {"text/html": {"schema": {"type": "string"}}}}},
            },
        },
    }


def build_spec(base_url: str | None = None) -> dict:
    paths = _paths()
    paths.pop("/scores/factors_store", None)
    # POST /scores/factors shares the /scores/factors path with the GET factor
    # listing — merge the operation in.
    paths["/scores/factors"]["post"] = {
        "tags": ["Scores"], "summary": "Bulk-store computed factor values on a score",
        "requestBody": _body({
            "type": "object", "required": ["score_id", "values"],
            "properties": {
                "score_id": {"type": "integer"},
                "values": {"type": "array", "items": {
                    "type": "object",
                    "properties": {"factor_id": {"type": "integer"},
                                   "raw_value": {"type": "number"},
                                   "weighted_value": {"type": "number"}}}},
            },
        }),
        "responses": _responses({
            "type": "object",
            "properties": {"score_id": {"type": "integer"},
                           "factors_stored": {"type": "integer"}}}),
    }

    spec = {
        "openapi": OPENAPI_VERSION,
        "info": {
            "title": "OpenReturn API",
            "version": _app_version(),
            "description": _DESCRIPTION,
        },
        "servers": [{"url": base_url or "/"}],
        "tags": [
            {"name": "Organizations"}, {"name": "Filings"}, {"name": "Scores"},
            {"name": "Upload"}, {"name": "Meta"},
        ],
        "paths": paths,
        "components": {
            "securitySchemes": {
                "bearerAuth": {"type": "http", "scheme": "bearer"},
                "apiKeyAuth": {"type": "apiKey", "in": "header", "name": "X-API-Key"},
            },
            "schemas": _schemas(),
            "responses": _responses_components(),
        },
        # Active only when the server runs with --auth; the Meta routes override
        # this with `security: []` so discovery is always public.
        "security": [{"bearerAuth": []}, {"apiKeyAuth": []}],
    }
    return spec


def spec_json(base_url: str | None = None, indent: int | None = 2) -> str:
    return json.dumps(build_spec(base_url), indent=indent)


def cmd_openapi(args) -> int:
    text = spec_json(base_url=getattr(args, "base_url", None) or None,
                     indent=(None if getattr(args, "compact", False) else 2))
    out = getattr(args, "output", None)
    if out:
        with open(out, "w") as fh:
            fh.write(text + "\n")
        print(f"Wrote OpenAPI spec to {out}")
    else:
        print(text)
    return 0


def main() -> int:  # pragma: no cover — thin CLI wrapper
    import argparse
    ap = argparse.ArgumentParser(prog="openreturn-openapi",
                                 description="Print the OpenReturn OpenAPI 3.1 spec.")
    ap.add_argument("--output", "-o", default=None, help="Write to a file instead of stdout")
    ap.add_argument("--base-url", dest="base_url", default=None, help="servers[0].url")
    ap.add_argument("--compact", action="store_true", help="Minified JSON")
    return cmd_openapi(ap.parse_args())


if __name__ == "__main__":  # pragma: no cover
    import sys
    sys.exit(main())
