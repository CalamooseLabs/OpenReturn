import sys
import os
import io
import json
import threading
import unittest
from unittest.mock import patch, MagicMock
import urllib.request
import urllib.error
from http.server import HTTPServer

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

from router import Router
from server import Server
import server.server as server_module


# ---------------------------------------------------------------------------
# Shared live-server helper (same pattern as test_server_auth.py)
# ---------------------------------------------------------------------------

class _LiveServer:
    """Spin up a real HTTPServer on an ephemeral port for integration tests."""

    def __init__(self, srv: Server):
        self._srv = srv
        self.url = None
        self._httpd = None
        self._thread = None

    def __enter__(self):
        handler_class = self._srv._create_handler()
        self._httpd = HTTPServer(('127.0.0.1', 0), handler_class)
        port = self._httpd.server_address[1]
        self.url = f'http://127.0.0.1:{port}'
        self._thread = threading.Thread(target=self._httpd.serve_forever, daemon=True)
        self._thread.start()
        return self

    def __exit__(self, *_):
        if self._httpd:
            self._httpd.shutdown()
            self._httpd.server_close()


def _get(url: str, headers: dict | None = None):
    req = urllib.request.Request(url, headers=headers or {})
    try:
        with urllib.request.urlopen(req) as resp:
            return resp.status, resp.headers, resp.read().decode()
    except urllib.error.HTTPError as e:
        return e.code, e.headers, e.read().decode()


def _post(url: str, data: bytes, content_type: str, headers: dict | None = None):
    req = urllib.request.Request(url, data=data, method='POST', headers=headers or {})
    req.add_header('Content-Type', content_type)
    req.add_header('Content-Length', str(len(data)))
    try:
        with urllib.request.urlopen(req) as resp:
            return resp.status, resp.headers, resp.read().decode()
    except urllib.error.HTTPError as e:
        return e.code, e.headers, e.read().decode()


# ---------------------------------------------------------------------------
# 1. Module-level helper functions
# ---------------------------------------------------------------------------

class TestHelperFunctions(unittest.TestCase):

    # _method_color
    def test_method_color_get_returns_green(self):
        color = server_module._method_color('GET')
        self.assertEqual(color, server_module._GREEN)

    def test_method_color_post_returns_yellow(self):
        color = server_module._method_color('POST')
        self.assertEqual(color, server_module._YELLOW)

    def test_method_color_unknown_returns_cyan(self):
        color = server_module._method_color('DELETE')
        self.assertEqual(color, server_module._CYAN)

    def test_method_color_patch_returns_cyan(self):
        color = server_module._method_color('PATCH')
        self.assertEqual(color, server_module._CYAN)

    # _status_color
    def test_status_color_2xx_returns_green(self):
        self.assertEqual(server_module._status_color(200), server_module._GREEN)

    def test_status_color_3xx_returns_cyan(self):
        self.assertEqual(server_module._status_color(301), server_module._CYAN)

    def test_status_color_4xx_returns_yellow(self):
        self.assertEqual(server_module._status_color(404), server_module._YELLOW)

    def test_status_color_5xx_returns_red(self):
        self.assertEqual(server_module._status_color(500), server_module._RED)

    def test_status_color_boundary_300_returns_cyan(self):
        self.assertEqual(server_module._status_color(300), server_module._CYAN)

    def test_status_color_boundary_400_returns_yellow(self):
        self.assertEqual(server_module._status_color(400), server_module._YELLOW)

    def test_status_color_boundary_500_returns_red(self):
        self.assertEqual(server_module._status_color(500), server_module._RED)

    # _debug_line
    def test_debug_line_prints_label_and_value(self):
        captured = io.StringIO()
        with patch('sys.stdout', captured):
            server_module._debug_line('my-label', 'my-value')
        output = captured.getvalue()
        self.assertIn('my-label', output)
        self.assertIn('my-value', output)

    def test_debug_line_default_value_empty(self):
        captured = io.StringIO()
        with patch('sys.stdout', captured):
            server_module._debug_line('label-only')
        output = captured.getvalue()
        self.assertIn('label-only', output)

    # _debug_sep
    def test_debug_sep_with_title_prints_title(self):
        captured = io.StringIO()
        with patch('sys.stdout', captured):
            server_module._debug_sep('my-section')
        output = captured.getvalue()
        self.assertIn('my-section', output)

    def test_debug_sep_no_title_prints_separator(self):
        captured = io.StringIO()
        with patch('sys.stdout', captured):
            server_module._debug_sep()
        # just verify it doesn't raise and produces some output
        output = captured.getvalue()
        self.assertGreater(len(output), 0)

    def test_debug_sep_empty_string_title_prints_separator(self):
        captured = io.StringIO()
        with patch('sys.stdout', captured):
            server_module._debug_sep('')
        output = captured.getvalue()
        self.assertGreater(len(output), 0)


