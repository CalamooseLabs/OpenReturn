"""Tests for the unified financial layer: concept/observation/canonical model,
990 derivation (+ score equality), conflict + manual canonical selection, a
non-990 org scored from audited observations, and the FinancialsRouter."""

import os
import sys
import unittest
from unittest.mock import MagicMock

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

from auth import Principal
from database import OpenReturnDB
from scoring import ScoringEngine
from scoring.engine import _PATHS
from router.Financials import FinancialsRouter


def _actor(label='alice'):
    return Principal(kind='user', actor_id=1, label=label, permissions=frozenset(), user_id=1)


def _add_990(db, ein='123456789', year=2023, values=None):
    """Insert an org + a 990 filing + reported_data (the raw 990 store)."""
    db.cursor.execute("INSERT OR IGNORE INTO organization (ein, name) VALUES (?, 'Org')", (ein,))
    db.cursor.execute(
        "INSERT INTO filing (uuid, year, organization_id, form_code) VALUES (?,?,?,'990')",
        (f"u-{ein}-{year}", year, ein))
    filing_id = db.cursor.lastrowid
    xidx = db.meta.get_xpath_index()
    for key, amt in (values or {}).items():
        fid = xidx.get(_PATHS[key])
        if fid is not None:
            db.cursor.execute(
                "INSERT OR IGNORE INTO reported_data (filing_id, field_id, raw_value) VALUES (?,?,?)",
                (filing_id, fid, str(amt)))
    db.connection.commit()
    return filing_id


class TestFinancialsConcepts(unittest.TestCase):
    def setUp(self):
        self.db = OpenReturnDB(path=':memory:')

    def tearDown(self):
        self.db.close()

    def test_concepts_seeded_from_paths(self):
        codes = {c['code'] for c in self.db.financials.list_concepts()}
        self.assertEqual(codes, set(_PATHS))
        prog = next(c for c in self.db.financials.list_concepts() if c['code'] == 'prog')
        self.assertEqual(prog['default_xml_path'], _PATHS['prog'])

    def test_sources_seeded(self):
        codes = {s['code'] for s in self.db.financials.list_sources()}
        self.assertIn('irs_990_xml', codes)
        self.assertIn('audited_statement', codes)


class TestDerivationAndScoring(unittest.TestCase):
    def setUp(self):
        self.db = OpenReturnDB(path=':memory:')

    def tearDown(self):
        self.db.close()

    def test_derive_from_990_reproduces_values(self):
        _add_990(self.db, values={'prog': 800, 'total_exp': 1000})
        self.db.financials.derive_from_990('123456789')
        vals = self.db.financials.get_year_canonical_values('123456789', 2023)
        self.assertEqual(vals['prog'], 800.0)
        self.assertEqual(vals['total_exp'], 1000.0)

    def test_score_matches_raw_990(self):
        # Scoring (which reads canonical concepts) equals scoring the raw 990.
        _add_990(self.db, values={'prog': 800, 'total_exp': 1000})
        eng = ScoringEngine(self.db)
        score = eng.calculate('123456789', 2023, model_version=1)
        # model v1 factor 'Program Expense' = prog/total_exp = 0.8 → contributes
        self.assertGreater(score['total_score'], 0.0)
        pe = next(f for f in score['factors'] if f['name'] == 'Program Expense')
        self.assertAlmostEqual(pe['raw_value'], 0.8)

    def test_rebuild_backfills_all(self):
        _add_990(self.db, ein='111111111', values={'prog': 1, 'total_exp': 2})
        _add_990(self.db, ein='222222222', values={'cy_rev': 5})
        res = self.db.financials.rebuild()
        self.assertGreaterEqual(res['orgs'], 2)
        self.assertGreater(res['observations'], 0)


