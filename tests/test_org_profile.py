"""Tests for the org-profile API additions: the shared in_portfolio flag +
/organizations/portfolio, latest_mission() exposed on /organizations/full, and
the per-org personnel reader + /organizations/personnel."""

import os
import sys
import unittest
import xml.etree.ElementTree as ET
from unittest.mock import MagicMock

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

from auth import Principal
from database import OpenReturnDB
from parser.groups import extract_groups
from router.Org import OrgRouter

_NS = 'http://www.irs.gov/efile'
_PERSONNEL_XML = f"""<?xml version="1.0"?>
<Return xmlns="{_NS}">
  <ReturnHeader><Filer><EIN>100000001</EIN></Filer></ReturnHeader>
  <ReturnData>
    <IRS990>
      <Form990PartVIISectionAGrp>
        <PersonNm>Jane Doe</PersonNm>
        <TitleTxt>President</TitleTxt>
        <OfficerInd>true</OfficerInd>
        <ReportableCompFromOrgAmt>120000</ReportableCompFromOrgAmt>
        <OtherCompensationAmt>5000</OtherCompensationAmt>
      </Form990PartVIISectionAGrp>
      <Form990PartVIISectionAGrp>
        <PersonNm>John Roe</PersonNm>
        <TitleTxt>Treasurer</TitleTxt>
        <IndividualTrusteeOrDirectorInd>1</IndividualTrusteeOrDirectorInd>
      </Form990PartVIISectionAGrp>
    </IRS990>
  </ReturnData>
</Return>"""


def _user_actor(uid, label='alice'):
    return Principal(kind='user', actor_id=uid, label=label, permissions=frozenset(), user_id=uid)


class TestInPortfolio(unittest.TestCase):
    def setUp(self):
        self.db = OpenReturnDB(path=':memory:')
        self.db.cursor.execute("INSERT INTO organization (ein, name, org_type) VALUES "
                               "('100000001','Charity Co','nonprofit')")
        self.db.connection.commit()

    def tearDown(self):
        self.db.close()

    def test_toggle_and_row(self):
        self.assertFalse(self.db.orgs.get_organization('100000001')['in_portfolio'])
        self.assertTrue(self.db.orgs.set_in_portfolio('100000001', True))
        self.assertTrue(self.db.orgs.get_organization('100000001')['in_portfolio'])
        self.assertTrue(self.db.orgs.set_in_portfolio('100000001', False))
        self.assertFalse(self.db.orgs.get_organization('100000001')['in_portfolio'])

    def test_unknown_org(self):
        self.assertFalse(self.db.orgs.set_in_portfolio('999999999', True))


class TestLatestMission(unittest.TestCase):
    def setUp(self):
        self.db = OpenReturnDB(path=':memory:')
        self.db.cursor.execute("INSERT INTO organization (ein, name) VALUES ('100000001','Co')")
        self.db.connection.commit()

    def tearDown(self):
        self.db.close()

    def _mission_field_id(self, xml_path='ReturnData/IRS990/MissionDesc'):
        return self.db.cursor.execute(
            "SELECT field_id FROM field WHERE xml_path = ?", (xml_path,)).fetchone()[0]

    def _file_with_mission(self, year, text, xml_path='ReturnData/IRS990/MissionDesc'):
        uuid = self.db.filings.create_filing('100000001', year, '990')
        self.db.reported_data.store_reported_data(uuid, {self._mission_field_id(xml_path): text})
        self.db.connection.commit()
        return uuid

    def test_none_without_filing(self):
        self.assertIsNone(self.db.orgs.latest_mission('100000001'))

    def test_returns_mission(self):
        self._file_with_mission(2023, 'To serve the community.')
        self.assertEqual(self.db.orgs.latest_mission('100000001'), 'To serve the community.')

    def test_newest_filing_wins(self):
        self._file_with_mission(2021, 'Old mission.')
        self._file_with_mission(2023, 'New mission.')
        self.assertEqual(self.db.orgs.latest_mission('100000001'), 'New mission.')

    def test_full_route_includes_mission(self):
        self._file_with_mission(2023, 'Serve all.')
        router = OrgRouter(db=self.db)
        h = MagicMock(); h.get.return_value = ""; h._principal = None
        out = router.routes['GET']['/organizations/full'](
            query_params={'ein': ['100000001']}, body=None, headers=h)
        self.assertEqual(out['mission'], 'Serve all.')


