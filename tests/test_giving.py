"""Tests for the shared giving concern (db.giving) and its router: record/list/
delete gifts, the by-year summary, amount/year coercion + validation, permission
seeding, and the org cascade."""

import os
import sys
import unittest
from unittest.mock import MagicMock

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

from auth import Principal
from database import OpenReturnDB
from router.Giving import GivingRouter


def _user_actor(uid, label='alice'):
    return Principal(kind='user', actor_id=uid, label=label, permissions=frozenset(), user_id=uid)


class TestGivingDB(unittest.TestCase):
    def setUp(self):
        self.db = OpenReturnDB(path=':memory:')
        self.db.cursor.execute("INSERT INTO organization (ein, name) VALUES ('100000001','Co')")
        self.db.connection.commit()
        self.uid = self.db.users.create_user('alice', 'pw', roles=['editor'])
        self.actor = _user_actor(self.uid)

    def tearDown(self):
        self.db.close()

    def test_add_and_summary(self):
        self.db.giving.add_gift('100000001', 1000, fiscal_year=2022, actor=self.actor)
        self.db.giving.add_gift('100000001', 2500.5, fiscal_year=2023, purpose='ops', actor=self.actor)
        self.db.giving.add_gift('100000001', 500, fiscal_year=2023, actor=self.actor)
        out = self.db.giving.list_giving('100000001')
        self.assertEqual(out['summary']['gift_count'], 3)
        self.assertEqual(out['summary']['total_amount'], 4000.5)
        # newest year first
        self.assertEqual([y['year'] for y in out['summary']['by_year']], [2023, 2022])
        self.assertEqual(out['summary']['by_year'][0]['amount'], 3000.5)

    def test_amount_coercion_and_validation(self):
        g = self.db.giving.add_gift('100000001', '750.25', fiscal_year='2021', actor=self.actor)
        self.assertEqual(g['amount'], 750.25)
        self.assertEqual(g['fiscal_year'], 2021)
        with self.assertRaises(ValueError):
            self.db.giving.add_gift('100000001', 'not-a-number', actor=self.actor)
        with self.assertRaises(ValueError):
            self.db.giving.add_gift('100000001', 100, fiscal_year='nope', actor=self.actor)

    def test_year_optional(self):
        g = self.db.giving.add_gift('100000001', 100, actor=self.actor)
        self.assertIsNone(g['fiscal_year'])
        # a gift with no year is counted but contributes no by-year bucket
        out = self.db.giving.list_giving('100000001')
        self.assertEqual(out['summary']['gift_count'], 1)
        self.assertEqual(out['summary']['by_year'], [])

    def test_unknown_org_rejected(self):
        with self.assertRaises(ValueError):
            self.db.giving.add_gift('999999999', 100, actor=self.actor)

    def test_delete(self):
        g = self.db.giving.add_gift('100000001', 100, actor=self.actor)
        self.assertTrue(self.db.giving.delete_gift(g['gift_id'], actor=self.actor))
        self.assertEqual(self.db.giving.list_giving('100000001')['gifts'], [])
        self.assertFalse(self.db.giving.delete_gift(g['gift_id'], actor=self.actor))

    def test_cascade_on_org_delete(self):
        self.db.giving.add_gift('100000001', 100, actor=self.actor)
        self.db.cursor.execute("DELETE FROM organization WHERE ein = '100000001'")
        self.db.connection.commit()
        self.assertEqual(self.db.cursor.execute("SELECT count(*) FROM giving").fetchone()[0], 0)


class TestGivingPermissionsSeeded(unittest.TestCase):
    def test_role_grants(self):
        db = OpenReturnDB(path=':memory:')
        try:
            self.assertIn('giving:read', db.users.permissions_for_role('viewer'))
            self.assertNotIn('giving:write', db.users.permissions_for_role('viewer'))
            self.assertIn('giving:write', db.users.permissions_for_role('editor'))
            self.assertIn('giving:read', db.users.permissions_for_role('service'))
            self.assertNotIn('giving:write', db.users.permissions_for_role('service'))
        finally:
            db.close()


class TestGivingRouter(unittest.TestCase):
    def setUp(self):
        self.db = OpenReturnDB(path=':memory:')
        self.db.cursor.execute("INSERT INTO organization (ein, name) VALUES ('100000001','Co')")
        self.db.connection.commit()
        self.uid = self.db.users.create_user('alice', 'pw', roles=['editor'])
        self.router = GivingRouter(db=self.db)

    def tearDown(self):
        self.db.close()

    def _h(self, principal):
        h = MagicMock(); h.get.return_value = ""; h._principal = principal
        return h

    def _call(self, method, path, body=None, qp=None, principal=None):
        return self.router.routes[method][path](
            query_params=qp or {}, body=body, headers=self._h(principal))

    def test_permissions(self):
        self.assertEqual(self.router.routes['GET']['/giving']._permission, 'giving:read')
        self.assertEqual(self.router.routes['POST']['/giving']._permission, 'giving:write')
        self.assertEqual(self.router.routes['POST']['/giving/delete']._permission, 'giving:write')

    def test_add_list_delete_flow(self):
        actor = _user_actor(self.uid)
        added = self._call('POST', '/giving',
                           {'ein': '100000001', 'amount': 1200, 'fiscal_year': 2023}, principal=actor)
        self.assertEqual(added['amount'], 1200)
        listed = self._call('GET', '/giving', qp={'ein': ['100000001']}, principal=actor)
        self.assertEqual(listed['summary']['gift_count'], 1)
        out = self._call('POST', '/giving/delete', {'gift_id': added['gift_id']}, principal=actor)
        self.assertTrue(out['removed'])

    def test_add_requires_fields(self):
        self.assertIn('error', self._call('POST', '/giving', {'ein': '100000001'},
                                          principal=_user_actor(self.uid)))

    def test_add_bad_amount(self):
        out = self._call('POST', '/giving', {'ein': '100000001', 'amount': 'x'},
                         principal=_user_actor(self.uid))
        self.assertIn('error', out)


if __name__ == '__main__':
    unittest.main()
