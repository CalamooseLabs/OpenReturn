"""Tests for console.py, main.py, keys.py, and ingest.py."""

import contextlib
import io
import os
import sys
import tempfile
import unittest
import zipfile
from pathlib import Path
from unittest.mock import MagicMock, patch

# Make both src/ and the project root importable.
_ROOT = os.path.join(os.path.dirname(__file__), '..')
_SRC  = os.path.join(_ROOT, 'src')
sys.path.insert(0, _SRC)
sys.path.insert(0, _ROOT)

# ---------------------------------------------------------------------------
# console.py
# ---------------------------------------------------------------------------

import console


class TestConsoleConstants(unittest.TestCase):
    """Importing console covers all lines; just verify the constants are there."""

    def test_bold_exists(self):
        self.assertTrue(hasattr(console, '_B'))

    def test_reset_exists(self):
        self.assertTrue(hasattr(console, '_R'))

    def test_dim_exists(self):
        self.assertTrue(hasattr(console, '_DIM'))

    def test_green_exists(self):
        self.assertTrue(hasattr(console, '_GRN'))

    def test_red_exists(self):
        self.assertTrue(hasattr(console, '_RED'))

    def test_yellow_exists(self):
        self.assertTrue(hasattr(console, '_YLW'))

    def test_cyan_exists(self):
        self.assertTrue(hasattr(console, '_CYN'))

    def test_magenta_exists(self):
        self.assertTrue(hasattr(console, '_MAG'))

    def test_clear_exists(self):
        self.assertTrue(hasattr(console, '_CLR'))

    def test_all_constants_are_strings(self):
        for name in ('_B', '_R', '_DIM', '_GRN', '_RED', '_YLW', '_CYN', '_MAG', '_CLR'):
            self.assertIsInstance(getattr(console, name), str, f"{name} should be str")


# ---------------------------------------------------------------------------
# main.py — _dump_db
# ---------------------------------------------------------------------------

import main as main_mod
from database.Score import ScoreDatabase


class TestDumpDb(unittest.TestCase):
    """_dump_db should run without raising against a real in-memory database."""

    @classmethod
    def setUpClass(cls):
        cls.db = ScoreDatabase(path=":memory:")

    @classmethod
    def tearDownClass(cls):
        cls.db.close()

    def setUp(self):
        self.db.cursor.executescript("""
            DELETE FROM organization_score_factor;
            DELETE FROM organization_score;
            DELETE FROM reported_data;
            DELETE FROM filing;
            DELETE FROM organization;
            DELETE FROM api_key;
        """)

    def test_empty_database_does_not_raise(self):
        buf = io.StringIO()
        with contextlib.redirect_stdout(buf):
            main_mod._dump_db(self.db)

    def test_with_organization_rows(self):
        self.db.upsert_organization("123456789", "Test Org")
        buf = io.StringIO()
        with contextlib.redirect_stdout(buf):
            main_mod._dump_db(self.db)

    def test_with_filing_rows(self):
        self.db.upsert_organization("123456789", "Test Org")
        self.db.create_filing("123456789", 2023, "990")
        buf = io.StringIO()
        with contextlib.redirect_stdout(buf):
            main_mod._dump_db(self.db)

    def test_output_contains_database_snapshot(self):
        buf = io.StringIO()
        with contextlib.redirect_stdout(buf):
            main_mod._dump_db(self.db)
        # Strip ANSI codes for a simple membership check
        raw = buf.getvalue()
        self.assertIn("Database snapshot", raw)

    def test_more_than_five_rows_triggers_ellipsis(self):
        ein_base = "10000000"
        for i in range(6):
            ein = f"{int(ein_base) + i:09d}"
            self.db.upsert_organization(ein, f"Org {i}")
            self.db.create_filing(ein, 2020 + i, "990")
        buf = io.StringIO()
        with contextlib.redirect_stdout(buf):
            main_mod._dump_db(self.db)
        raw = buf.getvalue()
        self.assertIn("more rows", raw)

    def test_user_table_absent_from_db_is_skipped(self):
        """Covers the 'if t not in all_tables: continue' branch (main.py line 54)."""
        mock_db = MagicMock()
        mock_cur = MagicMock()
        mock_db.cursor = mock_cur
        mock_cur.execute.return_value = mock_cur
        # Only 'organization' exists; 'filing', 'reported_data', etc. are absent
        mock_cur.fetchall.return_value = [('organization',)]
        mock_cur.fetchone.return_value = (0,)  # 0 rows so no preview fetch needed
        buf = io.StringIO()
        with contextlib.redirect_stdout(buf):
            main_mod._dump_db(mock_db)
        # Function should complete without raising despite missing tables


