"""Tests for the per-user follow / watchlist concern (db.follows) and its router:
follow/unfollow semantics (idempotent, user-only), the watchlist + type filter,
the `following` flag, permission seeding, and cascade behavior."""

import os
import sys
import unittest
from unittest.mock import MagicMock

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

from auth import Principal
from database import OpenReturnDB
from router.Follow import FollowRouter


def _user_actor(uid, label='alice'):
    return Principal(kind='user', actor_id=uid, label=label, permissions=frozenset(), user_id=uid)


def _program_actor():
    return Principal(kind='program', actor_id=1, label='svc', permissions=frozenset())


class TestFollowDB(unittest.TestCase):
    def setUp(self):
        self.db = OpenReturnDB(path=':memory:')
        c = self.db.cursor
        c.execute("INSERT INTO organization (ein, name, org_type) VALUES ('100000001','Found Co','foundation')")
        c.execute("INSERT INTO organization (ein, name, org_type) VALUES ('100000002','Charity Co','nonprofit')")
        self.db.connection.commit()
        self.uid = self.db.users.create_user('alice', 'pw', roles=['viewer'])
        self.actor = _user_actor(self.uid)

    def tearDown(self):
        self.db.close()

    def test_follow_is_idempotent_and_per_user(self):
        self.assertTrue(self.db.follows.follow_org('100000001', actor=self.actor))
        self.assertTrue(self.db.follows.follow_org('100000001', actor=self.actor))  # no-op, still True
        self.assertTrue(self.db.follows.is_following(self.uid, '100000001'))
        self.assertEqual(self.db.follows.follower_count('100000001'), 1)
        bob = _user_actor(self.db.users.create_user('bob', 'pw'), 'bob')
        self.assertFalse(self.db.follows.is_following(bob.user_id, '100000001'))

    def test_hyphenated_ein_normalizes(self):
        self.db.follows.follow_org('10-0000001', actor=self.actor)
        self.assertTrue(self.db.follows.is_following(self.uid, '100000001'))

    def test_unfollow(self):
        self.db.follows.follow_org('100000001', actor=self.actor)
        self.assertTrue(self.db.follows.unfollow_org('100000001', actor=self.actor))
        self.assertFalse(self.db.follows.is_following(self.uid, '100000001'))
        self.assertFalse(self.db.follows.unfollow_org('100000001', actor=self.actor))  # already gone

    def test_program_cannot_follow(self):
        with self.assertRaises(ValueError):
            self.db.follows.follow_org('100000001', actor=_program_actor())
        self.assertFalse(self.db.follows.unfollow_org('100000001', actor=_program_actor()))

    def test_unknown_org_rejected(self):
        with self.assertRaises(ValueError):
            self.db.follows.follow_org('999999999', actor=self.actor)

    def test_list_followed_and_type_filter(self):
        self.db.follows.follow_org('100000001', actor=self.actor)
        self.db.follows.follow_org('100000002', actor=self.actor)
        allf = self.db.follows.list_followed(self.uid)
        self.assertEqual({o['ein'] for o in allf}, {'100000001', '100000002'})
        self.assertTrue(all(o['following'] for o in allf))
        founds = self.db.follows.list_followed(self.uid, org_type='foundation')
        self.assertEqual([o['ein'] for o in founds], ['100000001'])

    def test_followed_eins_batch(self):
        self.db.follows.follow_org('100000001', actor=self.actor)
        self.assertEqual(
            self.db.follows.followed_eins(self.uid, ['100000001', '100000002']), {'100000001'})
        self.assertEqual(self.db.follows.followed_eins(None, ['100000001']), set())

    def test_cascade_on_user_delete(self):
        self.db.follows.follow_org('100000001', actor=self.actor)
        self.db.cursor.execute("DELETE FROM app_user WHERE user_id = ?", (self.uid,))
        self.db.connection.commit()
        self.assertEqual(self.db.follows.follower_count('100000001'), 0)

    def test_viewer_none_returns_empty(self):
        self.assertEqual(self.db.follows.list_followed(None), [])
        self.assertFalse(self.db.follows.is_following(None, '100000001'))


class TestFollowPermissionsSeeded(unittest.TestCase):
    def test_roles_have_follow_permissions(self):
        db = OpenReturnDB(path=':memory:')
        try:
            self.assertEqual(db.users.permissions_for_role('viewer') & {'follow:read', 'follow:write'},
                             {'follow:read', 'follow:write'})
            self.assertIn('follow:read', db.users.permissions_for_role('service'))
            self.assertNotIn('follow:write', db.users.permissions_for_role('service'))
            self.assertIn('follow:write', db.users.permissions_for_role('admin'))
        finally:
            db.close()


class TestFollowRouter(unittest.TestCase):
    def setUp(self):
        self.db = OpenReturnDB(path=':memory:')
        self.db.cursor.execute("INSERT INTO organization (ein, name) VALUES ('100000001','Co')")
        self.db.connection.commit()
        self.uid = self.db.users.create_user('alice', 'pw', roles=['viewer'])
        self.router = FollowRouter(db=self.db)

    def tearDown(self):
        self.db.close()

    def _h(self, principal):
        h = MagicMock(); h.get.return_value = ""; h._principal = principal
        return h

    def _call(self, method, path, body=None, principal=None):
        return self.router.routes[method][path](
            query_params={}, body=body, headers=self._h(principal))

    def test_permissions(self):
        self.assertEqual(self.router.routes['GET']['/follows']._permission, 'follow:read')
        self.assertEqual(self.router.routes['POST']['/follows/follow']._permission, 'follow:write')

    def test_follow_unfollow_flow(self):
        actor = _user_actor(self.uid)
        out = self._call('POST', '/follows/follow', {'ein': '100000001'}, actor)
        self.assertTrue(out['following'])
        listed = self.router.routes['GET']['/follows'](
            query_params={}, body=None, headers=self._h(actor))
        self.assertEqual([o['ein'] for o in listed['organizations']], ['100000001'])
        out = self._call('POST', '/follows/unfollow', {'ein': '100000001'}, actor)
        self.assertFalse(out['following'])
        self.assertTrue(out['removed'])

    def test_follow_requires_ein(self):
        self.assertIn('error', self._call('POST', '/follows/follow', {}, _user_actor(self.uid)))

    def test_unfollow_requires_ein(self):
        self.assertIn('error', self._call('POST', '/follows/unfollow', {}, _user_actor(self.uid)))

    def test_program_follow_errors(self):
        out = self._call('POST', '/follows/follow', {'ein': '100000001'}, _program_actor())
        self.assertIn('error', out)

    def test_program_watchlist_empty(self):
        out = self.router.routes['GET']['/follows'](
            query_params={}, body=None, headers=self._h(_program_actor()))
        self.assertEqual(out['organizations'], [])


if __name__ == '__main__':
    unittest.main()
