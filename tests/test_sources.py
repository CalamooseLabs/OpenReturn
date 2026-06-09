"""Tests for src/sources.py — URL detection, ZIP-link discovery, downloads."""

import contextlib
import io
import os
import sys
import tempfile
import unittest
from pathlib import Path
from unittest.mock import MagicMock, patch

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

import sources


# ---------------------------------------------------------------------------
# Fake HTTP response plumbing for patching sources.urlopen
# ---------------------------------------------------------------------------

class _FakeHeaders:
    def __init__(self, d, charset='utf-8'):
        self._d = d
        self._charset = charset

    def get(self, key, default=None):
        return self._d.get(key, default)

    def get_content_charset(self):
        return self._charset


class _FakeResp:
    def __init__(self, body=b'', headers=None, charset='utf-8'):
        self._body = body
        self._pos = 0
        self.headers = _FakeHeaders(headers or {}, charset)

    def __enter__(self):
        return self

    def __exit__(self, *exc):
        return False

    def read(self, n=-1):
        if n is None or n < 0:
            chunk = self._body[self._pos:]
            self._pos = len(self._body)
        else:
            chunk = self._body[self._pos:self._pos + n]
            self._pos += len(chunk)
        return chunk


_PAGE_URL = "https://apps.irs.gov/pub/epostcard/990/xml/2024/index.html"
_HTML = """
<html><body>
<a href="https://apps.irs.gov/pub/epostcard/990/xml/2024/2024_TEOS_XML_01A.zip">Jan</a>
<a href="https://apps.irs.gov/pub/epostcard/990/xml/2024/2024_TEOS_XML_02A.zip">Feb</a>
<a href="https://apps.irs.gov/pub/epostcard/990/xml/2024/index_2024.csv">Index CSV</a>
<a href="/charities-non-profits/form-990-series-downloads-2023">2023 page</a>
<a href="https://www.irs.gov/help">Help</a>
<a href="mailto:foo@irs.gov">Email</a>
<a>noref</a>
<a href="">empty</a>
<a href="2024_TEOS_XML_01A.zip?x=1#frag">relative dup with query</a>
<DIV href="ignored.zip">not an anchor</DIV>
</body></html>
""".encode("utf-8")

_ZIP_01A = "https://apps.irs.gov/pub/epostcard/990/xml/2024/2024_TEOS_XML_01A.zip"
_ZIP_02A = "https://apps.irs.gov/pub/epostcard/990/xml/2024/2024_TEOS_XML_02A.zip"


# ---------------------------------------------------------------------------
# is_url
# ---------------------------------------------------------------------------

class TestIsUrl(unittest.TestCase):

    def test_http(self):
        self.assertTrue(sources.is_url("http://example.com"))

    def test_https_uppercase(self):
        self.assertTrue(sources.is_url("HTTPS://EXAMPLE.COM/x.zip"))

    def test_local_path(self):
        self.assertFalse(sources.is_url("/data/zips"))

    def test_relative_path(self):
        self.assertFalse(sources.is_url("zips"))

    def test_non_string(self):
        self.assertFalse(sources.is_url(None))

    def test_whitespace_padded(self):
        self.assertTrue(sources.is_url("  https://x/a.zip  "))


# ---------------------------------------------------------------------------
# discover_zip_urls
# ---------------------------------------------------------------------------

class TestDiscoverZipUrls(unittest.TestCase):

    def test_direct_zip_url_no_network(self):
        mock_open = MagicMock()
        with patch('sources.urlopen', mock_open):
            result = sources.discover_zip_urls("https://x/data/2024_TEOS_XML_01A.zip")
        self.assertEqual(result, ["https://x/data/2024_TEOS_XML_01A.zip"])
        mock_open.assert_not_called()

    def test_page_filters_to_zip_only(self):
        with patch('sources.urlopen', return_value=_FakeResp(_HTML)):
            result = sources.discover_zip_urls(_PAGE_URL)
        self.assertEqual(result, [_ZIP_01A, _ZIP_02A])

    def test_page_excludes_csv_and_nav(self):
        with patch('sources.urlopen', return_value=_FakeResp(_HTML)):
            result = sources.discover_zip_urls(_PAGE_URL)
        joined = " ".join(result)
        self.assertNotIn(".csv", joined)
        self.assertNotIn("form-990-series-downloads-2023", joined)
        self.assertNotIn("/help", joined)
        self.assertNotIn("mailto", joined)

    def test_query_and_fragment_stripped_and_deduped(self):
        # The relative href "2024_TEOS_XML_01A.zip?x=1#frag" resolves to the same
        # bare URL as the absolute 01A link, so the result has no duplicates.
        with patch('sources.urlopen', return_value=_FakeResp(_HTML)):
            result = sources.discover_zip_urls(_PAGE_URL)
        self.assertEqual(len(result), len(set(result)))
        self.assertNotIn("?", " ".join(result))

    def test_charset_none_defaults_utf8(self):
        with patch('sources.urlopen', return_value=_FakeResp(_HTML, charset=None)):
            result = sources.discover_zip_urls(_PAGE_URL)
        self.assertEqual(result, [_ZIP_01A, _ZIP_02A])

    def test_page_with_no_zip_links(self):
        html = b"<html><body><a href='/about'>About</a></body></html>"
        with patch('sources.urlopen', return_value=_FakeResp(html)):
            result = sources.discover_zip_urls("https://x/page")
        self.assertEqual(result, [])