class TestDeriveBulk(unittest.TestCase):
    """The set-based bulk derivation (the scoring/ingest fast path) must produce the
    same canonical values as the per-org derive_from_990, handle signed integers, and
    be idempotent + scopeable."""

    def setUp(self):
        self.db = OpenReturnDB(path=':memory:')

    def tearDown(self):
        self.db.close()

    def test_bulk_matches_values_signed_and_idempotent(self):
        _add_990(self.db, ein='111111111', year=2022, values={'prog': 800, 'total_exp': 1000})
        _add_990(self.db, ein='111111111', year=2023, values={'prog': 900, 'total_exp': 1100, 'equity': -50})
        _add_990(self.db, ein='222222222', year=2023, values={'cy_rev': 5})
        self.assertIsNone(self.db.financials.derive_bulk()['orgs'])   # whole-corpus
        v22 = self.db.financials.get_year_canonical_values('111111111', 2022)
        v23 = self.db.financials.get_year_canonical_values('111111111', 2023)
        self.assertEqual((v22['prog'], v22['total_exp']), (800.0, 1000.0))
        self.assertEqual((v23['prog'], v23['total_exp'], v23['equity']), (900.0, 1100.0, -50.0))
        self.assertEqual(self.db.financials.get_year_canonical_values('222222222', 2023)['cy_rev'], 5.0)
        # re-running adds no duplicate observations
        n1 = self.db.cursor.execute('SELECT COUNT(*) FROM financial_observation').fetchone()[0]
        self.db.financials.derive_bulk()
        n2 = self.db.cursor.execute('SELECT COUNT(*) FROM financial_observation').fetchone()[0]
        self.assertEqual(n1, n2)

    def test_bulk_equals_derive_from_990(self):
        vals = {'prog': 123, 'total_exp': 456, 'cy_rev': 789, 'fund': 12}
        b = OpenReturnDB(path=':memory:')
        try:
            _add_990(self.db, values=vals)
            _add_990(b, values=vals)
            self.db.financials.derive_from_990('123456789')
            b.financials.derive_bulk()
            self.assertEqual(self.db.financials.get_year_canonical_values('123456789', 2023),
                             b.financials.get_year_canonical_values('123456789', 2023))
        finally:
            b.close()

    def test_bulk_scoped_to_eins(self):
        _add_990(self.db, ein='111111111', values={'cy_rev': 5})
        _add_990(self.db, ein='222222222', values={'cy_rev': 9})
        self.db.financials.derive_bulk(eins=['111111111'])
        self.assertEqual(self.db.financials.get_year_canonical_values('111111111', 2023)['cy_rev'], 5.0)
        self.assertEqual(self.db.financials.get_year_canonical_values('222222222', 2023), {})


class TestConflictAndCanonical(unittest.TestCase):
    def setUp(self):
        self.db = OpenReturnDB(path=':memory:')
        _add_990(self.db, values={'cy_rev': 1000})
        self.db.financials.derive_from_990('123456789')   # irs_990_xml: cy_rev=1000

    def tearDown(self):
        self.db.close()

    def test_sole_source_is_canonical(self):
        facts = {f['concept_code']: f for f in
                 self.db.financials.get_org_financials('123456789', 2023)['facts']}
        self.assertEqual(facts['cy_rev']['canonical_value'], 1000.0)
        self.assertFalse(facts['cy_rev']['conflict'])

    def test_disagreeing_source_creates_conflict_and_keeps_both(self):
        # A manually-entered 990 says cy_rev=1200 — retained, flagged, canonical unchanged.
        self.db.financials.record_observations(
            '123456789', 2023, 'manual_990', {'cy_rev': 1200}, actor=_actor())
        facts = {f['concept_code']: f for f in
                 self.db.financials.get_org_financials('123456789', 2023)['facts']}
        cy = facts['cy_rev']
        self.assertTrue(cy['conflict'])
        self.assertEqual({o['value'] for o in cy['observations']}, {1000.0, 1200.0})
        self.assertEqual(cy['canonical_value'], 1000.0)        # original stays until chosen
        self.assertEqual(len(self.db.financials.conflicts('123456789')), 1)

    def test_manual_canonical_resolves_conflict(self):
        out = self.db.financials.record_observations(
            '123456789', 2023, 'manual_990', {'cy_rev': 1200}, actor=_actor())
        new_obs = out['observations'][0]['observation_id']
        self.assertTrue(self.db.financials.set_canonical(
            '123456789', 2023, 'cy_rev', new_obs, actor=_actor()))
        facts = {f['concept_code']: f for f in
                 self.db.financials.get_org_financials('123456789', 2023)['facts']}
        self.assertEqual(facts['cy_rev']['canonical_value'], 1200.0)
        self.assertEqual(self.db.financials.conflicts('123456789'), [])

    def test_set_canonical_rejects_foreign_observation(self):
        self.assertFalse(self.db.financials.set_canonical('123456789', 2023, 'cy_rev', 99999))


