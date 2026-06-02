import os
import sys
import sqlite3
import unittest
from unittest.mock import MagicMock, call

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

from router.IRS990 import IRS990Router


ORG_ALPHA = {"ein": "111111111", "name": "Alpha Org", "created_at": "2024-01-01", "updated_at": "2024-01-01"}
ORG_BETA  = {"ein": "222222222", "name": "Beta Org",  "created_at": "2024-01-02", "updated_at": "2024-01-02"}

FILING_ONE = {
    "filing_id": "uuid-abc-123", "year": 2023, "ein": "111111111",
    "form_code": "990", "created_at": "2024-01-01", "object_id": None, "xml_source_url": None,
}

REPORTED_ROW = {"xml_path": "ReturnData/IRS990/ActivityOrMissionDesc", "raw_value": "Test", "field_id": 42}


def _make_router():
    db = MagicMock()
    db.list_organizations.return_value = []
    db.get_organization.return_value = None
    db.list_filings.return_value = []
    db.get_filing.return_value = None
    db.create_filing.return_value = "uuid-abc-123"
    db.get_reported_data.return_value = []
    return IRS990Router(db=db), db


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

class TestIRS990RouterRegistration(unittest.TestCase):

    def setUp(self):
        self.router, _ = _make_router()

    def test_get_organizations_registered(self):
        self.assertIn("/irs990/organizations", self.router.routes["GET"])

    def test_get_organizations_detail_registered(self):
        self.assertIn("/irs990/organizations/detail", self.router.routes["GET"])

    def test_post_organizations_registered(self):
        self.assertIn("/irs990/organizations", self.router.routes["POST"])

    def test_get_filings_registered(self):
        self.assertIn("/irs990/filings", self.router.routes["GET"])

    def test_get_filings_detail_registered(self):
        self.assertIn("/irs990/filings/detail", self.router.routes["GET"])

    def test_post_filings_registered(self):
        self.assertIn("/irs990/filings", self.router.routes["POST"])

    def test_get_filings_data_registered(self):
        self.assertIn("/irs990/filings/data", self.router.routes["GET"])

    def test_post_filings_data_registered(self):
        self.assertIn("/irs990/filings/data", self.router.routes["POST"])

    def test_custom_prefix_applied(self):
        router, _ = _make_router()
        router2 = IRS990Router(prefix='/api/irs990', db=MagicMock())
        self.assertIn("/api/irs990/organizations", router2.routes["GET"])

    def test_no_unexpected_get_routes(self):
        expected = {
            "/irs990/organizations",
            "/irs990/organizations/detail",
            "/irs990/filings",
            "/irs990/filings/detail",
            "/irs990/filings/data",
        }
        self.assertEqual(set(self.router.routes["GET"].keys()), expected)

    def test_no_unexpected_post_routes(self):
        expected = {
            "/irs990/organizations",
            "/irs990/filings",
            "/irs990/filings/data",
        }
        self.assertEqual(set(self.router.routes["POST"].keys()), expected)


# ---------------------------------------------------------------------------
# GET /irs990/organizations
# ---------------------------------------------------------------------------

class TestListOrganizations(unittest.TestCase):

    def setUp(self):
        self.router, self.db = _make_router()

    def _call(self, **qp):
        return _call(self.router, "GET", "/irs990/organizations", _qp(**qp) if qp else {})

    def test_returns_dict(self):
        result = self._call()
        self.assertIsInstance(result, dict)

    def test_returns_organizations_key(self):
        result = self._call()
        self.assertIn("organizations", result)

    def test_organizations_is_list(self):
        result = self._call()
        self.assertIsInstance(result["organizations"], list)

    def test_calls_list_organizations(self):
        self._call()
        self.db.list_organizations.assert_called_once_with()

    def test_empty_list_when_no_orgs(self):
        result = self._call()
        self.assertEqual(result["organizations"], [])

    def test_returns_orgs_from_db(self):
        self.db.list_organizations.return_value = [ORG_ALPHA, ORG_BETA]
        result = self._call()
        self.assertEqual(result["organizations"], [ORG_ALPHA, ORG_BETA])

    def test_count_matches_db(self):
        self.db.list_organizations.return_value = [ORG_ALPHA, ORG_BETA]
        result = self._call()
        self.assertEqual(len(result["organizations"]), 2)


