import os
import sys
import sqlite3
import unittest
from unittest.mock import MagicMock, call

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

from router.Score import ScoreRouter


FACTOR_STUB = {
    "factor_id": 1, "name": "Program Expense", "weight": 0.05,
    "formula_description": "Average Program Expenses ÷ Average Total Expenses",
}

SCORE_STUB = {
    "score_id": 7, "organization_id": "111111111", "model_version": 1,
    "total_score": 0.75, "scored_at": "2024-01-01 00:00:00",
    "factors": [{"name": "Program Expense", "weight": 0.05, "raw_value": 0.8, "weighted_value": 0.04}],
}

SCORE_LIST_STUB = [
    {"score_id": 7, "model_version": 1, "total_score": 0.75, "scored_at": "2024-01-01"},
    {"score_id": 8, "model_version": 1, "total_score": 0.60, "scored_at": "2024-01-02"},
]


def _make_router():
    db = MagicMock()
    db.get_factors.return_value = []
    db.list_scores.return_value = []
    db.get_score.return_value = None
    db.create_score.return_value = 7
    return ScoreRouter(db=db), db


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

class TestScoreRouterRegistration(unittest.TestCase):

    def setUp(self):
        self.router, _ = _make_router()

    def test_get_factors_registered(self):
        self.assertIn("/scores/factors", self.router.routes["GET"])

    def test_get_scores_registered(self):
        self.assertIn("/scores", self.router.routes["GET"])

    def test_get_scores_detail_registered(self):
        self.assertIn("/scores/detail", self.router.routes["GET"])

    def test_post_scores_registered(self):
        self.assertIn("/scores", self.router.routes["POST"])

    def test_post_scores_factors_registered(self):
        self.assertIn("/scores/factors", self.router.routes["POST"])

    def test_post_scores_finalize_registered(self):
        self.assertIn("/scores/finalize", self.router.routes["POST"])

    def test_custom_prefix_applied(self):
        router2 = ScoreRouter(prefix='/api/scores', db=MagicMock())
        self.assertIn("/api/scores/factors", router2.routes["GET"])

    def test_no_unexpected_get_routes(self):
        expected = {"/scores/factors", "/scores", "/scores/filing", "/scores/detail", "/scores/lookup"}
        self.assertEqual(set(self.router.routes["GET"].keys()), expected)

    def test_no_unexpected_post_routes(self):
        expected = {"/scores", "/scores/factors", "/scores/finalize", "/scores/calculate"}
        self.assertEqual(set(self.router.routes["POST"].keys()), expected)


# ---------------------------------------------------------------------------
# GET /scores/factors
# ---------------------------------------------------------------------------

class TestGetFactors(unittest.TestCase):

    def setUp(self):
        self.router, self.db = _make_router()

    def _call(self, **qp):
        return _call(self.router, "GET", "/scores/factors", _qp(**qp) if qp else {})

    def test_returns_dict(self):
        result = self._call()
        self.assertIsInstance(result, dict)

    def test_returns_model_version_key(self):
        result = self._call()
        self.assertIn("model_version", result)

    def test_returns_factors_key(self):
        result = self._call()
        self.assertIn("factors", result)

    def test_factors_is_list(self):
        result = self._call()
        self.assertIsInstance(result["factors"], list)

    def test_default_version_is_1(self):
        self._call()
        self.db.get_factors.assert_called_once_with(1)

    def test_default_model_version_in_response_is_1(self):
        result = self._call()
        self.assertEqual(result["model_version"], 1)

    def test_explicit_version_passed_to_db(self):
        self._call(version="2")
        self.db.get_factors.assert_called_once_with(2)

    def test_explicit_version_reflected_in_response(self):
        result = self._call(version="2")
        self.assertEqual(result["model_version"], 2)

    def test_non_digit_version_falls_back_to_1(self):
        self._call(version="abc")
        self.db.get_factors.assert_called_once_with(1)

    def test_missing_version_falls_back_to_1(self):
        self._call()
        self.db.get_factors.assert_called_once_with(1)

    def test_returns_factors_from_db(self):
        self.db.get_factors.return_value = [FACTOR_STUB]
        result = self._call()
        self.assertEqual(result["factors"], [FACTOR_STUB])

    def test_empty_factors_when_unknown_version(self):
        self.db.get_factors.return_value = []
        result = self._call(version="99")
        self.assertEqual(result["factors"], [])


