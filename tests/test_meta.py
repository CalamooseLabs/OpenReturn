"""Tests for the public meta routes (served OpenAPI spec, health, version) — the
endpoints a frontend hits before it has a token."""

import os
import sys
import unittest
from unittest.mock import patch

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

import router.Meta.meta as meta_mod
from router.Meta import MetaRouter


class _H:
    def __init__(self, **hdrs):
        self._hdrs = hdrs

    def get(self, key, default=None):
        return self._hdrs.get(key, default)


def _call(router, path, headers=None):
    return router.routes['GET'][path](query_params={}, body=None, headers=headers or _H())


class TestMetaRouter(unittest.TestCase):
    def setUp(self):
        self.router = MetaRouter()

    def test_routes_are_public(self):
        for path in ('/openapi.json', '/health', '/version'):
            fn = self.router.routes['GET'][path]
            self.assertFalse(getattr(fn, '_secured', False), path)
            self.assertIsNone(getattr(fn, '_permission', None), path)

    def test_openapi_json_is_the_spec(self):
        spec = _call(self.router, '/openapi.json')
        self.assertEqual(spec['openapi'], '3.1.0')
        self.assertIn('/follows', spec['paths'])

    def test_openapi_base_url_follows_request_host(self):
        spec = _call(self.router, '/openapi.json',
                     _H(Host='api.example.com', **{'X-Forwarded-Proto': 'https'}))
        self.assertEqual(spec['servers'][0]['url'], 'https://api.example.com')

    def test_health(self):
        out = _call(self.router, '/health')
        self.assertEqual(out['status'], 'ok')
        self.assertIn('version', out)

    def test_version(self):
        out = _call(self.router, '/version')
        self.assertEqual(out['name'], 'openreturn')
        self.assertIn('version', out)


class TestVersionHelper(unittest.TestCase):
    def test_installed_version_is_normalized(self):
        with patch.object(meta_mod, '_pkg_version', return_value='0.1.0rc4'):
            self.assertEqual(meta_mod._version(), '0.1.0-rc.4')

    def test_missing_package_is_dev(self):
        with patch.object(meta_mod, '_pkg_version',
                          side_effect=meta_mod.PackageNotFoundError):
            self.assertEqual(meta_mod._version(), 'dev')


if __name__ == '__main__':
    unittest.main()
