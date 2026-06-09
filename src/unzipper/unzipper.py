import os
import shutil
import subprocess
import tempfile
import zipfile as zf


class MemberReader:
  """Reads ZIP members by name as bytes.

  Supported archives are read directly via ``zipfile``. For archives whose
  compression Python cannot decode (e.g. Deflate64, common in IRS TEOS ZIPs),
  the *whole* archive is extracted once with ``unzip`` and members are served
  from the extraction directory. This avoids spawning an ``unzip -p``
  subprocess per file — at ~21 ms/spawn over hundreds of thousands of files
  that fallback dominated bulk-ingest wall-clock.

  The extraction dir is created under TMPDIR (tmpfs/RAM on most systems), so
  the extracted files are read straight from memory. Use as a context manager
  (or call close()) to clean it up.
  """

  def __init__(self, zip_path) -> None:
    self.zip_path = str(zip_path)
    self._zip = zf.ZipFile(self.zip_path)
    self._extract_dir: str | None = None

  def namelist(self) -> list[str]:
    return self._zip.namelist()

  def read(self, name: str) -> bytes:
    if self._extract_dir is None:
      try:
        return self._zip.read(name)
      except NotImplementedError:
        # Unsupported compression — extract the whole archive once, then
        # serve this and every subsequent member from disk.
        self._extract_all()
    # Guard against zip-slip: a malicious member name (e.g. '../../etc/passwd')
    # could otherwise resolve outside the extraction dir and read an arbitrary
    # file. Reject any name that escapes the extraction root.
    root = os.path.realpath(self._extract_dir)
    target = os.path.realpath(os.path.join(root, name))
    if target != root and not target.startswith(root + os.sep):
      raise ValueError(f"unsafe ZIP member path: {name!r}")
    with open(target, 'rb') as f:
      return f.read()

  def _extract_all(self) -> None:
    self._extract_dir = tempfile.mkdtemp(prefix='openreturn-zip-')
    subprocess.run(
      ['unzip', '-o', '-qq', '--', self.zip_path, '-d', self._extract_dir],
      capture_output=True,
    )

  def __enter__(self) -> "MemberReader":
    return self

  def __exit__(self, *exc) -> None:
    self.close()

  def close(self) -> None:
    self._zip.close()
    if self._extract_dir:
      shutil.rmtree(self._extract_dir, ignore_errors=True)
      self._extract_dir = None


class Unzipper:
  def __init__(self, path) -> None:
    self.path = path
    self._zip = None
    self._tmpdir = None
    self._paths = None

    try:
      if not zf.is_zipfile(path):
        raise zf.BadZipFile()
      self._zip = zf.ZipFile(path)
      self.files = [f for f in self._zip.namelist() if not f.endswith('/')]
      # Probe the first entry — some ZIPs have a valid central directory but
      # corrupt local file headers that only surface on open().
      if self.files:
        with self._zip.open(self.files[0]) as f:
          f.read(1)
    except (zf.BadZipFile, NotImplementedError):
      if self._zip:
        self._zip.close()
        self._zip = None
      self._extract_with_unzip(path)

    self.index = -1

  def _extract_with_unzip(self, path):
    self._tmpdir = tempfile.mkdtemp()
    result = subprocess.run(
      ['unzip', '-o', path, '-d', self._tmpdir],
      capture_output=True
    )

    self.files = []
    self._paths = []
    for root, _, filenames in os.walk(self._tmpdir):
      for filename in filenames:
        abs_path = os.path.join(root, filename)
        if os.path.islink(abs_path):
          continue
        rel_path = os.path.relpath(abs_path, self._tmpdir)
        self.files.append(rel_path)
        self._paths.append(abs_path)

    # unzip exits 1 for minor warnings and sometimes 2-3 for recoverable header
    # quirks (common in IRS-released ZIPs) while still extracting all files.
    # Only treat a non-zero exit as fatal when nothing was extracted at all.
    if result.returncode > 1 and not self.files:
      shutil.rmtree(self._tmpdir, ignore_errors=True)
      self._tmpdir = None
      self.files = []
      self._paths = []
      raise ValueError(f"Could not open ZIP file (unzip exit {result.returncode}): {path}")

  def close(self):
    if self._zip:
      self._zip.close()
      self._zip = None
    if self._tmpdir:
      shutil.rmtree(self._tmpdir, ignore_errors=True)
      self._tmpdir = None

  def __iter__(self):
    return self

  def __next__(self):
    self.index += 1
    if self.index >= len(self.files):
      raise StopIteration
    return self

  def read(self) -> str:
    if self._zip:
      with self._zip.open(self.files[self.index]) as f:
        return f.read().decode()
    with open(self._paths[self.index], 'rb') as f:
      return f.read().decode()

  def name(self) -> str:
    return self.files[self.index]
