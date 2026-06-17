"""Tests for the model *kind* dimension: base `model`, `composite`, and
`super_composite`. Covers TOML validation, the DB layer, cross-model scoring in
the engine (calculate + batch rebuild), registration's cross-model reference
checks, and the /scores/kinds + /scores/factors routes."""

import json
import os
import sys
import tempfile
import types
import unittest
from unittest.mock import MagicMock

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

from database import OpenReturnDB
from scoring import ScoringEngine
from scoring.engine import _PATHS
from router.Score import ScoreRouter
import models as models_cli


# ── helpers ──────────────────────────────────────────────────────────────────

def _add_filing(db, ein='123456789', year=2023, filing_id=1, uuid='u1',
                form_code='990', values=None):
    db.cursor.execute("INSERT OR IGNORE INTO organization (ein, name) VALUES (?, 'Org')", (ein,))
    db.cursor.execute(
        "INSERT INTO filing (filing_id, uuid, year, organization_id, form_code) "
        "VALUES (?,?,?,?,?)", (filing_id, uuid, year, ein, form_code))
    if values:
        xidx = db.meta.get_xpath_index()
        for key, amt in values.items():
            fid = xidx.get(_PATHS[key])
            if fid is not None:
                db.cursor.execute(
                    "INSERT OR IGNORE INTO reported_data (filing_id, field_id, raw_value) "
                    "VALUES (?,?,?)", (filing_id, fid, str(amt)))
    db.connection.commit()


def _add_model(db, version, factors, kind='model', mode='computed', mtype='financial'):
    """factors: list of (name, weight, formula_type, inputs(list), direction, lo, hi)."""
    db.cursor.execute(
        "INSERT INTO score_model (version, description, model_type, scoring_mode, model_kind) "
        "VALUES (?,?,?,?,?)", (version, f'm{version}', mtype, mode, kind))
    mid = db.cursor.lastrowid
    for name, w, ft, inp, d, lo, hi in factors:
        db.cursor.execute(
            "INSERT INTO score_factor (model_id, name, weight, formula_type, inputs, "
            "direction, benchmark_lo, benchmark_hi) VALUES (?,?,?,?,?,?,?,?)",
            (mid, name, w, ft, json.dumps(inp), d, lo, hi))
    db.connection.commit()
    return mid


def _toml(kind='model', factors=None, mode='computed', version=2):
    model = {'version': version, 'kind': kind}
    if mode != 'computed':
        model['mode'] = mode
    return {'model': model, 'factor': factors or []}


def _f(name, inputs, ft='ratio', w=1.0, d='higher', lo=0.0, hi=1.0):
    return {'name': name, 'weight': w, 'formula_type': ft, 'inputs': inputs,
            'direction': d, 'benchmark_lo': lo, 'benchmark_hi': hi}


def _errors(issues):
    return [i for i in issues if i.startswith('ERROR')]


# ── validate_toml: kind handling ──────────────────────────────────────────────

