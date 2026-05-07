from __future__ import annotations
from typing import TypedDict, TypeAlias

import xml.etree.ElementTree as ET

class TreeNode(TypedDict):
    text: str
    children: list[dict[str, TreeNode]]

Tree: TypeAlias = dict[str, TreeNode]
CleanTree: TypeAlias = dict[str, str]

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

  def tree(self, depth: int = -1, tagStrip: str = "", groupSkip: list[str] = []) -> tuple[Tree, CleanTree]:
    return self.__tree(self.root, depth, 1, tagStrip, groupSkip)

  def __tree(self, root: ET.Element, depth: int, currentDepth: int, tagStrip: str, groupSkip: list[str]) -> tuple[Tree, CleanTree]:
    tag: str = root.tag.removeprefix(tagStrip)
    txt: str = root.text.strip() if root.text is not None else ""

    if (tag in groupSkip):
      return {},{}

    dataTree: Tree = {
      tag: {
        "text": txt,
        "children": []
      }
    }

    cleanTree: CleanTree = {}
    if (txt != ""):
      cleanTree = {
        tag: txt
      }

    for child in root:
      if (currentDepth < depth or depth == -1):
        returnTree: tuple[Tree, CleanTree] = self.__tree(child, depth, currentDepth + 1, tagStrip, groupSkip)
        dataTree[tag]["children"].append(returnTree[0])
        cleanTree.update(returnTree[1])

    return dataTree, cleanTree
