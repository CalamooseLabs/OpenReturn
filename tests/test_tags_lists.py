"""Tests for the Tags and Lists concerns (static + smart-by-tag lists, private/
public visibility) and their routers."""

import os
import sys
import unittest
from unittest.mock import MagicMock

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

from auth import Principal
from database import OpenReturnDB
from database.Lists.lists import PermissionError_
from router.Tags import TagsRouter
from router.Lists import ListsRouter


def _actor(label='alice', user_id=1):
    return Principal(kind='user', actor_id=user_id, label=label,
                     permissions=frozenset(), user_id=user_id)


class TestTagsDB(unittest.TestCase):
    def setUp(self):
        self.db = OpenReturnDB(path=':memory:')
        for ein, name in [('364348917', 'Administer Justice'), ('111111111', 'Beta')]:
            self.db.orgs.create_org(ein, name)

    def tearDown(self):
        self.db.close()

    def test_apply_and_list(self):
        self.db.tags.apply_tag('364348917', 'prospect', actor=_actor())
        self.db.tags.apply_tag('364348917', 'midwest', actor=_actor())
        self.assertEqual(set(self.db.tags.org_tags('364348917')), {'prospect', 'midwest'})
        tags = {t['name']: t['org_count'] for t in self.db.tags.list_tags()}
        self.assertEqual(tags['prospect'], 1)

    def test_apply_is_idempotent_and_case_insensitive(self):
        self.db.tags.apply_tag('364348917', 'Prospect')
        self.db.tags.apply_tag('364348917', 'prospect')   # same tag (NOCASE)
        self.assertEqual(len(self.db.tags.list_tags()), 1)

    def test_apply_unknown_org_raises(self):
        with self.assertRaises(ValueError):
            self.db.tags.apply_tag('999999999', 'x')

    def test_remove(self):
        self.db.tags.apply_tag('364348917', 'prospect')
        self.assertTrue(self.db.tags.remove_tag('364348917', 'prospect'))
        self.assertEqual(self.db.tags.org_tags('364348917'), [])

    def test_orgs_with_tags_any_and_all(self):
        self.db.tags.apply_tag('364348917', 'prospect')
        self.db.tags.apply_tag('364348917', 'midwest')
        self.db.tags.apply_tag('111111111', 'prospect')
        self.assertEqual(set(self.db.tags.orgs_with_tags(['prospect'])), {'364348917', '111111111'})
        self.assertEqual(self.db.tags.orgs_with_tags(['prospect', 'midwest'], match='all'),
                         ['364348917'])

    def test_apply_audited(self):
        self.db.tags.apply_tag('364348917', 'prospect', actor=_actor('bob'))
        log = self.db.audit.list_log(entity_type='org_tag')
        self.assertEqual(log[0]['actor_label'], 'bob')


