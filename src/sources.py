"""Remote ingest sources: URL detection, ZIP-link discovery, and downloads.

The ingest CLI accepts an ``http(s)://`` source in addition to a local
directory. A source may be a direct link to a ``.zip`` archive or an HTML
index page such as the IRS Form 990 series downloads page
(https://www.irs.gov/charities-non-profits/form-990-series-downloads), whose
data archives live on ``apps.irs.gov``. Only ``<a href>`` targets whose path
ends in ``.zip`` are kept, so CSV index files and ordinary navigation links are
ignored automatically.

Stdlib only (``urllib`` + ``html.parser``) — no third-party HTTP dependency.
"""

import os
from html.parser import HTMLParser
from pathlib import Path
from urllib.parse import urljoin, urlparse
from urllib.request import Request, urlopen

from console import _DIM, _GRN, _R, _CLR

# A browser-ish User-Agent — apps.irs.gov / www.irs.gov reject the default
# ``Python-urllib`` agent with 403 on some paths.
_USER_AGENT = "Mozilla/5.0 (compatible; OpenReturn-ingest/0.1)"
_CHUNK = 1 << 20  # 1 MiB streaming download chunks


def is_url(source: str) -> bool:
    """True if ``source`` looks like an http(s) URL rather than a local path.

    Tolerates surrounding whitespace (a pasted/piped URL) so the CLI dispatches
    it to the URL path instead of treating it as a directory name.
    """
    return isinstance(source, str) and source.strip().lower().startswith(("http://", "https://"))


class _AnchorParser(HTMLParser):
    """Collects the href of every ``<a>`` tag on a page."""

    def __init__(self) -> None:
        super().__init__()
        self.hrefs: list[str] = []

    def handle_starttag(self, tag: str, attrs: list) -> None:
        if tag.lower() != "a":
            return
        for key, value in attrs:
            if key.lower() == "href" and value:
                self.hrefs.append(value)


def _open(url: str):
    return urlopen(Request(url, headers={"User-Agent": _USER_AGENT}))


def discover_zip_urls(source: str) -> list[str]:
    """Return the sorted, de-duplicated list of ZIP URLs reachable from ``source``.

    If ``source`` itself points at a ``.zip`` file it is returned as the sole
    entry with no network request. Otherwise the page is fetched and every
    ``<a href>`` resolving to a URL whose path ends in ``.zip`` is returned;
    CSV index files and other hyperlinks are dropped by that filter. Query
    strings and fragments are stripped so the bare file URL is the canonical id.
    """
    if urlparse(source).path.lower().endswith(".zip"):
        return [source]

    with _open(source) as resp:
        charset = resp.headers.get_content_charset() or "utf-8"
        html = resp.read().decode(charset, errors="replace")

    parser = _AnchorParser()
    parser.feed(html)

    found: set[str] = set()
    for href in parser.hrefs:
        absolute = urljoin(source, href.strip())
        parts = urlparse(absolute)
        if parts.scheme in ("http", "https") and parts.path.lower().endswith(".zip"):
            found.add(parts._replace(query="", fragment="").geturl())
    return sorted(found)


def _human(n: int | None) -> str:
    if not n:
        return "?"
    size = float(n)
    for unit in ("B", "KB", "MB", "GB"):
        if size < 1024 or unit == "GB":
            return f"{size:.1f}{unit}"
        size /= 1024


def download_zip(url: str, dest_dir, *, progress: bool = True) -> tuple[Path, dict]:
    """Stream ``url`` into ``dest_dir`` and return ``(path, meta)``.

    ``meta`` carries the HTTP ``etag``, ``last_modified`` and ``content_length``
    (any may be ``None``). Streaming in chunks keeps a multi-GB archive off the
    heap. The on-disk name is the URL's basename so ``filing.zip_filename`` stays
    the published archive name.

    The download is atomic and integrity-checked: bytes stream into a ``.part``
    file that is renamed onto ``name`` only after a complete transfer. If the
    server advertised a ``Content-Length`` and fewer (or more) bytes arrive, an
    ``OSError`` is raised so the caller treats it as a failed download (counted,
    not recorded, retried next run) rather than silently ingesting a truncated
    archive. On any failure the partial ``.part`` file is removed.
    """
    dest_dir = Path(dest_dir)
    name = os.path.basename(urlparse(url).path) or "download.zip"
    out = dest_dir / name
    part = out.with_name(out.name + ".part")

    try:
        with _open(url) as resp:
            raw_len = resp.headers.get("Content-Length")
            total = int(raw_len) if raw_len and raw_len.isdigit() else None
            meta = {
                "etag":           resp.headers.get("ETag"),
                "last_modified":  resp.headers.get("Last-Modified"),
                "content_length": total,
            }
            got = 0
            with open(part, "wb") as fh:
                while True:
                    chunk = resp.read(_CHUNK)
                    if not chunk:
                        break
                    fh.write(chunk)
                    got += len(chunk)
                    if progress:
                        if total:
                            print(f"\r{_DIM}  ↓ {name}  {_human(got)}/{_human(total)}  "
                                  f"{got / total * 100:5.1f}%{_R}{_CLR}", end="", flush=True)
                        else:
                            print(f"\r{_DIM}  ↓ {name}  {_human(got)}{_R}{_CLR}", end="", flush=True)
        if total is not None and got != total:
            raise OSError(f"incomplete download: got {got} of {total} bytes for {url}")
        os.replace(part, out)
    except BaseException:
        part.unlink(missing_ok=True)
        raise

    if progress:
        print(f"\r{_GRN}  ↓ {name}  {_human(got)}{_R}{_CLR}")
    meta["content_length"] = meta["content_length"] or got
    return out, meta
