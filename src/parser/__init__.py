import xml.etree.ElementTree as ET

class Parser:
  def __init__(self, xmlstr: str, namespace: dict[str, str], nsFind: str) -> None:
    self.root = ET.fromstring(xmlstr)
    self.ns = namespace
    self.nsFind = nsFind

  def getElem(self, path: str) -> str:
    chunks = path.split("/")
    findStr = "./"
    for chunk in chunks:
      findStr = findStr + self.nsFind + chunk

    elem = self.root.find(findStr, self.ns)

    if type(elem) is ET.Element:
      innerText = elem.text
      if type(innerText) is str:
        return innerText

    raise Exception("Parser Error", "Most likely an invalid path")
