"""Tests for the graph layer — parser.groups.extract_groups (repeating-group
extraction) and database.Appearance (store_filing_graph / resolve / readers)."""

import argparse
import os
import sys
import tempfile
import unittest
import xml.etree.ElementTree as ET

_ROOT = os.path.join(os.path.dirname(__file__), '..')
_SRC = os.path.join(_ROOT, 'src')
sys.path.insert(0, _SRC)

from parser.groups import extract_groups, _real, _bool
from database import OpenReturnDB
from ingest import new_graph_buffer, buffer_graph, _flush_graph

_NS = 'http://www.irs.gov/efile'

# A synthetic return exercising: 2 officers (990 Part VII-A, one a person one a
# business institutional trustee), 2 PF grants (paid, one to a person), 1 PF grant
# approved, 1 Schedule I org grant (with EIN + address), 1 Schedule R related org.
_XML = f"""<?xml version="1.0"?>
<Return xmlns="{_NS}">
  <ReturnHeader>
    <Filer><EIN>111111111</EIN></Filer>
  </ReturnHeader>
  <ReturnData>
    <IRS990>
      <Form990PartVIISectionAGrp>
        <PersonNm>Jane Doe</PersonNm>
        <TitleTxt>President</TitleTxt>
        <AverageHoursPerWeekRt>40.0</AverageHoursPerWeekRt>
        <OfficerInd>true</OfficerInd>
        <ReportableCompFromOrgAmt>120000</ReportableCompFromOrgAmt>
        <OtherCompensationAmt>5000</OtherCompensationAmt>
      </Form990PartVIISectionAGrp>
      <Form990PartVIISectionAGrp>
        <BusinessName><BusinessNameLine1Txt>Acme Trust Co</BusinessNameLine1Txt></BusinessName>
        <TitleTxt>Trustee</TitleTxt>
        <IndividualTrusteeOrDirectorInd>1</IndividualTrusteeOrDirectorInd>
        <ReportableCompFromOrgAmt>0</ReportableCompFromOrgAmt>
      </Form990PartVIISectionAGrp>
      <ScheduleI>placeholder-not-a-real-path</ScheduleI>
    </IRS990>
    <IRS990ScheduleI>
      <RecipientTable>
        <RecipientEIN>222222222</RecipientEIN>
        <RecipientBusinessName><BusinessNameLine1Txt>Helping Hands Inc</BusinessNameLine1Txt></RecipientBusinessName>
        <USAddress>
          <AddressLine1Txt>1 Main St</AddressLine1Txt>
          <CityNm>Austin</CityNm>
          <StateAbbreviationCd>TX</StateAbbreviationCd>
          <ZIPCd>78701</ZIPCd>
        </USAddress>
        <CashGrantAmt>50000</CashGrantAmt>
        <PurposeOfGrantTxt>General support</PurposeOfGrantTxt>
      </RecipientTable>
    </IRS990ScheduleI>
    <IRS990ScheduleR>
      <IdRelatedTaxExemptOrgGrp>
        <EIN>333333333</EIN>
        <RelatedOrganizationName><BusinessNameLine1Txt>Sister Org</BusinessNameLine1Txt></RelatedOrganizationName>
        <PrimaryActivitiesTxt>Education</PrimaryActivitiesTxt>
        <LegalDomicileStateCd>TX</LegalDomicileStateCd>
        <ControlledOrganizationInd>true</ControlledOrganizationInd>
      </IdRelatedTaxExemptOrgGrp>
    </IRS990ScheduleR>
  </ReturnData>
</Return>"""

