import sys
import os
import json
import unittest
from unittest.mock import MagicMock

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

from scoring.engine import ScoringEngine, _PATHS, FORMULA_TYPES, FORMULA_INPUT_COUNTS


def _build_vals(**kwargs):
    """Build a vals dict from shorthand keys using _PATHS."""
    return {_PATHS[k]: v for k, v in kwargs.items()}


def _factor(formula_type: str, inputs: list[str], direction: str = 'higher',
            lo: float = 0.0, hi: float = 1.0, weight: float = 0.1) -> dict:
    """Build a minimal factor dict for use with _compute_factor / _normalize."""
    return {
        'factor_id':    1,
        'name':         'Test',
        'weight':       weight,
        'formula_type': formula_type,
        'inputs':       json.dumps(inputs),
        'direction':    direction,
        'benchmark_lo': lo,
        'benchmark_hi': hi,
        'formula_description': '',
    }


# ---------------------------------------------------------------------------
# Module-level constants
# ---------------------------------------------------------------------------

class TestModuleConstants(unittest.TestCase):

    def test_paths_is_dict(self):
        self.assertIsInstance(_PATHS, dict)

    def test_paths_has_19_keys(self):
        self.assertEqual(len(_PATHS), 19)

    def test_formula_types_is_set(self):
        self.assertIsInstance(FORMULA_TYPES, set)

    def test_formula_types_contains_expected(self):
        for ft in ('ratio', 'ratio_positive', 'growth', 'working_capital', 'sum_ratio'):
            self.assertIn(ft, FORMULA_TYPES)

    def test_formula_input_counts_all_types_covered(self):
        for ft in FORMULA_TYPES:
            self.assertIn(ft, FORMULA_INPUT_COUNTS)

    def test_formula_input_counts_values(self):
        self.assertEqual(FORMULA_INPUT_COUNTS['ratio'],           2)
        self.assertEqual(FORMULA_INPUT_COUNTS['ratio_positive'],  2)
        self.assertEqual(FORMULA_INPUT_COUNTS['growth'],          2)
        self.assertEqual(FORMULA_INPUT_COUNTS['working_capital'], 4)
        self.assertEqual(FORMULA_INPUT_COUNTS['sum_ratio'],       3)


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
        f = _factor('ratio', ['prog', 'total_exp'], 'higher', 0.60, 0.85)
        self.assertEqual(self.engine._normalize(f, None), 0.0)

    def test_higher_below_lo_returns_zero(self):
        f = _factor('ratio', ['prog', 'total_exp'], 'higher', 0.60, 0.85)
        result = self.engine._normalize(f, 0.10)
        self.assertEqual(result, 0.0)

    def test_higher_above_hi_returns_one(self):
        f = _factor('ratio', ['prog', 'total_exp'], 'higher', 0.60, 0.85)
        result = self.engine._normalize(f, 0.95)
        self.assertEqual(result, 1.0)

    def test_higher_in_range(self):
        # lo=0.60, hi=0.85, raw=0.725 → (0.725-0.60)/0.25 = 0.5
        f = _factor('ratio', ['prog', 'total_exp'], 'higher', 0.60, 0.85)
        result = self.engine._normalize(f, 0.725)
        self.assertAlmostEqual(result, 0.5)

    def test_lower_above_hi_returns_zero(self):
        f = _factor('ratio', ['admin', 'total_exp'], 'lower', 0.10, 0.30)
        result = self.engine._normalize(f, 0.40)
        self.assertEqual(result, 0.0)

    def test_lower_below_lo_returns_one(self):
        f = _factor('ratio', ['admin', 'total_exp'], 'lower', 0.10, 0.30)
        result = self.engine._normalize(f, 0.05)
        self.assertEqual(result, 1.0)

    def test_lower_in_range(self):
        # lo=0.10, hi=0.30, raw=0.20 → (0.30-0.20)/0.20 = 0.5
        f = _factor('ratio', ['admin', 'total_exp'], 'lower', 0.10, 0.30)
        result = self.engine._normalize(f, 0.20)
        self.assertAlmostEqual(result, 0.5)

    def test_span_zero_returns_zero(self):
        f = _factor('ratio', ['prog', 'total_exp'], 'higher', 0.5, 0.5)
        result = self.engine._normalize(f, 0.5)
        self.assertEqual(result, 0.0)


