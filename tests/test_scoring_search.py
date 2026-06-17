"""Tests for the post-ingest scoring hook + `openreturn score` CLI, the batch
scoring engine's time-spanning recompute, normalized address capture, and the
strict/fuzzy organization search."""

import contextlib
import io
import os
import sys
import tempfile
import unittest
import zipfile
from pathlib import Path
from types import SimpleNamespace
from unittest.mock import patch

_ROOT = os.path.join(os.path.dirname(__file__), '..')
sys.path.insert(0, os.path.join(_ROOT, 'src'))
sys.path.insert(0, _ROOT)

import ingest as ingest_mod
from database import OpenReturnDB
from scoring import ScoringEngine
from scoring.engine import _PATHS


def _full_990_xml(ein="123456789", name="Hope Childrens Foundation", year=2023,
                  city="Austin", state="TX", zipcode="78701") -> bytes:
    return f"""<?xml version="1.0" encoding="UTF-8"?>
<Return xmlns="http://www.irs.gov/efile">
  <ReturnHeader>
    <TaxYr>{year}</TaxYr>
    <ReturnTypeCd>990</ReturnTypeCd>
    <Filer>
      <EIN>{ein}</EIN>
      <BusinessName><BusinessNameLine1Txt>{name}</BusinessNameLine1Txt></BusinessName>
      <USAddress>
        <AddressLine1Txt>1 Main St</AddressLine1Txt>
        <CityNm>{city}</CityNm>
        <StateAbbreviationCd>{state}</StateAbbreviationCd>
        <ZIPCd>{zipcode}</ZIPCd>
      </USAddress>
    </Filer>
  </ReturnHeader>
  <ReturnData>
    <IRS990>
      <CYTotalRevenueAmt>1000000</CYTotalRevenueAmt>
      <CYTotalExpensesAmt>950000</CYTotalExpensesAmt>
      <TotalContributionsAmt>600000</TotalContributionsAmt>
      <TotalAssetsEOYAmt>2000000</TotalAssetsEOYAmt>
      <TotalLiabilitiesEOYAmt>400000</TotalLiabilitiesEOYAmt>
      <NetAssetsOrFundBalancesEOYAmt>1600000</NetAssetsOrFundBalancesEOYAmt>
      <TotalFunctionalExpensesGrp>
        <ProgramServicesAmt>800000</ProgramServicesAmt>
        <ManagementAndGeneralAmt>100000</ManagementAndGeneralAmt>
        <FundraisingAmt>50000</FundraisingAmt>
        <TotalAmt>950000</TotalAmt>
      </TotalFunctionalExpensesGrp>
    </IRS990>
  </ReturnData>
</Return>""".encode()


def _make_zip(directory: Path, name: str, members: dict) -> Path:
    p = directory / name
    with zipfile.ZipFile(p, 'w') as zf:
        for fn, content in members.items():
            zf.writestr(fn, content)
    return p


# ---------------------------------------------------------------------------
# End-to-end: a real directory ingest captures the address AND scores the org
# ---------------------------------------------------------------------------