# ---------------------------------------------------------------------------
# GET /scores
# ---------------------------------------------------------------------------

class TestListScores(unittest.TestCase):

    def setUp(self):
        self.router, self.db = _make_router()

    def _call(self, **qp):
        return _call(self.router, "GET", "/scores", _qp(**qp) if qp else {})

    def test_missing_ein_returns_error(self):
        result = self._call()
        self.assertIn("error", result)

    def test_missing_ein_error_mentions_param(self):
        result = self._call()
        self.assertIn("ein", result["error"])

    def test_returns_ein_key(self):
        result = self._call(ein="111111111")
        self.assertIn("ein", result)

    def test_ein_echoed_in_response(self):
        result = self._call(ein="111111111")
        self.assertEqual(result["ein"], "111111111")

    def test_returns_scores_key(self):
        result = self._call(ein="111111111")
        self.assertIn("scores", result)

    def test_scores_is_list(self):
        result = self._call(ein="111111111")
        self.assertIsInstance(result["scores"], list)

    def test_calls_list_scores_with_ein(self):
        self._call(ein="111111111")
        self.db.list_scores.assert_called_once_with("111111111")

    def test_empty_list_when_no_scores(self):
        result = self._call(ein="111111111")
        self.assertEqual(result["scores"], [])

    def test_returns_scores_from_db(self):
        self.db.list_scores.return_value = SCORE_LIST_STUB
        result = self._call(ein="111111111")
        self.assertEqual(result["scores"], SCORE_LIST_STUB)

    def test_score_count_matches_db(self):
        self.db.list_scores.return_value = SCORE_LIST_STUB
        result = self._call(ein="111111111")
        self.assertEqual(len(result["scores"]), 2)


# ---------------------------------------------------------------------------
# GET /scores/detail
# ---------------------------------------------------------------------------

class TestGetScore(unittest.TestCase):

    def setUp(self):
        self.router, self.db = _make_router()

    def _call(self, **qp):
        return _call(self.router, "GET", "/scores/detail", _qp(**qp) if qp else {})

    def test_missing_score_id_returns_error(self):
        result = self._call()
        self.assertIn("error", result)

    def test_missing_score_id_error_mentions_param(self):
        result = self._call()
        self.assertIn("score_id", result["error"])

    def test_non_integer_score_id_returns_error(self):
        result = self._call(score_id="not-an-int")
        self.assertIn("error", result)

    def test_not_found_returns_error(self):
        self.db.get_score.return_value = None
        result = self._call(score_id="99999")
        self.assertIn("error", result)

    def test_not_found_error_contains_id(self):
        result = self._call(score_id="99999")
        self.assertIn("99999", result["error"])

    def test_found_returns_score_dict(self):
        self.db.get_score.return_value = SCORE_STUB
        result = self._call(score_id="7")
        self.assertEqual(result, SCORE_STUB)

    def test_calls_get_score_with_int_id(self):
        self._call(score_id="7")
        self.db.get_score.assert_called_once_with(7)

    def test_score_id_cast_to_int(self):
        self._call(score_id="42")
        self.db.get_score.assert_called_once_with(42)

    def test_found_has_score_id_field(self):
        self.db.get_score.return_value = SCORE_STUB
        result = self._call(score_id="7")
        self.assertEqual(result["score_id"], 7)

    def test_found_has_model_version_field(self):
        self.db.get_score.return_value = SCORE_STUB
        result = self._call(score_id="7")
        self.assertEqual(result["model_version"], 1)

    def test_found_has_factors_field(self):
        self.db.get_score.return_value = SCORE_STUB
        result = self._call(score_id="7")
        self.assertIn("factors", result)


# ---------------------------------------------------------------------------
# POST /scores
# ---------------------------------------------------------------------------

