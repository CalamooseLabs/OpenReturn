"""Tests for the auth core: password hashing, the User concern (accounts, roles,
permissions, sessions, authenticate), the AuthRouter, and the `openreturn users`
CLI."""

import os
import sys
import types
import unittest
from contextlib import contextmanager
from pathlib import Path
from tempfile import TemporaryDirectory

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

import auth
import users as users_cli
from database import OpenReturnDB
from router.Auth import AuthRouter


class _Headers:
    """Minimal stand-in for the request headers object the server passes to a
    handler, carrying an optional Authorization token and resolved principal."""

    def __init__(self, authorization: str | None = None, principal=None):
        self._authorization = authorization
        if principal is not None:
            self._principal = principal

    def get(self, key, default=None):
        if key == 'Authorization':
            return self._authorization or ''
        return default


# ── password hashing ──────────────────────────────────────────────────────────

class TestPasswordHashing(unittest.TestCase):
    def test_roundtrip(self):
        enc = auth.hash_password("correct horse battery staple")
        self.assertTrue(enc.startswith("scrypt$"))
        self.assertTrue(auth.verify_password("correct horse battery staple", enc))

    def test_wrong_password_fails(self):
        enc = auth.hash_password("hunter2")
        self.assertFalse(auth.verify_password("hunter3", enc))

    def test_salt_is_random(self):
        self.assertNotEqual(auth.hash_password("x"), auth.hash_password("x"))

    def test_malformed_hash_returns_false(self):
        self.assertFalse(auth.verify_password("x", "not-a-hash"))

    def test_token_helpers(self):
        tok = auth.generate_token()
        self.assertEqual(auth.hash_token(tok), auth.hash_token(tok))
        self.assertNotEqual(auth.hash_token(tok), tok)


# ── User concern ────────────────────────────────────────────────────────────────

