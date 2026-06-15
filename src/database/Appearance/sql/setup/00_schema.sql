-- Graph layer: people, grants, and related-org relationships extracted from the
-- REPEATING XML groups that the flat EAV (reported_data) cannot hold. Each row in
-- reported_data is one value per (filing, field); repeating groups (officers, PF
-- grants, Schedule I/R recipients) have many instances per filing, so they live
-- here instead — one row per occurrence — as the edges of a person<->org<->grant
-- graph (nodes = organization + party).
--
-- Design notes (see docs/development/graph-model.md):
--  * No AUTOINCREMENT: PKs are plain INTEGER rowid aliases so the bulk-ingest path
--    can client-assign ids seeded past MAX (mirroring filing.filing_id).
--  * EINs (appearance_ein) are SOFT links stored as TEXT with NO FK to
--    organization(ein): a grantee/related org usually has not filed (or, for PF
--    grants, carries no EIN at all), so a hard FK would fail the bulk insert under
--    PRAGMA foreign_keys=ON. The org node link is made at resolve/query time.
--  * Idempotency: every table keys on UNIQUE(filing_id, group_code,
--    occurrence_index) — positional + deterministic, so re-ingest is a no-op.
--  * Address is stored INLINE on party_appearance as a point-in-time snapshot
--    (an attribute of the appearance, not a shared graph node).

-- One person/org exactly as it appears in one repeating-group instance on one
-- filing — the un-resolved node "appearance". Edges point here; the resolver fills
-- resolved_party_id later. Address columns hold the recipient/person address as
-- filed (US: state_code/zipcode; FOREIGN: province/country_code/foreign_postal).
CREATE TABLE IF NOT EXISTS party_appearance (
  appearance_id    INTEGER PRIMARY KEY,
  filing_id        INTEGER NOT NULL REFERENCES filing (filing_id) ON DELETE CASCADE,
  group_code       TEXT NOT NULL,            -- 1:1 with a single XML container path
  occurrence_index INTEGER NOT NULL,         -- 0-based position within that container
  party_kind       TEXT NOT NULL,            -- 'person' | 'organization'
  person_name      TEXT,                     -- PersonNm / RecipientPersonNm
  business_name    TEXT,                     -- BusinessNameLine1Txt(+Line2)
  appearance_ein   TEXT,                     -- soft link (Sched I/R); NULL for PF grants
  -- Address-as-filed lives in the shared `address` table (owned by the
  -- Organization concern), referenced by a deterministic owner key
  -- 'ap:<filing_id>:<group_code>:<occurrence_index>' so re-ingest is idempotent
  -- with no content-dedup. NULL when the group carries no address.
  address_uuid     TEXT REFERENCES address (uuid),
  resolved_party_id INTEGER REFERENCES party (party_id),  -- NULL until resolver runs
  UNIQUE (filing_id, group_code, occurrence_index)
);

-- person <-> org governance/compensation edge (Form 990 Part VII-A, 990-EZ Part
-- IV, 990-PF Part VIII). Role flags + compensation as typed numerics (edge
-- weights). Columns a given form does not carry stay NULL.
CREATE TABLE IF NOT EXISTS person_role (
  role_id          INTEGER PRIMARY KEY,
  filing_id        INTEGER NOT NULL REFERENCES filing (filing_id) ON DELETE CASCADE,
  appearance_id    INTEGER NOT NULL REFERENCES party_appearance (appearance_id) ON DELETE CASCADE,
  group_code       TEXT NOT NULL,
  occurrence_index INTEGER NOT NULL,
  title            TEXT,
  avg_hours_org    REAL,
  avg_hours_related REAL,
  is_officer          INTEGER,
  is_director_trustee INTEGER,
  is_key_employee     INTEGER,
  is_highest_comp     INTEGER,
  is_former           INTEGER,
  reportable_comp_org     REAL,
  reportable_comp_related REAL,
  other_comp              REAL,
  UNIQUE (filing_id, group_code, occurrence_index)
);