# ---------------------------------------------------------------------------
# main.py — main()
# ---------------------------------------------------------------------------

class TestMainFunction(unittest.TestCase):

    def _run_main(self, argv, extra_patches=None):
        """Helper: patch Server.run away, set sys.argv, call main()."""
        patches = [
            patch('sys.argv', argv),
            patch('main.Server.run', return_value=None),
        ]
        if extra_patches:
            patches.extend(extra_patches)
        with contextlib.ExitStack() as stack:
            mocks = [stack.enter_context(p) for p in patches]
            buf = io.StringIO()
            with contextlib.redirect_stdout(buf):
                result = main_mod.main()
        return result, mocks

    def test_default_args_returns_zero(self):
        result, _ = self._run_main(['main'])
        self.assertEqual(result, 0)

    def test_debug_flag_accepted(self):
        result, _ = self._run_main(['main', '--debug'])
        self.assertEqual(result, 0)

    def test_testing_flag_deletes_db_if_present(self):
        with tempfile.TemporaryDirectory() as td:
            old_cwd = os.getcwd()
            os.chdir(td)
            try:
                # Create a dummy IRS990.db so unlink has something to remove
                Path("IRS990.db").write_bytes(b"")
                result, _ = self._run_main(['main', '--testing'])
                self.assertEqual(result, 0)
                # File should have been recreated by ScoreDatabase init
            finally:
                os.chdir(old_cwd)

    def test_testing_flag_without_zip_dir(self):
        with tempfile.TemporaryDirectory() as td:
            old_cwd = os.getcwd()
            os.chdir(td)
            try:
                result, _ = self._run_main(['main', '--testing'])
                self.assertEqual(result, 0)
            finally:
                os.chdir(old_cwd)

    def test_testing_with_zip_dir_calls_process_zip_dir(self):
        with tempfile.TemporaryDirectory() as td:
            old_cwd = os.getcwd()
            os.chdir(td)
            try:
                mock_results = patch(
                    'main.UploadRouter.process_zip_dir',
                    return_value=[{'status': 'stored', 'file': 'x.xml', 'ein': '123'}],
                )
                result, _ = self._run_main(
                    ['main', '--testing', '--zip-dir', td],
                    extra_patches=[mock_results],
                )
                self.assertEqual(result, 0)
            finally:
                os.chdir(old_cwd)

    def test_auth_flag_accepted(self):
        result, _ = self._run_main(['main', '--auth'])
        self.assertEqual(result, 0)

    def test_custom_host_and_port(self):
        result, _ = self._run_main(['main', '--host', '0.0.0.0', '--port', '9090'])
        self.assertEqual(result, 0)


# ---------------------------------------------------------------------------
# keys.py
# ---------------------------------------------------------------------------

import keys as keys_mod


class TestRequireDb(unittest.TestCase):

    def test_exits_when_db_missing(self):
        with patch('keys.Path') as mock_path_cls:
            mock_path_cls.return_value.exists.return_value = False
            with self.assertRaises(SystemExit) as ctx:
                keys_mod._require_db()
            self.assertEqual(ctx.exception.code, 1)

    def test_returns_database_when_db_exists(self):
        with tempfile.TemporaryDirectory() as td:
            db_path = Path(td) / "IRS990.db"
            # Use a real in-memory db to avoid touching disk inside ScoreDatabase
            with patch('keys.Path') as mock_path_cls, \
                 patch('keys.ScoreDatabase') as mock_db_cls:
                mock_path_cls.return_value.exists.return_value = True
                mock_db_instance = MagicMock()
                mock_db_cls.return_value = mock_db_instance
                result = keys_mod._require_db()
                self.assertIs(result, mock_db_instance)