class TestIngestScoringHook(unittest.TestCase):

    def _ingest(self, td, *extra, workers="1"):
        zip_dir = Path(td) / "zips"
        zip_dir.mkdir()
        _make_zip(zip_dir, "filings.zip", {"f1.xml": _full_990_xml()})
        argv = ['ingest', '--workers', workers, *extra, str(zip_dir)]
        old = os.getcwd()
        os.chdir(td)
        try:
            with patch('sys.argv', argv), \
                 contextlib.redirect_stdout(io.StringIO()), \
                 contextlib.redirect_stderr(io.StringIO()):
                rc = ingest_mod.main()
        finally:
            os.chdir(old)
        return rc

    def test_ingest_stores_normalized_address(self):
        with tempfile.TemporaryDirectory() as td:
            self.assertEqual(self._ingest(td), 0)
            db = OpenReturnDB(path=str(Path(td) / "OpenReturn.db"))
            org = db.orgs.get_organization("123456789")
            self.assertIsNotNone(org)
            self.assertEqual(org["address"], {"street": "1 Main St", "city": "Austin",
                                              "state": "TX", "zip": "78701",
                                              "county_fips": None, "county_name": None})
            # normalized: the data lives in the address table, linked by EIN
            n = db.cursor.execute("SELECT COUNT(*) FROM address WHERE uuid = '123456789'").fetchone()[0]
            self.assertEqual(n, 1)
            db.close()

    def test_ingest_auto_scores_computed_model(self):
        with tempfile.TemporaryDirectory() as td:
            self.assertEqual(self._ingest(td), 0)
            db = OpenReturnDB(path=str(Path(td) / "OpenReturn.db"))
            score = db.scores.get_score_by_ein_year("123456789", 2023)
            self.assertIsNotNone(score)              # the seeded v1 model was scored
            self.assertEqual(score["model_version"], 1)
            self.assertGreater(score["total_score"], 0)   # real financial fields → non-zero
            db.close()

    def test_no_score_flag_skips_scoring(self):
        with tempfile.TemporaryDirectory() as td:
            self.assertEqual(self._ingest(td, '--no-score'), 0)
            db = OpenReturnDB(path=str(Path(td) / "OpenReturn.db"))
            self.assertEqual(db.cursor.execute("SELECT COUNT(*) FROM organization_score").fetchone()[0], 0)
            # the filing still ingested
            self.assertEqual(db.cursor.execute("SELECT COUNT(*) FROM filing").fetchone()[0], 1)
            db.close()

    def test_parallel_ingest_builds_fuzzy_index(self):
        # The default (parallel) path writes orgs via raw INSERT OR IGNORE, which
        # bypasses the per-org FTS sync — the finalize must rebuild the trigram
        # index so bulk-loaded orgs are fuzzy-searchable. (Regression: this used
        # to be missing; --workers 1 masked it.)
        with tempfile.TemporaryDirectory() as td:
            self.assertEqual(self._ingest(td, workers="2"), 0)
            db = OpenReturnDB(path=str(Path(td) / "OpenReturn.db"))
            r = db.orgs.search_organizations("childen", fuzzy=True)   # typo for "Childrens"
            self.assertEqual(r["mode"], "fuzzy")
            self.assertTrue(any(o["ein"] == "123456789" for o in r["organizations"]))
            db.close()


# ---------------------------------------------------------------------------
# Batch scoring engine: time-spanning factors recompute across all years
# ---------------------------------------------------------------------------

