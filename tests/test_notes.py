"""Tests for the shared org notes/updates concern (db.notes) and its router:
add/list/delete, author stamping, empty-body + unknown-org rejection, permission
seeding, and the org cascade."""

import os
import sys
import unittest
from unittest.mock import MagicMock

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

from auth import Principal
from database import OpenReturnDB
from router.Note import NoteRouter


def _user_actor(uid, label='alice'):
    return Principal(kind='user', actor_id=uid, label=label, permissions=frozenset(), user_id=uid)


def _program_actor():
    return Principal(kind='program', actor_id=1, label='svc', permissions=frozenset())


class TestNoteDB(unittest.TestCase):
    def setUp(self):
        self.db = OpenReturnDB(path=':memory:')
        self.db.cursor.execute("INSERT INTO organization (ein, name) VALUES ('100000001','Co')")
        self.db.connection.commit()
        self.uid = self.db.users.create_user('alice', 'pw', roles=['editor'])
        self.actor = _user_actor(self.uid)

    def tearDown(self):
        self.db.close()

    def test_add_and_list_stamps_author(self):
        n = self.db.notes.add_note('100000001', 'Met with the ED', actor=self.actor)
        self.assertEqual(n['body'], 'Met with the ED')
        self.assertEqual(n['author_label'], 'alice')
        self.assertEqual(n['author_user_id'], self.uid)
        self.assertTrue(n['created_at'])
        listed = self.db.notes.list_notes('100000001')
        self.assertEqual(len(listed), 1)
        self.assertEqual(listed[0]['note_id'], n['note_id'])

    def test_newest_first(self):
        a = self.db.notes.add_note('100000001', 'first', actor=self.actor)
        b = self.db.notes.add_note('100000001', 'second', actor=self.actor)
        ids = [r['note_id'] for r in self.db.notes.list_notes('100000001')]
        self.assertEqual(ids, [b['note_id'], a['note_id']])

    def test_body_trimmed_and_required(self):
        n = self.db.notes.add_note('100000001', '  padded  ', actor=self.actor)
        self.assertEqual(n['body'], 'padded')
        with self.assertRaises(ValueError):
            self.db.notes.add_note('100000001', '   ', actor=self.actor)

    def test_unknown_org_rejected(self):
        with self.assertRaises(ValueError):
            self.db.notes.add_note('999999999', 'x', actor=self.actor)

    def test_hyphenated_ein_normalizes(self):
        self.db.notes.add_note('10-0000001', 'x', actor=self.actor)
        self.assertEqual(len(self.db.notes.list_notes('100000001')), 1)

    def test_delete(self):
        n = self.db.notes.add_note('100000001', 'x', actor=self.actor)
        self.assertTrue(self.db.notes.delete_note(n['note_id'], actor=self.actor))
        self.assertEqual(self.db.notes.list_notes('100000001'), [])
        self.assertFalse(self.db.notes.delete_note(n['note_id'], actor=self.actor))

    def test_shared_across_users(self):
        # A note posted by alice is visible to everyone (notes are team-wide).
        self.db.notes.add_note('100000001', 'shared', actor=self.actor)
        self.assertEqual(len(self.db.notes.list_notes('100000001')), 1)

    def test_author_preserved_on_user_delete(self):
        n = self.db.notes.add_note('100000001', 'x', actor=self.actor)
        self.db.cursor.execute("DELETE FROM app_user WHERE user_id = ?", (self.uid,))
        self.db.connection.commit()
        row = self.db.notes.list_notes('100000001')[0]
        self.assertIsNone(row['author_user_id'])          # FK SET NULL
        self.assertEqual(row['author_label'], 'alice')    # label preserved
        self.assertEqual(row['note_id'], n['note_id'])

    def test_cascade_on_org_delete(self):
        self.db.notes.add_note('100000001', 'x', actor=self.actor)
        self.db.cursor.execute("DELETE FROM organization WHERE ein = '100000001'")
        self.db.connection.commit()
        self.assertEqual(
            self.db.cursor.execute("SELECT count(*) FROM org_note").fetchone()[0], 0)


class TestNotePermissionsSeeded(unittest.TestCase):
    def test_role_grants(self):
        db = OpenReturnDB(path=':memory:')
        try:
            self.assertIn('note:read', db.users.permissions_for_role('viewer'))
            self.assertNotIn('note:write', db.users.permissions_for_role('viewer'))
            self.assertIn('note:write', db.users.permissions_for_role('editor'))
            self.assertIn('note:read', db.users.permissions_for_role('service'))
            self.assertNotIn('note:write', db.users.permissions_for_role('service'))
        finally:
            db.close()


class TestNoteRouter(unittest.TestCase):
    def setUp(self):
        self.db = OpenReturnDB(path=':memory:')
        self.db.cursor.execute("INSERT INTO organization (ein, name) VALUES ('100000001','Co')")
        self.db.connection.commit()
        self.uid = self.db.users.create_user('alice', 'pw', roles=['editor'])
        self.router = NoteRouter(db=self.db)

    def tearDown(self):
        self.db.close()

    def _h(self, principal):
        h = MagicMock(); h.get.return_value = ""; h._principal = principal
        return h

    def _call(self, method, path, body=None, qp=None, principal=None):
        return self.router.routes[method][path](
            query_params=qp or {}, body=body, headers=self._h(principal))

    def test_permissions(self):
        self.assertEqual(self.router.routes['GET']['/notes']._permission, 'note:read')
        self.assertEqual(self.router.routes['POST']['/notes']._permission, 'note:write')
        self.assertEqual(self.router.routes['POST']['/notes/delete']._permission, 'note:write')

    def test_add_list_delete_flow(self):
        actor = _user_actor(self.uid)
        added = self._call('POST', '/notes', {'ein': '100000001', 'body': 'hello'}, principal=actor)
        self.assertEqual(added['body'], 'hello')
        listed = self._call('GET', '/notes', qp={'ein': ['100000001']}, principal=actor)
        self.assertEqual(len(listed['notes']), 1)
        out = self._call('POST', '/notes/delete', {'note_id': added['note_id']}, principal=actor)
        self.assertTrue(out['removed'])

    def test_list_requires_ein(self):
        self.assertIn('error', self._call('GET', '/notes', qp={}, principal=_user_actor(self.uid)))

    def test_add_requires_fields(self):
        self.assertIn('error', self._call('POST', '/notes', {'ein': '100000001'},
                                          principal=_user_actor(self.uid)))

    def test_delete_bad_id(self):
        self.assertIn('error', self._call('POST', '/notes/delete', {'note_id': 'abc'},
                                          principal=_user_actor(self.uid)))


if __name__ == '__main__':
    unittest.main()
