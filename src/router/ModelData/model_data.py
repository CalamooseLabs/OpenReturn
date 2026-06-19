from typing import Any
from http.client import HTTPMessage

from router import Router
from database import OpenReturnDB


class ModelDataRouter(Router):
  """Per-(org, model, year) annotations: free-form notes + custom data fields.
  ``GET /model-data?ein=&version=&year=`` requires ``model_data:read``; the
  add/remove routes require ``model_data:write``."""

  def __init__(self, prefix: str = '/model-data', db: OpenReturnDB = None,
               secure_by_default: bool = False) -> None:
    super().__init__(prefix, secure_by_default=secure_by_default)
    self.db = db
    self._register_routes()

  def _register_routes(self):

    @self.get('', permission='model_data:read')
    def get_model_data(query_params: dict, body: Any, headers: HTTPMessage):
      """Notes + custom fields for one org/model/year (params: ein, version, year)."""
      ein = self._qp(query_params, 'ein')
      version = self._qp(query_params, 'version')
      year, err = self._qp_int_or_error(query_params, 'year', field='year')
      if err:  # present but non-integer → the specific message
        return err
      if not ein or not version or year is None:
        return {"error": "ein, version, and year are required"}
      try:
        return self.db.model_data.get(ein, version, year)
      except ValueError as e:
        return {"error": str(e)}

    @self.post('/note', permission='model_data:write')
    def add_note(query_params: dict, body: Any, headers: HTTPMessage):
      data, err = self._require_fields(body, 'ein', 'version', 'year', 'body')
      if err:
        return err
      try:
        return self.db.model_data.add_note(
          data['ein'], data['version'], data['year'], data['body'],
          actor=self._principal(headers))
      except ValueError as e:
        return {"error": str(e)}

    @self.post('/note/delete', permission='model_data:write')
    def delete_note(query_params: dict, body: Any, headers: HTTPMessage):
      data, err = self._require_fields(body, 'note_id')
      if err:
        return err
      try:
        note_id = int(data['note_id'])
      except (ValueError, TypeError):
        return {"error": "note_id must be an integer"}
      return {"note_id": note_id,
              "removed": self.db.model_data.delete_note(note_id, actor=self._principal(headers))}

    @self.post('/field', permission='model_data:write')
    def add_field(query_params: dict, body: Any, headers: HTTPMessage):
      data, err = self._require_fields(body, 'ein', 'version', 'year', 'label')
      if err:
        return err
      try:
        return self.db.model_data.add_field(
          data['ein'], data['version'], data['year'], data['label'], data.get('value'),
          actor=self._principal(headers))
      except ValueError as e:
        return {"error": str(e)}

    @self.post('/field/delete', permission='model_data:write')
    def delete_field(query_params: dict, body: Any, headers: HTTPMessage):
      data, err = self._require_fields(body, 'field_id')
      if err:
        return err
      try:
        field_id = int(data['field_id'])
      except (ValueError, TypeError):
        return {"error": "field_id must be an integer"}
      return {"field_id": field_id,
              "removed": self.db.model_data.delete_field(field_id, actor=self._principal(headers))}
