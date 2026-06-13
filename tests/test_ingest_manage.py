"""Tests for ingested-archive management: IngestRepository forget/find helpers,
ScoreDatabase purge (filings + reported_data + scores), and the ingest CLI
management flags (--ingested / --forget / --purge / --stop)."""

import contextlib
import io
import os
import sys
import tempfile
import unittest
from types import SimpleNamespace
from unittest.mock import patch

_ROOT = os.path.join(os.path.dirname(__file__), '..')
_SRC = os.path.join(_ROOT, 'src')
sys.path.insert(0, _SRC)
sys.path.insert(0, _ROOT)

import ingest as ingest_mod
from database.Score import ScoreDatabase


def _seed(db, filings):
    """filings: list of (filing_id, uuid, year, zip_filename, with_score)."""
    db.cursor.execute("INSERT OR IGNORE INTO organization (ein, name) VALUES ('123456789','Org')")
    field_id = db.cursor.execute("SELECT field_id FROM field LIMIT 1").fetchone()[0]
    model_id = db.cursor.execute("SELECT model_id FROM score_model LIMIT 1").fetchone()[0]
    for fid, uu, yr, zf, with_score in filings:
        db.cursor.execute(
            "INSERT INTO filing (filing_id, uuid, year, organization_id, form_code, zip_filename) "
            "VALUES (?,?,?, '123456789','990', ?)", (fid, uu, yr, zf))
        db.cursor.execute(
            "INSERT INTO reported_data (filing_id, field_id, raw_value) VALUES (?,?, '1')", (fid, field_id))
        if with_score:
            db.cursor.execute(
                "INSERT INTO organization_score (filing_id, model_id, total_score) VALUES (?,?, 9.0)",
                (uu, model_id))
        db.cursor.execute(
            "INSERT INTO ingested_zip (source, filename, filings_stored) VALUES (?,?, 1)",
            (f"http://h/{zf}", zf))
    db.connection.commit()


def _count(db, table):
    return db.cursor.execute(f"SELECT COUNT(*) FROM {table}").fetchone()[0]


# ---------------------------------------------------------------------------
# IngestRepository: find / forget
# ---------------------------------------------------------------------------

class TestForget(unittest.TestCase):

    def setUp(self):
        self.db = ScoreDatabase(path=":memory:")
        _seed(self.db, [(1, 'u1', 2023, 'd_2023_1.zip', False),
                        (2, 'u2', 2022, 'd_2022_1.zip', False)])

    def tearDown(self):
        self.db.close()

    def test_count(self):
        self.assertEqual(self.db.count_ingested_zips(), 2)

    def test_find_by_year_substring(self):
        m = self.db.find_ingested_zips('2023')
        self.assertEqual([r['filename'] for r in m], ['d_2023_1.zip'])

    def test_find_by_source_substring(self):
        self.assertEqual(len(self.db.find_ingested_zips('http://h/')), 2)

    def test_find_no_match(self):
        self.assertEqual(self.db.find_ingested_zips('nope'), [])

    def test_forget_specific(self):
        n = self.db.forget_ingested_zips(['http://h/d_2023_1.zip'])
        self.assertEqual(n, 1)
        self.assertEqual(self.db.count_ingested_zips(), 1)

    def test_forget_empty_list_is_noop(self):
        self.assertEqual(self.db.forget_ingested_zips([]), 0)
        self.assertEqual(self.db.count_ingested_zips(), 2)

    def test_forget_all(self):
        self.assertEqual(self.db.forget_all_ingested_zips(), 2)
        self.assertEqual(self.db.count_ingested_zips(), 0)

    def test_forget_does_not_touch_filings(self):
        self.db.forget_all_ingested_zips()
        self.assertEqual(_count(self.db, 'filing'), 2)


# ---------------------------------------------------------------------------
# ScoreDatabase: purge (filings + reported_data + scores)
# ---------------------------------------------------------------------------

