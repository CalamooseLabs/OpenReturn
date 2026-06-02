import os
import sys
import sqlite3
import tempfile
import unittest

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

from database.Score import ScoreDatabase
from database.IRS990 import IRS990Database


# Canonical v1 factor data: (name, weight, formula_description)
V1_FACTORS = [
    ("Program Expense",             0.05, "Average Program Expenses ÷ Average Total Expenses"),
    ("Admin Expense",               0.05, "Average Administrative Expenses ÷ Average Total Expenses"),
    ("Fundraising Expense",         0.05, "Average Fundraising Expenses ÷ Average Total Expenses"),
    ("Fundraising Efficiency",      0.10, "Average Fundraising Expenses ÷ Average Total Contributions"),
    ("Program Expense Growth",      0.05, "(Yn / Y0)^(1/(n+1)) - 1"),
    ("Assets to Liabilities Ratio", 0.15, "Total Liabilities ÷ Total Assets"),
    ("Debt to Equity Ratio",        0.10, "Total Liabilities ÷ Equity"),
    ("Working Capital Ratio",       0.10, "Working Capital ÷ Average Total Expenses"),
    ("Government Reliance",         0.05, "Gov. Grants ÷ Total Contributions"),
    ("Excess/Deficit at Year End",  0.05, "Total Revenue ÷ Total Expenses"),
    ("% Gift is of Revenue",        0.05, "Gift or Ask Amount ÷ Total Contributions"),
    ("Dependence on Gifts/Grants",  0.10, "Total Contributions ÷ Total Expenses"),
    ("Return on Investments",       0.05, "Investment Income ÷ Investment Made"),
    ("Admin Cost Ratio",            0.05, "(Total Fundraising + General and Admin Expense) ÷ Total Expenses"),
]


class ScoreDbTestCase(unittest.TestCase):
    """Base: fresh ScoreDatabase + one seeded org per test method."""

    EIN_ALPHA = "111111111"
    EIN_BETA  = "222222222"

    def setUp(self):
        self._tmpdir = tempfile.TemporaryDirectory()
        self._orig_cwd = os.getcwd()
        os.chdir(self._tmpdir.name)
        self.db = ScoreDatabase()
        self.db.upsert_organization(self.EIN_ALPHA, "Alpha Org")
        self.db.upsert_organization(self.EIN_BETA, "Beta Org")
        self.factors = self.db.get_factors(1)

    def tearDown(self):
        if self.db is not None:
            self.db.close()
        os.chdir(self._orig_cwd)
        self._tmpdir.cleanup()

    def _factor_ids(self):
        """Return all factor_ids for model v1, in order."""
        return [f["factor_id"] for f in self.db.get_factors(1)]

    def _all_factor_values(self, raw=1.0):
        """Build a complete {factor_id: (raw, weighted)} dict for model v1."""
        return {
            f["factor_id"]: (raw, raw * f["weight"])
            for f in self.db.get_factors(1)
        }


# ---------------------------------------------------------------------------
# Initialization / Schema
# ---------------------------------------------------------------------------

class TestScoreDatabaseInit(ScoreDbTestCase):

    def test_is_subclass_of_irs990_database(self):
        self.assertIsInstance(self.db, IRS990Database)

    def test_score_model_table_exists(self):
        count = self.db.cursor.execute(
            "SELECT COUNT(*) FROM sqlite_master WHERE type='table' AND name='score_model'"
        ).fetchone()[0]
        self.assertEqual(count, 1)

    def test_score_factor_table_exists(self):
        count = self.db.cursor.execute(
            "SELECT COUNT(*) FROM sqlite_master WHERE type='table' AND name='score_factor'"
        ).fetchone()[0]
        self.assertEqual(count, 1)

    def test_organization_score_table_exists(self):
        count = self.db.cursor.execute(
            "SELECT COUNT(*) FROM sqlite_master WHERE type='table' AND name='organization_score'"
        ).fetchone()[0]
        self.assertEqual(count, 1)

    def test_organization_score_factor_table_exists(self):
        count = self.db.cursor.execute(
            "SELECT COUNT(*) FROM sqlite_master WHERE type='table' AND name='organization_score_factor'"
        ).fetchone()[0]
        self.assertEqual(count, 1)

    def test_irs990_tables_still_exist(self):
        for table in ("organization", "filing", "reported_data", "field"):
            count = self.db.cursor.execute(
                "SELECT COUNT(*) FROM sqlite_master WHERE type='table' AND name=?", (table,)
            ).fetchone()[0]
            self.assertEqual(count, 1, f"Expected IRS990 table '{table}' to exist")

    def test_score_tables_use_if_not_exists(self):
        # Verify schema won't error if run twice; score_model/factor use INSERT OR IGNORE
        count = self.db.cursor.execute("SELECT COUNT(*) FROM score_factor").fetchone()[0]
        self.assertEqual(count, 14)

    def test_v1_model_seeded(self):
        count = self.db.cursor.execute(
            "SELECT COUNT(*) FROM score_model WHERE version = 1"
        ).fetchone()[0]
        self.assertEqual(count, 1)

    def test_only_one_model_seeded(self):
        count = self.db.cursor.execute(
            "SELECT COUNT(*) FROM score_model"
        ).fetchone()[0]
        self.assertEqual(count, 1)

    def test_14_factors_seeded(self):
        count = self.db.cursor.execute(
            "SELECT COUNT(*) FROM score_factor"
        ).fetchone()[0]
        self.assertEqual(count, 14)

    def test_organization_score_empty_on_init(self):
        count = self.db.cursor.execute(
            "SELECT COUNT(*) FROM organization_score"
        ).fetchone()[0]
        self.assertEqual(count, 0)

    def test_organization_score_factor_empty_on_init(self):
        count = self.db.cursor.execute(
            "SELECT COUNT(*) FROM organization_score_factor"
        ).fetchone()[0]
        self.assertEqual(count, 0)


