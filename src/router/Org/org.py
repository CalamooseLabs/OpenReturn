import sqlite3
from typing import Any
from http.client import HTTPMessage

from router import Router
from database.IRS990 import IRS990Database


class OrgRouter(Router):
  def __init__(self, prefix: str = '/organizations', db: IRS990Database = None, secure_by_default: bool = False) -> None:
    super().__init__(prefix, secure_by_default=secure_by_default)
    self.db = db
    self._register_routes()

  def _register_routes(self):

    @self.get('')
    def list_organizations(query_params: dict, body: Any, headers: HTTPMessage):
      search = self._qp(query_params, 'search')
      try:
        limit  = min(int(self._qp(query_params, 'limit')  or 50), 500)
        offset = max(int(self._qp(query_params, 'offset') or 0),  0)
      except ValueError:
        return {"error": "limit and offset must be integers"}
      return self.db.list_organizations(search=search, limit=limit, offset=offset)

    @self.get('/detail')
    def get_organization(query_params: dict, body: Any, headers: HTTPMessage):
      ein = self._qp(query_params, 'ein')
      if not ein:
        return {"error": "missing query param: ein"}
      org = self.db.get_organization(ein)
      if org is None:
        return {"error": f"organization not found: {ein}"}
      return org

    @self.get('/full')
    def get_organization_full(query_params: dict, body: Any, headers: HTTPMessage):
      ein = self._qp(query_params, 'ein')
      if not ein:
        return {"error": "missing query param: ein"}
      org = self.db.get_organization(ein)
      if org is None:
        return {"error": f"organization not found: {ein}"}
      filings = self.db.list_filings(ein)
      for f in filings:
        f['links'] = {
          "detail": f"/filings/detail?filing_id={f['filing_id']}",
          "data":   f"/filings/data?filing_id={f['filing_id']}",
          "lookup": f"/filings/lookup?ein={ein}&year={f['year']}",
        }
      return {**org, "filings": filings}

    @self.post('')
    def upsert_organization(query_params: dict, body: Any, headers: HTTPMessage):
      data, err = self._require_fields(body, 'ein', 'name')
      if err:
        return err
      try:
        self.db.upsert_organization(data['ein'], data['name'])
      except sqlite3.IntegrityError as e:
        return {"error": str(e)}
      return self.db.get_organization(data['ein'])
