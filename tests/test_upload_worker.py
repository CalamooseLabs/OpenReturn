"""Tests for worker functions and UploadRouter methods in router/Upload/upload.py."""

import contextlib
import io
import os
import sys
import tempfile
import unittest
import zipfile
from pathlib import Path
from unittest.mock import MagicMock, patch

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

import router.Upload.upload as upload_mod
from router.Upload import UploadRouter

_FULL_XML = b"""<?xml version="1.0" encoding="UTF-8"?>
<Return xmlns="http://www.irs.gov/efile">
  <ReturnHeader>
    <Filer>
      <EIN>123456789</EIN>
      <BusinessName>
        <BusinessNameLine1Txt>Test Organization</BusinessNameLine1Txt>
      </BusinessName>
    </Filer>
    <TaxYr>2023</TaxYr>
    <ReturnTypeCd>990</ReturnTypeCd>
  </ReturnHeader>
</Return>"""


def _make_mock_db():
    mock_db = MagicMock()
    mock_db.get_xpath_index.return_value = {}
    mock_db.get_supported_forms.return_value = {"990"}
    mock_db.create_filing.return_value = "test-uuid"
    return mock_db


def _zip_with(tmpdir, filename, content, zip_name="test.zip"):
    zip_path = Path(tmpdir) / zip_name
    with zipfile.ZipFile(zip_path, 'w') as zf:
        zf.writestr(filename, content)
    return zip_path


# ---------------------------------------------------------------------------
# _worker_init
# ---------------------------------------------------------------------------

class TestWorkerInit(unittest.TestCase):

    def test_sets_xpath_index(self):
        xpath = {"ReturnData/IRS990/ActivityOrMissionDesc": 1}
        upload_mod._worker_init(xpath, set())
        self.assertEqual(upload_mod._xpath_index, xpath)

    def test_sets_supported_forms(self):
        upload_mod._worker_init({}, {"990", "990EZ"})
        self.assertEqual(upload_mod._supported_forms, {"990", "990EZ"})


# ---------------------------------------------------------------------------
# _parse_xml_task
# ---------------------------------------------------------------------------

class TestParseXmlTask(unittest.TestCase):
    """The worker now receives already-read XML bytes (the main process reads
    them), so these pass bytes directly rather than a ZIP path."""

    def setUp(self):
        upload_mod._worker_init({"ReturnData/IRS990/CYTotalRevenueAmt": 1}, {"990"})

    def test_returns_parsed_for_valid_xml(self):
        result = upload_mod._parse_xml_task((_FULL_XML, "filing.xml", "test.zip"))
        self.assertEqual(result["status"], "parsed")
        self.assertEqual(result["ein"], "123456789")
        self.assertEqual(result["year"], 2023)

    def test_returns_skipped_for_unsupported_form(self):
        xml = _FULL_XML.replace(b"<ReturnTypeCd>990</ReturnTypeCd>",
                                 b"<ReturnTypeCd>UNSUPPORTED</ReturnTypeCd>")
        result = upload_mod._parse_xml_task((xml, "filing.xml", "test.zip"))
        self.assertEqual(result["status"], "skipped")
        self.assertIn("unsupported", result["reason"])

    def test_returns_error_for_missing_header_fields(self):
        xml = b"""<?xml version="1.0"?>
<Return xmlns="http://www.irs.gov/efile">
  <ReturnHeader>
    <TaxYr>2023</TaxYr>
    <ReturnTypeCd>990</ReturnTypeCd>
  </ReturnHeader>
</Return>"""
        result = upload_mod._parse_xml_task((xml, "filing.xml", "test.zip"))
        self.assertEqual(result["status"], "error")
        self.assertIn("missing", result["reason"])

    def test_returns_error_for_invalid_xml(self):
        result = upload_mod._parse_xml_task((b"not xml content", "filing.xml", "test.zip"))
        self.assertEqual(result["status"], "error")

    def test_extracts_value_when_element_found(self):
        """Covers values[field_id] = text when a mapped path is present."""
        upload_mod._worker_init({"ReturnHeader/TaxYr": 999}, {"990"})
        result = upload_mod._parse_xml_task((_FULL_XML, "filing.xml", "test.zip"))
        self.assertEqual(result["status"], "parsed")
        self.assertIn(999, result["values"])
        self.assertEqual(result["values"][999], "2023")

    def test_walk_keeps_first_occurrence_of_repeated_path(self):
        """The single-pass walk uses setdefault, matching find()'s first-match."""
        xml = _FULL_XML.replace(
            b"</ReturnHeader>",
            b"</ReturnHeader><ReturnData><IRS990>"
            b"<Dup>first</Dup><Dup>second</Dup></IRS990></ReturnData>",
        )
        upload_mod._worker_init({"ReturnData/IRS990/Dup": 7}, {"990"})
        result = upload_mod._parse_xml_task((xml, "filing.xml", "test.zip"))
        self.assertEqual(result["values"][7], "first")


