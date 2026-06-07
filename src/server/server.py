import json
import re
import threading
import time
import traceback
from importlib.metadata import version, PackageNotFoundError

from http.server import HTTPServer, BaseHTTPRequestHandler
from http.client import HTTPMessage
from urllib.parse import urlparse, parse_qs
from typing import Callable, TypeAlias, Any

from router import Router

QueryParams: TypeAlias = dict[str, list[str]]
Body: TypeAlias = dict[str, Any] | str | None
Headers: TypeAlias = HTTPMessage

# ANSI color helpers
_R = '\033[0m'
_BOLD = '\033[1m'
_DIM = '\033[2m'
_GREEN = '\033[32m'
_YELLOW = '\033[33m'
_CYAN = '\033[36m'
_RED = '\033[31m'
_BLUE = '\033[34m'
_MAGENTA = '\033[35m'

def _method_color(method: str) -> str:
  return {
    'GET':  _GREEN,
    'POST': _YELLOW,
  }.get(method, _CYAN)

def _status_color(code: int) -> str:
  if code < 300:
    return _GREEN
  if code < 400:
    return _CYAN
  if code < 500:
    return _YELLOW
  return _RED

def _debug_line(label: str, value: str = ''):
  print(f"  {_DIM}│{_R}  {_MAGENTA}{label:<18}{_R}  {value}")

def _debug_sep(title: str = ''):
  if title:
    print(f"  {_DIM}├─ {title}{_R}")
  else:
    print(f"  {_DIM}│{_R}")

_RATE_WINDOW = 60.0  # seconds per rate-limit window

