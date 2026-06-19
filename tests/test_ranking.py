"""Tests for query-time ranking: the windowed leaderboard (global + subset), the
per-org COUNT-greater primitive (and the invariant that it equals the org's position
in the same-subset leaderboard), the per-org dimensions call, and the routes."""

import os
import sys
import unittest
from unittest.mock import MagicMock

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

from auth import Principal
from database import OpenReturnDB
from router.Score import ScoreRouter


def _actor():
    return Principal(kind='user', actor_id=1, label='ed', permissions=frozenset(), user_id=1)


def _seed(db, rows, *, model_version=1, year=2023):
    """rows: list of (ein, name, sector, state, score)."""
    mid = db.cursor.execute("SELECT model_id FROM score_model WHERE version = ?",
                            (model_version,)).fetchone()[0]
    for ein, name, sector, state, score in rows:
        db.orgs.create_org(ein, name, sector_code=sector,
                           physical_address={'state': state, 'city': 'X', 'zip': '1'}, actor=_actor())
        db.cursor.execute("INSERT INTO filing (uuid, year, organization_id, form_code) "
                          "VALUES (?, ?, ?, '990')", (f'u-{ein}-{year}', year, ein))
        fid = db.cursor.lastrowid
        db.cursor.execute("INSERT INTO organization_score (filing_id, model_id, total_score) "
                          "VALUES (?, ?, ?)", (fid, mid, score))
    db.connection.commit()


def _score(db, ein, year, score, *, model_version=1):
    """Add a filing + score for an EXISTING org (a second year)."""
    mid = db.cursor.execute("SELECT model_id FROM score_model WHERE version = ?",
                            (model_version,)).fetchone()[0]
    db.cursor.execute("INSERT INTO filing (uuid, year, organization_id, form_code) "
                      "VALUES (?, ?, ?, '990')", (f'u-{ein}-{year}', year, ein))
    db.cursor.execute("INSERT INTO organization_score (filing_id, model_id, total_score) "
                      "VALUES (?, ?, ?)", (db.cursor.lastrowid, mid, score))
    db.connection.commit()


_ROWS = [('100000001', 'A', 'E', 'TX', 0.90), ('100000002', 'B', 'E', 'TX', 0.70),
         ('100000003', 'C', 'P', 'CA', 0.80), ('100000004', 'D', 'E', 'CA', 0.60)]


