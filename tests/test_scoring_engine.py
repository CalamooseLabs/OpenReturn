import sys
import os
import unittest
from unittest.mock import MagicMock

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

from scoring.engine import ScoringEngine, _PATHS, _BENCHMARKS


def _build_vals(**kwargs):
    """Build a vals dict from shorthand keys using _PATHS."""
    return {_PATHS[k]: v for k, v in kwargs.items()}


# ---------------------------------------------------------------------------
# _load_values
# ---------------------------------------------------------------------------

class TestLoadValues(unittest.TestCase):
    def setUp(self):
        self.engine = ScoringEngine(db=None)

    def _field(self, xml_path=None, value=None):
        return {'xml_path': xml_path, 'value': value}

    def test_normal_float_conversion(self):
        fields = [self._field(_PATHS['prog'], '100000')]
        result = self.engine._load_values(fields)
        self.assertAlmostEqual(result[_PATHS['prog']], 100000.0)

    def test_integer_value_converted(self):
        fields = [self._field(_PATHS['admin'], 5000)]
        result = self.engine._load_values(fields)
        self.assertAlmostEqual(result[_PATHS['admin']], 5000.0)

    def test_non_numeric_value_skipped(self):
        fields = [self._field(_PATHS['prog'], 'not-a-number')]
        result = self.engine._load_values(fields)
        self.assertNotIn(_PATHS['prog'], result)

    def test_none_value_skipped(self):
        fields = [self._field(_PATHS['prog'], None)]
        result = self.engine._load_values(fields)
        self.assertNotIn(_PATHS['prog'], result)

    def test_missing_path_skipped(self):
        fields = [{'xml_path': None, 'value': '500'}]
        result = self.engine._load_values(fields)
        self.assertEqual(result, {})

    def test_empty_fields_returns_empty(self):
        result = self.engine._load_values([])
        self.assertEqual(result, {})

    def test_multiple_fields_mixed(self):
        fields = [
            self._field(_PATHS['prog'], '200'),
            self._field(_PATHS['admin'], 'bad'),
            self._field(None, '999'),
            self._field(_PATHS['fund'], None),
            self._field(_PATHS['total_exp'], '1000'),
        ]
        result = self.engine._load_values(fields)
        self.assertIn(_PATHS['prog'], result)
        self.assertIn(_PATHS['total_exp'], result)
        self.assertNotIn(_PATHS['admin'], result)
        self.assertNotIn(_PATHS['fund'], result)


# ---------------------------------------------------------------------------
# _normalize
# ---------------------------------------------------------------------------

class TestNormalize(unittest.TestCase):
    def setUp(self):
        self.engine = ScoringEngine(db=None)

    def test_raw_none_returns_zero(self):
        self.assertEqual(self.engine._normalize('Program Expense', None), 0.0)

    def test_higher_below_lo_returns_zero(self):
        # Program Expense: higher, lo=0.60, hi=0.85 — raw below 0.60
        result = self.engine._normalize('Program Expense', 0.10)
        self.assertEqual(result, 0.0)

    def test_higher_above_hi_returns_one(self):
        result = self.engine._normalize('Program Expense', 0.95)
        self.assertEqual(result, 1.0)

    def test_higher_in_range(self):
        # lo=0.60, hi=0.85, raw=0.725 → (0.725-0.60)/(0.25) = 0.5
        result = self.engine._normalize('Program Expense', 0.725)
        self.assertAlmostEqual(result, 0.5)

    def test_lower_above_hi_returns_zero(self):
        # Admin Expense: lower, lo=0.10, hi=0.30 — raw above 0.30
        result = self.engine._normalize('Admin Expense', 0.40)
        self.assertEqual(result, 0.0)

    def test_lower_below_lo_returns_one(self):
        result = self.engine._normalize('Admin Expense', 0.05)
        self.assertEqual(result, 1.0)

    def test_lower_in_range(self):
        # lo=0.10, hi=0.30, raw=0.20 → (0.30-0.20)/0.20 = 0.5
        result = self.engine._normalize('Admin Expense', 0.20)
        self.assertAlmostEqual(result, 0.5)

    def test_span_zero_returns_zero(self):
        # Inject a benchmark with lo == hi by temporarily patching _BENCHMARKS
        import scoring.engine as eng_mod
        original = eng_mod._BENCHMARKS.copy()
        eng_mod._BENCHMARKS['_ZeroSpan'] = ('higher', 0.5, 0.5)
        try:
            result = self.engine._normalize('_ZeroSpan', 0.5)
            self.assertEqual(result, 0.0)
        finally:
            eng_mod._BENCHMARKS.clear()
            eng_mod._BENCHMARKS.update(original)


