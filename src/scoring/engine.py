from __future__ import annotations
import json

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

FORMULA_TYPES = {'ratio', 'ratio_positive', 'growth', 'working_capital', 'sum_ratio'}
FORMULA_INPUT_COUNTS = {
    'ratio':           2,
    'ratio_positive':  2,
    'growth':          2,
    'working_capital': 4,
    'sum_ratio':       3,
}


class ScoringEngine:
    def __init__(self, db) -> None:
        self.db = db

    def calculate(self, ein: str, year: int, model_version: int = 1) -> dict:
        filing = self.db.get_filing_data_by_ein_year(ein, year)
        if filing is None:
            raise ValueError(f"No filing found for EIN {ein} year {year}")

        vals = self._load_values(filing['fields'])
        factors = self.db.get_factors(model_version)

        factor_results: dict[int, tuple[float | None, float]] = {}
        for f in factors:
            raw = self._compute_factor(f, vals)
            normalized = self._normalize(f, raw)
            weighted = normalized * f['weight']
            factor_results[f['factor_id']] = (raw, weighted)

        score_id = self.db.create_score(filing['filing_id'], model_version)
        self.db.store_factor_values(score_id, factor_results)
        total = sum(w for _, w in factor_results.values())
        self.db.finalize_score(score_id, total)

        return self.db.get_score(score_id)

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

    def _v(self, vals: dict[str, float], key: str) -> float | None:
        return vals.get(_PATHS[key])

    def _compute_factor(self, factor: dict, vals: dict[str, float]) -> float | None:
        """Compute a raw factor value from filing data using the factor's formula_type and inputs."""
        formula_type = factor['formula_type']
        keys = json.loads(factor['inputs'])
        inputs = [self._v(vals, k) for k in keys]

        if formula_type == 'ratio':
            n, d = inputs[0], inputs[1]
            return n / d if d else None

        if formula_type == 'ratio_positive':
            n, d = inputs[0], inputs[1]
            return n / d if d and d > 0 else None

        if formula_type == 'growth':
            cy, py = inputs[0], inputs[1]
            return cy / py - 1.0 if py and py != 0 else None

        if formula_type == 'working_capital':
            cash    = (inputs[0] or 0.0) + (inputs[1] or 0.0)
            payable = inputs[2] or 0.0
            exp     = inputs[3]
            return (cash - payable) / exp if exp else None

        if formula_type == 'sum_ratio':
            a, b, c = inputs[0], inputs[1], inputs[2]
            if c and a is not None and b is not None:
                return (a + b) / c
            return None

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
