from typing import Any
from http.client import HTTPMessage

from router import Router
from database import OpenReturnDB


class AuthRouter(Router):
  """User authentication: a public login that issues a session key, plus logout
  and a 'who am I' endpoint. Programs authenticate with API keys instead and do
  not use these routes.
  """

  def __init__(self, prefix: str = '/auth', db: OpenReturnDB = None,
               secure_by_default: bool = False) -> None:
    super().__init__(prefix, secure_by_default=secure_by_default)
    self.db = db
    self._register_routes()

  @staticmethod
  def _bearer(headers: HTTPMessage) -> str | None:
    h = headers.get('Authorization', '') or ''
    if h.startswith('Bearer '):
      return h[7:]
    return headers.get('X-API-Key') or None

  def _register_routes(self):

    @self.post('/login')  # public — a user has no session yet
    def login(query_params: dict, body: Any, headers: HTTPMessage):
      """Exchange username + password for a session key (used as a Bearer token).
      Body: {username, password}. The session key is returned once."""
      data, err = self._require_fields(body, 'username', 'password')
      if err:
        return err
      result = self.db.users.login(str(data['username']), str(data['password']))
      if result is None:
        return {"error": "invalid credentials"}
      return {"session_key": result["session_key"],
              "expires_at": result["expires_at"],
              "user": result["user"]}

    @self.post('/logout', secured=True)
    def logout(query_params: dict, body: Any, headers: HTTPMessage):
      """Revoke the caller's current session."""
      return {"logged_out": self.db.users.logout(self._bearer(headers))}

    @self.get('/me', secured=True)
    def me(query_params: dict, body: Any, headers: HTTPMessage):
      """The authenticated caller: kind, label, granted permissions, and (for a
      user) their account + roles."""
      p = self._principal(headers)
      if p is None:
        return {"error": "not authenticated"}
      out = {"kind": p.kind, "label": p.label, "permissions": sorted(p.permissions)}
      if p.kind == "user":
        out["user"] = self.db.users.get_user(p.label)
      return out
