"""Tests for tools/build_wiki.py — the docs/ → GitHub-wiki transformer.

Covers the GFM slugifier, leading-H1 stripping, mermaid-tag normalization,
remote-URL parsing, link rewriting/validation, and a full build of the real
docs/ tree (asserting it transforms with no broken links and no .md/path leaks),
plus the build's safety guards (unmapped page, missing page, broken link,
dangling anchor)."""

import contextlib
import io
import os
import re
import sys
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

_ROOT = os.path.join(os.path.dirname(__file__), '..')
_TOOLS = os.path.join(_ROOT, 'tools')
sys.path.insert(0, _TOOLS)

import build_wiki

_REPO = Path(_ROOT).resolve()
_REPO_URL = 'https://github.com/CalamooseLabs/OpenReturn'


def _silent_build(docs, out, repo_url=_REPO_URL):
    """Run build() with stderr suppressed; return the exit code."""
    with contextlib.redirect_stderr(io.StringIO()):
        return build_wiki.build(Path(docs), Path(out), repo_url)


class TestSlugify(unittest.TestCase):
    def test_known_headings(self):
        cases = {
            'Manual (Graded) Models': 'manual-graded-models',
            'GET /organizations/search': 'get-organizationssearch',
            '`GET /scores/debug`': 'get-scoresdebug',
            'Running ingest on the server': 'running-ingest-on-the-server',
            'Database Encryption': 'database-encryption',
        }
        for text, slug in cases.items():
            self.assertEqual(build_wiki.slugify(text), slug)

    def test_ampersand_leaves_double_hyphen(self):
        # GitHub drops the '&' but keeps both surrounding spaces -> two hyphens.
        self.assertEqual(
            build_wiki.slugify('Pre-computing & storing scores'),
            'pre-computing--storing-scores',
        )

    def test_long_punctuated_heading(self):
        self.assertEqual(
            build_wiki.slugify(
                'Historical formulas (1 field-key input; operate over all '
                'available filing years for the org)'
            ),
            'historical-formulas-1-field-key-input-operate-over-all-available-'
            'filing-years-for-the-org',
        )


class TestHeadingSlugs(unittest.TestCase):
    def test_skips_fenced_and_dedups(self):
        md = (
            '# Title\n\n## Dup\n\n```\n## Not A Heading\n```\n\n## Dup\n'
        )
        slugs = build_wiki.heading_slugs(md)
        self.assertIn('title', slugs)
        self.assertIn('dup', slugs)
        self.assertIn('dup-1', slugs)        # second "## Dup" deduped
        self.assertNotIn('not-a-heading', slugs)  # inside code fence


class TestStripLeadingH1(unittest.TestCase):
    def test_strips_h1_and_following_blank(self):
        self.assertEqual(build_wiki.strip_leading_h1('# Title\n\nbody'), 'body')

    def test_strips_h1_without_blank(self):
        self.assertEqual(build_wiki.strip_leading_h1('# Title\nbody'), 'body')

    def test_strips_after_leading_blanks(self):
        self.assertEqual(build_wiki.strip_leading_h1('\n\n# Title\n\nbody'), 'body')

    def test_leaves_non_h1(self):
        self.assertEqual(build_wiki.strip_leading_h1('## Sub\nbody'), '## Sub\nbody')
        self.assertEqual(build_wiki.strip_leading_h1('intro\n# Mid'), 'intro\n# Mid')


class TestNormalizeMermaid(unittest.TestCase):
    def test_normalizes_variants(self):
        self.assertEqual(build_wiki.normalize_mermaid('```Mermaid'), '```mermaid')
        self.assertEqual(build_wiki.normalize_mermaid('```mmd'), '```mermaid')
        self.assertEqual(build_wiki.normalize_mermaid('   ```MERMAID'), '   ```mermaid')

    def test_leaves_canonical_and_other_langs(self):
        self.assertEqual(build_wiki.normalize_mermaid('```mermaid'), '```mermaid')
        self.assertEqual(build_wiki.normalize_mermaid('```python'), '```python')


class TestToHttps(unittest.TestCase):
    def test_forms(self):
        cases = {
            'git@github.com:CalamooseLabs/OpenReturn.git': _REPO_URL,
            'https://github.com/CalamooseLabs/OpenReturn.git': _REPO_URL,
            'https://github.com/CalamooseLabs/OpenReturn': _REPO_URL,
            'ssh://git@github.com/CalamooseLabs/OpenReturn.git': _REPO_URL,
        }
        for remote, expected in cases.items():
            self.assertEqual(build_wiki._to_https(remote), expected)

    def test_drops_port_userinfo_and_scp_port(self):
        # Ported/credential-bearing remotes must normalise to the plain web URL
        # so nothing leaks into a published wiki page.
        cases = {
            'ssh://git@github.com:22/CalamooseLabs/OpenReturn.git': _REPO_URL,
            'git@github.com:22/CalamooseLabs/OpenReturn.git': _REPO_URL,
            'https://github.com:443/CalamooseLabs/OpenReturn': _REPO_URL,
            'https://x-access-token:TOKEN@github.com/CalamooseLabs/OpenReturn.git': _REPO_URL,
        }
        for remote, expected in cases.items():
            self.assertEqual(build_wiki._to_https(remote), expected)

    def test_unparseable(self):
        self.assertIsNone(build_wiki._to_https('not a url'))


