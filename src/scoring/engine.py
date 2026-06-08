from __future__ import annotations
import json
import math

_FACTOR_PREFIX = 'factor:'

_PATHS: dict[str, str] = {
    'prog':       'ReturnData/IRS990/TotalFunctionalExpensesGrp/ProgramServicesAmt',
    'admin':      'ReturnData/IRS990/TotalFunctionalExpensesGrp/ManagementAndGeneralAmt',
    'fund':       'ReturnData/IRS990/TotalFunctionalExpensesGrp/FundraisingAmt',
    'total_exp':  'ReturnData/IRS990/TotalFunctionalExpensesGrp/TotalAmt',
    'cy_exp':     'ReturnData/IRS990/CYTotalExpensesAmt',
    'py_exp':     'ReturnData/IRS990/PYTotalExpensesAmt',
    'cy_rev':     'ReturnData/IRS990/CYTotalRevenueAmt',
    'cy_grants':  'ReturnData/IRS990/CYGrantsAndSimilarPaidAmt',
    'py_grants':  'ReturnData/IRS990/PYGrantsAndSimilarPaidAmt',
    'contrib':    'ReturnData/IRS990/TotalContributionsAmt',
    'gov_grants': 'ReturnData/IRS990/GovernmentGrantsAmt',
    'invest_inc': 'ReturnData/IRS990/CYInvestmentIncomeAmt',
    'assets':     'ReturnData/IRS990/TotalAssetsEOYAmt',
    'liabilities':'ReturnData/IRS990/TotalLiabilitiesEOYAmt',
    'equity':     'ReturnData/IRS990/NetAssetsOrFundBalancesEOYAmt',
    'cash':       'ReturnData/IRS990/CashNonInterestBearingGrp/EOYAmt',
    'savings':    'ReturnData/IRS990/SavingsAndTempCashInvstGrp/EOYAmt',
    'invest_val': 'ReturnData/IRS990/InvestmentsOtherSecuritiesGrp/EOYAmt',
    'accts_pay':  'ReturnData/IRS990/AccountsPayableAccrExpnssGrp/EOYAmt',
}

# None means variable-length (1+ inputs accepted); integer means exact count required.
FORMULA_TYPES = {
    # Original
    'ratio', 'ratio_positive', 'growth', 'working_capital', 'sum_ratio',
    # Fixed, 2-input
    'difference', 'product',
    # Fixed, 3-input
    'clamp',
    # Fixed, 1-input
    'abs_value', 'inverse',
    # Variable-length (1+ inputs) — None values are skipped
    'sum', 'average', 'min', 'max', 'median',
    # Historical: operate over all available years of data for the org (1 field-key input)
    'running_average', 'cumulative_sum', 'historical_min', 'historical_max',
    'cagr', 'historical_std_dev', 'coefficient_of_variation',
}
FORMULA_INPUT_COUNTS: dict[str, int | None] = {
    'ratio':                    2,
    'ratio_positive':           2,
    'growth':                   2,
    'working_capital':          4,
    'sum_ratio':                3,
    'difference':               2,
    'product':                  2,
    'clamp':                    3,
    'abs_value':                1,
    'inverse':                  1,
    'sum':                      None,
    'average':                  None,
    'min':                      None,
    'max':                      None,
    'median':                   None,
    'running_average':          1,
    'cumulative_sum':           1,
    'historical_min':           1,
    'historical_max':           1,
    'cagr':                     1,
    'historical_std_dev':       1,
    'coefficient_of_variation': 1,
}

_HISTORICAL_TYPES = frozenset({
    'running_average', 'cumulative_sum', 'historical_min', 'historical_max',
    'cagr', 'historical_std_dev', 'coefficient_of_variation',
})