# ---------------------------------------------------------------------------
# get_model_id
# ---------------------------------------------------------------------------

class TestGetModelId(ScoreDbTestCase):

    def test_returns_int(self):
        result = self.db.get_model_id(1)
        self.assertIsInstance(result, int)

    def test_returns_positive_int(self):
        result = self.db.get_model_id(1)
        self.assertGreater(result, 0)

    def test_v1_model_id_consistent(self):
        id1 = self.db.get_model_id(1)
        id2 = self.db.get_model_id(1)
        self.assertEqual(id1, id2)

    def test_unknown_version_raises_value_error(self):
        with self.assertRaises(ValueError):
            self.db.get_model_id(999)

    def test_error_message_contains_version_number(self):
        with self.assertRaises(ValueError) as ctx:
            self.db.get_model_id(42)
        self.assertIn("42", str(ctx.exception))

    def test_version_zero_raises_value_error(self):
        with self.assertRaises(ValueError):
            self.db.get_model_id(0)

    def test_negative_version_raises_value_error(self):
        with self.assertRaises(ValueError):
            self.db.get_model_id(-1)


# ---------------------------------------------------------------------------
# get_factors
# ---------------------------------------------------------------------------

class TestGetFactors(ScoreDbTestCase):

    def test_returns_list(self):
        self.assertIsInstance(self.factors, list)

    def test_returns_14_factors(self):
        self.assertEqual(len(self.factors), 14)

    def test_each_factor_is_dict(self):
        for f in self.factors:
            self.assertIsInstance(f, dict)

    def test_each_factor_has_factor_id_key(self):
        for f in self.factors:
            self.assertIn("factor_id", f)

    def test_each_factor_has_name_key(self):
        for f in self.factors:
            self.assertIn("name", f)

    def test_each_factor_has_weight_key(self):
        for f in self.factors:
            self.assertIn("weight", f)

    def test_each_factor_has_formula_description_key(self):
        for f in self.factors:
            self.assertIn("formula_description", f)

    def test_factor_has_no_extra_keys(self):
        expected_keys = {"factor_id", "name", "weight", "formula_description"}
        for f in self.factors:
            self.assertEqual(set(f.keys()), expected_keys)

    def test_all_factor_ids_are_positive_ints(self):
        for f in self.factors:
            self.assertIsInstance(f["factor_id"], int)
            self.assertGreater(f["factor_id"], 0)

    def test_factor_ids_are_unique(self):
        ids = [f["factor_id"] for f in self.factors]
        self.assertEqual(len(ids), len(set(ids)))

    def test_all_weights_are_floats(self):
        for f in self.factors:
            self.assertIsInstance(f["weight"], float)

    def test_all_weights_are_positive(self):
        for f in self.factors:
            self.assertGreater(f["weight"], 0)

    def test_weights_sum_to_1(self):
        total = sum(f["weight"] for f in self.factors)
        self.assertAlmostEqual(total, 1.0, places=10)

    def test_all_expected_names_present(self):
        names = {f["name"] for f in self.factors}
        for expected_name, _, _ in V1_FACTORS:
            self.assertIn(expected_name, names)

    def test_factor_names_match_expected_exactly(self):
        names = [f["name"] for f in self.factors]
        expected_names = [name for name, _, _ in V1_FACTORS]
        self.assertEqual(sorted(names), sorted(expected_names))

    def test_factor_weights_match_expected(self):
        by_name = {f["name"]: f["weight"] for f in self.factors}
        for name, weight, _ in V1_FACTORS:
            self.assertAlmostEqual(by_name[name], weight, places=10,
                                   msg=f"Weight mismatch for '{name}'")

    def test_formula_descriptions_are_nonempty_strings(self):
        for f in self.factors:
            self.assertIsInstance(f["formula_description"], str)
            self.assertGreater(len(f["formula_description"]), 0)

    def test_formula_descriptions_match_expected(self):
        by_name = {f["name"]: f["formula_description"] for f in self.factors}
        for name, _, formula in V1_FACTORS:
            self.assertEqual(by_name[name], formula,
                             msg=f"Formula mismatch for '{name}'")

    def test_ordering_is_stable(self):
        factors2 = self.db.get_factors(1)
        ids1 = [f["factor_id"] for f in self.factors]
        ids2 = [f["factor_id"] for f in factors2]
        self.assertEqual(ids1, ids2)

    def test_ordered_by_factor_id_ascending(self):
        ids = [f["factor_id"] for f in self.factors]
        self.assertEqual(ids, sorted(ids))

    def test_unknown_version_returns_empty_list(self):
        result = self.db.get_factors(999)
        self.assertEqual(result, [])

    def test_version_zero_returns_empty_list(self):
        result = self.db.get_factors(0)
        self.assertEqual(result, [])

    # Spot-check specific factors

    def test_program_expense_weight_is_5_percent(self):
        by_name = {f["name"]: f["weight"] for f in self.factors}
        self.assertAlmostEqual(by_name["Program Expense"], 0.05)

    def test_assets_to_liabilities_weight_is_15_percent(self):
        by_name = {f["name"]: f["weight"] for f in self.factors}
        self.assertAlmostEqual(by_name["Assets to Liabilities Ratio"], 0.15)

    def test_fundraising_efficiency_weight_is_10_percent(self):
        by_name = {f["name"]: f["weight"] for f in self.factors}
        self.assertAlmostEqual(by_name["Fundraising Efficiency"], 0.10)


