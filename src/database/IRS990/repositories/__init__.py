"""Repository mixins for IRS990Database.

Each mixin groups one area of query/command responsibility and operates on
the ``self.cursor`` / ``self.connection`` provided by the base ``Database``.
``IRS990Database`` composes them via multiple inheritance, so the public
interface (``db.list_organizations(...)`` etc.) stays flat and unchanged.
"""

from .api_keys import ApiKeyRepository as ApiKeyRepository
from .filings import FilingRepository as FilingRepository
from .ingest import IngestRepository as IngestRepository
from .metadata import MetadataRepository as MetadataRepository
from .migrations import MigrationRepository as MigrationRepository
from .organizations import OrganizationRepository as OrganizationRepository
from .reported_data import ReportedDataRepository as ReportedDataRepository
