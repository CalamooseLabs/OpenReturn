#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3

import sys

from parser.Form990 import Form990Parser
from unzipper import Unzipper
from parser import Parser
from database import Database



def main() -> int:
  UZ = Unzipper(sys.argv[1])
  db = Database()

  for f in UZ:
    t = Form990Parser(f.read())
    [_, smallTree] = t.dict()
    db.insert_record(smallTree)

  db.close()
  return 0;

if __name__ == '__main__':
  if (len(sys.argv) != 2):
    print("Please provide only one file.")
    sys.exit(1)
  sys.exit(main())
