from typing import Any
from http.client import HTTPMessage

from auth import Principal
from router import Router
from database import OpenReturnDB

# Stand-in actor for an admin action reached without an authenticated caller
# (server running without --auth, where the user:admin gate is not enforced). It
# keeps the audit trail honest — distinct from a genuine CLI action (actor None).
_ANON = Principal(kind='anonymous', actor_id=0, label='anonymous (no-auth)')


class AdminRouter(Router):
  """Administration of users, roles, and permissions over HTTP. Every route
  requires the ``user:admin`` permission and is audited. This complements the
  ``openreturn users`` CLI (which remains available); the most sensitive ops
  (create user, reset password) are exposed here too, per the admin mandate."""

  def __init__(self, prefix: str = '/admin', db: OpenReturnDB = None,
               secure_by_default: bool = False) -> None:
    super().__init__(prefix, secure_by_default=secure_by_default)
    self.db = db
    self._register_routes()

  def _audit(self, headers, action, entity_type, entity_id, changes=None):
    self.db.audit.record(self._principal(headers) or _ANON, action, entity_type,
                         entity_id, changes)

  def _register_routes(self):

    # ── Users ─────────────────────────────────────────────────────────────
    @self.get('/users', permission='user:admin')
    def list_users(query_params: dict, body: Any, headers: HTTPMessage):
      return {"users": self.db.users.list_users()}

    @self.post('/users', permission='user:admin')
    def create_user(query_params: dict, body: Any, headers: HTTPMessage):
      """Create a user. Body: {username, password?, roles?}. A generated
      temporary password is returned (once) when none is supplied."""
      data, err = self._require_fields(body, 'username')
      if err:
        return err
      from auth import generate_token
      password = data.get('password') or generate_token()
      generated = not data.get('password')
      roles = data.get('roles') or []
      try:
        user_id = self.db.users.create_user(data['username'], password, roles=roles)
      except ValueError as e:
        return {"error": str(e)}
      self._audit(headers, 'create', 'user', data['username'], {'roles': roles})
      out = {"user_id": user_id, "username": data['username'], "roles": roles}
      if generated:
        out["temporary_password"] = password
      return out

    @self.post('/users/reset-password', permission='user:admin')
    def reset_password(query_params: dict, body: Any, headers: HTTPMessage):
      data, err = self._require_fields(body, 'username')
      if err:
        return err
      temp = self.db.users.reset_password(data['username'])
      if temp is None:
        return {"error": f"user not found: {data['username']}"}
      self._audit(headers, 'update', 'user', data['username'], {'password': 'reset'})
      return {"username": data['username'], "temporary_password": temp}

    @self.post('/users/activate', permission='user:admin')
    def activate(query_params: dict, body: Any, headers: HTTPMessage):
      return self._set_active(body, True, headers)

    @self.post('/users/deactivate', permission='user:admin')
    def deactivate(query_params: dict, body: Any, headers: HTTPMessage):
      return self._set_active(body, False, headers)

    @self.post('/users/assign-role', permission='user:admin')
    def assign_role(query_params: dict, body: Any, headers: HTTPMessage):
      data, err = self._require_fields(body, 'username', 'role')
      if err:
        return err
      if not self.db.users.assign_role(data['username'], data['role']):
        return {"error": "user or role not found"}
      self._audit(headers, 'update', 'user', data['username'], {'assign_role': data['role']})
      return {"username": data['username'], "roles": self.db.users.get_user(data['username'])['roles']}

    @self.post('/users/revoke-role', permission='user:admin')
    def revoke_role(query_params: dict, body: Any, headers: HTTPMessage):
      data, err = self._require_fields(body, 'username', 'role')
      if err:
        return err
      try:
        ok = self.db.users.revoke_role(data['username'], data['role'])
      except ValueError as e:
        return {"error": str(e)}
      if not ok:
        return {"error": "user/role not found or role not assigned"}
      self._audit(headers, 'update', 'user', data['username'], {'revoke_role': data['role']})
      return {"username": data['username'], "roles": self.db.users.get_user(data['username'])['roles']}

    # ── Roles ─────────────────────────────────────────────────────────────
    @self.get('/roles', permission='user:admin')
    def list_roles(query_params: dict, body: Any, headers: HTTPMessage):
      return {"roles": self.db.users.list_roles()}

    @self.post('/roles', permission='user:admin')
    def create_role(query_params: dict, body: Any, headers: HTTPMessage):
      data, err = self._require_fields(body, 'code')
      if err:
        return err
      try:
        self.db.users.create_role(data['code'], data.get('name', data['code']),
                                  data.get('description'))
      except ValueError as e:
        return {"error": str(e)}
      self._audit(headers, 'create', 'role', data['code'])
      return {"roles": self.db.users.list_roles()}

    @self.post('/roles/delete', permission='user:admin')
    def delete_role(query_params: dict, body: Any, headers: HTTPMessage):
      data, err = self._require_fields(body, 'code')
      if err:
        return err
      try:
        ok = self.db.users.delete_role(data['code'])
      except ValueError as e:
        return {"error": str(e)}
      if not ok:
        return {"error": f"role not found: {data['code']}"}
      self._audit(headers, 'delete', 'role', data['code'])
      return {"deleted": True}

    @self.post('/roles/grant', permission='user:admin')
    def grant(query_params: dict, body: Any, headers: HTTPMessage):
      data, err = self._require_fields(body, 'role', 'permission')
      if err:
        return err
      if not self.db.users.grant_permission(data['role'], data['permission']):
        return {"error": "role or permission not found"}
      self._audit(headers, 'update', 'role', data['role'], {'grant': data['permission']})
      return {"role": data['role'],
              "permissions": next((r['permissions'] for r in self.db.users.list_roles()
                                   if r['code'] == data['role']), [])}

    @self.post('/roles/revoke', permission='user:admin')
    def revoke(query_params: dict, body: Any, headers: HTTPMessage):
      data, err = self._require_fields(body, 'role', 'permission')
      if err:
        return err
      try:
        ok = self.db.users.revoke_permission(data['role'], data['permission'])
      except ValueError as e:
        return {"error": str(e)}
      if not ok:
        return {"error": "role/permission not found or not granted"}
      self._audit(headers, 'update', 'role', data['role'], {'revoke': data['permission']})
      return {"role": data['role'],
              "permissions": next((r['permissions'] for r in self.db.users.list_roles()
                                   if r['code'] == data['role']), [])}

    # ── Permissions ─────────────────────────────────────────────────────────
    @self.get('/permissions', permission='user:admin')
    def list_permissions(query_params: dict, body: Any, headers: HTTPMessage):
      return {"permissions": self.db.users.list_permissions()}

    @self.post('/permissions', permission='user:admin')
    def create_permission(query_params: dict, body: Any, headers: HTTPMessage):
      data, err = self._require_fields(body, 'code')
      if err:
        return err
      try:
        self.db.users.create_permission(data['code'], data.get('description'))
      except ValueError as e:
        return {"error": str(e)}
      self._audit(headers, 'create', 'permission', data['code'])
      return {"permissions": self.db.users.list_permissions()}

    # ── Scoring models (the admin model builder) ──────────────────────────────
    @self.get('/models', permission='user:admin')
    def list_models(query_params: dict, body: Any, headers: HTTPMessage):
      """Registered scoring models — so the builder can show what exists (and what a
      composite can reference)."""
      return {"models": self.db.scores.list_models()}

    @self.post('/models', permission='user:admin')
    def create_model(query_params: dict, body: Any, headers: HTTPMessage):
      """Create (register) a scoring model from a definition (the same
      ``{model, factor}`` shape a template provides). ``dry_run`` validates without
      writing; ``skip_existing`` no-ops a duplicate version. Audited via
      ``register_model``."""
      data, err = self._require_fields(body, 'definition')
      if err:
        return err
      from models import register_model
      try:
        result = register_model(
          self.db, data['definition'], actor=self._principal(headers),
          skip_existing=bool(data.get('skip_existing')), dry_run=bool(data.get('dry_run')))
      except (ValueError, KeyError, TypeError) as e:
        return {"error": str(e) or "invalid model definition"}
      return result

  def _set_active(self, body, active, headers):
    data, err = self._require_fields(body, 'username')
    if err:
      return err
    try:
      ok = self.db.users.set_active(data['username'], active)
    except ValueError as e:
      return {"error": str(e)}
    if not ok:
      return {"error": f"user not found: {data['username']}"}
    self._audit(headers, 'update', 'user', data['username'], {'is_active': active})
    return {"username": data['username'], "is_active": active}