class TestRankingDB(unittest.TestCase):
    def setUp(self):
        self.db = OpenReturnDB(path=':memory:')
        _seed(self.db, _ROWS)

    def tearDown(self):
        self.db.close()

    def test_global_leaderboard_order_and_total(self):
        lb = self.db.scores.rank_leaderboard(1)
        self.assertEqual([(r['rank'], r['ein']) for r in lb['leaderboard']],
                         [(1, '100000001'), (2, '100000003'), (3, '100000002'), (4, '100000004')])
        self.assertEqual(lb['total'], 4)

    def test_subset_ranks_within_subset(self):
        lb = self.db.scores.rank_leaderboard(1, sector='E')
        self.assertEqual([(r['rank'], r['ein']) for r in lb['leaderboard']],
                         [(1, '100000001'), (2, '100000002'), (3, '100000004')])
        self.assertEqual([r['ein'] for r in self.db.scores.rank_leaderboard(1, state='TX')['leaderboard']],
                         ['100000001', '100000002'])

    def test_city_subset_strips_whitespace(self):
        # The leaderboard city subset must match the same rows /organizations/search
        # would for the same dropdown value, so it normalizes whitespace like search.
        lb = self.db.scores.rank_leaderboard(1, city=' X ')
        self.assertEqual(len(lb['leaderboard']), 4)
        self.assertEqual(self.db.scores.rank_org('100000001', city=' X ')['rank'], 1)

    def test_ties_share_rank(self):
        _seed(self.db, [('100000005', 'E', 'E', 'TX', 0.90)])   # ties with A at 0.90
        lb = self.db.scores.rank_leaderboard(1)
        ranks = {r['ein']: r['rank'] for r in lb['leaderboard']}
        self.assertEqual(ranks['100000001'], ranks['100000005'])     # tie → same rank
        self.assertEqual(ranks['100000003'], 3)                      # next rank skips (RANK semantics)

    def test_rank_org_matches_leaderboard_position(self):
        # The COUNT-greater primitive must equal the org's position in the same subset.
        for subset in ({}, {'sector': 'E'}, {'state': 'TX'}):
            lb = self.db.scores.rank_leaderboard(1, limit=500, **subset)
            pos = {r['ein']: r['rank'] for r in lb['leaderboard']}
            for ein, exp in pos.items():
                self.assertEqual(self.db.scores.rank_org(ein, 1, **subset)['rank'], exp,
                                 f"{ein} subset={subset}")

    def test_rank_org_percentile_and_size(self):
        r = self.db.scores.rank_org('100000002', 1)        # B: 0.7 → rank 3 of 4
        self.assertEqual((r['rank'], r['of']), (3, 4))
        top = self.db.scores.rank_org('100000001', 1)
        self.assertEqual(top['percentile'], 100.0)

    def test_rank_org_not_in_subset_is_none(self):
        r = self.db.scores.rank_org('100000001', 1, sector='P')   # A is sector E, not P
        self.assertIsNone(r['rank'])

    def test_rank_org_dimensions(self):
        dims = self.db.scores.rank_org_dimensions('100000001', 1)['dimensions']
        self.assertEqual(dims['global']['rank'], 1)
        self.assertEqual(dims['sector']['rank'], 1)         # top of sector E
        self.assertEqual(dims['state']['of'], 2)            # TX has 2 orgs
        self.assertIsNone(self.db.scores.rank_org_dimensions('999999999', 1))

    def test_fixed_year_filter(self):
        _score(self.db, '100000001', 2022, 0.10)        # an older, lower year for A
        # Latest (default) keeps 2023's 0.90 at rank 1; fixing year=2022 ranks only that year.
        self.assertEqual(self.db.scores.rank_leaderboard(1)['leaderboard'][0]['ein'], '100000001')
        lb22 = self.db.scores.rank_leaderboard(1, year=2022)
        self.assertEqual([r['ein'] for r in lb22['leaderboard']], ['100000001'])


class TestRankingRoutes(unittest.TestCase):
    def setUp(self):
        self.db = OpenReturnDB(path=':memory:')
        _seed(self.db, _ROWS)
        self.router = ScoreRouter(db=self.db)

    def tearDown(self):
        self.db.close()

    def _get(self, path, **qp):
        h = MagicMock(); h.get.return_value = ""
        return self.router.routes['GET'][path](
            query_params={k: [v] for k, v in qp.items()}, body=None, headers=h)

    def test_permissions(self):
        self.assertEqual(self.router.routes['GET']['/scores/leaderboard']._permission, 'score:read')
        self.assertEqual(self.router.routes['GET']['/scores/ranking']._permission, 'score:read')

    def test_leaderboard_route(self):
        out = self._get('/scores/leaderboard', model='1', sector='E')
        self.assertEqual([r['ein'] for r in out['leaderboard']], ['100000001', '100000002', '100000004'])

    def test_leaderboard_bad_param(self):
        self.assertIn('error', self._get('/scores/leaderboard', limit='x'))

    def test_ranking_route(self):
        out = self._get('/scores/ranking', ein='100000001', model='1')
        self.assertEqual(out['dimensions']['global']['rank'], 1)

    def test_ranking_requires_ein(self):
        self.assertIn('error', self._get('/scores/ranking', model='1'))

    def test_ranking_unknown_org(self):
        self.assertIn('error', self._get('/scores/ranking', ein='999999999'))


