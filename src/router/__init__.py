from typing import Callable

class Router:
  def __init__(self, template_dir = "", prefix: str = ''):
    self.prefix = prefix
    self.routes: dict[str, dict[str, Callable]] = {
      'GET': {},
      'POST': {}
    }
    self.template_dir = template_dir

  def route(self, path: str, method: str = 'GET'):
    def decorator(func: Callable):
      full_path = self.prefix + path
      self.routes[method.upper()][full_path] = func
      return func
    return decorator

  def get(self, path: str):
    return self.route(path, 'GET')

  def post(self, path: str):
    return self.route(path, 'POST')

  def render_template(self, filename: str, **kwargs) -> str:
    with open(f'{self.template_dir}/{filename}', 'r') as f:
      content = f.read()
    for key, value in kwargs.items():
      content = content.replace('{{' + key + '}}', str(value))
    return content