# ---------------------------------------------------------------------------
# 2. Server.run() — mock HTTPServer to avoid blocking
# ---------------------------------------------------------------------------

class TestServerRun(unittest.TestCase):

    def _make_mock_httpd(self):
        instance = MagicMock()
        instance.serve_forever.side_effect = KeyboardInterrupt
        instance.server_address = ('127.0.0.1', 8080)
        return instance

    def test_run_completes_on_keyboard_interrupt(self):
        with patch('server.server.HTTPServer') as MockHTTP:
            MockHTTP.return_value = self._make_mock_httpd()
            srv = Server(host='127.0.0.1', port=0)
            # Should not raise
            srv.run()
        MockHTTP.assert_called_once()

    def test_run_calls_serve_forever(self):
        with patch('server.server.HTTPServer') as MockHTTP:
            instance = self._make_mock_httpd()
            MockHTTP.return_value = instance
            srv = Server(host='127.0.0.1', port=0)
            srv.run()
        instance.serve_forever.assert_called_once()

    def test_run_calls_server_close_in_finally(self):
        with patch('server.server.HTTPServer') as MockHTTP:
            instance = self._make_mock_httpd()
            MockHTTP.return_value = instance
            srv = Server(host='127.0.0.1', port=0)
            srv.run()
        instance.server_close.assert_called_once()

    def test_run_with_debug_true_prints_debug_tag(self):
        captured = io.StringIO()
        with patch('server.server.HTTPServer') as MockHTTP:
            MockHTTP.return_value = self._make_mock_httpd()
            srv = Server(host='127.0.0.1', port=0, debug=True)
            with patch('sys.stdout', captured):
                srv.run()
        output = captured.getvalue()
        self.assertIn('debug', output)

    def test_run_with_key_validator_prints_auth_tag(self):
        captured = io.StringIO()
        with patch('server.server.HTTPServer') as MockHTTP:
            MockHTTP.return_value = self._make_mock_httpd()
            srv = Server(host='127.0.0.1', port=0, key_validator=lambda k: -1)
            with patch('sys.stdout', captured):
                srv.run()
        output = captured.getvalue()
        self.assertIn('auth', output)

    def test_run_with_debug_and_key_validator(self):
        captured = io.StringIO()
        with patch('server.server.HTTPServer') as MockHTTP:
            MockHTTP.return_value = self._make_mock_httpd()
            srv = Server(host='127.0.0.1', port=0, debug=True, key_validator=lambda k: -1)
            with patch('sys.stdout', captured):
                srv.run()
        output = captured.getvalue()
        self.assertIn('debug', output)
        self.assertIn('auth', output)

    def test_run_version_dev_when_package_not_found(self):
        """PackageNotFoundError branch → _version = 'dev'."""
        captured = io.StringIO()
        with patch('server.server.HTTPServer') as MockHTTP:
            MockHTTP.return_value = self._make_mock_httpd()
            with patch('server.server.version', side_effect=server_module.PackageNotFoundError):
                srv = Server(host='127.0.0.1', port=0)
                with patch('sys.stdout', captured):
                    srv.run()
        output = captured.getvalue()
        self.assertIn('dev', output)

    def test_run_version_parsed_when_package_found(self):
        """version() returns a string → it appears in banner."""
        captured = io.StringIO()
        with patch('server.server.HTTPServer') as MockHTTP:
            MockHTTP.return_value = self._make_mock_httpd()
            with patch('server.server.version', return_value='1.2.3'):
                srv = Server(host='127.0.0.1', port=0)
                with patch('sys.stdout', captured):
                    srv.run()
        output = captured.getvalue()
        self.assertIn('1.2.3', output)


