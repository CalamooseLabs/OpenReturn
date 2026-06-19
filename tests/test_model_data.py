"""Tests for the per-(org, model, year) annotations concern (db.model_data) and
its router: notes + custom fields, scoping by model/year, validation, permission
seeding, and the org cascade."""

import os
import sys
import unittest
from unittest.mock import MagicMock

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

from auth import Principal
from database import OpenReturnDB
from router.ModelData import ModelDataRouter


def _user_actor(uid, label='alice'):
    return Principal(kind='user', actor_id=uid, label=label, permissions=frozenset(), user_id=uid)


class TestModelDataDB(unittest.TestCase):
    def setUp(self):
        self.db = OpenReturnDB(path=':memory:')
        self.db.cursor.execute("INSERT INTO organization (ein, name) VALUES ('100000001','Co')")
        self.db.connection.commit()
        self.uid = self.db.users.create_user('alice', 'pw', roles=['editor'])
        self.actor = _user_actor(self.uid)

    def tearDown(self):
        self.db.close()

    def test_notes_scoped_by_model_and_year(self):
        self.db.model_data.add_note('100000001', '30', 2023, 'changed board', actor=self.actor)
        self.db.model_data.add_note('100000001', '30', 2022, 'older', actor=self.actor)
        self.db.model_data.add_note('100000001', '20', 2023, 'other model', actor=self.actor)
        g = self.db.model_data.get('100000001', '30', 2023)
        self.assertEqual([n['body'] for n in g['notes']], ['changed board'])
        self.assertEqual(g['notes'][0]['author_label'], 'alice')

    def test_fields_scoped_and_listed(self):
        self.db.model_data.add_field('100000001', '30', 2023, 'Site visit', '4/5', actor=self.actor)
        self.db.model_data.add_field('100000001', '30', 2023, 'Interview', None, actor=self.actor)
        g = self.db.model_data.get('100000001', '30', 2023)
        self.assertEqual({f['label'] for f in g['fields']}, {'Site visit', 'Interview'})
        # value-less field stored as None
        iv = next(f for f in g['fields'] if f['label'] == 'Interview')
        self.assertIsNone(iv['value'])

    def test_validation(self):
        with self.assertRaises(ValueError):
            self.db.model_data.add_note('100000001', '30', 2023, '   ', actor=self.actor)
        with self.assertRaises(ValueError):
            self.db.model_data.add_field('100000001', '30', 2023, '  ', 'x', actor=self.actor)
        with self.assertRaises(ValueError):
            self.db.model_data.add_note('100000001', '30', 'nope', 'x', actor=self.actor)
        with self.assertRaises(ValueError):
            self.db.model_data.add_note('999999999', '30', 2023, 'x', actor=self.actor)

    def test_delete(self):
        n = self.db.model_data.add_note('100000001', '30', 2023, 'x', actor=self.actor)
        f = self.db.model_data.add_field('100000001', '30', 2023, 'L', 'v', actor=self.actor)
        self.assertTrue(self.db.model_data.delete_note(n['note_id'], actor=self.actor))
        self.assertTrue(self.db.model_data.delete_field(f['field_id'], actor=self.actor))
        g = self.db.model_data.get('100000001', '30', 2023)
        self.assertEqual(g['notes'], [])
        self.assertEqual(g['fields'], [])

    def test_cascade_on_org_delete(self):
        self.db.model_data.add_note('100000001', '30', 2023, 'x', actor=self.actor)
        self.db.model_data.add_field('100000001', '30', 2023, 'L', 'v', actor=self.actor)
        self.db.cursor.execute("DELETE FROM organization WHERE ein = '100000001'")
        self.db.connection.commit()
        self.assertEqual(self.db.cursor.execute("SELECT count(*) FROM model_year_note").fetchone()[0], 0)
        self.assertEqual(self.db.cursor.execute("SELECT count(*) FROM model_year_field").fetchone()[0], 0)


class TestModelDataPermissionsSeeded(unittest.TestCase):
    def test_role_grants(self):
        db = OpenReturnDB(path=':memory:')
        try:
            self.assertIn('model_data:read', db.users.permissions_for_role('viewer'))
            self.assertNotIn('model_data:write', db.users.permissions_for_role('viewer'))
            self.assertIn('model_data:write', db.users.permissions_for_role('editor'))
            self.assertIn('model_data:read', db.users.permissions_for_role('service'))
            self.assertNotIn('model_data:write', db.users.permissions_for_role('service'))
        finally:
            db.close()


class TestModelDataRouter(unittest.TestCase):
    def setUp(self):
        self.db = OpenReturnDB(path=':memory:')
        self.db.cursor.execute("INSERT INTO organization (ein, name) VALUES ('100000001','Co')")
        self.db.connection.commit()
        self.uid = self.db.users.create_user('alice', 'pw', roles=['editor'])
        self.router = ModelDataRouter(db=self.db)

    def tearDown(self):
        self.db.close()

    def _h(self, principal):
        h = MagicMock(); h.get.return_value = ""; h._principal = principal
        return h

    def _call(self, method, path, body=None, qp=None, principal=None):
        return self.router.routes[method][path](
            query_params=qp or {}, body=body, headers=self._h(principal))

    def test_permissions(self):
        self.assertEqual(self.router.routes['GET']['/model-data']._permission, 'model_data:read')
        self.assertEqual(self.router.routes['POST']['/model-data/note']._permission, 'model_data:write')
        self.assertEqual(self.router.routes['POST']['/model-data/field']._permission, 'model_data:write')

    def test_flow(self):
        actor = _user_actor(self.uid)
        self._call('POST', '/model-data/note',
                   {'ein': '100000001', 'version': '30', 'year': 2023, 'body': 'hi'},
                   principal=actor)
        added = self._call('POST', '/model-data/field',
                           {'ein': '100000001', 'version': '30', 'year': 2023,
                            'label': 'Visit', 'value': 'good'}, principal=actor)
        got = self._call('GET', '/model-data',
                         qp={'ein': ['100000001'], 'version': ['30'], 'year': ['2023']},
                         principal=actor)
        self.assertEqual(len(got['notes']), 1)
        self.assertEqual(len(got['fields']), 1)
        out = self._call('POST', '/model-data/field/delete',
                         {'field_id': added['field_id']}, principal=actor)
        self.assertTrue(out['removed'])

    def test_get_requires_params(self):
        out = self._call('GET', '/model-data', qp={'ein': ['100000001']},
                         principal=_user_actor(self.uid))
        self.assertIn('error', out)


if __name__ == '__main__':
    unittest.main()