class TestRewriteLinks(unittest.TestCase):
    def setUp(self):
        self.page_map = {
            'index.md': 'Home',
            'api.md': 'API-Reference',
            'scoring/models.md': 'Scoring-Models',
        }
        self.anchors = {
            'Home': {'sec'},
            'API-Reference': {'post-scoresgrade'},
            'Scoring-Models': set(),
        }

    def _rw(self, text, src):
        errors = []
        out, n = build_wiki.rewrite_links(
            text, src, self.page_map, self.anchors, _REPO_URL, errors)
        return out, n, errors

    def test_relative_parent_link_with_anchor(self):
        out, n, errors = self._rw('see [g](../api.md#post-scoresgrade)', 'scoring/models.md')
        self.assertEqual(out, 'see [g](API-Reference#post-scoresgrade)')
        self.assertEqual(n, 1)
        self.assertEqual(errors, [])

    def test_same_dir_link_no_anchor(self):
        out, n, _ = self._rw('see [m](scoring/models.md)', 'index.md')
        self.assertEqual(out, 'see [m](Scoring-Models)')
        self.assertEqual(n, 1)

    def test_openapi_escapes_to_blob_url(self):
        out, n, errors = self._rw('[spec](../openapi.json)', 'api.md')
        self.assertEqual(out, f'[spec]({_REPO_URL}/blob/HEAD/openapi.json)')
        self.assertEqual(n, 1)
        self.assertEqual(errors, [])

    def test_same_page_anchor_validated(self):
        _, _, ok = self._rw('[x](#sec)', 'index.md')
        self.assertEqual(ok, [])
        _, _, bad = self._rw('[x](#nope)', 'index.md')
        self.assertEqual(len(bad), 1)

    def test_dangling_cross_page_anchor(self):
        _, _, errors = self._rw('[x](../api.md#missing)', 'scoring/models.md')
        self.assertEqual(len(errors), 1)

    def test_unknown_md_target_is_error(self):
        _, _, errors = self._rw('[x](ghost.md)', 'index.md')
        self.assertEqual(len(errors), 1)

    def test_external_links_untouched(self):
        out, n, errors = self._rw('[h](https://x.test/y) [m](mailto:a@b.c)', 'index.md')
        self.assertEqual(out, '[h](https://x.test/y) [m](mailto:a@b.c)')
        self.assertEqual(n, 0)
        self.assertEqual(errors, [])

    def test_links_in_code_fences_untouched(self):
        text = '```\n[x](api.md)\n```\n[y](api.md)'
        out, n, _ = self._rw(text, 'index.md')
        self.assertEqual(out, '```\n[x](api.md)\n```\n[y](API-Reference)')
        self.assertEqual(n, 1)  # only the link outside the fence

    def test_inline_link_title_attribute_preserved(self):
        out, n, errors = self._rw('see [g](api.md "API docs")', 'index.md')
        self.assertEqual(out, 'see [g](API-Reference "API docs")')
        self.assertEqual(n, 1)
        self.assertEqual(errors, [])

    def test_title_attribute_cannot_hide_broken_md(self):
        _, _, errors = self._rw('[x](ghost.md "t")', 'index.md')
        self.assertEqual(len(errors), 1)

    def test_reference_definition_rewritten(self):
        out, n, errors = self._rw('use [the api][a]\n\n[a]: api.md', 'index.md')
        self.assertEqual(out, 'use [the api][a]\n\n[a]: API-Reference')
        self.assertEqual(n, 1)
        self.assertEqual(errors, [])

    def test_reference_definition_with_title_and_anchor(self):
        out, _, _ = self._rw('[a]: api.md#post-scoresgrade "grade"', 'index.md')
        self.assertEqual(out, '[a]: API-Reference#post-scoresgrade "grade"')

    def test_reference_definition_broken_md_errors(self):
        _, _, errors = self._rw('[a]: ghost.md', 'index.md')
        self.assertEqual(len(errors), 1)