_PF_XML = f"""<?xml version="1.0"?>
<Return xmlns="{_NS}">
  <ReturnData>
    <IRS990PF>
      <SupplementaryInformationGrp>
        <GrantOrContributionPdDurYrGrp>
          <RecipientBusinessName><BusinessNameLine1Txt>Food Bank</BusinessNameLine1Txt></RecipientBusinessName>
          <RecipientFoundationStatusTxt>PC</RecipientFoundationStatusTxt>
          <GrantOrContributionPurposeTxt>Meals</GrantOrContributionPurposeTxt>
          <Amt>25000</Amt>
          <RecipientForeignAddress>
            <AddressLine1Txt>10 Rue</AddressLine1Txt>
            <CityNm>Paris</CityNm>
            <CountryCd>FR</CountryCd>
            <ForeignPostalCd>75001</ForeignPostalCd>
          </RecipientForeignAddress>
        </GrantOrContributionPdDurYrGrp>
        <GrantOrContributionPdDurYrGrp>
          <RecipientPersonNm>John Smith</RecipientPersonNm>
          <Amt>1000</Amt>
        </GrantOrContributionPdDurYrGrp>
        <GrantOrContriApprvForFutGrp>
          <RecipientBusinessName><BusinessNameLine1Txt>Future Fund</BusinessNameLine1Txt></RecipientBusinessName>
          <Amt>9000</Amt>
        </GrantOrContriApprvForFutGrp>
      </SupplementaryInformationGrp>
    </IRS990PF>
  </ReturnData>
</Return>"""


class TestExtractGroups(unittest.TestCase):
  def setUp(self):
    self.recs = extract_groups(ET.fromstring(_XML))

  def _of(self, group_code):
    return [r for r in self.recs if r['group_code'] == group_code]

  def test_officers_extracted_in_order(self):
    officers = self._of('F990_PART7A')
    self.assertEqual(len(officers), 2)
    self.assertEqual(officers[0]['occurrence_index'], 0)
    self.assertEqual(officers[0]['person_name'], 'Jane Doe')
    self.assertEqual(officers[0]['party_kind'], 'person')
    self.assertEqual(officers[0]['edge']['is_officer'], 1)
    self.assertEqual(officers[0]['edge']['reportable_comp_org'], 120000.0)
    # second is an institutional trustee → business, occurrence 1
    self.assertEqual(officers[1]['occurrence_index'], 1)
    self.assertEqual(officers[1]['business_name'], 'Acme Trust Co')
    self.assertEqual(officers[1]['party_kind'], 'organization')

  def test_schedule_i_has_ein_and_address(self):
    g = self._of('SCHED_I_ORG')
    self.assertEqual(len(g), 1)
    self.assertEqual(g[0]['ein'], '222222222')
    self.assertEqual(g[0]['edge']['tag'], 'SCHED_I_ORG')
    self.assertEqual(g[0]['edge']['cash_amount'], 50000.0)
    self.assertEqual(g[0]['address']['address_kind'], 'US')
    self.assertEqual(g[0]['address']['state_code'], 'TX')

  def test_schedule_r_related_org(self):
    g = self._of('SCHED_R_EXEMPT')
    self.assertEqual(len(g), 1)
    self.assertEqual(g[0]['ein'], '333333333')
    self.assertEqual(g[0]['edge']['control_ind'], 1)
    self.assertEqual(g[0]['edge']['legal_domicile'], 'TX')

  def test_pf_grants_paid_and_approved(self):
    recs = extract_groups(ET.fromstring(_PF_XML))
    paid = [r for r in recs if r['group_code'] == 'PF_GRANT_PAID']
    approved = [r for r in recs if r['group_code'] == 'PF_GRANT_APPROVED']
    self.assertEqual(len(paid), 2)
    self.assertEqual(len(approved), 1)
    self.assertEqual(paid[0]['business_name'], 'Food Bank')
    self.assertIsNone(paid[0]['ein'])                       # PF grants carry no EIN
    self.assertEqual(paid[0]['edge']['cash_amount'], 25000.0)
    self.assertEqual(paid[0]['address']['address_kind'], 'FOREIGN')
    self.assertEqual(paid[0]['address']['country_code'], 'FR')
    self.assertEqual(paid[1]['person_name'], 'John Smith')  # grant to an individual
    self.assertEqual(paid[1]['party_kind'], 'person')

  def test_real_and_bool_parsing(self):
    g = ET.fromstring('<G><Amt>N/A</Amt><B>false</B><C>maybe</C><D>1,250</D></G>')
    self.assertIsNone(_real(g, 'Amt'))      # non-numeric → None
    self.assertEqual(_real(g, 'D'), 1250.0)  # commas stripped
    self.assertEqual(_bool(g, 'B'), 0)       # false → 0
    self.assertIsNone(_bool(g, 'C'))         # unrecognized → None

  def test_empty_groups_skipped(self):
    # A container with no name leaf yields no record.
    xml = f'<Return xmlns="{_NS}"><ReturnData><IRS990>' \
          '<Form990PartVIISectionAGrp><TitleTxt>x</TitleTxt></Form990PartVIISectionAGrp>' \
          '</IRS990></ReturnData></Return>'
    self.assertEqual(extract_groups(ET.fromstring(xml)), [])


