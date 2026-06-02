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
