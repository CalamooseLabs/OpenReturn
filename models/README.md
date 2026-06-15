# Scoring models

TOML scoring-model definitions, registered with `openreturn models register`. They
demonstrate the three model **kinds** and reconstruct a MinistryWatch-style financial
rating from a real ministry profile:
[Administer Justice, EIN 36-4348917](https://db.ministrywatch.com/ministry.php?ein=364348917).

## The three kinds

A model declares a `kind` (orthogonal to its `type` and `mode`):

| `kind` | Made up of… | Factor inputs |
|--------|-------------|---------------|
| `model` (default) | factors over 990 fields | field keys, numeric literals, `factor:<name>` |
| `composite` | the final **scores of base models** | `model:<version>` (+ `factor:`, literals) |
| `super_composite` | the final **scores of composites** | `model:<version>` (+ `factor:`, literals) |

A `composite`/`super_composite` factor references a child by `model:<version>`; the
engine evaluates base models → composites → super-composites so each layer's inputs
are ready. See [`docs/scoring/models.md`](../docs/scoring/models.md) for the full format.

## The hierarchy in this folder

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

## Register them

Children must be registered before their parents, so register in version order —
the filename prefixes sort that way:

```bash
for f in models/*.toml; do openreturn models register "$f"; done
# then compute scores (composites/super-composites are scored automatically):
openreturn score --rebuild
```

`openreturn models register <file> --dry-run` validates without writing.

## Caveat: relative vs. absolute scoring

MinistryWatch rates ministries **relative** to ~22 peer groups (percentile rank →
1–5 stars) and does not publish its exact per-ratio curves or weights. OpenReturn
scores one filing against the **fixed benchmark ranges** in each TOML — a
self-contained approximation, not a reproduction of MinistryWatch's stars. Tune the
`benchmark_lo`/`benchmark_hi` and `weight` values to your corpus.
