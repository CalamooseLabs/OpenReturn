"""Tests for src/daemon.py — pidfile handling, liveness, and the double-fork
background runner with cooperative stop."""

import os
import signal
import sys
import tempfile
import time
import unittest
from pathlib import Path

_SRC = os.path.join(os.path.dirname(__file__), '..', 'src')
sys.path.insert(0, _SRC)

import daemon


class TestStopFlag(unittest.TestCase):

    def setUp(self):
        daemon._stop_requested = False

    def tearDown(self):
        daemon._stop_requested = False

    def test_default_false(self):
        self.assertFalse(daemon.stop_requested())

    def test_request_stop_sets_flag(self):
        daemon.request_stop()
        self.assertTrue(daemon.stop_requested())

    def test_handler_signature_accepts_signal_args(self):
        # SIGTERM handlers are called with (signum, frame)
        daemon.request_stop(signal.SIGTERM, None)
        self.assertTrue(daemon.stop_requested())


class TestPidfile(unittest.TestCase):

    def setUp(self):
        self.td = tempfile.mkdtemp()
        self.pf = os.path.join(self.td, 'ingest.pid')

    def test_write_then_read_roundtrip(self):
        daemon.write_pidfile(self.pf, {"pid": 123, "source": "x"})
        self.assertEqual(daemon.read_pidfile(self.pf), {"pid": 123, "source": "x"})

    def test_read_missing_returns_none(self):
        self.assertIsNone(daemon.read_pidfile(self.pf))

    def test_read_corrupt_returns_none(self):
        Path(self.pf).write_text("not json {{{")
        self.assertIsNone(daemon.read_pidfile(self.pf))

    def test_remove_missing_is_silent(self):
        daemon.remove_pidfile(self.pf)  # should not raise

    def test_remove_existing(self):
        daemon.write_pidfile(self.pf, {"pid": 1})
        daemon.remove_pidfile(self.pf)
        self.assertFalse(os.path.exists(self.pf))


class TestPidAlive(unittest.TestCase):

    def test_self_is_alive(self):
        self.assertTrue(daemon.pid_alive(os.getpid()))

    def test_unused_pid_not_alive(self):
        # A very high PID is virtually certain not to exist.
        self.assertFalse(daemon.pid_alive(2_000_000_000))


class TestRunningDaemon(unittest.TestCase):

    def setUp(self):
        self.td = tempfile.mkdtemp()
        self.pf = os.path.join(self.td, 'ingest.pid')

    def test_no_pidfile_returns_none(self):
        self.assertIsNone(daemon.running_daemon(self.pf))

    def test_live_pid_returns_info(self):
        daemon.write_pidfile(self.pf, {"pid": os.getpid(), "source": "s"})
        info = daemon.running_daemon(self.pf)
        self.assertIsNotNone(info)
        self.assertEqual(info["source"], "s")

    def test_stale_pidfile_is_removed(self):
        daemon.write_pidfile(self.pf, {"pid": 2_000_000_000})
        self.assertIsNone(daemon.running_daemon(self.pf))
        self.assertFalse(os.path.exists(self.pf))


class TestSpawnLock(unittest.TestCase):

    def setUp(self):
        self.td = tempfile.mkdtemp()
        self.pf = os.path.join(self.td, 'ingest.pid')

    def test_acquire_then_second_fails(self):
        lock = daemon.acquire_spawn_lock(self.pf)
        self.assertIsNotNone(lock)
        self.assertIsNone(daemon.acquire_spawn_lock(self.pf))

    def test_release_allows_reacquire(self):
        lock = daemon.acquire_spawn_lock(self.pf)
        daemon.release_spawn_lock(lock)
        self.assertIsNotNone(daemon.acquire_spawn_lock(self.pf))

    def test_release_none_is_noop(self):
        daemon.release_spawn_lock(None)  # should not raise


class TestSpawnBackground(unittest.TestCase):
    """Exercises the real double-fork. Each test waits for the detached daemon
    to finish (the pidfile disappears on clean exit)."""

    def setUp(self):
        self.td = tempfile.mkdtemp()
        self.pf = os.path.join(self.td, 'ingest.pid')
        self.log = os.path.join(self.td, 'ingest.log')

    def _wait_gone(self, pid, timeout=10.0):
        deadline = time.monotonic() + timeout
        while time.monotonic() < deadline:
            if not daemon.pid_alive(pid):
                return True
            time.sleep(0.05)
        return False

    def test_runs_work_and_returns_pid(self):
        marker = os.path.join(self.td, 'marker')

        def run():
            Path(marker).write_text("ran")
            return 0

        pid = daemon.spawn_background(run, self.log, self.pf, {"source": "s"})
        self.assertGreater(pid, 0)
        self.assertTrue(self._wait_gone(pid))
        self.assertTrue(os.path.exists(marker))

    def test_pidfile_written_then_cleaned(self):
        def run():
            time.sleep(0.3)
            return 0

        pid = daemon.spawn_background(run, self.log, self.pf, {"source": "s"})
        # Pidfile exists while running.
        info = daemon.read_pidfile(self.pf)
        self.assertEqual(info["pid"], pid)
        self.assertTrue(self._wait_gone(pid))
        # Removed on clean exit.
        self.assertFalse(os.path.exists(self.pf))

    def test_cooperative_stop_via_sigterm(self):
        def run():
            for _ in range(400):
                if daemon.stop_requested():
                    break
                time.sleep(0.05)
            return 0

        pid = daemon.spawn_background(run, self.log, self.pf, {"source": "s"})
        time.sleep(0.3)
        self.assertTrue(daemon.pid_alive(pid))
        os.kill(pid, signal.SIGTERM)
        self.assertTrue(self._wait_gone(pid), "daemon should exit after SIGTERM")
        self.assertFalse(os.path.exists(self.pf))

    def test_output_goes_to_log(self):
        def run():
            print("hello-from-daemon")
            return 0

        pid = daemon.spawn_background(run, self.log, self.pf, {"source": "s"})
        self.assertTrue(self._wait_gone(pid))
        self.assertIn("hello-from-daemon", Path(self.log).read_text())

    def test_pidfile_none_skips_pidfile_but_still_runs(self):
        marker = os.path.join(self.td, 'marker2')

        def run():
            Path(marker).write_text("ran")
            return 0

        pid = daemon.spawn_background(run, self.log, None, {"role": "server"})
        self.assertGreater(pid, 0)
        self.assertTrue(self._wait_gone(pid))
        self.assertTrue(os.path.exists(marker))
        self.assertFalse(os.path.exists(self.pf))  # no pidfile managed

    def test_nonzero_return_code_still_cleans_pidfile(self):
        def run():
            return 3

        pid = daemon.spawn_background(run, self.log, self.pf, {"source": "s"})
        self.assertTrue(self._wait_gone(pid))
        self.assertFalse(os.path.exists(self.pf))

    def test_exception_in_run_is_logged_and_cleaned(self):
        def run():
            raise RuntimeError("boom-xyz")

        pid = daemon.spawn_background(run, self.log, self.pf, {"source": "s"})
        self.assertTrue(self._wait_gone(pid))
        self.assertFalse(os.path.exists(self.pf))
        self.assertIn("boom-xyz", Path(self.log).read_text())


if __name__ == '__main__':  # pragma: no cover
    unittest.main()