# ---------------------------------------------------------------------------
# 3. Server registration methods
# ---------------------------------------------------------------------------

class TestServerRegistration(unittest.TestCase):

    def test_get_registers_handler_in_get_routes(self):
        srv = Server()

        @srv.get('/foo')
        def handler(**_):
            return 'ok'

        self.assertIn('/foo', srv.routes['GET'])
        self.assertIs(srv.routes['GET']['/foo'], handler)

    def test_post_registers_handler_in_post_routes(self):
        srv = Server()

        @srv.post('/bar')
        def handler(**_):
            return 'ok'

        self.assertIn('/bar', srv.routes['POST'])
        self.assertIs(srv.routes['POST']['/bar'], handler)

    def test_route_registers_custom_method(self):
        srv = Server()
        # Add a method bucket first so route() can write to it
        srv.routes['PUT'] = {}

        @srv.route('/baz', 'PUT')
        def handler(**_):
            return 'ok'

        self.assertIn('/baz', srv.routes['PUT'])
        self.assertIs(srv.routes['PUT']['/baz'], handler)

    def test_route_default_method_is_get(self):
        srv = Server()

        @srv.route('/qux')
        def handler(**_):
            return 'ok'

        self.assertIn('/qux', srv.routes['GET'])

    def test_include_router_merges_routes(self):
        router = Router(prefix='/api')

        @router.get('/items')
        def list_items(**_):
            return []

        srv = Server()
        srv.include_router(router)
        self.assertIn('/api/items', srv.routes['GET'])

    def test_include_router_merges_post_routes(self):
        router = Router(prefix='/api')

        @router.post('/submit')
        def submit(**_):
            return {"submitted": True}

        srv = Server()
        srv.include_router(router)
        self.assertIn('/api/submit', srv.routes['POST'])

    def test_include_router_does_not_clear_existing_routes(self):
        srv = Server()

        @srv.get('/existing')
        def existing(**_):
            return 'existing'

        router = Router(prefix='')

        @router.get('/new')
        def new_handler(**_):
            return 'new'

        srv.include_router(router)
        self.assertIn('/existing', srv.routes['GET'])
        self.assertIn('/new', srv.routes['GET'])


# ---------------------------------------------------------------------------
# 4. Server._print_routes
# ---------------------------------------------------------------------------

class TestServerPrintRoutes(unittest.TestCase):

    def test_print_routes_outputs_registered_paths(self):
        srv = Server()

        @srv.get('/hello')
        def h(**_):
            return 'ok'

        @srv.post('/submit')
        def p(**_):
            return 'ok'

        captured = io.StringIO()
        with patch('sys.stdout', captured):
            srv._print_routes()
        output = captured.getvalue()
        self.assertIn('/hello', output)
        self.assertIn('/submit', output)
        self.assertIn('GET', output)
        self.assertIn('POST', output)

    def test_print_routes_with_no_routes_does_not_raise(self):
        srv = Server()
        captured = io.StringIO()
        with patch('sys.stdout', captured):
            srv._print_routes()
        output = captured.getvalue()
        self.assertIn('Available routes', output)


# ---------------------------------------------------------------------------
# 5. Debug mode — request logging paths
# ---------------------------------------------------------------------------

