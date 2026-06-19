# Access Control

OpenReturn authenticates two kinds of caller and authorizes every route with a
permission check.

- **Users** log in with a username + password and receive a **session key**.
- **Programs** (e.g. the frontend server) authenticate with an **[API key](api-keys.md)**.

Both send their key as `Authorization: Bearer <key>` (or `X-API-Key: <key>`).
Enforcement is active when the server runs with `--auth`.

## Roles and permissions

Authorization is **permission-based**:

- A **permission** is a capability code such as `org:write`.
- A **role** grants a set of permissions.
- A **user** (or an API key) holds one or more roles.
- A **route** declares the one permission it requires (in code). A request is
  allowed when the caller's roles grant that permission — otherwise **403**.

`role → permission` and `user → role` live in the database and are editable at
runtime with the CLI (no redeploy). The `route → permission` mapping lives in the
router code.

### Built-in roles

| Role | Intended for | Grants |
|------|--------------|--------|
| `admin` | Administrators | every permission, incl. `user:admin` |
| `editor` | Staff who edit data | all reads + `org/person/tag/list/score/filing/note/giving/model_data` writes + `upload:write` + `follow:write` |
| `viewer` | Read-only users | all `*:read` + `follow:write` (their own watchlist) |
| `service` | Programs (API keys) | restricted reads: `org/person/tag/list/filing/score/follow/note/giving/model_data :read` |

### Permissions

`org:read` `org:write` · `person:read` `person:write` · `tag:read` `tag:write` ·
`list:read` `list:write` · `filing:read` `filing:write` · `score:read`
`score:write` · `follow:read` `follow:write` · `note:read` `note:write` ·
`giving:read` `giving:write` · `model_data:read` `model_data:write` · `upload:write` ·
`user:admin`

List them live with `GET /scores/types`-style discovery via the CLI: `openreturn users roles`.

## Sessions (users)

```
POST /auth/login     { "username": "...", "password": "..." }
                     → { "session_key": "<key>", "expires_at": "...", "user": {...} }
```

`/auth/login` is **public** (a user has no session yet); it is rate-limited at the
deployment layer. The returned `session_key` is shown once — send it as a Bearer
token on subsequent requests. Sessions expire after 30 days (configurable).

```
GET  /auth/me        → { kind, label, permissions, user }   # who am I
POST /auth/logout    → { logged_out: true }                 # revoke this session
```

Changing or resetting a password, or deactivating a user, revokes that user's
existing sessions.

## Programs (API keys)

An [API key](api-keys.md) is bound to a role (default `service` — restricted
read-only) and is meant for programs such as the frontend:

```bash
openreturn keys create "frontend" --role service     # restricted (default)
openreturn keys create "import-bot" --role editor     # if a program needs writes
```

API keys retain per-key rate limiting; user sessions are not rate-limited by the
server.

## Admin HTTP API

An administrator (a user holding **`user:admin`**) can manage everything over
HTTP under `/admin` — users (incl. create + password reset), roles, and
permissions. Every action is audited. This complements the CLI below (which
stays available, e.g. for the first bootstrap admin).

| Method & path | Does |
|---------------|------|
| `GET /admin/users` · `POST /admin/users` | list · create (returns a temp password if none supplied) |
| `POST /admin/users/reset-password` | new temp password (revokes sessions) |
| `POST /admin/users/{activate,deactivate}` | toggle account |
| `POST /admin/users/{assign-role,revoke-role}` | `{username, role}` |
| `GET /admin/roles` · `POST /admin/roles` · `POST /admin/roles/delete` | list · create · delete (built-ins protected) |
| `POST /admin/roles/{grant,revoke}` | `{role, permission}` — edit any role's permissions |
| `GET /admin/permissions` · `POST /admin/permissions` | list · create a new permission code |

New permissions and roles created here are immediately usable: grant a permission
to a role, assign the role to a user, and the user's `authenticate()` resolves it.

**Lockout protection.** The server refuses any single change that would leave
**no active user holding `user:admin`** — deactivating the last admin, revoking
the last admin's admin-granting role, revoking `user:admin` from the last role
that grants it, or deleting that role. The operation is rolled back and returns
an error (the same guard applies to the CLI). It only triggers when an admin
currently exists, so a fresh database with no admin yet stays fully editable for
bootstrapping. Note: when the server runs **without `--auth`** the `user:admin`
gate is not enforced (all secured routes are open); admin mutations made that way
are attributed to an `anonymous (no-auth)` actor in the audit log.

## Managing users (CLI)

The same operations are available from the CLI (the only option before the admin
API, and still the way to bootstrap the first admin). Run from the server's data
directory (where `OpenReturn.db` lives):

```bash
openreturn users create alice --role editor          # prints a generated temp password
openreturn users create bob --role viewer --password '...'   # or set one explicitly
openreturn users set-password alice                  # prompt securely (getpass)
openreturn users reset-password alice                # new temp password, revokes sessions
openreturn users list
openreturn users activate alice / deactivate alice
openreturn users assign-role alice admin / revoke-role alice admin
openreturn users roles                               # roles and their permissions
openreturn users grant viewer org:write              # edit a role's permissions
openreturn users revoke viewer org:write
```

Every change is recorded in the [audit trail](#audit-trail).

On NixOS, set `services.openreturn.initialAdmin.passwordFile` to bootstrap the
first `admin` user from a credential file on first deploy (idempotent) — see the
[NixOS module](nixos.md#bootstrapping-the-admin-user). After that, manage users
with the CLI above.

## Securing a route (for contributors)

A route declares its required permission with the `permission=` argument; the
server enforces authentication, the permission, and rate limits before the
handler runs, and attaches the resolved caller to the request:

```python
@self.post('', permission='org:write')
def create_org(query_params, body, headers):
    actor = self._principal(headers)   # the authenticated user/program, or None
    ...                                # use actor for audit attribution
```

`secured=True` (without a `permission`) requires only a valid principal (any
permission). A route with neither is public.

## Audit trail

Every mutation records who did what in `audit_log`: the actor (`user` / `program`
/ `cli`), the action, the entity type and id, an optional JSON change summary, and
a timestamp. Mutating routes attribute the change to the authenticated caller;
CLI mutations are recorded as `cli`.

## Password & token handling

Passwords are hashed with stdlib **scrypt** and a per-user random salt (encoded as
`scrypt$n$r$p$salt$hash`). Session and API keys are high-entropy random tokens
stored only as their SHA-256 hash — the raw value is shown once and never
persisted. No external crypto dependency is used. See
[`src/auth.py`](../src/auth.py).
