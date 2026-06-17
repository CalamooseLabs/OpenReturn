from typing import Any
from http.client import HTTPMessage

from router import Router
from database import OpenReturnDB


class TagsRouter(Router):
  """Organization tags. Reads require ``tag:read``; applying/removing requires
  ``tag:write``."""

  def __init__(self, prefix: str = '/tags', db: OpenReturnDB = None,
               secure_by_default: bool = False) -> None:
    super().__init__(prefix, secure_by_default=secure_by_default)
    self.db = db
    self._register_routes()

  def _register_routes(self):

    @self.get('', permission='tag:read')
    def list_tags(query_params: dict, body: Any, headers: HTTPMessage):
      """All tags + org counts, or — with ?ein= — the tags on one organization."""
      ein = self._qp(query_params, 'ein')
      if ein:
        return {"ein": ein, "tags": self.db.tags.org_tags(ein)}
      return {"tags": self.db.tags.list_tags()}

    @self.get('/organizations', permission='tag:read')
    def orgs_with_tag(query_params: dict, body: Any, headers: HTTPMessage):
      tag = self._qp(query_params, 'tag')
      if not tag:
        return {"error": "missing query param: tag"}
      return {"tag": tag, "eins": self.db.tags.orgs_with_tags([tag])}

    @self.post('', permission='tag:write')
    def apply_tag(query_params: dict, body: Any, headers: HTTPMessage):
      data, err = self._require_fields(body, 'ein', 'tag')
      if err:
        return err
      try:
        return self.db.tags.apply_tag(data['ein'], data['tag'], actor=self._principal(headers))
      except ValueError as e:
        return {"error": str(e)}

    @self.post('/remove', permission='tag:write')
    def remove_tag(query_params: dict, body: Any, headers: HTTPMessage):
      data, err = self._require_fields(body, 'ein', 'tag')
      if err:
        return err
      return {"removed": self.db.tags.remove_tag(
        data['ein'], data['tag'], actor=self._principal(headers))}
