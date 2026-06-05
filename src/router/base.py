from typing import Callable

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

  def render_template(self, filename: str, **kwargs) -> str:
    if filename not in self._template_cache:
      with open(f'{self.template_dir}/{filename}', 'r') as f:
        self._template_cache[filename] = f.read()
    content = self._template_cache[filename]
    for key, value in kwargs.items():
      content = content.replace('{{' + key + '}}', str(value))
    return content
