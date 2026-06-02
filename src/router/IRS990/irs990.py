import sqlite3
from typing import Any
from http.client import HTTPMessage

from router import Router
from database.IRS990 import IRS990Database


def _qp(query_params: dict, key: str) -> str | None:
    return query_params.get(key, [None])[0]


def _require_fields(body: Any, *keys: str) -> tuple[dict | None, dict | None]:
    if not isinstance(body, dict):
        return None, {"error": "JSON body required"}
    missing = [k for k in keys if k not in body]
    if missing:
        return None, {"error": f"missing required fields: {missing}"}
    return body, None


class IRS990Router(Router):
  def __init__(self, prefix: str = '/irs990', db: IRS990Database = None) -> None:
    super().__init__(prefix)
    self.db = db
    self._register_routes()

  def _register_routes(self):

    # --- Organizations ---

    @self.get('/organizations')
    def list_organizations(query_params: dict, body: Any, headers: HTTPMessage):
      return {"organizations": self.db.list_organizations()}

    @self.get('/organizations/detail')
    def get_organization(query_params: dict, body: Any, headers: HTTPMessage):
      ein = _qp(query_params, 'ein')
      if not ein:
        return {"error": "missing query param: ein"}
      org = self.db.get_organization(ein)
      if org is None:
        return {"error": f"organization not found: {ein}"}
      return org

    @self.post('/organizations')
    def upsert_organization(query_params: dict, body: Any, headers: HTTPMessage):
      data, err = _require_fields(body, 'ein', 'name')
      if err:
        return err
      try:
        self.db.upsert_organization(data['ein'], data['name'])
      except sqlite3.IntegrityError as e:
        return {"error": str(e)}
      return self.db.get_organization(data['ein'])

    # --- Filings ---

    @self.get('/filings')
    def list_filings(query_params: dict, body: Any, headers: HTTPMessage):
      ein = _qp(query_params, 'ein')
      if not ein:
        return {"error": "missing query param: ein"}
      return {"filings": self.db.list_filings(ein)}

    @self.get('/filings/detail')
    def get_filing(query_params: dict, body: Any, headers: HTTPMessage):
      filing_id = _qp(query_params, 'filing_id')
      if not filing_id:
        return {"error": "missing query param: filing_id"}
      filing = self.db.get_filing(filing_id)
      if filing is None:
        return {"error": f"filing not found: {filing_id}"}
      return filing

    @self.post('/filings')
    def create_filing(query_params: dict, body: Any, headers: HTTPMessage):
      data, err = _require_fields(body, 'ein', 'year', 'form_code')
      if err:
        return err
      try:
        filing_id = self.db.create_filing(data['ein'], int(data['year']), data['form_code'])
      except (sqlite3.IntegrityError, ValueError) as e:
        return {"error": str(e)}
      return {"filing_id": filing_id}

    # --- Reported Data ---

    @self.get('/filings/data')
    def get_reported_data(query_params: dict, body: Any, headers: HTTPMessage):
      filing_id = _qp(query_params, 'filing_id')
      if not filing_id:
        return {"error": "missing query param: filing_id"}
      return {"filing_id": filing_id, "data": self.db.get_reported_data(filing_id)}

    @self.post('/filings/data')
    def store_reported_data(query_params: dict, body: Any, headers: HTTPMessage):
      data, err = _require_fields(body, 'filing_id', 'values')
      if err:
        return err
      if not isinstance(data['values'], dict):
        return {"error": "values must be a dict mapping field_id to raw_value"}
      try:
        values = {int(k): v for k, v in data['values'].items()}
        self.db.store_reported_data(data['filing_id'], values)
      except (sqlite3.IntegrityError, ValueError) as e:
        return {"error": str(e)}
      return {"filing_id": data['filing_id'], "fields_stored": len(values)}
