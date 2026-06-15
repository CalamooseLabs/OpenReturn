from database.base import Database
from database.ApiKey import ApiKeyDatabase
from database.Appearance import AppearanceDatabase
from database.Filing import FilingDatabase
from database.Ingest import IngestDatabase
from database.Migration import MigrationDatabase
from database.Organization import OrganizationDatabase
from database.ReportedData import ReportedDataDatabase
from database.Schema import SchemaDatabase
from database.Score import ScoreDatabase


class OpenReturnDB(Database):
    """The application database — a coordinator over one SQLite connection.

    Each concern is its own ``Database`` subclass (in its own folder under
    ``src/database/``) with its own ``sql/setup`` + ``sql/populate`` tree. This
    coordinator owns the single connection, applies the connection-level PRAGMAs,
    and instantiates each concern in foreign-key-dependency order, handing it the
    shared connection. Because every concern lives in the one file, the
    cross-concern foreign keys + cascades (e.g. ``organization_score`` →
    ``filing``, ``reported_data`` → ``filing``/``field``) are all enforceable.

    Concerns are reached by namespace::

        db.meta.get_xpath_index(...)        db.orgs.list_organizations(...)
        db.filings.get_filing(...)          db.reported_data.get_reported_data(...)
        db.keys.validate_api_key(...)       db.ingest.record_ingested_zip(...)
        db.migrations.apply_migration(...)  db.scores.get_score(...)

    Connection lifecycle — ``commit`` / ``close`` / ``begin_bulk_load`` /
    ``end_bulk_load`` — stays on the base ``Database``.
    """

    def __init__(self, name: str = "OpenReturn", path: str | None = None) -> None:
        # Own the connection (and its PRAGMAs); load no sql tree of our own.
        super().__init__(name, sql_dir=None, path=path)

        # Instantiate each concern sharing this connection, in FK-dependency
        # order: schema metadata and organizations before the filings that
        # reference them, reported_data and scores after the filings they hang
        # off of. (SQLite tolerates out-of-order CREATEs, but this keeps the
        # seed inserts and the mental model honest.)
        self.meta          = SchemaDatabase(self)        # form/part/section/line/field
        self.orgs          = OrganizationDatabase(self)  # organization/address/state
        self.filings       = FilingDatabase(self)        # filing → organization, form
        self.reported_data = ReportedDataDatabase(self)  # reported_data → filing, field
        self.keys          = ApiKeyDatabase(self)        # api_key (standalone)
        self.ingest        = IngestDatabase(self)        # ingested_zip (standalone)
        self.migrations    = MigrationDatabase(self)     # migration tracking
        self.scores        = ScoreDatabase(self)         # score_* → filing
        self.appearances   = AppearanceDatabase(self)    # graph: people/grants/related → filing

        # Shared field-metadata cache: built once here, read by reported_data.
        self._field_meta: dict[int, dict] = self.meta._build_field_meta_cache()
