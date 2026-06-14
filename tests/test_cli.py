"""Tests for console.py, main.py, keys.py, and ingest.py."""

import contextlib
import io
import os
import sys
import tempfile
import unittest
import uuid
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
from database import OpenReturnDB


class TestDumpDb(unittest.TestCase):
    """_dump_db should run without raising against a real in-memory database."""

    @classmethod
    def setUpClass(cls):
        cls.db = OpenReturnDB(path=":memory:")

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
        self.db.orgs.upsert_organization("123456789", "Test Org")
        buf = io.StringIO()
        with contextlib.redirect_stdout(buf):
            main_mod._dump_db(self.db)

    def test_with_filing_rows(self):
        self.db.orgs.upsert_organization("123456789", "Test Org")
        self.db.filings.create_filing("123456789", 2023, "990")
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
            self.db.orgs.upsert_organization(ein, f"Org {i}")
            self.db.filings.create_filing(ein, 2020 + i, "990")
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
                # Create a dummy OpenReturn.db so unlink has something to remove
                Path("OpenReturn.db").write_bytes(b"")
                result, _ = self._run_main(['main', '--testing'])
                self.assertEqual(result, 0)
                # File should have been recreated by OpenReturnDB init
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
            db_path = Path(td) / "OpenReturn.db"
            # Use a real in-memory db to avoid touching disk inside OpenReturnDB
            with patch('keys.Path') as mock_path_cls, \
                 patch('keys.OpenReturnDB') as mock_db_cls:
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
        mock_db.keys.create_api_key.return_value = (42, "rawtoken123")
        with patch('keys._require_db', return_value=mock_db):
            buf = io.StringIO()
            with contextlib.redirect_stdout(buf):
                result = keys_mod.cmd_create(self._make_args())
        self.assertEqual(result, 0)
        mock_db.keys.create_api_key.assert_called_once_with("Test Key", rate_limit=-1)
        mock_db.close.assert_called_once()

    def test_output_contains_created(self):
        mock_db = MagicMock()
        mock_db.keys.create_api_key.return_value = (1, "secret")
        with patch('keys._require_db', return_value=mock_db):
            buf = io.StringIO()
            with contextlib.redirect_stdout(buf):
                keys_mod.cmd_create(self._make_args("My Key"))
        self.assertIn("API key created", buf.getvalue())

    def test_output_contains_key_id(self):
        mock_db = MagicMock()
        mock_db.keys.create_api_key.return_value = (99, "tok")
        with patch('keys._require_db', return_value=mock_db):
            buf = io.StringIO()
            with contextlib.redirect_stdout(buf):
                keys_mod.cmd_create(self._make_args())
        self.assertIn("99", buf.getvalue())