# ---------------------------------------------------------------------------
# GET /irs990/organizations/detail
# ---------------------------------------------------------------------------

class TestGetOrganization(unittest.TestCase):

    def setUp(self):
        self.router, self.db = _make_router()

    def _call(self, **qp):
        return _call(self.router, "GET", "/irs990/organizations/detail", _qp(**qp) if qp else {})

    def test_missing_ein_returns_error(self):
        result = self._call()
        self.assertIn("error", result)

    def test_missing_ein_error_mentions_param(self):
        result = self._call()
        self.assertIn("ein", result["error"])

    def test_not_found_returns_error(self):
        self.db.get_organization.return_value = None
        result = self._call(ein="999999999")
        self.assertIn("error", result)

    def test_not_found_error_contains_ein(self):
        result = self._call(ein="999999999")
        self.assertIn("999999999", result["error"])

    def test_found_returns_org_dict(self):
        self.db.get_organization.return_value = ORG_ALPHA
        result = self._call(ein="111111111")
        self.assertEqual(result, ORG_ALPHA)

    def test_calls_get_organization_with_ein(self):
        self._call(ein="111111111")
        self.db.get_organization.assert_called_once_with("111111111")

    def test_found_has_ein_field(self):
        self.db.get_organization.return_value = ORG_ALPHA
        result = self._call(ein="111111111")
        self.assertEqual(result["ein"], "111111111")

    def test_found_has_name_field(self):
        self.db.get_organization.return_value = ORG_ALPHA
        result = self._call(ein="111111111")
        self.assertEqual(result["name"], "Alpha Org")


# ---------------------------------------------------------------------------
# POST /irs990/organizations
# ---------------------------------------------------------------------------

class TestUpsertOrganization(unittest.TestCase):

    def setUp(self):
        self.router, self.db = _make_router()
        self.db.get_organization.return_value = ORG_ALPHA

    def _call(self, body=None):
        return _call(self.router, "POST", "/irs990/organizations", body=body)

    def test_valid_body_calls_upsert(self):
        self._call({"ein": "111111111", "name": "Alpha Org"})
        self.db.upsert_organization.assert_called_once_with("111111111", "Alpha Org")

    def test_valid_body_returns_org(self):
        result = self._call({"ein": "111111111", "name": "Alpha Org"})
        self.assertEqual(result, ORG_ALPHA)

    def test_calls_get_organization_after_upsert(self):
        self._call({"ein": "111111111", "name": "Alpha Org"})
        self.db.get_organization.assert_called_once_with("111111111")

    def test_missing_ein_returns_error(self):
        result = self._call({"name": "Alpha Org"})
        self.assertIn("error", result)

    def test_missing_ein_error_names_field(self):
        result = self._call({"name": "Alpha Org"})
        self.assertIn("ein", result["error"])

    def test_missing_name_returns_error(self):
        result = self._call({"ein": "111111111"})
        self.assertIn("error", result)

    def test_missing_name_error_names_field(self):
        result = self._call({"ein": "111111111"})
        self.assertIn("name", result["error"])

    def test_string_body_returns_error(self):
        result = self._call("not a dict")
        self.assertIn("error", result)

    def test_none_body_returns_error(self):
        result = self._call(None)
        self.assertIn("error", result)

    def test_list_body_returns_error(self):
        result = self._call([{"ein": "111111111"}])
        self.assertIn("error", result)

    def test_integrity_error_returns_error(self):
        self.db.upsert_organization.side_effect = sqlite3.IntegrityError("constraint")
        result = self._call({"ein": "111111111", "name": "Alpha Org"})
        self.assertIn("error", result)

    def test_integrity_error_does_not_raise(self):
        self.db.upsert_organization.side_effect = sqlite3.IntegrityError("constraint")
        self._call({"ein": "111111111", "name": "Alpha Org"})  # must not raise


