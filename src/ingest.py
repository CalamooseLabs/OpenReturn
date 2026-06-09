#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3

import argparse
import os
import shutil
import sys
import tempfile
import time
import uuid
import zipfile
from collections import defaultdict
from concurrent.futures import ProcessPoolExecutor, as_completed
from pathlib import Path

import sources
from console import _B, _R, _DIM, _CYN, _GRN, _RED, _YLW, _CLR
from database.Score import ScoreDatabase
from router.Upload import UploadRouter
from router.Upload.upload import _worker_init, _parse_xml_batch
from unzipper import MemberReader

# Filings per worker task. Per-filing parsing is cheap (a single tree walk),
# so batching amortizes the process-pool IPC cost across many filings.
_BATCH_FILES = 50

_INSERT_REPORTED_DATA = (
    "INSERT OR IGNORE INTO reported_data (filing_id, field_id, raw_value) VALUES (?, ?, ?)"
)

_DATA_ROWS_PER_FLUSH = 500_000  # flush + WAL checkpoint every ~500 k data rows mid-ZIP


def _bar(done: int, total: int, width: int = 35) -> str:
    pct = done / total if total else 0
    filled = int(width * pct)
    return f"[{'█' * filled}{'░' * (width - filled)}] {pct * 100:5.1f}%"


def _trunc(s: str, n: int) -> str:
    return s if len(s) <= n else '…' + s[-(n - 1):]


def _fmt_duration(secs: float) -> str:
    """Format a duration as e.g. '1h 02m 03s' or '42.7s'."""
    if secs < 60:
        return f"{secs:.1f}s"
    m, s = divmod(int(secs), 60)
    h, m = divmod(m, 60)
    return f"{h}h {m:02d}m {s:02d}s" if h else f"{m}m {s:02d}s"


def _resolve_ids(db, filing_key_to_id: dict) -> dict:
    """Return {pre_id: actual_id} for any filings where INSERT OR IGNORE hit an
    existing row (a duplicate (EIN, year, form) already in the table), so its
    client-assigned integer filing_id was ignored in favour of the existing one."""
    db.cursor.execute(
        "CREATE TEMP TABLE IF NOT EXISTS _key_resolve (ein TEXT, year INT, form_code TEXT)"
    )
    db.cursor.execute("DELETE FROM _key_resolve")
    db.cursor.executemany("INSERT INTO _key_resolve VALUES (?,?,?)", filing_key_to_id.keys())
    rows = db.cursor.execute("""
        SELECT f.organization_id, f.year, f.form_code, f.filing_id
        FROM filing f
        JOIN _key_resolve k
          ON k.ein = f.organization_id
         AND k.year = f.year
         AND k.form_code = f.form_code
    """).fetchall()
    remap = {}
    for ein, year, form_code, actual_id in rows:
        pre_id = filing_key_to_id[(ein, year, form_code)]
        if actual_id != pre_id:
            remap[pre_id] = actual_id
    return remap


def _flush_zip(db, pending_orgs, pending_filings, pending_data, id_remap,
               prof: dict | None = None) -> None:
    """Flush one batch. ``id_remap`` is a per-ZIP {pre_id: actual_id} dict that
    persists across flushes: we resolve only THIS batch's just-inserted filing
    keys (not the whole accumulated set) and merge any collisions into id_remap,
    then apply the full id_remap to pending_data. Persisting the remap is needed
    when a within-ZIP duplicate's reported_data lands in a later flush than the
    (colliding) filing row that produced the remap."""
    if pending_orgs:
        db.cursor.executemany(
            "INSERT OR IGNORE INTO organization (ein, name) VALUES (?,?)",
            pending_orgs
        )
    if pending_filings:
        db.cursor.executemany(
            "INSERT OR IGNORE INTO filing "
            "(filing_id, uuid, year, organization_id, form_code, xml_filename, zip_filename) "
            "VALUES (?,?,?,?,?,?,?)",
            pending_filings
        )
        _t = time.monotonic()
        # Only this batch's keys — tuple layout: (pre_id, uuid, year, ein, form, ...)
        batch_keys = {(t[3], t[2], t[4]): t[0] for t in pending_filings}
        id_remap.update(_resolve_ids(db, batch_keys))
        if prof is not None:
            prof['flush_resolve'] += time.monotonic() - _t
    if id_remap and pending_data:
        pending_data[:] = [
            (id_remap.get(r[0], r[0]), r[1], r[2]) for r in pending_data
        ]
    if pending_data:
        _t = time.monotonic()
        db.cursor.executemany(_INSERT_REPORTED_DATA, pending_data)
        if prof is not None:
            prof['flush_insert'] += time.monotonic() - _t
    _t = time.monotonic()
    db.commit()
    if prof is not None:
        prof['flush_commit'] += time.monotonic() - _t