class TestAppearanceStore(unittest.TestCase):
  def setUp(self):
    self.db = OpenReturnDB(path=':memory:')
    self.db.orgs.upsert_organization('111111111', 'Test Org')
    self.uuid = self.db.filings.create_filing('111111111', 2023, '990')
    self.db.commit()

  def test_store_and_read_round_trip(self):
    n = self.db.appearances.store_filing_graph(self.uuid, extract_groups(ET.fromstring(_XML)))
    self.db.commit()
    self.assertEqual(n, 4)   # 2 officers + 1 sched I + 1 sched R
    graph = self.db.appearances.get_filing_graph(self.uuid)
    self.assertEqual(len(graph['people']), 2)
    self.assertEqual(graph['people'][0]['name'], 'Jane Doe')
    self.assertEqual(graph['people'][0]['reportable_comp_org'], 120000.0)
    self.assertEqual(len(graph['grants']), 1)
    self.assertEqual(graph['grants'][0]['recipient_ein'], '222222222')
    self.assertEqual(len(graph['related_orgs']), 1)
    self.assertEqual(graph['related_orgs'][0]['related_ein'], '333333333')
    # The Schedule I recipient's address lands in the SHARED address table,
    # linked from party_appearance.address_uuid (deterministic owner key).
    fid = self.db.cursor.execute(
      "SELECT filing_id FROM filing WHERE uuid = ?", (self.uuid,)).fetchone()[0]
    row = self.db.cursor.execute(
      "SELECT a.state_code, a.city FROM party_appearance pa JOIN address a "
      "ON a.uuid = pa.address_uuid WHERE pa.filing_id = ? AND pa.group_code = 'SCHED_I_ORG'",
      (fid,)).fetchone()
    self.assertEqual(row, ('TX', 'Austin'))

  def test_store_is_idempotent(self):
    recs = extract_groups(ET.fromstring(_XML))
    self.db.appearances.store_filing_graph(self.uuid, recs)
    self.db.appearances.store_filing_graph(self.uuid, recs)   # re-store
    self.db.commit()
    counts = self.db.appearances.graph_counts()
    self.assertEqual(counts['party_appearance'], 4)
    self.assertEqual(counts['person_role'], 2)

  def test_store_unknown_filing_is_noop(self):
    n = self.db.appearances.store_filing_graph('no-such-uuid', extract_groups(ET.fromstring(_XML)))
    self.assertEqual(n, 0)

  def test_resolve_clusters_repeated_person(self):
    # Same officer name on two filings → one party node, both appearances resolved.
    self.db.appearances.store_filing_graph(self.uuid, extract_groups(ET.fromstring(_XML)))
    u2 = self.db.filings.create_filing('111111111', 2022, '990')
    self.db.appearances.store_filing_graph(u2, extract_groups(ET.fromstring(_XML)))
    self.db.commit()
    res = self.db.appearances.resolve(resolver_version=1)
    self.assertEqual(res['appearances'], 8)        # 4 records x 2 filings
    # Jane Doe appears twice but resolves to ONE party; idempotent re-run.
    before = self.db.appearances.graph_counts()['party']
    self.db.appearances.resolve(resolver_version=1)
    self.assertEqual(self.db.appearances.graph_counts()['party'], before)
    jane = self.db.cursor.execute(
      "SELECT COUNT(DISTINCT resolved_party_id) FROM party_appearance WHERE person_name = 'Jane Doe'"
    ).fetchone()[0]
    self.assertEqual(jane, 1)

  def test_get_filing_graph_unknown_filing(self):
    self.assertEqual(self.db.appearances.get_filing_graph('nope'),
                     {"people": [], "grants": [], "related_orgs": []})

  def test_resolve_skips_unnamed_appearance(self):
    # A directly-inserted appearance with no name yields no identity → skipped.
    fid = self.db.cursor.execute(
      "SELECT filing_id FROM filing WHERE uuid = ?", (self.uuid,)).fetchone()[0]
    self.db.cursor.execute(
      "INSERT INTO party_appearance (filing_id, group_code, occurrence_index, party_kind) "
      "VALUES (?, 'X', 0, 'person')", (fid,))
    self.db.commit()
    self.db.appearances.resolve()
    unresolved = self.db.cursor.execute(
      "SELECT resolved_party_id FROM party_appearance WHERE group_code = 'X'").fetchone()[0]
    self.assertIsNone(unresolved)

  def test_legacy_address_table_gains_foreign_columns(self):
    # A pre-foreign nullable address table is migrated in place (ALTER ADD COLUMN),
    # not rebuilt — the org join keeps working and graph/foreign addresses fit.
    self.db.cursor.execute("DROP TABLE address")
    self.db.cursor.execute(
      "CREATE TABLE address (uuid CHARACTER(36) PRIMARY KEY, street TEXT, city TEXT, "
      "state_code CHARACTER(2), zipcode TEXT)")
    self.db.connection.commit()
    self.db.orgs._migrate_schema()
    cols = {c[1] for c in self.db.cursor.execute("PRAGMA table_info(address)").fetchall()}
    for c in ('address_kind', 'street2', 'province', 'country_code', 'foreign_postal'):
      self.assertIn(c, cols)

  def test_resolve_org_by_ein(self):
    self.db.appearances.store_filing_graph(self.uuid, extract_groups(ET.fromstring(_XML)))
    self.db.commit()
    self.db.appearances.resolve()
    # Schedule I recipient (EIN 222222222) resolves to an organization party keyed on EIN.
    row = self.db.cursor.execute(
      "SELECT party_type, ein FROM party WHERE ein = '222222222'").fetchone()
    self.assertEqual(row, ('organization', '222222222'))


