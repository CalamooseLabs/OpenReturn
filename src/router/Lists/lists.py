from typing import Any
from http.client import HTTPMessage

from router import Router
from database import OpenReturnDB
from database.Lists import lists as _lists_mod


class ListsRouter(Router):
  """Organization lists — private/public, static/smart. Reads require
  ``list:read``; mutations require ``list:write`` and are scoped to the owner for
  private lists."""

  def __init__(self, prefix: str = '/lists', db: OpenReturnDB = None,
               secure_by_default: bool = False) -> None:
    super().__init__(prefix, secure_by_default=secure_by_default)
    self.db = db
    self._register_routes()

  def _viewer(self, headers: HTTPMessage):
    """The viewer's user_id for ownership/visibility checks — None for a program
    (API key) caller, which can see public lists but owns no private ones."""
    p = self._principal(headers)
    return p.user_id if (p is not None and p.kind == 'user') else None

  def _register_routes(self):

    @self.get('', permission='list:read')
    def list_lists(query_params: dict, body: Any, headers: HTTPMessage):
      """Lists the caller can see — all public lists plus their own private ones."""
      return {"lists": self.db.lists.list_lists(self._viewer(headers))}

    @self.get('/detail', permission='list:read')
    def list_detail(query_params: dict, body: Any, headers: HTTPMessage):
      lid, err = self._qp_int_or_error(query_params, 'list_id', field='list_id')
      if err:
        return err
      if lid is None:
        return {"error": "missing query param: list_id"}
      viewer = self._viewer(headers)
      lst = self.db.lists.get_list(lid, viewer)
      if lst is None:
        return {"error": f"list not found: {lid}"}
      lst["organizations"] = self.db.lists.list_members(lid, viewer)
      return lst

    @self.post('', permission='list:write')
    def create_list(query_params: dict, body: Any, headers: HTTPMessage):
      data, err = self._require_fields(body, 'name')
      if err:
        return err
      try:
        return self.db.lists.create_list(
          data['name'], owner_user_id=self._viewer(headers),
          visibility=data.get('visibility', 'private'), kind=data.get('kind', 'static'),
          definition=data.get('definition'), actor=self._principal(headers))
      except ValueError as e:
        return {"error": str(e)}

    @self.post('/edit', permission='list:write')
    def edit_list(query_params: dict, body: Any, headers: HTTPMessage):
      lid, err = self._lid(body)
      if err:
        return err
      fields = {k: body[k] for k in ('name', 'visibility', 'definition') if k in body}
      try:
        lst = self.db.lists.update_list(lid, fields, viewer_user_id=self._viewer(headers),
                                        actor=self._principal(headers))
      except _lists_mod.PermissionError_:
        return {"error": "forbidden: not the owner of this list"}
      except ValueError as e:
        return {"error": str(e)}
      return lst if lst is not None else {"error": f"list not found: {lid}"}

    @self.post('/delete', permission='list:write')
    def delete_list(query_params: dict, body: Any, headers: HTTPMessage):
      lid, err = self._lid(body)
      if err:
        return err
      try:
        return {"deleted": self.db.lists.delete_list(
          lid, viewer_user_id=self._viewer(headers), actor=self._principal(headers))}
      except _lists_mod.PermissionError_:
        return {"error": "forbidden: not the owner of this list"}

    @self.post('/members/add', permission='list:write')
    def add_member(query_params: dict, body: Any, headers: HTTPMessage):
      data, err = self._require_fields(body, 'list_id', 'ein')
      if err:
        return err
      lid, lerr = self._lid(body)
      if lerr:
        return lerr
      try:
        return {"added": self.db.lists.add_member(
          lid, data['ein'], viewer_user_id=self._viewer(headers), actor=self._principal(headers))}
      except _lists_mod.PermissionError_:
        return {"error": "forbidden: not the owner of this list"}
      except ValueError as e:
        return {"error": str(e)}

    @self.post('/members/remove', permission='list:write')
    def remove_member(query_params: dict, body: Any, headers: HTTPMessage):
      data, err = self._require_fields(body, 'list_id', 'ein')
      if err:
        return err
      lid, lerr = self._lid(body)
      if lerr:
        return lerr
      try:
        return {"removed": self.db.lists.remove_member(
          lid, data['ein'], viewer_user_id=self._viewer(headers), actor=self._principal(headers))}
      except _lists_mod.PermissionError_:
        return {"error": "forbidden: not the owner of this list"}
      except ValueError as e:
        return {"error": str(e)}

  @staticmethod
  def _lid(body: Any):
    """Extract an integer list_id from the body, or an error dict."""
    if not isinstance(body, dict) or 'list_id' not in body:
      return None, {"error": "missing required field: list_id"}
    try:
      return int(body['list_id']), None
    except (TypeError, ValueError):
      return None, {"error": "list_id must be an integer"}
