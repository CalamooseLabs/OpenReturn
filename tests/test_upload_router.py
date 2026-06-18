import os
import sys
import unittest
from unittest.mock import MagicMock, patch

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

from router.Upload import UploadRouter


def _make_router():
    db = MagicMock()
    # UploadRouter.__init__ reads these once; values are opaque to the grab routes.
    db.meta.get_xpath_index.return_value = {}
    db.meta.get_supported_forms.return_value = set()
    return UploadRouter(db=db), db


def _qp(**kwargs):
    return {k: [v] for k, v in kwargs.items()}


def _headers():
    h = MagicMock()
    h.get.return_value = ""
    return h


def _call(router, method, path, query_params=None, body=None):
    handler = router.routes[method][path]
    return handler(query_params=query_params or {}, body=body, headers=_headers())


# ---------------------------------------------------------------------------
# Route registration + permissions
# ---------------------------------------------------------------------------

class TestGrabRoutesRegistered(unittest.TestCase):

    def setUp(self):
        self.router, _ = _make_router()

    def test_ingested_registered(self):
        self.assertIn("/upload/ingested", self.router.routes["GET"])

    def test_discover_registered(self):
        self.assertIn("/upload/discover", self.router.routes["POST"])

    def test_grab_registered(self):
        self.assertIn("/upload/grab", self.router.routes["POST"])

    def test_grab_requires_upload_write(self):
        handler = self.router.routes["POST"]["/upload/grab"]
        self.assertEqual(handler._permission, "upload:write")


# ---------------------------------------------------------------------------
# GET /upload/ingested
# ---------------------------------------------------------------------------

class TestListIngested(unittest.TestCase):

    def setUp(self):
        self.router, self.db = _make_router()
        self.db.ingest.list_ingested_zips.return_value = [
            {"source": "https://x/01A.zip", "filename": "01A.zip", "filings_stored": 10},
            {"source": "https://x/02A.zip", "filename": "02A.zip", "filings_stored": 20},
        ]
        self.db.filings.archives_summary.return_value = [
            {"zip_filename": "02A.zip", "filings": 20, "first_year": 2024,
             "last_year": 2024, "first_ingested": "t1", "last_ingested": "t2"},
        ]

    def test_lists_grabbed_newest_first(self):
        with patch("daemon.running_daemon", return_value=None):
            out = _call(self.router, "GET", "/upload/ingested")
        self.assertEqual(out["grabbed_count"], 2)
        # list_ingested_zips returns oldest-first; the route reverses it.
        self.assertEqual(out["grabbed"][0]["filename"], "02A.zip")
        self.assertEqual(out["archives"][0]["filings"], 20)
        self.assertFalse(out["ingest_running"])
        self.assertIn("irs.gov", out["default_source"])

    def test_reports_running_ingest(self):
        with patch("daemon.running_daemon", return_value={"pid": 4242}):
            out = _call(self.router, "GET", "/upload/ingested")
        self.assertTrue(out["ingest_running"])
        self.assertEqual(out["ingest"]["pid"], 4242)


# ---------------------------------------------------------------------------
# POST /upload/discover
# ---------------------------------------------------------------------------

class TestDiscover(unittest.TestCase):

    def setUp(self):
        self.router, self.db = _make_router()
        self.db.ingest.get_ingested_sources.return_value = {"https://x/01A.zip"}

    def test_discovers_and_flags_ingested(self):
        urls = ["https://x/01A.zip", "https://x/02A.zip"]
        with patch("sources.discover_zip_urls", return_value=urls):
            out = _call(self.router, "POST", "/upload/discover",
                        body={"url": "https://x/index.html"})
        self.assertEqual(out["count"], 2)
        self.assertEqual(out["new"], 1)
        by_name = {a["filename"]: a for a in out["archives"]}
        self.assertTrue(by_name["01A.zip"]["ingested"])
        self.assertFalse(by_name["02A.zip"]["ingested"])

    def test_defaults_to_irs_url(self):
        with patch("sources.discover_zip_urls", return_value=[]) as disc:
            out = _call(self.router, "POST", "/upload/discover", body={})
        self.assertIn("irs.gov", disc.call_args[0][0])
        self.assertIn("irs.gov", out["source"])

    def test_rejects_non_url(self):
        out = _call(self.router, "POST", "/upload/discover", body={"url": "not-a-url"})
        self.assertIn("error", out)

    def test_surfaces_fetch_failure(self):
        with patch("sources.discover_zip_urls", side_effect=OSError("boom")):
            out = _call(self.router, "POST", "/upload/discover",
                        body={"url": "https://x/index.html"})
        self.assertIn("error", out)
        self.assertIn("boom", out["error"])


# ---------------------------------------------------------------------------
# POST /upload/grab
# ---------------------------------------------------------------------------

