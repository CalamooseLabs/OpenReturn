# Financial Data (unified, multi-source)

Scoring models run against a **unified financial layer**, not raw 990 XML. This
lets organizations that don't file a 990 (only audited statements) be scored, lets
the same fact arrive from several sources (a manually-entered 990, the IRS feed, an
OCR'd PDF) with **all sources retained and their differences surfaced**, and lets a
person choose which value the models actually use.

## Model

| Thing | What it is |
|-------|------------|
| **Concept** | A canonical metric whose code **is** the scoring model input key — `prog`, `total_exp`, `cy_rev`, … (`GET /financials/concepts`). Every source maps into the same concepts. |
| **Source** | Where a value came from: `irs_990_xml`, `irs_regrab`, `audited_statement`, `manual_990`, `ocr_990_pdf`. |
| **Document** | One source's submission for an org-year (a 990 filing, an audited PDF, an OCR run, a manual batch). The provenance anchor. |
| **Observation** | One source's value for one concept in a document. **Many** may exist per `(org, year, concept)` — they are all kept. |
| **Canonical** | The single chosen observation per `(org, year, concept)` that models read. |

A fact (`org`, `year`, `concept`) with a **single** observation is canonical
automatically. When a second source reports a **different** value, both are kept
and the fact becomes a **conflict** that a person resolves by choosing the
canonical observation — selection is manual (`POST /financials/canonical`). The
chosen value stays until someone changes it.

Only observations that **carry a value** auto-become canonical — a blank/unreadable
reading (e.g. an OCR miss) is retained but never blocks a real value that arrives
later. If the canonical observation is ever deleted (e.g. a bad document is
removed) and another valued observation for the fact survives, the canonical is
**re-selected automatically** so the fact never silently loses its value.

The chosen value is **denormalized onto the canonical row** (`financial_canonical.value`),
so scoring reads it without joining the observation table — at corpus scale that
join's random per-observation fetch dominated the read. The mirror is maintained
at every place a canonical is chosen (auto-canonical, manual selection, bulk
derivation, and the re-selection trigger) and can't drift, since an observation's
value is write-once. Upgrading an existing database backfills the column
**automatically** the first time it is opened (a one-time pass, recorded so it
never repeats); `openreturn financials backfill-values` forces/repeats it
(resumable, safe to re-run).

## Where the data comes from

- **990 filings** (the existing path) stay the raw store (`reported_data`); their
  values are **derived** into observations via each concept's `default_xml_path`.
  Derivation is idempotent and runs automatically whenever an org is scored (and
  in the ingest finalize); back-fill explicitly with `openreturn financials rebuild`.
- **Audited statements / manual entry** are recorded directly as observations:
  `POST /financials/observations` `{ein, fiscal_year, source, values:{concept:number}}`,
  or `openreturn financials import <file.json>`. A non-990 org gets a synthetic
  `FIN` filing as its scoring anchor, so it can be scored from audited data alone.
- **OCR'd 990 PDFs** add observations with a per-reading **confidence** (see the
  OCR section of [Ingest & Upload](ingest.md)).

## Reading + resolving

```
GET  /financials/concepts                 # the concept catalog (= scoring keys)
GET  /financials?ein=…&year=…             # every fact: all observations, canonical pick, conflict flag
GET  /financials/conflicts?ein=…          # facts where sources disagree and no one has chosen yet
POST /financials/observations             # record a source's values (data:write)
POST /financials/canonical                # choose the canonical observation for a fact (data:write)
```

Reads require `data:read`; writes require `data:write` (granted to admin/editor;
viewer/service read). Every write is audited.

**Needs-review flag.** A sole observation auto-becomes canonical even when it is a
low-confidence reading (e.g. OCR of a 990 PDF), so each fact also carries
`canonical_source`, `canonical_confidence`, and a derived **`review`** flag — true
when the canonical value is below the review threshold (0.80) **and** no human has
verified it (`chosen_by` is auto/NULL). The `/financials` UI lists these under
"Needs review" with a **Confirm value** action: choosing the existing observation
as canonical (`POST /financials/canonical`) records `chosen_by = <actor>`, marking
it human-verified and clearing the flag. Recording a corrected value instead turns
it into a normal conflict to resolve.

## Scoring

The engine reads the **canonical** value per concept for an org-year (single
filing via `calculate`, all years via `rebuild`), so a model input like `prog`
resolves to the chosen `prog` observation. Historical formulas read the canonical
series across years. For a 990-only org with no conflicts the chosen values equal
the 990 values, so scores are unchanged from before this layer existed. The
[score debug walkthrough](api.md#get-scoresdebug) now shows each input's
`canonical_source`, `confidence`, and `conflict` alongside the 990 field trace.