class TestServerDebugMode(unittest.TestCase):

    def setUp(self):
        self._srv = Server(host='127.0.0.1', port=0, debug=True)

        @self._srv.get('/ping')
        def ping(**_):
            return {"pong": True}

        @self._srv.post('/echo')
        def echo(body, **_):
            return {"received": body}

        @self._srv.get('/search')
        def search(query_params, **_):
            return {"q": query_params.get('q', [])}

        self._ctx = _LiveServer(self._srv)
        self._live = self._ctx.__enter__()

    def tearDown(self):
        self._ctx.__exit__(None, None, None)

    def test_debug_get_returns_200(self):
        status, _, _ = _get(f'{self._live.url}/ping')
        self.assertEqual(status, 200)

    def test_debug_get_response_is_json(self):
        _, _, body = _get(f'{self._live.url}/ping')
        data = json.loads(body)
        self.assertIn('pong', data)

    def test_debug_get_with_query_params_returns_200(self):
        status, _, _ = _get(f'{self._live.url}/search?q=test')
        self.assertEqual(status, 200)

    def test_debug_post_json_returns_200(self):
        payload = json.dumps({"hello": "world"}).encode()
        status, _, _ = _post(f'{self._live.url}/echo', payload, 'application/json')
        self.assertEqual(status, 200)

    def test_debug_404_returns_404(self):
        status, _, _ = _get(f'{self._live.url}/nonexistent')
        self.assertEqual(status, 404)

    def test_debug_post_json_body_echoed(self):
        payload = json.dumps({"key": "val"}).encode()
        _, _, body = _post(f'{self._live.url}/echo', payload, 'application/json')
        data = json.loads(body)
        self.assertEqual(data['received'], {"key": "val"})


# ---------------------------------------------------------------------------
# 6. POST body handling
# ---------------------------------------------------------------------------

class TestServerPostHandling(unittest.TestCase):

    def setUp(self):
        self._srv = Server(host='127.0.0.1', port=0)
        self._received_bodies = []
        received = self._received_bodies

        @self._srv.post('/collect')
        def collect(body, **_):
            received.append(body)
            return {"ok": True}

        self._ctx = _LiveServer(self._srv)
        self._live = self._ctx.__enter__()

    def tearDown(self):
        self._ctx.__exit__(None, None, None)

    def test_post_json_body_parsed_as_dict(self):
        payload = json.dumps({"name": "Alice"}).encode()
        status, _, _ = _post(f'{self._live.url}/collect', payload, 'application/json')
        self.assertEqual(status, 200)
        self.assertEqual(self._received_bodies[-1], {"name": "Alice"})

    def test_post_text_plain_body_is_string(self):
        payload = b'plain text content'
        status, _, _ = _post(f'{self._live.url}/collect', payload, 'text/plain')
        self.assertEqual(status, 200)
        self.assertIsInstance(self._received_bodies[-1], str)
        self.assertEqual(self._received_bodies[-1], 'plain text content')

    def test_post_multipart_body_is_bytes(self):
        boundary = b'boundary123'
        payload = (
            b'--boundary123\r\n'
            b'Content-Disposition: form-data; name="field"\r\n\r\n'
            b'value\r\n'
            b'--boundary123--\r\n'
        )
        status, _, _ = _post(
            f'{self._live.url}/collect',
            payload,
            'multipart/form-data; boundary=boundary123'
        )
        self.assertEqual(status, 200)
        self.assertIsInstance(self._received_bodies[-1], bytes)

    def test_post_empty_body_is_empty_string(self):
        status, _, _ = _post(f'{self._live.url}/collect', b'', 'text/plain')
        self.assertEqual(status, 200)

    def test_post_returns_json_response(self):
        payload = json.dumps({}).encode()
        _, headers, body = _post(f'{self._live.url}/collect', payload, 'application/json')
        data = json.loads(body)
        self.assertIn('ok', data)


# ---------------------------------------------------------------------------
# 7. 500 errors — handler raises an exception
# ---------------------------------------------------------------------------

class TestServer500Error(unittest.TestCase):

    def setUp(self):
        self._srv = Server(host='127.0.0.1', port=0)

        @self._srv.get('/boom')
        def boom(**_):
            raise RuntimeError("intentional failure")

        self._ctx = _LiveServer(self._srv)
        self._live = self._ctx.__enter__()

    def tearDown(self):
        self._ctx.__exit__(None, None, None)

    def test_handler_exception_returns_500(self):
        status, _, _ = _get(f'{self._live.url}/boom')
        self.assertEqual(status, 500)

    def test_handler_exception_body_mentions_error(self):
        _, _, body = _get(f'{self._live.url}/boom')
        self.assertIn('Internal Server Error', body)

    def test_handler_exception_body_includes_message(self):
        _, _, body = _get(f'{self._live.url}/boom')
        self.assertIn('intentional failure', body)