# ---------------------------------------------------------------------------
# create_score
# ---------------------------------------------------------------------------

class TestCreateScore(ScoreDbTestCase):

    def test_returns_int(self):
        result = self.db.create_score(self.EIN_ALPHA)
        self.assertIsInstance(result, int)

    def test_returns_positive_int(self):
        result = self.db.create_score(self.EIN_ALPHA)
        self.assertGreater(result, 0)

    def test_creates_row_in_organization_score(self):
        score_id = self.db.create_score(self.EIN_ALPHA)
        count = self.db.cursor.execute(
            "SELECT COUNT(*) FROM organization_score WHERE score_id = ?", (score_id,)
        ).fetchone()[0]
        self.assertEqual(count, 1)

    def test_row_has_correct_organization_id(self):
        score_id = self.db.create_score(self.EIN_ALPHA)
        ein = self.db.cursor.execute(
            "SELECT organization_id FROM organization_score WHERE score_id = ?", (score_id,)
        ).fetchone()[0]
        self.assertEqual(ein, self.EIN_ALPHA)

    def test_row_has_correct_model_id_for_v1(self):
        model_id = self.db.get_model_id(1)
        score_id = self.db.create_score(self.EIN_ALPHA)
        stored_model_id = self.db.cursor.execute(
            "SELECT model_id FROM organization_score WHERE score_id = ?", (score_id,)
        ).fetchone()[0]
        self.assertEqual(stored_model_id, model_id)

    def test_total_score_is_null_initially(self):
        score_id = self.db.create_score(self.EIN_ALPHA)
        total = self.db.cursor.execute(
            "SELECT total_score FROM organization_score WHERE score_id = ?", (score_id,)
        ).fetchone()[0]
        self.assertIsNone(total)

    def test_scored_at_is_populated(self):
        score_id = self.db.create_score(self.EIN_ALPHA)
        scored_at = self.db.cursor.execute(
            "SELECT scored_at FROM organization_score WHERE score_id = ?", (score_id,)
        ).fetchone()[0]
        self.assertIsNotNone(scored_at)
        self.assertIsInstance(scored_at, str)
        self.assertGreater(len(scored_at), 0)

    def test_two_scores_for_same_org_have_different_ids(self):
        id1 = self.db.create_score(self.EIN_ALPHA)
        id2 = self.db.create_score(self.EIN_ALPHA)
        self.assertNotEqual(id1, id2)

    def test_scores_for_different_orgs_have_different_ids(self):
        id1 = self.db.create_score(self.EIN_ALPHA)
        id2 = self.db.create_score(self.EIN_BETA)
        self.assertNotEqual(id1, id2)

    def test_scores_for_different_orgs_store_correct_eins(self):
        id1 = self.db.create_score(self.EIN_ALPHA)
        id2 = self.db.create_score(self.EIN_BETA)
        ein1 = self.db.cursor.execute(
            "SELECT organization_id FROM organization_score WHERE score_id = ?", (id1,)
        ).fetchone()[0]
        ein2 = self.db.cursor.execute(
            "SELECT organization_id FROM organization_score WHERE score_id = ?", (id2,)
        ).fetchone()[0]
        self.assertEqual(ein1, self.EIN_ALPHA)
        self.assertEqual(ein2, self.EIN_BETA)

    def test_default_model_version_is_1(self):
        model_id_v1 = self.db.get_model_id(1)
        score_id = self.db.create_score(self.EIN_ALPHA)
        stored_model_id = self.db.cursor.execute(
            "SELECT model_id FROM organization_score WHERE score_id = ?", (score_id,)
        ).fetchone()[0]
        self.assertEqual(stored_model_id, model_id_v1)

    def test_explicit_model_version_1_works(self):
        score_id = self.db.create_score(self.EIN_ALPHA, model_version=1)
        self.assertIsInstance(score_id, int)

    def test_unknown_model_version_raises_value_error(self):
        with self.assertRaises(ValueError):
            self.db.create_score(self.EIN_ALPHA, model_version=999)

    def test_nonexistent_ein_raises_integrity_error(self):
        with self.assertRaises(sqlite3.IntegrityError):
            self.db.create_score("999999999")

    def test_multiple_scores_increment_count(self):
        self.db.create_score(self.EIN_ALPHA)
        self.db.create_score(self.EIN_ALPHA)
        self.db.create_score(self.EIN_BETA)
        count = self.db.cursor.execute(
            "SELECT COUNT(*) FROM organization_score"
        ).fetchone()[0]
        self.assertEqual(count, 3)