class ScoringEngine:
    def __init__(self, db) -> None:
        self.db = db

    def calculate(self, ein: str, year: int, model_version: int = 1) -> dict:
        filing = self.db.get_filing_data_by_ein_year(ein, year)
        if filing is None:
            raise ValueError(f"No filing found for EIN {ein} year {year}")

        vals = self._load_values(filing['fields'])
        factors = self.db.get_factors(model_version)
        sorted_factors = self._topo_sort(factors)

        needs_history = any(f['formula_type'] in _HISTORICAL_TYPES for f in sorted_factors)
        historical: dict[str, list[float]] = self.db.get_historical_values(ein) if needs_history else {}

        computed: dict[str, float | None] = {}
        factor_results: dict[int, tuple[float | None, float]] = {}
        for f in sorted_factors:
            raw = self._compute_factor(f, vals, computed, historical)
            computed[f['name']] = raw
            normalized = self._normalize(f, raw)
            weighted = normalized * f['weight']
            factor_results[f['factor_id']] = (raw, weighted)

        score_id = self.db.create_score(filing['filing_id'], model_version)
        self.db.store_factor_values(score_id, factor_results)
        total = sum(w for _, w in factor_results.values())
        self.db.finalize_score(score_id, total)

        return self.db.get_score(score_id)

    def _topo_sort(self, factors: list[dict]) -> list[dict]:
        name_to_factor = {f['name']: f for f in factors}
        visited:  set[str] = set()
        in_stack: set[str] = set()
        order: list[dict] = []

        def visit(name: str) -> None:
            if name in in_stack:
                raise ValueError(f"Circular factor dependency involving '{name}'")
            if name in visited:
                return
            in_stack.add(name)
            for inp in json.loads(name_to_factor[name]['inputs']):
                if inp.startswith(_FACTOR_PREFIX):
                    dep = inp[len(_FACTOR_PREFIX):]
                    if dep not in name_to_factor:
                        raise ValueError(f"Factor '{name}' references unknown factor '{dep}'")
                    visit(dep)
            in_stack.discard(name)
            visited.add(name)
            order.append(name_to_factor[name])

        for f in factors:
            visit(f['name'])
        return order

    def _load_values(self, fields: list[dict]) -> dict[str, float]:
        result: dict[str, float] = {}
        for f in fields:
            path = f.get('xml_path')
            raw = f.get('value')
            if path and raw is not None:
                try:
                    result[path] = float(raw)
                except (ValueError, TypeError):
                    pass
        return result

    def _resolve_input(self, key: str, vals: dict[str, float],
                       computed: dict[str, float | None]) -> float | None:
        if key.startswith(_FACTOR_PREFIX):
            return computed.get(key[len(_FACTOR_PREFIX):])
        try:
            return float(key)
        except (ValueError, TypeError):
            pass
        path = _PATHS.get(key)
        return vals.get(path) if path else None

    def _compute_factor(self, factor: dict, vals: dict[str, float],
                        computed: dict[str, float | None] | None = None,
                        historical: dict[str, list[float]] | None = None) -> float | None:
        if computed is None:
            computed = {}
        if historical is None:
            historical = {}
        formula_type = factor['formula_type']
        keys = json.loads(factor['inputs'])

        # --- Historical formulas ---
        if formula_type in _HISTORICAL_TYPES:
            path = _PATHS.get(keys[0]) if keys else None
            hist = historical.get(path, []) if path else []
            if not hist:
                return None
            if formula_type == 'running_average':
                return sum(hist) / len(hist)
            if formula_type == 'cumulative_sum':
                return sum(hist)
            if formula_type == 'historical_min':
                return min(hist)
            if formula_type == 'historical_max':
                return max(hist)
            if formula_type == 'cagr':
                if len(hist) < 2 or hist[0] <= 0 or hist[-1] <= 0:
                    return None
                return (hist[-1] / hist[0]) ** (1.0 / (len(hist) - 1)) - 1.0
            if formula_type == 'historical_std_dev':
                mean = sum(hist) / len(hist)
                return math.sqrt(sum((x - mean) ** 2 for x in hist) / len(hist))
            if formula_type == 'coefficient_of_variation':
                mean = sum(hist) / len(hist)
                if mean == 0:
                    return None
                std_dev = math.sqrt(sum((x - mean) ** 2 for x in hist) / len(hist))
                return std_dev / abs(mean)

        inputs = [self._resolve_input(k, vals, computed) for k in keys]

        # --- Fixed 2-input ---
        if formula_type == 'ratio':
            n, d = inputs[0], inputs[1]
            return n / d if d else None

        if formula_type == 'ratio_positive':
            n, d = inputs[0], inputs[1]
            return n / d if d and d > 0 else None

        if formula_type == 'growth':
            cy, py = inputs[0], inputs[1]
            return cy / py - 1.0 if py and py != 0 else None

        if formula_type == 'difference':
            a, b = inputs[0], inputs[1]
            return a - b if a is not None and b is not None else None

        if formula_type == 'product':
            a, b = inputs[0], inputs[1]
            return a * b if a is not None and b is not None else None

        if formula_type == 'clamp':
            v, lo, hi = inputs[0], inputs[1], inputs[2]
            return max(lo, min(hi, v)) if v is not None and lo is not None and hi is not None else None

        # --- Fixed multi-input ---
        if formula_type == 'working_capital':
            cash    = (inputs[0] or 0.0) + (inputs[1] or 0.0)
            payable = inputs[2] or 0.0
            exp     = inputs[3]
            return (cash - payable) / exp if exp else None

        if formula_type == 'sum_ratio':
            a, b, c = inputs[0], inputs[1], inputs[2]
            return (a + b) / c if c and a is not None and b is not None else None

        # --- Fixed 1-input ---
        if formula_type == 'abs_value':
            a = inputs[0]
            return abs(a) if a is not None else None

        if formula_type == 'inverse':
            a = inputs[0]
            return 1.0 / a if a else None

        # --- Variable-length (skip None inputs) ---
        non_none = [v for v in inputs if v is not None]

        if formula_type == 'sum':
            return sum(non_none) if non_none else None

        if formula_type == 'average':
            return sum(non_none) / len(non_none) if non_none else None

        if formula_type == 'min':
            return min(non_none) if non_none else None

        if formula_type == 'max':
            return max(non_none) if non_none else None

        if formula_type == 'median':
            if not non_none:
                return None
            s = sorted(non_none)
            mid = len(s) // 2
            return s[mid] if len(s) % 2 else (s[mid - 1] + s[mid]) / 2.0

        return None

    def _normalize(self, factor: dict, raw: float | None) -> float:
        """Map a raw factor value to [0, 1] using the factor's benchmark range."""
        if raw is None:
            return 0.0
        direction = factor['direction']
        lo = factor['benchmark_lo']
        hi = factor['benchmark_hi']
        span = hi - lo
        if span == 0:
            return 0.0
        if direction == 'higher':
            return max(0.0, min(1.0, (raw - lo) / span))
        else:
            return max(0.0, min(1.0, (hi - raw) / span))
