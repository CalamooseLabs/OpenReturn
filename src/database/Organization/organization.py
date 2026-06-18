from database.base import Database, escape_like


class OrganizationDatabase(Database):
  """Organization lookups, upserts, favorite flagging, and search.

  A ``Database`` subclass sharing the coordinator's connection; sibling concerns
  reach it as ``db.orgs`` and it reaches them via ``self._db``. Owns the
  organization / address / state / organization_type tables and the
  ``organization_fts`` trigram index that backs fuzzy name search.

  The filer address is normalized into the ``address`` table, linked from
  ``organization.business_address_id``. The link key is the org's EIN (one filer
  address per org): deterministic, so an ``INSERT OR IGNORE`` re-ingest is
  idempotent and never orphans an address row.
  """

  # Org columns + the LEFT-joined physical (a) and mailing (m) addresses, in
  # select order. _row() depends on this exact column order.
  _COLS = (
    "o.ein, o.name, o.is_favorite, o.created_at, o.updated_at, "
    "a.street, a.city, a.state_code, a.zipcode, "
    "o.website, o.main_email, o.created_by, o.updated_by, "
    "m.street, m.city, m.state_code, m.zipcode, "
    "o.org_type, o.is_grantmaker, "
    "o.sector_code, s.name, a.county_fips, a.county_name")
  _ADDR_JOINS = (
    "LEFT JOIN address a ON a.uuid = o.business_address_id "
    "LEFT JOIN address m ON m.uuid = o.mailing_address_id "
    "LEFT JOIN sector s ON s.code = o.sector_code")
  _FROM = f"FROM organization o {_ADDR_JOINS}"
  _SELECT = f"SELECT {_COLS} {_FROM}"

  def __init__(self, db) -> None:
    self._db = db
    super().__init__("Organization", "Organization", populate_guard="state",
                     connection=db.connection, cursor=db.cursor)
    self._migrate_schema()
    self._ensure_search_index()

  # Foreign-address columns added to the shared address table (the appearance
  # graph layer + foreign filer addresses need them; US rows leave them NULL).
  _ADDRESS_EXTRA_COLS = ('address_kind', 'street2', 'province', 'country_code', 'foreign_postal')

  def _migrate_schema(self) -> None:
    """Relax a legacy strict ``address`` table (NOT NULL columns + a state FK)
    to the nullable, FK-free schema partial addresses need, and add the
    foreign-address columns to legacy tables that predate them. Additive: the
    ``uuid`` PK and existing US columns are untouched, so org joins / the bulk
    flush keep working unchanged."""
    info = self.cursor.execute("PRAGMA table_info(address)").fetchall()
    # table_info cols: (cid, name, type, notnull, dflt_value, pk)
    strict = any(c[1] in ('street', 'city', 'state_code', 'zipcode') and c[3] == 1 for c in info)
    if strict:
      self.cursor.execute("DROP TABLE address")
      self.cursor.execute(
        "CREATE TABLE address (uuid CHARACTER(36) PRIMARY KEY, street TEXT, "
        "city TEXT, state_code CHARACTER(2), zipcode TEXT, address_kind TEXT, "
        "street2 TEXT, province TEXT, country_code TEXT, foreign_postal TEXT)")
    cols = {c[1] for c in self.cursor.execute("PRAGMA table_info(address)").fetchall()}
    # Foreign-address columns + the deduced-county columns (see derive_counties).
    for col in (*self._ADDRESS_EXTRA_COLS, 'county_fips', 'county_name'):
      if col not in cols:
        self.cursor.execute(f"ALTER TABLE address ADD COLUMN {col} TEXT")
    self.cursor.execute("CREATE INDEX IF NOT EXISTS idx_address_state ON address (state_code)")
    self.cursor.execute("CREATE INDEX IF NOT EXISTS idx_address_city ON address (city)")
    self.cursor.execute("CREATE INDEX IF NOT EXISTS idx_address_county ON address (county_fips)")
    # Editable-org columns added to legacy organization tables (fresh DBs get
    # them from sql/setup). mailing_address_id is a nullable FK → address.
    org_cols = {c[1] for c in self.cursor.execute("PRAGMA table_info(organization)").fetchall()}
    for ddl, col in (
      ("ALTER TABLE organization ADD COLUMN mailing_address_id CHARACTER(36) REFERENCES address (uuid)", "mailing_address_id"),
      ("ALTER TABLE organization ADD COLUMN website TEXT", "website"),
      ("ALTER TABLE organization ADD COLUMN main_email TEXT", "main_email"),
      ("ALTER TABLE organization ADD COLUMN created_by TEXT", "created_by"),
      ("ALTER TABLE organization ADD COLUMN updated_by TEXT", "updated_by"),
      # Derived foundation/nonprofit classification (see classify_organizations).
      ("ALTER TABLE organization ADD COLUMN org_type TEXT", "org_type"),
      ("ALTER TABLE organization ADD COLUMN is_grantmaker INTEGER NOT NULL DEFAULT 0", "is_grantmaker"),
      # Assignable NTEE-major-group sector (see the sector table).
      ("ALTER TABLE organization ADD COLUMN sector_code TEXT REFERENCES sector (code)", "sector_code"),
    ):
      if col not in org_cols:
        self.cursor.execute(ddl)
    self.cursor.execute("CREATE INDEX IF NOT EXISTS idx_organization_org_type ON organization (org_type)")
    self.cursor.execute("CREATE INDEX IF NOT EXISTS idx_organization_sector ON organization (sector_code)")
    self.connection.commit()

  def _ensure_search_index(self) -> None:
    """Create the FTS5 trigram index over organization names (used for fuzzy
    name search). Best-effort: a SQLite build without FTS5/trigram leaves
    ``self.has_fts`` False and fuzzy search falls back to strict substring."""
    self.has_fts = False
    try:
      self.cursor.execute(
        "CREATE VIRTUAL TABLE IF NOT EXISTS organization_fts "
        "USING fts5(ein UNINDEXED, name, tokenize='trigram')")
      self.connection.commit()
      self.has_fts = True
    except Exception:
      self.has_fts = False

  def rebuild_search_index(self) -> int:
    """Repopulate the trigram name index from the organization table. Cheap
    relative to a bulk ingest; called from the ingest finalize and lazily
    self-healed on a fuzzy search if empty. Returns the rows indexed."""
    if not self.has_fts:
      return 0
    self.cursor.execute("DELETE FROM organization_fts")
    self.cursor.execute("INSERT INTO organization_fts (ein, name) SELECT ein, name FROM organization")
    self.connection.commit()
    return self.cursor.execute("SELECT COUNT(*) FROM organization_fts").fetchone()[0]

  # Keep an IN-clause's bind-param count well under SQLite's limit: a full-corpus
  # ingest finalize can touch >800k eins, and one giant `IN (?,?,…)` errors with
  # "too many SQL variables" — so the scoped UPDATEs below batch the eins.
  _EIN_CHUNK = 900

  def _update_scoped(self, base_sql, ein_col, eins, *, connector="WHERE"):
    """Run a set-based UPDATE either over the whole table (``eins is None``) or
    scoped to ``eins`` — chunked into ``_EIN_CHUNK``-sized IN-clauses so a huge
    list never trips SQLite's variable limit. One commit. Returns the total
    rowcount, or None when ``eins`` is an empty list (caller short-circuits)."""
    if eins is None:
      self.cursor.execute(base_sql)
      self.connection.commit()
      return self.cursor.rowcount
    eins = list(eins)
    if not eins:
      return None
    n = 0
    for i in range(0, len(eins), self._EIN_CHUNK):
      chunk = eins[i:i + self._EIN_CHUNK]
      self.cursor.execute(
        f"{base_sql} {connector} {ein_col} IN ({','.join('?' * len(chunk))})", chunk)
      n += self.cursor.rowcount
    self.connection.commit()
    return n

  def org_type_map(self, eins=None) -> dict:
    """``{ein: org_type}`` for scoping models per org during a batch rescore.
    ``eins=None`` returns the whole corpus in one query; a subset is fetched in
    chunks (SQLite bound-variable limit). Unclassified orgs map to None."""
    if eins is None:
      return {r[0]: r[1] for r in
              self.cursor.execute("SELECT ein, org_type FROM organization").fetchall()}
    out: dict = {}
    eins = list(eins)
    for i in range(0, len(eins), 900):
      chunk = eins[i:i + 900]
      ph = ",".join("?" * len(chunk))
      for r in self.cursor.execute(
          f"SELECT ein, org_type FROM organization WHERE ein IN ({ph})", chunk).fetchall():
        out[r[0]] = r[1]
    return out

  def classify_organizations(self, eins=None) -> dict:
    """(Re)derive each org's cached ``org_type`` + ``is_grantmaker`` from its filings
    and grant edges (idempotent, one set-based UPDATE). ``org_type`` is 'foundation'
    if the org has EVER filed a 990-PF, else 'nonprofit' for a 990/990-EZ/990-N filer,
    else 'other' for any other real form (e.g. 990-T), else NULL (a FIN-only synthetic
    anchor / no IRS form). ``is_grantmaker`` is 1 for any org with grant_edge rows
    (incl. Schedule-I grantmaking public charities). Optionally scoped to ``eins``.
    Run at the ingest finalize (for touched orgs) and via `openreturn classify`."""
    update_sql = (
      "UPDATE organization SET "
      "org_type = CASE "
      "  WHEN EXISTS(SELECT 1 FROM filing f WHERE f.organization_id = organization.ein "
      "              AND f.form_code = '990PF') THEN 'foundation' "
      "  WHEN EXISTS(SELECT 1 FROM filing f WHERE f.organization_id = organization.ein "
      "              AND f.form_code IN ('990','990EZ','990N')) THEN 'nonprofit' "
      "  WHEN EXISTS(SELECT 1 FROM filing f WHERE f.organization_id = organization.ein "
      "              AND f.form_code <> 'FIN') THEN 'other' "
      "  ELSE NULL END, "
      "is_grantmaker = CASE WHEN EXISTS("
      "  SELECT 1 FROM grant_edge g JOIN filing f ON f.filing_id = g.filing_id "
      "  WHERE f.organization_id = organization.ein) THEN 1 ELSE 0 END")
    n = self._update_scoped(update_sql, "ein", eins)
    if n is None:
      return {"classified": 0}
    return {"classified": n}

  def import_zip_county(self, rows) -> int:
    """Bulk-load the ZIP→county crosswalk (``openreturn counties import``). ``rows``
    is an iterable of ``(zipcode, county_fips, county_name, state_code, dominant)``.
    A crosswalk file is the complete ZIP→county universe, so an import **replaces**
    the table wholesale (``DELETE`` then insert) — re-importable, and crucially this
    guarantees exactly one ``dominant=1`` row per ZIP. (A plain INSERT OR REPLACE
    keyed on ``(zipcode, county_fips)`` would, when a later file flips a ZIP's
    dominant county, leave the old dominant row in place → two dominant rows → a
    non-deterministic ``derive_counties`` join.) Returns the crosswalk row count."""
    self.cursor.execute("DELETE FROM zip_county")
    self.cursor.executemany(
      "INSERT OR REPLACE INTO zip_county "
      "(zipcode, county_fips, county_name, state_code, dominant) VALUES (?, ?, ?, ?, ?)",
      rows)
    self.connection.commit()
    return self.cursor.execute("SELECT COUNT(*) FROM zip_county").fetchone()[0]

  def derive_counties(self, eins=None) -> dict:
    """Deduce ``address.county_fips``/``county_name`` from the address ZIP via the
    dominant ``zip_county`` row (one idempotent UPDATE). The ZIP is normalized to 5
    digits (ZIP+4 trimmed). A no-op when the crosswalk is empty. Optionally scoped to
    ``eins`` (whose filer-address uuid == the EIN). Run at the ingest finalize for
    touched orgs and via ``openreturn counties import|derive``."""
    base = ("UPDATE address SET county_fips = zc.county_fips, county_name = zc.county_name "
            "FROM zip_county zc "
            "WHERE zc.dominant = 1 AND address.zipcode IS NOT NULL "
            "AND zc.zipcode = substr(replace(address.zipcode, '-', ''), 1, 5)")
    n = self._update_scoped(base, "address.uuid", eins, connector="AND")
    if n is None:
      return {"updated": 0}
    return {"updated": n}

  @staticmethod
  def _trigram_query(s: str) -> str | None:
    """Decompose a query into its (lowercased) trigrams OR'd together so the FTS5
    trigram index ranks names by shared-trigram count — typo tolerant (a
    misspelling only perturbs a few trigrams). A single quoted phrase would
    instead do exact-substring matching. None for queries shorter than a trigram
    (caller falls back to strict)."""
    s = s.lower()
    if len(s) < 3:
      return None
    grams = {s[i:i + 3] for i in range(len(s) - 2)}
    return " OR ".join('"' + g.replace('"', '""') + '"' for g in grams)

  def _fts_stale(self) -> bool:
    """True if the trigram index is out of sync with the organization table, so a
    fuzzy search can self-heal. Compares counts (not just emptiness) so a
    partially-populated index — e.g. some orgs added before the index existed —
    also heals. The ingest finalize rebuilds the index directly; this is the
    backstop for orgs that never went through it."""
    if not self.has_fts:
      return False
    fts = self.cursor.execute("SELECT COUNT(*) FROM organization_fts").fetchone()[0]
    orgs = self.cursor.execute("SELECT COUNT(*) FROM organization").fetchone()[0]
    return fts != orgs

  def _row(self, r) -> dict:
    address = ({"street": r[5], "city": r[6], "state": r[7], "zip": r[8],
                "county_fips": r[21], "county_name": r[22]} if any(r[5:9]) else None)
    mailing = {"street": r[13], "city": r[14], "state": r[15], "zip": r[16]} if any(r[13:17]) else None
    return {"ein": r[0], "name": r[1], "is_favorite": bool(r[2]),
            "created_at": r[3], "updated_at": r[4],
            "website": r[9], "main_email": r[10],
            "created_by": r[11], "updated_by": r[12],
            "address": address, "mailing_address": mailing,
            "org_type": r[17], "is_grantmaker": bool(r[18]),
            "sector_code": r[19], "sector_name": r[20]}

  def list_organizations(self, search: str | None = None,
                         limit: int = 50, offset: int = 0,
                         favorites_only: bool = False,
                         org_type: str | None = None, grantmaker: bool | None = None,
                         sector: str | None = None) -> dict:
    clauses: list[str] = []
    params: list = []
    if search:
      clauses.append("o.name LIKE ? ESCAPE '\\'")
      params.append(f"%{escape_like(search)}%")
    if favorites_only:
      clauses.append("o.is_favorite = 1")
    if org_type:
      clauses.append("o.org_type = ?")
      params.append(org_type)
    if grantmaker is not None:
      clauses.append("o.is_grantmaker = ?")
      params.append(1 if grantmaker else 0)
    if sector:
      clauses.append("o.sector_code = ?")
      params.append(sector)
    where = ("WHERE " + " AND ".join(clauses)) if clauses else ""
    total = self.cursor.execute(
      f"SELECT COUNT(*) FROM organization o {where}", params).fetchone()[0]
    rows = self.cursor.execute(
      f"{self._SELECT} {where} ORDER BY o.name LIMIT ? OFFSET ?",
      [*params, limit, offset]).fetchall()
    return {"total": total, "limit": limit, "offset": offset,
            "organizations": [self._row(r) for r in rows]}

  def search_organizations(self, query: str | None = None, *, fuzzy: bool = False,
                           ein: str | None = None, state: str | None = None,
                           city: str | None = None, favorites_only: bool = False,
                           org_type: str | None = None, grantmaker: bool | None = None,
                           sector: str | None = None, county: str | None = None,
                           limit: int = 50, offset: int = 0) -> dict:
    """Strict and fuzzy organization search.

    - ``query`` matches the name: a case-insensitive substring (strict), or — when
      ``fuzzy`` is set and the trigram index is available and the query is ≥3
      chars — typo-tolerant trigram matching ranked by relevance.
    - ``ein`` is a strict forward-looking prefix (``1234`` → ``123456789``).
    - ``state`` / ``city`` are exact filter selections (dropdown-style, not
      fuzzy) against the org's filer address.
    All supplied filters combine with AND. Returns the standard paged shape plus
    a ``mode`` of ``"fuzzy"`` or ``"strict"``.
    """
    query = (query or "").strip()
    ein = (ein or "").strip()
    state = (state or "").strip().upper()
    city = (city or "").strip()
    limit = max(1, min(limit, 500))
    offset = max(offset, 0)

    use_fuzzy = bool(fuzzy and self.has_fts and len(query) >= 3)
    if use_fuzzy and self._fts_stale():
      self.rebuild_search_index()
    match = self._trigram_query(query) if use_fuzzy else None
    if match is None:
      use_fuzzy = False

    def _filters() -> tuple[list[str], list]:
      clauses: list[str] = []
      p: list = []
      if ein:
        clauses.append("o.ein LIKE ? ESCAPE '\\'")
        p.append(f"{escape_like(ein)}%")               # forward-looking prefix
      if state:
        clauses.append("a.state_code = ?")             # exact (dropdown)
        p.append(state)
      if city:
        clauses.append("a.city = ? COLLATE NOCASE")    # exact (dropdown)
        p.append(city)
      if favorites_only:
        clauses.append("o.is_favorite = 1")
      if org_type:                                     # exact (dropdown)
        clauses.append("o.org_type = ?")
        p.append(org_type)
      if grantmaker is not None:
        clauses.append("o.is_grantmaker = ?")
        p.append(1 if grantmaker else 0)
      if sector:                                        # exact (dropdown)
        clauses.append("o.sector_code = ?")
        p.append(sector)
      if county:                                        # exact county FIPS (dropdown)
        clauses.append("a.county_fips = ?")
        p.append(county)
      return clauses, p

    cols = self._COLS

    if use_fuzzy:
      clauses, p = _filters()
      where = " AND ".join(["organization_fts MATCH ?", *clauses])
      base = (f"FROM organization_fts f JOIN organization o ON o.ein = f.ein {self._ADDR_JOINS} "
              f"WHERE {where}")
      total = self.cursor.execute(f"SELECT COUNT(*) {base}", [match, *p]).fetchone()[0]
      rows = self.cursor.execute(
        f"SELECT {cols} {base} ORDER BY bm25(organization_fts) LIMIT ? OFFSET ?",
        [match, *p, limit, offset]).fetchall()
      mode = "fuzzy"
    else:
      clauses, p = _filters()
      if query:
        clauses.insert(0, "o.name LIKE ? ESCAPE '\\'")
        p.insert(0, f"%{escape_like(query)}%")
      where = ("WHERE " + " AND ".join(clauses)) if clauses else ""
      base = self._FROM
      total = self.cursor.execute(f"SELECT COUNT(*) {base} {where}", p).fetchone()[0]
      rows = self.cursor.execute(
        f"SELECT {cols} {base} {where} ORDER BY o.name LIMIT ? OFFSET ?",
        [*p, limit, offset]).fetchall()
      mode = "strict"

    return {"total": total, "limit": limit, "offset": offset, "mode": mode,
            "organizations": [self._row(r) for r in rows]}

  def list_states(self) -> list[dict]:
    """Distinct states present in ORG FILER addresses, named from the `state`
    reference list — the source for the state-search dropdown. Joined through
    organization so the shared address table's appearance (grantee) addresses
    don't leak into the filer-location dropdown."""
    rows = self.cursor.execute(
      "SELECT a.state_code, s.name FROM (SELECT DISTINCT a.state_code FROM address a "
      "JOIN organization o ON o.business_address_id = a.uuid WHERE a.state_code IS NOT NULL) a "
      "LEFT JOIN state s ON s.code = a.state_code ORDER BY a.state_code").fetchall()
    return [{"code": r[0], "name": r[1]} for r in rows]

  def list_cities(self, state: str | None = None) -> list[str]:
    """Distinct cities present in ORG FILER addresses (optionally within one
    state) — the source for the city-search dropdown. Joined through organization
    so appearance addresses in the shared table don't leak in."""
    base = ("SELECT DISTINCT a.city FROM address a "
            "JOIN organization o ON o.business_address_id = a.uuid WHERE a.city IS NOT NULL")
    if state:
      rows = self.cursor.execute(
        base + " AND a.state_code = ? ORDER BY a.city", (state.strip().upper(),)).fetchall()
    else:
      rows = self.cursor.execute(base + " ORDER BY a.city").fetchall()
    return [r[0] for r in rows]

  def list_sectors(self) -> list[dict]:
    """The full sector vocabulary (NTEE major groups), for the sector dropdown."""
    rows = self.cursor.execute(
      "SELECT code, name, parent_code FROM sector ORDER BY code").fetchall()
    return [{"code": r[0], "name": r[1], "parent_code": r[2]} for r in rows]

  def list_counties(self, state: str | None = None) -> list[dict]:
    """Distinct counties present in ORG FILER addresses (optionally within one
    state) — the source for the county-search dropdown. Joined through organization
    (like list_cities); empty until counties are derived from an imported crosswalk."""
    base = ("SELECT DISTINCT a.county_fips, a.county_name, a.state_code FROM address a "
            "JOIN organization o ON o.business_address_id = a.uuid "
            "WHERE a.county_fips IS NOT NULL")
    if state:
      rows = self.cursor.execute(
        base + " AND a.state_code = ? ORDER BY a.county_name", (state.strip().upper(),)).fetchall()
    else:
      rows = self.cursor.execute(base + " ORDER BY a.county_name").fetchall()
    return [{"fips": r[0], "name": r[1], "state": r[2]} for r in rows]

  def get_organization(self, ein: str) -> dict | None:
    row = self.cursor.execute(f"{self._SELECT} WHERE o.ein = ?", (ein,)).fetchone()
    return self._row(row) if row else None

  def upsert_organization(self, ein: str, name: str, address: dict | None = None) -> None:
    """Insert an org if its EIN is new (first-seen wins, like the name). When
    ``address`` (``{street, city, state, zip}``) carries any value, the filer
    address is stored in the address table keyed by the EIN and linked via
    business_address_id. Inserted address-first so the org→address FK holds."""
    has_addr = bool(address and any(address.get(k) for k in ('street', 'city', 'state', 'zip')))
    if has_addr:
      state = (address.get('state') or '').strip().upper() or None
      self.cursor.execute(
        "INSERT OR IGNORE INTO address (uuid, street, city, state_code, zipcode) "
        "VALUES (?, ?, ?, ?, ?)",
        (ein, address.get('street'), address.get('city'), state, address.get('zip')))
    self.cursor.execute(
      "INSERT OR IGNORE INTO organization (ein, name, business_address_id) VALUES (?, ?, ?)",
      (ein, name, ein if has_addr else None))
    # Index genuinely new orgs (rowcount > 0). Bulk ingest bypasses this and
    # rebuilds the index once in the finalize step instead.
    if self.has_fts and self.cursor.rowcount > 0:
      self.cursor.execute("INSERT INTO organization_fts (ein, name) VALUES (?, ?)", (ein, name))

  # ── editable create / edit (app layer) ───────────────────────────────────
  # upsert_organization above is the ingest path (EIN + name, first-seen wins).
  # create_org / update_org are the user-facing CRUD: they validate the EIN,
  # carry the rich contact fields + a physical and a mailing address, and write
  # an audit entry attributing the change to the acting principal.

  _ADDR_FIELDS = ('street', 'city', 'state', 'zip', 'street2')

  @staticmethod
  def normalize_ein(raw) -> str:
    """Validate + normalize an EIN to 9 digits (a single hyphen is allowed, e.g.
    '36-4348917'). Raises ValueError otherwise — every org must have a real EIN."""
    digits = str(raw or '').replace('-', '').replace(' ', '')
    if len(digits) != 9 or not digits.isdigit():
      raise ValueError(f"EIN must be 9 digits, got: {raw!r}")
    return digits

  @classmethod
  def try_normalize_ein(cls, raw) -> str:
    """Best-effort EIN normalization for lookups in sibling concerns: returns the
    9-digit form, or the input unchanged if it isn't a valid EIN (so a malformed
    value simply fails to match rather than raising)."""
    try:
      return cls.normalize_ein(raw)
    except ValueError:
      return str(raw or '')

  @classmethod
  def _addr_has_content(cls, addr) -> bool:
    return bool(addr) and any(addr.get(k) for k in cls._ADDR_FIELDS)

  def _write_address(self, uuid: str, addr: dict | None) -> bool:
    """Upsert one address row keyed by ``uuid`` (the owner key). Returns True if
    the address had content (and was written), False otherwise."""
    if not self._addr_has_content(addr):
      return False
    state = (addr.get('state') or '').strip().upper() or None
    self.cursor.execute(
      "INSERT OR REPLACE INTO address (uuid, street, city, state_code, zipcode, street2) "
      "VALUES (?, ?, ?, ?, ?, ?)",
      (uuid, addr.get('street'), addr.get('city'), state, addr.get('zip'), addr.get('street2')))
    return True

  def _check_sector(self, code) -> None:
    """Raise if ``code`` is a non-empty sector not in the seeded vocabulary."""
    if code and not self.cursor.execute(
        "SELECT 1 FROM sector WHERE code = ?", (code,)).fetchone():
      raise ValueError(f"unknown sector code: {code}")

  def create_org(self, ein: str, name: str, *, website: str | None = None,
                 main_email: str | None = None, physical_address: dict | None = None,
                 mailing_address: dict | None = None, sector_code: str | None = None,
                 actor=None) -> dict:
    """Create a new organization with contact fields and physical/mailing
    addresses. Raises ValueError on a bad EIN or a duplicate. Records an audit
    entry attributed to ``actor`` (an auth.Principal, or None for CLI)."""
    ein = self.normalize_ein(ein)
    if not name or not str(name).strip():
      raise ValueError("name is required")
    if self.cursor.execute("SELECT 1 FROM organization WHERE ein = ?", (ein,)).fetchone():
      raise ValueError(f"organization {ein} already exists")
    self._check_sector(sector_code)
    label = actor.label if actor is not None else None
    phys_linked = self._write_address(ein, physical_address)
    mail_uuid = f"mail:{ein}"
    mail_linked = self._write_address(mail_uuid, mailing_address)
    self.cursor.execute(
      "INSERT INTO organization (ein, name, business_address_id, mailing_address_id, "
      "website, main_email, sector_code, created_by, updated_by) "
      "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)",
      (ein, name, ein if phys_linked else None, mail_uuid if mail_linked else None,
       website, main_email, sector_code or None, label, label))
    if self.has_fts:
      self.cursor.execute("INSERT INTO organization_fts (ein, name) VALUES (?, ?)", (ein, name))
    self._db.audit.record(actor, 'create', 'organization', ein,
                          {'name': name, 'website': website, 'main_email': main_email},
                          commit=False)
    if phys_linked:
      # _write_address is INSERT OR REPLACE (a full row rewrite) and does not carry
      # the derived county columns, so backfill them from the new filer ZIP.
      self.derive_counties(eins=[ein])   # commits; a no-op without a crosswalk
    self.connection.commit()
    return self.get_organization(ein)

  def update_org(self, ein: str, fields: dict, *, actor=None) -> dict | None:
    """Edit an existing organization. Only keys present in ``fields`` are changed
    (``name``, ``website``, ``main_email``, ``sector_code``, ``physical_address``,
    ``mailing_address``). Returns the updated org, or None if no such EIN.
    Records an audit entry attributed to ``actor``."""
    ein = self.normalize_ein(ein)
    if not self.cursor.execute("SELECT 1 FROM organization WHERE ein = ?", (ein,)).fetchone():
      return None
    if 'sector_code' in fields:
      self._check_sector(fields['sector_code'])
    sets: list[str] = []
    params: list = []
    for col in ('name', 'website', 'main_email', 'sector_code'):
      if col in fields:
        sets.append(f"{col} = ?")
        params.append(fields[col] or None if col == 'sector_code' else fields[col])
    phys_written = False
    if 'physical_address' in fields:
      phys_written = self._write_address(ein, fields['physical_address'])
      sets.append("business_address_id = ?")
      params.append(ein if phys_written else None)
    if 'mailing_address' in fields:
      mail_uuid = f"mail:{ein}"
      linked = self._write_address(mail_uuid, fields['mailing_address'])
      sets.append("mailing_address_id = ?")
      params.append(mail_uuid if linked else None)
    label = actor.label if actor is not None else None
    sets.append("updated_by = ?")
    params.append(label)
    sets.append("updated_at = CURRENT_TIMESTAMP")
    self.cursor.execute(
      f"UPDATE organization SET {', '.join(sets)} WHERE ein = ?", [*params, ein])
    if 'name' in fields and self.has_fts:
      self.cursor.execute("UPDATE organization_fts SET name = ? WHERE ein = ?", (fields['name'], ein))
    self._db.audit.record(actor, 'update', 'organization', ein,
                          {'fields': sorted(fields.keys())}, commit=False)
    if phys_written:
      # _write_address rewrote the row (INSERT OR REPLACE) without the derived county
      # columns, and the ZIP may have changed — re-derive county from the new ZIP.
      self.derive_counties(eins=[ein])   # commits; a no-op without a crosswalk
    self.connection.commit()
    return self.get_organization(ein)

  def set_favorite(self, ein: str, is_favorite: bool, *, actor=None) -> bool:
    """Mark an organization as favorited (or not) and bump ``updated_at``.

    Returns True if an organization with that EIN exists (and was updated),
    False if no such organization is present. Audited like the other org edits."""
    self.cursor.execute(
      "UPDATE organization SET is_favorite = ?, updated_at = CURRENT_TIMESTAMP "
      "WHERE ein = ?",
      (1 if is_favorite else 0, ein)
    )
    changed = self.cursor.rowcount > 0
    if changed:
      self._db.audit.record(actor, 'update', 'organization', ein,
                            {'is_favorite': bool(is_favorite)}, commit=False)
    self.connection.commit()
    return changed
