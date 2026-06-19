from typing import Any
from http.client import HTTPMessage

from router import Router
from database import OpenReturnDB


class FinancialsRouter(Router):
  """The unified financial layer over HTTP. Reads (`data:read`) expose concepts,
  an org's observations, and conflicts; writes (`data:write`) record observations
  (manual / audited / re-grab) and choose the canonical value for a fact."""

  def __init__(self, prefix: str = '/financials', db: OpenReturnDB = None,
               secure_by_default: bool = False) -> None:
    super().__init__(prefix, secure_by_default=secure_by_default)
    self.db = db
    self._register_routes()

  def _register_routes(self):

    @self.get('/concepts', permission='data:read')
    def concepts(query_params: dict, body: Any, headers: HTTPMessage):
      """The canonical financial concepts (their codes are the scoring keys)."""
      return {"concepts": self.db.financials.list_concepts()}

    @self.get('/sources', permission='data:read')
    def sources(query_params: dict, body: Any, headers: HTTPMessage):
      return {"sources": self.db.financials.list_sources()}

    @self.get('', permission='data:read')
    def org_financials(query_params: dict, body: Any, headers: HTTPMessage):
      """All of an org's facts (every source's observations, with the canonical
      pick and a conflict flag). Optional ?year=."""
      ein = self._qp(query_params, 'ein')
      if not ein:
        return {"error": "missing query param: ein"}
      year, err = self._qp_int_or_error(query_params, 'year', field='year')
      if err:
        return err
      return self.db.financials.get_org_financials(ein, year)

    @self.get('/conflicts', permission='data:read')
    def conflicts(query_params: dict, body: Any, headers: HTTPMessage):
      """Facts where sources disagree and no choice has resolved them — the diff
      between e.g. a manually-entered 990 and the IRS one."""
      ein = self._qp(query_params, 'ein')
      if not ein:
        return {"error": "missing query param: ein"}
      return {"ein": ein, "conflicts": self.db.financials.conflicts(ein)}

    @self.get('/conflict-orgs', permission='data:read')
    def conflict_orgs(query_params: dict, body: Any, headers: HTTPMessage):
      """Corpus-wide conflicts inbox: orgs that currently have ≥1 unresolved
      conflict, each with its conflict count, paginated (limit capped at 200)."""
      limit, err = self._qp_int_or_error(query_params, 'limit', default=50, field='limit')
      if err:
        return err
      offset, err = self._qp_int_or_error(query_params, 'offset', default=0, field='offset')
      if err:
        return err
      return self.db.financials.orgs_with_conflicts(limit, offset)

    @self.post('/observations', permission='data:write')
    def record(query_params: dict, body: Any, headers: HTTPMessage):
      """Record a source's values for an org-year. Body: {ein, fiscal_year,
      source, values:{concept:number}, confidence?, note?}. Creates a document +
      observations; a fact with no canonical yet is set canonical automatically,
      and disagreements are surfaced as conflicts for manual resolution."""
      data, err = self._require_fields(body, 'ein', 'fiscal_year', 'source', 'values')
      if err:
        return err
      if not isinstance(data['values'], dict):
        return {"error": "values must be an object mapping concept_code → number"}
      try:
        year = int(data['fiscal_year'])
      except (TypeError, ValueError):
        return {"error": "fiscal_year must be an integer"}
      try:
        return self.db.financials.record_observations(
          data['ein'], year, data['source'], data['values'],
          confidence=data.get('confidence'), kind=data.get('kind'),
          filename=data.get('filename'), note=data.get('note'),
          actor=self._principal(headers))
      except ValueError as e:
        return {"error": str(e)}

    @self.post('/canonical', permission='data:write')
    def choose_canonical(query_params: dict, body: Any, headers: HTTPMessage):
      """Choose which observation is canonical for a fact. Body:
      {ein, fiscal_year, concept, observation_id}."""
      data, err = self._require_fields(body, 'ein', 'fiscal_year', 'concept', 'observation_id')
      if err:
        return err
      try:
        year = int(data['fiscal_year'])
        obs_id = int(data['observation_id'])
      except (TypeError, ValueError):
        return {"error": "fiscal_year and observation_id must be integers"}
      ok = self.db.financials.set_canonical(data['ein'], year, data['concept'], obs_id,
                                            actor=self._principal(headers))
      if not ok:
        return {"error": "observation not found for that org/year/concept"}
      return self.db.financials.get_org_financials(data['ein'], year)

    @self.post('/value', permission='data:write')
    def edit_value(query_params: dict, body: Any, headers: HTTPMessage):
      """Hand-edit a fact's value and make it canonical. Body:
      {ein, fiscal_year, concept, value, note?}. A non-manual fact mints a new
      manual observation (originals kept); a manual fact is updated in place.
      Scores go stale → the result flags recompute_needed."""
      data, err = self._require_fields(body, 'ein', 'fiscal_year', 'concept', 'value')
      if err:
        return err
      try:
        year = int(data['fiscal_year'])
      except (TypeError, ValueError):
        return {"error": "fiscal_year must be an integer"}
      try:
        return self.db.financials.edit_value(
          data['ein'], year, data['concept'], data['value'],
          note=data.get('note'), actor=self._principal(headers))
      except ValueError as e:
        return {"error": str(e)}
