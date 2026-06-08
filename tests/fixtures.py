"""Shared XML fixtures for tests."""
from pathlib import Path

FIXTURE_ZIPS_DIR = Path(__file__).parent / 'data' / 'zips' / 'good'
FIXTURE_BAD_ZIPS_DIR = Path(__file__).parent / 'data' / 'zips' / 'bad'

VALID_990_XML = """<?xml version="1.0" encoding="UTF-8"?>
<Return xmlns="http://www.irs.gov/efile">
  <ReturnHeader>
    <TaxYr>2023</TaxYr>
    <ReturnTypeCd>990</ReturnTypeCd>
    <Filer>
      <EIN>123456789</EIN>
      <BusinessName>
        <BusinessNameLine1Txt>Test Org</BusinessNameLine1Txt>
      </BusinessName>
    </Filer>
  </ReturnHeader>
  <ReturnData>
    <IRS990>
      <ActivityOrMissionDesc>Test mission</ActivityOrMissionDesc>
    </IRS990>
  </ReturnData>
</Return>"""

VALID_990_XML_2 = """<?xml version="1.0" encoding="UTF-8"?>
<Return xmlns="http://www.irs.gov/efile">
  <ReturnHeader>
    <TaxYr>2022</TaxYr>
    <ReturnTypeCd>990</ReturnTypeCd>
    <Filer>
      <EIN>987654321</EIN>
      <BusinessName>
        <BusinessNameLine1Txt>Beta Org</BusinessNameLine1Txt>
      </BusinessName>
    </Filer>
  </ReturnHeader>
  <ReturnData>
    <IRS990>
      <ActivityOrMissionDesc>Beta mission</ActivityOrMissionDesc>
    </IRS990>
  </ReturnData>
</Return>"""

MISSING_EIN_XML = """<?xml version="1.0" encoding="UTF-8"?>
<Return xmlns="http://www.irs.gov/efile">
  <ReturnHeader>
    <TaxYr>2023</TaxYr>
    <ReturnTypeCd>990</ReturnTypeCd>
    <Filer>
      <BusinessName>
        <BusinessNameLine1Txt>No EIN Org</BusinessNameLine1Txt>
      </BusinessName>
    </Filer>
  </ReturnHeader>
</Return>"""

VALID_990EZ_XML = """<?xml version="1.0" encoding="UTF-8"?>
<Return xmlns="http://www.irs.gov/efile">
  <ReturnHeader>
    <TaxYr>2023</TaxYr>
    <ReturnTypeCd>990EZ</ReturnTypeCd>
    <Filer>
      <EIN>111111111</EIN>
      <BusinessName>
        <BusinessNameLine1Txt>Small Nonprofit EZ</BusinessNameLine1Txt>
      </BusinessName>
    </Filer>
  </ReturnHeader>
  <ReturnData>
    <IRS990EZ>
      <PrimaryExemptPurposeTxt>Providing community services</PrimaryExemptPurposeTxt>
      <ContributionsGiftsGrantsEtcAmt>150000</ContributionsGiftsGrantsEtcAmt>
      <ProgramServiceRevenueAmt>25000</ProgramServiceRevenueAmt>
      <InvestmentIncomeAmt>1000</InvestmentIncomeAmt>
      <TotalRevenueAmt>176000</TotalRevenueAmt>
      <GrantsAndSimilarAmountsPaidAmt>10000</GrantsAndSimilarAmountsPaidAmt>
      <SalariesOtherCompEmpBnftsAmt>80000</SalariesOtherCompEmpBnftsAmt>
      <TotalExpensesAmt>140000</TotalExpensesAmt>
      <ExcessOrDeficitForYearAmt>36000</ExcessOrDeficitForYearAmt>
      <NetAssetsOrFundBalancesBOYAmt>50000</NetAssetsOrFundBalancesBOYAmt>
      <NetAssetsOrFundBalancesEOYAmt>86000</NetAssetsOrFundBalancesEOYAmt>
      <TotalAssetsEOYAmt>90000</TotalAssetsEOYAmt>
      <TotalLiabilitiesEOYAmt>4000</TotalLiabilitiesEOYAmt>
      <TotalEmployeeCnt>3</TotalEmployeeCnt>
    </IRS990EZ>
  </ReturnData>
</Return>"""

