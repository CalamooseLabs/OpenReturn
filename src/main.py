#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3
import sys

from unzipper import Unzipper
from parser import Parser

def main() -> int:
  UZ = Unzipper(sys.argv[1])

  for f in UZ:
    p = Parser(f.read(), {'irs': 'http://www.irs.gov/efile'}, "/irs:")
    print(p.getElem("Filer/EIN"))

  return 0;

if __name__ == '__main__':
  if (len(sys.argv) != 2):
    print("Please provide only one file.")
    sys.exit(1)
  sys.exit(main())