class TestOrgsWithConflicts(unittest.TestCase):
    """The corpus-wide conflicts inbox: only orgs with ≥1 unresolved conflict
    (diverging non-NULL observations, no manual canonical) appear, with a per-org
    conflict count, paginated."""

    def setUp(self):
        self.db = OpenReturnDB(path=':memory:')

    def tearDown(self):
        self.db.close()

    def _names(self, **kw):
        return {o['ein'] for o in self.db.financials.orgs_with_conflicts(**kw)['organizations']}

    def test_conflicting_org_appears_with_count(self):
        # Org A: two diverging cy_rev observations for one year → one conflict.
        _add_990(self.db, ein='111111111', year=2023, values={'cy_rev': 1000})
        self.db.financials.derive_from_990('111111111')
        self.db.financials.record_observations(
            '111111111', 2023, 'manual_990', {'cy_rev': 1200}, actor=_actor())
        out = self.db.financials.orgs_with_conflicts()
        self.assertEqual(out['total'], 1)
        org = next(o for o in out['organizations'] if o['ein'] == '111111111')
        self.assertEqual(org['conflict_count'], 1)
        self.assertEqual(org['name'], 'Org')

    def test_sole_and_agreeing_observations_are_not_conflicts(self):
        # Org B has a sole-source value; Org C has two AGREEING observations.
        # Neither is a conflict, so the inbox stays empty.
        _add_990(self.db, ein='222222222', year=2023, values={'cy_rev': 500})
        self.db.financials.derive_from_990('222222222')
        _add_990(self.db, ein='333333333', year=2023, values={'cy_rev': 700})
        self.db.financials.derive_from_990('333333333')
        self.db.financials.record_observations(
            '333333333', 2023, 'audited_statement', {'cy_rev': 700}, actor=_actor())
        out = self.db.financials.orgs_with_conflicts()
        self.assertEqual(out['total'], 0)
        self.assertEqual(out['organizations'], [])

    def test_resolved_conflict_drops_out_of_inbox(self):
        # A diverging fact a human has resolved (manual canonical) is no longer a
        # conflict and must not appear.
        _add_990(self.db, ein='444444444', year=2023, values={'cy_rev': 1000})
        self.db.financials.derive_from_990('444444444')
        out = self.db.financials.record_observations(
            '444444444', 2023, 'manual_990', {'cy_rev': 1200}, actor=_actor())
        self.assertEqual(self.db.financials.orgs_with_conflicts()['total'], 1)
        self.db.financials.set_canonical(
            '444444444', 2023, 'cy_rev', out['observations'][0]['observation_id'], actor=_actor())
        self.assertEqual(self.db.financials.orgs_with_conflicts()['total'], 0)

    def test_pagination_and_ordering_by_count(self):
        # Org X has two conflicting facts (count 2), org Y has one (count 1).
        # Ordered by conflict_count desc, so X is first; limit/offset page.
        _add_990(self.db, ein='555555555', year=2023, values={'cy_rev': 1000, 'prog': 800})
        self.db.financials.derive_from_990('555555555')
        self.db.financials.record_observations(
            '555555555', 2023, 'manual_990', {'cy_rev': 1200, 'prog': 900}, actor=_actor())
        _add_990(self.db, ein='666666666', year=2023, values={'cy_rev': 50})
        self.db.financials.derive_from_990('666666666')
        self.db.financials.record_observations(
            '666666666', 2023, 'manual_990', {'cy_rev': 60}, actor=_actor())
        out = self.db.financials.orgs_with_conflicts()
        self.assertEqual(out['total'], 2)
        self.assertEqual(out['organizations'][0]['ein'], '555555555')
        self.assertEqual(out['organizations'][0]['conflict_count'], 2)
        self.assertEqual(out['organizations'][1]['conflict_count'], 1)
        # Page through: limit 1, offset 1 → just the second org.
        page = self.db.financials.orgs_with_conflicts(limit=1, offset=1)
        self.assertEqual(page['total'], 2)
        self.assertEqual([o['ein'] for o in page['organizations']], ['666666666'])

    def test_limit_capped_at_200(self):
        out = self.db.financials.orgs_with_conflicts(limit=9999)
        self.assertEqual(out['limit'], 200)


