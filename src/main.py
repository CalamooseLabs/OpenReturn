#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3

from database.Score import ScoreDatabase
from router.Upload import UploadRouter
from router.IRS990 import IRS990Router
from router.Score import ScoreRouter
from server import Server


def main() -> int:
    db = ScoreDatabase()

    app = Server()
    app.include_router(UploadRouter(db=db))
    app.include_router(IRS990Router(db=db))
    app.include_router(ScoreRouter(db=db))
    app.run()

    db.close()
    return 0


if __name__ == "__main__":
    import sys
    sys.exit(main())
