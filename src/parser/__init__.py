from __future__ import annotations
from typing import TypedDict, TypeAlias

import xml.etree.ElementTree as ET

class TreeNode(TypedDict):
    text: str
    children: list[dict[str, TreeNode]]

Tree: TypeAlias = dict[str, TreeNode]

class Parser:
  def __init__(self, xmlstr: str, namespace: dict[str, str], nsFind: str) -> None:
    self.root = ET.fromstring(xmlstr)
    self.ns = namespace
    self.nsFind = nsFind

  def getElem(self, path: str) -> str | None:
    chunks = path.split("/")
    findStr = "./"
    for chunk in chunks:
      findStr = findStr + self.nsFind + chunk

    elem = self.root.find(findStr, self.ns)

    if type(elem) is ET.Element:
      innerText = elem.text
      if type(innerText) is str:
        return innerText

    return None

  def tree(self, depth: int = -1, tagStrip: str = "") -> Tree:
    return self.__tree(self.root, depth, 1, tagStrip)

  def __tree(self, root: ET.Element, depth: int, currentDepth: int, tagStrip: str) -> Tree:
    tag: str = root.tag.removeprefix(tagStrip)
    txt: str = root.text.strip() if root.text is not None else ""

    dataTree: Tree = {
      tag: {
        "text": txt,
        "children": []
      }
    }

    for child in root:
      if (currentDepth < depth or depth == -1):
        returnTree: Tree = self.__tree(child, depth, currentDepth + 1, tagStrip)
        dataTree[tag]["children"].append(returnTree)

    return dataTree