class TestValidateKind(unittest.TestCase):

    def test_base_model_default_kind_ok(self):
        data = {'model': {'version': 2}, 'factor': [_f('A', ['prog', 'total_exp'])]}
        self.assertEqual(_errors(models_cli.validate_toml(data)), [])

    def test_valid_composite(self):
        data = _toml('composite', [_f('Fin', ['model:10'], ft='sum')])
        self.assertEqual(_errors(models_cli.validate_toml(data)), [])

    def test_valid_super_composite(self):
        data = _toml('super_composite', [_f('Overall', ['model:20'], ft='sum')])
        self.assertEqual(_errors(models_cli.validate_toml(data)), [])

    def test_unknown_kind_rejected(self):
        data = _toml('mega', [_f('A', ['prog', 'total_exp'])])
        errs = _errors(models_cli.validate_toml(data))
        self.assertTrue(any('kind must be one of' in e for e in errs))

    def test_base_model_cannot_reference_model(self):
        data = _toml('model', [_f('A', ['model:10'], ft='sum')])
        errs = _errors(models_cli.validate_toml(data))
        self.assertTrue(any("base 'model' cannot reference other models" in e for e in errs))

    def test_composite_cannot_take_field_input(self):
        data = _toml('composite', [_f('A', ['prog', 'total_exp'])])
        errs = _errors(models_cli.validate_toml(data))
        self.assertTrue(any('990 field key' in e for e in errs))

    def test_composite_requires_a_model_reference(self):
        # A composite whose only inputs are literals references no child model.
        data = _toml('composite', [_f('A', ['0.5'], ft='sum')])
        errs = _errors(models_cli.validate_toml(data))
        self.assertTrue(any('must reference at least one child' in e for e in errs))

    def test_composite_cannot_be_manual(self):
        data = _toml('composite', [{'name': 'A', 'weight': 1.0, 'scale': 'percent'}],
                     mode='manual')
        errs = _errors(models_cli.validate_toml(data))
        self.assertTrue(any('cannot be manual' in e for e in errs))

    def test_bad_model_version_token(self):
        for bad in ['model:abc', 'model:0', 'model:-1', 'model:']:
            data = _toml('composite', [_f('A', [bad], ft='sum')])
            errs = _errors(models_cli.validate_toml(data))
            self.assertTrue(any("'model:' reference must be a positive integer" in e for e in errs),
                            f"expected rejection for {bad!r}")

    def test_composite_allows_factor_and_literal_with_model(self):
        data = _toml('composite', [
            _f('Blend', ['model:10', 'model:11'], ft='average'),
            _f('Final', ['factor:Blend', '1.0'], ft='product'),
        ])
        self.assertEqual(_errors(models_cli.validate_toml(data)), [])

    def test_bare_numeric_literal_rejected_with_clear_message(self):
        # A bare TOML number (not a quoted string) must be flagged clearly, not as
        # an "unknown input key" that confusingly lists "a numeric literal" as valid.
        data = _toml('composite', [_f('A', [0.5, 'model:10'], ft='product')])
        errs = _errors(models_cli.validate_toml(data))
        self.assertTrue(any('must be a quoted' in e for e in errs), errs)
        self.assertFalse(any('unknown input key' in e for e in errs), errs)

    def test_leading_zero_model_token_rejected(self):
        data = _toml('composite', [_f('A', ['model:01'], ft='sum')])
        errs = _errors(models_cli.validate_toml(data))
        self.assertTrue(any("'model:' reference must be a positive integer" in e for e in errs), errs)


# ── DB layer ───────────────────────────────────────────────────────────────────

class TestModelKindDB(unittest.TestCase):

    def setUp(self):
        self.db = OpenReturnDB(path=':memory:')  # seeds model v1 (base/financial)

    def tearDown(self):
        self.db.close()

    def test_list_model_kinds(self):
        codes = {k['code'] for k in self.db.scores.list_model_kinds()}
        self.assertEqual(codes, {'model', 'composite', 'super_composite'})

    def test_seeded_model_defaults_to_model_kind(self):
        self.assertEqual(self.db.scores.get_model(1)['model_kind'], 'model')

    def test_list_computed_models_carries_kind(self):
        _add_model(self.db, 20, [('F', 1.0, 'sum', ['model:1'], 'higher', 0.0, 1.0)],
                   kind='composite')
        kinds = {m['version']: m['model_kind'] for m in self.db.scores.list_computed_models()}
        self.assertEqual(kinds[1], 'model')
        self.assertEqual(kinds[20], 'composite')


# ── engine: cross-model scoring ────────────────────────────────────────────────

