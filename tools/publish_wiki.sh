#!/usr/bin/env bash
# Build the wiki from docs/ and publish it to a GitHub wiki repository.
#
#   tools/publish_wiki.sh git@github.com:OWNER/REPO.wiki.git
#
# The wiki is a separate git repo (enable Wikis in the repo settings and create
# the first page once so the repo exists). This regenerates every page from the
# canonical docs/, so docs/ remains the single source of truth.
set -euo pipefail

REMOTE="${1:?usage: tools/publish_wiki.sh <wiki-repo-url>}"
ROOT="$(git -C "$(dirname "$0")" rev-parse --show-toplevel)"

build="$(mktemp -d)"
python3 "$ROOT/tools/build_wiki.py" --out "$build"

clone="$(mktemp -d)"
git clone "$REMOTE" "$clone"

# Replace the wiki's markdown with the freshly generated pages.
rm -f "$clone"/*.md
cp "$build"/*.md "$clone"/

cd "$clone"
git add -A
if git diff --cached --quiet; then
  echo "Wiki already up to date."
  exit 0
fi
git commit -m "Sync wiki from docs/"
git push
echo "Published $(ls "$build"/*.md | wc -l) pages to $REMOTE"
