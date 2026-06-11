import os
import sys
import sqlite3
import unittest
from unittest.mock import MagicMock

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

from router.Org import OrgRouter


ORG_ALPHA = {"ein": "111111111", "name": "Alpha Org", "is_favorite": False, "created_at": "2024-01-01", "updated_at": "2024-01-01"}
ORG_BETA  = {"ein": "222222222", "name": "Beta Org",  "is_favorite": False, "created_at": "2024-01-02", "updated_at": "2024-01-02"}

FILING_ONE = {
    "filing_id": "uuid-abc-123", "year": 2023, "ein": "111111111",
    "form_code": "990", "created_at": "2024-01-01", "object_id": None, "xml_source_url": None,
}


def _make_router():
    db = MagicMock()
    db.list_organizations.return_value = {"total": 0, "limit": 50, "offset": 0, "organizations": []}
    db.get_organization.return_value = None
    db.list_filings.return_value = []
    return OrgRouter(db=db), db


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

class TestOrgRouterRegistration(unittest.TestCase):

    def setUp(self):
        self.router, _ = _make_router()

    def test_get_organizations_registered(self):
        self.assertIn("/organizations", self.router.routes["GET"])

    def test_get_organizations_detail_registered(self):
        self.assertIn("/organizations/detail", self.router.routes["GET"])

    def test_get_organizations_full_registered(self):
        self.assertIn("/organizations/full", self.router.routes["GET"])

    def test_post_organizations_registered(self):
        self.assertIn("/organizations", self.router.routes["POST"])

    def test_post_organizations_favorite_registered(self):
        self.assertIn("/organizations/favorite", self.router.routes["POST"])

    def test_custom_prefix_applied(self):
        router2 = OrgRouter(prefix='/api/orgs', db=MagicMock())
        self.assertIn("/api/orgs", router2.routes["GET"])

    def test_no_unexpected_get_routes(self):
        expected = {
            "/organizations",
            "/organizations/detail",
            "/organizations/full",
        }
        self.assertEqual(set(self.router.routes["GET"].keys()), expected)

    def test_no_unexpected_post_routes(self):
        expected = {"/organizations", "/organizations/favorite"}
        self.assertEqual(set(self.router.routes["POST"].keys()), expected)


# ---------------------------------------------------------------------------
# GET /organizations
# ---------------------------------------------------------------------------

class TestListOrganizations(unittest.TestCase):

    def setUp(self):
        self.router, self.db = _make_router()

    def _call(self, **qp):
        return _call(self.router, "GET", "/organizations", _qp(**qp) if qp else {})

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
        self.db.list_organizations.assert_called_once_with(search=None, limit=50, offset=0, favorites_only=False)

    def test_favorite_param_filters(self):
        self._call(favorite="true")
        self.db.list_organizations.assert_called_once_with(search=None, limit=50, offset=0, favorites_only=True)

    def test_favorite_param_falsey_does_not_filter(self):
        self._call(favorite="0")
        self.db.list_organizations.assert_called_once_with(search=None, limit=50, offset=0, favorites_only=False)

    def test_empty_list_when_no_orgs(self):
        result = self._call()
        self.assertEqual(result["organizations"], [])

    def test_returns_orgs_from_db(self):
        self.db.list_organizations.return_value = {
            "total": 2, "limit": 50, "offset": 0, "organizations": [ORG_ALPHA, ORG_BETA]
        }
        result = self._call()
        self.assertEqual(result["organizations"], [ORG_ALPHA, ORG_BETA])

    def test_non_integer_limit_returns_error(self):
        result = self._call(limit="bad")
        self.assertIn("error", result)

    def test_non_integer_offset_returns_error(self):
        result = self._call(offset="abc")
        self.assertIn("error", result)

    def test_count_matches_db(self):
        self.db.list_organizations.return_value = {
            "total": 2, "limit": 50, "offset": 0, "organizations": [ORG_ALPHA, ORG_BETA]
        }
        result = self._call()
        self.assertEqual(len(result["organizations"]), 2)