# ---------------------------------------------------------------------------
# _compute_factor — all 14 named factors + fallthrough
# ---------------------------------------------------------------------------

class TestComputeFactor(unittest.TestCase):
    def setUp(self):
        self.engine = ScoringEngine(db=None)

    # --- Program Expense ---

    def test_program_expense_normal(self):
        vals = _build_vals(prog=700.0, total_exp=1000.0)
        result = self.engine._compute_factor('Program Expense', vals)
        self.assertAlmostEqual(result, 0.7)

    def test_program_expense_zero_total(self):
        vals = _build_vals(prog=700.0, total_exp=0.0)
        result = self.engine._compute_factor('Program Expense', vals)
        self.assertIsNone(result)

    def test_program_expense_missing_total(self):
        vals = _build_vals(prog=700.0)
        result = self.engine._compute_factor('Program Expense', vals)
        self.assertIsNone(result)

    # --- Admin Expense ---

    def test_admin_expense_normal(self):
        vals = _build_vals(admin=100.0, total_exp=1000.0)
        result = self.engine._compute_factor('Admin Expense', vals)
        self.assertAlmostEqual(result, 0.1)

    def test_admin_expense_zero_total(self):
        vals = _build_vals(admin=100.0, total_exp=0.0)
        result = self.engine._compute_factor('Admin Expense', vals)
        self.assertIsNone(result)

    # --- Fundraising Expense ---

    def test_fundraising_expense_normal(self):
        vals = _build_vals(fund=50.0, total_exp=1000.0)
        result = self.engine._compute_factor('Fundraising Expense', vals)
        self.assertAlmostEqual(result, 0.05)

    def test_fundraising_expense_zero_total(self):
        vals = _build_vals(fund=50.0, total_exp=0.0)
        result = self.engine._compute_factor('Fundraising Expense', vals)
        self.assertIsNone(result)

    # --- Fundraising Efficiency ---

    def test_fundraising_efficiency_normal(self):
        vals = _build_vals(fund=50.0, contrib=500.0)
        result = self.engine._compute_factor('Fundraising Efficiency', vals)
        self.assertAlmostEqual(result, 0.1)

    def test_fundraising_efficiency_zero_contrib(self):
        vals = _build_vals(fund=50.0, contrib=0.0)
        result = self.engine._compute_factor('Fundraising Efficiency', vals)
        self.assertIsNone(result)

    def test_fundraising_efficiency_missing_contrib(self):
        vals = _build_vals(fund=50.0)
        result = self.engine._compute_factor('Fundraising Efficiency', vals)
        self.assertIsNone(result)

    # --- Program Expense Growth ---

    def test_program_expense_growth_normal(self):
        vals = _build_vals(cy_grants=110.0, py_grants=100.0)
        result = self.engine._compute_factor('Program Expense Growth', vals)
        self.assertAlmostEqual(result, 0.1)

    def test_program_expense_growth_zero_py(self):
        vals = _build_vals(cy_grants=110.0, py_grants=0.0)
        result = self.engine._compute_factor('Program Expense Growth', vals)
        self.assertIsNone(result)

    def test_program_expense_growth_missing_py(self):
        vals = _build_vals(cy_grants=110.0)
        result = self.engine._compute_factor('Program Expense Growth', vals)
        self.assertIsNone(result)

    # --- Assets to Liabilities Ratio ---

    def test_assets_to_liabilities_normal(self):
        vals = _build_vals(liabilities=300.0, assets=1000.0)
        result = self.engine._compute_factor('Assets to Liabilities Ratio', vals)
        self.assertAlmostEqual(result, 0.3)

    def test_assets_to_liabilities_zero_assets(self):
        vals = _build_vals(liabilities=300.0, assets=0.0)
        result = self.engine._compute_factor('Assets to Liabilities Ratio', vals)
        self.assertIsNone(result)

    def test_assets_to_liabilities_missing_assets(self):
        vals = _build_vals(liabilities=300.0)
        result = self.engine._compute_factor('Assets to Liabilities Ratio', vals)
        self.assertIsNone(result)

    # --- Debt to Equity Ratio ---

    def test_debt_to_equity_normal(self):
        vals = _build_vals(liabilities=200.0, equity=800.0)
        result = self.engine._compute_factor('Debt to Equity Ratio', vals)
        self.assertAlmostEqual(result, 0.25)

    def test_debt_to_equity_zero_equity(self):
        vals = _build_vals(liabilities=200.0, equity=0.0)
        result = self.engine._compute_factor('Debt to Equity Ratio', vals)
        self.assertIsNone(result)

    def test_debt_to_equity_negative_equity(self):
        vals = _build_vals(liabilities=200.0, equity=-100.0)
        result = self.engine._compute_factor('Debt to Equity Ratio', vals)
        self.assertIsNone(result)

    def test_debt_to_equity_missing_equity(self):
        vals = _build_vals(liabilities=200.0)
        result = self.engine._compute_factor('Debt to Equity Ratio', vals)
        self.assertIsNone(result)

    # --- Working Capital Ratio ---

    def test_working_capital_normal(self):
        # cash=500, savings=200, accts_pay=100, cy_exp=1200
        vals = _build_vals(cash=500.0, savings=200.0, accts_pay=100.0, cy_exp=1200.0)
        result = self.engine._compute_factor('Working Capital Ratio', vals)
        self.assertAlmostEqual(result, (500.0 + 200.0 - 100.0) / 1200.0)

    def test_working_capital_missing_optionals(self):
        # cash and savings default to 0, accts_pay defaults to 0
        vals = _build_vals(cy_exp=1000.0)
        result = self.engine._compute_factor('Working Capital Ratio', vals)
        self.assertAlmostEqual(result, 0.0)

    def test_working_capital_zero_exp(self):
        vals = _build_vals(cash=500.0, savings=200.0, accts_pay=100.0, cy_exp=0.0)
        result = self.engine._compute_factor('Working Capital Ratio', vals)
        self.assertIsNone(result)

    def test_working_capital_missing_exp(self):
        vals = _build_vals(cash=500.0)
        result = self.engine._compute_factor('Working Capital Ratio', vals)
        self.assertIsNone(result)

    # --- Government Reliance ---

    def test_government_reliance_normal(self):
        vals = _build_vals(gov_grants=300.0, contrib=600.0)
        result = self.engine._compute_factor('Government Reliance', vals)
        self.assertAlmostEqual(result, 0.5)

    def test_government_reliance_zero_contrib(self):
        vals = _build_vals(gov_grants=300.0, contrib=0.0)
        result = self.engine._compute_factor('Government Reliance', vals)
        self.assertIsNone(result)

    def test_government_reliance_missing_contrib(self):
        vals = _build_vals(gov_grants=300.0)
        result = self.engine._compute_factor('Government Reliance', vals)
        self.assertIsNone(result)

    # --- Excess/Deficit at Year End ---

    def test_excess_deficit_normal(self):
        vals = _build_vals(cy_rev=1100.0, cy_exp=1000.0)
        result = self.engine._compute_factor('Excess/Deficit at Year End', vals)
        self.assertAlmostEqual(result, 1.1)

    def test_excess_deficit_zero_exp(self):
        vals = _build_vals(cy_rev=1100.0, cy_exp=0.0)
        result = self.engine._compute_factor('Excess/Deficit at Year End', vals)
        self.assertIsNone(result)

    def test_excess_deficit_missing_exp(self):
        vals = _build_vals(cy_rev=1100.0)
        result = self.engine._compute_factor('Excess/Deficit at Year End', vals)
        self.assertIsNone(result)

    # --- % Gift is of Revenue ---

    def test_gift_of_revenue_normal(self):
        vals = _build_vals(contrib=800.0, cy_rev=1000.0)
        result = self.engine._compute_factor('% Gift is of Revenue', vals)
        self.assertAlmostEqual(result, 0.8)

    def test_gift_of_revenue_zero_rev(self):
        vals = _build_vals(contrib=800.0, cy_rev=0.0)
        result = self.engine._compute_factor('% Gift is of Revenue', vals)
        self.assertIsNone(result)

    def test_gift_of_revenue_missing_rev(self):
        vals = _build_vals(contrib=800.0)
        result = self.engine._compute_factor('% Gift is of Revenue', vals)
        self.assertIsNone(result)

    # --- Dependence on Gifts/Grants ---

    def test_dependence_on_gifts_normal(self):
        vals = _build_vals(contrib=600.0, cy_exp=1000.0)
        result = self.engine._compute_factor('Dependence on Gifts/Grants', vals)
        self.assertAlmostEqual(result, 0.6)

    def test_dependence_on_gifts_zero_exp(self):
        vals = _build_vals(contrib=600.0, cy_exp=0.0)
        result = self.engine._compute_factor('Dependence on Gifts/Grants', vals)
        self.assertIsNone(result)

    def test_dependence_on_gifts_missing_exp(self):
        vals = _build_vals(contrib=600.0)
        result = self.engine._compute_factor('Dependence on Gifts/Grants', vals)
        self.assertIsNone(result)

    # --- Return on Investments ---

    def test_return_on_investments_normal(self):
        vals = _build_vals(invest_inc=50.0, invest_val=1000.0)
        result = self.engine._compute_factor('Return on Investments', vals)
        self.assertAlmostEqual(result, 0.05)

    def test_return_on_investments_zero_inv(self):
        vals = _build_vals(invest_inc=50.0, invest_val=0.0)
        result = self.engine._compute_factor('Return on Investments', vals)
        self.assertIsNone(result)

    def test_return_on_investments_missing_inv(self):
        vals = _build_vals(invest_inc=50.0)
        result = self.engine._compute_factor('Return on Investments', vals)
        self.assertIsNone(result)

    # --- Admin Cost Ratio ---

    def test_admin_cost_ratio_normal(self):
        vals = _build_vals(admin=100.0, fund=50.0, total_exp=1000.0)
        result = self.engine._compute_factor('Admin Cost Ratio', vals)
        self.assertAlmostEqual(result, 0.15)

    def test_admin_cost_ratio_zero_total(self):
        vals = _build_vals(admin=100.0, fund=50.0, total_exp=0.0)
        result = self.engine._compute_factor('Admin Cost Ratio', vals)
        self.assertIsNone(result)

    def test_admin_cost_ratio_missing_total(self):
        vals = _build_vals(admin=100.0, fund=50.0)
        result = self.engine._compute_factor('Admin Cost Ratio', vals)
        self.assertIsNone(result)

    def test_admin_cost_ratio_missing_admin(self):
        vals = _build_vals(fund=50.0, total_exp=1000.0)
        result = self.engine._compute_factor('Admin Cost Ratio', vals)
        self.assertIsNone(result)

    def test_admin_cost_ratio_missing_fund(self):
        vals = _build_vals(admin=100.0, total_exp=1000.0)
        result = self.engine._compute_factor('Admin Cost Ratio', vals)
        self.assertIsNone(result)

    # --- Unknown factor name (fallthrough) ---

    def test_unknown_factor_returns_none(self):
        vals = _build_vals(prog=700.0, total_exp=1000.0)
        result = self.engine._compute_factor('Unknown', vals)
        self.assertIsNone(result)