class TestBuildRealDocs(unittest.TestCase):
    """Build the actual docs/ tree and assert it produces clean wiki pages."""

    @classmethod
    def setUpClass(cls):
        cls.out = tempfile.mkdtemp()
        cls.code = _silent_build(_REPO / 'docs', cls.out)
        cls.files = {p.name: p.read_text(encoding='utf-8')
                     for p in Path(cls.out).glob('*.md')}

    def test_build_succeeds(self):
        self.assertEqual(self.code, 0)

    def test_expected_pages_exist(self):
        for name in ('Home.md', 'Installation.md', 'API-Reference.md',
                     'Scoring-Models.md', 'Architecture.md', 'Testing.md',
                     '_Sidebar.md', '_Footer.md'):
            self.assertIn(name, self.files)
        # Source filenames must NOT survive as wiki pages.
        for name in ('index.md', 'models.md', 'architecture.md', 'api-keys.md'):
            self.assertNotIn(name, self.files)

    def test_no_md_or_path_in_internal_links(self):
        link_re = re.compile(r'\]\(([^)]+)\)')
        slug_re = re.compile(r'^[A-Za-z0-9][A-Za-z0-9-]*(#.+)?$')
        for name, text in self.files.items():
            in_fence = False
            for line in text.splitlines():
                if build_wiki._FENCE_RE.match(line):
                    in_fence = not in_fence
                    continue
                if in_fence:
                    continue
                for target in link_re.findall(line):
                    if target.startswith(('http://', 'https://', 'mailto:', '#')):
                        continue
                    self.assertRegex(
                        target, slug_re,
                        msg=f'{name}: internal link target "{target}" is not a '
                            f'bare wiki slug',
                    )

    def test_mermaid_diagrams_preserved(self):
        total = sum(t.count('```mermaid') for t in self.files.values())
        self.assertEqual(total, 6)

    def test_leading_h1_stripped(self):
        # Home and API-Reference both lose their body H1; first content line is
        # not an ATX H1.
        for name in ('Home.md', 'API-Reference.md', 'Testing.md'):
            first = next(ln for ln in self.files[name].splitlines() if ln.strip())
            self.assertFalse(first.startswith('# '), f'{name} still has a body H1')

    def test_sidebar_and_footer_content(self):
        side = self.files['_Sidebar.md']
        self.assertIn('[Home](Home)', side)
        self.assertIn('[Scoring Models](Scoring-Models)', side)
        self.assertNotIn('.md)', side)
        self.assertIn('generated from', self.files['_Footer.md'])


class TestBuildGuards(unittest.TestCase):
    """The build must fail closed on structural/link problems."""

    def _docs(self, files):
        d = tempfile.mkdtemp()
        for name, content in files.items():
            p = Path(d) / name
            p.parent.mkdir(parents=True, exist_ok=True)
            p.write_text(content, encoding='utf-8')
        return d

    TINY_NAV = [('G', [('a.md', 'A', 'A'), ('b.md', 'B', 'B')])]

    def test_happy_tiny_build(self):
        docs = self._docs({
            'a.md': '# A\n\n## Sec A\n\nsee [b](b.md) and [self](#sec-a)\n',
            'b.md': '# B\n\nback to [a sec](a.md#sec-a)\n',
        })
        with patch.object(build_wiki, 'NAV', self.TINY_NAV):
            self.assertEqual(_silent_build(docs, tempfile.mkdtemp()), 0)

    def test_unmapped_page_fails(self):
        docs = self._docs({
            'a.md': '# A\n', 'b.md': '# B\n', 'c.md': '# C (unmapped)\n',
        })
        with patch.object(build_wiki, 'NAV', self.TINY_NAV):
            self.assertEqual(_silent_build(docs, tempfile.mkdtemp()), 1)

    def test_missing_nav_page_fails(self):
        docs = self._docs({'a.md': '# A\n'})  # b.md declared in NAV but absent
        with patch.object(build_wiki, 'NAV', self.TINY_NAV):
            self.assertEqual(_silent_build(docs, tempfile.mkdtemp()), 1)

    def test_broken_link_fails(self):
        docs = self._docs({
            'a.md': '# A\n\n[ghost](ghost.md)\n', 'b.md': '# B\n',
        })
        with patch.object(build_wiki, 'NAV', self.TINY_NAV):
            self.assertEqual(_silent_build(docs, tempfile.mkdtemp()), 1)

    def test_dangling_anchor_fails(self):
        docs = self._docs({
            'a.md': '# A\n\n[x](b.md#nope)\n', 'b.md': '# B\n\n## Real\n',
        })
        with patch.object(build_wiki, 'NAV', self.TINY_NAV):
            self.assertEqual(_silent_build(docs, tempfile.mkdtemp()), 1)


if __name__ == '__main__':
    unittest.main()
