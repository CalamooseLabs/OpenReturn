-- Form 990-EZ — extended field mappings (part 25 EXT).

-- ========================================================================
-- FORM 990EZ — 144 new field mappings
-- ========================================================================

INSERT OR IGNORE INTO
  part (part_id, form_code, part_number, part_name)
VALUES
  (25, '990EZ', 'EXT', 'Extended Fields');

INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (25000, 25, '001', 'Direct Form Fields'),
  (25001, 25, '002', 'Books In Care Of Detail'),
  (25002, 25, '003', 'Bus Tr Involve Interested Prsn Group'),
  (25003, 25, '004', 'Cash Savings And Investments Group'),
  (25004, 25, '005', 'Compensation Explanation Group'),
  (25005, 25, '006', 'Disqualified Person Ex Bnft Tr Group'),
  (25006, 25, '007', 'Form990Total Assets Group'),
  (25007, 25, '008', 'Govt Furn Srvc Fclts Vl170 Group'),
  (25008, 25, '009', 'Govt Furn Srvc Fclts Vl509 Group'),
  (25009, 25, '010', 'Gross Receipts Non Unrlt Bus Group'),
  (25010, 25, '011', 'Land And Buildings Group'),
  (25011, 25, '012', 'Loans Btwn Org Interested Prsn Group'),
  (25012, 25, '013', 'Net Assets Or Fund Balances Group'),
  (25013, 25, '014', 'Officer Director Trustee Empl Group'),
  (25014, 25, '015', 'Other Assets Total Detail'),
  (25015, 25, '016', 'Post1975UBTI Group'),
  (25016, 25, '017', 'Program Srvc Accomplishment Group'),
  (25017, 25, '018', 'Sum Of Total Liabilities Group'),
  (25018, 25, '019', 'Supported Org Information Group'),
  (25019, 25, '020', 'Tax Rev Levied Orgnztnl Bnft170 Group'),
  (25020, 25, '021', 'Tax Rev Levied Orgnztnl Bnft509 Group'),
  (25021, 25, '022', 'Unrelated Business Net Incm170 Group');