class TestUserDB(unittest.TestCase):
    def setUp(self):
        self.db = OpenReturnDB(path=':memory:')

    def tearDown(self):
        self.db.close()

    def test_builtin_roles_seeded(self):
        self.assertEqual({r['code'] for r in self.db.users.list_roles()},
                         {'admin', 'editor', 'viewer', 'service'})

    def test_create_and_permissions(self):
        uid = self.db.users.create_user('alice', 'pw', roles=['editor'])
        perms = self.db.users.user_permissions(uid)
        self.assertIn('org:write', perms)
        self.assertNotIn('user:admin', perms)

    def test_duplicate_username_raises(self):
        self.db.users.create_user('bob', 'pw')
        with self.assertRaises(ValueError):
            self.db.users.create_user('bob', 'pw2')

    def test_unknown_role_raises(self):
        with self.assertRaises(ValueError):
            self.db.users.create_user('carol', 'pw', roles=['wizard'])

    def test_unknown_role_leaves_no_orphan_user(self):
        # roles are resolved before the insert, so a bad role writes nothing
        with self.assertRaises(ValueError):
            self.db.users.create_user('carol', 'pw', roles=['admin', 'wizard'])
        self.assertIsNone(self.db.users.get_user('carol'))

    def test_login_unknown_user_returns_none(self):
        # (the dummy-hash path) — unknown user still returns None, no exception
        self.assertIsNone(self.db.users.login('ghost', 'whatever'))

    def test_login_authenticate_logout(self):
        self.db.users.create_user('dave', 'sekret', roles=['viewer'])
        self.assertIsNone(self.db.users.login('dave', 'wrong'))
        res = self.db.users.login('dave', 'sekret')
        self.assertIsNotNone(res)
        token = res['session_key']
        p = self.db.users.authenticate(token)
        self.assertEqual(p.kind, 'user')
        self.assertTrue(p.has('org:read'))
        self.assertFalse(p.has('org:write'))
        self.assertTrue(self.db.users.logout(token))
        self.assertIsNone(self.db.users.authenticate(token))

    def test_inactive_user_cannot_login_or_authenticate(self):
        self.db.users.create_user('eve', 'pw', roles=['viewer'])
        res = self.db.users.login('eve', 'pw')
        token = res['session_key']
        self.db.users.set_active('eve', False)
        self.assertIsNone(self.db.users.authenticate(token))   # sessions revoked
        self.assertIsNone(self.db.users.login('eve', 'pw'))    # login blocked

    def test_password_reset_revokes_sessions(self):
        self.db.users.create_user('frank', 'pw', roles=['viewer'])
        token = self.db.users.login('frank', 'pw')['session_key']
        temp = self.db.users.reset_password('frank')
        self.assertIsNotNone(temp)
        self.assertIsNone(self.db.users.authenticate(token))    # old session dead
        self.assertIsNotNone(self.db.users.login('frank', temp))  # new password works

    def test_assign_and_revoke_role(self):
        self.db.users.create_user('keeper', 'pw', roles=['admin'])   # standing admin
        uid = self.db.users.create_user('grace', 'pw')
        self.assertTrue(self.db.users.assign_role('grace', 'admin'))
        self.assertIn('user:admin', self.db.users.user_permissions(uid))
        self.assertTrue(self.db.users.revoke_role('grace', 'admin'))
        self.assertNotIn('user:admin', self.db.users.user_permissions(uid))
        self.assertFalse(self.db.users.assign_role('grace', 'nope'))

    def test_grant_and_revoke_permission_on_role(self):
        self.assertNotIn('org:write', self.db.users.permissions_for_role('viewer'))
        self.assertTrue(self.db.users.grant_permission('viewer', 'org:write'))
        self.assertIn('org:write', self.db.users.permissions_for_role('viewer'))
        self.assertTrue(self.db.users.revoke_permission('viewer', 'org:write'))
        self.assertNotIn('org:write', self.db.users.permissions_for_role('viewer'))

    def test_api_key_authenticates_as_program(self):
        _, raw = self.db.keys.create_api_key('frontend')  # default service role
        p = self.db.users.authenticate(raw)
        self.assertEqual(p.kind, 'program')
        self.assertTrue(p.has('org:read'))
        self.assertFalse(p.has('org:write'))

    def test_api_key_can_take_a_richer_role(self):
        _, raw = self.db.keys.create_api_key('admin-bot', role='editor')
        p = self.db.users.authenticate(raw)
        self.assertTrue(p.has('org:write'))

    def test_authenticate_none_token(self):
        self.assertIsNone(self.db.users.authenticate(None))
        self.assertIsNone(self.db.users.authenticate('garbage'))


# ── AuthRouter ────────────────────────────────────────────────────────────────

class TestAuthRouter(unittest.TestCase):
    def setUp(self):
        self.db = OpenReturnDB(path=':memory:')
        self.db.users.create_user('alice', 'pw', roles=['editor'])
        self.router = AuthRouter(db=self.db)

    def tearDown(self):
        self.db.close()

    def _call(self, method, path, body=None, headers=None):
        return self.router.routes[method][path](
            query_params={}, body=body, headers=headers or _Headers())

    def test_login_success_and_me(self):
        out = self._call('POST', '/auth/login', {'username': 'alice', 'password': 'pw'})
        self.assertIn('session_key', out)
        token = out['session_key']
        principal = self.db.users.authenticate(token)
        me = self._call('GET', '/auth/me', headers=_Headers(principal=principal))
        self.assertEqual(me['kind'], 'user')
        self.assertIn('org:write', me['permissions'])
        self.assertEqual(me['user']['username'], 'alice')

    def test_login_bad_credentials(self):
        out = self._call('POST', '/auth/login', {'username': 'alice', 'password': 'nope'})
        self.assertIn('error', out)
        self.assertNotIn('session_key', out)

    def test_login_missing_fields(self):
        out = self._call('POST', '/auth/login', {'username': 'alice'})
        self.assertIn('error', out)

    def test_logout(self):
        token = self._call('POST', '/auth/login',
                           {'username': 'alice', 'password': 'pw'})['session_key']
        out = self._call('POST', '/auth/logout',
                         headers=_Headers(authorization=f'Bearer {token}'))
        self.assertTrue(out['logged_out'])
        self.assertIsNone(self.db.users.authenticate(token))

    def test_login_is_public_logout_and_me_secured(self):
        self.assertFalse(self.router.routes['POST']['/auth/login']._secured)
        self.assertTrue(self.router.routes['POST']['/auth/logout']._secured)
        self.assertTrue(self.router.routes['GET']['/auth/me']._secured)


