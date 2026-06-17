"""Tests for county deduction: the ZIP→county crosswalk import (column-flexible,
dominant pick), derivation onto org addresses (ZIP+4 normalized), the search filter
+ dropdown, and the `openreturn counties` CLI."""

import os
import sys
import tempfile
import unittest
from types import SimpleNamespace

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

import counties as C
from auth import Principal
from database import OpenReturnDB


def _actor():
    return Principal(kind='user', actor_id=1, label='ed', permissions=frozenset(), user_id=1)


def _org(db, ein, zip_):
    db.orgs.create_org(ein, f'Org {ein}', physical_address={'street': '1 X', 'city': 'Y',
                       'state': 'IL', 'zip': zip_}, actor=_actor())


# ── crosswalk parsing ─────────────────────────────────────────────────────────

class TestParseCrosswalk(unittest.TestCase):
    def _write(self, text):
        td = tempfile.mkdtemp()
        p = os.path.join(td, 'x.csv')
        open(p, 'w', newline='').write(text)
        return p

    def test_hud_shape_dominant_by_res_ratio(self):
        rows = C.parse_crosswalk(self._write(
            "ZIP,COUNTY,USPS_ZIP_PREF_STATE,RES_RATIO\n"
            "60120,17031,IL,0.30\n60120,17089,IL,0.70\n"))
        by = {(r[0], r[1]): r for r in rows}
        self.assertEqual(by[('60120', '17089')][4], 1)   # higher res share → dominant
        self.assertEqual(by[('60120', '17031')][4], 0)

    def test_optional_name_and_zip4_trim(self):
        rows = C.parse_crosswalk(self._write(
            "zipcode,county_fips,county_name,res_ratio\n60120-1234,17089,Kane County,1.0\n"))
        self.assertEqual(rows[0][:3], ('60120', '17089', 'Kane County'))

    def test_missing_columns_raises(self):
        with self.assertRaises(ValueError):
            C.parse_crosswalk(self._write("foo,bar\n1,2\n"))


# ── import + derive ───────────────────────────────────────────────────────────