# ---------------------------------------------------------------------------
# _compute_factor — ratio
# ---------------------------------------------------------------------------

class TestComputeFactorRatio(unittest.TestCase):
    def setUp(self):
        self.engine = ScoringEngine(db=None)

    def _f(self, inputs):
        return _factor('ratio', inputs)

    def test_program_expense_normal(self):
        vals = _build_vals(prog=700.0, total_exp=1000.0)
        result = self.engine._compute_factor(self._f(['prog', 'total_exp']), vals)
        self.assertAlmostEqual(result, 0.7)

    def test_program_expense_zero_total(self):
        vals = _build_vals(prog=700.0, total_exp=0.0)
        result = self.engine._compute_factor(self._f(['prog', 'total_exp']), vals)
        self.assertIsNone(result)

    def test_program_expense_missing_total(self):
        vals = _build_vals(prog=700.0)
        result = self.engine._compute_factor(self._f(['prog', 'total_exp']), vals)
        self.assertIsNone(result)

    def test_admin_expense_normal(self):
        vals = _build_vals(admin=100.0, total_exp=1000.0)
        result = self.engine._compute_factor(self._f(['admin', 'total_exp']), vals)
        self.assertAlmostEqual(result, 0.1)

    def test_admin_expense_zero_total(self):
        vals = _build_vals(admin=100.0, total_exp=0.0)
        result = self.engine._compute_factor(self._f(['admin', 'total_exp']), vals)
        self.assertIsNone(result)

    def test_fundraising_expense_normal(self):
        vals = _build_vals(fund=50.0, total_exp=1000.0)
        result = self.engine._compute_factor(self._f(['fund', 'total_exp']), vals)
        self.assertAlmostEqual(result, 0.05)

    def test_fundraising_expense_zero_total(self):
        vals = _build_vals(fund=50.0, total_exp=0.0)
        result = self.engine._compute_factor(self._f(['fund', 'total_exp']), vals)
        self.assertIsNone(result)

    def test_fundraising_efficiency_normal(self):
        vals = _build_vals(fund=50.0, contrib=500.0)
        result = self.engine._compute_factor(self._f(['fund', 'contrib']), vals)
        self.assertAlmostEqual(result, 0.1)

    def test_fundraising_efficiency_zero_contrib(self):
        vals = _build_vals(fund=50.0, contrib=0.0)
        result = self.engine._compute_factor(self._f(['fund', 'contrib']), vals)
        self.assertIsNone(result)

    def test_fundraising_efficiency_missing_contrib(self):
        vals = _build_vals(fund=50.0)
        result = self.engine._compute_factor(self._f(['fund', 'contrib']), vals)
        self.assertIsNone(result)

    def test_assets_to_liabilities_normal(self):
        vals = _build_vals(liabilities=300.0, assets=1000.0)
        result = self.engine._compute_factor(self._f(['liabilities', 'assets']), vals)
        self.assertAlmostEqual(result, 0.3)

    def test_assets_to_liabilities_zero_assets(self):
        vals = _build_vals(liabilities=300.0, assets=0.0)
        result = self.engine._compute_factor(self._f(['liabilities', 'assets']), vals)
        self.assertIsNone(result)

    def test_government_reliance_normal(self):
        vals = _build_vals(gov_grants=300.0, contrib=600.0)
        result = self.engine._compute_factor(self._f(['gov_grants', 'contrib']), vals)
        self.assertAlmostEqual(result, 0.5)

    def test_government_reliance_zero_contrib(self):
        vals = _build_vals(gov_grants=300.0, contrib=0.0)
        result = self.engine._compute_factor(self._f(['gov_grants', 'contrib']), vals)
        self.assertIsNone(result)

    def test_excess_deficit_normal(self):
        vals = _build_vals(cy_rev=1100.0, cy_exp=1000.0)
        result = self.engine._compute_factor(self._f(['cy_rev', 'cy_exp']), vals)
        self.assertAlmostEqual(result, 1.1)

    def test_excess_deficit_zero_exp(self):
        vals = _build_vals(cy_rev=1100.0, cy_exp=0.0)
        result = self.engine._compute_factor(self._f(['cy_rev', 'cy_exp']), vals)
        self.assertIsNone(result)

    def test_gift_of_revenue_normal(self):
        vals = _build_vals(contrib=800.0, cy_rev=1000.0)
        result = self.engine._compute_factor(self._f(['contrib', 'cy_rev']), vals)
        self.assertAlmostEqual(result, 0.8)

    def test_gift_of_revenue_missing_rev(self):
        vals = _build_vals(contrib=800.0)
        result = self.engine._compute_factor(self._f(['contrib', 'cy_rev']), vals)
        self.assertIsNone(result)

    def test_dependence_on_gifts_normal(self):
        vals = _build_vals(contrib=600.0, cy_exp=1000.0)
        result = self.engine._compute_factor(self._f(['contrib', 'cy_exp']), vals)
        self.assertAlmostEqual(result, 0.6)

    def test_dependence_on_gifts_zero_exp(self):
        vals = _build_vals(contrib=600.0, cy_exp=0.0)
        result = self.engine._compute_factor(self._f(['contrib', 'cy_exp']), vals)
        self.assertIsNone(result)

    def test_return_on_investments_normal(self):
        vals = _build_vals(invest_inc=50.0, invest_val=1000.0)
        result = self.engine._compute_factor(self._f(['invest_inc', 'invest_val']), vals)
        self.assertAlmostEqual(result, 0.05)

    def test_return_on_investments_zero_inv(self):
        vals = _build_vals(invest_inc=50.0, invest_val=0.0)
        result = self.engine._compute_factor(self._f(['invest_inc', 'invest_val']), vals)
        self.assertIsNone(result)


