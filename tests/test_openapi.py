"""Tests for the OpenAPI spec (src/openapi.py) and the DocsRouter that serves it.

The coverage test is the anti-drift guard: it asserts the spec documents exactly
the routes the app registers — no more, no less."""

import contextlib
import io
import json
import os
import sys
import tempfile
import unittest
from unittest.mock import MagicMock, patch

_SRC = os.path.join(os.path.dirname(__file__), '..', 'src')
sys.path.insert(0, _SRC)

import openapi
from router.Upload import UploadRouter
from router.Org import OrgRouter
from router.Filing import FilingRouter
from router.Score import ScoreRouter
from router.Docs import DocsRouter


class TestSpecStructure(unittest.TestCase):

    def setUp(self):
        self.spec = openapi.build_spec(base_url="http://localhost:8080")

    def test_openapi_version(self):
        self.assertEqual(self.spec["openapi"], "3.1.0")

    def test_info(self):
        info = self.spec["info"]
        self.assertEqual(info["title"], "OpenReturn API")
        self.assertIn("version", info)
        self.assertIn("description", info)

    def test_server_base_url(self):
        self.assertEqual(self.spec["servers"][0]["url"], "http://localhost:8080")

    def test_security_schemes(self):
        schemes = self.spec["components"]["securitySchemes"]
        self.assertIn("bearerAuth", schemes)
        self.assertIn("apiKeyAuth", schemes)

    def test_every_operation_has_responses(self):
        for path, ops in self.spec["paths"].items():
            for method, op in ops.items():
                self.assertTrue(op.get("responses"), f"{method} {path} missing responses")

    def test_is_json_serializable(self):
        json.dumps(self.spec)  # must not raise

    def test_meta_routes_are_public(self):
        # discovery routes override the global security with []
        self.assertEqual(self.spec["paths"]["/openapi.json"]["get"]["security"], [])
        self.assertEqual(self.spec["paths"]["/docs"]["get"]["security"], [])

    def test_post_and_get_on_shared_factor_path(self):
        # /scores/factors is both a GET (list) and POST (store)
        self.assertIn("get", self.spec["paths"]["/scores/factors"])
        self.assertIn("post", self.spec["paths"]["/scores/factors"])

    def test_grade_documented(self):
        body = self.spec["paths"]["/scores/grade"]["post"]["requestBody"]
        props = body["content"]["application/json"]["schema"]["properties"]
        self.assertEqual(set(props) & {"score_id", "factor_id", "value", "comment"},
                         {"score_id", "factor_id", "value", "comment"})


class TestSpecCoverage(unittest.TestCase):
    """The spec must document exactly the registered routes (anti-drift)."""

    def _registered_routes(self):
        db = MagicMock()
        routers = [UploadRouter(db=db), OrgRouter(db=db), FilingRouter(db=db),
                   ScoreRouter(db=db), DocsRouter()]
        routes = set()
        for r in routers:
            for method, paths in r.routes.items():
                for path in paths:
                    routes.add((method, path))
        return routes

    def _spec_routes(self, spec):
        return {(m.upper(), path) for path, ops in spec["paths"].items() for m in ops}

    def test_spec_matches_registered_routes(self):
        spec = openapi.build_spec()
        registered = self._registered_routes()
        documented = self._spec_routes(spec)
        self.assertEqual(documented, registered,
                         f"\nmissing from spec: {sorted(registered - documented)}"
                         f"\nextra in spec: {sorted(documented - registered)}")


class TestDocsRouter(unittest.TestCase):

    def setUp(self):
        self.router = DocsRouter(base_url="http://localhost:8080")

    def test_openapi_json_route(self):
        body, ct = self.router.routes['GET']['/openapi.json'](
            query_params={}, body=None, headers=None)
        self.assertEqual(ct, 'application/json')
        self.assertEqual(json.loads(body)["openapi"], "3.1.0")

    def test_docs_html_route(self):
        html, ct = self.router.routes['GET']['/docs'](
            query_params={}, body=None, headers=None)
        self.assertTrue(ct.startswith('text/html'))
        self.assertIn('redoc', html.lower())
        self.assertIn('/openapi.json', html)

    def test_routes_are_public(self):
        self.assertIs(self.router.routes['GET']['/openapi.json']._secured, False)
        self.assertIs(self.router.routes['GET']['/docs']._secured, False)


class TestCmdOpenapi(unittest.TestCase):

    def test_prints_spec(self):
        buf = io.StringIO()
        with contextlib.redirect_stdout(buf):
            rc = openapi.cmd_openapi(MagicMock(output=None, base_url=None, compact=False))
        self.assertEqual(rc, 0)
        self.assertEqual(json.loads(buf.getvalue())["openapi"], "3.1.0")

    def test_writes_file(self):
        with tempfile.TemporaryDirectory() as td:
            out = os.path.join(td, 'openapi.json')
            buf = io.StringIO()
            with contextlib.redirect_stdout(buf):
                openapi.cmd_openapi(MagicMock(output=out, base_url=None, compact=False))
            self.assertEqual(json.load(open(out))["openapi"], "3.1.0")

    def test_compact_is_single_line(self):
        buf = io.StringIO()
        with contextlib.redirect_stdout(buf):
            openapi.cmd_openapi(MagicMock(output=None, base_url=None, compact=True))
        self.assertEqual(len(buf.getvalue().strip().splitlines()), 1)


class TestCliDispatch(unittest.TestCase):

    def test_openapi_dispatches(self):
        import cli
        with patch('sys.argv', ['openreturn', 'openapi', '--compact']), \
             patch('cli._load_env'), patch('openapi.cmd_openapi', return_value=0) as m:
            rc = cli.main()
        self.assertEqual(rc, 0)
        m.assert_called_once()


if __name__ == '__main__':  # pragma: no cover
    unittest.main()
