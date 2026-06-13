"""Serves the OpenAPI document and an interactive docs page.

Both routes are **public** (registered with the router's default
``secure_by_default=False``), so API consumers can discover how to call the API
even when the server runs with ``--auth``. ``GET /openapi.json`` is the
machine-readable spec; ``GET /docs`` is a Redoc HTML page that renders it (Redoc
is loaded from a CDN — the page needs internet, but the spec itself does not).
"""

from typing import Any
from http.client import HTTPMessage

from router import Router
import openapi

_REDOC_HTML = """<!DOCTYPE html>
<html>
  <head>
    <title>OpenReturn API</title>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <style>body { margin: 0; padding: 0; }</style>
  </head>
  <body>
    <redoc spec-url="{{spec_url}}"></redoc>
    <script src="https://cdn.redoc.ly/redoc/latest/bundles/redoc.standalone.js"></script>
  </body>
</html>
"""


class DocsRouter(Router):
  def __init__(self, prefix: str = '', base_url: str | None = None,
               spec_url: str = '/openapi.json') -> None:
    super().__init__(prefix)  # secure_by_default=False → public routes
    self._base_url = base_url
    self._spec_url = spec_url
    self._register_routes()

  def _register_routes(self):
    @self.get('/openapi.json')
    def openapi_json(query_params: dict, body: Any, headers: HTTPMessage):
      return openapi.spec_json(base_url=self._base_url), 'application/json'

    @self.get('/docs')
    def docs_page(query_params: dict, body: Any, headers: HTTPMessage):
      return _REDOC_HTML.replace('{{spec_url}}', self._spec_url), 'text/html; charset=utf-8'
