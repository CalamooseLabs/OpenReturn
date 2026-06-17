"""Tests for the sector classification: the seeded NTEE-major-group vocabulary,
assigning sector via create/update (validated, audited), the search filter, the
dropdown, and the org-row fields."""

import os
import sys
import unittest
from unittest.mock import MagicMock

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

from auth import Principal
from database import OpenReturnDB
from router.Org import OrgRouter


def _actor(label='ed'):
    return Principal(kind='user', actor_id=1, label=label, permissions=frozenset(), user_id=1)


class TestSectorDB(unittest.TestCase):
    def setUp(self):
        self.db = OpenReturnDB(path=':memory:')

    def tearDown(self):
        self.db.close()

    def test_ntee_seeded(self):
        secs = {s['code']: s for s in self.db.orgs.list_sectors()}
        self.assertEqual(len(secs), 26)               # A–Z
        self.assertEqual(secs['E']['name'], 'Health Care')
        self.assertIn('parent_code', secs['E'])       # column present for later grouping

    def test_create_with_sector(self):
        o = self.db.orgs.create_org('364348917', 'AJ', sector_code='I', actor=_actor())
        self.assertEqual(o['sector_code'], 'I')
        self.assertEqual(o['sector_name'], 'Crime & Legal-Related')

    def test_update_sector_and_clear(self):
        self.db.orgs.create_org('111111111', 'Co', actor=_actor())
        self.assertEqual(self.db.orgs.update_org('111111111', {'sector_code': 'X'},
                                                 actor=_actor())['sector_code'], 'X')
        self.assertIsNone(self.db.orgs.update_org('111111111', {'sector_code': ''},
                                                  actor=_actor())['sector_code'])

    def test_unknown_sector_rejected(self):
        self.db.orgs.create_org('111111111', 'Co', actor=_actor())
        with self.assertRaises(ValueError):
            self.db.orgs.update_org('111111111', {'sector_code': 'BOGUS'}, actor=_actor())
        with self.assertRaises(ValueError):
            self.db.orgs.create_org('222222222', 'Bad', sector_code='QQ', actor=_actor())

    def test_search_and_list_filters(self):
        self.db.orgs.create_org('100000001', 'Health A', sector_code='E', actor=_actor())
        self.db.orgs.create_org('100000002', 'Legal B', sector_code='I', actor=_actor())
        self.assertEqual([o['ein'] for o in self.db.orgs.search_organizations(sector='E')['organizations']],
                         ['100000001'])
        self.assertEqual([o['ein'] for o in self.db.orgs.list_organizations(sector='I')['organizations']],
                         ['100000002'])

    def test_create_audited(self):
        self.db.orgs.create_org('100000001', 'Org', sector_code='B', actor=_actor('alice'))
        self.assertTrue(self.db.audit.list_log(entity_type='organization', entity_id='100000001'))


class TestSectorRouter(unittest.TestCase):
    def setUp(self):
        self.db = OpenReturnDB(path=':memory:')
        self.router = OrgRouter(db=self.db)

    def tearDown(self):
        self.db.close()

    def _h(self, principal=None):
        h = MagicMock(); h.get.return_value = ""; h._principal = principal
        return h

    def _get(self, path, principal=None, **qp):
        return self.router.routes['GET'][path](
            query_params={k: [v] for k, v in qp.items()}, body=None, headers=self._h(principal))

    def test_sectors_dropdown(self):
        out = self._get('/organizations/sectors')
        self.assertEqual(len(out['sectors']), 26)

    def test_create_and_search_via_router(self):
        actor = _actor()
        self.router.routes['POST']['/organizations'](
            query_params={}, body={'ein': '100000001', 'name': 'Health Org', 'sector_code': 'E'},
            headers=self._h(actor))
        res = self._get('/organizations/search', actor, sector='E')
        self.assertEqual([o['ein'] for o in res['organizations']], ['100000001'])
        self.assertEqual(res['organizations'][0]['sector_name'], 'Health Care')


if __name__ == '__main__':
    unittest.main()