class _Ctx:
    """Run-level state shared across every ZIP in one ingest run. Both the
    local-directory and URL paths build one ``_Ctx``, then feed it ZIPs one at
    a time. ``total_xmls`` is known up front for a directory (pre-scan) and
    grows per-ZIP for a URL source (each archive is scanned as it arrives)."""

    def __init__(self, n_zips: int, total_xmls: int = 0, workers: int = 1) -> None:
        self.n_zips = n_zips
        self.zw = len(str(n_zips)) if n_zips else 1
        self.total_xmls = total_xmls
        self.workers = workers
        self.done = 0
        self.totals = {'stored': 0, 'skipped': 0, 'error': 0}
        self.prof: dict = defaultdict(float)
        # Parallel-path state, shared so filing_ids stay unique across ZIPs.
        self.seen_eins: set[str] = set()
        self.next_filing_id = 1


def _zip_header(ctx: _Ctx, zip_idx: int, zip_name: str, n_xml: int) -> str:
    return (
        f"{_B}[ZIP {zip_idx:{ctx.zw}}/{ctx.n_zips}]{_R}  "
        f"{_CYN}{zip_name}{_R}  "
        f"{_DIM}({n_xml} file{'s' if n_xml != 1 else ''}){_R}"
    )


def _process_zip_seq(router, ctx: _Ctx, zip_idx: int, zip_path: Path,
                     xml_names: list[str] | None) -> dict:
    """Sequential path — one file at a time using router._process_xml. Mutates
    the run counters on ``ctx`` and returns this ZIP's per-status tallies."""
    n_xml = len(xml_names) if xml_names is not None else 0
    fw = len(str(n_xml)) if n_xml else 1
    per = {'stored': 0, 'skipped': 0, 'error': 0}
    zip_hdr = _zip_header(ctx, zip_idx, zip_path.name, n_xml)

    if xml_names is None:
        print(f"{zip_hdr}  {_RED}invalid ZIP — skipped{_R}")
        ctx.totals['error'] += 1
        return per

    print(zip_hdr)

    if n_xml == 0:
        print(f"  {_DIM}no XML files{_R}\n")
        return per

    try:
        with MemberReader(zip_path) as reader:
            for file_idx, name in enumerate(xml_names, 1):
                bar = _bar(ctx.done, ctx.total_xmls)
                status_line = (
                    f"  [{file_idx:{fw}}/{n_xml}]  {_trunc(name, 50)}  "
                    f"{bar}  ({ctx.done}/{ctx.total_xmls})"
                )
                print(f"\r{status_line}{_CLR}", end='', flush=True)

                try:
                    xml_bytes = reader.read(name)
                    result = router._process_xml(
                        xml_bytes.decode('utf-8'), name, zip_filename=zip_path.name
                    )
                except Exception as exc:
                    result = {'file': name, 'status': 'error', 'reason': str(exc)}

                status = result.get('status', 'error')
                per[status]        = per.get(status, 0) + 1
                ctx.totals[status] = ctx.totals.get(status, 0) + 1
                ctx.done += 1

    except zipfile.BadZipFile:
        print(f"\r  {_RED}corrupt ZIP — skipping remaining files{_R}{_CLR}")
        ctx.totals['error'] += 1
        print()
        return per

    bar = _bar(ctx.done, ctx.total_xmls)
    err_color = _RED if per['error'] else _DIM
    print(
        f"\r  {_GRN}stored {per['stored']}{_R}  "
        f"{_YLW}skipped {per['skipped']}{_R}  "
        f"{err_color}errors {per['error']}{_R}  "
        f"{bar}  ({ctx.done}/{ctx.total_xmls}){_CLR}"
    )
    print()
    return per