class TestCmdCreate(unittest.TestCase):

    def _make_args(self, name="Test Key", rate_limit=-1):
        args = MagicMock()
        args.name = name
        args.rate_limit = rate_limit
        return args

    def test_prints_key_info_and_returns_zero(self):
        mock_db = MagicMock()
        mock_db.create_api_key.return_value = (42, "rawtoken123")
        with patch('keys._require_db', return_value=mock_db):
            buf = io.StringIO()
            with contextlib.redirect_stdout(buf):
                result = keys_mod.cmd_create(self._make_args())
        self.assertEqual(result, 0)
        mock_db.create_api_key.assert_called_once_with("Test Key", rate_limit=-1)
        mock_db.close.assert_called_once()

    def test_output_contains_created(self):
        mock_db = MagicMock()
        mock_db.create_api_key.return_value = (1, "secret")
        with patch('keys._require_db', return_value=mock_db):
            buf = io.StringIO()
            with contextlib.redirect_stdout(buf):
                keys_mod.cmd_create(self._make_args("My Key"))
        self.assertIn("API key created", buf.getvalue())

    def test_output_contains_key_id(self):
        mock_db = MagicMock()
        mock_db.create_api_key.return_value = (99, "tok")
        with patch('keys._require_db', return_value=mock_db):
            buf = io.StringIO()
            with contextlib.redirect_stdout(buf):
                keys_mod.cmd_create(self._make_args())
        self.assertIn("99", buf.getvalue())


class TestCmdList(unittest.TestCase):

    def test_empty_list_prints_no_keys(self):
        mock_db = MagicMock()
        mock_db.list_api_keys.return_value = []
        with patch('keys._require_db', return_value=mock_db):
            buf = io.StringIO()
            with contextlib.redirect_stdout(buf):
                result = keys_mod.cmd_list(MagicMock())
        self.assertEqual(result, 0)
        self.assertIn("No API keys", buf.getvalue())

    def test_list_with_keys_returns_zero(self):
        mock_db = MagicMock()
        mock_db.list_api_keys.return_value = [
            {'key_id': 1, 'name': 'CI', 'created_at': '2024-01-01', 'last_used_at': None, 'active': True, 'rate_limit': -1},
        ]
        with patch('keys._require_db', return_value=mock_db):
            buf = io.StringIO()
            with contextlib.redirect_stdout(buf):
                result = keys_mod.cmd_list(MagicMock())
        self.assertEqual(result, 0)

    def test_list_with_keys_prints_name(self):
        mock_db = MagicMock()
        mock_db.list_api_keys.return_value = [
            {'key_id': 7, 'name': 'Dashboard', 'created_at': '2024-06-01', 'last_used_at': '2024-06-05', 'active': True, 'rate_limit': -1},
        ]
        with patch('keys._require_db', return_value=mock_db):
            buf = io.StringIO()
            with contextlib.redirect_stdout(buf):
                keys_mod.cmd_list(MagicMock())
        self.assertIn("Dashboard", buf.getvalue())

    def test_revoked_key_shown(self):
        mock_db = MagicMock()
        mock_db.list_api_keys.return_value = [
            {'key_id': 3, 'name': 'Old', 'created_at': '2023-01-01', 'last_used_at': None, 'active': False, 'rate_limit': -1},
        ]
        with patch('keys._require_db', return_value=mock_db):
            buf = io.StringIO()
            with contextlib.redirect_stdout(buf):
                result = keys_mod.cmd_list(MagicMock())
        self.assertEqual(result, 0)


