import json
import time
import traceback

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

class Server:
  def __init__(self, host: str = 'localhost', port: int = 8080, debug: bool = False):
    self.host = host
    self.port = port
    self.debug = debug
    self.routes: dict[str, dict[str, Callable]] = {
      'GET': {},
      'POST': {}
    }
    self.server: HTTPServer | None = None

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

    class RequestHandler(BaseHTTPRequestHandler):
      def _send_response(self, status_code: int, body: str | bytes, content_type: str = 'text/html'):
        self.send_response(status_code)
        self.send_header('Content-Type', content_type)
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

    debug_tag = f"  {_YELLOW}{_BOLD}debug{_R}" if self.debug else ""
    print(f"{_BOLD}{_GREEN}OpenReturn{_R}  listening on {_CYAN}http://{self.host}:{self.port}{_R}{debug_tag}")
    self._print_routes()

    try:
      self.server.serve_forever()
    except KeyboardInterrupt:
      print(f"\n{_YELLOW}Shutting down...{_R}")
    finally:
      self.server.server_close()
      print(f"{_DIM}Server stopped.{_R}")