class TestGrab(unittest.TestCase):

    def setUp(self):
        self.router, self.db = _make_router()

    def test_rejects_non_url(self):
        out = _call(self.router, "POST", "/upload/grab", body={"url": "nope"})
        self.assertIn("error", out)

    def test_rejects_when_already_running(self):
        with patch("daemon.running_daemon", return_value={"pid": 1}):
            out = _call(self.router, "POST", "/upload/grab",
                        body={"url": "https://x/01A.zip"})
        self.assertIn("error", out)
        self.assertIn("already running", out["error"])

    def test_rejects_under_systemd(self):
        with patch("daemon.running_daemon", return_value=None), \
             patch("ingest._systemd_active", return_value=True):
            out = _call(self.router, "POST", "/upload/grab",
                        body={"url": "https://x/01A.zip"})
        self.assertIn("error", out)
        self.assertIn("systemd", out["error"])

    def test_started_launches_background_cli(self):
        proc = MagicMock(returncode=0, stdout="started", stderr="")
        with patch("daemon.running_daemon", return_value=None), \
             patch("ingest._systemd_active", return_value=False), \
             patch("subprocess.run", return_value=proc) as run:
            out = _call(self.router, "POST", "/upload/grab",
                        body={"url": "https://x/01A.zip"})
        self.assertEqual(out["status"], "started")
        self.assertEqual(out["source"], "https://x/01A.zip")
        # Launched the detached, server-restarting background ingest.
        cmd = run.call_args[0][0]
        self.assertIn("--background", cmd)
        self.assertIn("--restart-server", cmd)
        self.assertEqual(cmd[-1], "https://x/01A.zip")
        self.db.audit.record.assert_called_once()

    def test_force_passes_flag(self):
        proc = MagicMock(returncode=0, stdout="", stderr="")
        with patch("daemon.running_daemon", return_value=None), \
             patch("ingest._systemd_active", return_value=False), \
             patch("subprocess.run", return_value=proc) as run:
            out = _call(self.router, "POST", "/upload/grab",
                        body={"url": "https://x/01A.zip", "force": True})
        self.assertTrue(out["force"])
        cmd = run.call_args[0][0]
        self.assertIn("--force", cmd)

    def test_reports_launch_failure(self):
        proc = MagicMock(returncode=1, stdout="", stderr="bad args")
        with patch("daemon.running_daemon", return_value=None), \
             patch("ingest._systemd_active", return_value=False), \
             patch("subprocess.run", return_value=proc):
            out = _call(self.router, "POST", "/upload/grab",
                        body={"url": "https://x/01A.zip"})
        self.assertIn("error", out)
        self.assertIn("bad args", out["detail"])

    def test_default_schedule_uses_12s_grace(self):
        proc = MagicMock(returncode=0, stdout="", stderr="")
        with patch("daemon.running_daemon", return_value=None), \
             patch("ingest._systemd_active", return_value=False), \
             patch("subprocess.run", return_value=proc) as run:
            out = _call(self.router, "POST", "/upload/grab",
                        body={"url": "https://x/01A.zip"})
        cmd = run.call_args[0][0]
        # No user schedule → the hardcoded +12s grace.
        self.assertIn("--schedule", cmd)
        self.assertEqual(cmd[cmd.index("--schedule") + 1], "+12s")
        self.assertEqual(out["schedule"], "now")

    def test_user_schedule_passed_and_echoed(self):
        proc = MagicMock(returncode=0, stdout="", stderr="")
        with patch("daemon.running_daemon", return_value=None), \
             patch("ingest._systemd_active", return_value=False), \
             patch("subprocess.run", return_value=proc) as run:
            out = _call(self.router, "POST", "/upload/grab",
                        body={"url": "https://x/01A.zip", "schedule": "01:00"})
        self.assertEqual(out["status"], "started")
        self.assertEqual(out["schedule"], "01:00")
        cmd = run.call_args[0][0]
        # The user's schedule replaces the +12s grace, and the url stays last.
        self.assertIn("--schedule", cmd)
        self.assertEqual(cmd[cmd.index("--schedule") + 1], "01:00")
        self.assertEqual(cmd[-1], "https://x/01A.zip")

    def test_invalid_schedule_does_not_launch(self):
        with patch("daemon.running_daemon", return_value=None), \
             patch("ingest._systemd_active", return_value=False), \
             patch("subprocess.run") as run:
            out = _call(self.router, "POST", "/upload/grab",
                        body={"url": "https://x/01A.zip", "schedule": "not-a-time"})
        self.assertIn("error", out)
        self.assertIn("invalid schedule", out["error"])
        run.assert_not_called()


# ---------------------------------------------------------------------------
# POST /upload/pdf — lock-guard against a running bulk ingest
# ---------------------------------------------------------------------------

class TestPdfLockGuard(unittest.TestCase):

    def setUp(self):
        self.router, _ = _make_router()

    def test_refused_while_ingest_running(self):
        import ocr as ocr_mod
        with patch.object(ocr_mod, "ocr_available", return_value=True), \
             patch("daemon.running_daemon", return_value={"pid": 99}):
            out = _call(self.router, "POST", "/upload/pdf",
                        query_params=_qp(ein="123456789", year="2023"),
                        body=b"")
        self.assertIn("error", out)
        self.assertIn("bulk ingest", out["error"])


if __name__ == "__main__":
    unittest.main()
