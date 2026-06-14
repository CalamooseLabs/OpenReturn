import math
import sys
import os
import json
import unittest
from unittest.mock import MagicMock

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

from scoring.engine import (ScoringEngine, _PATHS, FORMULA_TYPES, FORMULA_INPUT_COUNTS,
                            _FACTOR_PREFIX, _HISTORICAL_TYPES)


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
        for ft in ('ratio', 'ratio_positive', 'growth', 'working_capital', 'sum_ratio',
                   'difference', 'product', 'clamp', 'abs_value', 'inverse',
                   'sum', 'average', 'min', 'max', 'median',
                   'running_average', 'cumulative_sum', 'historical_min', 'historical_max',
                   'cagr', 'historical_std_dev', 'coefficient_of_variation'):
            self.assertIn(ft, FORMULA_TYPES)

    def test_formula_input_counts_all_types_covered(self):
        for ft in FORMULA_TYPES:
            self.assertIn(ft, FORMULA_INPUT_COUNTS)

    def test_formula_input_counts_values(self):
        self.assertEqual(FORMULA_INPUT_COUNTS['ratio'],                    2)
        self.assertEqual(FORMULA_INPUT_COUNTS['ratio_positive'],           2)
        self.assertEqual(FORMULA_INPUT_COUNTS['growth'],                   2)
        self.assertEqual(FORMULA_INPUT_COUNTS['working_capital'],          4)
        self.assertEqual(FORMULA_INPUT_COUNTS['sum_ratio'],                3)
        self.assertEqual(FORMULA_INPUT_COUNTS['difference'],               2)
        self.assertEqual(FORMULA_INPUT_COUNTS['product'],                  2)
        self.assertEqual(FORMULA_INPUT_COUNTS['clamp'],                    3)
        self.assertEqual(FORMULA_INPUT_COUNTS['abs_value'],                1)
        self.assertEqual(FORMULA_INPUT_COUNTS['inverse'],                  1)
        self.assertIsNone(FORMULA_INPUT_COUNTS['sum'])
        self.assertIsNone(FORMULA_INPUT_COUNTS['average'])
        self.assertIsNone(FORMULA_INPUT_COUNTS['min'])
        self.assertIsNone(FORMULA_INPUT_COUNTS['max'])
        self.assertIsNone(FORMULA_INPUT_COUNTS['median'])
        self.assertEqual(FORMULA_INPUT_COUNTS['running_average'],          1)
        self.assertEqual(FORMULA_INPUT_COUNTS['cumulative_sum'],           1)
        self.assertEqual(FORMULA_INPUT_COUNTS['historical_min'],           1)
        self.assertEqual(FORMULA_INPUT_COUNTS['historical_max'],           1)
        self.assertEqual(FORMULA_INPUT_COUNTS['cagr'],                     1)
        self.assertEqual(FORMULA_INPUT_COUNTS['historical_std_dev'],       1)
        self.assertEqual(FORMULA_INPUT_COUNTS['coefficient_of_variation'], 1)

    def test_historical_types_is_subset_of_formula_types(self):
        self.assertTrue(_HISTORICAL_TYPES.issubset(FORMULA_TYPES))


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
# _compute_factor — difference
# ---------------------------------------------------------------------------

class TestComputeFactorDifference(unittest.TestCase):
    def setUp(self):
        self.engine = ScoringEngine(db=None)

    def _f(self, inputs):
        return _factor('difference', inputs)

    def test_normal(self):
        vals = _build_vals(cy_rev=1100.0, cy_exp=1000.0)
        self.assertAlmostEqual(self.engine._compute_factor(self._f(['cy_rev', 'cy_exp']), vals), 100.0)

    def test_negative_result(self):
        vals = _build_vals(cy_rev=900.0, cy_exp=1000.0)
        self.assertAlmostEqual(self.engine._compute_factor(self._f(['cy_rev', 'cy_exp']), vals), -100.0)

    def test_missing_a_returns_none(self):
        vals = _build_vals(cy_exp=1000.0)
        self.assertIsNone(self.engine._compute_factor(self._f(['cy_rev', 'cy_exp']), vals))

    def test_missing_b_returns_none(self):
        vals = _build_vals(cy_rev=1000.0)
        self.assertIsNone(self.engine._compute_factor(self._f(['cy_rev', 'cy_exp']), vals))


# ---------------------------------------------------------------------------
# _compute_factor — product
# ---------------------------------------------------------------------------

