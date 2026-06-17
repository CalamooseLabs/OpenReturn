import re

from database.base import Database


class AppearanceDatabase(Database):
  """The graph layer (reached as ``db.appearances``): people, grants, and
  related-org edges extracted from repeating XML groups, plus the resolved
  ``party`` nodes.

  A ``Database`` subclass sharing the coordinator's connection. Owns
  ``party_appearance`` (one un-resolved node-appearance per repeating-group
  instance, with the address inline as filed) and the typed edge tables
  ``person_role`` / ``grant_edge`` / ``related_org``. ``party`` holds the
  canonical nodes, populated by :meth:`resolve` (the ``openreturn resolve`` step),
  never by ingest. See ``docs/development/graph-model.md``.
  """

  _APPEARANCE_COLS = (
    "filing_id, group_code, occurrence_index, party_kind, person_name, "
    "business_name, appearance_ein, address_uuid")

  _INSERT_ADDRESS = (
    "INSERT OR IGNORE INTO address (uuid, address_kind, street, street2, city, "
    "state_code, zipcode, province, country_code, foreign_postal) "
    "VALUES (?,?,?,?,?,?,?,?,?,?)")

  def __init__(self, db) -> None:
    self._db = db
    super().__init__("Appearance", "Appearance", connection=db.connection, cursor=db.cursor)

  # -- write -----------------------------------------------------------------

  def store_filing_graph(self, filing_uuid: str, records: list[dict]) -> int:
    """Insert the extracted repeating-group records for one filing.

    ``filing_uuid`` is the public uuid (resolved to the integer filing_id like
    ``store_reported_data``); ``records`` is :func:`parser.groups.extract_groups`
    output. Idempotent: every row is ``INSERT OR IGNORE`` on its
    ``(filing_id, group_code, occurrence_index)`` natural key, so a re-store is a
    no-op. Returns the number of records processed."""
    row = self.cursor.execute(
      "SELECT filing_id FROM filing WHERE uuid = ?", (filing_uuid,)).fetchone()
    if not row:
      return 0
    fid = row[0]
    for rec in records:
      self._store_record(fid, rec)
    return len(records)

  def _store_record(self, fid: int, rec: dict) -> None:
    addr = rec.get("address")
    addr_uuid = None
    if addr:
      addr_uuid = f"ap:{fid}:{rec['group_code']}:{rec['occurrence_index']}"
      self.cursor.execute(self._INSERT_ADDRESS, (
        addr_uuid, addr.get("address_kind"), addr.get("street"), addr.get("street2"),
        addr.get("city"), addr.get("state_code"), addr.get("zipcode"),
        addr.get("province"), addr.get("country_code"), addr.get("foreign_postal")))
    self.cursor.execute(
      f"INSERT OR IGNORE INTO party_appearance ({self._APPEARANCE_COLS}) "
      f"VALUES ({', '.join(['?'] * 8)})",
      (fid, rec["group_code"], rec["occurrence_index"], rec["party_kind"],
       rec.get("person_name"), rec.get("business_name"), rec.get("ein"), addr_uuid))
    ap = self.cursor.execute(
      "SELECT appearance_id FROM party_appearance "
      "WHERE filing_id = ? AND group_code = ? AND occurrence_index = ?",
      (fid, rec["group_code"], rec["occurrence_index"])).fetchone()[0]
    e = rec.get("edge", {})
    key = (fid, rec["group_code"], rec["occurrence_index"])
    if rec["kind"] == "person_role":
      self.cursor.execute(
        "INSERT OR IGNORE INTO person_role (filing_id, appearance_id, group_code, "
        "occurrence_index, title, avg_hours_org, avg_hours_related, is_officer, "
        "is_director_trustee, is_key_employee, is_highest_comp, is_former, "
        "reportable_comp_org, reportable_comp_related, other_comp) "
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
        (fid, ap, key[1], key[2], e.get("title"), e.get("avg_hours_org"),
         e.get("avg_hours_related"), e.get("is_officer"), e.get("is_director_trustee"),
         e.get("is_key_employee"), e.get("is_highest_comp"), e.get("is_former"),
         e.get("reportable_comp_org"), e.get("reportable_comp_related"), e.get("other_comp")))
    elif rec["kind"] == "grant":
      self.cursor.execute(
        "INSERT OR IGNORE INTO grant_edge (filing_id, appearance_id, group_code, "
        "occurrence_index, grant_kind, recipient_ein, cash_amount, noncash_amount, "
        "purpose_txt, irc_section, recipient_relationship, recipient_foundation_status) "
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
        (fid, ap, key[1], key[2], e.get("tag"), rec.get("ein"), e.get("cash_amount"),
         e.get("noncash_amount"), e.get("purpose_txt"), e.get("irc_section"),
         e.get("recipient_relationship"), e.get("recipient_foundation_status")))
    elif rec["kind"] == "related_org":
      self.cursor.execute(
        "INSERT OR IGNORE INTO related_org (filing_id, appearance_id, group_code, "
        "occurrence_index, relation_kind, related_ein, primary_activities, "
        "legal_domicile, ownership_pct, control_ind) "
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
        (fid, ap, key[1], key[2], e.get("tag"), rec.get("ein"),
         e.get("primary_activities"), e.get("legal_domicile"),
         e.get("ownership_pct"), e.get("control_ind")))

  # -- resolve (the `openreturn resolve` step; not part of ingest) ------------

  @staticmethod
  def _norm(s: str | None) -> str:
    return re.sub(r"[^a-z0-9 ]", "", (s or "").lower()).strip()

  @classmethod
  def _identity(cls, party_kind: str, person_name, business_name, ein) -> tuple | None:
    """Deterministic (party_type, canonical_name, ein, cluster_key) for a
    conservative first resolver — exact normalized name (+ EIN for orgs). A miss
    leaves a singleton node, never a wrong merge. None if there is no name."""
    if party_kind == "person":
      n = cls._norm(person_name)
      return ("person", person_name, None, f"P:{n}") if n else None
    name = business_name or person_name
    n = cls._norm(name)
    if ein:
      return ("organization", name, ein, f"O#{ein}")
    return ("organization", name, None, f"O:{n}") if n else None

  def resolve(self, resolver_version: int = 1) -> dict:
    """Cluster appearances into canonical ``party`` nodes and backfill
    ``party_appearance.resolved_party_id``. Re-runnable and idempotent
    (``INSERT OR IGNORE`` on the deterministic cluster_key). Returns counts."""
    rows = self.cursor.execute(
      "SELECT appearance_id, party_kind, person_name, business_name, appearance_ein "
      "FROM party_appearance").fetchall()
    parties = 0
    for ap_id, kind, person, business, ein in rows:
      ident = self._identity(kind, person, business, ein)
      if ident is None:
        continue
      ptype, cname, pein, ckey = ident
      cur = self.cursor.execute(
        "INSERT OR IGNORE INTO party (party_type, canonical_name, ein, cluster_key, "
        "resolver_version) VALUES (?, ?, ?, ?, ?)", (ptype, cname, pein, ckey, resolver_version))
      parties += cur.rowcount
      pid = self.cursor.execute(
        "SELECT party_id FROM party WHERE cluster_key = ?", (ckey,)).fetchone()[0]
      self.cursor.execute(
        "UPDATE party_appearance SET resolved_party_id = ? WHERE appearance_id = ?",
        (pid, ap_id))
    self.connection.commit()
    return {"appearances": len(rows), "parties_created": parties}

  # -- read ------------------------------------------------------------------

  def get_filing_graph(self, filing_uuid: str) -> dict:
    """All graph edges for one filing, grouped by kind (people / grants /
    related orgs), each joined to its appearance node."""
    fid_row = self.cursor.execute(
      "SELECT filing_id FROM filing WHERE uuid = ?", (filing_uuid,)).fetchone()
    if not fid_row:
      return {"people": [], "grants": [], "related_orgs": []}
    fid = fid_row[0]

    people = [
      {"name": r[0] or r[1], "title": r[2], "is_officer": r[3], "is_director_trustee": r[4],
       "is_key_employee": r[5], "is_highest_comp": r[6], "reportable_comp_org": r[7],
       "other_comp": r[8], "resolved_party_id": r[9]}
      for r in self.cursor.execute(
        "SELECT pa.person_name, pa.business_name, pr.title, pr.is_officer, "
        "pr.is_director_trustee, pr.is_key_employee, pr.is_highest_comp, "
        "pr.reportable_comp_org, pr.other_comp, pa.resolved_party_id "
        "FROM person_role pr JOIN party_appearance pa ON pa.appearance_id = pr.appearance_id "
        "WHERE pr.filing_id = ? ORDER BY pr.group_code, pr.occurrence_index", (fid,)).fetchall()]
    grants = [
      {"recipient": r[0] or r[1], "recipient_ein": r[2], "grant_kind": r[3],
       "cash_amount": r[4], "purpose": r[5], "foundation_status": r[6],
       "resolved_party_id": r[7]}
      for r in self.cursor.execute(
        "SELECT pa.business_name, pa.person_name, g.recipient_ein, g.grant_kind, "
        "g.cash_amount, g.purpose_txt, g.recipient_foundation_status, pa.resolved_party_id "
        "FROM grant_edge g JOIN party_appearance pa ON pa.appearance_id = g.appearance_id "
        "WHERE g.filing_id = ? ORDER BY g.group_code, g.occurrence_index", (fid,)).fetchall()]
    related = [
      {"name": r[0], "related_ein": r[1], "relation_kind": r[2],
       "ownership_pct": r[3], "resolved_party_id": r[4]}
      for r in self.cursor.execute(
        "SELECT pa.business_name, ro.related_ein, ro.relation_kind, ro.ownership_pct, "
        "pa.resolved_party_id "
        "FROM related_org ro JOIN party_appearance pa ON pa.appearance_id = ro.appearance_id "
        "WHERE ro.filing_id = ? ORDER BY ro.group_code, ro.occurrence_index", (fid,)).fetchall()]
    return {"people": people, "grants": grants, "related_orgs": related}

  @staticmethod
  def _grant_summary(grants: list[dict], *, key: str) -> dict:
    """Roll a list of grant rows into totals: count, summed amount, distinct
    counterparties (by ``key``), and amount by year (newest first)."""
    by_year: dict[int, float] = {}
    parties = set()
    total = 0.0
    for g in grants:
      total += g["amount"]
      by_year[g["year"]] = by_year.get(g["year"], 0.0) + g["amount"]
      if g.get(key):
        parties.add(g[key])
    return {"grant_count": len(grants), "total_amount": total,
            "counterparties": len(parties),
            "by_year": [{"year": y, "amount": by_year[y]} for y in sorted(by_year, reverse=True)]}

  def grants_made(self, ein: str) -> dict:
    """A grantor org's **outbound** grants (the foundation/grantmaker → recipients
    view): every grant_edge on the org's filings, joined to the grantee appearance
    (+ its resolved canonical party). ``amount`` is cash + non-cash. For a 990-PF
    grant the recipient EIN is only known once ``openreturn resolve`` links the
    grantee to a party; Schedule-I grants carry the EIN as filed."""
    ein = self._db.orgs.try_normalize_ein(ein)
    rows = self.cursor.execute(
      "SELECT f.year, pa.business_name, pa.person_name, "
      "       COALESCE(g.recipient_ein, p.ein) AS recipient_ein, g.grant_kind, "
      "       g.cash_amount, g.noncash_amount, g.purpose_txt, "
      "       g.recipient_foundation_status, pa.resolved_party_id, p.canonical_name "
      "FROM filing f "
      "JOIN grant_edge g ON g.filing_id = f.filing_id "
      "JOIN party_appearance pa ON pa.appearance_id = g.appearance_id "
      "LEFT JOIN party p ON p.party_id = pa.resolved_party_id "
      "WHERE f.organization_id = ? "
      "ORDER BY f.year DESC, g.cash_amount DESC", (ein,)).fetchall()
    grants = [{"year": r[0], "recipient": r[10] or r[1] or r[2], "recipient_ein": r[3],
               "grant_kind": r[4], "cash_amount": r[5], "noncash_amount": r[6],
               "amount": (r[5] or 0.0) + (r[6] or 0.0), "purpose": r[7],
               "foundation_status": r[8], "resolved_party_id": r[9]} for r in rows]
    return {"ein": ein, "direction": "made",
            "summary": self._grant_summary(grants, key="recipient_ein"), "grants": grants}

  def grants_received(self, ein: str) -> dict:
    """An org's **inbound** grants (who funds this nonprofit): grant_edges whose
    recipient EIN is this org (Schedule-I, matched directly) or whose grantee
    appearance resolves to a party with this EIN (990-PF, after ``openreturn
    resolve``), joined to the grantor filer org."""
    ein = self._db.orgs.try_normalize_ein(ein)
    rows = self.cursor.execute(
      "SELECT f.year, f.organization_id, o.name, g.grant_kind, "
      "       g.cash_amount, g.noncash_amount, g.purpose_txt "
      "FROM grant_edge g "
      "JOIN filing f ON f.filing_id = g.filing_id "
      "LEFT JOIN organization o ON o.ein = f.organization_id "
      "LEFT JOIN party_appearance pa ON pa.appearance_id = g.appearance_id "
      "LEFT JOIN party p ON p.party_id = pa.resolved_party_id "
      "WHERE g.recipient_ein = ? OR p.ein = ? "
      "ORDER BY f.year DESC, g.cash_amount DESC", (ein, ein)).fetchall()
    grants = [{"year": r[0], "grantor_ein": r[1], "grantor": r[2] or r[1],
               "grant_kind": r[3], "cash_amount": r[4], "noncash_amount": r[5],
               "amount": (r[4] or 0.0) + (r[5] or 0.0), "purpose": r[6]} for r in rows]
    return {"ein": ein, "direction": "received",
            "summary": self._grant_summary(grants, key="grantor_ein"), "grants": grants}

  def graph_counts(self) -> dict:
    """Row counts for the graph tables (for status / coverage reporting)."""
    out = {}
    for tbl in ("party_appearance", "person_role", "grant_edge", "related_org", "party"):
      out[tbl] = self.cursor.execute(f"SELECT COUNT(*) FROM {tbl}").fetchone()[0]
    return out
