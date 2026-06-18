"""Thread-local DB connections for the multi-threaded HTTP server.

The server (ThreadingHTTPServer) handles each request on its own thread; the DB
layer gives each thread its own SQLite connection so concurrent reads run in
parallel (WAL) instead of contending on one shared cursor. These tests verify
the mechanism — the rest of the suite is single-threaded and can't.
"""

import os
import shutil
import sqlite3
import tempfile
import threading
import unittest
import urllib.request
from http.server import BaseHTTPRequestHandler

from database import OpenReturnDB
from server.server import PooledHTTPServer


class TestThreadLocalConnections(unittest.TestCase):
    def setUp(self):
        self._tmp = tempfile.mkdtemp()
        self.path = os.path.join(self._tmp, "thread.db")
        self.db = OpenReturnDB(path=self.path)

    def tearDown(self):
        self.db.close()
        shutil.rmtree(self._tmp, ignore_errors=True)

    def test_memory_db_never_enables_threadlocal(self):
        # A per-thread :memory: connection would be a separate empty DB, so
        # enable_threadlocal must be a no-op for in-memory databases.
        mdb = OpenReturnDB(path=":memory:")
        mdb.enable_threadlocal()
        self.assertFalse(mdb._threadlocal)
        mdb.close()

    def test_main_thread_keeps_the_main_connection(self):
        self.db.enable_threadlocal()
        self.db.cursor.execute("SELECT 1").fetchone()
        # The main thread never opens a thread-local connection.
        self.assertIsNone(getattr(self.db._tls, "connection", None))

    def test_concurrent_reads_use_per_thread_connections(self):
        self.db.enable_threadlocal()
        self.assertTrue(self.db._threadlocal)
        # model_kind is seeded (model / composite / super_composite).
        expected = self.db.cursor.execute(
            "SELECT COUNT(*) FROM model_kind").fetchone()[0]

        errors: list = []
        results: list = []
        barrier = threading.Barrier(8)

        def worker():
            try:
                barrier.wait()  # maximize real overlap
                for _ in range(25):
                    n = self.db.cursor.execute(
                        "SELECT COUNT(*) FROM model_kind").fetchone()[0]
                    results.append(n)
                    # A concern method routes its cursor through the coordinator's
                    # thread-local too — exercise that path as well.
                    self.db.scores.list_model_kinds()
            except Exception as exc:  # noqa: BLE001 — capture for the assert
                errors.append(exc)

        threads = [threading.Thread(target=worker) for _ in range(8)]
        for t in threads:
            t.start()
        for t in threads:
            t.join()

        self.assertEqual(errors, [], f"threaded reads raised: {errors[:3]}")
        self.assertTrue(results)
        self.assertTrue(all(r == expected for r in results))
        # Worker threads opened their own connections (tracked for close()).
        self.assertGreaterEqual(len(self.db._thread_conns), 1)

    def test_close_closes_thread_connections(self):
        self.db.enable_threadlocal()

        def worker():
            self.db.cursor.execute("SELECT 1").fetchone()

        t = threading.Thread(target=worker)
        t.start()
        t.join()
        self.assertGreaterEqual(len(self.db._thread_conns), 1)
        conns = list(self.db._thread_conns)
        self.db.close()
        # After close() each per-thread connection is ACTUALLY closed — not merely
        # unusable from the main thread. Per-thread connections are opened with
        # check_same_thread=False so the main thread's close() can release them; a
        # use-after-close therefore raises "closed database", NOT a cross-thread
        # ProgrammingError (which would mean the connection had leaked, still open).
        for conn in conns:
            with self.assertRaises(sqlite3.ProgrammingError) as cm:
                conn.execute("SELECT 1")
            self.assertIn("closed", str(cm.exception).lower())


    def test_pooled_server_bounds_connections(self):
        """The pooled HTTP server reuses a fixed set of worker threads, so the
        per-thread connection count stays bounded by max_workers no matter how
        many requests arrive. This is the regression guard for the old
        thread-per-request leak (which opened one connection per request and never
        closed it — 60 requests would have meant 60+ leaked connections)."""
        self.db.enable_threadlocal()
        db = self.db
        max_workers = 4

        class Handler(BaseHTTPRequestHandler):
            def do_GET(self):
                # Touch the DB on the worker thread → opens/reuses its connection.
                db.cursor.execute("SELECT COUNT(*) FROM model_kind").fetchone()
                self.send_response(200)
                self.send_header("Content-Length", "2")
                self.end_headers()
                self.wfile.write(b"ok")

            def log_message(self, *_args):
                pass

        httpd = PooledHTTPServer(("127.0.0.1", 0), Handler, max_workers=max_workers)
        port = httpd.server_address[1]
        serve = threading.Thread(target=httpd.serve_forever, daemon=True)
        serve.start()
        try:
            for _ in range(60):
                with urllib.request.urlopen(
                    f"http://127.0.0.1:{port}/", timeout=5) as resp:
                    resp.read()
        finally:
            httpd.shutdown()
            httpd.server_close()
            serve.join(timeout=5)

        # 60 requests served, but worker threads (and thus connections) are capped.
        self.assertGreaterEqual(len(db._thread_conns), 1)
        self.assertLessEqual(len(db._thread_conns), max_workers)


if __name__ == "__main__":
    unittest.main()