class TestRankingCache(unittest.TestCase):
    """The org_score_latest fast-path: it must produce results IDENTICAL to the
    live fallback (clearing the cache forces the fallback), reflect the latest
    year, and preserve the rank==leaderboard-position invariant."""

    def setUp(self):
        self.db = OpenReturnDB(path=':memory:')
        _seed(self.db, _ROWS)
        self.db.scores.rebuild_score_latest()
        self.db.connection.commit()

    def tearDown(self):
        self.db.close()

    def _clear_cache(self):
        self.db.cursor.execute("DELETE FROM org_score_latest")
        self.db.connection.commit()

    def test_cache_populated_one_row_per_org(self):
        n = self.db.cursor.execute("SELECT COUNT(*) FROM org_score_latest").fetchone()[0]
        self.assertEqual(n, len(_ROWS))

    def test_cache_denormalizes_dims(self):
        row = self.db.cursor.execute(
            "SELECT total_score, sector_code, state_code FROM org_score_latest "
            "WHERE ein = ?", ('100000001',)).fetchone()
        self.assertAlmostEqual(row[0], 0.90)
        self.assertEqual(row[1], 'E')
        self.assertEqual(row[2], 'TX')

    def test_leaderboard_cache_equals_fallback(self):
        cached = self.db.scores.rank_leaderboard(1)
        cached_tx = self.db.scores.rank_leaderboard(1, state='TX')
        self._clear_cache()
        self.assertEqual(cached, self.db.scores.rank_leaderboard(1))
        self.assertEqual(cached_tx, self.db.scores.rank_leaderboard(1, state='TX'))

    def test_rank_org_cache_equals_fallback(self):
        cached = {e: self.db.scores.rank_org(e, 1) for e, *_ in _ROWS}
        cached_tx = {e: self.db.scores.rank_org(e, 1, state='TX') for e, *_ in _ROWS}
        self._clear_cache()
        for e, *_ in _ROWS:
            self.assertEqual(cached[e], self.db.scores.rank_org(e, 1))
            self.assertEqual(cached_tx[e], self.db.scores.rank_org(e, 1, state='TX'))

    def test_dimensions_cache_equals_fallback(self):
        cached = self.db.scores.rank_org_dimensions('100000001', 1)
        self._clear_cache()
        self.assertEqual(cached, self.db.scores.rank_org_dimensions('100000001', 1))

    def test_rank_equals_leaderboard_position_via_cache(self):
        # The test-asserted invariant, now through the cache path.
        board = self.db.scores.rank_leaderboard(1, limit=500)["leaderboard"]
        pos = {r["ein"]: r["rank"] for r in board}
        for e, *_ in _ROWS:
            self.assertEqual(self.db.scores.rank_org(e, 1)["rank"], pos[e])

    def test_cache_reflects_latest_year(self):
        # A newer filing restates the org's latest score; a rebuild must update it.
        _score(self.db, '100000004', 2024, 0.99)
        self.db.scores.rebuild_score_latest()
        self.db.connection.commit()
        row = self.db.cursor.execute(
            "SELECT total_score, year FROM org_score_latest WHERE ein = ?",
            ('100000004',)).fetchone()
        self.assertAlmostEqual(row[0], 0.99)
        self.assertEqual(row[1], 2024)

    def test_surgical_rebuild_updates_only_target(self):
        _score(self.db, '100000002', 2024, 0.99)
        self.db.scores.rebuild_score_latest(eins=['100000002'])
        self.db.connection.commit()
        updated = self.db.cursor.execute(
            "SELECT total_score FROM org_score_latest WHERE ein = ?",
            ('100000002',)).fetchone()[0]
        self.assertAlmostEqual(updated, 0.99)
        # An untouched org keeps its row.
        other = self.db.cursor.execute(
            "SELECT total_score FROM org_score_latest WHERE ein = ?",
            ('100000001',)).fetchone()[0]
        self.assertAlmostEqual(other, 0.90)

    def test_purge_invalidates_cache(self):
        self.db.scores.delete_all_filings()
        n = self.db.cursor.execute("SELECT COUNT(*) FROM org_score_latest").fetchone()[0]
        self.assertEqual(n, 0)

    def test_clear_score_latest_forces_fallback(self):
        mid = self.db.cursor.execute(
            "SELECT model_id FROM score_model WHERE version='1'").fetchone()[0]
        self.assertTrue(self.db.scores._score_latest_ready(mid))
        self.db.scores.clear_score_latest([mid])
        self.db.connection.commit()
        self.assertFalse(self.db.scores._score_latest_ready(mid))
        # With the cache cleared, reads still work (live fallback) and match.
        self.assertTrue(self.db.scores.rank_leaderboard(1)["leaderboard"])

    def test_dimension_edit_keeps_cache_consistent_with_fallback(self):
        # Editing a denormalized dim (sector) must refresh the cache, or the
        # cached subset filter would diverge from the live fallback. update_org
        # moves 100000004 from sector E to P.
        self.db.orgs.update_org("100000004", {"sector_code": "P"}, actor=_actor())
        for sector in ("E", "P"):
            cached = self.db.scores.rank_leaderboard(1, sector=sector)
            # Clearing the cache forces the live fallback; the two must agree.
            self.db.cursor.execute("DELETE FROM org_score_latest")
            self.db.connection.commit()
            fallback = self.db.scores.rank_leaderboard(1, sector=sector)
            self.assertEqual(
                [r["ein"] for r in cached["leaderboard"]],
                [r["ein"] for r in fallback["leaderboard"]],
                f"cache≠fallback for sector={sector} after a dim edit")
            self.assertEqual(cached["total"], fallback["total"])
            self.db.scores.rebuild_score_latest()  # restore cache for next iter
            self.db.connection.commit()

    def test_page1_walk_and_deep_page_match_fallback_with_ties(self):
        # Tie 100000002 with 100000001 at 0.90 (both cache + source), so RANK
        # ties are exercised on the page-1 walk (offset 0) AND the windowed deep
        # pages (offset > 0). Both must equal the live fallback exactly.
        self.db.cursor.execute(
            "UPDATE organization_score SET total_score = 0.90 WHERE filing_id IN "
            "(SELECT filing_id FROM filing WHERE organization_id = '100000002')")
        self.db.connection.commit()
        self.db.scores.rebuild_score_latest()
        self.db.connection.commit()
        for limit, offset in [(10, 0), (2, 0), (2, 1), (2, 2), (1, 3)]:
            cached = self.db.scores.rank_leaderboard(1, limit=limit, offset=offset)
            self.db.cursor.execute("DELETE FROM org_score_latest")
            self.db.connection.commit()
            fb = self.db.scores.rank_leaderboard(1, limit=limit, offset=offset)
            self.assertEqual(
                [(r["ein"], r["rank"]) for r in cached["leaderboard"]],
                [(r["ein"], r["rank"]) for r in fb["leaderboard"]],
                f"cache≠fallback at limit={limit} offset={offset}")
            self.assertEqual(cached["total"], fb["total"])
            self.db.scores.rebuild_score_latest()
            self.db.connection.commit()

    def test_city_index_self_heals_to_nocase(self):
        # A DB built before the city index was made case-insensitive has a BINARY
        # idx_osl_type_city, which the COLLATE NOCASE city filter can't seek. The
        # migration must rebuild it NOCASE.
        cur = self.db.cursor
        cur.execute("DROP INDEX idx_osl_type_city")
        cur.execute("CREATE INDEX idx_osl_type_city ON org_score_latest "
                    "(model_id, org_type, city, total_score)")  # BINARY
        self.db.connection.commit()
        sql = cur.execute("SELECT sql FROM sqlite_master WHERE "
                          "name='idx_osl_type_city'").fetchone()[0]
        self.assertNotIn("NOCASE", sql.upper())
        self.db.scores._migrate_score_latest_indexes()
        sql = cur.execute("SELECT sql FROM sqlite_master WHERE "
                          "name='idx_osl_type_city'").fetchone()[0]
        self.assertIn("NOCASE", sql.upper())


if __name__ == '__main__':
    unittest.main()