class TestNon990Scoring(unittest.TestCase):
    def test_audited_only_org_is_scoreable(self):
        db = OpenReturnDB(path=':memory:')
        try:
            db.cursor.execute("INSERT INTO organization (ein, name) VALUES ('555555555','Audited Co')")
            db.connection.commit()
            # No 990 — record audited financials directly (creates a FIN anchor filing).
            db.financials.record_observations(
                '555555555', 2022, 'audited_statement',
                {'prog': 850, 'total_exp': 1000}, confidence=1.0, actor=_actor())
            # A FIN filing now anchors the org-year so scoring can attach.
            row = db.cursor.execute(
                "SELECT form_code FROM filing WHERE organization_id='555555555' AND year=2022").fetchone()
            self.assertEqual(row[0], 'FIN')
            eng = ScoringEngine(db)
            score = eng.calculate('555555555', 2022, model_version=1)
            pe = next(f for f in score['factors'] if f['name'] == 'Program Expense')
            self.assertAlmostEqual(pe['raw_value'], 0.85)   # 850/1000 from audited data
        finally:
            db.close()


class TestAnchorDedup(unittest.TestCase):
    def test_fin_anchor_dropped_when_real_filing_exists(self):
        db = OpenReturnDB(path=':memory:')
        try:
            db.cursor.execute("INSERT INTO organization (ein, name) VALUES ('777777777','Co')")
            db.connection.commit()
            # Audited data first → creates a synthetic FIN filing for 2023.
            db.financials.record_observations(
                '777777777', 2023, 'audited_statement', {'cy_rev': 900}, actor=_actor())
            # Then the real 990 arrives for the same year.
            _add_990(db, ein='777777777', year=2023, values={'cy_rev': 1000})
            forms = {r[0] for r in db.cursor.execute(
                "SELECT form_code FROM filing WHERE organization_id='777777777' AND year=2023").fetchall()}
            self.assertEqual(forms, {'FIN', '990'})           # both filings exist
            # Scoring de-dupes to one anchor per year (FIN dropped → one score).
            filings, _, _ = db.financials.get_org_scoring_data('777777777', ['cy_rev'])
            years_2023 = [f for f in filings if f['year'] == 2023]
            self.assertEqual(len(years_2023), 1)
            self.assertEqual(years_2023[0]['form_code'], '990')
        finally:
            db.close()


class TestNullCanonicalAndDeletion(unittest.TestCase):
    def setUp(self):
        self.db = OpenReturnDB(path=':memory:')
        self.db.cursor.execute("INSERT INTO organization (ein, name) VALUES ('888888888','Co')")
        self.db.connection.commit()

    def tearDown(self):
        self.db.close()

    def _facts(self, year=2023):
        return {f['concept_code']: f for f in
                self.db.financials.get_org_financials('888888888', year)['facts']}

    def test_null_observation_does_not_block_a_later_real_value(self):
        # A non-numeric reading (value -> NULL) must NOT become canonical, else it
        # would silently block the real value that arrives later (finding #4).
        self.db.financials.record_observations(
            '888888888', 2023, 'manual_990', {'cy_rev': 'n/a'}, actor=_actor())
        self.assertIsNone(self._facts()['cy_rev']['canonical_value'])
        self.db.financials.record_observations(
            '888888888', 2023, 'audited_statement', {'cy_rev': 1500}, actor=_actor())
        self.assertEqual(self._facts()['cy_rev']['canonical_value'], 1500.0)

    def test_set_canonical_without_actor_records_manual_and_resolves(self):
        # No authenticated actor must still resolve the conflict (chosen_by='manual',
        # never NULL — finding #5).
        self.db.financials.record_observations(
            '888888888', 2023, 'irs_990_xml', {'cy_rev': 1000}, actor=_actor())
        out = self.db.financials.record_observations(
            '888888888', 2023, 'manual_990', {'cy_rev': 1200}, actor=_actor())
        obs = out['observations'][0]['observation_id']
        self.assertTrue(self.db.financials.set_canonical('888888888', 2023, 'cy_rev', obs))
        self.assertEqual(self.db.financials.conflicts('888888888'), [])
        self.assertEqual(self._facts()['cy_rev']['chosen_by'], 'manual')

    def test_deleting_canonical_observation_reselects_a_survivor(self):
        # Two documents both report cy_rev; the first is auto-canonical. Deleting
        # that document (its observation + canonical row cascade) must re-promote
        # the survivor, not leave the fact value-less (finding #6).
        first = self.db.financials.record_observations(
            '888888888', 2023, 'irs_990_xml', {'cy_rev': 1000}, actor=_actor())
        self.db.financials.record_observations(
            '888888888', 2023, 'audited_statement', {'cy_rev': 1000}, actor=_actor())
        self.db.cursor.execute("DELETE FROM financial_document WHERE document_id = ?",
                               (first['document_id'],))
        self.db.connection.commit()
        cy = self._facts()['cy_rev']
        self.assertEqual(cy['canonical_value'], 1000.0)
        self.assertTrue(any(o['is_canonical'] for o in cy['observations']))

    def test_concept_xml_path_refreshes_on_reseed(self):
        # A stale default_xml_path must be corrected back to _PATHS on re-seed,
        # not kept by INSERT-OR-IGNORE (finding #7).
        self.db.cursor.execute(
            "UPDATE financial_concept SET default_xml_path = 'WRONG' WHERE code = 'prog'")
        self.db.connection.commit()
        self.db.financials._seed_concepts()
        row = self.db.cursor.execute(
            "SELECT default_xml_path FROM financial_concept WHERE code = 'prog'").fetchone()
        self.assertEqual(row[0], _PATHS['prog'])


