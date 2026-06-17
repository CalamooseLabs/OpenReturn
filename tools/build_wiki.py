#!/usr/bin/env python3
"""Build GitHub-wiki-ready pages from the repo's ``docs/`` tree.

``docs/`` is the single source of truth and is written for GitHub's *repository*
view: a nested folder layout (``docs/scoring/``, ``docs/development/``) with
relative ``.md`` links that are clickable on github.com. A GitHub *wiki*, by
contrast, is a flat, single-namespace set of pages where:

* the page filename (hyphenated) *is* the page title, rendered above the body —
  so a leading ``# H1`` in the body is redundant;
* internal links are bare page slugs (``[text](Page-Slug)``) — a ``.md`` suffix
  or a ``subdir/page`` path does not resolve;
* navigation comes from a reserved ``_Sidebar.md`` / ``_Footer.md`` at the root.

This script bridges the two. It reads ``docs/``, then for each page:

* flattens it to a flat, uniquely-named wiki slug (``scoring/models.md`` ->
  ``Scoring-Models.md``; ``index.md`` -> ``Home.md``);
* rewrites relative ``.md`` links (including ``../`` and ``#anchors``) to the
  flat wiki slugs, dropping the ``.md`` suffix;
* repoints links that escape ``docs/`` (e.g. ``../openapi.json``) at an absolute
  GitHub blob URL;
* strips the redundant leading ``# H1``;
* normalises mermaid fences to the lowercase ``mermaid`` tag the wiki requires.

It also generates ``_Sidebar.md`` and ``_Footer.md`` from :data:`NAV`, and
**validates every internal link and ``#anchor``** — an unmapped page, a link to
a missing page, or a dangling anchor fails the build (non-zero exit). Every
``*.md`` under ``docs/`` must appear in :data:`NAV`, which is what stops a newly
added page from being silently dropped from the wiki.

Mermaid renders natively in github.com wikis, so diagrams are emitted as-is.

Usage::

    python3 tools/build_wiki.py --out <wiki-clone-dir> [--docs DIR] [--repo-url URL]
"""

from __future__ import annotations

import argparse
import posixpath
import re
import subprocess
import sys
from pathlib import Path

# Wiki navigation. Order here drives _Sidebar.md (top to bottom). Each page is
# (source path relative to docs/, flat wiki slug, sidebar label). The slug is the
# on-disk wiki filename without extension AND the URL segment after /wiki/; the
# wiki renders the slug (hyphens shown as spaces) as the page's title. Every *.md
# under docs/ MUST be listed here or the build aborts.
NAV: list[tuple[str, list[tuple[str, str, str]]]] = [
    ('Getting Started', [
        ('index.md',                    'Home',              'Home'),
        ('install.md',                  'Installation',      'Installation'),
    ]),
    ('Loading Data', [
        ('ingest.md',                   'Ingest-and-Upload', 'Ingest & Upload'),
    ]),
    ('HTTP API', [
        ('api.md',                      'API-Reference',     'API Reference'),
        ('frontend.md',                 'Frontend-Guide',    'Frontend Integration'),
        ('access-control.md',           'Access-Control',    'Access Control'),
        ('api-keys.md',                 'API-Keys',          'API Keys'),
        ('financials.md',               'Financial-Data',    'Financial Data'),
        ('foundations.md',              'Foundations',       'Foundations & Grants'),
        ('scoring/models.md',           'Scoring-Models',    'Scoring Models'),
    ]),
    ('Deployment', [
        ('nixos.md',                    'NixOS-Module',      'NixOS Module'),
    ]),
    ('Development', [
        ('development/architecture.md', 'Architecture',      'Architecture'),
        ('development/testing.md',      'Testing',           'Testing'),
    ]),
]

# Default GitHub ref for blob links to repo files (rename-proof — resolves to the
# default branch).
BLOB_REF = 'HEAD'

# Matches a markdown inline link: [text](target). Targets containing ')' are not
# used in these docs, so a non-greedy up-to-first-')' capture is sufficient. The
# captured target may carry a trailing title (`url "title"`), split off in repl().
_LINK_RE = re.compile(r'(?<!\!)\[([^\]]*)\]\(([^)]+)\)')
# Matches a reference-style link definition line: `[label]: target ["title"]`.
_LINK_DEF_RE = re.compile(r'^(\s{0,3}\[[^\]]+\]:\s*)(\S+)(.*)$')
# Matches a code-fence boundary (``` or ~~~), optionally indented.
_FENCE_RE = re.compile(r'^\s*(```+|~~~+)')
# Matches a mermaid fence with a non-canonical tag we should normalise.
_MERMAID_TAG_RE = re.compile(r'^(\s*```+)\s*(?:Mermaid|MERMAID|mmd)\s*$')


