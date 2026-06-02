import sys
import os
import tempfile
import unittest

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

from database.IRS990 import IRS990Database


class TestIRS990Database(unittest.TestCase):
    def setUp(self):
        self._tmpdir = tempfile.TemporaryDirectory()
        self._orig_cwd = os.getcwd()
        os.chdir(self._tmpdir.name)
        self.db = IRS990Database()

    def tearDown(self):
        self.db.close()
        os.chdir(self._orig_cwd)
        self._tmpdir.cleanup()

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


if __name__ == "__main__":
    unittest.main()
