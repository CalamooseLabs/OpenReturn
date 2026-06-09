import contextlib
import io
import sys
import os
import sqlite3
import tempfile
import unittest
from unittest.mock import MagicMock, patch

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

import database.base as db_base
from database.IRS990 import IRS990Database


# ---------------------------------------------------------------------------
# _open_connection
# ---------------------------------------------------------------------------

class TestOpenConnection(unittest.TestCase):

    def setUp(self):
        # Ensure DB_SECRET_KEY is absent between tests
        os.environ.pop('DB_SECRET_KEY', None)

    def tearDown(self):
        os.environ.pop('DB_SECRET_KEY', None)

    def test_no_key_returns_plain_sqlite(self):
        conn = db_base._open_connection(':memory:')
        self.assertIsInstance(conn, sqlite3.Connection)
        conn.close()

    def test_key_set_no_cipher_warns_and_falls_back(self):
        os.environ['DB_SECRET_KEY'] = 'testpassword'
        stderr_buf = io.StringIO()
        with patch.object(db_base, '_HAS_CIPHER', False), \
             contextlib.redirect_stderr(stderr_buf):
            conn = db_base._open_connection(':memory:')
        self.assertIsInstance(conn, sqlite3.Connection)
        self.assertIn('sqlcipher3', stderr_buf.getvalue())
        conn.close()

    def test_key_set_with_cipher_uses_cipher_connect(self):
        os.environ['DB_SECRET_KEY'] = 'testpassword'
        mock_conn = MagicMock()
        mock_cipher = MagicMock()
        mock_cipher.connect.return_value = mock_conn
        with patch.object(db_base, '_HAS_CIPHER', True), \
             patch.object(db_base, '_sqlcipher', mock_cipher):
            result = db_base._open_connection(':memory:')
        mock_cipher.connect.assert_called_once_with(':memory:')
        mock_conn.execute.assert_called_once_with("PRAGMA key='testpassword'")
        self.assertIs(result, mock_conn)

    def test_key_with_single_quote_is_escaped(self):
        os.environ['DB_SECRET_KEY'] = "pa'ss"
        mock_conn = MagicMock()
        mock_cipher = MagicMock()
        mock_cipher.connect.return_value = mock_conn
        with patch.object(db_base, '_HAS_CIPHER', True), \
             patch.object(db_base, '_sqlcipher', mock_cipher):
            db_base._open_connection(':memory:')
        mock_conn.execute.assert_called_once_with("PRAGMA key='pa''ss'")


# ---------------------------------------------------------------------------
# _resolve_db_key — DB_SECRET_KEY vs DB_SECRET_KEY_FILE
# ---------------------------------------------------------------------------

class TestResolveDbKey(unittest.TestCase):

    def setUp(self):
        for v in ('DB_SECRET_KEY', 'DB_SECRET_KEY_FILE'):
            os.environ.pop(v, None)

    def tearDown(self):
        for v in ('DB_SECRET_KEY', 'DB_SECRET_KEY_FILE'):
            os.environ.pop(v, None)

    def test_none_when_unset(self):
        self.assertIsNone(db_base._resolve_db_key())

    def test_direct_env_key(self):
        with patch.dict(os.environ, {'DB_SECRET_KEY': 'direct'}):
            self.assertEqual(db_base._resolve_db_key(), 'direct')

    def test_file_key_is_read_and_stripped(self):
        with tempfile.TemporaryDirectory() as td:
            p = os.path.join(td, 'key')
            with open(p, 'w') as f:
                f.write('  filekey\n')
            with patch.dict(os.environ, {'DB_SECRET_KEY_FILE': p}):
                self.assertEqual(db_base._resolve_db_key(), 'filekey')

    def test_direct_env_wins_over_file(self):
        with tempfile.TemporaryDirectory() as td:
            p = os.path.join(td, 'key')
            with open(p, 'w') as f:
                f.write('filekey')
            with patch.dict(os.environ, {'DB_SECRET_KEY': 'direct', 'DB_SECRET_KEY_FILE': p}):
                self.assertEqual(db_base._resolve_db_key(), 'direct')

    def test_empty_file_is_none(self):
        with tempfile.TemporaryDirectory() as td:
            p = os.path.join(td, 'key')
            with open(p, 'w') as f:
                f.write('   \n')
            with patch.dict(os.environ, {'DB_SECRET_KEY_FILE': p}):
                self.assertIsNone(db_base._resolve_db_key())

    def test_unreadable_file_warns_and_returns_none(self):
        with patch.dict(os.environ, {'DB_SECRET_KEY_FILE': '/no/such/openreturn/key'}):
            err = io.StringIO()
            with contextlib.redirect_stderr(err):
                result = db_base._resolve_db_key()
            self.assertIsNone(result)
            self.assertIn('could not be read', err.getvalue())


