"""Tests for the model-template catalog: the loader, the read-only TemplatesRouter,
the `openreturn templates` CLI, and that every bundled template validates + round-
trips into a real model via register_model."""

import io
import os
import sys
import unittest
from contextlib import redirect_stdout
from types import SimpleNamespace
from unittest.mock import MagicMock, patch

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

import templates as catalog
import models as models_cli
from auth import Principal
from database import OpenReturnDB
from router.Templates import TemplatesRouter


class TestCatalogLoader(unittest.TestCase):
    def test_codes_and_summaries(self):
        codes = catalog.template_codes()
        self.assertIn('20-financial-composite', codes)
        summaries = {t['code']: t for t in catalog.list_templates()}
        self.assertEqual(set(summaries), set(codes))
        comp = summaries['20-financial-composite']
        self.assertEqual(comp['kind'], 'composite')
        self.assertEqual(comp['version'], '20')
        self.assertGreater(comp['factor_count'], 0)

    def test_get_template_and_toml(self):
        d = catalog.get_template('10-operating-ratios')
        self.assertEqual(d['model']['version'], '10')
        self.assertIn('factor', d)
        self.assertTrue(catalog.get_template_toml('10-operating-ratios').startswith('#'))

    def test_unknown_and_path_escape(self):
        self.assertIsNone(catalog.get_template('nope'))
        self.assertIsNone(catalog.get_template('../../etc/passwd'))
        self.assertIsNone(catalog.get_template_toml('nope'))

    def test_every_template_validates(self):
        for code in catalog.template_codes():
            errs = [i for i in models_cli.validate_toml(catalog.get_template(code))
                    if i.startswith('ERROR:')]
            self.assertEqual(errs, [], f"{code}: {errs}")


class TestTemplatesCLI(unittest.TestCase):
    def test_list(self):
        out = io.StringIO()
        with redirect_stdout(out):
            rc = catalog.cmd_list(SimpleNamespace())
        self.assertEqual(rc, 0)
        self.assertIn('10-operating-ratios', out.getvalue())

    def test_show(self):
        out = io.StringIO()
        with redirect_stdout(out):
            rc = catalog.cmd_show(SimpleNamespace(code='30-overall-score'))
        self.assertEqual(rc, 0)
        self.assertIn('[model]', out.getvalue())

    def test_show_unknown(self):
        self.assertEqual(catalog.cmd_show(SimpleNamespace(code='nope')), 1)

    def test_list_empty_catalog(self):
        out = io.StringIO()
        with redirect_stdout(out), patch.object(catalog, 'list_templates', return_value=[]):
            rc = catalog.cmd_list(SimpleNamespace())
        self.assertEqual(rc, 0)
        self.assertIn('No templates', out.getvalue())


class TestTemplatesRouter(unittest.TestCase):
    def setUp(self):
        self.db = OpenReturnDB(path=':memory:')
        self.router = TemplatesRouter(db=self.db)

    def tearDown(self):
        self.db.close()

    def _call(self, path, **qp):
        h = MagicMock(); h.get.return_value = ""
        return self.router.routes['GET'][path](
            query_params={k: [v] for k, v in qp.items()}, body=None, headers=h)

    def test_permissions(self):
        self.assertEqual(self.router.routes['GET']['/templates']._permission, 'score:read')
        self.assertEqual(self.router.routes['GET']['/templates/detail']._permission, 'score:read')

    def test_list_and_detail(self):
        codes = {t['code'] for t in self._call('/templates')['templates']}
        self.assertIn('20-financial-composite', codes)
        det = self._call('/templates/detail', code='20-financial-composite')
        self.assertEqual(det['definition']['model']['version'], '20')

    def test_detail_requires_and_validates_code(self):
        self.assertIn('error', self._call('/templates/detail'))
        self.assertIn('error', self._call('/templates/detail', code='nope'))


class TestTemplateRoundTrip(unittest.TestCase):
    def test_full_stack_registers_from_templates(self):
        db = OpenReturnDB(path=':memory:')
        actor = Principal(kind='user', actor_id=1, label='root',
                          permissions=frozenset(), user_id=1)
        try:
            for code in catalog.template_codes():   # base→composite→super (sorted)
                res = models_cli.register_model(db, catalog.get_template(code), actor=actor)
                self.assertIn('version', res)
            versions = {m['version'] for m in db.scores.list_models()}
            self.assertTrue({'10', '11', '12', '13', '20', '30'} <= versions)
        finally:
            db.close()


if __name__ == '__main__':
    unittest.main()
