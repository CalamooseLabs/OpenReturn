from typing import Any
from http.client import HTTPMessage

from router import Router
from database import OpenReturnDB


class GivingRouter(Router):
  """Shared record of gifts the team gave to an org (hand-entered "giving data",
  distinct from the 990 grant graph). ``GET /giving?ein=`` requires ``giving:read``;
  recording and removing gifts require ``giving:write``."""

  def __init__(self, prefix: str = '/giving', db: OpenReturnDB = None,
               secure_by_default: bool = False) -> None:
    super().__init__(prefix, secure_by_default=secure_by_default)
    self.db = db
    self._register_routes()

  def _register_routes(self):

    @self.get('', permission='giving:read')
    def list_giving(query_params: dict, body: Any, headers: HTTPMessage):
      """An org's recorded gifts + a by-year summary (param: ein)."""
      ein = self._qp(query_params, 'ein')
      if not ein:
        return {"error": "missing query param: ein"}
      return self.db.giving.list_giving(ein)

    @self.post('', permission='giving:write')
    def add_gift(query_params: dict, body: Any, headers: HTTPMessage):
      """Record a gift. Body: {ein, amount, fiscal_year?, gift_date?, purpose?}."""
      data, err = self._require_fields(body, 'ein', 'amount')
      if err:
        return err
      try:
        return self.db.giving.add_gift(
          data['ein'], data['amount'],
          fiscal_year=data.get('fiscal_year'), gift_date=data.get('gift_date'),
          purpose=data.get('purpose'), actor=self._principal(headers))
      except ValueError as e:
        return {"error": str(e)}

    @self.post('/delete', permission='giving:write')
    def delete_gift(query_params: dict, body: Any, headers: HTTPMessage):
      data, err = self._require_fields(body, 'gift_id')
      if err:
        return err
      try:
        gift_id = int(data['gift_id'])
      except (ValueError, TypeError):
        return {"error": "gift_id must be an integer"}
      return {"gift_id": gift_id,
              "removed": self.db.giving.delete_gift(gift_id, actor=self._principal(headers))}
