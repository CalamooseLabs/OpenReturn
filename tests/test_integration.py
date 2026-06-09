"""
Integration tests covering three levels:
  1. Unzipper → IRS990Parser  (no DB)
  2. Unzipper → IRS990Parser → IRS990Database  (full pipeline)
  3. Real ZIP fixtures from tests/data/zips/  (skipped when absent)
"""
import io
import os
import shutil
import sys
import tempfile
import unittest
import zipfile

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

from unzipper import Unzipper
from parser.IRS990 import IRS990Parser
from database.IRS990 import IRS990Database
from tests.fixtures import (
    VALID_990_XML,
    VALID_990_XML_2,
    MISSING_EIN_XML,
    FIXTURE_ZIPS_DIR,
    FIXTURE_BAD_ZIPS_DIR,
)

_EIN_PATH   = "ReturnHeader/Filer/EIN"
_NAME_PATH  = "ReturnHeader/Filer/BusinessName/BusinessNameLine1Txt"
_YEAR_PATH  = "ReturnHeader/TaxYr"
_FORM_PATH  = "ReturnHeader/ReturnTypeCd"


def _make_zip(directory: str, name: str, files: dict[str, str]) -> str:
    path = os.path.join(directory, name)
    with zipfile.ZipFile(path, 'w') as zf:
        for fname, content in files.items():
            zf.writestr(fname, content)
    return path


def _run_pipeline(zip_path: str, db: IRS990Database) -> list[dict]:
    """Full Unzipper → Parser → DB pipeline. Returns one result dict per XML."""
    xpath_index = db.get_xpath_index()
    results = []
    uz = Unzipper(zip_path)
    for entry in uz:
        if not entry.name().endswith('.xml'):
            continue
        parser = IRS990Parser(entry.read())
        ein       = parser.getElem(_EIN_PATH)
        name      = parser.getElem(_NAME_PATH)
        year      = parser.getElem(_YEAR_PATH)
        form_code = parser.getElem(_FORM_PATH)
        if not all([ein, name, year, form_code]):
            results.append({"file": entry.name(), "status": "error"})
            continue
        db.upsert_organization(ein, name)
        filing_id = db.create_filing(ein, int(year), form_code)
        values = {}
        for xpath, field_id in xpath_index.items():
            value = parser.getElem(xpath)
            if value is not None:
                values[field_id] = value
        db.store_reported_data(filing_id, values)
        results.append({
            "file": entry.name(), "status": "stored",
            "filing_id": filing_id, "ein": ein,
            "year": year, "form_code": form_code,
            "fields_stored": len(values),
        })
    uz.close()
    return results


# ---------------------------------------------------------------------------
# 1. Unzipper → IRS990Parser  (no DB)
# ---------------------------------------------------------------------------

