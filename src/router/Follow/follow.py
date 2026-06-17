from typing import Any
from http.client import HTTPMessage

from router import Router
from database import OpenReturnDB


class FollowRouter(Router):
  """Per-user organization follows / watchlist. ``GET /follows`` (the caller's
  watchlist) requires ``follow:read``; follow/unfollow require ``follow:write`` and
  act as the calling user. A program (API key) has no personal watchlist."""

  def __init__(self, prefix: str = '/follows', db: OpenReturnDB = None,
               secure_by_default: bool = False) -> None:
    super().__init__(prefix, secure_by_default=secure_by_default)
    self.db = db
    self._register_routes()

  def _viewer(self, headers: HTTPMessage):
    p = self._principal(headers)
    return p.user_id if (p is not None and p.kind == 'user') else None

  def _register_routes(self):

    @self.get('', permission='follow:read')
    def list_followed(query_params: dict, body: Any, headers: HTTPMessage):
      """The caller's followed orgs, optionally filtered to one ``?type=`` (e.g.
      foundation). Empty for a program (API key) caller."""
      org_type = self._qp(query_params, 'type')
      return {"organizations": self.db.follows.list_followed(
        self._viewer(headers), org_type=org_type)}

    @self.post('/follow', permission='follow:write')
    def follow_org(query_params: dict, body: Any, headers: HTTPMessage):
      data, err = self._require_fields(body, 'ein')
      if err:
        return err
      try:
        self.db.follows.follow_org(data['ein'], actor=self._principal(headers))
      except ValueError as e:
        return {"error": str(e)}
      return {"ein": data['ein'], "following": True}

    @self.post('/unfollow', permission='follow:write')
    def unfollow_org(query_params: dict, body: Any, headers: HTTPMessage):
      data, err = self._require_fields(body, 'ein')
      if err:
        return err
      removed = self.db.follows.unfollow_org(data['ein'], actor=self._principal(headers))
      return {"ein": data['ein'], "following": False, "removed": removed}
