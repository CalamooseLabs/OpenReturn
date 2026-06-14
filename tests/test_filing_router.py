import os
import sys
import sqlite3
import unittest
from unittest.mock import MagicMock

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

from router.Filing import FilingRouter


FILING_ONE = {
    "filing_id": "uuid-abc-123", "year": 2023, "ein": "111111111",
    "form_code": "990", "created_at": "2024-01-01", "object_id": None, "xml_source_url": None,
}

FILING_ONE_FULL = {
    **FILING_ONE,
    "xml_filename": "filing.xml",
    "zip_filename": "2023.zip",
}

FILING_DATA = {
    "filing_id": "uuid-abc-123", "ein": "111111111", "year": 2023,
    "form_code": "990", "xml_filename": "filing.xml", "zip_filename": "2023.zip",
    "fields": [],
}

REPORTED_ROW = {"xml_path": "ReturnData/IRS990/ActivityOrMissionDesc", "raw_value": "Test", "field_id": 42}


def _make_router():
    db = MagicMock()
    db.filings.list_filings.return_value = []
    db.filings.get_filing.return_value = None
    db.filings.create_filing.return_value = "uuid-abc-123"
    db.reported_data.get_reported_data.return_value = []
    db.filings.get_filing_data_by_ein_year.return_value = None
    return FilingRouter(db=db), db


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
# Route registration
# ---------------------------------------------------------------------------

class TestFilingRouterRegistration(unittest.TestCase):

    def setUp(self):
        self.router, _ = _make_router()

    def test_get_filings_registered(self):
        self.assertIn("/filings", self.router.routes["GET"])

    def test_get_filings_detail_registered(self):
        self.assertIn("/filings/detail", self.router.routes["GET"])

    def test_get_filings_data_registered(self):
        self.assertIn("/filings/data", self.router.routes["GET"])

    def test_get_filings_lookup_registered(self):
        self.assertIn("/filings/lookup", self.router.routes["GET"])

    def test_post_filings_registered(self):
        self.assertIn("/filings", self.router.routes["POST"])

    def test_post_filings_data_registered(self):
        self.assertIn("/filings/data", self.router.routes["POST"])

    def test_custom_prefix_applied(self):
        router2 = FilingRouter(prefix='/api/filings', db=MagicMock())
        self.assertIn("/api/filings", router2.routes["GET"])

    def test_no_unexpected_get_routes(self):
        expected = {
            "/filings",
            "/filings/detail",
            "/filings/data",
            "/filings/lookup",
        }
        self.assertEqual(set(self.router.routes["GET"].keys()), expected)

    def test_no_unexpected_post_routes(self):
        expected = {"/filings", "/filings/data"}
        self.assertEqual(set(self.router.routes["POST"].keys()), expected)


# ---------------------------------------------------------------------------
# GET /filings
# ---------------------------------------------------------------------------

class TestListFilings(unittest.TestCase):

    def setUp(self):
        self.router, self.db = _make_router()

    def _call(self, **qp):
        return _call(self.router, "GET", "/filings", _qp(**qp) if qp else {})

    def test_missing_ein_returns_error(self):
        result = self._call()
        self.assertIn("error", result)

    def test_missing_ein_error_mentions_param(self):
        result = self._call()
        self.assertIn("ein", result["error"])

    def test_returns_filings_key(self):
        result = self._call(ein="111111111")
        self.assertIn("filings", result)

    def test_filings_is_list(self):
        result = self._call(ein="111111111")
        self.assertIsInstance(result["filings"], list)

    def test_calls_list_filings_with_ein(self):
        self._call(ein="111111111")
        self.db.filings.list_filings.assert_called_once_with("111111111")

    def test_empty_list_when_no_filings(self):
        result = self._call(ein="111111111")
        self.assertEqual(result["filings"], [])

    def test_returns_filings_from_db(self):
        self.db.filings.list_filings.return_value = [FILING_ONE]
        result = self._call(ein="111111111")
        self.assertEqual(result["filings"], [FILING_ONE])

    def test_count_matches_db(self):
        self.db.filings.list_filings.return_value = [FILING_ONE, FILING_ONE]
        result = self._call(ein="111111111")
        self.assertEqual(len(result["filings"]), 2)