class TestBatchScoringTimeSpan(unittest.TestCase):

    def setUp(self):
        self.db = OpenReturnDB(path=":memory:")
        self.eng = ScoringEngine(self.db)
        self.xidx = self.db.meta.get_xpath_index()
        # A computed model with a time-spanning factor (running_average of revenue).
        self.db.cursor.execute(
            "INSERT INTO score_model (version, description, scoring_mode) VALUES (7,'t','computed')")
        mid = self.db.cursor.lastrowid
        self.db.cursor.execute(
            "INSERT INTO score_factor (model_id,name,weight,formula_type,inputs,direction,"
            "benchmark_lo,benchmark_hi,formula_description) VALUES (?,?,?,?,?,?,?,?,?)",
            (mid, "AvgRev", 1.0, "running_average", '["cy_rev"]', "higher", 0.0, 300000.0, "avg"))
        self.db.connection.commit()

    def tearDown(self):
        self.db.close()

    def _add(self, year, fid, uuid, rev):
        self.db.orgs.upsert_organization("990000001", "Org")
        self.db.cursor.execute(
            "INSERT INTO filing (filing_id,uuid,year,organization_id,form_code,zip_filename) "
            "VALUES (?,?,?, '990000001','990','z.zip')", (fid, uuid, year))
        f = self.xidx[_PATHS['cy_rev']]
        self.db.cursor.execute(
            "INSERT OR IGNORE INTO reported_data (filing_id,field_id,raw_value) VALUES (?,?,?)",
            (fid, f, str(rev)))
        self.db.connection.commit()

    def _avg(self, uuid):
        s = self.db.scores.get_score_by_filing(uuid)
        return next(f["raw_value"] for f in s["factors"] if f["name"] == "AvgRev")

    def test_running_average_spans_all_years(self):
        self._add(2021, 1, "u1", 100000)
        self._add(2022, 2, "u2", 120000)
        self._add(2023, 3, "u3", 140000)
        res = self.eng.rebuild(model_versions=[7])
        self.assertEqual(res["scores"], 3)
        for u in ("u1", "u2", "u3"):
            self.assertEqual(self._avg(u), 120000.0)   # mean of all three years

    def test_new_year_recomputes_all_prior_years(self):
        self._add(2021, 1, "u1", 100000)
        self._add(2022, 2, "u2", 120000)
        self.eng.rebuild(model_versions=[7])
        self.assertEqual(self._avg("u1"), 110000.0)
        # A new filing arrives → recompute the org; every year's average updates.
        self._add(2023, 3, "u3", 240000)
        self.eng.rebuild(model_versions=[7], eins=["990000001"])
        for u in ("u1", "u2", "u3"):
            self.assertEqual(self._avg(u), 153333.33333333334)   # mean(100,120,240)k

    def test_rebuild_is_idempotent(self):
        self._add(2023, 1, "u1", 100000)
        self.eng.rebuild(model_versions=[7])
        self.eng.rebuild(model_versions=[7])   # second run must not raise / duplicate
        n = self.db.cursor.execute(
            "SELECT COUNT(*) FROM organization_score os JOIN filing f "
            "ON f.filing_id = os.filing_id WHERE f.uuid='u1'").fetchone()[0]
        self.assertEqual(n, 1)

    def test_manual_model_not_scored(self):
        self.db.cursor.execute(
            "INSERT INTO score_model (version, description, scoring_mode) VALUES (8,'m','manual')")
        self.db.connection.commit()
        self._add(2023, 1, "u1", 100000)
        res = self.eng.rebuild(model_versions=[8])   # manual → nothing to compute
        self.assertEqual(res, {"orgs": 0, "scores": 0, "models": 0})


# ---------------------------------------------------------------------------
# `openreturn score` CLI
# ---------------------------------------------------------------------------

class TestScoreCLI(unittest.TestCase):

    def setUp(self):
        self._cwd = os.getcwd()
        self.td = tempfile.mkdtemp()
        os.chdir(self.td)
        db = OpenReturnDB()
        xidx = db.meta.get_xpath_index()
        db.orgs.upsert_organization("123456789", "Org")
        db.cursor.execute("INSERT INTO filing (filing_id,uuid,year,organization_id,form_code,zip_filename) "
                          "VALUES (1,'u1',2023,'123456789','990','z.zip')")
        for key in ("prog", "total_exp", "cy_rev", "cy_exp", "contrib", "assets", "liabilities"):
            db.cursor.execute("INSERT OR IGNORE INTO reported_data (filing_id,field_id,raw_value) VALUES (1,?,?)",
                              (xidx[_PATHS[key]], "100000"))
        db.connection.commit()
        db.close()

    def tearDown(self):
        os.chdir(self._cwd)

    def _run(self, **kw):
        base = dict(db=None, rebuild=False, org=None, version=None)
        base.update(kw)
        from scores import cmd_score
        with contextlib.redirect_stdout(io.StringIO()), contextlib.redirect_stderr(io.StringIO()):
            return cmd_score(SimpleNamespace(**base))

    def test_rebuild_scores_all(self):
        self.assertEqual(self._run(rebuild=True), 0)
        db = OpenReturnDB()
        self.assertEqual(db.cursor.execute("SELECT COUNT(*) FROM organization_score").fetchone()[0], 1)
        db.close()

    def test_no_args_is_guarded(self):
        self.assertEqual(self._run(), 2)   # neither --rebuild nor --org

    def test_org_filter(self):
        self.assertEqual(self._run(org=["123456789"]), 0)
        db = OpenReturnDB()
        self.assertIsNotNone(db.scores.get_score_by_filing("u1"))
        db.close()

    def test_missing_db_errors(self):
        with tempfile.TemporaryDirectory() as empty:
            self.assertEqual(self._run(db=str(Path(empty) / "nope.db"), rebuild=True), 1)


# ---------------------------------------------------------------------------
# Organization search — strict name, fuzzy name, EIN prefix, exact state/city
# ---------------------------------------------------------------------------