class TestBulkGraphFlush(unittest.TestCase):
  """The parallel-ingest pipeline: buffer_graph -> _flush_graph (appearance-id
  resolution by natural key, filing-id remap, idempotent INSERT OR IGNORE)."""

  def setUp(self):
    self.db = OpenReturnDB(path=':memory:')
    self.db.orgs.upsert_organization('111111111', 'Test Org')
    uuid = self.db.filings.create_filing('111111111', 2023, '990')
    self.db.commit()
    self.fid = self.db.cursor.execute(
      "SELECT filing_id FROM filing WHERE uuid = ?", (uuid,)).fetchone()[0]

  def _flush(self, pre_id, id_remap=None):
    pg = new_graph_buffer()
    buffer_graph(pg, pre_id, extract_groups(ET.fromstring(_XML)))
    _flush_graph(self.db, pg, id_remap or {})
    self.db.commit()

  def _counts(self):
    return self.db.appearances.graph_counts()

  def test_flush_populates_and_links(self):
    self._flush(self.fid)
    c = self._counts()
    self.assertEqual(c['party_appearance'], 4)
    self.assertEqual(c['person_role'], 2)
    self.assertEqual(c['grant_edge'], 1)
    self.assertEqual(c['related_org'], 1)
    # Every edge resolves to a real appearance row (FK integrity).
    orphans = self.db.cursor.execute(
      "SELECT COUNT(*) FROM person_role pr LEFT JOIN party_appearance pa "
      "ON pa.appearance_id = pr.appearance_id WHERE pa.appearance_id IS NULL").fetchone()[0]
    self.assertEqual(orphans, 0)

  def test_flush_is_idempotent(self):
    self._flush(self.fid)
    self._flush(self.fid)            # re-ingest the same filing
    self.assertEqual(self._counts()['party_appearance'], 4)
    self.assertEqual(self._counts()['person_role'], 2)

  def test_filing_id_remap_collision(self):
    # Buffered under a client pre_id (777) that remaps to the real filing_id —
    # rows must land under the real filing, not the client id.
    self._flush(777, id_remap={777: self.fid})
    landed = self.db.cursor.execute(
      "SELECT COUNT(*) FROM party_appearance WHERE filing_id = ?", (self.fid,)).fetchone()[0]
    self.assertEqual(landed, 4)
    stray = self.db.cursor.execute(
      "SELECT COUNT(*) FROM party_appearance WHERE filing_id = 777").fetchone()[0]
    self.assertEqual(stray, 0)