# ---------------------------------------------------------------------------
# GET /filings/detail
# ---------------------------------------------------------------------------

class TestGetFiling(unittest.TestCase):

    def setUp(self):
        self.router, self.db = _make_router()

    def _call(self, **qp):
        return _call(self.router, "GET", "/filings/detail", _qp(**qp) if qp else {})

    def test_missing_filing_id_returns_error(self):
        result = self._call()
        self.assertIn("error", result)

    def test_missing_filing_id_error_mentions_param(self):
        result = self._call()
        self.assertIn("filing_id", result["error"])

    def test_not_found_returns_error(self):
        self.db.filings.get_filing.return_value = None
        result = self._call(filing_id="no-such-uuid")
        self.assertIn("error", result)

    def test_not_found_error_contains_id(self):
        result = self._call(filing_id="no-such-uuid")
        self.assertIn("no-such-uuid", result["error"])

    def test_found_returns_filing_dict(self):
        self.db.filings.get_filing.return_value = FILING_ONE
        result = self._call(filing_id="uuid-abc-123")
        self.assertEqual(result, FILING_ONE)

    def test_calls_get_filing_with_id(self):
        self._call(filing_id="uuid-abc-123")
        self.db.filings.get_filing.assert_called_once_with("uuid-abc-123")

    def test_found_has_filing_id_field(self):
        self.db.filings.get_filing.return_value = FILING_ONE
        result = self._call(filing_id="uuid-abc-123")
        self.assertEqual(result["filing_id"], "uuid-abc-123")

    def test_found_has_year_field(self):
        self.db.filings.get_filing.return_value = FILING_ONE
        result = self._call(filing_id="uuid-abc-123")
        self.assertEqual(result["year"], 2023)

    def test_found_has_form_code_field(self):
        self.db.filings.get_filing.return_value = FILING_ONE
        result = self._call(filing_id="uuid-abc-123")
        self.assertEqual(result["form_code"], "990")


# ---------------------------------------------------------------------------
# POST /filings
# ---------------------------------------------------------------------------

class TestCreateFiling(unittest.TestCase):

    def setUp(self):
        self.router, self.db = _make_router()

    def _call(self, body=None):
        return _call(self.router, "POST", "/filings", body=body)

    def test_valid_body_returns_filing_id(self):
        result = self._call({"ein": "111111111", "year": 2023, "form_code": "990"})
        self.assertIn("filing_id", result)

    def test_filing_id_matches_db_return(self):
        result = self._call({"ein": "111111111", "year": 2023, "form_code": "990"})
        self.assertEqual(result["filing_id"], "uuid-abc-123")

    def test_calls_create_filing_with_int_year(self):
        self._call({"ein": "111111111", "year": 2023, "form_code": "990"})
        self.db.filings.create_filing.assert_called_once_with("111111111", 2023, "990")

    def test_year_as_string_is_cast_to_int(self):
        self._call({"ein": "111111111", "year": "2022", "form_code": "990"})
        self.db.filings.create_filing.assert_called_once_with("111111111", 2022, "990")

    def test_missing_ein_returns_error(self):
        result = self._call({"year": 2023, "form_code": "990"})
        self.assertIn("error", result)

    def test_missing_year_returns_error(self):
        result = self._call({"ein": "111111111", "form_code": "990"})
        self.assertIn("error", result)

    def test_missing_form_code_returns_error(self):
        result = self._call({"ein": "111111111", "year": 2023})
        self.assertIn("error", result)

    def test_missing_all_fields_error_lists_them(self):
        result = self._call({})
        self.assertIn("error", result)
        self.assertIn("ein", result["error"])

    def test_string_body_returns_error(self):
        result = self._call("bad body")
        self.assertIn("error", result)

    def test_none_body_returns_error(self):
        result = self._call(None)
        self.assertIn("error", result)

    def test_integrity_error_returns_error(self):
        self.db.filings.create_filing.side_effect = sqlite3.IntegrityError("fk constraint")
        result = self._call({"ein": "111111111", "year": 2023, "form_code": "990"})
        self.assertIn("error", result)

    def test_integrity_error_does_not_raise(self):
        self.db.filings.create_filing.side_effect = sqlite3.IntegrityError("fk constraint")
        self._call({"ein": "111111111", "year": 2023, "form_code": "990"})  # must not raise

    def test_value_error_on_bad_year_returns_error(self):
        result = self._call({"ein": "111111111", "year": "not-a-year", "form_code": "990"})
        self.assertIn("error", result)

    def test_successful_create_commits(self):
        # Durability: create_filing does not commit itself, so the handler must.
        self._call({"ein": "111111111", "year": 2023, "form_code": "990"})
        self.db.commit.assert_called_once()

    def test_integrity_error_does_not_commit(self):
        self.db.filings.create_filing.side_effect = sqlite3.IntegrityError("fk constraint")
        self._call({"ein": "111111111", "year": 2023, "form_code": "990"})
        self.db.commit.assert_not_called()


