import uuid as _uuid

from database.base import Database
from scoring.engine import _PATHS  # concept code → 990 xml_path (single source of truth)

# Nicer labels/categories for the seeded concepts; anything unlisted falls back
# to the code with no category.
_CONCEPT_META: dict[str, tuple[str, str]] = {
  'prog': ('Program service expenses', 'expense'),
  'admin': ('Management & general expenses', 'expense'),
  'fund': ('Fundraising expenses', 'expense'),
  'total_exp': ('Total functional expenses', 'expense'),
  'cy_exp': ('Current-year total expenses', 'expense'),
  'py_exp': ('Prior-year total expenses', 'expense'),
  'cy_rev': ('Current-year total revenue', 'revenue'),
  'cy_grants': ('Current-year grants paid', 'expense'),
  'py_grants': ('Prior-year grants paid', 'expense'),
  'contrib': ('Total contributions', 'revenue'),
  'gov_grants': ('Government grants', 'revenue'),
  'invest_inc': ('Investment income', 'revenue'),
  'assets': ('Total assets (EOY)', 'balance'),
  'liabilities': ('Total liabilities (EOY)', 'balance'),
  'equity': ('Net assets / fund balances (EOY)', 'balance'),
  'cash': ('Cash (EOY)', 'balance'),
  'savings': ('Savings & temp cash investments (EOY)', 'balance'),
  'invest_val': ('Other investments (EOY)', 'balance'),
  'accts_pay': ('Accounts payable & accrued expenses (EOY)', 'balance'),
  # 990-PF (private foundation)
  'pf_charitable_disb': ('Total charitable disbursements (990-PF)', 'expense'),
  'pf_grants_paid': ('Contributions & grants paid (990-PF)', 'expense'),
  'pf_total_exp': ('Total expenses (990-PF)', 'expense'),
  'pf_total_assets': ('Total assets EOY (990-PF)', 'balance'),
  'pf_net_assets': ('Net assets / fund balances EOY (990-PF)', 'balance'),
}


def _to_float(raw):
  try:
    return float(raw)
  except (ValueError, TypeError):
    return None


# Marker recorded in the `migration` table once financial_canonical.value has been
# fully backfilled, so the automatic backfill in _migrate_columns runs at most once
# (and resumes if interrupted, since the marker is set only on completion).
_BACKFILL_MARKER = 'financials_canonical_value_backfill'

# The value-aware re-canonical trigger. The trigger BODY (the WHEN guard + the
# INSERT…SELECT) is kept identical to the copy in Financials/sql/setup/00_schema.sql;
# only the CREATE preamble differs — setup uses `CREATE TRIGGER IF NOT EXISTS` to
# create it on a fresh DB, while this constant omits IF NOT EXISTS because
# _migrate_columns always DROPs first then recreates (a legacy DB's old, value-less
# trigger would otherwise survive `CREATE … IF NOT EXISTS`, so a delete-then-
# recanonical on a legacy DB would write a NULL value).
_RECANONICAL_TRIGGER = """
CREATE TRIGGER trg_fobs_recanonical
AFTER DELETE ON financial_observation
FOR EACH ROW
WHEN NOT EXISTS (
  SELECT 1 FROM financial_canonical c
  WHERE c.organization_id = OLD.organization_id
    AND c.fiscal_year = OLD.fiscal_year
    AND c.concept_code = OLD.concept_code)
AND EXISTS (
  SELECT 1 FROM financial_observation o
  WHERE o.organization_id = OLD.organization_id
    AND o.fiscal_year = OLD.fiscal_year
    AND o.concept_code = OLD.concept_code
    AND o.value IS NOT NULL)
BEGIN
  INSERT INTO financial_canonical
    (organization_id, fiscal_year, concept_code, observation_id, value, chosen_by)
  SELECT OLD.organization_id, OLD.fiscal_year, OLD.concept_code, o.observation_id, o.value, 'auto'
  FROM financial_observation o
  WHERE o.organization_id = OLD.organization_id
    AND o.fiscal_year = OLD.fiscal_year
    AND o.concept_code = OLD.concept_code
    AND o.value IS NOT NULL
  ORDER BY o.observation_id
  LIMIT 1;
END;
"""