class TestOrgSearch(unittest.TestCase):

    def setUp(self):
        self.db = OpenReturnDB(path=":memory:")
        for ein, name, city, state in [
            ("100000001", "Hope Childrens Foundation", "Austin", "TX"),
            ("100000002", "Hopewell Community Church", "Dallas", "TX"),
            ("100000003", "Riverside Animal Shelter", "Portland", "OR"),
            ("200000004", "Childrens Hospital of Boston", "Boston", "MA"),
        ]:
            self.db.orgs.upsert_organization(ein, name, {"city": city, "state": state})
        self.db.commit()
        self.db.orgs.rebuild_search_index()

    def tearDown(self):
        self.db.close()

    def _names(self, res):
        return sorted(o["name"] for o in res["organizations"])

    def test_strict_name_substring(self):
        r = self.db.orgs.search_organizations("hope")
        self.assertEqual(r["mode"], "strict")
        self.assertEqual(self._names(r), ["Hope Childrens Foundation", "Hopewell Community Church"])

    def test_fuzzy_name_typo(self):
        r = self.db.orgs.search_organizations("childen", fuzzy=True)   # typo for "children"
        self.assertEqual(r["mode"], "fuzzy")
        names = [o["name"] for o in r["organizations"]]
        self.assertIn("Hope Childrens Foundation", names)
        self.assertIn("Childrens Hospital of Boston", names)

    def test_fuzzy_short_query_falls_back_to_strict(self):
        r = self.db.orgs.search_organizations("ho", fuzzy=True)   # <3 chars
        self.assertEqual(r["mode"], "strict")

    def test_ein_prefix_forward_only(self):
        r = self.db.orgs.search_organizations(ein="10000000")
        self.assertEqual(len(r["organizations"]), 3)            # the three 100000* orgs
        self.assertEqual(self.db.orgs.search_organizations(ein="0000")["total"], 0)  # not a substring

    def test_state_exact(self):
        self.assertEqual(self.db.orgs.search_organizations(state="TX")["total"], 2)
        self.assertEqual(self.db.orgs.search_organizations(state="tx")["total"], 2)   # case-insensitive

    def test_city_exact_not_substring(self):
        self.assertEqual(self.db.orgs.search_organizations(city="Austin")["total"], 1)
        self.assertEqual(self.db.orgs.search_organizations(city="Aust")["total"], 0)  # exact, not prefix

    def test_combined_fuzzy_and_state(self):
        r = self.db.orgs.search_organizations("childen", fuzzy=True, state="TX")
        self.assertEqual(self._names(r), ["Hope Childrens Foundation"])

    def test_search_results_include_address(self):
        r = self.db.orgs.search_organizations(state="OR")
        self.assertEqual(r["organizations"][0]["address"]["city"], "Portland")

    def test_list_states_and_cities(self):
        states = {s["code"] for s in self.db.orgs.list_states()}
        self.assertEqual(states, {"TX", "OR", "MA"})
        self.assertEqual(self.db.orgs.list_cities("TX"), ["Austin", "Dallas"])

    def test_fuzzy_self_heals_stale_index(self):
        # An org inserted without the per-org FTS sync (mimics the raw bulk path)
        # is detected as stale (count mismatch) and a fuzzy search self-heals.
        self.db.cursor.execute(
            "INSERT OR IGNORE INTO organization (ein, name) VALUES ('900000009', 'Childrens Refuge Center')")
        self.db.connection.commit()
        self.assertTrue(self.db.orgs._fts_stale())
        r = self.db.orgs.search_organizations("childen", fuzzy=True)   # triggers rebuild
        self.assertTrue(any(o["ein"] == "900000009" for o in r["organizations"]))
        self.assertFalse(self.db.orgs._fts_stale())                    # healed

    def test_no_filters_requires_something(self):
        # The router enforces "at least one of q/ein/state/city"; the repo simply
        # returns everything when called with nothing (used by list paths).
        r = self.db.orgs.search_organizations()
        self.assertEqual(r["total"], 4)


if __name__ == '__main__':  # pragma: no cover
    unittest.main()