# ---------------------------------------------------------------------------
# _compute_factor — ratio_positive
# ---------------------------------------------------------------------------

class TestComputeFactorRatioPositive(unittest.TestCase):
    def setUp(self):
        self.engine = ScoringEngine(db=None)

    def _f(self, inputs):
        return _factor('ratio_positive', inputs)

    def test_debt_to_equity_normal(self):
        vals = _build_vals(liabilities=200.0, equity=800.0)
        result = self.engine._compute_factor(self._f(['liabilities', 'equity']), vals)
        self.assertAlmostEqual(result, 0.25)

    def test_debt_to_equity_zero_equity(self):
        vals = _build_vals(liabilities=200.0, equity=0.0)
        result = self.engine._compute_factor(self._f(['liabilities', 'equity']), vals)
        self.assertIsNone(result)

    def test_debt_to_equity_negative_equity(self):
        vals = _build_vals(liabilities=200.0, equity=-100.0)
        result = self.engine._compute_factor(self._f(['liabilities', 'equity']), vals)
        self.assertIsNone(result)

    def test_debt_to_equity_missing_equity(self):
        vals = _build_vals(liabilities=200.0)
        result = self.engine._compute_factor(self._f(['liabilities', 'equity']), vals)
        self.assertIsNone(result)


# ---------------------------------------------------------------------------
# _compute_factor — growth
# ---------------------------------------------------------------------------

class TestComputeFactorGrowth(unittest.TestCase):
    def setUp(self):
        self.engine = ScoringEngine(db=None)

    def _f(self, inputs):
        return _factor('growth', inputs)

    def test_program_expense_growth_normal(self):
        vals = _build_vals(cy_grants=110.0, py_grants=100.0)
        result = self.engine._compute_factor(self._f(['cy_grants', 'py_grants']), vals)
        self.assertAlmostEqual(result, 0.1)

    def test_program_expense_growth_zero_py(self):
        vals = _build_vals(cy_grants=110.0, py_grants=0.0)
        result = self.engine._compute_factor(self._f(['cy_grants', 'py_grants']), vals)
        self.assertIsNone(result)

    def test_program_expense_growth_missing_py(self):
        vals = _build_vals(cy_grants=110.0)
        result = self.engine._compute_factor(self._f(['cy_grants', 'py_grants']), vals)
        self.assertIsNone(result)

    def test_growth_negative(self):
        vals = _build_vals(cy_grants=90.0, py_grants=100.0)
        result = self.engine._compute_factor(self._f(['cy_grants', 'py_grants']), vals)
        self.assertAlmostEqual(result, -0.1)


# ---------------------------------------------------------------------------
# _compute_factor — working_capital
# ---------------------------------------------------------------------------