class TestComputeFactorProduct(unittest.TestCase):
    def setUp(self):
        self.engine = ScoringEngine(db=None)

    def _f(self, inputs):
        return _factor('product', inputs)

    def test_normal(self):
        vals = _build_vals(cy_rev=2.0, cy_exp=3.0)
        self.assertAlmostEqual(self.engine._compute_factor(self._f(['cy_rev', 'cy_exp']), vals), 6.0)

    def test_missing_input_returns_none(self):
        vals = _build_vals(cy_rev=2.0)
        self.assertIsNone(self.engine._compute_factor(self._f(['cy_rev', 'cy_exp']), vals))

    def test_zero_factor_returns_zero(self):
        vals = _build_vals(cy_rev=0.0, cy_exp=999.0)
        self.assertAlmostEqual(self.engine._compute_factor(self._f(['cy_rev', 'cy_exp']), vals), 0.0)


# ---------------------------------------------------------------------------
# _compute_factor — abs_value
# ---------------------------------------------------------------------------

class TestComputeFactorAbsValue(unittest.TestCase):
    def setUp(self):
        self.engine = ScoringEngine(db=None)

    def _f(self, inputs):
        return _factor('abs_value', inputs)

    def test_positive(self):
        vals = _build_vals(cy_rev=500.0)
        self.assertAlmostEqual(self.engine._compute_factor(self._f(['cy_rev']), vals), 500.0)

    def test_negative_becomes_positive(self):
        vals = _build_vals(equity=-300.0)
        self.assertAlmostEqual(self.engine._compute_factor(self._f(['equity']), vals), 300.0)

    def test_missing_returns_none(self):
        self.assertIsNone(self.engine._compute_factor(self._f(['cy_rev']), {}))


# ---------------------------------------------------------------------------
# _compute_factor — inverse
# ---------------------------------------------------------------------------

class TestComputeFactorInverse(unittest.TestCase):
    def setUp(self):
        self.engine = ScoringEngine(db=None)

    def _f(self, inputs):
        return _factor('inverse', inputs)

    def test_normal(self):
        vals = _build_vals(cy_rev=4.0)
        self.assertAlmostEqual(self.engine._compute_factor(self._f(['cy_rev']), vals), 0.25)

    def test_zero_returns_none(self):
        vals = _build_vals(cy_rev=0.0)
        self.assertIsNone(self.engine._compute_factor(self._f(['cy_rev']), vals))

    def test_missing_returns_none(self):
        self.assertIsNone(self.engine._compute_factor(self._f(['cy_rev']), {}))


# ---------------------------------------------------------------------------
# _compute_factor — sum
# ---------------------------------------------------------------------------

class TestComputeFactorSum(unittest.TestCase):
    def setUp(self):
        self.engine = ScoringEngine(db=None)

    def _f(self, inputs):
        return _factor('sum', inputs)

    def test_single_input(self):
        vals = _build_vals(prog=500.0)
        self.assertAlmostEqual(self.engine._compute_factor(self._f(['prog']), vals), 500.0)

    def test_multiple_inputs(self):
        vals = _build_vals(prog=500.0, admin=200.0, fund=100.0)
        self.assertAlmostEqual(
            self.engine._compute_factor(self._f(['prog', 'admin', 'fund']), vals), 800.0)

    def test_none_inputs_skipped(self):
        vals = _build_vals(prog=500.0, fund=100.0)
        self.assertAlmostEqual(
            self.engine._compute_factor(self._f(['prog', 'admin', 'fund']), vals), 600.0)

    def test_all_none_returns_none(self):
        self.assertIsNone(self.engine._compute_factor(self._f(['prog', 'admin']), {}))


# ---------------------------------------------------------------------------
# _compute_factor — average
# ---------------------------------------------------------------------------

class TestComputeFactorAverage(unittest.TestCase):
    def setUp(self):
        self.engine = ScoringEngine(db=None)

    def _f(self, inputs):
        return _factor('average', inputs)

    def test_single_input(self):
        vals = _build_vals(cy_rev=900.0)
        self.assertAlmostEqual(self.engine._compute_factor(self._f(['cy_rev']), vals), 900.0)

    def test_multiple_inputs(self):
        vals = _build_vals(cy_rev=1000.0, cy_exp=2000.0)
        self.assertAlmostEqual(
            self.engine._compute_factor(self._f(['cy_rev', 'cy_exp']), vals), 1500.0)

    def test_none_inputs_skipped(self):
        vals = _build_vals(cy_rev=1000.0)
        self.assertAlmostEqual(
            self.engine._compute_factor(self._f(['cy_rev', 'cy_exp']), vals), 1000.0)

    def test_all_none_returns_none(self):
        self.assertIsNone(self.engine._compute_factor(self._f(['cy_rev', 'cy_exp']), {}))