def _process_zip_par(db, pool, ctx: _Ctx, zip_idx: int, zip_path: Path,
                     xml_names: list[str] | None) -> dict:
    """Parallel path — XML parsing in worker processes, DB writes batched per
    ZIP. Mutates the run counters on ``ctx`` and returns this ZIP's tallies."""
    n_xml = len(xml_names) if xml_names is not None else 0
    per = {'stored': 0, 'skipped': 0, 'error': 0}
    zip_hdr = _zip_header(ctx, zip_idx, zip_path.name, n_xml)

    if xml_names is None:
        print(f"{zip_hdr}  {_RED}invalid ZIP — skipped{_R}")
        ctx.totals['error'] += 1
        return per

    print(zip_hdr)

    if n_xml == 0:
        print(f"  {_DIM}no XML files{_R}\n")
        return per

    pending_orgs:     list[tuple] = []
    pending_filings:  list[tuple] = []
    filing_key_to_id: dict[tuple, int] = {}
    id_remap:         dict[int, int] = {}
    pending_data:     list[tuple] = []
    zip_read0 = ctx.prof['read']

    # Read each XML in this process and hand the bytes to workers (workers do
    # no I/O), grouped into batches to amortize IPC. Read one chunk of files at
    # a time so at most chunk_sz files' bytes are in flight at once.
    chunk_sz = ctx.workers * _BATCH_FILES * 2
    try:
        with MemberReader(zip_path) as reader:
            for start in range(0, n_xml, chunk_sz):
                chunk   = xml_names[start:start + chunk_sz]
                futures = {}
                batch   = []
                for name in chunk:
                    try:
                        _tr = time.monotonic()
                        xml_bytes = reader.read(name)
                        ctx.prof['read'] += time.monotonic() - _tr
                    except Exception:
                        per['error'] += 1
                        ctx.totals['error'] += 1
                        ctx.done += 1
                        continue
                    batch.append((xml_bytes, name, zip_path.name))
                    if len(batch) >= _BATCH_FILES:
                        futures[pool.submit(_parse_xml_batch, batch)] = len(batch)
                        batch = []
                if batch:
                    futures[pool.submit(_parse_xml_batch, batch)] = len(batch)

                for fut in as_completed(futures):
                    try:
                        results = fut.result()
                    except Exception:
                        n = futures[fut]
                        per['error'] += n
                        ctx.totals['error'] += n
                        ctx.done += n
                        continue

                    for parsed in results:
                        status = parsed.get('status', 'error')

                        if status == 'parsed':
                            try:
                                ein       = parsed['ein']
                                year      = parsed['year']
                                form_code = parsed['form_code']
                                key       = (ein, year, form_code)

                                if ein not in ctx.seen_eins:
                                    pending_orgs.append((ein, parsed['name']))
                                    ctx.seen_eins.add(ein)

                                if key not in filing_key_to_id:
                                    pre_id = ctx.next_filing_id
                                    ctx.next_filing_id += 1
                                    filing_key_to_id[key] = pre_id
                                    pending_filings.append((
                                        pre_id, str(uuid.uuid4()), year, ein, form_code,
                                        parsed['file'], parsed['zip_filename'],
                                    ))

                                pre_id = filing_key_to_id[key]
                                pending_data.extend(
                                    (pre_id, fid, v)
                                    for fid, v in parsed['values'].items()
                                )
                                status = 'stored'
                            except Exception:
                                status = 'error'

                        per[status]        = per.get(status, 0) + 1
                        ctx.totals[status] = ctx.totals.get(status, 0) + 1
                        ctx.done += 1

                    bar = _bar(ctx.done, ctx.total_xmls)
                    print(
                        f"\r  {_GRN}{per['stored']}{_R} stored  {bar}  ({ctx.done}/{ctx.total_xmls}){_CLR}",
                        end='', flush=True,
                    )

                    if len(pending_data) >= _DATA_ROWS_PER_FLUSH:
                        _flush_zip(db, pending_orgs, pending_filings, pending_data, id_remap, ctx.prof)
                        pending_orgs.clear()
                        pending_filings.clear()
                        pending_data.clear()
    except zipfile.BadZipFile:
        print(f"\r  {_RED}corrupt ZIP — skipping remaining files{_R}{_CLR}")
        ctx.totals['error'] += 1

    _flush_zip(db, pending_orgs, pending_filings, pending_data, id_remap, ctx.prof)
    _tc = time.monotonic()
    db.cursor.execute("PRAGMA wal_checkpoint(TRUNCATE)")
    ctx.prof['checkpoint'] += time.monotonic() - _tc

    zip_read_ms = (ctx.prof['read'] - zip_read0) / n_xml * 1000 if n_xml else 0
    bar = _bar(ctx.done, ctx.total_xmls)
    err_color = _RED if per['error'] else _DIM
    print(
        f"\r  {_GRN}stored {per['stored']}{_R}  "
        f"{_YLW}skipped {per['skipped']}{_R}  "
        f"{err_color}errors {per['error']}{_R}  "
        f"{_DIM}read {zip_read_ms:.2f}ms/file{_R}  "
        f"{bar}  ({ctx.done}/{ctx.total_xmls}){_CLR}"
    )
    print()
    return per


