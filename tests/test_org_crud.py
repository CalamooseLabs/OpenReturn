"""Tests for editable organizations: create_org / update_org (EIN validation,
physical + mailing addresses, contact fields) and the audit trail."""

import os
import sys
import unittest

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

from auth import Principal
from database import OpenReturnDB


def _actor(label='alice'):
    return Principal(kind='user', actor_id=1, label=label, permissions=frozenset(), user_id=1)


class TestOrgCrud(unittest.TestCase):
    def setUp(self):
        self.db = OpenReturnDB(path=':memory:')

    def tearDown(self):
        self.db.close()

    def test_normalize_ein(self):
        n = self.db.orgs.normalize_ein
        self.assertEqual(n('364348917'), '364348917')
        self.assertEqual(n('36-4348917'), '364348917')
        for bad in ('123', '36434891', '36434891X', '1234567890', None, ''):
            with self.assertRaises(ValueError):
                n(bad)

    def test_create_with_rich_fields(self):
        org = self.db.orgs.create_org(
            '36-4348917', 'Administer Justice', website='https://aj.org',
            main_email='info@aj.org',
            physical_address={'street': '1 Main', 'city': 'Elgin', 'state': 'il', 'zip': '60120'},
            mailing_address={'street': 'PO Box 9', 'city': 'Elgin', 'state': 'IL', 'zip': '60121'},
            actor=_actor())
        self.assertEqual(org['ein'], '364348917')
        self.assertEqual(org['website'], 'https://aj.org')
        self.assertEqual(org['main_email'], 'info@aj.org')
        self.assertEqual(org['address']['city'], 'Elgin')
        self.assertEqual(org['address']['state'], 'IL')          # normalized upper
        self.assertEqual(org['mailing_address']['street'], 'PO Box 9')
        self.assertEqual(org['created_by'], 'alice')

    def test_create_duplicate_raises(self):
        self.db.orgs.create_org('364348917', 'AJ')
        with self.assertRaises(ValueError):
            self.db.orgs.create_org('364348917', 'AJ again')

    def test_create_bad_ein_raises(self):
        with self.assertRaises(ValueError):
            self.db.orgs.create_org('not-an-ein', 'X')

    def test_create_requires_name(self):
        with self.assertRaises(ValueError):
            self.db.orgs.create_org('364348917', '   ')

    def test_create_writes_audit(self):
        self.db.orgs.create_org('364348917', 'AJ', actor=_actor('bob'))
        log = self.db.audit.list_log(entity_type='organization', entity_id='364348917')
        self.assertEqual(log[0]['action'], 'create')
        self.assertEqual(log[0]['actor_label'], 'bob')

    def test_update_changes_only_present_fields(self):
        self.db.orgs.create_org('364348917', 'AJ', website='old.org', main_email='a@aj.org')
        org = self.db.orgs.update_org('364348917', {'website': 'new.org'}, actor=_actor())
        self.assertEqual(org['website'], 'new.org')
        self.assertEqual(org['main_email'], 'a@aj.org')          # untouched
        self.assertEqual(org['updated_by'], 'alice')

    def test_update_name_reindexes_search(self):
        self.db.orgs.create_org('364348917', 'Original Name')
        self.db.orgs.update_org('364348917', {'name': 'Renamed Org'}, actor=_actor())
        res = self.db.orgs.search_organizations('Renamed', fuzzy=True)
        self.assertTrue(any(o['ein'] == '364348917' for o in res['organizations']))

    def test_update_adds_mailing_address(self):
        self.db.orgs.create_org('364348917', 'AJ')
        org = self.db.orgs.update_org(
            '364348917', {'mailing_address': {'city': 'Elgin', 'state': 'IL'}}, actor=_actor())
        self.assertEqual(org['mailing_address']['city'], 'Elgin')

    def test_update_missing_org_returns_none(self):
        self.assertIsNone(self.db.orgs.update_org('999999999', {'name': 'X'}))

    def test_update_writes_audit(self):
        self.db.orgs.create_org('364348917', 'AJ')
        self.db.orgs.update_org('364348917', {'name': 'AJ2'}, actor=_actor('carol'))
        log = self.db.audit.list_log(entity_type='organization', entity_id='364348917')
        self.assertEqual(log[0]['action'], 'update')             # most recent first
        self.assertEqual(log[0]['actor_label'], 'carol')

    def test_set_favorite_is_audited(self):
        self.db.orgs.create_org('364348917', 'AJ')
        self.assertTrue(self.db.orgs.set_favorite('364348917', True, actor=_actor('dave')))
        log = self.db.audit.list_log(entity_type='organization', entity_id='364348917')
        self.assertEqual(log[0]['action'], 'update')
        self.assertEqual(log[0]['changes'], {'is_favorite': True})
        self.assertEqual(log[0]['actor_label'], 'dave')

    def test_created_org_is_searchable_and_in_dropdowns(self):
        self.db.orgs.create_org(
            '364348917', 'Administer Justice',
            physical_address={'city': 'Elgin', 'state': 'IL'})
        self.assertIsNotNone(self.db.orgs.get_organization('364348917'))
        self.assertIn('IL', [s['code'] for s in self.db.orgs.list_states()])
        self.assertIn('Elgin', self.db.orgs.list_cities('IL'))


if __name__ == '__main__':
    unittest.main()