# ---------------------------------------------------------------------------
# _compute_factor — min / max
# ---------------------------------------------------------------------------

class TestComputeFactorMinMax(unittest.TestCase):
    def setUp(self):
        self.engine = ScoringEngine(db=None)

    def test_min_normal(self):
        vals = _build_vals(cy_rev=300.0, cy_exp=800.0, prog=500.0)
        f = _factor('min', ['cy_rev', 'cy_exp', 'prog'])
        self.assertAlmostEqual(self.engine._compute_factor(f, vals), 300.0)

    def test_max_normal(self):
        vals = _build_vals(cy_rev=300.0, cy_exp=800.0, prog=500.0)
        f = _factor('max', ['cy_rev', 'cy_exp', 'prog'])
        self.assertAlmostEqual(self.engine._compute_factor(f, vals), 800.0)

    def test_min_skips_none(self):
        vals = _build_vals(cy_rev=400.0, prog=100.0)
        f = _factor('min', ['cy_rev', 'cy_exp', 'prog'])
        self.assertAlmostEqual(self.engine._compute_factor(f, vals), 100.0)

    def test_max_skips_none(self):
        vals = _build_vals(cy_rev=400.0, prog=100.0)
        f = _factor('max', ['cy_rev', 'cy_exp', 'prog'])
        self.assertAlmostEqual(self.engine._compute_factor(f, vals), 400.0)

    def test_all_none_returns_none(self):
        f = _factor('min', ['cy_rev', 'cy_exp'])
        self.assertIsNone(self.engine._compute_factor(f, {}))


# ---------------------------------------------------------------------------
# _compute_factor — median
# ---------------------------------------------------------------------------

class TestComputeFactorMedian(unittest.TestCase):
    def setUp(self):
        self.engine = ScoringEngine(db=None)

    def test_odd_count(self):
        vals = _build_vals(cy_rev=300.0, cy_exp=500.0, prog=700.0)
        f = _factor('median', ['cy_rev', 'cy_exp', 'prog'])
        self.assertAlmostEqual(self.engine._compute_factor(f, vals), 500.0)

    def test_even_count_averages_middle_two(self):
        vals = _build_vals(cy_rev=200.0, cy_exp=800.0)
        f = _factor('median', ['cy_rev', 'cy_exp'])
        self.assertAlmostEqual(self.engine._compute_factor(f, vals), 500.0)

    def test_single_input(self):
        vals = _build_vals(cy_rev=999.0)
        f = _factor('median', ['cy_rev'])
        self.assertAlmostEqual(self.engine._compute_factor(f, vals), 999.0)

    def test_none_inputs_skipped(self):
        vals = _build_vals(cy_rev=400.0, prog=600.0)
        f = _factor('median', ['cy_rev', 'cy_exp', 'prog'])
        self.assertAlmostEqual(self.engine._compute_factor(f, vals), 500.0)

    def test_all_none_returns_none(self):
        f = _factor('median', ['cy_rev', 'cy_exp'])
        self.assertIsNone(self.engine._compute_factor(f, {}))


# ---------------------------------------------------------------------------
# _compute_factor — clamp
# ---------------------------------------------------------------------------

class TestComputeFactorClamp(unittest.TestCase):
    def setUp(self):
        self.engine = ScoringEngine(db=None)

    def test_value_within_range(self):
        vals = _build_vals(cy_rev=0.5)
        f = _factor('clamp', ['cy_rev', '0', '1'])
        self.assertAlmostEqual(self.engine._compute_factor(f, vals), 0.5)

    def test_value_below_lo_clamped_to_lo(self):
        vals = _build_vals(cy_rev=-5.0)
        f = _factor('clamp', ['cy_rev', '0', '1'])
        self.assertAlmostEqual(self.engine._compute_factor(f, vals), 0.0)

    def test_value_above_hi_clamped_to_hi(self):
        vals = _build_vals(cy_rev=5.0)
        f = _factor('clamp', ['cy_rev', '0', '1'])
        self.assertAlmostEqual(self.engine._compute_factor(f, vals), 1.0)

    def test_field_key_bounds(self):
        vals = _build_vals(cy_rev=500.0, cy_exp=200.0, admin=800.0)
        f = _factor('clamp', ['cy_rev', 'cy_exp', 'admin'])
        self.assertAlmostEqual(self.engine._compute_factor(f, vals), 500.0)

    def test_missing_value_returns_none(self):
        f = _factor('clamp', ['cy_rev', '0', '1'])
        self.assertIsNone(self.engine._compute_factor(f, {}))

    def test_missing_bound_returns_none(self):
        vals = _build_vals(cy_rev=0.5)
        f = _factor('clamp', ['cy_rev', 'cy_exp', '1'])
        self.assertIsNone(self.engine._compute_factor(f, vals))


