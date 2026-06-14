"""Tests for model types (seeded enum) and manual/graded scoring."""

import os
import sys
import unittest

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

from database import OpenReturnDB
from scoring import ScoringEngine
import models as models_mod


def _add_manual_model(db, version=2, model_type='governance', factors=None):
    factors = factors or [
        ('Board Independence', 0.5, 'percent', 'higher', 0.0, 1.0, 'Rate 0-100'),
        ('Conflict Policy',    0.5, 'benchmark', 'higher', 1.0, 5.0, 'Rate 1-5'),
    ]
    db.cursor.execute(
        "INSERT INTO score_model (version, description, model_type, scoring_mode) "
        "VALUES (?, 'm', ?, 'manual')", (version, model_type))
    mid = db.cursor.lastrowid
    ids = []
    for name, w, scale, direction, lo, hi, desc in factors:
        db.cursor.execute(
            "INSERT INTO score_factor (model_id, name, weight, formula_type, inputs, "
            "direction, benchmark_lo, benchmark_hi, manual_scale, formula_description) "
            "VALUES (?,?,?, 'manual', '[]', ?,?,?,?,?)",
            (mid, name, w, direction, lo, hi, scale, desc))
        ids.append(db.cursor.lastrowid)
    db.connection.commit()
    return ids


def _add_filing(db, ein='123456789', year=2023, filing_id=1, uuid='u1'):
    db.cursor.execute("INSERT OR IGNORE INTO organization (ein, name) VALUES (?, 'Org')", (ein,))
    db.cursor.execute(
        "INSERT INTO filing (filing_id, uuid, year, organization_id, form_code) "
        "VALUES (?,?,?,?, '990')", (filing_id, uuid, year, ein))
    db.connection.commit()


class TestModelTypeSeed(unittest.TestCase):

    def setUp(self):
        self.db = OpenReturnDB(path=":memory:")

    def tearDown(self):
        self.db.close()

    def test_types_seeded(self):
        codes = {t['code'] for t in self.db.scores.list_model_types()}
        self.assertEqual(codes, {'financial', 'governance', 'whole_person', 'christ_centeredness'})

    def test_v1_is_financial_computed(self):
        m = self.db.scores.get_model(1)
        self.assertEqual(m['model_type'], 'financial')
        self.assertEqual(m['scoring_mode'], 'computed')

    def test_list_models_includes_type_and_mode(self):
        ms = self.db.scores.list_models()
        self.assertEqual(ms[0]['model_type'], 'financial')
        self.assertEqual(ms[0]['scoring_mode'], 'computed')


class TestNormalizeManual(unittest.TestCase):

    def setUp(self):
        self.eng = ScoringEngine(OpenReturnDB(path=":memory:"))

    def tearDown(self):
        self.eng.db.close()

    def test_percent(self):
        f = {'manual_scale': 'percent', 'weight': 1.0}
        self.assertAlmostEqual(self.eng._normalize_manual(f, 80), 0.8)
        self.assertEqual(self.eng._normalize_manual(f, 150), 1.0)   # clamped

    def test_normalized(self):
        f = {'manual_scale': 'normalized', 'weight': 1.0}
        self.assertAlmostEqual(self.eng._normalize_manual(f, 0.6), 0.6)
        self.assertEqual(self.eng._normalize_manual(f, -1), 0.0)    # clamped

    def test_benchmark(self):
        f = {'manual_scale': 'benchmark', 'direction': 'higher',
             'benchmark_lo': 1.0, 'benchmark_hi': 5.0}
        self.assertAlmostEqual(self.eng._normalize_manual(f, 4), 0.75)

    def test_none_is_zero(self):
        self.assertEqual(self.eng._normalize_manual({'manual_scale': 'percent'}, None), 0.0)


class TestGrade(unittest.TestCase):

    def setUp(self):
        self.db = OpenReturnDB(path=":memory:")
        self.eng = ScoringEngine(self.db)
        _add_filing(self.db)
        self.fids = _add_manual_model(self.db, version=2)
        self.score_id = self.db.scores.create_score('u1', 2)

    def tearDown(self):
        self.db.close()

    def test_grade_updates_value_comment_and_total(self):
        self.eng.grade(self.score_id, self.fids[0], 80, "indep board")
        res = self.eng.grade(self.score_id, self.fids[1], 4, "good policy")
        self.assertAlmostEqual(res['total_score'], 0.4 + 0.375)  # 0.8*.5 + 0.75*.5
        by = {f['factor_id']: f for f in res['factors']}
        self.assertEqual(by[self.fids[0]]['comment'], "indep board")
        self.assertAlmostEqual(by[self.fids[0]]['weighted_value'], 0.4)

    def test_grade_is_idempotent_upsert(self):
        self.eng.grade(self.score_id, self.fids[0], 80, "first")
        res = self.eng.grade(self.score_id, self.fids[0], 50, "revised")
        by = {f['factor_id']: f for f in res['factors']}
        self.assertEqual(by[self.fids[0]]['raw_value'], 50.0)
        self.assertEqual(by[self.fids[0]]['comment'], "revised")

    def test_grade_rejects_computed_model(self):
        # v1 is computed; make a score for it and try to grade
        _add_filing(self.db, year=2022, filing_id=2, uuid='u2')
        sid = self.db.scores.create_score('u2', 1)
        with self.assertRaises(ValueError):
            self.eng.grade(sid, 1, 0.5, "nope")

    def test_grade_rejects_foreign_factor(self):
        with self.assertRaises(ValueError):
            self.eng.grade(self.score_id, 99999, 1, "nope")

    def test_grade_unknown_score(self):
        with self.assertRaises(ValueError):
            self.eng.grade(123456, self.fids[0], 1, "nope")

    def test_grade_rejects_non_finite(self):
        for bad in (float('inf'), float('-inf'), float('nan')):
            with self.assertRaises(ValueError):
                self.eng.grade(self.score_id, self.fids[0], bad, "x")


