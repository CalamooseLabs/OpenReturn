"""Tests for db.py — cmd_init and cmd_migrate."""

import contextlib
import io
import os
import sys
import tempfile
import unittest
from pathlib import Path
from unittest.mock import MagicMock, patch, PropertyMock

_ROOT = os.path.join(os.path.dirname(__file__), '..')
_SRC  = os.path.join(_ROOT, 'src')
sys.path.insert(0, _SRC)
sys.path.insert(0, _ROOT)

import db as db_mod
from database import OpenReturnDB


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def _make_args(**kwargs):
    args = MagicMock()
    for k, v in kwargs.items():
        setattr(args, k, v)
    return args


# ---------------------------------------------------------------------------
# cmd_init
# ---------------------------------------------------------------------------

class TestCmdInit(unittest.TestCase):

    def setUp(self):
        self.db = OpenReturnDB(path=":memory:")

    def tearDown(self):
        self.db.close()

    def _run(self, **kwargs):
        args = _make_args(db=":memory:", **kwargs)
        with patch('db.OpenReturnDB', return_value=self.db), \
             patch.object(self.db, 'close'):
            buf = io.StringIO()
            with contextlib.redirect_stdout(buf):
                result = db_mod.cmd_init(args)
        return result, buf.getvalue()

    def test_returns_zero(self):
        result, _ = self._run()
        self.assertEqual(result, 0)

    def test_prints_initialized(self):
        _, out = self._run()
        self.assertIn("initialized", out)

    def test_prints_form_count(self):
        _, out = self._run()
        # "Forms:" followed by a nonzero count from seed data
        self.assertIn("Forms:", out)

    def test_prints_field_count(self):
        _, out = self._run()
        self.assertIn("Fields:", out)

    def test_form_count_is_nonzero(self):
        count = self.db.cursor.execute("SELECT COUNT(*) FROM form").fetchone()[0]
        self.assertGreater(count, 0)

    def test_field_count_is_nonzero(self):
        count = self.db.cursor.execute("SELECT COUNT(*) FROM field").fetchone()[0]
        self.assertGreater(count, 0)

    def test_closes_db(self):
        mock_db = MagicMock()
        mock_db.cursor.execute.return_value.fetchone.return_value = (5,)
        args = _make_args(db=":memory:")
        with patch('db.OpenReturnDB', return_value=mock_db):
            buf = io.StringIO()
            with contextlib.redirect_stdout(buf):
                db_mod.cmd_init(args)
        mock_db.close.assert_called_once()


# ---------------------------------------------------------------------------
# cmd_migrate — list flag
# ---------------------------------------------------------------------------

class TestCmdMigrateList(unittest.TestCase):

    def _mock_db(self, available, applied):
        mock_db = MagicMock()
        mock_db.migrations.list_available_migrations.return_value = available
        mock_db.migrations.get_applied_migrations.return_value = set(applied)
        return mock_db

    def _run_list(self, mock_db):
        args = _make_args(db=":memory:", list=True)
        with patch('db.OpenReturnDB', return_value=mock_db):
            buf = io.StringIO()
            with contextlib.redirect_stdout(buf):
                result = db_mod.cmd_migrate(args)
        return result, buf.getvalue()

    def test_list_returns_zero(self):
        mock_db = self._mock_db([("001_test", Path("/dev/null"))], [])
        result, _ = self._run_list(mock_db)
        self.assertEqual(result, 0)

    def test_list_shows_migration_name(self):
        mock_db = self._mock_db([("001_add_indexes", Path("/dev/null"))], [])
        _, out = self._run_list(mock_db)
        self.assertIn("001_add_indexes", out)

    def test_list_shows_applied_status(self):
        mock_db = self._mock_db(
            [("001_test", Path("/dev/null"))],
            ["001_test"],
        )
        _, out = self._run_list(mock_db)
        self.assertIn("applied", out)

    def test_list_shows_pending_status(self):
        mock_db = self._mock_db([("001_test", Path("/dev/null"))], [])
        _, out = self._run_list(mock_db)
        self.assertIn("pending", out)

    def test_list_closes_db(self):
        mock_db = self._mock_db([("001_test", Path("/dev/null"))], [])
        args = _make_args(db=":memory:", list=True)
        with patch('db.OpenReturnDB', return_value=mock_db):
            buf = io.StringIO()
            with contextlib.redirect_stdout(buf):
                db_mod.cmd_migrate(args)
        mock_db.close.assert_called_once()


# ---------------------------------------------------------------------------
# cmd_migrate — no pending migrations
# ---------------------------------------------------------------------------

