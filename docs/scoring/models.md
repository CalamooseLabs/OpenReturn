# Scoring Models

Scores represent a financial health assessment of a Form 990 filing under a versioned scoring model. Models are defined as TOML files and registered with the `openreturn-models` CLI.

## CLI

Run from the directory where `IRS990.db` lives:

```bash
openreturn-models register model_v1.toml          # validate and write to DB
openreturn-models register model_v1.toml --dry-run  # validate only, no DB write
openreturn-models list                             # list all registered versions
```

## TOML Format

```toml
[model]
version     = 1
description = "Initial financial health model"   # optional

[[factor]]
name               = "Program Efficiency"
weight             = 0.30
formula_type       = "ratio"
inputs             = ["prog", "total_exp"]
direction          = "higher"
benchmark_lo       = 0.50
benchmark_hi       = 0.85
formula_description = "Program expenses as a share of total expenses"  # optional

[[factor]]
name         = "Expense Growth"
weight       = 0.20
formula_type = "growth"
inputs       = ["cy_exp", "py_exp"]
direction    = "lower"
benchmark_lo = 0.0
benchmark_hi = 0.15
```

### Factor fields

| Field | Required | Description |
|-------|----------|-------------|
| `name` | yes | Unique label (used in `factor:<name>` references) |
| `weight` | yes | Contribution to total score; must be ≥ 0. Set to `0` for intermediate factors. |
| `formula_type` | yes | One of the types listed below |
| `inputs` | yes | Ordered list of input keys (field keys, numeric literals, or `factor:<name>`) |
| `direction` | yes | `"higher"` or `"lower"` — which end of the benchmark range scores best |
| `benchmark_lo` | yes | Lower bound for normalization |
| `benchmark_hi` | yes | Upper bound for normalization; must be > `benchmark_lo` |
| `formula_description` | no | Human-readable description of what the formula measures |

**Weights** should sum to `1.0` — a warning is printed if they don't, but it is not an error. Weights of `0` are allowed and do not contribute to the total score (useful for intermediate factors).

## Formula Types

### Fixed-input formulas

| `formula_type` | Inputs | Formula | Returns None when |
|----------------|--------|---------|-------------------|
| `ratio` | `[n, d]` | `n / d` | `d = 0` |
| `ratio_positive` | `[n, d]` | `n / d` | `d ≤ 0` |
| `growth` | `[cy, py]` | `cy / py − 1` | `py = 0` |
| `difference` | `[a, b]` | `a − b` | either input missing |
| `product` | `[a, b]` | `a × b` | either input missing |
| `clamp` | `[v, lo, hi]` | `max(lo, min(hi, v))` | any input missing |
| `abs_value` | `[a]` | `\|a\|` | input missing |
| `inverse` | `[a]` | `1 / a` | `a = 0` |
| `working_capital` | `[cash, savings, accts_pay, total_exp]` | `(cash + savings − payable) / exp` | `exp = 0` |
| `sum_ratio` | `[a, b, d]` | `(a + b) / d` | `d = 0` or either numerator missing |

### Variable-length formulas (1+ inputs; `None` values are skipped)

| `formula_type` | Formula |
|----------------|---------|
| `sum` | `a + b + …` |
| `average` | `mean(a, b, …)` |
| `min` | `min(a, b, …)` |
| `max` | `max(a, b, …)` |
| `median` | median of inputs (even-length: average of two middle values) |

All variable-length types require at least 1 input; zero inputs is a validation error.

### Historical formulas (1 field-key input; operate over all available filing years for the org)

| `formula_type` | Formula | Returns None when |
|----------------|---------|-------------------|
| `running_average` | mean of field across all years | no history |
| `cumulative_sum` | sum of field across all years | no history |
| `historical_min` | minimum across all years | no history |
| `historical_max` | maximum across all years | no history |
| `cagr` | `(last / first)^(1 / (n−1)) − 1` | < 2 years, or either endpoint ≤ 0 |
| `historical_std_dev` | population standard deviation | no history |
| `coefficient_of_variation` | `std_dev / \|mean\|` | no history, or mean = 0 |

Historical formulas take exactly 1 input — a field key (not `factor:<name>`). The engine fetches all available years for the organization on first use and caches the result for the duration of the scoring call.

## Input Keys

### IRS Form 990 field keys

| Key | Form 990 field |
|-----|----------------|
| `prog` | Program services expenses |
| `admin` | Management & general expenses |
| `fund` | Fundraising expenses |
| `total_exp` | Total functional expenses |
| `cy_exp` | Current year total expenses |
| `py_exp` | Prior year total expenses |
| `cy_rev` | Current year total revenue |
| `cy_grants` | Current year grants paid |
| `py_grants` | Prior year grants paid |
| `contrib` | Total contributions |
| `gov_grants` | Government grants |
| `invest_inc` | Investment income |
| `assets` | Total assets (EOY) |
| `liabilities` | Total liabilities (EOY) |
| `equity` | Net assets / fund balances (EOY) |
| `cash` | Cash (EOY) |
| `savings` | Savings & temp cash investments (EOY) |
| `invest_val` | Other investments (EOY) |
| `accts_pay` | Accounts payable & accrued expenses (EOY) |

### Other input types

| Syntax | Example | Resolves to |
|--------|---------|-------------|
| `factor:<name>` | `factor:Expense Ratio` | Raw computed value of a previously evaluated factor |
| numeric literal | `"0"`, `"1.0"`, `"-0.5"` | The literal float value |

Numeric literals are useful for `clamp` bounds: `inputs = ["cy_rev", "0", "1000000"]`.

## Normalization

Each raw factor value is mapped to `[0, 1]` using the factor's benchmark range:

- `direction = "higher"`: `clamp((raw − lo) / (hi − lo), 0, 1)`
- `direction = "lower"`: `clamp((hi − raw) / (hi − lo), 0, 1)`

If the raw value is `None` (formula returned no result), the normalized value is `0.0`.

The final score is the sum of all `normalized × weight` values. If weights sum to 1.0 the total score is in `[0, 1]`.

## Intermediate (Derived) Factors

A factor can reference another factor's raw (pre-normalization) value using `factor:<name>`. Set `weight = 0` on the upstream factor so it is computed and stored but does not contribute to the total score.

```toml
[[factor]]
name         = "Expense Ratio"
weight       = 0.0                    # computed but excluded from total
formula_type = "ratio"
inputs       = ["prog", "total_exp"]
direction    = "higher"
benchmark_lo = 0.5
benchmark_hi = 0.85

[[factor]]
name         = "Adjusted Efficiency"
weight       = 0.30
formula_type = "ratio"
inputs       = ["factor:Expense Ratio", "cy_rev"]
direction    = "higher"
benchmark_lo = 0.0
benchmark_hi = 0.001
```

Factors are evaluated in dependency order automatically. Circular references are caught at registration time and rejected.