# ---------------------------------------------------------------------------
# GET /organizations/detail
# ---------------------------------------------------------------------------

class TestGetOrganization(unittest.TestCase):

    def setUp(self):
        self.router, self.db = _make_router()

    def _call(self, **qp):
        return _call(self.router, "GET", "/organizations/detail", _qp(**qp) if qp else {})

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
# POST /organizations
# ---------------------------------------------------------------------------

class TestUpsertOrganization(unittest.TestCase):

    def setUp(self):
        self.router, self.db = _make_router()
        self.db.get_organization.return_value = ORG_ALPHA

    def _call(self, body=None):
        return _call(self.router, "POST", "/organizations", body=body)

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
# GET /organizations/full
# ---------------------------------------------------------------------------

class TestGetOrganizationFull(unittest.TestCase):

    def setUp(self):
        self.router, self.db = _make_router()

    def _call(self, **qp):
        return _call(self.router, "GET", "/organizations/full", _qp(**qp) if qp else {})

    def test_missing_ein_returns_error(self):
        result = self._call()
        self.assertIn("error", result)

    def test_missing_ein_error_mentions_param(self):
        result = self._call()
        self.assertIn("ein", result["error"])

    def test_org_not_found_returns_error(self):
        result = self._call(ein="999999999")
        self.assertIn("error", result)

    def test_org_not_found_error_contains_ein(self):
        result = self._call(ein="999999999")
        self.assertIn("999999999", result["error"])

    def test_calls_get_organization_with_ein(self):
        self._call(ein="111111111")
        self.db.get_organization.assert_called_once_with("111111111")

    def test_found_calls_list_filings_with_ein(self):
        self.db.get_organization.return_value = ORG_ALPHA
        self._call(ein="111111111")
        self.db.list_filings.assert_called_once_with("111111111")

    def test_not_found_does_not_call_list_filings(self):
        self._call(ein="999999999")
        self.db.list_filings.assert_not_called()

    def test_found_includes_org_ein(self):
        self.db.get_organization.return_value = ORG_ALPHA
        result = self._call(ein="111111111")
        self.assertEqual(result["ein"], "111111111")

    def test_found_includes_org_name(self):
        self.db.get_organization.return_value = ORG_ALPHA
        result = self._call(ein="111111111")
        self.assertEqual(result["name"], "Alpha Org")

    def test_found_includes_filings_key(self):
        self.db.get_organization.return_value = ORG_ALPHA
        result = self._call(ein="111111111")
        self.assertIn("filings", result)

    def test_filings_is_list(self):
        self.db.get_organization.return_value = ORG_ALPHA
        result = self._call(ein="111111111")
        self.assertIsInstance(result["filings"], list)

    def test_empty_filings_when_none(self):
        self.db.get_organization.return_value = ORG_ALPHA
        result = self._call(ein="111111111")
        self.assertEqual(result["filings"], [])

    def test_filing_count_matches_db(self):
        self.db.get_organization.return_value = ORG_ALPHA
        self.db.list_filings.return_value = [dict(FILING_ONE), dict(FILING_ONE)]
        result = self._call(ein="111111111")
        self.assertEqual(len(result["filings"]), 2)

    def test_each_filing_has_links(self):
        self.db.get_organization.return_value = ORG_ALPHA
        self.db.list_filings.return_value = [dict(FILING_ONE)]
        result = self._call(ein="111111111")
        self.assertIn("links", result["filings"][0])

    def test_links_has_detail_key(self):
        self.db.get_organization.return_value = ORG_ALPHA
        self.db.list_filings.return_value = [dict(FILING_ONE)]
        result = self._call(ein="111111111")
        self.assertIn("detail", result["filings"][0]["links"])

    def test_links_has_data_key(self):
        self.db.get_organization.return_value = ORG_ALPHA
        self.db.list_filings.return_value = [dict(FILING_ONE)]
        result = self._call(ein="111111111")
        self.assertIn("data", result["filings"][0]["links"])

    def test_links_has_lookup_key(self):
        self.db.get_organization.return_value = ORG_ALPHA
        self.db.list_filings.return_value = [dict(FILING_ONE)]
        result = self._call(ein="111111111")
        self.assertIn("lookup", result["filings"][0]["links"])

    def test_detail_link_contains_filing_id(self):
        self.db.get_organization.return_value = ORG_ALPHA
        self.db.list_filings.return_value = [dict(FILING_ONE)]
        result = self._call(ein="111111111")
        self.assertIn("uuid-abc-123", result["filings"][0]["links"]["detail"])

    def test_lookup_link_contains_ein(self):
        self.db.get_organization.return_value = ORG_ALPHA
        self.db.list_filings.return_value = [dict(FILING_ONE)]
        result = self._call(ein="111111111")
        self.assertIn("111111111", result["filings"][0]["links"]["lookup"])

    def test_lookup_link_contains_year(self):
        self.db.get_organization.return_value = ORG_ALPHA
        self.db.list_filings.return_value = [dict(FILING_ONE)]
        result = self._call(ein="111111111")
        self.assertIn("2023", result["filings"][0]["links"]["lookup"])

    def test_data_link_contains_filing_id(self):
        self.db.get_organization.return_value = ORG_ALPHA
        self.db.list_filings.return_value = [dict(FILING_ONE)]
        result = self._call(ein="111111111")
        self.assertIn("uuid-abc-123", result["filings"][0]["links"]["data"])


