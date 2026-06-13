"""Tests for ingest --schedule parsing/waiting and --restart-server helpers."""

import contextlib
import io
import os
import sys
import unittest
from datetime import datetime, timedelta
from types import SimpleNamespace
from unittest.mock import MagicMock, patch

_SRC = os.path.join(os.path.dirname(__file__), '..', 'src')
sys.path.insert(0, _SRC)

import ingest as ingest_mod
import daemon


class TestParseSchedule(unittest.TestCase):

    NOW = datetime(2026, 6, 13, 4, 0, 0)

    def p(self, s):
        return ingest_mod._parse_schedule(s, now=self.NOW)

    def test_relative_seconds(self):
        self.assertEqual(self.p('+30s'), self.NOW + timedelta(seconds=30))

    def test_relative_minutes(self):
        self.assertEqual(self.p('+15m'), self.NOW + timedelta(minutes=15))

    def test_relative_hours(self):
        self.assertEqual(self.p('+2h'), self.NOW + timedelta(hours=2))

    def test_relative_days(self):
        self.assertEqual(self.p('+1d'), self.NOW + timedelta(days=1))

    def test_clock_future_today(self):
        self.assertEqual(self.p('06:30'), datetime(2026, 6, 13, 6, 30))

    def test_clock_past_rolls_to_tomorrow(self):
        # 03:30 is before 04:00 now → next day
        self.assertEqual(self.p('03:30'), datetime(2026, 6, 14, 3, 30))

    def test_clock_with_seconds(self):
        self.assertEqual(self.p('06:30:15'), datetime(2026, 6, 13, 6, 30, 15))

    def test_absolute_space(self):
        self.assertEqual(self.p('2026-07-01 02:00'), datetime(2026, 7, 1, 2, 0))

    def test_absolute_t_separator(self):
        self.assertEqual(self.p('2026-07-01T02:00'), datetime(2026, 7, 1, 2, 0))

    def test_invalid_garbage(self):
        with self.assertRaises(ValueError):
            self.p('nonsense')

    def test_invalid_hour_out_of_range(self):
        with self.assertRaises(ValueError):
            self.p('25:00')

    def test_invalid_relative_unit(self):
        with self.assertRaises(ValueError):
            self.p('+5x')


class TestWaitUntil(unittest.TestCase):

    def setUp(self):
        daemon._stop_requested = False

    def tearDown(self):
        daemon._stop_requested = False

    def test_past_target_returns_immediately(self):
        self.assertTrue(ingest_mod._wait_until(datetime.now() - timedelta(seconds=5)))

    def test_stop_requested_cancels(self):
        daemon._stop_requested = True
        with contextlib.redirect_stdout(io.StringIO()):
            # target in the future, but stop flag set → returns False without sleeping out
            self.assertFalse(ingest_mod._wait_until(datetime.now() + timedelta(seconds=30)))

    def test_keyboard_interrupt_cancels(self):
        with contextlib.redirect_stdout(io.StringIO()), \
             patch('ingest.time.sleep', side_effect=KeyboardInterrupt):
            self.assertFalse(ingest_mod._wait_until(datetime.now() + timedelta(seconds=30)))


class TestStopRunningServer(unittest.TestCase):

    def test_no_server_returns_none(self):
        with patch('daemon.running_daemon', return_value=None), \
             contextlib.redirect_stdout(io.StringIO()):
            self.assertIsNone(ingest_mod._stop_running_server())

    def test_systemd_managed_is_left_alone(self):
        with patch('daemon.running_daemon', return_value={"pid": 123}), \
             patch('ingest._systemd_active', return_value=True), \
             contextlib.redirect_stdout(io.StringIO()):
            self.assertIsNone(ingest_mod._stop_running_server())

    def test_stops_and_returns_config(self):
        info = {"pid": 4242, "host": "0.0.0.0", "port": 9000, "auth": True, "debug": False}
        with patch('daemon.running_daemon', return_value=info), \
             patch('ingest._systemd_active', return_value=False), \
             patch('ingest.os.kill') as kill, \
             patch('daemon.pid_alive', return_value=False), \
             contextlib.redirect_stdout(io.StringIO()):
            cfg = ingest_mod._stop_running_server()
        kill.assert_called_once()
        self.assertEqual(cfg, {"host": "0.0.0.0", "port": 9000, "auth": True, "debug": False})


class TestRunIngestWiring(unittest.TestCase):
    """_run_ingest orchestration without real ingest/daemon work."""

    def _args(self, **kw):
        base = dict(directory='/data/zips', restart_server=False)
        base.update(kw)
        return SimpleNamespace(**base)

    def test_waits_then_ingests(self):
        with patch('ingest._wait_until', return_value=True) as wait, \
             patch('ingest.sources.is_url', return_value=False), \
             patch('ingest._cmd_ingest_dir', return_value=0) as dir_ingest:
            rc = ingest_mod._run_ingest(self._args(), '/data/zips', datetime.now())
        wait.assert_called_once()
        dir_ingest.assert_called_once()
        self.assertEqual(rc, 0)

    def test_cancel_skips_ingest(self):
        with patch('ingest._wait_until', return_value=False), \
             patch('ingest._cmd_ingest_dir') as dir_ingest, \
             contextlib.redirect_stdout(io.StringIO()):
            rc = ingest_mod._run_ingest(self._args(), '/data/zips', datetime.now())
        dir_ingest.assert_not_called()
        self.assertEqual(rc, 0)

    def test_restart_server_stops_and_restarts_around_ingest(self):
        cfg = {"host": "localhost", "port": 8080}
        order = []
        with patch('ingest._stop_running_server', return_value=cfg) as stop, \
             patch('ingest.sources.is_url', return_value=False), \
             patch('ingest._cmd_ingest_dir', side_effect=lambda *a: order.append('ingest') or 0), \
             patch('ingest._restart_server', side_effect=lambda c: order.append('restart')) as restart:
            ingest_mod._run_ingest(self._args(restart_server=True), '/data/zips', None)
        stop.assert_called_once()
        restart.assert_called_once_with(cfg)
        self.assertEqual(order, ['ingest', 'restart'])  # restart after ingest

    def test_restart_server_restarts_even_if_ingest_raises(self):
        with patch('ingest._stop_running_server', return_value={"port": 8080}), \
             patch('ingest.sources.is_url', return_value=False), \
             patch('ingest._cmd_ingest_dir', side_effect=RuntimeError('boom')), \
             patch('ingest._restart_server') as restart:
            with self.assertRaises(RuntimeError):
                ingest_mod._run_ingest(self._args(restart_server=True), '/data/zips', None)
        restart.assert_called_once()  # finally-block restart still runs


if __name__ == '__main__':  # pragma: no cover
    unittest.main()