class TestComputeFactorWorkingCapital(unittest.TestCase):
    def setUp(self):
        self.engine = ScoringEngine(db=None)

    def _f(self):
        return _factor('working_capital', ['cash', 'savings', 'accts_pay', 'cy_exp'])

    def test_working_capital_normal(self):
        vals = _build_vals(cash=500.0, savings=200.0, accts_pay=100.0, cy_exp=1200.0)
        result = self.engine._compute_factor(self._f(), vals)
        self.assertAlmostEqual(result, (500.0 + 200.0 - 100.0) / 1200.0)

    def test_working_capital_missing_optionals(self):
        vals = _build_vals(cy_exp=1000.0)
        result = self.engine._compute_factor(self._f(), vals)
        self.assertAlmostEqual(result, 0.0)

    def test_working_capital_zero_exp(self):
        vals = _build_vals(cash=500.0, savings=200.0, accts_pay=100.0, cy_exp=0.0)
        result = self.engine._compute_factor(self._f(), vals)
        self.assertIsNone(result)

    def test_working_capital_missing_exp(self):
        vals = _build_vals(cash=500.0)
        result = self.engine._compute_factor(self._f(), vals)
        self.assertIsNone(result)


# ---------------------------------------------------------------------------
# _compute_factor — sum_ratio
# ---------------------------------------------------------------------------

class TestComputeFactorSumRatio(unittest.TestCase):
    def setUp(self):
        self.engine = ScoringEngine(db=None)

    def _f(self, inputs):
        return _factor('sum_ratio', inputs)

    def test_admin_cost_ratio_normal(self):
        vals = _build_vals(admin=100.0, fund=50.0, total_exp=1000.0)
        result = self.engine._compute_factor(self._f(['admin', 'fund', 'total_exp']), vals)
        self.assertAlmostEqual(result, 0.15)

    def test_admin_cost_ratio_zero_total(self):
        vals = _build_vals(admin=100.0, fund=50.0, total_exp=0.0)
        result = self.engine._compute_factor(self._f(['admin', 'fund', 'total_exp']), vals)
        self.assertIsNone(result)

    def test_admin_cost_ratio_missing_total(self):
        vals = _build_vals(admin=100.0, fund=50.0)
        result = self.engine._compute_factor(self._f(['admin', 'fund', 'total_exp']), vals)
        self.assertIsNone(result)

    def test_admin_cost_ratio_missing_admin(self):
        vals = _build_vals(fund=50.0, total_exp=1000.0)
        result = self.engine._compute_factor(self._f(['admin', 'fund', 'total_exp']), vals)
        self.assertIsNone(result)

    def test_admin_cost_ratio_missing_fund(self):
        vals = _build_vals(admin=100.0, total_exp=1000.0)
        result = self.engine._compute_factor(self._f(['admin', 'fund', 'total_exp']), vals)
        self.assertIsNone(result)


# ---------------------------------------------------------------------------
# _compute_factor — unknown formula_type
# ---------------------------------------------------------------------------

class TestComputeFactorUnknown(unittest.TestCase):
    def setUp(self):
        self.engine = ScoringEngine(db=None)

    def test_unknown_formula_type_returns_none(self):
        f = _factor('unknown_type', ['prog', 'total_exp'])
        vals = _build_vals(prog=700.0, total_exp=1000.0)
        result = self.engine._compute_factor(f, vals)
        self.assertIsNone(result)


# ---------------------------------------------------------------------------
# calculate()
# ---------------------------------------------------------------------------

