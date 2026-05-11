import zipfile as zf

class Unzipper:
  def __init__(self, path) -> None:
    if not zf.is_zipfile(path):
      raise Exception("Invalid ZIP File", "Please provide a valid zipfile")
    self.path = path
    self.unzippedFile = zf.ZipFile(path)
    self.files = self.unzippedFile.namelist()
    self.index = -1

  def __iter__(self):
    return self

  def __next__(self):
    self.index += 1
    if self.index >= len(self.files):
      raise StopIteration
    return self

  def read(self) -> str:
    with self.unzippedFile.open(self.files[self.index]) as f:
      content = f.read().decode()
      return content

  def name(self) -> str:
    with self.unzippedFile.open(self.files[self.index]) as f:
      return f.name
