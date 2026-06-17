"""Tests for the admin HTTP management surface (users/roles/permissions) and the
new db.users role/permission-creation methods."""

import os
import sys
import unittest
from unittest.mock import MagicMock

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

from auth import Principal
from database import OpenReturnDB
from router.Admin import AdminRouter


def _admin_headers():
    h = MagicMock()
    h.get.return_value = ""
    h._principal = Principal(kind='user', actor_id=1, label='root',
                             permissions=frozenset({'user:admin'}), user_id=1)
    return h


class TestUserAdminDB(unittest.TestCase):
    def setUp(self):
        self.db = OpenReturnDB(path=':memory:')

    def tearDown(self):
        self.db.close()

    def test_create_role_and_grant(self):
        self.db.users.create_role('analyst', 'Analyst', 'Read + score')
        self.assertIn('analyst', {r['code'] for r in self.db.users.list_roles()})
        self.assertTrue(self.db.users.grant_permission('analyst', 'org:read'))
        perms = next(r['permissions'] for r in self.db.users.list_roles() if r['code'] == 'analyst')
        self.assertIn('org:read', perms)

    def test_create_duplicate_role_raises(self):
        self.db.users.create_role('analyst', 'Analyst')
        with self.assertRaises(ValueError):
            self.db.users.create_role('analyst', 'Dup')

    def test_delete_role_blocks_builtin(self):
        with self.assertRaises(ValueError):
            self.db.users.delete_role('admin')          # built-in
        self.db.users.create_role('temp', 'Temp')
        self.assertTrue(self.db.users.delete_role('temp'))
        self.assertFalse(self.db.users.delete_role('temp'))   # already gone

    def test_create_permission(self):
        self.db.users.create_permission('report:export', 'Export reports')
        self.assertIn('report:export', {p['code'] for p in self.db.users.list_permissions()})
        with self.assertRaises(ValueError):
            self.db.users.create_permission('report:export')

    def test_new_permission_is_grantable_and_resolves(self):
        self.db.users.create_permission('report:export')
        self.db.users.create_role('reporter')
        self.db.users.grant_permission('reporter', 'report:export')
        uid = self.db.users.create_user('r', 'pw', roles=['reporter'])
        self.assertIn('report:export', self.db.users.user_permissions(uid))