VALID_990N_XML = """<?xml version="1.0" encoding="UTF-8"?>
<Return xmlns="http://www.irs.gov/efile">
  <ReturnHeader>
    <TaxYr>2023</TaxYr>
    <ReturnTypeCd>990N</ReturnTypeCd>
    <Filer>
      <EIN>222222222</EIN>
      <BusinessName>
        <BusinessNameLine1Txt>Tiny Community Group</BusinessNameLine1Txt>
      </BusinessName>
    </Filer>
  </ReturnHeader>
  <ReturnData>
    <IRS990N>
      <GrossReceiptsNotGreaterThan50000Ind>X</GrossReceiptsNotGreaterThan50000Ind>
      <Organization501c3Ind>X</Organization501c3Ind>
      <OrganizationTerminatedInd>false</OrganizationTerminatedInd>
      <WebsiteAddressTxt>www.tinycommunitygroup.org</WebsiteAddressTxt>
      <PrincipalOfficerNm>Jane Doe</PrincipalOfficerNm>
    </IRS990N>
  </ReturnData>
</Return>"""

VALID_990PF_XML = """<?xml version="1.0" encoding="UTF-8"?>
<Return xmlns="http://www.irs.gov/efile">
  <ReturnHeader>
    <TaxYr>2023</TaxYr>
    <ReturnTypeCd>990PF</ReturnTypeCd>
    <Filer>
      <EIN>333333333</EIN>
      <BusinessName>
        <BusinessNameLine1Txt>Example Private Foundation</BusinessNameLine1Txt>
      </BusinessName>
    </Filer>
  </ReturnHeader>
  <ReturnData>
    <IRS990PF>
      <AnalysisRevExpnssGrp>
        <ContriRcvdRevAndExpnssGrp>
          <RevenueAndExpensesPerBooksAmt>500000</RevenueAndExpensesPerBooksAmt>
        </ContriRcvdRevAndExpnssGrp>
        <TotalRevAndExpnssGrp>
          <RevenueAndExpensesPerBooksAmt>550000</RevenueAndExpensesPerBooksAmt>
          <NetInvestmentIncomeAmt>50000</NetInvestmentIncomeAmt>
        </TotalRevAndExpnssGrp>
        <TotExpnsAndDsbrsmntsGrp>
          <RevenueAndExpensesPerBooksAmt>200000</RevenueAndExpensesPerBooksAmt>
          <NetInvestmentIncomeAmt>10000</NetInvestmentIncomeAmt>
        </TotExpnsAndDsbrsmntsGrp>
        <ExcessRevenueOverExpnssGrp>
          <RevenueAndExpensesPerBooksAmt>350000</RevenueAndExpensesPerBooksAmt>
        </ExcessRevenueOverExpnssGrp>
      </AnalysisRevExpnssGrp>
      <TotalAssetsEOYAmt>5000000</TotalAssetsEOYAmt>
      <TotalLiabilitiesEOYAmt>100000</TotalLiabilitiesEOYAmt>
      <TotNetAstOrFundBalancesEOYAmt>4900000</TotNetAstOrFundBalancesEOYAmt>
      <TotalQualifyingDistribtnsAmt>275000</TotalQualifyingDistribtnsAmt>
    </IRS990PF>
  </ReturnData>
</Return>"""

VALID_990T_XML = """<?xml version="1.0" encoding="UTF-8"?>
<Return xmlns="http://www.irs.gov/efile">
  <ReturnHeader>
    <TaxYr>2023</TaxYr>
    <ReturnTypeCd>990T</ReturnTypeCd>
    <Filer>
      <EIN>444444444</EIN>
      <BusinessName>
        <BusinessNameLine1Txt>University With UBI</BusinessNameLine1Txt>
      </BusinessName>
    </Filer>
  </ReturnHeader>
  <ReturnData>
    <IRS990T>
      <TotalGrossUBIAmt>300000</TotalGrossUBIAmt>
      <TotalDeductionsAmt>200000</TotalDeductionsAmt>
      <UBIBeforeNOLDedAmt>100000</UBIBeforeNOLDedAmt>
      <NetOperatingLossDeductionAmt>0</NetOperatingLossDeductionAmt>
      <UnrelatedBusinessTaxableIncm>100000</UnrelatedBusinessTaxableIncm>
      <TaxableIncome990TAmt>100000</TaxableIncome990TAmt>
      <TaxOnUBIAmt>21000</TaxOnUBIAmt>
      <TotalTaxAmt>21000</TotalTaxAmt>
    </IRS990T>
  </ReturnData>
</Return>"""
