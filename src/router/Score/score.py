import sqlite3
from typing import Any
from http.client import HTTPMessage

from router import Router
from database.Score import ScoreDatabase
from scoring import ScoringEngine


class ScoreRouter(Router):
  def __init__(self, prefix: str = '/scores', db: ScoreDatabase = None, secure_by_default: bool = False) -> None:
    super().__init__(prefix, secure_by_default=secure_by_default)
    self.db = db
    self.engine = ScoringEngine(db)
    self._register_routes()

  def _register_routes(self):

    # --- Model / Factors ---

    @self.get('/factors')
    def get_factors(query_params: dict, body: Any, headers: HTTPMessage):
      raw = self._qp(query_params, 'version')
      version = int(raw) if raw and raw.isdigit() else 1
      return {"model_version": version, "factors": self.db.get_factors(version)}

    # --- Scores ---

    @self.get('')
    def list_scores(query_params: dict, body: Any, headers: HTTPMessage):
      ein = self._qp(query_params, 'ein')
      if not ein:
        return {"error": "missing query param: ein"}
      return {"ein": ein, "scores": self.db.list_scores(ein)}

    @self.get('/filing')
    def get_score_by_filing(query_params: dict, body: Any, headers: HTTPMessage):
      filing_id = self._qp(query_params, 'filing_id')
      if not filing_id:
        return {"error": "missing query param: filing_id"}
      score = self.db.get_score_by_filing(filing_id)
      if score is None:
        return {"error": f"no score found for filing: {filing_id}"}
      return score

    @self.get('/detail')
    def get_score(query_params: dict, body: Any, headers: HTTPMessage):
      raw = self._qp(query_params, 'score_id')
      if not raw:
        return {"error": "missing query param: score_id"}
      try:
        score_id = int(raw)
      except ValueError:
        return {"error": "score_id must be an integer"}
      score = self.db.get_score(score_id)
      if score is None:
        return {"error": f"score not found: {score_id}"}
      return score

    @self.post('')
    def create_score(query_params: dict, body: Any, headers: HTTPMessage):
      data, err = self._require_fields(body, 'filing_id')
      if err:
        return err
      model_version = int(data.get('model_version', 1))
      try:
        score_id = self.db.create_score(data['filing_id'], model_version)
      except ValueError as e:
        return {"error": str(e)}
      except sqlite3.IntegrityError as e:
        return {"error": str(e)}
      return {"score_id": score_id, "filing_id": data['filing_id'], "model_version": model_version}

    @self.post('/factors')
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
        self.db.store_factor_values(score_id, values)
      except (sqlite3.IntegrityError, ValueError) as e:
        return {"error": str(e)}
      return {"score_id": score_id, "factors_stored": len(values)}

    @self.post('/finalize')
    def finalize_score(query_params: dict, body: Any, headers: HTTPMessage):
      data, err = self._require_fields(body, 'score_id', 'total_score')
      if err:
        return err
      try:
        score_id = int(data['score_id'])
        total_score = float(data['total_score'])
        self.db.finalize_score(score_id, total_score)
      except ValueError as e:
        return {"error": str(e)}
      return {"score_id": score_id, "total_score": total_score}

    @self.post('/calculate')
    def calculate_score(query_params: dict, body: Any, headers: HTTPMessage):
      data, err = self._require_fields(body, 'ein', 'year')
      if err:
        return err
      try:
        year = int(data['year'])
        model_version = int(data.get('model_version', 1))
        result = self.engine.calculate(data['ein'], year, model_version)
      except ValueError as e:
        return {"error": str(e)}
      except sqlite3.IntegrityError as e:
        return {"error": str(e)}
      return result

    @self.get('/lookup')
    def lookup_score(query_params: dict, body: Any, headers: HTTPMessage):
      ein  = self._qp(query_params, 'ein')
      year = self._qp(query_params, 'year')
      if not ein or not year:
        return {"error": "missing query params: ein, year"}
      try:
        year_int = int(year)
      except ValueError:
        return {"error": "year must be an integer"}
      score = self.db.get_score_by_ein_year(ein, year_int)
      if score is None:
        return {"error": f"no score found for EIN {ein} year {year}"}
      return score
