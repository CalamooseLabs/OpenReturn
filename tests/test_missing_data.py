"""Tests for the configurable missing-data fallbacks that complete a score
history: per-input strategies, the two-pass batch fill (interior + incomplete
years, with a synthetic FIN anchor), composite/super-composite imputation reading
filled child years, the score-equality invariant for no-policy models, historical
formulas ignoring imputed points, and idempotent rebuilds."""

import json
import os
import sys
import unittest
from unittest.mock import MagicMock

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

from auth import Principal
from database import OpenReturnDB
from scoring import ScoringEngine
from scoring.engine import _FillCtx, _pick_donor_year
from models import validate_toml


def _toml(inputs, *, missing_data=None):
    m = {'version': 2}
    if missing_data is not None:
        m['missing_data'] = missing_data
    return {'model': m, 'factor': [{'name': 'PE', 'weight': 1.0, 'formula_type': 'ratio',
            'inputs': inputs, 'direction': 'higher', 'benchmark_lo': 0.0, 'benchmark_hi': 1.0}]}


def _errors(data):
    return [i for i in validate_toml(data) if i.startswith('ERROR:')]


def _actor():
    return Principal(kind='user', actor_id=1, label='alice', permissions=frozenset(), user_id=1)


def _add_model(db, version, factors, *, kind='model', missing_data=None):
    """Insert a computed model + factors directly. ``factors`` is a list of dicts
    with name/weight/formula_type/inputs (inputs may be strings or {key,missing})."""
    db.cursor.execute(
        "INSERT INTO score_model (version, model_type, scoring_mode, model_kind, missing_data) "
        "VALUES (?, 'financial', 'computed', ?, ?)", (version, kind, missing_data))
    model_id = db.cursor.lastrowid
    for f in factors:
        db.cursor.execute(
            "INSERT INTO score_factor (model_id, name, weight, formula_type, inputs, "
            "direction, benchmark_lo, benchmark_hi) VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
            (model_id, f['name'], f['weight'], f['formula_type'], json.dumps(f['inputs']),
             f.get('direction', 'higher'), f.get('benchmark_lo', 0.0), f.get('benchmark_hi', 1.0)))
    db.connection.commit()
    return model_id


def _data(db, ein, year, values):
    db.cursor.execute("INSERT OR IGNORE INTO organization (ein, name) VALUES (?, 'Org')", (ein,))
    db.connection.commit()
    db.financials.record_observations(ein, year, 'audited_statement', values, actor=_actor())


def _scores_by_year(db, ein, version=1):
    rows = db.cursor.execute(
        "SELECT f.year, os.total_score, os.imputed FROM organization_score os "
        "JOIN filing f ON f.filing_id = os.filing_id "
        "JOIN score_model sm ON sm.model_id = os.model_id "
        "WHERE f.organization_id = ? AND sm.version = ? ORDER BY f.year",
        (ein, version)).fetchall()
    return {r[0]: {"total": r[1], "imputed": bool(r[2])} for r in rows}


# ── pure strategy logic ──────────────────────────────────────────────────────

class TestStrategies(unittest.TestCase):
    def test_pick_donor_year(self):
        s = {2018: 1.0, 2020: 2.0, 2023: 3.0}
        self.assertEqual(_pick_donor_year(s, 2021, 'newest'), 2023)
        self.assertEqual(_pick_donor_year(s, 2021, 'oldest'), 2018)
        # 2021: nearest is 2020 (dist 1) vs 2023 (dist 2) → 2020 either way.
        self.assertEqual(_pick_donor_year(s, 2021, 'closest_older'), 2020)
        self.assertEqual(_pick_donor_year(s, 2021, 'closest_newer'), 2020)
        # 2019 is equidistant from 2018 and 2020 → tie-break by direction.
        self.assertEqual(_pick_donor_year(s, 2019, 'closest_older'), 2018)
        self.assertEqual(_pick_donor_year(s, 2019, 'closest_newer'), 2020)
        self.assertIsNone(_pick_donor_year({}, 2020, 'newest'))

    def test_resolve_input_filled(self):
        eng = ScoringEngine(db=MagicMock())
        fill = _FillCtx({'cy_rev': {2019: 100.0, 2022: 400.0}}, {}, 2020, None)
        # present this year → no fill
        self.assertEqual(eng._resolve_input_filled('cy_rev', 'newest', {'cy_rev': 9.0}, {}, {}, fill),
                         (9.0, None, False))
        # missing, policy none → no fill
        self.assertEqual(eng._resolve_input_filled('cy_rev', 'none', {}, {}, {}, fill),
                         (None, None, False))
        # missing, newest → donor 2022
        self.assertEqual(eng._resolve_input_filled('cy_rev', 'newest', {}, {}, {}, fill),
                         (400.0, 2022, True))
        # constant fill carries no donor year
        self.assertEqual(eng._resolve_input_filled('cy_rev', 'value:5', {}, {}, {}, fill),
                         (5.0, None, True))
        # a factor: ref is never series-filled
        self.assertEqual(eng._resolve_input_filled('factor:x', 'newest', {}, {}, {}, fill),
                         (None, None, False))
        # a model:<v> input fills from its year series
        fill2 = _FillCtx({}, {10: {2019: 0.5, 2022: 0.9}}, 2020, None)
        self.assertEqual(eng._resolve_input_filled('model:10', 'newest', {}, {}, {}, fill2),
                         (0.9, 2022, True))
        # malformed model ref → no series → no fill
        self.assertEqual(eng._resolve_input_filled('model:x', 'newest', {}, {}, {}, fill2),
                         (None, None, False))
        # empty series → no donor
        self.assertEqual(
            eng._resolve_input_filled('cy_rev', 'newest', {}, {}, {}, _FillCtx({}, {}, 2020, None)),
            (None, None, False))
        # unparseable value:<x> → no fill
        self.assertEqual(eng._resolve_input_filled('cy_rev', 'value:abc', {}, {}, {}, fill),
                         (None, None, False))