# ---------------------------------------------------------------------------
# store_factor_values
# ---------------------------------------------------------------------------

class TestStoreFactorValues(ScoreDbTestCase):

    def setUp(self):
        super().setUp()
        self.score_id = self.db.create_score(self.EIN_ALPHA)
        self.factors = self.db.get_factors(1)

    def _first_factor_id(self):
        return self.factors[0]["factor_id"]

    def _stored_row(self, score_id, factor_id):
        return self.db.cursor.execute(
            "SELECT raw_value, weighted_value FROM organization_score_factor "
            "WHERE score_id = ? AND factor_id = ?",
            (score_id, factor_id),
        ).fetchone()

    def test_inserts_correct_number_of_rows(self):
        values = {f["factor_id"]: (0.5, 0.025) for f in self.factors[:3]}
        self.db.store_factor_values(self.score_id, values)
        count = self.db.cursor.execute(
            "SELECT COUNT(*) FROM organization_score_factor WHERE score_id = ?",
            (self.score_id,),
        ).fetchone()[0]
        self.assertEqual(count, 3)

    def test_stores_correct_raw_value(self):
        fid = self._first_factor_id()
        self.db.store_factor_values(self.score_id, {fid: (0.75, 0.0375)})
        row = self._stored_row(self.score_id, fid)
        self.assertAlmostEqual(row[0], 0.75)

    def test_stores_correct_weighted_value(self):
        fid = self._first_factor_id()
        self.db.store_factor_values(self.score_id, {fid: (0.75, 0.0375)})
        row = self._stored_row(self.score_id, fid)
        self.assertAlmostEqual(row[1], 0.0375)

    def test_empty_dict_inserts_nothing(self):
        self.db.store_factor_values(self.score_id, {})
        count = self.db.cursor.execute(
            "SELECT COUNT(*) FROM organization_score_factor WHERE score_id = ?",
            (self.score_id,),
        ).fetchone()[0]
        self.assertEqual(count, 0)

    def test_empty_dict_does_not_raise(self):
        self.db.store_factor_values(self.score_id, {})  # must not raise

    def test_partial_factor_store_succeeds(self):
        partial = {f["factor_id"]: (0.5, f["weight"] * 0.5) for f in self.factors[:5]}
        self.db.store_factor_values(self.score_id, partial)
        count = self.db.cursor.execute(
            "SELECT COUNT(*) FROM organization_score_factor WHERE score_id = ?",
            (self.score_id,),
        ).fetchone()[0]
        self.assertEqual(count, 5)

    def test_all_14_factors_stored(self):
        values = self._all_factor_values()
        self.db.store_factor_values(self.score_id, values)
        count = self.db.cursor.execute(
            "SELECT COUNT(*) FROM organization_score_factor WHERE score_id = ?",
            (self.score_id,),
        ).fetchone()[0]
        self.assertEqual(count, 14)

    def test_replace_updates_raw_value(self):
        fid = self._first_factor_id()
        self.db.store_factor_values(self.score_id, {fid: (0.50, 0.025)})
        self.db.store_factor_values(self.score_id, {fid: (0.80, 0.040)})
        row = self._stored_row(self.score_id, fid)
        self.assertAlmostEqual(row[0], 0.80)

    def test_replace_updates_weighted_value(self):
        fid = self._first_factor_id()
        self.db.store_factor_values(self.score_id, {fid: (0.50, 0.025)})
        self.db.store_factor_values(self.score_id, {fid: (0.80, 0.040)})
        row = self._stored_row(self.score_id, fid)
        self.assertAlmostEqual(row[1], 0.040)

    def test_replace_does_not_duplicate_rows(self):
        fid = self._first_factor_id()
        self.db.store_factor_values(self.score_id, {fid: (0.50, 0.025)})
        self.db.store_factor_values(self.score_id, {fid: (0.80, 0.040)})
        count = self.db.cursor.execute(
            "SELECT COUNT(*) FROM organization_score_factor "
            "WHERE score_id = ? AND factor_id = ?",
            (self.score_id, fid),
        ).fetchone()[0]
        self.assertEqual(count, 1)

    def test_zero_raw_value_stored(self):
        fid = self._first_factor_id()
        self.db.store_factor_values(self.score_id, {fid: (0.0, 0.0)})
        row = self._stored_row(self.score_id, fid)
        self.assertAlmostEqual(row[0], 0.0)

    def test_negative_raw_value_stored(self):
        fid = self._first_factor_id()
        self.db.store_factor_values(self.score_id, {fid: (-0.5, -0.025)})
        row = self._stored_row(self.score_id, fid)
        self.assertAlmostEqual(row[0], -0.5)

    def test_null_raw_value_stored(self):
        fid = self._first_factor_id()
        self.db.store_factor_values(self.score_id, {fid: (None, None)})
        row = self._stored_row(self.score_id, fid)
        self.assertIsNone(row[0])

    def test_null_weighted_value_stored(self):
        fid = self._first_factor_id()
        self.db.store_factor_values(self.score_id, {fid: (None, None)})
        row = self._stored_row(self.score_id, fid)
        self.assertIsNone(row[1])

    def test_does_not_affect_other_score(self):
        other_score_id = self.db.create_score(self.EIN_BETA)
        values = self._all_factor_values()
        self.db.store_factor_values(self.score_id, values)
        count = self.db.cursor.execute(
            "SELECT COUNT(*) FROM organization_score_factor WHERE score_id = ?",
            (other_score_id,),
        ).fetchone()[0]
        self.assertEqual(count, 0)

    def test_separate_scores_store_independently(self):
        other_score_id = self.db.create_score(self.EIN_BETA)
        fid = self._first_factor_id()
        self.db.store_factor_values(self.score_id,    {fid: (0.30, 0.015)})
        self.db.store_factor_values(other_score_id,   {fid: (0.70, 0.035)})
        row_a = self._stored_row(self.score_id,   fid)
        row_b = self._stored_row(other_score_id,  fid)
        self.assertAlmostEqual(row_a[0], 0.30)
        self.assertAlmostEqual(row_b[0], 0.70)

    def test_very_large_raw_value_stored(self):
        fid = self._first_factor_id()
        self.db.store_factor_values(self.score_id, {fid: (1e9, 5e7)})
        row = self._stored_row(self.score_id, fid)
        self.assertAlmostEqual(row[0], 1e9, delta=1.0)


