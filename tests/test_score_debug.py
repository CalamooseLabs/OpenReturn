"""Tests for ScoringEngine.debug() — the read-only model walkthrough that traces
each factor's formula, substituted values, variables, and field source."""

import os
import sys
import unittest

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

from database.Score import ScoreDatabase
from scoring import ScoringEngine
from scoring.engine import _PATHS, _fmt_num


def _add_filing(db, ein='123456789', year=2023, filing_id=1, uuid='u1',
                form_code='990', zip_filename='a_2023.zip', values=None):
    db.cursor.execute("INSERT OR IGNORE INTO organization (ein, name) VALUES (?, 'Org')", (ein,))
    db.cursor.execute(
        "INSERT INTO filing (filing_id, uuid, year, organization_id, form_code, zip_filename) "
        "VALUES (?,?,?,?,?,?)", (filing_id, uuid, year, ein, form_code, zip_filename))
    if values:
        xidx = db.get_xpath_index()
        for key, amt in values.items():
            fid = xidx.get(_PATHS[key])
            if fid is not None:
                db.cursor.execute(
                    "INSERT OR IGNORE INTO reported_data (filing_id, field_id, raw_value) VALUES (?,?,?)",
                    (filing_id, fid, str(amt)))
    db.connection.commit()


def _add_model(db, version, factors):
    """factors: list of (name, weight, formula_type, inputs_json, direction, lo, hi, desc)."""
    db.cursor.execute("INSERT INTO score_model (version, description) VALUES (?, 'm')", (version,))
    mid = db.cursor.lastrowid
    for name, w, ft, inp, d, lo, hi, desc in factors:
        db.cursor.execute(
            "INSERT INTO score_factor (model_id, name, weight, formula_type, inputs, direction, "
            "benchmark_lo, benchmark_hi, formula_description) VALUES (?,?,?,?,?,?,?,?,?)",
            (mid, name, w, ft, inp, d, lo, hi, desc))
    db.connection.commit()


class TestFmtNum(unittest.TestCase):
    def test_none(self):
        self.assertEqual(_fmt_num(None), "None")

    def test_integral_float(self):
        self.assertEqual(_fmt_num(950000.0), "950000")

    def test_fraction(self):
        self.assertEqual(_fmt_num(0.8547368), "0.854737")

    def test_negative(self):
        self.assertEqual(_fmt_num(-0.05), "-0.05")


class TestDebugRatio(unittest.TestCase):

    def setUp(self):
        self.db = ScoreDatabase(path=":memory:")  # seeds model v1
        _add_filing(self.db, values={'prog': 812000, 'total_exp': 950000})
        self.eng = ScoringEngine(self.db)
        self.report = self.eng.debug('123456789', 2023, 1)
        self.f0 = self.report['factors'][0]  # Program Expense: prog/total_exp

    def tearDown(self):
        self.db.close()

    def test_top_level_fields(self):
        self.assertEqual(self.report['ein'], '123456789')
        self.assertEqual(self.report['year'], 2023)
        self.assertEqual(self.report['form_code'], '990')
        self.assertEqual(self.report['model_version'], 1)
        self.assertEqual(self.report['filing_id'], 'u1')
        self.assertIn('total_score', self.report)
        self.assertEqual(len(self.report['evaluation_order']), len(self.report['factors']))

    def test_formula_expression_and_substitution(self):
        self.assertEqual(self.f0['formula']['expression'], 'prog / total_exp')
        self.assertEqual(self.f0['formula']['substituted'], '812000 / 950000')
        self.assertTrue(self.f0['formula']['computable'])
        self.assertAlmostEqual(self.f0['raw_value'], 812000 / 950000)

    def test_variable_values(self):
        v = {var['key']: var for var in self.f0['variables']}
        self.assertEqual(v['prog']['kind'], 'field')
        self.assertEqual(v['prog']['value'], 812000.0)
        self.assertEqual(v['prog']['raw_value'], '812000')
        self.assertTrue(v['prog']['present'])

    def test_variable_source_traceback(self):
        src = self.f0['variables'][0]['source']
        self.assertEqual(src['form']['code'], '990')
        self.assertEqual(src['part']['number'], 'IX')
        self.assertEqual(src['line']['number'], '25')
        self.assertIn('xml_path', src)
        self.assertIsInstance(src['field_id'], int)

    def test_normalization(self):
        n = self.f0['normalization']
        self.assertEqual(n['direction'], 'higher')
        # expression is the pure template; numbers live in benchmark_* + substituted
        self.assertEqual(n['expression'], 'clamp01((raw - lo) / (hi - lo))')
        self.assertIn('0.854737', n['substituted'])
        self.assertEqual(n['benchmark_lo'], 0.6)
        self.assertEqual(n['benchmark_hi'], 0.85)
        self.assertEqual(n['normalized'], 1.0)  # 0.855 > hi=0.85 → clamps to 1

    def test_weighted_value(self):
        self.assertAlmostEqual(self.f0['weighted_value'],
                               self.f0['normalized'] * self.f0['weight'])

    def test_debug_does_not_persist(self):
        n = self.db.cursor.execute("SELECT COUNT(*) FROM organization_score").fetchone()[0]
        self.assertEqual(n, 0)

    def test_matches_calculate(self):
        calc = self.eng.calculate('123456789', 2023, 1)
        self.assertAlmostEqual(calc['total_score'], self.report['total_score'])


