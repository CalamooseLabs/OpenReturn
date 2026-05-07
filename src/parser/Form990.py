from parser import Parser

class Form990Parser(Parser):
  namespace =  {'irs': 'http://www.irs.gov/efile'}
  nsFind = "/irs:"

  supportedForms = ["990", "990PF", "990T"]

  headerPaths: dict[str, str] = {
    "ein": "ReturnHeader/Filer/EIN",
    "name": "ReturnHeader/Filer/BusinessName/BusinessNameLine1Txt",
    "return_type": "ReturnHeader/ReturnTypeCd",
    "tax_year": "ReturnHeader/TaxYr"
  }

  dataPaths = {
    "990": {
      "total_expenses": ["ReturnData/IRS990/TotalFunctionalExpensesGrp/TotalAmt"],
      "program_expenses": ["ReturnData/IRS990/TotalFunctionalExpensesGrp/ProgramServicesAmt"],
      "management_expenses": ["ReturnData/IRS990/TotalFunctionalExpensesGrp/ManagementAndGeneralAmt"],
      "fundraising_expenses": ["ReturnData/IRS990/TotalFunctionalExpensesGrp/FundraisingAmt"],
      "contributions": ["ReturnData/IRS990/CYContributionsGrantsAmt"],
      "government_grants": ["ReturnData/IRS990/GovernmentGrantsAmt"],
      "surplus_revenue": ["ReturnData/IRS990/CYRevenuesLessExpensesAmt"],
      "liabilities": ["ReturnData/IRS990/TotalLiabilitiesEOYAmt"],
      "assets": ["ReturnData/IRS990/NetAssetsOrFundBalancesEOYAmt"],
      "working_capital": [
        "ReturnData/IRS990/CashNonInterestBearingGrp/EOYAmt",
        "ReturnData/IRS990/SavingsAndTempCashInvstGrp/EOYAmt",
        "ReturnData/IRS990/unknown/EOYAmt",
        "ReturnData/IRS990/unknown/EOYAmt",
        "ReturnData/IRS990/unknown/EOYAmt",
        "ReturnData/IRS990/unknown/EOYAmt",
        "ReturnData/IRS990/unknown/EOYAmt"
      ],
      "investment_income": ["ReturnData/IRS990/CYInvestmentIncomeAmt"],
      "investments_made": [
        "ReturnData/IRS990/CashNonInterestBearingGrp/EOYAmt",
        "ReturnData/IRS990/SavingsAndTempCashInvstGrp/EOYAmt",
        "ReturnData/IRS990/unknown/EOYAmt",
        "ReturnData/IRS990/unknown/EOYAmt",
        "ReturnData/IRS990/unknown/EOYAmt",
      ],
      "equity": ["ReturnData/IRS990/NetAssetsOrFundBalancesEOYAmt"]
    }
  }

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

  def extract(self, formType = "990"):
    extractedData = {}
    for key, path in self.headerPaths.items():
      val = super().getElem(path)
      extractedData[key] = val.title() if type(val) is str else ""

    for key, paths in self.dataPaths[formType].items():
      finalVal = 0
      for path in paths:
        val = super().getElem(path)
        finalVal += int(val if val != None else 0)
      extractedData[key] = finalVal

    return extractedData

  def dict(self, depth: int = -1):
    tree = super().tree(depth, "{%s}" % self.namespace["irs"])
    return tree