def slugify(text: str) -> str:
    """Slugify heading text the way GitHub-Flavored Markdown does.

    Lowercase, drop every character that is not a word char / space / hyphen,
    then turn spaces into hyphens. Critically this does *not* collapse runs of
    hyphens, so ``Pre-computing & storing`` -> ``pre-computing--storing`` (the
    removed ``&`` leaves two spaces -> two hyphens), matching github.com.
    """
    text = text.strip().lower()
    text = re.sub(r'[^\w \-]', '', text)
    return text.replace(' ', '-')


def heading_slugs(md_text: str) -> set[str]:
    """Return the set of in-page anchor slugs for every ATX heading.

    Headings inside fenced code blocks are ignored, and duplicate slugs get the
    GitHub ``-1`` / ``-2`` suffixes so the returned set matches real anchors.
    """
    slugs: set[str] = set()
    counts: dict[str, int] = {}
    in_fence = False
    for line in md_text.splitlines():
        if _FENCE_RE.match(line):
            in_fence = not in_fence
            continue
        if in_fence:
            continue
        m = re.match(r'^(#{1,6})\s+(.*?)\s*#*\s*$', line)
        if not m:
            continue
        base = slugify(m.group(2))
        n = counts.get(base, 0)
        slugs.add(base if n == 0 else f'{base}-{n}')
        counts[base] = n + 1
    return slugs


def strip_leading_h1(md_text: str) -> str:
    """Drop a leading ``# H1`` (and the blank line after it).

    The wiki renders the page filename as the title above the body, so the body
    H1 would be a duplicate. Only the first content line is touched, and only if
    it is an H1 — deeper headings and any later ``#`` lines are left alone.
    """
    lines = md_text.splitlines()
    i = 0
    while i < len(lines) and lines[i].strip() == '':
        i += 1
    if i < len(lines) and re.match(r'^#\s+\S', lines[i]):
        del lines[:i + 1]                  # drop any leading blanks + the H1
        if lines and lines[0].strip() == '':
            del lines[0]                   # and the blank line after it
    return '\n'.join(lines)


def _docs_rel(src_rel: str, target_path: str) -> str:
    """Resolve a link's path part against the linking page's directory.

    Returns a path relative to ``docs/`` (may start with ``../`` if it escapes
    the docs tree, e.g. a link to the repo-root ``openapi.json``).
    """
    src_dir = posixpath.dirname(src_rel)
    return posixpath.normpath(posixpath.join(src_dir, target_path))


def _resolve_target(
    raw: str,
    src_rel: str,
    page_map: dict[str, str],
    slug_anchors: dict[str, set[str]],
    repo_url: str,
    errors: list[str],
) -> tuple[str, bool]:
    """Resolve one link target to its wiki form. Returns (target, rewritten?).

    External/absolute/mail targets and bare same-page anchors are returned
    unchanged (anchors still validated). A docs page becomes its flat slug; a
    target escaping ``docs/`` becomes a GitHub blob URL. An unresolved ``.md``
    target is recorded in ``errors``.
    """
    this_slug = page_map[src_rel]
    target = raw.strip()

    if re.match(r'^[a-z][a-z0-9+.-]*:', target) or target.startswith('//'):
        return raw, False

    if target.startswith('#'):
        anchor = target[1:]
        if anchor and anchor not in slug_anchors.get(this_slug, set()):
            errors.append(
                f'{src_rel}: link to "{target}" has no matching heading on this page'
            )
        return raw, False

    path, _, anchor = target.partition('#')
    if not path:
        return raw, False

    resolved = _docs_rel(src_rel, path)

    if resolved in page_map:
        slug = page_map[resolved]
        if anchor and anchor not in slug_anchors.get(slug, set()):
            errors.append(
                f'{src_rel}: link to "{target}" has no matching heading on '
                f'page "{slug}"'
            )
        return (slug if not anchor else f'{slug}#{anchor}'), True

    if resolved.startswith('..'):
        repo_rel = re.sub(r'^(\.\./)+', '', resolved)
        blob = f'{repo_url}/blob/{BLOB_REF}/{repo_rel}'
        return (f'{blob}#{anchor}' if anchor else blob), True

    if path.endswith('.md'):
        errors.append(
            f'{src_rel}: link to "{target}" does not resolve to a known wiki page'
        )
    return raw, False