class TestCmdMigrateNoPending(unittest.TestCase):

    def setUp(self):
        self.db = OpenReturnDB(path=":memory:")
        # Pre-apply all migrations so nothing is pending
        for name, path in self.db.migrations.list_available_migrations():
            self.db.migrations.apply_migration(name, path.read_text())

    def tearDown(self):
        self.db.close()

    def _run(self):
        args = _make_args(db=":memory:", list=False)
        with patch('db.OpenReturnDB', return_value=self.db), \
             patch.object(self.db, 'close'):
            buf = io.StringIO()
            with contextlib.redirect_stdout(buf):
                result = db_mod.cmd_migrate(args)
        return result, buf.getvalue()

    def test_returns_zero(self):
        result, _ = self._run()
        self.assertEqual(result, 0)

    def test_prints_no_pending(self):
        _, out = self._run()
        self.assertIn("No pending migrations", out)


# ---------------------------------------------------------------------------
# cmd_migrate — apply pending migrations (mock DB with fake migrations)
# ---------------------------------------------------------------------------

class TestCmdMigrateApply(unittest.TestCase):

    def _make_mock_db(self, names):
        """Return a mock DB with the given migration names as pending."""
        mock_path = MagicMock(spec=Path)
        mock_path.read_text.return_value = "-- no-op"
        mock_db = MagicMock()
        mock_db.migrations.list_available_migrations.return_value = [(n, mock_path) for n in names]
        mock_db.migrations.get_applied_migrations.return_value = set()
        return mock_db

    def _run(self, mock_db):
        args = _make_args(db=":memory:", list=False)
        with patch('db.OpenReturnDB', return_value=mock_db):
            buf = io.StringIO()
            with contextlib.redirect_stdout(buf):
                result = db_mod.cmd_migrate(args)
        return result, buf.getvalue()

    def test_returns_zero_when_migrations_applied(self):
        result, _ = self._run(self._make_mock_db(["001_test"]))
        self.assertEqual(result, 0)

    def test_prints_applying(self):
        _, out = self._run(self._make_mock_db(["001_test"]))
        self.assertIn("Applying", out)

    def test_prints_all_applied(self):
        _, out = self._run(self._make_mock_db(["001_test"]))
        self.assertIn("All migrations applied", out)

    def test_apply_migration_called_for_each_pending(self):
        mock_db = self._make_mock_db(["001_a", "002_b"])
        self._run(mock_db)
        self.assertEqual(mock_db.migrations.apply_migration.call_count, 2)

    def test_second_run_with_none_pending_shows_no_pending(self):
        mock_db = MagicMock()
        mock_db.migrations.list_available_migrations.return_value = []
        mock_db.migrations.get_applied_migrations.return_value = set()
        _, out = self._run(mock_db)
        self.assertIn("No pending migrations", out)


# ---------------------------------------------------------------------------
# cmd_migrate — migration failure
# ---------------------------------------------------------------------------

class TestCmdMigrateFailure(unittest.TestCase):

    def test_returns_one_on_migration_error(self):
        mock_db = MagicMock()
        mock_path = MagicMock(spec=Path)
        mock_path.read_text.return_value = "-- bad sql"
        mock_db.migrations.list_available_migrations.return_value = [("001_bad", mock_path)]
        mock_db.migrations.get_applied_migrations.return_value = set()
        mock_db.migrations.apply_migration.side_effect = Exception("SQL error")

        args = _make_args(db=":memory:", list=False)
        with patch('db.OpenReturnDB', return_value=mock_db):
            buf = io.StringIO()
            with contextlib.redirect_stdout(buf):
                result = db_mod.cmd_migrate(args)
        self.assertEqual(result, 1)

    def test_prints_failed_on_error(self):
        mock_db = MagicMock()
        mock_path = MagicMock(spec=Path)
        mock_path.read_text.return_value = "-- bad sql"
        mock_db.migrations.list_available_migrations.return_value = [("001_bad", mock_path)]
        mock_db.migrations.get_applied_migrations.return_value = set()
        mock_db.migrations.apply_migration.side_effect = Exception("SQL error")

        args = _make_args(db=":memory:", list=False)
        with patch('db.OpenReturnDB', return_value=mock_db):
            buf = io.StringIO()
            with contextlib.redirect_stdout(buf):
                db_mod.cmd_migrate(args)
        self.assertIn("FAILED", buf.getvalue())

    def test_closes_db_on_failure(self):
        mock_db = MagicMock()
        mock_path = MagicMock(spec=Path)
        mock_path.read_text.return_value = "-- bad sql"
        mock_db.migrations.list_available_migrations.return_value = [("001_bad", mock_path)]
        mock_db.migrations.get_applied_migrations.return_value = set()
        mock_db.migrations.apply_migration.side_effect = Exception("SQL error")

        args = _make_args(db=":memory:", list=False)
        with patch('db.OpenReturnDB', return_value=mock_db):
            buf = io.StringIO()
            with contextlib.redirect_stdout(buf):
                db_mod.cmd_migrate(args)
        mock_db.close.assert_called_once()


# ---------------------------------------------------------------------------
# cli.py dispatch — init and migrate subcommands
# ---------------------------------------------------------------------------

import cli as cli_mod


