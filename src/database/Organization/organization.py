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

  # Org columns + the LEFT-joined filer address, in select order.
  _SELECT = (
    "SELECT o.ein, o.name, o.is_favorite, o.created_at, o.updated_at, "
    "a.street, a.city, a.state_code, a.zipcode "
    "FROM organization o LEFT JOIN address a ON a.uuid = o.business_address_id")

  def __init__(self, db) -> None:
    self._db = db
    super().__init__("Organization", "Organization", populate_guard="state",
                     connection=db.connection, cursor=db.cursor)
    self._migrate_schema()
    self._ensure_search_index()

  def _migrate_schema(self) -> None:
    """Relax a legacy strict ``address`` table (NOT NULL columns + a state FK)
    to the nullable, FK-free schema partial addresses need. The address table
    has never been populated, so recreating it is safe."""
    info = self.cursor.execute("PRAGMA table_info(address)").fetchall()
    # table_info cols: (cid, name, type, notnull, dflt_value, pk)
    strict = any(c[1] in ('street', 'city', 'state_code', 'zipcode') and c[3] == 1 for c in info)
    if strict:
      self.cursor.execute("DROP TABLE address")
      self.cursor.execute(
        "CREATE TABLE address (uuid CHARACTER(36) PRIMARY KEY, street TEXT, "
        "city TEXT, state_code CHARACTER(2), zipcode TEXT)")
    self.cursor.execute("CREATE INDEX IF NOT EXISTS idx_address_state ON address (state_code)")
    self.cursor.execute("CREATE INDEX IF NOT EXISTS idx_address_city ON address (city)")
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
    address = None
    if any(r[5:9]):
      address = {"street": r[5], "city": r[6], "state": r[7], "zip": r[8]}
    return {"ein": r[0], "name": r[1], "is_favorite": bool(r[2]),
            "created_at": r[3], "updated_at": r[4], "address": address}

  def list_organizations(self, search: str | None = None,
                         limit: int = 50, offset: int = 0,
                         favorites_only: bool = False) -> dict:
    clauses: list[str] = []
    params: list = []
    if search:
      clauses.append("o.name LIKE ? ESCAPE '\\'")
      params.append(f"%{escape_like(search)}%")
    if favorites_only:
      clauses.append("o.is_favorite = 1")
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
      return clauses, p

    cols = ("o.ein, o.name, o.is_favorite, o.created_at, o.updated_at, "
            "a.street, a.city, a.state_code, a.zipcode")

    if use_fuzzy:
      clauses, p = _filters()
      where = " AND ".join(["organization_fts MATCH ?", *clauses])
      base = ("FROM organization_fts f JOIN organization o ON o.ein = f.ein "
              f"LEFT JOIN address a ON a.uuid = o.business_address_id WHERE {where}")
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
      base = "FROM organization o LEFT JOIN address a ON a.uuid = o.business_address_id"
      total = self.cursor.execute(f"SELECT COUNT(*) {base} {where}", p).fetchone()[0]
      rows = self.cursor.execute(
        f"SELECT {cols} {base} {where} ORDER BY o.name LIMIT ? OFFSET ?",
        [*p, limit, offset]).fetchall()
      mode = "strict"

    return {"total": total, "limit": limit, "offset": offset, "mode": mode,
            "organizations": [self._row(r) for r in rows]}

  def list_states(self) -> list[dict]:
    """Distinct states present in stored addresses, named from the `state`
    reference list — the source for the state-search dropdown."""
    rows = self.cursor.execute(
      "SELECT a.state_code, s.name FROM (SELECT DISTINCT state_code FROM address "
      "WHERE state_code IS NOT NULL) a LEFT JOIN state s ON s.code = a.state_code "
      "ORDER BY a.state_code").fetchall()
    return [{"code": r[0], "name": r[1]} for r in rows]

  def list_cities(self, state: str | None = None) -> list[str]:
    """Distinct cities present in stored addresses (optionally within one state)
    — the source for the city-search dropdown."""
    if state:
      rows = self.cursor.execute(
        "SELECT DISTINCT city FROM address WHERE city IS NOT NULL AND state_code = ? "
        "ORDER BY city", (state.strip().upper(),)).fetchall()
    else:
      rows = self.cursor.execute(
        "SELECT DISTINCT city FROM address WHERE city IS NOT NULL ORDER BY city").fetchall()
    return [r[0] for r in rows]

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

  def set_favorite(self, ein: str, is_favorite: bool) -> bool:
    """Mark an organization as favorited (or not) and bump ``updated_at``.

    Returns True if an organization with that EIN exists (and was updated),
    False if no such organization is present."""
    self.cursor.execute(
      "UPDATE organization SET is_favorite = ?, updated_at = CURRENT_TIMESTAMP "
      "WHERE ein = ?",
      (1 if is_favorite else 0, ein)
    )
    self.connection.commit()
    return self.cursor.rowcount > 0