def _full_factor(factor_id, name, formula_type, inputs, direction, lo, hi, weight):
    return {
        'factor_id':    factor_id,
        'name':         name,
        'weight':       weight,
        'formula_type': formula_type,
        'inputs':       json.dumps(inputs),
        'direction':    direction,
        'benchmark_lo': lo,
        'benchmark_hi': hi,
        'formula_description': '',
    }


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
        fields = [{'xml_path': path, 'value': '1000'} for path in _PATHS.values()]
        filing = {'filing_id': 42, 'fields': fields}

        factors = [
            _full_factor(1,  'Program Expense',             'ratio',          ['prog','total_exp'],                    'higher',  0.60,  0.85, 0.1),
            _full_factor(2,  'Admin Expense',               'ratio',          ['admin','total_exp'],                   'lower',   0.10,  0.30, 0.1),
            _full_factor(3,  'Fundraising Expense',         'ratio',          ['fund','total_exp'],                    'lower',   0.05,  0.30, 0.05),
            _full_factor(4,  'Fundraising Efficiency',      'ratio',          ['fund','contrib'],                      'lower',   0.05,  0.35, 0.05),
            _full_factor(5,  'Program Expense Growth',      'growth',         ['cy_grants','py_grants'],               'higher', -0.20,  0.20, 0.05),
            _full_factor(6,  'Assets to Liabilities Ratio', 'ratio',          ['liabilities','assets'],                'lower',   0.10,  0.75, 0.1),
            _full_factor(7,  'Debt to Equity Ratio',        'ratio_positive', ['liabilities','equity'],                'lower',   0.10,  2.00, 0.1),
            _full_factor(8,  'Working Capital Ratio',       'working_capital',['cash','savings','accts_pay','cy_exp'], 'higher',  0.00,  0.50, 0.05),
            _full_factor(9,  'Government Reliance',         'ratio',          ['gov_grants','contrib'],                'lower',   0.00,  0.75, 0.05),
            _full_factor(10, 'Excess/Deficit at Year End',  'ratio',          ['cy_rev','cy_exp'],                     'higher',  0.90,  1.10, 0.1),
            _full_factor(11, '% Gift is of Revenue',        'ratio',          ['contrib','cy_rev'],                    'higher',  0.40,  0.95, 0.05),
            _full_factor(12, 'Dependence on Gifts/Grants',  'ratio',          ['contrib','cy_exp'],                    'higher',  0.50,  1.20, 0.05),
            _full_factor(13, 'Return on Investments',       'ratio',          ['invest_inc','invest_val'],              'higher',  0.00,  0.10, 0.05),
            _full_factor(14, 'Admin Cost Ratio',            'sum_ratio',      ['admin','fund','total_exp'],            'lower',   0.10,  0.40, 0.1),
        ]

        expected_score = {'score_id': 99, 'total': 0.72}

        db = MagicMock()
        db.get_filing_data_by_ein_year.return_value = filing
        db.get_factors.return_value = factors
        db.create_score.return_value = 99
        db.get_score.return_value = expected_score

        engine = ScoringEngine(db=db)
        result = engine.calculate('12-3456789', 2023, model_version=1)

        db.get_filing_data_by_ein_year.assert_called_once_with('12-3456789', 2023)
        db.get_factors.assert_called_once_with(1)
        db.create_score.assert_called_once_with(42, 1)
        db.store_factor_values.assert_called_once()
        db.finalize_score.assert_called_once()
        db.get_score.assert_called_once_with(99)

        self.assertEqual(result, expected_score)

    def test_calculate_finalize_receives_correct_total(self):
        fields = [{'xml_path': path, 'value': '1000'} for path in _PATHS.values()]
        filing = {'filing_id': 7, 'fields': fields}

        factors = [
            _full_factor(1, 'Program Expense', 'ratio', ['prog', 'total_exp'], 'higher', 0.60, 0.85, 0.5),
        ]

        db = MagicMock()
        db.get_filing_data_by_ein_year.return_value = filing
        db.get_factors.return_value = factors
        db.create_score.return_value = 1
        db.get_score.return_value = {}

        ScoringEngine(db=db).calculate('00-0000000', 2022)

        score_id_arg, total_arg = db.finalize_score.call_args[0]
        self.assertEqual(score_id_arg, 1)
        # prog/total_exp = 1000/1000 = 1.0 → normalize higher, lo=0.60, hi=0.85
        # (1.0-0.60)/(0.25) = 1.6 → clamped to 1.0 → weighted = 1.0 * 0.5
        self.assertAlmostEqual(total_arg, 0.5)

    def test_calculate_with_none_factor_raw(self):
        filing = {'filing_id': 3, 'fields': []}
        factors = [_full_factor(1, 'Program Expense', 'ratio', ['prog', 'total_exp'], 'higher', 0.60, 0.85, 1.0)]

        db = MagicMock()
        db.get_filing_data_by_ein_year.return_value = filing
        db.get_factors.return_value = factors
        db.create_score.return_value = 5
        db.get_score.return_value = {}

        ScoringEngine(db=db).calculate('00-0000001', 2021)

        total_arg = db.finalize_score.call_args[0][1]
        self.assertAlmostEqual(total_arg, 0.0)


if __name__ == '__main__':
    unittest.main()