class TestFinancialsRouter(unittest.TestCase):
    def setUp(self):
        self.db = OpenReturnDB(path=':memory:')
        _add_990(self.db, values={'cy_rev': 1000})
        self.db.financials.derive_from_990('123456789')
        self.router = FinancialsRouter(db=self.db)

    def tearDown(self):
        self.db.close()

    def _h(self, principal=None):
        h = MagicMock(); h.get.return_value = ""
        if principal is not None:
            h._principal = principal
        return h

    def _call(self, method, path, query_params=None, body=None, principal=None):
        return self.router.routes[method][path](
            query_params=query_params or {}, body=body, headers=self._h(principal))

    def test_permissions(self):
        self.assertEqual(self.router.routes['GET']['/financials']._permission, 'data:read')
        self.assertEqual(self.router.routes['POST']['/financials/observations']._permission, 'data:write')

    def test_concepts_route(self):
        out = self._call('GET', '/financials/concepts')
        self.assertEqual({c['code'] for c in out['concepts']}, set(_PATHS))

    def test_record_and_conflict_flow(self):
        self._call('POST', '/financials/observations',
                   body={'ein': '123456789', 'fiscal_year': 2023, 'source': 'manual_990',
                         'values': {'cy_rev': 1200}}, principal=_actor())
        out = self._call('GET', '/financials/conflicts', query_params={'ein': ['123456789']})
        self.assertEqual(len(out['conflicts']), 1)

    def test_conflict_orgs_route(self):
        self.assertEqual(self.router.routes['GET']['/financials/conflict-orgs']._permission,
                         'data:read')
        self._call('POST', '/financials/observations',
                   body={'ein': '123456789', 'fiscal_year': 2023, 'source': 'manual_990',
                         'values': {'cy_rev': 1200}}, principal=_actor())
        out = self._call('GET', '/financials/conflict-orgs')
        self.assertEqual(out['total'], 1)
        self.assertEqual(out['organizations'][0]['ein'], '123456789')
        self.assertEqual(out['organizations'][0]['conflict_count'], 1)

    def test_record_requires_fields(self):
        self.assertIn('error', self._call('POST', '/financials/observations',
                                          body={'ein': '123456789'}, principal=_actor()))

    def test_record_rejects_unknown_concept(self):
        out = self._call('POST', '/financials/observations',
                         body={'ein': '123456789', 'fiscal_year': 2023, 'source': 'manual_990',
                               'values': {'not_a_concept': 5}}, principal=_actor())
        self.assertIn('error', out)