class TestServer500ErrorDebug(unittest.TestCase):
    """Same 500 path but with debug=True to cover the debug exception branch."""

    def setUp(self):
        self._srv = Server(host='127.0.0.1', port=0, debug=True)

        @self._srv.get('/boom')
        def boom(**_):
            raise ValueError("debug mode error")

        self._ctx = _LiveServer(self._srv)
        self._live = self._ctx.__enter__()

    def tearDown(self):
        self._ctx.__exit__(None, None, None)

    def test_debug_handler_exception_returns_500(self):
        status, _, _ = _get(f'{self._live.url}/boom')
        self.assertEqual(status, 500)


# ---------------------------------------------------------------------------
# 8. Tuple response — handler returns (body, content_type)
# ---------------------------------------------------------------------------

class TestServerTupleResponse(unittest.TestCase):

    def setUp(self):
        self._srv = Server(host='127.0.0.1', port=0)

        @self._srv.get('/text')
        def text_handler(**_):
            return ("hello world", "text/plain")

        @self._srv.get('/csv')
        def csv_handler(**_):
            return ("a,b,c\n1,2,3", "text/csv")

        self._ctx = _LiveServer(self._srv)
        self._live = self._ctx.__enter__()

    def tearDown(self):
        self._ctx.__exit__(None, None, None)

    def test_tuple_response_returns_200(self):
        status, _, _ = _get(f'{self._live.url}/text')
        self.assertEqual(status, 200)

    def test_tuple_response_body_is_correct(self):
        _, _, body = _get(f'{self._live.url}/text')
        self.assertEqual(body, "hello world")

    def test_tuple_response_content_type_header(self):
        _, headers, _ = _get(f'{self._live.url}/text')
        self.assertIn('text/plain', headers.get('Content-Type', ''))

    def test_tuple_response_csv_content_type(self):
        _, headers, _ = _get(f'{self._live.url}/csv')
        self.assertIn('text/csv', headers.get('Content-Type', ''))

    def test_tuple_response_csv_body(self):
        _, _, body = _get(f'{self._live.url}/csv')
        self.assertIn('a,b,c', body)


# ---------------------------------------------------------------------------
# 9. Query params in non-debug GET
# ---------------------------------------------------------------------------

class TestServerQueryParams(unittest.TestCase):

    def setUp(self):
        self._srv = Server(host='127.0.0.1', port=0)
        self._last_params = {}
        captured = self._last_params

        @self._srv.get('/search')
        def search(query_params, **_):
            captured.update(query_params)
            return {"received": list(query_params.keys())}

        self._ctx = _LiveServer(self._srv)
        self._live = self._ctx.__enter__()

    def tearDown(self):
        self._ctx.__exit__(None, None, None)

    def test_query_params_passed_to_handler(self):
        status, _, body = _get(f'{self._live.url}/search?q=hello&limit=10')
        self.assertEqual(status, 200)
        self.assertIn('q', self._last_params)
        self.assertIn('limit', self._last_params)

    def test_query_params_values_are_lists(self):
        _get(f'{self._live.url}/search?tag=a&tag=b')
        self.assertIn('tag', self._last_params)
        self.assertEqual(len(self._last_params['tag']), 2)

    def test_no_query_params_handler_receives_empty_dict(self):
        _get(f'{self._live.url}/search')
        self.assertEqual(self._last_params, {})


# ---------------------------------------------------------------------------
# 10. Debug mode — 401 path logging
# ---------------------------------------------------------------------------