class TestUnzipperToParser(unittest.TestCase):

    def setUp(self):
        self._tmpdir = tempfile.mkdtemp()

    def tearDown(self):
        import shutil; shutil.rmtree(self._tmpdir, ignore_errors=True)

    def _zip(self, **files):
        return _make_zip(self._tmpdir, 'test.zip', files)

    def test_xml_from_zip_parses_without_error(self):
        path = self._zip(**{'filing.xml': VALID_990_XML})
        uz = Unzipper(path)
        for entry in uz:
            IRS990Parser(entry.read())  # must not raise
        uz.close()

    def test_parser_reads_ein_from_zip(self):
        path = self._zip(**{'filing.xml': VALID_990_XML})
        uz = Unzipper(path)
        for entry in uz:
            parser = IRS990Parser(entry.read())
            self.assertEqual(parser.getElem(_EIN_PATH), "123456789")
        uz.close()

    def test_parser_reads_name_from_zip(self):
        path = self._zip(**{'filing.xml': VALID_990_XML})
        uz = Unzipper(path)
        for entry in uz:
            parser = IRS990Parser(entry.read())
            self.assertEqual(parser.getElem(_NAME_PATH), "Test Org")
        uz.close()

    def test_parser_reads_year_from_zip(self):
        path = self._zip(**{'filing.xml': VALID_990_XML})
        uz = Unzipper(path)
        for entry in uz:
            parser = IRS990Parser(entry.read())
            self.assertEqual(parser.getElem(_YEAR_PATH), "2023")
        uz.close()

    def test_parser_reads_form_code_from_zip(self):
        path = self._zip(**{'filing.xml': VALID_990_XML})
        uz = Unzipper(path)
        for entry in uz:
            parser = IRS990Parser(entry.read())
            self.assertEqual(parser.getElem(_FORM_PATH), "990")
        uz.close()

    def test_parser_reads_field_value_from_zip(self):
        path = self._zip(**{'filing.xml': VALID_990_XML})
        uz = Unzipper(path)
        for entry in uz:
            parser = IRS990Parser(entry.read())
            self.assertEqual(
                parser.getElem("ReturnData/IRS990/ActivityOrMissionDesc"),
                "Test mission"
            )
        uz.close()

    def test_multiple_xmls_in_zip_parse_independently(self):
        path = self._zip(**{'a.xml': VALID_990_XML, 'b.xml': VALID_990_XML_2})
        uz = Unzipper(path)
        eins = []
        for entry in uz:
            parser = IRS990Parser(entry.read())
            eins.append(parser.getElem(_EIN_PATH))
        uz.close()
        self.assertEqual(sorted(eins), ["123456789", "987654321"])

    def test_each_file_gets_fresh_parser_state(self):
        # Both XMLs have ActivityOrMissionDesc — each parser must return its own value.
        path = self._zip(**{'a.xml': VALID_990_XML, 'b.xml': VALID_990_XML_2})
        uz = Unzipper(path)
        missions = []
        for entry in uz:
            parser = IRS990Parser(entry.read())
            missions.append(parser.getElem("ReturnData/IRS990/ActivityOrMissionDesc"))
        uz.close()
        self.assertIn("Test mission", missions)
        self.assertIn("Beta mission", missions)

    def test_non_xml_files_in_zip_skipped_by_caller(self):
        path = self._zip(**{'filing.xml': VALID_990_XML, 'readme.txt': 'ignore'})
        uz = Unzipper(path)
        xml_count = sum(1 for e in uz if e.name().endswith('.xml'))
        uz.close()
        self.assertEqual(xml_count, 1)

    def test_missing_ein_xml_returns_none_for_ein(self):
        path = self._zip(**{'bad.xml': MISSING_EIN_XML})
        uz = Unzipper(path)
        for entry in uz:
            parser = IRS990Parser(entry.read())
            self.assertIsNone(parser.getElem(_EIN_PATH))
        uz.close()


# ---------------------------------------------------------------------------
# 2. Unzipper → IRS990Parser → IRS990Database  (full pipeline)
# ---------------------------------------------------------------------------