class TestCalculateRejectsManual(unittest.TestCase):

    def test_calculate_manual_raises(self):
        db = OpenReturnDB(path=":memory:")
        _add_filing(db)
        _add_manual_model(db, version=2)
        with self.assertRaises(ValueError):
            ScoringEngine(db).calculate('123456789', 2023, 2)
        db.close()


class TestDebugManual(unittest.TestCase):

    def setUp(self):
        self.db = OpenReturnDB(path=":memory:")
        self.eng = ScoringEngine(self.db)
        _add_filing(self.db)
        self.fids = _add_manual_model(self.db, version=2)

    def tearDown(self):
        self.db.close()

    def test_debug_ungraded(self):
        rep = self.eng.debug('123456789', 2023, 2)
        self.assertEqual(rep['scoring_mode'], 'manual')
        self.assertEqual(rep['model_type'], 'governance')
        self.assertFalse(rep['graded'])
        f0 = rep['factors'][0]
        self.assertEqual(f0['kind'], 'manual')
        self.assertEqual(f0['manual_scale'], 'percent')
        self.assertIsNone(f0['value'])
        self.assertEqual(f0['weighted_value'], 0.0)

    def test_debug_graded_shows_values_and_comments(self):
        sid = self.db.scores.create_score('u1', 2)
        self.eng.grade(sid, self.fids[0], 80, "indep")
        rep = self.eng.debug('123456789', 2023, 2)
        self.assertTrue(rep['graded'])
        f0 = next(f for f in rep['factors'] if f['factor_id'] == self.fids[0])
        self.assertEqual(f0['value'], 80.0)
        self.assertEqual(f0['comment'], "indep")
        self.assertIn('clamp01(80 / 100)', f0['normalization']['substituted'])


class TestManualTomlValidation(unittest.TestCase):

    BASE = {'model': {'version': 5, 'type': 'governance', 'mode': 'manual'},
            'factor': [{'name': 'A', 'weight': 1.0, 'scale': 'percent',
                        'formula_description': 'rate it'}]}

    def _issues(self, data):
        return [i for i in models_mod.validate_toml(data) if i.startswith('ERROR')]

    def test_valid_manual(self):
        self.assertEqual(self._issues(self.BASE), [])

    def test_missing_scale(self):
        d = {'model': self.BASE['model'], 'factor': [{'name': 'A', 'weight': 1.0}]}
        self.assertTrue(any('scale' in i for i in self._issues(d)))

    def test_bad_scale(self):
        d = {'model': self.BASE['model'],
             'factor': [{'name': 'A', 'weight': 1.0, 'scale': 'bogus'}]}
        self.assertTrue(self._issues(d))

    def test_benchmark_scale_needs_direction_and_bounds(self):
        d = {'model': self.BASE['model'],
             'factor': [{'name': 'A', 'weight': 1.0, 'scale': 'benchmark'}]}
        self.assertTrue(self._issues(d))

    def test_formula_type_must_be_manual(self):
        d = {'model': self.BASE['model'],
             'factor': [{'name': 'A', 'weight': 1.0, 'scale': 'percent', 'formula_type': 'ratio'}]}
        self.assertTrue(any('formula_type' in i for i in self._issues(d)))

    def test_bad_mode(self):
        d = {'model': {'version': 5, 'mode': 'wibble'}, 'factor': self.BASE['factor']}
        self.assertTrue(any('mode' in i for i in self._issues(d)))

    def test_computed_model_unaffected(self):
        d = {'model': {'version': 6},
             'factor': [{'name': 'X', 'weight': 1.0, 'formula_type': 'ratio',
                         'inputs': ['prog', 'total_exp'], 'direction': 'higher',
                         'benchmark_lo': 0.0, 'benchmark_hi': 1.0}]}
        self.assertEqual(self._issues(d), [])

    def test_computed_factor_with_scale_rejected(self):
        d = {'model': {'version': 6},
             'factor': [{'name': 'X', 'weight': 1.0, 'formula_type': 'ratio',
                         'inputs': ['prog', 'total_exp'], 'direction': 'higher',
                         'benchmark_lo': 0.0, 'benchmark_hi': 1.0, 'scale': 'percent'}]}
        self.assertTrue(any('scale' in i for i in self._issues(d)))


if __name__ == '__main__':  # pragma: no cover
    unittest.main()
