from typing import Callable, Any


class Router:
  def __init__(self, prefix: str = '', template_dir: str = '', secure_by_default: bool = False):
    self.prefix = prefix
    self.secure_by_default = secure_by_default
    self.routes: dict[str, dict[str, Callable]] = {
      'GET': {},
      'POST': {}
    }
    self.template_dir = template_dir
    self._template_cache: dict[str, str] = {}
    self._fallback = None

  def route(self, path: str, method: str = 'GET', secured: bool | None = None):
    def decorator(func: Callable):
      full_path = self.prefix + path
      func._secured = secured if secured is not None else self.secure_by_default
      self.routes[method.upper()][full_path] = func
      return func
    return decorator

  def get(self, path: str, secured: bool | None = None):
    return self.route(path, 'GET', secured=secured)

  def post(self, path: str, secured: bool | None = None):
    return self.route(path, 'POST', secured=secured)

  @staticmethod
  def _qp(query_params: dict, key: str) -> str | None:
    return query_params.get(key, [None])[0]

  @staticmethod
  def _qp_int(query_params: dict, key: str, default: int | None = None) -> int | None:
    """Parse an int query param. Returns ``default`` if the param is absent or
    not a valid integer — never raises. Use for optional params with a fallback."""
    raw = query_params.get(key, [None])[0]
    if not raw:
      return default
    try:
      return int(raw)
    except ValueError:
      return default

  @staticmethod
  def _qp_int_or_error(query_params: dict, key: str, default: int | None = None,
                       field: str | None = None) -> tuple[int | None, dict | None]:
    """Parse an int query param. Returns ``(value, None)`` on success or absence
    (using ``default``), or ``(None, error_dict)`` if present but non-integer."""
    raw = query_params.get(key, [None])[0]
    if not raw:
      return default, None
    try:
      return int(raw), None
    except ValueError:
      return None, {"error": f"{field or key} must be an integer"}

  @staticmethod
  def _require_fields(body: Any, *keys: str) -> tuple[dict | None, dict | None]:
    if not isinstance(body, dict):
      return None, {"error": "JSON body required"}
    missing = [k for k in keys if k not in body]
    if missing:
      return None, {"error": f"missing required fields: {missing}"}
    return body, None

  def set_fallback(self, handler: Callable):
    self._fallback = handler
    return handler

  def render_template(self, filename: str, **kwargs) -> str:
    if filename not in self._template_cache:
      with open(f'{self.template_dir}/{filename}', 'r') as f:
        self._template_cache[filename] = f.read()
    content = self._template_cache[filename]
    for key, value in kwargs.items():
      content = content.replace('{{' + key + '}}', str(value))
    return content