def rewrite_links(
    md_text: str,
    src_rel: str,
    page_map: dict[str, str],
    slug_anchors: dict[str, set[str]],
    repo_url: str,
    errors: list[str],
) -> tuple[str, int]:
    """Rewrite internal ``.md`` links to flat wiki slugs and validate them.

    Handles inline links ``[text](target ["title"])`` and reference-style
    definitions ``[label]: target ["title"]`` — both have their target resolved
    and validated; an optional title attribute is preserved. Records unresolved
    page targets and dangling ``#anchors`` in ``errors``. Fenced code blocks,
    external URLs, and bare same-page anchors are left as-is.
    """
    rewritten = 0

    def resolve(raw: str) -> str:
        nonlocal rewritten
        new, did = _resolve_target(
            raw, src_rel, page_map, slug_anchors, repo_url, errors)
        rewritten += did
        return new

    def repl(match: re.Match[str]) -> str:
        # Split an optional `url "title"` (markdown forbids spaces in the URL).
        url, _, title = match.group(2).strip().partition(' ')
        suffix = f' {title.strip()}' if title.strip() else ''
        return f'[{match.group(1)}]({resolve(url)}{suffix})'

    out_lines = []
    in_fence = False
    for line in md_text.splitlines():
        if _FENCE_RE.match(line):
            in_fence = not in_fence
            out_lines.append(line)
            continue
        if in_fence:
            out_lines.append(line)
            continue
        defn = _LINK_DEF_RE.match(line)
        if defn:
            out_lines.append(f'{defn.group(1)}{resolve(defn.group(2))}{defn.group(3)}')
        else:
            out_lines.append(_LINK_RE.sub(repl, line))
    return '\n'.join(out_lines), rewritten


def normalize_mermaid(md_text: str) -> str:
    """Rewrite ``Mermaid`` / ``mmd`` fence tags to the lowercase ``mermaid``.

    github.com only renders the literal lowercase tag; anything else falls
    through to a plain code block.
    """
    return '\n'.join(
        _MERMAID_TAG_RE.sub(r'\1mermaid', line) for line in md_text.splitlines()
    )


def render_sidebar(repo_url: str) -> str:
    lines = [f'### [OpenReturn]({repo_url})', '']
    for group, pages in NAV:
        lines.append(f'**{group}**')
        lines.append('')
        for _src, slug, label in pages:
            lines.append(f'- [{label}]({slug})')
        lines.append('')
    return '\n'.join(lines).rstrip() + '\n'


def render_footer(repo_url: str) -> str:
    return (
        '---\n\n'
        f'📖 [Documentation Home](Home) &nbsp;·&nbsp; '
        f'💻 [Source code]({repo_url}) &nbsp;·&nbsp; '
        f'🐛 [Report an issue]({repo_url}/issues)\n\n'
        f'<sub>This wiki is generated from '
        f'<a href="{repo_url}/tree/{BLOB_REF}/docs"><code>docs/</code></a> by '
        f'<code>publish-wiki</code> — edit the docs, not the wiki.</sub>\n'
    )


def _to_https(remote: str) -> str | None:
    """Convert a git remote URL to its ``https://HOST/OWNER/REPO`` web form.

    Handles scp-like (``git@host:owner/repo``), ``ssh://`` and ``http(s)://``
    remotes, dropping any userinfo, port, and ``.git`` suffix — the web URL is
    always ``https://HOST/OWNER/REPO`` (so a credential-bearing or ported remote
    never leaks into a published wiki page).
    """
    remote = remote.strip()
    patterns = (
        # scp-like: [ssh://]git@host[:port]:owner/repo(.git)
        r'^(?:ssh://)?git@([^:/]+)(?::\d+)?[:/](.+?)(?:\.git)?/?$',
        # ssh://[user@]host[:port]/owner/repo(.git)
        r'^ssh://(?:[^@/]+@)?([^:/]+)(?::\d+)?/(.+?)(?:\.git)?/?$',
        # http(s)://[user[:pass]@]host[:port]/owner/repo(.git)
        r'^https?://(?:[^@/]+@)?([^:/]+)(?::\d+)?/(.+?)(?:\.git)?/?$',
    )
    for pat in patterns:
        m = re.match(pat, remote)
        if m:
            return f'https://{m.group(1)}/{m.group(2)}'
    return None


