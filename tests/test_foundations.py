"""Tests for distinguishing foundations vs nonprofits: org classification
(org_type + is_grantmaker from filings/grant_edge), the search type/grantmaker
filters, the grant-direction reads (made/received) + route, and the `following`
annotation on org responses."""

import os
import sys
import unittest
from types import SimpleNamespace
from unittest.mock import MagicMock

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

from auth import Principal
from database import OpenReturnDB
from router.Org import OrgRouter


def _org(db, ein, name):
    db.cursor.execute("INSERT OR IGNORE INTO organization (ein, name) VALUES (?, ?)", (ein, name))


def _filing(db, ein, year, form):
    db.cursor.execute(
        "INSERT INTO filing (uuid, year, organization_id, form_code) VALUES (?, ?, ?, ?)",
        (f"u-{ein}-{year}-{form}", year, ein, form))
    return db.cursor.lastrowid


def _grant(db, grantor_filing_id, recipient_name, *, recipient_ein=None, kind='PF_PAID',
           cash=1000.0):
    db.cursor.execute(
        "INSERT INTO party_appearance (filing_id, party_kind, business_name, appearance_ein, "
        "group_code, occurrence_index) VALUES (?, 'organization', ?, ?, 'G', "
        "(SELECT COUNT(*) FROM party_appearance WHERE filing_id = ?))",
        (grantor_filing_id, recipient_name, recipient_ein, grantor_filing_id))
    aid = db.cursor.lastrowid
    db.cursor.execute(
        "INSERT INTO grant_edge (filing_id, appearance_id, group_code, occurrence_index, "
        "grant_kind, recipient_ein, cash_amount) VALUES (?, ?, 'G', "
        "(SELECT COUNT(*) FROM grant_edge WHERE filing_id = ?), ?, ?, ?)",
        (grantor_filing_id, aid, grantor_filing_id, kind, recipient_ein, cash))