class TestValidation(unittest.TestCase):
    def test_model_level_missing_data_valid(self):
        self.assertEqual(_errors(_toml(['prog', 'total_exp'], missing_data='newest')), [])

    def test_model_level_missing_data_invalid(self):
        errs = _errors(_toml(['prog', 'total_exp'], missing_data='bogus'))
        self.assertTrue(any('missing_data' in e for e in errs))

    def test_per_input_dict_valid(self):
        self.assertEqual(
            _errors(_toml([{'key': 'prog'}, {'key': 'total_exp', 'missing': 'closest_older'}])), [])

    def test_per_input_value_strategy_valid(self):
        self.assertEqual(_errors(_toml([{'key': 'prog', 'missing': 'value:0'}, 'total_exp'])), [])

    def test_per_input_invalid_strategy(self):
        errs = _errors(_toml([{'key': 'prog', 'missing': 'nope'}, 'total_exp']))
        self.assertTrue(any('invalid missing strategy' in e for e in errs))

    def test_per_input_unparseable_value(self):
        errs = _errors(_toml([{'key': 'prog', 'missing': 'value:abc'}, 'total_exp']))
        self.assertTrue(any('invalid missing strategy' in e for e in errs))

    def test_input_table_unknown_key(self):
        errs = _errors(_toml([{'key': 'prog', 'typo': 1}, 'total_exp']))
        self.assertTrue(any('unknown input-table key' in e for e in errs))

    def test_input_table_non_string_key(self):
        errs = _errors(_toml([{'key': 123}, 'total_exp']))
        self.assertTrue(any("string 'key'" in e for e in errs))


# ── batch fill (the score history) ───────────────────────────────────────────

_PE = {'name': 'PE', 'weight': 1.0, 'formula_type': 'ratio',
       'inputs': ['prog', 'total_exp'], 'benchmark_lo': 0.0, 'benchmark_hi': 1.0}