class TestCreateScore(unittest.TestCase):

    def setUp(self):
        self.router, self.db = _make_router()

    def _call(self, body=None):
        return _call(self.router, "POST", "/scores", body=body)

    def test_valid_body_returns_score_id(self):
        result = self._call({"filing_id": "test-filing-uuid"})
        self.assertIn("score_id", result)

    def test_score_id_matches_db_return(self):
        result = self._call({"filing_id": "test-filing-uuid"})
        self.assertEqual(result["score_id"], 7)

    def test_returns_filing_id_in_response(self):
        result = self._call({"filing_id": "test-filing-uuid"})
        self.assertEqual(result["filing_id"], "test-filing-uuid")

    def test_returns_model_version_in_response(self):
        result = self._call({"filing_id": "test-filing-uuid"})
        self.assertIn("model_version", result)

    def test_default_model_version_is_1(self):
        result = self._call({"filing_id": "test-filing-uuid"})
        self.assertEqual(result["model_version"], 1)

    def test_calls_create_score_with_default_version(self):
        self._call({"filing_id": "test-filing-uuid"})
        self.db.create_score.assert_called_once_with("test-filing-uuid", 1)

    def test_explicit_model_version_passed_to_db(self):
        self._call({"filing_id": "test-filing-uuid", "model_version": 2})
        self.db.create_score.assert_called_once_with("test-filing-uuid", 2)

    def test_explicit_model_version_in_response(self):
        result = self._call({"filing_id": "test-filing-uuid", "model_version": 2})
        self.assertEqual(result["model_version"], 2)

    def test_missing_filing_id_returns_error(self):
        result = self._call({"model_version": 1})
        self.assertIn("error", result)

    def test_missing_filing_id_error_names_field(self):
        result = self._call({"model_version": 1})
        self.assertIn("filing_id", result["error"])

    def test_empty_body_returns_error(self):
        result = self._call({})
        self.assertIn("error", result)

    def test_string_body_returns_error(self):
        result = self._call("not a dict")
        self.assertIn("error", result)

    def test_none_body_returns_error(self):
        result = self._call(None)
        self.assertIn("error", result)

    def test_value_error_unknown_version_returns_error(self):
        self.db.create_score.side_effect = ValueError("Score model version 99 not found")
        result = self._call({"filing_id": "test-filing-uuid", "model_version": 99})
        self.assertIn("error", result)

    def test_value_error_does_not_raise(self):
        self.db.create_score.side_effect = ValueError("Score model version 99 not found")
        self._call({"filing_id": "test-filing-uuid", "model_version": 99})  # must not raise

    def test_integrity_error_unknown_filing_returns_error(self):
        self.db.create_score.side_effect = sqlite3.IntegrityError("fk violation")
        result = self._call({"filing_id": "nonexistent-uuid"})
        self.assertIn("error", result)

    def test_integrity_error_does_not_raise(self):
        self.db.create_score.side_effect = sqlite3.IntegrityError("fk violation")
        self._call({"filing_id": "nonexistent-uuid"})  # must not raise


# ---------------------------------------------------------------------------
# POST /scores/factors
# ---------------------------------------------------------------------------