class TestCmdRevoke(unittest.TestCase):

    def _make_args(self, key_id=5):
        args = MagicMock()
        args.key_id = key_id
        return args

    def test_revoke_existing_key_returns_zero(self):
        mock_db = MagicMock()
        mock_db.revoke_api_key.return_value = True
        with patch('keys._require_db', return_value=mock_db):
            buf = io.StringIO()
            with contextlib.redirect_stdout(buf):
                result = keys_mod.cmd_revoke(self._make_args(5))
        self.assertEqual(result, 0)
        mock_db.revoke_api_key.assert_called_once_with(5)

    def test_revoke_existing_prints_revoked(self):
        mock_db = MagicMock()
        mock_db.revoke_api_key.return_value = True
        with patch('keys._require_db', return_value=mock_db):
            buf = io.StringIO()
            with contextlib.redirect_stdout(buf):
                keys_mod.cmd_revoke(self._make_args(5))
        self.assertIn("revoked", buf.getvalue())

    def test_revoke_missing_key_returns_one(self):
        mock_db = MagicMock()
        mock_db.revoke_api_key.return_value = False
        with patch('keys._require_db', return_value=mock_db):
            buf = io.StringIO()
            with contextlib.redirect_stdout(buf):
                result = keys_mod.cmd_revoke(self._make_args(999))
        self.assertEqual(result, 1)

    def test_revoke_missing_prints_not_found(self):
        mock_db = MagicMock()
        mock_db.revoke_api_key.return_value = False
        with patch('keys._require_db', return_value=mock_db):
            stderr_buf = io.StringIO()
            with contextlib.redirect_stderr(stderr_buf):
                keys_mod.cmd_revoke(self._make_args(999))
        self.assertIn("not found", stderr_buf.getvalue())


class TestKeysMain(unittest.TestCase):

    def _run(self, argv):
        mock_db = MagicMock()
        mock_db.list_api_keys.return_value = []
        with patch('sys.argv', argv), \
             patch('keys._require_db', return_value=mock_db):
            buf = io.StringIO()
            with contextlib.redirect_stdout(buf):
                result = keys_mod.main()
        return result

    def test_list_subcommand(self):
        result = self._run(['keys', 'list'])
        self.assertEqual(result, 0)

    def test_create_subcommand(self):
        mock_db = MagicMock()
        mock_db.create_api_key.return_value = (1, "tok")
        with patch('sys.argv', ['keys', 'create', 'MyApp']), \
             patch('keys._require_db', return_value=mock_db):
            buf = io.StringIO()
            with contextlib.redirect_stdout(buf):
                result = keys_mod.main()
        self.assertEqual(result, 0)

    def test_revoke_subcommand(self):
        mock_db = MagicMock()
        mock_db.revoke_api_key.return_value = True
        with patch('sys.argv', ['keys', 'revoke', '1']), \
             patch('keys._require_db', return_value=mock_db):
            buf = io.StringIO()
            with contextlib.redirect_stdout(buf):
                result = keys_mod.main()
        self.assertEqual(result, 0)

    def test_missing_subcommand_raises(self):
        with patch('sys.argv', ['keys']):
            with self.assertRaises(SystemExit):
                keys_mod.main()


# ---------------------------------------------------------------------------
# ingest.py — _bar and _trunc
# ---------------------------------------------------------------------------

import ingest as ingest_mod


class TestBar(unittest.TestCase):

    def test_returns_string(self):
        self.assertIsInstance(ingest_mod._bar(0, 10), str)

    def test_zero_total_does_not_raise(self):
        result = ingest_mod._bar(0, 0)
        self.assertIsInstance(result, str)

    def test_zero_total_shows_zero_percent(self):
        result = ingest_mod._bar(0, 0)
        self.assertIn("0.0%", result)

    def test_full_progress(self):
        result = ingest_mod._bar(10, 10)
        self.assertIn("100.0%", result)

    def test_half_progress(self):
        result = ingest_mod._bar(5, 10)
        self.assertIn("50.0%", result)

    def test_custom_width(self):
        result = ingest_mod._bar(0, 10, width=10)
        # bar has brackets and 10 chars inside
        self.assertIn("[", result)

    def test_contains_block_chars(self):
        result = ingest_mod._bar(5, 10)
        self.assertIn("█", result)

    def test_contains_empty_chars_when_not_full(self):
        result = ingest_mod._bar(0, 10)
        self.assertIn("░", result)