-- grantor org -> grantee org/person money edge. Schedule I (RecipientEIN present)
-- and 990-PF grants paid/approved (no EIN — name+address only). grant_kind tags
-- the source. Amount is the typed edge weight.
CREATE TABLE IF NOT EXISTS grant_edge (
  grant_id         INTEGER PRIMARY KEY,
  filing_id        INTEGER NOT NULL REFERENCES filing (filing_id) ON DELETE CASCADE,  -- grantor (filer)
  appearance_id    INTEGER NOT NULL REFERENCES party_appearance (appearance_id) ON DELETE CASCADE,  -- grantee
  group_code       TEXT NOT NULL,
  occurrence_index INTEGER NOT NULL,
  grant_kind       TEXT NOT NULL,           -- 'SCHED_I_ORG' | 'PF_PAID' | 'PF_APPROVED'
  recipient_ein    TEXT,                    -- Sched I only; NULL for PF
  cash_amount      REAL,
  noncash_amount   REAL,
  purpose_txt      TEXT,
  irc_section      TEXT,
  recipient_relationship      TEXT,         -- PF RecipientRelationshipTxt (insider flag)
  recipient_foundation_status TEXT,         -- PF RecipientFoundationStatusTxt (grantee classifier)
  UNIQUE (filing_id, group_code, occurrence_index)
);

-- org <-> org affiliation/control/ownership edge (Schedule R). related_ein is a
-- soft link (these carry an EIN, so they hard-link better than PF grants).
CREATE TABLE IF NOT EXISTS related_org (
  related_id       INTEGER PRIMARY KEY,
  filing_id        INTEGER NOT NULL REFERENCES filing (filing_id) ON DELETE CASCADE,
  appearance_id    INTEGER NOT NULL REFERENCES party_appearance (appearance_id) ON DELETE CASCADE,
  group_code       TEXT NOT NULL,
  occurrence_index INTEGER NOT NULL,
  relation_kind    TEXT NOT NULL,           -- 'SCHED_R_EXEMPT' | 'SCHED_R_PARTNERSHIP' | ...
  related_ein      TEXT,
  primary_activities TEXT,
  legal_domicile     TEXT,
  ownership_pct      REAL,
  control_ind        INTEGER,
  UNIQUE (filing_id, group_code, occurrence_index)
);

-- Canonical resolved graph NODE: a person or non-filer org that >=1 appearances
-- resolve to. Filer orgs stay in `organization` (EIN = node id). Populated by the
-- re-runnable resolver (openreturn resolve), NOT by ingest. cluster_key is the
-- resolver's deterministic identity hash (NOT NULL) so re-runs INSERT OR IGNORE
-- idempotently regardless of NULL EINs.
CREATE TABLE IF NOT EXISTS party (
  party_id       INTEGER PRIMARY KEY,
  party_type     TEXT NOT NULL,             -- 'person' | 'organization'
  canonical_name TEXT NOT NULL,
  ein            TEXT,                       -- set when known
  cluster_key    TEXT NOT NULL,
  resolver_version INTEGER,
  created_at     DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE (cluster_key)
);

-- Lookup-only indexes. NOTE: these are added to Schema._INGEST_INDEXES so the
-- bulk path drops them before load and rebuilds them once at the end; the UNIQUE
-- idempotency constraints above are NOT dropped (they guard the load).
CREATE INDEX IF NOT EXISTS idx_appearance_filing   ON party_appearance (filing_id);
CREATE INDEX IF NOT EXISTS idx_appearance_ein      ON party_appearance (appearance_ein);
CREATE INDEX IF NOT EXISTS idx_appearance_resolved ON party_appearance (resolved_party_id);
CREATE INDEX IF NOT EXISTS idx_appearance_person   ON party_appearance (person_name);
CREATE INDEX IF NOT EXISTS idx_appearance_business ON party_appearance (business_name);
CREATE INDEX IF NOT EXISTS idx_person_role_appearance ON person_role (appearance_id);
CREATE INDEX IF NOT EXISTS idx_grant_edge_appearance  ON grant_edge (appearance_id);
CREATE INDEX IF NOT EXISTS idx_grant_edge_ein         ON grant_edge (recipient_ein);
CREATE INDEX IF NOT EXISTS idx_related_org_appearance ON related_org (appearance_id);
CREATE INDEX IF NOT EXISTS idx_related_org_ein        ON related_org (related_ein);
CREATE INDEX IF NOT EXISTS idx_party_ein             ON party (ein);