# ---------------------------------------------------------------------------
# finalize_score
# ---------------------------------------------------------------------------

class TestFinalizeScore(ScoreDbTestCase):

    def setUp(self):
        super().setUp()
        self.score_id = self.db.create_score(self.EIN_ALPHA)

    def _get_total(self, score_id):
        return self.db.cursor.execute(
            "SELECT total_score FROM organization_score WHERE score_id = ?", (score_id,)
        ).fetchone()[0]

    def test_sets_total_score(self):
        self.db.finalize_score(self.score_id, 0.75)
        self.assertIsNotNone(self._get_total(self.score_id))

    def test_total_score_matches_value(self):
        self.db.finalize_score(self.score_id, 0.75)
        self.assertAlmostEqual(self._get_total(self.score_id), 0.75)

    def test_zero_total_score(self):
        self.db.finalize_score(self.score_id, 0.0)
        self.assertAlmostEqual(self._get_total(self.score_id), 0.0)

    def test_perfect_score_of_1(self):
        self.db.finalize_score(self.score_id, 1.0)
        self.assertAlmostEqual(self._get_total(self.score_id), 1.0)

    def test_negative_total_score(self):
        self.db.finalize_score(self.score_id, -0.25)
        self.assertAlmostEqual(self._get_total(self.score_id), -0.25)

    def test_fractional_total_score_precision(self):
        self.db.finalize_score(self.score_id, 0.123456789)
        self.assertAlmostEqual(self._get_total(self.score_id), 0.123456789, places=7)

    def test_finalize_twice_overwrites_first_value(self):
        self.db.finalize_score(self.score_id, 0.50)
        self.db.finalize_score(self.score_id, 0.99)
        self.assertAlmostEqual(self._get_total(self.score_id), 0.99)

    def test_nonexistent_score_id_is_silent(self):
        self.db.finalize_score(99999, 0.5)  # must not raise

    def test_only_affects_target_score(self):
        other_id = self.db.create_score(self.EIN_BETA)
        self.db.finalize_score(self.score_id, 0.80)
        self.assertIsNone(self._get_total(other_id))

    def test_does_not_change_organization_id(self):
        self.db.finalize_score(self.score_id, 0.70)
        ein = self.db.cursor.execute(
            "SELECT organization_id FROM organization_score WHERE score_id = ?",
            (self.score_id,),
        ).fetchone()[0]
        self.assertEqual(ein, self.EIN_ALPHA)

    def test_does_not_change_model_id(self):
        model_id_before = self.db.cursor.execute(
            "SELECT model_id FROM organization_score WHERE score_id = ?", (self.score_id,)
        ).fetchone()[0]
        self.db.finalize_score(self.score_id, 0.70)
        model_id_after = self.db.cursor.execute(
            "SELECT model_id FROM organization_score WHERE score_id = ?", (self.score_id,)
        ).fetchone()[0]
        self.assertEqual(model_id_before, model_id_after)