class TestClassification(unittest.TestCase):
    def setUp(self):
        self.db = OpenReturnDB(path=':memory:')

    def tearDown(self):
        self.db.close()

    def _type(self, ein):
        return self.db.orgs.get_organization(ein)['org_type']

    def test_classification_by_form(self):
        _org(self.db, '100000001', 'Found')
        _org(self.db, '100000002', 'Charity')
        _org(self.db, '100000003', 'UBI')
        _org(self.db, '100000004', 'NoForm')
        _filing(self.db, '100000001', 2023, '990PF')
        _filing(self.db, '100000002', 2023, '990')
        _filing(self.db, '100000003', 2023, '990T')
        self.db.connection.commit()
        self.db.orgs.classify_organizations()
        self.assertEqual(self._type('100000001'), 'foundation')
        self.assertEqual(self._type('100000002'), 'nonprofit')
        self.assertEqual(self._type('100000003'), 'other')
        self.assertIsNone(self._type('100000004'))

    def test_filed_both_is_foundation(self):
        _org(self.db, '100000005', 'Both')
        _filing(self.db, '100000005', 2021, '990')
        _filing(self.db, '100000005', 2023, '990PF')
        self.db.connection.commit()
        self.db.orgs.classify_organizations()
        self.assertEqual(self._type('100000005'), 'foundation')

    def test_grantmaker_flag(self):
        _org(self.db, '100000001', 'Found')
        _org(self.db, '100000002', 'Charity')
        fid = _filing(self.db, '100000001', 2023, '990PF')
        _filing(self.db, '100000002', 2023, '990')
        _grant(self.db, fid, 'Some NP')
        self.db.connection.commit()
        self.db.orgs.classify_organizations()
        self.assertTrue(self.db.orgs.get_organization('100000001')['is_grantmaker'])
        self.assertFalse(self.db.orgs.get_organization('100000002')['is_grantmaker'])

    def test_scoped_and_idempotent(self):
        _org(self.db, '100000001', 'Found')
        _org(self.db, '100000002', 'Charity')
        _filing(self.db, '100000001', 2023, '990PF')
        _filing(self.db, '100000002', 2023, '990')
        self.db.connection.commit()
        # Scope to one EIN: only it is classified.
        self.db.orgs.classify_organizations(eins=['100000001'])
        self.assertEqual(self._type('100000001'), 'foundation')
        self.assertIsNone(self._type('100000002'))
        self.assertEqual(self.db.orgs.classify_organizations(eins=[])['classified'], 0)
        # Full run is idempotent.
        self.db.orgs.classify_organizations()
        self.db.orgs.classify_organizations()
        self.assertEqual(self._type('100000002'), 'nonprofit')

    def test_scoped_chunks_large_ein_list(self):
        # A full-corpus finalize passes >800k eins; the scoped UPDATE must batch the
        # IN-clause so it never errors "too many SQL variables".
        for ein, form in (('100000001', '990PF'), ('100000002', '990'), ('100000003', '990T')):
            _org(self.db, ein, ein)
            _filing(self.db, ein, 2023, form)
        self.db.connection.commit()
        orig = self.db.orgs._EIN_CHUNK
        self.db.orgs._EIN_CHUNK = 1   # force several chunks for 3 eins
        try:
            res = self.db.orgs.classify_organizations(
                eins=['100000001', '100000002', '100000003'])
        finally:
            self.db.orgs._EIN_CHUNK = orig
        self.assertEqual(res['classified'], 3)
        self.assertEqual(self._type('100000001'), 'foundation')
        self.assertEqual(self._type('100000002'), 'nonprofit')
        self.assertEqual(self._type('100000003'), 'other')

    def test_search_type_and_grantmaker_filters(self):
        _org(self.db, '100000001', 'Found')
        _org(self.db, '100000002', 'Charity')
        fid = _filing(self.db, '100000001', 2023, '990PF')
        _filing(self.db, '100000002', 2023, '990')
        _grant(self.db, fid, 'NP')
        self.db.connection.commit()
        self.db.orgs.classify_organizations()
        out = self.db.orgs.search_organizations(org_type='foundation')
        self.assertEqual([o['ein'] for o in out['organizations']], ['100000001'])
        out = self.db.orgs.search_organizations(grantmaker=True)
        self.assertEqual([o['ein'] for o in out['organizations']], ['100000001'])
        out = self.db.orgs.search_organizations(org_type='nonprofit')
        self.assertEqual([o['ein'] for o in out['organizations']], ['100000002'])
        # org rows carry the classification
        self.assertEqual(self.db.orgs.get_organization('100000001')['org_type'], 'foundation')

    def test_list_organizations_type_and_grantmaker_filters(self):
        _org(self.db, '100000001', 'Found')
        _org(self.db, '100000002', 'Charity')
        fid = _filing(self.db, '100000001', 2023, '990PF')
        _filing(self.db, '100000002', 2023, '990')
        _grant(self.db, fid, 'NP')
        self.db.connection.commit()
        self.db.orgs.classify_organizations()
        self.assertEqual([o['ein'] for o in self.db.orgs.list_organizations(
            org_type='foundation')['organizations']], ['100000001'])
        self.assertEqual([o['ein'] for o in self.db.orgs.list_organizations(
            grantmaker=True)['organizations']], ['100000001'])
        self.assertEqual([o['ein'] for o in self.db.orgs.list_organizations(
            grantmaker=False)['organizations']], ['100000002'])


class TestGrantReads(unittest.TestCase):
    def setUp(self):
        self.db = OpenReturnDB(path=':memory:')
        _org(self.db, '100000001', 'Found Co')
        _org(self.db, '100000002', 'Charity Co')
        self.fid = _filing(self.db, '100000001', 2023, '990PF')
        _grant(self.db, self.fid, 'Charity Co', recipient_ein='100000002', cash=25000.0)
        _grant(self.db, self.fid, 'Other NP', recipient_ein='300000003', cash=5000.0)
        self.db.connection.commit()

    def tearDown(self):
        self.db.close()

    def test_grants_made(self):
        out = self.db.appearances.grants_made('100000001')
        self.assertEqual(out['direction'], 'made')
        self.assertEqual(out['summary']['grant_count'], 2)
        self.assertEqual(out['summary']['total_amount'], 30000.0)
        self.assertEqual(out['summary']['counterparties'], 2)
        recips = {g['recipient_ein'] for g in out['grants']}
        self.assertEqual(recips, {'100000002', '300000003'})

    def test_grants_received_schedule_i(self):
        out = self.db.appearances.grants_received('100000002')
        self.assertEqual(out['direction'], 'received')
        self.assertEqual(out['summary']['grant_count'], 1)
        self.assertEqual(out['grants'][0]['grantor'], 'Found Co')
        self.assertEqual(out['grants'][0]['amount'], 25000.0)

    def test_grants_received_none_for_unfunded(self):
        out = self.db.appearances.grants_received('100000001')
        self.assertEqual(out['summary']['grant_count'], 0)