class TestPurge(unittest.TestCase):

    def setUp(self):
        self.db = ScoreDatabase(path=":memory:")
        _seed(self.db, [(1, 'u1', 2023, 'd_2023_1.zip', True),   # has a score
                        (2, 'u2', 2022, 'd_2022_1.zip', False)])

    def tearDown(self):
        self.db.close()

    def test_find_zip_filenames(self):
        self.assertEqual(self.db.find_zip_filenames('2023'), [('d_2023_1.zip', 1)])

    def test_delete_by_zip_counts(self):
        res = self.db.delete_filings_by_zip('2022')
        self.assertEqual(res, {"filings": 1, "values": 1, "scores": 0})
        self.assertEqual(_count(self.db, 'filing'), 1)

    def test_delete_by_zip_cascades_reported_data(self):
        self.db.delete_filings_by_zip('2022')
        # filing 2's reported_data is gone; filing 1's remains
        self.assertEqual(_count(self.db, 'reported_data'), 1)

    def test_delete_with_score_removes_score_first(self):
        # filing u1 has a score; deleting it must not raise an FK error.
        res = self.db.delete_filings_by_zip('2023')
        self.assertEqual(res, {"filings": 1, "values": 1, "scores": 1})
        self.assertEqual(_count(self.db, 'organization_score'), 0)

    def test_delete_all(self):
        res = self.db.delete_all_filings()
        self.assertEqual(res, {"filings": 2, "values": 2, "scores": 1})
        self.assertEqual(_count(self.db, 'filing'), 0)
        self.assertEqual(_count(self.db, 'reported_data'), 0)
        self.assertEqual(_count(self.db, 'organization_score'), 0)

    def test_delete_all_keeps_organization(self):
        self.db.delete_all_filings()
        self.assertEqual(_count(self.db, 'organization'), 1)

    def test_no_match_returns_zeros(self):
        self.assertEqual(self.db.delete_filings_by_zip('zzz'),
                         {"filings": 0, "values": 0, "scores": 0})

    def test_underscore_is_literal_not_wildcard(self):
        # '2023_1' must match '2023_1.zip' literally, NOT '2023X1.zip'.
        db = ScoreDatabase(path=":memory:")
        _seed(db, [(1, 'a', 2023, '2023_1.zip', False),
                   (2, 'b', 2024, '2023X1.zip', False)])
        self.assertEqual(db.find_zip_filenames('2023_1'), [('2023_1.zip', 1)])
        res = db.delete_filings_by_zip('2023_1')
        self.assertEqual(res["filings"], 1)
        self.assertEqual(_count(db, 'filing'), 1)  # 2023X1.zip survives
        db.close()

    def test_percent_is_literal_not_wildcard(self):
        db = ScoreDatabase(path=":memory:")
        _seed(db, [(1, 'a', 2023, 'plain.zip', False)])
        # A bare '%' must not match everything.
        self.assertEqual(db.find_zip_filenames('%'), [])
        db.close()


# ---------------------------------------------------------------------------
# ingest CLI management flags (run against a real cwd DB)
# ---------------------------------------------------------------------------