-- 990EZ / Direct Form Fields
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (250001, 25000, '1', 'Activities Not Previously Rpt Ind', 'BOOLEAN'),
  (250002, 25000, '2', 'Address Change Ind', 'BOOLEAN'),
  (250003, 25000, '3', 'Application Pending Ind', 'BOOLEAN'),
  (250004, 25000, '4', 'Chg Made To Orgnzng Doc Not Rpt Ind', 'BOOLEAN'),
  (250005, 25000, '5', 'Cost Or Other Basis Expense Sale Amt', 'CURRENCY'),
  (250006, 25000, '6', 'Direct Indirect Pltcl Expend Amt', 'CURRENCY'),
  (250007, 25000, '7', 'Donor Advised Fnds Ind', 'BOOLEAN'),
  (250008, 25000, '8', 'Engaged In Excess Benefit Trans Ind', 'BOOLEAN'),
  (250009, 25000, '9', 'Filed Schedule A Ind', 'BOOLEAN'),
  (250010, 25000, '10', 'Foreign Financial Account Ind', 'BOOLEAN'),
  (250011, 25000, '11', 'Foreign Office Ind', 'BOOLEAN'),
  (250012, 25000, '12', 'Form1120Pol Filed Ind', 'BOOLEAN'),
  (250013, 25000, '13', 'Form720Filed Ind', 'BOOLEAN'),
  (250014, 25000, '14', 'Fundraising Gross Income Amt', 'CURRENCY'),
  (250015, 25000, '15', 'Gross Profit Loss Sls Of Invntry Amt', 'CURRENCY'),
  (250016, 25000, '16', 'Gross Receipts Amt', 'CURRENCY'),
  (250017, 25000, '17', 'Gross Receipts For Public Use Amt', 'CURRENCY'),
  (250018, 25000, '18', 'Group Exemption Num', 'INTEGER'),
  (250019, 25000, '19', 'Info In Schedule O Part III Ind', 'BOOLEAN'),
  (250020, 25000, '20', 'Info In Schedule O Part II Ind', 'BOOLEAN'),
  (250021, 25000, '21', 'Info In Schedule O Part I Ind', 'BOOLEAN'),
  (250022, 25000, '22', 'Info In Schedule O Part IV Ind', 'BOOLEAN'),
  (250023, 25000, '23', 'Info In Schedule O Part V Ind', 'BOOLEAN'),
  (250024, 25000, '24', 'Initial Return Ind', 'BOOLEAN'),
  (250025, 25000, '25', 'Initiation Fees And Cap Contri Amt', 'CURRENCY'),
  (250026, 25000, '26', 'Lobbying Activities Ind', 'BOOLEAN'),
  (250027, 25000, '27', 'Made Loans To From Officers Ind', 'BOOLEAN'),
  (250028, 25000, '28', 'Method Of Accounting Accrual Ind', 'BOOLEAN'),
  (250029, 25000, '29', 'Method Of Accounting Cash Ind', 'BOOLEAN'),
  (250030, 25000, '30', 'Method Of Accounting Other Desc', 'TEXT'),
  (250031, 25000, '31', 'Name Change Ind', 'BOOLEAN'),
  (250032, 25000, '32', 'Operate Hospital Ind', 'BOOLEAN'),
  (250033, 25000, '33', 'Organization501c3Ind', 'BOOLEAN'),
  (250034, 25000, '34', 'Organization501c Ind', 'BOOLEAN'),
  (250035, 25000, '35', 'Organization Dissolved Etc Ind', 'BOOLEAN'),
  (250036, 25000, '36', 'Organization Had UBI Ind', 'BOOLEAN'),
  (250037, 25000, '37', 'Part VI Hghst Pd Cntrct Prof Srvc Txt', 'TEXT'),
  (250038, 25000, '38', 'Part VI Of Comp Of Hghst Pd Empl Txt', 'TEXT'),
  (250039, 25000, '39', 'Political Campaign Acty Ind', 'BOOLEAN'),
  (250040, 25000, '40', 'Prohibited Tax Shelter Trans Ind', 'BOOLEAN'),
  (250041, 25000, '41', 'Related Org Sect527Org Ind', 'BOOLEAN'),
  (250042, 25000, '42', 'Related Organization Ctrl Ent Ind', 'BOOLEAN'),
  (250043, 25000, '43', 'Salaries Other Comp Empl Bnft Amt', 'CURRENCY'),
  (250044, 25000, '44', 'Sale Of Assets Gross Amt', 'CURRENCY'),
  (250045, 25000, '45', 'Schedule B Not Required Ind', 'BOOLEAN'),
  (250046, 25000, '46', 'School Operating Ind', 'BOOLEAN'),
  (250047, 25000, '47', 'Special Events Direct Expenses Amt', 'CURRENCY'),
  (250048, 25000, '48', 'Special Events Net Income Loss Amt', 'CURRENCY'),
  (250049, 25000, '49', 'States Where Copy Of Return Is Fld Cd', 'TEXT'),
  (250050, 25000, '50', 'Subject To Proxy Tax Ind', 'BOOLEAN'),
  (250051, 25000, '51', 'Tanning Services Provided Ind', 'BOOLEAN'),
  (250052, 25000, '52', 'Tax Imposed On Organization Mgr Amt', 'CURRENCY'),
  (250053, 25000, '53', 'Tax Imposed Under IRC4911Amt', 'CURRENCY'),
  (250054, 25000, '54', 'Tax Imposed Under IRC4912Amt', 'CURRENCY'),
  (250055, 25000, '55', 'Tax Imposed Under IRC4955Amt', 'CURRENCY'),
  (250056, 25000, '56', 'Tax Reimbursed By Organization Amt', 'CURRENCY'),
  (250057, 25000, '57', 'Total Program Service Expenses Amt', 'CURRENCY'),
  (250058, 25000, '58', 'Transaction With Control Ent Ind', 'BOOLEAN'),
  (250059, 25000, '59', 'Trnsfr Exmpt Non Chrtbl Rltd Org Ind', 'BOOLEAN'),
  (250060, 25000, '60', 'Type Of Organization Assoc Ind', 'BOOLEAN'),
  (250061, 25000, '61', 'Type Of Organization Corp Ind', 'BOOLEAN'),
  (250062, 25000, '62', 'Type Of Organization Other Desc', 'TEXT'),
  (250063, 25000, '63', 'Type Of Organization Other Ind', 'BOOLEAN'),
  (250064, 25000, '64', 'Type Of Organization Trust Ind', 'BOOLEAN'),
  (250065, 25000, '65', 'Website Address Txt', 'TEXT'),
  (250066, 25000, '66', 'Facts And Circumstances Test Txt', 'TEXT'),
  (250067, 25000, '67', 'IRS Written Determination Ind', 'BOOLEAN'),
  (250068, 25000, '68', 'Ten Pct Facts Crcmstncs Test CY Ind', 'BOOLEAN'),
  (250069, 25000, '69', 'Explanation Txt', 'TEXT'),
  (250070, 25000, '70', 'Declaration Desc', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (250001, NULL, NULL, 'Activities Not Previously Rpt Ind', 'BOOLEAN', 'ReturnData/IRS990EZ/ActivitiesNotPreviouslyRptInd'),
  (250002, NULL, NULL, 'Address Change Ind', 'BOOLEAN', 'ReturnData/IRS990EZ/AddressChangeInd'),
  (250003, NULL, NULL, 'Application Pending Ind', 'BOOLEAN', 'ReturnData/IRS990EZ/ApplicationPendingInd'),
  (250004, NULL, NULL, 'Chg Made To Orgnzng Doc Not Rpt Ind', 'BOOLEAN', 'ReturnData/IRS990EZ/ChgMadeToOrgnzngDocNotRptInd'),
  (250005, NULL, NULL, 'Cost Or Other Basis Expense Sale Amt', 'CURRENCY', 'ReturnData/IRS990EZ/CostOrOtherBasisExpenseSaleAmt'),
  (250006, NULL, NULL, 'Direct Indirect Pltcl Expend Amt', 'CURRENCY', 'ReturnData/IRS990EZ/DirectIndirectPltclExpendAmt'),
  (250007, NULL, NULL, 'Donor Advised Fnds Ind', 'BOOLEAN', 'ReturnData/IRS990EZ/DonorAdvisedFndsInd'),
  (250008, NULL, NULL, 'Engaged In Excess Benefit Trans Ind', 'BOOLEAN', 'ReturnData/IRS990EZ/EngagedInExcessBenefitTransInd'),
  (250009, NULL, NULL, 'Filed Schedule A Ind', 'BOOLEAN', 'ReturnData/IRS990EZ/FiledScheduleAInd'),
  (250010, NULL, NULL, 'Foreign Financial Account Ind', 'BOOLEAN', 'ReturnData/IRS990EZ/ForeignFinancialAccountInd'),
  (250011, NULL, NULL, 'Foreign Office Ind', 'BOOLEAN', 'ReturnData/IRS990EZ/ForeignOfficeInd'),
  (250012, NULL, NULL, 'Form1120Pol Filed Ind', 'BOOLEAN', 'ReturnData/IRS990EZ/Form1120PolFiledInd'),
  (250013, NULL, NULL, 'Form720Filed Ind', 'BOOLEAN', 'ReturnData/IRS990EZ/Form720FiledInd'),
  (250014, NULL, NULL, 'Fundraising Gross Income Amt', 'CURRENCY', 'ReturnData/IRS990EZ/FundraisingGrossIncomeAmt'),
  (250015, NULL, NULL, 'Gross Profit Loss Sls Of Invntry Amt', 'CURRENCY', 'ReturnData/IRS990EZ/GrossProfitLossSlsOfInvntryAmt'),
  (250016, NULL, NULL, 'Gross Receipts Amt', 'CURRENCY', 'ReturnData/IRS990EZ/GrossReceiptsAmt'),
  (250017, NULL, NULL, 'Gross Receipts For Public Use Amt', 'CURRENCY', 'ReturnData/IRS990EZ/GrossReceiptsForPublicUseAmt'),
  (250018, NULL, NULL, 'Group Exemption Num', 'INTEGER', 'ReturnData/IRS990EZ/GroupExemptionNum'),
  (250019, NULL, NULL, 'Info In Schedule O Part III Ind', 'BOOLEAN', 'ReturnData/IRS990EZ/InfoInScheduleOPartIIIInd'),
  (250020, NULL, NULL, 'Info In Schedule O Part II Ind', 'BOOLEAN', 'ReturnData/IRS990EZ/InfoInScheduleOPartIIInd'),
  (250021, NULL, NULL, 'Info In Schedule O Part I Ind', 'BOOLEAN', 'ReturnData/IRS990EZ/InfoInScheduleOPartIInd'),
  (250022, NULL, NULL, 'Info In Schedule O Part IV Ind', 'BOOLEAN', 'ReturnData/IRS990EZ/InfoInScheduleOPartIVInd'),
  (250023, NULL, NULL, 'Info In Schedule O Part V Ind', 'BOOLEAN', 'ReturnData/IRS990EZ/InfoInScheduleOPartVInd'),
  (250024, NULL, NULL, 'Initial Return Ind', 'BOOLEAN', 'ReturnData/IRS990EZ/InitialReturnInd'),
  (250025, NULL, NULL, 'Initiation Fees And Cap Contri Amt', 'CURRENCY', 'ReturnData/IRS990EZ/InitiationFeesAndCapContriAmt'),
  (250026, NULL, NULL, 'Lobbying Activities Ind', 'BOOLEAN', 'ReturnData/IRS990EZ/LobbyingActivitiesInd'),
  (250027, NULL, NULL, 'Made Loans To From Officers Ind', 'BOOLEAN', 'ReturnData/IRS990EZ/MadeLoansToFromOfficersInd'),
  (250028, NULL, NULL, 'Method Of Accounting Accrual Ind', 'BOOLEAN', 'ReturnData/IRS990EZ/MethodOfAccountingAccrualInd'),
  (250029, NULL, NULL, 'Method Of Accounting Cash Ind', 'BOOLEAN', 'ReturnData/IRS990EZ/MethodOfAccountingCashInd'),
  (250030, NULL, NULL, 'Method Of Accounting Other Desc', 'TEXT', 'ReturnData/IRS990EZ/MethodOfAccountingOtherDesc'),
  (250031, NULL, NULL, 'Name Change Ind', 'BOOLEAN', 'ReturnData/IRS990EZ/NameChangeInd'),
  (250032, NULL, NULL, 'Operate Hospital Ind', 'BOOLEAN', 'ReturnData/IRS990EZ/OperateHospitalInd'),
  (250033, NULL, NULL, 'Organization501c3Ind', 'BOOLEAN', 'ReturnData/IRS990EZ/Organization501c3Ind'),
  (250034, NULL, NULL, 'Organization501c Ind', 'BOOLEAN', 'ReturnData/IRS990EZ/Organization501cInd'),
  (250035, NULL, NULL, 'Organization Dissolved Etc Ind', 'BOOLEAN', 'ReturnData/IRS990EZ/OrganizationDissolvedEtcInd'),
  (250036, NULL, NULL, 'Organization Had UBI Ind', 'BOOLEAN', 'ReturnData/IRS990EZ/OrganizationHadUBIInd'),
  (250037, NULL, NULL, 'Part VI Hghst Pd Cntrct Prof Srvc Txt', 'TEXT', 'ReturnData/IRS990EZ/PartVIHghstPdCntrctProfSrvcTxt'),
  (250038, NULL, NULL, 'Part VI Of Comp Of Hghst Pd Empl Txt', 'TEXT', 'ReturnData/IRS990EZ/PartVIOfCompOfHghstPdEmplTxt'),
  (250039, NULL, NULL, 'Political Campaign Acty Ind', 'BOOLEAN', 'ReturnData/IRS990EZ/PoliticalCampaignActyInd'),
  (250040, NULL, NULL, 'Prohibited Tax Shelter Trans Ind', 'BOOLEAN', 'ReturnData/IRS990EZ/ProhibitedTaxShelterTransInd'),
  (250041, NULL, NULL, 'Related Org Sect527Org Ind', 'BOOLEAN', 'ReturnData/IRS990EZ/RelatedOrgSect527OrgInd'),
  (250042, NULL, NULL, 'Related Organization Ctrl Ent Ind', 'BOOLEAN', 'ReturnData/IRS990EZ/RelatedOrganizationCtrlEntInd'),
  (250043, NULL, NULL, 'Salaries Other Comp Empl Bnft Amt', 'CURRENCY', 'ReturnData/IRS990EZ/SalariesOtherCompEmplBnftAmt'),
  (250044, NULL, NULL, 'Sale Of Assets Gross Amt', 'CURRENCY', 'ReturnData/IRS990EZ/SaleOfAssetsGrossAmt'),
  (250045, NULL, NULL, 'Schedule B Not Required Ind', 'BOOLEAN', 'ReturnData/IRS990EZ/ScheduleBNotRequiredInd'),
  (250046, NULL, NULL, 'School Operating Ind', 'BOOLEAN', 'ReturnData/IRS990EZ/SchoolOperatingInd'),
  (250047, NULL, NULL, 'Special Events Direct Expenses Amt', 'CURRENCY', 'ReturnData/IRS990EZ/SpecialEventsDirectExpensesAmt'),
  (250048, NULL, NULL, 'Special Events Net Income Loss Amt', 'CURRENCY', 'ReturnData/IRS990EZ/SpecialEventsNetIncomeLossAmt'),
  (250049, NULL, NULL, 'States Where Copy Of Return Is Fld Cd', 'TEXT', 'ReturnData/IRS990EZ/StatesWhereCopyOfReturnIsFldCd'),
  (250050, NULL, NULL, 'Subject To Proxy Tax Ind', 'BOOLEAN', 'ReturnData/IRS990EZ/SubjectToProxyTaxInd'),
  (250051, NULL, NULL, 'Tanning Services Provided Ind', 'BOOLEAN', 'ReturnData/IRS990EZ/TanningServicesProvidedInd'),
  (250052, NULL, NULL, 'Tax Imposed On Organization Mgr Amt', 'CURRENCY', 'ReturnData/IRS990EZ/TaxImposedOnOrganizationMgrAmt'),
  (250053, NULL, NULL, 'Tax Imposed Under IRC4911Amt', 'CURRENCY', 'ReturnData/IRS990EZ/TaxImposedUnderIRC4911Amt'),
  (250054, NULL, NULL, 'Tax Imposed Under IRC4912Amt', 'CURRENCY', 'ReturnData/IRS990EZ/TaxImposedUnderIRC4912Amt'),
  (250055, NULL, NULL, 'Tax Imposed Under IRC4955Amt', 'CURRENCY', 'ReturnData/IRS990EZ/TaxImposedUnderIRC4955Amt'),
  (250056, NULL, NULL, 'Tax Reimbursed By Organization Amt', 'CURRENCY', 'ReturnData/IRS990EZ/TaxReimbursedByOrganizationAmt'),
  (250057, NULL, NULL, 'Total Program Service Expenses Amt', 'CURRENCY', 'ReturnData/IRS990EZ/TotalProgramServiceExpensesAmt'),
  (250058, NULL, NULL, 'Transaction With Control Ent Ind', 'BOOLEAN', 'ReturnData/IRS990EZ/TransactionWithControlEntInd'),
  (250059, NULL, NULL, 'Trnsfr Exmpt Non Chrtbl Rltd Org Ind', 'BOOLEAN', 'ReturnData/IRS990EZ/TrnsfrExmptNonChrtblRltdOrgInd'),
  (250060, NULL, NULL, 'Type Of Organization Assoc Ind', 'BOOLEAN', 'ReturnData/IRS990EZ/TypeOfOrganizationAssocInd'),
  (250061, NULL, NULL, 'Type Of Organization Corp Ind', 'BOOLEAN', 'ReturnData/IRS990EZ/TypeOfOrganizationCorpInd'),
  (250062, NULL, NULL, 'Type Of Organization Other Desc', 'TEXT', 'ReturnData/IRS990EZ/TypeOfOrganizationOtherDesc'),
  (250063, NULL, NULL, 'Type Of Organization Other Ind', 'BOOLEAN', 'ReturnData/IRS990EZ/TypeOfOrganizationOtherInd'),
  (250064, NULL, NULL, 'Type Of Organization Trust Ind', 'BOOLEAN', 'ReturnData/IRS990EZ/TypeOfOrganizationTrustInd'),
  (250065, NULL, NULL, 'Website Address Txt', 'TEXT', 'ReturnData/IRS990EZ/WebsiteAddressTxt'),
  (250066, NULL, NULL, 'Facts And Circumstances Test Txt', 'TEXT', 'ReturnData/IRS990ScheduleA/FactsAndCircumstancesTestTxt'),
  (250067, NULL, NULL, 'IRS Written Determination Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/IRSWrittenDeterminationInd'),
  (250068, NULL, NULL, 'Ten Pct Facts Crcmstncs Test CY Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/TenPctFactsCrcmstncsTestCYInd'),
  (250069, NULL, NULL, 'Explanation Txt', 'TEXT', 'ReturnData/ReasonableCauseExplanation/ExplanationTxt'),
  (250070, NULL, NULL, 'Declaration Desc', 'TEXT', 'ReturnData/TransferPrsnlBnftContractsDecl/DeclarationDesc');

-- 990EZ / Books In Care Of Detail
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (250071, 25001, '1', 'Business Name Line1Txt', 'TEXT'),
  (250072, 25001, '2', 'Person Nm', 'TEXT'),
  (250073, 25001, '3', 'Phone Num', 'TEXT'),
  (250074, 25001, '4', 'Address Line1Txt', 'TEXT'),
  (250075, 25001, '5', 'City Nm', 'TEXT'),
  (250076, 25001, '6', 'State Abbreviation Cd', 'TEXT'),
  (250077, 25001, '7', 'ZIP Cd', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (250071, NULL, NULL, 'Business Name Line1Txt', 'TEXT', 'ReturnData/IRS990EZ/BooksInCareOfDetail/BusinessName/BusinessNameLine1Txt'),
  (250072, NULL, NULL, 'Person Nm', 'TEXT', 'ReturnData/IRS990EZ/BooksInCareOfDetail/PersonNm'),
  (250073, NULL, NULL, 'Phone Num', 'TEXT', 'ReturnData/IRS990EZ/BooksInCareOfDetail/PhoneNum'),
  (250074, NULL, NULL, 'Address Line1Txt', 'TEXT', 'ReturnData/IRS990EZ/BooksInCareOfDetail/USAddress/AddressLine1Txt'),
  (250075, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990EZ/BooksInCareOfDetail/USAddress/CityNm'),
  (250076, NULL, NULL, 'State Abbreviation Cd', 'TEXT', 'ReturnData/IRS990EZ/BooksInCareOfDetail/USAddress/StateAbbreviationCd'),
  (250077, NULL, NULL, 'ZIP Cd', 'TEXT', 'ReturnData/IRS990EZ/BooksInCareOfDetail/USAddress/ZIPCd');

-- 990EZ / Bus Tr Involve Interested Prsn Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (250078, 25002, '1', 'Person Nm', 'TEXT'),
  (250079, 25002, '2', 'Relationship Description Txt', 'TEXT'),
  (250080, 25002, '3', 'Sharing Of Revenues Ind', 'BOOLEAN'),
  (250081, 25002, '4', 'Transaction Amt', 'CURRENCY'),
  (250082, 25002, '5', 'Transaction Desc', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (250078, NULL, NULL, 'Person Nm', 'TEXT', 'ReturnData/IRS990ScheduleL/BusTrInvolveInterestedPrsnGrp/NameOfInterested/PersonNm'),
  (250079, NULL, NULL, 'Relationship Description Txt', 'TEXT', 'ReturnData/IRS990ScheduleL/BusTrInvolveInterestedPrsnGrp/RelationshipDescriptionTxt'),
  (250080, NULL, NULL, 'Sharing Of Revenues Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleL/BusTrInvolveInterestedPrsnGrp/SharingOfRevenuesInd'),
  (250081, NULL, NULL, 'Transaction Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleL/BusTrInvolveInterestedPrsnGrp/TransactionAmt'),
  (250082, NULL, NULL, 'Transaction Desc', 'TEXT', 'ReturnData/IRS990ScheduleL/BusTrInvolveInterestedPrsnGrp/TransactionDesc');

-- 990EZ / Cash Savings And Investments Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (250083, 25003, '1', 'BOY Amt', 'CURRENCY'),
  (250084, 25003, '2', 'EOY Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (250083, NULL, NULL, 'BOY Amt', 'CURRENCY', 'ReturnData/IRS990EZ/CashSavingsAndInvestmentsGrp/BOYAmt'),
  (250084, NULL, NULL, 'EOY Amt', 'CURRENCY', 'ReturnData/IRS990EZ/CashSavingsAndInvestmentsGrp/EOYAmt');

-- 990EZ / Compensation Explanation Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (250085, 25004, '1', 'Person Nm', 'TEXT'),
  (250086, 25004, '2', 'Short Explanation Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (250085, NULL, NULL, 'Person Nm', 'TEXT', 'ReturnData/CompensationExplanation/CompensationExplanationGrp/PersonNm'),
  (250086, NULL, NULL, 'Short Explanation Txt', 'TEXT', 'ReturnData/CompensationExplanation/CompensationExplanationGrp/ShortExplanationTxt');

-- 990EZ / Disqualified Person Ex Bnft Tr Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (250087, 25005, '1', 'Transaction Corrected Ind', 'BOOLEAN');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (250087, NULL, NULL, 'Transaction Corrected Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleL/DisqualifiedPersonExBnftTrGrp/TransactionCorrectedInd');

-- 990EZ / Form990Total Assets Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (250088, 25006, '1', 'BOY Amt', 'CURRENCY'),
  (250089, 25006, '2', 'EOY Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (250088, NULL, NULL, 'BOY Amt', 'CURRENCY', 'ReturnData/IRS990EZ/Form990TotalAssetsGrp/BOYAmt'),
  (250089, NULL, NULL, 'EOY Amt', 'CURRENCY', 'ReturnData/IRS990EZ/Form990TotalAssetsGrp/EOYAmt');

-- 990EZ / Govt Furn Srvc Fclts Vl170 Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (250090, 25007, '1', 'Current Tax Year Amt', 'CURRENCY'),
  (250091, 25007, '2', 'Current Tax Year Minus1Year Amt', 'CURRENCY'),
  (250092, 25007, '3', 'Current Tax Year Minus2Years Amt', 'CURRENCY'),
  (250093, 25007, '4', 'Current Tax Year Minus3Years Amt', 'CURRENCY'),
  (250094, 25007, '5', 'Current Tax Year Minus4Years Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (250090, NULL, NULL, 'Current Tax Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/GovtFurnSrvcFcltsVl170Grp/CurrentTaxYearAmt'),
  (250091, NULL, NULL, 'Current Tax Year Minus1Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/GovtFurnSrvcFcltsVl170Grp/CurrentTaxYearMinus1YearAmt'),
  (250092, NULL, NULL, 'Current Tax Year Minus2Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/GovtFurnSrvcFcltsVl170Grp/CurrentTaxYearMinus2YearsAmt'),
  (250093, NULL, NULL, 'Current Tax Year Minus3Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/GovtFurnSrvcFcltsVl170Grp/CurrentTaxYearMinus3YearsAmt'),
  (250094, NULL, NULL, 'Current Tax Year Minus4Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/GovtFurnSrvcFcltsVl170Grp/CurrentTaxYearMinus4YearsAmt');

-- 990EZ / Govt Furn Srvc Fclts Vl509 Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (250095, 25008, '1', 'Current Tax Year Amt', 'CURRENCY'),
  (250096, 25008, '2', 'Current Tax Year Minus1Year Amt', 'CURRENCY'),
  (250097, 25008, '3', 'Current Tax Year Minus2Years Amt', 'CURRENCY'),
  (250098, 25008, '4', 'Current Tax Year Minus3Years Amt', 'CURRENCY'),
  (250099, 25008, '5', 'Current Tax Year Minus4Years Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (250095, NULL, NULL, 'Current Tax Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/GovtFurnSrvcFcltsVl509Grp/CurrentTaxYearAmt'),
  (250096, NULL, NULL, 'Current Tax Year Minus1Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/GovtFurnSrvcFcltsVl509Grp/CurrentTaxYearMinus1YearAmt'),
  (250097, NULL, NULL, 'Current Tax Year Minus2Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/GovtFurnSrvcFcltsVl509Grp/CurrentTaxYearMinus2YearsAmt'),
  (250098, NULL, NULL, 'Current Tax Year Minus3Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/GovtFurnSrvcFcltsVl509Grp/CurrentTaxYearMinus3YearsAmt'),
  (250099, NULL, NULL, 'Current Tax Year Minus4Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/GovtFurnSrvcFcltsVl509Grp/CurrentTaxYearMinus4YearsAmt');

-- 990EZ / Gross Receipts Non Unrlt Bus Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (250100, 25009, '1', 'Current Tax Year Amt', 'CURRENCY'),
  (250101, 25009, '2', 'Current Tax Year Minus1Year Amt', 'CURRENCY'),
  (250102, 25009, '3', 'Current Tax Year Minus2Years Amt', 'CURRENCY'),
  (250103, 25009, '4', 'Current Tax Year Minus3Years Amt', 'CURRENCY'),
  (250104, 25009, '5', 'Current Tax Year Minus4Years Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (250100, NULL, NULL, 'Current Tax Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/GrossReceiptsNonUnrltBusGrp/CurrentTaxYearAmt'),
  (250101, NULL, NULL, 'Current Tax Year Minus1Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/GrossReceiptsNonUnrltBusGrp/CurrentTaxYearMinus1YearAmt'),
  (250102, NULL, NULL, 'Current Tax Year Minus2Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/GrossReceiptsNonUnrltBusGrp/CurrentTaxYearMinus2YearsAmt'),
  (250103, NULL, NULL, 'Current Tax Year Minus3Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/GrossReceiptsNonUnrltBusGrp/CurrentTaxYearMinus3YearsAmt'),
  (250104, NULL, NULL, 'Current Tax Year Minus4Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/GrossReceiptsNonUnrltBusGrp/CurrentTaxYearMinus4YearsAmt');

-- 990EZ / Land And Buildings Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (250105, 25010, '1', 'BOY Amt', 'CURRENCY'),
  (250106, 25010, '2', 'EOY Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (250105, NULL, NULL, 'BOY Amt', 'CURRENCY', 'ReturnData/IRS990EZ/LandAndBuildingsGrp/BOYAmt'),
  (250106, NULL, NULL, 'EOY Amt', 'CURRENCY', 'ReturnData/IRS990EZ/LandAndBuildingsGrp/EOYAmt');

-- 990EZ / Loans Btwn Org Interested Prsn Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (250107, 25011, '1', 'Board Or Committee Approval Ind', 'BOOLEAN'),
  (250108, 25011, '2', 'Default Ind', 'BOOLEAN'),
  (250109, 25011, '3', 'Written Agreement Ind', 'BOOLEAN');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (250107, NULL, NULL, 'Board Or Committee Approval Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleL/LoansBtwnOrgInterestedPrsnGrp/BoardOrCommitteeApprovalInd'),
  (250108, NULL, NULL, 'Default Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleL/LoansBtwnOrgInterestedPrsnGrp/DefaultInd'),
  (250109, NULL, NULL, 'Written Agreement Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleL/LoansBtwnOrgInterestedPrsnGrp/WrittenAgreementInd');

-- 990EZ / Net Assets Or Fund Balances Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (250110, 25012, '1', 'BOY Amt', 'CURRENCY'),
  (250111, 25012, '2', 'EOY Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (250110, NULL, NULL, 'BOY Amt', 'CURRENCY', 'ReturnData/IRS990EZ/NetAssetsOrFundBalancesGrp/BOYAmt'),
  (250111, NULL, NULL, 'EOY Amt', 'CURRENCY', 'ReturnData/IRS990EZ/NetAssetsOrFundBalancesGrp/EOYAmt');

-- 990EZ / Officer Director Trustee Empl Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (250112, 25013, '1', 'Average Hrs Per Wk Devoted To Pos Rt', 'PERCENT'),
  (250113, 25013, '2', 'Compensation Amt', 'CURRENCY'),
  (250114, 25013, '3', 'Employee Benefit Program Amt', 'CURRENCY'),
  (250115, 25013, '4', 'Expense Account Other Allwnc Amt', 'CURRENCY'),
  (250116, 25013, '5', 'Person Nm', 'TEXT'),
  (250117, 25013, '6', 'Title Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (250112, NULL, NULL, 'Average Hrs Per Wk Devoted To Pos Rt', 'PERCENT', 'ReturnData/IRS990EZ/OfficerDirectorTrusteeEmplGrp/AverageHrsPerWkDevotedToPosRt'),
  (250113, NULL, NULL, 'Compensation Amt', 'CURRENCY', 'ReturnData/IRS990EZ/OfficerDirectorTrusteeEmplGrp/CompensationAmt'),
  (250114, NULL, NULL, 'Employee Benefit Program Amt', 'CURRENCY', 'ReturnData/IRS990EZ/OfficerDirectorTrusteeEmplGrp/EmployeeBenefitProgramAmt'),
  (250115, NULL, NULL, 'Expense Account Other Allwnc Amt', 'CURRENCY', 'ReturnData/IRS990EZ/OfficerDirectorTrusteeEmplGrp/ExpenseAccountOtherAllwncAmt'),
  (250116, NULL, NULL, 'Person Nm', 'TEXT', 'ReturnData/IRS990EZ/OfficerDirectorTrusteeEmplGrp/PersonNm'),
  (250117, NULL, NULL, 'Title Txt', 'TEXT', 'ReturnData/IRS990EZ/OfficerDirectorTrusteeEmplGrp/TitleTxt');

-- 990EZ / Other Assets Total Detail
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (250118, 25014, '1', 'BOY Amt', 'CURRENCY'),
  (250119, 25014, '2', 'EOY Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (250118, NULL, NULL, 'BOY Amt', 'CURRENCY', 'ReturnData/IRS990EZ/OtherAssetsTotalDetail/BOYAmt'),
  (250119, NULL, NULL, 'EOY Amt', 'CURRENCY', 'ReturnData/IRS990EZ/OtherAssetsTotalDetail/EOYAmt');

-- 990EZ / Post1975UBTI Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (250120, 25015, '1', 'Current Tax Year Amt', 'CURRENCY'),
  (250121, 25015, '2', 'Current Tax Year Minus1Year Amt', 'CURRENCY'),
  (250122, 25015, '3', 'Current Tax Year Minus2Years Amt', 'CURRENCY'),
  (250123, 25015, '4', 'Current Tax Year Minus3Years Amt', 'CURRENCY'),
  (250124, 25015, '5', 'Current Tax Year Minus4Years Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (250120, NULL, NULL, 'Current Tax Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/Post1975UBTIGrp/CurrentTaxYearAmt'),
  (250121, NULL, NULL, 'Current Tax Year Minus1Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/Post1975UBTIGrp/CurrentTaxYearMinus1YearAmt'),
  (250122, NULL, NULL, 'Current Tax Year Minus2Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/Post1975UBTIGrp/CurrentTaxYearMinus2YearsAmt'),
  (250123, NULL, NULL, 'Current Tax Year Minus3Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/Post1975UBTIGrp/CurrentTaxYearMinus3YearsAmt'),
  (250124, NULL, NULL, 'Current Tax Year Minus4Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/Post1975UBTIGrp/CurrentTaxYearMinus4YearsAmt');

-- 990EZ / Program Srvc Accomplishment Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (250125, 25016, '1', 'Description Program Srvc Accom Txt', 'TEXT'),
  (250126, 25016, '2', 'Grants And Allocations Amt', 'CURRENCY'),
  (250127, 25016, '3', 'Program Service Expenses Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (250125, NULL, NULL, 'Description Program Srvc Accom Txt', 'TEXT', 'ReturnData/IRS990EZ/ProgramSrvcAccomplishmentGrp/DescriptionProgramSrvcAccomTxt'),
  (250126, NULL, NULL, 'Grants And Allocations Amt', 'CURRENCY', 'ReturnData/IRS990EZ/ProgramSrvcAccomplishmentGrp/GrantsAndAllocationsAmt'),
  (250127, NULL, NULL, 'Program Service Expenses Amt', 'CURRENCY', 'ReturnData/IRS990EZ/ProgramSrvcAccomplishmentGrp/ProgramServiceExpensesAmt');

-- 990EZ / Sum Of Total Liabilities Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (250128, 25017, '1', 'BOY Amt', 'CURRENCY'),
  (250129, 25017, '2', 'EOY Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (250128, NULL, NULL, 'BOY Amt', 'CURRENCY', 'ReturnData/IRS990EZ/SumOfTotalLiabilitiesGrp/BOYAmt'),
  (250129, NULL, NULL, 'EOY Amt', 'CURRENCY', 'ReturnData/IRS990EZ/SumOfTotalLiabilitiesGrp/EOYAmt');

-- 990EZ / Supported Org Information Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (250130, 25018, '1', 'Business Name Line2Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (250130, NULL, NULL, 'Business Name Line2Txt', 'TEXT', 'ReturnData/IRS990ScheduleA/SupportedOrgInformationGrp/SupportedOrganizationName/BusinessNameLine2Txt');

-- 990EZ / Tax Rev Levied Orgnztnl Bnft170 Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (250131, 25019, '1', 'Current Tax Year Amt', 'CURRENCY'),
  (250132, 25019, '2', 'Current Tax Year Minus1Year Amt', 'CURRENCY'),
  (250133, 25019, '3', 'Current Tax Year Minus2Years Amt', 'CURRENCY'),
  (250134, 25019, '4', 'Current Tax Year Minus3Years Amt', 'CURRENCY'),
  (250135, 25019, '5', 'Current Tax Year Minus4Years Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (250131, NULL, NULL, 'Current Tax Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/TaxRevLeviedOrgnztnlBnft170Grp/CurrentTaxYearAmt'),
  (250132, NULL, NULL, 'Current Tax Year Minus1Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/TaxRevLeviedOrgnztnlBnft170Grp/CurrentTaxYearMinus1YearAmt'),
  (250133, NULL, NULL, 'Current Tax Year Minus2Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/TaxRevLeviedOrgnztnlBnft170Grp/CurrentTaxYearMinus2YearsAmt'),
  (250134, NULL, NULL, 'Current Tax Year Minus3Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/TaxRevLeviedOrgnztnlBnft170Grp/CurrentTaxYearMinus3YearsAmt'),
  (250135, NULL, NULL, 'Current Tax Year Minus4Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/TaxRevLeviedOrgnztnlBnft170Grp/CurrentTaxYearMinus4YearsAmt');

-- 990EZ / Tax Rev Levied Orgnztnl Bnft509 Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (250136, 25020, '1', 'Current Tax Year Amt', 'CURRENCY'),
  (250137, 25020, '2', 'Current Tax Year Minus1Year Amt', 'CURRENCY'),
  (250138, 25020, '3', 'Current Tax Year Minus2Years Amt', 'CURRENCY'),
  (250139, 25020, '4', 'Current Tax Year Minus3Years Amt', 'CURRENCY'),
  (250140, 25020, '5', 'Current Tax Year Minus4Years Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (250136, NULL, NULL, 'Current Tax Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/TaxRevLeviedOrgnztnlBnft509Grp/CurrentTaxYearAmt'),
  (250137, NULL, NULL, 'Current Tax Year Minus1Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/TaxRevLeviedOrgnztnlBnft509Grp/CurrentTaxYearMinus1YearAmt'),
  (250138, NULL, NULL, 'Current Tax Year Minus2Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/TaxRevLeviedOrgnztnlBnft509Grp/CurrentTaxYearMinus2YearsAmt'),
  (250139, NULL, NULL, 'Current Tax Year Minus3Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/TaxRevLeviedOrgnztnlBnft509Grp/CurrentTaxYearMinus3YearsAmt'),
  (250140, NULL, NULL, 'Current Tax Year Minus4Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/TaxRevLeviedOrgnztnlBnft509Grp/CurrentTaxYearMinus4YearsAmt');

-- 990EZ / Unrelated Business Net Incm170 Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (250141, 25021, '1', 'Current Tax Year Amt', 'CURRENCY'),
  (250142, 25021, '2', 'Current Tax Year Minus1Year Amt', 'CURRENCY'),
  (250143, 25021, '3', 'Current Tax Year Minus2Years Amt', 'CURRENCY'),
  (250144, 25021, '4', 'Current Tax Year Minus3Years Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (250141, NULL, NULL, 'Current Tax Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/UnrelatedBusinessNetIncm170Grp/CurrentTaxYearAmt'),
  (250142, NULL, NULL, 'Current Tax Year Minus1Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/UnrelatedBusinessNetIncm170Grp/CurrentTaxYearMinus1YearAmt'),
  (250143, NULL, NULL, 'Current Tax Year Minus2Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/UnrelatedBusinessNetIncm170Grp/CurrentTaxYearMinus2YearsAmt'),
  (250144, NULL, NULL, 'Current Tax Year Minus3Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/UnrelatedBusinessNetIncm170Grp/CurrentTaxYearMinus3YearsAmt');


-- ========================================================================
-- FORM 990-EZ — Extended field mappings (Round 2)
-- ========================================================================

-- 990EZ / IRS990 EZ Direct Fields
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (25022, 25, '023', 'IRS990 EZ Direct Fields');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (250145, 25022, '1', 'Other Employee Paid Over100k Cnt', 'INTEGER'),
  (250146, 25022, '2', 'Cntrct Rcvd Greater Than100 K Cnt', 'INTEGER'),
  (250147, 25022, '3', 'Organization Filed990 T Ind', 'BOOLEAN'),
  (250148, 25022, '4', 'Loans To From Officers Amt', 'CURRENCY'),
  (250149, 25022, '5', 'Amended Return Ind', 'BOOLEAN'),
  (250150, 25022, '6', 'Final Return Ind', 'BOOLEAN'),
  (250151, 25022, '7', 'Foreign Office Country Cd', 'TEXT'),
  (250152, 25022, '8', 'Info In Schedule O Part VI Ind', 'BOOLEAN'),
  (250153, 25022, '9', 'Foreign Financial Account Cntry Cd', 'TEXT'),
  (250154, 25022, '10', 'Organization4947a1 Not PF Ind', 'BOOLEAN'),
  (250155, 25022, '11', 'NECT Filing Form990 Ind', 'BOOLEAN');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (250145, NULL, NULL, 'Other Employee Paid Over100k Cnt', 'INTEGER', 'ReturnData/IRS990EZ/OtherEmployeePaidOver100kCnt'),
  (250146, NULL, NULL, 'Cntrct Rcvd Greater Than100 K Cnt', 'INTEGER', 'ReturnData/IRS990EZ/CntrctRcvdGreaterThan100KCnt'),
  (250147, NULL, NULL, 'Organization Filed990 T Ind', 'BOOLEAN', 'ReturnData/IRS990EZ/OrganizationFiled990TInd'),
  (250148, NULL, NULL, 'Loans To From Officers Amt', 'CURRENCY', 'ReturnData/IRS990EZ/LoansToFromOfficersAmt'),
  (250149, NULL, NULL, 'Amended Return Ind', 'BOOLEAN', 'ReturnData/IRS990EZ/AmendedReturnInd'),
  (250150, NULL, NULL, 'Final Return Ind', 'BOOLEAN', 'ReturnData/IRS990EZ/FinalReturnInd'),
  (250151, NULL, NULL, 'Foreign Office Country Cd', 'TEXT', 'ReturnData/IRS990EZ/ForeignOfficeCountryCd'),
  (250152, NULL, NULL, 'Info In Schedule O Part VI Ind', 'BOOLEAN', 'ReturnData/IRS990EZ/InfoInScheduleOPartVIInd'),
  (250153, NULL, NULL, 'Foreign Financial Account Cntry Cd', 'TEXT', 'ReturnData/IRS990EZ/ForeignFinancialAccountCntryCd'),
  (250154, NULL, NULL, 'Organization4947a1 Not PF Ind', 'BOOLEAN', 'ReturnData/IRS990EZ/Organization4947a1NotPFInd'),
  (250155, NULL, NULL, 'NECT Filing Form990 Ind', 'BOOLEAN', 'ReturnData/IRS990EZ/NECTFilingForm990Ind');

-- 990EZ / Books In Care Of Detail
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (25023, 25, '024', 'Books In Care Of Detail');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (250156, 25023, '1', 'Address Line2 Txt', 'TEXT'),
  (250157, 25023, '2', 'Business Name Line2 Txt', 'TEXT'),
  (250158, 25023, '3', 'Address Line1 Txt', 'TEXT'),
  (250159, 25023, '4', 'Country Cd', 'TEXT'),
  (250160, 25023, '5', 'City Nm', 'TEXT'),
  (250161, 25023, '6', 'Foreign Postal Cd', 'TEXT'),
  (250162, 25023, '7', 'Province Or State Nm', 'TEXT'),
  (250163, 25023, '8', 'Address Line2 Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (250156, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/IRS990EZ/BooksInCareOfDetail/USAddress/AddressLine2Txt'),
  (250157, NULL, NULL, 'Business Name Line2 Txt', 'TEXT', 'ReturnData/IRS990EZ/BooksInCareOfDetail/BusinessName/BusinessNameLine2Txt'),
  (250158, NULL, NULL, 'Address Line1 Txt', 'TEXT', 'ReturnData/IRS990EZ/BooksInCareOfDetail/ForeignAddress/AddressLine1Txt'),
  (250159, NULL, NULL, 'Country Cd', 'TEXT', 'ReturnData/IRS990EZ/BooksInCareOfDetail/ForeignAddress/CountryCd'),
  (250160, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990EZ/BooksInCareOfDetail/ForeignAddress/CityNm'),
  (250161, NULL, NULL, 'Foreign Postal Cd', 'TEXT', 'ReturnData/IRS990EZ/BooksInCareOfDetail/ForeignAddress/ForeignPostalCd'),
  (250162, NULL, NULL, 'Province Or State Nm', 'TEXT', 'ReturnData/IRS990EZ/BooksInCareOfDetail/ForeignAddress/ProvinceOrStateNm'),
  (250163, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/IRS990EZ/BooksInCareOfDetail/ForeignAddress/AddressLine2Txt');

-- 990EZ / Program Srvc Accomplishment Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (25024, 25, '025', 'Program Srvc Accomplishment Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (250164, 25024, '1', 'Foreign Grants Ind', 'BOOLEAN');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (250164, NULL, NULL, 'Foreign Grants Ind', 'BOOLEAN', 'ReturnData/IRS990EZ/ProgramSrvcAccomplishmentGrp/ForeignGrantsInd');

-- 990EZ / Compensation Highest Paid Empl Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (25025, 25, '026', 'Compensation Highest Paid Empl Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (250165, 25025, '1', 'Average Hours Per Week Rt', 'PERCENT'),
  (250166, 25025, '2', 'Compensation Amt', 'CURRENCY'),
  (250167, 25025, '3', 'Employee Benefits Amt', 'CURRENCY'),
  (250168, 25025, '4', 'Expense Account Amt', 'CURRENCY'),
  (250169, 25025, '5', 'Person Nm', 'TEXT'),
  (250170, 25025, '6', 'Title Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (250165, NULL, NULL, 'Average Hours Per Week Rt', 'PERCENT', 'ReturnData/IRS990EZ/CompensationHighestPaidEmplGrp/AverageHoursPerWeekRt'),
  (250166, NULL, NULL, 'Compensation Amt', 'CURRENCY', 'ReturnData/IRS990EZ/CompensationHighestPaidEmplGrp/CompensationAmt'),
  (250167, NULL, NULL, 'Employee Benefits Amt', 'CURRENCY', 'ReturnData/IRS990EZ/CompensationHighestPaidEmplGrp/EmployeeBenefitsAmt'),
  (250168, NULL, NULL, 'Expense Account Amt', 'CURRENCY', 'ReturnData/IRS990EZ/CompensationHighestPaidEmplGrp/ExpenseAccountAmt'),
  (250169, NULL, NULL, 'Person Nm', 'TEXT', 'ReturnData/IRS990EZ/CompensationHighestPaidEmplGrp/PersonNm'),
  (250170, NULL, NULL, 'Title Txt', 'TEXT', 'ReturnData/IRS990EZ/CompensationHighestPaidEmplGrp/TitleTxt');

-- 990EZ / Compensation Of Hghst Pd Cntrct Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (25026, 25, '027', 'Compensation Of Hghst Pd Cntrct Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (250171, 25026, '1', 'Compensation Amt', 'CURRENCY'),
  (250172, 25026, '2', 'Service Type Txt', 'TEXT'),
  (250173, 25026, '3', 'Address Line1 Txt', 'TEXT'),
  (250174, 25026, '4', 'City Nm', 'TEXT'),
  (250175, 25026, '5', 'State Abbreviation Cd', 'TEXT'),
  (250176, 25026, '6', 'ZIP Cd', 'TEXT'),
  (250177, 25026, '7', 'Business Name Line1 Txt', 'TEXT'),
  (250178, 25026, '8', 'Person Nm', 'TEXT'),
  (250179, 25026, '9', 'Address Line2 Txt', 'TEXT'),
  (250180, 25026, '10', 'Address Line1 Txt', 'TEXT'),
  (250181, 25026, '11', 'City Nm', 'TEXT'),
  (250182, 25026, '12', 'Country Cd', 'TEXT'),
  (250183, 25026, '13', 'Foreign Postal Cd', 'TEXT'),
  (250184, 25026, '14', 'Province Or State Nm', 'TEXT'),
  (250185, 25026, '15', 'Address Line2 Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (250171, NULL, NULL, 'Compensation Amt', 'CURRENCY', 'ReturnData/IRS990EZ/CompensationOfHghstPdCntrctGrp/CompensationAmt'),
  (250172, NULL, NULL, 'Service Type Txt', 'TEXT', 'ReturnData/IRS990EZ/CompensationOfHghstPdCntrctGrp/ServiceTypeTxt'),
  (250173, NULL, NULL, 'Address Line1 Txt', 'TEXT', 'ReturnData/IRS990EZ/CompensationOfHghstPdCntrctGrp/USAddress/AddressLine1Txt'),
  (250174, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990EZ/CompensationOfHghstPdCntrctGrp/USAddress/CityNm'),
  (250175, NULL, NULL, 'State Abbreviation Cd', 'TEXT', 'ReturnData/IRS990EZ/CompensationOfHghstPdCntrctGrp/USAddress/StateAbbreviationCd'),
  (250176, NULL, NULL, 'ZIP Cd', 'TEXT', 'ReturnData/IRS990EZ/CompensationOfHghstPdCntrctGrp/USAddress/ZIPCd'),
  (250177, NULL, NULL, 'Business Name Line1 Txt', 'TEXT', 'ReturnData/IRS990EZ/CompensationOfHghstPdCntrctGrp/BusinessName/BusinessNameLine1Txt'),
  (250178, NULL, NULL, 'Person Nm', 'TEXT', 'ReturnData/IRS990EZ/CompensationOfHghstPdCntrctGrp/PersonNm'),
  (250179, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/IRS990EZ/CompensationOfHghstPdCntrctGrp/USAddress/AddressLine2Txt'),
  (250180, NULL, NULL, 'Address Line1 Txt', 'TEXT', 'ReturnData/IRS990EZ/CompensationOfHghstPdCntrctGrp/ForeignAddress/AddressLine1Txt'),
  (250181, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990EZ/CompensationOfHghstPdCntrctGrp/ForeignAddress/CityNm'),
  (250182, NULL, NULL, 'Country Cd', 'TEXT', 'ReturnData/IRS990EZ/CompensationOfHghstPdCntrctGrp/ForeignAddress/CountryCd'),
  (250183, NULL, NULL, 'Foreign Postal Cd', 'TEXT', 'ReturnData/IRS990EZ/CompensationOfHghstPdCntrctGrp/ForeignAddress/ForeignPostalCd'),
  (250184, NULL, NULL, 'Province Or State Nm', 'TEXT', 'ReturnData/IRS990EZ/CompensationOfHghstPdCntrctGrp/ForeignAddress/ProvinceOrStateNm'),
  (250185, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/IRS990EZ/CompensationOfHghstPdCntrctGrp/ForeignAddress/AddressLine2Txt');

-- 990EZ / Officer Director Trustee Empl Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (25027, 25, '028', 'Officer Director Trustee Empl Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (250186, 25027, '1', 'Business Name Line1 Txt', 'TEXT'),
  (250187, 25027, '2', 'Business Name Line2 Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (250186, NULL, NULL, 'Business Name Line1 Txt', 'TEXT', 'ReturnData/IRS990EZ/OfficerDirectorTrusteeEmplGrp/BusinessName/BusinessNameLine1Txt'),
  (250187, NULL, NULL, 'Business Name Line2 Txt', 'TEXT', 'ReturnData/IRS990EZ/OfficerDirectorTrusteeEmplGrp/BusinessName/BusinessNameLine2Txt');

-- 990EZ / Special Condition Desc
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (25028, 25, '029', 'Special Condition Desc');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (250188, 25028, '1', 'Special Condition Desc', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (250188, NULL, NULL, 'Special Condition Desc', 'TEXT', 'ReturnData/IRS990EZ/SpecialConditionDesc');

-- 990EZ / Compensation Explanation Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (25029, 25, '030', 'Compensation Explanation Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (250189, 25029, '1', 'Business Name Line1 Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (250189, NULL, NULL, 'Business Name Line1 Txt', 'TEXT', 'ReturnData/CompensationExplanation/CompensationExplanationGrp/BusinessName/BusinessNameLine1Txt');

-- 990EZ / Employee Comp Explanation Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (25030, 25, '031', 'Employee Comp Explanation Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (250190, 25030, '1', 'Employee Nm', 'TEXT'),
  (250191, 25030, '2', 'Explanation Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (250190, NULL, NULL, 'Employee Nm', 'TEXT', 'ReturnData/EmployeeCompensationExpln/EmployeeCompExplanationGrp/EmployeeNm'),
  (250191, NULL, NULL, 'Explanation Txt', 'TEXT', 'ReturnData/EmployeeCompensationExpln/EmployeeCompExplanationGrp/ExplanationTxt');