# ---------------------------------------------------------------------------
# _compute_factor — historical formulas
# ---------------------------------------------------------------------------

class TestComputeFactorHistorical(unittest.TestCase):
    def setUp(self):
        self.engine = ScoringEngine(db=None)
        self.hist = {_PATHS['cy_rev']: [800.0, 1000.0, 1200.0]}

    def _f(self, formula_type):
        return _factor(formula_type, ['cy_rev'])

    def test_running_average_normal(self):
        result = self.engine._compute_factor(self._f('running_average'), {}, historical=self.hist)
        self.assertAlmostEqual(result, 1000.0)

    def test_cumulative_sum_normal(self):
        result = self.engine._compute_factor(self._f('cumulative_sum'), {}, historical=self.hist)
        self.assertAlmostEqual(result, 3000.0)

    def test_historical_min_normal(self):
        result = self.engine._compute_factor(self._f('historical_min'), {}, historical=self.hist)
        self.assertAlmostEqual(result, 800.0)

    def test_historical_max_normal(self):
        result = self.engine._compute_factor(self._f('historical_max'), {}, historical=self.hist)
        self.assertAlmostEqual(result, 1200.0)

    def test_no_historical_data_returns_none(self):
        result = self.engine._compute_factor(self._f('running_average'), {}, historical={})
        self.assertIsNone(result)

    def test_empty_historical_for_key_returns_none(self):
        result = self.engine._compute_factor(
            self._f('running_average'), {}, historical={_PATHS['cy_rev']: []})
        self.assertIsNone(result)

    def test_single_year_running_average(self):
        hist = {_PATHS['cy_rev']: [1500.0]}
        result = self.engine._compute_factor(self._f('running_average'), {}, historical=hist)
        self.assertAlmostEqual(result, 1500.0)

    def test_cagr_normal(self):
        # hist = [800, 1000, 1200]; CAGR = (1200/800)^(1/2) - 1
        result = self.engine._compute_factor(self._f('cagr'), {}, historical=self.hist)
        expected = (1200.0 / 800.0) ** (1.0 / 2) - 1.0
        self.assertAlmostEqual(result, expected)

    def test_cagr_single_value_returns_none(self):
        hist = {_PATHS['cy_rev']: [1000.0]}
        self.assertIsNone(self.engine._compute_factor(self._f('cagr'), {}, historical=hist))

    def test_cagr_zero_start_returns_none(self):
        hist = {_PATHS['cy_rev']: [0.0, 1200.0]}
        self.assertIsNone(self.engine._compute_factor(self._f('cagr'), {}, historical=hist))

    def test_cagr_negative_start_returns_none(self):
        hist = {_PATHS['cy_rev']: [-100.0, 1200.0]}
        self.assertIsNone(self.engine._compute_factor(self._f('cagr'), {}, historical=hist))

    def test_cagr_negative_end_returns_none(self):
        hist = {_PATHS['cy_rev']: [800.0, -200.0]}
        self.assertIsNone(self.engine._compute_factor(self._f('cagr'), {}, historical=hist))

    def test_historical_std_dev_normal(self):
        # hist = [800, 1000, 1200]; mean=1000; population std_dev
        result = self.engine._compute_factor(self._f('historical_std_dev'), {}, historical=self.hist)
        mean = 1000.0
        expected = math.sqrt(((800 - mean) ** 2 + (1000 - mean) ** 2 + (1200 - mean) ** 2) / 3)
        self.assertAlmostEqual(result, expected)

    def test_historical_std_dev_single_value_is_zero(self):
        hist = {_PATHS['cy_rev']: [1000.0]}
        result = self.engine._compute_factor(self._f('historical_std_dev'), {}, historical=hist)
        self.assertAlmostEqual(result, 0.0)

    def test_coefficient_of_variation_normal(self):
        result = self.engine._compute_factor(self._f('coefficient_of_variation'), {}, historical=self.hist)
        mean = 1000.0
        std_dev = math.sqrt(((800 - mean) ** 2 + (1000 - mean) ** 2 + (1200 - mean) ** 2) / 3)
        self.assertAlmostEqual(result, std_dev / abs(mean))

    def test_coefficient_of_variation_zero_mean_returns_none(self):
        hist = {_PATHS['cy_rev']: [-500.0, 500.0]}
        self.assertIsNone(
            self.engine._compute_factor(self._f('coefficient_of_variation'), {}, historical=hist))


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
        db.filings.get_filing_data_by_ein_year.return_value = filing
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
        db.filings.get_filing_data_by_ein_year.return_value = filing
        db.scores.get_factors.return_value = factors
        db.scores.create_score.return_value = 99
        db.scores.get_score.return_value = expected_score

        engine = ScoringEngine(db=db)
        result = engine.calculate('12-3456789', 2023, model_version=1)

        db.filings.get_filing_data_by_ein_year.assert_called_once_with('12-3456789', 2023)
        db.scores.get_factors.assert_called_once_with(1)
        db.scores.create_score.assert_called_once_with(42, 1)
        db.scores.store_factor_values.assert_called_once()
        db.scores.finalize_score.assert_called_once()
        db.scores.get_score.assert_called_once_with(99)

        self.assertEqual(result, expected_score)

    def test_calculate_finalize_receives_correct_total(self):
        fields = [{'xml_path': path, 'value': '1000'} for path in _PATHS.values()]
        filing = {'filing_id': 7, 'fields': fields}

        factors = [
            _full_factor(1, 'Program Expense', 'ratio', ['prog', 'total_exp'], 'higher', 0.60, 0.85, 0.5),
        ]

        db = MagicMock()
        db.filings.get_filing_data_by_ein_year.return_value = filing
        db.scores.get_factors.return_value = factors
        db.scores.create_score.return_value = 1
        db.scores.get_score.return_value = {}

        ScoringEngine(db=db).calculate('00-0000000', 2022)

        score_id_arg, total_arg = db.scores.finalize_score.call_args[0]
        self.assertEqual(score_id_arg, 1)
        # prog/total_exp = 1000/1000 = 1.0 → normalize higher, lo=0.60, hi=0.85
        # (1.0-0.60)/(0.25) = 1.6 → clamped to 1.0 → weighted = 1.0 * 0.5
        self.assertAlmostEqual(total_arg, 0.5)

    def test_calculate_with_none_factor_raw(self):
        filing = {'filing_id': 3, 'fields': []}
        factors = [_full_factor(1, 'Program Expense', 'ratio', ['prog', 'total_exp'], 'higher', 0.60, 0.85, 1.0)]

        db = MagicMock()
        db.filings.get_filing_data_by_ein_year.return_value = filing
        db.scores.get_factors.return_value = factors
        db.scores.create_score.return_value = 5
        db.scores.get_score.return_value = {}

        ScoringEngine(db=db).calculate('00-0000001', 2021)

        total_arg = db.scores.finalize_score.call_args[0][1]
        self.assertAlmostEqual(total_arg, 0.0)