class TestCompositeScoring(unittest.TestCase):

    def setUp(self):
        self.db = OpenReturnDB(path=':memory:')
        # Two base models, a composite over both, and a super-composite over it.
        _add_model(self.db, 10, [('PE', 1.0, 'ratio', ['prog', 'total_exp'], 'higher', 0.0, 1.0)])
        _add_model(self.db, 11, [('AE', 1.0, 'ratio', ['admin', 'total_exp'], 'lower', 0.0, 1.0)])
        _add_model(self.db, 20, [
            ('Op', 0.6, 'sum', ['model:10'], 'higher', 0.0, 1.0),
            ('Fund', 0.4, 'sum', ['model:11'], 'higher', 0.0, 1.0),
        ], kind='composite')
        _add_model(self.db, 30, [('Fin', 1.0, 'sum', ['model:20'], 'higher', 0.0, 1.0)],
                   kind='super_composite')
        # prog/total_exp = 0.8 → model 10 = 0.8; admin/total_exp = 0.2, lower-better → 0.8.
        _add_filing(self.db, values={'prog': 800, 'admin': 200, 'total_exp': 1000})
        self.eng = ScoringEngine(self.db)

    def tearDown(self):
        self.db.close()

    def _calc(self, version):
        self.db.cursor.execute("DELETE FROM organization_score")
        self.db.connection.commit()
        return self.eng.calculate('123456789', 2023, version)['total_score']

    def test_base_model_totals(self):
        self.assertAlmostEqual(self._calc(10), 0.8)
        self.assertAlmostEqual(self._calc(11), 0.8)

    def test_composite_is_weighted_blend_of_children(self):
        # 0.6*0.8 + 0.4*0.8 = 0.8
        self.assertAlmostEqual(self._calc(20), 0.8)

    def test_super_composite_passes_through_composite(self):
        self.assertAlmostEqual(self._calc(30), 0.8)

    def test_rebuild_matches_calculate_and_orders_dependencies(self):
        self.eng.rebuild()
        rows = self.db.cursor.execute(
            "SELECT sm.version, os.total_score FROM organization_score os "
            "JOIN score_model sm ON sm.model_id = os.model_id").fetchall()
        totals = {v: t for v, t in rows}
        # All four (plus seeded v1) scored in one batch, composite/super resolved.
        self.assertAlmostEqual(totals[10], 0.8)
        self.assertAlmostEqual(totals[20], 0.8)
        self.assertAlmostEqual(totals[30], 0.8)

    def test_scoring_composite_subset_pulls_in_children(self):
        # `--version 20` (composite only) must still compute its children, else
        # model: inputs resolve to None and the composite would score 0.
        self.eng.rebuild(model_versions=[20])
        rows = dict(self.db.cursor.execute(
            "SELECT sm.version, os.total_score FROM organization_score os "
            "JOIN score_model sm ON sm.model_id = os.model_id").fetchall())
        self.assertAlmostEqual(rows[20], 0.8)        # composite scored correctly
        self.assertIn(10, rows)                       # child pulled in + scored
        self.assertAlmostEqual(rows[10], 0.8)

    def test_debug_surfaces_model_variable(self):
        report = self.eng.debug('123456789', 2023, 20)
        self.assertEqual(report['model_kind'], 'composite')
        var = report['factors'][0]['variables'][0]
        self.assertEqual(var['kind'], 'model')
        self.assertEqual(var['references'], 10)
        self.assertAlmostEqual(var['value'], 0.8)


class TestBrokenDependencyConsistency(unittest.TestCase):
    """A composite with an unresolvable child (missing/factorless/manual) must
    behave identically in calculate() and the batch path — both degrade the
    broken child to a 0 contribution rather than one raising and one persisting 0.
    (Registration blocks creating these; this guards direct-DB edits.)"""

    def setUp(self):
        self.db = OpenReturnDB(path=':memory:')
        _add_model(self.db, 10, [('PE', 1.0, 'ratio', ['prog', 'total_exp'], 'higher', 0.0, 1.0)])
        # Composite over a real child (v10 → 0.8) and a NONEXISTENT child (v999).
        _add_model(self.db, 20, [
            ('Real', 0.5, 'sum', ['model:10'], 'higher', 0.0, 1.0),
            ('Broken', 0.5, 'sum', ['model:999'], 'higher', 0.0, 1.0),
        ], kind='composite')
        _add_filing(self.db, values={'prog': 800, 'total_exp': 1000})
        self.eng = ScoringEngine(self.db)

    def tearDown(self):
        self.db.close()

    def test_calculate_does_not_raise_and_matches_batch(self):
        # Broken half contributes 0; real half = 0.5 * 0.8 = 0.4.
        self.db.cursor.execute("DELETE FROM organization_score")
        self.db.connection.commit()
        calc = self.eng.calculate('123456789', 2023, 20)['total_score']
        self.assertAlmostEqual(calc, 0.4)

        self.db.cursor.execute("DELETE FROM organization_score")
        self.db.connection.commit()
        self.eng.rebuild()
        row = self.db.cursor.execute(
            "SELECT os.total_score FROM organization_score os "
            "JOIN score_model sm ON sm.model_id = os.model_id WHERE sm.version = 20"
        ).fetchone()
        self.assertAlmostEqual(row[0], calc)