class TestBatchFill(unittest.TestCase):
    def setUp(self):
        self.db = OpenReturnDB(path=':memory:')

    def tearDown(self):
        self.db.close()

    def test_no_policy_model_is_unchanged_and_never_imputes(self):
        _add_model(self.db, 91, [_PE])                      # no missing_data
        for y, p in ((2020, 700), (2021, 800), (2022, 900)):
            _data(self.db, '100000001', y, {'prog': p, 'total_exp': 1000})
        ScoringEngine(self.db).rebuild(eins=['100000001'], model_versions=[91])
        sc = _scores_by_year(self.db, '100000001', 91)
        self.assertEqual(set(sc), {2020, 2021, 2022})
        self.assertFalse(any(v['imputed'] for v in sc.values()))
        self.assertAlmostEqual(sc[2022]['total'], 0.9)
        # No FIN anchor is created for a no-policy model (only real years scored).
        self.assertEqual(set(sc), {2020, 2021, 2022})

    def test_interior_gap_is_filled_and_flagged(self):
        _add_model(self.db, 91, [_PE], missing_data='closest_newer')
        _data(self.db, '100000002', 2020, {'prog': 700, 'total_exp': 1000})
        _data(self.db, '100000002', 2022, {'prog': 900, 'total_exp': 1000})  # gap at 2021
        ScoringEngine(self.db).rebuild(eins=['100000002'], model_versions=[91])
        sc = _scores_by_year(self.db, '100000002', 91)
        self.assertEqual(set(sc), {2020, 2021, 2022})       # gap filled
        self.assertFalse(sc[2020]['imputed'])
        self.assertFalse(sc[2022]['imputed'])
        self.assertTrue(sc[2021]['imputed'])
        # closest_newer from 2021 → 2022 (0.9), so the filled year mirrors 2022.
        self.assertAlmostEqual(sc[2021]['total'], 0.9)
        # The per-factor donor year is recorded.
        row = self.db.cursor.execute(
            "SELECT osf.source_year, osf.imputed FROM organization_score_factor osf "
            "JOIN organization_score os ON os.score_id = osf.score_id "
            "JOIN filing f ON f.filing_id = os.filing_id "
            "WHERE f.organization_id = '100000002' AND f.year = 2021").fetchone()
        self.assertEqual((row[0], bool(row[1])), (2022, True))

    def test_incomplete_year_fills_only_missing_inputs(self):
        # 2021 has total_exp but not prog → prog filled from 2020, total_exp real.
        _add_model(self.db, 91, [_PE], missing_data='oldest')
        _data(self.db, '100000003', 2020, {'prog': 600, 'total_exp': 1000})
        _data(self.db, '100000003', 2021, {'total_exp': 2000})
        ScoringEngine(self.db).rebuild(eins=['100000003'], model_versions=[91])
        sc = _scores_by_year(self.db, '100000003', 91)
        self.assertTrue(sc[2021]['imputed'])
        # prog filled with 2020's 600; total_exp real 2000 → 600/2000 = 0.3
        self.assertAlmostEqual(sc[2021]['total'], 0.3)

    def test_window_never_precedes_earliest_data(self):
        _add_model(self.db, 91, [_PE], missing_data='newest')
        _data(self.db, '100000004', 2021, {'prog': 500, 'total_exp': 1000})
        _data(self.db, '100000004', 2023, {'prog': 700, 'total_exp': 1000})
        ScoringEngine(self.db).rebuild(eins=['100000004'], model_versions=[91])
        sc = _scores_by_year(self.db, '100000004', 91)
        self.assertEqual(min(sc), 2021)                     # nothing before 2021
        self.assertEqual(set(sc), {2021, 2022, 2023})

    def test_rebuild_is_idempotent_no_fin_accumulation(self):
        _add_model(self.db, 91, [_PE], missing_data='newest')
        _data(self.db, '100000005', 2020, {'prog': 500, 'total_exp': 1000})
        _data(self.db, '100000005', 2022, {'prog': 800, 'total_exp': 1000})
        eng = ScoringEngine(self.db)
        eng.rebuild(eins=['100000005'], model_versions=[91])
        eng.rebuild(eins=['100000005'], model_versions=[91])                     # run twice
        fin = self.db.cursor.execute(
            "SELECT COUNT(*) FROM filing WHERE organization_id = '100000005' "
            "AND year = 2021 AND form_code = 'FIN'").fetchone()[0]
        self.assertEqual(fin, 1)                            # one synthetic anchor, not two
        sc = _scores_by_year(self.db, '100000005', 91)
        self.assertEqual(len([y for y in sc if y == 2021]), 1)


# ── composites read imputed child years ──────────────────────────────────────

class TestCompositeFill(unittest.TestCase):
    def test_super_composite_reads_imputed_composite_year(self):
        db = OpenReturnDB(path=':memory:')
        try:
            # v10 base (PE), v20 composite of v10, v30 super-composite of v20 — all
            # carrying a fill policy so the missing year propagates up the chain.
            _add_model(db, 10, [_PE], missing_data='newest')
            _add_model(db, 20, [{'name': 'C', 'weight': 1.0, 'formula_type': 'sum',
                                 'inputs': [{'key': 'model:10', 'missing': 'newest'}],
                                 'benchmark_lo': 0.0, 'benchmark_hi': 1.0}],
                       kind='composite', missing_data='newest')
            _add_model(db, 30, [{'name': 'S', 'weight': 1.0, 'formula_type': 'sum',
                                 'inputs': [{'key': 'model:20', 'missing': 'newest'}],
                                 'benchmark_lo': 0.0, 'benchmark_hi': 1.0}],
                       kind='super_composite', missing_data='newest')
            _data(db, '200000001', 2020, {'prog': 800, 'total_exp': 1000})   # PE 0.8
            _data(db, '200000001', 2022, {'prog': 900, 'total_exp': 1000})   # gap at 2021
            ScoringEngine(db).rebuild(eins=['200000001'], model_versions=[30])
            base = _scores_by_year(db, '200000001', 10)
            top = _scores_by_year(db, '200000001', 30)
            self.assertTrue(base[2021]['imputed'])
            self.assertTrue(top[2021]['imputed'])
            # v30[2021] derives from v20[2021] which derives from v10's filled 2021.
            self.assertAlmostEqual(top[2021]['total'], top[2022]['total'])
        finally:
            db.close()