class TestDebugMissingInput(unittest.TestCase):

    def test_missing_field_marks_incomputable(self):
        db = ScoreDatabase(path=":memory:")
        # total_exp present, prog absent → ratio prog/total_exp has a None numerator
        _add_filing(db, values={'total_exp': 950000})
        rep = ScoringEngine(db).debug('123456789', 2023, 1)
        f0 = rep['factors'][0]
        prog = next(v for v in f0['variables'] if v['key'] == 'prog')
        self.assertFalse(prog['present'])
        self.assertIsNone(prog['value'])
        self.assertEqual(f0['formula']['substituted'], 'None / 950000')
        # ratio with None numerator → engine returns None
        self.assertIsNone(f0['raw_value'])
        self.assertFalse(f0['formula']['computable'])
        self.assertIsNotNone(f0['formula']['note'])
        self.assertEqual(f0['normalized'], 0.0)
        db.close()


class TestDebugLiteralAndFactorRef(unittest.TestCase):

    def setUp(self):
        self.db = ScoreDatabase(path=":memory:")
        _add_model(self.db, 9, [
            ("Base", 0.0, "ratio", '["prog","total_exp"]', "higher", 0.0, 1.0, "base ratio"),
            ("Clamped", 0.5, "clamp", '["factor:Base","0","0.5"]', "higher", 0.0, 1.0, "clamp the base"),
        ])
        _add_filing(self.db, values={'prog': 400000, 'total_exp': 1000000})
        self.rep = ScoringEngine(self.db).debug('123456789', 2023, 9)

    def tearDown(self):
        self.db.close()

    def test_factor_reference_variable(self):
        clamped = next(f for f in self.rep['factors'] if f['name'] == 'Clamped')
        ref = clamped['variables'][0]
        self.assertEqual(ref['kind'], 'factor')
        self.assertEqual(ref['references'], 'Base')
        self.assertAlmostEqual(ref['value'], 0.4)  # 400000/1000000

    def test_literal_variables(self):
        clamped = next(f for f in self.rep['factors'] if f['name'] == 'Clamped')
        lits = [v for v in clamped['variables'] if v['kind'] == 'literal']
        self.assertEqual([v['value'] for v in lits], [0.0, 0.5])

    def test_clamp_expression(self):
        clamped = next(f for f in self.rep['factors'] if f['name'] == 'Clamped')
        self.assertEqual(clamped['formula']['expression'], 'max(0, min(0.5, factor:Base))')
        # 0.4 clamped to [0, 0.5] = 0.4
        self.assertAlmostEqual(clamped['raw_value'], 0.4)

    def test_evaluation_order_dependencies_first(self):
        # Base must be evaluated before Clamped that references it.
        order = self.rep['evaluation_order']
        self.assertLess(order.index('Base'), order.index('Clamped'))