def _git_remote_url(repo_root: Path) -> str | None:
    try:
        out = subprocess.run(
            ['git', '-C', str(repo_root), 'remote', 'get-url', 'origin'],
            capture_output=True, text=True, check=True,
        ).stdout.strip()
    except (OSError, subprocess.CalledProcessError):
        return None
    return _to_https(out)


def build(docs_dir: Path, out_dir: Path, repo_url: str) -> int:
    """Transform ``docs_dir`` into wiki pages under ``out_dir``. Returns exit code."""
    page_map = {src: slug for _g, pages in NAV for src, slug, _l in pages}

    # Every docs/*.md must be mapped — guards against silently dropping a page.
    found = sorted(
        str(p.relative_to(docs_dir).as_posix()) for p in docs_dir.rglob('*.md')
    )
    errors: list[str] = []
    for rel in found:
        if rel not in page_map:
            errors.append(
                f'{rel}: not listed in NAV (tools/build_wiki.py) — add it so it '
                f'is published to the wiki'
            )
    for rel in page_map:
        if not (docs_dir / rel).is_file():
            errors.append(f'{rel}: listed in NAV but missing under {docs_dir}')
    if errors:
        _report(errors)
        return 1

    # Transform body first (mermaid + H1 strip), THEN derive anchor slug sets
    # from the transformed text — so #anchor validation reflects the page as it
    # is actually published (the stripped H1 is no longer an anchor target).
    bodies = {
        rel: strip_leading_h1(normalize_mermaid((docs_dir / rel).read_text(encoding='utf-8')))
        for rel in page_map
    }
    slug_anchors = {page_map[rel]: heading_slugs(text) for rel, text in bodies.items()}

    # Rewrite links (validating page + anchor targets) and write each page.
    out_dir.mkdir(parents=True, exist_ok=True)
    total_links = 0
    for rel, text in bodies.items():
        text, n = rewrite_links(text, rel, page_map, slug_anchors, repo_url, errors)
        total_links += n
        dest = out_dir / f'{page_map[rel]}.md'
        dest.write_text(text.rstrip('\n') + '\n', encoding='utf-8')

    (out_dir / '_Sidebar.md').write_text(render_sidebar(repo_url), encoding='utf-8')
    (out_dir / '_Footer.md').write_text(render_footer(repo_url), encoding='utf-8')

    if errors:
        _report(errors)
        return 1

    print(
        f'Built {len(page_map)} pages + _Sidebar.md + _Footer.md '
        f'({total_links} internal links rewritten) into {out_dir}'
    )
    return 0


def _report(errors: list[str]) -> None:
    print('build_wiki: aborting — fix these first:', file=sys.stderr)
    for e in errors:
        print(f'  BROKEN: {e}', file=sys.stderr)


def main(argv: list[str] | None = None) -> int:
    repo_root = Path(__file__).resolve().parents[1]
    parser = argparse.ArgumentParser(description='Build GitHub wiki pages from docs/.')
    parser.add_argument('--out', required=True, help='output directory (wiki clone)')
    parser.add_argument('--docs', default=str(repo_root / 'docs'),
                        help='docs source directory (default: <repo>/docs)')
    parser.add_argument('--repo-url',
                        help='GitHub repo URL, e.g. https://github.com/OWNER/REPO '
                             '(default: derived from origin remote)')
    args = parser.parse_args(argv)

    docs_dir = Path(args.docs).resolve()
    if not docs_dir.is_dir():
        print(f'build_wiki: docs dir not found: {docs_dir}', file=sys.stderr)
        return 1

    repo_url = args.repo_url or _git_remote_url(repo_root)
    if not repo_url:
        print('build_wiki: could not determine repo URL — pass --repo-url',
              file=sys.stderr)
        return 1
    repo_url = repo_url.rstrip('/')

    return build(docs_dir, Path(args.out).resolve(), repo_url)


if __name__ == '__main__':
    raise SystemExit(main())