class TestCliDispatchInit(unittest.TestCase):

    def _run(self, argv):
        with patch('sys.argv', argv), \
             patch('db.cmd_init', return_value=0) as mock_init:
            result = cli_mod.main()
        return result, mock_init

    def test_init_dispatches_to_cmd_init(self):
        _, mock_init = self._run(['openreturn', 'init'])
        mock_init.assert_called_once()

    def test_init_returns_zero(self):
        result, _ = self._run(['openreturn', 'init'])
        self.assertEqual(result, 0)

    def test_init_passes_db_arg(self):
        with patch('sys.argv', ['openreturn', 'init', '--db', '/tmp/test.db']), \
             patch('db.cmd_init', return_value=0) as mock_init:
            cli_mod.main()
        args = mock_init.call_args[0][0]
        self.assertEqual(args.db, '/tmp/test.db')


class TestCliDispatchMigrate(unittest.TestCase):

    def _run(self, argv):
        with patch('sys.argv', argv), \
             patch('db.cmd_migrate', return_value=0) as mock_migrate:
            result = cli_mod.main()
        return result, mock_migrate

    def test_migrate_dispatches_to_cmd_migrate(self):
        _, mock_migrate = self._run(['openreturn', 'migrate'])
        mock_migrate.assert_called_once()

    def test_migrate_returns_zero(self):
        result, _ = self._run(['openreturn', 'migrate'])
        self.assertEqual(result, 0)

    def test_migrate_list_flag_passes_through(self):
        with patch('sys.argv', ['openreturn', 'migrate', '--list']), \
             patch('db.cmd_migrate', return_value=0) as mock_migrate:
            cli_mod.main()
        args = mock_migrate.call_args[0][0]
        self.assertTrue(args.list)

    def test_migrate_passes_db_arg(self):
        with patch('sys.argv', ['openreturn', 'migrate', '--db', '/tmp/test.db']), \
             patch('db.cmd_migrate', return_value=0) as mock_migrate:
            cli_mod.main()
        args = mock_migrate.call_args[0][0]
        self.assertEqual(args.db, '/tmp/test.db')


# ---------------------------------------------------------------------------
# cmd_reset
# ---------------------------------------------------------------------------

class TestCmdReset(unittest.TestCase):

    def setUp(self):
        self.td = tempfile.mkdtemp()
        self.path = os.path.join(self.td, 'OpenReturn.db')
        # main + WAL + SHM sidecars
        for suffix in ('', '-wal', '-shm'):
            Path(self.path + suffix).write_bytes(b'x' * 16)

    def _args(self, yes=False):
        return _make_args(db=self.path, yes=yes)

    def _run(self, args, stdin=None):
        buf = io.StringIO()
        ctx = patch('builtins.input', return_value=stdin) if stdin is not None else contextlib.nullcontext()
        with patch('daemon.running_daemon', return_value=None), \
             contextlib.redirect_stdout(buf), contextlib.redirect_stderr(buf), ctx:
            rc = db_mod.cmd_reset(args)
        return rc, buf.getvalue()

    def test_yes_deletes_all_files(self):
        rc, _ = self._run(self._args(yes=True))
        self.assertEqual(rc, 0)
        for suffix in ('', '-wal', '-shm'):
            self.assertFalse(Path(self.path + suffix).exists())

    def test_confirm_by_typing_name_deletes(self):
        rc, _ = self._run(self._args(), stdin='OpenReturn.db')
        self.assertEqual(rc, 0)
        self.assertFalse(Path(self.path).exists())

    def test_wrong_input_aborts(self):
        rc, out = self._run(self._args(), stdin='nope')
        self.assertEqual(rc, 1)
        self.assertIn("Aborted", out)
        self.assertTrue(Path(self.path).exists())

    def test_nothing_to_delete(self):
        for suffix in ('', '-wal', '-shm'):
            Path(self.path + suffix).unlink()
        rc, out = self._run(self._args(yes=True))
        self.assertEqual(rc, 0)
        self.assertIn("Nothing to delete", out)

    def test_refuses_while_background_ingest_running(self):
        buf = io.StringIO()
        with patch('daemon.running_daemon', return_value={"pid": 4321}), \
             contextlib.redirect_stdout(buf), contextlib.redirect_stderr(buf):
            rc = db_mod.cmd_reset(self._args())
        self.assertEqual(rc, 1)
        self.assertIn("background ingest", buf.getvalue().lower())
        self.assertTrue(Path(self.path).exists())

    def test_yes_does_not_override_running_ingest(self):
        # The running-ingest guard is a safety barrier, not a confirmation
        # prompt — --yes must NOT bypass it.
        buf = io.StringIO()
        with patch('daemon.running_daemon', return_value={"pid": 4321}), \
             contextlib.redirect_stdout(buf), contextlib.redirect_stderr(buf):
            rc = db_mod.cmd_reset(self._args(yes=True))
        self.assertEqual(rc, 1)
        self.assertTrue(Path(self.path).exists())


if __name__ == '__main__':  # pragma: no cover
    unittest.main()
