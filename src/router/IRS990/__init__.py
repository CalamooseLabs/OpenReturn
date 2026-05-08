from router import Router

class IRS990Router(Router):
  def __init__(self, prefix: str = '') -> None:
    super().__init__(prefix)
    self._register_routes()

  def _register_routes(self):
    pass
