#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3

import argparse
import os
import sys
import time
import uuid
import zipfile
from collections import defaultdict
from concurrent.futures import ProcessPoolExecutor, as_completed
from pathlib import Path

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


def cmd_ingest(args) -> int:
    dir_path = Path(args.directory)
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
    zw = len(str(n_zips))
    print(
        f"\r{_B}Found{_R}  {_CYN}{n_zips} ZIP{'s' if n_zips != 1 else ''}{_R}  /  "
        f"{_CYN}{total_xmls} XML file{'s' if total_xmls != 1 else ''}{_R}{_CLR}\n"
    )

    if total_xmls == 0 and all(x is not None for _, x in manifest):
        print("No XML files found inside any ZIP.")
        return 0

    t_start = time.monotonic()
    db = ScoreDatabase()
    router = UploadRouter(db=db, secure_by_default=True)

    db.begin_bulk_load()
    db.drop_ingest_indexes()

    totals = {'stored': 0, 'skipped': 0, 'error': 0}
    done = 0
    # Per-phase wall-clock accumulators (parallel path); printed with --profile.
    prof: dict = defaultdict(float)

    if args.workers == 1:
        # ---------------------------------------------------------------
        # Sequential path — one file at a time using router._process_xml
        # ---------------------------------------------------------------
        for zip_idx, (zip_path, xml_names) in enumerate(manifest, 1):
            n_xml = len(xml_names) if xml_names is not None else 0
            fw = len(str(n_xml)) if n_xml else 1
            zip_hdr = (
                f"{_B}[ZIP {zip_idx:{zw}}/{n_zips}]{_R}  "
                f"{_CYN}{zip_path.name}{_R}  "
                f"{_DIM}({n_xml} file{'s' if n_xml != 1 else ''}){_R}"
            )

            if xml_names is None:
                print(f"{zip_hdr}  {_RED}invalid ZIP — skipped{_R}")
                totals['error'] += 1
                continue

            print(zip_hdr)

            if n_xml == 0:
                print(f"  {_DIM}no XML files{_R}\n")
                continue

            per = {'stored': 0, 'skipped': 0, 'error': 0}

            try:
                with MemberReader(zip_path) as reader:
                    for file_idx, name in enumerate(xml_names, 1):
                        bar = _bar(done, total_xmls)
                        status_line = (
                            f"  [{file_idx:{fw}}/{n_xml}]  {_trunc(name, 50)}  "
                            f"{bar}  ({done}/{total_xmls})"
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
                        per[status]    = per.get(status, 0) + 1
                        totals[status] = totals.get(status, 0) + 1
                        done += 1

            except zipfile.BadZipFile:
                print(f"\r  {_RED}corrupt ZIP — skipping remaining files{_R}{_CLR}")
                totals['error'] += 1
                print()
                continue

            bar = _bar(done, total_xmls)
            err_color = _RED if per['error'] else _DIM
            print(
                f"\r  {_GRN}stored {per['stored']}{_R}  "
                f"{_YLW}skipped {per['skipped']}{_R}  "
                f"{err_color}errors {per['error']}{_R}  "
                f"{bar}  ({done}/{total_xmls}){_CLR}"
            )
            print()

    else:
        # ---------------------------------------------------------------
        # Parallel path — XML parsing in worker processes, DB writes batched per ZIP
        # ---------------------------------------------------------------
        print(f"{_DIM}Using {args.workers} worker processes{_R}\n")

        seen_eins: set[str] = set()
        # Assign integer filing_ids client-side (the bulk insert builds
        # reported_data rows before the filing rows hit the DB, so we can't use
        # autoincrement). Seed past the current max; ingest holds an exclusive
        # lock so no other writer competes.
        _row = db.cursor.execute("SELECT COALESCE(MAX(filing_id), 0) FROM filing").fetchone()
        next_filing_id = (_row[0] if _row and isinstance(_row[0], int) else 0) + 1

        with ProcessPoolExecutor(
            max_workers=args.workers,
            initializer=_worker_init,
            initargs=(router.xpath_index, router.supported_forms),
        ) as pool:
            for zip_idx, (zip_path, xml_names) in enumerate(manifest, 1):
                n_xml = len(xml_names) if xml_names is not None else 0
                zip_hdr = (
                    f"{_B}[ZIP {zip_idx:{zw}}/{n_zips}]{_R}  "
                    f"{_CYN}{zip_path.name}{_R}  "
                    f"{_DIM}({n_xml} file{'s' if n_xml != 1 else ''}){_R}"
                )

                if xml_names is None:
                    print(f"{zip_hdr}  {_RED}invalid ZIP — skipped{_R}")
                    totals['error'] += 1
                    continue

                print(zip_hdr)

                if n_xml == 0:
                    print(f"  {_DIM}no XML files{_R}\n")
                    continue

                per                = {'stored': 0, 'skipped': 0, 'error': 0}
                pending_orgs       : list[tuple] = []
                pending_filings    : list[tuple] = []
                filing_key_to_id   : dict[tuple, int] = {}
                id_remap           : dict[int, int] = {}
                pending_data       : list[tuple] = []
                zip_read0          = prof['read']

                # Read each XML in this process and hand the bytes to workers
                # (workers do no I/O), grouped into batches to amortize IPC.
                # Read one chunk of files at a time so at most chunk_sz files'
                # bytes are in flight at once, bounding memory.
                chunk_sz = args.workers * _BATCH_FILES * 2
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
                                    prof['read'] += time.monotonic() - _tr
                                except Exception:
                                    per['error'] += 1
                                    totals['error'] += 1
                                    done += 1
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
                                    totals['error'] += n
                                    done += n
                                    continue

                                for parsed in results:
                                    status = parsed.get('status', 'error')

                                    if status == 'parsed':
                                        try:
                                            ein       = parsed['ein']
                                            year      = parsed['year']
                                            form_code = parsed['form_code']
                                            key       = (ein, year, form_code)

                                            if ein not in seen_eins:
                                                pending_orgs.append((ein, parsed['name']))
                                                seen_eins.add(ein)

                                            if key not in filing_key_to_id:
                                                pre_id = next_filing_id
                                                next_filing_id += 1
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

                                    per[status]    = per.get(status, 0) + 1
                                    totals[status] = totals.get(status, 0) + 1
                                    done += 1

                                bar = _bar(done, total_xmls)
                                print(
                                    f"\r  {_GRN}{per['stored']}{_R} stored  {bar}  ({done}/{total_xmls}){_CLR}",
                                    end='', flush=True,
                                )

                                if len(pending_data) >= _DATA_ROWS_PER_FLUSH:
                                    _flush_zip(db, pending_orgs, pending_filings, pending_data, id_remap, prof)
                                    pending_orgs.clear()
                                    pending_filings.clear()
                                    pending_data.clear()
                except zipfile.BadZipFile:
                    print(f"\r  {_RED}corrupt ZIP — skipping remaining files{_R}{_CLR}")
                    totals['error'] += 1

                _flush_zip(db, pending_orgs, pending_filings, pending_data, id_remap, prof)
                _tc = time.monotonic()
                db.cursor.execute("PRAGMA wal_checkpoint(TRUNCATE)")
                prof['checkpoint'] += time.monotonic() - _tc

                zip_read_ms = (prof['read'] - zip_read0) / n_xml * 1000 if n_xml else 0
                bar = _bar(done, total_xmls)
                err_color = _RED if per['error'] else _DIM
                print(
                    f"\r  {_GRN}stored {per['stored']}{_R}  "
                    f"{_YLW}skipped {per['skipped']}{_R}  "
                    f"{err_color}errors {per['error']}{_R}  "
                    f"{_DIM}read {zip_read_ms:.2f}ms/file{_R}  "
                    f"{bar}  ({done}/{total_xmls}){_CLR}"
                )
                print()

    t_process = time.monotonic()

    bar = _bar(done, total_xmls)
    err_color = _RED if totals['error'] else _DIM
    print(
        f"{_B}Complete{_R}  {bar}\n"
        f"  {_GRN}stored  {totals['stored']}{_R}\n"
        f"  {_YLW}skipped {totals['skipped']}{_R}\n"
        f"  {err_color}errors  {totals['error']}{_R}\n"
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
    rate        = done / process_s if process_s else 0
    print(
        f"{_B}Timing{_R}  {_CYN}{args.workers} worker{'s' if args.workers != 1 else ''}{_R}\n"
        f"  {_DIM}process  {_R}{_fmt_duration(process_s)}  "
        f"{_DIM}({rate:,.0f} filings/s){_R}\n"
        f"  {_DIM}finalize {_R}{_fmt_duration(finalize_s)}  {_DIM}(index rebuild + checkpoint){_R}\n"
        f"  {_B}total    {_R}{_fmt_duration(total_s)}\n"
    )

    if getattr(args, 'profile', False) and args.workers != 1:
        accounted = (prof['read'] + prof['flush_resolve'] + prof['flush_insert']
                     + prof['flush_commit'] + prof['checkpoint'])
        other = max(0.0, process_s - accounted)
        rows = [
            ('read (decompress)',        prof['read']),
            ('insert reported_data',     prof['flush_insert']),
            ('resolve filing uuids',     prof['flush_resolve']),
            ('commit',                   prof['flush_commit']),
            ('wal checkpoint (per-zip)', prof['checkpoint']),
            ('worker wait + collect',    other),
        ]
        print(f"{_B}Profile{_R}  {_DIM}(share of {_fmt_duration(process_s)} process time){_R}")
        for label, secs in sorted(rows, key=lambda r: -r[1]):
            pct = 100 * secs / process_s if process_s else 0
            print(f"  {_DIM}{label:24}{_R}{_fmt_duration(secs):>10}  {pct:5.1f}%")
        print()
    return 0


def main() -> int:
    ap = argparse.ArgumentParser(
        prog='openreturn-ingest',
        description='Bulk-ingest a directory of 990 ZIP files into OpenReturn.',
    )
    ap.add_argument('directory', help='Path to a directory of .zip files')
    ap.add_argument(
        '--workers', type=int, default=os.cpu_count() or 4,
        help='Parallel XML parser processes (default: CPU count)',
    )
    ap.add_argument(
        '--profile', action='store_true',
        help='Print a per-phase wall-clock breakdown of the parallel ingest',
    )
    args = ap.parse_args()
    return cmd_ingest(args)


if __name__ == '__main__':  # pragma: no cover
    sys.exit(main())
