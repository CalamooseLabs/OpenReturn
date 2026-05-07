#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3

from pprint import pprint
import sys

from src.parser.IRS990 import IRS990Parser
from unzipper import Unzipper
from database import Database

def main() -> int:
  UZ = Unzipper(sys.argv[1])
  db = Database()

  for f in UZ:
      t = IRS990Parser(f.read())
      pprint(t.extract())

  db.close()
  return 0;

if __name__ == '__main__':
  if (len(sys.argv) != 2):
    print("Please provide only one file.")
    sys.exit(1)
  sys.exit(main())