class TestStoreFactorValues(unittest.TestCase):

    def setUp(self):
        self.router, self.db = _make_router()

    def _call(self, body=None):
        return _call(self.router, "POST", "/scores/factors", body=body)

    def test_valid_body_returns_score_id(self):
        result = self._call({"score_id": 7, "values": [
            {"factor_id": 1, "raw_value": 0.8, "weighted_value": 0.04},
        ]})
        self.assertIn("score_id", result)

    def test_score_id_in_response(self):
        result = self._call({"score_id": 7, "values": [
            {"factor_id": 1, "raw_value": 0.8, "weighted_value": 0.04},
        ]})
        self.assertEqual(result["score_id"], 7)

    def test_returns_factors_stored_count(self):
        result = self._call({"score_id": 7, "values": [
            {"factor_id": 1, "raw_value": 0.8, "weighted_value": 0.04},
            {"factor_id": 2, "raw_value": 0.5, "weighted_value": 0.025},
        ]})
        self.assertEqual(result["factors_stored"], 2)

    def test_calls_store_factor_values_with_correct_dict(self):
        self._call({"score_id": 7, "values": [
            {"factor_id": 1, "raw_value": 0.8, "weighted_value": 0.04},
        ]})
        self.db.store_factor_values.assert_called_once_with(7, {1: (0.8, 0.04)})

    def test_multiple_factors_passed_correctly(self):
        self._call({"score_id": 7, "values": [
            {"factor_id": 1, "raw_value": 0.8,  "weighted_value": 0.04},
            {"factor_id": 2, "raw_value": 0.5,  "weighted_value": 0.025},
            {"factor_id": 3, "raw_value": 0.3,  "weighted_value": 0.015},
        ]})
        self.db.store_factor_values.assert_called_once_with(7, {
            1: (0.8, 0.04), 2: (0.5, 0.025), 3: (0.3, 0.015),
        })

    def test_score_id_cast_to_int(self):
        self._call({"score_id": "7", "values": [
            {"factor_id": 1, "raw_value": 0.8, "weighted_value": 0.04},
        ]})
        self.db.store_factor_values.assert_called_once_with(7, {1: (0.8, 0.04)})

    def test_null_raw_and_weighted_values_allowed(self):
        result = self._call({"score_id": 7, "values": [
            {"factor_id": 1, "raw_value": None, "weighted_value": None},
        ]})
        self.assertNotIn("error", result)
        self.db.store_factor_values.assert_called_once_with(7, {1: (None, None)})

    def test_missing_raw_value_defaults_to_none(self):
        self._call({"score_id": 7, "values": [{"factor_id": 1}]})
        self.db.store_factor_values.assert_called_once_with(7, {1: (None, None)})

    def test_empty_values_list_stores_nothing(self):
        result = self._call({"score_id": 7, "values": []})
        self.assertEqual(result["factors_stored"], 0)
        self.db.store_factor_values.assert_called_once_with(7, {})

    def test_missing_score_id_returns_error(self):
        result = self._call({"values": [{"factor_id": 1, "raw_value": 0.8, "weighted_value": 0.04}]})
        self.assertIn("error", result)

    def test_missing_values_returns_error(self):
        result = self._call({"score_id": 7})
        self.assertIn("error", result)

    def test_values_as_dict_returns_error(self):
        result = self._call({"score_id": 7, "values": {"1": 0.8}})
        self.assertIn("error", result)

    def test_item_missing_factor_id_returns_error(self):
        result = self._call({"score_id": 7, "values": [{"raw_value": 0.8}]})
        self.assertIn("error", result)

    def test_item_missing_factor_id_does_not_call_db(self):
        self._call({"score_id": 7, "values": [{"raw_value": 0.8}]})
        self.db.store_factor_values.assert_not_called()

    def test_string_body_returns_error(self):
        result = self._call("not json")
        self.assertIn("error", result)

    def test_none_body_returns_error(self):
        result = self._call(None)
        self.assertIn("error", result)

    def test_integrity_error_returns_error(self):
        self.db.store_factor_values.side_effect = sqlite3.IntegrityError("constraint")
        result = self._call({"score_id": 7, "values": [
            {"factor_id": 1, "raw_value": 0.8, "weighted_value": 0.04},
        ]})
        self.assertIn("error", result)

    def test_integrity_error_does_not_raise(self):
        self.db.store_factor_values.side_effect = sqlite3.IntegrityError("constraint")
        self._call({"score_id": 7, "values": [
            {"factor_id": 1, "raw_value": 0.8, "weighted_value": 0.04},
        ]})  # must not raise


# ---------------------------------------------------------------------------
# POST /scores/finalize
# ---------------------------------------------------------------------------