class TestTrunc(unittest.TestCase):

    def test_short_string_unchanged(self):
        self.assertEqual(ingest_mod._trunc("hello", 10), "hello")

    def test_exact_length_unchanged(self):
        self.assertEqual(ingest_mod._trunc("hello", 5), "hello")

    def test_long_string_truncated(self):
        result = ingest_mod._trunc("abcdefghij", 5)
        self.assertEqual(len(result), 5)

    def test_truncated_starts_with_ellipsis(self):
        result = ingest_mod._trunc("abcdefghij", 5)
        self.assertTrue(result.startswith("…"))

    def test_truncated_keeps_tail(self):
        s = "0123456789"
        result = ingest_mod._trunc(s, 5)
        # keeps last 4 chars: "6789"
        self.assertEqual(result, "…6789")

    def test_empty_string_unchanged(self):
        self.assertEqual(ingest_mod._trunc("", 5), "")


# ---------------------------------------------------------------------------
# ingest.py — main()
# ---------------------------------------------------------------------------

def _make_zip(directory: Path, zip_name: str, xml_files: dict[str, bytes]) -> Path:
    """Create a ZIP file inside directory containing the given xml_files mapping."""
    zip_path = directory / zip_name
    with zipfile.ZipFile(zip_path, 'w') as zf:
        for name, content in xml_files.items():
            zf.writestr(name, content)
    return zip_path


_MINIMAL_XML = b"""<?xml version="1.0" encoding="UTF-8"?>
<Return xmlns="http://www.irs.gov/efile">
  <ReturnHeader><ReturnTypeCd>990</ReturnTypeCd></ReturnHeader>
</Return>"""