def _seed_filing_id(db) -> int:
    """Seed the client-side filing_id counter past the current max. Ingest holds
    an exclusive lock so no other writer competes for the range."""
    _row = db.cursor.execute("SELECT COALESCE(MAX(filing_id), 0) FROM filing").fetchone()
    return (_row[0] if _row and isinstance(_row[0], int) else 0) + 1


def _finish_run(args, ctx: _Ctx, db, t_start: float, t_process: float) -> int:
    """Print the completion summary, rebuild indexes, end bulk-load, close the
    DB, and print timing (+ optional profile). Shared by both ingest paths."""
    bar = _bar(ctx.done, ctx.total_xmls)
    err_color = _RED if ctx.totals['error'] else _DIM
    print(
        f"{_B}Complete{_R}  {bar}\n"
        f"  {_GRN}stored  {ctx.totals['stored']}{_R}\n"
        f"  {_YLW}skipped {ctx.totals['skipped']}{_R}\n"
        f"  {err_color}errors  {ctx.totals['error']}{_R}\n"
    )

    print(f"{_DIM}Rebuilding indexes…{_R}", flush=True)
    db.restore_ingest_indexes()
    print(f"{_DIM}Checkpointing WAL…{_R}", flush=True)
    db.end_bulk_load()

    db.close()

    t_end       = time.monotonic()
    process_s   = t_process - t_start
    finalize_s  = t_end - t_process
    total_s     = t_end - t_start
    rate        = ctx.done / process_s if process_s else 0
    print(
        f"{_B}Timing{_R}  {_CYN}{args.workers} worker{'s' if args.workers != 1 else ''}{_R}\n"
        f"  {_DIM}process  {_R}{_fmt_duration(process_s)}  "
        f"{_DIM}({rate:,.0f} filings/s){_R}\n"
        f"  {_DIM}finalize {_R}{_fmt_duration(finalize_s)}  {_DIM}(index rebuild + checkpoint){_R}\n"
        f"  {_B}total    {_R}{_fmt_duration(total_s)}\n"
    )

    if getattr(args, 'profile', False) and args.workers != 1:
        accounted = (ctx.prof['read'] + ctx.prof['flush_resolve'] + ctx.prof['flush_insert']
                     + ctx.prof['flush_commit'] + ctx.prof['checkpoint'])
        other = max(0.0, process_s - accounted)
        rows = [
            ('read (decompress)',        ctx.prof['read']),
            ('insert reported_data',     ctx.prof['flush_insert']),
            ('resolve filing uuids',     ctx.prof['flush_resolve']),
            ('commit',                   ctx.prof['flush_commit']),
            ('wal checkpoint (per-zip)', ctx.prof['checkpoint']),
            ('worker wait + collect',    other),
        ]
        print(f"{_B}Profile{_R}  {_DIM}(share of {_fmt_duration(process_s)} process time){_R}")
        for label, secs in sorted(rows, key=lambda r: -r[1]):
            pct = 100 * secs / process_s if process_s else 0
            print(f"  {_DIM}{label:24}{_R}{_fmt_duration(secs):>10}  {pct:5.1f}%")
        print()
    return 0


def _process_zip(db, router, pool, ctx, zip_idx, zip_path, xml_names) -> dict:
    """Dispatch one ZIP to the sequential or parallel processor by ``pool``."""
    if pool is None:
        return _process_zip_seq(router, ctx, zip_idx, zip_path, xml_names)
    return _process_zip_par(db, pool, ctx, zip_idx, zip_path, xml_names)


def cmd_ingest(args) -> int:
    if sources.is_url(args.directory):
        return _cmd_ingest_url(args, args.directory)
    return _cmd_ingest_dir(args, args.directory)


