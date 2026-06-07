#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3

import argparse
import subprocess
import sys
import zipfile
from pathlib import Path

from console import _B, _R, _DIM, _CYN, _GRN, _RED, _YLW, _CLR
from database.Score import ScoreDatabase
from router.Upload import UploadRouter


def _bar(done: int, total: int, width: int = 35) -> str:
    pct = done / total if total else 0
    filled = int(width * pct)
    return f"[{'█' * filled}{'░' * (width - filled)}] {pct * 100:5.1f}%"


def _trunc(s: str, n: int) -> str:
    return s if len(s) <= n else '…' + s[-(n - 1):]


def main() -> int:
    ap = argparse.ArgumentParser(
        prog='openreturn-ingest',
        description='Bulk-ingest a directory of 990 ZIP files into OpenReturn.',
    )
    ap.add_argument('directory', help='Path to a directory of .zip files')
    args = ap.parse_args()

    if not Path('IRS990.db').exists():
        print(
            "IRS990.db not found — run openreturn-ingest from the server's data directory.",
            file=sys.stderr,
        )
        return 1

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

    totals = {'stored': 0, 'skipped': 0, 'error': 0}
    done = 0

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
                                ['unzip', '-p', str(zip_path), name],
                                capture_output=True,
                            )
                            xml_bytes = proc.stdout
                        result = router._process_xml(
                            xml_bytes.decode('utf-8'), name, zip_filename=zip_path.name
                        )
                    except Exception as exc:
                        result = {'file': name, 'status': 'error', 'reason': str(exc)}

                    status = result.get('status', 'error')
                    per[status] = per.get(status, 0) + 1
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

    bar = _bar(done, total_xmls)
    err_color = _RED if totals['error'] else _DIM
    print(
        f"{_B}Complete{_R}  {bar}\n"
        f"  {_GRN}stored  {totals['stored']}{_R}\n"
        f"  {_YLW}skipped {totals['skipped']}{_R}\n"
        f"  {err_color}errors  {totals['error']}{_R}\n"
    )

    db.close()
    return 0


if __name__ == '__main__':  # pragma: no cover
    sys.exit(main())