class TestAdminRouter(unittest.TestCase):
    def setUp(self):
        self.db = OpenReturnDB(path=':memory:')
        self.router = AdminRouter(db=self.db)

    def tearDown(self):
        self.db.close()

    def _call(self, method, path, body=None):
        return self.router.routes[method][path](
            query_params={}, body=body, headers=_admin_headers())

    def test_every_route_requires_user_admin(self):
        for method in ('GET', 'POST'):
            for path, fn in self.router.routes[method].items():
                self.assertEqual(fn._permission, 'user:admin', f"{method} {path}")

    def test_create_user_over_http(self):
        out = self._call('POST', '/admin/users',
                         {'username': 'newbie', 'roles': ['viewer']})
        self.assertEqual(out['username'], 'newbie')
        self.assertIn('temporary_password', out)        # generated since none supplied
        self.assertIsNotNone(self.db.users.get_user('newbie'))

    def test_create_user_audited(self):
        self._call('POST', '/admin/users', {'username': 'audited'})
        log = self.db.audit.list_log(entity_type='user', entity_id='audited')
        self.assertEqual(log[0]['actor_label'], 'root')

    def test_reset_password_over_http(self):
        self.db.users.create_user('bob', 'pw')
        out = self._call('POST', '/admin/users/reset-password', {'username': 'bob'})
        self.assertIn('temporary_password', out)
        self.assertIsNotNone(self.db.users.login('bob', out['temporary_password']))

    def test_create_role_grant_and_assign_flow(self):
        self._call('POST', '/admin/permissions', {'code': 'report:export'})
        self._call('POST', '/admin/roles', {'code': 'reporter', 'name': 'Reporter'})
        self._call('POST', '/admin/roles/grant', {'role': 'reporter', 'permission': 'report:export'})
        self._call('POST', '/admin/users', {'username': 'rita', 'roles': ['reporter']})
        uid = self.db.users.get_user('rita')['user_id']
        self.assertIn('report:export', self.db.users.user_permissions(uid))

    def test_delete_builtin_role_errors(self):
        out = self._call('POST', '/admin/roles/delete', {'code': 'admin'})
        self.assertIn('error', out)

    def test_create_model_from_definition(self):
        defn = {"model": {"version": 77, "type": "financial"},
                "factor": [{"name": "PE", "weight": 1.0, "formula_type": "ratio",
                            "inputs": ["prog", "total_exp"], "direction": "higher",
                            "benchmark_lo": 0.0, "benchmark_hi": 1.0}]}
        out = self._call('POST', '/admin/models', {'definition': defn})
        self.assertEqual(out['version'], 77)
        self.assertIn(77, {m['version'] for m in self._call('GET', '/admin/models')['models']})
        log = self.db.audit.list_log(entity_type='score_model', entity_id='77')
        self.assertEqual(log[0]['actor_label'], 'root')

    def test_create_model_dry_run_and_errors(self):
        defn = {"model": {"version": 78},
                "factor": [{"name": "PE", "weight": 1.0, "formula_type": "ratio",
                            "inputs": ["prog", "total_exp"], "direction": "higher",
                            "benchmark_lo": 0.0, "benchmark_hi": 1.0}]}
        dry = self._call('POST', '/admin/models', {'definition': defn, 'dry_run': True})
        self.assertTrue(dry['dry_run'])
        self.assertEqual([m['version'] for m in self._call('GET', '/admin/models')['models']
                          if m['version'] == 78], [])   # not written
        self._call('POST', '/admin/models', {'definition': defn})           # real create
        self.assertIn('error', self._call('POST', '/admin/models', {'definition': defn}))  # dup
        self.assertEqual(self._call('POST', '/admin/models',
                                    {'definition': defn, 'skip_existing': True})['skipped'], True)
        self.assertIn('error', self._call('POST', '/admin/models',
                                          {'definition': {'model': {}, 'factor': []}}))
        self.assertIn('error', self._call('POST', '/admin/models', {}))   # missing definition

    def test_assign_unknown_role_errors(self):
        self.db.users.create_user('x', 'pw')
        out = self._call('POST', '/admin/users/assign-role', {'username': 'x', 'role': 'ghost'})
        self.assertIn('error', out)

    def test_audit_without_principal_attributes_anonymous(self):
        # Reached without --auth (no principal on the request): the mutation is
        # attributed to the anonymous sentinel, not silently logged as a CLI action.
        h = MagicMock(); h.get.return_value = ""; h._principal = None
        self.router.routes['POST']['/admin/users'](
            query_params={}, body={'username': 'noauth'}, headers=h)
        log = self.db.audit.list_log(entity_type='user', entity_id='noauth')
        self.assertEqual(log[0]['actor_kind'], 'anonymous')
        self.assertEqual(log[0]['actor_label'], 'anonymous (no-auth)')

    def test_revoke_last_admin_role_over_http_errors(self):
        self.db.users.create_user('root', 'pw', roles=['admin'])
        out = self._call('POST', '/admin/users/revoke-role', {'username': 'root', 'role': 'admin'})
        self.assertIn('error', out)
        self.assertIn('admin', self.db.users.get_user('root')['roles'])   # rolled back

    def test_revoke_user_admin_permission_over_http_errors(self):
        self.db.users.create_user('root', 'pw', roles=['admin'])
        out = self._call('POST', '/admin/roles/revoke', {'role': 'admin', 'permission': 'user:admin'})
        self.assertIn('error', out)

    def test_deactivate_last_admin_over_http_errors(self):
        self.db.users.create_user('root', 'pw', roles=['admin'])
        out = self._call('POST', '/admin/users/deactivate', {'username': 'root'})
        self.assertIn('error', out)
        self.assertTrue(self.db.users.get_user('root')['is_active'])


class TestAdminLockoutProtection(unittest.TestCase):
    """The db.users guards that refuse to leave the system with no active admin."""

    def setUp(self):
        self.db = OpenReturnDB(path=':memory:')
        self.db.users.create_user('root', 'pw', roles=['admin'])   # the lone admin

    def tearDown(self):
        self.db.close()

    def test_cannot_deactivate_last_admin(self):
        with self.assertRaises(ValueError):
            self.db.users.set_active('root', False)
        self.assertTrue(self.db.users.get_user('root')['is_active'])

    def test_cannot_revoke_last_admin_role(self):
        with self.assertRaises(ValueError):
            self.db.users.revoke_role('root', 'admin')
        self.assertIn('admin', self.db.users.get_user('root')['roles'])

    def test_cannot_revoke_user_admin_from_last_role(self):
        with self.assertRaises(ValueError):
            self.db.users.revoke_permission('admin', 'user:admin')
        self.assertIn('user:admin', self.db.users.permissions_for_role('admin'))

    def test_cannot_delete_the_last_admin_granting_role(self):
        # Route the sole admin through a custom role, then try to delete it.
        self.db.users.create_role('super', 'Super')
        self.db.users.grant_permission('super', 'user:admin')
        self.db.users.assign_role('root', 'super')
        self.db.users.revoke_role('root', 'admin')      # 'super' is now the only path
        with self.assertRaises(ValueError):
            self.db.users.delete_role('super')
        self.assertIn('user:admin', self.db.users.user_permissions(
            self.db.users.get_user('root')['user_id']))

    def test_second_admin_allows_removing_the_first(self):
        self.db.users.create_user('root2', 'pw', roles=['admin'])
        self.assertTrue(self.db.users.set_active('root', False))
        self.assertFalse(self.db.users.get_user('root')['is_active'])


if __name__ == '__main__':
    unittest.main()