def _cmd_ingest_dir(args, dir_str: str) -> int:
    dir_path = Path(dir_str)
    if not dir_path.is_dir():
        print(f"Not a directory: {dir_path}", file=sys.stderr)
        return 1

    zips = sorted(dir_path.glob('*.zip'))
    if not zips:
        print("No ZIP files found in directory.")
        return 0

    # Pre-scan all ZIPs to get the total XML count before processing starts
    print(f"\n{_B}Scanning{_R}  {_CYN}{dir_path}{_R} ...", end='', flush=True)
    manifest: list[tuple[Path, list[str] | None]] = []
    total_xmls = 0
    for z in zips:
        try:
            with zipfile.ZipFile(z, 'r') as zf:
                names = [n for n in zf.namelist() if n.endswith('.xml') and not n.endswith('/')]
            manifest.append((z, names))
            total_xmls += len(names)
        except zipfile.BadZipFile:
            manifest.append((z, None))

    n_zips = len(manifest)
    print(
        f"\r{_B}Found{_R}  {_CYN}{n_zips} ZIP{'s' if n_zips != 1 else ''}{_R}  /  "
        f"{_CYN}{total_xmls} XML file{'s' if total_xmls != 1 else ''}{_R}{_CLR}\n"
    )

    if total_xmls == 0 and all(x is not None for _, x in manifest):
        print("No XML files found inside any ZIP.")
        return 0

    t_start = time.monotonic()
    ctx = _Ctx(n_zips=n_zips, total_xmls=total_xmls, workers=args.workers)
    db = ScoreDatabase()
    router = UploadRouter(db=db, secure_by_default=True)

    db.begin_bulk_load()
    db.drop_ingest_indexes()

    if args.workers == 1:
        for zip_idx, (zip_path, xml_names) in enumerate(manifest, 1):
            _process_zip(db, router, None, ctx, zip_idx, zip_path, xml_names)
    else:
        ctx.next_filing_id = _seed_filing_id(db)
        print(f"{_DIM}Using {args.workers} worker processes{_R}\n")
        with ProcessPoolExecutor(
            max_workers=args.workers,
            initializer=_worker_init,
            initargs=(router.xpath_index, router.supported_forms),
        ) as pool:
            for zip_idx, (zip_path, xml_names) in enumerate(manifest, 1):
                _process_zip(db, router, pool, ctx, zip_idx, zip_path, xml_names)

    t_process = time.monotonic()
    return _finish_run(args, ctx, db, t_start, t_process)


def _cmd_ingest_url(args, source: str) -> int:
    source = source.strip()
    try:
        urls = sources.discover_zip_urls(source)
    except Exception as exc:
        print(f"Failed to read {source}: {exc}", file=sys.stderr)
        return 1

    if not urls:
        print(f"No ZIP links found at {source}")
        return 0

    db = ScoreDatabase()
    recorded = set() if getattr(args, 'force', False) else db.get_ingested_sources()
    todo = [u for u in urls if u not in recorded]
    skipped = len(urls) - len(todo)

    print(f"\n{_B}Source{_R}  {_CYN}{source}{_R}")
    print(
        f"{_B}Found{_R}  {_CYN}{len(urls)} ZIP link{'s' if len(urls) != 1 else ''}{_R}"
        + (f"  {_DIM}({skipped} already ingested){_R}" if skipped else "")
    )

    if getattr(args, 'list_sources', False):
        print()
        for u in urls:
            tag = f"{_GRN}ingested{_R}" if u in recorded else f"{_YLW}new     {_R}"
            print(f"  {tag}  {u}")
        print()
        db.close()
        return 0

    if not todo:
        print(f"\n{_DIM}Nothing new to ingest.{_R}\n")
        db.close()
        return 0

    print(f"{_B}To ingest{_R}  {_CYN}{len(todo)}{_R}\n")

    keep = getattr(args, 'keep_downloads', False)
    cache_arg = getattr(args, 'cache_dir', None)
    if cache_arg:
        cache_dir = Path(cache_arg)
        cache_dir.mkdir(parents=True, exist_ok=True)
        created_tmp = False
    else:
        cache_dir = Path(tempfile.mkdtemp(prefix='openreturn-dl-'))
        created_tmp = True

    ctx = _Ctx(n_zips=len(todo), total_xmls=0, workers=args.workers)
    router = UploadRouter(db=db, secure_by_default=True)
    db.begin_bulk_load()
    db.drop_ingest_indexes()

    t_start = time.monotonic()
    if args.workers == 1:
        for idx, url in enumerate(todo, 1):
            _ingest_one_remote(db, router, None, ctx, idx, url, cache_dir, keep)
    else:
        ctx.next_filing_id = _seed_filing_id(db)
        print(f"{_DIM}Using {args.workers} worker processes{_R}\n")
        with ProcessPoolExecutor(
            max_workers=args.workers,
            initializer=_worker_init,
            initargs=(router.xpath_index, router.supported_forms),
        ) as pool:
            for idx, url in enumerate(todo, 1):
                _ingest_one_remote(db, router, pool, ctx, idx, url, cache_dir, keep)

    t_process = time.monotonic()
    rc = _finish_run(args, ctx, db, t_start, t_process)

    if created_tmp:
        if keep:
            print(f"{_DIM}Downloads kept in {cache_dir}{_R}")
        else:
            shutil.rmtree(cache_dir, ignore_errors=True)
    return rc


