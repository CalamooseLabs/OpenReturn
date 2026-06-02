import os
import shutil
import subprocess
import tempfile
import zipfile as zf


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