class TestIngestMain(unittest.TestCase):

    def _run_main(self, argv, cwd=None):
        """Run ingest.main() with patched argv, optionally from a given cwd."""
        old_cwd = os.getcwd()
        if cwd:
            os.chdir(cwd)
        try:
            with patch('sys.argv', argv):
                buf = io.StringIO()
                err_buf = io.StringIO()
                with contextlib.redirect_stdout(buf), contextlib.redirect_stderr(err_buf):
                    result = ingest_mod.main()
        finally:
            if cwd:
                os.chdir(old_cwd)
        return result, buf.getvalue(), err_buf.getvalue()

    def test_missing_db_returns_one(self):
        with tempfile.TemporaryDirectory() as td:
            # No IRS990.db in td
            result, _, err = self._run_main(['ingest', td], cwd=td)
        self.assertEqual(result, 1)
        self.assertIn("IRS990.db not found", err)

    def test_directory_does_not_exist_returns_one(self):
        with tempfile.TemporaryDirectory() as td:
            # Create IRS990.db so we pass the first check
            (Path(td) / "IRS990.db").write_bytes(b"")
            nonexistent = str(Path(td) / "no_such_dir")
            result, _, err = self._run_main(['ingest', nonexistent], cwd=td)
        self.assertEqual(result, 1)
        self.assertIn("Not a directory", err)

    def test_empty_directory_returns_zero(self):
        with tempfile.TemporaryDirectory() as td:
            (Path(td) / "IRS990.db").write_bytes(b"")
            zip_dir = Path(td) / "zips"
            zip_dir.mkdir()
            result, out, _ = self._run_main(['ingest', str(zip_dir)], cwd=td)
        self.assertEqual(result, 0)
        self.assertIn("No ZIP files found", out)

    def test_invalid_zip_in_directory(self):
        with tempfile.TemporaryDirectory() as td:
            (Path(td) / "IRS990.db").write_bytes(b"")
            zip_dir = Path(td) / "zips"
            zip_dir.mkdir()
            # Write a corrupt ZIP file
            (zip_dir / "bad.zip").write_bytes(b"not a zip")

            mock_db = MagicMock()
            mock_router = MagicMock()
            with patch('ingest.ScoreDatabase', return_value=mock_db), \
                 patch('ingest.UploadRouter', return_value=mock_router):
                result, out, _ = self._run_main(['ingest', str(zip_dir)], cwd=td)
        # Bad ZIP is counted as error; function still returns 0
        self.assertEqual(result, 0)
        self.assertIn("invalid ZIP", out)

    def test_normal_zip_processes_without_raise(self):
        with tempfile.TemporaryDirectory() as td:
            (Path(td) / "IRS990.db").write_bytes(b"")
            zip_dir = Path(td) / "zips"
            zip_dir.mkdir()
            _make_zip(zip_dir, "filings.zip", {"filing_001.xml": _MINIMAL_XML})

            mock_db = MagicMock()
            mock_router = MagicMock()
            mock_router._process_xml.return_value = {
                'status': 'stored', 'file': 'filing_001.xml', 'ein': '123456789'
            }
            with patch('ingest.ScoreDatabase', return_value=mock_db), \
                 patch('ingest.UploadRouter', return_value=mock_router):
                result, _, _ = self._run_main(['ingest', str(zip_dir)], cwd=td)
        self.assertEqual(result, 0)
        mock_router._process_xml.assert_called_once()

    def test_normal_zip_with_multiple_xmls(self):
        with tempfile.TemporaryDirectory() as td:
            (Path(td) / "IRS990.db").write_bytes(b"")
            zip_dir = Path(td) / "zips"
            zip_dir.mkdir()
            _make_zip(zip_dir, "filings.zip", {
                "filing_001.xml": _MINIMAL_XML,
                "filing_002.xml": _MINIMAL_XML,
            })

            mock_db = MagicMock()
            mock_router = MagicMock()
            mock_router._process_xml.return_value = {
                'status': 'skipped', 'file': 'filing_001.xml', 'reason': 'dup'
            }
            with patch('ingest.ScoreDatabase', return_value=mock_db), \
                 patch('ingest.UploadRouter', return_value=mock_router):
                result, _, _ = self._run_main(['ingest', str(zip_dir)], cwd=td)
        self.assertEqual(result, 0)
        self.assertEqual(mock_router._process_xml.call_count, 2)

    def test_zip_with_no_xml_files(self):
        with tempfile.TemporaryDirectory() as td:
            (Path(td) / "IRS990.db").write_bytes(b"")
            zip_dir = Path(td) / "zips"
            zip_dir.mkdir()
            # ZIP with only a non-XML file
            zip_path = zip_dir / "noxml.zip"
            with zipfile.ZipFile(zip_path, 'w') as zf:
                zf.writestr("readme.txt", b"hello")

            mock_db = MagicMock()
            mock_router = MagicMock()
            with patch('ingest.ScoreDatabase', return_value=mock_db), \
                 patch('ingest.UploadRouter', return_value=mock_router):
                result, out, _ = self._run_main(['ingest', str(zip_dir)], cwd=td)
        self.assertEqual(result, 0)
        # No XMLs found inside — still completes
        mock_router._process_xml.assert_not_called()

    def test_process_xml_exception_counts_as_error(self):
        with tempfile.TemporaryDirectory() as td:
            (Path(td) / "IRS990.db").write_bytes(b"")
            zip_dir = Path(td) / "zips"
            zip_dir.mkdir()
            _make_zip(zip_dir, "filings.zip", {"filing_001.xml": _MINIMAL_XML})

            mock_db = MagicMock()
            mock_router = MagicMock()
            mock_router._process_xml.side_effect = ValueError("parse failure")
            with patch('ingest.ScoreDatabase', return_value=mock_db), \
                 patch('ingest.UploadRouter', return_value=mock_router):
                result, out, _ = self._run_main(['ingest', str(zip_dir)], cwd=td)
        self.assertEqual(result, 0)
        self.assertIn("errors", out)

    def test_zip_with_no_xml_alongside_zip_with_xml(self):
        """Covers lines 97-98: n_xml==0 branch when another ZIP has XMLs."""
        with tempfile.TemporaryDirectory() as td:
            (Path(td) / "IRS990.db").write_bytes(b"")
            zip_dir = Path(td) / "zips"
            zip_dir.mkdir()
            # First ZIP: no XML files (n_xml == 0 → hits the continue)
            no_xml_zip = zip_dir / "aaa_noxml.zip"
            with zipfile.ZipFile(no_xml_zip, 'w') as zf:
                zf.writestr("readme.txt", "no xml")
            # Second ZIP: one XML (ensures total_xmls > 0 so no early return)
            _make_zip(zip_dir, "zzz_filing.zip", {"filing.xml": _MINIMAL_XML})

            mock_db = MagicMock()
            mock_router = MagicMock()
            mock_router._process_xml.return_value = {
                'status': 'stored', 'file': 'filing.xml', 'ein': '111'
            }
            with patch('ingest.ScoreDatabase', return_value=mock_db), \
                 patch('ingest.UploadRouter', return_value=mock_router):
                result, out, _ = self._run_main(['ingest', str(zip_dir)], cwd=td)
        self.assertEqual(result, 0)
        # The no-xml ZIP is visited and the no-xml branch printed
        self.assertIn("no XML files", out)

    def test_notimplementederror_uses_unzip_fallback(self):
        """Covers lines 116-121: Deflate64 ZIP falls back to subprocess unzip."""
        _BAD_ZIP = os.path.join(os.path.dirname(__file__), 'data', 'zips', 'bad', 'sample_bad.zip')
        if not os.path.exists(_BAD_ZIP):
            self.skipTest("bad zip fixture not found")
        with tempfile.TemporaryDirectory() as td:
            (Path(td) / "IRS990.db").write_bytes(b"")
            zip_dir = Path(td) / "zips"
            zip_dir.mkdir()
            import shutil
            shutil.copy(_BAD_ZIP, zip_dir / "deflate64.zip")

            mock_db = MagicMock()
            mock_router = MagicMock()
            mock_router._process_xml.return_value = {
                'status': 'stored', 'file': '000000000000000000_public.xml', 'ein': '000000001'
            }
            with patch('ingest.ScoreDatabase', return_value=mock_db), \
                 patch('ingest.UploadRouter', return_value=mock_router):
                result, _, _ = self._run_main(['ingest', str(zip_dir)], cwd=td)
        self.assertEqual(result, 0)
        mock_router._process_xml.assert_called_once()

    def test_badzip_in_main_loop_counts_as_error(self):
        """Covers lines 133-137: BadZipFile raised during main-loop ZipFile.open."""
        with tempfile.TemporaryDirectory() as td:
            (Path(td) / "IRS990.db").write_bytes(b"")
            zip_dir = Path(td) / "zips"
            zip_dir.mkdir()
            # Create a placeholder file; we'll mock ZipFile so it doesn't matter
            zip_path = zip_dir / "tricky.zip"
            zip_path.write_bytes(b"placeholder")

            # Pre-scan call: returns names normally
            mock_prescan = MagicMock()
            mock_prescan.__enter__ = MagicMock(return_value=mock_prescan)
            mock_prescan.__exit__ = MagicMock(return_value=False)
            mock_prescan.namelist.return_value = ['filing.xml']

            call_count = [0]
            orig_ZipFile = zipfile.ZipFile

            def fake_ZipFile(path, mode='r'):
                call_count[0] += 1
                if call_count[0] == 1:
                    return mock_prescan
                raise zipfile.BadZipFile("corrupted during main loop")

            mock_db = MagicMock()
            mock_router = MagicMock()
            with patch('ingest.zipfile.ZipFile', side_effect=fake_ZipFile), \
                 patch('ingest.ScoreDatabase', return_value=mock_db), \
                 patch('ingest.UploadRouter', return_value=mock_router):
                result, out, _ = self._run_main(['ingest', str(zip_dir)], cwd=td)
        self.assertEqual(result, 0)
        self.assertIn("corrupt ZIP", out)

    def test_db_close_called_after_processing(self):
        with tempfile.TemporaryDirectory() as td:
            (Path(td) / "IRS990.db").write_bytes(b"")
            zip_dir = Path(td) / "zips"
            zip_dir.mkdir()
            _make_zip(zip_dir, "filings.zip", {"filing_001.xml": _MINIMAL_XML})

            mock_db = MagicMock()
            mock_router = MagicMock()
            mock_router._process_xml.return_value = {
                'status': 'stored', 'file': 'filing_001.xml', 'ein': '111'
            }
            with patch('ingest.ScoreDatabase', return_value=mock_db), \
                 patch('ingest.UploadRouter', return_value=mock_router):
                self._run_main(['ingest', str(zip_dir)], cwd=td)
        mock_db.close.assert_called_once()


if __name__ == '__main__':  # pragma: no cover
    unittest.main()