# ---------------------------------------------------------------------------
# _parse_xml_batch
# ---------------------------------------------------------------------------

class TestParseXmlBatch(unittest.TestCase):

    def setUp(self):
        upload_mod._worker_init({"ReturnHeader/TaxYr": 999}, {"990"})

    def test_returns_one_result_per_task(self):
        batch = [
            (_FULL_XML, "a.xml", "test.zip"),
            (b"not xml", "b.xml", "test.zip"),
        ]
        results = upload_mod._parse_xml_batch(batch)
        self.assertEqual(len(results), 2)
        self.assertEqual(results[0]["status"], "parsed")
        self.assertEqual(results[0]["file"], "a.xml")
        self.assertEqual(results[1]["status"], "error")

    def test_empty_batch_returns_empty_list(self):
        self.assertEqual(upload_mod._parse_xml_batch([]), [])


# ---------------------------------------------------------------------------
# UploadRouter._store_parsed
# ---------------------------------------------------------------------------

class TestStoreParsed(unittest.TestCase):

    def setUp(self):
        self.mock_db = _make_mock_db()
        self.router = UploadRouter(db=self.mock_db)
        self.results = []

    def _parsed(self, **overrides):
        base = {
            'ein': '123456789', 'name': 'Test Org', 'year': 2023,
            'form_code': '990', 'file': 'f.xml', 'zip_filename': 'z.zip',
            'values': {1: 'val'},
        }
        base.update(overrides)
        return base

    def test_returns_stored(self):
        status = self.router._store_parsed(self._parsed(), self.results)
        self.assertEqual(status, "stored")

    def test_appends_result_to_list(self):
        self.router._store_parsed(self._parsed(), self.results)
        self.assertEqual(len(self.results), 1)

    def test_result_status_is_stored(self):
        self.router._store_parsed(self._parsed(), self.results)
        self.assertEqual(self.results[0]["status"], "stored")

    def test_result_has_expected_keys(self):
        self.router._store_parsed(self._parsed(), self.results)
        for key in ("file", "status", "filing_id", "ein", "year", "form", "fields_stored"):
            self.assertIn(key, self.results[0])

    def test_calls_upsert_organization(self):
        self.router._store_parsed(self._parsed(), self.results)
        self.mock_db.upsert_organization.assert_called_once_with("123456789", "Test Org")

    def test_calls_create_filing(self):
        self.router._store_parsed(self._parsed(), self.results)
        self.mock_db.create_filing.assert_called_once()

    def test_calls_store_reported_data(self):
        self.router._store_parsed(self._parsed(), self.results)
        self.mock_db.store_reported_data.assert_called_once()

    def test_fields_stored_count(self):
        self.router._store_parsed(
            self._parsed(values={1: 'a', 2: 'b', 3: 'c'}), self.results
        )
        self.assertEqual(self.results[0]["fields_stored"], 3)


# ---------------------------------------------------------------------------
# UploadRouter.process_zip_dir (lines 214-215, 220-227)
# ---------------------------------------------------------------------------

