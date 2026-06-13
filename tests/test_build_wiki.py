"""Tests for tools/build_wiki.py — docs/ → GitHub wiki generation."""

import os
import re
import sys
import tempfile
import unittest
from pathlib import Path

_ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(_ROOT / "tools"))

import build_wiki as bw

_DOCS = str(_ROOT / "docs")


class TestBuildWiki(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        cls.pages = bw.build_wiki(_DOCS)

    def test_one_page_per_doc_plus_sidebar_footer(self):
        expected = {f"{name}.md" for name, _ in bw.PAGES.values()}
        expected |= {"_Sidebar.md", "_Footer.md"}
        self.assertEqual(set(self.pages), expected)

    def test_index_becomes_home(self):
        self.assertIn("Home.md", self.pages)

    def test_inter_doc_links_rewritten_to_wiki_pages(self):
        self.assertIn("Scoring-Models#manual-graded-models", self.pages["API-Reference.md"])
        self.assertIn("API-Reference#post-scoresgrade", self.pages["Scoring-Models.md"])
        self.assertIn("NixOS-Module#running-ingest-on-the-server",
                      self.pages["Ingest-and-Upload.md"])
        self.assertIn("(Installation-and-Setup)", self.pages["Home.md"])

    def test_no_leftover_relative_doc_links(self):
        docnames = "install|ingest|nixos|api|api-keys|index|scoring/models|" \
                   "development/architecture|development/testing"
        pattern = re.compile(r"\]\((?:\.\./)?(?:" + docnames + r")\.md")
        for fn, content in self.pages.items():
            self.assertEqual(pattern.findall(content), [], f"{fn} has un-rewritten doc links")

    def test_external_and_anchor_links_untouched(self):
        # a same-page anchor and an http link must survive unchanged
        ingest = self.pages["Ingest-and-Upload.md"]
        self.assertIn("https://www.irs.gov/charities-non-profits/form-990-series-downloads", ingest)

    def test_mermaid_blocks_preserved(self):
        arch = self.pages["Architecture.md"]
        self.assertIn("```mermaid", arch)
        self.assertIn("erDiagram", arch)
        # fences still balanced after conversion
        self.assertEqual(arch.count("```") % 2, 0)

    def test_mermaid_node_syntax_not_mangled(self):
        # node labels like db[(ScoreDatabase…)] / client([…]) must be intact
        arch = self.pages["Architecture.md"]
        self.assertIn("[(", arch)  # cylinder node survived link regex

    def test_sidebar_lists_all_pages(self):
        sidebar = self.pages["_Sidebar.md"]
        for name, title in bw.PAGES.values():
            self.assertIn(f"({name})", sidebar)

    def test_footer_marks_generated(self):
        self.assertIn("Generated from", self.pages["_Footer.md"])


class TestWriteWiki(unittest.TestCase):

    def test_writes_files_to_disk(self):
        with tempfile.TemporaryDirectory() as td:
            n = bw.write_wiki(td, _DOCS)
            written = {p.name for p in Path(td).glob("*.md")}
            self.assertEqual(n, len(written))
            self.assertIn("Home.md", written)
            self.assertIn("_Sidebar.md", written)


class TestRewriteTarget(unittest.TestCase):

    def test_relative_with_anchor(self):
        self.assertEqual(bw._rewrite_target("install.md#setup", "ingest.md"),
                         "Installation-and-Setup#setup")

    def test_parent_relative(self):
        self.assertEqual(bw._rewrite_target("../api.md", "scoring/models.md"),
                         "API-Reference")

    def test_http_untouched(self):
        self.assertEqual(bw._rewrite_target("https://x.test/y", "api.md"),
                         "https://x.test/y")

    def test_same_page_anchor_untouched(self):
        self.assertEqual(bw._rewrite_target("#section", "api.md"), "#section")

    def test_unknown_doc_untouched(self):
        self.assertEqual(bw._rewrite_target("CONTRIBUTING.md", "api.md"), "CONTRIBUTING.md")


if __name__ == "__main__":  # pragma: no cover
    unittest.main()
