from parser import Parser

class IRS990Parser(Parser):
  namespace =  {'irs': 'http://www.irs.gov/efile'}
  nsFind = "/irs:"

  supportedForms = ["990", "990PF", "990T"]

  def __init__(self, xmlstr: str) -> None:
    super().__init__(xmlstr, self.namespace, self.nsFind)

  def __split_words(self, tag: str) -> str:
    wordList: list[str] = []
    currWord: str = tag[0]

    for xIdx in range(1, len(tag) - 1):
      clearWord: bool = False
      edgeAdd: bool = False
      prev, curr, next = tag[xIdx-1:xIdx+2]

      currWord += curr
      if not curr.isdigit():
        if next.isdigit():
          clearWord = True
        else:
          if next.isupper():
            if not curr.isupper():
              clearWord = True
          else:
            if curr.isupper() and prev.isupper():
              clearWord = True
              edgeAdd = True
              currWord = currWord[:-1]

      if (clearWord):
        wordList.append(currWord)
        currWord = ""

      if (edgeAdd):
        currWord += curr

    currWord += tag[len(tag)-1]
    wordList.append(currWord)

    return ' '.join(wordList)

  def cleanTags(self, xTree):
    cleanedTree = {}
    for tag in xTree:
      cleanedTree[self.__split_words(tag)] = xTree[tag]

    return cleanedTree

  def dict(self, depth: int = -1):
    tree = super().tree(depth, "{%s}" % self.namespace["irs"])
    return tree