class TestPersonnel(unittest.TestCase):
    def setUp(self):
        self.db = OpenReturnDB(path=':memory:')
        self.db.cursor.execute("INSERT INTO organization (ein, name) VALUES ('100000001','Co')")
        self.db.connection.commit()

    def tearDown(self):
        self.db.close()

    def _store(self, year):
        uuid = self.db.filings.create_filing('100000001', year, '990')
        self.db.appearances.store_filing_graph(uuid, extract_groups(ET.fromstring(_PERSONNEL_XML)))
        self.db.connection.commit()
        return uuid

    def test_empty_without_graph(self):
        out = self.db.appearances.personnel('100000001')
        self.assertEqual(out['personnel'], [])

    def test_returns_officers(self):
        self._store(2023)
        out = self.db.appearances.personnel('100000001')
        names = {p['name'] for p in out['personnel']}
        self.assertEqual(names, {'Jane Doe', 'John Roe'})
        jane = next(p for p in out['personnel'] if p['name'] == 'Jane Doe')
        self.assertTrue(jane['is_officer'])
        self.assertEqual(jane['title'], 'President')
        self.assertEqual(jane['reportable_comp_org'], 120000)
        self.assertEqual(out['year'], 2023)

    def test_returns_all_years_newest_first(self):
        self._store(2021)
        self._store(2023)
        out = self.db.appearances.personnel('100000001')
        self.assertEqual(out['year'], 2023)          # most recent filing year
        self.assertEqual(out['years'], [2023, 2021])
        self.assertEqual(len(out['personnel']), 4)   # all years, each tagged
        self.assertEqual(out['personnel'][0]['filing_year'], 2023)
        recent = [p for p in out['personnel'] if p['filing_year'] == 2023]
        self.assertEqual(len(recent), 2)

    def test_personnel_route(self):
        self._store(2023)
        router = OrgRouter(db=self.db)
        h = MagicMock(); h.get.return_value = ""; h._principal = None
        out = router.routes['GET']['/organizations/personnel'](
            query_params={'ein': ['100000001']}, body=None, headers=h)
        self.assertEqual(len(out['personnel']), 2)
        self.assertIn('error', router.routes['GET']['/organizations/personnel'](
            query_params={}, body=None, headers=h))


class TestPortfolioRoute(unittest.TestCase):
    def setUp(self):
        self.db = OpenReturnDB(path=':memory:')
        self.db.cursor.execute("INSERT INTO organization (ein, name) VALUES ('100000001','Co')")
        self.db.connection.commit()
        self.uid = self.db.users.create_user('alice', 'pw', roles=['editor'])
        self.router = OrgRouter(db=self.db)

    def tearDown(self):
        self.db.close()

    def _h(self):
        h = MagicMock(); h.get.return_value = ""; h._principal = _user_actor(self.uid)
        return h

    def test_permission(self):
        self.assertEqual(self.router.routes['POST']['/organizations/portfolio']._permission, 'org:write')

    def test_set_portfolio(self):
        out = self.router.routes['POST']['/organizations/portfolio'](
            query_params={}, body={'ein': '100000001', 'in_portfolio': True}, headers=self._h())
        self.assertTrue(out['in_portfolio'])
        out = self.router.routes['POST']['/organizations/portfolio'](
            query_params={}, body={'ein': '100000001', 'in_portfolio': '0'}, headers=self._h())
        self.assertFalse(out['in_portfolio'])

    def test_requires_fields(self):
        out = self.router.routes['POST']['/organizations/portfolio'](
            query_params={}, body={'ein': '100000001'}, headers=self._h())
        self.assertIn('error', out)

    def test_unknown_org(self):
        out = self.router.routes['POST']['/organizations/portfolio'](
            query_params={}, body={'ein': '999999999', 'in_portfolio': True}, headers=self._h())
        self.assertIn('error', out)


if __name__ == '__main__':
    unittest.main()