# ---------------------------------------------------------------------------
# GET /filings/data
# ---------------------------------------------------------------------------

class TestGetReportedData(unittest.TestCase):

    def setUp(self):
        self.router, self.db = _make_router()
        self.db.filings.get_filing.return_value = FILING_ONE_FULL

    def _call(self, **qp):
        return _call(self.router, "GET", "/filings/data", _qp(**qp) if qp else {})

    def test_missing_filing_id_returns_error(self):
        result = self._call()
        self.assertIn("error", result)

    def test_missing_filing_id_error_mentions_param(self):
        result = self._call()
        self.assertIn("filing_id", result["error"])

    def test_not_found_returns_error(self):
        self.db.filings.get_filing.return_value = None
        result = self._call(filing_id="no-such-uuid")
        self.assertIn("error", result)

    def test_not_found_error_contains_id(self):
        self.db.filings.get_filing.return_value = None
        result = self._call(filing_id="no-such-uuid")
        self.assertIn("no-such-uuid", result["error"])

    def test_returns_filing_id_key(self):
        result = self._call(filing_id="uuid-abc-123")
        self.assertIn("filing_id", result)

    def test_filing_id_echoed_in_response(self):
        result = self._call(filing_id="uuid-abc-123")
        self.assertEqual(result["filing_id"], "uuid-abc-123")

    def test_returns_fields_key(self):
        result = self._call(filing_id="uuid-abc-123")
        self.assertIn("fields", result)

    def test_fields_is_list(self):
        result = self._call(filing_id="uuid-abc-123")
        self.assertIsInstance(result["fields"], list)

    def test_calls_get_reported_data_with_id(self):
        self._call(filing_id="uuid-abc-123")
        self.db.reported_data.get_reported_data.assert_called_once_with("uuid-abc-123")

    def test_empty_fields_when_no_data(self):
        result = self._call(filing_id="uuid-abc-123")
        self.assertEqual(result["fields"], [])

    def test_returns_fields_from_db(self):
        self.db.reported_data.get_reported_data.return_value = [REPORTED_ROW]
        result = self._call(filing_id="uuid-abc-123")
        self.assertEqual(result["fields"], [REPORTED_ROW])

    def test_fields_count_matches_db(self):
        self.db.reported_data.get_reported_data.return_value = [REPORTED_ROW, REPORTED_ROW]
        result = self._call(filing_id="uuid-abc-123")
        self.assertEqual(len(result["fields"]), 2)


# ---------------------------------------------------------------------------
# POST /filings/data
# ---------------------------------------------------------------------------