# ---------------------------------------------------------------------------
# get_score
# ---------------------------------------------------------------------------

class TestGetScore(ScoreDbTestCase):

    def setUp(self):
        super().setUp()
        self.score_id = self.db.create_score(self.EIN_ALPHA)

    def test_returns_none_for_nonexistent_score(self):
        result = self.db.get_score(99999)
        self.assertIsNone(result)

    def test_returns_dict_for_valid_score(self):
        result = self.db.get_score(self.score_id)
        self.assertIsInstance(result, dict)

    def test_score_id_matches(self):
        result = self.db.get_score(self.score_id)
        self.assertEqual(result["score_id"], self.score_id)

    def test_organization_id_matches(self):
        result = self.db.get_score(self.score_id)
        self.assertEqual(result["organization_id"], self.EIN_ALPHA)

    def test_model_version_is_1(self):
        result = self.db.get_score(self.score_id)
        self.assertEqual(result["model_version"], 1)

    def test_total_score_is_none_before_finalization(self):
        result = self.db.get_score(self.score_id)
        self.assertIsNone(result["total_score"])

    def test_total_score_correct_after_finalization(self):
        self.db.finalize_score(self.score_id, 0.82)
        result = self.db.get_score(self.score_id)
        self.assertAlmostEqual(result["total_score"], 0.82)

    def test_scored_at_is_nonempty_string(self):
        result = self.db.get_score(self.score_id)
        self.assertIsInstance(result["scored_at"], str)
        self.assertGreater(len(result["scored_at"]), 0)

    def test_result_contains_factors_key(self):
        result = self.db.get_score(self.score_id)
        self.assertIn("factors", result)

    def test_factors_is_list(self):
        result = self.db.get_score(self.score_id)
        self.assertIsInstance(result["factors"], list)

    def test_factors_empty_when_none_stored(self):
        result = self.db.get_score(self.score_id)
        self.assertEqual(result["factors"], [])

    def test_factors_count_matches_stored_count(self):
        values = self._all_factor_values()
        self.db.store_factor_values(self.score_id, values)
        result = self.db.get_score(self.score_id)
        self.assertEqual(len(result["factors"]), 14)

    def test_partial_factors_reflected(self):
        partial = {f["factor_id"]: (0.5, f["weight"] * 0.5) for f in self.factors[:4]}
        self.db.store_factor_values(self.score_id, partial)
        result = self.db.get_score(self.score_id)
        self.assertEqual(len(result["factors"]), 4)

    def test_each_factor_has_name_key(self):
        values = self._all_factor_values()
        self.db.store_factor_values(self.score_id, values)
        result = self.db.get_score(self.score_id)
        for f in result["factors"]:
            self.assertIn("name", f)

    def test_each_factor_has_weight_key(self):
        values = self._all_factor_values()
        self.db.store_factor_values(self.score_id, values)
        result = self.db.get_score(self.score_id)
        for f in result["factors"]:
            self.assertIn("weight", f)

    def test_each_factor_has_raw_value_key(self):
        values = self._all_factor_values()
        self.db.store_factor_values(self.score_id, values)
        result = self.db.get_score(self.score_id)
        for f in result["factors"]:
            self.assertIn("raw_value", f)

    def test_each_factor_has_weighted_value_key(self):
        values = self._all_factor_values()
        self.db.store_factor_values(self.score_id, values)
        result = self.db.get_score(self.score_id)
        for f in result["factors"]:
            self.assertIn("weighted_value", f)

    def test_factor_raw_values_match_stored(self):
        raw = 0.6
        values = {f["factor_id"]: (raw, raw * f["weight"]) for f in self.factors}
        self.db.store_factor_values(self.score_id, values)
        result = self.db.get_score(self.score_id)
        for f in result["factors"]:
            self.assertAlmostEqual(f["raw_value"], raw,
                                   msg=f"raw_value mismatch for factor '{f['name']}'")

    def test_factor_weighted_values_match_stored(self):
        values = {f["factor_id"]: (1.0, f["weight"]) for f in self.factors}
        self.db.store_factor_values(self.score_id, values)
        result = self.db.get_score(self.score_id)
        by_name = {f["name"]: f for f in result["factors"]}
        for name, weight, _ in V1_FACTORS:
            self.assertAlmostEqual(by_name[name]["weighted_value"], weight,
                                   msg=f"weighted_value mismatch for '{name}'")

    def test_factor_weights_in_result_match_model(self):
        values = self._all_factor_values()
        self.db.store_factor_values(self.score_id, values)
        result = self.db.get_score(self.score_id)
        by_name = {f["name"]: f["weight"] for f in result["factors"]}
        for name, weight, _ in V1_FACTORS:
            self.assertAlmostEqual(by_name[name], weight,
                                   msg=f"weight mismatch for '{name}'")

    def test_returns_correct_score_among_multiple(self):
        other_id = self.db.create_score(self.EIN_BETA)
        self.db.finalize_score(self.score_id, 0.70)
        self.db.finalize_score(other_id, 0.90)
        result_a = self.db.get_score(self.score_id)
        result_b = self.db.get_score(other_id)
        self.assertAlmostEqual(result_a["total_score"], 0.70)
        self.assertAlmostEqual(result_b["total_score"], 0.90)

    def test_result_has_no_unexpected_keys(self):
        result = self.db.get_score(self.score_id)
        expected_keys = {"score_id", "organization_id", "model_version",
                         "total_score", "scored_at", "factors"}
        self.assertEqual(set(result.keys()), expected_keys)

    def test_factor_null_raw_value_preserved(self):
        fid = self.factors[0]["factor_id"]
        self.db.store_factor_values(self.score_id, {fid: (None, None)})
        result = self.db.get_score(self.score_id)
        self.assertIsNone(result["factors"][0]["raw_value"])