# ---------------------------------------------------------------------------
# _resolve_input
# ---------------------------------------------------------------------------

class TestResolveInput(unittest.TestCase):
    def setUp(self):
        self.engine = ScoringEngine(db=None)
        self.vals = _build_vals(prog=700.0, total_exp=1000.0)

    def test_field_key_resolves_from_vals(self):
        result = self.engine._resolve_input('prog', self.vals, {})
        self.assertAlmostEqual(result, 700.0)

    def test_field_key_missing_returns_none(self):
        result = self.engine._resolve_input('cy_rev', self.vals, {})
        self.assertIsNone(result)

    def test_unknown_field_key_returns_none(self):
        result = self.engine._resolve_input('not_a_key', self.vals, {})
        self.assertIsNone(result)

    def test_factor_prefix_resolves_from_computed(self):
        computed = {'Prog Ratio': 0.7}
        result = self.engine._resolve_input('factor:Prog Ratio', self.vals, computed)
        self.assertAlmostEqual(result, 0.7)

    def test_factor_prefix_missing_returns_none(self):
        result = self.engine._resolve_input('factor:Missing Factor', self.vals, {})
        self.assertIsNone(result)

    def test_factor_prefix_none_value_propagates(self):
        computed = {'Bad Factor': None}
        result = self.engine._resolve_input('factor:Bad Factor', self.vals, computed)
        self.assertIsNone(result)

    def test_numeric_literal_integer_zero(self):
        self.assertAlmostEqual(self.engine._resolve_input('0', self.vals, {}), 0.0)

    def test_numeric_literal_positive_float(self):
        self.assertAlmostEqual(self.engine._resolve_input('0.75', self.vals, {}), 0.75)

    def test_numeric_literal_negative(self):
        self.assertAlmostEqual(self.engine._resolve_input('-1.5', self.vals, {}), -1.5)

    def test_numeric_literal_one(self):
        self.assertAlmostEqual(self.engine._resolve_input('1', self.vals, {}), 1.0)


