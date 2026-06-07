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
    return lambda key: -1 if key in valid_keys else None


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


class TestServerRateLimit(unittest.TestCase):
    """Rate limiting: validator returns rate_limit int, server enforces it."""

    VALID_KEY = "rate-test-key"

    def _make_server(self, rate_limit: int):
        """Build a _LiveServer whose validator grants VALID_KEY with the given rate limit."""
        def validator(key):
            if key == self.VALID_KEY:
                return rate_limit
            return None
        return _LiveServer(key_validator=validator)

    def test_unlimited_key_always_succeeds(self):
        ctx = self._make_server(-1)
        srv = ctx.__enter__()
        try:
            for _ in range(5):
                status, _, _ = _get(f"{srv.url}/secured",
                                    {'Authorization': f'Bearer {self.VALID_KEY}'})
                self.assertEqual(status, 200)
        finally:
            ctx.__exit__(None, None, None)

    def test_rate_limited_key_returns_429_after_limit(self):
        ctx = self._make_server(2)  # 2 requests per minute
        srv = ctx.__enter__()
        try:
            # First two requests should succeed
            status1, _, _ = _get(f"{srv.url}/secured",
                                  {'Authorization': f'Bearer {self.VALID_KEY}'})
            status2, _, _ = _get(f"{srv.url}/secured",
                                  {'Authorization': f'Bearer {self.VALID_KEY}'})
            # Third should be rate limited
            status3, _, _ = _get(f"{srv.url}/secured",
                                  {'Authorization': f'Bearer {self.VALID_KEY}'})
        finally:
            ctx.__exit__(None, None, None)
        self.assertEqual(status1, 200)
        self.assertEqual(status2, 200)
        self.assertEqual(status3, 429)

    def test_rate_limit_exceeded_returns_retry_after_header(self):
        ctx = self._make_server(1)
        srv = ctx.__enter__()
        try:
            _get(f"{srv.url}/secured", {'Authorization': f'Bearer {self.VALID_KEY}'})
            _, headers, _ = _get(f"{srv.url}/secured",
                                  {'Authorization': f'Bearer {self.VALID_KEY}'})
        finally:
            ctx.__exit__(None, None, None)
        self.assertIn('Retry-After', headers)

    def test_rate_limit_exceeded_body_has_error(self):
        ctx = self._make_server(1)
        srv = ctx.__enter__()
        try:
            _get(f"{srv.url}/secured", {'Authorization': f'Bearer {self.VALID_KEY}'})
            _, _, body = _get(f"{srv.url}/secured",
                               {'Authorization': f'Bearer {self.VALID_KEY}'})
        finally:
            ctx.__exit__(None, None, None)
        import json
        data = json.loads(body)
        self.assertIn("error", data)

    def test_zero_rate_limit_blocks_all_requests(self):
        ctx = self._make_server(0)
        srv = ctx.__enter__()
        try:
            status, _, _ = _get(f"{srv.url}/secured",
                                  {'Authorization': f'Bearer {self.VALID_KEY}'})
        finally:
            ctx.__exit__(None, None, None)
        self.assertEqual(status, 429)

    def test_open_route_not_rate_limited(self):
        ctx = self._make_server(0)  # rate limit = 0 but route is open
        srv = ctx.__enter__()
        try:
            status, _, _ = _get(f"{srv.url}/open")
        finally:
            ctx.__exit__(None, None, None)
        self.assertEqual(status, 200)

    def test_window_reset_allows_request_after_expiry(self):
        """Lines 110-111: when window expires the counter resets."""
        import threading
        from http.server import HTTPServer
        from server import server as server_module

        srv_obj = Server(host='127.0.0.1', port=0,
                         key_validator=lambda k: 1 if k == self.VALID_KEY else None)
        router = Router(prefix='')

        @router.get('/secured', secured=True)
        def handler(**_):
            return {"ok": True}

        @router.get('/open', secured=False)
        def open_handler(**_):
            return {"ok": True}

        srv_obj.include_router(router)
        httpd = HTTPServer(('127.0.0.1', 0), srv_obj._create_handler())
        port = httpd.server_address[1]
        base_url = f'http://127.0.0.1:{port}'
        t = threading.Thread(target=httpd.serve_forever, daemon=True)
        t.start()
        try:
            # Consume the one allowed request
            _get(f"{base_url}/secured",
                 {'Authorization': f'Bearer {self.VALID_KEY}'})
            # Force window expiry by backdating window_start on the Server object
            with srv_obj._rate_lock:
                if self.VALID_KEY in srv_obj._rate_counters:
                    srv_obj._rate_counters[self.VALID_KEY][1] -= server_module._RATE_WINDOW + 1
            # Window has expired → counter resets → request should succeed again
            status, _, _ = _get(f"{base_url}/secured",
                                 {'Authorization': f'Bearer {self.VALID_KEY}'})
        finally:
            httpd.shutdown()
        self.assertEqual(status, 200)


class TestServerDebugRateLimit(unittest.TestCase):
    """Lines 177-178: debug=True branch of the 429 path."""

    VALID_KEY = "debug-rate-key"

    def setUp(self):
        def validator(key):
            return 1 if key == self.VALID_KEY else None

        self._srv = Server(host='127.0.0.1', port=0, debug=True, key_validator=validator)
        router = Router(prefix='')

        @router.get('/locked', secured=True)
        def locked(**_):
            return {"ok": True}

        self._srv.include_router(router)
        from http.server import HTTPServer
        handler_class = self._srv._create_handler()
        import threading
        self._httpd = HTTPServer(('127.0.0.1', 0), handler_class)
        port = self._httpd.server_address[1]
        self._url = f'http://127.0.0.1:{port}'
        self._thread = threading.Thread(target=self._httpd.serve_forever, daemon=True)
        self._thread.start()

    def tearDown(self):
        self._httpd.shutdown()

    def test_debug_rate_limit_exceeded_returns_429(self):
        _get(f'{self._url}/locked', {'Authorization': f'Bearer {self.VALID_KEY}'})
        status, _, _ = _get(f'{self._url}/locked',
                             {'Authorization': f'Bearer {self.VALID_KEY}'})
        self.assertEqual(status, 429)


if __name__ == "__main__":
    unittest.main()