class TestListsDB(unittest.TestCase):
    def setUp(self):
        self.db = OpenReturnDB(path=':memory:')
        self.db.users.create_user('u1', 'pw')   # user_id 1 (list owner FK target)
        self.db.users.create_user('u2', 'pw')   # user_id 2
        for ein, name in [('364348917', 'Administer Justice'), ('111111111', 'Beta')]:
            self.db.orgs.create_org(ein, name)

    def tearDown(self):
        self.db.close()

    def test_static_list_members(self):
        lst = self.db.lists.create_list('Watchlist', owner_user_id=1, actor=_actor())
        self.db.lists.add_member(lst['list_id'], '364348917', viewer_user_id=1, actor=_actor())
        members = self.db.lists.list_members(lst['list_id'], viewer_user_id=1)
        self.assertEqual([m['ein'] for m in members], ['364348917'])

    def test_private_list_hidden_from_others(self):
        lst = self.db.lists.create_list('Mine', owner_user_id=1, visibility='private', actor=_actor())
        self.assertIsNotNone(self.db.lists.get_list(lst['list_id'], viewer_user_id=1))
        self.assertIsNone(self.db.lists.get_list(lst['list_id'], viewer_user_id=2))  # other user
        self.assertIsNone(self.db.lists.get_list(lst['list_id'], viewer_user_id=None))  # program

    def test_public_list_visible_to_all(self):
        lst = self.db.lists.create_list('Shared', owner_user_id=1, visibility='public', actor=_actor())
        self.assertIsNotNone(self.db.lists.get_list(lst['list_id'], viewer_user_id=2))
        self.assertIsNotNone(self.db.lists.get_list(lst['list_id'], viewer_user_id=None))

    def test_list_lists_shows_public_and_own(self):
        self.db.lists.create_list('A-private', owner_user_id=1, visibility='private', actor=_actor())
        self.db.lists.create_list('B-public', owner_user_id=2, visibility='public', actor=_actor('x', 2))
        self.db.lists.create_list('C-other-private', owner_user_id=2, visibility='private', actor=_actor('x', 2))
        names = {ls['name'] for ls in self.db.lists.list_lists(viewer_user_id=1)}
        self.assertEqual(names, {'A-private', 'B-public'})

    def test_private_requires_owner(self):
        with self.assertRaises(ValueError):
            self.db.lists.create_list('NoOwner', owner_user_id=None, visibility='private')

    def test_smart_list_resolves_by_tag(self):
        self.db.tags.apply_tag('364348917', 'prospect')
        lst = self.db.lists.create_list(
            'Prospects', owner_user_id=1, visibility='public', kind='smart',
            definition={'tags': ['prospect'], 'match': 'any'}, actor=_actor())
        members = self.db.lists.list_members(lst['list_id'], viewer_user_id=1)
        self.assertEqual([m['ein'] for m in members], ['364348917'])
        # tagging another org updates the smart list automatically
        self.db.tags.apply_tag('111111111', 'prospect')
        members = self.db.lists.list_members(lst['list_id'], viewer_user_id=1)
        self.assertEqual({m['ein'] for m in members}, {'364348917', '111111111'})

    def test_smart_list_requires_tags(self):
        with self.assertRaises(ValueError):
            self.db.lists.create_list('Bad', owner_user_id=1, kind='smart', definition={})

    def test_smart_definition_must_be_well_formed(self):
        for bad in (None, {'tags': 'prospect'}, {'tags': []}, {'tags': [1, 2]}, 'nope'):
            with self.assertRaises(ValueError):
                self.db.lists.create_list('Bad', owner_user_id=1, kind='smart', definition=bad)

    def test_non_owner_cannot_edit_even_null_owner(self):
        # a program-owned (NULL owner) public list is not editable by a user
        lst = self.db.lists.create_list('Sys', owner_user_id=None, visibility='public', actor=None)
        with self.assertRaises(PermissionError_):
            self.db.lists.update_list(lst['list_id'], {'name': 'X'}, viewer_user_id=1)

    def test_cannot_add_member_to_smart_list(self):
        lst = self.db.lists.create_list('S', owner_user_id=1, kind='smart',
                                        definition={'tags': ['x']}, actor=_actor())
        with self.assertRaises(ValueError):
            self.db.lists.add_member(lst['list_id'], '364348917', viewer_user_id=1)

    def test_non_owner_cannot_edit(self):
        lst = self.db.lists.create_list('Mine', owner_user_id=1, visibility='public', actor=_actor())
        with self.assertRaises(PermissionError_):
            self.db.lists.update_list(lst['list_id'], {'name': 'Hacked'}, viewer_user_id=2)

    def test_owner_can_edit_and_delete(self):
        lst = self.db.lists.create_list('Mine', owner_user_id=1, actor=_actor())
        up = self.db.lists.update_list(lst['list_id'], {'name': 'Renamed'}, viewer_user_id=1, actor=_actor())
        self.assertEqual(up['name'], 'Renamed')
        self.assertTrue(self.db.lists.delete_list(lst['list_id'], viewer_user_id=1, actor=_actor()))


class TestTagsListsRouters(unittest.TestCase):
    def _h(self, principal=None):
        h = MagicMock()
        h.get.return_value = ""
        if principal is not None:
            h._principal = principal
        return h

    def test_tags_routes_and_permissions(self):
        r = TagsRouter(db=MagicMock())
        self.assertEqual(set(r.routes['GET']), {'/tags', '/tags/organizations'})
        self.assertEqual(set(r.routes['POST']), {'/tags', '/tags/remove'})
        self.assertEqual(r.routes['POST']['/tags']._permission, 'tag:write')
        self.assertEqual(r.routes['GET']['/tags']._permission, 'tag:read')

    def test_lists_routes_and_permissions(self):
        r = ListsRouter(db=MagicMock())
        self.assertEqual(set(r.routes['GET']), {'/lists', '/lists/detail'})
        self.assertEqual(set(r.routes['POST']),
                         {'/lists', '/lists/edit', '/lists/delete',
                          '/lists/members/add', '/lists/members/remove'})
        self.assertEqual(r.routes['POST']['/lists']._permission, 'list:write')

    def test_list_create_passes_owner_from_principal(self):
        db = MagicMock()
        r = ListsRouter(db=db)
        r.routes['POST']['/lists'](query_params={}, body={'name': 'X'},
                                   headers=self._h(_actor(user_id=7)))
        _, kwargs = db.lists.create_list.call_args
        self.assertEqual(kwargs['owner_user_id'], 7)

    def test_tag_apply_requires_fields(self):
        r = TagsRouter(db=MagicMock())
        out = r.routes['POST']['/tags'](query_params={}, body={'ein': '1'}, headers=self._h())
        self.assertIn('error', out)


if __name__ == '__main__':
    unittest.main()