# ---------------------------------------------------------------------------
# _topo_sort
# ---------------------------------------------------------------------------

class TestTopoSort(unittest.TestCase):
    def setUp(self):
        self.engine = ScoringEngine(db=None)

    def _f(self, name, inputs):
        return {
            'factor_id': 1, 'name': name, 'weight': 0.1,
            'formula_type': 'ratio', 'inputs': json.dumps(inputs),
            'direction': 'higher', 'benchmark_lo': 0.0, 'benchmark_hi': 1.0,
            'formula_description': '',
        }

    def test_independent_factors_all_returned(self):
        factors = [self._f('A', ['prog', 'total_exp']),
                   self._f('B', ['admin', 'total_exp'])]
        result = self.engine._topo_sort(factors)
        self.assertEqual(len(result), 2)
        self.assertEqual({f['name'] for f in result}, {'A', 'B'})

    def test_dependency_comes_before_dependent(self):
        factors = [
            self._f('B', ['factor:A', 'total_exp']),
            self._f('A', ['prog', 'total_exp']),
        ]
        result = self.engine._topo_sort(factors)
        names = [f['name'] for f in result]
        self.assertLess(names.index('A'), names.index('B'))

    def test_chain_sorted_correctly(self):
        factors = [
            self._f('C', ['factor:B', 'total_exp']),
            self._f('A', ['prog', 'total_exp']),
            self._f('B', ['factor:A', 'total_exp']),
        ]
        result = self.engine._topo_sort(factors)
        names = [f['name'] for f in result]
        self.assertLess(names.index('A'), names.index('B'))
        self.assertLess(names.index('B'), names.index('C'))

    def test_circular_dependency_raises(self):
        factors = [
            self._f('A', ['factor:B', 'total_exp']),
            self._f('B', ['factor:A', 'total_exp']),
        ]
        with self.assertRaises(ValueError) as ctx:
            self.engine._topo_sort(factors)
        self.assertIn('Circular', str(ctx.exception))

    def test_self_reference_raises(self):
        factors = [self._f('A', ['factor:A', 'total_exp'])]
        with self.assertRaises(ValueError):
            self.engine._topo_sort(factors)

    def test_unknown_factor_reference_raises(self):
        factors = [self._f('A', ['factor:Ghost', 'total_exp'])]
        with self.assertRaises(ValueError) as ctx:
            self.engine._topo_sort(factors)
        self.assertIn('Ghost', str(ctx.exception))


# ---------------------------------------------------------------------------
# calculate() — factor references and weight=0
# ---------------------------------------------------------------------------

