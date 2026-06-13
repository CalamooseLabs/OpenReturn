#!/usr/bin/env python3
"""Generate a GitHub-wiki tree from the canonical ``docs/`` directory.

``docs/`` stays the single source of truth (the code, CLAUDE.md, and the
doc-update workflow all reference ``docs/<path>.md``). This script renders those
pages into the flat, page-named layout a GitHub wiki expects:

- each doc becomes ``<Page-Name>.md`` (e.g. ``Installation-and-Setup.md``),
- ``docs/index.md`` becomes ``Home.md`` (the wiki landing page),
- relative inter-doc links (``install.md#x``, ``../api.md``) are rewritten to
  wiki page links (``Installation-and-Setup#x``, ``API-Reference``),
- a ``_Sidebar.md`` (navigation) and ``_Footer.md`` are generated.

Mermaid code fences pass through untouched (GitHub renders mermaid in wikis).
Publish with ``tools/publish_wiki.sh <wiki-repo-url>``.
"""

import argparse
import os
import re
from pathlib import Path

# doc path (relative to docs/) → (wiki page name, human title)
PAGES: dict[str, tuple[str, str]] = {
    "index.md":                    ("Home", "OpenReturn"),
    "install.md":                  ("Installation-and-Setup", "Installation & Setup"),
    "ingest.md":                   ("Ingest-and-Upload", "Ingest & Upload"),
    "scoring/models.md":           ("Scoring-Models", "Scoring Models"),
    "api.md":                      ("API-Reference", "API Reference"),
    "api-keys.md":                 ("API-Keys", "API Keys"),
    "nixos.md":                    ("NixOS-Module", "NixOS Module"),
    "development/architecture.md": ("Architecture", "Architecture"),
    "development/testing.md":      ("Testing", "Testing"),
}

# Sidebar groups → ordered doc paths
SIDEBAR: list[tuple[str, list[str]]] = [
    ("Getting started", ["index.md", "install.md"]),
    ("Guides", ["ingest.md", "scoring/models.md", "api.md", "api-keys.md"]),
    ("Operations", ["nixos.md"]),
    ("Development", ["development/architecture.md", "development/testing.md"]),
]

_LINK_RE = re.compile(r"\[([^\]]*)\]\(([^)]+)\)")


def _rewrite_target(target: str, doc_relpath: str) -> str:
    """Map a link target found in ``doc_relpath`` to a wiki target."""
    if target.startswith(("http://", "https://", "mailto:", "#")):
        return target
    path, sep, anchor = target.partition("#")
    if not path.endswith(".md"):
        return target
    base = os.path.dirname(doc_relpath)
    resolved = os.path.normpath(os.path.join(base, path) if base else path).replace(os.sep, "/")
    page = PAGES.get(resolved)
    if not page:
        return target  # unknown doc — leave untouched
    return f"{page[0]}#{anchor}" if anchor else page[0]


def _convert(text: str, doc_relpath: str) -> str:
    """Rewrite inter-doc links to wiki links, skipping fenced code blocks."""
    out: list[str] = []
    in_fence = False
    for line in text.splitlines(keepends=True):
        if line.lstrip().startswith("```"):
            in_fence = not in_fence
            out.append(line)
            continue
        if in_fence:
            out.append(line)
            continue
        out.append(_LINK_RE.sub(
            lambda m: f"[{m.group(1)}]({_rewrite_target(m.group(2), doc_relpath)})", line))
    return "".join(out)


def _sidebar() -> str:
    lines = ["### OpenReturn", ""]
    for group, docs in SIDEBAR:
        lines.append(f"**{group}**")
        lines.append("")
        for relpath in docs:
            name, title = PAGES[relpath]
            lines.append(f"- [{title}]({name})")
        lines.append("")
    return "\n".join(lines).rstrip() + "\n"


def build_wiki(docs_dir: str = "docs") -> dict[str, str]:
    """Return {wiki_filename: content} for the whole wiki (no disk writes)."""
    docs = Path(docs_dir)
    pages: dict[str, str] = {}
    for relpath, (name, _title) in PAGES.items():
        src = docs / relpath
        if not src.exists():  # pragma: no cover — a doc was renamed
            raise FileNotFoundError(f"missing doc: {src}")
        pages[f"{name}.md"] = _convert(src.read_text(), relpath)
    pages["_Sidebar.md"] = _sidebar()
    pages["_Footer.md"] = (
        "_Generated from `docs/` in the main repository — edit the docs there and "
        "re-run `tools/build_wiki.py`, don't edit wiki pages directly._\n"
    )
    return pages


def write_wiki(out_dir: str, docs_dir: str = "docs") -> int:
    out = Path(out_dir)
    out.mkdir(parents=True, exist_ok=True)
    pages = build_wiki(docs_dir)
    for filename, content in pages.items():
        (out / filename).write_text(content)
    return len(pages)


def main() -> int:  # pragma: no cover — thin CLI wrapper
    ap = argparse.ArgumentParser(
        prog="build_wiki", description="Generate a GitHub-wiki tree from docs/")
    here = Path(__file__).resolve().parent.parent
    ap.add_argument("--docs", default=str(here / "docs"), help="Path to the docs/ directory")
    ap.add_argument("--out", default=str(here / "wiki"), help="Output directory for wiki pages")
    args = ap.parse_args()
    n = write_wiki(args.out, args.docs)
    print(f"Wrote {n} wiki page(s) to {args.out}")
    return 0


if __name__ == "__main__":  # pragma: no cover
    import sys
    sys.exit(main())