class TestProcessZipDir(unittest.TestCase):

    def setUp(self):
        self.mock_db = _make_mock_db()
        self.router = UploadRouter(db=self.mock_db, workers=2)

    def _make_zip(self, tmpdir, name, files):
        zip_path = Path(tmpdir) / name
        with zipfile.ZipFile(zip_path, 'w') as zf:
            for fname, content in files.items():
                zf.writestr(fname, content)
        return zip_path

    def _mock_pool(self, future_result=None):
        mock_future = MagicMock()
        mock_future.result.return_value = future_result

        mock_pool = MagicMock()
        mock_pool.__enter__ = MagicMock(return_value=mock_pool)
        mock_pool.__exit__ = MagicMock(return_value=False)
        mock_pool.submit.return_value = mock_future
        return mock_pool, mock_future

    @staticmethod
    def _fake_as_completed(futures):
        return iter(futures.keys())

    def test_parsed_result_calls_store_parsed(self):
        """Covers lines 220-222: _store_parsed called for 'parsed' status."""
        parsed = {
            'status': 'parsed', 'ein': '123456789', 'name': 'Test', 'year': 2023,
            'form_code': '990', 'file': 'f.xml', 'zip_filename': 'test.zip', 'values': {},
        }
        mock_pool, _ = self._mock_pool(future_result=parsed)

        with tempfile.TemporaryDirectory() as td:
            self._make_zip(td, "test.zip", {"f.xml": _FULL_XML})
            with patch('router.Upload.upload.ProcessPoolExecutor', return_value=mock_pool), \
                 patch('router.Upload.upload.as_completed', side_effect=self._fake_as_completed):
                results = self.router.process_zip_dir(Path(td))

        stored = [r for r in results if r.get("status") == "stored"]
        self.assertEqual(len(stored), 1)

    def test_read_exception_appends_error(self):
        """Covers lines 214-215: exception during file read/submit caught."""
        mock_pool, _ = self._mock_pool()
        mock_pool.submit.side_effect = RuntimeError("pool submit failed")

        with tempfile.TemporaryDirectory() as td:
            self._make_zip(td, "test.zip", {"f.xml": _FULL_XML})
            with patch('router.Upload.upload.ProcessPoolExecutor', return_value=mock_pool), \
                 patch('router.Upload.upload.as_completed', side_effect=self._fake_as_completed):
                results = self.router.process_zip_dir(Path(td))

        errors = [r for r in results if r.get("status") == "error"]
        self.assertEqual(len(errors), 1)

    def test_store_parsed_exception_appends_error(self):
        """Covers lines 226-227: exception inside _store_parsed caught."""
        parsed = {
            'status': 'parsed', 'ein': '123456789', 'name': 'Test', 'year': 2023,
            'form_code': '990', 'file': 'f.xml', 'zip_filename': 'test.zip', 'values': {},
        }
        mock_pool, _ = self._mock_pool(future_result=parsed)
        self.mock_db.create_filing.side_effect = RuntimeError("DB write failed")

        with tempfile.TemporaryDirectory() as td:
            self._make_zip(td, "test.zip", {"f.xml": _FULL_XML})
            with patch('router.Upload.upload.ProcessPoolExecutor', return_value=mock_pool), \
                 patch('router.Upload.upload.as_completed', side_effect=self._fake_as_completed):
                results = self.router.process_zip_dir(Path(td))

        errors = [r for r in results if r.get("status") == "error"]
        self.assertEqual(len(errors), 1)

    def test_batch_commit_at_batch_size(self):
        """Covers lines 223-225: mid-batch commit when uncommitted reaches _BATCH_SIZE."""
        self.router._BATCH_SIZE = 1
        parsed = {
            'status': 'parsed', 'ein': '123456789', 'name': 'Test', 'year': 2023,
            'form_code': '990', 'file': 'f.xml', 'zip_filename': 'test.zip', 'values': {},
        }
        mock_pool, _ = self._mock_pool(future_result=parsed)

        with tempfile.TemporaryDirectory() as td:
            self._make_zip(td, "test.zip", {"f.xml": _FULL_XML})
            with patch('router.Upload.upload.ProcessPoolExecutor', return_value=mock_pool), \
                 patch('router.Upload.upload.as_completed', side_effect=self._fake_as_completed):
                self.router.process_zip_dir(Path(td))

        # batch commit (uncommitted >= 1) + final commit = at least 2
        self.assertGreaterEqual(self.mock_db.commit.call_count, 2)


if __name__ == "__main__":
    unittest.main()
