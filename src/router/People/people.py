from typing import Any
from http.client import HTTPMessage

from router import Router
from database import OpenReturnDB


class PeopleRouter(Router):
  """People CRUD and organization memberships. Reads require ``person:read``,
  mutations ``person:write``."""

  def __init__(self, prefix: str = '/people', db: OpenReturnDB = None,
               secure_by_default: bool = False) -> None:
    super().__init__(prefix, secure_by_default=secure_by_default)
    self.db = db
    self._register_routes()

  def _register_routes(self):

    @self.get('', permission='person:read')
    def list_people(query_params: dict, body: Any, headers: HTTPMessage):
      """List people. With ?ein=<EIN>, lists the people who belong to that org;
      otherwise a paged list (optional ?search=, ?limit=, ?offset=)."""
      ein = self._qp(query_params, 'ein')
      if ein:
        return {"ein": ein, "people": self.db.people.list_org_people(ein)}
      limit = self._qp_int(query_params, 'limit', default=50)
      offset = self._qp_int(query_params, 'offset', default=0)
      return self.db.people.list_people(self._qp(query_params, 'search'),
                                        limit=limit, offset=offset)

    @self.get('/detail', permission='person:read')
    def get_person(query_params: dict, body: Any, headers: HTTPMessage):
      pid, err = self._qp_int_or_error(query_params, 'person_id', field='person_id')
      if err:
        return err
      if pid is None:
        return {"error": "missing query param: person_id"}
      person = self.db.people.get_person(pid)
      return person if person is not None else {"error": f"person not found: {pid}"}

    @self.post('', permission='person:write')
    def create_person(query_params: dict, body: Any, headers: HTTPMessage):
      data, err = self._require_fields(body, 'full_name')
      if err:
        return err
      try:
        return self.db.people.create_person(
          data['full_name'], email=data.get('email'), phone=data.get('phone'),
          title=data.get('title'), notes=data.get('notes'),
          actor=self._principal(headers))
      except ValueError as e:
        return {"error": str(e)}

    @self.post('/edit', permission='person:write')
    def edit_person(query_params: dict, body: Any, headers: HTTPMessage):
      data, err = self._require_fields(body, 'person_id')
      if err:
        return err
      try:
        pid = int(data['person_id'])
      except (TypeError, ValueError):
        return {"error": "person_id must be an integer"}
      fields = {k: data[k] for k in ('full_name', 'email', 'phone', 'title', 'notes')
                if k in data}
      person = self.db.people.update_person(pid, fields, actor=self._principal(headers))
      return person if person is not None else {"error": f"person not found: {pid}"}

    @self.post('/delete', permission='person:write')
    def delete_person(query_params: dict, body: Any, headers: HTTPMessage):
      data, err = self._require_fields(body, 'person_id')
      if err:
        return err
      try:
        pid = int(data['person_id'])
      except (TypeError, ValueError):
        return {"error": "person_id must be an integer"}
      return {"deleted": self.db.people.delete_person(pid, actor=self._principal(headers))}

    @self.post('/membership', permission='person:write')
    def add_membership(query_params: dict, body: Any, headers: HTTPMessage):
      """Link a person to an organization. Body: {person_id, ein, role_title?,
      is_primary?, start_date?, end_date?}."""
      data, err = self._require_fields(body, 'person_id', 'ein')
      if err:
        return err
      try:
        pid = int(data['person_id'])
      except (TypeError, ValueError):
        return {"error": "person_id must be an integer"}
      try:
        return self.db.people.add_membership(
          pid, data['ein'], role_title=data.get('role_title'),
          is_primary=bool(data.get('is_primary', False)),
          start_date=data.get('start_date'), end_date=data.get('end_date'),
          actor=self._principal(headers))
      except ValueError as e:
        return {"error": str(e)}

    @self.post('/membership/remove', permission='person:write')
    def remove_membership(query_params: dict, body: Any, headers: HTTPMessage):
      data, err = self._require_fields(body, 'person_id', 'ein')
      if err:
        return err
      try:
        pid = int(data['person_id'])
      except (TypeError, ValueError):
        return {"error": "person_id must be an integer"}
      return {"removed": self.db.people.remove_membership(
        pid, data['ein'], actor=self._principal(headers))}