class TestServerDebugAuth(unittest.TestCase):
    """Cover the debug=True branch inside the 401 early-return path."""

    def setUp(self):
        self._srv = Server(
            host='127.0.0.1',
            port=0,
            debug=True,
            key_validator=lambda k: -1 if k == 'secret' else None
        )
        router = Router(prefix='')

        @router.get('/protected', secured=True)
        def protected(**_):
            return {"ok": True}

        self._srv.include_router(router)
        self._ctx = _LiveServer(self._srv)
        self._live = self._ctx.__enter__()

    def tearDown(self):
        self._ctx.__exit__(None, None, None)

    def test_debug_valid_key_returns_200(self):
        status, _, _ = _get(
            f'{self._live.url}/protected',
            {'Authorization': 'Bearer secret'}
        )
        self.assertEqual(status, 200)

    def test_debug_invalid_key_returns_401(self):
        status, _, _ = _get(
            f'{self._live.url}/protected',
            {'Authorization': 'Bearer wrong'}
        )
        self.assertEqual(status, 401)

    def test_debug_no_key_returns_401(self):
        status, _, _ = _get(f'{self._live.url}/protected')
        self.assertEqual(status, 401)


# ---------------------------------------------------------------------------
# 11. Debug POST with multipart (covers multipart debug branch)
# ---------------------------------------------------------------------------

class TestServerDebugPostHandling(unittest.TestCase):

    def setUp(self):
        self._srv = Server(host='127.0.0.1', port=0, debug=True)

        @self._srv.post('/upload')
        def upload(body, **_):
            return {"size": len(body) if body else 0}

        @self._srv.post('/data')
        def data(body, **_):
            return {"body": body}

        self._ctx = _LiveServer(self._srv)
        self._live = self._ctx.__enter__()

    def tearDown(self):
        self._ctx.__exit__(None, None, None)

    def test_debug_multipart_post_returns_200(self):
        payload = (
            b'--bound\r\n'
            b'Content-Disposition: form-data; name="f"\r\n\r\n'
            b'v\r\n'
            b'--bound--\r\n'
        )
        status, _, _ = _post(
            f'{self._live.url}/upload',
            payload,
            'multipart/form-data; boundary=bound'
        )
        self.assertEqual(status, 200)

    def test_debug_text_plain_post_returns_200(self):
        payload = b'some plain text'
        status, _, _ = _post(f'{self._live.url}/data', payload, 'text/plain')
        self.assertEqual(status, 200)

    def test_debug_json_post_returns_200(self):
        payload = json.dumps({"x": 1}).encode()
        status, _, _ = _post(f'{self._live.url}/data', payload, 'application/json')
        self.assertEqual(status, 200)

    def test_debug_post_with_long_json_body(self):
        """Covers the multi-line JSON debug printing path."""
        big = {"items": list(range(50))}
        payload = json.dumps(big).encode()
        status, _, _ = _post(f'{self._live.url}/data', payload, 'application/json')
        self.assertEqual(status, 200)


# ---------------------------------------------------------------------------
# 11. String response — handler returns a plain str (else branch, lines 190-191)
# ---------------------------------------------------------------------------

class TestServerStringResponse(unittest.TestCase):

    def setUp(self):
        self._srv = Server(host='127.0.0.1', port=0)

        @self._srv.get('/html')
        def html_handler(**_):
            return "<html><body>hello</body></html>"

        @self._srv.get('/plain')
        def plain_handler(**_):
            return "just a string"

        self._ctx = _LiveServer(self._srv)
        self._live = self._ctx.__enter__()

    def tearDown(self):
        self._ctx.__exit__(None, None, None)

    def test_string_response_returns_200(self):
        status, _, _ = _get(f'{self._live.url}/html')
        self.assertEqual(status, 200)

    def test_string_response_body_is_correct(self):
        _, _, body = _get(f'{self._live.url}/html')
        self.assertEqual(body, "<html><body>hello</body></html>")

    def test_plain_string_body_returned(self):
        _, _, body = _get(f'{self._live.url}/plain')
        self.assertEqual(body, "just a string")

    def test_string_response_content_type_is_html(self):
        _, headers, _ = _get(f'{self._live.url}/html')
        self.assertIn('text/html', headers.get('Content-Type', ''))


if __name__ == '__main__':
    unittest.main()