class TestEngineOrderingHelpers(unittest.TestCase):

    def setUp(self):
        self.eng = ScoringEngine(db=None)

    def test_model_refs_extracts_versions(self):
        factors = [{'inputs': json.dumps(['model:10', 'factor:x', '0.5'])},
                   {'inputs': json.dumps(['model:11', 'model:10'])}]
        self.assertEqual(self.eng._model_refs(factors), {10, 11})

    def test_order_versions_topological(self):
        prepared = {
            30: {'deps': {20}}, 20: {'deps': {10, 11}}, 10: {'deps': set()},
            11: {'deps': set()},
        }
        order = self.eng._order_versions(prepared)
        self.assertLess(order.index(10), order.index(20))
        self.assertLess(order.index(11), order.index(20))
        self.assertLess(order.index(20), order.index(30))

    def test_order_versions_detects_cycle(self):
        prepared = {1: {'deps': {2}}, 2: {'deps': {1}}}
        with self.assertRaises(ValueError):
            self.eng._order_versions(prepared)

    def test_order_versions_ignores_absent_deps(self):
        # A dep on a version not in `prepared` (manual/filtered) is skipped, no error.
        prepared = {20: {'deps': {99}}}
        self.assertEqual(self.eng._order_versions(prepared), [20])


# ── cmd_register: cross-model reference checks ─────────────────────────────────

class TestRegisterCrossModel(unittest.TestCase):

    def setUp(self):
        self.tmp = tempfile.mkdtemp()
        self.dbpath = os.path.join(self.tmp, 'reg.db')
        OpenReturnDB(path=self.dbpath).close()  # seed schema

    def _write(self, body):
        path = os.path.join(self.tmp, 'm.toml')
        with open(path, 'w') as fh:
            fh.write(body)
        return path

    def _register(self, body):
        args = types.SimpleNamespace(file=self._write(body), db=self.dbpath,
                                     dry_run=False, skip_existing=False)
        return models_cli.cmd_register(args)

    def _register_base(self, version=10, kind='model', mode='computed'):
        extra = f'mode = "{mode}"\n' if mode != 'computed' else ''
        if mode == 'manual':
            factor = ('[[factor]]\nname="A"\nweight=1.0\nscale="percent"\n')
        else:
            factor = ('[[factor]]\nname="A"\nweight=1.0\nformula_type="ratio"\n'
                      'inputs=["prog","total_exp"]\ndirection="higher"\n'
                      'benchmark_lo=0.0\nbenchmark_hi=1.0\n')
        self._register(f'[model]\nversion={version}\nkind="{kind}"\n{extra}\n{factor}')

    def _composite_referencing(self, ref, version=20, kind='composite'):
        return (f'[model]\nversion={version}\nkind="{kind}"\n\n'
                f'[[factor]]\nname="C"\nweight=1.0\nformula_type="sum"\n'
                f'inputs=["model:{ref}"]\ndirection="higher"\n'
                f'benchmark_lo=0.0\nbenchmark_hi=1.0\n')

    def test_composite_missing_child_fails(self):
        with self.assertRaises(SystemExit):
            self._register(self._composite_referencing(999))

    def test_composite_referencing_manual_fails(self):
        self._register_base(version=10, kind='model', mode='manual')
        with self.assertRaises(SystemExit):
            self._register(self._composite_referencing(10))

    def test_super_composite_referencing_base_model_fails(self):
        # super_composite may reference composites only, not base models.
        self._register_base(version=10, kind='model')
        with self.assertRaises(SystemExit):
            self._register(self._composite_referencing(10, version=30, kind='super_composite'))

    def test_composite_referencing_factorless_child_fails(self):
        # Insert a registered-but-factorless model directly (validate_toml blocks
        # registering one normally), then a composite referencing it must be rejected.
        db = OpenReturnDB(path=self.dbpath)
        db.cursor.execute(
            "INSERT INTO score_model (version, model_type, scoring_mode, model_kind) "
            "VALUES (10, 'financial', 'computed', 'model')")
        db.connection.commit()
        db.close()
        with self.assertRaises(SystemExit):
            self._register(self._composite_referencing(10))

    def test_valid_chain_registers_and_persists_kind(self):
        self._register_base(version=10, kind='model')
        self._register(self._composite_referencing(10, version=20, kind='composite'))
        self._register(self._composite_referencing(20, version=30, kind='super_composite'))
        db = OpenReturnDB(path=self.dbpath)
        try:
            self.assertEqual(db.scores.get_model(20)['model_kind'], 'composite')
            self.assertEqual(db.scores.get_model(30)['model_kind'], 'super_composite')
        finally:
            db.close()