# ---------------------------------------------------------------------------
# GET /irs990/filings
# ---------------------------------------------------------------------------

class TestListFilings(unittest.TestCase):

    def setUp(self):
        self.router, self.db = _make_router()

    def _call(self, **qp):
        return _call(self.router, "GET", "/irs990/filings", _qp(**qp) if qp else {})

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
        self.db.list_filings.assert_called_once_with("111111111")

    def test_empty_list_when_no_filings(self):
        result = self._call(ein="111111111")
        self.assertEqual(result["filings"], [])

    def test_returns_filings_from_db(self):
        self.db.list_filings.return_value = [FILING_ONE]
        result = self._call(ein="111111111")
        self.assertEqual(result["filings"], [FILING_ONE])

    def test_count_matches_db(self):
        self.db.list_filings.return_value = [FILING_ONE, FILING_ONE]
        result = self._call(ein="111111111")
        self.assertEqual(len(result["filings"]), 2)


# ---------------------------------------------------------------------------
# GET /irs990/filings/detail
# ---------------------------------------------------------------------------

class TestGetFiling(unittest.TestCase):

    def setUp(self):
        self.router, self.db = _make_router()

    def _call(self, **qp):
        return _call(self.router, "GET", "/irs990/filings/detail", _qp(**qp) if qp else {})

    def test_missing_filing_id_returns_error(self):
        result = self._call()
        self.assertIn("error", result)

    def test_missing_filing_id_error_mentions_param(self):
        result = self._call()
        self.assertIn("filing_id", result["error"])

    def test_not_found_returns_error(self):
        self.db.get_filing.return_value = None
        result = self._call(filing_id="no-such-uuid")
        self.assertIn("error", result)

    def test_not_found_error_contains_id(self):
        result = self._call(filing_id="no-such-uuid")
        self.assertIn("no-such-uuid", result["error"])

    def test_found_returns_filing_dict(self):
        self.db.get_filing.return_value = FILING_ONE
        result = self._call(filing_id="uuid-abc-123")
        self.assertEqual(result, FILING_ONE)

    def test_calls_get_filing_with_id(self):
        self._call(filing_id="uuid-abc-123")
        self.db.get_filing.assert_called_once_with("uuid-abc-123")

    def test_found_has_filing_id_field(self):
        self.db.get_filing.return_value = FILING_ONE
        result = self._call(filing_id="uuid-abc-123")
        self.assertEqual(result["filing_id"], "uuid-abc-123")

    def test_found_has_year_field(self):
        self.db.get_filing.return_value = FILING_ONE
        result = self._call(filing_id="uuid-abc-123")
        self.assertEqual(result["year"], 2023)

    def test_found_has_form_code_field(self):
        self.db.get_filing.return_value = FILING_ONE
        result = self._call(filing_id="uuid-abc-123")
        self.assertEqual(result["form_code"], "990")


# ---------------------------------------------------------------------------
# POST /irs990/filings
# ---------------------------------------------------------------------------