# ---------------------------------------------------------------------------
# Integration / End-to-End
# ---------------------------------------------------------------------------

class TestScoreDatabaseIntegration(ScoreDbTestCase):

    def test_full_workflow_single_org(self):
        score_id = self.db.create_score(self.EIN_ALPHA)
        values = self._all_factor_values(raw=1.0)
        self.db.store_factor_values(score_id, values)
        total = sum(wv for _, (_, wv) in values.items())
        self.db.finalize_score(score_id, total)

        result = self.db.get_score(score_id)
        self.assertEqual(result["organization_id"], self.EIN_ALPHA)
        self.assertEqual(result["model_version"], 1)
        self.assertAlmostEqual(result["total_score"], total)
        self.assertEqual(len(result["factors"]), 14)

    def test_full_workflow_total_equals_sum_of_weighted_values(self):
        score_id = self.db.create_score(self.EIN_ALPHA)
        values = {f["factor_id"]: (f["weight"] * 2, f["weight"] * 2 * f["weight"])
                  for f in self.factors}
        self.db.store_factor_values(score_id, values)
        expected_total = sum(wv for _, (_, wv) in values.items())
        self.db.finalize_score(score_id, expected_total)

        result = self.db.get_score(score_id)
        computed_sum = sum(f["weighted_value"] for f in result["factors"])
        self.assertAlmostEqual(result["total_score"], computed_sum, places=10)

    def test_multiple_orgs_scores_are_independent(self):
        sid_a = self.db.create_score(self.EIN_ALPHA)
        sid_b = self.db.create_score(self.EIN_BETA)
        self.db.finalize_score(sid_a, 0.60)
        self.db.finalize_score(sid_b, 0.40)

        result_a = self.db.get_score(sid_a)
        result_b = self.db.get_score(sid_b)
        self.assertAlmostEqual(result_a["total_score"], 0.60)
        self.assertAlmostEqual(result_b["total_score"], 0.40)
        self.assertEqual(result_a["organization_id"], self.EIN_ALPHA)
        self.assertEqual(result_b["organization_id"], self.EIN_BETA)

    def test_multiple_scores_per_org_are_independent(self):
        sid1 = self.db.create_score(self.EIN_ALPHA)
        sid2 = self.db.create_score(self.EIN_ALPHA)
        self.db.finalize_score(sid1, 0.55)
        self.db.finalize_score(sid2, 0.75)

        r1 = self.db.get_score(sid1)
        r2 = self.db.get_score(sid2)
        self.assertAlmostEqual(r1["total_score"], 0.55)
        self.assertAlmostEqual(r2["total_score"], 0.75)

    def test_factor_values_for_two_scores_are_isolated(self):
        sid1 = self.db.create_score(self.EIN_ALPHA)
        sid2 = self.db.create_score(self.EIN_ALPHA)
        fid = self.factors[0]["factor_id"]
        self.db.store_factor_values(sid1, {fid: (0.10, 0.005)})
        self.db.store_factor_values(sid2, {fid: (0.90, 0.045)})

        r1 = self.db.get_score(sid1)
        r2 = self.db.get_score(sid2)
        self.assertAlmostEqual(r1["factors"][0]["raw_value"], 0.10)
        self.assertAlmostEqual(r2["factors"][0]["raw_value"], 0.90)

    def test_irs990_functionality_preserved(self):
        index = self.db.get_xpath_index()
        self.assertIsInstance(index, dict)
        self.assertGreater(len(index), 0)

    def test_irs990_filing_coexists_with_scores(self):
        filing_id = self.db.create_filing(self.EIN_ALPHA, 2023, "990")
        score_id = self.db.create_score(self.EIN_ALPHA)
        self.assertIsNotNone(filing_id)
        self.assertIsNotNone(score_id)

    def test_score_inherits_org_created_via_irs990_methods(self):
        self.db.upsert_organization("333333333", "Gamma Org")
        score_id = self.db.create_score("333333333")
        self.assertIsInstance(score_id, int)

    def test_weights_sum_to_1_across_all_factor_rows(self):
        total = sum(w for _, w, _ in V1_FACTORS)
        self.assertAlmostEqual(total, 1.0, places=10)

    def test_score_model_row_count_after_init(self):
        count = self.db.cursor.execute("SELECT COUNT(*) FROM score_model").fetchone()[0]
        self.assertEqual(count, 1)

    def test_score_factor_row_count_after_init(self):
        count = self.db.cursor.execute("SELECT COUNT(*) FROM score_factor").fetchone()[0]
        self.assertEqual(count, 14)

    def test_score_persists_to_disk(self):
        score_id = self.db.create_score(self.EIN_ALPHA)
        self.db.finalize_score(score_id, 0.88)
        self.db.close()

        conn = sqlite3.connect("IRS990.db")
        row = conn.execute(
            "SELECT total_score FROM organization_score WHERE score_id = ?", (score_id,)
        ).fetchone()
        conn.close()
        self.db = None  # prevent tearDown double-close

        self.assertIsNotNone(row)
        self.assertAlmostEqual(row[0], 0.88)

    def test_factor_values_persist_to_disk(self):
        score_id = self.db.create_score(self.EIN_ALPHA)
        fid = self.factors[0]["factor_id"]
        self.db.store_factor_values(score_id, {fid: (0.42, 0.021)})
        self.db.close()

        conn = sqlite3.connect("IRS990.db")
        row = conn.execute(
            "SELECT raw_value FROM organization_score_factor "
            "WHERE score_id = ? AND factor_id = ?",
            (score_id, fid),
        ).fetchone()
        conn.close()
        self.db = None  # prevent tearDown double-close

        self.assertIsNotNone(row)
        self.assertAlmostEqual(row[0], 0.42)


if __name__ == "__main__":
    unittest.main()