class TestFinalizeScore(unittest.TestCase):

    def setUp(self):
        self.router, self.db = _make_router()

    def _call(self, body=None):
        return _call(self.router, "POST", "/scores/finalize", body=body)

    def test_valid_body_returns_score_id(self):
        result = self._call({"score_id": 7, "total_score": 0.75})
        self.assertIn("score_id", result)

    def test_score_id_in_response(self):
        result = self._call({"score_id": 7, "total_score": 0.75})
        self.assertEqual(result["score_id"], 7)

    def test_total_score_in_response(self):
        result = self._call({"score_id": 7, "total_score": 0.75})
        self.assertAlmostEqual(result["total_score"], 0.75)

    def test_calls_finalize_score(self):
        self._call({"score_id": 7, "total_score": 0.75})
        self.db.finalize_score.assert_called_once_with(7, 0.75)

    def test_score_id_cast_to_int(self):
        self._call({"score_id": "7", "total_score": 0.75})
        self.db.finalize_score.assert_called_once_with(7, 0.75)

    def test_total_score_cast_to_float(self):
        self._call({"score_id": 7, "total_score": "0.75"})
        self.db.finalize_score.assert_called_once_with(7, 0.75)

    def test_integer_total_score_cast_to_float(self):
        self._call({"score_id": 7, "total_score": 1})
        args = self.db.finalize_score.call_args[0]
        self.assertIsInstance(args[1], float)

    def test_zero_total_score(self):
        result = self._call({"score_id": 7, "total_score": 0})
        self.assertAlmostEqual(result["total_score"], 0.0)

    def test_negative_total_score(self):
        result = self._call({"score_id": 7, "total_score": -0.5})
        self.assertAlmostEqual(result["total_score"], -0.5)

    def test_perfect_score_of_1(self):
        result = self._call({"score_id": 7, "total_score": 1.0})
        self.assertAlmostEqual(result["total_score"], 1.0)

    def test_missing_score_id_returns_error(self):
        result = self._call({"total_score": 0.75})
        self.assertIn("error", result)

    def test_missing_score_id_error_names_field(self):
        result = self._call({"total_score": 0.75})
        self.assertIn("score_id", result["error"])

    def test_missing_total_score_returns_error(self):
        result = self._call({"score_id": 7})
        self.assertIn("error", result)

    def test_missing_total_score_error_names_field(self):
        result = self._call({"score_id": 7})
        self.assertIn("total_score", result["error"])

    def test_string_body_returns_error(self):
        result = self._call("not json")
        self.assertIn("error", result)

    def test_none_body_returns_error(self):
        result = self._call(None)
        self.assertIn("error", result)

    def test_non_numeric_total_score_returns_error(self):
        result = self._call({"score_id": 7, "total_score": "not-a-number"})
        self.assertIn("error", result)

    def test_non_numeric_total_score_does_not_raise(self):
        self._call({"score_id": 7, "total_score": "not-a-number"})  # must not raise

    def test_non_numeric_total_score_does_not_call_db(self):
        self._call({"score_id": 7, "total_score": "not-a-number"})
        self.db.finalize_score.assert_not_called()


# ---------------------------------------------------------------------------
# GET /scores/filing
# ---------------------------------------------------------------------------

class TestGetScoreByFiling(unittest.TestCase):

    def setUp(self):
        self.router, self.db = _make_router()

    def _call(self, **qp):
        return _call(self.router, "GET", "/scores/filing", _qp(**qp) if qp else {})

    def test_missing_filing_id_returns_error(self):
        result = self._call()
        self.assertIn("error", result)

    def test_missing_filing_id_error_mentions_param(self):
        result = self._call()
        self.assertIn("filing_id", result["error"])

    def test_not_found_returns_error(self):
        self.db.get_score_by_filing.return_value = None
        result = self._call(filing_id="nonexistent-uuid")
        self.assertIn("error", result)

    def test_not_found_error_contains_filing_id(self):
        self.db.get_score_by_filing.return_value = None
        result = self._call(filing_id="nonexistent-uuid")
        self.assertIn("nonexistent-uuid", result["error"])

    def test_found_returns_score(self):
        self.db.get_score_by_filing.return_value = SCORE_STUB
        result = self._call(filing_id="test-uuid")
        self.assertEqual(result, SCORE_STUB)

    def test_calls_get_score_by_filing_with_id(self):
        self._call(filing_id="test-uuid")
        self.db.get_score_by_filing.assert_called_once_with("test-uuid")


# ---------------------------------------------------------------------------
# POST /scores/calculate
# ---------------------------------------------------------------------------