# ── CLI ──────────────────────────────────────────────────────────────────────

@contextmanager
def _cli_db():
    """Run inside a temp dir holding a fresh OpenReturn.db (what _require_db opens)."""
    cwd = os.getcwd()
    with TemporaryDirectory() as td:
        os.chdir(td)
        OpenReturnDB().close()  # creates ./OpenReturn.db with schema + seeds
        try:
            yield
        finally:
            os.chdir(cwd)


class TestUsersCLI(unittest.TestCase):
    def test_create_reset_list_assign(self):
        with _cli_db():
            rc = users_cli.cmd_create(types.SimpleNamespace(
                username='admin', role=['admin'], password='initpw'))
            self.assertEqual(rc, 0)
            # duplicate fails
            self.assertEqual(users_cli.cmd_create(types.SimpleNamespace(
                username='admin', role=None, password='x')), 1)
            # reset prints a new temp password and succeeds
            self.assertEqual(users_cli.cmd_reset_password(
                types.SimpleNamespace(username='admin')), 0)
            self.assertEqual(users_cli.cmd_reset_password(
                types.SimpleNamespace(username='ghost')), 1)
            # assign-role / list / roles
            self.assertEqual(users_cli.cmd_create(types.SimpleNamespace(
                username='val', role=None, password='pw')), 0)
            self.assertEqual(users_cli.cmd_assign_role(
                types.SimpleNamespace(username='val', role='viewer')), 0)
            self.assertEqual(users_cli.cmd_assign_role(
                types.SimpleNamespace(username='val', role='nope')), 1)
            self.assertEqual(users_cli.cmd_list(types.SimpleNamespace()), 0)
            self.assertEqual(users_cli.cmd_roles(types.SimpleNamespace()), 0)

    def test_skip_existing_and_password_file(self):
        with _cli_db():
            ns = lambda **k: types.SimpleNamespace(**k)  # noqa: E731
            self.assertEqual(users_cli.cmd_create(
                ns(username='admin', role=['admin'], password='pw',
                   password_file=None, skip_existing=False)), 0)
            # second create with --skip-existing is a no-op success
            self.assertEqual(users_cli.cmd_create(
                ns(username='admin', role=None, password='x',
                   password_file=None, skip_existing=True)), 0)
            # password-file path: the file's contents become the password
            with open('pw.txt', 'w') as fh:
                fh.write('  filepass  \n')
            self.assertEqual(users_cli.cmd_create(
                ns(username='fromfile', role=None, password=None,
                   password_file='pw.txt', skip_existing=False)), 0)
            db = OpenReturnDB()
            try:
                self.assertIsNotNone(db.users.login('fromfile', 'filepass'))
            finally:
                db.close()

    def test_grant_and_deactivate(self):
        with _cli_db():
            self.assertEqual(users_cli.cmd_grant(
                types.SimpleNamespace(role='viewer', permission='org:write')), 0)
            self.assertEqual(users_cli.cmd_grant(
                types.SimpleNamespace(role='viewer', permission='nope:nope')), 1)
            users_cli.cmd_create(types.SimpleNamespace(username='u', role=None, password='pw'))
            self.assertEqual(users_cli.cmd_deactivate(types.SimpleNamespace(username='u')), 0)
            self.assertEqual(users_cli.cmd_activate(types.SimpleNamespace(username='u')), 0)


if __name__ == '__main__':
    unittest.main()