class TestCreateFiling(unittest.TestCase):

    def setUp(self):
        self.router, self.db = _make_router()

    def _call(self, body=None):
        return _call(self.router, "POST", "/irs990/filings", body=body)

    def test_valid_body_returns_filing_id(self):
        result = self._call({"ein": "111111111", "year": 2023, "form_code": "990"})
        self.assertIn("filing_id", result)

    def test_filing_id_matches_db_return(self):
        result = self._call({"ein": "111111111", "year": 2023, "form_code": "990"})
        self.assertEqual(result["filing_id"], "uuid-abc-123")

    def test_calls_create_filing_with_int_year(self):
        self._call({"ein": "111111111", "year": 2023, "form_code": "990"})
        self.db.create_filing.assert_called_once_with("111111111", 2023, "990")

    def test_year_as_string_is_cast_to_int(self):
        self._call({"ein": "111111111", "year": "2022", "form_code": "990"})
        self.db.create_filing.assert_called_once_with("111111111", 2022, "990")

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
        self.db.create_filing.side_effect = sqlite3.IntegrityError("fk constraint")
        result = self._call({"ein": "111111111", "year": 2023, "form_code": "990"})
        self.assertIn("error", result)

    def test_integrity_error_does_not_raise(self):
        self.db.create_filing.side_effect = sqlite3.IntegrityError("fk constraint")
        self._call({"ein": "111111111", "year": 2023, "form_code": "990"})  # must not raise

    def test_value_error_on_bad_year_returns_error(self):
        result = self._call({"ein": "111111111", "year": "not-a-year", "form_code": "990"})
        self.assertIn("error", result)


# ---------------------------------------------------------------------------
# GET /irs990/filings/data
# ---------------------------------------------------------------------------

class TestGetReportedData(unittest.TestCase):

    def setUp(self):
        self.router, self.db = _make_router()

    def _call(self, **qp):
        return _call(self.router, "GET", "/irs990/filings/data", _qp(**qp) if qp else {})

    def test_missing_filing_id_returns_error(self):
        result = self._call()
        self.assertIn("error", result)

    def test_missing_filing_id_error_mentions_param(self):
        result = self._call()
        self.assertIn("filing_id", result["error"])

    def test_returns_filing_id_key(self):
        result = self._call(filing_id="uuid-abc-123")
        self.assertIn("filing_id", result)

    def test_filing_id_echoed_in_response(self):
        result = self._call(filing_id="uuid-abc-123")
        self.assertEqual(result["filing_id"], "uuid-abc-123")

    def test_returns_data_key(self):
        result = self._call(filing_id="uuid-abc-123")
        self.assertIn("data", result)

    def test_data_is_list(self):
        result = self._call(filing_id="uuid-abc-123")
        self.assertIsInstance(result["data"], list)

    def test_calls_get_reported_data_with_id(self):
        self._call(filing_id="uuid-abc-123")
        self.db.get_reported_data.assert_called_once_with("uuid-abc-123")

    def test_empty_data_when_no_fields(self):
        result = self._call(filing_id="uuid-abc-123")
        self.assertEqual(result["data"], [])

    def test_returns_data_from_db(self):
        self.db.get_reported_data.return_value = [REPORTED_ROW]
        result = self._call(filing_id="uuid-abc-123")
        self.assertEqual(result["data"], [REPORTED_ROW])

    def test_data_count_matches_db(self):
        self.db.get_reported_data.return_value = [REPORTED_ROW, REPORTED_ROW]
        result = self._call(filing_id="uuid-abc-123")
        self.assertEqual(len(result["data"]), 2)


# ---------------------------------------------------------------------------
# POST /irs990/filings/data
# ---------------------------------------------------------------------------

class TestStoreReportedData(unittest.TestCase):

    def setUp(self):
        self.router, self.db = _make_router()

    def _call(self, body=None):
        return _call(self.router, "POST", "/irs990/filings/data", body=body)

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
        self.db.store_reported_data.assert_called_once_with("uuid-abc-123", {42: "hello"})

    def test_calls_store_reported_data(self):
        self._call({"filing_id": "uuid-abc-123", "values": {"1": "v"}})
        self.db.store_reported_data.assert_called_once()

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
        self.db.store_reported_data.side_effect = sqlite3.IntegrityError("constraint")
        result = self._call({"filing_id": "uuid-abc-123", "values": {"1": "v"}})
        self.assertIn("error", result)

    def test_value_error_on_non_int_key_returns_error(self):
        result = self._call({"filing_id": "uuid-abc-123", "values": {"not-an-int": "v"}})
        self.assertIn("error", result)


if __name__ == "__main__":
    unittest.main()
