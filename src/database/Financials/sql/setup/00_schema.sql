-- Unified, multi-source financial data: the layer the scoring models read from.
--
-- A `financial_concept` is a canonical metric (its code IS the scoring key, e.g.
-- 'prog', 'total_exp') that every source maps into. A `financial_document` is one
-- source of data for an org-year (a 990 filing, an audited statement, an OCR run,
-- a manual batch). A `financial_observation` is one source's value for one concept
-- in that document — MANY may exist per (org, year, concept). `financial_canonical`
-- records the single chosen observation per (org, year, concept) that models use;
-- a sole observation is canonical automatically, and genuine disagreements wait
-- for a manual choice (see ListsDatabase docs / access-control). All observations
-- are always retained, so differences between sources are never lost.

CREATE TABLE IF NOT EXISTS financial_concept (
  code             TEXT PRIMARY KEY,        -- == the scoring model input key
  label            TEXT NOT NULL,
  category         TEXT,
  unit             TEXT,
  default_xml_path TEXT,                     -- 990 xml_path this concept derives from
  direction_hint   TEXT
);

CREATE TABLE IF NOT EXISTS financial_source (
  code TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  rank INTEGER NOT NULL DEFAULT 0            -- informational only; selection is manual
);

INSERT OR IGNORE INTO financial_source (code, name, rank) VALUES
  ('irs_990_xml',       'IRS 990 (e-file XML)',         100),
  ('irs_regrab',        'IRS 990 (re-fetched)',         100),
  ('audited_statement', 'Audited financial statement',   70),
  ('manual_990',        'Manually entered 990',          50),
  ('ocr_990_pdf',       'OCR of a 990 PDF',              30);

CREATE TABLE IF NOT EXISTS financial_document (
  document_id     INTEGER PRIMARY KEY AUTOINCREMENT,
  organization_id CHARACTER(10) NOT NULL REFERENCES organization (ein) ON DELETE CASCADE,
  fiscal_year     SMALLINT NOT NULL,
  source_code     TEXT NOT NULL REFERENCES financial_source (code),
  kind            TEXT,
  filename        TEXT,
  object_id       TEXT,
  filing_id       INTEGER REFERENCES filing (filing_id) ON DELETE CASCADE,
  uploaded_by     TEXT,
  uploaded_at     TEXT NOT NULL DEFAULT (datetime('now')),
  note            TEXT
);

-- derive_bulk()'s set-based pass scopes/joins on these: organization_id (the eins
-- filter at the ingest finalize) and filing_id (the NOT-EXISTS doc guard + the
-- join to reported_data). Without them a scoped derive full-scans financial_document.
CREATE INDEX IF NOT EXISTS idx_findoc_org    ON financial_document (organization_id);
CREATE INDEX IF NOT EXISTS idx_findoc_filing ON financial_document (filing_id);

CREATE TABLE IF NOT EXISTS financial_observation (
  observation_id  INTEGER PRIMARY KEY AUTOINCREMENT,
  organization_id CHARACTER(10) NOT NULL REFERENCES organization (ein) ON DELETE CASCADE,
  fiscal_year     SMALLINT NOT NULL,
  concept_code    TEXT NOT NULL REFERENCES financial_concept (code),
  source_code     TEXT NOT NULL REFERENCES financial_source (code),
  document_id     INTEGER NOT NULL REFERENCES financial_document (document_id) ON DELETE CASCADE,
  value           REAL,
  raw_value       TEXT,
  confidence      REAL,                      -- 0..1; per-reading (esp. OCR), else source default
  entered_by      TEXT,
  entered_at      TEXT NOT NULL DEFAULT (datetime('now')),
  note            TEXT,
  UNIQUE (document_id, concept_code)
);

CREATE INDEX IF NOT EXISTS idx_fobs_fact
  ON financial_observation (organization_id, fiscal_year, concept_code);

CREATE TABLE IF NOT EXISTS financial_canonical (
  organization_id CHARACTER(10) NOT NULL REFERENCES organization (ein) ON DELETE CASCADE,
  fiscal_year     SMALLINT NOT NULL,
  concept_code    TEXT NOT NULL REFERENCES financial_concept (code),
  observation_id  INTEGER NOT NULL REFERENCES financial_observation (observation_id) ON DELETE CASCADE,
  -- Denormalized copy of the chosen observation's value, so scoring reads the
  -- canonical value WITHOUT joining financial_observation (the join's random
  -- observation_id fetch was ~84% of the corpus-scale canonical-read cost).
  -- observation.value is write-once (never UPDATEd — only confidence is, in
  -- ocr.py), so this mirror can never drift from its source. Maintained at every
  -- canonical write site (see financials.py) + the trg_fobs_recanonical trigger.
  -- Nullable: set_canonical may pick a NULL-valued observation; reads filter
  -- `value IS NOT NULL`, identical to the old `o.value IS NOT NULL`.
  value           REAL,
  chosen_by       TEXT,
  chosen_at       TEXT NOT NULL DEFAULT (datetime('now')),
  PRIMARY KEY (organization_id, fiscal_year, concept_code)
);

-- When the canonical observation for a fact is deleted, its financial_canonical
-- row cascades away (above). If another valued observation for that fact still
-- exists (e.g. a sibling document), re-select a canonical automatically so the
-- fact does not silently lose its value. The cascade delete runs BEFORE this
-- AFTER DELETE trigger, so the WHEN guard sees the canonical already gone.
CREATE TRIGGER IF NOT EXISTS trg_fobs_recanonical
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
