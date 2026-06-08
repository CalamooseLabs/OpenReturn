#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3

import argparse
import os
import subprocess
import sys
import uuid
import zipfile
from concurrent.futures import ProcessPoolExecutor, as_completed
from pathlib import Path

from console import _B, _R, _DIM, _CYN, _GRN, _RED, _YLW, _CLR
from database.Score import ScoreDatabase
from router.Upload import UploadRouter
from router.Upload.upload import _worker_init, _parse_xml_task

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


def _resolve_uuids(db, filing_key_to_uuid: dict) -> dict:
    """Return {pre_uuid: actual_uuid} for any filings where INSERT OR IGNORE hit an existing row."""
    db.cursor.execute(
        "CREATE TEMP TABLE IF NOT EXISTS _key_resolve (ein TEXT, year INT, form_code TEXT)"
    )
    db.cursor.execute("DELETE FROM _key_resolve")
    db.cursor.executemany("INSERT INTO _key_resolve VALUES (?,?,?)", filing_key_to_uuid.keys())
    rows = db.cursor.execute("""
        SELECT f.organization_id, f.year, f.form_code, f.uuid
        FROM filing f
        JOIN _key_resolve k
          ON k.ein = f.organization_id
         AND k.year = f.year
         AND k.form_code = f.form_code
    """).fetchall()
    remap = {}
    for ein, year, form_code, actual_uuid in rows:
        pre_uuid = filing_key_to_uuid[(ein, year, form_code)]
        if actual_uuid != pre_uuid:
            remap[pre_uuid] = actual_uuid
    return remap


def _flush_zip(db, pending_orgs, pending_filings, filing_key_to_uuid, pending_data) -> None:
    if pending_orgs:
        db.cursor.executemany(
            "INSERT OR IGNORE INTO organization (ein, name) VALUES (?,?)",
            pending_orgs
        )
    if pending_filings:
        db.cursor.executemany(
            "INSERT OR IGNORE INTO filing "
            "(uuid, year, organization_id, form_code, xml_filename, zip_filename) "
            "VALUES (?,?,?,?,?,?)",
            pending_filings
        )
        uuid_remap = _resolve_uuids(db, filing_key_to_uuid)
        if uuid_remap:
            pending_data[:] = [
                (uuid_remap.get(r[0], r[0]), r[1], r[2]) for r in pending_data
            ]
    if pending_data:
        db.cursor.executemany(_INSERT_REPORTED_DATA, pending_data)
    db.commit()


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

    db = ScoreDatabase()
    router = UploadRouter(db=db, secure_by_default=True)

    db.begin_bulk_load()
    db.drop_ingest_indexes()

    totals = {'stored': 0, 'skipped': 0, 'error': 0}
    done = 0

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
                with zipfile.ZipFile(zip_path, 'r') as zf:
                    for file_idx, name in enumerate(xml_names, 1):
                        bar = _bar(done, total_xmls)
                        status_line = (
                            f"  [{file_idx:{fw}}/{n_xml}]  {_trunc(name, 50)}  "
                            f"{bar}  ({done}/{total_xmls})"
                        )
                        print(f"\r{status_line}{_CLR}", end='', flush=True)

                        try:
                            try:
                                with zf.open(name) as f:
                                    xml_bytes = f.read()
                            except NotImplementedError:
                                proc = subprocess.run(
                                    ['unzip', '-p', '--', str(zip_path), name],
                                    capture_output=True,
                                )
                                xml_bytes = proc.stdout
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
        chunk_sz = args.workers * 8
        print(f"{_DIM}Using {args.workers} worker processes{_R}\n")

        seen_eins: set[str] = set()

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
                filing_key_to_uuid : dict[tuple, str] = {}
                pending_data       : list[tuple] = []

                zip_path_str = str(zip_path)
                for start in range(0, n_xml, chunk_sz):
                    chunk   = xml_names[start:start + chunk_sz]
                    futures = {
                        pool.submit(_parse_xml_task, (zip_path_str, name, zip_path.name)): name
                        for name in chunk
                    }

                    for fut in as_completed(futures):
                        name   = futures[fut]
                        try:
                            parsed = fut.result()
                        except Exception as exc:
                            per['error'] += 1
                            totals['error'] += 1
                            done += 1
                            continue
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

                                if key not in filing_key_to_uuid:
                                    pre_uuid = str(uuid.uuid4())
                                    filing_key_to_uuid[key] = pre_uuid
                                    pending_filings.append((
                                        pre_uuid, year, ein, form_code,
                                        parsed['file'], parsed['zip_filename'],
                                    ))

                                pre_uuid = filing_key_to_uuid[key]
                                pending_data.extend(
                                    (pre_uuid, fid, v)
                                    for fid, v in parsed['values'].items()
                                )
                                status = 'stored'
                            except Exception as exc:
                                status = 'error'

                        per[status]    = per.get(status, 0) + 1
                        totals[status] = totals.get(status, 0) + 1
                        done += 1

                        bar = _bar(done, total_xmls)
                        print(
                            f"\r  {_trunc(name, 50)}  {bar}  ({done}/{total_xmls}){_CLR}",
                            end='', flush=True,
                        )

                    if len(pending_data) >= _DATA_ROWS_PER_FLUSH:
                        _flush_zip(db, pending_orgs, pending_filings, filing_key_to_uuid, pending_data)
                        pending_orgs.clear()
                        pending_filings.clear()
                        pending_data.clear()

                _flush_zip(db, pending_orgs, pending_filings, filing_key_to_uuid, pending_data)
                db.cursor.execute("PRAGMA wal_checkpoint(RESTART)")

                bar = _bar(done, total_xmls)
                err_color = _RED if per['error'] else _DIM
                print(
                    f"\r  {_GRN}stored {per['stored']}{_R}  "
                    f"{_YLW}skipped {per['skipped']}{_R}  "
                    f"{err_color}errors {per['error']}{_R}  "
                    f"{bar}  ({done}/{total_xmls}){_CLR}"
                )
                print()

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
    args = ap.parse_args()
    return cmd_ingest(args)


if __name__ == '__main__':  # pragma: no cover
    sys.exit(main())
