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

  def _viewer(self, headers: HTTPMessage):
    p = self._principal(headers)
    return p.user_id if (p is not None and p.kind == 'user') else None

  def _with_following(self, result: dict, headers: HTTPMessage) -> dict:
    """Annotate each org in a search/list envelope with a ``following`` flag for the
    calling user (False for all when the caller isn't a logged-in user)."""
    orgs = result.get('organizations', [])
    followed = self.db.follows.followed_eins(self._viewer(headers), [o['ein'] for o in orgs])
    for o in orgs:
      o['following'] = o['ein'] in followed
    return result

  def _qp_bool(self, query_params: dict, key: str):
    """Tri-state bool query param: None if absent, else truthy parse."""
    raw = self._qp(query_params, key)
    return None if raw is None else raw.strip().lower() in ('1', 'true', 'yes')

  def _register_routes(self):

    @self.get('', permission='org:read')
    def list_organizations(query_params: dict, body: Any, headers: HTTPMessage):
      search = self._qp(query_params, 'search')
      limit,  e1 = self._qp_int_or_error(query_params, 'limit',  default=50)
      offset, e2 = self._qp_int_or_error(query_params, 'offset', default=0)
      if e1 or e2:
        return {"error": "limit and offset must be integers"}
      limit  = min(limit, 500)
      offset = max(offset, 0)
      favorites_only = (self._qp(query_params, 'favorite') or '').strip().lower() in ('1', 'true', 'yes')
      return self._with_following(self.db.orgs.list_organizations(
        search=search, limit=limit, offset=offset, favorites_only=favorites_only,
        org_type=self._qp(query_params, 'type'),
        grantmaker=self._qp_bool(query_params, 'grantmaker'),
        sector=self._qp(query_params, 'sector')), headers)

    @self.get('/search', permission='org:read')
    def search_organizations(query_params: dict, body: Any, headers: HTTPMessage):
      """Strict or fuzzy organization search. Params: q (name), ein (prefix),
      state (exact 2-letter), city (exact), county (exact FIPS), type
      (foundation/nonprofit/other), sector (NTEE code), grantmaker (1/0), fuzzy=1
      (typo-tolerant name), favorite=1, limit, offset. At least one filter is required."""
      q     = self._qp(query_params, 'q') or self._qp(query_params, 'query')
      ein   = self._qp(query_params, 'ein')
      state = self._qp(query_params, 'state')
      city  = self._qp(query_params, 'city')
      county = self._qp(query_params, 'county')
      org_type = self._qp(query_params, 'type')
      sector = self._qp(query_params, 'sector')
      grantmaker = self._qp_bool(query_params, 'grantmaker')
      if not any([q, ein, state, city, county, org_type, sector, grantmaker is not None]):
        return {"error": "provide at least one of: q, ein, state, city, county, type, sector, grantmaker"}
      limit,  e1 = self._qp_int_or_error(query_params, 'limit',  default=50)
      offset, e2 = self._qp_int_or_error(query_params, 'offset', default=0)
      if e1 or e2:
        return {"error": "limit and offset must be integers"}
      fuzzy          = (self._qp(query_params, 'fuzzy')    or '').strip().lower() in ('1', 'true', 'yes')
      favorites_only = (self._qp(query_params, 'favorite') or '').strip().lower() in ('1', 'true', 'yes')
      return self._with_following(self.db.orgs.search_organizations(
        q, fuzzy=fuzzy, ein=ein, state=state, city=city, county=county, org_type=org_type,
        sector=sector, grantmaker=grantmaker, favorites_only=favorites_only,
        limit=limit, offset=offset), headers)

    @self.get('/states', permission='org:read')
    def list_states(query_params: dict, body: Any, headers: HTTPMessage):
      """States present in stored filer addresses (for the state-search dropdown)."""
      return {"states": self.db.orgs.list_states()}

    @self.get('/cities', permission='org:read')
    def list_cities(query_params: dict, body: Any, headers: HTTPMessage):
      """Cities present in stored filer addresses, optionally within one state
      (param: state) — for the city-search dropdown."""
      return {"cities": self.db.orgs.list_cities(self._qp(query_params, 'state'))}

    @self.get('/sectors', permission='org:read')
    def list_sectors(query_params: dict, body: Any, headers: HTTPMessage):
      """The sector vocabulary (NTEE major groups) — for the sector dropdown."""
      return {"sectors": self.db.orgs.list_sectors()}

    @self.get('/counties', permission='org:read')
    def list_counties(query_params: dict, body: Any, headers: HTTPMessage):
      """Counties present in stored filer addresses (optionally within one state) —
      for the county-search dropdown. Empty until counties are imported/derived."""
      return {"counties": self.db.orgs.list_counties(self._qp(query_params, 'state'))}

    @self.get('/detail', permission='org:read')
    def get_organization(query_params: dict, body: Any, headers: HTTPMessage):
      ein = self._qp(query_params, 'ein')
      if not ein:
        return {"error": "missing query param: ein"}
      org = self.db.orgs.get_organization(ein)
      if org is None:
        return {"error": f"organization not found: {ein}"}
      org['following'] = self.db.follows.is_following(self._viewer(headers), ein)
      return org

    @self.get('/grants', permission='org:read')
    def org_grants(query_params: dict, body: Any, headers: HTTPMessage):
      """Grants this org made (``direction=made``, default — the foundation →
      nonprofits view) or received (``direction=received``). Built on the grant
      graph; 990-PF grantee EINs link only after `openreturn resolve`."""
      ein = self._qp(query_params, 'ein')
      if not ein:
        return {"error": "missing query param: ein"}
      direction = (self._qp(query_params, 'direction') or 'made').strip().lower()
      if direction == 'received':
        return self.db.appearances.grants_received(ein)
      if direction == 'made':
        return self.db.appearances.grants_made(ein)
      return {"error": "direction must be 'made' or 'received'"}

    @self.get('/full', permission='org:read')
    def get_organization_full(query_params: dict, body: Any, headers: HTTPMessage):
      ein = self._qp(query_params, 'ein')
      if not ein:
        return {"error": "missing query param: ein"}
      org = self.db.orgs.get_organization(ein)
      if org is None:
        return {"error": f"organization not found: {ein}"}
      org['following'] = self.db.follows.is_following(self._viewer(headers), ein)
      filings = self.db.filings.list_filings(ein)
      for f in filings:
        f['links'] = {
          "detail": f"/filings/detail?filing_id={f['filing_id']}",
          "data":   f"/filings/data?filing_id={f['filing_id']}",
          "lookup": f"/filings/lookup?ein={ein}&year={f['year']}",
        }
      return {**org, "filings": filings}

    @self.post('', permission='org:write')
    def create_organization(query_params: dict, body: Any, headers: HTTPMessage):
      """Create an organization. Body: {ein, name, website?, main_email?,
      sector_code?, address? (physical), mailing_address?}. EIN must be 9 digits and new."""
      data, err = self._require_fields(body, 'ein', 'name')
      if err:
        return err
      try:
        return self.db.orgs.create_org(
          data['ein'], data['name'],
          website=data.get('website'), main_email=data.get('main_email'),
          sector_code=data.get('sector_code'),
          physical_address=data.get('physical_address') or data.get('address'),
          mailing_address=data.get('mailing_address'),
          actor=self._principal(headers))
      except ValueError as e:
        return {"error": str(e)}
      except sqlite3.IntegrityError as e:
        return {"error": str(e)}

    @self.post('/edit', permission='org:write')
    def edit_organization(query_params: dict, body: Any, headers: HTTPMessage):
      """Edit an existing organization. Body: {ein, ...changed fields}. Only the
      fields present are updated (name, website, main_email, sector_code,
      address/physical_address, mailing_address)."""
      data, err = self._require_fields(body, 'ein')
      if err:
        return err
      fields = {k: data[k] for k in ('name', 'website', 'main_email', 'sector_code',
                                     'physical_address', 'mailing_address') if k in data}
      if 'address' in data and 'physical_address' not in fields:
        fields['physical_address'] = data['address']
      try:
        org = self.db.orgs.update_org(data['ein'], fields, actor=self._principal(headers))
      except ValueError as e:
        return {"error": str(e)}
      if org is None:
        return {"error": f"organization not found: {data['ein']}"}
      return org

    @self.post('/favorite', permission='org:write')
    def set_favorite(query_params: dict, body: Any, headers: HTTPMessage):
      data, err = self._require_fields(body, 'ein', 'is_favorite')
      if err:
        return err
      raw = data['is_favorite']
      is_favorite = raw if isinstance(raw, bool) else str(raw).strip().lower() in ('1', 'true', 'yes')
      if not self.db.orgs.set_favorite(data['ein'], is_favorite, actor=self._principal(headers)):
        return {"error": f"organization not found: {data['ein']}"}
      return self.db.orgs.get_organization(data['ein'])
