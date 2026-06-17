"""Tests for the People concern (editable people + org memberships) and the
PeopleRouter."""

import os
import sys
import unittest
from unittest.mock import MagicMock

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

from auth import Principal
from database import OpenReturnDB
from router.People import PeopleRouter


def _actor(label='alice'):
    return Principal(kind='user', actor_id=1, label=label, permissions=frozenset(), user_id=1)


class TestPeopleDB(unittest.TestCase):
    def setUp(self):
        self.db = OpenReturnDB(path=':memory:')
        self.db.orgs.create_org('364348917', 'Administer Justice')

    def tearDown(self):
        self.db.close()

    def test_create_and_get(self):
        p = self.db.people.create_person('Bruce Strom', email='b@aj.org', title='CEO',
                                         actor=_actor())
        self.assertEqual(p['full_name'], 'Bruce Strom')
        self.assertEqual(p['created_by'], 'alice')
        self.assertEqual(p['memberships'], [])
        got = self.db.people.get_person(p['person_id'])
        self.assertEqual(got['email'], 'b@aj.org')

    def test_create_requires_name(self):
        with self.assertRaises(ValueError):
            self.db.people.create_person('   ')

    def test_create_audited(self):
        p = self.db.people.create_person('X', actor=_actor('bob'))
        log = self.db.audit.list_log(entity_type='person', entity_id=p['person_id'])
        self.assertEqual(log[0]['action'], 'create')
        self.assertEqual(log[0]['actor_label'], 'bob')

    def test_update(self):
        p = self.db.people.create_person('Old Name', email='old@x.org')
        up = self.db.people.update_person(p['person_id'], {'full_name': 'New Name'}, actor=_actor())
        self.assertEqual(up['full_name'], 'New Name')
        self.assertEqual(up['email'], 'old@x.org')
        self.assertEqual(up['updated_by'], 'alice')

    def test_update_missing_returns_none(self):
        self.assertIsNone(self.db.people.update_person(999, {'full_name': 'X'}))

    def test_membership_add_list_remove(self):
        p = self.db.people.create_person('Bruce')
        m = self.db.people.add_membership(p['person_id'], '364348917',
                                          role_title='CEO', is_primary=True, actor=_actor())
        self.assertEqual(m['role_title'], 'CEO')
        self.assertTrue(m['is_primary'])
        # listed from the org side
        org_people = self.db.people.list_org_people('364348917')
        self.assertEqual(org_people[0]['full_name'], 'Bruce')
        self.assertEqual(org_people[0]['role_title'], 'CEO')
        # and from the person side (with org name)
        got = self.db.people.get_person(p['person_id'])
        self.assertEqual(got['memberships'][0]['org_name'], 'Administer Justice')
        # remove
        self.assertTrue(self.db.people.remove_membership(p['person_id'], '364348917'))
        self.assertEqual(self.db.people.list_org_people('364348917'), [])

    def test_membership_upsert_updates_role(self):
        p = self.db.people.create_person('Bruce')
        first = self.db.people.add_membership(p['person_id'], '364348917', role_title='CEO')
        second = self.db.people.add_membership(p['person_id'], '364348917', role_title='President')
        self.assertEqual(first['membership_id'], second['membership_id'])   # same row
        self.assertEqual(second['role_title'], 'President')

    def test_membership_unknown_person_or_org_raises(self):
        p = self.db.people.create_person('Bruce')
        with self.assertRaises(ValueError):
            self.db.people.add_membership(p['person_id'], '999999999')   # no such org
        with self.assertRaises(ValueError):
            self.db.people.add_membership(999, '364348917')              # no such person

    def test_delete_person_cascades_membership(self):
        p = self.db.people.create_person('Bruce')
        self.db.people.add_membership(p['person_id'], '364348917')
        self.assertTrue(self.db.people.delete_person(p['person_id'], actor=_actor()))
        self.assertEqual(self.db.people.list_org_people('364348917'), [])

    def test_deleting_org_cascades_membership(self):
        p = self.db.people.create_person('Bruce')
        self.db.people.add_membership(p['person_id'], '364348917')
        self.db.cursor.execute("DELETE FROM organization WHERE ein = '364348917'")
        self.db.commit()
        self.assertEqual(self.db.people.get_person(p['person_id'])['memberships'], [])


class TestPeopleRouter(unittest.TestCase):
    def setUp(self):
        self.db = MagicMock()
        self.router = PeopleRouter(db=self.db)

    def _h(self):
        h = MagicMock()
        h.get.return_value = ""
        return h

    def _call(self, method, path, query_params=None, body=None):
        return self.router.routes[method][path](
            query_params=query_params or {}, body=body, headers=self._h())

    def test_routes_registered(self):
        self.assertEqual(set(self.router.routes['GET']), {'/people', '/people/detail'})
        self.assertEqual(set(self.router.routes['POST']),
                         {'/people', '/people/edit', '/people/delete',
                          '/people/membership', '/people/membership/remove'})

    def test_permissions_declared(self):
        self.assertEqual(self.router.routes['GET']['/people']._permission, 'person:read')
        self.assertEqual(self.router.routes['POST']['/people']._permission, 'person:write')
        self.assertEqual(self.router.routes['POST']['/people/membership']._permission, 'person:write')

    def test_list_by_org(self):
        self.db.people.list_org_people.return_value = [{"full_name": "Bruce"}]
        out = self._call('GET', '/people', query_params={'ein': ['364348917']})
        self.assertEqual(out['ein'], '364348917')
        self.db.people.list_org_people.assert_called_once_with('364348917')

    def test_create_requires_full_name(self):
        self.assertIn('error', self._call('POST', '/people', body={'email': 'x@y.z'}))

    def test_membership_requires_person_and_ein(self):
        self.assertIn('error', self._call('POST', '/people/membership', body={'person_id': 1}))

    def test_membership_value_error_surfaces(self):
        self.db.people.add_membership.side_effect = ValueError("organization 999 not found")
        out = self._call('POST', '/people/membership', body={'person_id': 1, 'ein': '999'})
        self.assertIn('error', out)


if __name__ == '__main__':
    unittest.main()