class FinancialsDatabase(Database):
  """Unified multi-source financial data (reached as ``db.financials``) — the
  layer scoring reads from. Concepts are seeded from the scoring engine's
  ``_PATHS`` so the concept codes ARE the model input keys (no drift). 990 values
  are *derived* into observations from ``reported_data``; audited/OCR/manual
  sources add their own observations; a per-fact canonical observation is what
  models use (auto when sole, manual on disagreement)."""

  def __init__(self, db) -> None:
    self._db = db
    super().__init__("Financials", "Financials", connection=db.connection, cursor=db.cursor)
    self._migrate_columns()
    self._seed_concepts()

  def _migrate_columns(self) -> None:
    """Bring a legacy DB up to the denormalized-canonical schema (fresh DBs get it
    from sql/setup). Mirrors ScoreDatabase._migrate_columns: the ALTER no-ops on a
    fresh DB (column already present → 'duplicate column', swallowed) and is
    metadata-only/instant on a legacy 104GB DB. The trigger is DROP+recreated
    because setup's `CREATE TRIGGER IF NOT EXISTS` will NOT replace an existing
    old-body (value-less) trigger on a legacy DB — and a missed re-canonical write
    site silently corrupts scores. The ALTER leaves existing rows' value NULL, so we
    then backfill them automatically (marker-gated, so it runs at most once and the
    value-filtered scoring reads can never silently see un-backfilled NULLs)."""
    try:
      self.cursor.execute("ALTER TABLE financial_canonical ADD COLUMN value REAL")
    except Exception as exc:
      # Expected when the column already exists; re-raise anything else (string
      # match keeps this binding-agnostic across sqlite3 / sqlcipher3).
      if 'duplicate column' not in str(exc).lower():
        raise
    self.cursor.execute("DROP TRIGGER IF EXISTS trg_fobs_recanonical")
    self.cursor.executescript(_RECANONICAL_TRIGGER)
    self.connection.commit()
    # Close the migrate-then-score window: a legacy DB's existing canonical rows have
    # value=NULL until filled, and the new reads filter `value IS NOT NULL`, so an
    # un-backfilled DB would score from empty inputs *silently*. Backfill now, once
    # (the `migration` table — created before this concern — records completion;
    # backfill_canonical_values is resumable, so an interrupted run finishes next
    # open). A fresh DB has an empty table → instant no-op.
    done = self.cursor.execute(
      "SELECT 1 FROM migration WHERE name = ?", (_BACKFILL_MARKER,)).fetchone()
    if not done:
      self.backfill_canonical_values()

  def _seed_concepts(self) -> None:
    """Seed financial_concept from the engine's _PATHS (idempotent). Keeps the
    concept set and the scoring keys identical."""
    for code, path in _PATHS.items():
      label, category = _CONCEPT_META.get(code, (code, None))
      # _PATHS is the single source of truth for the concept→xml_path map, so a
      # path that changes between releases must propagate (INSERT OR IGNORE would
      # keep the stale path and silently break 990 derivation). Refresh it on
      # conflict; leave label/category alone in case they were customized.
      self.cursor.execute(
        "INSERT INTO financial_concept (code, label, category, default_xml_path) "
        "VALUES (?, ?, ?, ?) "
        "ON CONFLICT(code) DO UPDATE SET default_xml_path = excluded.default_xml_path",
        (code, label, category, path))
    # Synthetic form so non-990 financial data has a filing to anchor scores to.
    self.cursor.execute(
      "INSERT OR IGNORE INTO form (code, name, description, supported) "
      "VALUES ('FIN', 'Financial Statement', 'Non-990 financial data (audited/manual/OCR)', 0)")
    self.connection.commit()

  # ── reference ──────────────────────────────────────────────────────────────

  def list_concepts(self) -> list[dict]:
    rows = self.cursor.execute(
      "SELECT code, label, category, unit, default_xml_path FROM financial_concept "
      "ORDER BY code").fetchall()
    return [{"code": r[0], "label": r[1], "category": r[2], "unit": r[3],
             "default_xml_path": r[4]} for r in rows]

  def list_sources(self) -> list[dict]:
    rows = self.cursor.execute(
      "SELECT code, name, rank FROM financial_source ORDER BY rank DESC, code").fetchall()
    return [{"code": r[0], "name": r[1], "rank": r[2]} for r in rows]

  def _concept_codes(self) -> set[str]:
    return {r[0] for r in self.cursor.execute("SELECT code FROM financial_concept").fetchall()}

  # ── documents + observations + canonical ─────────────────────────────────────

  def _ensure_anchor(self, ein: str, fiscal_year: int) -> tuple[int, str]:
    """Return ``(filing_id, uuid)`` for (ein, year) to anchor scores/data to,
    creating a synthetic 'FIN' filing if the org has no filing for that year yet.
    Prefers a real filing over a FIN anchor. Idempotent (reuses an existing
    anchor), so re-ingest / re-score never accumulates duplicate FIN filings."""
    row = self.cursor.execute(
      "SELECT filing_id, uuid FROM filing WHERE organization_id = ? AND year = ? "
      "ORDER BY (form_code = 'FIN') ASC, filing_id LIMIT 1", (ein, fiscal_year)).fetchone()
    if row:
      return row[0], row[1]
    new_uuid = str(_uuid.uuid4())
    self.cursor.execute(
      "INSERT INTO filing (uuid, year, organization_id, form_code) VALUES (?, ?, ?, 'FIN')",
      (new_uuid, fiscal_year, ein))
    return self.cursor.lastrowid, new_uuid

  def _ensure_filing_anchor(self, ein: str, fiscal_year: int) -> int:
    """The integer filing_id form of :meth:`_ensure_anchor` (for observation
    storage, which keys on the integer filing_id)."""
    return self._ensure_anchor(ein, fiscal_year)[0]

  def ensure_year_anchor_uuid(self, ein: str, fiscal_year: int) -> str:
    """The filing **uuid** for (ein, year) (creating a FIN anchor if needed) — the
    uuid leg of the anchor helper (the batch scorer uses
    :meth:`ensure_year_anchor_filing_id`, the integer leg). The anchor carries no
    observations, so :meth:`get_org_scoring_data` drops it from real-data scoring
    (it exists only to satisfy organization_score's filing FK)."""
    return self._ensure_anchor(ein, fiscal_year)[1]

  def ensure_year_anchor_filing_id(self, ein: str, fiscal_year: int) -> int:
    """The integer **filing_id** for (ein, year) (creating a FIN anchor if needed)
    — the form the batch scoring path uses to anchor an imputed year, since
    organization_score stores the integer filing_id directly. Same idempotent
    :meth:`_ensure_anchor` as :meth:`ensure_year_anchor_uuid`, just the integer leg."""
    return self._ensure_anchor(ein, fiscal_year)[0]

  def create_document(self, ein: str, fiscal_year: int, source_code: str, *, kind=None,
                      filename=None, object_id=None, filing_id=None, actor=None,
                      note=None) -> int:
    label = actor.label if actor is not None else None
    self.cursor.execute(
      "INSERT INTO financial_document (organization_id, fiscal_year, source_code, kind, "
      "filename, object_id, filing_id, uploaded_by, note) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)",
      (ein, fiscal_year, source_code, kind, filename, object_id, filing_id, label, note))
    return self.cursor.lastrowid

  def _add_observation(self, document_id: int, ein: str, fiscal_year: int, concept_code: str,
                       value, raw_value, source_code: str, confidence, label) -> int | None:
    """Insert one observation (idempotent per document+concept) and make it
    canonical if the fact has no canonical yet. Returns the observation_id, or
    None if this document already had that concept."""
    self.cursor.execute(
      "INSERT OR IGNORE INTO financial_observation (organization_id, fiscal_year, concept_code, "
      "source_code, document_id, value, raw_value, confidence, entered_by) "
      "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)",
      (ein, fiscal_year, concept_code, source_code, document_id, value,
       raw_value, confidence, label))
    if self.cursor.rowcount == 0:
      return None
    obs_id = self.cursor.lastrowid
    # Auto-canonical only when the fact has no chosen value yet (sole source) AND
    # this observation actually carries a value — a NULL reading must never become
    # canonical, or it would silently block every later real value for the fact.
    if value is not None:
      self.cursor.execute(
        "INSERT OR IGNORE INTO financial_canonical "
        "(organization_id, fiscal_year, concept_code, observation_id, value, chosen_by) "
        "VALUES (?, ?, ?, ?, ?, ?)", (ein, fiscal_year, concept_code, obs_id, value, 'auto'))
    return obs_id

  def record_observations(self, ein: str, fiscal_year: int, source_code: str,
                          values: dict, *, confidence=None, kind=None, filename=None,
                          object_id=None, filing_id=None, actor=None, note=None,
                          anchor=True) -> dict:
    """Create a document and record one observation per concept in ``values``
    ({concept_code: number}). Sets canonical for facts that have none yet
    (conflicts are left for manual resolution). Ensures a filing anchor exists
    (so non-990 data is scoreable) unless ``anchor=False``. Returns
    ``{document_id, recorded, observations}``."""
    valid = self._concept_codes()
    unknown = [c for c in values if c not in valid]
    if unknown:
      raise ValueError(f"unknown concept(s): {sorted(unknown)}")
    if filing_id is None and anchor:
      filing_id = self._ensure_filing_anchor(ein, fiscal_year)
    label = actor.label if actor is not None else None
    document_id = self.create_document(ein, fiscal_year, source_code, kind=kind,
                                       filename=filename, object_id=object_id,
                                       filing_id=filing_id, actor=actor, note=note)
    recorded = []
    for concept, v in values.items():
      val = _to_float(v)
      obs_id = self._add_observation(document_id, ein, fiscal_year, concept, val, str(v),
                                     source_code, confidence, label)
      if obs_id is not None:
        recorded.append({"concept_code": concept, "observation_id": obs_id, "value": val})
    self._db.audit.record(actor, 'create', 'financial_document', document_id,
                          {'ein': ein, 'fiscal_year': fiscal_year, 'source': source_code,
                           'concepts': len(recorded)}, commit=False)
    self.connection.commit()
    return {"document_id": document_id, "recorded": len(recorded), "observations": recorded}

  def set_canonical(self, ein: str, fiscal_year: int, concept_code: str,
                    observation_id: int, *, actor=None) -> bool:
    """Manually choose which observation is canonical for a fact. The observation
    must belong to that (org, year, concept). Returns False otherwise."""
    row = self.cursor.execute(
      "SELECT value FROM financial_observation WHERE observation_id = ? AND organization_id = ? "
      "AND fiscal_year = ? AND concept_code = ?",
      (observation_id, ein, fiscal_year, concept_code)).fetchone()
    if not row:
      return False
    # Denormalize the chosen observation's value onto financial_canonical (set on
    # BOTH the INSERT and the DO UPDATE legs, or a re-pick would leave a stale
    # value). A human may legitimately pick a NULL-valued observation; the read
    # path filters `value IS NOT NULL`, so a NULL canonical contributes nothing.
    value = row[0]
    # A manual choice must never record chosen_by=NULL: get_org_financials treats
    # NULL/'auto' as unresolved, so a NULL here would leave the conflict standing
    # forever. Fall back to 'manual' when there is no authenticated actor.
    label = actor.label if actor is not None else 'manual'
    self.cursor.execute(
      "INSERT INTO financial_canonical (organization_id, fiscal_year, concept_code, "
      "observation_id, value, chosen_by) VALUES (?, ?, ?, ?, ?, ?) "
      "ON CONFLICT(organization_id, fiscal_year, concept_code) DO UPDATE SET "
      "observation_id = excluded.observation_id, value = excluded.value, "
      "chosen_by = excluded.chosen_by, chosen_at = datetime('now')",
      (ein, fiscal_year, concept_code, observation_id, value, label))
    self._db.audit.record(actor, 'update', 'financial_canonical',
                          f"{ein}:{fiscal_year}:{concept_code}",
                          {'observation_id': observation_id}, commit=False)
    self.connection.commit()
    return True

  # ── reads: per-fact, per-org, conflicts ──────────────────────────────────────

  def get_org_financials(self, ein: str, fiscal_year: int | None = None) -> dict:
    """All observations for an org (optionally one year), grouped by
    (fiscal_year, concept), each fact flagged canonical + conflict."""
    where = "WHERE o.organization_id = ?"
    params = [ein]
    if fiscal_year is not None:
      where += " AND o.fiscal_year = ?"
      params.append(fiscal_year)
    rows = self.cursor.execute(
      f"SELECT o.observation_id, o.fiscal_year, o.concept_code, o.source_code, o.value, "
      f"o.raw_value, o.confidence, o.document_id, o.entered_by, o.entered_at, "
      f"(c.observation_id = o.observation_id) AS is_canonical, c.chosen_by "
      f"FROM financial_observation o "
      f"LEFT JOIN financial_canonical c ON c.organization_id = o.organization_id "
      f"AND c.fiscal_year = o.fiscal_year AND c.concept_code = o.concept_code "
      f"{where} ORDER BY o.fiscal_year DESC, o.concept_code, o.observation_id", params).fetchall()
    facts: dict = {}
    for r in rows:
      key = (r[1], r[2])
      facts.setdefault(key, {"fiscal_year": r[1], "concept_code": r[2],
                             "chosen_by": r[11], "observations": []})
      facts[key]["observations"].append({
        "observation_id": r[0], "source_code": r[3], "value": r[4], "raw_value": r[5],
        "confidence": r[6], "document_id": r[7], "entered_by": r[8], "entered_at": r[9],
        "is_canonical": bool(r[10])})
    out = []
    for f in facts.values():
      vals = {o["value"] for o in f["observations"] if o["value"] is not None}
      f["diverges"] = len(vals) > 1          # ≥2 distinct values exist
      # A divergence a human hasn't picked through yet is an unresolved conflict;
      # once chosen manually (chosen_by != 'auto') it is resolved.
      f["resolved"] = f["chosen_by"] not in (None, 'auto')
      f["conflict"] = f["diverges"] and not f["resolved"]
      f["canonical_value"] = next((o["value"] for o in f["observations"] if o["is_canonical"]), None)
      out.append(f)
    return {"ein": ein, "facts": out}

  def conflicts(self, ein: str) -> list[dict]:
    """Facts where sources disagree and no one has chosen yet (the to-resolve list)."""
    return [f for f in self.get_org_financials(ein)["facts"] if f["conflict"]]

  # ── 990 derivation ────────────────────────────────────────────────────────────

  def derive_from_990(self, ein: str, *, source_code: str = 'irs_990_xml',
                      commit: bool = True) -> int:
    """(Re)derive observations from the org's stored 990 reported_data via the
    concept→xml_path map. Idempotent: one document per (filing, source); each
    observation INSERT-OR-IGNOREd. Returns observations written. Pass
    ``commit=False`` from a batch loop (the caller commits once / per chunk) so a
    per-org commit doesn't break the scoring rebuild's chunked-commit batching."""
    concepts = self.cursor.execute(
      "SELECT code, default_xml_path FROM financial_concept WHERE default_xml_path IS NOT NULL"
    ).fetchall()
    path_to_concept = {p: c for c, p in concepts}
    filings = self.cursor.execute(
      "SELECT filing_id, year FROM filing WHERE organization_id = ? AND form_code != 'FIN'",
      (ein,)).fetchall()
    written = 0
    for filing_id, year in filings:
      doc = self.cursor.execute(
        "SELECT document_id FROM financial_document WHERE filing_id = ? AND source_code = ?",
        (filing_id, source_code)).fetchone()
      document_id = doc[0] if doc else self.create_document(
        ein, year, source_code, kind='990_derived', filing_id=filing_id)
      vrows = self.cursor.execute(
        "SELECT fi.xml_path, rd.raw_value FROM reported_data rd "
        "JOIN field fi ON fi.field_id = rd.field_id "
        "WHERE rd.filing_id = ? AND fi.xml_path IN ({})".format(
          ",".join("?" * len(path_to_concept))),
        (filing_id, *path_to_concept.keys())).fetchall()
      for path, raw in vrows:
        concept = path_to_concept.get(path)
        if concept is None or raw is None:
          continue
        if self._add_observation(document_id, ein, year, concept, _to_float(raw), raw,
                                 source_code, 1.0, None) is not None:
          written += 1
    if commit:
      self.connection.commit()
    return written

  def rebuild(self, eins=None) -> dict:
    """Derive 990 observations for the given orgs (default: every org with a
    non-FIN filing). Used for the one-time backfill and the ingest finalize.
    Commits once at the end rather than per org."""
    if eins is None:
      eins = [r[0] for r in self.cursor.execute(
        "SELECT DISTINCT organization_id FROM filing WHERE form_code != 'FIN' "
        "AND organization_id IS NOT NULL").fetchall()]
    total = 0
    for ein in eins:
      total += self.derive_from_990(ein, commit=False)
    self.connection.commit()
    return {"orgs": len(eins), "observations": total}

  # SQL value expression mirroring _to_float for the 990 money strings: a guarded
  # CAST. Concept raw_values are integer (occasionally signed) dollar amounts in the
  # e-file — verified across the corpus — so CAST == float() for every real value;
  # anything non-numeric (alpha/empty) → NULL so it can never become canonical, the
  # same as _to_float returning None. This is what keeps derive_bulk byte-identical
  # to the per-org derive_from_990 (and the score-equality invariant intact).
  _BULK_VALUE = ("CASE WHEN rd.raw_value GLOB '*[0-9]*' "
                 "AND rd.raw_value NOT GLOB '*[^0-9.-]*' "
                 "THEN CAST(rd.raw_value AS REAL) ELSE NULL END")

  def derive_bulk(self, eins=None, *, source_code: str = 'irs_990_xml',
                  commit: bool = True, batch: int = 25000, progress=None) -> dict:
    """Set-based equivalent of running ``derive_from_990`` over many orgs — the fast
    path for the scoring rebuild + ingest finalize. Documents → observations →
    sole-source auto-canonical via three INSERT…SELECTs instead of a per-org/
    per-concept Python loop (profiling showed the old per-org derive was ~98% of
    rebuild time). Fully idempotent (NOT EXISTS guard on documents; UNIQUE/PK
    INSERT OR IGNOREs on observations + canonical).

    ``eins=None`` derives the **whole corpus**, iterating ``filing_id`` ranges of
    ``batch`` and committing per range — sequential IO over reported_data and a
    bounded WAL (a single all-corpus transaction over ~200M reported_data rows
    OOMs / blows the WAL). ``eins`` (a small list) scopes it by org instead, chunked
    under SQLite's variable limit — for ``score --org`` and tiny ingests; for a
    large touched-set the caller passes None (deriving extra orgs is idempotent and
    far cheaper than random per-org IO). ``progress(done, total)`` is called per
    range. Returns ``{"orgs": n|None}``."""
    doc = ("INSERT INTO financial_document "
           "(organization_id, fiscal_year, source_code, kind, filing_id) "
           "SELECT f.organization_id, f.year, ?, '990_derived', f.filing_id FROM filing f "
           "WHERE f.form_code != 'FIN' AND f.organization_id IS NOT NULL "
           "AND NOT EXISTS (SELECT 1 FROM financial_document d "
           "                WHERE d.filing_id = f.filing_id AND d.source_code = ?)")
    obs = ("INSERT OR IGNORE INTO financial_observation "
           "(organization_id, fiscal_year, concept_code, source_code, document_id, "
           " value, raw_value, confidence) "
           "SELECT d.organization_id, d.fiscal_year, fc.code, ?, d.document_id, "
           f"{self._BULK_VALUE}, rd.raw_value, 1.0 "
           "FROM financial_document d "
           "JOIN reported_data rd ON rd.filing_id = d.filing_id "
           "JOIN field fi ON fi.field_id = rd.field_id "
           "JOIN financial_concept fc ON fc.default_xml_path = fi.xml_path "
           "WHERE d.source_code = ? AND rd.raw_value IS NOT NULL")
    # Sole-source auto-canonical (MIN observation per fact), only where none chosen
    # yet (PK INSERT OR IGNORE) and the value is non-NULL — same rule as _add_observation.
    if eins is None:
      # (1) Documents: one '990_derived' doc per non-FIN filing, in filing_id batches
      #     (bounded WAL; idempotent via the NOT EXISTS guard).
      max_fid = self.cursor.execute("SELECT COALESCE(MAX(filing_id), 0) FROM filing").fetchone()[0]
      lo = 0
      while lo <= max_fid:
        hi = lo + batch
        self.cursor.execute(f"{doc} AND f.filing_id >= ? AND f.filing_id < ?",
                            (source_code, source_code, lo, hi))
        self.connection.commit()
        if progress:
          progress(min(hi, max_fid + 1), max_fid + 1)
        lo = hi
      # (2) Observations: driven per concept field_id so SQLite uses
      #     idx_reported_data_field and touches only the ~16 concept fields' rows
      #     (~6% of reported_data) instead of scanning all ~200M. One INSERT per
      #     field_id (committed), joining each reading to its 990-derived document.
      fobs = ("INSERT OR IGNORE INTO financial_observation "
              "(organization_id, fiscal_year, concept_code, source_code, document_id, "
              " value, raw_value, confidence) "
              "SELECT d.organization_id, d.fiscal_year, ?, ?, d.document_id, "
              f"{self._BULK_VALUE}, rd.raw_value, 1.0 "
              "FROM reported_data rd "
              "JOIN financial_document d ON d.filing_id = rd.filing_id AND d.source_code = ? "
              "WHERE rd.field_id = ? AND rd.raw_value IS NOT NULL")
      field_map = self.cursor.execute(
        "SELECT fi.field_id, fc.code FROM field fi "
        "JOIN financial_concept fc ON fc.default_xml_path = fi.xml_path "
        "WHERE fc.default_xml_path IS NOT NULL").fetchall()
      for field_id, concept_code in field_map:
        self.cursor.execute(fobs, (concept_code, source_code, source_code, field_id))
        self.connection.commit()
      # (3) Sole-source auto-canonical: pick MIN(observation_id) per fact (the
      #     index-ordered GROUP BY over idx_fobs_fact streams without a temp sort),
      #     then JOIN back to that exact observation to denormalize its value onto
      #     financial_canonical — value OF the MIN(observation_id) row, never
      #     MIN(value)/an aggregate (which would corrupt the score). The picked row
      #     has value IS NOT NULL (the subquery filters it), so canonical.value is
      #     consistent with the observation_id stored beside it.
      self.cursor.execute(
        "INSERT OR IGNORE INTO financial_canonical "
        "(organization_id, fiscal_year, concept_code, observation_id, value, chosen_by) "
        "SELECT o.organization_id, o.fiscal_year, o.concept_code, o.observation_id, o.value, 'auto' "
        "FROM financial_observation o JOIN ("
        " SELECT organization_id, fiscal_year, concept_code, MIN(observation_id) AS moid "
        " FROM financial_observation WHERE value IS NOT NULL "
        " GROUP BY organization_id, fiscal_year, concept_code) m ON m.moid = o.observation_id")
      self.connection.commit()
      return {"orgs": None}
    can = ("INSERT OR IGNORE INTO financial_canonical "
           "(organization_id, fiscal_year, concept_code, observation_id, value, chosen_by) "
           "SELECT o.organization_id, o.fiscal_year, o.concept_code, o.observation_id, o.value, 'auto' "
           "FROM financial_observation o JOIN ("
           " SELECT organization_id, fiscal_year, concept_code, MIN(observation_id) AS moid "
           " FROM financial_observation WHERE value IS NOT NULL AND organization_id IN ({ph}) "
           " GROUP BY organization_id, fiscal_year, concept_code) m ON m.moid = o.observation_id")
    eins = list(eins)
    if eins:
      for i in range(0, len(eins), 900):
        ch = eins[i:i + 900]
        ph = ",".join("?" * len(ch))
        self.cursor.execute(f"{doc} AND f.organization_id IN ({ph})", (source_code, source_code, *ch))
        self.cursor.execute(f"{obs} AND d.organization_id IN ({ph})", (source_code, source_code, *ch))
        self.cursor.execute(can.format(ph=ph), tuple(ch))
    if commit:
      self.connection.commit()
    return {"orgs": len(eins)}

  def backfill_canonical_values(self, *, batch: int = 25000, progress=None) -> int:
    """One-time backfill of the denormalized ``financial_canonical.value`` for rows
    written before the column existed (the migration ALTERs it in as NULL). Copies
    EXACTLY what the old read-path join returned — the chosen observation's value
    via ``observation_id`` — so the equality invariant holds for every existing
    fact. Resumable + idempotent: only rows with ``value IS NULL`` are filled, in
    hidden-rowid ranges committed per range (so the WAL stays bounded and an
    interrupted run resumes cheaply; a fully-backfilled re-run is a no-op scan).
    Returns rows filled. ``progress(done, total)`` is called per range."""
    max_rid = self.cursor.execute(
      "SELECT COALESCE(MAX(rowid), 0) FROM financial_canonical").fetchone()[0]
    filled, lo = 0, 0
    while lo <= max_rid:
      hi = lo + batch
      self.cursor.execute(
        "UPDATE financial_canonical SET value = ("
        " SELECT o.value FROM financial_observation o "
        " WHERE o.observation_id = financial_canonical.observation_id) "
        "WHERE rowid >= ? AND rowid < ? AND value IS NULL", (lo, hi))
      filled += self.cursor.rowcount
      self.connection.commit()
      if progress:
        progress(min(hi, max_rid + 1), max_rid + 1)
      lo = hi
    # Record completion so the automatic backfill in _migrate_columns skips on
    # future opens. Set only here (after a full pass), so an interrupted backfill
    # re-runs next time rather than leaving stale NULLs behind the marker.
    self.cursor.execute("INSERT OR IGNORE INTO migration (name) VALUES (?)", (_BACKFILL_MARKER,))
    self.connection.commit()
    return filled

  # ── scoring loaders (canonical values, keyed by concept) ──────────────────────

  # The chosen value is denormalized onto financial_canonical (see the schema +
  # the write sites), so scoring reads it DIRECTLY — no financial_observation join
  # (whose random observation_id fetch dominated the corpus-scale read). The
  # `value IS NOT NULL` filter is identical to the old `o.value IS NOT NULL`.
  def get_year_canonical_values(self, ein: str, fiscal_year: int) -> dict[str, float]:
    """{concept_code: canonical value} for one (org, year) — for single-filing scoring."""
    rows = self.cursor.execute(
      "SELECT concept_code, value FROM financial_canonical "
      "WHERE organization_id = ? AND fiscal_year = ? AND value IS NOT NULL",
      (ein, fiscal_year)).fetchall()
    return {r[0]: r[1] for r in rows}

  def get_historical_values(self, ein: str) -> dict[str, list[float]]:
    """{concept_code: [canonical value per year, oldest→newest]} across the org."""
    rows = self.cursor.execute(
      "SELECT concept_code, value FROM financial_canonical "
      "WHERE organization_id = ? AND value IS NOT NULL "
      "ORDER BY concept_code, fiscal_year ASC", (ein,)).fetchall()
    out: dict[str, list[float]] = {}
    for code, val in rows:
      out.setdefault(code, []).append(val)
    return out

  def get_org_scoring_data(self, ein: str, concepts) -> tuple[list[dict], dict, dict]:
    """Batch-scoring load, mirroring ReportedData.get_org_scoring_data but keyed by
    canonical CONCEPT (not xml_path): (filings, vals_by_fid, historical) where each
    filing dict carries the integer ``filing_id`` (so the score row stores it
    directly — no uuid→id lookup), ``vals_by_fid[filing_id]`` is that filing's
    YEAR's canonical concept values, and historical[concept] is the flat
    oldest→newest list of REAL canonical values.

    Filings are ordered ``year ASC, real-before-FIN, filing_id`` so the first filing
    per year is a deterministic representative; projecting the integer filing_id
    (not the uuid) lets the scan be index-only on the UNIQUE(org,year,form_code)
    autoindex. A FIN anchor is dropped when the year also has a real filing (audited
    + 990 → score once) OR when it carries no canonical data at all — the latter
    being a score-anchor synthesized by the imputation path
    (:meth:`ensure_year_anchor_filing_id`), which must not be scored as a real
    year. Canonical value is read directly off financial_canonical (no observation
    join)."""
    frows = self.cursor.execute(
      "SELECT filing_id, year, form_code FROM filing WHERE organization_id = ? "
      "ORDER BY year ASC, (form_code = 'FIN') ASC, filing_id ASC", (ein,)).fetchall()
    wanted = set(concepts)
    crows = self.cursor.execute(
      "SELECT fiscal_year, concept_code, value FROM financial_canonical "
      "WHERE organization_id = ? AND value IS NOT NULL ORDER BY fiscal_year ASC",
      (ein,)).fetchall()
    by_year: dict[int, dict[str, float]] = {}
    historical: dict[str, list[float]] = {}
    for year, code, val in crows:
      if code not in wanted:
        continue
      by_year.setdefault(year, {})[code] = val
      historical.setdefault(code, []).append(val)
    real_years = {r[1] for r in frows if r[2] != 'FIN'}
    filings = [{"filing_id": r[0], "year": r[1], "form_code": r[2]} for r in frows
               if not (r[2] == 'FIN' and (r[1] in real_years or not by_year.get(r[1])))]
    vals_by_fid = {f["filing_id"]: by_year.get(f["year"], {}) for f in filings}
    return filings, vals_by_fid, historical
