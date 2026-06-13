"""Tests for cmd_serve's single-instance guard and server.pid lifecycle."""

import contextlib
import io
import os
import sys
import tempfile
import unittest
from types import SimpleNamespace
from unittest.mock import patch

_SRC = os.path.join(os.path.dirname(__file__), '..', 'src')
sys.path.insert(0, _SRC)

import main
import daemon


def _args(testing=False, host='localhost', port=8080, auth=False, debug=False):
    return SimpleNamespace(testing=testing, zip_dir=None, host=host, port=port,
                           auth=auth, debug=debug, workers=1)


class TestSingleInstanceGuard(unittest.TestCase):

    def test_refuses_when_a_server_is_running(self):
        buf = io.StringIO()
        with patch('daemon.running_daemon', return_value={"pid": 999, "host": "localhost", "port": 8080}), \
             patch('main.ScoreDatabase') as SD, \
             contextlib.redirect_stdout(buf), contextlib.redirect_stderr(buf):
            rc = main.cmd_serve(_args())
        self.assertEqual(rc, 1)
        self.assertIn("already running", buf.getvalue())
        SD.assert_not_called()  # bailed before opening the DB

    def test_testing_mode_skips_guard(self):
        # --testing must not be blocked by a stale/foreign server.pid.
        with tempfile.TemporaryDirectory() as td:
            cwd = os.getcwd()
            os.chdir(td)
            try:
                with patch('daemon.running_daemon', return_value={"pid": 999}) as rd, \
                     patch('main.ScoreDatabase'), patch('main.UploadRouter'), \
                     patch('main.OrgRouter'), patch('main.FilingRouter'), \
                     patch('main.ScoreRouter'), patch('main.Server') as Srv, \
                     patch('main.signal.signal'), \
                     patch('main._dump_db'), \
                     contextlib.redirect_stdout(io.StringIO()):
                    Srv.return_value.run.return_value = None
                    rc = main.cmd_serve(_args(testing=True))
                # guard is skipped in testing mode → running_daemon not consulted
                rd.assert_not_called()
                self.assertEqual(rc, 0)
            finally:
                os.chdir(cwd)


class TestPidfileLifecycle(unittest.TestCase):

    def setUp(self):
        self._cwd = os.getcwd()
        self.td = tempfile.mkdtemp()
        os.chdir(self.td)

    def tearDown(self):
        os.chdir(self._cwd)

    def test_pidfile_written_during_run_and_removed_after(self):
        seen = {}

        def fake_run():
            seen['exists_during'] = os.path.exists(daemon.SERVER_PIDFILE)
            seen['pid'] = daemon.read_pidfile(daemon.SERVER_PIDFILE)

        with patch('daemon.running_daemon', return_value=None), \
             patch('main.ScoreDatabase'), patch('main.UploadRouter'), \
             patch('main.OrgRouter'), patch('main.FilingRouter'), \
             patch('main.ScoreRouter'), patch('main.Server') as Srv, \
             patch('main.signal.signal'), \
             contextlib.redirect_stdout(io.StringIO()):
            Srv.return_value.run.side_effect = fake_run
            rc = main.cmd_serve(_args(host='0.0.0.0', port=9001, auth=True))

        self.assertEqual(rc, 0)
        self.assertTrue(seen['exists_during'], "server.pid should exist while serving")
        self.assertEqual(seen['pid']['host'], '0.0.0.0')
        self.assertEqual(seen['pid']['port'], 9001)
        self.assertTrue(seen['pid']['auth'])
        self.assertEqual(seen['pid']['role'], 'server')
        self.assertFalse(os.path.exists(daemon.SERVER_PIDFILE), "server.pid removed on shutdown")

    def test_pidfile_removed_even_if_run_raises(self):
        with patch('daemon.running_daemon', return_value=None), \
             patch('main.ScoreDatabase'), patch('main.UploadRouter'), \
             patch('main.OrgRouter'), patch('main.FilingRouter'), \
             patch('main.ScoreRouter'), patch('main.Server') as Srv, \
             patch('main.signal.signal'), \
             contextlib.redirect_stdout(io.StringIO()):
            Srv.return_value.run.side_effect = KeyboardInterrupt
            with self.assertRaises(KeyboardInterrupt):
                main.cmd_serve(_args())
        self.assertFalse(os.path.exists(daemon.SERVER_PIDFILE))


if __name__ == '__main__':  # pragma: no cover
    unittest.main()