class TestStoreReportedData(unittest.TestCase):

    def setUp(self):
        self.router, self.db = _make_router()

    def _call(self, body=None):
        return _call(self.router, "POST", "/filings/data", body=body)

    def test_valid_body_returns_filing_id(self):
        result = self._call({"filing_id": "uuid-abc-123", "values": {"1": "foo", "2": "bar"}})
        self.assertIn("filing_id", result)

    def test_filing_id_echoed_in_response(self):
        result = self._call({"filing_id": "uuid-abc-123", "values": {"1": "foo"}})
        self.assertEqual(result["filing_id"], "uuid-abc-123")

    def test_returns_fields_stored_count(self):
        result = self._call({"filing_id": "uuid-abc-123", "values": {"1": "foo", "2": "bar"}})
        self.assertEqual(result["fields_stored"], 2)

    def test_string_keys_cast_to_int(self):
        self._call({"filing_id": "uuid-abc-123", "values": {"42": "hello"}})
        self.db.reported_data.store_reported_data.assert_called_once_with("uuid-abc-123", {42: "hello"})

    def test_calls_store_reported_data(self):
        self._call({"filing_id": "uuid-abc-123", "values": {"1": "v"}})
        self.db.reported_data.store_reported_data.assert_called_once()

    def test_empty_values_stores_nothing(self):
        result = self._call({"filing_id": "uuid-abc-123", "values": {}})
        self.assertEqual(result["fields_stored"], 0)

    def test_missing_filing_id_returns_error(self):
        result = self._call({"values": {"1": "v"}})
        self.assertIn("error", result)

    def test_missing_values_returns_error(self):
        result = self._call({"filing_id": "uuid-abc-123"})
        self.assertIn("error", result)

    def test_values_as_list_returns_error(self):
        result = self._call({"filing_id": "uuid-abc-123", "values": [1, 2, 3]})
        self.assertIn("error", result)

    def test_string_body_returns_error(self):
        result = self._call("not json")
        self.assertIn("error", result)

    def test_none_body_returns_error(self):
        result = self._call(None)
        self.assertIn("error", result)

    def test_integrity_error_returns_error(self):
        self.db.reported_data.store_reported_data.side_effect = sqlite3.IntegrityError("constraint")
        result = self._call({"filing_id": "uuid-abc-123", "values": {"1": "v"}})
        self.assertIn("error", result)

    def test_value_error_on_non_int_key_returns_error(self):
        result = self._call({"filing_id": "uuid-abc-123", "values": {"not-an-int": "v"}})
        self.assertIn("error", result)

    def test_successful_store_commits(self):
        # Durability: store_reported_data does not commit itself, so the handler must.
        self._call({"filing_id": "uuid-abc-123", "values": {"1": "v"}})
        self.db.commit.assert_called_once()

    def test_integrity_error_does_not_commit(self):
        self.db.reported_data.store_reported_data.side_effect = sqlite3.IntegrityError("constraint")
        self._call({"filing_id": "uuid-abc-123", "values": {"1": "v"}})
        self.db.commit.assert_not_called()


# ---------------------------------------------------------------------------
# GET /filings/lookup
# ---------------------------------------------------------------------------

