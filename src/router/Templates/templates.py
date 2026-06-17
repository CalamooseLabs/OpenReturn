from typing import Any
from http.client import HTTPMessage

from router import Router
import templates as catalog


class TemplatesRouter(Router):
  """Read-only model-template catalog — the guides a frontend lists and fetches to
  **prefill** a model builder. Reads require ``score:read``; templates are not
  active models (create one via ``POST /admin/models`` or the CLI)."""

  def __init__(self, prefix: str = '/templates', db=None, secure_by_default: bool = False) -> None:
    super().__init__(prefix, secure_by_default=secure_by_default)
    self.db = db
    self._register_routes()

  def _register_routes(self):

    @self.get('', permission='score:read')
    def list_templates(query_params: dict, body: Any, headers: HTTPMessage):
      """The catalog: code / name / kind / type / version / factor_count per template."""
      return {"templates": catalog.list_templates()}

    @self.get('/detail', permission='score:read')
    def template_detail(query_params: dict, body: Any, headers: HTTPMessage):
      """The full definition (``{model, factor}``) for ``?code=`` — what the model
      builder prefills with."""
      code = self._qp(query_params, 'code')
      if not code:
        return {"error": "missing query param: code"}
      data = catalog.get_template(code)
      if data is None:
        return {"error": f"template not found: {code}"}
      return {"code": code, "definition": data}
