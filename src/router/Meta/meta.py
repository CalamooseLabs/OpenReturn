import re
from typing import Any
from http.client import HTTPMessage
from importlib.metadata import version as _pkg_version, PackageNotFoundError

from router import Router
import openapi


def _version() -> str:
    """The package version as a semver-ish string ('dev' when not installed)."""
    try:
        raw = _pkg_version("openreturn")
    except PackageNotFoundError:
        return "dev"
    return re.sub(r'a(\d+)$', r'-alpha.\1',
                  re.sub(r'b(\d+)$', r'-beta.\1',
                         re.sub(r'rc(\d+)$', r'-rc.\1', raw)))


class MetaRouter(Router):
  """Public service-meta endpoints a frontend can hit without auth — the served
  OpenAPI contract, a health probe, and the version. Registered with
  ``secure_by_default=False`` so they stay open even when the server runs with
  ``--auth`` (a SPA must read the spec / health before it has a token)."""

  def __init__(self, prefix: str = '', db=None, secure_by_default: bool = False) -> None:
    super().__init__(prefix, secure_by_default=secure_by_default)
    self.db = db
    self._register_routes()

  def _register_routes(self):

    @self.get('/openapi.json')
    def openapi_json(query_params: dict, body: Any, headers: HTTPMessage):
      """The live OpenAPI 3.1 spec, with ``servers[0].url`` set to the host the
      request came in on so a generated client targets the right base."""
      host = headers.get('Host')
      scheme = headers.get('X-Forwarded-Proto', 'http')
      base = f"{scheme}://{host}" if host else None
      return openapi.build_spec(base)

    @self.get('/health')
    def health(query_params: dict, body: Any, headers: HTTPMessage):
      return {"status": "ok", "version": _version()}

    @self.get('/version')
    def version(query_params: dict, body: Any, headers: HTTPMessage):
      return {"name": "openreturn", "version": _version()}