class TestOrgGrantRouteAndFollowing(unittest.TestCase):
    def setUp(self):
        self.db = OpenReturnDB(path=':memory:')
        _org(self.db, '100000001', 'Found Co')
        _org(self.db, '100000002', 'Charity Co')
        fid = _filing(self.db, '100000001', 2023, '990PF')
        _grant(self.db, fid, 'Charity Co', recipient_ein='100000002', cash=9000.0)
        self.db.connection.commit()
        self.db.orgs.classify_organizations()
        self.uid = self.db.users.create_user('alice', 'pw', roles=['viewer'])
        self.actor = Principal(kind='user', actor_id=self.uid, label='alice',
                               permissions=frozenset({'org:read'}), user_id=self.uid)
        self.router = OrgRouter(db=self.db)

    def tearDown(self):
        self.db.close()

    def _h(self, principal=None):
        return SimpleNamespace(_principal=principal, get=lambda *a, **k: "")

    def _call(self, path, qp, principal=None):
        return self.router.routes['GET'][path](
            query_params={k: [v] for k, v in qp.items()}, body=None, headers=self._h(principal))

    def test_grants_route_made_and_received(self):
        made = self._call('/organizations/grants', {'ein': '100000001', 'direction': 'made'})
        self.assertEqual(made['summary']['total_amount'], 9000.0)
        recv = self._call('/organizations/grants', {'ein': '100000002', 'direction': 'received'})
        self.assertEqual(recv['grants'][0]['grantor'], 'Found Co')

    def test_grants_route_bad_direction(self):
        self.assertIn('error', self._call('/organizations/grants',
                                          {'ein': '100000001', 'direction': 'sideways'}))

    def test_grants_route_requires_ein(self):
        self.assertIn('error', self._call('/organizations/grants', {'direction': 'made'}))

    def test_search_requires_a_criterion(self):
        self.assertIn('error', self._call('/organizations/search', {}))

    def test_following_flag(self):
        self.db.follows.follow_org('100000001', actor=self.actor)
        detail = self._call('/organizations/detail', {'ein': '100000001'}, self.actor)
        self.assertTrue(detail['following'])
        other = self._call('/organizations/detail', {'ein': '100000002'}, self.actor)
        self.assertFalse(other['following'])
        # search results carry following for the user
        res = self._call('/organizations/search', {'type': 'foundation'}, self.actor)
        self.assertTrue(res['organizations'][0]['following'])
        # no-user caller → following False
        anon = self._call('/organizations/detail', {'ein': '100000001'}, None)
        self.assertFalse(anon['following'])


class TestClassifyCLI(unittest.TestCase):
    def test_cmd_classify(self):
        import tempfile
        from classify import cmd_classify
        with tempfile.TemporaryDirectory() as td:
            path = os.path.join(td, 'OpenReturn.db')
            db = OpenReturnDB(path=path)
            _org(db, '100000001', 'Found')
            _filing(db, '100000001', 2023, '990PF')
            db.connection.commit()
            db.close()
            rc = cmd_classify(SimpleNamespace(db=path))
            self.assertEqual(rc, 0)
            db2 = OpenReturnDB(path=path)
            self.assertEqual(db2.orgs.get_organization('100000001')['org_type'], 'foundation')
            db2.close()

    def test_cmd_classify_missing_db(self):
        from classify import cmd_classify
        self.assertEqual(cmd_classify(SimpleNamespace(db='/nonexistent/nope.db')), 1)


if __name__ == '__main__':
    unittest.main()