class TestDatabaseBase(unittest.TestCase):

    def setUp(self):
        self.db = IRS990Database(path=":memory:")

    def tearDown(self):
        self.db.close()

    def test_commit_does_not_raise(self):
        self.db.commit()

    def test_begin_and_end_bulk_load(self):
        self.db.begin_bulk_load()
        self.db.end_bulk_load()


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
            "SELECT COUNT(*) FROM reported_data rd JOIN filing f ON f.filing_id = rd.filing_id "
            "WHERE f.uuid = ?", (filing_id,)
        ).fetchone()[0]
        self.assertEqual(count, len(values))

    def test_store_reported_data_stores_correct_values(self):
        self.db.upsert_organization("123456789", "Test Org")
        filing_id = self.db.create_filing("123456789", 2023, "990")

        xpath_index = self.db.get_xpath_index()
        field_id = list(xpath_index.values())[0]

        self.db.store_reported_data(filing_id, {field_id: "expected value"})

        raw = self.db.cursor.execute(
            "SELECT rd.raw_value FROM reported_data rd JOIN filing f ON f.filing_id = rd.filing_id "
            "WHERE f.uuid = ? AND rd.field_id = ?",
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
            "SELECT COUNT(*) FROM reported_data rd JOIN filing f ON f.filing_id = rd.filing_id "
            "WHERE f.uuid = ?", (filing_id,)
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
        self.assertEqual(result["organizations"], [])
        self.assertEqual(result["total"], 0)

    def test_list_organizations_returns_inserted(self):
        self.db.upsert_organization("111111111", "Alpha Org")
        result = self.db.list_organizations()
        self.assertEqual(result["total"], 1)
        self.assertEqual(result["organizations"][0]["ein"], "111111111")

    def test_list_organizations_multiple(self):
        self.db.upsert_organization("111111111", "Alpha Org")
        self.db.upsert_organization("222222222", "Beta Org")
        result = self.db.list_organizations()
        self.assertEqual(result["total"], 2)
        self.assertEqual(len(result["organizations"]), 2)

    def test_list_organizations_has_expected_keys(self):
        self.db.upsert_organization("111111111", "Alpha Org")
        result = self.db.list_organizations()
        self.assertIn("ein", result["organizations"][0])
        self.assertIn("name", result["organizations"][0])
        self.assertIn("created_at", result["organizations"][0])
        self.assertIn("updated_at", result["organizations"][0])

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

    def test_list_organizations_search_returns_match(self):
        self.db.upsert_organization("111111111", "Alpha Org")
        self.db.upsert_organization("222222222", "Beta Org")
        result = self.db.list_organizations(search="Alpha")
        self.assertEqual(result["total"], 1)
        self.assertEqual(result["organizations"][0]["name"], "Alpha Org")

    def test_list_organizations_search_case_insensitive(self):
        self.db.upsert_organization("111111111", "Alpha Org")
        result = self.db.list_organizations(search="alpha")
        self.assertEqual(result["total"], 1)

    def test_list_organizations_search_no_match(self):
        self.db.upsert_organization("111111111", "Alpha Org")
        result = self.db.list_organizations(search="Zzz")
        self.assertEqual(result["total"], 0)
        self.assertEqual(result["organizations"], [])

    def test_drop_and_restore_ingest_indexes(self):
        self.db.drop_ingest_indexes()
        self.db.restore_ingest_indexes()

    def test_get_historical_values_empty(self):
        self.db.upsert_organization("111111111", "Alpha Org")
        result = self.db.get_historical_values("111111111")
        self.assertIsInstance(result, dict)
        self.assertEqual(result, {})

    def test_get_historical_values_returns_values(self):
        from database.IRS990 import IRS990Database
        from scoring.engine import _PATHS
        self.db.upsert_organization("333333333", "Hist Org")
        self.db.connection.commit()
        fid = self.db.create_filing("333333333", 2021, "990")
        fid2 = self.db.create_filing("333333333", 2022, "990")
        xpath = _PATHS['cy_rev']
        xpath_index = self.db.get_xpath_index()
        if xpath in xpath_index:
            field_id = xpath_index[xpath]
            self.db.store_reported_data(fid,  {field_id: "1000"})
            self.db.store_reported_data(fid2, {field_id: "1500"})
            self.db.connection.commit()
            result = self.db.get_historical_values("333333333")
            self.assertIn(xpath, result)
            self.assertEqual(sorted(result[xpath]), [1000.0, 1500.0])

    def test_get_historical_values_skips_non_numeric(self):
        self.db.upsert_organization("444444444", "Bad Org")
        self.db.connection.commit()
        fid = self.db.create_filing("444444444", 2021, "990")
        xpath_index = self.db.get_xpath_index()
        from scoring.engine import _PATHS
        xpath = _PATHS['cy_rev']
        if xpath in xpath_index:
            field_id = xpath_index[xpath]
            self.db.store_reported_data(fid, {field_id: "not-a-number"})
            self.db.connection.commit()
            result = self.db.get_historical_values("444444444")
            self.assertEqual(result.get(xpath, []), [])


# ---------------------------------------------------------------------------
# IngestRepository — ingested_zip tracking
# ---------------------------------------------------------------------------

class TestIngestRepository(unittest.TestCase):

    def setUp(self):
        self.db = IRS990Database(path=":memory:")

    def tearDown(self):
        self.db.close()

    def test_empty_sources_is_empty_set(self):
        self.assertEqual(self.db.get_ingested_sources(), set())
        self.assertEqual(self.db.list_ingested_zips(), [])

    def test_record_then_get_sources(self):
        self.db.record_ingested_zip(
            "https://x/2024_TEOS_XML_01A.zip",
            url="https://x/2024_TEOS_XML_01A.zip",
            filename="2024_TEOS_XML_01A.zip",
            etag='"abc"', last_modified="Mon, 01 Jan 2024 00:00:00 GMT",
            content_length=12345, filings_stored=7,
        )
        self.assertEqual(
            self.db.get_ingested_sources(), {"https://x/2024_TEOS_XML_01A.zip"}
        )

    def test_list_returns_full_record(self):
        self.db.record_ingested_zip(
            "https://x/a.zip", url="https://x/a.zip", filename="a.zip",
            etag="E", last_modified="LM", content_length=10, filings_stored=3,
        )
        rows = self.db.list_ingested_zips()
        self.assertEqual(len(rows), 1)
        row = rows[0]
        self.assertEqual(row["source"], "https://x/a.zip")
        self.assertEqual(row["url"], "https://x/a.zip")
        self.assertEqual(row["filename"], "a.zip")
        self.assertEqual(row["etag"], "E")
        self.assertEqual(row["last_modified"], "LM")
        self.assertEqual(row["content_length"], 10)
        self.assertEqual(row["filings_stored"], 3)
        self.assertIsNotNone(row["ingested_at"])

    def test_record_is_upsert(self):
        self.db.record_ingested_zip("https://x/a.zip", filename="a.zip", filings_stored=1)
        self.db.record_ingested_zip("https://x/a.zip", filename="a.zip", filings_stored=99)
        rows = self.db.list_ingested_zips()
        self.assertEqual(len(rows), 1)
        self.assertEqual(rows[0]["filings_stored"], 99)

    def test_record_defaults(self):
        self.db.record_ingested_zip("local/a.zip", filename="a.zip")
        rows = self.db.list_ingested_zips()
        self.assertEqual(rows[0]["url"], None)
        self.assertEqual(rows[0]["etag"], None)
        self.assertEqual(rows[0]["content_length"], None)
        self.assertEqual(rows[0]["filings_stored"], 0)


if __name__ == "__main__":
    unittest.main()
