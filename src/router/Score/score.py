import math
import sqlite3
from typing import Any
from http.client import HTTPMessage

from router import Router
from database import OpenReturnDB
from scoring import ScoringEngine


class ScoreRouter(Router):
  def __init__(self, prefix: str = '/scores', db: OpenReturnDB = None, secure_by_default: bool = False) -> None:
    super().__init__(prefix, secure_by_default=secure_by_default)
    self.db = db
    self.engine = ScoringEngine(db)
    self._register_routes()

  def _register_routes(self):

    # --- Model / Factors ---

    @self.get('/factors', permission='score:read')
    def get_factors(query_params: dict, body: Any, headers: HTTPMessage):
      version = self._qp(query_params, 'version') or '1'
      model = self.db.scores.get_model(version)
      return {
        "model_version": version,
        "model_type": model.get("model_type") if model else None,
        "scoring_mode": model.get("scoring_mode") if model else "computed",
        "model_kind": model.get("model_kind") if model else "model",
        "factors": self.db.scores.get_factors(version),
      }

    @self.get('/types', permission='score:read')
    def list_model_types(query_params: dict, body: Any, headers: HTTPMessage):
      """The available model categories (financial, governance, …)."""
      return {"types": self.db.scores.list_model_types()}

    @self.get('/kinds', permission='score:read')
    def list_model_kinds(query_params: dict, body: Any, headers: HTTPMessage):
      """The available model kinds (model, composite, super_composite)."""
      return {"kinds": self.db.scores.list_model_kinds()}

    # --- Manual (graded) scoring ---

    @self.post('/grade', permission='score:write')
    def grade_factor(query_params: dict, body: Any, headers: HTTPMessage):
      """Record a grader's value + comment for one factor of a *manual* model and
      return the updated score. Body: {score_id, factor_id, value, comment?}."""
      data, err = self._require_fields(body, 'score_id', 'factor_id', 'value')
      if err:
        return err
      try:
        score_id = int(data['score_id'])
        factor_id = int(data['factor_id'])
        value = float(data['value'])
      except (TypeError, ValueError):
        return {"error": "score_id and factor_id must be integers, value a number"}
      if not math.isfinite(value):  # reject JSON Infinity / NaN
        return {"error": "value must be a finite number"}
      comment = data.get('comment')
      try:
        return self.engine.grade(score_id, factor_id, value, comment)
      except ValueError as e:
        return {"error": str(e)}

    # --- Scores ---

    @self.get('', permission='score:read')
    def list_scores(query_params: dict, body: Any, headers: HTTPMessage):
      ein = self._qp(query_params, 'ein')
      if not ein:
        return {"error": "missing query param: ein"}
      return {"ein": ein, "scores": self.db.scores.list_scores(ein)}

    @self.get('/history', permission='score:read')
    def score_history(query_params: dict, body: Any, headers: HTTPMessage):
      """One model's full year-by-year score series for an org (oldest→newest),
      with each year flagged ``imputed`` and carrying the donor ``source_year`` of
      any filled factors — the multi-year history view. ``version`` defaults to 1."""
      ein = self._qp(query_params, 'ein')
      if not ein:
        return {"error": "missing query param: ein"}
      version = self._qp(query_params, 'version') or '1'
      return {"ein": ein, "model_version": version,
              "history": self.db.scores.list_score_history(ein, version)}

    @self.get('/leaderboard', permission='score:read')
    def leaderboard(query_params: dict, body: Any, headers: HTTPMessage):
      """Rank orgs by a model's latest scored total (or ``year=``), globally or within
      a subset: ``sector`` (NTEE code), ``state`` (2-letter), ``city``, ``county``
      (FIPS), ``list`` (list_id), ``type`` (org_type), ``grantmaker`` (1/0). ``model``
      = model version (default 1). Paginated (``limit``/``offset``)."""
      model = self._qp(query_params, 'model') or '1'
      year, e2 = self._qp_int_or_error(query_params, 'year', default=None, field='year')
      if e2:
        return e2
      limit, e3 = self._qp_int_or_error(query_params, 'limit', default=50, field='limit')
      offset, e4 = self._qp_int_or_error(query_params, 'offset', default=0, field='offset')
      if e3 or e4:
        return e3 or e4
      list_id, e5 = self._qp_int_or_error(query_params, 'list', default=None, field='list')
      if e5:
        return e5
      gm = self._qp(query_params, 'grantmaker')
      return self.db.scores.rank_leaderboard(
        model, year=year, limit=limit, offset=offset,
        sector=self._qp(query_params, 'sector'), state=self._qp(query_params, 'state'),
        city=self._qp(query_params, 'city'), county=self._qp(query_params, 'county'),
        org_type=self._qp(query_params, 'type'), list_id=list_id,
        grantmaker=None if gm is None else gm.strip().lower() in ('1', 'true', 'yes'))

    @self.get('/ranking', permission='score:read')
    def ranking(query_params: dict, body: Any, headers: HTTPMessage):
      """An org's rank for a model in global + its own sector/state/city/county.
      ``ein`` required; ``model`` (version, default 1); optional ``year``."""
      ein = self._qp(query_params, 'ein')
      if not ein:
        return {"error": "missing query param: ein"}
      model = self._qp(query_params, 'model') or '1'
      year, e2 = self._qp_int_or_error(query_params, 'year', default=None, field='year')
      if e2:
        return e2
      result = self.db.scores.rank_org_dimensions(ein, model, year=year)
      if result is None:
        return {"error": f"organization not found: {ein}"}
      return result

    @self.get('/filing', permission='score:read')
    def get_score_by_filing(query_params: dict, body: Any, headers: HTTPMessage):
      filing_id = self._qp(query_params, 'filing_id')
      if not filing_id:
        return {"error": "missing query param: filing_id"}
      score = self.db.scores.get_score_by_filing(filing_id)
      if score is None:
        return {"error": f"no score found for filing: {filing_id}"}
      return score

    @self.get('/detail', permission='score:read')
    def get_score(query_params: dict, body: Any, headers: HTTPMessage):
      if not self._qp(query_params, 'score_id'):
        return {"error": "missing query param: score_id"}
      score_id, err = self._qp_int_or_error(query_params, 'score_id')
      if err:
        return err
      score = self.db.scores.get_score(score_id)
      if score is None:
        return {"error": f"score not found: {score_id}"}
      return score

    @self.post('', permission='score:write')
    def create_score(query_params: dict, body: Any, headers: HTTPMessage):
      data, err = self._require_fields(body, 'filing_id')
      if err:
        return err
      try:
        model_version = str(data.get('model_version', '1'))
        # This endpoint anchors MANUAL grades — refuse a computed model (and
        # find-or-create so re-grading reuses the row instead of UNIQUE-erroring).
        score_id = self.db.scores.create_score(data['filing_id'], model_version, manual_only=True)
      except ValueError as e:
        return {"error": str(e)}
      except sqlite3.IntegrityError as e:
        return {"error": str(e)}
      return {"score_id": score_id, "filing_id": data['filing_id'], "model_version": model_version}

    @self.post('/factors', permission='score:write')
    def store_factor_values(query_params: dict, body: Any, headers: HTTPMessage):
      """
      Body: {score_id: int, values: [{factor_id, raw_value, weighted_value}, ...]}
      """
      data, err = self._require_fields(body, 'score_id', 'values')
      if err:
        return err
      if not isinstance(data['values'], list):
        return {"error": "values must be a list of {factor_id, raw_value, weighted_value} objects"}
      try:
        score_id = int(data['score_id'])
        values: dict[int, tuple[float, float]] = {}
        for item in data['values']:
          if 'factor_id' not in item:
            return {"error": "each value entry must have factor_id"}
          fid = int(item['factor_id'])
          raw = item.get('raw_value')
          weighted = item.get('weighted_value')
          values[fid] = (raw, weighted)
        self.db.scores.store_factor_values(score_id, values)
      except (sqlite3.IntegrityError, ValueError) as e:
        return {"error": str(e)}
      return {"score_id": score_id, "factors_stored": len(values)}

    @self.post('/finalize', permission='score:write')
    def finalize_score(query_params: dict, body: Any, headers: HTTPMessage):
      data, err = self._require_fields(body, 'score_id', 'total_score')
      if err:
        return err
      try:
        score_id = int(data['score_id'])
        total_score = float(data['total_score'])
        self.db.scores.finalize_score(score_id, total_score)
      except ValueError as e:
        return {"error": str(e)}
      return {"score_id": score_id, "total_score": total_score}

    @self.post('/calculate', permission='score:write')
    def calculate_score(query_params: dict, body: Any, headers: HTTPMessage):
      data, err = self._require_fields(body, 'ein', 'year')
      if err:
        return err
      try:
        year = int(data['year'])
        model_version = str(data.get('model_version', '1'))
        result = self.engine.calculate(data['ein'], year, model_version)
      except ValueError as e:
        return {"error": str(e)}
      except sqlite3.IntegrityError as e:
        return {"error": str(e)}
      return result

    @self.get('/lookup', permission='score:read')
    def lookup_score(query_params: dict, body: Any, headers: HTTPMessage):
      ein  = self._qp(query_params, 'ein')
      year = self._qp(query_params, 'year')
      if not ein or not year:
        return {"error": "missing query params: ein, year"}
      year_int, err = self._qp_int_or_error(query_params, 'year', field='year')
      if err:
        return err
      score = self.db.scores.get_score_by_ein_year(ein, year_int)
      if score is None:
        return {"error": f"no score found for EIN {ein} year {year}"}
      return score

    @self.get('/debug', permission='score:read')
    def debug_score(query_params: dict, body: Any, headers: HTTPMessage):
      """Trace a model evaluation: per factor, the formula, the formula with this
      filing's numbers substituted in, every variable, and where each field input
      is grabbed from (form / part / section / line / xml_path). Read-only — does
      not persist a score. Accepts filing_id, or ein + year; version defaults 1."""
      version = self._qp(query_params, 'version') or '1'
      filing_id = self._qp(query_params, 'filing_id')
      if filing_id:
        filing = self.db.filings.get_filing(filing_id)
        if filing is None:
          return {"error": f"filing not found: {filing_id}"}
        ein, year = filing['ein'], filing['year']
      else:
        ein = self._qp(query_params, 'ein')
        if not ein:
          return {"error": "provide filing_id, or ein and year"}
        year, err = self._qp_int_or_error(query_params, 'year', field='year')
        if err:
          return err
        if year is None:
          return {"error": "missing query param: year"}
      try:
        return self.engine.debug(ein, year, version)
      except ValueError as e:
        return {"error": str(e)}

    @self.get('/compare', permission='score:read')
    def compare_scores(query_params: dict, body: Any, headers: HTTPMessage):
      ein  = self._qp(query_params, 'ein')
      year = self._qp(query_params, 'year')
      if not ein or not year:
        return {"error": "missing query params: ein, year"}
      year_int, err = self._qp_int_or_error(query_params, 'year', field='year')
      if err:
        return err
      scores = self.db.scores.compare_scores(ein, year_int)
      return {"ein": ein, "year": year_int, "scores": scores}