class TestResolveCLI(unittest.TestCase):
  """`openreturn resolve` (src/resolve.py:cmd_resolve)."""

  def test_db_not_found(self):
    from resolve import cmd_resolve
    self.assertEqual(cmd_resolve(argparse.Namespace(db='/no/such.db', version=1)), 1)

  def test_no_appearances_is_ok(self):
    from resolve import cmd_resolve
    path = tempfile.mktemp(suffix='.db')
    OpenReturnDB(path=path).close()
    try:
      self.assertEqual(cmd_resolve(argparse.Namespace(db=path, version=1)), 0)
    finally:
      os.unlink(path)

  def test_resolve_populates_party_nodes(self):
    from resolve import cmd_resolve
    path = tempfile.mktemp(suffix='.db')
    db = OpenReturnDB(path=path)
    db.orgs.upsert_organization('111111111', 'Org')
    u = db.filings.create_filing('111111111', 2023, '990')
    db.appearances.store_filing_graph(u, extract_groups(ET.fromstring(_XML)))
    db.commit()
    db.close()
    try:
      self.assertEqual(cmd_resolve(argparse.Namespace(db=path, version=2)), 0)
      db2 = OpenReturnDB(path=path)
      self.assertGreater(db2.appearances.graph_counts()['party'], 0)
      db2.close()
    finally:
      os.unlink(path)


class TestScoreFilingKeyMigration(unittest.TestCase):
  """ScoreDatabase._migrate_filing_key rebuilds a legacy uuid-keyed
  organization_score into the integer filing.filing_id."""

  def test_legacy_uuid_key_migrated_to_int(self):
    db = OpenReturnDB(path=':memory:')
    model_id = db.cursor.execute(
      "SELECT model_id FROM score_model ORDER BY model_id LIMIT 1").fetchone()[0]
    db.orgs.upsert_organization('111111111', 'Org')
    u = db.filings.create_filing('111111111', 2023, '990')
    fid = db.cursor.execute("SELECT filing_id FROM filing WHERE uuid = ?", (u,)).fetchone()[0]
    # Recreate a legacy organization_score keyed by the filing uuid + a score row.
    db.cursor.execute("DROP TABLE organization_score")
    db.cursor.execute(
      "CREATE TABLE organization_score (score_id INTEGER PRIMARY KEY AUTOINCREMENT, "
      "filing_id CHARACTER(36) NOT NULL REFERENCES filing (uuid), "
      "model_id INTEGER NOT NULL REFERENCES score_model (model_id), total_score REAL, "
      "scored_at DATETIME DEFAULT CURRENT_TIMESTAMP, UNIQUE (filing_id, model_id))")
    db.cursor.execute(
      "INSERT INTO organization_score (filing_id, model_id, total_score) VALUES (?, ?, 5.0)",
      (u, model_id))
    db.connection.commit()

    db.scores._migrate_filing_key()

    col = next(c for c in db.cursor.execute("PRAGMA table_info(organization_score)").fetchall()
               if c[1] == 'filing_id')
    self.assertIn('INT', (col[2] or '').upper())          # column is now INTEGER
    self.assertEqual(
      db.cursor.execute("SELECT filing_id, total_score FROM organization_score").fetchone(),
      (fid, 5.0))                                          # value converted, score preserved


if __name__ == '__main__':
  unittest.main()
