# Model templates (catalog)

The bundled **model-template catalog**: read-only scoring-model definitions that
**prefill** a model builder — you can't "enable" a template, you create a model from
it (optionally edited) via the admin builder or the CLI. They demonstrate the three
model **kinds** and reconstruct a MinistryWatch-style financial rating from a real
ministry profile:
[Administer Justice, EIN 36-4348917](https://db.ministrywatch.com/ministry.php?ein=364348917).

The frontend lists templates (`GET /templates`) and fetches one
(`GET /templates/detail?code=…`) to seed its editor; `openreturn templates list` /
`show <code>` do the same from the CLI. Add a template by dropping a `.toml` here.

## The three kinds

A model declares a `kind` (orthogonal to its `type` and `mode`):

| `kind` | Made up of… | Factor inputs |
|--------|-------------|---------------|
| `model` (default) | factors over 990 fields | field keys, numeric literals, `factor:<name>` |
| `composite` | the final **scores of base models** | `model:<version>` (+ `factor:`, literals) |
| `super_composite` | the final **scores of composites** | `model:<version>` (+ `factor:`, literals) |

A `composite`/`super_composite` factor references a child by `model:<version>`; the
engine evaluates base models → composites → super-composites so each layer's inputs
are ready. See [`docs/scoring/models.md`](../../docs/scoring/models.md) for the full format.

## The hierarchy in this catalog

```
Overall Score (super_composite, v30)
└── Financial (composite, v20)
    ├── Operating Ratios            (model, v10)   ← Resource Allocation ratios
    ├── Funding Ratios              (model, v11)   ← Fund Acquisition ratios
    ├── Liquidity & Solvency Ratios (model, v12)   ┐ Asset Utilization ratios
    └── Investing Ratios            (model, v13)   ┘
```

Each base model turns the individual MinistryWatch ratios into weighted factors;
the **Financial** composite weights those four models into one financial score; the
**Overall Score** super composite is where the other org pillars (Leadership,
Whole-Person Impact, Christ-Centeredness) plug in — for now it is Financial at
weight 1.0. Weights are illustrative; adjust them (and the benchmarks) freely.

## Create models from these templates

A template is a *guide*, not an active model — create a model from it (edited as you
like). A composite references its children by version, so create base models before
their parents (the filename prefixes sort that way):

```bash
# from the catalog, via the CLI:
openreturn templates show 10-operating-ratios > /tmp/m.toml   # then edit /tmp/m.toml
openreturn models register /tmp/m.toml
# or build the whole MinistryWatch stack in version order:
for c in 10-operating-ratios 11-funding-ratios 12-liquidity-solvency-ratios \
         13-investing-ratios 20-financial-composite 30-overall-score; do
  openreturn templates show "$c" | openreturn models register /dev/stdin
done
openreturn score --rebuild
```

Over HTTP the admin model builder does the same: prefill from `GET /templates/detail`,
then `POST /admin/models` (a `dry_run` flag validates without writing).
`openreturn models register <file> --dry-run` is the CLI equivalent.

## Completing a multi-year history (optional)

By default an org's score history has gaps where a year is missing data. To fill
them MinistryWatch-style — so `GET /scores/history` returns a value for every year
from the org's earliest data forward — give an input (or a whole model) a
**missing-data fallback**:

```toml
[model]
version      = 20
kind         = "composite"
missing_data = "closest_newer"   # default fallback for every input in this model

[[factor]]
name         = "Program Expense"
formula_type = "ratio"
# or per-input: total_exp falls back; prog stays strict.
inputs       = [{ key = "prog" }, { key = "total_exp", missing = "closest_newer" }]
```

Strategies: `newest`, `oldest`, `closest_older`, `closest_newer`, `value:<x>`, or
`none` (default, no fill). Filled years are flagged `imputed` with the donor
`source_year`. **The templates here set `missing_data = "closest_newer"`** so a model
built from them has a complete history from the org's earliest data forward (carry the
nearest year into a gap, preferring the more recent on a tie) — drop the line to turn
fill off. Full rules: [Scoring Models → Missing-data fallbacks](../../docs/scoring/models.md#missing-data-fallbacks-completing-a-multi-year-history).

## Caveat: relative vs. absolute scoring

MinistryWatch rates ministries **relative** to ~22 peer groups (percentile rank →
1–5 stars) and does not publish its exact per-ratio curves or weights. OpenReturn
scores one filing against the **fixed benchmark ranges** in each TOML — a
self-contained approximation, not a reproduction of MinistryWatch's stars. Tune the
`benchmark_lo`/`benchmark_hi` and `weight` values to your corpus.