class TestLookupFilingByEinYear(unittest.TestCase):

    def setUp(self):
        self.router, self.db = _make_router()

    def _call(self, **qp):
        return _call(self.router, "GET", "/filings/lookup", _qp(**qp) if qp else {})

    def test_missing_ein_returns_error(self):
        result = self._call(year="2023")
        self.assertIn("error", result)

    def test_missing_year_returns_error(self):
        result = self._call(ein="111111111")
        self.assertIn("error", result)

    def test_missing_both_returns_error(self):
        result = self._call()
        self.assertIn("error", result)

    def test_missing_ein_error_mentions_param(self):
        result = self._call(year="2023")
        self.assertIn("ein", result["error"])

    def test_non_integer_year_returns_error(self):
        result = self._call(ein="111111111", year="not-a-year")
        self.assertIn("error", result)

    def test_non_integer_year_error_mentions_year(self):
        result = self._call(ein="111111111", year="not-a-year")
        self.assertIn("year", result["error"])

    def test_not_found_returns_error(self):
        result = self._call(ein="111111111", year="2023")
        self.assertIn("error", result)

    def test_not_found_error_contains_ein(self):
        result = self._call(ein="111111111", year="2023")
        self.assertIn("111111111", result["error"])

    def test_not_found_error_contains_year(self):
        result = self._call(ein="111111111", year="2023")
        self.assertIn("2023", result["error"])

    def test_calls_db_with_ein_and_int_year(self):
        self._call(ein="111111111", year="2023")
        self.db.filings.get_filing_data_by_ein_year.assert_called_once_with("111111111", 2023)

    def test_found_returns_db_result(self):
        self.db.filings.get_filing_data_by_ein_year.return_value = FILING_DATA
        result = self._call(ein="111111111", year="2023")
        self.assertEqual(result, FILING_DATA)

    def test_found_result_is_dict(self):
        self.db.filings.get_filing_data_by_ein_year.return_value = FILING_DATA
        result = self._call(ein="111111111", year="2023")
        self.assertIsInstance(result, dict)

    def test_format_md_returns_string(self):
        self.db.filings.get_filing_data_by_ein_year.return_value = FILING_DATA
        result = self._call(ein="111111111", year="2023", format="md")
        self.assertIsInstance(result, str)

    def test_format_html_returns_string(self):
        self.db.filings.get_filing_data_by_ein_year.return_value = FILING_DATA
        result = self._call(ein="111111111", year="2023", format="html")
        self.assertIsInstance(result, str)

    def test_format_xml_returns_tuple(self):
        self.db.filings.get_filing_data_by_ein_year.return_value = FILING_DATA
        result = self._call(ein="111111111", year="2023", format="xml")
        self.assertIsInstance(result, tuple)

    def test_format_xml_content_type(self):
        self.db.filings.get_filing_data_by_ein_year.return_value = FILING_DATA
        _, content_type = self._call(ein="111111111", year="2023", format="xml")
        self.assertEqual(content_type, 'application/xml')

    def test_format_case_insensitive(self):
        self.db.filings.get_filing_data_by_ein_year.return_value = FILING_DATA
        result_lower = self._call(ein="111111111", year="2023", format="xml")
        result_upper = self._call(ein="111111111", year="2023", format="XML")
        self.assertIsInstance(result_lower, tuple)
        self.assertIsInstance(result_upper, tuple)


# ---------------------------------------------------------------------------
# GET /filings/data — format parameter
# ---------------------------------------------------------------------------

class TestGetReportedDataFormat(unittest.TestCase):

    def setUp(self):
        self.router, self.db = _make_router()
        self.db.filings.get_filing.return_value = FILING_ONE_FULL

    def _call(self, **qp):
        return _call(self.router, "GET", "/filings/data", _qp(**qp) if qp else {})

    def test_default_format_returns_dict(self):
        result = self._call(filing_id="uuid-abc-123")
        self.assertIsInstance(result, dict)

    def test_format_json_returns_dict(self):
        result = self._call(filing_id="uuid-abc-123", format="json")
        self.assertIsInstance(result, dict)

    def test_format_md_returns_string(self):
        result = self._call(filing_id="uuid-abc-123", format="md")
        self.assertIsInstance(result, str)

    def test_format_html_returns_string(self):
        result = self._call(filing_id="uuid-abc-123", format="html")
        self.assertIsInstance(result, str)

    def test_format_xml_returns_tuple(self):
        result = self._call(filing_id="uuid-abc-123", format="xml")
        self.assertIsInstance(result, tuple)

    def test_format_xml_content_type(self):
        _, content_type = self._call(filing_id="uuid-abc-123", format="xml")
        self.assertEqual(content_type, 'application/xml')

    def test_format_xml_body_is_string(self):
        body, _ = self._call(filing_id="uuid-abc-123", format="xml")
        self.assertIsInstance(body, str)

    def test_format_case_insensitive_xml(self):
        result = self._call(filing_id="uuid-abc-123", format="XML")
        self.assertIsInstance(result, tuple)

    def test_format_case_insensitive_md(self):
        result = self._call(filing_id="uuid-abc-123", format="MD")
        self.assertIsInstance(result, str)

    def test_unknown_format_falls_back_to_dict(self):
        result = self._call(filing_id="uuid-abc-123", format="csv")
        self.assertIsInstance(result, dict)


if __name__ == "__main__":
    unittest.main()
