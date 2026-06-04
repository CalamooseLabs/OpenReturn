from __future__ import annotations

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

# (direction, lo, hi) — lo=worst, hi=best for 'higher'; lo=best, hi=worst for 'lower'
_BENCHMARKS: dict[str, tuple[str, float, float]] = {
    'Program Expense':             ('higher', 0.60, 0.85),
    'Admin Expense':               ('lower',  0.10, 0.30),
    'Fundraising Expense':         ('lower',  0.05, 0.30),
    'Fundraising Efficiency':      ('lower',  0.05, 0.35),
    'Program Expense Growth':      ('higher', -0.20, 0.20),
    'Assets to Liabilities Ratio': ('lower',  0.10, 0.75),
    'Debt to Equity Ratio':        ('lower',  0.10, 2.00),
    'Working Capital Ratio':       ('higher', 0.00, 0.50),
    'Government Reliance':         ('lower',  0.00, 0.75),
    'Excess/Deficit at Year End':  ('higher', 0.90, 1.10),
    '% Gift is of Revenue':        ('higher', 0.40, 0.95),
    'Dependence on Gifts/Grants':  ('higher', 0.50, 1.20),
    'Return on Investments':       ('higher', 0.00, 0.10),
    'Admin Cost Ratio':            ('lower',  0.10, 0.40),
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
            raw = self._compute_factor(f['name'], vals)
            normalized = self._normalize(f['name'], raw)
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

    def _compute_factor(self, name: str, vals: dict[str, float]) -> float | None:
        v = lambda k: self._v(vals, k)

        if name == 'Program Expense':
            prog, total = v('prog'), v('total_exp')
            return prog / total if total else None

        if name == 'Admin Expense':
            admin, total = v('admin'), v('total_exp')
            return admin / total if total else None

        if name == 'Fundraising Expense':
            fund, total = v('fund'), v('total_exp')
            return fund / total if total else None

        if name == 'Fundraising Efficiency':
            fund, contrib = v('fund'), v('contrib')
            return fund / contrib if contrib else None

        if name == 'Program Expense Growth':
            cy, py = v('cy_grants'), v('py_grants')
            return cy / py - 1.0 if py and py != 0 else None

        if name == 'Assets to Liabilities Ratio':
            liab, assets = v('liabilities'), v('assets')
            return liab / assets if assets else None

        if name == 'Debt to Equity Ratio':
            liab, equity = v('liabilities'), v('equity')
            return liab / equity if equity and equity > 0 else None

        if name == 'Working Capital Ratio':
            cash = (v('cash') or 0.0) + (v('savings') or 0.0)
            payable = v('accts_pay') or 0.0
            exp = v('cy_exp')
            return (cash - payable) / exp if exp else None

        if name == 'Government Reliance':
            gov, contrib = v('gov_grants'), v('contrib')
            return gov / contrib if contrib else None

        if name == 'Excess/Deficit at Year End':
            rev, exp = v('cy_rev'), v('cy_exp')
            return rev / exp if exp else None

        if name == '% Gift is of Revenue':
            contrib, rev = v('contrib'), v('cy_rev')
            return contrib / rev if rev else None

        if name == 'Dependence on Gifts/Grants':
            contrib, exp = v('contrib'), v('cy_exp')
            return contrib / exp if exp else None

        if name == 'Return on Investments':
            inc, inv = v('invest_inc'), v('invest_val')
            return inc / inv if inv else None

        if name == 'Admin Cost Ratio':
            admin, fund, total = v('admin'), v('fund'), v('total_exp')
            if total and admin is not None and fund is not None:
                return (admin + fund) / total
            return None

        return None

    def _normalize(self, name: str, raw: float | None) -> float:
        if raw is None:
            return 0.0
        direction, lo, hi = _BENCHMARKS[name]
        span = hi - lo
        if span == 0:
            return 0.0
        if direction == 'higher':
            return max(0.0, min(1.0, (raw - lo) / span))
        else:
            return max(0.0, min(1.0, (hi - raw) / span))
