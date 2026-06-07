import sys
import os
import unittest

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

from database.IRS990 import IRS990Database


class TestIRS990Database(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        cls.db = IRS990Database(path=":memory:")

    @classmethod
    def tearDownClass(cls):
        cls.db.close()

    def setUp(self):
        self.db.cursor.executescript(
            "DELETE FROM reported_data; DELETE FROM filing; DELETE FROM organization;"
        )

    # --- get_xpath_index ---

    def test_xpath_index_is_nonempty_dict(self):
        index = self.db.get_xpath_index()
        self.assertIsInstance(index, dict)
        self.assertGreater(len(index), 0)

    def test_xpath_index_keys_are_strings(self):
        index = self.db.get_xpath_index()
        for key in list(index.keys())[:5]:
            self.assertIsInstance(key, str)

    def test_xpath_index_values_are_ints(self):
        index = self.db.get_xpath_index()
        for val in list(index.values())[:5]:
            self.assertIsInstance(val, int)

    def test_known_xpath_present(self):
        index = self.db.get_xpath_index()
        self.assertIn("ReturnData/IRS990/ActivityOrMissionDesc", index)

    # --- upsert_organization ---

    def test_upsert_creates_organization(self):
        self.db.upsert_organization("123456789", "Test Org")
        row = self.db.cursor.execute(
            "SELECT ein, name FROM organization WHERE ein = ?", ("123456789",)
        ).fetchone()
        self.assertIsNotNone(row)
        self.assertEqual(row[0], "123456789")
        self.assertEqual(row[1], "Test Org")

    def test_upsert_is_idempotent(self):
        self.db.upsert_organization("123456789", "Test Org")
        self.db.upsert_organization("123456789", "Test Org")
        count = self.db.cursor.execute(
            "SELECT COUNT(*) FROM organization WHERE ein = ?", ("123456789",)
        ).fetchone()[0]
        self.assertEqual(count, 1)

    def test_upsert_multiple_organizations(self):
        self.db.upsert_organization("111111111", "Org One")
        self.db.upsert_organization("222222222", "Org Two")
        count = self.db.cursor.execute("SELECT COUNT(*) FROM organization").fetchone()[0]
        self.assertEqual(count, 2)

    # --- create_filing ---

    def test_create_filing_returns_string(self):
        self.db.upsert_organization("123456789", "Test Org")
        filing_id = self.db.create_filing("123456789", 2023, "990")
        self.assertIsInstance(filing_id, str)
        self.assertGreater(len(filing_id), 0)

    def test_create_filing_returns_uuid_format(self):
        self.db.upsert_organization("123456789", "Test Org")
        filing_id = self.db.create_filing("123456789", 2023, "990")
        import uuid
        uuid.UUID(filing_id)  # raises ValueError if not a valid UUID

    def test_create_filing_stores_correct_data(self):
        self.db.upsert_organization("123456789", "Test Org")
        filing_id = self.db.create_filing("123456789", 2023, "990")
        row = self.db.cursor.execute(
            "SELECT year, organization_id, form_code FROM filing WHERE uuid = ?",
            (filing_id,),
        ).fetchone()
        self.assertIsNotNone(row)
        self.assertEqual(row[0], 2023)
        self.assertEqual(row[1], "123456789")
        self.assertEqual(row[2], "990")

    def test_create_filing_returns_unique_ids(self):
        self.db.upsert_organization("123456789", "Test Org")
        id1 = self.db.create_filing("123456789", 2022, "990")
        id2 = self.db.create_filing("123456789", 2023, "990")
        self.assertNotEqual(id1, id2)

    def test_create_filing_idempotent_on_duplicate(self):
        self.db.upsert_organization("123456789", "Test Org")
        id1 = self.db.create_filing("123456789", 2023, "990")
        id2 = self.db.create_filing("123456789", 2023, "990")
        self.assertEqual(id1, id2)

    def test_create_filing_allows_different_form_same_year(self):
        self.db.upsert_organization("123456789", "Test Org")
        id1 = self.db.create_filing("123456789", 2023, "990")
        id2 = self.db.create_filing("123456789", 2023, "990EZ")
        self.assertNotEqual(id1, id2)

    # --- store_reported_data ---

    def test_store_reported_data_inserts_rows(self):
        self.db.upsert_organization("123456789", "Test Org")
        filing_id = self.db.create_filing("123456789", 2023, "990")

        xpath_index = self.db.get_xpath_index()
        field_ids = list(xpath_index.values())[:3]
        values = {fid: f"value_{fid}" for fid in field_ids}

        self.db.store_reported_data(filing_id, values)

        count = self.db.cursor.execute(
            "SELECT COUNT(*) FROM reported_data WHERE filing_id = ?", (filing_id,)
        ).fetchone()[0]
        self.assertEqual(count, len(values))

    def test_store_reported_data_stores_correct_values(self):
        self.db.upsert_organization("123456789", "Test Org")
        filing_id = self.db.create_filing("123456789", 2023, "990")

        xpath_index = self.db.get_xpath_index()
        field_id = list(xpath_index.values())[0]

        self.db.store_reported_data(filing_id, {field_id: "expected value"})

        raw = self.db.cursor.execute(
            "SELECT raw_value FROM reported_data WHERE filing_id = ? AND field_id = ?",
            (filing_id, field_id),
        ).fetchone()[0]
        self.assertEqual(raw, "expected value")

    def test_store_reported_data_is_idempotent(self):
        self.db.upsert_organization("123456789", "Test Org")
        filing_id = self.db.create_filing("123456789", 2023, "990")

        xpath_index = self.db.get_xpath_index()
        field_id = list(xpath_index.values())[0]
        values = {field_id: "value"}

        self.db.store_reported_data(filing_id, values)
        self.db.store_reported_data(filing_id, values)  # should not raise

        count = self.db.cursor.execute(
            "SELECT COUNT(*) FROM reported_data WHERE filing_id = ?", (filing_id,)
        ).fetchone()[0]
        self.assertEqual(count, 1)

    def test_store_reported_data_empty_dict(self):
        self.db.upsert_organization("123456789", "Test Org")
        filing_id = self.db.create_filing("123456789", 2023, "990")
        self.db.store_reported_data(filing_id, {})  # should not raise


# --- list_organizations ---

class TestIRS990DatabaseListMethods(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        cls.db = IRS990Database(path=":memory:")

    @classmethod
    def tearDownClass(cls):
        cls.db.close()

    def setUp(self):
        self.db.cursor.executescript(
            "DELETE FROM reported_data; DELETE FROM filing; DELETE FROM organization;"
        )

    def test_list_organizations_empty(self):
        result = self.db.list_organizations()
        self.assertEqual(result, [])

    def test_list_organizations_returns_inserted(self):
        self.db.upsert_organization("111111111", "Alpha Org")
        result = self.db.list_organizations()
        self.assertEqual(len(result), 1)
        self.assertEqual(result[0]["ein"], "111111111")

    def test_list_organizations_multiple(self):
        self.db.upsert_organization("111111111", "Alpha Org")
        self.db.upsert_organization("222222222", "Beta Org")
        result = self.db.list_organizations()
        self.assertEqual(len(result), 2)

    def test_list_organizations_has_expected_keys(self):
        self.db.upsert_organization("111111111", "Alpha Org")
        result = self.db.list_organizations()
        self.assertIn("ein", result[0])
        self.assertIn("name", result[0])
        self.assertIn("created_at", result[0])
        self.assertIn("updated_at", result[0])

    # --- get_organization ---

    def test_get_organization_found(self):
        self.db.upsert_organization("111111111", "Alpha Org")
        result = self.db.get_organization("111111111")
        self.assertIsNotNone(result)
        self.assertEqual(result["ein"], "111111111")
        self.assertEqual(result["name"], "Alpha Org")

    def test_get_organization_not_found_returns_none(self):
        result = self.db.get_organization("999999999")
        self.assertIsNone(result)

    # --- list_filings ---

    def test_list_filings_empty(self):
        self.db.upsert_organization("111111111", "Alpha Org")
        result = self.db.list_filings("111111111")
        self.assertEqual(result, [])

    def test_list_filings_returns_inserted(self):
        self.db.upsert_organization("111111111", "Alpha Org")
        self.db.create_filing("111111111", 2023, "990")
        result = self.db.list_filings("111111111")
        self.assertEqual(len(result), 1)
        self.assertEqual(result[0]["year"], 2023)
        self.assertEqual(result[0]["form_code"], "990")

    def test_list_filings_has_expected_keys(self):
        self.db.upsert_organization("111111111", "Alpha Org")
        self.db.create_filing("111111111", 2023, "990")
        result = self.db.list_filings("111111111")
        for key in ("filing_id", "year", "form_code", "created_at"):
            self.assertIn(key, result[0])

    def test_list_filings_only_returns_own_org(self):
        self.db.upsert_organization("111111111", "Alpha Org")
        self.db.upsert_organization("222222222", "Beta Org")
        self.db.create_filing("111111111", 2023, "990")
        self.db.create_filing("222222222", 2023, "990")
        result = self.db.list_filings("111111111")
        self.assertEqual(len(result), 1)

    # --- get_filing ---

    def test_get_filing_found(self):
        self.db.upsert_organization("111111111", "Alpha Org")
        fid = self.db.create_filing("111111111", 2023, "990")
        result = self.db.get_filing(fid)
        self.assertIsNotNone(result)
        self.assertEqual(result["filing_id"], fid)
        self.assertEqual(result["ein"], "111111111")

    def test_get_filing_not_found_returns_none(self):
        result = self.db.get_filing("00000000-0000-0000-0000-000000000000")
        self.assertIsNone(result)

    def test_get_filing_has_expected_keys(self):
        self.db.upsert_organization("111111111", "Alpha Org")
        fid = self.db.create_filing("111111111", 2023, "990")
        result = self.db.get_filing(fid)
        for key in ("filing_id", "year", "ein", "form_code", "created_at"):
            self.assertIn(key, result)

    # --- get_filing_data_by_ein_year ---

    def test_get_filing_data_by_ein_year_not_found_returns_none(self):
        result = self.db.get_filing_data_by_ein_year("999999999", 2023)
        self.assertIsNone(result)

    def test_get_filing_data_by_ein_year_found(self):
        self.db.upsert_organization("111111111", "Alpha Org")
        self.db.create_filing("111111111", 2023, "990")
        result = self.db.get_filing_data_by_ein_year("111111111", 2023)
        self.assertIsNotNone(result)
        self.assertEqual(result["ein"], "111111111")
        self.assertEqual(result["year"], 2023)

    def test_get_filing_data_by_ein_year_includes_fields(self):
        self.db.upsert_organization("111111111", "Alpha Org")
        self.db.create_filing("111111111", 2023, "990")
        result = self.db.get_filing_data_by_ein_year("111111111", 2023)
        self.assertIn("fields", result)
        self.assertIsInstance(result["fields"], list)

    def test_get_filing_data_by_ein_year_wrong_year_returns_none(self):
        self.db.upsert_organization("111111111", "Alpha Org")
        self.db.create_filing("111111111", 2023, "990")
        result = self.db.get_filing_data_by_ein_year("111111111", 2022)
        self.assertIsNone(result)

    # --- get_supported_forms ---

    def test_get_supported_forms_returns_set(self):
        result = self.db.get_supported_forms()
        self.assertIsInstance(result, set)

    def test_get_supported_forms_contains_990(self):
        result = self.db.get_supported_forms()
        self.assertIn("990", result)


if __name__ == "__main__":
    unittest.main()