class TestCountyDerive(unittest.TestCase):
    def setUp(self):
        self.db = OpenReturnDB(path=':memory:')
        _org(self.db, '364348917', '60120')
        _org(self.db, '111111111', '60120-1234')      # ZIP+4 → normalizes to 60120
        _org(self.db, '222222222', '99999')           # not in crosswalk

    def tearDown(self):
        self.db.close()

    def test_import_and_derive(self):
        n = self.db.orgs.import_zip_county([
            ('60120', '17089', 'Kane County', 'IL', 1),
            ('60120', '17031', 'Cook County', 'IL', 0)])
        self.assertEqual(n, 2)
        self.assertEqual(self.db.orgs.derive_counties()['updated'], 2)
        for ein in ('364348917', '111111111'):
            a = self.db.orgs.get_organization(ein)['address']
            self.assertEqual((a['county_fips'], a['county_name']), ('17089', 'Kane County'))
        self.assertIsNone(self.db.orgs.get_organization('222222222')['address']['county_fips'])

    def test_derive_is_noop_without_crosswalk(self):
        self.assertEqual(self.db.orgs.derive_counties()['updated'], 0)

    def test_reimport_replaces_dominant(self):
        # First crosswalk: 60120's dominant county is Kane.
        self.db.orgs.import_zip_county([('60120', '17089', 'Kane County', 'IL', 1),
                                        ('60120', '17031', 'Cook County', 'IL', 0)])
        self.db.orgs.derive_counties()
        self.assertEqual(self.db.orgs.get_organization('364348917')['address']['county_fips'], '17089')
        # A corrected crosswalk flips 60120's dominant county to Cook. A full replace
        # must leave exactly ONE dominant row for the ZIP (no stale Kane dominant).
        self.db.orgs.import_zip_county([('60120', '17031', 'Cook County', 'IL', 1)])
        dom = self.db.cursor.execute(
            "SELECT COUNT(*) FROM zip_county WHERE zipcode = '60120' AND dominant = 1").fetchone()[0]
        self.assertEqual(dom, 1)
        self.assertEqual(self.db.orgs.derive_counties()['updated'], 2)
        self.assertEqual(self.db.orgs.get_organization('364348917')['address']['county_fips'], '17031')

    def test_address_edit_redrives_county(self):
        self.db.orgs.import_zip_county([('60120', '17089', 'Kane County', 'IL', 1),
                                        ('77001', '48201', 'Harris County', 'TX', 1)])
        self.db.orgs.derive_counties()
        self.assertEqual(self.db.orgs.get_organization('364348917')['address']['county_fips'], '17089')
        # Editing the address rewrites the row (INSERT OR REPLACE) — county must be
        # re-derived from the new ZIP, not silently wiped.
        self.db.orgs.update_org('364348917',
            {'physical_address': {'street': '2 Z', 'city': 'Houston', 'state': 'TX', 'zip': '77001'}},
            actor=_actor())
        a = self.db.orgs.get_organization('364348917')['address']
        self.assertEqual((a['county_fips'], a['county_name']), ('48201', 'Harris County'))

    def test_derive_chunks_large_ein_list(self):
        # A full-corpus finalize passes >800k eins; the scoped UPDATE must batch
        # them so it never trips SQLite's "too many SQL variables" limit.
        self.db.orgs.import_zip_county([('60120', '17089', 'Kane County', 'IL', 1)])
        orig = self.db.orgs._EIN_CHUNK
        self.db.orgs._EIN_CHUNK = 1   # force several chunks for 3 eins
        try:
            res = self.db.orgs.derive_counties(eins=['364348917', '111111111', '222222222'])
        finally:
            self.db.orgs._EIN_CHUNK = orig
        self.assertEqual(res['updated'], 2)   # the two 60120 orgs; 99999 unmatched
        for ein in ('364348917', '111111111'):
            self.assertEqual(self.db.orgs.get_organization(ein)['address']['county_fips'], '17089')

    def test_create_derives_county_when_crosswalk_present(self):
        self.db.orgs.import_zip_county([('30301', '13121', 'Fulton County', 'GA', 1)])
        self.db.orgs.create_org('333333333', 'New Org',
            physical_address={'street': '1 A', 'city': 'Atlanta', 'state': 'GA', 'zip': '30301'},
            actor=_actor())
        self.assertEqual(self.db.orgs.get_organization('333333333')['address']['county_fips'], '13121')

    def test_search_and_list_counties(self):
        self.db.orgs.import_zip_county([('60120', '17089', 'Kane County', 'IL', 1)])
        self.db.orgs.derive_counties()
        self.assertEqual(
            {o['ein'] for o in self.db.orgs.search_organizations(county='17089')['organizations']},
            {'364348917', '111111111'})
        counties = self.db.orgs.list_counties()
        self.assertEqual(counties, [{'fips': '17089', 'name': 'Kane County', 'state': 'IL'}])
        self.assertEqual(self.db.orgs.list_counties(state='TX'), [])


# ── CLI ───────────────────────────────────────────────────────────────────────

class TestCountiesCLI(unittest.TestCase):
    def test_import_and_derive_cli(self):
        with tempfile.TemporaryDirectory() as td:
            dbp = os.path.join(td, 'OpenReturn.db')
            db = OpenReturnDB(path=dbp)
            _org(db, '364348917', '60120')
            db.close()
            csvp = os.path.join(td, 'hud.csv')
            open(csvp, 'w', newline='').write("ZIP,COUNTY,RES_RATIO\n60120,17089,1.0\n")
            self.assertEqual(C.cmd_import(SimpleNamespace(file=csvp, db=dbp)), 0)
            db = OpenReturnDB(path=dbp)
            self.assertEqual(db.orgs.get_organization('364348917')['address']['county_fips'], '17089')
            db.close()
            self.assertEqual(C.cmd_derive(SimpleNamespace(db=dbp)), 0)

    def test_import_missing_file(self):
        self.assertEqual(C.cmd_import(SimpleNamespace(file='/no/such.csv', db='/no/db')), 1)

    def test_derive_missing_db(self):
        self.assertEqual(C.cmd_derive(SimpleNamespace(db='/no/such.db')), 1)

    def test_derive_empty_crosswalk_message(self):
        with tempfile.TemporaryDirectory() as td:
            dbp = os.path.join(td, 'OpenReturn.db')
            OpenReturnDB(path=dbp).close()
            self.assertEqual(C.cmd_derive(SimpleNamespace(db=dbp)), 0)


if __name__ == '__main__':
    unittest.main()
