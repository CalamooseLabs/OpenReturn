"""Repository classes for the 990 data layer.

Each repository groups one area of query/command responsibility and operates on
the shared ``self.cursor`` / ``self.connection`` it captures from the facade in
``__init__(self, db)``. ``OpenReturnDB`` composes them as namespaces
(``db.orgs.list_organizations(...)`` etc.); repositories reach siblings via
``self._db`` when a query spans concerns.
"""

from .api_keys import ApiKeyRepository as ApiKeyRepository
from .filings import FilingRepository as FilingRepository
from .ingest import IngestRepository as IngestRepository
from .metadata import MetadataRepository as MetadataRepository
from .migrations import MigrationRepository as MigrationRepository
from .organizations import OrganizationRepository as OrganizationRepository
from .reported_data import ReportedDataRepository as ReportedDataRepository