class TestDenormalizedCanonicalValue(unittest.TestCase):
    """The chosen value is mirrored onto financial_canonical.value (so scoring reads
    it without joining financial_observation). These guard that the mirror is set at
    every write site and never drifts from the source observation's value — a drift
    would silently corrupt scores while value-mocking tests stayed green."""

    def setUp(self):
        self.db = OpenReturnDB(path=':memory:')

    def tearDown(self):
        self.db.close()

    def _mirror_drift(self) -> int:
        """0 iff every canonical row's denormalized value equals its chosen
        observation's value (NULL-safe). The definitive consistency check."""
        return self.db.cursor.execute(
            "SELECT COUNT(*) FROM financial_canonical c "
            "JOIN financial_observation o ON o.observation_id = c.observation_id "
            "WHERE c.value IS NOT o.value").fetchone()[0]

    def _canon_value(self, ein, year, concept):
        row = self.db.cursor.execute(
            "SELECT value FROM financial_canonical WHERE organization_id=? AND fiscal_year=? "
            "AND concept_code=?", (ein, year, concept)).fetchone()
        return row[0] if row else None

    def test_derive_from_990_sets_denormalized_value(self):
        _add_990(self.db, values={'prog': 800, 'total_exp': 1000})
        self.db.financials.derive_from_990('123456789')
        self.assertEqual(self._canon_value('123456789', 2023, 'prog'), 800.0)
        self.assertEqual(self._mirror_drift(), 0)

    def test_derive_bulk_whole_corpus_sets_value(self):
        _add_990(self.db, ein='111111111', values={'prog': 800, 'total_exp': 1000, 'equity': -50})
        self.db.financials.derive_bulk()
        self.assertEqual(self._canon_value('111111111', 2023, 'equity'), -50.0)
        self.assertEqual(self._mirror_drift(), 0)

    def test_derive_bulk_scoped_sets_value(self):
        _add_990(self.db, ein='111111111', values={'cy_rev': 7})
        self.db.financials.derive_bulk(eins=['111111111'])
        self.assertEqual(self._canon_value('111111111', 2023, 'cy_rev'), 7.0)
        self.assertEqual(self._mirror_drift(), 0)

    def test_bulk_canonical_value_is_min_obs_not_min_value(self):
        # Two valued observations for one fact, no canonical yet. The bulk
        # auto-canonical picks MIN(observation_id) — the FIRST inserted (value 999),
        # NOT the smallest value (111). Proves the value-join targets the picked
        # observation, not an aggregate over values.
        self.db.cursor.execute("INSERT INTO organization (ein, name) VALUES ('900000001','Co')")
        for v in (999, 111):       # one observation per document (UNIQUE(document_id, concept))
            self.db.cursor.execute(
                "INSERT INTO financial_document (organization_id, fiscal_year, source_code) "
                "VALUES ('900000001', 2023, 'manual_990')")
            doc = self.db.cursor.lastrowid
            self.db.cursor.execute(
                "INSERT INTO financial_observation (organization_id, fiscal_year, concept_code, "
                "source_code, document_id, value, raw_value) "
                "VALUES ('900000001', 2023, 'cy_rev', 'manual_990', ?, ?, ?)", (doc, v, str(v)))
        self.db.connection.commit()
        first_obs = self.db.cursor.execute(
            "SELECT MIN(observation_id) FROM financial_observation "
            "WHERE organization_id='900000001'").fetchone()[0]
        self.db.financials.derive_bulk()                                   # whole-corpus
        row = self.db.cursor.execute(
            "SELECT observation_id, value FROM financial_canonical "
            "WHERE organization_id='900000001' AND fiscal_year=2023 AND concept_code='cy_rev'").fetchone()
        self.assertEqual(row[0], first_obs)
        self.assertEqual(row[1], 999.0)                                    # MIN(obs id)'s value, not 111
        self.assertEqual(self._mirror_drift(), 0)

    def test_set_canonical_updates_value_on_both_legs(self):
        _add_990(self.db, values={'cy_rev': 1000})
        self.db.financials.derive_from_990('123456789')                    # auto-canonical 1000
        out = self.db.financials.record_observations(
            '123456789', 2023, 'manual_990', {'cy_rev': 1200}, actor=_actor())
        obs1200 = out['observations'][0]['observation_id']
        self.db.financials.set_canonical('123456789', 2023, 'cy_rev', obs1200, actor=_actor())
        self.assertEqual(self._canon_value('123456789', 2023, 'cy_rev'), 1200.0)  # DO UPDATE leg
        self.assertEqual(self._mirror_drift(), 0)
        # Re-pick back to the original observation → value follows again.
        orig = next(o['observation_id'] for o in
                    self.db.financials.get_org_financials('123456789', 2023)['facts'][0]['observations']
                    if o['value'] == 1000.0)
        self.db.financials.set_canonical('123456789', 2023, 'cy_rev', orig, actor=_actor())
        self.assertEqual(self._canon_value('123456789', 2023, 'cy_rev'), 1000.0)

    def _new_org(self, ein):
        self.db.cursor.execute("INSERT OR IGNORE INTO organization (ein, name) VALUES (?, 'Co')", (ein,))
        self.db.connection.commit()

    def test_recanonical_trigger_sets_value(self):
        # Two documents report cy_rev; first is auto-canonical. Deleting it fires the
        # AFTER DELETE trigger, which must re-promote the survivor AND set its value.
        self._new_org('910000001')
        first = self.db.financials.record_observations(
            '910000001', 2023, 'irs_990_xml', {'cy_rev': 1000}, actor=_actor())
        self.db.financials.record_observations(
            '910000001', 2023, 'audited_statement', {'cy_rev': 2000}, actor=_actor())
        self.db.cursor.execute("DELETE FROM financial_document WHERE document_id = ?",
                               (first['document_id'],))
        self.db.connection.commit()
        self.assertEqual(self._canon_value('910000001', 2023, 'cy_rev'), 2000.0)
        self.assertEqual(self._mirror_drift(), 0)

    def test_set_canonical_null_valued_obs_excluded_from_reads(self):
        # A human may pick a NULL-valued observation; canonical.value becomes NULL and
        # the read path filters it out (identical to the old o.value IS NOT NULL).
        self._new_org('920000001')
        self.db.financials.record_observations(
            '920000001', 2023, 'irs_990_xml', {'cy_rev': 1000}, actor=_actor())
        out = self.db.financials.record_observations(
            '920000001', 2023, 'manual_990', {'cy_rev': 'n/a'}, actor=_actor())   # value → NULL
        null_obs = out['observations'][0]['observation_id']
        self.assertTrue(self.db.financials.set_canonical(
            '920000001', 2023, 'cy_rev', null_obs, actor=_actor()))
        self.assertIsNone(self._canon_value('920000001', 2023, 'cy_rev'))
        self.assertNotIn('cy_rev', self.db.financials.get_year_canonical_values('920000001', 2023))

    def test_backfill_fills_null_values_and_is_idempotent(self):
        _add_990(self.db, ein='111111111', values={'prog': 5, 'total_exp': 9})
        self.db.financials.derive_bulk()
        # Simulate a pre-upgrade DB: null out the denormalized values.
        self.db.cursor.execute("UPDATE financial_canonical SET value = NULL")
        self.db.connection.commit()
        self.assertGreater(self.db.financials.backfill_canonical_values(batch=1), 0)
        self.assertEqual(self._canon_value('111111111', 2023, 'prog'), 5.0)
        self.assertEqual(self._mirror_drift(), 0)
        self.assertEqual(self.db.financials.backfill_canonical_values(), 0)        # no-op re-run

    def test_migrate_columns_idempotent_and_trigger_value_aware(self):
        self.db.financials._migrate_columns()                                      # second run, no error
        trig = self.db.cursor.execute(
            "SELECT sql FROM sqlite_master WHERE name='trg_fobs_recanonical'").fetchone()[0]
        self.assertIn('value', trig)

    def test_migrate_auto_backfills_unfilled_values(self):
        # The migrate-then-score window is closed: a legacy DB whose canonical values
        # are still NULL (and whose backfill marker is absent) is auto-filled when the
        # migration step runs at DB open — so the value-filtered reads never silently
        # see un-backfilled NULLs.
        from database.Financials.financials import _BACKFILL_MARKER
        _add_990(self.db, ein='111111111', values={'prog': 5, 'total_exp': 9})
        self.db.financials.derive_bulk()
        self.db.cursor.execute("UPDATE financial_canonical SET value = NULL")       # simulate pre-backfill
        self.db.cursor.execute("DELETE FROM migration WHERE name = ?", (_BACKFILL_MARKER,))
        self.db.connection.commit()
        self.db.financials._migrate_columns()                                       # as a real re-open would
        self.assertEqual(self._canon_value('111111111', 2023, 'prog'), 5.0)
        self.assertEqual(self._mirror_drift(), 0)
        self.assertTrue(self.db.cursor.execute(
            "SELECT 1 FROM migration WHERE name = ?", (_BACKFILL_MARKER,)).fetchone())


if __name__ == '__main__':
    unittest.main()
