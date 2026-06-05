import sys
import os
import io
import zipfile
import tempfile
import unittest
from unittest.mock import MagicMock

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

from router import Router
from router.Upload import UploadRouter
from tests.fixtures import VALID_990_XML, MISSING_EIN_XML


def _make_upload_body(xml_files: dict[str, str]) -> tuple[bytes, str]:
    """Build a multipart/form-data body containing a ZIP of the given XML files."""
    buf = io.BytesIO()
    with zipfile.ZipFile(buf, 'w') as zf:
        for name, content in xml_files.items():
            zf.writestr(name, content)
    zip_bytes = buf.getvalue()

    boundary = "testboundary1234"
    body = (
        f"--{boundary}\r\n"
        f'Content-Disposition: form-data; name="file"; filename="upload.zip"\r\n'
        f"Content-Type: application/zip\r\n\r\n"
    ).encode() + zip_bytes + f"\r\n--{boundary}--\r\n".encode()

    return body, boundary


def _mock_headers(content_type: str) -> MagicMock:
    headers = MagicMock()
    headers.get.side_effect = lambda key, default="": (
        content_type if key == "Content-Type" else default
    )
    return headers


def _make_router() -> tuple[UploadRouter, MagicMock]:
    db = MagicMock()
    db.get_xpath_index.return_value = {
        "ReturnData/IRS990/ActivityOrMissionDesc": 1001,
    }
    db.create_filing.return_value = "mock-filing-uuid"
    return UploadRouter(db=db), db


class TestRouter(unittest.TestCase):
    def test_get_route_registered(self):
        router = Router(prefix="/test")

        @router.get("/foo")
        def handler(**_):
            return "ok"

        self.assertIn("/test/foo", router.routes["GET"])

    def test_post_route_registered(self):
        router = Router(prefix="/test")

        @router.post("/bar")
        def handler(**_):
            return "ok"

        self.assertIn("/test/bar", router.routes["POST"])

    # --- secure_by_default / per-route secured ---

    def test_default_secure_by_default_is_false(self):
        router = Router(prefix="/test")

        @router.get("/pub")
        def handler(**_): return "ok"

        self.assertFalse(handler._secured)

    def test_secure_by_default_true_stamps_handler(self):
        router = Router(prefix="/test", secure_by_default=True)

        @router.get("/priv")
        def handler(**_): return "ok"

        self.assertTrue(handler._secured)

    def test_per_route_secured_true_overrides_default_false(self):
        router = Router(prefix="/test", secure_by_default=False)

        @router.get("/priv", secured=True)
        def handler(**_): return "ok"

        self.assertTrue(handler._secured)

    def test_per_route_secured_false_overrides_default_true(self):
        router = Router(prefix="/test", secure_by_default=True)

        @router.get("/pub", secured=False)
        def handler(**_): return "ok"

        self.assertFalse(handler._secured)

    def test_secured_none_falls_back_to_secure_by_default_false(self):
        router = Router(prefix="/test", secure_by_default=False)

        @router.get("/x", secured=None)
        def handler(**_): return "ok"

        self.assertFalse(handler._secured)

    def test_secured_none_falls_back_to_secure_by_default_true(self):
        router = Router(prefix="/test", secure_by_default=True)

        @router.get("/x", secured=None)
        def handler(**_): return "ok"

        self.assertTrue(handler._secured)

    def test_post_route_inherits_secure_by_default(self):
        router = Router(prefix="/test", secure_by_default=True)

        @router.post("/data")
        def handler(**_): return "ok"

        self.assertTrue(handler._secured)

    def test_two_routes_different_secured_values(self):
        router = Router(prefix="/test", secure_by_default=True)

        @router.get("/priv")
        def priv(**_): return "ok"

        @router.get("/pub", secured=False)
        def pub(**_): return "ok"

        self.assertTrue(priv._secured)
        self.assertFalse(pub._secured)

    def test_render_template_substitutes_variables(self):
        router = Router(template_dir=tempfile.gettempdir())
        tmp = os.path.join(tempfile.gettempdir(), "_test_template.html")
        with open(tmp, "w") as f:
            f.write("<p>{{greeting}}</p>")
        try:
            result = router.render_template("_test_template.html", greeting="hello")
            self.assertEqual(result, "<p>hello</p>")
        finally:
            os.unlink(tmp)

    def test_render_template_multiple_substitutions(self):
        router = Router(template_dir=tempfile.gettempdir())
        tmp = os.path.join(tempfile.gettempdir(), "_test_template2.html")
        with open(tmp, "w") as f:
            f.write("{{a}} and {{b}}")
        try:
            result = router.render_template("_test_template2.html", a="x", b="y")
            self.assertEqual(result, "x and y")
        finally:
            os.unlink(tmp)