# ── router ─────────────────────────────────────────────────────────────────────

class TestKindRoutes(unittest.TestCase):

    def _headers(self):
        h = MagicMock()
        h.get.return_value = ""
        return h

    def test_kinds_route(self):
        db = MagicMock()
        db.scores.list_model_kinds.return_value = [
            {'code': 'model', 'name': 'Model', 'description': 'x'}]
        router = ScoreRouter(db=db)
        out = router.routes['GET']['/scores/kinds'](query_params={}, body=None, headers=self._headers())
        self.assertEqual(out['kinds'][0]['code'], 'model')

    def test_factors_route_includes_kind(self):
        db = MagicMock()
        db.scores.get_factors.return_value = []
        db.scores.get_model.return_value = {
            'model_type': 'financial', 'scoring_mode': 'computed', 'model_kind': 'composite'}
        router = ScoreRouter(db=db)
        out = router.routes['GET']['/scores/factors'](
            query_params={'version': ['20']}, body=None, headers=self._headers())
        self.assertEqual(out['model_kind'], 'composite')


# ── bundled template catalog (src/templates/*.toml) ─────────────────────────────

import templates as templates_mod


class TestShippedModelTomls(unittest.TestCase):
    """The MinistryWatch-derived templates in the catalog must validate cleanly and
    form a coherent base → composite → super_composite hierarchy."""

    def setUp(self):
        self.models = {}
        for code in templates_mod.template_codes():
            data = templates_mod.get_template(code)
            self.models[data['model']['version']] = (code, data)

    def _refs(self, data):
        out = set()
        for factor in data['factor']:
            for inp in factor.get('inputs', []):
                if isinstance(inp, str) and inp.startswith('model:'):
                    out.add(int(inp[len('model:'):]))
        return out

    def test_all_validate(self):
        self.assertTrue(self.models, "expected templates in the catalog")
        for version, (fn, data) in self.models.items():
            errs = _errors(models_cli.validate_toml(data))
            self.assertEqual(errs, [], f"{fn}: {errs}")

    def test_hierarchy_references_resolve_to_right_kind(self):
        kinds = {v: data['model'].get('kind', 'model') for v, (_, data) in self.models.items()}
        expect = {'composite': 'model', 'super_composite': 'composite'}
        for version, (fn, data) in self.models.items():
            kind = kinds[version]
            for ref in self._refs(data):
                self.assertIn(ref, kinds, f"{fn} references missing model v{ref}")
                self.assertEqual(kinds[ref], expect[kind],
                                 f"{fn} ({kind}) should reference a {expect[kind]}, "
                                 f"but v{ref} is a {kinds[ref]}")

    def test_contains_all_three_kinds(self):
        kinds = {data['model'].get('kind', 'model') for _, data in self.models.values()}
        self.assertEqual(kinds, {'model', 'composite', 'super_composite'})


if __name__ == '__main__':
    unittest.main()