class TestCmdList(unittest.TestCase):

    def test_empty_list_prints_no_keys(self):
        mock_db = MagicMock()
        mock_db.keys.list_api_keys.return_value = []
        with patch('keys._require_db', return_value=mock_db):
            buf = io.StringIO()
            with contextlib.redirect_stdout(buf):
                result = keys_mod.cmd_list(MagicMock())
        self.assertEqual(result, 0)
        self.assertIn("No API keys", buf.getvalue())

    def test_list_with_keys_returns_zero(self):
        mock_db = MagicMock()
        mock_db.keys.list_api_keys.return_value = [
            {'key_id': 1, 'name': 'CI', 'created_at': '2024-01-01', 'last_used_at': None, 'active': True, 'rate_limit': -1},
        ]
        with patch('keys._require_db', return_value=mock_db):
            buf = io.StringIO()
            with contextlib.redirect_stdout(buf):
                result = keys_mod.cmd_list(MagicMock())
        self.assertEqual(result, 0)

    def test_list_with_keys_prints_name(self):
        mock_db = MagicMock()
        mock_db.keys.list_api_keys.return_value = [
            {'key_id': 7, 'name': 'Dashboard', 'created_at': '2024-06-01', 'last_used_at': '2024-06-05', 'active': True, 'rate_limit': -1},
        ]
        with patch('keys._require_db', return_value=mock_db):
            buf = io.StringIO()
            with contextlib.redirect_stdout(buf):
                keys_mod.cmd_list(MagicMock())
        self.assertIn("Dashboard", buf.getvalue())

    def test_revoked_key_shown(self):
        mock_db = MagicMock()
        mock_db.keys.list_api_keys.return_value = [
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
        mock_db.keys.revoke_api_key.return_value = True
        with patch('keys._require_db', return_value=mock_db):
            buf = io.StringIO()
            with contextlib.redirect_stdout(buf):
                result = keys_mod.cmd_revoke(self._make_args(5))
        self.assertEqual(result, 0)
        mock_db.keys.revoke_api_key.assert_called_once_with(5)

    def test_revoke_existing_prints_revoked(self):
        mock_db = MagicMock()
        mock_db.keys.revoke_api_key.return_value = True
        with patch('keys._require_db', return_value=mock_db):
            buf = io.StringIO()
            with contextlib.redirect_stdout(buf):
                keys_mod.cmd_revoke(self._make_args(5))
        self.assertIn("revoked", buf.getvalue())

    def test_revoke_missing_key_returns_one(self):
        mock_db = MagicMock()
        mock_db.keys.revoke_api_key.return_value = False
        with patch('keys._require_db', return_value=mock_db):
            buf = io.StringIO()
            with contextlib.redirect_stdout(buf):
                result = keys_mod.cmd_revoke(self._make_args(999))
        self.assertEqual(result, 1)

    def test_revoke_missing_prints_not_found(self):
        mock_db = MagicMock()
        mock_db.keys.revoke_api_key.return_value = False
        with patch('keys._require_db', return_value=mock_db):
            stderr_buf = io.StringIO()
            with contextlib.redirect_stderr(stderr_buf):
                keys_mod.cmd_revoke(self._make_args(999))
        self.assertIn("not found", stderr_buf.getvalue())


class TestKeysMain(unittest.TestCase):

    def _run(self, argv):
        mock_db = MagicMock()
        mock_db.keys.list_api_keys.return_value = []
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
        mock_db.keys.create_api_key.return_value = (1, "tok")
        with patch('sys.argv', ['keys', 'create', 'MyApp']), \
             patch('keys._require_db', return_value=mock_db):
            buf = io.StringIO()
            with contextlib.redirect_stdout(buf):
                result = keys_mod.main()
        self.assertEqual(result, 0)

    def test_revoke_subcommand(self):
        mock_db = MagicMock()
        mock_db.keys.revoke_api_key.return_value = True
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
# ingest.py — _resolve_uuids
# ---------------------------------------------------------------------------

class TestResolveIds(unittest.TestCase):
    """ingest._resolve_ids maps client-assigned integer filing_ids to the
    actual filing_id when an (EIN, year, form) row already exists."""

    def setUp(self):
        from database import OpenReturnDB
        self.db = OpenReturnDB(path=":memory:")
        self.db.orgs.upsert_organization("123456789", "Test Org")

    def tearDown(self):
        self.db.close()

    def _existing_id(self, ein, year, form):
        self.db.filings.create_filing(ein, year, form)
        return self.db.cursor.execute(
            "SELECT filing_id FROM filing WHERE organization_id=? AND year=? AND form_code=?",
            (ein, year, form),
        ).fetchone()[0]

    def test_empty_input_returns_empty(self):
        self.assertEqual(ingest_mod._resolve_ids(self.db, {}), {})

    def test_matching_id_returns_empty_remap(self):
        fid = self._existing_id("123456789", 2023, "990")
        result = ingest_mod._resolve_ids(self.db, {("123456789", 2023, "990"): fid})
        self.assertEqual(result, {})

    def test_different_id_is_remapped(self):
        fid = self._existing_id("123456789", 2023, "990")
        pre_id = 999999
        result = ingest_mod._resolve_ids(self.db, {("123456789", 2023, "990"): pre_id})
        self.assertEqual(result, {pre_id: fid})

    def test_multiple_keys_partial_remap(self):
        fid2023 = self._existing_id("123456789", 2023, "990")
        pre_id = 999999
        keys = {
            ("123456789", 2023, "990"): pre_id,
            ("123456789", 2022, "990"): 888888,  # no existing row → not remapped
        }
        result = ingest_mod._resolve_ids(self.db, keys)
        self.assertEqual(result, {pre_id: fid2023})


# ---------------------------------------------------------------------------
# ingest.py — _flush_zip
# ---------------------------------------------------------------------------

class TestFlushZip(unittest.TestCase):

    def setUp(self):
        from database import OpenReturnDB
        self.db = OpenReturnDB(path=":memory:")
        xpath_index = self.db.meta.get_xpath_index()
        self.field_id = list(xpath_index.values())[0]

    def tearDown(self):
        self.db.close()

    def test_empty_lists_just_commits(self):
        ingest_mod._flush_zip(self.db, [], [], [], {})

    def test_inserts_organization(self):
        ingest_mod._flush_zip(self.db, [("111111111", "Alpha")], [], [], {})
        row = self.db.cursor.execute(
            "SELECT name FROM organization WHERE ein = ?", ("111111111",)
        ).fetchone()
        self.assertIsNotNone(row)
        self.assertEqual(row[0], "Alpha")

    def test_inserts_filing(self):
        pending_orgs = [("111111111", "Alpha")]
        pending_filings = [(1, str(uuid.uuid4()), 2023, "111111111", "990", "f.xml", "z.zip")]
        ingest_mod._flush_zip(self.db, pending_orgs, pending_filings, [], {})
        row = self.db.cursor.execute(
            "SELECT uuid FROM filing WHERE organization_id = ?", ("111111111",)
        ).fetchone()
        self.assertIsNotNone(row)

    def test_inserts_reported_data(self):
        pre_id = 1
        pending_orgs = [("111111111", "Alpha")]
        pending_filings = [(pre_id, str(uuid.uuid4()), 2023, "111111111", "990", "f.xml", "z.zip")]
        pending_data = [(pre_id, self.field_id, "testval")]
        ingest_mod._flush_zip(self.db, pending_orgs, pending_filings, pending_data, {})
        count = self.db.cursor.execute(
            "SELECT COUNT(*) FROM reported_data WHERE filing_id = ?", (pre_id,)
        ).fetchone()[0]
        self.assertEqual(count, 1)

    def test_id_remap_when_filing_exists(self):
        self.db.orgs.upsert_organization("111111111", "Alpha")
        self.db.filings.create_filing("111111111", 2023, "990")
        actual_id = self.db.cursor.execute(
            "SELECT filing_id FROM filing WHERE organization_id=? AND year=? AND form_code=?",
            ("111111111", 2023, "990"),
        ).fetchone()[0]
        pre_id = 999999
        pending_orgs = [("111111111", "Alpha")]
        pending_filings = [(pre_id, str(uuid.uuid4()), 2023, "111111111", "990", "f.xml", "z.zip")]
        pending_data = [(pre_id, self.field_id, "value")]
        ingest_mod._flush_zip(self.db, pending_orgs, pending_filings, pending_data, {})
        count = self.db.cursor.execute(
            "SELECT COUNT(*) FROM reported_data WHERE filing_id = ?", (actual_id,)
        ).fetchone()[0]
        self.assertEqual(count, 1)

    def test_persistent_remap_applies_to_later_flush(self):
        """A remap from an earlier flush must still apply when a within-ZIP
        duplicate's reported_data arrives in a later flush (empty filings)."""
        self.db.orgs.upsert_organization("111111111", "Alpha")
        self.db.filings.create_filing("111111111", 2023, "990")
        actual_id = self.db.cursor.execute(
            "SELECT filing_id FROM filing WHERE organization_id=? AND year=? AND form_code=?",
            ("111111111", 2023, "990"),
        ).fetchone()[0]
        pre_id = 999999
        id_remap: dict = {}
        # Flush 1: filing collides → remap recorded in id_remap.
        ingest_mod._flush_zip(
            self.db, [("111111111", "Alpha")],
            [(pre_id, str(uuid.uuid4()), 2023, "111111111", "990", "f.xml", "z.zip")],
            [(pre_id, self.field_id, "v1")], id_remap,
        )
        # Flush 2: no new filing, but more data for the same pre_id.
        field2 = list(self.db.meta.get_xpath_index().values())[1]
        ingest_mod._flush_zip(self.db, [], [], [(pre_id, field2, "v2")], id_remap)
        count = self.db.cursor.execute(
            "SELECT COUNT(*) FROM reported_data WHERE filing_id = ?", (actual_id,)
        ).fetchone()[0]
        self.assertEqual(count, 2)


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

    def test_directory_does_not_exist_returns_one(self):
        with tempfile.TemporaryDirectory() as td:
            # Create OpenReturn.db so we pass the first check
            (Path(td) / "OpenReturn.db").write_bytes(b"")
            nonexistent = str(Path(td) / "no_such_dir")
            result, _, err = self._run_main(['ingest', nonexistent], cwd=td)
        self.assertEqual(result, 1)
        self.assertIn("Not a directory", err)

    def test_empty_directory_returns_zero(self):
        with tempfile.TemporaryDirectory() as td:
            (Path(td) / "OpenReturn.db").write_bytes(b"")
            zip_dir = Path(td) / "zips"
            zip_dir.mkdir()
            result, out, _ = self._run_main(['ingest', str(zip_dir)], cwd=td)
        self.assertEqual(result, 0)
        self.assertIn("No ZIP files found", out)

    def test_invalid_zip_in_directory(self):
        with tempfile.TemporaryDirectory() as td:
            (Path(td) / "OpenReturn.db").write_bytes(b"")
            zip_dir = Path(td) / "zips"
            zip_dir.mkdir()
            # Write a corrupt ZIP file
            (zip_dir / "bad.zip").write_bytes(b"not a zip")

            mock_db = MagicMock()
            mock_router = MagicMock()
            with patch('ingest.OpenReturnDB', return_value=mock_db), \
                 patch('ingest.UploadRouter', return_value=mock_router):
                result, out, _ = self._run_main(['ingest', str(zip_dir)], cwd=td)
        # Bad ZIP is counted as error; function still returns 0
        self.assertEqual(result, 0)
        self.assertIn("invalid ZIP", out)

    def test_normal_zip_processes_without_raise(self):
        with tempfile.TemporaryDirectory() as td:
            (Path(td) / "OpenReturn.db").write_bytes(b"")
            zip_dir = Path(td) / "zips"
            zip_dir.mkdir()
            _make_zip(zip_dir, "filings.zip", {"filing_001.xml": _MINIMAL_XML})

            mock_db = MagicMock()
            mock_router = MagicMock()
            mock_router._process_xml.return_value = {
                'status': 'stored', 'file': 'filing_001.xml', 'ein': '123456789'
            }
            with patch('ingest.OpenReturnDB', return_value=mock_db), \
                 patch('ingest.UploadRouter', return_value=mock_router):
                result, _, _ = self._run_main(['ingest', '--workers', '1', str(zip_dir)], cwd=td)
        self.assertEqual(result, 0)
        mock_router._process_xml.assert_called_once()

    def test_normal_zip_with_multiple_xmls(self):
        with tempfile.TemporaryDirectory() as td:
            (Path(td) / "OpenReturn.db").write_bytes(b"")
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
            with patch('ingest.OpenReturnDB', return_value=mock_db), \
                 patch('ingest.UploadRouter', return_value=mock_router):
                result, _, _ = self._run_main(['ingest', '--workers', '1', str(zip_dir)], cwd=td)
        self.assertEqual(result, 0)
        self.assertEqual(mock_router._process_xml.call_count, 2)

    def test_zip_with_no_xml_files(self):
        with tempfile.TemporaryDirectory() as td:
            (Path(td) / "OpenReturn.db").write_bytes(b"")
            zip_dir = Path(td) / "zips"
            zip_dir.mkdir()
            # ZIP with only a non-XML file
            zip_path = zip_dir / "noxml.zip"
            with zipfile.ZipFile(zip_path, 'w') as zf:
                zf.writestr("readme.txt", b"hello")

            mock_db = MagicMock()
            mock_router = MagicMock()
            with patch('ingest.OpenReturnDB', return_value=mock_db), \
                 patch('ingest.UploadRouter', return_value=mock_router):
                result, out, _ = self._run_main(['ingest', str(zip_dir)], cwd=td)
        self.assertEqual(result, 0)
        # No XMLs found inside — still completes
        mock_router._process_xml.assert_not_called()

    def test_process_xml_exception_counts_as_error(self):
        with tempfile.TemporaryDirectory() as td:
            (Path(td) / "OpenReturn.db").write_bytes(b"")
            zip_dir = Path(td) / "zips"
            zip_dir.mkdir()
            _make_zip(zip_dir, "filings.zip", {"filing_001.xml": _MINIMAL_XML})

            mock_db = MagicMock()
            mock_router = MagicMock()
            mock_router._process_xml.side_effect = ValueError("parse failure")
            with patch('ingest.OpenReturnDB', return_value=mock_db), \
                 patch('ingest.UploadRouter', return_value=mock_router):
                result, out, _ = self._run_main(['ingest', '--workers', '1', str(zip_dir)], cwd=td)
        self.assertEqual(result, 0)
        self.assertIn("errors", out)

    def test_zip_with_no_xml_alongside_zip_with_xml(self):
        """Covers the n_xml==0 branch when another ZIP has XMLs."""
        with tempfile.TemporaryDirectory() as td:
            (Path(td) / "OpenReturn.db").write_bytes(b"")
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
            with patch('ingest.OpenReturnDB', return_value=mock_db), \
                 patch('ingest.UploadRouter', return_value=mock_router):
                result, out, _ = self._run_main(['ingest', '--workers', '1', str(zip_dir)], cwd=td)
        self.assertEqual(result, 0)
        # The no-xml ZIP is visited and the no-xml branch printed
        self.assertIn("no XML files", out)

    def test_notimplementederror_uses_unzip_fallback(self):
        """Covers Deflate64 ZIP falling back to subprocess unzip."""
        _BAD_ZIP = os.path.join(os.path.dirname(__file__), 'data', 'zips', 'bad', 'sample_bad.zip')
        if not os.path.exists(_BAD_ZIP):
            self.skipTest("bad zip fixture not found")
        with tempfile.TemporaryDirectory() as td:
            (Path(td) / "OpenReturn.db").write_bytes(b"")
            zip_dir = Path(td) / "zips"
            zip_dir.mkdir()
            import shutil
            shutil.copy(_BAD_ZIP, zip_dir / "deflate64.zip")

            mock_db = MagicMock()
            mock_router = MagicMock()
            mock_router._process_xml.return_value = {
                'status': 'stored', 'file': '000000000000000000_public.xml', 'ein': '000000001'
            }
            with patch('ingest.OpenReturnDB', return_value=mock_db), \
                 patch('ingest.UploadRouter', return_value=mock_router):
                result, _, _ = self._run_main(['ingest', '--workers', '1', str(zip_dir)], cwd=td)
        self.assertEqual(result, 0)
        mock_router._process_xml.assert_called_once()

    def test_badzip_in_main_loop_counts_as_error(self):
        """Covers BadZipFile raised during main-loop ZipFile.open."""
        with tempfile.TemporaryDirectory() as td:
            (Path(td) / "OpenReturn.db").write_bytes(b"")
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

            def fake_ZipFile(path, mode='r'):
                call_count[0] += 1
                if call_count[0] == 1:
                    return mock_prescan
                raise zipfile.BadZipFile("corrupted during main loop")

            mock_db = MagicMock()
            mock_router = MagicMock()
            with patch('ingest.zipfile.ZipFile', side_effect=fake_ZipFile), \
                 patch('ingest.OpenReturnDB', return_value=mock_db), \
                 patch('ingest.UploadRouter', return_value=mock_router):
                result, out, _ = self._run_main(['ingest', '--workers', '1', str(zip_dir)], cwd=td)
        self.assertEqual(result, 0)
        self.assertIn("corrupt ZIP", out)

    def test_db_close_called_after_processing(self):
        with tempfile.TemporaryDirectory() as td:
            (Path(td) / "OpenReturn.db").write_bytes(b"")
            zip_dir = Path(td) / "zips"
            zip_dir.mkdir()
            _make_zip(zip_dir, "filings.zip", {"filing_001.xml": _MINIMAL_XML})

            mock_db = MagicMock()
            mock_router = MagicMock()
            mock_router._process_xml.return_value = {
                'status': 'stored', 'file': 'filing_001.xml', 'ein': '111'
            }
            with patch('ingest.OpenReturnDB', return_value=mock_db), \
                 patch('ingest.UploadRouter', return_value=mock_router):
                self._run_main(['ingest', '--workers', '1', str(zip_dir)], cwd=td)
        mock_db.close.assert_called_once()

    def test_invalid_zip_sequential_mode(self):
        """Covers lines 148-150: xml_names is None in the sequential (--workers 1) path."""
        with tempfile.TemporaryDirectory() as td:
            (Path(td) / "OpenReturn.db").write_bytes(b"")
            zip_dir = Path(td) / "zips"
            zip_dir.mkdir()
            (zip_dir / "bad.zip").write_bytes(b"not a zip")

            mock_db = MagicMock()
            mock_router = MagicMock()
            with patch('ingest.OpenReturnDB', return_value=mock_db), \
                 patch('ingest.UploadRouter', return_value=mock_router):
                result, out, _ = self._run_main(
                    ['ingest', '--workers', '1', str(zip_dir)], cwd=td
                )
        self.assertEqual(result, 0)
        self.assertIn("invalid ZIP", out)


# ---------------------------------------------------------------------------
# ingest.py — parallel path (lines 234-313)
# ---------------------------------------------------------------------------

class TestIngestParallel(unittest.TestCase):
    """Cover the parallel ProcessPoolExecutor path by mocking the executor."""

    def _run_main(self, argv, extra_patches):
        with contextlib.ExitStack() as stack:
            for p in extra_patches:
                stack.enter_context(p)
            buf = io.StringIO()
            err_buf = io.StringIO()
            with contextlib.redirect_stdout(buf), contextlib.redirect_stderr(err_buf):
                with patch('sys.argv', argv):
                    result = ingest_mod.main()
        return result, buf.getvalue()

    def _make_mock_pool(self, submit_result=None, submit_raises=None):
        mock_future = MagicMock()
        if submit_raises is not None:
            mock_future.result.side_effect = submit_raises
        else:
            mock_future.result.return_value = submit_result

        mock_pool = MagicMock()
        mock_pool.__enter__ = MagicMock(return_value=mock_pool)
        mock_pool.__exit__ = MagicMock(return_value=False)
        mock_pool.submit.return_value = mock_future
        return mock_pool

    @staticmethod
    def _fake_as_completed(futures):
        return iter(futures.keys())

    def test_parallel_processes_parsed_result(self):
        """Covers print(zip_hdr), futures loop, and summary print in parallel mode."""
        parsed = {
            'status': 'parsed', 'ein': '123456789', 'name': 'Test Org', 'year': 2023,
            'form_code': '990', 'file': 'filing.xml', 'zip_filename': 'test.zip',
            'values': {},
        }
        mock_db = MagicMock()
        mock_pool = self._make_mock_pool(submit_result=[parsed])

        with tempfile.TemporaryDirectory() as td:
            zip_dir = Path(td) / "zips"
            zip_dir.mkdir()
            _make_zip(zip_dir, "test.zip", {"filing.xml": _MINIMAL_XML})

            result, out = self._run_main(
                ['ingest', '--workers', '2', str(zip_dir)],
                extra_patches=[
                    patch('ingest.OpenReturnDB', return_value=mock_db),
                    patch('ingest.UploadRouter', return_value=MagicMock()),
                    patch('ingest.ProcessPoolExecutor', return_value=mock_pool),
                    patch('ingest.as_completed', side_effect=self._fake_as_completed),
                ],
            )
        self.assertEqual(result, 0)
        self.assertIn("stored", out)

    def test_parallel_future_exception_counts_error(self):
        """Covers except-block (lines 258-262) when fut.result() raises."""
        mock_db = MagicMock()
        mock_pool = self._make_mock_pool(submit_raises=RuntimeError("worker died"))

        with tempfile.TemporaryDirectory() as td:
            zip_dir = Path(td) / "zips"
            zip_dir.mkdir()
            _make_zip(zip_dir, "test.zip", {"filing.xml": _MINIMAL_XML})

            result, out = self._run_main(
                ['ingest', '--workers', '2', str(zip_dir)],
                extra_patches=[
                    patch('ingest.OpenReturnDB', return_value=mock_db),
                    patch('ingest.UploadRouter', return_value=MagicMock()),
                    patch('ingest.ProcessPoolExecutor', return_value=mock_pool),
                    patch('ingest.as_completed', side_effect=self._fake_as_completed),
                ],
            )
        self.assertEqual(result, 0)
        self.assertIn("errors", out)

    def test_parallel_parsed_inner_exception_counts_error(self):
        """Covers inner except-block (lines 290-291) when parsed dict is incomplete."""
        parsed = {
            'status': 'parsed', 'ein': '123456789', 'year': 2023,
            'form_code': '990', 'file': 'filing.xml', 'zip_filename': 'test.zip',
            # 'name' missing → KeyError inside the try block
        }
        mock_db = MagicMock()
        mock_pool = self._make_mock_pool(submit_result=[parsed])

        with tempfile.TemporaryDirectory() as td:
            zip_dir = Path(td) / "zips"
            zip_dir.mkdir()
            _make_zip(zip_dir, "test.zip", {"filing.xml": _MINIMAL_XML})

            result, _ = self._run_main(
                ['ingest', '--workers', '2', str(zip_dir)],
                extra_patches=[
                    patch('ingest.OpenReturnDB', return_value=mock_db),
                    patch('ingest.UploadRouter', return_value=MagicMock()),
                    patch('ingest.ProcessPoolExecutor', return_value=mock_pool),
                    patch('ingest.as_completed', side_effect=self._fake_as_completed),
                ],
            )
        self.assertEqual(result, 0)

    def test_parallel_no_xml_zip_alongside_valid_zip(self):
        """Covers n_xml == 0 branch (lines 236-238) in parallel mode."""
        parsed = {
            'status': 'parsed', 'ein': '123456789', 'name': 'Test Org', 'year': 2023,
            'form_code': '990', 'file': 'filing.xml', 'zip_filename': 'zzz_filing.zip',
            'values': {},
        }
        mock_db = MagicMock()
        mock_pool = self._make_mock_pool(submit_result=[parsed])

        with tempfile.TemporaryDirectory() as td:
            zip_dir = Path(td) / "zips"
            zip_dir.mkdir()
            with zipfile.ZipFile(zip_dir / "aaa_noxml.zip", 'w') as zf:
                zf.writestr("readme.txt", "no xml here")
            _make_zip(zip_dir, "zzz_filing.zip", {"filing.xml": _MINIMAL_XML})

            result, out = self._run_main(
                ['ingest', '--workers', '2', str(zip_dir)],
                extra_patches=[
                    patch('ingest.OpenReturnDB', return_value=mock_db),
                    patch('ingest.UploadRouter', return_value=MagicMock()),
                    patch('ingest.ProcessPoolExecutor', return_value=mock_pool),
                    patch('ingest.as_completed', side_effect=self._fake_as_completed),
                ],
            )
        self.assertEqual(result, 0)
        self.assertIn("no XML files", out)


# ---------------------------------------------------------------------------
# ingest.py — URL source path (_cmd_ingest_url / _ingest_one_remote)
# ---------------------------------------------------------------------------

_URL_1 = "https://apps.irs.gov/pub/epostcard/990/xml/2024/2024_TEOS_XML_01A.zip"
_URL_2 = "https://apps.irs.gov/pub/epostcard/990/xml/2024/2024_TEOS_XML_02A.zip"

_PARSED = {
    'status': 'parsed', 'ein': '123456789', 'name': 'Test Org', 'year': 2023,
    'form_code': '990', 'file': 'f.xml', 'zip_filename': '2024_TEOS_XML_01A.zip',
    'values': {},
}


def _fake_download(created, *, good=True, meta=None):
    """Build a download_zip stand-in that writes a real (or corrupt) ZIP into the
    destination dir and records the produced path in ``created``."""
    def _dl(url, dest_dir, *, progress=True):
        name = url.rstrip('/').split('/')[-1] or 'download.zip'
        p = Path(dest_dir) / name
        if good:
            with zipfile.ZipFile(p, 'w') as zf:
                zf.writestr('f.xml', _MINIMAL_XML)
        else:
            p.write_bytes(b'not a zip')
        created.append(p)
        return p, (meta or {'etag': '"e"', 'last_modified': 'LM', 'content_length': 123})
    return _dl


class TestIngestUrl(unittest.TestCase):

    def setUp(self):
        self._td = tempfile.TemporaryDirectory()
        self.db_path = str(Path(self._td.name) / "OpenReturn.db")
        # Populate schema + seed once so the in-ingest open skips re-populate.
        OpenReturnDB(path=self.db_path).close()
        self.created = []

    def tearDown(self):
        self._td.cleanup()

    def _open_db(self):
        return OpenReturnDB(path=self.db_path)

    def _run(self, argv, discover=None, download=None, extra_patches=None):
        patches = [patch('sys.argv', ['ingest'] + argv),
                   patch('ingest.OpenReturnDB', side_effect=lambda *a, **k: OpenReturnDB(path=self.db_path)),
                   patch('ingest.UploadRouter', return_value=MagicMock())]
        if discover is not None:
            patches.append(patch('ingest.sources.discover_zip_urls', discover))
        if download is not None:
            patches.append(patch('ingest.sources.download_zip', download))
        if extra_patches:
            patches.extend(extra_patches)
        with contextlib.ExitStack() as stack:
            for p in patches:
                stack.enter_context(p)
            buf, err = io.StringIO(), io.StringIO()
            with contextlib.redirect_stdout(buf), contextlib.redirect_stderr(err):
                result = ingest_mod.main()
        return result, buf.getvalue(), err.getvalue()

    # ── discovery edge cases ────────────────────────────────────────────────

    def test_discovery_error_returns_one(self):
        result, _, err = self._run(
            [_URL_1], discover=MagicMock(side_effect=RuntimeError("boom")),
        )
        self.assertEqual(result, 1)
        self.assertIn("Failed to read", err)

    def test_no_links_returns_zero(self):
        result, out, _ = self._run([_URL_1], discover=MagicMock(return_value=[]))
        self.assertEqual(result, 0)
        self.assertIn("No ZIP links found", out)

    # ── list (dry run) ──────────────────────────────────────────────────────

    def test_list_mode_shows_status_and_skips_download(self):
        db = self._open_db()
        db.ingest.record_ingested_zip(_URL_1, url=_URL_1, filename="2024_TEOS_XML_01A.zip")
        db.close()
        dl = MagicMock()
        result, out, _ = self._run(
            ['--list', 'https://x/page'],
            discover=MagicMock(return_value=[_URL_1, _URL_2]),
            download=dl,
        )
        self.assertEqual(result, 0)
        self.assertIn("ingested", out)
        self.assertIn("new", out)
        dl.assert_not_called()

    # ── nothing new ─────────────────────────────────────────────────────────

    def test_all_recorded_nothing_new(self):
        db = self._open_db()
        db.ingest.record_ingested_zip(_URL_1, url=_URL_1, filename="a.zip")
        db.ingest.record_ingested_zip(_URL_2, url=_URL_2, filename="b.zip")
        db.close()
        dl = MagicMock()
        result, out, _ = self._run(
            ['https://x/page'],
            discover=MagicMock(return_value=[_URL_1, _URL_2]),
            download=dl,
        )
        self.assertEqual(result, 0)
        self.assertIn("Nothing new", out)
        dl.assert_not_called()

    # ── happy path (sequential) ─────────────────────────────────────────────

    def test_sequential_download_ingest_record_delete(self):
        router = MagicMock()
        router._process_xml.return_value = {'status': 'stored', 'file': 'f.xml', 'ein': '1'}
        result, out, _ = self._run(
            ['--workers', '1', 'https://x/page'],
            discover=MagicMock(return_value=[_URL_1]),
            download=_fake_download(self.created),
            extra_patches=[patch('ingest.UploadRouter', return_value=router)],
        )
        self.assertEqual(result, 0)
        self.assertIn("Complete", out)
        # Recorded in the DB with the stored count.
        db = self._open_db()
        rows = db.ingest.list_ingested_zips()
        db.close()
        self.assertEqual(len(rows), 1)
        self.assertEqual(rows[0]["source"], _URL_1)
        self.assertEqual(rows[0]["filename"], "2024_TEOS_XML_01A.zip")
        self.assertEqual(rows[0]["filings_stored"], 1)
        self.assertEqual(rows[0]["content_length"], 123)
        # Downloaded file deleted afterward.
        self.assertFalse(self.created[0].exists())

    def test_force_reingests_recorded(self):
        db = self._open_db()
        db.ingest.record_ingested_zip(_URL_1, url=_URL_1, filename="2024_TEOS_XML_01A.zip", filings_stored=0)
        db.close()
        router = MagicMock()
        router._process_xml.return_value = {'status': 'stored', 'file': 'f.xml', 'ein': '1'}
        dl = MagicMock(side_effect=_fake_download(self.created))
        result, out, _ = self._run(
            ['--workers', '1', '--force', 'https://x/page'],
            discover=MagicMock(return_value=[_URL_1]),
            download=dl,
            extra_patches=[patch('ingest.UploadRouter', return_value=router)],
        )
        self.assertEqual(result, 0)
        dl.assert_called_once()
        db = self._open_db()
        self.assertEqual(db.ingest.list_ingested_zips()[0]["filings_stored"], 1)
        db.close()

    # ── failure handling ────────────────────────────────────────────────────

    def test_download_failure_is_counted_not_recorded(self):
        dl = MagicMock(side_effect=RuntimeError("network down"))
        result, out, _ = self._run(
            ['--workers', '1', 'https://x/page'],
            discover=MagicMock(return_value=[_URL_1]),
            download=dl,
        )
        self.assertEqual(result, 0)
        self.assertIn("download failed", out)
        db = self._open_db()
        self.assertEqual(db.ingest.get_ingested_sources(), set())
        db.close()

    def test_corrupt_download_not_recorded(self):
        result, out, _ = self._run(
            ['--workers', '1', 'https://x/page'],
            discover=MagicMock(return_value=[_URL_1]),
            download=_fake_download(self.created, good=False),
        )
        self.assertEqual(result, 0)
        self.assertIn("invalid ZIP", out)
        db = self._open_db()
        self.assertEqual(db.ingest.get_ingested_sources(), set())
        db.close()

    # ── download retention ──────────────────────────────────────────────────

    def test_keep_downloads_with_cache_dir(self):
        cache = Path(self._td.name) / "cache"
        router = MagicMock()
        router._process_xml.return_value = {'status': 'stored', 'file': 'f.xml', 'ein': '1'}
        result, _, _ = self._run(
            ['--workers', '1', '--keep-downloads', '--cache-dir', str(cache), 'https://x/page'],
            discover=MagicMock(return_value=[_URL_1]),
            download=_fake_download(self.created),
            extra_patches=[patch('ingest.UploadRouter', return_value=router)],
        )
        self.assertEqual(result, 0)
        self.assertTrue(self.created[0].exists())

    def test_keep_downloads_with_temp_dir_prints_location(self):
        keep_dir = Path(self._td.name) / "kept"
        keep_dir.mkdir()
        router = MagicMock()
        router._process_xml.return_value = {'status': 'stored', 'file': 'f.xml', 'ein': '1'}
        result, out, _ = self._run(
            ['--workers', '1', '--keep-downloads', 'https://x/page'],
            discover=MagicMock(return_value=[_URL_1]),
            download=_fake_download(self.created),
            extra_patches=[
                patch('ingest.UploadRouter', return_value=router),
                patch('ingest.tempfile.mkdtemp', return_value=str(keep_dir)),
            ],
        )
        self.assertEqual(result, 0)
        self.assertIn("Downloads kept in", out)
        self.assertTrue(self.created[0].exists())

    # ── parallel URL path ───────────────────────────────────────────────────

    def test_parallel_url_path(self):
        mock_future = MagicMock()
        mock_future.result.return_value = [_PARSED]
        mock_pool = MagicMock()
        mock_pool.__enter__ = MagicMock(return_value=mock_pool)
        mock_pool.__exit__ = MagicMock(return_value=False)
        mock_pool.submit.return_value = mock_future

        result, out, _ = self._run(
            ['--workers', '2', 'https://x/page'],
            discover=MagicMock(return_value=[_URL_1]),
            download=_fake_download(self.created),
            extra_patches=[
                patch('ingest.ProcessPoolExecutor', return_value=mock_pool),
                patch('ingest.as_completed', side_effect=lambda f: iter(f.keys())),
            ],
        )
        self.assertEqual(result, 0)
        db = self._open_db()
        self.assertEqual(db.ingest.get_ingested_sources(), {_URL_1})
        # The parsed filing was written through the bulk-load flush path.
        self.assertEqual(
            db.cursor.execute("SELECT COUNT(*) FROM filing").fetchone()[0], 1
        )
        db.close()

    # ── direct .zip URL (no page scrape) ────────────────────────────────────

    def test_direct_zip_url_dispatches_to_url_path(self):
        router = MagicMock()
        router._process_xml.return_value = {'status': 'stored', 'file': 'f.xml', 'ein': '1'}
        # discover_zip_urls is NOT mocked here — the real one short-circuits a
        # .zip URL to [url] without any network call.
        result, out, _ = self._run(
            ['--workers', '1', _URL_1],
            download=_fake_download(self.created),
            extra_patches=[patch('ingest.UploadRouter', return_value=router)],
        )
        self.assertEqual(result, 0)
        db = self._open_db()
        self.assertEqual(db.ingest.get_ingested_sources(), {_URL_1})
        db.close()


# ---------------------------------------------------------------------------
# ingest.py — _fmt_duration
# ---------------------------------------------------------------------------

class TestFmtDuration(unittest.TestCase):

    def test_sub_minute(self):
        self.assertEqual(ingest_mod._fmt_duration(42.7), "42.7s")

    def test_minutes(self):
        self.assertEqual(ingest_mod._fmt_duration(125), "2m 05s")

    def test_hours(self):
        self.assertEqual(ingest_mod._fmt_duration(3725), "1h 02m 05s")


# ---------------------------------------------------------------------------
# ingest.py — parallel-path branches (batch flush, errors, --profile)
# ---------------------------------------------------------------------------

class TestIngestParallelBranches(unittest.TestCase):

    def _run(self, argv, extra_patches):
        with contextlib.ExitStack() as stack:
            for p in extra_patches:
                stack.enter_context(p)
            buf, err = io.StringIO(), io.StringIO()
            with contextlib.redirect_stdout(buf), contextlib.redirect_stderr(err):
                with patch('sys.argv', ['ingest'] + argv):
                    result = ingest_mod.main()
        return result, buf.getvalue()

    def _pool(self, result_value):
        fut = MagicMock()
        fut.result.return_value = result_value
        pool = MagicMock()
        pool.__enter__ = MagicMock(return_value=pool)
        pool.__exit__ = MagicMock(return_value=False)
        pool.submit.return_value = fut
        return pool

    @staticmethod
    def _iter(futures):
        return iter(futures.keys())

    def test_read_exception_counts_error(self):
        """reader.read() raising mid-batch is caught and counted (per-file except)."""
        class _FailReader:
            def __init__(self, *a):
                pass
            def __enter__(self):
                return self
            def __exit__(self, *e):
                return False
            def read(self, name):
                raise OSError("boom")

        with tempfile.TemporaryDirectory() as td:
            zd = Path(td) / "zips"; zd.mkdir()
            _make_zip(zd, "test.zip", {"a.xml": _MINIMAL_XML})
            result, out = self._run(['--workers', '2', str(zd)], [
                patch('ingest.OpenReturnDB', return_value=MagicMock()),
                patch('ingest.UploadRouter', return_value=MagicMock()),
                patch('ingest.ProcessPoolExecutor', return_value=self._pool([])),
                patch('ingest.as_completed', side_effect=self._iter),
                patch('ingest.MemberReader', _FailReader),
            ])
        self.assertEqual(result, 0)
        self.assertIn("errors", out)

    def test_batch_threshold_submits_multiple(self):
        """>_BATCH_FILES files in a ZIP triggers a mid-loop submit then a final one."""
        files = {f"f{i:03d}.xml": _MINIMAL_XML for i in range(ingest_mod._BATCH_FILES + 1)}
        pool = self._pool([])
        with tempfile.TemporaryDirectory() as td:
            zd = Path(td) / "zips"; zd.mkdir()
            _make_zip(zd, "big.zip", files)
            result, _ = self._run(['--workers', '2', str(zd)], [
                patch('ingest.OpenReturnDB', return_value=MagicMock()),
                patch('ingest.UploadRouter', return_value=MagicMock()),
                patch('ingest.ProcessPoolExecutor', return_value=pool),
                patch('ingest.as_completed', side_effect=self._iter),
            ])
        self.assertEqual(result, 0)
        self.assertEqual(pool.submit.call_count, 2)  # batch of 50, then 1

    def test_midzip_flush_when_buffer_exceeds_threshold(self):
        """pending_data crossing _DATA_ROWS_PER_FLUSH flushes mid-ZIP."""
        parsed = {
            'status': 'parsed', 'ein': '1', 'name': 'N', 'year': 2023,
            'form_code': '990', 'file': 'f.xml', 'zip_filename': 'test.zip',
            'values': {1: 'v'},
        }
        with tempfile.TemporaryDirectory() as td:
            zd = Path(td) / "zips"; zd.mkdir()
            _make_zip(zd, "test.zip", {"f.xml": _MINIMAL_XML})
            result, _ = self._run(['--workers', '2', str(zd)], [
                patch('ingest.OpenReturnDB', return_value=MagicMock()),
                patch('ingest.UploadRouter', return_value=MagicMock()),
                patch('ingest.ProcessPoolExecutor', return_value=self._pool([parsed])),
                patch('ingest.as_completed', side_effect=self._iter),
                patch('ingest._DATA_ROWS_PER_FLUSH', 0),
            ])
        self.assertEqual(result, 0)

    def test_parallel_badzip_caught(self):
        """MemberReader raising BadZipFile mid-parallel is caught and reported."""
        class _BadReader:
            def __init__(self, *a):
                raise zipfile.BadZipFile("bad")

        with tempfile.TemporaryDirectory() as td:
            zd = Path(td) / "zips"; zd.mkdir()
            _make_zip(zd, "test.zip", {"a.xml": _MINIMAL_XML})
            result, out = self._run(['--workers', '2', str(zd)], [
                patch('ingest.OpenReturnDB', return_value=MagicMock()),
                patch('ingest.UploadRouter', return_value=MagicMock()),
                patch('ingest.ProcessPoolExecutor', return_value=self._pool([])),
                patch('ingest.as_completed', side_effect=self._iter),
                patch('ingest.MemberReader', _BadReader),
            ])
        self.assertEqual(result, 0)
        self.assertIn("corrupt ZIP", out)

    def test_profile_output(self):
        """--profile prints the per-phase breakdown after a parallel run."""
        parsed = {
            'status': 'parsed', 'ein': '1', 'name': 'N', 'year': 2023,
            'form_code': '990', 'file': 'f.xml', 'zip_filename': 'test.zip',
            'values': {},
        }
        with tempfile.TemporaryDirectory() as td:
            zd = Path(td) / "zips"; zd.mkdir()
            _make_zip(zd, "test.zip", {"f.xml": _MINIMAL_XML})
            result, out = self._run(['--workers', '2', '--profile', str(zd)], [
                patch('ingest.OpenReturnDB', return_value=MagicMock()),
                patch('ingest.UploadRouter', return_value=MagicMock()),
                patch('ingest.ProcessPoolExecutor', return_value=self._pool([parsed])),
                patch('ingest.as_completed', side_effect=self._iter),
            ])
        self.assertEqual(result, 0)
        self.assertIn("Profile", out)


if __name__ == '__main__':  # pragma: no cover
    unittest.main()