class TestUploadRouterProcessXml(unittest.TestCase):
    def setUp(self):
        self.router, self.db = _make_router()

    def test_valid_xml_returns_stored_status(self):
        result = self.router._process_xml(VALID_990_XML, "test.xml")
        self.assertEqual(result["status"], "stored")

    def test_valid_xml_returns_correct_metadata(self):
        result = self.router._process_xml(VALID_990_XML, "test.xml")
        self.assertEqual(result["ein"], "123456789")
        self.assertEqual(result["year"], "2023")
        self.assertEqual(result["form"], "990")
        self.assertEqual(result["file"], "test.xml")

    def test_valid_xml_returns_filing_id(self):
        result = self.router._process_xml(VALID_990_XML, "test.xml")
        self.assertEqual(result["filing_id"], "mock-filing-uuid")

    def test_valid_xml_reports_fields_stored(self):
        result = self.router._process_xml(VALID_990_XML, "test.xml")
        self.assertEqual(result["fields_stored"], 1)

    def test_valid_xml_calls_upsert_organization(self):
        self.router._process_xml(VALID_990_XML, "test.xml")
        self.db.upsert_organization.assert_called_once_with("123456789", "Test Org")

    def test_valid_xml_calls_create_filing(self):
        self.router._process_xml(VALID_990_XML, "test.xml")
        self.db.create_filing.assert_called_once_with("123456789", 2023, "990")

    def test_valid_xml_calls_store_reported_data(self):
        self.router._process_xml(VALID_990_XML, "test.xml")
        self.db.store_reported_data.assert_called_once_with(
            "mock-filing-uuid", {1001: "Test mission"}
        )

    def test_missing_header_returns_error_status(self):
        result = self.router._process_xml(MISSING_EIN_XML, "bad.xml")
        self.assertEqual(result["status"], "error")

    def test_missing_header_names_missing_fields(self):
        result = self.router._process_xml(MISSING_EIN_XML, "bad.xml")
        self.assertIn("EIN", result["reason"])

    def test_missing_header_does_not_touch_db(self):
        self.router._process_xml(MISSING_EIN_XML, "bad.xml")
        self.db.upsert_organization.assert_not_called()
        self.db.create_filing.assert_not_called()
        self.db.store_reported_data.assert_not_called()

    def test_xpath_with_no_match_not_stored(self):
        router, db = _make_router()
        db.get_xpath_index.return_value = {"ReturnData/IRS990/NoSuchField": 9999}
        router = UploadRouter(db=db)
        result = router._process_xml(VALID_990_XML, "test.xml")
        self.assertEqual(result["fields_stored"], 0)
        db.store_reported_data.assert_called_once_with("mock-filing-uuid", {})


class TestUploadRouterHandleUpload(unittest.TestCase):
    def setUp(self):
        self.router, self.db = _make_router()
        self.handler = self.router.routes["POST"]["/upload"]

    def _call(self, body: bytes, boundary: str) -> dict:
        headers = _mock_headers(f"multipart/form-data; boundary={boundary}")
        return self.handler(query_params={}, body=body, headers=headers)

    def test_valid_zip_with_one_xml_returns_complete(self):
        body, boundary = _make_upload_body({"filing.xml": VALID_990_XML})
        result = self._call(body, boundary)
        self.assertEqual(result["status"], "complete")

    def test_valid_zip_counts_stored_filings(self):
        body, boundary = _make_upload_body({"filing.xml": VALID_990_XML})
        result = self._call(body, boundary)
        self.assertEqual(result["stored"], 1)
        self.assertEqual(result["errors"], 0)

    def test_valid_zip_with_multiple_xmls(self):
        body, boundary = _make_upload_body({
            "filing1.xml": VALID_990_XML,
            "filing2.xml": VALID_990_XML,
        })
        result = self._call(body, boundary)
        self.assertEqual(result["stored"], 2)

    def test_non_xml_files_in_zip_are_skipped(self):
        body, boundary = _make_upload_body({
            "filing.xml": VALID_990_XML,
            "readme.txt": "ignore me",
        })
        result = self._call(body, boundary)
        self.assertEqual(result["stored"], 1)

    def test_zip_with_only_non_xml_returns_zero_stored(self):
        body, boundary = _make_upload_body({"readme.txt": "no xml here"})
        result = self._call(body, boundary)
        self.assertEqual(result["stored"], 0)

    def test_non_multipart_returns_error(self):
        headers = _mock_headers("application/json")
        result = self.handler(query_params={}, body=b"{}", headers=headers)
        self.assertIn("error", result)

    def test_non_bytes_body_returns_error(self):
        headers = _mock_headers("multipart/form-data; boundary=x")
        result = self.handler(query_params={}, body="not bytes", headers=headers)
        self.assertIn("error", result)

    def test_invalid_zip_returns_error(self):
        boundary = "testboundary1234"
        body = (
            f"--{boundary}\r\n"
            f'Content-Disposition: form-data; name="file"; filename="bad.zip"\r\n'
            f"Content-Type: application/zip\r\n\r\n"
            "this is not a zip"
            f"\r\n--{boundary}--\r\n"
        ).encode()
        result = self._call(body, boundary)
        self.assertIn("error", result)

    def test_no_zip_in_multipart_returns_error(self):
        boundary = "testboundary1234"
        body = (
            f"--{boundary}\r\n"
            f'Content-Disposition: form-data; name="field"\r\n\r\n'
            "just a text field"
            f"\r\n--{boundary}--\r\n"
        ).encode()
        result = self._call(body, boundary)
        self.assertIn("error", result)


if __name__ == "__main__":
    unittest.main()
