from database import Database
from .repositories import (
  ApiKeyRepository,
  FilingRepository,
  MetadataRepository,
  MigrationRepository,
  OrganizationRepository,
  ReportedDataRepository,
)


class IRS990Database(
  Database,
  MigrationRepository,
  ApiKeyRepository,
  MetadataRepository,
  OrganizationRepository,
  FilingRepository,
  ReportedDataRepository,
):
  """IRS Form 990 database.

  Schema and seed data load from ``IRS990/sql/{setup,populate}/`` via the
  base ``Database``. Query/command behaviour is split across the repository
  mixins in ``IRS990/repositories/``; they are composed here so the public
  surface stays flat (``db.list_organizations(...)``, ``db.create_filing(...)``).
  """

  def __init__(self, name="OpenReturn", path: str | None = None) -> None:
    super().__init__(name, "IRS990", populate_guard="form", path=path)
    try:
      self.cursor.execute(
        "ALTER TABLE api_key ADD COLUMN rate_limit INTEGER NOT NULL DEFAULT -1"
      )
      self.connection.commit()  # pragma: no cover — only runs on pre-migration DBs
    except Exception:
      pass  # column already exists (fresh DB has it from sql/setup/01_api_keys.sql)
    self._field_meta: dict[int, dict] = self._build_field_meta_cache()
    self._key_cache:  dict[str, int | None] = {}
