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

    def setUp(self):
        upload_mod._zip_cache.clear()

    def test_sets_xpath_index(self):
        xpath = {"ReturnData/IRS990/ActivityOrMissionDesc": 1}
        upload_mod._worker_init(xpath, set())
        self.assertEqual(upload_mod._xpath_index, xpath)

    def test_sets_supported_forms(self):
        upload_mod._worker_init({}, {"990", "990EZ"})
        self.assertEqual(upload_mod._supported_forms, {"990", "990EZ"})

    def test_sets_xpath_compiled(self):
        xpath = {"ReturnData/IRS990/ActivityOrMissionDesc": 42}
        upload_mod._worker_init(xpath, set())
        expected_key = upload_mod._build_find("ReturnData/IRS990/ActivityOrMissionDesc")
        self.assertIn(expected_key, upload_mod._xpath_compiled)
        self.assertEqual(upload_mod._xpath_compiled[expected_key], 42)


# ---------------------------------------------------------------------------
# _parse_xml_task
# ---------------------------------------------------------------------------

class TestParseXmlTask(unittest.TestCase):

    def setUp(self):
        upload_mod._zip_cache.clear()
        upload_mod._worker_init({"ReturnData/IRS990/CYTotalRevenueAmt": 1}, {"990"})

    def test_returns_parsed_for_valid_xml(self):
        with tempfile.TemporaryDirectory() as td:
            zip_path = _zip_with(td, "filing.xml", _FULL_XML)
            result = upload_mod._parse_xml_task((str(zip_path), "filing.xml", "test.zip"))
        self.assertEqual(result["status"], "parsed")
        self.assertEqual(result["ein"], "123456789")
        self.assertEqual(result["year"], 2023)

    def test_returns_skipped_for_unsupported_form(self):
        xml = _FULL_XML.replace(b"<ReturnTypeCd>990</ReturnTypeCd>",
                                 b"<ReturnTypeCd>UNSUPPORTED</ReturnTypeCd>")
        with tempfile.TemporaryDirectory() as td:
            zip_path = _zip_with(td, "filing.xml", xml)
            result = upload_mod._parse_xml_task((str(zip_path), "filing.xml", "test.zip"))
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
        with tempfile.TemporaryDirectory() as td:
            zip_path = _zip_with(td, "filing.xml", xml)
            result = upload_mod._parse_xml_task((str(zip_path), "filing.xml", "test.zip"))
        self.assertEqual(result["status"], "error")
        self.assertIn("missing", result["reason"])

    def test_returns_error_for_invalid_xml(self):
        with tempfile.TemporaryDirectory() as td:
            zip_path = _zip_with(td, "filing.xml", b"not xml content")
            result = upload_mod._parse_xml_task((str(zip_path), "filing.xml", "test.zip"))
        self.assertEqual(result["status"], "error")

    def test_uses_zip_cache_on_second_call(self):
        with tempfile.TemporaryDirectory() as td:
            zip_path = _zip_with(td, "filing.xml", _FULL_XML)
            zip_str = str(zip_path)
            upload_mod._parse_xml_task((zip_str, "filing.xml", "test.zip"))
            self.assertIn(zip_str, upload_mod._zip_cache)
            result = upload_mod._parse_xml_task((zip_str, "filing.xml", "test.zip"))
        self.assertEqual(result["status"], "parsed")

    def test_extracts_value_when_element_found(self):
        """Covers line 89: values[field_id] = elem.text when XPath matches."""
        upload_mod._worker_init({"ReturnHeader/TaxYr": 999}, {"990"})
        with tempfile.TemporaryDirectory() as td:
            zip_path = _zip_with(td, "filing.xml", _FULL_XML)
            result = upload_mod._parse_xml_task((str(zip_path), "filing.xml", "test.zip"))
        self.assertEqual(result["status"], "parsed")
        self.assertIn(999, result["values"])
        self.assertEqual(result["values"][999], "2023")

    def test_notimplementederror_falls_back_to_subprocess(self):
        with tempfile.TemporaryDirectory() as td:
            zip_path_str = str(Path(td) / "fake.zip")
            mock_zf = MagicMock()
            mock_zf.read.side_effect = NotImplementedError
            upload_mod._zip_cache[zip_path_str] = mock_zf
            try:
                with patch('router.Upload.upload.subprocess.run') as mock_run:
                    mock_run.return_value.stdout = b"<not>valid xml</not>"
                    result = upload_mod._parse_xml_task((zip_path_str, "f.xml", "fake.zip"))
            finally:
                upload_mod._zip_cache.pop(zip_path_str, None)
        self.assertEqual(result["status"], "error")


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
