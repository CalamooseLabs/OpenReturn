import sqlite3
from typing import Any
from http.client import HTTPMessage

from router import Router
from database.Score import ScoreDatabase


def _qp(query_params: dict, key: str) -> str | None:
    return query_params.get(key, [None])[0]


def _require_fields(body: Any, *keys: str) -> tuple[dict | None, dict | None]:
    if not isinstance(body, dict):
        return None, {"error": "JSON body required"}
    missing = [k for k in keys if k not in body]
    if missing:
        return None, {"error": f"missing required fields: {missing}"}
    return body, None


class ScoreRouter(Router):
  def __init__(self, prefix: str = '/scores', db: ScoreDatabase = None) -> None:
    super().__init__(prefix)
    self.db = db
    self._register_routes()

  def _register_routes(self):

    # --- Model / Factors ---

    @self.get('/factors')
    def get_factors(query_params: dict, body: Any, headers: HTTPMessage):
      raw = _qp(query_params, 'version')
      version = int(raw) if raw and raw.isdigit() else 1
      return {"model_version": version, "factors": self.db.get_factors(version)}

    # --- Scores ---

    @self.get('')
    def list_scores(query_params: dict, body: Any, headers: HTTPMessage):
      ein = _qp(query_params, 'ein')
      if not ein:
        return {"error": "missing query param: ein"}
      return {"ein": ein, "scores": self.db.list_scores(ein)}

    @self.get('/detail')
    def get_score(query_params: dict, body: Any, headers: HTTPMessage):
      raw = _qp(query_params, 'score_id')
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
      data, err = _require_fields(body, 'ein')
      if err:
        return err
      model_version = int(data.get('model_version', 1))
      try:
        score_id = self.db.create_score(data['ein'], model_version)
      except ValueError as e:
        return {"error": str(e)}
      except sqlite3.IntegrityError as e:
        return {"error": str(e)}
      return {"score_id": score_id, "ein": data['ein'], "model_version": model_version}

    @self.post('/factors')
    def store_factor_values(query_params: dict, body: Any, headers: HTTPMessage):
      """
      Body: {score_id: int, values: [{factor_id, raw_value, weighted_value}, ...]}
      """
      data, err = _require_fields(body, 'score_id', 'values')
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
      data, err = _require_fields(body, 'score_id', 'total_score')
      if err:
        return err
      try:
        score_id = int(data['score_id'])
        total_score = float(data['total_score'])
        self.db.finalize_score(score_id, total_score)
      except ValueError as e:
        return {"error": str(e)}
      return {"score_id": score_id, "total_score": total_score}
