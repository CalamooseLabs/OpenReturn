#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3

from pprint import pprint
import sys

from parser.IRS990 import IRS990Parser
from unzipper import Unzipper
from database import Database
from router import Router, QueryParams, Body, Headers

def main() -> int:
  UZ = Unzipper(sys.argv[1])
  db = Database()

  for f in UZ:
      t = IRS990Parser(f.read())
      print(t.getElem("ReturnData/IRS990/ProgramServiceRevenueGrp/Desc"))
      print(t.getElem("ReturnData/IRS990/ProgramServiceRevenueGrp/Desc"))

  db.close()

  app = Router()

  @app.get('/')
  def home(query_params: QueryParams | None = None, body=None, headers=None):
    return "<h1>Welcome!</h1>"

  @app.get('/hello')
  def hello(query_params: QueryParams | None =None, body: Body | None =None, headers: Headers | None =None):
    name = query_params.get("name") if query_params is not None else "World"
    return f"<h1>Hello, {name}!</h1>"

  @app.get('/api/data')
  def get_data(query_params=None, body=None, headers=None):
    return {"message": "This is JSON data", "status": "success"}

  app.run()

  return 0;

if __name__ == '__main__':
  if (len(sys.argv) != 2):
    print("Please provide only one file.")
    sys.exit(1)
  sys.exit(main())