def _ingest_one_remote(db, router, pool, ctx, idx, url, cache_dir, keep) -> None:
    """Download one remote ZIP, ingest it, record it, and (unless ``keep``)
    delete it. Download/scan failures are counted and skipped without aborting
    the run; only a ZIP that actually processed is recorded."""
    try:
        zip_path, meta = sources.download_zip(url, cache_dir)
    except Exception as exc:
        print(f"  {_RED}download failed{_R}  {_CYN}{url}{_R}  {_DIM}{exc}{_R}")
        ctx.totals['error'] += 1
        return

    try:
        with zipfile.ZipFile(zip_path, 'r') as zf:
            xml_names = [n for n in zf.namelist() if n.endswith('.xml') and not n.endswith('/')]
    except zipfile.BadZipFile:
        xml_names = None

    if xml_names is not None:
        ctx.total_xmls += len(xml_names)

    per = _process_zip(db, router, pool, ctx, idx, zip_path, xml_names)

    if xml_names is not None:
        db.record_ingested_zip(
            url, url=url, filename=zip_path.name,
            etag=meta.get('etag'), last_modified=meta.get('last_modified'),
            content_length=meta.get('content_length'), filings_stored=per['stored'],
        )

    if not keep:
        try:
            zip_path.unlink()
        except OSError:  # pragma: no cover — best-effort cleanup
            pass


def _add_ingest_arguments(ap) -> None:
    """Register the ingest flags on ``ap``. Used by this module's standalone
    ``main()``; the unified ``openreturn ingest`` subcommand in ``cli.py``
    declares the same flags inline (to avoid importing this module at parse
    time), so keep the two in sync."""
    ap.add_argument(
        'directory',
        help='Path to a directory of .zip files, or an http(s):// URL to a ZIP '
             'or to the IRS Form 990 series downloads page',
    )
    ap.add_argument(
        '--workers', type=int, default=os.cpu_count() or 4,
        help='Parallel XML parser processes (default: CPU count)',
    )
    ap.add_argument(
        '--profile', action='store_true',
        help='Print a per-phase wall-clock breakdown of the parallel ingest',
    )
    ap.add_argument(
        '--force', action='store_true',
        help='(URL sources) re-ingest archives even if already recorded as processed',
    )
    ap.add_argument(
        '--keep-downloads', dest='keep_downloads', action='store_true',
        help='(URL sources) keep downloaded ZIPs instead of deleting after ingest',
    )
    ap.add_argument(
        '--cache-dir', dest='cache_dir', default=None,
        help='(URL sources) directory to download ZIPs into (default: a temp dir, removed after)',
    )
    ap.add_argument(
        '--list', dest='list_sources', action='store_true',
        help='(URL sources) list discovered ZIP URLs and whether each is already ingested, then exit',
    )


def main() -> int:
    ap = argparse.ArgumentParser(
        prog='openreturn-ingest',
        description='Bulk-ingest 990 ZIP files into OpenReturn from a directory or URL.',
    )
    _add_ingest_arguments(ap)
    args = ap.parse_args()
    return cmd_ingest(args)


if __name__ == '__main__':  # pragma: no cover
    sys.exit(main())
