"""Tests for src/status.py — size/encryption/count/migration helpers, server
probe, and the cmd_status renderer."""

import contextlib
import io
import json
import os
import socket
import sys
import tempfile
import unittest
from types import SimpleNamespace
from unittest.mock import patch

_ROOT = os.path.join(os.path.dirname(__file__), '..')
_SRC = os.path.join(_ROOT, 'src')
sys.path.insert(0, _SRC)
sys.path.insert(0, _ROOT)

import status
from database.Score import ScoreDatabase


def _args(db=None, host='localhost', port=9, as_json=False):
    # port 9 (discard) is virtually never open on a dev box → "not responding"
    return SimpleNamespace(db=db, host=host, port=port, as_json=as_json)


class TestFmtBytes(unittest.TestCase):

    def test_bytes(self):
        self.assertEqual(status._fmt_bytes(0), "0 B")
        self.assertEqual(status._fmt_bytes(512), "512 B")

    def test_kib(self):
        self.assertEqual(status._fmt_bytes(2048), "2.0 KiB")

    def test_mib(self):
        self.assertEqual(status._fmt_bytes(5 * 1024 * 1024), "5.0 MiB")

    def test_gib(self):
        self.assertEqual(status._fmt_bytes(3 * 1024 ** 3), "3.0 GiB")


class TestSeededDB(unittest.TestCase):
    """Build one seeded DB file the helpers can read."""

    @classmethod
    def setUpClass(cls):
        cls.td = tempfile.mkdtemp()
        cls.db_path = os.path.join(cls.td, 'OpenReturn.db')
        # ScoreDatabase(name=...) writes <name>.db
        db = ScoreDatabase(name=os.path.join(cls.td, 'OpenReturn'))
        db.cursor.execute("INSERT INTO organization (ein, name) VALUES ('123456789','Org')")
        db.cursor.execute(
            "INSERT INTO filing (filing_id, uuid, year, organization_id, form_code, zip_filename) "
            "VALUES (1,'u1',2023,'123456789','990','a.zip')")
        db.cursor.execute("INSERT INTO ingested_zip (source, filename, filings_stored) "
                          "VALUES ('http://h/a.zip','a.zip',1)")
        db.connection.commit()
        db.close()

    def test_file_sizes(self):
        s = status._file_sizes(self.db_path)
        self.assertGreater(s["main"], 0)
        self.assertEqual(s["total"], s["main"] + s["wal"] + s["shm"])

    def test_counts(self):
        c = status._counts(self.db_path)
        self.assertEqual(c["organizations"], 1)
        self.assertEqual(c["filings"], 1)
        self.assertEqual(c["ingested archives"], 1)

    def test_migrations_all_applied_or_pending(self):
        m = status._migrations(self.db_path)
        self.assertIn("applied", m)
        self.assertIn("pending", m)
        self.assertEqual(m["applied"] + m["pending"], m["applied"] + len(m["pending_names"]))

    def test_encryption_off_when_no_key(self):
        with patch.dict(os.environ, {}, clear=False):
            os.environ.pop('DB_SECRET_KEY', None)
            os.environ.pop('DB_SECRET_KEY_FILE', None)
            enc = status._encryption(self.db_path)
        self.assertFalse(enc["key_configured"])
        # Unencrypted SQLite begins with the magic header.
        self.assertFalse(enc["looks_encrypted"])

    def test_gather_includes_data_and_migrations(self):
        rep = status.gather(_args(db=self.db_path))
        self.assertTrue(rep["database"]["exists"])
        self.assertEqual(rep["data"]["filings"], 1)
        self.assertIn("migrations", rep)

    def test_cmd_status_json(self):
        buf = io.StringIO()
        with contextlib.redirect_stdout(buf):
            rc = status.cmd_status(_args(db=self.db_path, as_json=True))
        self.assertEqual(rc, 0)
        rep = json.loads(buf.getvalue())
        self.assertEqual(rep["database"]["path"], self.db_path)

    def test_cmd_status_human_renders(self):
        buf = io.StringIO()
        with contextlib.redirect_stdout(buf):
            rc = status.cmd_status(_args(db=self.db_path))
        out = buf.getvalue()
        self.assertEqual(rc, 0)
        self.assertIn("OpenReturn status", out)
        self.assertIn("Database", out)
        self.assertIn("Migrations", out)


class TestMissingDB(unittest.TestCase):

    def test_not_initialized(self):
        with tempfile.TemporaryDirectory() as td:
            path = os.path.join(td, 'OpenReturn.db')
            rep = status.gather(_args(db=path))
            self.assertFalse(rep["database"]["exists"])
            self.assertNotIn("data", rep)

    def test_human_shows_not_initialized(self):
        with tempfile.TemporaryDirectory() as td:
            path = os.path.join(td, 'OpenReturn.db')
            buf = io.StringIO()
            with contextlib.redirect_stdout(buf):
                status.cmd_status(_args(db=path))
            self.assertIn("not initialized", buf.getvalue())


class TestServerProbe(unittest.TestCase):

    def test_listening_socket_detected(self):
        srv = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        srv.bind(('127.0.0.1', 0))
        srv.listen(1)
        port = srv.getsockname()[1]
        try:
            self.assertTrue(status._probe_server('127.0.0.1', port))
        finally:
            srv.close()

    def test_closed_port_not_listening(self):
        # Bind+close to obtain a port nothing is listening on.
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.bind(('127.0.0.1', 0))
        port = s.getsockname()[1]
        s.close()
        self.assertFalse(status._probe_server('127.0.0.1', port, timeout=0.2))


class TestSystemdState(unittest.TestCase):

    def test_no_systemctl_returns_none(self):
        with patch('status.shutil.which', return_value=None):
            self.assertIsNone(status._systemd_state())

    def test_reads_is_active_output(self):
        fake = SimpleNamespace(stdout="active\n", stderr="")
        with patch('status.shutil.which', return_value='/usr/bin/systemctl'), \
             patch('status.subprocess.run', return_value=fake):
            self.assertEqual(status._systemd_state(), "active")


class TestLockedDB(unittest.TestCase):

    def test_counts_reports_locked(self):
        # Simulate an exclusive-locked DB: the COUNT raises "database is locked".
        class _Cur:
            def execute(self, *a):
                raise Exception("database is locked")
        class _Conn:
            def cursor(self):
                return _Cur()
            def close(self):
                pass
        with patch('database.base._open_connection', return_value=_Conn()):
            self.assertEqual(status._counts('whatever.db'), {"locked": True})


if __name__ == '__main__':  # pragma: no cover
    unittest.main()
