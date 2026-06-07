import sys
import os
import hashlib
import unittest

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

from database.IRS990 import IRS990Database


class TestApiKeyBase(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        cls.db = IRS990Database(path=":memory:")

    @classmethod
    def tearDownClass(cls):
        cls.db.close()

    def setUp(self):
        self.db.cursor.executescript("DELETE FROM api_key;")


class TestCreateApiKey(TestApiKeyBase):
    def test_returns_tuple(self):
        result = self.db.create_api_key("test-key")
        self.assertIsInstance(result, tuple)
        self.assertEqual(len(result), 2)

    def test_first_element_is_int(self):
        key_id, _ = self.db.create_api_key("test-key")
        self.assertIsInstance(key_id, int)

    def test_second_element_is_str(self):
        _, raw = self.db.create_api_key("test-key")
        self.assertIsInstance(raw, str)

    def test_raw_key_not_stored_directly(self):
        _, raw = self.db.create_api_key("test-key")
        row = self.db.cursor.execute(
            "SELECT key_hash FROM api_key WHERE name = ?", ("test-key",)
        ).fetchone()
        self.assertIsNotNone(row)
        self.assertNotEqual(row[0], raw)

    def test_sha256_hash_stored(self):
        _, raw = self.db.create_api_key("test-key")
        expected_hash = hashlib.sha256(raw.encode()).hexdigest()
        row = self.db.cursor.execute(
            "SELECT key_hash FROM api_key WHERE name = ?", ("test-key",)
        ).fetchone()
        self.assertEqual(row[0], expected_hash)

    def test_key_active_by_default(self):
        key_id, _ = self.db.create_api_key("test-key")
        row = self.db.cursor.execute(
            "SELECT active FROM api_key WHERE key_id = ?", (key_id,)
        ).fetchone()
        self.assertEqual(row[0], 1)

    def test_two_creates_return_different_keys(self):
        _, raw1 = self.db.create_api_key("key-one")
        _, raw2 = self.db.create_api_key("key-two")
        self.assertNotEqual(raw1, raw2)

    def test_two_creates_return_different_ids(self):
        id1, _ = self.db.create_api_key("key-one")
        id2, _ = self.db.create_api_key("key-two")
        self.assertNotEqual(id1, id2)


class TestValidateApiKey(TestApiKeyBase):
    def setUp(self):
        super().setUp()
        self.key_id, self.raw = self.db.create_api_key("valid-key")

    def test_valid_key_returns_true(self):
        self.assertTrue(self.db.validate_api_key(self.raw))

    def test_invalid_key_returns_false(self):
        self.assertFalse(self.db.validate_api_key("not-a-real-key"))

    def test_empty_string_returns_false(self):
        self.assertFalse(self.db.validate_api_key(""))

    def test_revoked_key_returns_false(self):
        self.db.revoke_api_key(self.key_id)
        self.assertFalse(self.db.validate_api_key(self.raw))

    def test_valid_use_updates_last_used_at(self):
        before = self.db.cursor.execute(
            "SELECT last_used_at FROM api_key WHERE key_id = ?", (self.key_id,)
        ).fetchone()[0]
        self.assertIsNone(before)
        self.db.validate_api_key(self.raw)
        after = self.db.cursor.execute(
            "SELECT last_used_at FROM api_key WHERE key_id = ?", (self.key_id,)
        ).fetchone()[0]
        self.assertIsNotNone(after)

    def test_invalid_key_does_not_update_last_used_at(self):
        self.db.validate_api_key("wrong-key")
        row = self.db.cursor.execute(
            "SELECT last_used_at FROM api_key WHERE key_id = ?", (self.key_id,)
        ).fetchone()[0]
        self.assertIsNone(row)


class TestListApiKeys(TestApiKeyBase):
    def test_empty_initially(self):
        self.assertEqual(self.db.list_api_keys(), [])

    def test_returns_created_key(self):
        self.db.create_api_key("my-key")
        keys = self.db.list_api_keys()
        self.assertEqual(len(keys), 1)

    def test_has_required_fields(self):
        self.db.create_api_key("my-key")
        key = self.db.list_api_keys()[0]
        for field in ("key_id", "name", "created_at", "last_used_at", "active"):
            self.assertIn(field, key)

    def test_correct_name(self):
        self.db.create_api_key("my-key")
        key = self.db.list_api_keys()[0]
        self.assertEqual(key["name"], "my-key")

    def test_active_true_by_default(self):
        self.db.create_api_key("my-key")
        key = self.db.list_api_keys()[0]
        self.assertTrue(key["active"])

    def test_last_used_at_none_initially(self):
        self.db.create_api_key("my-key")
        key = self.db.list_api_keys()[0]
        self.assertIsNone(key["last_used_at"])

    def test_includes_revoked_keys(self):
        key_id, _ = self.db.create_api_key("my-key")
        self.db.revoke_api_key(key_id)
        keys = self.db.list_api_keys()
        self.assertEqual(len(keys), 1)
        self.assertFalse(keys[0]["active"])

    def test_ordered_by_key_id(self):
        self.db.create_api_key("alpha")
        self.db.create_api_key("beta")
        self.db.create_api_key("gamma")
        keys = self.db.list_api_keys()
        ids = [k["key_id"] for k in keys]
        self.assertEqual(ids, sorted(ids))

    def test_multiple_keys_all_returned(self):
        self.db.create_api_key("a")
        self.db.create_api_key("b")
        self.db.create_api_key("c")
        self.assertEqual(len(self.db.list_api_keys()), 3)


class TestRevokeApiKey(TestApiKeyBase):
    def test_returns_true_for_existing_key(self):
        key_id, _ = self.db.create_api_key("my-key")
        self.assertTrue(self.db.revoke_api_key(key_id))

    def test_returns_false_for_nonexistent_key(self):
        self.assertFalse(self.db.revoke_api_key(99999))

    def test_sets_active_to_zero(self):
        key_id, _ = self.db.create_api_key("my-key")
        self.db.revoke_api_key(key_id)
        row = self.db.cursor.execute(
            "SELECT active FROM api_key WHERE key_id = ?", (key_id,)
        ).fetchone()
        self.assertEqual(row[0], 0)

    def test_validate_returns_false_after_revoke(self):
        key_id, raw = self.db.create_api_key("my-key")
        self.assertTrue(self.db.validate_api_key(raw))
        self.db.revoke_api_key(key_id)
        self.assertFalse(self.db.validate_api_key(raw))

    def test_does_not_affect_other_keys(self):
        id1, raw1 = self.db.create_api_key("key-one")
        _id2, raw2 = self.db.create_api_key("key-two")
        self.db.revoke_api_key(id1)
        self.assertFalse(self.db.validate_api_key(raw1))
        self.assertTrue(self.db.validate_api_key(raw2))


if __name__ == "__main__":
    unittest.main()