# ---------------------------------------------------------------------------
# POST /organizations/favorite
# ---------------------------------------------------------------------------

class TestSetFavorite(unittest.TestCase):

    def setUp(self):
        self.router, self.db = _make_router()
        self.db.set_favorite.return_value = True
        self.db.get_organization.return_value = {**ORG_ALPHA, "is_favorite": True}

    def _call(self, body=None):
        return _call(self.router, "POST", "/organizations/favorite", body=body)

    def test_valid_body_calls_set_favorite(self):
        self._call({"ein": "111111111", "is_favorite": True})
        self.db.set_favorite.assert_called_once_with("111111111", True)

    def test_unfavorite_passes_false(self):
        self._call({"ein": "111111111", "is_favorite": False})
        self.db.set_favorite.assert_called_once_with("111111111", False)

    def test_returns_updated_org(self):
        result = self._call({"ein": "111111111", "is_favorite": True})
        self.assertTrue(result["is_favorite"])

    def test_calls_get_organization_after_set(self):
        self._call({"ein": "111111111", "is_favorite": True})
        self.db.get_organization.assert_called_once_with("111111111")

    def test_string_true_coerced(self):
        self._call({"ein": "111111111", "is_favorite": "true"})
        self.db.set_favorite.assert_called_once_with("111111111", True)

    def test_string_false_coerced(self):
        self._call({"ein": "111111111", "is_favorite": "false"})
        self.db.set_favorite.assert_called_once_with("111111111", False)

    def test_int_one_coerced(self):
        self._call({"ein": "111111111", "is_favorite": 1})
        self.db.set_favorite.assert_called_once_with("111111111", True)

    def test_not_found_returns_error(self):
        self.db.set_favorite.return_value = False
        result = self._call({"ein": "999999999", "is_favorite": True})
        self.assertIn("error", result)

    def test_not_found_error_contains_ein(self):
        self.db.set_favorite.return_value = False
        result = self._call({"ein": "999999999", "is_favorite": True})
        self.assertIn("999999999", result["error"])

    def test_not_found_does_not_call_get_organization(self):
        self.db.set_favorite.return_value = False
        self._call({"ein": "999999999", "is_favorite": True})
        self.db.get_organization.assert_not_called()

    def test_missing_ein_returns_error(self):
        result = self._call({"is_favorite": True})
        self.assertIn("error", result)

    def test_missing_is_favorite_returns_error(self):
        result = self._call({"ein": "111111111"})
        self.assertIn("error", result)

    def test_string_body_returns_error(self):
        result = self._call("not a dict")
        self.assertIn("error", result)


if __name__ == "__main__":
    unittest.main()
