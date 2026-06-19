import secrets
import sqlite3

from auth import (Principal, generate_token, hash_password, hash_token,
                  verify_password)
from database.base import Database

# A throwaway hash verified on logins for unknown/inactive users so every login
# attempt runs scrypt exactly once — no timing oracle that distinguishes
# "no such user / deactivated" (fast) from "valid user, wrong password" (slow).
_DUMMY_HASH = hash_password(secrets.token_hex(16))


class UserDatabase(Database):
  """User accounts, roles/permissions, and login sessions (reached as ``db.users``).

  Owns the RBAC tables and the authentication logic. ``authenticate(token)`` is
  the single entry point the server uses to resolve a Bearer token to a
  ``Principal`` — it accepts both a user **session key** and a program **API key**
  (delegating the latter to ``db.keys``). User creation and password resets are
  CLI-only (no HTTP route calls them); login/logout are HTTP.
  """

  def __init__(self, db) -> None:
    self._db = db
    super().__init__("User", "User", populate_guard="role",
                     connection=db.connection, cursor=db.cursor)
    self._ensure_data_permissions()
    self._ensure_follow_permissions()
    self._ensure_note_permissions()
    self._ensure_giving_permissions()
    self._ensure_model_data_permissions()

  def _ensure_data_permissions(self) -> None:
    """Add the data:read/data:write permissions + default grants on DBs created
    before they existed. Runs once (guarded on data:read's presence) so a later
    manual revoke is respected and not re-granted on restart."""
    if self.cursor.execute("SELECT 1 FROM permission WHERE code = 'data:read'").fetchone():
      return
    self.cursor.execute(
      "INSERT OR IGNORE INTO permission (code, description) VALUES "
      "('data:read', 'Read financial data, observations, and conflicts'), "
      "('data:write', 'Record financial observations and choose canonical values')")
    grants = {'admin': ('data:read', 'data:write'), 'editor': ('data:read', 'data:write'),
              'viewer': ('data:read',), 'service': ('data:read',)}
    for role, perms in grants.items():
      for p in perms:
        self.cursor.execute(
          "INSERT OR IGNORE INTO role_permission (role_id, permission_id) "
          "SELECT r.role_id, pm.permission_id FROM role r, permission pm "
          "WHERE r.code = ? AND pm.code = ?", (role, p))
    self.connection.commit()

  def _ensure_follow_permissions(self) -> None:
    """Add the follow:read/follow:write permissions + default grants on DBs created
    before they existed (guarded on follow:read's presence, so a later manual revoke
    is respected). Mirrors _ensure_data_permissions."""
    if self.cursor.execute("SELECT 1 FROM permission WHERE code = 'follow:read'").fetchone():
      return
    self.cursor.execute(
      "INSERT OR IGNORE INTO permission (code, description) VALUES "
      "('follow:read', 'Read the caller''s organization watchlist'), "
      "('follow:write', 'Follow and unfollow organizations')")
    grants = {'admin': ('follow:read', 'follow:write'), 'editor': ('follow:read', 'follow:write'),
              'viewer': ('follow:read', 'follow:write'), 'service': ('follow:read',)}
    for role, perms in grants.items():
      for p in perms:
        self.cursor.execute(
          "INSERT OR IGNORE INTO role_permission (role_id, permission_id) "
          "SELECT r.role_id, pm.permission_id FROM role r, permission pm "
          "WHERE r.code = ? AND pm.code = ?", (role, p))
    self.connection.commit()

  def _ensure_note_permissions(self) -> None:
    """Add the note:read/note:write permissions + default grants on DBs created
    before they existed (guarded on note:read's presence). Notes are shared,
    team-wide org updates. Mirrors _ensure_follow_permissions."""
    if self.cursor.execute("SELECT 1 FROM permission WHERE code = 'note:read'").fetchone():
      return
    self.cursor.execute(
      "INSERT OR IGNORE INTO permission (code, description) VALUES "
      "('note:read', 'Read organization notes / updates'), "
      "('note:write', 'Post and remove organization notes / updates')")
    grants = {'admin': ('note:read', 'note:write'), 'editor': ('note:read', 'note:write'),
              'viewer': ('note:read',), 'service': ('note:read',)}
    for role, perms in grants.items():
      for p in perms:
        self.cursor.execute(
          "INSERT OR IGNORE INTO role_permission (role_id, permission_id) "
          "SELECT r.role_id, pm.permission_id FROM role r, permission pm "
          "WHERE r.code = ? AND pm.code = ?", (role, p))
    self.connection.commit()

  def _ensure_giving_permissions(self) -> None:
    """Add the giving:read/giving:write permissions + default grants on DBs created
    before they existed (guarded on giving:read's presence). Giving rows are the
    shared record of gifts the team gave to an org. Mirrors _ensure_follow_permissions."""
    if self.cursor.execute("SELECT 1 FROM permission WHERE code = 'giving:read'").fetchone():
      return
    self.cursor.execute(
      "INSERT OR IGNORE INTO permission (code, description) VALUES "
      "('giving:read', 'Read recorded giving / gifts'), "
      "('giving:write', 'Record and remove giving / gifts')")
    grants = {'admin': ('giving:read', 'giving:write'), 'editor': ('giving:read', 'giving:write'),
              'viewer': ('giving:read',), 'service': ('giving:read',)}
    for role, perms in grants.items():
      for p in perms:
        self.cursor.execute(
          "INSERT OR IGNORE INTO role_permission (role_id, permission_id) "
          "SELECT r.role_id, pm.permission_id FROM role r, permission pm "
          "WHERE r.code = ? AND pm.code = ?", (role, p))
    self.connection.commit()

  def _ensure_model_data_permissions(self) -> None:
    """Add the model_data:read/model_data:write permissions + default grants on DBs
    created before they existed (guarded on model_data:read's presence). Covers the
    per-(org, model, year) notes + custom data fields. Mirrors the others."""
    if self.cursor.execute("SELECT 1 FROM permission WHERE code = 'model_data:read'").fetchone():
      return
    self.cursor.execute(
      "INSERT OR IGNORE INTO permission (code, description) VALUES "
      "('model_data:read', 'Read per-model/year notes and custom data fields'), "
      "('model_data:write', 'Add and remove per-model/year notes and custom data fields')")
    grants = {'admin': ('model_data:read', 'model_data:write'),
              'editor': ('model_data:read', 'model_data:write'),
              'viewer': ('model_data:read',), 'service': ('model_data:read',)}
    for role, perms in grants.items():
      for p in perms:
        self.cursor.execute(
          "INSERT OR IGNORE INTO role_permission (role_id, permission_id) "
          "SELECT r.role_id, pm.permission_id FROM role r, permission pm "
          "WHERE r.code = ? AND pm.code = ?", (role, p))
    self.connection.commit()

  # ── lookups / permission resolution ──────────────────────────────────────

  def _role_id(self, code: str) -> int | None:
    row = self.cursor.execute("SELECT role_id FROM role WHERE code = ?", (code,)).fetchone()
    return row[0] if row else None

  def _permission_id(self, code: str) -> int | None:
    row = self.cursor.execute(
      "SELECT permission_id FROM permission WHERE code = ?", (code,)).fetchone()
    return row[0] if row else None

  def user_permissions(self, user_id: int) -> set[str]:
    rows = self.cursor.execute(
      """
      SELECT DISTINCT p.code
      FROM user_role ur
      JOIN role_permission rp ON rp.role_id = ur.role_id
      JOIN permission p ON p.permission_id = rp.permission_id
      WHERE ur.user_id = ?
      """, (user_id,)).fetchall()
    return {r[0] for r in rows}

  def permissions_for_role(self, role_code: str) -> set[str]:
    rows = self.cursor.execute(
      """
      SELECT p.code FROM role r
      JOIN role_permission rp ON rp.role_id = r.role_id
      JOIN permission p ON p.permission_id = rp.permission_id
      WHERE r.code = ?
      """, (role_code,)).fetchall()
    return {r[0] for r in rows}

  def _active_admins(self) -> set[int]:
    """User-ids of active users who hold ``user:admin`` through any role. The
    lockout guards below refuse any revoke/deactivate/role-delete that would empty
    this set (but only when it was non-empty to begin with, so a fresh DB with no
    admin user yet stays fully editable)."""
    rows = self.cursor.execute(
      "SELECT DISTINCT u.user_id FROM app_user u "
      "JOIN user_role ur ON ur.user_id = u.user_id "
      "JOIN role_permission rp ON rp.role_id = ur.role_id "
      "JOIN permission p ON p.permission_id = rp.permission_id "
      "WHERE p.code = 'user:admin' AND u.is_active = 1").fetchall()
    return {r[0] for r in rows}

  def _user_roles(self, user_id: int) -> list[str]:
    rows = self.cursor.execute(
      "SELECT r.code FROM user_role ur JOIN role r ON r.role_id = ur.role_id "
      "WHERE ur.user_id = ? ORDER BY r.code", (user_id,)).fetchall()
    return [r[0] for r in rows]

  def _user_dict(self, row) -> dict:
    return {"user_id": row[0], "username": row[1], "is_active": bool(row[2]),
            "created_at": row[3], "last_login_at": row[4],
            "roles": self._user_roles(row[0])}

  def get_user(self, username: str) -> dict | None:
    row = self.cursor.execute(
      "SELECT user_id, username, is_active, created_at, last_login_at "
      "FROM app_user WHERE username = ?", (username,)).fetchone()
    return self._user_dict(row) if row else None

  def list_users(self) -> list[dict]:
    rows = self.cursor.execute(
      "SELECT user_id, username, is_active, created_at, last_login_at "
      "FROM app_user ORDER BY username").fetchall()
    return [self._user_dict(r) for r in rows]

  # ── account management (CLI-only) ─────────────────────────────────────────

  def create_user(self, username: str, password: str, roles: list[str] | None = None) -> int:
    """Create a user with an scrypt-hashed password and optional roles. Raises
    ValueError if the username is taken or a named role does not exist. Roles are
    resolved BEFORE the insert, so a bad role leaves no orphaned user row."""
    role_ids = []
    for code in roles or []:
      rid = self._role_id(code)
      if rid is None:
        raise ValueError(f"unknown role '{code}'")
      role_ids.append(rid)
    try:
      self.cursor.execute(
        "INSERT INTO app_user (username, password_hash) VALUES (?, ?)",
        (username, hash_password(password)))
    except sqlite3.IntegrityError:
      raise ValueError(f"user '{username}' already exists")
    user_id = self.cursor.lastrowid
    for rid in role_ids:
      self.cursor.execute(
        "INSERT OR IGNORE INTO user_role (user_id, role_id) VALUES (?, ?)", (user_id, rid))
    self.connection.commit()
    return user_id

  def set_password(self, username: str, password: str) -> bool:
    """Set a user's password and revoke their existing sessions. Returns False if
    the user does not exist."""
    self.cursor.execute(
      "UPDATE app_user SET password_hash = ?, updated_at = datetime('now') WHERE username = ?",
      (hash_password(password), username))
    changed = self.cursor.rowcount > 0
    if changed:
      self.cursor.execute(
        "DELETE FROM session WHERE user_id = (SELECT user_id FROM app_user WHERE username = ?)",
        (username,))
    self.connection.commit()
    return changed

  def reset_password(self, username: str) -> str | None:
    """Set a freshly generated temporary password and return it (shown once), or
    None if the user does not exist."""
    temp = generate_token()
    return temp if self.set_password(username, temp) else None

  def set_active(self, username: str, active: bool) -> bool:
    had_admin = bool(self._active_admins())
    self.cursor.execute(
      "UPDATE app_user SET is_active = ?, updated_at = datetime('now') WHERE username = ?",
      (1 if active else 0, username))
    changed = self.cursor.rowcount > 0
    if changed and not active:
      if had_admin and not self._active_admins():
        self.connection.rollback()
        raise ValueError("refusing to deactivate the last active administrator")
      self.cursor.execute(
        "DELETE FROM session WHERE user_id = (SELECT user_id FROM app_user WHERE username = ?)",
        (username,))
    self.connection.commit()
    return changed

  def assign_role(self, username: str, role_code: str) -> bool:
    row = self.cursor.execute("SELECT user_id FROM app_user WHERE username = ?", (username,)).fetchone()
    rid = self._role_id(role_code)
    if row is None or rid is None:
      return False
    self.cursor.execute(
      "INSERT OR IGNORE INTO user_role (user_id, role_id) VALUES (?, ?)", (row[0], rid))
    self.connection.commit()
    return True

  def revoke_role(self, username: str, role_code: str) -> bool:
    row = self.cursor.execute("SELECT user_id FROM app_user WHERE username = ?", (username,)).fetchone()
    rid = self._role_id(role_code)
    if row is None or rid is None:
      return False
    had_admin = bool(self._active_admins())
    self.cursor.execute("DELETE FROM user_role WHERE user_id = ? AND role_id = ?", (row[0], rid))
    revoked = self.cursor.rowcount > 0
    if revoked and had_admin and not self._active_admins():
      self.connection.rollback()
      raise ValueError("refusing to revoke the last active administrator's admin role")
    self.connection.commit()
    return revoked

  # ── role / permission management ──────────────────────────────────────────

  def list_roles(self) -> list[dict]:
    rows = self.cursor.execute(
      "SELECT role_id, code, name, description FROM role ORDER BY code").fetchall()
    out = []
    for r in rows:
      perms = self.cursor.execute(
        "SELECT p.code FROM role_permission rp JOIN permission p "
        "ON p.permission_id = rp.permission_id WHERE rp.role_id = ? ORDER BY p.code",
        (r[0],)).fetchall()
      out.append({"code": r[1], "name": r[2], "description": r[3],
                  "permissions": [p[0] for p in perms]})
    return out

  def list_permissions(self) -> list[dict]:
    rows = self.cursor.execute(
      "SELECT code, description FROM permission ORDER BY code").fetchall()
    return [{"code": r[0], "description": r[1]} for r in rows]

  def create_role(self, code: str, name: str | None = None, description: str | None = None) -> int:
    """Create a (non-builtin) role. Raises ValueError if the code is taken."""
    if not code or not str(code).strip():
      raise ValueError("role code is required")
    try:
      self.cursor.execute(
        "INSERT INTO role (code, name, description, is_builtin) VALUES (?, ?, ?, 0)",
        (code, name or code, description))
    except sqlite3.IntegrityError:
      raise ValueError(f"role '{code}' already exists")
    self.connection.commit()
    return self.cursor.lastrowid

  def delete_role(self, code: str) -> bool:
    """Delete a role (its grants/assignments cascade). Built-in roles are
    protected. Returns False if no such role; raises ValueError for a builtin."""
    row = self.cursor.execute(
      "SELECT role_id, is_builtin FROM role WHERE code = ?", (code,)).fetchone()
    if row is None:
      return False
    if row[1]:
      raise ValueError(f"role '{code}' is built-in and cannot be deleted")
    had_admin = bool(self._active_admins())
    self.cursor.execute("DELETE FROM role WHERE role_id = ?", (row[0],))
    if had_admin and not self._active_admins():
      self.connection.rollback()
      raise ValueError(f"refusing to delete role '{code}': it grants the only active "
                       "administrator's user:admin")
    self.connection.commit()
    return True

  def create_permission(self, code: str, description: str | None = None) -> int:
    """Create a new permission code. Raises ValueError if it already exists."""
    if not code or not str(code).strip():
      raise ValueError("permission code is required")
    try:
      self.cursor.execute(
        "INSERT INTO permission (code, description) VALUES (?, ?)", (code, description))
    except sqlite3.IntegrityError:
      raise ValueError(f"permission '{code}' already exists")
    self.connection.commit()
    return self.cursor.lastrowid

  def grant_permission(self, role_code: str, permission_code: str) -> bool:
    rid, pid = self._role_id(role_code), self._permission_id(permission_code)
    if rid is None or pid is None:
      return False
    self.cursor.execute(
      "INSERT OR IGNORE INTO role_permission (role_id, permission_id) VALUES (?, ?)", (rid, pid))
    self.connection.commit()
    return True

  def revoke_permission(self, role_code: str, permission_code: str) -> bool:
    rid, pid = self._role_id(role_code), self._permission_id(permission_code)
    if rid is None or pid is None:
      return False
    had_admin = bool(self._active_admins())
    self.cursor.execute(
      "DELETE FROM role_permission WHERE role_id = ? AND permission_id = ?", (rid, pid))
    revoked = self.cursor.rowcount > 0
    if revoked and had_admin and not self._active_admins():
      self.connection.rollback()
      raise ValueError("refusing to revoke user:admin from the last role granting it")
    self.connection.commit()
    return revoked

  # ── sessions / authentication ─────────────────────────────────────────────

  def _build_user_principal(self, user_id: int, username: str) -> Principal:
    return Principal(kind="user", actor_id=user_id, label=username,
                     permissions=frozenset(self.user_permissions(user_id)),
                     rate_limit=-1, user_id=user_id)

  def login(self, username: str, password: str, ttl_days: int = 30) -> dict | None:
    """Verify credentials and open a session. Returns
    ``{session_key, expires_at, principal, user}`` (session_key shown once) or
    None on bad credentials / inactive account."""
    row = self.cursor.execute(
      "SELECT user_id, password_hash, is_active FROM app_user WHERE username = ?",
      (username,)).fetchone()
    # Always run scrypt exactly once (against a dummy hash for an unknown user)
    # so the three rejection paths — no such user, inactive, wrong password — are
    # timing-indistinguishable.
    ok = verify_password(password, row[1] if row else _DUMMY_HASH)
    if row is None or not row[2] or not ok:
      return None
    user_id = row[0]
    raw = generate_token()
    sid = hash_token(raw)
    self.cursor.execute(
      "INSERT INTO session (session_id, user_id, expires_at) "
      "VALUES (?, ?, datetime('now', ?))", (sid, user_id, f"+{int(ttl_days)} days"))
    self.cursor.execute(
      "UPDATE app_user SET last_login_at = datetime('now') WHERE user_id = ?", (user_id,))
    expires_at = self.cursor.execute(
      "SELECT expires_at FROM session WHERE session_id = ?", (sid,)).fetchone()[0]
    self.connection.commit()
    return {"session_key": raw, "expires_at": expires_at,
            "principal": self._build_user_principal(user_id, username),
            "user": self.get_user(username)}

  def authenticate(self, token: str | None) -> Principal | None:
    """Resolve a Bearer token to a Principal — a live, non-expired user session
    first, otherwise an active API key (a program). Returns None if neither."""
    if not token:
      return None
    sid = hash_token(token)
    row = self.cursor.execute(
      "SELECT u.user_id, u.username FROM session s "
      "JOIN app_user u ON u.user_id = s.user_id "
      "WHERE s.session_id = ? AND s.expires_at > datetime('now') AND u.is_active = 1",
      (sid,)).fetchone()
    if row:
      self.cursor.execute(
        "UPDATE session SET last_used_at = datetime('now') WHERE session_id = ?", (sid,))
      self.connection.commit()
      return self._build_user_principal(row[0], row[1])
    key = self._db.keys.get_active_key(token)
    if key:
      return Principal(kind="program", actor_id=key["key_id"], label=key["name"],
                       permissions=frozenset(self.permissions_for_role(key["role_code"])),
                       rate_limit=key["rate_limit"])
    return None

  def logout(self, token: str | None) -> bool:
    if not token:
      return False
    self.cursor.execute("DELETE FROM session WHERE session_id = ?", (hash_token(token),))
    self.connection.commit()
    return self.cursor.rowcount > 0
