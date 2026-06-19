from typing import Any
from http.client import HTTPMessage

from router import Router
from database import OpenReturnDB


class NoteRouter(Router):
  """Shared, team-wide organization notes / updates. ``GET /notes?ein=`` requires
  ``note:read``; posting and removing require ``note:write``. Notes are not
  per-user — everyone sees the same feed, and each note records its author."""

  def __init__(self, prefix: str = '/notes', db: OpenReturnDB = None,
               secure_by_default: bool = False) -> None:
    super().__init__(prefix, secure_by_default=secure_by_default)
    self.db = db
    self._register_routes()

  def _register_routes(self):

    @self.get('', permission='note:read')
    def list_notes(query_params: dict, body: Any, headers: HTTPMessage):
      """An org's notes/updates, newest first (param: ein)."""
      ein = self._qp(query_params, 'ein')
      if not ein:
        return {"error": "missing query param: ein"}
      return {"ein": ein, "notes": self.db.notes.list_notes(ein)}

    @self.post('', permission='note:write')
    def add_note(query_params: dict, body: Any, headers: HTTPMessage):
      data, err = self._require_fields(body, 'ein', 'body')
      if err:
        return err
      try:
        return self.db.notes.add_note(data['ein'], data['body'], actor=self._principal(headers))
      except ValueError as e:
        return {"error": str(e)}

    @self.post('/delete', permission='note:write')
    def delete_note(query_params: dict, body: Any, headers: HTTPMessage):
      data, err = self._require_fields(body, 'note_id')
      if err:
        return err
      try:
        note_id = int(data['note_id'])
      except (ValueError, TypeError):
        return {"error": "note_id must be an integer"}
      return {"note_id": note_id,
              "removed": self.db.notes.delete_note(note_id, actor=self._principal(headers))}