# ── historical formulas ignore imputed points ────────────────────────────────

class TestHistoricalUnaffected(unittest.TestCase):
    def test_cagr_uses_real_years_only(self):
        db = OpenReturnDB(path=':memory:')
        try:
            # A model mixing a historical factor (CAGR over cy_rev) with a filled
            # ratio. The interior gap is imputed for the ratio, but CAGR must read
            # only the two real years (1000 → 1210 over 2 steps = 10%/yr).
            _add_model(db, 91, [
                {'name': 'Growth', 'weight': 0.5, 'formula_type': 'cagr',
                 'inputs': ['cy_rev'], 'benchmark_lo': 0.0, 'benchmark_hi': 0.2},
                {'name': 'PE', 'weight': 0.5, 'formula_type': 'ratio',
                 'inputs': ['prog', 'total_exp'], 'benchmark_lo': 0.0, 'benchmark_hi': 1.0},
            ], missing_data='newest')
            _data(db, '300000001', 2020, {'cy_rev': 1000, 'prog': 800, 'total_exp': 1000})
            _data(db, '300000001', 2022, {'cy_rev': 1210, 'prog': 900, 'total_exp': 1000})
            ScoringEngine(db).rebuild(eins=['300000001'], model_versions=[91])
            eng = ScoringEngine(db)
            dbg2020 = eng.debug('300000001', 2020, 91)
            cagr = next(f for f in dbg2020['factors'] if f['name'] == 'Growth')
            # Two REAL years → CAGR = (1210/1000)^(1/1) - 1 = 0.21. Had an imputed
            # 2021 point leaked into the series it would be 3 points and ≈0.10, so
            # 0.21 proves historical formulas read real years only.
            self.assertAlmostEqual(cagr['raw_value'], 0.21, places=4)
        finally:
            db.close()


class TestCalculateFill(unittest.TestCase):
    """The single-year on-demand path fills an existing incomplete year the same
    way the batch path does (no drift)."""

    def test_calculate_fills_incomplete_year(self):
        db = OpenReturnDB(path=':memory:')
        try:
            _add_model(db, 91, [_PE], missing_data='oldest')
            _data(db, '500000001', 2020, {'prog': 600, 'total_exp': 1000})
            _data(db, '500000001', 2021, {'total_exp': 2000})     # prog missing
            score = ScoringEngine(db).calculate('500000001', 2021, 91)
            self.assertTrue(score['imputed'])
            pe = next(f for f in score['factors'] if f['name'] == 'PE')
            self.assertAlmostEqual(pe['raw_value'], 0.3)          # 600 (from 2020) / 2000
        finally:
            db.close()

    def test_calculate_composite_fills_child_year(self):
        db = OpenReturnDB(path=':memory:')
        try:
            _add_model(db, 10, [_PE], missing_data='oldest')
            _add_model(db, 20, [{'name': 'C', 'weight': 1.0, 'formula_type': 'sum',
                                 'inputs': ['model:10'], 'benchmark_lo': 0.0, 'benchmark_hi': 1.0}],
                       kind='composite', missing_data='oldest')
            _data(db, '500000002', 2020, {'prog': 800, 'total_exp': 1000})
            _data(db, '500000002', 2021, {'total_exp': 2000})     # child prog filled from 2020
            score = ScoringEngine(db).calculate('500000002', 2021, 20)
            self.assertAlmostEqual(score['total_score'], 0.4)     # child PE 800/2000 = 0.4
        finally:
            db.close()


class TestHistorySurface(unittest.TestCase):
    def test_history_and_get_score_carry_flags(self):
        db = OpenReturnDB(path=':memory:')
        try:
            _add_model(db, 91, [_PE], missing_data='newest')
            _data(db, '400000001', 2020, {'prog': 700, 'total_exp': 1000})
            _data(db, '400000001', 2022, {'prog': 900, 'total_exp': 1000})   # gap 2021
            ScoringEngine(db).rebuild(eins=['400000001'], model_versions=[91])
            hist = db.scores.list_score_history('400000001', 91)
            years = {h['year']: h for h in hist}
            self.assertEqual(sorted(years), [2020, 2021, 2022])
            self.assertFalse(years[2020]['imputed'])
            self.assertTrue(years[2021]['imputed'])
            self.assertEqual(years[2021]['source_year'], 2022)   # newest donor
            # get_score surfaces the score-level + per-factor flags.
            full = db.scores.get_score(years[2021]['score_id'])
            self.assertTrue(full['imputed'])
            self.assertTrue(full['factors'][0]['imputed'])
            self.assertEqual(full['factors'][0]['source_year'], 2022)
        finally:
            db.close()


if __name__ == '__main__':
    unittest.main()