class TestCalculateFactorRefs(unittest.TestCase):

    def _make_filing(self):
        fields = [{'xml_path': path, 'value': '1000'} for path in _PATHS.values()]
        return {'filing_id': 1, 'fields': fields}

    def test_weight_zero_excluded_from_total(self):
        factors = [
            _full_factor(1, 'Intermediate', 'ratio', ['prog', 'total_exp'], 'higher', 0.0, 1.0, 0.0),
            _full_factor(2, 'Final',        'ratio', ['prog', 'total_exp'], 'higher', 0.0, 1.0, 1.0),
        ]
        db = MagicMock()
        db.filings.get_filing_data_by_ein_year.return_value = self._make_filing()
        db.scores.get_factors.return_value = factors
        db.scores.create_score.return_value = 1
        db.scores.get_score.return_value = {}
        ScoringEngine(db=db).calculate('000000000', 2023)
        _, total = db.scores.finalize_score.call_args[0]
        # Intermediate weight=0 contributes nothing; Final weight=1.0 normalized
        self.assertGreater(total, 0.0)
        stored = db.scores.store_factor_values.call_args[0][1]
        # Both factors stored (weight-zero factor still persisted)
        self.assertIn(1, stored)
        self.assertIn(2, stored)

    def test_factor_ref_passes_raw_value_to_downstream(self):
        # prog=1000, total_exp=2000 → ratio = 0.5
        fields = [
            {'xml_path': _PATHS['prog'],      'value': '1000'},
            {'xml_path': _PATHS['total_exp'], 'value': '2000'},
        ]
        filing = {'filing_id': 2, 'fields': fields}
        factors = [
            # Upstream: prog/total_exp = 0.5; weight=0 (intermediate)
            _full_factor(1, 'Prog Ratio', 'ratio', ['prog', 'total_exp'], 'higher', 0.0, 1.0, 0.0),
            # Downstream uses that 0.5 as numerator, total_exp(2000) as denom → 0.5/2000 = 0.00025
            _full_factor(2, 'Derived',    'ratio', ['factor:Prog Ratio', 'total_exp'], 'higher', 0.0, 1.0, 1.0),
        ]
        db = MagicMock()
        db.filings.get_filing_data_by_ein_year.return_value = filing
        db.scores.get_factors.return_value = factors
        db.scores.create_score.return_value = 1
        db.scores.get_score.return_value = {}
        ScoringEngine(db=db).calculate('000000000', 2023)
        stored = db.scores.store_factor_values.call_args[0][1]
        upstream_raw, _ = stored[1]
        downstream_raw, _ = stored[2]
        self.assertAlmostEqual(upstream_raw, 0.5)
        self.assertAlmostEqual(downstream_raw, 0.5 / 2000.0)


# ---------------------------------------------------------------------------
# calculate() — historical data fetching
# ---------------------------------------------------------------------------

class TestCalculateHistorical(unittest.TestCase):

    def _make_db(self, factors, hist=None):
        db = MagicMock()
        db.filings.get_filing_data_by_ein_year.return_value = {'filing_id': 1, 'fields': []}
        db.scores.get_factors.return_value = factors
        db.scores.create_score.return_value = 1
        db.scores.get_score.return_value = {}
        db.reported_data.get_historical_values.return_value = hist or {}
        return db

    def test_historical_formula_triggers_fetch(self):
        factors = [_full_factor(1, 'Avg Rev', 'running_average', ['cy_rev'], 'higher', 0.0, 2000.0, 1.0)]
        hist = {_PATHS['cy_rev']: [800.0, 1000.0, 1200.0]}
        db = self._make_db(factors, hist)
        ScoringEngine(db=db).calculate('000000001', 2023)
        db.reported_data.get_historical_values.assert_called_once_with('000000001')

    def test_no_historical_formula_skips_fetch(self):
        factors = [_full_factor(1, 'Ratio', 'ratio', ['prog', 'total_exp'], 'higher', 0.0, 1.0, 1.0)]
        db = self._make_db(factors)
        ScoringEngine(db=db).calculate('000000001', 2023)
        db.reported_data.get_historical_values.assert_not_called()

    def test_running_average_stored_correctly(self):
        factors = [_full_factor(1, 'Avg Rev', 'running_average', ['cy_rev'], 'higher', 0.0, 2000.0, 1.0)]
        hist = {_PATHS['cy_rev']: [800.0, 1000.0, 1200.0]}
        db = self._make_db(factors, hist)
        ScoringEngine(db=db).calculate('000000001', 2023)
        stored = db.scores.store_factor_values.call_args[0][1]
        raw, _ = stored[1]
        self.assertAlmostEqual(raw, 1000.0)

    def test_cumulative_sum_stored_correctly(self):
        factors = [_full_factor(1, 'Total Rev', 'cumulative_sum', ['cy_rev'], 'higher', 0.0, 5000.0, 1.0)]
        hist = {_PATHS['cy_rev']: [1000.0, 1500.0, 2000.0]}
        db = self._make_db(factors, hist)
        ScoringEngine(db=db).calculate('000000001', 2023)
        stored = db.scores.store_factor_values.call_args[0][1]
        raw, _ = stored[1]
        self.assertAlmostEqual(raw, 4500.0)


if __name__ == '__main__':
    unittest.main()