class TestPipelineEndToEnd(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        cls.db = IRS990Database(path=":memory:")
        cls._tmpdir = tempfile.mkdtemp()

    @classmethod
    def tearDownClass(cls):
        cls.db.close()
        shutil.rmtree(cls._tmpdir, ignore_errors=True)

    def setUp(self):
        self.db.cursor.executescript(
            "DELETE FROM reported_data; DELETE FROM filing; DELETE FROM organization;"
        )

    def _zip(self, name='test.zip', **files):
        return _make_zip(self.__class__._tmpdir, name, files)

    def _run(self, zip_path):
        return _run_pipeline(zip_path, self.db)

    # --- single filing ---

    def test_pipeline_returns_stored_status(self):
        results = self._run(self._zip(**{'filing.xml': VALID_990_XML}))
        self.assertEqual(results[0]['status'], 'stored')

    def test_pipeline_creates_organization(self):
        self._run(self._zip(**{'filing.xml': VALID_990_XML}))
        count = self.db.cursor.execute(
            "SELECT COUNT(*) FROM organization WHERE ein = ?", ("123456789",)
        ).fetchone()[0]
        self.assertEqual(count, 1)

    def test_pipeline_correct_ein_stored(self):
        self._run(self._zip(**{'filing.xml': VALID_990_XML}))
        org = self.db.get_organization("123456789")
        self.assertIsNotNone(org)
        self.assertEqual(org['ein'], "123456789")

    def test_pipeline_correct_name_stored(self):
        self._run(self._zip(**{'filing.xml': VALID_990_XML}))
        org = self.db.get_organization("123456789")
        self.assertEqual(org['name'], "Test Org")

    def test_pipeline_creates_filing(self):
        results = self._run(self._zip(**{'filing.xml': VALID_990_XML}))
        filing = self.db.get_filing(results[0]['filing_id'])
        self.assertIsNotNone(filing)

    def test_pipeline_correct_year_in_filing(self):
        results = self._run(self._zip(**{'filing.xml': VALID_990_XML}))
        filing = self.db.get_filing(results[0]['filing_id'])
        self.assertEqual(filing['year'], 2023)

    def test_pipeline_correct_form_code_in_filing(self):
        results = self._run(self._zip(**{'filing.xml': VALID_990_XML}))
        filing = self.db.get_filing(results[0]['filing_id'])
        self.assertEqual(filing['form_code'], "990")

    def test_pipeline_filing_linked_to_correct_org(self):
        results = self._run(self._zip(**{'filing.xml': VALID_990_XML}))
        filing = self.db.get_filing(results[0]['filing_id'])
        self.assertEqual(filing['ein'], "123456789")

    def test_pipeline_stores_reported_data(self):
        results = self._run(self._zip(**{'filing.xml': VALID_990_XML}))
        data = self.db.get_reported_data(results[0]['filing_id'])
        self.assertIsInstance(data, list)
        self.assertGreater(len(data), 0)

    def test_pipeline_known_field_value_stored(self):
        results = self._run(self._zip(**{'filing.xml': VALID_990_XML}))
        data = self.db.get_reported_data(results[0]['filing_id'])
        mission_row = next(
            (r for r in data if r['xml_path'] == 'ReturnData/IRS990/ActivityOrMissionDesc'),
            None
        )
        self.assertIsNotNone(mission_row)
        self.assertEqual(mission_row['value'], "Test mission")

    def test_pipeline_fields_stored_count_matches_db(self):
        results = self._run(self._zip(**{'filing.xml': VALID_990_XML}))
        db_count = self.db.cursor.execute(
            "SELECT COUNT(*) FROM reported_data rd JOIN filing f ON f.filing_id = rd.filing_id "
            "WHERE f.uuid = ?",
            (results[0]['filing_id'],)
        ).fetchone()[0]
        self.assertEqual(results[0]['fields_stored'], db_count)

    def test_pipeline_returns_filing_id_in_result(self):
        results = self._run(self._zip(**{'filing.xml': VALID_990_XML}))
        self.assertIn('filing_id', results[0])
        self.assertIsInstance(results[0]['filing_id'], str)

    # --- non-XML files ---

    def test_pipeline_skips_non_xml_files(self):
        results = self._run(self._zip(**{'filing.xml': VALID_990_XML, 'readme.txt': 'skip'}))
        self.assertEqual(len(results), 1)

    def test_pipeline_non_xml_files_leave_no_db_rows(self):
        self._run(self._zip(**{'readme.txt': 'skip me'}))
        count = self.db.cursor.execute("SELECT COUNT(*) FROM filing").fetchone()[0]
        self.assertEqual(count, 0)

    # --- missing header fields ---

    def test_pipeline_missing_ein_returns_error_status(self):
        results = self._run(self._zip(**{'bad.xml': MISSING_EIN_XML}))
        self.assertEqual(results[0]['status'], 'error')

    def test_pipeline_missing_ein_creates_no_org(self):
        self._run(self._zip(**{'bad.xml': MISSING_EIN_XML}))
        count = self.db.cursor.execute("SELECT COUNT(*) FROM organization").fetchone()[0]
        self.assertEqual(count, 0)

    def test_pipeline_missing_ein_creates_no_filing(self):
        self._run(self._zip(**{'bad.xml': MISSING_EIN_XML}))
        count = self.db.cursor.execute("SELECT COUNT(*) FROM filing").fetchone()[0]
        self.assertEqual(count, 0)

    # --- multiple XMLs in one ZIP ---

    def test_pipeline_multiple_xmls_returns_all_results(self):
        results = self._run(self._zip(**{'a.xml': VALID_990_XML, 'b.xml': VALID_990_XML_2}))
        self.assertEqual(len(results), 2)

    def test_pipeline_multiple_xmls_all_stored(self):
        results = self._run(self._zip(**{'a.xml': VALID_990_XML, 'b.xml': VALID_990_XML_2}))
        self.assertTrue(all(r['status'] == 'stored' for r in results))

    def test_pipeline_multiple_xmls_create_multiple_orgs(self):
        self._run(self._zip(**{'a.xml': VALID_990_XML, 'b.xml': VALID_990_XML_2}))
        count = self.db.cursor.execute("SELECT COUNT(*) FROM organization").fetchone()[0]
        self.assertEqual(count, 2)

    def test_pipeline_multiple_xmls_create_multiple_filings(self):
        self._run(self._zip(**{'a.xml': VALID_990_XML, 'b.xml': VALID_990_XML_2}))
        count = self.db.cursor.execute("SELECT COUNT(*) FROM filing").fetchone()[0]
        self.assertEqual(count, 2)

    def test_pipeline_same_xml_twice_is_idempotent(self):
        # Same org/year/form_code deduplicates to one filing
        self._run(self._zip(**{'a.xml': VALID_990_XML, 'b.xml': VALID_990_XML}))
        count = self.db.cursor.execute("SELECT COUNT(*) FROM filing").fetchone()[0]
        self.assertEqual(count, 1)

    def test_pipeline_same_xml_twice_creates_one_org(self):
        self._run(self._zip(**{'a.xml': VALID_990_XML, 'b.xml': VALID_990_XML}))
        count = self.db.cursor.execute("SELECT COUNT(*) FROM organization").fetchone()[0]
        self.assertEqual(count, 1)

    def test_pipeline_correct_eins_for_multiple_orgs(self):
        self._run(self._zip(**{'a.xml': VALID_990_XML, 'b.xml': VALID_990_XML_2}))
        eins = {r[0] for r in self.db.cursor.execute("SELECT ein FROM organization").fetchall()}
        self.assertIn("123456789", eins)
        self.assertIn("987654321", eins)

    def test_pipeline_mixed_valid_invalid_processes_valid(self):
        results = self._run(self._zip(**{'good.xml': VALID_990_XML, 'bad.xml': MISSING_EIN_XML}))
        statuses = {r['file']: r['status'] for r in results}
        self.assertEqual(statuses['good.xml'], 'stored')
        self.assertEqual(statuses['bad.xml'], 'error')

    def test_pipeline_mixed_stores_only_valid_org(self):
        self._run(self._zip(**{'good.xml': VALID_990_XML, 'bad.xml': MISSING_EIN_XML}))
        count = self.db.cursor.execute("SELECT COUNT(*) FROM organization").fetchone()[0]
        self.assertEqual(count, 1)


# ---------------------------------------------------------------------------
# 3. Real ZIP fixtures from tests/data/zips/
# ---------------------------------------------------------------------------

def _find_zips(directory):
    if not directory.exists():
        return []
    return sorted(directory.glob('*.zip'))


class TestZipFixtures(unittest.TestCase):
    """
    Tests against real IRS ZIP files placed in tests/data/zips/ (good) and
    tests/data/zips/bad/ (broken headers that should trigger the unzip fallback).
    All tests skip automatically when no ZIPs are present.
    """

    # --- Good ZIPs ---

    def test_good_zips_open_without_error(self):
        zips = _find_zips(FIXTURE_ZIPS_DIR)
        if not zips:
            self.skipTest("No fixture ZIPs in tests/data/zips/")
        for zip_path in zips:
            with self.subTest(zip=zip_path.name):
                uz = Unzipper(str(zip_path))
                uz.close()

    def test_good_zips_use_zipfile_path(self):
        zips = _find_zips(FIXTURE_ZIPS_DIR)
        if not zips:
            self.skipTest("No fixture ZIPs in tests/data/zips/")
        for zip_path in zips:
            with self.subTest(zip=zip_path.name):
                uz = Unzipper(str(zip_path))
                self.assertIsNotNone(uz._zip, f"{zip_path.name} unexpectedly used fallback")
                uz.close()

    def test_good_zips_yield_at_least_one_file(self):
        zips = _find_zips(FIXTURE_ZIPS_DIR)
        if not zips:
            self.skipTest("No fixture ZIPs in tests/data/zips/")
        for zip_path in zips:
            with self.subTest(zip=zip_path.name):
                uz = Unzipper(str(zip_path))
                names = [e.name() for e in uz]
                uz.close()
                self.assertGreater(len(names), 0, f"{zip_path.name} contained no files")

    def test_good_zips_contain_xml_files(self):
        zips = _find_zips(FIXTURE_ZIPS_DIR)
        if not zips:
            self.skipTest("No fixture ZIPs in tests/data/zips/")
        for zip_path in zips:
            with self.subTest(zip=zip_path.name):
                uz = Unzipper(str(zip_path))
                xml_names = [e.name() for e in uz if e.name().endswith('.xml')]
                uz.close()
                self.assertGreater(len(xml_names), 0, f"{zip_path.name} has no .xml files")

    def test_good_zips_files_readable_as_strings(self):
        zips = _find_zips(FIXTURE_ZIPS_DIR)
        if not zips:
            self.skipTest("No fixture ZIPs in tests/data/zips/")
        for zip_path in zips:
            with self.subTest(zip=zip_path.name):
                uz = Unzipper(str(zip_path))
                for entry in uz:
                    if entry.name().endswith('.xml'):
                        content = entry.read()
                        self.assertIsInstance(content, str)
                        self.assertGreater(len(content), 0)
                uz.close()

    def test_good_zips_xml_files_parse_without_error(self):
        zips = _find_zips(FIXTURE_ZIPS_DIR)
        if not zips:
            self.skipTest("No fixture ZIPs in tests/data/zips/")
        for zip_path in zips:
            with self.subTest(zip=zip_path.name):
                uz = Unzipper(str(zip_path))
                for entry in uz:
                    if entry.name().endswith('.xml'):
                        with self.subTest(file=entry.name()):
                            IRS990Parser(entry.read())  # must not raise
                uz.close()

    def test_good_zips_pipeline_runs_without_error(self):
        zips = _find_zips(FIXTURE_ZIPS_DIR)
        if not zips:
            self.skipTest("No fixture ZIPs in tests/data/zips/")
        db = IRS990Database(path=":memory:")
        for zip_path in zips:
            with self.subTest(zip=zip_path.name):
                results = _run_pipeline(str(zip_path), db)
                for r in results:
                    self.assertIn(r['status'], ('stored', 'error'),
                                  f"Unexpected status in {zip_path.name}: {r}")
        db.close()

    def test_good_zips_pipeline_stores_at_least_one_filing(self):
        zips = _find_zips(FIXTURE_ZIPS_DIR)
        if not zips:
            self.skipTest("No fixture ZIPs in tests/data/zips/")
        db = IRS990Database(path=":memory:")
        for zip_path in zips:
            with self.subTest(zip=zip_path.name):
                results = _run_pipeline(str(zip_path), db)
                stored = [r for r in results if r['status'] == 'stored']
                self.assertGreater(len(stored), 0, f"{zip_path.name} stored no filings")
        db.close()

    # --- Bad ZIPs (broken headers — should trigger unzip fallback) ---

    def test_bad_zips_open_without_error(self):
        zips = _find_zips(FIXTURE_BAD_ZIPS_DIR)
        if not zips:
            self.skipTest("No fixture ZIPs in tests/data/zips/bad/")
        for zip_path in zips:
            with self.subTest(zip=zip_path.name):
                uz = Unzipper(str(zip_path))
                uz.close()

    def test_bad_zips_use_fallback_path(self):
        zips = _find_zips(FIXTURE_BAD_ZIPS_DIR)
        if not zips:
            self.skipTest("No fixture ZIPs in tests/data/zips/bad/")
        for zip_path in zips:
            with self.subTest(zip=zip_path.name):
                uz = Unzipper(str(zip_path))
                self.assertIsNone(uz._zip, f"{zip_path.name} did not use fallback")
                self.assertIsNotNone(uz._tmpdir)
                uz.close()

    def test_bad_zips_yield_xml_files(self):
        zips = _find_zips(FIXTURE_BAD_ZIPS_DIR)
        if not zips:
            self.skipTest("No fixture ZIPs in tests/data/zips/bad/")
        for zip_path in zips:
            with self.subTest(zip=zip_path.name):
                uz = Unzipper(str(zip_path))
                xml_names = [e.name() for e in uz if e.name().endswith('.xml')]
                uz.close()
                self.assertGreater(len(xml_names), 0, f"{zip_path.name} has no .xml files")

    def test_bad_zips_files_readable_as_strings(self):
        zips = _find_zips(FIXTURE_BAD_ZIPS_DIR)
        if not zips:
            self.skipTest("No fixture ZIPs in tests/data/zips/bad/")
        for zip_path in zips:
            with self.subTest(zip=zip_path.name):
                uz = Unzipper(str(zip_path))
                for entry in uz:
                    if entry.name().endswith('.xml'):
                        content = entry.read()
                        self.assertIsInstance(content, str)
                        self.assertGreater(len(content), 0)
                uz.close()

    def test_bad_zips_xml_files_parse_without_error(self):
        zips = _find_zips(FIXTURE_BAD_ZIPS_DIR)
        if not zips:
            self.skipTest("No fixture ZIPs in tests/data/zips/bad/")
        for zip_path in zips:
            with self.subTest(zip=zip_path.name):
                uz = Unzipper(str(zip_path))
                for entry in uz:
                    if entry.name().endswith('.xml'):
                        with self.subTest(file=entry.name()):
                            IRS990Parser(entry.read())
                uz.close()

    def test_bad_zips_pipeline_runs_without_error(self):
        zips = _find_zips(FIXTURE_BAD_ZIPS_DIR)
        if not zips:
            self.skipTest("No fixture ZIPs in tests/data/zips/bad/")
        db = IRS990Database(path=":memory:")
        for zip_path in zips:
            with self.subTest(zip=zip_path.name):
                results = _run_pipeline(str(zip_path), db)
                for r in results:
                    self.assertIn(r['status'], ('stored', 'error'))
        db.close()

    def test_bad_zips_fallback_tempdir_cleaned_up_after_close(self):
        zips = _find_zips(FIXTURE_BAD_ZIPS_DIR)
        if not zips:
            self.skipTest("No fixture ZIPs in tests/data/zips/bad/")
        for zip_path in zips:
            with self.subTest(zip=zip_path.name):
                uz = Unzipper(str(zip_path))
                tmpdir = uz._tmpdir
                uz.close()
                self.assertFalse(os.path.isdir(tmpdir))


if __name__ == '__main__':
    unittest.main()