class Server:
  def __init__(self, host: str = 'localhost', port: int = 8080, debug: bool = False, key_validator=None):
    self.host = host
    self.port = port
    self.debug = debug
    self.key_validator = key_validator
    self.routes: dict[str, dict[str, Callable]] = {
      'GET': {},
      'POST': {}
    }
    self.server: HTTPServer | None = None
    self._rate_counters: dict[str, list] = {}  # raw_key → [count, window_start]
    self._rate_lock = threading.Lock()

  def include_router(self, router: Router):
    for method in router.routes:
      self.routes[method].update(router.routes[method])

  def route(self, path: str, method: str = 'GET'):
    def decorator(func: Callable):
      self.routes[method.upper()][path] = func
      return func
    return decorator

  def get(self, path: str):
    return self.route(path, 'GET')

  def post(self, path: str):
    return self.route(path, 'POST')

  def _print_routes(self):
    print(f"\n{_BOLD}Available routes:{_R}")
    for method, paths in self.routes.items():
      for path in sorted(paths):
        mc = _method_color(method)
        print(f"  {mc}{_BOLD}{method:<6}{_R}  {_CYAN}{path}{_R}")
    print()

  def _create_handler(self):
    routes = self.routes
    debug = self.debug
    key_validator = self.key_validator
    rate_counters = self._rate_counters
    rate_lock = self._rate_lock

    def _is_rate_limited(key: str, limit: int) -> bool:
      if limit == -1:
        return False
      now = time.monotonic()
      with rate_lock:
        if key not in rate_counters:
          rate_counters[key] = [0, now]
        entry = rate_counters[key]
        if now - entry[1] > _RATE_WINDOW:
          entry[0] = 0
          entry[1] = now
        entry[0] += 1
        return entry[0] > limit

    class RequestHandler(BaseHTTPRequestHandler):
      def _send_response(self, status_code: int, body: str | bytes, content_type: str = 'text/html', extra_headers: dict | None = None):
        self.send_response(status_code)
        self.send_header('Content-Type', content_type)
        if extra_headers:
          for k, v in extra_headers.items():
            self.send_header(k, v)
        self.end_headers()
        if isinstance(body, str):
          body = body.encode('utf-8')
        self.wfile.write(body)

      def _handle_request(self, method: str):
        start = time.monotonic()
        parsed_path = urlparse(self.path)
        path = parsed_path.path
        query_params = parse_qs(parsed_path.query)

        if debug:
          mc = _method_color(method)
          print(f"\n  {mc}{_BOLD}{method}{_R}  {_CYAN}{self.path}{_R}  {_DIM}from {self.client_address[0]}{_R}")
          _debug_sep('headers')
          for key, val in self.headers.items():
            _debug_line(key, val)

        status = 404
        result_body: str | None = None

        if path in routes[method]:
          handler = routes[method][path]

          if debug:
            _debug_sep(f'handler → {handler.__name__}')

          if key_validator is not None and getattr(handler, '_secured', False):
            provided = None
            auth_header = self.headers.get('Authorization', '')
            if auth_header.startswith('Bearer '):
              provided = auth_header[7:]
            if not provided:
              provided = self.headers.get('X-API-Key') or None

            rate_limit = key_validator(provided) if provided else None
            if rate_limit is None:
              body = json.dumps({"error": "unauthorized"})
              self._send_response(401, body, 'application/json',
                                  {'WWW-Authenticate': 'Bearer realm="openreturn"'})
              elapsed_ms = (time.monotonic() - start) * 1000
              mc = _method_color(method)
              if debug:
                _debug_sep()
                print(f"  {_DIM}└─{_R}  {_RED}{_BOLD}401{_R}  {_DIM}{elapsed_ms:.1f}ms{_R}")
              else:
                print(f"  {mc}{_BOLD}{method:<6}{_R}  {_CYAN}{path}{_R}  {_RED}401{_R}  {_DIM}{elapsed_ms:.1f}ms{_R}")
              return
            if _is_rate_limited(provided, rate_limit):
              body = json.dumps({"error": "rate limit exceeded"})
              self._send_response(429, body, 'application/json',
                                  {'Retry-After': str(int(_RATE_WINDOW))})
              elapsed_ms = (time.monotonic() - start) * 1000
              mc = _method_color(method)
              if debug:
                _debug_sep()
                print(f"  {_DIM}└─{_R}  {_RED}{_BOLD}429{_R}  {_DIM}{elapsed_ms:.1f}ms{_R}")
              else:
                print(f"  {mc}{_BOLD}{method:<6}{_R}  {_CYAN}{path}{_R}  {_RED}429{_R}  {_DIM}{elapsed_ms:.1f}ms{_R}")
              return

          body = None
          if method == 'POST':
            content_length = int(self.headers.get('Content-Length', 0))
            raw_body = self.rfile.read(content_length)
            content_type_hdr = self.headers.get('Content-Type', '')

            if debug:
              _debug_sep('request body')
              _debug_line('content-length', f'{content_length} bytes')

            if 'multipart/form-data' in content_type_hdr:
              body = raw_body
              if debug:
                _debug_line('type', 'multipart/form-data (binary)')
            else:
              body = raw_body.decode('utf-8')
              try:
                body = json.loads(body)
                if debug:
                  _debug_line('type', 'application/json')
                  for line in json.dumps(body, indent=2).splitlines():
                    print(f"  {_DIM}│{_R}    {line}")
              except json.JSONDecodeError:
                if debug:
                  _debug_line('type', 'text/plain')
                  snippet = body[:200] + ('…' if len(body) > 200 else '')
                  _debug_line('body', snippet)

          elif debug and query_params:
            _debug_sep('query params')
            for k, v in query_params.items():
              _debug_line(k, ', '.join(v))

          try:
            result = handler(query_params=query_params, body=body, headers=self.headers)
            if isinstance(result, dict):
              result_body = json.dumps(result)
              self._send_response(200, result_body, 'application/json')
            elif isinstance(result, tuple):
              result_body, content_type = result
              self._send_response(200, result_body, content_type)
            else:
              result_body = str(result)
              self._send_response(200, result_body)
            status = 200
          except Exception as e:
            tb = traceback.format_exc()
            self._send_response(500, f"Internal Server Error: {str(e)}")
            status = 500
            if debug:
              _debug_sep('exception')
              for line in tb.strip().splitlines():
                print(f"  {_DIM}│{_R}  {_RED}{line}{_R}")
            else:
              print(f"  {_RED}ERROR{_R}  {_DIM}{str(e)}{_R}")
        else:
          self._send_response(404, "Not Found")

        elapsed_ms = (time.monotonic() - start) * 1000
        sc = _status_color(status)
        mc = _method_color(method)

        if debug:
          if status == 200 and result_body is not None:
            _debug_sep('response body')
            snippet = result_body[:500] + ('…' if len(result_body) > 500 else '')
            for line in snippet.splitlines()[:20]:
              print(f"  {_DIM}│{_R}    {line}")
          _debug_sep()
          print(
            f"  {_DIM}└─{_R}"
            f"  {sc}{_BOLD}{status}{_R}"
            f"  {_DIM}{elapsed_ms:.1f}ms{_R}"
          )
        else:
          print(
            f"  {mc}{_BOLD}{method:<6}{_R}"
            f"  {_CYAN}{path}{_R}"
            f"  {sc}{status}{_R}"
            f"  {_DIM}{elapsed_ms:.1f}ms{_R}"
          )

      def do_GET(self):
        self._handle_request('GET')

      def do_POST(self):
        self._handle_request('POST')

      def log_message(self, format: str, *args):
        pass  # suppress default HTTPServer noise; handled in _handle_request

    return RequestHandler

  def run(self):
    handler = self._create_handler()
    self.server = HTTPServer((self.host, self.port), handler)

    try:
      raw = version("openreturn")
      _version = re.sub(r'a(\d+)$', r'-alpha.\1',
                 re.sub(r'b(\d+)$', r'-beta.\1',
                 re.sub(r'rc(\d+)$', r'-rc.\1', raw)))
    except PackageNotFoundError:
      _version = "dev"
    tags = []
    if self.debug:
      tags.append(f"{_YELLOW}{_BOLD}debug{_R}")
    if self.key_validator:
      tags.append(f"{_MAGENTA}auth{_R}")
    tag_str = ("  " + "  ".join(tags)) if tags else ""
    print(f"{_BOLD}{_GREEN}OpenReturn{_R}  {_DIM}v{_version}{_R}  listening on {_CYAN}http://{self.host}:{self.port}{_R}{tag_str}")
    self._print_routes()

    try:
      self.server.serve_forever()
    except KeyboardInterrupt:
      print(f"\n{_YELLOW}Shutting down...{_R}")
    finally:
      self.server.server_close()
      print(f"{_DIM}Server stopped.{_R}")
