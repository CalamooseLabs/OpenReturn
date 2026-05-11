#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3

from pprint import pprint
import sys

from parser.IRS990 import IRS990Parser
from unzipper import Unzipper
from database.IRS990 import IRS990Database
from router.Upload import UploadRouter
from server import Server

def main() -> int:
  UZ = Unzipper(sys.argv[1])
  db = IRS990Database()
  xpath_index = db.get_xpath_index()

  for f in UZ:
      t = IRS990Parser(f.read())
      print()
      print()
      print(f"---{f.name()}---")
      for key in xpath_index:
        print(f"{key}: {t.getElem(key)}")

  db.close()

  # app = Server()

  # upload_router = UploadRouter()
  # app.include_router(upload_router)

  # app.run()

  return 0;

if __name__ == '__main__':
  # if (len(sys.argv) != 2):
  #   print("Please provide only one file.")
  #   sys.exit(1)
  sys.exit(main())