# ---------------------------------------------------------------------------
# calculate()
# ---------------------------------------------------------------------------

class TestCalculate(unittest.TestCase):
    def _make_db(self, filing=None):
        db = MagicMock()
        db.get_filing_data_by_ein_year.return_value = filing
        return db

    def test_raises_value_error_when_no_filing(self):
        db = self._make_db(filing=None)
        engine = ScoringEngine(db=db)
        with self.assertRaises(ValueError) as ctx:
            engine.calculate('12-3456789', 2023)
        self.assertIn('12-3456789', str(ctx.exception))
        self.assertIn('2023', str(ctx.exception))

    def test_calculate_normal_path(self):
        # Build a realistic filing payload with all fields populated
        fields = []
        for key, path in _PATHS.items():
            fields.append({'xml_path': path, 'value': '1000'})

        filing = {'filing_id': 42, 'fields': fields}

        factors = [
            {'factor_id': 1, 'name': 'Program Expense',             'weight': 0.1},
            {'factor_id': 2, 'name': 'Admin Expense',               'weight': 0.1},
            {'factor_id': 3, 'name': 'Fundraising Expense',         'weight': 0.05},
            {'factor_id': 4, 'name': 'Fundraising Efficiency',      'weight': 0.05},
            {'factor_id': 5, 'name': 'Program Expense Growth',      'weight': 0.05},
            {'factor_id': 6, 'name': 'Assets to Liabilities Ratio', 'weight': 0.1},
            {'factor_id': 7, 'name': 'Debt to Equity Ratio',        'weight': 0.1},
            {'factor_id': 8, 'name': 'Working Capital Ratio',       'weight': 0.05},
            {'factor_id': 9, 'name': 'Government Reliance',         'weight': 0.05},
            {'factor_id': 10, 'name': 'Excess/Deficit at Year End', 'weight': 0.1},
            {'factor_id': 11, 'name': '% Gift is of Revenue',       'weight': 0.05},
            {'factor_id': 12, 'name': 'Dependence on Gifts/Grants', 'weight': 0.05},
            {'factor_id': 13, 'name': 'Return on Investments',      'weight': 0.05},
            {'factor_id': 14, 'name': 'Admin Cost Ratio',           'weight': 0.1},
        ]

        expected_score = {'score_id': 99, 'total': 0.72}

        db = MagicMock()
        db.get_filing_data_by_ein_year.return_value = filing
        db.get_factors.return_value = factors
        db.create_score.return_value = 99
        db.get_score.return_value = expected_score

        engine = ScoringEngine(db=db)
        result = engine.calculate('12-3456789', 2023, model_version=1)

        # Verify DB interactions
        db.get_filing_data_by_ein_year.assert_called_once_with('12-3456789', 2023)
        db.get_factors.assert_called_once_with(1)
        db.create_score.assert_called_once_with(42, 1)
        db.store_factor_values.assert_called_once()
        db.finalize_score.assert_called_once()
        db.get_score.assert_called_once_with(99)

        self.assertEqual(result, expected_score)

    def test_calculate_finalize_receives_correct_total(self):
        """Verify the summed weighted score passed to finalize_score."""
        fields = []
        # All values = 1000, so every computable factor produces a float
        for path in _PATHS.values():
            fields.append({'xml_path': path, 'value': '1000'})

        filing = {'filing_id': 7, 'fields': fields}

        # Single factor so total == its weighted score
        raw_factor_weight = 0.5
        factors = [
            {'factor_id': 1, 'name': 'Program Expense', 'weight': raw_factor_weight},
        ]

        db = MagicMock()
        db.get_filing_data_by_ein_year.return_value = filing
        db.get_factors.return_value = factors
        db.create_score.return_value = 1
        db.get_score.return_value = {}

        engine = ScoringEngine(db=db)
        engine.calculate('00-0000000', 2022)

        # Extract the total that was passed to finalize_score
        call_args = db.finalize_score.call_args
        score_id_arg, total_arg = call_args[0]
        self.assertEqual(score_id_arg, 1)
        # Program Expense with all vals=1000: prog/total_exp = 1000/1000 = 1.0
        # normalize higher: (1.0 - 0.60)/(0.85-0.60) = 1.6 → clamped to 1.0
        # weighted = 1.0 * 0.5 = 0.5
        self.assertAlmostEqual(total_arg, 0.5)

    def test_calculate_with_none_factor_raw(self):
        """Factors that produce None raw values contribute 0.0 (normalized) weight."""
        # Supply no field values so every _compute_factor returns None
        filing = {'filing_id': 3, 'fields': []}

        factors = [
            {'factor_id': 1, 'name': 'Program Expense', 'weight': 1.0},
        ]

        db = MagicMock()
        db.get_filing_data_by_ein_year.return_value = filing
        db.get_factors.return_value = factors
        db.create_score.return_value = 5
        db.get_score.return_value = {}

        engine = ScoringEngine(db=db)
        engine.calculate('00-0000001', 2021)

        call_args = db.finalize_score.call_args[0]
        total_arg = call_args[1]
        # None raw → _normalize returns 0.0 → weighted = 0.0 * 1.0 = 0.0
        self.assertAlmostEqual(total_arg, 0.0)


if __name__ == '__main__':
    unittest.main()
