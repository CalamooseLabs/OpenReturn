"""OpenAPI 3.1 description of the OpenReturn REST API.

``build_spec()`` returns the spec as a plain dict. ``openreturn openapi -o
openapi.json`` writes it to the committed ``openapi.json`` at the repo root,
which consumers point at directly. The spec is hand-authored here rather than
introspected from handlers (the routers carry no schema metadata);
``tests/test_openapi.py`` asserts it covers exactly the routes the app registers
**and** that the committed ``openapi.json`` is up to date, so it cannot drift.

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
    "`--auth`, every route requires an API key sent as `Authorization: "
    "Bearer <key>` or `X-API-Key: <key>` (a 401 is returned otherwise, and a 429 "
    "if a per-key rate limit is exceeded).\n\n"
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
            "example": {"error": "organization not found: 999999999"},
        },
        "Address": {
            "type": ["object", "null"],
            "properties": {
                "street": {"type": ["string", "null"]},
                "city": {"type": ["string", "null"]},
                "state": {"type": ["string", "null"], "description": "2-letter USPS code"},
                "zip": {"type": ["string", "null"]},
                "county_fips": {"type": ["string", "null"],
                                "description": "Deduced from the ZIP; null until counties imported"},
                "county_name": {"type": ["string", "null"]},
            },
        },
        "Organization": {
            "type": "object",
            "properties": {
                "ein": {"type": "string", "description": "9-digit EIN"},
                "name": {"type": "string"},
                "is_favorite": {"type": "boolean"},
                "org_type": {"type": ["string", "null"],
                             "enum": ["foundation", "nonprofit", "other", None],
                             "description": "Derived: 'foundation' (filed 990-PF), "
                                            "'nonprofit' (990/990-EZ/990-N), 'other', or null"},
                "is_grantmaker": {"type": "boolean",
                                  "description": "Has grant_edge rows (makes grants)"},
                "sector_code": {"type": ["string", "null"],
                                "description": "Assigned NTEE major-group code (see /organizations/sectors)"},
                "sector_name": {"type": ["string", "null"]},
                "following": {"type": "boolean",
                              "description": "Whether the calling user follows this org "
                                             "(false for non-user callers)"},
                "website": {"type": ["string", "null"]},
                "main_email": {"type": ["string", "null"]},
                "created_by": {"type": ["string", "null"], "description": "Actor who created the org"},
                "updated_by": {"type": ["string", "null"], "description": "Actor who last edited the org"},
                "created_at": {"type": "string"},
                "updated_at": {"type": "string"},
                "address": {**_ref("Address"),
                            "description": "Physical address (the as-filed filer address), or null"},
                "mailing_address": {**_ref("Address"),
                                    "description": "Editable mailing address, or null"},
            },
            "example": {
                "ein": "364348917", "name": "ADMINISTER JUSTICE INC", "is_favorite": False,
                "org_type": "nonprofit", "is_grantmaker": False,
                "sector_code": "I", "sector_name": "Crime & Legal-Related", "following": True,
                "website": "https://administerjustice.org", "main_email": None,
                "created_by": None, "updated_by": None,
                "created_at": "2025-01-15 10:23:45", "updated_at": "2025-01-15 10:23:45",
                "address": {"street": "1 MAIN ST", "city": "ELGIN", "state": "IL", "zip": "60120",
                            "county_fips": "17089", "county_name": "Kane County"},
                "mailing_address": None,
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
                "imputed": {"type": "boolean",
                            "description": "True if an input was filled from another year"},
                "source_year": {"type": ["integer", "null"],
                                "description": "Donor year of a filled input, if any"},
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
                "model_kind": {"type": "string",
                               "enum": ["model", "composite", "super_composite"]},
                "imputed": {"type": "boolean",
                            "description": "True if any factor used a missing-data fallback"},
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
                "model_kind": {"type": "string",
                               "enum": ["model", "composite", "super_composite"]},
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
        "Template": {
            "type": "object",
            "description": "A model-template catalog entry (a prefill guide).",
            "properties": {
                "code": {"type": "string", "description": "Catalog code (filename stem)"},
                "name": {"type": ["string", "null"]},
                "description": {"type": ["string", "null"]},
                "kind": {"type": "string",
                         "enum": ["model", "composite", "super_composite"]},
                "type": {"type": ["string", "null"]},
                "version": {"type": ["integer", "null"]},
                "factor_count": {"type": "integer"},
            },
        },
        "User": {
            "type": "object",
            "properties": {
                "user_id": {"type": "integer"},
                "username": {"type": "string"},
                "is_active": {"type": "boolean"},
                "created_at": {"type": "string"},
                "last_login_at": {"type": ["string", "null"]},
                "roles": {"type": "array", "items": {"type": "string"},
                          "description": "Role codes the user holds"},
            },
        },
        "Role": {
            "type": "object",
            "properties": {
                "code": {"type": "string"},
                "name": {"type": "string"},
                "description": {"type": ["string", "null"]},
                "permissions": {"type": "array", "items": {"type": "string"}},
            },
        },
        "Permission": {
            "type": "object",
            "properties": {
                "code": {"type": "string"},
                "description": {"type": ["string", "null"]},
            },
        },
        "FinancialConcept": {
            "type": "object",
            "properties": {
                "code": {"type": "string", "description": "Also the scoring model input key"},
                "label": {"type": "string"},
                "category": {"type": ["string", "null"]},
                "unit": {"type": ["string", "null"]},
                "default_xml_path": {"type": ["string", "null"]},
            },
        },
        "FinancialObservation": {
            "type": "object",
            "properties": {
                "observation_id": {"type": "integer"},
                "source_code": {"type": "string"},
                "value": {"type": ["number", "null"]},
                "raw_value": {"type": ["string", "null"]},
                "confidence": {"type": ["number", "null"]},
                "document_id": {"type": "integer"},
                "entered_by": {"type": ["string", "null"]},
                "entered_at": {"type": "string"},
                "is_canonical": {"type": "boolean"},
            },
        },
        "FinancialFact": {
            "type": "object",
            "description": "A (year, concept) with every source's observation, the "
                           "chosen canonical value, and a conflict flag.",
            "properties": {
                "fiscal_year": {"type": "integer"},
                "concept_code": {"type": "string"},
                "canonical_value": {"type": ["number", "null"]},
                "conflict": {"type": "boolean"},
                "observations": {"type": "array", "items": _ref("FinancialObservation")},
            },
        },
        "Membership": {
            "type": "object",
            "description": "A person's link to an organization (with role and dates).",
            "properties": {
                "membership_id": {"type": "integer"},
                "person_id": {"type": "integer"},
                "org_ein": {"type": "string"},
                "org_name": {"type": ["string", "null"]},
                "role_title": {"type": ["string", "null"]},
                "is_primary": {"type": "boolean"},
                "start_date": {"type": ["string", "null"]},
                "end_date": {"type": ["string", "null"]},
            },
        },
        "Person": {
            "type": "object",
            "properties": {
                "person_id": {"type": "integer"},
                "full_name": {"type": "string"},
                "email": {"type": ["string", "null"]},
                "phone": {"type": ["string", "null"]},
                "title": {"type": ["string", "null"]},
                "notes": {"type": ["string", "null"]},
                "created_by": {"type": ["string", "null"]},
                "updated_by": {"type": ["string", "null"]},
                "created_at": {"type": "string"},
                "updated_at": {"type": "string"},
                "memberships": {"type": "array", "items": _ref("Membership")},
            },
        },
        "Tag": {
            "type": "object",
            "properties": {
                "tag_id": {"type": "integer"},
                "name": {"type": "string"},
                "org_count": {"type": "integer"},
            },
        },
        "OrgList": {
            "type": "object",
            "properties": {
                "list_id": {"type": "integer"},
                "name": {"type": "string"},
                "owner_user_id": {"type": ["integer", "null"]},
                "visibility": {"type": "string", "enum": ["private", "public"]},
                "kind": {"type": "string", "enum": ["static", "smart"]},
                "definition": {"type": ["object", "null"],
                               "description": "Smart-list tag query, e.g. {tags:[...], match:any|all}"},
                "created_by": {"type": ["string", "null"]},
                "created_at": {"type": "string"},
                "updated_at": {"type": "string"},
            },
        },
        "ModelKind": {
            "type": "object",
            "description": "A model composition kind (model / composite / super_composite).",
            "properties": {
                "code": {"type": "string",
                         "enum": ["model", "composite", "super_composite"]},
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
                "model_kind": {"type": "string",
                               "enum": ["model", "composite", "super_composite"]},
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
        # ── Meta (public; no auth) ───────────────────────────────────────────
        "/openapi.json": {
            "get": {
                "tags": ["Meta"],
                "summary": "The live OpenAPI 3.1 spec (public)",
                "description": "Served unauthenticated so a frontend can fetch the contract "
                               "from the running server; servers[0].url reflects the request host.",
                "responses": _responses({"type": "object"}),
            },
        },
        "/health": {
            "get": {
                "tags": ["Meta"], "summary": "Liveness probe (public)",
                "responses": _responses({
                    "type": "object",
                    "properties": {"status": {"type": "string"},
                                   "version": {"type": "string"}}}),
            },
        },
        "/version": {
            "get": {
                "tags": ["Meta"], "summary": "Server name + version (public)",
                "responses": _responses({
                    "type": "object",
                    "properties": {"name": {"type": "string"},
                                   "version": {"type": "string"}}}),
            },
        },
        # ── Auth ─────────────────────────────────────────────────────────────
        "/auth/login": {
            "post": {
                "tags": ["Auth"],
                "summary": "Log in with username + password; returns a session key",
                "description": ("Public (no auth required). The returned `session_key` "
                                "is sent as `Authorization: Bearer <key>` on subsequent "
                                "requests. Programs use an API key instead and skip this."),
                "security": [],
                "requestBody": _body({
                    "type": "object", "required": ["username", "password"],
                    "properties": {"username": {"type": "string"},
                                   "password": {"type": "string"}},
                }),
                "responses": _responses({
                    "type": "object",
                    "properties": {"session_key": {"type": "string"},
                                   "expires_at": {"type": "string"},
                                   "user": _ref("User")}}, secured=False),
            },
        },
        "/auth/logout": {
            "post": {
                "tags": ["Auth"], "summary": "Revoke the caller's current session",
                "responses": _responses({
                    "type": "object",
                    "properties": {"logged_out": {"type": "boolean"}}}),
            },
        },
        "/auth/me": {
            "get": {
                "tags": ["Auth"],
                "summary": "The authenticated caller — kind, label, permissions, user",
                "responses": _responses({
                    "type": "object",
                    "properties": {
                        "kind": {"type": "string", "enum": ["user", "program"]},
                        "label": {"type": "string"},
                        "permissions": {"type": "array", "items": {"type": "string"}},
                        "user": _ref("User")}}),
            },
        },
        # ── Organizations ────────────────────────────────────────────────────
        "/organizations": {
            "get": {
                "tags": ["Organizations"], "summary": "List organizations",
                "parameters": [
                    _q("search", desc="Case-insensitive substring match on name"),
                    _q("type", desc="Filter by org_type: foundation / nonprofit / other"),
                    _q("grantmaker", "boolean", desc="Truthy → only grantmaking orgs"),
                    _q("sector", desc="Filter by sector (NTEE code; see /organizations/sectors)"),
                    _q("limit", "integer", default=50, desc="Results per page (max 500)"),
                    _q("offset", "integer", default=0, desc="Results to skip"),
                    _q("favorite", "boolean", default=False,
                       desc="Truthy → only favorited organizations"),
                ],
                "responses": _responses(_ref("OrganizationList")),
            },
            "post": {
                "tags": ["Organizations"],
                "summary": "Create an organization (requires org:write)",
                "description": "EIN must be 9 digits and not already exist.",
                "requestBody": _body({
                    "type": "object", "required": ["ein", "name"],
                    "properties": {
                        "ein": {"type": "string", "description": "9 digits (a hyphen is allowed)"},
                        "name": {"type": "string"},
                        "website": {"type": "string"},
                        "main_email": {"type": "string"},
                        "sector_code": {"type": "string", "description": "NTEE major-group code"},
                        "address": {**_ref("Address"), "description": "Physical address"},
                        "mailing_address": _ref("Address"),
                    },
                }),
                "responses": _responses(_ref("Organization")),
            },
        },
        "/organizations/edit": {
            "post": {
                "tags": ["Organizations"],
                "summary": "Edit an existing organization (requires org:write)",
                "description": "Only the fields present in the body are changed.",
                "requestBody": _body({
                    "type": "object", "required": ["ein"],
                    "properties": {
                        "ein": {"type": "string"},
                        "name": {"type": "string"},
                        "website": {"type": "string"},
                        "main_email": {"type": "string"},
                        "sector_code": {"type": "string", "description": "NTEE major-group code"},
                        "address": {**_ref("Address"), "description": "Physical address"},
                        "mailing_address": _ref("Address"),
                    },
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
        "/organizations/search": {
            "get": {
                "tags": ["Organizations"],
                "summary": "Search organizations (strict or fuzzy)",
                "description": ("Name match (strict substring, or typo-tolerant fuzzy "
                                "when fuzzy=1), EIN forward-prefix, exact state, city, "
                                "org type, and grantmaker flag — combined with AND. At "
                                "least one of q/ein/state/city/type/grantmaker is required."),
                "parameters": [
                    _q("q", desc="Name query (substring; fuzzy when fuzzy=1)"),
                    _q("ein", desc="EIN forward-looking prefix (e.g. 1234 → 123456789)"),
                    _q("state", desc="Exact 2-letter state code (dropdown selection)"),
                    _q("city", desc="Exact city, case-insensitive (dropdown selection)"),
                    _q("county", desc="Exact county FIPS (dropdown selection)"),
                    _q("type", desc="Exact org_type: foundation / nonprofit / other"),
                    _q("sector", desc="Exact sector (NTEE code)"),
                    _q("grantmaker", "boolean", desc="Truthy → only grantmaking orgs"),
                    _q("fuzzy", "boolean", default=False,
                       desc="Truthy → typo-tolerant trigram name matching, ranked"),
                    _q("favorite", "boolean", default=False, desc="Truthy → only favorited"),
                    _q("limit", "integer", default=50, desc="Results per page (max 500)"),
                    _q("offset", "integer", default=0, desc="Results to skip"),
                ],
                "responses": _responses({
                    "allOf": [
                        _ref("OrganizationList"),
                        {"type": "object", "properties": {
                            "mode": {"type": "string", "enum": ["strict", "fuzzy"]}}},
                    ],
                }),
            },
        },
        "/organizations/states": {
            "get": {
                "tags": ["Organizations"],
                "summary": "States present in filer addresses (search dropdown)",
                "responses": _responses({
                    "type": "object",
                    "properties": {"states": {"type": "array", "items": {
                        "type": "object", "properties": {
                            "code": {"type": "string"}, "name": {"type": ["string", "null"]}}}}},
                }),
            },
        },
        "/organizations/cities": {
            "get": {
                "tags": ["Organizations"],
                "summary": "Cities present in filer addresses (search dropdown)",
                "parameters": [_q("state", desc="Limit to cities within this 2-letter state code")],
                "responses": _responses({
                    "type": "object",
                    "properties": {"cities": {"type": "array", "items": {"type": "string"}}},
                }),
            },
        },
        "/organizations/sectors": {
            "get": {
                "tags": ["Organizations"],
                "summary": "The sector vocabulary (NTEE major groups) — sector dropdown",
                "responses": _responses({
                    "type": "object",
                    "properties": {"sectors": {"type": "array", "items": {
                        "type": "object", "properties": {
                            "code": {"type": "string"}, "name": {"type": "string"},
                            "parent_code": {"type": ["string", "null"]}}}}},
                }),
            },
        },
        "/organizations/counties": {
            "get": {
                "tags": ["Organizations"],
                "summary": "Counties present in filer addresses (search dropdown)",
                "description": "Empty until a ZIP→county crosswalk is imported "
                               "(`openreturn counties import`).",
                "parameters": [_q("state", desc="Limit to counties within this 2-letter state code")],
                "responses": _responses({
                    "type": "object",
                    "properties": {"counties": {"type": "array", "items": {
                        "type": "object", "properties": {
                            "fips": {"type": "string"}, "name": {"type": ["string", "null"]},
                            "state": {"type": ["string", "null"]}}}}},
                }),
            },
        },
        "/organizations/grants": {
            "get": {
                "tags": ["Organizations"],
                "summary": "Grants an org made (foundation → nonprofits) or received",
                "description": ("Built on the grant graph. direction=made (default) lists "
                                "the org's outbound grants with a summary (total $, distinct "
                                "recipients, by year); direction=received lists its funders. "
                                "990-PF grantee EINs link only after `openreturn resolve`; "
                                "Schedule-I grants carry the EIN as filed."),
                "parameters": [
                    _q("ein", required=True, desc="9-digit EIN of the org"),
                    _q("direction", desc="made (default) | received"),
                ],
                "responses": _responses({
                    "type": "object",
                    "properties": {
                        "ein": {"type": "string"},
                        "direction": {"type": "string", "enum": ["made", "received"]},
                        "summary": {"type": "object", "properties": {
                            "grant_count": {"type": "integer"},
                            "total_amount": {"type": "number"},
                            "counterparties": {"type": "integer"},
                            "by_year": {"type": "array", "items": {"type": "object"}}}},
                        "grants": {"type": "array", "items": {"type": "object"}}},
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
        "/scores/history": {
            "get": {
                "tags": ["Scores"],
                "summary": "One model's full year-by-year score history for an org",
                "description": "Oldest→newest series for the model, with each year flagged "
                               "`imputed` and carrying the donor `source_year` of any filled "
                               "factors (the multi-year / MinistryWatch-style view).",
                "parameters": [_q("ein", required=True), _q("version")],
                "responses": _responses({
                    "type": "object",
                    "properties": {"ein": {"type": "string"},
                                   "model_version": {"type": "integer"},
                                   "history": {"type": "array", "items": {
                                       "type": "object",
                                       "properties": {
                                           "year": {"type": "integer"},
                                           "total_score": {"type": ["number", "null"]},
                                           "imputed": {"type": "boolean"},
                                           "score_id": {"type": "integer"},
                                           "source_year": {"type": ["integer", "null"]}}}}}}),
            },
        },
        "/scores/leaderboard": {
            "get": {
                "tags": ["Scores"],
                "summary": "Rank orgs by a model's score, globally or within a subset",
                "description": "Ranks orgs by `model` (version)'s latest scored total (or a "
                               "fixed `year`), filtered to an optional subset (sector / state / "
                               "city / county / list / type / grantmaker). Ties share a rank. "
                               "Works for base, composite, and super-composite models.",
                "parameters": [
                    _q("model", "integer", default=1, desc="Model version to rank by"),
                    _q("year", "integer", desc="Rank a fixed tax year (default: each org's latest)"),
                    _q("sector"), _q("state"), _q("city"),
                    _q("county", desc="County FIPS"), _q("type", desc="org_type"),
                    _q("list", "integer", desc="Restrict to an org list (list_id)"),
                    _q("grantmaker", "boolean"),
                    _q("limit", "integer", default=50), _q("offset", "integer", default=0),
                ],
                "responses": _responses({
                    "type": "object",
                    "properties": {
                        "model_version": {"type": "integer"}, "year": {"type": ["integer", "null"]},
                        "total": {"type": "integer"}, "limit": {"type": "integer"},
                        "offset": {"type": "integer"},
                        "leaderboard": {"type": "array", "items": {
                            "type": "object", "properties": {
                                "rank": {"type": "integer"}, "ein": {"type": "string"},
                                "name": {"type": "string"},
                                "total_score": {"type": ["number", "null"]},
                                "year": {"type": "integer"}}}}}}),
            },
        },
        "/scores/ranking": {
            "get": {
                "tags": ["Scores"],
                "summary": "One org's rank for a model, by dimension",
                "description": "The org's rank (and percentile) in global + its own sector / "
                               "state / city / county, for `model` (version). `ein` required.",
                "parameters": [_q("ein", required=True), _q("model", "integer", default=1),
                               _q("year", "integer")],
                "responses": _responses({
                    "type": "object",
                    "properties": {
                        "ein": {"type": "string"}, "model_version": {"type": "integer"},
                        "year": {"type": ["integer", "null"]},
                        "dimensions": {"type": "object",
                                       "description": "global / sector / state / city / county → "
                                                      "{rank, of, percentile, total_score}"}}}),
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
        "/scores/kinds": {
            "get": {
                "tags": ["Scores"],
                "summary": "Available model kinds (model / composite / super_composite)",
                "responses": _responses({
                    "type": "object",
                    "properties": {"kinds": {"type": "array", "items": _ref("ModelKind")}}}),
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
        # ── People ───────────────────────────────────────────────────────────
        "/people": {
            "get": {
                "tags": ["People"],
                "summary": "List people (or an org's people with ?ein=)",
                "parameters": [
                    _q("ein", desc="List the people who belong to this organization"),
                    _q("search", desc="Name/email substring (when ein is omitted)"),
                    _q("limit", "integer", default=50), _q("offset", "integer", default=0),
                ],
                "responses": _responses({
                    "type": "object",
                    "properties": {"people": {"type": "array", "items": _ref("Person")}}}),
            },
            "post": {
                "tags": ["People"], "summary": "Create a person (requires person:write)",
                "requestBody": _body({
                    "type": "object", "required": ["full_name"],
                    "properties": {"full_name": {"type": "string"},
                                   "email": {"type": "string"}, "phone": {"type": "string"},
                                   "title": {"type": "string"}, "notes": {"type": "string"}},
                }),
                "responses": _responses(_ref("Person")),
            },
        },
        "/people/detail": {
            "get": {
                "tags": ["People"], "summary": "Fetch a person with their memberships",
                "parameters": [_q("person_id", "integer", required=True)],
                "responses": _responses(_ref("Person")),
            },
        },
        "/people/edit": {
            "post": {
                "tags": ["People"], "summary": "Edit a person (requires person:write)",
                "requestBody": _body({
                    "type": "object", "required": ["person_id"],
                    "properties": {"person_id": {"type": "integer"},
                                   "full_name": {"type": "string"}, "email": {"type": "string"},
                                   "phone": {"type": "string"}, "title": {"type": "string"},
                                   "notes": {"type": "string"}},
                }),
                "responses": _responses(_ref("Person")),
            },
        },
        "/people/delete": {
            "post": {
                "tags": ["People"], "summary": "Delete a person (requires person:write)",
                "requestBody": _body({
                    "type": "object", "required": ["person_id"],
                    "properties": {"person_id": {"type": "integer"}},
                }),
                "responses": _responses({
                    "type": "object", "properties": {"deleted": {"type": "boolean"}}}),
            },
        },
        "/people/membership": {
            "post": {
                "tags": ["People"],
                "summary": "Link a person to an organization (requires person:write)",
                "requestBody": _body({
                    "type": "object", "required": ["person_id", "ein"],
                    "properties": {"person_id": {"type": "integer"}, "ein": {"type": "string"},
                                   "role_title": {"type": "string"},
                                   "is_primary": {"type": "boolean"},
                                   "start_date": {"type": "string"}, "end_date": {"type": "string"}},
                }),
                "responses": _responses(_ref("Membership")),
            },
        },
        "/people/membership/remove": {
            "post": {
                "tags": ["People"],
                "summary": "Remove a person's membership in an organization (requires person:write)",
                "requestBody": _body({
                    "type": "object", "required": ["person_id", "ein"],
                    "properties": {"person_id": {"type": "integer"}, "ein": {"type": "string"}},
                }),
                "responses": _responses({
                    "type": "object", "properties": {"removed": {"type": "boolean"}}}),
            },
        },
        # ── Tags ─────────────────────────────────────────────────────────────
        "/tags": {
            "get": {
                "tags": ["Tags"], "summary": "List tags, or an org's tags with ?ein=",
                "parameters": [_q("ein", desc="Return the tags applied to this organization")],
                "responses": _responses({
                    "type": "object",
                    "properties": {"tags": {"type": "array",
                                            "items": {"oneOf": [_ref("Tag"), {"type": "string"}]}}}}),
            },
            "post": {
                "tags": ["Tags"], "summary": "Apply a tag to an organization (tag:write)",
                "requestBody": _body({
                    "type": "object", "required": ["ein", "tag"],
                    "properties": {"ein": {"type": "string"}, "tag": {"type": "string"}},
                }),
                "responses": _responses({
                    "type": "object",
                    "properties": {"ein": {"type": "string"},
                                   "tags": {"type": "array", "items": {"type": "string"}}}}),
            },
        },
        "/tags/remove": {
            "post": {
                "tags": ["Tags"], "summary": "Remove a tag from an organization (tag:write)",
                "requestBody": _body({
                    "type": "object", "required": ["ein", "tag"],
                    "properties": {"ein": {"type": "string"}, "tag": {"type": "string"}},
                }),
                "responses": _responses({
                    "type": "object", "properties": {"removed": {"type": "boolean"}}}),
            },
        },
        "/tags/organizations": {
            "get": {
                "tags": ["Tags"], "summary": "EINs of organizations carrying a tag",
                "parameters": [_q("tag", required=True)],
                "responses": _responses({
                    "type": "object",
                    "properties": {"tag": {"type": "string"},
                                   "eins": {"type": "array", "items": {"type": "string"}}}}),
            },
        },
        # ── Lists ────────────────────────────────────────────────────────────
        "/lists": {
            "get": {
                "tags": ["Lists"], "summary": "Lists the caller can see (public + own)",
                "responses": _responses({
                    "type": "object",
                    "properties": {"lists": {"type": "array", "items": _ref("OrgList")}}}),
            },
            "post": {
                "tags": ["Lists"], "summary": "Create a list (list:write)",
                "requestBody": _body({
                    "type": "object", "required": ["name"],
                    "properties": {"name": {"type": "string"},
                                   "visibility": {"type": "string", "enum": ["private", "public"]},
                                   "kind": {"type": "string", "enum": ["static", "smart"]},
                                   "definition": {"type": "object",
                                                  "description": "Smart-list tag query"}},
                }),
                "responses": _responses(_ref("OrgList")),
            },
        },
        "/lists/detail": {
            "get": {
                "tags": ["Lists"], "summary": "A list with its resolved organizations",
                "parameters": [_q("list_id", "integer", required=True)],
                "responses": _responses({
                    "allOf": [_ref("OrgList"), {"type": "object", "properties": {
                        "organizations": {"type": "array", "items": {
                            "type": "object", "properties": {"ein": {"type": "string"},
                                                             "name": {"type": "string"}}}}}}]}),
            },
        },
        "/lists/edit": {
            "post": {
                "tags": ["Lists"], "summary": "Edit a list (owner only; list:write)",
                "requestBody": _body({
                    "type": "object", "required": ["list_id"],
                    "properties": {"list_id": {"type": "integer"}, "name": {"type": "string"},
                                   "visibility": {"type": "string", "enum": ["private", "public"]},
                                   "definition": {"type": "object"}},
                }),
                "responses": _responses(_ref("OrgList")),
            },
        },
        "/lists/delete": {
            "post": {
                "tags": ["Lists"], "summary": "Delete a list (owner only; list:write)",
                "requestBody": _body({
                    "type": "object", "required": ["list_id"],
                    "properties": {"list_id": {"type": "integer"}},
                }),
                "responses": _responses({
                    "type": "object", "properties": {"deleted": {"type": "boolean"}}}),
            },
        },
        "/lists/members/add": {
            "post": {
                "tags": ["Lists"], "summary": "Add an org to a static list (list:write)",
                "requestBody": _body({
                    "type": "object", "required": ["list_id", "ein"],
                    "properties": {"list_id": {"type": "integer"}, "ein": {"type": "string"}},
                }),
                "responses": _responses({
                    "type": "object", "properties": {"added": {"type": "boolean"}}}),
            },
        },
        "/lists/members/remove": {
            "post": {
                "tags": ["Lists"], "summary": "Remove an org from a static list (list:write)",
                "requestBody": _body({
                    "type": "object", "required": ["list_id", "ein"],
                    "properties": {"list_id": {"type": "integer"}, "ein": {"type": "string"}},
                }),
                "responses": _responses({
                    "type": "object", "properties": {"removed": {"type": "boolean"}}}),
            },
        },
        # ── Follows (per-user watchlist) ─────────────────────────────────────
        "/follows": {
            "get": {
                "tags": ["Follows"],
                "summary": "The caller's followed organizations (follow:read)",
                "description": "Empty for a program (API-key) caller — following is a user action.",
                "parameters": [_q("type", desc="Filter to one org_type, e.g. foundation")],
                "responses": _responses({
                    "type": "object",
                    "properties": {"organizations": {"type": "array", "items": {
                        "type": "object", "properties": {
                            "ein": {"type": "string"}, "name": {"type": "string"},
                            "org_type": {"type": ["string", "null"]},
                            "is_grantmaker": {"type": "boolean"},
                            "followed_at": {"type": "string"},
                            "following": {"type": "boolean"}}}}},
                }),
            },
        },
        "/follows/follow": {
            "post": {
                "tags": ["Follows"], "summary": "Follow an organization (follow:write)",
                "requestBody": _body({
                    "type": "object", "required": ["ein"],
                    "properties": {"ein": {"type": "string"}}}),
                "responses": _responses({
                    "type": "object", "properties": {"ein": {"type": "string"},
                                                     "following": {"type": "boolean"}}}),
            },
        },
        "/follows/unfollow": {
            "post": {
                "tags": ["Follows"], "summary": "Unfollow an organization (follow:write)",
                "requestBody": _body({
                    "type": "object", "required": ["ein"],
                    "properties": {"ein": {"type": "string"}}}),
                "responses": _responses({
                    "type": "object", "properties": {"ein": {"type": "string"},
                                                     "following": {"type": "boolean"},
                                                     "removed": {"type": "boolean"}}}),
            },
        },
        # ── Templates (model-builder prefill catalog) ────────────────────────
        "/templates": {
            "get": {
                "tags": ["Templates"],
                "summary": "List the model-template catalog (score:read)",
                "description": "Read-only guides that prefill the model builder; create a "
                               "model from one via POST /admin/models. See the Frontend Guide.",
                "responses": _responses({
                    "type": "object",
                    "properties": {"templates": {"type": "array", "items": _ref("Template")}}}),
            },
        },
        "/templates/detail": {
            "get": {
                "tags": ["Templates"],
                "summary": "A template's full definition, to prefill the builder",
                "parameters": [_q("code", required=True, desc="Template code (filename stem)")],
                "responses": _responses({
                    "type": "object",
                    "properties": {"code": {"type": "string"},
                                   "definition": {"type": "object",
                                                  "description": "{model, factor} — the same "
                                                                 "shape POST /admin/models takes"}}}),
            },
        },
        # ── Admin (user:admin) ───────────────────────────────────────────────
        "/admin/models": {
            "get": {
                "tags": ["Admin"], "summary": "List registered scoring models (user:admin)",
                "responses": _responses({
                    "type": "object",
                    "properties": {"models": {"type": "array", "items": {"type": "object"}}}}),
            },
            "post": {
                "tags": ["Admin"],
                "summary": "Create a scoring model from a definition (user:admin)",
                "description": "Registers a model from a `{model, factor}` definition (e.g. a "
                               "template, edited). `dry_run` validates without writing; "
                               "`skip_existing` no-ops a duplicate version. Audited.",
                "requestBody": _body({
                    "type": "object", "required": ["definition"],
                    "properties": {
                        "definition": {"type": "object",
                                       "description": "{model, factor} — TOML/JSON model definition"},
                        "dry_run": {"type": "boolean"},
                        "skip_existing": {"type": "boolean"}},
                }),
                "responses": _responses({
                    "type": "object",
                    "properties": {"version": {"type": "integer"},
                                   "model_id": {"type": "integer"},
                                   "factors": {"type": "integer"},
                                   "kind": {"type": "string"}}}),
            },
        },
        "/admin/users": {
            "get": {"tags": ["Admin"], "summary": "List users (user:admin)",
                    "responses": _responses({"type": "object", "properties": {
                        "users": {"type": "array", "items": _ref("User")}}})},
            "post": {"tags": ["Admin"], "summary": "Create a user (user:admin)",
                     "requestBody": _body({"type": "object", "required": ["username"],
                         "properties": {"username": {"type": "string"},
                                        "password": {"type": "string"},
                                        "roles": {"type": "array", "items": {"type": "string"}}}}),
                     "responses": _responses({"type": "object", "properties": {
                         "user_id": {"type": "integer"}, "username": {"type": "string"},
                         "temporary_password": {"type": "string"}}})},
        },
        "/admin/users/reset-password": {
            "post": {"tags": ["Admin"], "summary": "Reset a user's password (user:admin)",
                     "requestBody": _body({"type": "object", "required": ["username"],
                         "properties": {"username": {"type": "string"}}}),
                     "responses": _responses({"type": "object", "properties": {
                         "username": {"type": "string"}, "temporary_password": {"type": "string"}}})},
        },
        "/admin/users/activate": {
            "post": {"tags": ["Admin"], "summary": "Activate a user (user:admin)",
                     "requestBody": _body({"type": "object", "required": ["username"],
                         "properties": {"username": {"type": "string"}}}),
                     "responses": _responses({"type": "object", "properties": {
                         "username": {"type": "string"}, "is_active": {"type": "boolean"}}})},
        },
        "/admin/users/deactivate": {
            "post": {"tags": ["Admin"], "summary": "Deactivate a user (user:admin)",
                     "requestBody": _body({"type": "object", "required": ["username"],
                         "properties": {"username": {"type": "string"}}}),
                     "responses": _responses({"type": "object", "properties": {
                         "username": {"type": "string"}, "is_active": {"type": "boolean"}}})},
        },
        "/admin/users/assign-role": {
            "post": {"tags": ["Admin"], "summary": "Assign a role to a user (user:admin)",
                     "requestBody": _body({"type": "object", "required": ["username", "role"],
                         "properties": {"username": {"type": "string"}, "role": {"type": "string"}}}),
                     "responses": _responses({"type": "object", "properties": {
                         "username": {"type": "string"},
                         "roles": {"type": "array", "items": {"type": "string"}}}})},
        },
        "/admin/users/revoke-role": {
            "post": {"tags": ["Admin"], "summary": "Revoke a role from a user (user:admin)",
                     "requestBody": _body({"type": "object", "required": ["username", "role"],
                         "properties": {"username": {"type": "string"}, "role": {"type": "string"}}}),
                     "responses": _responses({"type": "object", "properties": {
                         "username": {"type": "string"},
                         "roles": {"type": "array", "items": {"type": "string"}}}})},
        },
        "/admin/roles": {
            "get": {"tags": ["Admin"], "summary": "List roles + their permissions (user:admin)",
                    "responses": _responses({"type": "object", "properties": {
                        "roles": {"type": "array", "items": _ref("Role")}}})},
            "post": {"tags": ["Admin"], "summary": "Create a role (user:admin)",
                     "requestBody": _body({"type": "object", "required": ["code"],
                         "properties": {"code": {"type": "string"}, "name": {"type": "string"},
                                        "description": {"type": "string"}}}),
                     "responses": _responses({"type": "object", "properties": {
                         "roles": {"type": "array", "items": _ref("Role")}}})},
        },
        "/admin/roles/delete": {
            "post": {"tags": ["Admin"], "summary": "Delete a non-builtin role (user:admin)",
                     "requestBody": _body({"type": "object", "required": ["code"],
                         "properties": {"code": {"type": "string"}}}),
                     "responses": _responses({"type": "object", "properties": {
                         "deleted": {"type": "boolean"}}})},
        },
        "/admin/roles/grant": {
            "post": {"tags": ["Admin"], "summary": "Grant a permission to a role (user:admin)",
                     "requestBody": _body({"type": "object", "required": ["role", "permission"],
                         "properties": {"role": {"type": "string"}, "permission": {"type": "string"}}}),
                     "responses": _responses({"type": "object", "properties": {
                         "role": {"type": "string"},
                         "permissions": {"type": "array", "items": {"type": "string"}}}})},
        },
        "/admin/roles/revoke": {
            "post": {"tags": ["Admin"], "summary": "Revoke a permission from a role (user:admin)",
                     "requestBody": _body({"type": "object", "required": ["role", "permission"],
                         "properties": {"role": {"type": "string"}, "permission": {"type": "string"}}}),
                     "responses": _responses({"type": "object", "properties": {
                         "role": {"type": "string"},
                         "permissions": {"type": "array", "items": {"type": "string"}}}})},
        },
        "/admin/permissions": {
            "get": {"tags": ["Admin"], "summary": "List permissions (user:admin)",
                    "responses": _responses({"type": "object", "properties": {
                        "permissions": {"type": "array", "items": _ref("Permission")}}})},
            "post": {"tags": ["Admin"], "summary": "Create a permission (user:admin)",
                     "requestBody": _body({"type": "object", "required": ["code"],
                         "properties": {"code": {"type": "string"}, "description": {"type": "string"}}}),
                     "responses": _responses({"type": "object", "properties": {
                         "permissions": {"type": "array", "items": _ref("Permission")}}})},
        },
        # ── Financials ───────────────────────────────────────────────────────
        "/financials/concepts": {
            "get": {"tags": ["Financials"], "summary": "Canonical financial concepts (data:read)",
                    "responses": _responses({"type": "object", "properties": {
                        "concepts": {"type": "array", "items": _ref("FinancialConcept")}}})},
        },
        "/financials/sources": {
            "get": {"tags": ["Financials"], "summary": "Financial data sources (data:read)",
                    "responses": _responses({"type": "object", "properties": {
                        "sources": {"type": "array", "items": {"type": "object"}}}})},
        },
        "/financials": {
            "get": {"tags": ["Financials"],
                    "summary": "An org's financial facts — every source + canonical pick (data:read)",
                    "parameters": [_q("ein", required=True), _q("year", "integer")],
                    "responses": _responses({"type": "object", "properties": {
                        "ein": {"type": "string"},
                        "facts": {"type": "array", "items": _ref("FinancialFact")}}})},
        },
        "/financials/conflicts": {
            "get": {"tags": ["Financials"],
                    "summary": "Facts where sources disagree, unresolved (data:read)",
                    "parameters": [_q("ein", required=True)],
                    "responses": _responses({"type": "object", "properties": {
                        "ein": {"type": "string"},
                        "conflicts": {"type": "array", "items": _ref("FinancialFact")}}})},
        },
        "/financials/observations": {
            "post": {"tags": ["Financials"],
                     "summary": "Record a source's values for an org-year (data:write)",
                     "requestBody": _body({
                         "type": "object", "required": ["ein", "fiscal_year", "source", "values"],
                         "properties": {
                             "ein": {"type": "string"}, "fiscal_year": {"type": "integer"},
                             "source": {"type": "string"},
                             "values": {"type": "object", "additionalProperties": {"type": "number"},
                                        "description": "concept_code → value"},
                             "confidence": {"type": "number"}, "note": {"type": "string"}}}),
                     "responses": _responses({"type": "object", "properties": {
                         "document_id": {"type": "integer"}, "recorded": {"type": "integer"}}})},
        },
        "/financials/canonical": {
            "post": {"tags": ["Financials"],
                     "summary": "Choose the canonical observation for a fact (data:write)",
                     "requestBody": _body({
                         "type": "object",
                         "required": ["ein", "fiscal_year", "concept", "observation_id"],
                         "properties": {
                             "ein": {"type": "string"}, "fiscal_year": {"type": "integer"},
                             "concept": {"type": "string"}, "observation_id": {"type": "integer"}}}),
                     "responses": _responses({"type": "object", "properties": {
                         "ein": {"type": "string"},
                         "facts": {"type": "array", "items": _ref("FinancialFact")}}})},
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
        "/upload/pdf": {
            "post": {
                "tags": ["Upload"],
                "summary": "OCR a 990 PDF into confidence-scored financial observations",
                "description": "Requires the OCR engine (bundled tesseract). Query params "
                               "`ein` and `year` identify the org-year.",
                "parameters": [_q("ein", required=True), _q("year", "integer", required=True)],
                "requestBody": _body({
                    "type": "object",
                    "properties": {"file": {"type": "string", "format": "binary"}},
                }, content_type="multipart/form-data"),
                "responses": _responses({
                    "type": "object",
                    "properties": {"status": {"type": "string"}, "ein": {"type": "string"},
                                   "year": {"type": "integer"}, "pages": {"type": "integer"},
                                   "recorded": {"type": "integer"},
                                   "concepts": {"type": "object"}}}, body_limit=True),
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
            {"name": "Auth"}, {"name": "Organizations"}, {"name": "Filings"},
            {"name": "Scores"}, {"name": "People"}, {"name": "Tags"},
            {"name": "Lists"}, {"name": "Admin"}, {"name": "Financials"},
            {"name": "Follows"}, {"name": "Templates"}, {"name": "Upload"},
            {"name": "Meta"},
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
