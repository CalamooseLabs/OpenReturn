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


if __name__ == '__main__':
    unittest.main()