class TestIngestManageCLI(unittest.TestCase):

    def setUp(self):
        self._cwd = os.getcwd()
        self.td = tempfile.mkdtemp()
        os.chdir(self.td)
        db = ScoreDatabase()  # ./OpenReturn.db
        _seed(db, [(1, 'u1', 2023, 'd_2023_1.zip', True),
                   (2, 'u2', 2022, 'd_2022_1.zip', False)])
        db.close()

    def tearDown(self):
        os.chdir(self._cwd)

    def _args(self, **kw):
        base = dict(directory=None, stop=False, ingested=False, forget=None,
                    forget_all=False, purge=None, purge_all=False, yes=False,
                    background=False, workers=1)
        base.update(kw)
        return SimpleNamespace(**base)

    def _run(self, args, stdin=None):
        buf = io.StringIO()
        ctx = patch('builtins.input', return_value=stdin) if stdin is not None else contextlib.nullcontext()
        with contextlib.redirect_stdout(buf), contextlib.redirect_stderr(buf), ctx:
            rc = ingest_mod.cmd_ingest(args)
        return rc, buf.getvalue()

    def test_no_source_no_action_errors(self):
        rc, out = self._run(self._args())
        self.assertEqual(rc, 2)
        self.assertIn("required", out)

    def test_ingested_lists(self):
        rc, out = self._run(self._args(ingested=True))
        self.assertEqual(rc, 0)
        self.assertIn("d_2023_1.zip", out)
        self.assertIn("d_2022_1.zip", out)

    def test_forget_pattern(self):
        rc, out = self._run(self._args(forget='2023'))
        self.assertEqual(rc, 0)
        db = ScoreDatabase()
        self.assertEqual(db.count_ingested_zips(), 1)
        self.assertEqual(_count(db, 'filing'), 2)  # data untouched
        db.close()

    def test_forget_no_match(self):
        rc, out = self._run(self._args(forget='zzz'))
        self.assertEqual(rc, 0)
        self.assertIn("No ingested archives match", out)

    def test_forget_all(self):
        rc, out = self._run(self._args(forget_all=True))
        self.assertEqual(rc, 0)
        db = ScoreDatabase()
        self.assertEqual(db.count_ingested_zips(), 0)
        db.close()

    def test_purge_pattern_confirmed(self):
        rc, out = self._run(self._args(purge='2023'), stdin='yes')
        self.assertEqual(rc, 0)
        db = ScoreDatabase()
        self.assertEqual(_count(db, 'filing'), 1)
        self.assertEqual(db.count_ingested_zips(), 1)  # the 2023 record was forgotten too
        db.close()

    def test_purge_aborted_on_wrong_input(self):
        rc, out = self._run(self._args(purge='2023'), stdin='no')
        self.assertEqual(rc, 1)
        self.assertIn("Aborted", out)
        db = ScoreDatabase()
        self.assertEqual(_count(db, 'filing'), 2)
        db.close()

    def test_purge_yes_flag_skips_prompt(self):
        rc, out = self._run(self._args(purge='2022', yes=True))  # no stdin
        self.assertEqual(rc, 0)
        db = ScoreDatabase()
        self.assertEqual(_count(db, 'filing'), 1)
        db.close()

    def test_purge_all_confirmed(self):
        rc, out = self._run(self._args(purge_all=True), stdin='yes')
        self.assertEqual(rc, 0)
        db = ScoreDatabase()
        self.assertEqual(_count(db, 'filing'), 0)
        self.assertEqual(_count(db, 'organization'), 1)
        db.close()

    def test_purge_nothing_matches(self):
        rc, out = self._run(self._args(purge='zzz'))
        self.assertEqual(rc, 0)
        self.assertIn("Nothing matches", out)

    def test_stop_with_nothing_running(self):
        rc, out = self._run(self._args(stop=True))
        self.assertEqual(rc, 0)
        self.assertIn("No background ingest", out)

    def test_management_refused_while_ingest_running(self):
        # _require_db refuses (so purge/forget can't run against a DB an ingest
        # holds exclusively locked).
        buf = io.StringIO()
        with patch('daemon.running_daemon', return_value={"pid": 999}), \
             contextlib.redirect_stdout(buf), contextlib.redirect_stderr(buf):
            self.assertIsNone(ingest_mod._require_db())
        self.assertIn("background ingest is running", buf.getvalue())

    def test_purge_refused_while_ingest_running(self):
        # With a fake running daemon, _require_db returns None -> rc 1 and the
        # data is left untouched.
        with patch('daemon.running_daemon', return_value={"pid": 999}):
            rc, out = self._run(self._args(purge_all=True, yes=True))
        self.assertEqual(rc, 1)
        db = ScoreDatabase()
        self.assertEqual(_count(db, 'filing'), 2)  # nothing deleted
        db.close()


class TestRequireDBMissing(unittest.TestCase):

    def test_require_db_missing(self):
        cwd = os.getcwd()
        try:
            with tempfile.TemporaryDirectory() as td:
                os.chdir(td)
                buf = io.StringIO()
                with contextlib.redirect_stderr(buf):
                    self.assertIsNone(ingest_mod._require_db())
                self.assertIn("not found", buf.getvalue())
        finally:
            os.chdir(cwd)


if __name__ == '__main__':  # pragma: no cover
    unittest.main()
