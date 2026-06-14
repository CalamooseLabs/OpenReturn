from database.base import Database
from database.IRS990.repositories import (
    ApiKeyRepository,
    FilingRepository,
    IngestRepository,
    MetadataRepository,
    MigrationRepository,
    OrganizationRepository,
    ReportedDataRepository,
)
from database.Score.score import ScoreRepository


class OpenReturnDB(Database):
    """The application database — one SQLite connection with each concern exposed
    as a repository.

    Schema/seed load from the ``IRS990`` and ``Score`` sql trees onto the single
    connection owned by the base ``Database``. Behaviour is composed (not
    inherited) from focused repositories accessed by namespace::

        db.orgs.list_organizations(...)     db.filings.get_filing(...)
        db.reported_data.get_reported_data(...)   db.meta.get_xpath_index(...)
        db.keys.validate_api_key(...)       db.migrations.apply_migration(...)
        db.ingest.record_ingested_zip(...)  db.scores.get_score(...)

    The repositories share this facade's connection (so cross-concern JOINs, FKs,
    and one transaction scope all hold) and reach each other via ``self._db``.
    Connection lifecycle — ``commit``/``close``/``begin_bulk_load``/
    ``end_bulk_load`` — lives on the base ``Database``.
    """

    def __init__(self, name: str = "OpenReturn", path: str | None = None) -> None:
        # Base schema + seed for the 990 data layer (IRS990 sql tree).
        super().__init__(name, "IRS990", populate_guard="form", path=path)

        # Additive migration for databases created before api_key.rate_limit
        # existed (fresh DBs already have it from sql/setup).
        try:
            self.cursor.execute(
                "ALTER TABLE api_key ADD COLUMN rate_limit INTEGER NOT NULL DEFAULT -1")
            self.connection.commit()  # pragma: no cover — only on pre-migration DBs
        except Exception:
            pass

        # Scoring schema + seed (loaded after the base 990 schema).
        self._run_dir("sql/setup", "Score")
        self._migrate_model_columns()
        if not self._table_has_rows("score_model"):
            self._run_dir("sql/populate", "Score")

        # Repositories (composition over inheritance). They capture the shared
        # cursor/connection and reach siblings lazily through this facade.
        self.meta          = MetadataRepository(self)
        self.orgs          = OrganizationRepository(self)
        self.filings       = FilingRepository(self)
        self.reported_data = ReportedDataRepository(self)
        self.keys          = ApiKeyRepository(self)
        self.migrations    = MigrationRepository(self)
        self.ingest        = IngestRepository(self)
        self.scores        = ScoreRepository(self)

        # Shared field-metadata cache: built once here, read by reported_data.
        self._field_meta: dict[int, dict] = self.meta._build_field_meta_cache()

    def _migrate_model_columns(self) -> None:
        """Add the model-type / manual-scoring columns to databases created
        before they existed (fresh DBs get them from sql/setup). Each ALTER is
        independent and ignored only when the column already exists."""
        for ddl in (
            "ALTER TABLE score_model ADD COLUMN model_type TEXT REFERENCES model_type (code)",
            "ALTER TABLE score_model ADD COLUMN scoring_mode TEXT NOT NULL DEFAULT 'computed'",
            "ALTER TABLE score_factor ADD COLUMN manual_scale TEXT",
            "ALTER TABLE organization_score_factor ADD COLUMN comment TEXT",
        ):
            try:
                self.cursor.execute(ddl)
            except Exception as exc:
                # Expected when the column already exists; re-raise anything else
                # so a genuine migration failure isn't silently swallowed (string
                # match keeps this binding-agnostic across sqlite3 / sqlcipher3).
                if 'duplicate column' not in str(exc).lower():
                    raise
        # Backfill pre-existing models as financial/computed (the only kind before).
        try:
            self.cursor.execute(
                "UPDATE score_model SET model_type = 'financial' WHERE model_type IS NULL")
        except Exception:  # pragma: no cover — column guaranteed present above
            pass
        self.connection.commit()
