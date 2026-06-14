import sqlite3
from typing import Any
from http.client import HTTPMessage

from router import Router
from database import OpenReturnDB


class OrgRouter(Router):
  def __init__(self, prefix: str = '/organizations', db: OpenReturnDB = None, secure_by_default: bool = False) -> None:
    super().__init__(prefix, secure_by_default=secure_by_default)
    self.db = db
    self._register_routes()

  def _register_routes(self):

    @self.get('')
    def list_organizations(query_params: dict, body: Any, headers: HTTPMessage):
      search = self._qp(query_params, 'search')
      limit,  e1 = self._qp_int_or_error(query_params, 'limit',  default=50)
      offset, e2 = self._qp_int_or_error(query_params, 'offset', default=0)
      if e1 or e2:
        return {"error": "limit and offset must be integers"}
      limit  = min(limit, 500)
      offset = max(offset, 0)
      favorites_only = (self._qp(query_params, 'favorite') or '').strip().lower() in ('1', 'true', 'yes')
      return self.db.orgs.list_organizations(search=search, limit=limit, offset=offset,
                                        favorites_only=favorites_only)

    @self.get('/detail')
    def get_organization(query_params: dict, body: Any, headers: HTTPMessage):
      ein = self._qp(query_params, 'ein')
      if not ein:
        return {"error": "missing query param: ein"}
      org = self.db.orgs.get_organization(ein)
      if org is None:
        return {"error": f"organization not found: {ein}"}
      return org

    @self.get('/full')
    def get_organization_full(query_params: dict, body: Any, headers: HTTPMessage):
      ein = self._qp(query_params, 'ein')
      if not ein:
        return {"error": "missing query param: ein"}
      org = self.db.orgs.get_organization(ein)
      if org is None:
        return {"error": f"organization not found: {ein}"}
      filings = self.db.filings.list_filings(ein)
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
        self.db.orgs.upsert_organization(data['ein'], data['name'])
        self.db.commit()
      except sqlite3.IntegrityError as e:
        return {"error": str(e)}
      return self.db.orgs.get_organization(data['ein'])

    @self.post('/favorite')
    def set_favorite(query_params: dict, body: Any, headers: HTTPMessage):
      data, err = self._require_fields(body, 'ein', 'is_favorite')
      if err:
        return err
      raw = data['is_favorite']
      is_favorite = raw if isinstance(raw, bool) else str(raw).strip().lower() in ('1', 'true', 'yes')
      if not self.db.orgs.set_favorite(data['ein'], is_favorite):
        return {"error": f"organization not found: {data['ein']}"}
      return self.db.orgs.get_organization(data['ein'])
