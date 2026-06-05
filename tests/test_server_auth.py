import sys
import os
import json
import threading
import unittest
import urllib.request
import urllib.error
from http.server import HTTPServer

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

from router import Router
from server import Server


def _make_validator(valid_keys: set[str]):
    return lambda key: key in valid_keys


class _LiveServer:
    """Spin up a real HTTPServer on an ephemeral port for integration tests."""

    def __init__(self, key_validator=None):
        self._key_validator = key_validator
        self.url = None
        self._httpd = None
        self._thread = None

    def __enter__(self):
        router = Router(prefix='')

        @router.get('/secured', secured=True)
        def secured_handler(**_):
            return {"ok": True}

        @router.get('/open', secured=False)
        def open_handler(**_):
            return {"ok": True}

        srv = Server(host='127.0.0.1', port=0, key_validator=self._key_validator)
        srv.include_router(router)

        handler_class = srv._create_handler()
        self._httpd = HTTPServer(('127.0.0.1', 0), handler_class)
        port = self._httpd.server_address[1]
        self.url = f'http://127.0.0.1:{port}'

        self._thread = threading.Thread(target=self._httpd.serve_forever, daemon=True)
        self._thread.start()
        return self

    def __exit__(self, *_):
        if self._httpd:
            self._httpd.shutdown()


def _get(url: str, headers: dict | None = None):
    req = urllib.request.Request(url, headers=headers or {})
    try:
        with urllib.request.urlopen(req) as resp:
            return resp.status, resp.headers, resp.read().decode()
    except urllib.error.HTTPError as e:
        return e.code, e.headers, e.read().decode()


class TestServerAuthSecuredRoute(unittest.TestCase):
    VALID_KEY = "test-valid-key-abc123"

    def setUp(self):
        self._ctx = _LiveServer(key_validator=_make_validator({self.VALID_KEY}))
        self._server = self._ctx.__enter__()

    def tearDown(self):
        self._ctx.__exit__(None, None, None)

    def test_valid_bearer_token_returns_200(self):
        status, _, _ = _get(
            f"{self._server.url}/secured",
            {"Authorization": f"Bearer {self.VALID_KEY}"}
        )
        self.assertEqual(status, 200)

    def test_invalid_bearer_token_returns_401(self):
        status, _, _ = _get(
            f"{self._server.url}/secured",
            {"Authorization": "Bearer wrong-key"}
        )
        self.assertEqual(status, 401)

    def test_no_key_returns_401(self):
        status, _, _ = _get(f"{self._server.url}/secured")
        self.assertEqual(status, 401)

    def test_valid_x_api_key_header_returns_200(self):
        status, _, _ = _get(
            f"{self._server.url}/secured",
            {"X-API-Key": self.VALID_KEY}
        )
        self.assertEqual(status, 200)

    def test_invalid_x_api_key_returns_401(self):
        status, _, _ = _get(
            f"{self._server.url}/secured",
            {"X-API-Key": "not-valid"}
        )
        self.assertEqual(status, 401)

    def test_401_body_has_error_key(self):
        status, _, body = _get(f"{self._server.url}/secured")
        self.assertEqual(status, 401)
        data = json.loads(body)
        self.assertIn("error", data)

    def test_401_has_www_authenticate_header(self):
        _, headers, _ = _get(f"{self._server.url}/secured")
        self.assertIsNotNone(headers.get("WWW-Authenticate"))

    def test_401_www_authenticate_is_bearer(self):
        _, headers, _ = _get(f"{self._server.url}/secured")
        self.assertIn("Bearer", headers.get("WWW-Authenticate", ""))


class TestServerAuthOpenRoute(unittest.TestCase):
    VALID_KEY = "test-valid-key-abc123"

    def setUp(self):
        self._ctx = _LiveServer(key_validator=_make_validator({self.VALID_KEY}))
        self._server = self._ctx.__enter__()

    def tearDown(self):
        self._ctx.__exit__(None, None, None)

    def test_open_route_no_key_returns_200_when_validator_set(self):
        status, _, _ = _get(f"{self._server.url}/open")
        self.assertEqual(status, 200)

    def test_open_route_with_invalid_key_still_returns_200(self):
        status, _, _ = _get(
            f"{self._server.url}/open",
            {"Authorization": "Bearer wrong-key"}
        )
        self.assertEqual(status, 200)


class TestServerAuthNoValidator(unittest.TestCase):
    def setUp(self):
        self._ctx = _LiveServer(key_validator=None)
        self._server = self._ctx.__enter__()

    def tearDown(self):
        self._ctx.__exit__(None, None, None)

    def test_secured_route_no_validator_returns_200(self):
        status, _, _ = _get(f"{self._server.url}/secured")
        self.assertEqual(status, 200)

    def test_open_route_no_validator_returns_200(self):
        status, _, _ = _get(f"{self._server.url}/open")
        self.assertEqual(status, 200)


class TestServerAuthNotFound(unittest.TestCase):
    def setUp(self):
        self._ctx = _LiveServer(key_validator=_make_validator({"any-key"}))
        self._server = self._ctx.__enter__()

    def tearDown(self):
        self._ctx.__exit__(None, None, None)

    def test_unknown_path_returns_404(self):
        status, _, _ = _get(f"{self._server.url}/nonexistent")
        self.assertEqual(status, 404)


if __name__ == "__main__":
    unittest.main()