class TestDebugHistorical(unittest.TestCase):

    def test_series_in_variable_and_formula(self):
        db = ScoreDatabase(path=":memory:")
        _add_model(db, 7, [
            ("Rev Trend", 1.0, "running_average", '["cy_rev"]', "higher", 0.0, 1000000.0, "avg revenue"),
        ])
        # three years of revenue for the same org
        _add_filing(db, year=2021, filing_id=1, uuid='a', values={'cy_rev': 100000})
        _add_filing(db, year=2022, filing_id=2, uuid='b', values={'cy_rev': 120000})
        _add_filing(db, year=2023, filing_id=3, uuid='c', values={'cy_rev': 140000})
        rep = ScoringEngine(db).debug('123456789', 2023, 7)
        f0 = rep['factors'][0]
        var = f0['variables'][0]
        self.assertEqual(sorted(var['series']), [100000.0, 120000.0, 140000.0])
        self.assertIn('mean(', f0['formula']['expression'])
        self.assertAlmostEqual(f0['raw_value'], 120000.0)
        db.close()


class TestDebugWorkingCapital(unittest.TestCase):

    def test_missing_optionals_render_as_zero(self):
        # working_capital treats missing cash/savings/accts_pay as 0.0; the
        # substituted formula must show 0, not a misleading None.
        db = ScoreDatabase(path=":memory:")
        _add_model(db, 8, [
            ("WC", 1.0, "working_capital", '["cash","savings","accts_pay","cy_exp"]',
             "higher", 0.0, 0.5, "working capital"),
        ])
        _add_filing(db, values={'cash': 60000, 'cy_exp': 950000})  # savings, accts_pay missing
        rep = ScoringEngine(db).debug('123456789', 2023, 8)
        f0 = rep['factors'][0]
        self.assertNotIn('None', f0['formula']['substituted'])
        self.assertEqual(f0['formula']['substituted'], '(60000 + 0 - 0) / 950000')
        # matches the engine's actual computation
        self.assertAlmostEqual(f0['raw_value'], 60000 / 950000)
        db.close()


class TestFieldSourceConsistency(unittest.TestCase):

    def test_source_field_id_matches_xpath_index(self):
        # get_field_source must resolve to the SAME field_id the value was stored
        # under (get_xpath_index, last-wins). Otherwise the traceback could show a
        # different field that merely shares the xml_path.
        db = ScoreDatabase(path=":memory:")
        xidx = db.get_xpath_index()
        for path in set(_PATHS.values()):
            if path not in xidx:
                continue
            src = db.get_field_source(path)
            self.assertIsNotNone(src, path)
            self.assertEqual(src['field_id'], xidx[path], f"mismatch for {path}")
        db.close()


class TestDebugErrors(unittest.TestCase):

    def test_calculate_empty_model_raises(self):
        # parity with debug(): calculate() must also reject an empty model rather
        # than silently persisting a 0.0 score.
        db = ScoreDatabase(path=":memory:")
        _add_filing(db, values={'prog': 1, 'total_exp': 2})
        with self.assertRaises(ValueError):
            ScoringEngine(db).calculate('123456789', 2023, 999)
        db.close()


    def test_unknown_filing_raises(self):
        db = ScoreDatabase(path=":memory:")
        with self.assertRaises(ValueError):
            ScoringEngine(db).debug('999999999', 1999, 1)
        db.close()

    def test_model_with_no_factors_raises(self):
        db = ScoreDatabase(path=":memory:")
        _add_filing(db, values={'prog': 1, 'total_exp': 2})
        with self.assertRaises(ValueError):
            ScoringEngine(db).debug('123456789', 2023, 999)
        db.close()


if __name__ == '__main__':  # pragma: no cover
    unittest.main()