# ---------------------------------------------------------------------------
# _human
# ---------------------------------------------------------------------------

class TestHuman(unittest.TestCase):

    def test_zero_and_none(self):
        self.assertEqual(sources._human(0), "?")
        self.assertEqual(sources._human(None), "?")

    def test_bytes(self):
        self.assertEqual(sources._human(512), "512.0B")

    def test_kilobytes(self):
        self.assertEqual(sources._human(2048), "2.0KB")

    def test_megabytes(self):
        self.assertEqual(sources._human(5 * 1024 * 1024), "5.0MB")

    def test_gigabytes(self):
        self.assertEqual(sources._human(3 * 1024 ** 3), "3.0GB")

    def test_terabytes_clamp_to_gb(self):
        # Larger than GB still reports in GB (the loop's last unit).
        self.assertTrue(sources._human(5 * 1024 ** 4).endswith("GB"))


# ---------------------------------------------------------------------------
# download_zip
# ---------------------------------------------------------------------------

class TestDownloadZip(unittest.TestCase):

    def _run(self, url, headers, body, **kw):
        with tempfile.TemporaryDirectory() as td:
            with patch('sources.urlopen', return_value=_FakeResp(body, headers)):
                buf = io.StringIO()
                with contextlib.redirect_stdout(buf):
                    path, meta = sources.download_zip(url, td, **kw)
                data = Path(path).read_bytes()
            return path, meta, data, buf.getvalue()

    def test_with_content_length(self):
        path, meta, data, _ = self._run(
            "https://x/2024_TEOS_XML_01A.zip",
            {"Content-Length": "10", "ETag": '"e"', "Last-Modified": "LM"},
            b"0123456789",
        )
        self.assertEqual(Path(path).name, "2024_TEOS_XML_01A.zip")
        self.assertEqual(data, b"0123456789")
        self.assertEqual(meta["etag"], '"e"')
        self.assertEqual(meta["last_modified"], "LM")
        self.assertEqual(meta["content_length"], 10)

    def test_without_content_length(self):
        path, meta, data, _ = self._run(
            "https://x/a.zip", {}, b"hello",
        )
        self.assertEqual(data, b"hello")
        # Falls back to bytes actually read.
        self.assertEqual(meta["content_length"], 5)
        self.assertIsNone(meta["etag"])

    def test_non_digit_content_length(self):
        path, meta, data, _ = self._run(
            "https://x/a.zip", {"Content-Length": "not-a-number"}, b"abc",
        )
        self.assertEqual(meta["content_length"], 3)

    def test_progress_disabled_no_output(self):
        path, meta, data, out = self._run(
            "https://x/a.zip", {"Content-Length": "3"}, b"abc", progress=False,
        )
        self.assertEqual(out, "")
        self.assertEqual(data, b"abc")

    def test_name_fallback_when_url_has_no_basename(self):
        path, meta, data, _ = self._run("https://x/", {}, b"z")
        self.assertEqual(Path(path).name, "download.zip")

    def test_incomplete_download_raises_and_cleans_up(self):
        # Server advertises 10 bytes but delivers 5 → integrity check fails and
        # the partial .part file is removed (nothing left in the dir).
        with tempfile.TemporaryDirectory() as td:
            with patch('sources.urlopen', return_value=_FakeResp(b"12345", {"Content-Length": "10"})):
                buf = io.StringIO()
                with contextlib.redirect_stdout(buf):
                    with self.assertRaises(OSError):
                        sources.download_zip("https://x/a.zip", td)
            self.assertEqual(list(Path(td).iterdir()), [])


if __name__ == '__main__':
    unittest.main()
