import json

from http.server import HTTPServer, BaseHTTPRequestHandler
from http.client import HTTPMessage
from urllib.parse import urlparse, parse_qs
from typing import Callable, Optional, TypeAlias, Any

from router import Router

QueryParams: TypeAlias = dict[str, list[str]]
Body: TypeAlias = dict[str, Any] | str | None
Headers: TypeAlias = HTTPMessage

class Server:
  def __init__(self, host: str = 'localhost', port: int = 8080):
    self.host = host
    self.port = port
    self.routes: dict[str, dict[str, Callable]] = {
      'GET': {},
      'POST': {}
    }
    self.server: Optional[HTTPServer] = None

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

  def _create_handler(self):
    routes = self.routes

    class RequestHandler(BaseHTTPRequestHandler):
      def _send_response(self, status_code: int, body: str | bytes, content_type: str = 'text/html'):
        self.send_response(status_code)
        self.send_header('Content-Type', content_type)
        self.end_headers()
        if isinstance(body, str):
          body = body.encode('utf-8')
        self.wfile.write(body)

      def _handle_request(self, method: str):
        parsed_path = urlparse(self.path)
        path = parsed_path.path
        query_params = parse_qs(parsed_path.query)

        if path in routes[method]:
          handler = routes[method][path]

          body = None
          if method == 'POST':
            content_length = int(self.headers.get('Content-Length', 0))
            raw_body = self.rfile.read(content_length)

            content_type = self.headers.get('Content-Type', '')
            if 'multipart/form-data' in content_type:
              body = raw_body
            else:
              body = raw_body.decode('utf-8')
              try:
                body = json.loads(body)
              except json.JSONDecodeError:
                pass

          try:
            result = handler(query_params=query_params, body=body, headers=self.headers)
            if isinstance(result, dict):
              self._send_response(200, json.dumps(result), 'application/json')
            else:
              self._send_response(200, str(result))
          except Exception as e:
            self._send_response(500, f"Internal Server Error: {str(e)}")
        else:
          self._send_response(404, "Not Found")

      def do_GET(self):
        self._handle_request('GET')

      def do_POST(self):
        self._handle_request('POST')

      def log_message(self, format: str, *args):
        print(f"[{self.log_date_time_string()}] {args[0]}")

    return RequestHandler

  def run(self):
    handler = self._create_handler()
    self.server = HTTPServer((self.host, self.port), handler)

    print(f"Starting server on http://{self.host}:{self.port}")

    try:
      self.server.serve_forever()
    except KeyboardInterrupt:
      print("\nShutting down server...")
    finally:
      self.server.server_close()
      print("Server stopped.")