class TestCalculateScore(unittest.TestCase):

    def setUp(self):
        self.router, self.db = _make_router()

    def _call(self, body=None):
        return _call(self.router, "POST", "/scores/calculate", body=body)

    def test_missing_ein_returns_error(self):
        result = self._call({"year": 2023})
        self.assertIn("error", result)

    def test_missing_year_returns_error(self):
        result = self._call({"ein": "111111111"})
        self.assertIn("error", result)

    def test_empty_body_returns_error(self):
        result = self._call({})
        self.assertIn("error", result)

    def test_none_body_returns_error(self):
        result = self._call(None)
        self.assertIn("error", result)

    def test_valid_body_calls_engine_calculate(self):
        from unittest.mock import patch
        with patch.object(self.router.engine, 'calculate', return_value={"score": 0.8}) as mock_calc:
            result = self._call({"ein": "111111111", "year": 2023})
        mock_calc.assert_called_once_with("111111111", 2023, 1)

    def test_value_error_returns_error_dict(self):
        from unittest.mock import patch
        with patch.object(self.router.engine, 'calculate', side_effect=ValueError("no filing")):
            result = self._call({"ein": "111111111", "year": 2023})
        self.assertIn("error", result)

    def test_integrity_error_returns_error_dict(self):
        from unittest.mock import patch
        with patch.object(self.router.engine, 'calculate', side_effect=sqlite3.IntegrityError("fk")):
            result = self._call({"ein": "111111111", "year": 2023})
        self.assertIn("error", result)

    def test_custom_model_version_passed_to_engine(self):
        from unittest.mock import patch
        with patch.object(self.router.engine, 'calculate', return_value={"score": 0.5}) as mock_calc:
            self._call({"ein": "111111111", "year": 2023, "model_version": 2})
        mock_calc.assert_called_once_with("111111111", 2023, 2)

    def test_year_cast_to_int(self):
        from unittest.mock import patch
        with patch.object(self.router.engine, 'calculate', return_value={"score": 0.5}) as mock_calc:
            self._call({"ein": "111111111", "year": "2023"})
        args = mock_calc.call_args[0]
        self.assertEqual(args[1], 2023)

    def test_successful_calculate_returns_result(self):
        from unittest.mock import patch
        expected = {"score_id": 5, "total_score": 0.8}
        with patch.object(self.router.engine, 'calculate', return_value=expected):
            result = self._call({"ein": "111111111", "year": 2023})
        self.assertEqual(result, expected)


# ---------------------------------------------------------------------------
# GET /scores/lookup
# ---------------------------------------------------------------------------

class TestLookupScore(unittest.TestCase):

    def setUp(self):
        self.router, self.db = _make_router()

    def _call(self, **qp):
        return _call(self.router, "GET", "/scores/lookup", _qp(**qp) if qp else {})

    def test_missing_ein_returns_error(self):
        result = self._call(year="2023")
        self.assertIn("error", result)

    def test_missing_year_returns_error(self):
        result = self._call(ein="111111111")
        self.assertIn("error", result)

    def test_missing_both_returns_error(self):
        result = self._call()
        self.assertIn("error", result)

    def test_non_integer_year_returns_error(self):
        result = self._call(ein="111111111", year="notanint")
        self.assertIn("error", result)

    def test_not_found_returns_error(self):
        self.db.get_score_by_ein_year.return_value = None
        result = self._call(ein="111111111", year="2023")
        self.assertIn("error", result)

    def test_not_found_error_contains_ein_and_year(self):
        self.db.get_score_by_ein_year.return_value = None
        result = self._call(ein="111111111", year="2023")
        self.assertIn("111111111", result["error"])
        self.assertIn("2023", result["error"])

    def test_found_returns_score(self):
        self.db.get_score_by_ein_year.return_value = SCORE_STUB
        result = self._call(ein="111111111", year="2023")
        self.assertEqual(result, SCORE_STUB)

    def test_calls_get_score_by_ein_year_with_correct_args(self):
        self.db.get_score_by_ein_year.return_value = SCORE_STUB
        self._call(ein="111111111", year="2023")
        self.db.get_score_by_ein_year.assert_called_once_with("111111111", 2023)

    def test_year_cast_to_int(self):
        self.db.get_score_by_ein_year.return_value = SCORE_STUB
        self._call(ein="111111111", year="2022")
        args = self.db.get_score_by_ein_year.call_args[0]
        self.assertIsInstance(args[1], int)


if __name__ == "__main__":
    unittest.main()
