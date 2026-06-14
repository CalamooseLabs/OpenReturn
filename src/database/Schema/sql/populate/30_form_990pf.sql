-- Form 990-PF — extended field mappings (part 45 EXT).

-- ========================================================================
-- FORM 990PF — 634 new field mappings
-- ========================================================================

INSERT OR IGNORE INTO
  part (part_id, form_code, part_number, part_name)
VALUES
  (45, '990PF', 'EXT', 'Extended Fields');

INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (45000, 45, '001', 'Direct Form Fields'),
  (45001, 45, '002', 'Accounting Fees Detail'),
  (45002, 45, '003', 'All Other Program Related Invst Group'),
  (45003, 45, '004', 'Analysis Income Producing Acty Group'),
  (45004, 45, '005', 'Analysis Of Revenue And Expenses'),
  (45005, 45, '006', 'Cap Gains Loss Tx Invst Incm Detail'),
  (45006, 45, '007', 'Chg In Net Assets Fund Balances Group'),
  (45007, 45, '008', 'Contributor Information Group'),
  (45008, 45, '009', 'Dissolution Information Group'),
  (45009, 45, '010', 'Distributable Amount Group'),
  (45010, 45, '011', 'Excise Tax Based On Invst Incm Group'),
  (45011, 45, '012', 'Form990PF Balance Sheets Group'),
  (45012, 45, '013', 'Gain Loss Sale Other Asset Group'),
  (45013, 45, '014', 'General Explanation Group'),
  (45014, 45, '015', 'Investments Corporate Bonds Group'),
  (45015, 45, '016', 'Investments Corporate Stock Group'),
  (45016, 45, '017', 'Investments Other Group'),
  (45017, 45, '018', 'Land Etc Group'),
  (45018, 45, '019', 'Legal Fees Group'),
  (45019, 45, '020', 'Minimum Investment Return Group'),
  (45020, 45, '021', 'Non Cash Property Contribution Group'),
  (45021, 45, '022', 'Officer Dir Trst Key Empl Info Group'),
  (45022, 45, '023', 'Other Assets Schedule Group'),
  (45023, 45, '024', 'Other Decreases Detail'),
  (45024, 45, '025', 'Other Expenses Schedule Group'),
  (45025, 45, '026', 'Other Income Detail'),
  (45026, 45, '027', 'Other Increases Detail'),
  (45027, 45, '028', 'Other Liabilities Detail'),
  (45028, 45, '029', 'Other Professional Fees Detail'),
  (45029, 45, '030', 'PF Qualifying Distributions Group'),
  (45030, 45, '031', 'Private Operating Foundations Group'),
  (45031, 45, '032', 'Rln Of Acty To Accom Of Exmpt Prps Group'),
  (45032, 45, '033', 'Statements Regarding Acty Group'),
  (45033, 45, '034', 'Statements Regarding Acty4720 Group'),
  (45034, 45, '035', 'Substantial Contributor Detail'),
  (45035, 45, '036', 'Sum Of Program Related Invst Group'),
  (45036, 45, '037', 'Summary Of Direct Chrtbl Acty Group'),
  (45037, 45, '038', 'Supplementary Information Group'),
  (45038, 45, '039', 'Taxes Detail'),
  (45039, 45, '040', 'Trnsfr Trans Rln Nonchrtbl EO Group'),
  (45040, 45, '041', 'Undistributed Income Group');

-- 990PF / Direct Form Fields
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450001, 45000, '1', 'Explanation Txt', 'TEXT'),
  (450002, 45000, '2', 'Address Change Ind', 'BOOLEAN'),
  (450003, 45000, '3', 'Amended Return Ind', 'BOOLEAN'),
  (450004, 45000, '4', 'Application Pending Ind', 'BOOLEAN'),
  (450005, 45000, '5', 'FMV Assets EOY Amt', 'CURRENCY'),
  (450006, 45000, '6', 'Final Return Ind', 'BOOLEAN'),
  (450007, 45000, '7', 'Initial Return Former Pub Chrty Ind', 'BOOLEAN'),
  (450008, 45000, '8', 'Initial Return Ind', 'BOOLEAN'),
  (450009, 45000, '9', 'Method Of Accounting Accrual Ind', 'BOOLEAN'),
  (450010, 45000, '10', 'Method Of Accounting Cash Ind', 'BOOLEAN'),
  (450011, 45000, '11', 'Organization501c3Exempt PF Ind', 'BOOLEAN'),
  (450012, 45000, '12', 'PF Status Term Sect507b1A Ind', 'BOOLEAN'),
  (450013, 45000, '13', 'General Rule Ind', 'BOOLEAN'),
  (450014, 45000, '14', 'Organization501c3Exempt PF Ind', 'BOOLEAN'),
  (450015, 45000, '15', 'State Local Sec Book Vl EOY Amt', 'CURRENCY'),
  (450016, 45000, '16', 'State Local Sec EOYFMV Amt', 'CURRENCY'),
  (450017, 45000, '17', 'US Govt Obligations Book Vl EOY Amt', 'CURRENCY'),
  (450018, 45000, '18', 'US Govt Obligations EOYFMV Amt', 'CURRENCY'),
  (450019, 45000, '19', 'Explanation Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450001, NULL, NULL, 'Explanation Txt', 'TEXT', 'ReturnData/ExplnOfNonFilingWithAGStmt/ExplanationTxt'),
  (450002, NULL, NULL, 'Address Change Ind', 'BOOLEAN', 'ReturnData/IRS990PF/AddressChangeInd'),
  (450003, NULL, NULL, 'Amended Return Ind', 'BOOLEAN', 'ReturnData/IRS990PF/AmendedReturnInd'),
  (450004, NULL, NULL, 'Application Pending Ind', 'BOOLEAN', 'ReturnData/IRS990PF/ApplicationPendingInd'),
  (450005, NULL, NULL, 'FMV Assets EOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/FMVAssetsEOYAmt'),
  (450006, NULL, NULL, 'Final Return Ind', 'BOOLEAN', 'ReturnData/IRS990PF/FinalReturnInd'),
  (450007, NULL, NULL, 'Initial Return Former Pub Chrty Ind', 'BOOLEAN', 'ReturnData/IRS990PF/InitialReturnFormerPubChrtyInd'),
  (450008, NULL, NULL, 'Initial Return Ind', 'BOOLEAN', 'ReturnData/IRS990PF/InitialReturnInd'),
  (450009, NULL, NULL, 'Method Of Accounting Accrual Ind', 'BOOLEAN', 'ReturnData/IRS990PF/MethodOfAccountingAccrualInd'),
  (450010, NULL, NULL, 'Method Of Accounting Cash Ind', 'BOOLEAN', 'ReturnData/IRS990PF/MethodOfAccountingCashInd'),
  (450011, NULL, NULL, 'Organization501c3Exempt PF Ind', 'BOOLEAN', 'ReturnData/IRS990PF/Organization501c3ExemptPFInd'),
  (450012, NULL, NULL, 'PF Status Term Sect507b1A Ind', 'BOOLEAN', 'ReturnData/IRS990PF/PFStatusTermSect507b1AInd'),
  (450013, NULL, NULL, 'General Rule Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleB/GeneralRuleInd'),
  (450014, NULL, NULL, 'Organization501c3Exempt PF Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleB/Organization501c3ExemptPFInd'),
  (450015, NULL, NULL, 'State Local Sec Book Vl EOY Amt', 'CURRENCY', 'ReturnData/InvestmentsGovtObligationsSch/StateLocalSecBookVlEOYAmt'),
  (450016, NULL, NULL, 'State Local Sec EOYFMV Amt', 'CURRENCY', 'ReturnData/InvestmentsGovtObligationsSch/StateLocalSecEOYFMVAmt'),
  (450017, NULL, NULL, 'US Govt Obligations Book Vl EOY Amt', 'CURRENCY', 'ReturnData/InvestmentsGovtObligationsSch/USGovtObligationsBookVlEOYAmt'),
  (450018, NULL, NULL, 'US Govt Obligations EOYFMV Amt', 'CURRENCY', 'ReturnData/InvestmentsGovtObligationsSch/USGovtObligationsEOYFMVAmt'),
  (450019, NULL, NULL, 'Explanation Txt', 'TEXT', 'ReturnData/LiquidationExplanationStmt/ExplanationTxt');

-- 990PF / Accounting Fees Detail
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450020, 45001, '1', 'Adjusted Net Income Amt', 'CURRENCY'),
  (450021, 45001, '2', 'Amt', 'CURRENCY'),
  (450022, 45001, '3', 'Category Txt', 'TEXT'),
  (450023, 45001, '4', 'Disbursements Charitable Prps Amt', 'CURRENCY'),
  (450024, 45001, '5', 'Net Investment Income Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450020, NULL, NULL, 'Adjusted Net Income Amt', 'CURRENCY', 'ReturnData/AccountingFeesSchedule/AccountingFeesDetail/AdjustedNetIncomeAmt'),
  (450021, NULL, NULL, 'Amt', 'CURRENCY', 'ReturnData/AccountingFeesSchedule/AccountingFeesDetail/Amt'),
  (450022, NULL, NULL, 'Category Txt', 'TEXT', 'ReturnData/AccountingFeesSchedule/AccountingFeesDetail/CategoryTxt'),
  (450023, NULL, NULL, 'Disbursements Charitable Prps Amt', 'CURRENCY', 'ReturnData/AccountingFeesSchedule/AccountingFeesDetail/DisbursementsCharitablePrpsAmt'),
  (450024, NULL, NULL, 'Net Investment Income Amt', 'CURRENCY', 'ReturnData/AccountingFeesSchedule/AccountingFeesDetail/NetInvestmentIncomeAmt');

-- 990PF / All Other Program Related Invst Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450025, 45002, '1', 'Amt', 'CURRENCY'),
  (450026, 45002, '2', 'Desc', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450025, NULL, NULL, 'Amt', 'CURRENCY', 'ReturnData/AllOthProgRltdInvestmentsSch/AllOtherProgramRelatedInvstGrp/Amt'),
  (450026, NULL, NULL, 'Desc', 'TEXT', 'ReturnData/AllOthProgRltdInvestmentsSch/AllOtherProgramRelatedInvstGrp/Desc');

-- 990PF / Analysis Income Producing Acty Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450027, 45003, '1', 'Business Cd', 'TEXT'),
  (450028, 45003, '2', 'Exclusion Amt', 'CURRENCY'),
  (450029, 45003, '3', 'Exclusion Cd', 'TEXT'),
  (450030, 45003, '4', 'Related Or Exempt Function Incm Amt', 'CURRENCY'),
  (450031, 45003, '5', 'Unrelated Business Taxbl Incm Amt', 'CURRENCY'),
  (450032, 45003, '6', 'Exclusion Amt', 'CURRENCY'),
  (450033, 45003, '7', 'Exclusion Cd', 'TEXT'),
  (450034, 45003, '8', 'Related Or Exempt Function Incm Amt', 'CURRENCY'),
  (450035, 45003, '9', 'Unrelated Business Taxbl Incm Amt', 'CURRENCY'),
  (450036, 45003, '10', 'Exclusion Amt', 'CURRENCY'),
  (450037, 45003, '11', 'Related Or Exempt Function Incm Amt', 'CURRENCY'),
  (450038, 45003, '12', 'Unrelated Business Taxbl Incm Amt', 'CURRENCY'),
  (450039, 45003, '13', 'Business Cd', 'TEXT'),
  (450040, 45003, '14', 'Exclusion Amt', 'CURRENCY'),
  (450041, 45003, '15', 'Exclusion Cd', 'TEXT'),
  (450042, 45003, '16', 'Related Or Exempt Function Incm Amt', 'CURRENCY'),
  (450043, 45003, '17', 'Unrelated Business Taxbl Incm Amt', 'CURRENCY'),
  (450044, 45003, '18', 'Exclusion Amt', 'CURRENCY'),
  (450045, 45003, '19', 'Related Or Exempt Function Incm Amt', 'CURRENCY'),
  (450046, 45003, '20', 'Unrelated Business Taxbl Incm Amt', 'CURRENCY'),
  (450047, 45003, '21', 'Exclusion Amt', 'CURRENCY'),
  (450048, 45003, '22', 'Related Or Exempt Function Incm Amt', 'CURRENCY'),
  (450049, 45003, '23', 'Unrelated Business Taxbl Incm Amt', 'CURRENCY'),
  (450050, 45003, '24', 'Exclusion Amt', 'CURRENCY'),
  (450051, 45003, '25', 'Related Or Exempt Function Incm Amt', 'CURRENCY'),
  (450052, 45003, '26', 'Unrelated Business Taxbl Incm Amt', 'CURRENCY'),
  (450053, 45003, '27', 'Exclusion Amt', 'CURRENCY'),
  (450054, 45003, '28', 'Related Or Exempt Function Incm Amt', 'CURRENCY'),
  (450055, 45003, '29', 'Unrelated Business Taxbl Incm Amt', 'CURRENCY'),
  (450056, 45003, '30', 'Exclusion Amt', 'CURRENCY'),
  (450057, 45003, '31', 'Related Or Exempt Function Incm Amt', 'CURRENCY'),
  (450058, 45003, '32', 'Unrelated Business Taxbl Incm Amt', 'CURRENCY'),
  (450059, 45003, '33', 'Exclusion Amt', 'CURRENCY'),
  (450060, 45003, '34', 'Related Or Exempt Function Incm Amt', 'CURRENCY'),
  (450061, 45003, '35', 'Unrelated Business Taxbl Incm Amt', 'CURRENCY'),
  (450062, 45003, '36', 'Business Cd', 'TEXT'),
  (450063, 45003, '37', 'Desc', 'TEXT'),
  (450064, 45003, '38', 'Exclusion Amt', 'CURRENCY'),
  (450065, 45003, '39', 'Exclusion Cd', 'TEXT'),
  (450066, 45003, '40', 'Related Or Exempt Function Incm Amt', 'CURRENCY'),
  (450067, 45003, '41', 'Unrelated Business Taxbl Incm Amt', 'CURRENCY'),
  (450068, 45003, '42', 'Desc', 'TEXT'),
  (450069, 45003, '43', 'Exclusion Amt', 'CURRENCY'),
  (450070, 45003, '44', 'Related Or Exempt Function Incm Amt', 'CURRENCY'),
  (450071, 45003, '45', 'Unrelated Business Taxbl Incm Amt', 'CURRENCY'),
  (450072, 45003, '46', 'Exclusion Amt', 'CURRENCY'),
  (450073, 45003, '47', 'Related Or Exempt Function Incm Amt', 'CURRENCY'),
  (450074, 45003, '48', 'Unrelated Business Taxbl Incm Amt', 'CURRENCY'),
  (450075, 45003, '49', 'Total Income Producing Acty Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450027, NULL, NULL, 'Business Cd', 'TEXT', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/DividendsAndInterestFromSecDtl/BusinessCd'),
  (450028, NULL, NULL, 'Exclusion Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/DividendsAndInterestFromSecDtl/ExclusionAmt'),
  (450029, NULL, NULL, 'Exclusion Cd', 'TEXT', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/DividendsAndInterestFromSecDtl/ExclusionCd'),
  (450030, NULL, NULL, 'Related Or Exempt Function Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/DividendsAndInterestFromSecDtl/RelatedOrExemptFunctionIncmAmt'),
  (450031, NULL, NULL, 'Unrelated Business Taxbl Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/DividendsAndInterestFromSecDtl/UnrelatedBusinessTaxblIncmAmt'),
  (450032, NULL, NULL, 'Exclusion Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/GainSalesAstOthThanInvntryGrp/ExclusionAmt'),
  (450033, NULL, NULL, 'Exclusion Cd', 'TEXT', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/GainSalesAstOthThanInvntryGrp/ExclusionCd'),
  (450034, NULL, NULL, 'Related Or Exempt Function Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/GainSalesAstOthThanInvntryGrp/RelatedOrExemptFunctionIncmAmt'),
  (450035, NULL, NULL, 'Unrelated Business Taxbl Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/GainSalesAstOthThanInvntryGrp/UnrelatedBusinessTaxblIncmAmt'),
  (450036, NULL, NULL, 'Exclusion Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/GrossProfitLossSlsOfInvntryGrp/ExclusionAmt'),
  (450037, NULL, NULL, 'Related Or Exempt Function Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/GrossProfitLossSlsOfInvntryGrp/RelatedOrExemptFunctionIncmAmt'),
  (450038, NULL, NULL, 'Unrelated Business Taxbl Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/GrossProfitLossSlsOfInvntryGrp/UnrelatedBusinessTaxblIncmAmt'),
  (450039, NULL, NULL, 'Business Cd', 'TEXT', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/IntOnSavAndTempCashInvstGrp/BusinessCd'),
  (450040, NULL, NULL, 'Exclusion Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/IntOnSavAndTempCashInvstGrp/ExclusionAmt'),
  (450041, NULL, NULL, 'Exclusion Cd', 'TEXT', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/IntOnSavAndTempCashInvstGrp/ExclusionCd'),
  (450042, NULL, NULL, 'Related Or Exempt Function Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/IntOnSavAndTempCashInvstGrp/RelatedOrExemptFunctionIncmAmt'),
  (450043, NULL, NULL, 'Unrelated Business Taxbl Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/IntOnSavAndTempCashInvstGrp/UnrelatedBusinessTaxblIncmAmt'),
  (450044, NULL, NULL, 'Exclusion Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/MembershipDuesAndAssmntGrp/ExclusionAmt'),
  (450045, NULL, NULL, 'Related Or Exempt Function Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/MembershipDuesAndAssmntGrp/RelatedOrExemptFunctionIncmAmt'),
  (450046, NULL, NULL, 'Unrelated Business Taxbl Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/MembershipDuesAndAssmntGrp/UnrelatedBusinessTaxblIncmAmt'),
  (450047, NULL, NULL, 'Exclusion Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/NetIncomeLossFromSpecialEvtGrp/ExclusionAmt'),
  (450048, NULL, NULL, 'Related Or Exempt Function Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/NetIncomeLossFromSpecialEvtGrp/RelatedOrExemptFunctionIncmAmt'),
  (450049, NULL, NULL, 'Unrelated Business Taxbl Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/NetIncomeLossFromSpecialEvtGrp/UnrelatedBusinessTaxblIncmAmt'),
  (450050, NULL, NULL, 'Exclusion Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/NetRentalIncomePersonalPropGrp/ExclusionAmt'),
  (450051, NULL, NULL, 'Related Or Exempt Function Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/NetRentalIncomePersonalPropGrp/RelatedOrExemptFunctionIncmAmt'),
  (450052, NULL, NULL, 'Unrelated Business Taxbl Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/NetRentalIncomePersonalPropGrp/UnrelatedBusinessTaxblIncmAmt'),
  (450053, NULL, NULL, 'Exclusion Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/NetRntlIncmReDebtFincdPropGrp/ExclusionAmt'),
  (450054, NULL, NULL, 'Related Or Exempt Function Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/NetRntlIncmReDebtFincdPropGrp/RelatedOrExemptFunctionIncmAmt'),
  (450055, NULL, NULL, 'Unrelated Business Taxbl Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/NetRntlIncmReDebtFincdPropGrp/UnrelatedBusinessTaxblIncmAmt'),
  (450056, NULL, NULL, 'Exclusion Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/NetRntlIncmReNotDebtFincdProp/ExclusionAmt'),
  (450057, NULL, NULL, 'Related Or Exempt Function Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/NetRntlIncmReNotDebtFincdProp/RelatedOrExemptFunctionIncmAmt'),
  (450058, NULL, NULL, 'Unrelated Business Taxbl Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/NetRntlIncmReNotDebtFincdProp/UnrelatedBusinessTaxblIncmAmt'),
  (450059, NULL, NULL, 'Exclusion Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/OtherInvestmentIncomeGrp/ExclusionAmt'),
  (450060, NULL, NULL, 'Related Or Exempt Function Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/OtherInvestmentIncomeGrp/RelatedOrExemptFunctionIncmAmt'),
  (450061, NULL, NULL, 'Unrelated Business Taxbl Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/OtherInvestmentIncomeGrp/UnrelatedBusinessTaxblIncmAmt'),
  (450062, NULL, NULL, 'Business Cd', 'TEXT', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/OtherRevenueDescribedGrp/BusinessCd'),
  (450063, NULL, NULL, 'Desc', 'TEXT', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/OtherRevenueDescribedGrp/Desc'),
  (450064, NULL, NULL, 'Exclusion Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/OtherRevenueDescribedGrp/ExclusionAmt'),
  (450065, NULL, NULL, 'Exclusion Cd', 'TEXT', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/OtherRevenueDescribedGrp/ExclusionCd'),
  (450066, NULL, NULL, 'Related Or Exempt Function Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/OtherRevenueDescribedGrp/RelatedOrExemptFunctionIncmAmt'),
  (450067, NULL, NULL, 'Unrelated Business Taxbl Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/OtherRevenueDescribedGrp/UnrelatedBusinessTaxblIncmAmt'),
  (450068, NULL, NULL, 'Desc', 'TEXT', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/ProgramServiceRevenueDtl/Desc'),
  (450069, NULL, NULL, 'Exclusion Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/ProgramServiceRevenueDtl/ExclusionAmt'),
  (450070, NULL, NULL, 'Related Or Exempt Function Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/ProgramServiceRevenueDtl/RelatedOrExemptFunctionIncmAmt'),
  (450071, NULL, NULL, 'Unrelated Business Taxbl Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/ProgramServiceRevenueDtl/UnrelatedBusinessTaxblIncmAmt'),
  (450072, NULL, NULL, 'Exclusion Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/SubtotalsIncmProducingActyGrp/ExclusionAmt'),
  (450073, NULL, NULL, 'Related Or Exempt Function Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/SubtotalsIncmProducingActyGrp/RelatedOrExemptFunctionIncmAmt'),
  (450074, NULL, NULL, 'Unrelated Business Taxbl Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/SubtotalsIncmProducingActyGrp/UnrelatedBusinessTaxblIncmAmt'),
  (450075, NULL, NULL, 'Total Income Producing Acty Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/TotalIncomeProducingActyAmt');

-- 990PF / Analysis Of Revenue And Expenses
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450076, 45004, '1', 'Accounting Fees Adj Net Incm Amt', 'CURRENCY'),
  (450077, 45004, '2', 'Accounting Fees Chrtbl Prps Amt', 'CURRENCY'),
  (450078, 45004, '3', 'Accounting Fees Net Invst Incm Amt', 'CURRENCY'),
  (450079, 45004, '4', 'Accounting Fees Rev And Expnss Amt', 'CURRENCY'),
  (450080, 45004, '5', 'Adjusted Net Income Amt', 'CURRENCY'),
  (450081, 45004, '6', 'Cap Gain Net Incm Net Invst Incm Amt', 'CURRENCY'),
  (450082, 45004, '7', 'Comp Ofcr Dir Trst Adj Net Incm Amt', 'CURRENCY'),
  (450083, 45004, '8', 'Comp Ofcr Dir Trst Dsbrs Chrtbl Amt', 'CURRENCY'),
  (450084, 45004, '9', 'Comp Ofcr Dir Trst Net Invst Incm Amt', 'CURRENCY'),
  (450085, 45004, '10', 'Comp Ofcr Dir Trst Rev And Expnss Amt', 'CURRENCY'),
  (450086, 45004, '11', 'Contri Paid Dsbrs Chrtbl Amt', 'CURRENCY'),
  (450087, 45004, '12', 'Contri Paid Rev And Expnss Amt', 'CURRENCY'),
  (450088, 45004, '13', 'Contri Rcvd Rev And Expnss Amt', 'CURRENCY'),
  (450089, 45004, '14', 'Cost Of Goods Sold Amt', 'CURRENCY'),
  (450090, 45004, '15', 'Deprec And Dpltn Adj Net Incm Amt', 'CURRENCY'),
  (450091, 45004, '16', 'Deprec And Dpltn Net Invst Incm Amt', 'CURRENCY'),
  (450092, 45004, '17', 'Deprec And Dpltn Rev And Expnss Amt', 'CURRENCY'),
  (450093, 45004, '18', 'Dividends Adj Net Incm Amt', 'CURRENCY'),
  (450094, 45004, '19', 'Dividends Net Invst Incm Amt', 'CURRENCY'),
  (450095, 45004, '20', 'Dividends Rev And Expnss Amt', 'CURRENCY'),
  (450096, 45004, '21', 'Excess Revenue Over Expenses Amt', 'CURRENCY'),
  (450097, 45004, '22', 'Gross Profit Adj Net Incm Amt', 'CURRENCY'),
  (450098, 45004, '23', 'Gross Profit Rev And Expnss Amt', 'CURRENCY'),
  (450099, 45004, '24', 'Gross Rents Adj Net Incm Amt', 'CURRENCY'),
  (450100, 45004, '25', 'Gross Rents Net Invst Incm Amt', 'CURRENCY'),
  (450101, 45004, '26', 'Gross Rents Rev And Expnss Amt', 'CURRENCY'),
  (450102, 45004, '27', 'Gross Sales Less Ret And Allwnc Amt', 'CURRENCY'),
  (450103, 45004, '28', 'Gross Sales Price Amt', 'CURRENCY'),
  (450104, 45004, '29', 'Incm Modifications Adj Net Incm Amt', 'CURRENCY'),
  (450105, 45004, '30', 'Interest Adj Net Incm Amt', 'CURRENCY'),
  (450106, 45004, '31', 'Interest Dsbrs Chrtbl Amt', 'CURRENCY'),
  (450107, 45004, '32', 'Interest Net Invst Incm Amt', 'CURRENCY'),
  (450108, 45004, '33', 'Interest On Sav Net Invst Incm Amt', 'CURRENCY'),
  (450109, 45004, '34', 'Interest On Sav Rev And Expnss Amt', 'CURRENCY'),
  (450110, 45004, '35', 'Interest On Savings Adj Net Incm Amt', 'CURRENCY'),
  (450111, 45004, '36', 'Interest Rev And Expnss Amt', 'CURRENCY'),
  (450112, 45004, '37', 'Legal Fees Adj Net Incm Amt', 'CURRENCY'),
  (450113, 45004, '38', 'Legal Fees Dsbrs Chrtbl Amt', 'CURRENCY'),
  (450114, 45004, '39', 'Legal Fees Net Invst Incm Amt', 'CURRENCY'),
  (450115, 45004, '40', 'Legal Fees Rev And Expnss Amt', 'CURRENCY'),
  (450116, 45004, '41', 'Net Gain Sale Ast Rev And Expnss Amt', 'CURRENCY'),
  (450117, 45004, '42', 'Net Investment Income Amt', 'CURRENCY'),
  (450118, 45004, '43', 'Net Rental Income Or Loss Amt', 'CURRENCY'),
  (450119, 45004, '44', 'Net ST Capital Gain Adj Net Incm Amt', 'CURRENCY'),
  (450120, 45004, '45', 'Occupancy Adj Net Incm Amt', 'CURRENCY'),
  (450121, 45004, '46', 'Occupancy Dsbrs Chrtbl Amt', 'CURRENCY'),
  (450122, 45004, '47', 'Occupancy Net Invst Incm Amt', 'CURRENCY'),
  (450123, 45004, '48', 'Occupancy Rev And Expnss Amt', 'CURRENCY'),
  (450124, 45004, '49', 'Oth Empl Slrs Wgs Adj Net Incm Amt', 'CURRENCY'),
  (450125, 45004, '50', 'Oth Empl Slrs Wgs Dsbrs Chrtbl Amt', 'CURRENCY'),
  (450126, 45004, '51', 'Oth Empl Slrs Wgs Net Invst Incm Amt', 'CURRENCY'),
  (450127, 45004, '52', 'Oth Empl Slrs Wgs Rev And Expnss Amt', 'CURRENCY'),
  (450128, 45004, '53', 'Other Expenses Adj Net Incm Amt', 'CURRENCY'),
  (450129, 45004, '54', 'Other Expenses Dsbrs Chrtbl Amt', 'CURRENCY'),
  (450130, 45004, '55', 'Other Expenses Net Invst Incm Amt', 'CURRENCY'),
  (450131, 45004, '56', 'Other Expenses Rev And Expnss Amt', 'CURRENCY'),
  (450132, 45004, '57', 'Other Income Adj Net Incm Amt', 'CURRENCY'),
  (450133, 45004, '58', 'Other Income Net Invst Incm Amt', 'CURRENCY'),
  (450134, 45004, '59', 'Other Income Rev And Expnss Amt', 'CURRENCY'),
  (450135, 45004, '60', 'Other Prof Fees Adj Net Incm Amt', 'CURRENCY'),
  (450136, 45004, '61', 'Other Prof Fees Dsbrs Chrtbl Amt', 'CURRENCY'),
  (450137, 45004, '62', 'Other Prof Fees Net Invst Incm Amt', 'CURRENCY'),
  (450138, 45004, '63', 'Other Prof Fees Rev And Expnss Amt', 'CURRENCY'),
  (450139, 45004, '64', 'Pension Empl Bnft Adj Net Incm Amt', 'CURRENCY'),
  (450140, 45004, '65', 'Pension Empl Bnft Dsbrs Chrtbl Amt', 'CURRENCY'),
  (450141, 45004, '66', 'Pension Empl Bnft Net Invst Incm Amt', 'CURRENCY'),
  (450142, 45004, '67', 'Pension Empl Bnft Rev And Expnss Amt', 'CURRENCY'),
  (450143, 45004, '68', 'Printing And Pub Adj Net Incm Amt', 'CURRENCY'),
  (450144, 45004, '69', 'Printing And Pub Dsbrs Chrtbl Amt', 'CURRENCY'),
  (450145, 45004, '70', 'Printing And Pub Net Invst Incm Amt', 'CURRENCY'),
  (450146, 45004, '71', 'Printing And Pub Rev And Expnss Amt', 'CURRENCY'),
  (450147, 45004, '72', 'Schedule B Not Required Ind', 'BOOLEAN'),
  (450148, 45004, '73', 'Taxes Adj Net Incm Amt', 'CURRENCY'),
  (450149, 45004, '74', 'Taxes Dsbrs Chrtbl Amt', 'CURRENCY'),
  (450150, 45004, '75', 'Taxes Net Invst Incm Amt', 'CURRENCY'),
  (450151, 45004, '76', 'Taxes Rev And Expnss Amt', 'CURRENCY'),
  (450152, 45004, '77', 'Tot Opr Expenses Adj Net Incm Amt', 'CURRENCY'),
  (450153, 45004, '78', 'Tot Opr Expenses Dsbrs Chrtbl Amt', 'CURRENCY'),
  (450154, 45004, '79', 'Tot Opr Expenses Net Invst Incm Amt', 'CURRENCY'),
  (450155, 45004, '80', 'Tot Opr Expenses Rev And Expnss Amt', 'CURRENCY'),
  (450156, 45004, '81', 'Total Adj Net Incm Amt', 'CURRENCY'),
  (450157, 45004, '82', 'Total Expenses Adj Net Incm Amt', 'CURRENCY'),
  (450158, 45004, '83', 'Total Expenses Dsbrs Chrtbl Amt', 'CURRENCY'),
  (450159, 45004, '84', 'Total Expenses Net Invst Incm Amt', 'CURRENCY'),
  (450160, 45004, '85', 'Total Expenses Rev And Expnss Amt', 'CURRENCY'),
  (450161, 45004, '86', 'Total Net Invst Incm Amt', 'CURRENCY'),
  (450162, 45004, '87', 'Total Rev And Expnss Amt', 'CURRENCY'),
  (450163, 45004, '88', 'Trav Conf Meeting Adj Net Incm Amt', 'CURRENCY'),
  (450164, 45004, '89', 'Trav Conf Meeting Dsbrs Chrtbl Amt', 'CURRENCY'),
  (450165, 45004, '90', 'Trav Conf Meeting Net Invst Incm Amt', 'CURRENCY'),
  (450166, 45004, '91', 'Trav Conf Meeting Rev And Expnss Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450076, NULL, NULL, 'Accounting Fees Adj Net Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/AccountingFeesAdjNetIncmAmt'),
  (450077, NULL, NULL, 'Accounting Fees Chrtbl Prps Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/AccountingFeesChrtblPrpsAmt'),
  (450078, NULL, NULL, 'Accounting Fees Net Invst Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/AccountingFeesNetInvstIncmAmt'),
  (450079, NULL, NULL, 'Accounting Fees Rev And Expnss Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/AccountingFeesRevAndExpnssAmt'),
  (450080, NULL, NULL, 'Adjusted Net Income Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/AdjustedNetIncomeAmt'),
  (450081, NULL, NULL, 'Cap Gain Net Incm Net Invst Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/CapGainNetIncmNetInvstIncmAmt'),
  (450082, NULL, NULL, 'Comp Ofcr Dir Trst Adj Net Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/CompOfcrDirTrstAdjNetIncmAmt'),
  (450083, NULL, NULL, 'Comp Ofcr Dir Trst Dsbrs Chrtbl Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/CompOfcrDirTrstDsbrsChrtblAmt'),
  (450084, NULL, NULL, 'Comp Ofcr Dir Trst Net Invst Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/CompOfcrDirTrstNetInvstIncmAmt'),
  (450085, NULL, NULL, 'Comp Ofcr Dir Trst Rev And Expnss Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/CompOfcrDirTrstRevAndExpnssAmt'),
  (450086, NULL, NULL, 'Contri Paid Dsbrs Chrtbl Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/ContriPaidDsbrsChrtblAmt'),
  (450087, NULL, NULL, 'Contri Paid Rev And Expnss Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/ContriPaidRevAndExpnssAmt'),
  (450088, NULL, NULL, 'Contri Rcvd Rev And Expnss Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/ContriRcvdRevAndExpnssAmt'),
  (450089, NULL, NULL, 'Cost Of Goods Sold Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/CostOfGoodsSoldAmt'),
  (450090, NULL, NULL, 'Deprec And Dpltn Adj Net Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/DeprecAndDpltnAdjNetIncmAmt'),
  (450091, NULL, NULL, 'Deprec And Dpltn Net Invst Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/DeprecAndDpltnNetInvstIncmAmt'),
  (450092, NULL, NULL, 'Deprec And Dpltn Rev And Expnss Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/DeprecAndDpltnRevAndExpnssAmt'),
  (450093, NULL, NULL, 'Dividends Adj Net Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/DividendsAdjNetIncmAmt'),
  (450094, NULL, NULL, 'Dividends Net Invst Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/DividendsNetInvstIncmAmt'),
  (450095, NULL, NULL, 'Dividends Rev And Expnss Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/DividendsRevAndExpnssAmt'),
  (450096, NULL, NULL, 'Excess Revenue Over Expenses Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/ExcessRevenueOverExpensesAmt'),
  (450097, NULL, NULL, 'Gross Profit Adj Net Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/GrossProfitAdjNetIncmAmt'),
  (450098, NULL, NULL, 'Gross Profit Rev And Expnss Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/GrossProfitRevAndExpnssAmt'),
  (450099, NULL, NULL, 'Gross Rents Adj Net Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/GrossRentsAdjNetIncmAmt'),
  (450100, NULL, NULL, 'Gross Rents Net Invst Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/GrossRentsNetInvstIncmAmt'),
  (450101, NULL, NULL, 'Gross Rents Rev And Expnss Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/GrossRentsRevAndExpnssAmt'),
  (450102, NULL, NULL, 'Gross Sales Less Ret And Allwnc Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/GrossSalesLessRetAndAllwncAmt'),
  (450103, NULL, NULL, 'Gross Sales Price Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/GrossSalesPriceAmt'),
  (450104, NULL, NULL, 'Incm Modifications Adj Net Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/IncmModificationsAdjNetIncmAmt'),
  (450105, NULL, NULL, 'Interest Adj Net Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/InterestAdjNetIncmAmt'),
  (450106, NULL, NULL, 'Interest Dsbrs Chrtbl Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/InterestDsbrsChrtblAmt'),
  (450107, NULL, NULL, 'Interest Net Invst Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/InterestNetInvstIncmAmt'),
  (450108, NULL, NULL, 'Interest On Sav Net Invst Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/InterestOnSavNetInvstIncmAmt'),
  (450109, NULL, NULL, 'Interest On Sav Rev And Expnss Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/InterestOnSavRevAndExpnssAmt'),
  (450110, NULL, NULL, 'Interest On Savings Adj Net Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/InterestOnSavingsAdjNetIncmAmt'),
  (450111, NULL, NULL, 'Interest Rev And Expnss Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/InterestRevAndExpnssAmt'),
  (450112, NULL, NULL, 'Legal Fees Adj Net Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/LegalFeesAdjNetIncmAmt'),
  (450113, NULL, NULL, 'Legal Fees Dsbrs Chrtbl Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/LegalFeesDsbrsChrtblAmt'),
  (450114, NULL, NULL, 'Legal Fees Net Invst Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/LegalFeesNetInvstIncmAmt'),
  (450115, NULL, NULL, 'Legal Fees Rev And Expnss Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/LegalFeesRevAndExpnssAmt'),
  (450116, NULL, NULL, 'Net Gain Sale Ast Rev And Expnss Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/NetGainSaleAstRevAndExpnssAmt'),
  (450117, NULL, NULL, 'Net Investment Income Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/NetInvestmentIncomeAmt'),
  (450118, NULL, NULL, 'Net Rental Income Or Loss Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/NetRentalIncomeOrLossAmt'),
  (450119, NULL, NULL, 'Net ST Capital Gain Adj Net Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/NetSTCapitalGainAdjNetIncmAmt'),
  (450120, NULL, NULL, 'Occupancy Adj Net Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/OccupancyAdjNetIncmAmt'),
  (450121, NULL, NULL, 'Occupancy Dsbrs Chrtbl Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/OccupancyDsbrsChrtblAmt'),
  (450122, NULL, NULL, 'Occupancy Net Invst Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/OccupancyNetInvstIncmAmt'),
  (450123, NULL, NULL, 'Occupancy Rev And Expnss Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/OccupancyRevAndExpnssAmt'),
  (450124, NULL, NULL, 'Oth Empl Slrs Wgs Adj Net Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/OthEmplSlrsWgsAdjNetIncmAmt'),
  (450125, NULL, NULL, 'Oth Empl Slrs Wgs Dsbrs Chrtbl Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/OthEmplSlrsWgsDsbrsChrtblAmt'),
  (450126, NULL, NULL, 'Oth Empl Slrs Wgs Net Invst Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/OthEmplSlrsWgsNetInvstIncmAmt'),
  (450127, NULL, NULL, 'Oth Empl Slrs Wgs Rev And Expnss Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/OthEmplSlrsWgsRevAndExpnssAmt'),
  (450128, NULL, NULL, 'Other Expenses Adj Net Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/OtherExpensesAdjNetIncmAmt'),
  (450129, NULL, NULL, 'Other Expenses Dsbrs Chrtbl Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/OtherExpensesDsbrsChrtblAmt'),
  (450130, NULL, NULL, 'Other Expenses Net Invst Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/OtherExpensesNetInvstIncmAmt'),
  (450131, NULL, NULL, 'Other Expenses Rev And Expnss Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/OtherExpensesRevAndExpnssAmt'),
  (450132, NULL, NULL, 'Other Income Adj Net Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/OtherIncomeAdjNetIncmAmt'),
  (450133, NULL, NULL, 'Other Income Net Invst Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/OtherIncomeNetInvstIncmAmt'),
  (450134, NULL, NULL, 'Other Income Rev And Expnss Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/OtherIncomeRevAndExpnssAmt'),
  (450135, NULL, NULL, 'Other Prof Fees Adj Net Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/OtherProfFeesAdjNetIncmAmt'),
  (450136, NULL, NULL, 'Other Prof Fees Dsbrs Chrtbl Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/OtherProfFeesDsbrsChrtblAmt'),
  (450137, NULL, NULL, 'Other Prof Fees Net Invst Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/OtherProfFeesNetInvstIncmAmt'),
  (450138, NULL, NULL, 'Other Prof Fees Rev And Expnss Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/OtherProfFeesRevAndExpnssAmt'),
  (450139, NULL, NULL, 'Pension Empl Bnft Adj Net Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/PensionEmplBnftAdjNetIncmAmt'),
  (450140, NULL, NULL, 'Pension Empl Bnft Dsbrs Chrtbl Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/PensionEmplBnftDsbrsChrtblAmt'),
  (450141, NULL, NULL, 'Pension Empl Bnft Net Invst Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/PensionEmplBnftNetInvstIncmAmt'),
  (450142, NULL, NULL, 'Pension Empl Bnft Rev And Expnss Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/PensionEmplBnftRevAndExpnssAmt'),
  (450143, NULL, NULL, 'Printing And Pub Adj Net Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/PrintingAndPubAdjNetIncmAmt'),
  (450144, NULL, NULL, 'Printing And Pub Dsbrs Chrtbl Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/PrintingAndPubDsbrsChrtblAmt'),
  (450145, NULL, NULL, 'Printing And Pub Net Invst Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/PrintingAndPubNetInvstIncmAmt'),
  (450146, NULL, NULL, 'Printing And Pub Rev And Expnss Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/PrintingAndPubRevAndExpnssAmt'),
  (450147, NULL, NULL, 'Schedule B Not Required Ind', 'BOOLEAN', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/ScheduleBNotRequiredInd'),
  (450148, NULL, NULL, 'Taxes Adj Net Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/TaxesAdjNetIncmAmt'),
  (450149, NULL, NULL, 'Taxes Dsbrs Chrtbl Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/TaxesDsbrsChrtblAmt'),
  (450150, NULL, NULL, 'Taxes Net Invst Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/TaxesNetInvstIncmAmt'),
  (450151, NULL, NULL, 'Taxes Rev And Expnss Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/TaxesRevAndExpnssAmt'),
  (450152, NULL, NULL, 'Tot Opr Expenses Adj Net Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/TotOprExpensesAdjNetIncmAmt'),
  (450153, NULL, NULL, 'Tot Opr Expenses Dsbrs Chrtbl Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/TotOprExpensesDsbrsChrtblAmt'),
  (450154, NULL, NULL, 'Tot Opr Expenses Net Invst Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/TotOprExpensesNetInvstIncmAmt'),
  (450155, NULL, NULL, 'Tot Opr Expenses Rev And Expnss Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/TotOprExpensesRevAndExpnssAmt'),
  (450156, NULL, NULL, 'Total Adj Net Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/TotalAdjNetIncmAmt'),
  (450157, NULL, NULL, 'Total Expenses Adj Net Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/TotalExpensesAdjNetIncmAmt'),
  (450158, NULL, NULL, 'Total Expenses Dsbrs Chrtbl Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/TotalExpensesDsbrsChrtblAmt'),
  (450159, NULL, NULL, 'Total Expenses Net Invst Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/TotalExpensesNetInvstIncmAmt'),
  (450160, NULL, NULL, 'Total Expenses Rev And Expnss Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/TotalExpensesRevAndExpnssAmt'),
  (450161, NULL, NULL, 'Total Net Invst Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/TotalNetInvstIncmAmt'),
  (450162, NULL, NULL, 'Total Rev And Expnss Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/TotalRevAndExpnssAmt'),
  (450163, NULL, NULL, 'Trav Conf Meeting Adj Net Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/TravConfMeetingAdjNetIncmAmt'),
  (450164, NULL, NULL, 'Trav Conf Meeting Dsbrs Chrtbl Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/TravConfMeetingDsbrsChrtblAmt'),
  (450165, NULL, NULL, 'Trav Conf Meeting Net Invst Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/TravConfMeetingNetInvstIncmAmt'),
  (450166, NULL, NULL, 'Trav Conf Meeting Rev And Expnss Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/TravConfMeetingRevAndExpnssAmt');

-- 990PF / Cap Gains Loss Tx Invst Incm Detail
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450167, 45005, '1', 'Acquired Dt', 'DATE'),
  (450168, 45005, '2', 'Cost Or Other Basis Amt', 'CURRENCY'),
  (450169, 45005, '3', 'Depreciation Amt', 'CURRENCY'),
  (450170, 45005, '4', 'Gain Or Loss Amt', 'CURRENCY'),
  (450171, 45005, '5', 'Gains Minus Excess Or Losses Amt', 'CURRENCY'),
  (450172, 45005, '6', 'Gross Sales Price Amt', 'CURRENCY'),
  (450173, 45005, '7', 'How Acquired Cd', 'TEXT'),
  (450174, 45005, '8', 'Property Desc', 'TEXT'),
  (450175, 45005, '9', 'Sold Dt', 'DATE'),
  (450176, 45005, '10', 'Capital Gain Net Income Amt', 'CURRENCY'),
  (450177, 45005, '11', 'Net Short Term Capital Gain Loss Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450167, NULL, NULL, 'Acquired Dt', 'DATE', 'ReturnData/IRS990PF/CapGainsLossTxInvstIncmDetail/CapGainsLossTxInvstIncmGrp/AcquiredDt'),
  (450168, NULL, NULL, 'Cost Or Other Basis Amt', 'CURRENCY', 'ReturnData/IRS990PF/CapGainsLossTxInvstIncmDetail/CapGainsLossTxInvstIncmGrp/CostOrOtherBasisAmt'),
  (450169, NULL, NULL, 'Depreciation Amt', 'CURRENCY', 'ReturnData/IRS990PF/CapGainsLossTxInvstIncmDetail/CapGainsLossTxInvstIncmGrp/DepreciationAmt'),
  (450170, NULL, NULL, 'Gain Or Loss Amt', 'CURRENCY', 'ReturnData/IRS990PF/CapGainsLossTxInvstIncmDetail/CapGainsLossTxInvstIncmGrp/GainOrLossAmt'),
  (450171, NULL, NULL, 'Gains Minus Excess Or Losses Amt', 'CURRENCY', 'ReturnData/IRS990PF/CapGainsLossTxInvstIncmDetail/CapGainsLossTxInvstIncmGrp/GainsMinusExcessOrLossesAmt'),
  (450172, NULL, NULL, 'Gross Sales Price Amt', 'CURRENCY', 'ReturnData/IRS990PF/CapGainsLossTxInvstIncmDetail/CapGainsLossTxInvstIncmGrp/GrossSalesPriceAmt'),
  (450173, NULL, NULL, 'How Acquired Cd', 'TEXT', 'ReturnData/IRS990PF/CapGainsLossTxInvstIncmDetail/CapGainsLossTxInvstIncmGrp/HowAcquiredCd'),
  (450174, NULL, NULL, 'Property Desc', 'TEXT', 'ReturnData/IRS990PF/CapGainsLossTxInvstIncmDetail/CapGainsLossTxInvstIncmGrp/PropertyDesc'),
  (450175, NULL, NULL, 'Sold Dt', 'DATE', 'ReturnData/IRS990PF/CapGainsLossTxInvstIncmDetail/CapGainsLossTxInvstIncmGrp/SoldDt'),
  (450176, NULL, NULL, 'Capital Gain Net Income Amt', 'CURRENCY', 'ReturnData/IRS990PF/CapGainsLossTxInvstIncmDetail/CapitalGainNetIncomeAmt'),
  (450177, NULL, NULL, 'Net Short Term Capital Gain Loss Amt', 'CURRENCY', 'ReturnData/IRS990PF/CapGainsLossTxInvstIncmDetail/NetShortTermCapitalGainLossAmt');

-- 990PF / Chg In Net Assets Fund Balances Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450178, 45006, '1', 'Excess Revenue Over Expenses Amt', 'CURRENCY'),
  (450179, 45006, '2', 'Other Decreases Amt', 'CURRENCY'),
  (450180, 45006, '3', 'Other Increases Amt', 'CURRENCY'),
  (450181, 45006, '4', 'Subtotal Amt', 'CURRENCY'),
  (450182, 45006, '5', 'Tot Net Ast Or Fund Balances BOY Amt', 'CURRENCY'),
  (450183, 45006, '6', 'Tot Net Ast Or Fund Balances EOY Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450178, NULL, NULL, 'Excess Revenue Over Expenses Amt', 'CURRENCY', 'ReturnData/IRS990PF/ChgInNetAssetsFundBalancesGrp/ExcessRevenueOverExpensesAmt'),
  (450179, NULL, NULL, 'Other Decreases Amt', 'CURRENCY', 'ReturnData/IRS990PF/ChgInNetAssetsFundBalancesGrp/OtherDecreasesAmt'),
  (450180, NULL, NULL, 'Other Increases Amt', 'CURRENCY', 'ReturnData/IRS990PF/ChgInNetAssetsFundBalancesGrp/OtherIncreasesAmt'),
  (450181, NULL, NULL, 'Subtotal Amt', 'CURRENCY', 'ReturnData/IRS990PF/ChgInNetAssetsFundBalancesGrp/SubtotalAmt'),
  (450182, NULL, NULL, 'Tot Net Ast Or Fund Balances BOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/ChgInNetAssetsFundBalancesGrp/TotNetAstOrFundBalancesBOYAmt'),
  (450183, NULL, NULL, 'Tot Net Ast Or Fund Balances EOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/ChgInNetAssetsFundBalancesGrp/TotNetAstOrFundBalancesEOYAmt');

-- 990PF / Contributor Information Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450184, 45007, '1', 'Business Name Line1Txt', 'TEXT'),
  (450185, 45007, '2', 'Contributor Person Nm', 'TEXT'),
  (450186, 45007, '3', 'Address Line1Txt', 'TEXT'),
  (450187, 45007, '4', 'Address Line2Txt', 'TEXT'),
  (450188, 45007, '5', 'City Nm', 'TEXT'),
  (450189, 45007, '6', 'State Abbreviation Cd', 'TEXT'),
  (450190, 45007, '7', 'ZIP Cd', 'TEXT'),
  (450191, 45007, '8', 'Noncash Contribution Ind', 'BOOLEAN'),
  (450192, 45007, '9', 'Person Contribution Ind', 'BOOLEAN');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450184, NULL, NULL, 'Business Name Line1Txt', 'TEXT', 'ReturnData/IRS990ScheduleB/ContributorInformationGrp/ContributorBusinessName/BusinessNameLine1Txt'),
  (450185, NULL, NULL, 'Contributor Person Nm', 'TEXT', 'ReturnData/IRS990ScheduleB/ContributorInformationGrp/ContributorPersonNm'),
  (450186, NULL, NULL, 'Address Line1Txt', 'TEXT', 'ReturnData/IRS990ScheduleB/ContributorInformationGrp/ContributorUSAddress/AddressLine1Txt'),
  (450187, NULL, NULL, 'Address Line2Txt', 'TEXT', 'ReturnData/IRS990ScheduleB/ContributorInformationGrp/ContributorUSAddress/AddressLine2Txt'),
  (450188, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990ScheduleB/ContributorInformationGrp/ContributorUSAddress/CityNm'),
  (450189, NULL, NULL, 'State Abbreviation Cd', 'TEXT', 'ReturnData/IRS990ScheduleB/ContributorInformationGrp/ContributorUSAddress/StateAbbreviationCd'),
  (450190, NULL, NULL, 'ZIP Cd', 'TEXT', 'ReturnData/IRS990ScheduleB/ContributorInformationGrp/ContributorUSAddress/ZIPCd'),
  (450191, NULL, NULL, 'Noncash Contribution Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleB/ContributorInformationGrp/NoncashContributionInd'),
  (450192, NULL, NULL, 'Person Contribution Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleB/ContributorInformationGrp/PersonContributionInd');

-- 990PF / Dissolution Information Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450193, 45008, '1', 'Business Name Line1Txt', 'TEXT'),
  (450194, 45008, '2', 'Dissolution Amt', 'CURRENCY'),
  (450195, 45008, '3', 'Short Explanation Txt', 'TEXT'),
  (450196, 45008, '4', 'Address Line1Txt', 'TEXT'),
  (450197, 45008, '5', 'City Nm', 'TEXT'),
  (450198, 45008, '6', 'State Abbreviation Cd', 'TEXT'),
  (450199, 45008, '7', 'ZIP Cd', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450193, NULL, NULL, 'Business Name Line1Txt', 'TEXT', 'ReturnData/DissolutionStmt/DissolutionInformationGrp/BusinessName/BusinessNameLine1Txt'),
  (450194, NULL, NULL, 'Dissolution Amt', 'CURRENCY', 'ReturnData/DissolutionStmt/DissolutionInformationGrp/DissolutionAmt'),
  (450195, NULL, NULL, 'Short Explanation Txt', 'TEXT', 'ReturnData/DissolutionStmt/DissolutionInformationGrp/ShortExplanationTxt'),
  (450196, NULL, NULL, 'Address Line1Txt', 'TEXT', 'ReturnData/DissolutionStmt/DissolutionInformationGrp/USAddress/AddressLine1Txt'),
  (450197, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/DissolutionStmt/DissolutionInformationGrp/USAddress/CityNm'),
  (450198, NULL, NULL, 'State Abbreviation Cd', 'TEXT', 'ReturnData/DissolutionStmt/DissolutionInformationGrp/USAddress/StateAbbreviationCd'),
  (450199, NULL, NULL, 'ZIP Cd', 'TEXT', 'ReturnData/DissolutionStmt/DissolutionInformationGrp/USAddress/ZIPCd');

-- 990PF / Distributable Amount Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450200, 45009, '1', 'Deduction From Distributable Amt', 'CURRENCY'),
  (450201, 45009, '2', 'Distributable As Adjusted Amt', 'CURRENCY'),
  (450202, 45009, '3', 'Distributable Before Adj Amt', 'CURRENCY'),
  (450203, 45009, '4', 'Distributable Before Ded Amt', 'CURRENCY'),
  (450204, 45009, '5', 'Income Tax Amt', 'CURRENCY'),
  (450205, 45009, '6', 'Minimum Investment Return Amt', 'CURRENCY'),
  (450206, 45009, '7', 'Recoveries Qualfied Distri Amt', 'CURRENCY'),
  (450207, 45009, '8', 'Sect4942j3j5Fndtn And Frgn Org Ind', 'BOOLEAN'),
  (450208, 45009, '9', 'Tax Based On Investment Income Amt', 'CURRENCY'),
  (450209, 45009, '10', 'Total Tax Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450200, NULL, NULL, 'Deduction From Distributable Amt', 'CURRENCY', 'ReturnData/IRS990PF/DistributableAmountGrp/DeductionFromDistributableAmt'),
  (450201, NULL, NULL, 'Distributable As Adjusted Amt', 'CURRENCY', 'ReturnData/IRS990PF/DistributableAmountGrp/DistributableAsAdjustedAmt'),
  (450202, NULL, NULL, 'Distributable Before Adj Amt', 'CURRENCY', 'ReturnData/IRS990PF/DistributableAmountGrp/DistributableBeforeAdjAmt'),
  (450203, NULL, NULL, 'Distributable Before Ded Amt', 'CURRENCY', 'ReturnData/IRS990PF/DistributableAmountGrp/DistributableBeforeDedAmt'),
  (450204, NULL, NULL, 'Income Tax Amt', 'CURRENCY', 'ReturnData/IRS990PF/DistributableAmountGrp/IncomeTaxAmt'),
  (450205, NULL, NULL, 'Minimum Investment Return Amt', 'CURRENCY', 'ReturnData/IRS990PF/DistributableAmountGrp/MinimumInvestmentReturnAmt'),
  (450206, NULL, NULL, 'Recoveries Qualfied Distri Amt', 'CURRENCY', 'ReturnData/IRS990PF/DistributableAmountGrp/RecoveriesQualfiedDistriAmt'),
  (450207, NULL, NULL, 'Sect4942j3j5Fndtn And Frgn Org Ind', 'BOOLEAN', 'ReturnData/IRS990PF/DistributableAmountGrp/Sect4942j3j5FndtnAndFrgnOrgInd'),
  (450208, NULL, NULL, 'Tax Based On Investment Income Amt', 'CURRENCY', 'ReturnData/IRS990PF/DistributableAmountGrp/TaxBasedOnInvestmentIncomeAmt'),
  (450209, NULL, NULL, 'Total Tax Amt', 'CURRENCY', 'ReturnData/IRS990PF/DistributableAmountGrp/TotalTaxAmt');

-- 990PF / Excise Tax Based On Invst Incm Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450210, 45010, '1', 'Applied To ES Tax Amt', 'CURRENCY'),
  (450211, 45010, '2', 'Backup Withholding Withheld Amt', 'CURRENCY'),
  (450212, 45010, '3', 'Es Penalty Amt', 'CURRENCY'),
  (450213, 45010, '4', 'Estimated Plus Ovpmt Incm Tx Amt', 'CURRENCY'),
  (450214, 45010, '5', 'Exempt Frgn Org Tax Wthld At Srce Amt', 'CURRENCY'),
  (450215, 45010, '6', 'Extsn Request Income Tax Paid Amt', 'CURRENCY'),
  (450216, 45010, '7', 'Form2220Attached Ind', 'BOOLEAN'),
  (450217, 45010, '8', 'Investment Income Excise Tax Amt', 'CURRENCY'),
  (450218, 45010, '9', 'Overpayment Amt', 'CURRENCY'),
  (450219, 45010, '10', 'Refund Amt', 'CURRENCY'),
  (450220, 45010, '11', 'Subtitle A Tax Amt', 'CURRENCY'),
  (450221, 45010, '12', 'Subtotal Amt', 'CURRENCY'),
  (450222, 45010, '13', 'Tax Based On Investment Income Amt', 'CURRENCY'),
  (450223, 45010, '14', 'Tax Due Amt', 'CURRENCY'),
  (450224, 45010, '15', 'Tax Under Section511Amt', 'CURRENCY'),
  (450225, 45010, '16', 'Total Payments And Credits Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450210, NULL, NULL, 'Applied To ES Tax Amt', 'CURRENCY', 'ReturnData/IRS990PF/ExciseTaxBasedOnInvstIncmGrp/AppliedToESTaxAmt'),
  (450211, NULL, NULL, 'Backup Withholding Withheld Amt', 'CURRENCY', 'ReturnData/IRS990PF/ExciseTaxBasedOnInvstIncmGrp/BackupWithholdingWithheldAmt'),
  (450212, NULL, NULL, 'Es Penalty Amt', 'CURRENCY', 'ReturnData/IRS990PF/ExciseTaxBasedOnInvstIncmGrp/EsPenaltyAmt'),
  (450213, NULL, NULL, 'Estimated Plus Ovpmt Incm Tx Amt', 'CURRENCY', 'ReturnData/IRS990PF/ExciseTaxBasedOnInvstIncmGrp/EstimatedPlusOvpmtIncmTxAmt'),
  (450214, NULL, NULL, 'Exempt Frgn Org Tax Wthld At Srce Amt', 'CURRENCY', 'ReturnData/IRS990PF/ExciseTaxBasedOnInvstIncmGrp/ExemptFrgnOrgTaxWthldAtSrceAmt'),
  (450215, NULL, NULL, 'Extsn Request Income Tax Paid Amt', 'CURRENCY', 'ReturnData/IRS990PF/ExciseTaxBasedOnInvstIncmGrp/ExtsnRequestIncomeTaxPaidAmt'),
  (450216, NULL, NULL, 'Form2220Attached Ind', 'BOOLEAN', 'ReturnData/IRS990PF/ExciseTaxBasedOnInvstIncmGrp/Form2220AttachedInd'),
  (450217, NULL, NULL, 'Investment Income Excise Tax Amt', 'CURRENCY', 'ReturnData/IRS990PF/ExciseTaxBasedOnInvstIncmGrp/InvestmentIncomeExciseTaxAmt'),
  (450218, NULL, NULL, 'Overpayment Amt', 'CURRENCY', 'ReturnData/IRS990PF/ExciseTaxBasedOnInvstIncmGrp/OverpaymentAmt'),
  (450219, NULL, NULL, 'Refund Amt', 'CURRENCY', 'ReturnData/IRS990PF/ExciseTaxBasedOnInvstIncmGrp/RefundAmt'),
  (450220, NULL, NULL, 'Subtitle A Tax Amt', 'CURRENCY', 'ReturnData/IRS990PF/ExciseTaxBasedOnInvstIncmGrp/SubtitleATaxAmt'),
  (450221, NULL, NULL, 'Subtotal Amt', 'CURRENCY', 'ReturnData/IRS990PF/ExciseTaxBasedOnInvstIncmGrp/SubtotalAmt'),
  (450222, NULL, NULL, 'Tax Based On Investment Income Amt', 'CURRENCY', 'ReturnData/IRS990PF/ExciseTaxBasedOnInvstIncmGrp/TaxBasedOnInvestmentIncomeAmt'),
  (450223, NULL, NULL, 'Tax Due Amt', 'CURRENCY', 'ReturnData/IRS990PF/ExciseTaxBasedOnInvstIncmGrp/TaxDueAmt'),
  (450224, NULL, NULL, 'Tax Under Section511Amt', 'CURRENCY', 'ReturnData/IRS990PF/ExciseTaxBasedOnInvstIncmGrp/TaxUnderSection511Amt'),
  (450225, NULL, NULL, 'Total Payments And Credits Amt', 'CURRENCY', 'ReturnData/IRS990PF/ExciseTaxBasedOnInvstIncmGrp/TotalPaymentsAndCreditsAmt');

-- 990PF / Form990PF Balance Sheets Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450226, 45011, '1', 'Accounts Payable BOY Amt', 'CURRENCY'),
  (450227, 45011, '2', 'Accounts Payable EOY Amt', 'CURRENCY'),
  (450228, 45011, '3', 'Acct Rcvbl Allwnc Dbtfl Acct Amt', 'CURRENCY'),
  (450229, 45011, '4', 'Acct Rcvbl Amt', 'CURRENCY'),
  (450230, 45011, '5', 'Acct Rcvbl BOY Amt', 'CURRENCY'),
  (450231, 45011, '6', 'Acct Rcvbl EOY Amt', 'CURRENCY'),
  (450232, 45011, '7', 'Acct Rcvbl EOYFMV Amt', 'CURRENCY'),
  (450233, 45011, '8', 'Additional Paid In Capital BOY Amt', 'CURRENCY'),
  (450234, 45011, '9', 'Additional Paid In Capital EOY Amt', 'CURRENCY'),
  (450235, 45011, '10', 'Capital Stock BOY Amt', 'CURRENCY'),
  (450236, 45011, '11', 'Capital Stock EOY Amt', 'CURRENCY'),
  (450237, 45011, '12', 'Cash BOY Amt', 'CURRENCY'),
  (450238, 45011, '13', 'Cash EOY Amt', 'CURRENCY'),
  (450239, 45011, '14', 'Cash EOYFMV Amt', 'CURRENCY'),
  (450240, 45011, '15', 'Corporate Bonds BOY Amt', 'CURRENCY'),
  (450241, 45011, '16', 'Corporate Bonds EOY Amt', 'CURRENCY'),
  (450242, 45011, '17', 'Corporate Bonds EOYFMV Amt', 'CURRENCY'),
  (450243, 45011, '18', 'Corporate Stock BOY Amt', 'CURRENCY'),
  (450244, 45011, '19', 'Corporate Stock EOY Amt', 'CURRENCY'),
  (450245, 45011, '20', 'Corporate Stock EOYFMV Amt', 'CURRENCY'),
  (450246, 45011, '21', 'Deferred Revenue BOY Amt', 'CURRENCY'),
  (450247, 45011, '22', 'Deferred Revenue EOY Amt', 'CURRENCY'),
  (450248, 45011, '23', 'Grants Payable BOY Amt', 'CURRENCY'),
  (450249, 45011, '24', 'Grants Payable EOY Amt', 'CURRENCY'),
  (450250, 45011, '25', 'Grants Receivable BOY Amt', 'CURRENCY'),
  (450251, 45011, '26', 'Grants Receivable EOY Amt', 'CURRENCY'),
  (450252, 45011, '27', 'Grants Receivable EOYFMV Amt', 'CURRENCY'),
  (450253, 45011, '28', 'Inventories BOY Amt', 'CURRENCY'),
  (450254, 45011, '29', 'Inventories EOY Amt', 'CURRENCY'),
  (450255, 45011, '30', 'Inventories EOYFMV Amt', 'CURRENCY'),
  (450256, 45011, '31', 'Invst Land Accum Depreciation Amt', 'CURRENCY'),
  (450257, 45011, '32', 'Invst Land Cost Or Other Basis Amt', 'CURRENCY'),
  (450258, 45011, '33', 'Land BOY Amt', 'CURRENCY'),
  (450259, 45011, '34', 'Land Bldg Equip Accum Deprec Amt', 'CURRENCY'),
  (450260, 45011, '35', 'Land Bldg Equip Cost Or Other Bss Amt', 'CURRENCY'),
  (450261, 45011, '36', 'Land Bldg Investments EOY Amt', 'CURRENCY'),
  (450262, 45011, '37', 'Land EOY Amt', 'CURRENCY'),
  (450263, 45011, '38', 'Land EOYFMV Amt', 'CURRENCY'),
  (450264, 45011, '39', 'Loans From Officers BOY Amt', 'CURRENCY'),
  (450265, 45011, '40', 'Loans From Officers EOY Amt', 'CURRENCY'),
  (450266, 45011, '41', 'Mortgage Loans BOY Amt', 'CURRENCY'),
  (450267, 45011, '42', 'Mortgage Loans EOY Amt', 'CURRENCY'),
  (450268, 45011, '43', 'Mortgage Loans EOYFMV Amt', 'CURRENCY'),
  (450269, 45011, '44', 'Mortgages And Notes Payable EOY Amt', 'CURRENCY'),
  (450270, 45011, '45', 'No Donor Rstr Net Assests BOY Amt', 'CURRENCY'),
  (450271, 45011, '46', 'No Donor Rstr Net Assests EOY Amt', 'CURRENCY'),
  (450272, 45011, '47', 'Org Does Not Follow FASB117Ind', 'BOOLEAN'),
  (450273, 45011, '48', 'Organization Follows FASB117Ind', 'BOOLEAN'),
  (450274, 45011, '49', 'Other Assets BOY Amt', 'CURRENCY'),
  (450275, 45011, '50', 'Other Assets EOY Amt', 'CURRENCY'),
  (450276, 45011, '51', 'Other Assets EOYFMV Amt', 'CURRENCY'),
  (450277, 45011, '52', 'Other Investments BOY Amt', 'CURRENCY'),
  (450278, 45011, '53', 'Other Investments EOY Amt', 'CURRENCY'),
  (450279, 45011, '54', 'Other Investments EOYFMV Amt', 'CURRENCY'),
  (450280, 45011, '55', 'Other Liabilities BOY Amt', 'CURRENCY'),
  (450281, 45011, '56', 'Other Liabilities EOY Amt', 'CURRENCY'),
  (450282, 45011, '57', 'Other Nts And Loans Rcvbl Amt', 'CURRENCY'),
  (450283, 45011, '58', 'Other Nts And Loans Rcvbl BOY Amt', 'CURRENCY'),
  (450284, 45011, '59', 'Other Nts And Loans Rcvbl EOY Amt', 'CURRENCY'),
  (450285, 45011, '60', 'Other Nts And Loans Rcvbl EOYFMV Amt', 'CURRENCY'),
  (450286, 45011, '61', 'Other Rcvbl Allwnc Dbtfl Acct Amt', 'CURRENCY'),
  (450287, 45011, '62', 'Pledges Rcvbl Allwnc Dbtfl Acct Amt', 'CURRENCY'),
  (450288, 45011, '63', 'Pledges Rcvbl Amt', 'CURRENCY'),
  (450289, 45011, '64', 'Pledges Rcvbl BOY Amt', 'CURRENCY'),
  (450290, 45011, '65', 'Pledges Rcvbl EOY Amt', 'CURRENCY'),
  (450291, 45011, '66', 'Pledges Rcvbl EOYFMV Amt', 'CURRENCY'),
  (450292, 45011, '67', 'Prepaid Expenses BOY Amt', 'CURRENCY'),
  (450293, 45011, '68', 'Prepaid Expenses EOY Amt', 'CURRENCY'),
  (450294, 45011, '69', 'Prepaid Expenses EOYFMV Amt', 'CURRENCY'),
  (450295, 45011, '70', 'Rcvbl From Officers BOY Amt', 'CURRENCY'),
  (450296, 45011, '71', 'Rcvbl From Officers EOY Amt', 'CURRENCY'),
  (450297, 45011, '72', 'Retained Earning BOY Amt', 'CURRENCY'),
  (450298, 45011, '73', 'Retained Earning EOY Amt', 'CURRENCY'),
  (450299, 45011, '74', 'Sav And Temp Cash Invst BOY Amt', 'CURRENCY'),
  (450300, 45011, '75', 'Sav And Temp Cash Invst EOY Amt', 'CURRENCY'),
  (450301, 45011, '76', 'Sav And Temp Cash Invst EOYFMV Amt', 'CURRENCY'),
  (450302, 45011, '77', 'Tot Net Ast Or Fund Balances BOY Amt', 'CURRENCY'),
  (450303, 45011, '78', 'Tot Net Ast Or Fund Balances EOY Amt', 'CURRENCY'),
  (450304, 45011, '79', 'Total Assets BOY Amt', 'CURRENCY'),
  (450305, 45011, '80', 'Total Assets EOY Amt', 'CURRENCY'),
  (450306, 45011, '81', 'Total Assets EOYFMV Amt', 'CURRENCY'),
  (450307, 45011, '82', 'Total Liabilities BOY Amt', 'CURRENCY'),
  (450308, 45011, '83', 'Total Liabilities EOY Amt', 'CURRENCY'),
  (450309, 45011, '84', 'Total Liabilities Net Ast BOY Amt', 'CURRENCY'),
  (450310, 45011, '85', 'Total Liabilities Net Ast EOY Amt', 'CURRENCY'),
  (450311, 45011, '86', 'US Government Obligations BOY Amt', 'CURRENCY'),
  (450312, 45011, '87', 'US Government Obligations EOY Amt', 'CURRENCY'),
  (450313, 45011, '88', 'US Govt Obligations EOYFMV Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450226, NULL, NULL, 'Accounts Payable BOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/AccountsPayableBOYAmt'),
  (450227, NULL, NULL, 'Accounts Payable EOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/AccountsPayableEOYAmt'),
  (450228, NULL, NULL, 'Acct Rcvbl Allwnc Dbtfl Acct Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/AcctRcvblAllwncDbtflAcctAmt'),
  (450229, NULL, NULL, 'Acct Rcvbl Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/AcctRcvblAmt'),
  (450230, NULL, NULL, 'Acct Rcvbl BOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/AcctRcvblBOYAmt'),
  (450231, NULL, NULL, 'Acct Rcvbl EOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/AcctRcvblEOYAmt'),
  (450232, NULL, NULL, 'Acct Rcvbl EOYFMV Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/AcctRcvblEOYFMVAmt'),
  (450233, NULL, NULL, 'Additional Paid In Capital BOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/AdditionalPaidInCapitalBOYAmt'),
  (450234, NULL, NULL, 'Additional Paid In Capital EOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/AdditionalPaidInCapitalEOYAmt'),
  (450235, NULL, NULL, 'Capital Stock BOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/CapitalStockBOYAmt'),
  (450236, NULL, NULL, 'Capital Stock EOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/CapitalStockEOYAmt'),
  (450237, NULL, NULL, 'Cash BOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/CashBOYAmt'),
  (450238, NULL, NULL, 'Cash EOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/CashEOYAmt'),
  (450239, NULL, NULL, 'Cash EOYFMV Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/CashEOYFMVAmt'),
  (450240, NULL, NULL, 'Corporate Bonds BOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/CorporateBondsBOYAmt'),
  (450241, NULL, NULL, 'Corporate Bonds EOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/CorporateBondsEOYAmt'),
  (450242, NULL, NULL, 'Corporate Bonds EOYFMV Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/CorporateBondsEOYFMVAmt'),
  (450243, NULL, NULL, 'Corporate Stock BOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/CorporateStockBOYAmt'),
  (450244, NULL, NULL, 'Corporate Stock EOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/CorporateStockEOYAmt'),
  (450245, NULL, NULL, 'Corporate Stock EOYFMV Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/CorporateStockEOYFMVAmt'),
  (450246, NULL, NULL, 'Deferred Revenue BOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/DeferredRevenueBOYAmt'),
  (450247, NULL, NULL, 'Deferred Revenue EOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/DeferredRevenueEOYAmt'),
  (450248, NULL, NULL, 'Grants Payable BOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/GrantsPayableBOYAmt'),
  (450249, NULL, NULL, 'Grants Payable EOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/GrantsPayableEOYAmt'),
  (450250, NULL, NULL, 'Grants Receivable BOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/GrantsReceivableBOYAmt'),
  (450251, NULL, NULL, 'Grants Receivable EOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/GrantsReceivableEOYAmt'),
  (450252, NULL, NULL, 'Grants Receivable EOYFMV Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/GrantsReceivableEOYFMVAmt'),
  (450253, NULL, NULL, 'Inventories BOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/InventoriesBOYAmt'),
  (450254, NULL, NULL, 'Inventories EOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/InventoriesEOYAmt'),
  (450255, NULL, NULL, 'Inventories EOYFMV Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/InventoriesEOYFMVAmt'),
  (450256, NULL, NULL, 'Invst Land Accum Depreciation Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/InvstLandAccumDepreciationAmt'),
  (450257, NULL, NULL, 'Invst Land Cost Or Other Basis Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/InvstLandCostOrOtherBasisAmt'),
  (450258, NULL, NULL, 'Land BOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/LandBOYAmt'),
  (450259, NULL, NULL, 'Land Bldg Equip Accum Deprec Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/LandBldgEquipAccumDeprecAmt'),
  (450260, NULL, NULL, 'Land Bldg Equip Cost Or Other Bss Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/LandBldgEquipCostOrOtherBssAmt'),
  (450261, NULL, NULL, 'Land Bldg Investments EOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/LandBldgInvestmentsEOYAmt'),
  (450262, NULL, NULL, 'Land EOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/LandEOYAmt'),
  (450263, NULL, NULL, 'Land EOYFMV Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/LandEOYFMVAmt'),
  (450264, NULL, NULL, 'Loans From Officers BOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/LoansFromOfficersBOYAmt'),
  (450265, NULL, NULL, 'Loans From Officers EOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/LoansFromOfficersEOYAmt'),
  (450266, NULL, NULL, 'Mortgage Loans BOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/MortgageLoansBOYAmt'),
  (450267, NULL, NULL, 'Mortgage Loans EOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/MortgageLoansEOYAmt'),
  (450268, NULL, NULL, 'Mortgage Loans EOYFMV Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/MortgageLoansEOYFMVAmt'),
  (450269, NULL, NULL, 'Mortgages And Notes Payable EOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/MortgagesAndNotesPayableEOYAmt'),
  (450270, NULL, NULL, 'No Donor Rstr Net Assests BOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/NoDonorRstrNetAssestsBOYAmt'),
  (450271, NULL, NULL, 'No Donor Rstr Net Assests EOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/NoDonorRstrNetAssestsEOYAmt'),
  (450272, NULL, NULL, 'Org Does Not Follow FASB117Ind', 'BOOLEAN', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/OrgDoesNotFollowFASB117Ind'),
  (450273, NULL, NULL, 'Organization Follows FASB117Ind', 'BOOLEAN', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/OrganizationFollowsFASB117Ind'),
  (450274, NULL, NULL, 'Other Assets BOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/OtherAssetsBOYAmt'),
  (450275, NULL, NULL, 'Other Assets EOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/OtherAssetsEOYAmt'),
  (450276, NULL, NULL, 'Other Assets EOYFMV Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/OtherAssetsEOYFMVAmt'),
  (450277, NULL, NULL, 'Other Investments BOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/OtherInvestmentsBOYAmt'),
  (450278, NULL, NULL, 'Other Investments EOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/OtherInvestmentsEOYAmt'),
  (450279, NULL, NULL, 'Other Investments EOYFMV Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/OtherInvestmentsEOYFMVAmt'),
  (450280, NULL, NULL, 'Other Liabilities BOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/OtherLiabilitiesBOYAmt'),
  (450281, NULL, NULL, 'Other Liabilities EOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/OtherLiabilitiesEOYAmt'),
  (450282, NULL, NULL, 'Other Nts And Loans Rcvbl Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/OtherNtsAndLoansRcvblAmt'),
  (450283, NULL, NULL, 'Other Nts And Loans Rcvbl BOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/OtherNtsAndLoansRcvblBOYAmt'),
  (450284, NULL, NULL, 'Other Nts And Loans Rcvbl EOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/OtherNtsAndLoansRcvblEOYAmt'),
  (450285, NULL, NULL, 'Other Nts And Loans Rcvbl EOYFMV Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/OtherNtsAndLoansRcvblEOYFMVAmt'),
  (450286, NULL, NULL, 'Other Rcvbl Allwnc Dbtfl Acct Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/OtherRcvblAllwncDbtflAcctAmt'),
  (450287, NULL, NULL, 'Pledges Rcvbl Allwnc Dbtfl Acct Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/PledgesRcvblAllwncDbtflAcctAmt'),
  (450288, NULL, NULL, 'Pledges Rcvbl Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/PledgesRcvblAmt'),
  (450289, NULL, NULL, 'Pledges Rcvbl BOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/PledgesRcvblBOYAmt'),
  (450290, NULL, NULL, 'Pledges Rcvbl EOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/PledgesRcvblEOYAmt'),
  (450291, NULL, NULL, 'Pledges Rcvbl EOYFMV Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/PledgesRcvblEOYFMVAmt'),
  (450292, NULL, NULL, 'Prepaid Expenses BOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/PrepaidExpensesBOYAmt'),
  (450293, NULL, NULL, 'Prepaid Expenses EOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/PrepaidExpensesEOYAmt'),
  (450294, NULL, NULL, 'Prepaid Expenses EOYFMV Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/PrepaidExpensesEOYFMVAmt'),
  (450295, NULL, NULL, 'Rcvbl From Officers BOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/RcvblFromOfficersBOYAmt'),
  (450296, NULL, NULL, 'Rcvbl From Officers EOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/RcvblFromOfficersEOYAmt'),
  (450297, NULL, NULL, 'Retained Earning BOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/RetainedEarningBOYAmt'),
  (450298, NULL, NULL, 'Retained Earning EOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/RetainedEarningEOYAmt'),
  (450299, NULL, NULL, 'Sav And Temp Cash Invst BOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/SavAndTempCashInvstBOYAmt'),
  (450300, NULL, NULL, 'Sav And Temp Cash Invst EOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/SavAndTempCashInvstEOYAmt'),
  (450301, NULL, NULL, 'Sav And Temp Cash Invst EOYFMV Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/SavAndTempCashInvstEOYFMVAmt'),
  (450302, NULL, NULL, 'Tot Net Ast Or Fund Balances BOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/TotNetAstOrFundBalancesBOYAmt'),
  (450303, NULL, NULL, 'Tot Net Ast Or Fund Balances EOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/TotNetAstOrFundBalancesEOYAmt'),
  (450304, NULL, NULL, 'Total Assets BOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/TotalAssetsBOYAmt'),
  (450305, NULL, NULL, 'Total Assets EOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/TotalAssetsEOYAmt'),
  (450306, NULL, NULL, 'Total Assets EOYFMV Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/TotalAssetsEOYFMVAmt'),
  (450307, NULL, NULL, 'Total Liabilities BOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/TotalLiabilitiesBOYAmt'),
  (450308, NULL, NULL, 'Total Liabilities EOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/TotalLiabilitiesEOYAmt'),
  (450309, NULL, NULL, 'Total Liabilities Net Ast BOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/TotalLiabilitiesNetAstBOYAmt'),
  (450310, NULL, NULL, 'Total Liabilities Net Ast EOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/TotalLiabilitiesNetAstEOYAmt'),
  (450311, NULL, NULL, 'US Government Obligations BOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/USGovernmentObligationsBOYAmt'),
  (450312, NULL, NULL, 'US Government Obligations EOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/USGovernmentObligationsEOYAmt'),
  (450313, NULL, NULL, 'US Govt Obligations EOYFMV Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/USGovtObligationsEOYFMVAmt');

-- 990PF / Gain Loss Sale Other Asset Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450314, 45012, '1', 'Accumulated Depreciation Amt', 'CURRENCY'),
  (450315, 45012, '2', 'Acquired Dt', 'DATE'),
  (450316, 45012, '3', 'Asset Desc', 'TEXT'),
  (450317, 45012, '4', 'Basis Amt', 'CURRENCY'),
  (450318, 45012, '5', 'Gross Sales Price Amt', 'CURRENCY'),
  (450319, 45012, '6', 'How Acquired Txt', 'TEXT'),
  (450320, 45012, '7', 'Business Name Line1Txt', 'TEXT'),
  (450321, 45012, '8', 'Sales Expense Amt', 'CURRENCY'),
  (450322, 45012, '9', 'Sold Dt', 'DATE');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450314, NULL, NULL, 'Accumulated Depreciation Amt', 'CURRENCY', 'ReturnData/GainLossSaleOtherAssetsSch/GainLossSaleOtherAssetGrp/AccumulatedDepreciationAmt'),
  (450315, NULL, NULL, 'Acquired Dt', 'DATE', 'ReturnData/GainLossSaleOtherAssetsSch/GainLossSaleOtherAssetGrp/AcquiredDt'),
  (450316, NULL, NULL, 'Asset Desc', 'TEXT', 'ReturnData/GainLossSaleOtherAssetsSch/GainLossSaleOtherAssetGrp/AssetDesc'),
  (450317, NULL, NULL, 'Basis Amt', 'CURRENCY', 'ReturnData/GainLossSaleOtherAssetsSch/GainLossSaleOtherAssetGrp/BasisAmt'),
  (450318, NULL, NULL, 'Gross Sales Price Amt', 'CURRENCY', 'ReturnData/GainLossSaleOtherAssetsSch/GainLossSaleOtherAssetGrp/GrossSalesPriceAmt'),
  (450319, NULL, NULL, 'How Acquired Txt', 'TEXT', 'ReturnData/GainLossSaleOtherAssetsSch/GainLossSaleOtherAssetGrp/HowAcquiredTxt'),
  (450320, NULL, NULL, 'Business Name Line1Txt', 'TEXT', 'ReturnData/GainLossSaleOtherAssetsSch/GainLossSaleOtherAssetGrp/PurchaserNameGrp/BusinessName/BusinessNameLine1Txt'),
  (450321, NULL, NULL, 'Sales Expense Amt', 'CURRENCY', 'ReturnData/GainLossSaleOtherAssetsSch/GainLossSaleOtherAssetGrp/SalesExpenseAmt'),
  (450322, NULL, NULL, 'Sold Dt', 'DATE', 'ReturnData/GainLossSaleOtherAssetsSch/GainLossSaleOtherAssetGrp/SoldDt');

-- 990PF / General Explanation Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450323, 45013, '1', 'Form And Line Reference Desc', 'TEXT'),
  (450324, 45013, '2', 'Identifier Txt', 'TEXT'),
  (450325, 45013, '3', 'Medium Explanation Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450323, NULL, NULL, 'Form And Line Reference Desc', 'TEXT', 'ReturnData/GeneralExplanationAttachment/GeneralExplanationGrp/FormAndLineReferenceDesc'),
  (450324, NULL, NULL, 'Identifier Txt', 'TEXT', 'ReturnData/GeneralExplanationAttachment/GeneralExplanationGrp/IdentifierTxt'),
  (450325, NULL, NULL, 'Medium Explanation Txt', 'TEXT', 'ReturnData/GeneralExplanationAttachment/GeneralExplanationGrp/MediumExplanationTxt');

-- 990PF / Investments Corporate Bonds Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450326, 45014, '1', 'Bond Nm', 'TEXT'),
  (450327, 45014, '2', 'EOY Book Value Amt', 'CURRENCY'),
  (450328, 45014, '3', 'EOYFMV Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450326, NULL, NULL, 'Bond Nm', 'TEXT', 'ReturnData/InvestmentsCorpBondsSchedule/InvestmentsCorporateBondsGrp/BondNm'),
  (450327, NULL, NULL, 'EOY Book Value Amt', 'CURRENCY', 'ReturnData/InvestmentsCorpBondsSchedule/InvestmentsCorporateBondsGrp/EOYBookValueAmt'),
  (450328, NULL, NULL, 'EOYFMV Amt', 'CURRENCY', 'ReturnData/InvestmentsCorpBondsSchedule/InvestmentsCorporateBondsGrp/EOYFMVAmt');

-- 990PF / Investments Corporate Stock Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450329, 45015, '1', 'EOY Book Value Amt', 'CURRENCY'),
  (450330, 45015, '2', 'EOYFMV Amt', 'CURRENCY'),
  (450331, 45015, '3', 'Stock Nm', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450329, NULL, NULL, 'EOY Book Value Amt', 'CURRENCY', 'ReturnData/InvestmentsCorpStockSchedule/InvestmentsCorporateStockGrp/EOYBookValueAmt'),
  (450330, NULL, NULL, 'EOYFMV Amt', 'CURRENCY', 'ReturnData/InvestmentsCorpStockSchedule/InvestmentsCorporateStockGrp/EOYFMVAmt'),
  (450331, NULL, NULL, 'Stock Nm', 'TEXT', 'ReturnData/InvestmentsCorpStockSchedule/InvestmentsCorporateStockGrp/StockNm');

-- 990PF / Investments Other Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450332, 45016, '1', 'Book Value Amt', 'CURRENCY'),
  (450333, 45016, '2', 'Category Or Item Txt', 'TEXT'),
  (450334, 45016, '3', 'EOYFMV Amt', 'CURRENCY'),
  (450335, 45016, '4', 'Listed At Cost Or FMV Cd', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450332, NULL, NULL, 'Book Value Amt', 'CURRENCY', 'ReturnData/InvestmentsOtherSchedule2/InvestmentsOtherGrp/BookValueAmt'),
  (450333, NULL, NULL, 'Category Or Item Txt', 'TEXT', 'ReturnData/InvestmentsOtherSchedule2/InvestmentsOtherGrp/CategoryOrItemTxt'),
  (450334, NULL, NULL, 'EOYFMV Amt', 'CURRENCY', 'ReturnData/InvestmentsOtherSchedule2/InvestmentsOtherGrp/EOYFMVAmt'),
  (450335, NULL, NULL, 'Listed At Cost Or FMV Cd', 'TEXT', 'ReturnData/InvestmentsOtherSchedule2/InvestmentsOtherGrp/ListedAtCostOrFMVCd');

-- 990PF / Land Etc Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450336, 45017, '1', 'Accumulated Depreciation Amt', 'CURRENCY'),
  (450337, 45017, '2', 'Book Value Amt', 'CURRENCY'),
  (450338, 45017, '3', 'Category Or Item Txt', 'TEXT'),
  (450339, 45017, '4', 'Cost Or Other Basis Amt', 'CURRENCY'),
  (450340, 45017, '5', 'EOYFMV Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450336, NULL, NULL, 'Accumulated Depreciation Amt', 'CURRENCY', 'ReturnData/LandEtcSchedule2/LandEtcGrp/AccumulatedDepreciationAmt'),
  (450337, NULL, NULL, 'Book Value Amt', 'CURRENCY', 'ReturnData/LandEtcSchedule2/LandEtcGrp/BookValueAmt'),
  (450338, NULL, NULL, 'Category Or Item Txt', 'TEXT', 'ReturnData/LandEtcSchedule2/LandEtcGrp/CategoryOrItemTxt'),
  (450339, NULL, NULL, 'Cost Or Other Basis Amt', 'CURRENCY', 'ReturnData/LandEtcSchedule2/LandEtcGrp/CostOrOtherBasisAmt'),
  (450340, NULL, NULL, 'EOYFMV Amt', 'CURRENCY', 'ReturnData/LandEtcSchedule2/LandEtcGrp/EOYFMVAmt');

-- 990PF / Legal Fees Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450341, 45018, '1', 'Adjusted Net Income Amt', 'CURRENCY'),
  (450342, 45018, '2', 'Category Txt', 'TEXT'),
  (450343, 45018, '3', 'Disbursements Charitable Prps Amt', 'CURRENCY'),
  (450344, 45018, '4', 'Legal Fees Amt', 'CURRENCY'),
  (450345, 45018, '5', 'Net Investment Income Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450341, NULL, NULL, 'Adjusted Net Income Amt', 'CURRENCY', 'ReturnData/LegalFeesSchedule/LegalFeesGrp/AdjustedNetIncomeAmt'),
  (450342, NULL, NULL, 'Category Txt', 'TEXT', 'ReturnData/LegalFeesSchedule/LegalFeesGrp/CategoryTxt'),
  (450343, NULL, NULL, 'Disbursements Charitable Prps Amt', 'CURRENCY', 'ReturnData/LegalFeesSchedule/LegalFeesGrp/DisbursementsCharitablePrpsAmt'),
  (450344, NULL, NULL, 'Legal Fees Amt', 'CURRENCY', 'ReturnData/LegalFeesSchedule/LegalFeesGrp/LegalFeesAmt'),
  (450345, NULL, NULL, 'Net Investment Income Amt', 'CURRENCY', 'ReturnData/LegalFeesSchedule/LegalFeesGrp/NetInvestmentIncomeAmt');

-- 990PF / Minimum Investment Return Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450346, 45019, '1', 'Acquisition Indebtedness Amt', 'CURRENCY'),
  (450347, 45019, '2', 'Adjusted Total FMV Of Unused Ast Amt', 'CURRENCY'),
  (450348, 45019, '3', 'Average Monthly Cash Balances Amt', 'CURRENCY'),
  (450349, 45019, '4', 'Average Monthly FMV Of Sec Amt', 'CURRENCY'),
  (450350, 45019, '5', 'Cash Deemed Charitable Amt', 'CURRENCY'),
  (450351, 45019, '6', 'FMV All Other Noncharitable Ast Amt', 'CURRENCY'),
  (450352, 45019, '7', 'Minimum Investment Return Amt', 'CURRENCY'),
  (450353, 45019, '8', 'Net Vl Noncharitable Assets Amt', 'CURRENCY'),
  (450354, 45019, '9', 'Reduction Claimed Amt', 'CURRENCY'),
  (450355, 45019, '10', 'Total FMV Of Unused Assets Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450346, NULL, NULL, 'Acquisition Indebtedness Amt', 'CURRENCY', 'ReturnData/IRS990PF/MinimumInvestmentReturnGrp/AcquisitionIndebtednessAmt'),
  (450347, NULL, NULL, 'Adjusted Total FMV Of Unused Ast Amt', 'CURRENCY', 'ReturnData/IRS990PF/MinimumInvestmentReturnGrp/AdjustedTotalFMVOfUnusedAstAmt'),
  (450348, NULL, NULL, 'Average Monthly Cash Balances Amt', 'CURRENCY', 'ReturnData/IRS990PF/MinimumInvestmentReturnGrp/AverageMonthlyCashBalancesAmt'),
  (450349, NULL, NULL, 'Average Monthly FMV Of Sec Amt', 'CURRENCY', 'ReturnData/IRS990PF/MinimumInvestmentReturnGrp/AverageMonthlyFMVOfSecAmt'),
  (450350, NULL, NULL, 'Cash Deemed Charitable Amt', 'CURRENCY', 'ReturnData/IRS990PF/MinimumInvestmentReturnGrp/CashDeemedCharitableAmt'),
  (450351, NULL, NULL, 'FMV All Other Noncharitable Ast Amt', 'CURRENCY', 'ReturnData/IRS990PF/MinimumInvestmentReturnGrp/FMVAllOtherNoncharitableAstAmt'),
  (450352, NULL, NULL, 'Minimum Investment Return Amt', 'CURRENCY', 'ReturnData/IRS990PF/MinimumInvestmentReturnGrp/MinimumInvestmentReturnAmt'),
  (450353, NULL, NULL, 'Net Vl Noncharitable Assets Amt', 'CURRENCY', 'ReturnData/IRS990PF/MinimumInvestmentReturnGrp/NetVlNoncharitableAssetsAmt'),
  (450354, NULL, NULL, 'Reduction Claimed Amt', 'CURRENCY', 'ReturnData/IRS990PF/MinimumInvestmentReturnGrp/ReductionClaimedAmt'),
  (450355, NULL, NULL, 'Total FMV Of Unused Assets Amt', 'CURRENCY', 'ReturnData/IRS990PF/MinimumInvestmentReturnGrp/TotalFMVOfUnusedAssetsAmt');

-- 990PF / Non Cash Property Contribution Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450356, 45020, '1', 'Contributor Num', 'INTEGER'),
  (450357, 45020, '2', 'Fair Market Value Amt', 'CURRENCY'),
  (450358, 45020, '3', 'Noncash Property Desc', 'TEXT'),
  (450359, 45020, '4', 'Received Dt', 'DATE');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450356, NULL, NULL, 'Contributor Num', 'INTEGER', 'ReturnData/IRS990ScheduleB/NonCashPropertyContributionGrp/ContributorNum'),
  (450357, NULL, NULL, 'Fair Market Value Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleB/NonCashPropertyContributionGrp/FairMarketValueAmt'),
  (450358, NULL, NULL, 'Noncash Property Desc', 'TEXT', 'ReturnData/IRS990ScheduleB/NonCashPropertyContributionGrp/NoncashPropertyDesc'),
  (450359, NULL, NULL, 'Received Dt', 'DATE', 'ReturnData/IRS990ScheduleB/NonCashPropertyContributionGrp/ReceivedDt');

-- 990PF / Officer Dir Trst Key Empl Info Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450360, 45021, '1', 'Comp Of Hghst Pd Cntrct Or NONE Txt', 'TEXT'),
  (450361, 45021, '2', 'Comp Of Hghst Pd Empl Or NONE Txt', 'TEXT'),
  (450362, 45021, '3', 'Business Name Line1Txt', 'TEXT'),
  (450363, 45021, '4', 'Compensation Amt', 'CURRENCY'),
  (450364, 45021, '5', 'Service Type Txt', 'TEXT'),
  (450365, 45021, '6', 'Address Line1Txt', 'TEXT'),
  (450366, 45021, '7', 'City Nm', 'TEXT'),
  (450367, 45021, '8', 'State Abbreviation Cd', 'TEXT'),
  (450368, 45021, '9', 'ZIP Cd', 'TEXT'),
  (450369, 45021, '10', 'Contractor Paid Over50k Cnt', 'INTEGER'),
  (450370, 45021, '11', 'Average Hrs Per Wk Devoted To Pos Rt', 'PERCENT'),
  (450371, 45021, '12', 'Business Name Line1Txt', 'TEXT'),
  (450372, 45021, '13', 'Compensation Amt', 'CURRENCY'),
  (450373, 45021, '14', 'Employee Benefit Program Amt', 'CURRENCY'),
  (450374, 45021, '15', 'Expense Account Other Allwnc Amt', 'CURRENCY'),
  (450375, 45021, '16', 'Person Nm', 'TEXT'),
  (450376, 45021, '17', 'Title Txt', 'TEXT'),
  (450377, 45021, '18', 'Address Line1Txt', 'TEXT'),
  (450378, 45021, '19', 'Address Line2Txt', 'TEXT'),
  (450379, 45021, '20', 'City Nm', 'TEXT'),
  (450380, 45021, '21', 'State Abbreviation Cd', 'TEXT'),
  (450381, 45021, '22', 'ZIP Cd', 'TEXT'),
  (450382, 45021, '23', 'Other Employee Paid Over50k Cnt', 'INTEGER');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450360, NULL, NULL, 'Comp Of Hghst Pd Cntrct Or NONE Txt', 'TEXT', 'ReturnData/IRS990PF/OfficerDirTrstKeyEmplInfoGrp/CompOfHghstPdCntrctOrNONETxt'),
  (450361, NULL, NULL, 'Comp Of Hghst Pd Empl Or NONE Txt', 'TEXT', 'ReturnData/IRS990PF/OfficerDirTrstKeyEmplInfoGrp/CompOfHghstPdEmplOrNONETxt'),
  (450362, NULL, NULL, 'Business Name Line1Txt', 'TEXT', 'ReturnData/IRS990PF/OfficerDirTrstKeyEmplInfoGrp/CompensationOfHghstPdCntrctGrp/BusinessName/BusinessNameLine1Txt'),
  (450363, NULL, NULL, 'Compensation Amt', 'CURRENCY', 'ReturnData/IRS990PF/OfficerDirTrstKeyEmplInfoGrp/CompensationOfHghstPdCntrctGrp/CompensationAmt'),
  (450364, NULL, NULL, 'Service Type Txt', 'TEXT', 'ReturnData/IRS990PF/OfficerDirTrstKeyEmplInfoGrp/CompensationOfHghstPdCntrctGrp/ServiceTypeTxt'),
  (450365, NULL, NULL, 'Address Line1Txt', 'TEXT', 'ReturnData/IRS990PF/OfficerDirTrstKeyEmplInfoGrp/CompensationOfHghstPdCntrctGrp/USAddress/AddressLine1Txt'),
  (450366, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990PF/OfficerDirTrstKeyEmplInfoGrp/CompensationOfHghstPdCntrctGrp/USAddress/CityNm'),
  (450367, NULL, NULL, 'State Abbreviation Cd', 'TEXT', 'ReturnData/IRS990PF/OfficerDirTrstKeyEmplInfoGrp/CompensationOfHghstPdCntrctGrp/USAddress/StateAbbreviationCd'),
  (450368, NULL, NULL, 'ZIP Cd', 'TEXT', 'ReturnData/IRS990PF/OfficerDirTrstKeyEmplInfoGrp/CompensationOfHghstPdCntrctGrp/USAddress/ZIPCd'),
  (450369, NULL, NULL, 'Contractor Paid Over50k Cnt', 'INTEGER', 'ReturnData/IRS990PF/OfficerDirTrstKeyEmplInfoGrp/ContractorPaidOver50kCnt'),
  (450370, NULL, NULL, 'Average Hrs Per Wk Devoted To Pos Rt', 'PERCENT', 'ReturnData/IRS990PF/OfficerDirTrstKeyEmplInfoGrp/OfficerDirTrstKeyEmplGrp/AverageHrsPerWkDevotedToPosRt'),
  (450371, NULL, NULL, 'Business Name Line1Txt', 'TEXT', 'ReturnData/IRS990PF/OfficerDirTrstKeyEmplInfoGrp/OfficerDirTrstKeyEmplGrp/BusinessName/BusinessNameLine1Txt'),
  (450372, NULL, NULL, 'Compensation Amt', 'CURRENCY', 'ReturnData/IRS990PF/OfficerDirTrstKeyEmplInfoGrp/OfficerDirTrstKeyEmplGrp/CompensationAmt'),
  (450373, NULL, NULL, 'Employee Benefit Program Amt', 'CURRENCY', 'ReturnData/IRS990PF/OfficerDirTrstKeyEmplInfoGrp/OfficerDirTrstKeyEmplGrp/EmployeeBenefitProgramAmt'),
  (450374, NULL, NULL, 'Expense Account Other Allwnc Amt', 'CURRENCY', 'ReturnData/IRS990PF/OfficerDirTrstKeyEmplInfoGrp/OfficerDirTrstKeyEmplGrp/ExpenseAccountOtherAllwncAmt'),
  (450375, NULL, NULL, 'Person Nm', 'TEXT', 'ReturnData/IRS990PF/OfficerDirTrstKeyEmplInfoGrp/OfficerDirTrstKeyEmplGrp/PersonNm'),
  (450376, NULL, NULL, 'Title Txt', 'TEXT', 'ReturnData/IRS990PF/OfficerDirTrstKeyEmplInfoGrp/OfficerDirTrstKeyEmplGrp/TitleTxt'),
  (450377, NULL, NULL, 'Address Line1Txt', 'TEXT', 'ReturnData/IRS990PF/OfficerDirTrstKeyEmplInfoGrp/OfficerDirTrstKeyEmplGrp/USAddress/AddressLine1Txt'),
  (450378, NULL, NULL, 'Address Line2Txt', 'TEXT', 'ReturnData/IRS990PF/OfficerDirTrstKeyEmplInfoGrp/OfficerDirTrstKeyEmplGrp/USAddress/AddressLine2Txt'),
  (450379, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990PF/OfficerDirTrstKeyEmplInfoGrp/OfficerDirTrstKeyEmplGrp/USAddress/CityNm'),
  (450380, NULL, NULL, 'State Abbreviation Cd', 'TEXT', 'ReturnData/IRS990PF/OfficerDirTrstKeyEmplInfoGrp/OfficerDirTrstKeyEmplGrp/USAddress/StateAbbreviationCd'),
  (450381, NULL, NULL, 'ZIP Cd', 'TEXT', 'ReturnData/IRS990PF/OfficerDirTrstKeyEmplInfoGrp/OfficerDirTrstKeyEmplGrp/USAddress/ZIPCd'),
  (450382, NULL, NULL, 'Other Employee Paid Over50k Cnt', 'INTEGER', 'ReturnData/IRS990PF/OfficerDirTrstKeyEmplInfoGrp/OtherEmployeePaidOver50kCnt');

-- 990PF / Other Assets Schedule Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450383, 45022, '1', 'BOY Book Value Amt', 'CURRENCY'),
  (450384, 45022, '2', 'Desc', 'TEXT'),
  (450385, 45022, '3', 'EOY Book Value Amt', 'CURRENCY'),
  (450386, 45022, '4', 'EOYFMV Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450383, NULL, NULL, 'BOY Book Value Amt', 'CURRENCY', 'ReturnData/OtherAssetsSchedule/OtherAssetsScheduleGrp/BOYBookValueAmt'),
  (450384, NULL, NULL, 'Desc', 'TEXT', 'ReturnData/OtherAssetsSchedule/OtherAssetsScheduleGrp/Desc'),
  (450385, NULL, NULL, 'EOY Book Value Amt', 'CURRENCY', 'ReturnData/OtherAssetsSchedule/OtherAssetsScheduleGrp/EOYBookValueAmt'),
  (450386, NULL, NULL, 'EOYFMV Amt', 'CURRENCY', 'ReturnData/OtherAssetsSchedule/OtherAssetsScheduleGrp/EOYFMVAmt');

-- 990PF / Other Decreases Detail
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450387, 45023, '1', 'Amt', 'CURRENCY'),
  (450388, 45023, '2', 'Desc', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450387, NULL, NULL, 'Amt', 'CURRENCY', 'ReturnData/OtherDecreasesSchedule/OtherDecreasesDetail/Amt'),
  (450388, NULL, NULL, 'Desc', 'TEXT', 'ReturnData/OtherDecreasesSchedule/OtherDecreasesDetail/Desc');

-- 990PF / Other Expenses Schedule Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450389, 45024, '1', 'Adjusted Net Income Amt', 'CURRENCY'),
  (450390, 45024, '2', 'Desc', 'TEXT'),
  (450391, 45024, '3', 'Disbursements Charitable Prps Amt', 'CURRENCY'),
  (450392, 45024, '4', 'Net Investment Income Amt', 'CURRENCY'),
  (450393, 45024, '5', 'Revenue And Expenses Per Books Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450389, NULL, NULL, 'Adjusted Net Income Amt', 'CURRENCY', 'ReturnData/OtherExpensesSchedule/OtherExpensesScheduleGrp/AdjustedNetIncomeAmt'),
  (450390, NULL, NULL, 'Desc', 'TEXT', 'ReturnData/OtherExpensesSchedule/OtherExpensesScheduleGrp/Desc'),
  (450391, NULL, NULL, 'Disbursements Charitable Prps Amt', 'CURRENCY', 'ReturnData/OtherExpensesSchedule/OtherExpensesScheduleGrp/DisbursementsCharitablePrpsAmt'),
  (450392, NULL, NULL, 'Net Investment Income Amt', 'CURRENCY', 'ReturnData/OtherExpensesSchedule/OtherExpensesScheduleGrp/NetInvestmentIncomeAmt'),
  (450393, NULL, NULL, 'Revenue And Expenses Per Books Amt', 'CURRENCY', 'ReturnData/OtherExpensesSchedule/OtherExpensesScheduleGrp/RevenueAndExpensesPerBooksAmt');

-- 990PF / Other Income Detail
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450394, 45025, '1', 'Adjusted Net Income Amt', 'CURRENCY'),
  (450395, 45025, '2', 'Desc', 'TEXT'),
  (450396, 45025, '3', 'Net Investment Income Amt', 'CURRENCY'),
  (450397, 45025, '4', 'Revenue And Expenses Per Books Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450394, NULL, NULL, 'Adjusted Net Income Amt', 'CURRENCY', 'ReturnData/OtherIncomeSchedule2/OtherIncomeDetail/AdjustedNetIncomeAmt'),
  (450395, NULL, NULL, 'Desc', 'TEXT', 'ReturnData/OtherIncomeSchedule2/OtherIncomeDetail/Desc'),
  (450396, NULL, NULL, 'Net Investment Income Amt', 'CURRENCY', 'ReturnData/OtherIncomeSchedule2/OtherIncomeDetail/NetInvestmentIncomeAmt'),
  (450397, NULL, NULL, 'Revenue And Expenses Per Books Amt', 'CURRENCY', 'ReturnData/OtherIncomeSchedule2/OtherIncomeDetail/RevenueAndExpensesPerBooksAmt');

-- 990PF / Other Increases Detail
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450398, 45026, '1', 'Amt', 'CURRENCY'),
  (450399, 45026, '2', 'Desc', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450398, NULL, NULL, 'Amt', 'CURRENCY', 'ReturnData/OtherIncreasesSchedule/OtherIncreasesDetail/Amt'),
  (450399, NULL, NULL, 'Desc', 'TEXT', 'ReturnData/OtherIncreasesSchedule/OtherIncreasesDetail/Desc');

-- 990PF / Other Liabilities Detail
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450400, 45027, '1', 'BOY Book Value Amt', 'CURRENCY'),
  (450401, 45027, '2', 'Desc', 'TEXT'),
  (450402, 45027, '3', 'EOY Book Value Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450400, NULL, NULL, 'BOY Book Value Amt', 'CURRENCY', 'ReturnData/OtherLiabilitiesSchedule/OtherLiabilitiesDetail/BOYBookValueAmt'),
  (450401, NULL, NULL, 'Desc', 'TEXT', 'ReturnData/OtherLiabilitiesSchedule/OtherLiabilitiesDetail/Desc'),
  (450402, NULL, NULL, 'EOY Book Value Amt', 'CURRENCY', 'ReturnData/OtherLiabilitiesSchedule/OtherLiabilitiesDetail/EOYBookValueAmt');

-- 990PF / Other Professional Fees Detail
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450403, 45028, '1', 'Adjusted Net Income Amt', 'CURRENCY'),
  (450404, 45028, '2', 'Amt', 'CURRENCY'),
  (450405, 45028, '3', 'Category Txt', 'TEXT'),
  (450406, 45028, '4', 'Disbursements Charitable Prps Amt', 'CURRENCY'),
  (450407, 45028, '5', 'Net Investment Income Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450403, NULL, NULL, 'Adjusted Net Income Amt', 'CURRENCY', 'ReturnData/OtherProfessionalFeesSchedule/OtherProfessionalFeesDetail/AdjustedNetIncomeAmt'),
  (450404, NULL, NULL, 'Amt', 'CURRENCY', 'ReturnData/OtherProfessionalFeesSchedule/OtherProfessionalFeesDetail/Amt'),
  (450405, NULL, NULL, 'Category Txt', 'TEXT', 'ReturnData/OtherProfessionalFeesSchedule/OtherProfessionalFeesDetail/CategoryTxt'),
  (450406, NULL, NULL, 'Disbursements Charitable Prps Amt', 'CURRENCY', 'ReturnData/OtherProfessionalFeesSchedule/OtherProfessionalFeesDetail/DisbursementsCharitablePrpsAmt'),
  (450407, NULL, NULL, 'Net Investment Income Amt', 'CURRENCY', 'ReturnData/OtherProfessionalFeesSchedule/OtherProfessionalFeesDetail/NetInvestmentIncomeAmt');

-- 990PF / PF Qualifying Distributions Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450408, 45029, '1', 'Charitable Assets Acquis Paid Amt', 'CURRENCY'),
  (450409, 45029, '2', 'Expenses And Contributions Amt', 'CURRENCY'),
  (450410, 45029, '3', 'Program Related Invst Total Amt', 'CURRENCY'),
  (450411, 45029, '4', 'Qualifying Distributions Amt', 'CURRENCY'),
  (450412, 45029, '5', 'Set Aside Cash Distri Test Amt', 'CURRENCY'),
  (450413, 45029, '6', 'Set Aside Suitability Test Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450408, NULL, NULL, 'Charitable Assets Acquis Paid Amt', 'CURRENCY', 'ReturnData/IRS990PF/PFQualifyingDistributionsGrp/CharitableAssetsAcquisPaidAmt'),
  (450409, NULL, NULL, 'Expenses And Contributions Amt', 'CURRENCY', 'ReturnData/IRS990PF/PFQualifyingDistributionsGrp/ExpensesAndContributionsAmt'),
  (450410, NULL, NULL, 'Program Related Invst Total Amt', 'CURRENCY', 'ReturnData/IRS990PF/PFQualifyingDistributionsGrp/ProgramRelatedInvstTotalAmt'),
  (450411, NULL, NULL, 'Qualifying Distributions Amt', 'CURRENCY', 'ReturnData/IRS990PF/PFQualifyingDistributionsGrp/QualifyingDistributionsAmt'),
  (450412, NULL, NULL, 'Set Aside Cash Distri Test Amt', 'CURRENCY', 'ReturnData/IRS990PF/PFQualifyingDistributionsGrp/SetAsideCashDistriTestAmt'),
  (450413, NULL, NULL, 'Set Aside Suitability Test Amt', 'CURRENCY', 'ReturnData/IRS990PF/PFQualifyingDistributionsGrp/SetAsideSuitabilityTestAmt');

-- 990PF / Private Operating Foundations Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450414, 45030, '1', 'Current Year Amt', 'CURRENCY'),
  (450415, 45030, '2', 'Total Amt', 'CURRENCY'),
  (450416, 45030, '3', 'Year1Amt', 'CURRENCY'),
  (450417, 45030, '4', 'Year2Amt', 'CURRENCY'),
  (450418, 45030, '5', 'Year3Amt', 'CURRENCY'),
  (450419, 45030, '6', 'Current Year Amt', 'CURRENCY'),
  (450420, 45030, '7', 'Total Amt', 'CURRENCY'),
  (450421, 45030, '8', 'Year1Amt', 'CURRENCY'),
  (450422, 45030, '9', 'Year2Amt', 'CURRENCY'),
  (450423, 45030, '10', 'Year3Amt', 'CURRENCY'),
  (450424, 45030, '11', 'Current Year Amt', 'CURRENCY'),
  (450425, 45030, '12', 'Total Amt', 'CURRENCY'),
  (450426, 45030, '13', 'Year1Amt', 'CURRENCY'),
  (450427, 45030, '14', 'Year2Amt', 'CURRENCY'),
  (450428, 45030, '15', 'Year3Amt', 'CURRENCY'),
  (450429, 45030, '16', 'Current Year Amt', 'CURRENCY'),
  (450430, 45030, '17', 'Total Amt', 'CURRENCY'),
  (450431, 45030, '18', 'Year1Amt', 'CURRENCY'),
  (450432, 45030, '19', 'Year2Amt', 'CURRENCY'),
  (450433, 45030, '20', 'Year3Amt', 'CURRENCY'),
  (450434, 45030, '21', 'Private Operating Fndtn Ruling Dt', 'DATE'),
  (450435, 45030, '22', 'Current Year Amt', 'CURRENCY'),
  (450436, 45030, '23', 'Total Amt', 'CURRENCY'),
  (450437, 45030, '24', 'Year1Amt', 'CURRENCY'),
  (450438, 45030, '25', 'Year2Amt', 'CURRENCY'),
  (450439, 45030, '26', 'Year3Amt', 'CURRENCY'),
  (450440, 45030, '27', 'Current Year Amt', 'CURRENCY'),
  (450441, 45030, '28', 'Total Amt', 'CURRENCY'),
  (450442, 45030, '29', 'Year1Amt', 'CURRENCY'),
  (450443, 45030, '30', 'Year2Amt', 'CURRENCY'),
  (450444, 45030, '31', 'Year3Amt', 'CURRENCY'),
  (450445, 45030, '32', 'Current Year Amt', 'CURRENCY'),
  (450446, 45030, '33', 'Total Amt', 'CURRENCY'),
  (450447, 45030, '34', 'Year1Amt', 'CURRENCY'),
  (450448, 45030, '35', 'Year2Amt', 'CURRENCY'),
  (450449, 45030, '36', 'Year3Amt', 'CURRENCY'),
  (450450, 45030, '37', 'Current Year Amt', 'CURRENCY'),
  (450451, 45030, '38', 'Total Amt', 'CURRENCY'),
  (450452, 45030, '39', 'Year1Amt', 'CURRENCY'),
  (450453, 45030, '40', 'Year2Amt', 'CURRENCY'),
  (450454, 45030, '41', 'Year3Amt', 'CURRENCY'),
  (450455, 45030, '42', 'Section4942j3Ind', 'BOOLEAN'),
  (450456, 45030, '43', 'Current Year Amt', 'CURRENCY'),
  (450457, 45030, '44', 'Total Amt', 'CURRENCY'),
  (450458, 45030, '45', 'Year1Amt', 'CURRENCY'),
  (450459, 45030, '46', 'Year2Amt', 'CURRENCY'),
  (450460, 45030, '47', 'Year3Amt', 'CURRENCY'),
  (450461, 45030, '48', 'Current Year Amt', 'CURRENCY'),
  (450462, 45030, '49', 'Total Amt', 'CURRENCY'),
  (450463, 45030, '50', 'Year1Amt', 'CURRENCY'),
  (450464, 45030, '51', 'Year2Amt', 'CURRENCY'),
  (450465, 45030, '52', 'Year3Amt', 'CURRENCY'),
  (450466, 45030, '53', 'Current Year Amt', 'CURRENCY'),
  (450467, 45030, '54', 'Total Amt', 'CURRENCY'),
  (450468, 45030, '55', 'Year1Amt', 'CURRENCY'),
  (450469, 45030, '56', 'Year2Amt', 'CURRENCY'),
  (450470, 45030, '57', 'Year3Amt', 'CURRENCY'),
  (450471, 45030, '58', 'Current Year Amt', 'CURRENCY'),
  (450472, 45030, '59', 'Total Amt', 'CURRENCY'),
  (450473, 45030, '60', 'Year1Amt', 'CURRENCY'),
  (450474, 45030, '61', 'Year2Amt', 'CURRENCY'),
  (450475, 45030, '62', 'Year3Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450414, NULL, NULL, 'Current Year Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/GrossInvestmentIncomeGrp/CurrentYearAmt'),
  (450415, NULL, NULL, 'Total Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/GrossInvestmentIncomeGrp/TotalAmt'),
  (450416, NULL, NULL, 'Year1Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/GrossInvestmentIncomeGrp/Year1Amt'),
  (450417, NULL, NULL, 'Year2Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/GrossInvestmentIncomeGrp/Year2Amt'),
  (450418, NULL, NULL, 'Year3Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/GrossInvestmentIncomeGrp/Year3Amt'),
  (450419, NULL, NULL, 'Current Year Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/LargestSupportFromEOGrp/CurrentYearAmt'),
  (450420, NULL, NULL, 'Total Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/LargestSupportFromEOGrp/TotalAmt'),
  (450421, NULL, NULL, 'Year1Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/LargestSupportFromEOGrp/Year1Amt'),
  (450422, NULL, NULL, 'Year2Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/LargestSupportFromEOGrp/Year2Amt'),
  (450423, NULL, NULL, 'Year3Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/LargestSupportFromEOGrp/Year3Amt'),
  (450424, NULL, NULL, 'Current Year Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/LessorAdjNetIncmMinInvstRetGrp/CurrentYearAmt'),
  (450425, NULL, NULL, 'Total Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/LessorAdjNetIncmMinInvstRetGrp/TotalAmt'),
  (450426, NULL, NULL, 'Year1Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/LessorAdjNetIncmMinInvstRetGrp/Year1Amt'),
  (450427, NULL, NULL, 'Year2Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/LessorAdjNetIncmMinInvstRetGrp/Year2Amt'),
  (450428, NULL, NULL, 'Year3Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/LessorAdjNetIncmMinInvstRetGrp/Year3Amt'),
  (450429, NULL, NULL, 'Current Year Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/Pct85LessorAdjIncmOrMinRetGrp/CurrentYearAmt'),
  (450430, NULL, NULL, 'Total Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/Pct85LessorAdjIncmOrMinRetGrp/TotalAmt'),
  (450431, NULL, NULL, 'Year1Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/Pct85LessorAdjIncmOrMinRetGrp/Year1Amt'),
  (450432, NULL, NULL, 'Year2Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/Pct85LessorAdjIncmOrMinRetGrp/Year2Amt'),
  (450433, NULL, NULL, 'Year3Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/Pct85LessorAdjIncmOrMinRetGrp/Year3Amt'),
  (450434, NULL, NULL, 'Private Operating Fndtn Ruling Dt', 'DATE', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/PrivateOperatingFndtnRulingDt'),
  (450435, NULL, NULL, 'Current Year Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/PublicSupportType/CurrentYearAmt'),
  (450436, NULL, NULL, 'Total Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/PublicSupportType/TotalAmt'),
  (450437, NULL, NULL, 'Year1Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/PublicSupportType/Year1Amt'),
  (450438, NULL, NULL, 'Year2Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/PublicSupportType/Year2Amt'),
  (450439, NULL, NULL, 'Year3Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/PublicSupportType/Year3Amt'),
  (450440, NULL, NULL, 'Current Year Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/QualifyingDistriMadeDrtGrp/CurrentYearAmt'),
  (450441, NULL, NULL, 'Total Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/QualifyingDistriMadeDrtGrp/TotalAmt'),
  (450442, NULL, NULL, 'Year1Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/QualifyingDistriMadeDrtGrp/Year1Amt'),
  (450443, NULL, NULL, 'Year2Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/QualifyingDistriMadeDrtGrp/Year2Amt'),
  (450444, NULL, NULL, 'Year3Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/QualifyingDistriMadeDrtGrp/Year3Amt'),
  (450445, NULL, NULL, 'Current Year Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/QualifyingDistriNotUsedDrtGrp/CurrentYearAmt'),
  (450446, NULL, NULL, 'Total Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/QualifyingDistriNotUsedDrtGrp/TotalAmt'),
  (450447, NULL, NULL, 'Year1Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/QualifyingDistriNotUsedDrtGrp/Year1Amt'),
  (450448, NULL, NULL, 'Year2Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/QualifyingDistriNotUsedDrtGrp/Year2Amt'),
  (450449, NULL, NULL, 'Year3Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/QualifyingDistriNotUsedDrtGrp/Year3Amt'),
  (450450, NULL, NULL, 'Current Year Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/QualifyingDistributionsGrp/CurrentYearAmt'),
  (450451, NULL, NULL, 'Total Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/QualifyingDistributionsGrp/TotalAmt'),
  (450452, NULL, NULL, 'Year1Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/QualifyingDistributionsGrp/Year1Amt'),
  (450453, NULL, NULL, 'Year2Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/QualifyingDistributionsGrp/Year2Amt'),
  (450454, NULL, NULL, 'Year3Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/QualifyingDistributionsGrp/Year3Amt'),
  (450455, NULL, NULL, 'Section4942j3Ind', 'BOOLEAN', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/Section4942j3Ind'),
  (450456, NULL, NULL, 'Current Year Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/TotalAssetsGrp/CurrentYearAmt'),
  (450457, NULL, NULL, 'Total Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/TotalAssetsGrp/TotalAmt'),
  (450458, NULL, NULL, 'Year1Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/TotalAssetsGrp/Year1Amt'),
  (450459, NULL, NULL, 'Year2Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/TotalAssetsGrp/Year2Amt'),
  (450460, NULL, NULL, 'Year3Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/TotalAssetsGrp/Year3Amt'),
  (450461, NULL, NULL, 'Current Year Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/TotalAssetsSect4942j3BiGrp/CurrentYearAmt'),
  (450462, NULL, NULL, 'Total Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/TotalAssetsSect4942j3BiGrp/TotalAmt'),
  (450463, NULL, NULL, 'Year1Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/TotalAssetsSect4942j3BiGrp/Year1Amt'),
  (450464, NULL, NULL, 'Year2Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/TotalAssetsSect4942j3BiGrp/Year2Amt'),
  (450465, NULL, NULL, 'Year3Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/TotalAssetsSect4942j3BiGrp/Year3Amt'),
  (450466, NULL, NULL, 'Current Year Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/TotalSupportGrp/CurrentYearAmt'),
  (450467, NULL, NULL, 'Total Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/TotalSupportGrp/TotalAmt'),
  (450468, NULL, NULL, 'Year1Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/TotalSupportGrp/Year1Amt'),
  (450469, NULL, NULL, 'Year2Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/TotalSupportGrp/Year2Amt'),
  (450470, NULL, NULL, 'Year3Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/TotalSupportGrp/Year3Amt'),
  (450471, NULL, NULL, 'Current Year Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/TwoThirdsMinimumInvstRetGrp/CurrentYearAmt'),
  (450472, NULL, NULL, 'Total Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/TwoThirdsMinimumInvstRetGrp/TotalAmt'),
  (450473, NULL, NULL, 'Year1Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/TwoThirdsMinimumInvstRetGrp/Year1Amt'),
  (450474, NULL, NULL, 'Year2Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/TwoThirdsMinimumInvstRetGrp/Year2Amt'),
  (450475, NULL, NULL, 'Year3Amt', 'CURRENCY', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/TwoThirdsMinimumInvstRetGrp/Year3Amt');

-- 990PF / Rln Of Acty To Accom Of Exmpt Prps Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450476, 45031, '1', 'Line Number Txt', 'TEXT'),
  (450477, 45031, '2', 'Relationship Statement Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450476, NULL, NULL, 'Line Number Txt', 'TEXT', 'ReturnData/IRS990PF/RlnOfActyToAccomOfExmptPrpsGrp/RlnOfActyToAccomOfExmptPrpsGrp/LineNumberTxt'),
  (450477, NULL, NULL, 'Relationship Statement Txt', 'TEXT', 'ReturnData/IRS990PF/RlnOfActyToAccomOfExmptPrpsGrp/RlnOfActyToAccomOfExmptPrpsGrp/RelationshipStatementTxt');

-- 990PF / Statements Regarding Acty Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450478, 45032, '1', 'Activities Not Previously Rpt Ind', 'BOOLEAN'),
  (450479, 45032, '2', 'At Least5000In Assets Ind', 'BOOLEAN'),
  (450480, 45032, '3', 'Changes To Articles Or Bylaws Ind', 'BOOLEAN'),
  (450481, 45032, '4', 'Comply With Public Insp Rqr Ind', 'BOOLEAN'),
  (450482, 45032, '5', 'Donor Advised Fund Ind', 'BOOLEAN'),
  (450483, 45032, '6', 'Foreign Accounts Question Ind', 'BOOLEAN'),
  (450484, 45032, '7', 'Form1120POL Filed Ind', 'BOOLEAN'),
  (450485, 45032, '8', 'Form990PF Filed With Atty Gen Ind', 'BOOLEAN'),
  (450486, 45032, '9', 'Form990T Filed Ind', 'BOOLEAN'),
  (450487, 45032, '10', 'Individual With Books Nm', 'TEXT'),
  (450488, 45032, '11', 'Legislative Political Acty Ind', 'BOOLEAN'),
  (450489, 45032, '12', 'Address Line1Txt', 'TEXT'),
  (450490, 45032, '13', 'Address Line2Txt', 'TEXT'),
  (450491, 45032, '14', 'City Nm', 'TEXT'),
  (450492, 45032, '15', 'State Abbreviation Cd', 'TEXT'),
  (450493, 45032, '16', 'ZIP Cd', 'TEXT'),
  (450494, 45032, '17', 'More Than100Spent Ind', 'BOOLEAN'),
  (450495, 45032, '18', 'New Substantial Contributors Ind', 'BOOLEAN'),
  (450496, 45032, '19', 'Org Report Or Register State Cd', 'TEXT'),
  (450497, 45032, '20', 'Organization Dissolved Etc Ind', 'BOOLEAN'),
  (450498, 45032, '21', 'Own Controlled Entity Ind', 'BOOLEAN'),
  (450499, 45032, '22', 'Business Name Line1Txt', 'TEXT'),
  (450500, 45032, '23', 'Business Name Line2Txt', 'TEXT'),
  (450501, 45032, '24', 'Phone Num', 'TEXT'),
  (450502, 45032, '25', 'Private Operating Foundation Ind', 'BOOLEAN'),
  (450503, 45032, '26', 'Section4955Managers Tax Amt', 'CURRENCY'),
  (450504, 45032, '27', 'Section4955Organization Tax Amt', 'CURRENCY'),
  (450505, 45032, '28', 'Section508e Rqr Satisfied Ind', 'BOOLEAN'),
  (450506, 45032, '29', 'Tax Reimbursed Amt', 'CURRENCY'),
  (450507, 45032, '30', 'Unrelated Bus Incm Over Limit Ind', 'BOOLEAN'),
  (450508, 45032, '31', 'Website Address Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450478, NULL, NULL, 'Activities Not Previously Rpt Ind', 'BOOLEAN', 'ReturnData/IRS990PF/StatementsRegardingActyGrp/ActivitiesNotPreviouslyRptInd'),
  (450479, NULL, NULL, 'At Least5000In Assets Ind', 'BOOLEAN', 'ReturnData/IRS990PF/StatementsRegardingActyGrp/AtLeast5000InAssetsInd'),
  (450480, NULL, NULL, 'Changes To Articles Or Bylaws Ind', 'BOOLEAN', 'ReturnData/IRS990PF/StatementsRegardingActyGrp/ChangesToArticlesOrBylawsInd'),
  (450481, NULL, NULL, 'Comply With Public Insp Rqr Ind', 'BOOLEAN', 'ReturnData/IRS990PF/StatementsRegardingActyGrp/ComplyWithPublicInspRqrInd'),
  (450482, NULL, NULL, 'Donor Advised Fund Ind', 'BOOLEAN', 'ReturnData/IRS990PF/StatementsRegardingActyGrp/DonorAdvisedFundInd'),
  (450483, NULL, NULL, 'Foreign Accounts Question Ind', 'BOOLEAN', 'ReturnData/IRS990PF/StatementsRegardingActyGrp/ForeignAccountsQuestionInd'),
  (450484, NULL, NULL, 'Form1120POL Filed Ind', 'BOOLEAN', 'ReturnData/IRS990PF/StatementsRegardingActyGrp/Form1120POLFiledInd'),
  (450485, NULL, NULL, 'Form990PF Filed With Atty Gen Ind', 'BOOLEAN', 'ReturnData/IRS990PF/StatementsRegardingActyGrp/Form990PFFiledWithAttyGenInd'),
  (450486, NULL, NULL, 'Form990T Filed Ind', 'BOOLEAN', 'ReturnData/IRS990PF/StatementsRegardingActyGrp/Form990TFiledInd'),
  (450487, NULL, NULL, 'Individual With Books Nm', 'TEXT', 'ReturnData/IRS990PF/StatementsRegardingActyGrp/IndividualWithBooksNm'),
  (450488, NULL, NULL, 'Legislative Political Acty Ind', 'BOOLEAN', 'ReturnData/IRS990PF/StatementsRegardingActyGrp/LegislativePoliticalActyInd'),
  (450489, NULL, NULL, 'Address Line1Txt', 'TEXT', 'ReturnData/IRS990PF/StatementsRegardingActyGrp/LocationOfBooksUSAddress/AddressLine1Txt'),
  (450490, NULL, NULL, 'Address Line2Txt', 'TEXT', 'ReturnData/IRS990PF/StatementsRegardingActyGrp/LocationOfBooksUSAddress/AddressLine2Txt'),
  (450491, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990PF/StatementsRegardingActyGrp/LocationOfBooksUSAddress/CityNm'),
  (450492, NULL, NULL, 'State Abbreviation Cd', 'TEXT', 'ReturnData/IRS990PF/StatementsRegardingActyGrp/LocationOfBooksUSAddress/StateAbbreviationCd'),
  (450493, NULL, NULL, 'ZIP Cd', 'TEXT', 'ReturnData/IRS990PF/StatementsRegardingActyGrp/LocationOfBooksUSAddress/ZIPCd'),
  (450494, NULL, NULL, 'More Than100Spent Ind', 'BOOLEAN', 'ReturnData/IRS990PF/StatementsRegardingActyGrp/MoreThan100SpentInd'),
  (450495, NULL, NULL, 'New Substantial Contributors Ind', 'BOOLEAN', 'ReturnData/IRS990PF/StatementsRegardingActyGrp/NewSubstantialContributorsInd'),
  (450496, NULL, NULL, 'Org Report Or Register State Cd', 'TEXT', 'ReturnData/IRS990PF/StatementsRegardingActyGrp/OrgReportOrRegisterStateCd'),
  (450497, NULL, NULL, 'Organization Dissolved Etc Ind', 'BOOLEAN', 'ReturnData/IRS990PF/StatementsRegardingActyGrp/OrganizationDissolvedEtcInd'),
  (450498, NULL, NULL, 'Own Controlled Entity Ind', 'BOOLEAN', 'ReturnData/IRS990PF/StatementsRegardingActyGrp/OwnControlledEntityInd'),
  (450499, NULL, NULL, 'Business Name Line1Txt', 'TEXT', 'ReturnData/IRS990PF/StatementsRegardingActyGrp/PersonsWithBooksName/BusinessNameLine1Txt'),
  (450500, NULL, NULL, 'Business Name Line2Txt', 'TEXT', 'ReturnData/IRS990PF/StatementsRegardingActyGrp/PersonsWithBooksName/BusinessNameLine2Txt'),
  (450501, NULL, NULL, 'Phone Num', 'TEXT', 'ReturnData/IRS990PF/StatementsRegardingActyGrp/PhoneNum'),
  (450502, NULL, NULL, 'Private Operating Foundation Ind', 'BOOLEAN', 'ReturnData/IRS990PF/StatementsRegardingActyGrp/PrivateOperatingFoundationInd'),
  (450503, NULL, NULL, 'Section4955Managers Tax Amt', 'CURRENCY', 'ReturnData/IRS990PF/StatementsRegardingActyGrp/Section4955ManagersTaxAmt'),
  (450504, NULL, NULL, 'Section4955Organization Tax Amt', 'CURRENCY', 'ReturnData/IRS990PF/StatementsRegardingActyGrp/Section4955OrganizationTaxAmt'),
  (450505, NULL, NULL, 'Section508e Rqr Satisfied Ind', 'BOOLEAN', 'ReturnData/IRS990PF/StatementsRegardingActyGrp/Section508eRqrSatisfiedInd'),
  (450506, NULL, NULL, 'Tax Reimbursed Amt', 'CURRENCY', 'ReturnData/IRS990PF/StatementsRegardingActyGrp/TaxReimbursedAmt'),
  (450507, NULL, NULL, 'Unrelated Bus Incm Over Limit Ind', 'BOOLEAN', 'ReturnData/IRS990PF/StatementsRegardingActyGrp/UnrelatedBusIncmOverLimitInd'),
  (450508, NULL, NULL, 'Website Address Txt', 'TEXT', 'ReturnData/IRS990PF/StatementsRegardingActyGrp/WebsiteAddressTxt');

-- 990PF / Statements Regarding Acty4720 Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450509, 45033, '1', 'Acts Fail To Qlfy As Exceptions Ind', 'BOOLEAN'),
  (450510, 45033, '2', 'Brrw Or Lend Disqualified Prsn Ind', 'BOOLEAN'),
  (450511, 45033, '3', 'Business Holdings Ind', 'BOOLEAN'),
  (450512, 45033, '4', 'Furn Goods Disqualified Prsn Ind', 'BOOLEAN'),
  (450513, 45033, '5', 'Grants To Individuals Ind', 'BOOLEAN'),
  (450514, 45033, '6', 'Grants To Organizations Ind', 'BOOLEAN'),
  (450515, 45033, '7', 'Influence Election Ind', 'BOOLEAN'),
  (450516, 45033, '8', 'Influence Legislation Ind', 'BOOLEAN'),
  (450517, 45033, '9', 'Jeopardy Investments Ind', 'BOOLEAN'),
  (450518, 45033, '10', 'Noncharitable Purpose Ind', 'BOOLEAN'),
  (450519, 45033, '11', 'Pay Comp Disqualified Prsn Ind', 'BOOLEAN'),
  (450520, 45033, '12', 'Pay Premiums Prsnl Bnft Cntrct Ind', 'BOOLEAN'),
  (450521, 45033, '13', 'Payment To Government Official Ind', 'BOOLEAN'),
  (450522, 45033, '14', 'Prohibited Tax Shelter Trans Ind', 'BOOLEAN'),
  (450523, 45033, '15', 'Rcv Fnds To Pay Prsnl Bnft Cntrct Ind', 'BOOLEAN'),
  (450524, 45033, '16', 'Sale Or Exch Disqualified Prsn Ind', 'BOOLEAN'),
  (450525, 45033, '17', 'Subj To Tax Rmnrtn Ex Prcht Pymt Ind', 'BOOLEAN'),
  (450526, 45033, '18', 'Transactions Fail To Qlfy As Exc Ind', 'BOOLEAN'),
  (450527, 45033, '19', 'Transfer Ast Disqualified Prsn Ind', 'BOOLEAN'),
  (450528, 45033, '20', 'Uncorrected PY Jeopardy Invst Ind', 'BOOLEAN'),
  (450529, 45033, '21', 'Uncorrected Prior Acts Ind', 'BOOLEAN'),
  (450530, 45033, '22', 'Undistr Incm Sect4942a2Not App Ind', 'BOOLEAN'),
  (450531, 45033, '23', 'Undistributed Income PY1Yr', 'TEXT'),
  (450532, 45033, '24', 'Undistributed Income PY2Yr', 'TEXT'),
  (450533, 45033, '25', 'Undistributed Income PY4Yr', 'TEXT'),
  (450534, 45033, '26', 'Undistributed Income PY Ind', 'BOOLEAN');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450509, NULL, NULL, 'Acts Fail To Qlfy As Exceptions Ind', 'BOOLEAN', 'ReturnData/IRS990PF/StatementsRegardingActy4720Grp/ActsFailToQlfyAsExceptionsInd'),
  (450510, NULL, NULL, 'Brrw Or Lend Disqualified Prsn Ind', 'BOOLEAN', 'ReturnData/IRS990PF/StatementsRegardingActy4720Grp/BrrwOrLendDisqualifiedPrsnInd'),
  (450511, NULL, NULL, 'Business Holdings Ind', 'BOOLEAN', 'ReturnData/IRS990PF/StatementsRegardingActy4720Grp/BusinessHoldingsInd'),
  (450512, NULL, NULL, 'Furn Goods Disqualified Prsn Ind', 'BOOLEAN', 'ReturnData/IRS990PF/StatementsRegardingActy4720Grp/FurnGoodsDisqualifiedPrsnInd'),
  (450513, NULL, NULL, 'Grants To Individuals Ind', 'BOOLEAN', 'ReturnData/IRS990PF/StatementsRegardingActy4720Grp/GrantsToIndividualsInd'),
  (450514, NULL, NULL, 'Grants To Organizations Ind', 'BOOLEAN', 'ReturnData/IRS990PF/StatementsRegardingActy4720Grp/GrantsToOrganizationsInd'),
  (450515, NULL, NULL, 'Influence Election Ind', 'BOOLEAN', 'ReturnData/IRS990PF/StatementsRegardingActy4720Grp/InfluenceElectionInd'),
  (450516, NULL, NULL, 'Influence Legislation Ind', 'BOOLEAN', 'ReturnData/IRS990PF/StatementsRegardingActy4720Grp/InfluenceLegislationInd'),
  (450517, NULL, NULL, 'Jeopardy Investments Ind', 'BOOLEAN', 'ReturnData/IRS990PF/StatementsRegardingActy4720Grp/JeopardyInvestmentsInd'),
  (450518, NULL, NULL, 'Noncharitable Purpose Ind', 'BOOLEAN', 'ReturnData/IRS990PF/StatementsRegardingActy4720Grp/NoncharitablePurposeInd'),
  (450519, NULL, NULL, 'Pay Comp Disqualified Prsn Ind', 'BOOLEAN', 'ReturnData/IRS990PF/StatementsRegardingActy4720Grp/PayCompDisqualifiedPrsnInd'),
  (450520, NULL, NULL, 'Pay Premiums Prsnl Bnft Cntrct Ind', 'BOOLEAN', 'ReturnData/IRS990PF/StatementsRegardingActy4720Grp/PayPremiumsPrsnlBnftCntrctInd'),
  (450521, NULL, NULL, 'Payment To Government Official Ind', 'BOOLEAN', 'ReturnData/IRS990PF/StatementsRegardingActy4720Grp/PaymentToGovernmentOfficialInd'),
  (450522, NULL, NULL, 'Prohibited Tax Shelter Trans Ind', 'BOOLEAN', 'ReturnData/IRS990PF/StatementsRegardingActy4720Grp/ProhibitedTaxShelterTransInd'),
  (450523, NULL, NULL, 'Rcv Fnds To Pay Prsnl Bnft Cntrct Ind', 'BOOLEAN', 'ReturnData/IRS990PF/StatementsRegardingActy4720Grp/RcvFndsToPayPrsnlBnftCntrctInd'),
  (450524, NULL, NULL, 'Sale Or Exch Disqualified Prsn Ind', 'BOOLEAN', 'ReturnData/IRS990PF/StatementsRegardingActy4720Grp/SaleOrExchDisqualifiedPrsnInd'),
  (450525, NULL, NULL, 'Subj To Tax Rmnrtn Ex Prcht Pymt Ind', 'BOOLEAN', 'ReturnData/IRS990PF/StatementsRegardingActy4720Grp/SubjToTaxRmnrtnExPrchtPymtInd'),
  (450526, NULL, NULL, 'Transactions Fail To Qlfy As Exc Ind', 'BOOLEAN', 'ReturnData/IRS990PF/StatementsRegardingActy4720Grp/TransactionsFailToQlfyAsExcInd'),
  (450527, NULL, NULL, 'Transfer Ast Disqualified Prsn Ind', 'BOOLEAN', 'ReturnData/IRS990PF/StatementsRegardingActy4720Grp/TransferAstDisqualifiedPrsnInd'),
  (450528, NULL, NULL, 'Uncorrected PY Jeopardy Invst Ind', 'BOOLEAN', 'ReturnData/IRS990PF/StatementsRegardingActy4720Grp/UncorrectedPYJeopardyInvstInd'),
  (450529, NULL, NULL, 'Uncorrected Prior Acts Ind', 'BOOLEAN', 'ReturnData/IRS990PF/StatementsRegardingActy4720Grp/UncorrectedPriorActsInd'),
  (450530, NULL, NULL, 'Undistr Incm Sect4942a2Not App Ind', 'BOOLEAN', 'ReturnData/IRS990PF/StatementsRegardingActy4720Grp/UndistrIncmSect4942a2NotAppInd'),
  (450531, NULL, NULL, 'Undistributed Income PY1Yr', 'TEXT', 'ReturnData/IRS990PF/StatementsRegardingActy4720Grp/UndistributedIncomePY1Yr'),
  (450532, NULL, NULL, 'Undistributed Income PY2Yr', 'TEXT', 'ReturnData/IRS990PF/StatementsRegardingActy4720Grp/UndistributedIncomePY2Yr'),
  (450533, NULL, NULL, 'Undistributed Income PY4Yr', 'TEXT', 'ReturnData/IRS990PF/StatementsRegardingActy4720Grp/UndistributedIncomePY4Yr'),
  (450534, NULL, NULL, 'Undistributed Income PY Ind', 'BOOLEAN', 'ReturnData/IRS990PF/StatementsRegardingActy4720Grp/UndistributedIncomePYInd');

-- 990PF / Substantial Contributor Detail
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450535, 45034, '1', 'Person Nm', 'TEXT'),
  (450536, 45034, '2', 'Address Line1Txt', 'TEXT'),
  (450537, 45034, '3', 'City Nm', 'TEXT'),
  (450538, 45034, '4', 'State Abbreviation Cd', 'TEXT'),
  (450539, 45034, '5', 'ZIP Cd', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450535, NULL, NULL, 'Person Nm', 'TEXT', 'ReturnData/SubstantialContributorsSch/SubstantialContributorDetail/PersonNm'),
  (450536, NULL, NULL, 'Address Line1Txt', 'TEXT', 'ReturnData/SubstantialContributorsSch/SubstantialContributorDetail/USAddress/AddressLine1Txt'),
  (450537, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/SubstantialContributorsSch/SubstantialContributorDetail/USAddress/CityNm'),
  (450538, NULL, NULL, 'State Abbreviation Cd', 'TEXT', 'ReturnData/SubstantialContributorsSch/SubstantialContributorDetail/USAddress/StateAbbreviationCd'),
  (450539, NULL, NULL, 'ZIP Cd', 'TEXT', 'ReturnData/SubstantialContributorsSch/SubstantialContributorDetail/USAddress/ZIPCd');

-- 990PF / Sum Of Program Related Invst Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450540, 45035, '1', 'All Other Program Rltd Invst Tot Amt', 'CURRENCY'),
  (450541, 45035, '2', 'Description1Txt', 'TEXT'),
  (450542, 45035, '3', 'Expenses1Amt', 'CURRENCY'),
  (450543, 45035, '4', 'Total Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450540, NULL, NULL, 'All Other Program Rltd Invst Tot Amt', 'CURRENCY', 'ReturnData/IRS990PF/SumOfProgramRelatedInvstGrp/AllOtherProgramRltdInvstTotAmt'),
  (450541, NULL, NULL, 'Description1Txt', 'TEXT', 'ReturnData/IRS990PF/SumOfProgramRelatedInvstGrp/Description1Txt'),
  (450542, NULL, NULL, 'Expenses1Amt', 'CURRENCY', 'ReturnData/IRS990PF/SumOfProgramRelatedInvstGrp/Expenses1Amt'),
  (450543, NULL, NULL, 'Total Amt', 'CURRENCY', 'ReturnData/IRS990PF/SumOfProgramRelatedInvstGrp/TotalAmt');

-- 990PF / Summary Of Direct Chrtbl Acty Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450544, 45036, '1', 'Description1Txt', 'TEXT'),
  (450545, 45036, '2', 'Description2Txt', 'TEXT'),
  (450546, 45036, '3', 'Expenses1Amt', 'CURRENCY'),
  (450547, 45036, '4', 'Expenses2Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450544, NULL, NULL, 'Description1Txt', 'TEXT', 'ReturnData/IRS990PF/SummaryOfDirectChrtblActyGrp/Description1Txt'),
  (450545, NULL, NULL, 'Description2Txt', 'TEXT', 'ReturnData/IRS990PF/SummaryOfDirectChrtblActyGrp/Description2Txt'),
  (450546, NULL, NULL, 'Expenses1Amt', 'CURRENCY', 'ReturnData/IRS990PF/SummaryOfDirectChrtblActyGrp/Expenses1Amt'),
  (450547, NULL, NULL, 'Expenses2Amt', 'CURRENCY', 'ReturnData/IRS990PF/SummaryOfDirectChrtblActyGrp/Expenses2Amt');

-- 990PF / Supplementary Information Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450548, 45037, '1', 'Form And Info And Materials Txt', 'TEXT'),
  (450549, 45037, '2', 'Recipient Person Nm', 'TEXT'),
  (450550, 45037, '3', 'Recipient Phone Num', 'TEXT'),
  (450551, 45037, '4', 'Address Line1Txt', 'TEXT'),
  (450552, 45037, '5', 'City Nm', 'TEXT'),
  (450553, 45037, '6', 'State Abbreviation Cd', 'TEXT'),
  (450554, 45037, '7', 'ZIP Cd', 'TEXT'),
  (450555, 45037, '8', 'Restrictions On Awards Txt', 'TEXT'),
  (450556, 45037, '9', 'Submission Deadlines Txt', 'TEXT'),
  (450557, 45037, '10', 'Contributing Manager Nm', 'TEXT'),
  (450558, 45037, '11', 'Amt', 'CURRENCY'),
  (450559, 45037, '12', 'Grant Or Contribution Purpose Txt', 'TEXT'),
  (450560, 45037, '13', 'Business Name Line1Txt', 'TEXT'),
  (450561, 45037, '14', 'Recipient Foundation Status Txt', 'TEXT'),
  (450562, 45037, '15', 'Recipient Relationship Txt', 'TEXT'),
  (450563, 45037, '16', 'Address Line1Txt', 'TEXT'),
  (450564, 45037, '17', 'City Nm', 'TEXT'),
  (450565, 45037, '18', 'State Abbreviation Cd', 'TEXT'),
  (450566, 45037, '19', 'ZIP Cd', 'TEXT'),
  (450567, 45037, '20', 'Amt', 'CURRENCY'),
  (450568, 45037, '21', 'Grant Or Contribution Purpose Txt', 'TEXT'),
  (450569, 45037, '22', 'Business Name Line1Txt', 'TEXT'),
  (450570, 45037, '23', 'Business Name Line2Txt', 'TEXT'),
  (450571, 45037, '24', 'Address Line1Txt', 'TEXT'),
  (450572, 45037, '25', 'City Nm', 'TEXT'),
  (450573, 45037, '26', 'Country Cd', 'TEXT'),
  (450574, 45037, '27', 'Recipient Foundation Status Txt', 'TEXT'),
  (450575, 45037, '28', 'Recipient Person Nm', 'TEXT'),
  (450576, 45037, '29', 'Recipient Relationship Txt', 'TEXT'),
  (450577, 45037, '30', 'Address Line1Txt', 'TEXT'),
  (450578, 45037, '31', 'Address Line2Txt', 'TEXT'),
  (450579, 45037, '32', 'City Nm', 'TEXT'),
  (450580, 45037, '33', 'State Abbreviation Cd', 'TEXT'),
  (450581, 45037, '34', 'ZIP Cd', 'TEXT'),
  (450582, 45037, '35', 'Only Contri To Preselected Ind', 'BOOLEAN'),
  (450583, 45037, '36', 'Shareholder Manager Nm', 'TEXT'),
  (450584, 45037, '37', 'Total Grant Or Contri Apprv Fut Amt', 'CURRENCY'),
  (450585, 45037, '38', 'Total Grant Or Contri Pd Dur Yr Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450548, NULL, NULL, 'Form And Info And Materials Txt', 'TEXT', 'ReturnData/IRS990PF/SupplementaryInformationGrp/ApplicationSubmissionInfoGrp/FormAndInfoAndMaterialsTxt'),
  (450549, NULL, NULL, 'Recipient Person Nm', 'TEXT', 'ReturnData/IRS990PF/SupplementaryInformationGrp/ApplicationSubmissionInfoGrp/RecipientPersonNm'),
  (450550, NULL, NULL, 'Recipient Phone Num', 'TEXT', 'ReturnData/IRS990PF/SupplementaryInformationGrp/ApplicationSubmissionInfoGrp/RecipientPhoneNum'),
  (450551, NULL, NULL, 'Address Line1Txt', 'TEXT', 'ReturnData/IRS990PF/SupplementaryInformationGrp/ApplicationSubmissionInfoGrp/RecipientUSAddress/AddressLine1Txt'),
  (450552, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990PF/SupplementaryInformationGrp/ApplicationSubmissionInfoGrp/RecipientUSAddress/CityNm'),
  (450553, NULL, NULL, 'State Abbreviation Cd', 'TEXT', 'ReturnData/IRS990PF/SupplementaryInformationGrp/ApplicationSubmissionInfoGrp/RecipientUSAddress/StateAbbreviationCd'),
  (450554, NULL, NULL, 'ZIP Cd', 'TEXT', 'ReturnData/IRS990PF/SupplementaryInformationGrp/ApplicationSubmissionInfoGrp/RecipientUSAddress/ZIPCd'),
  (450555, NULL, NULL, 'Restrictions On Awards Txt', 'TEXT', 'ReturnData/IRS990PF/SupplementaryInformationGrp/ApplicationSubmissionInfoGrp/RestrictionsOnAwardsTxt'),
  (450556, NULL, NULL, 'Submission Deadlines Txt', 'TEXT', 'ReturnData/IRS990PF/SupplementaryInformationGrp/ApplicationSubmissionInfoGrp/SubmissionDeadlinesTxt'),
  (450557, NULL, NULL, 'Contributing Manager Nm', 'TEXT', 'ReturnData/IRS990PF/SupplementaryInformationGrp/ContributingManagerNm'),
  (450558, NULL, NULL, 'Amt', 'CURRENCY', 'ReturnData/IRS990PF/SupplementaryInformationGrp/GrantOrContriApprvForFutGrp/Amt'),
  (450559, NULL, NULL, 'Grant Or Contribution Purpose Txt', 'TEXT', 'ReturnData/IRS990PF/SupplementaryInformationGrp/GrantOrContriApprvForFutGrp/GrantOrContributionPurposeTxt'),
  (450560, NULL, NULL, 'Business Name Line1Txt', 'TEXT', 'ReturnData/IRS990PF/SupplementaryInformationGrp/GrantOrContriApprvForFutGrp/RecipientBusinessName/BusinessNameLine1Txt'),
  (450561, NULL, NULL, 'Recipient Foundation Status Txt', 'TEXT', 'ReturnData/IRS990PF/SupplementaryInformationGrp/GrantOrContriApprvForFutGrp/RecipientFoundationStatusTxt'),
  (450562, NULL, NULL, 'Recipient Relationship Txt', 'TEXT', 'ReturnData/IRS990PF/SupplementaryInformationGrp/GrantOrContriApprvForFutGrp/RecipientRelationshipTxt'),
  (450563, NULL, NULL, 'Address Line1Txt', 'TEXT', 'ReturnData/IRS990PF/SupplementaryInformationGrp/GrantOrContriApprvForFutGrp/RecipientUSAddress/AddressLine1Txt'),
  (450564, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990PF/SupplementaryInformationGrp/GrantOrContriApprvForFutGrp/RecipientUSAddress/CityNm'),
  (450565, NULL, NULL, 'State Abbreviation Cd', 'TEXT', 'ReturnData/IRS990PF/SupplementaryInformationGrp/GrantOrContriApprvForFutGrp/RecipientUSAddress/StateAbbreviationCd'),
  (450566, NULL, NULL, 'ZIP Cd', 'TEXT', 'ReturnData/IRS990PF/SupplementaryInformationGrp/GrantOrContriApprvForFutGrp/RecipientUSAddress/ZIPCd'),
  (450567, NULL, NULL, 'Amt', 'CURRENCY', 'ReturnData/IRS990PF/SupplementaryInformationGrp/GrantOrContributionPdDurYrGrp/Amt'),
  (450568, NULL, NULL, 'Grant Or Contribution Purpose Txt', 'TEXT', 'ReturnData/IRS990PF/SupplementaryInformationGrp/GrantOrContributionPdDurYrGrp/GrantOrContributionPurposeTxt'),
  (450569, NULL, NULL, 'Business Name Line1Txt', 'TEXT', 'ReturnData/IRS990PF/SupplementaryInformationGrp/GrantOrContributionPdDurYrGrp/RecipientBusinessName/BusinessNameLine1Txt'),
  (450570, NULL, NULL, 'Business Name Line2Txt', 'TEXT', 'ReturnData/IRS990PF/SupplementaryInformationGrp/GrantOrContributionPdDurYrGrp/RecipientBusinessName/BusinessNameLine2Txt'),
  (450571, NULL, NULL, 'Address Line1Txt', 'TEXT', 'ReturnData/IRS990PF/SupplementaryInformationGrp/GrantOrContributionPdDurYrGrp/RecipientForeignAddress/AddressLine1Txt'),
  (450572, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990PF/SupplementaryInformationGrp/GrantOrContributionPdDurYrGrp/RecipientForeignAddress/CityNm'),
  (450573, NULL, NULL, 'Country Cd', 'TEXT', 'ReturnData/IRS990PF/SupplementaryInformationGrp/GrantOrContributionPdDurYrGrp/RecipientForeignAddress/CountryCd'),
  (450574, NULL, NULL, 'Recipient Foundation Status Txt', 'TEXT', 'ReturnData/IRS990PF/SupplementaryInformationGrp/GrantOrContributionPdDurYrGrp/RecipientFoundationStatusTxt'),
  (450575, NULL, NULL, 'Recipient Person Nm', 'TEXT', 'ReturnData/IRS990PF/SupplementaryInformationGrp/GrantOrContributionPdDurYrGrp/RecipientPersonNm'),
  (450576, NULL, NULL, 'Recipient Relationship Txt', 'TEXT', 'ReturnData/IRS990PF/SupplementaryInformationGrp/GrantOrContributionPdDurYrGrp/RecipientRelationshipTxt'),
  (450577, NULL, NULL, 'Address Line1Txt', 'TEXT', 'ReturnData/IRS990PF/SupplementaryInformationGrp/GrantOrContributionPdDurYrGrp/RecipientUSAddress/AddressLine1Txt'),
  (450578, NULL, NULL, 'Address Line2Txt', 'TEXT', 'ReturnData/IRS990PF/SupplementaryInformationGrp/GrantOrContributionPdDurYrGrp/RecipientUSAddress/AddressLine2Txt'),
  (450579, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990PF/SupplementaryInformationGrp/GrantOrContributionPdDurYrGrp/RecipientUSAddress/CityNm'),
  (450580, NULL, NULL, 'State Abbreviation Cd', 'TEXT', 'ReturnData/IRS990PF/SupplementaryInformationGrp/GrantOrContributionPdDurYrGrp/RecipientUSAddress/StateAbbreviationCd'),
  (450581, NULL, NULL, 'ZIP Cd', 'TEXT', 'ReturnData/IRS990PF/SupplementaryInformationGrp/GrantOrContributionPdDurYrGrp/RecipientUSAddress/ZIPCd'),
  (450582, NULL, NULL, 'Only Contri To Preselected Ind', 'BOOLEAN', 'ReturnData/IRS990PF/SupplementaryInformationGrp/OnlyContriToPreselectedInd'),
  (450583, NULL, NULL, 'Shareholder Manager Nm', 'TEXT', 'ReturnData/IRS990PF/SupplementaryInformationGrp/ShareholderManagerNm'),
  (450584, NULL, NULL, 'Total Grant Or Contri Apprv Fut Amt', 'CURRENCY', 'ReturnData/IRS990PF/SupplementaryInformationGrp/TotalGrantOrContriApprvFutAmt'),
  (450585, NULL, NULL, 'Total Grant Or Contri Pd Dur Yr Amt', 'CURRENCY', 'ReturnData/IRS990PF/SupplementaryInformationGrp/TotalGrantOrContriPdDurYrAmt');

-- 990PF / Taxes Detail
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450586, 45038, '1', 'Adjusted Net Income Amt', 'CURRENCY'),
  (450587, 45038, '2', 'Amt', 'CURRENCY'),
  (450588, 45038, '3', 'Category Txt', 'TEXT'),
  (450589, 45038, '4', 'Disbursements Charitable Prps Amt', 'CURRENCY'),
  (450590, 45038, '5', 'Net Investment Income Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450586, NULL, NULL, 'Adjusted Net Income Amt', 'CURRENCY', 'ReturnData/TaxesSchedule/TaxesDetail/AdjustedNetIncomeAmt'),
  (450587, NULL, NULL, 'Amt', 'CURRENCY', 'ReturnData/TaxesSchedule/TaxesDetail/Amt'),
  (450588, NULL, NULL, 'Category Txt', 'TEXT', 'ReturnData/TaxesSchedule/TaxesDetail/CategoryTxt'),
  (450589, NULL, NULL, 'Disbursements Charitable Prps Amt', 'CURRENCY', 'ReturnData/TaxesSchedule/TaxesDetail/DisbursementsCharitablePrpsAmt'),
  (450590, NULL, NULL, 'Net Investment Income Amt', 'CURRENCY', 'ReturnData/TaxesSchedule/TaxesDetail/NetInvestmentIncomeAmt');

-- 990PF / Trnsfr Trans Rln Nonchrtbl EO Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450591, 45039, '1', 'Loans Or Loan Guarantees Ind', 'BOOLEAN'),
  (450592, 45039, '2', 'Performance Of Services Etc Ind', 'BOOLEAN'),
  (450593, 45039, '3', 'Purchase Of Assets Nonchrtbl EO Ind', 'BOOLEAN'),
  (450594, 45039, '4', 'Reimbursement Arrangements Ind', 'BOOLEAN'),
  (450595, 45039, '5', 'Relationships Nonchrtbl EO Ind', 'BOOLEAN'),
  (450596, 45039, '6', 'Rental Of Facilities Oth Assets Ind', 'BOOLEAN'),
  (450597, 45039, '7', 'Sales Or Exchanges Of Assets Ind', 'BOOLEAN'),
  (450598, 45039, '8', 'Sharing Of Facilities Etc Ind', 'BOOLEAN'),
  (450599, 45039, '9', 'Trnsfr Of Cash To Nonchrtbl EO Ind', 'BOOLEAN'),
  (450600, 45039, '10', 'Trnsfr Other Asset Nonchrtbl EO Ind', 'BOOLEAN');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450591, NULL, NULL, 'Loans Or Loan Guarantees Ind', 'BOOLEAN', 'ReturnData/IRS990PF/TrnsfrTransRlnNonchrtblEOGrp/LoansOrLoanGuaranteesInd'),
  (450592, NULL, NULL, 'Performance Of Services Etc Ind', 'BOOLEAN', 'ReturnData/IRS990PF/TrnsfrTransRlnNonchrtblEOGrp/PerformanceOfServicesEtcInd'),
  (450593, NULL, NULL, 'Purchase Of Assets Nonchrtbl EO Ind', 'BOOLEAN', 'ReturnData/IRS990PF/TrnsfrTransRlnNonchrtblEOGrp/PurchaseOfAssetsNonchrtblEOInd'),
  (450594, NULL, NULL, 'Reimbursement Arrangements Ind', 'BOOLEAN', 'ReturnData/IRS990PF/TrnsfrTransRlnNonchrtblEOGrp/ReimbursementArrangementsInd'),
  (450595, NULL, NULL, 'Relationships Nonchrtbl EO Ind', 'BOOLEAN', 'ReturnData/IRS990PF/TrnsfrTransRlnNonchrtblEOGrp/RelationshipsNonchrtblEOInd'),
  (450596, NULL, NULL, 'Rental Of Facilities Oth Assets Ind', 'BOOLEAN', 'ReturnData/IRS990PF/TrnsfrTransRlnNonchrtblEOGrp/RentalOfFacilitiesOthAssetsInd'),
  (450597, NULL, NULL, 'Sales Or Exchanges Of Assets Ind', 'BOOLEAN', 'ReturnData/IRS990PF/TrnsfrTransRlnNonchrtblEOGrp/SalesOrExchangesOfAssetsInd'),
  (450598, NULL, NULL, 'Sharing Of Facilities Etc Ind', 'BOOLEAN', 'ReturnData/IRS990PF/TrnsfrTransRlnNonchrtblEOGrp/SharingOfFacilitiesEtcInd'),
  (450599, NULL, NULL, 'Trnsfr Of Cash To Nonchrtbl EO Ind', 'BOOLEAN', 'ReturnData/IRS990PF/TrnsfrTransRlnNonchrtblEOGrp/TrnsfrOfCashToNonchrtblEOInd'),
  (450600, NULL, NULL, 'Trnsfr Other Asset Nonchrtbl EO Ind', 'BOOLEAN', 'ReturnData/IRS990PF/TrnsfrTransRlnNonchrtblEOGrp/TrnsfrOtherAssetNonchrtblEOInd');

-- 990PF / Undistributed Income Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450601, 45040, '1', 'Applied To Current Year Amt', 'CURRENCY'),
  (450602, 45040, '2', 'Applied To Prior Years Amt', 'CURRENCY'),
  (450603, 45040, '3', 'Applied To Year1Amt', 'CURRENCY'),
  (450604, 45040, '4', 'Corpus Distri170b1E Or4942g3Amt', 'CURRENCY'),
  (450605, 45040, '5', 'Distributable As Adjusted Amt', 'CURRENCY'),
  (450606, 45040, '6', 'Excess Distri Cyov App CY Corpus Amt', 'CURRENCY'),
  (450607, 45040, '7', 'Excess Distri Cyov From Yr5Amt', 'CURRENCY'),
  (450608, 45040, '8', 'Excess Distri Cyov To Next Yr Amt', 'CURRENCY'),
  (450609, 45040, '9', 'Excess Distribution Cyov App CY Amt', 'CURRENCY'),
  (450610, 45040, '10', 'Excess Distribution Cyov Yr1Amt', 'CURRENCY'),
  (450611, 45040, '11', 'Excess Distribution Cyov Yr2Amt', 'CURRENCY'),
  (450612, 45040, '12', 'Excess Distribution Cyov Yr3Amt', 'CURRENCY'),
  (450613, 45040, '13', 'Excess Distribution Cyov Yr4Amt', 'CURRENCY'),
  (450614, 45040, '14', 'Excess Distribution Cyov Yr5Amt', 'CURRENCY'),
  (450615, 45040, '15', 'Excess From Current Year Amt', 'CURRENCY'),
  (450616, 45040, '16', 'Excess From Year1Amt', 'CURRENCY'),
  (450617, 45040, '17', 'Excess From Year2Amt', 'CURRENCY'),
  (450618, 45040, '18', 'Excess From Year3Amt', 'CURRENCY'),
  (450619, 45040, '19', 'Excess From Year4Amt', 'CURRENCY'),
  (450620, 45040, '20', 'Prior Year1Yr', 'TEXT'),
  (450621, 45040, '21', 'Prior Year2Yr', 'TEXT'),
  (450622, 45040, '22', 'Prior Year3Yr', 'TEXT'),
  (450623, 45040, '23', 'Prior Year Deficiency Or Tax Amt', 'CURRENCY'),
  (450624, 45040, '24', 'Prior Year Undistributed Incm Amt', 'CURRENCY'),
  (450625, 45040, '25', 'Qualifying Distributions Amt', 'CURRENCY'),
  (450626, 45040, '26', 'Remaining Distri From Corpus Amt', 'CURRENCY'),
  (450627, 45040, '27', 'Taxable1Amt', 'CURRENCY'),
  (450628, 45040, '28', 'Taxable2Amt', 'CURRENCY'),
  (450629, 45040, '29', 'Total Corpus Amt', 'CURRENCY'),
  (450630, 45040, '30', 'Total Excess Distribution Cyov Amt', 'CURRENCY'),
  (450631, 45040, '31', 'Total For Prior Years Amt', 'CURRENCY'),
  (450632, 45040, '32', 'Treated As Distri From Corpus Amt', 'CURRENCY'),
  (450633, 45040, '33', 'Undistributed Income CY Amt', 'CURRENCY'),
  (450634, 45040, '34', 'Undistributed Income PY Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450601, NULL, NULL, 'Applied To Current Year Amt', 'CURRENCY', 'ReturnData/IRS990PF/UndistributedIncomeGrp/AppliedToCurrentYearAmt'),
  (450602, NULL, NULL, 'Applied To Prior Years Amt', 'CURRENCY', 'ReturnData/IRS990PF/UndistributedIncomeGrp/AppliedToPriorYearsAmt'),
  (450603, NULL, NULL, 'Applied To Year1Amt', 'CURRENCY', 'ReturnData/IRS990PF/UndistributedIncomeGrp/AppliedToYear1Amt'),
  (450604, NULL, NULL, 'Corpus Distri170b1E Or4942g3Amt', 'CURRENCY', 'ReturnData/IRS990PF/UndistributedIncomeGrp/CorpusDistri170b1EOr4942g3Amt'),
  (450605, NULL, NULL, 'Distributable As Adjusted Amt', 'CURRENCY', 'ReturnData/IRS990PF/UndistributedIncomeGrp/DistributableAsAdjustedAmt'),
  (450606, NULL, NULL, 'Excess Distri Cyov App CY Corpus Amt', 'CURRENCY', 'ReturnData/IRS990PF/UndistributedIncomeGrp/ExcessDistriCyovAppCYCorpusAmt'),
  (450607, NULL, NULL, 'Excess Distri Cyov From Yr5Amt', 'CURRENCY', 'ReturnData/IRS990PF/UndistributedIncomeGrp/ExcessDistriCyovFromYr5Amt'),
  (450608, NULL, NULL, 'Excess Distri Cyov To Next Yr Amt', 'CURRENCY', 'ReturnData/IRS990PF/UndistributedIncomeGrp/ExcessDistriCyovToNextYrAmt'),
  (450609, NULL, NULL, 'Excess Distribution Cyov App CY Amt', 'CURRENCY', 'ReturnData/IRS990PF/UndistributedIncomeGrp/ExcessDistributionCyovAppCYAmt'),
  (450610, NULL, NULL, 'Excess Distribution Cyov Yr1Amt', 'CURRENCY', 'ReturnData/IRS990PF/UndistributedIncomeGrp/ExcessDistributionCyovYr1Amt'),
  (450611, NULL, NULL, 'Excess Distribution Cyov Yr2Amt', 'CURRENCY', 'ReturnData/IRS990PF/UndistributedIncomeGrp/ExcessDistributionCyovYr2Amt'),
  (450612, NULL, NULL, 'Excess Distribution Cyov Yr3Amt', 'CURRENCY', 'ReturnData/IRS990PF/UndistributedIncomeGrp/ExcessDistributionCyovYr3Amt'),
  (450613, NULL, NULL, 'Excess Distribution Cyov Yr4Amt', 'CURRENCY', 'ReturnData/IRS990PF/UndistributedIncomeGrp/ExcessDistributionCyovYr4Amt'),
  (450614, NULL, NULL, 'Excess Distribution Cyov Yr5Amt', 'CURRENCY', 'ReturnData/IRS990PF/UndistributedIncomeGrp/ExcessDistributionCyovYr5Amt'),
  (450615, NULL, NULL, 'Excess From Current Year Amt', 'CURRENCY', 'ReturnData/IRS990PF/UndistributedIncomeGrp/ExcessFromCurrentYearAmt'),
  (450616, NULL, NULL, 'Excess From Year1Amt', 'CURRENCY', 'ReturnData/IRS990PF/UndistributedIncomeGrp/ExcessFromYear1Amt'),
  (450617, NULL, NULL, 'Excess From Year2Amt', 'CURRENCY', 'ReturnData/IRS990PF/UndistributedIncomeGrp/ExcessFromYear2Amt'),
  (450618, NULL, NULL, 'Excess From Year3Amt', 'CURRENCY', 'ReturnData/IRS990PF/UndistributedIncomeGrp/ExcessFromYear3Amt'),
  (450619, NULL, NULL, 'Excess From Year4Amt', 'CURRENCY', 'ReturnData/IRS990PF/UndistributedIncomeGrp/ExcessFromYear4Amt'),
  (450620, NULL, NULL, 'Prior Year1Yr', 'TEXT', 'ReturnData/IRS990PF/UndistributedIncomeGrp/PriorYear1Yr'),
  (450621, NULL, NULL, 'Prior Year2Yr', 'TEXT', 'ReturnData/IRS990PF/UndistributedIncomeGrp/PriorYear2Yr'),
  (450622, NULL, NULL, 'Prior Year3Yr', 'TEXT', 'ReturnData/IRS990PF/UndistributedIncomeGrp/PriorYear3Yr'),
  (450623, NULL, NULL, 'Prior Year Deficiency Or Tax Amt', 'CURRENCY', 'ReturnData/IRS990PF/UndistributedIncomeGrp/PriorYearDeficiencyOrTaxAmt'),
  (450624, NULL, NULL, 'Prior Year Undistributed Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/UndistributedIncomeGrp/PriorYearUndistributedIncmAmt'),
  (450625, NULL, NULL, 'Qualifying Distributions Amt', 'CURRENCY', 'ReturnData/IRS990PF/UndistributedIncomeGrp/QualifyingDistributionsAmt'),
  (450626, NULL, NULL, 'Remaining Distri From Corpus Amt', 'CURRENCY', 'ReturnData/IRS990PF/UndistributedIncomeGrp/RemainingDistriFromCorpusAmt'),
  (450627, NULL, NULL, 'Taxable1Amt', 'CURRENCY', 'ReturnData/IRS990PF/UndistributedIncomeGrp/Taxable1Amt'),
  (450628, NULL, NULL, 'Taxable2Amt', 'CURRENCY', 'ReturnData/IRS990PF/UndistributedIncomeGrp/Taxable2Amt'),
  (450629, NULL, NULL, 'Total Corpus Amt', 'CURRENCY', 'ReturnData/IRS990PF/UndistributedIncomeGrp/TotalCorpusAmt'),
  (450630, NULL, NULL, 'Total Excess Distribution Cyov Amt', 'CURRENCY', 'ReturnData/IRS990PF/UndistributedIncomeGrp/TotalExcessDistributionCyovAmt'),
  (450631, NULL, NULL, 'Total For Prior Years Amt', 'CURRENCY', 'ReturnData/IRS990PF/UndistributedIncomeGrp/TotalForPriorYearsAmt'),
  (450632, NULL, NULL, 'Treated As Distri From Corpus Amt', 'CURRENCY', 'ReturnData/IRS990PF/UndistributedIncomeGrp/TreatedAsDistriFromCorpusAmt'),
  (450633, NULL, NULL, 'Undistributed Income CY Amt', 'CURRENCY', 'ReturnData/IRS990PF/UndistributedIncomeGrp/UndistributedIncomeCYAmt'),
  (450634, NULL, NULL, 'Undistributed Income PY Amt', 'CURRENCY', 'ReturnData/IRS990PF/UndistributedIncomeGrp/UndistributedIncomePYAmt');


-- ========================================================================
-- FORM 990-PF — Extended field mappings (Round 2)
-- ========================================================================

-- 990PF / Depreciation Property Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (45041, 45, '042', 'Depreciation Property Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450635, 45041, '1', 'Property Desc', 'TEXT'),
  (450636, 45041, '2', 'Cost Or Other Basis Amt', 'CURRENCY'),
  (450637, 45041, '3', 'Acquired Dt', 'TEXT'),
  (450638, 45041, '4', 'Computation Method Txt', 'TEXT'),
  (450639, 45041, '5', 'Prior Year Depreciation Amt', 'CURRENCY'),
  (450640, 45041, '6', 'Current Year Expense Amt', 'CURRENCY'),
  (450641, 45041, '7', 'Life Rt', 'PERCENT'),
  (450642, 45041, '8', 'Net Investment Income Amt', 'CURRENCY'),
  (450643, 45041, '9', 'Adjusted Net Income Amt', 'CURRENCY'),
  (450644, 45041, '10', 'Rt', 'PERCENT'),
  (450645, 45041, '11', 'Cost Of Goods Sold Not Included Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450635, NULL, NULL, 'Property Desc', 'TEXT', 'ReturnData/DepreciationSchedule/DepreciationPropertyGrp/PropertyDesc'),
  (450636, NULL, NULL, 'Cost Or Other Basis Amt', 'CURRENCY', 'ReturnData/DepreciationSchedule/DepreciationPropertyGrp/CostOrOtherBasisAmt'),
  (450637, NULL, NULL, 'Acquired Dt', 'TEXT', 'ReturnData/DepreciationSchedule/DepreciationPropertyGrp/AcquiredDt'),
  (450638, NULL, NULL, 'Computation Method Txt', 'TEXT', 'ReturnData/DepreciationSchedule/DepreciationPropertyGrp/ComputationMethodTxt'),
  (450639, NULL, NULL, 'Prior Year Depreciation Amt', 'CURRENCY', 'ReturnData/DepreciationSchedule/DepreciationPropertyGrp/PriorYearDepreciationAmt'),
  (450640, NULL, NULL, 'Current Year Expense Amt', 'CURRENCY', 'ReturnData/DepreciationSchedule/DepreciationPropertyGrp/CurrentYearExpenseAmt'),
  (450641, NULL, NULL, 'Life Rt', 'PERCENT', 'ReturnData/DepreciationSchedule/DepreciationPropertyGrp/LifeRt'),
  (450642, NULL, NULL, 'Net Investment Income Amt', 'CURRENCY', 'ReturnData/DepreciationSchedule/DepreciationPropertyGrp/NetInvestmentIncomeAmt'),
  (450643, NULL, NULL, 'Adjusted Net Income Amt', 'CURRENCY', 'ReturnData/DepreciationSchedule/DepreciationPropertyGrp/AdjustedNetIncomeAmt'),
  (450644, NULL, NULL, 'Rt', 'PERCENT', 'ReturnData/DepreciationSchedule/DepreciationPropertyGrp/Rt'),
  (450645, NULL, NULL, 'Cost Of Goods Sold Not Included Amt', 'CURRENCY', 'ReturnData/DepreciationSchedule/DepreciationPropertyGrp/CostOfGoodsSoldNotIncludedAmt');

-- 990PF / Officer Dir Trst Key Empl Info Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (45042, 45, '043', 'Officer Dir Trst Key Empl Info Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450646, 45042, '1', 'Average Hrs Per Wk Devoted To Pos Rt', 'PERCENT'),
  (450647, 45042, '2', 'Compensation Amt', 'CURRENCY'),
  (450648, 45042, '3', 'Person Nm', 'TEXT'),
  (450649, 45042, '4', 'Title Txt', 'TEXT'),
  (450650, 45042, '5', 'Address Line1 Txt', 'TEXT'),
  (450651, 45042, '6', 'City Nm', 'TEXT'),
  (450652, 45042, '7', 'State Abbreviation Cd', 'TEXT'),
  (450653, 45042, '8', 'ZIP Cd', 'TEXT'),
  (450654, 45042, '9', 'Employee Benefits Amt', 'CURRENCY'),
  (450655, 45042, '10', 'Expense Account Amt', 'CURRENCY'),
  (450656, 45042, '11', 'Address Line1 Txt', 'TEXT'),
  (450657, 45042, '12', 'Country Cd', 'TEXT'),
  (450658, 45042, '13', 'City Nm', 'TEXT'),
  (450659, 45042, '14', 'Person Nm', 'TEXT'),
  (450660, 45042, '15', 'Foreign Postal Cd', 'TEXT'),
  (450661, 45042, '16', 'Province Or State Nm', 'TEXT'),
  (450662, 45042, '17', 'Address Line1 Txt', 'TEXT'),
  (450663, 45042, '18', 'Country Cd', 'TEXT'),
  (450664, 45042, '19', 'City Nm', 'TEXT'),
  (450665, 45042, '20', 'Business Name Line2 Txt', 'TEXT'),
  (450666, 45042, '21', 'Foreign Postal Cd', 'TEXT'),
  (450667, 45042, '22', 'Address Line2 Txt', 'TEXT'),
  (450668, 45042, '23', 'Province Or State Nm', 'TEXT'),
  (450669, 45042, '24', 'Address Line2 Txt', 'TEXT'),
  (450670, 45042, '25', 'Address Line2 Txt', 'TEXT'),
  (450671, 45042, '26', 'Address Line2 Txt', 'TEXT'),
  (450672, 45042, '27', 'Address Line1 Txt', 'TEXT'),
  (450673, 45042, '28', 'Country Cd', 'TEXT'),
  (450674, 45042, '29', 'City Nm', 'TEXT'),
  (450675, 45042, '30', 'Foreign Postal Cd', 'TEXT'),
  (450676, 45042, '31', 'Business Name Line2 Txt', 'TEXT'),
  (450677, 45042, '32', 'Province Or State Nm', 'TEXT'),
  (450678, 45042, '33', 'Address Line2 Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450646, NULL, NULL, 'Average Hrs Per Wk Devoted To Pos Rt', 'PERCENT', 'ReturnData/IRS990PF/OfficerDirTrstKeyEmplInfoGrp/CompensationHighestPaidEmplGrp/AverageHrsPerWkDevotedToPosRt'),
  (450647, NULL, NULL, 'Compensation Amt', 'CURRENCY', 'ReturnData/IRS990PF/OfficerDirTrstKeyEmplInfoGrp/CompensationHighestPaidEmplGrp/CompensationAmt'),
  (450648, NULL, NULL, 'Person Nm', 'TEXT', 'ReturnData/IRS990PF/OfficerDirTrstKeyEmplInfoGrp/CompensationHighestPaidEmplGrp/PersonNm'),
  (450649, NULL, NULL, 'Title Txt', 'TEXT', 'ReturnData/IRS990PF/OfficerDirTrstKeyEmplInfoGrp/CompensationHighestPaidEmplGrp/TitleTxt'),
  (450650, NULL, NULL, 'Address Line1 Txt', 'TEXT', 'ReturnData/IRS990PF/OfficerDirTrstKeyEmplInfoGrp/CompensationHighestPaidEmplGrp/USAddress/AddressLine1Txt'),
  (450651, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990PF/OfficerDirTrstKeyEmplInfoGrp/CompensationHighestPaidEmplGrp/USAddress/CityNm'),
  (450652, NULL, NULL, 'State Abbreviation Cd', 'TEXT', 'ReturnData/IRS990PF/OfficerDirTrstKeyEmplInfoGrp/CompensationHighestPaidEmplGrp/USAddress/StateAbbreviationCd'),
  (450653, NULL, NULL, 'ZIP Cd', 'TEXT', 'ReturnData/IRS990PF/OfficerDirTrstKeyEmplInfoGrp/CompensationHighestPaidEmplGrp/USAddress/ZIPCd'),
  (450654, NULL, NULL, 'Employee Benefits Amt', 'CURRENCY', 'ReturnData/IRS990PF/OfficerDirTrstKeyEmplInfoGrp/CompensationHighestPaidEmplGrp/EmployeeBenefitsAmt'),
  (450655, NULL, NULL, 'Expense Account Amt', 'CURRENCY', 'ReturnData/IRS990PF/OfficerDirTrstKeyEmplInfoGrp/CompensationHighestPaidEmplGrp/ExpenseAccountAmt'),
  (450656, NULL, NULL, 'Address Line1 Txt', 'TEXT', 'ReturnData/IRS990PF/OfficerDirTrstKeyEmplInfoGrp/OfficerDirTrstKeyEmplGrp/ForeignAddress/AddressLine1Txt'),
  (450657, NULL, NULL, 'Country Cd', 'TEXT', 'ReturnData/IRS990PF/OfficerDirTrstKeyEmplInfoGrp/OfficerDirTrstKeyEmplGrp/ForeignAddress/CountryCd'),
  (450658, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990PF/OfficerDirTrstKeyEmplInfoGrp/OfficerDirTrstKeyEmplGrp/ForeignAddress/CityNm'),
  (450659, NULL, NULL, 'Person Nm', 'TEXT', 'ReturnData/IRS990PF/OfficerDirTrstKeyEmplInfoGrp/CompensationOfHghstPdCntrctGrp/PersonNm'),
  (450660, NULL, NULL, 'Foreign Postal Cd', 'TEXT', 'ReturnData/IRS990PF/OfficerDirTrstKeyEmplInfoGrp/OfficerDirTrstKeyEmplGrp/ForeignAddress/ForeignPostalCd'),
  (450661, NULL, NULL, 'Province Or State Nm', 'TEXT', 'ReturnData/IRS990PF/OfficerDirTrstKeyEmplInfoGrp/OfficerDirTrstKeyEmplGrp/ForeignAddress/ProvinceOrStateNm'),
  (450662, NULL, NULL, 'Address Line1 Txt', 'TEXT', 'ReturnData/IRS990PF/OfficerDirTrstKeyEmplInfoGrp/CompensationOfHghstPdCntrctGrp/ForeignAddress/AddressLine1Txt'),
  (450663, NULL, NULL, 'Country Cd', 'TEXT', 'ReturnData/IRS990PF/OfficerDirTrstKeyEmplInfoGrp/CompensationOfHghstPdCntrctGrp/ForeignAddress/CountryCd'),
  (450664, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990PF/OfficerDirTrstKeyEmplInfoGrp/CompensationOfHghstPdCntrctGrp/ForeignAddress/CityNm'),
  (450665, NULL, NULL, 'Business Name Line2 Txt', 'TEXT', 'ReturnData/IRS990PF/OfficerDirTrstKeyEmplInfoGrp/OfficerDirTrstKeyEmplGrp/BusinessName/BusinessNameLine2Txt'),
  (450666, NULL, NULL, 'Foreign Postal Cd', 'TEXT', 'ReturnData/IRS990PF/OfficerDirTrstKeyEmplInfoGrp/CompensationOfHghstPdCntrctGrp/ForeignAddress/ForeignPostalCd'),
  (450667, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/IRS990PF/OfficerDirTrstKeyEmplInfoGrp/CompensationOfHghstPdCntrctGrp/USAddress/AddressLine2Txt'),
  (450668, NULL, NULL, 'Province Or State Nm', 'TEXT', 'ReturnData/IRS990PF/OfficerDirTrstKeyEmplInfoGrp/CompensationOfHghstPdCntrctGrp/ForeignAddress/ProvinceOrStateNm'),
  (450669, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/IRS990PF/OfficerDirTrstKeyEmplInfoGrp/OfficerDirTrstKeyEmplGrp/ForeignAddress/AddressLine2Txt'),
  (450670, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/IRS990PF/OfficerDirTrstKeyEmplInfoGrp/CompensationHighestPaidEmplGrp/USAddress/AddressLine2Txt'),
  (450671, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/IRS990PF/OfficerDirTrstKeyEmplInfoGrp/CompensationOfHghstPdCntrctGrp/ForeignAddress/AddressLine2Txt'),
  (450672, NULL, NULL, 'Address Line1 Txt', 'TEXT', 'ReturnData/IRS990PF/OfficerDirTrstKeyEmplInfoGrp/CompensationHighestPaidEmplGrp/ForeignAddress/AddressLine1Txt'),
  (450673, NULL, NULL, 'Country Cd', 'TEXT', 'ReturnData/IRS990PF/OfficerDirTrstKeyEmplInfoGrp/CompensationHighestPaidEmplGrp/ForeignAddress/CountryCd'),
  (450674, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990PF/OfficerDirTrstKeyEmplInfoGrp/CompensationHighestPaidEmplGrp/ForeignAddress/CityNm'),
  (450675, NULL, NULL, 'Foreign Postal Cd', 'TEXT', 'ReturnData/IRS990PF/OfficerDirTrstKeyEmplInfoGrp/CompensationHighestPaidEmplGrp/ForeignAddress/ForeignPostalCd'),
  (450676, NULL, NULL, 'Business Name Line2 Txt', 'TEXT', 'ReturnData/IRS990PF/OfficerDirTrstKeyEmplInfoGrp/CompensationOfHghstPdCntrctGrp/BusinessName/BusinessNameLine2Txt'),
  (450677, NULL, NULL, 'Province Or State Nm', 'TEXT', 'ReturnData/IRS990PF/OfficerDirTrstKeyEmplInfoGrp/CompensationHighestPaidEmplGrp/ForeignAddress/ProvinceOrStateNm'),
  (450678, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/IRS990PF/OfficerDirTrstKeyEmplInfoGrp/CompensationHighestPaidEmplGrp/ForeignAddress/AddressLine2Txt');

-- 990PF / Expenditure Responsibility Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (45043, 45, '044', 'Expenditure Responsibility Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450679, 45043, '1', 'Purpose Of Grant Txt', 'TEXT'),
  (450680, 45043, '2', 'Grant Amt', 'CURRENCY'),
  (450681, 45043, '3', 'Grant Dt', 'TEXT'),
  (450682, 45043, '4', 'Business Name Line1 Txt', 'TEXT'),
  (450683, 45043, '5', 'Dates Of Reports By Grantee Txt', 'TEXT'),
  (450684, 45043, '6', 'Any Diversion By Grantee Txt', 'TEXT'),
  (450685, 45043, '7', 'Expended By Grantee Amt', 'CURRENCY'),
  (450686, 45043, '8', 'Address Line1 Txt', 'TEXT'),
  (450687, 45043, '9', 'City Nm', 'TEXT'),
  (450688, 45043, '10', 'State Abbreviation Cd', 'TEXT'),
  (450689, 45043, '11', 'ZIP Cd', 'TEXT'),
  (450690, 45043, '12', 'Results Of Verification Txt', 'TEXT'),
  (450691, 45043, '13', 'Verification Dt', 'TEXT'),
  (450692, 45043, '14', 'Address Line1 Txt', 'TEXT'),
  (450693, 45043, '15', 'Country Cd', 'TEXT'),
  (450694, 45043, '16', 'City Nm', 'TEXT'),
  (450695, 45043, '17', 'Foreign Postal Cd', 'TEXT'),
  (450696, 45043, '18', 'Province Or State Nm', 'TEXT'),
  (450697, 45043, '19', 'Address Line2 Txt', 'TEXT'),
  (450698, 45043, '20', 'Person Nm', 'TEXT'),
  (450699, 45043, '21', 'Address Line2 Txt', 'TEXT'),
  (450700, 45043, '22', 'Business Name Line2 Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450679, NULL, NULL, 'Purpose Of Grant Txt', 'TEXT', 'ReturnData/ExpenditureResponsibilityStmt/ExpenditureResponsibilityGrp/PurposeOfGrantTxt'),
  (450680, NULL, NULL, 'Grant Amt', 'CURRENCY', 'ReturnData/ExpenditureResponsibilityStmt/ExpenditureResponsibilityGrp/GrantAmt'),
  (450681, NULL, NULL, 'Grant Dt', 'TEXT', 'ReturnData/ExpenditureResponsibilityStmt/ExpenditureResponsibilityGrp/GrantDt'),
  (450682, NULL, NULL, 'Business Name Line1 Txt', 'TEXT', 'ReturnData/ExpenditureResponsibilityStmt/ExpenditureResponsibilityGrp/BusinessName/BusinessNameLine1Txt'),
  (450683, NULL, NULL, 'Dates Of Reports By Grantee Txt', 'TEXT', 'ReturnData/ExpenditureResponsibilityStmt/ExpenditureResponsibilityGrp/DatesOfReportsByGranteeTxt'),
  (450684, NULL, NULL, 'Any Diversion By Grantee Txt', 'TEXT', 'ReturnData/ExpenditureResponsibilityStmt/ExpenditureResponsibilityGrp/AnyDiversionByGranteeTxt'),
  (450685, NULL, NULL, 'Expended By Grantee Amt', 'CURRENCY', 'ReturnData/ExpenditureResponsibilityStmt/ExpenditureResponsibilityGrp/ExpendedByGranteeAmt'),
  (450686, NULL, NULL, 'Address Line1 Txt', 'TEXT', 'ReturnData/ExpenditureResponsibilityStmt/ExpenditureResponsibilityGrp/USAddress/AddressLine1Txt'),
  (450687, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/ExpenditureResponsibilityStmt/ExpenditureResponsibilityGrp/USAddress/CityNm'),
  (450688, NULL, NULL, 'State Abbreviation Cd', 'TEXT', 'ReturnData/ExpenditureResponsibilityStmt/ExpenditureResponsibilityGrp/USAddress/StateAbbreviationCd'),
  (450689, NULL, NULL, 'ZIP Cd', 'TEXT', 'ReturnData/ExpenditureResponsibilityStmt/ExpenditureResponsibilityGrp/USAddress/ZIPCd'),
  (450690, NULL, NULL, 'Results Of Verification Txt', 'TEXT', 'ReturnData/ExpenditureResponsibilityStmt/ExpenditureResponsibilityGrp/ResultsOfVerificationTxt'),
  (450691, NULL, NULL, 'Verification Dt', 'TEXT', 'ReturnData/ExpenditureResponsibilityStmt/ExpenditureResponsibilityGrp/VerificationDt'),
  (450692, NULL, NULL, 'Address Line1 Txt', 'TEXT', 'ReturnData/ExpenditureResponsibilityStmt/ExpenditureResponsibilityGrp/ForeignAddress/AddressLine1Txt'),
  (450693, NULL, NULL, 'Country Cd', 'TEXT', 'ReturnData/ExpenditureResponsibilityStmt/ExpenditureResponsibilityGrp/ForeignAddress/CountryCd'),
  (450694, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/ExpenditureResponsibilityStmt/ExpenditureResponsibilityGrp/ForeignAddress/CityNm'),
  (450695, NULL, NULL, 'Foreign Postal Cd', 'TEXT', 'ReturnData/ExpenditureResponsibilityStmt/ExpenditureResponsibilityGrp/ForeignAddress/ForeignPostalCd'),
  (450696, NULL, NULL, 'Province Or State Nm', 'TEXT', 'ReturnData/ExpenditureResponsibilityStmt/ExpenditureResponsibilityGrp/ForeignAddress/ProvinceOrStateNm'),
  (450697, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/ExpenditureResponsibilityStmt/ExpenditureResponsibilityGrp/ForeignAddress/AddressLine2Txt'),
  (450698, NULL, NULL, 'Person Nm', 'TEXT', 'ReturnData/ExpenditureResponsibilityStmt/ExpenditureResponsibilityGrp/PersonNm'),
  (450699, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/ExpenditureResponsibilityStmt/ExpenditureResponsibilityGrp/USAddress/AddressLine2Txt'),
  (450700, NULL, NULL, 'Business Name Line2 Txt', 'TEXT', 'ReturnData/ExpenditureResponsibilityStmt/ExpenditureResponsibilityGrp/BusinessName/BusinessNameLine2Txt');

-- 990PF / Form990 PF Balance Sheets Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (45044, 45, '045', 'Form990 PF Balance Sheets Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450701, 45044, '1', 'Donor Rstr Net Assets BOY Amt', 'CURRENCY'),
  (450702, 45044, '2', 'Donor Rstr Net Assets EOY Amt', 'CURRENCY'),
  (450703, 45044, '3', 'Land Bldg Investments EOYFMV Amt', 'CURRENCY'),
  (450704, 45044, '4', 'Land Bldg Investments BOY Amt', 'CURRENCY'),
  (450705, 45044, '5', 'Mortgages And Notes Payable BOY Amt', 'CURRENCY'),
  (450706, 45044, '6', 'Rcvbl From Officers EOYFMV Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450701, NULL, NULL, 'Donor Rstr Net Assets BOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/DonorRstrNetAssetsBOYAmt'),
  (450702, NULL, NULL, 'Donor Rstr Net Assets EOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/DonorRstrNetAssetsEOYAmt'),
  (450703, NULL, NULL, 'Land Bldg Investments EOYFMV Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/LandBldgInvestmentsEOYFMVAmt'),
  (450704, NULL, NULL, 'Land Bldg Investments BOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/LandBldgInvestmentsBOYAmt'),
  (450705, NULL, NULL, 'Mortgages And Notes Payable BOY Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/MortgagesAndNotesPayableBOYAmt'),
  (450706, NULL, NULL, 'Rcvbl From Officers EOYFMV Amt', 'CURRENCY', 'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/RcvblFromOfficersEOYFMVAmt');

-- 990PF / Supplementary Information Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (45045, 45, '046', 'Supplementary Information Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450707, 45045, '1', 'Recipient Email Address Txt', 'TEXT'),
  (450708, 45045, '2', 'Foreign Postal Cd', 'TEXT'),
  (450709, 45045, '3', 'Province Or State Nm', 'TEXT'),
  (450710, 45045, '4', 'Address Line2 Txt', 'TEXT'),
  (450711, 45045, '5', 'Address Line2 Txt', 'TEXT'),
  (450712, 45045, '6', 'Recipient Person Nm', 'TEXT'),
  (450713, 45045, '7', 'Address Line2 Txt', 'TEXT'),
  (450714, 45045, '8', 'Address Line1 Txt', 'TEXT'),
  (450715, 45045, '9', 'Country Cd', 'TEXT'),
  (450716, 45045, '10', 'City Nm', 'TEXT'),
  (450717, 45045, '11', 'Foreign Postal Cd', 'TEXT'),
  (450718, 45045, '12', 'Province Or State Nm', 'TEXT'),
  (450719, 45045, '13', 'Address Line2 Txt', 'TEXT'),
  (450720, 45045, '14', 'Address Line1 Txt', 'TEXT'),
  (450721, 45045, '15', 'Country Cd', 'TEXT'),
  (450722, 45045, '16', 'City Nm', 'TEXT'),
  (450723, 45045, '17', 'Foreign Postal Cd', 'TEXT'),
  (450724, 45045, '18', 'Province Or State Nm', 'TEXT'),
  (450725, 45045, '19', 'Business Name Line2 Txt', 'TEXT'),
  (450726, 45045, '20', 'Address Line2 Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450707, NULL, NULL, 'Recipient Email Address Txt', 'TEXT', 'ReturnData/IRS990PF/SupplementaryInformationGrp/ApplicationSubmissionInfoGrp/RecipientEmailAddressTxt'),
  (450708, NULL, NULL, 'Foreign Postal Cd', 'TEXT', 'ReturnData/IRS990PF/SupplementaryInformationGrp/GrantOrContributionPdDurYrGrp/RecipientForeignAddress/ForeignPostalCd'),
  (450709, NULL, NULL, 'Province Or State Nm', 'TEXT', 'ReturnData/IRS990PF/SupplementaryInformationGrp/GrantOrContributionPdDurYrGrp/RecipientForeignAddress/ProvinceOrStateNm'),
  (450710, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/IRS990PF/SupplementaryInformationGrp/ApplicationSubmissionInfoGrp/RecipientUSAddress/AddressLine2Txt'),
  (450711, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/IRS990PF/SupplementaryInformationGrp/GrantOrContributionPdDurYrGrp/RecipientForeignAddress/AddressLine2Txt'),
  (450712, NULL, NULL, 'Recipient Person Nm', 'TEXT', 'ReturnData/IRS990PF/SupplementaryInformationGrp/GrantOrContriApprvForFutGrp/RecipientPersonNm'),
  (450713, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/IRS990PF/SupplementaryInformationGrp/GrantOrContriApprvForFutGrp/RecipientUSAddress/AddressLine2Txt'),
  (450714, NULL, NULL, 'Address Line1 Txt', 'TEXT', 'ReturnData/IRS990PF/SupplementaryInformationGrp/GrantOrContriApprvForFutGrp/RecipientForeignAddress/AddressLine1Txt'),
  (450715, NULL, NULL, 'Country Cd', 'TEXT', 'ReturnData/IRS990PF/SupplementaryInformationGrp/GrantOrContriApprvForFutGrp/RecipientForeignAddress/CountryCd'),
  (450716, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990PF/SupplementaryInformationGrp/GrantOrContriApprvForFutGrp/RecipientForeignAddress/CityNm'),
  (450717, NULL, NULL, 'Foreign Postal Cd', 'TEXT', 'ReturnData/IRS990PF/SupplementaryInformationGrp/GrantOrContriApprvForFutGrp/RecipientForeignAddress/ForeignPostalCd'),
  (450718, NULL, NULL, 'Province Or State Nm', 'TEXT', 'ReturnData/IRS990PF/SupplementaryInformationGrp/GrantOrContriApprvForFutGrp/RecipientForeignAddress/ProvinceOrStateNm'),
  (450719, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/IRS990PF/SupplementaryInformationGrp/GrantOrContriApprvForFutGrp/RecipientForeignAddress/AddressLine2Txt'),
  (450720, NULL, NULL, 'Address Line1 Txt', 'TEXT', 'ReturnData/IRS990PF/SupplementaryInformationGrp/ApplicationSubmissionInfoGrp/RecipientForeignAddress/AddressLine1Txt'),
  (450721, NULL, NULL, 'Country Cd', 'TEXT', 'ReturnData/IRS990PF/SupplementaryInformationGrp/ApplicationSubmissionInfoGrp/RecipientForeignAddress/CountryCd'),
  (450722, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990PF/SupplementaryInformationGrp/ApplicationSubmissionInfoGrp/RecipientForeignAddress/CityNm'),
  (450723, NULL, NULL, 'Foreign Postal Cd', 'TEXT', 'ReturnData/IRS990PF/SupplementaryInformationGrp/ApplicationSubmissionInfoGrp/RecipientForeignAddress/ForeignPostalCd'),
  (450724, NULL, NULL, 'Province Or State Nm', 'TEXT', 'ReturnData/IRS990PF/SupplementaryInformationGrp/ApplicationSubmissionInfoGrp/RecipientForeignAddress/ProvinceOrStateNm'),
  (450725, NULL, NULL, 'Business Name Line2 Txt', 'TEXT', 'ReturnData/IRS990PF/SupplementaryInformationGrp/GrantOrContriApprvForFutGrp/RecipientBusinessName/BusinessNameLine2Txt'),
  (450726, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/IRS990PF/SupplementaryInformationGrp/ApplicationSubmissionInfoGrp/RecipientForeignAddress/AddressLine2Txt');

-- 990PF / Analysis Income Producing Acty Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (45046, 45, '047', 'Analysis Income Producing Acty Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450727, 45046, '1', 'Exclusion Cd', 'TEXT'),
  (450728, 45046, '2', 'Exclusion Cd', 'TEXT'),
  (450729, 45046, '3', 'Business Cd', 'TEXT'),
  (450730, 45046, '4', 'Business Cd', 'TEXT'),
  (450731, 45046, '5', 'Exclusion Cd', 'TEXT'),
  (450732, 45046, '6', 'Business Cd', 'TEXT'),
  (450733, 45046, '7', 'Exclusion Cd', 'TEXT'),
  (450734, 45046, '8', 'Exclusion Cd', 'TEXT'),
  (450735, 45046, '9', 'Business Cd', 'TEXT'),
  (450736, 45046, '10', 'Exclusion Cd', 'TEXT'),
  (450737, 45046, '11', 'Business Cd', 'TEXT'),
  (450738, 45046, '12', 'Business Cd', 'TEXT'),
  (450739, 45046, '13', 'Exclusion Cd', 'TEXT'),
  (450740, 45046, '14', 'Business Cd', 'TEXT'),
  (450741, 45046, '15', 'Business Cd', 'TEXT'),
  (450742, 45046, '16', 'Exclusion Cd', 'TEXT'),
  (450743, 45046, '17', 'Related Or Exempt Function Incm Amt', 'CURRENCY'),
  (450744, 45046, '18', 'Unrelated Business Taxbl Incm Amt', 'CURRENCY'),
  (450745, 45046, '19', 'Exclusion Amt', 'CURRENCY'),
  (450746, 45046, '20', 'Business Cd', 'TEXT'),
  (450747, 45046, '21', 'Business Cd', 'TEXT'),
  (450748, 45046, '22', 'Exclusion Cd', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450727, NULL, NULL, 'Exclusion Cd', 'TEXT', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/OtherInvestmentIncomeGrp/ExclusionCd'),
  (450728, NULL, NULL, 'Exclusion Cd', 'TEXT', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/NetRntlIncmReNotDebtFincdProp/ExclusionCd'),
  (450729, NULL, NULL, 'Business Cd', 'TEXT', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/GainSalesAstOthThanInvntryGrp/BusinessCd'),
  (450730, NULL, NULL, 'Business Cd', 'TEXT', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/OtherInvestmentIncomeGrp/BusinessCd'),
  (450731, NULL, NULL, 'Exclusion Cd', 'TEXT', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/ProgramServiceRevenueDtl/ExclusionCd'),
  (450732, NULL, NULL, 'Business Cd', 'TEXT', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/ProgramServiceRevenueDtl/BusinessCd'),
  (450733, NULL, NULL, 'Exclusion Cd', 'TEXT', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/NetIncomeLossFromSpecialEvtGrp/ExclusionCd'),
  (450734, NULL, NULL, 'Exclusion Cd', 'TEXT', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/GrossProfitLossSlsOfInvntryGrp/ExclusionCd'),
  (450735, NULL, NULL, 'Business Cd', 'TEXT', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/GrossProfitLossSlsOfInvntryGrp/BusinessCd'),
  (450736, NULL, NULL, 'Exclusion Cd', 'TEXT', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/NetRntlIncmReDebtFincdPropGrp/ExclusionCd'),
  (450737, NULL, NULL, 'Business Cd', 'TEXT', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/NetRntlIncmReNotDebtFincdProp/BusinessCd'),
  (450738, NULL, NULL, 'Business Cd', 'TEXT', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/NetRntlIncmReDebtFincdPropGrp/BusinessCd'),
  (450739, NULL, NULL, 'Exclusion Cd', 'TEXT', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/MembershipDuesAndAssmntGrp/ExclusionCd'),
  (450740, NULL, NULL, 'Business Cd', 'TEXT', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/MembershipDuesAndAssmntGrp/BusinessCd'),
  (450741, NULL, NULL, 'Business Cd', 'TEXT', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/NetIncomeLossFromSpecialEvtGrp/BusinessCd'),
  (450742, NULL, NULL, 'Exclusion Cd', 'TEXT', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/NetRentalIncomePersonalPropGrp/ExclusionCd'),
  (450743, NULL, NULL, 'Related Or Exempt Function Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/FeesContractsFromGovtAgGrp/RelatedOrExemptFunctionIncmAmt'),
  (450744, NULL, NULL, 'Unrelated Business Taxbl Incm Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/FeesContractsFromGovtAgGrp/UnrelatedBusinessTaxblIncmAmt'),
  (450745, NULL, NULL, 'Exclusion Amt', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/FeesContractsFromGovtAgGrp/ExclusionAmt'),
  (450746, NULL, NULL, 'Business Cd', 'TEXT', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/NetRentalIncomePersonalPropGrp/BusinessCd'),
  (450747, NULL, NULL, 'Business Cd', 'TEXT', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/FeesContractsFromGovtAgGrp/BusinessCd'),
  (450748, NULL, NULL, 'Exclusion Cd', 'TEXT', 'ReturnData/IRS990PF/AnalysisIncomeProducingActyGrp/FeesContractsFromGovtAgGrp/ExclusionCd');

-- 990PF / Statements Regarding Acty4720 Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (45047, 45, '048', 'Statements Regarding Acty4720 Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450749, 45047, '1', 'Maintained Expenditure Rspns Ind', 'BOOLEAN'),
  (450750, 45047, '2', 'Excess Business Holdings Ind', 'BOOLEAN'),
  (450751, 45047, '3', 'Proceeds Or Net Income Ind', 'BOOLEAN'),
  (450752, 45047, '4', 'Undistributed Income PY3 Yr', 'TEXT'),
  (450753, 45047, '5', 'Relying Current Ntc Dsstr Asst1 Ind', 'BOOLEAN'),
  (450754, 45047, '6', 'Undistr Incm Sect4942a2 App Yr1 Yr', 'TEXT'),
  (450755, 45047, '7', 'Relying Current Ntc Dsstr Asst Ind', 'BOOLEAN'),
  (450756, 45047, '8', 'Undistr Incm Sect4942a2 App Yr2 Yr', 'TEXT'),
  (450757, 45047, '9', 'Undistr Incm Sect4942a2 App Yr4 Yr', 'TEXT'),
  (450758, 45047, '10', 'Undistr Incm Sect4942a2 App Yr3 Yr', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450749, NULL, NULL, 'Maintained Expenditure Rspns Ind', 'BOOLEAN', 'ReturnData/IRS990PF/StatementsRegardingActy4720Grp/MaintainedExpenditureRspnsInd'),
  (450750, NULL, NULL, 'Excess Business Holdings Ind', 'BOOLEAN', 'ReturnData/IRS990PF/StatementsRegardingActy4720Grp/ExcessBusinessHoldingsInd'),
  (450751, NULL, NULL, 'Proceeds Or Net Income Ind', 'BOOLEAN', 'ReturnData/IRS990PF/StatementsRegardingActy4720Grp/ProceedsOrNetIncomeInd'),
  (450752, NULL, NULL, 'Undistributed Income PY3 Yr', 'TEXT', 'ReturnData/IRS990PF/StatementsRegardingActy4720Grp/UndistributedIncomePY3Yr'),
  (450753, NULL, NULL, 'Relying Current Ntc Dsstr Asst1 Ind', 'BOOLEAN', 'ReturnData/IRS990PF/StatementsRegardingActy4720Grp/RelyingCurrentNtcDsstrAsst1Ind'),
  (450754, NULL, NULL, 'Undistr Incm Sect4942a2 App Yr1 Yr', 'TEXT', 'ReturnData/IRS990PF/StatementsRegardingActy4720Grp/UndistrIncmSect4942a2AppYr1Yr'),
  (450755, NULL, NULL, 'Relying Current Ntc Dsstr Asst Ind', 'BOOLEAN', 'ReturnData/IRS990PF/StatementsRegardingActy4720Grp/RelyingCurrentNtcDsstrAsstInd'),
  (450756, NULL, NULL, 'Undistr Incm Sect4942a2 App Yr2 Yr', 'TEXT', 'ReturnData/IRS990PF/StatementsRegardingActy4720Grp/UndistrIncmSect4942a2AppYr2Yr'),
  (450757, NULL, NULL, 'Undistr Incm Sect4942a2 App Yr4 Yr', 'TEXT', 'ReturnData/IRS990PF/StatementsRegardingActy4720Grp/UndistrIncmSect4942a2AppYr4Yr'),
  (450758, NULL, NULL, 'Undistr Incm Sect4942a2 App Yr3 Yr', 'TEXT', 'ReturnData/IRS990PF/StatementsRegardingActy4720Grp/UndistrIncmSect4942a2AppYr3Yr');

-- 990PF / Summary Of Direct Chrtbl Acty Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (45048, 45, '049', 'Summary Of Direct Chrtbl Acty Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450759, 45048, '1', 'Description3 Txt', 'TEXT'),
  (450760, 45048, '2', 'Expenses3 Amt', 'CURRENCY'),
  (450761, 45048, '3', 'Description4 Txt', 'TEXT'),
  (450762, 45048, '4', 'Expenses4 Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450759, NULL, NULL, 'Description3 Txt', 'TEXT', 'ReturnData/IRS990PF/SummaryOfDirectChrtblActyGrp/Description3Txt'),
  (450760, NULL, NULL, 'Expenses3 Amt', 'CURRENCY', 'ReturnData/IRS990PF/SummaryOfDirectChrtblActyGrp/Expenses3Amt'),
  (450761, NULL, NULL, 'Description4 Txt', 'TEXT', 'ReturnData/IRS990PF/SummaryOfDirectChrtblActyGrp/Description4Txt'),
  (450762, NULL, NULL, 'Expenses4 Amt', 'CURRENCY', 'ReturnData/IRS990PF/SummaryOfDirectChrtblActyGrp/Expenses4Amt');

-- 990PF / IRS990 PF Direct Fields
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (45049, 45, '050', 'IRS990 PF Direct Fields');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450763, 45049, '1', 'Organization4947a1 Trtd PF Ind', 'BOOLEAN'),
  (450764, 45049, '2', 'Method Of Accounting Other Ind', 'BOOLEAN'),
  (450765, 45049, '3', 'Name Change Ind', 'BOOLEAN'),
  (450766, 45049, '4', 'PF60 Month Term Sect507b1 B Ind', 'BOOLEAN'),
  (450767, 45049, '5', 'Foreign Org Meeting85 Pct Test Ind', 'BOOLEAN'),
  (450768, 45049, '6', 'Foreign Organization Ind', 'BOOLEAN'),
  (450769, 45049, '7', 'Organization501c3 Taxable PF Ind', 'BOOLEAN');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450763, NULL, NULL, 'Organization4947a1 Trtd PF Ind', 'BOOLEAN', 'ReturnData/IRS990PF/Organization4947a1TrtdPFInd'),
  (450764, NULL, NULL, 'Method Of Accounting Other Ind', 'BOOLEAN', 'ReturnData/IRS990PF/MethodOfAccountingOtherInd'),
  (450765, NULL, NULL, 'Name Change Ind', 'BOOLEAN', 'ReturnData/IRS990PF/NameChangeInd'),
  (450766, NULL, NULL, 'PF60 Month Term Sect507b1 B Ind', 'BOOLEAN', 'ReturnData/IRS990PF/PF60MonthTermSect507b1BInd'),
  (450767, NULL, NULL, 'Foreign Org Meeting85 Pct Test Ind', 'BOOLEAN', 'ReturnData/IRS990PF/ForeignOrgMeeting85PctTestInd'),
  (450768, NULL, NULL, 'Foreign Organization Ind', 'BOOLEAN', 'ReturnData/IRS990PF/ForeignOrganizationInd'),
  (450769, NULL, NULL, 'Organization501c3 Taxable PF Ind', 'BOOLEAN', 'ReturnData/IRS990PF/Organization501c3TaxablePFInd');

-- 990PF / Investment Land Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (45050, 45, '051', 'Investment Land Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450770, 45050, '1', 'Category Or Item Txt', 'TEXT'),
  (450771, 45050, '2', 'Cost Or Other Basis Amt', 'CURRENCY'),
  (450772, 45050, '3', 'Book Value Amt', 'CURRENCY'),
  (450773, 45050, '4', 'Accumulated Depreciation Amt', 'CURRENCY'),
  (450774, 45050, '5', 'EOYFMV Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450770, NULL, NULL, 'Category Or Item Txt', 'TEXT', 'ReturnData/InvestmentsLandSchedule2/InvestmentLandGrp/CategoryOrItemTxt'),
  (450771, NULL, NULL, 'Cost Or Other Basis Amt', 'CURRENCY', 'ReturnData/InvestmentsLandSchedule2/InvestmentLandGrp/CostOrOtherBasisAmt'),
  (450772, NULL, NULL, 'Book Value Amt', 'CURRENCY', 'ReturnData/InvestmentsLandSchedule2/InvestmentLandGrp/BookValueAmt'),
  (450773, NULL, NULL, 'Accumulated Depreciation Amt', 'CURRENCY', 'ReturnData/InvestmentsLandSchedule2/InvestmentLandGrp/AccumulatedDepreciationAmt'),
  (450774, NULL, NULL, 'EOYFMV Amt', 'CURRENCY', 'ReturnData/InvestmentsLandSchedule2/InvestmentLandGrp/EOYFMVAmt');

-- 990PF / Gain Loss Sale Other Asset Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (45051, 45, '052', 'Gain Loss Sale Other Asset Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450775, 45051, '1', 'Total Net Amt', 'CURRENCY'),
  (450776, 45051, '2', 'Basis Method Txt', 'TEXT'),
  (450777, 45051, '3', 'Person Nm', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450775, NULL, NULL, 'Total Net Amt', 'CURRENCY', 'ReturnData/GainLossSaleOtherAssetsSch/GainLossSaleOtherAssetGrp/TotalNetAmt'),
  (450776, NULL, NULL, 'Basis Method Txt', 'TEXT', 'ReturnData/GainLossSaleOtherAssetsSch/GainLossSaleOtherAssetGrp/BasisMethodTxt'),
  (450777, NULL, NULL, 'Person Nm', 'TEXT', 'ReturnData/GainLossSaleOtherAssetsSch/GainLossSaleOtherAssetGrp/PurchaserNameGrp/PersonNm');

-- 990PF / Trnsfr Trans Rln Nonchrtbl EO Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (45052, 45, '053', 'Trnsfr Trans Rln Nonchrtbl EO Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450778, 45052, '1', 'Business Name Line1 Txt', 'TEXT'),
  (450779, 45052, '2', 'Organization Type Desc', 'TEXT'),
  (450780, 45052, '3', 'Relationship Description Txt', 'TEXT'),
  (450781, 45052, '4', 'Business Name Line1 Txt', 'TEXT'),
  (450782, 45052, '5', 'Transfers Trans And Shr Arrngm Desc', 'TEXT'),
  (450783, 45052, '6', 'Line Number Txt', 'TEXT'),
  (450784, 45052, '7', 'Involved Amt', 'CURRENCY'),
  (450785, 45052, '8', 'Business Name Line2 Txt', 'TEXT'),
  (450786, 45052, '9', 'Business Name Line2 Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450778, NULL, NULL, 'Business Name Line1 Txt', 'TEXT', 'ReturnData/IRS990PF/TrnsfrTransRlnNonchrtblEOGrp/RelationshipScheduleDetail/OrganizationBusinessName/BusinessNameLine1Txt'),
  (450779, NULL, NULL, 'Organization Type Desc', 'TEXT', 'ReturnData/IRS990PF/TrnsfrTransRlnNonchrtblEOGrp/RelationshipScheduleDetail/OrganizationTypeDesc'),
  (450780, NULL, NULL, 'Relationship Description Txt', 'TEXT', 'ReturnData/IRS990PF/TrnsfrTransRlnNonchrtblEOGrp/RelationshipScheduleDetail/RelationshipDescriptionTxt'),
  (450781, NULL, NULL, 'Business Name Line1 Txt', 'TEXT', 'ReturnData/IRS990PF/TrnsfrTransRlnNonchrtblEOGrp/TransferScheduleDetail/NoncharitableExemptOrgName/BusinessNameLine1Txt'),
  (450782, NULL, NULL, 'Transfers Trans And Shr Arrngm Desc', 'TEXT', 'ReturnData/IRS990PF/TrnsfrTransRlnNonchrtblEOGrp/TransferScheduleDetail/TransfersTransAndShrArrngmDesc'),
  (450783, NULL, NULL, 'Line Number Txt', 'TEXT', 'ReturnData/IRS990PF/TrnsfrTransRlnNonchrtblEOGrp/TransferScheduleDetail/LineNumberTxt'),
  (450784, NULL, NULL, 'Involved Amt', 'CURRENCY', 'ReturnData/IRS990PF/TrnsfrTransRlnNonchrtblEOGrp/TransferScheduleDetail/InvolvedAmt'),
  (450785, NULL, NULL, 'Business Name Line2 Txt', 'TEXT', 'ReturnData/IRS990PF/TrnsfrTransRlnNonchrtblEOGrp/RelationshipScheduleDetail/OrganizationBusinessName/BusinessNameLine2Txt'),
  (450786, NULL, NULL, 'Business Name Line2 Txt', 'TEXT', 'ReturnData/IRS990PF/TrnsfrTransRlnNonchrtblEOGrp/TransferScheduleDetail/NoncharitableExemptOrgName/BusinessNameLine2Txt');

-- 990PF / Cap Gains Loss Tx Invst Incm Detail
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (45053, 45, '054', 'Cap Gains Loss Tx Invst Incm Detail');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450787, 45053, '1', 'Excess FMV Over Adjusted Bss Amt', 'CURRENCY'),
  (450788, 45053, '2', 'FMV As Of123169 Amt', 'CURRENCY'),
  (450789, 45053, '3', 'Adjusted Basis As Of123169 Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450787, NULL, NULL, 'Excess FMV Over Adjusted Bss Amt', 'CURRENCY', 'ReturnData/IRS990PF/CapGainsLossTxInvstIncmDetail/CapGainsLossTxInvstIncmGrp/ExcessFMVOverAdjustedBssAmt'),
  (450788, NULL, NULL, 'FMV As Of123169 Amt', 'CURRENCY', 'ReturnData/IRS990PF/CapGainsLossTxInvstIncmDetail/CapGainsLossTxInvstIncmGrp/FMVAsOf123169Amt'),
  (450789, NULL, NULL, 'Adjusted Basis As Of123169 Amt', 'CURRENCY', 'ReturnData/IRS990PF/CapGainsLossTxInvstIncmDetail/CapGainsLossTxInvstIncmGrp/AdjustedBasisAsOf123169Amt');

-- 990PF / Statements Regarding Acty Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (45054, 45, '055', 'Statements Regarding Acty Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450790, 45054, '1', 'NECT Filing In Lieu OF Form1041 Ind', 'BOOLEAN'),
  (450791, 45054, '2', 'Foreign Country Cd', 'TEXT'),
  (450792, 45054, '3', 'Tax Exempt Interest Amt', 'CURRENCY'),
  (450793, 45054, '4', 'Address Line1 Txt', 'TEXT'),
  (450794, 45054, '5', 'Country Cd', 'TEXT'),
  (450795, 45054, '6', 'City Nm', 'TEXT'),
  (450796, 45054, '7', 'Foreign Postal Cd', 'TEXT'),
  (450797, 45054, '8', 'Province Or State Nm', 'TEXT'),
  (450798, 45054, '9', 'Address Line2 Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450790, NULL, NULL, 'NECT Filing In Lieu OF Form1041 Ind', 'BOOLEAN', 'ReturnData/IRS990PF/StatementsRegardingActyGrp/NECTFilingInLieuOFForm1041Ind'),
  (450791, NULL, NULL, 'Foreign Country Cd', 'TEXT', 'ReturnData/IRS990PF/StatementsRegardingActyGrp/ForeignCountryCd'),
  (450792, NULL, NULL, 'Tax Exempt Interest Amt', 'CURRENCY', 'ReturnData/IRS990PF/StatementsRegardingActyGrp/TaxExemptInterestAmt'),
  (450793, NULL, NULL, 'Address Line1 Txt', 'TEXT', 'ReturnData/IRS990PF/StatementsRegardingActyGrp/LocationOfBooksForeignAddress/AddressLine1Txt'),
  (450794, NULL, NULL, 'Country Cd', 'TEXT', 'ReturnData/IRS990PF/StatementsRegardingActyGrp/LocationOfBooksForeignAddress/CountryCd'),
  (450795, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990PF/StatementsRegardingActyGrp/LocationOfBooksForeignAddress/CityNm'),
  (450796, NULL, NULL, 'Foreign Postal Cd', 'TEXT', 'ReturnData/IRS990PF/StatementsRegardingActyGrp/LocationOfBooksForeignAddress/ForeignPostalCd'),
  (450797, NULL, NULL, 'Province Or State Nm', 'TEXT', 'ReturnData/IRS990PF/StatementsRegardingActyGrp/LocationOfBooksForeignAddress/ProvinceOrStateNm'),
  (450798, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/IRS990PF/StatementsRegardingActyGrp/LocationOfBooksForeignAddress/AddressLine2Txt');

-- 990PF / Other Notes Loans Rcvbl Long Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (45055, 45, '056', 'Other Notes Loans Rcvbl Long Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450799, 45055, '1', 'Interest Rt', 'PERCENT'),
  (450800, 45055, '2', 'Balance Due Amt', 'CURRENCY'),
  (450801, 45055, '3', 'Loan Original Amt', 'CURRENCY'),
  (450802, 45055, '4', 'Note Dt', 'TEXT'),
  (450803, 45055, '5', 'Loan Maturity Dt', 'TEXT'),
  (450804, 45055, '6', 'Loan Purpose Txt', 'TEXT'),
  (450805, 45055, '7', 'Repayment Terms Txt', 'TEXT'),
  (450806, 45055, '8', 'Business Name Line1 Txt', 'TEXT'),
  (450807, 45055, '9', 'Security Provided Borrower Txt', 'TEXT'),
  (450808, 45055, '10', 'Insider Relationship Txt', 'TEXT'),
  (450809, 45055, '11', 'Consideration FMV Amt', 'CURRENCY'),
  (450810, 45055, '12', 'Person Nm', 'TEXT'),
  (450811, 45055, '13', 'Lender Consideration Desc', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450799, NULL, NULL, 'Interest Rt', 'PERCENT', 'ReturnData/OtherNotesLoansRcvblLongSch/OtherNotesLoansRcvblLongGrp/InterestRt'),
  (450800, NULL, NULL, 'Balance Due Amt', 'CURRENCY', 'ReturnData/OtherNotesLoansRcvblLongSch/OtherNotesLoansRcvblLongGrp/BalanceDueAmt'),
  (450801, NULL, NULL, 'Loan Original Amt', 'CURRENCY', 'ReturnData/OtherNotesLoansRcvblLongSch/OtherNotesLoansRcvblLongGrp/LoanOriginalAmt'),
  (450802, NULL, NULL, 'Note Dt', 'TEXT', 'ReturnData/OtherNotesLoansRcvblLongSch/OtherNotesLoansRcvblLongGrp/NoteDt'),
  (450803, NULL, NULL, 'Loan Maturity Dt', 'TEXT', 'ReturnData/OtherNotesLoansRcvblLongSch/OtherNotesLoansRcvblLongGrp/LoanMaturityDt'),
  (450804, NULL, NULL, 'Loan Purpose Txt', 'TEXT', 'ReturnData/OtherNotesLoansRcvblLongSch/OtherNotesLoansRcvblLongGrp/LoanPurposeTxt'),
  (450805, NULL, NULL, 'Repayment Terms Txt', 'TEXT', 'ReturnData/OtherNotesLoansRcvblLongSch/OtherNotesLoansRcvblLongGrp/RepaymentTermsTxt'),
  (450806, NULL, NULL, 'Business Name Line1 Txt', 'TEXT', 'ReturnData/OtherNotesLoansRcvblLongSch/OtherNotesLoansRcvblLongGrp/BorrowerNameGrp/BusinessName/BusinessNameLine1Txt'),
  (450807, NULL, NULL, 'Security Provided Borrower Txt', 'TEXT', 'ReturnData/OtherNotesLoansRcvblLongSch/OtherNotesLoansRcvblLongGrp/SecurityProvidedBorrowerTxt'),
  (450808, NULL, NULL, 'Insider Relationship Txt', 'TEXT', 'ReturnData/OtherNotesLoansRcvblLongSch/OtherNotesLoansRcvblLongGrp/InsiderRelationshipTxt'),
  (450809, NULL, NULL, 'Consideration FMV Amt', 'CURRENCY', 'ReturnData/OtherNotesLoansRcvblLongSch/OtherNotesLoansRcvblLongGrp/ConsiderationFMVAmt'),
  (450810, NULL, NULL, 'Person Nm', 'TEXT', 'ReturnData/OtherNotesLoansRcvblLongSch/OtherNotesLoansRcvblLongGrp/BorrowerNameGrp/PersonNm'),
  (450811, NULL, NULL, 'Lender Consideration Desc', 'TEXT', 'ReturnData/OtherNotesLoansRcvblLongSch/OtherNotesLoansRcvblLongGrp/LenderConsiderationDesc');

-- 990PF / Excise Tax Based On Invst Incm Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (45056, 45, '057', 'Excise Tax Based On Invst Incm Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450812, 45056, '1', 'Original Return Tax Paid Amt', 'CURRENCY'),
  (450813, 45056, '2', 'Original Return Overpayment Amt', 'CURRENCY'),
  (450814, 45056, '3', 'Ruling Letter Dt', 'TEXT'),
  (450815, 45056, '4', 'Not Applicable Cd', 'TEXT'),
  (450816, 45056, '5', 'Exempt Operating Foundations Ind', 'BOOLEAN');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450812, NULL, NULL, 'Original Return Tax Paid Amt', 'CURRENCY', 'ReturnData/IRS990PF/ExciseTaxBasedOnInvstIncmGrp/OriginalReturnTaxPaidAmt'),
  (450813, NULL, NULL, 'Original Return Overpayment Amt', 'CURRENCY', 'ReturnData/IRS990PF/ExciseTaxBasedOnInvstIncmGrp/OriginalReturnOverpaymentAmt'),
  (450814, NULL, NULL, 'Ruling Letter Dt', 'TEXT', 'ReturnData/IRS990PF/ExciseTaxBasedOnInvstIncmGrp/RulingLetterDt'),
  (450815, NULL, NULL, 'Not Applicable Cd', 'TEXT', 'ReturnData/IRS990PF/ExciseTaxBasedOnInvstIncmGrp/NotApplicableCd'),
  (450816, NULL, NULL, 'Exempt Operating Foundations Ind', 'BOOLEAN', 'ReturnData/IRS990PF/ExciseTaxBasedOnInvstIncmGrp/ExemptOperatingFoundationsInd');

-- 990PF / Amortization Schedule Detail
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (45057, 45, '058', 'Amortization Schedule Detail');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450817, 45057, '1', 'Amortized Expenses Desc', 'TEXT'),
  (450818, 45057, '2', 'Total Amortization Amt', 'CURRENCY'),
  (450819, 45057, '3', 'Current Year Amortization Amt', 'CURRENCY'),
  (450820, 45057, '4', 'Acquired Completed Or Expended Dt', 'TEXT'),
  (450821, 45057, '5', 'Amortized Amt', 'CURRENCY'),
  (450822, 45057, '6', 'Amortization Period Rt', 'PERCENT'),
  (450823, 45057, '7', 'Deduction For Prior Years Amt', 'CURRENCY'),
  (450824, 45057, '8', 'Net Investment Income Amt', 'CURRENCY'),
  (450825, 45057, '9', 'Adjusted Net Income Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450817, NULL, NULL, 'Amortized Expenses Desc', 'TEXT', 'ReturnData/AmortizationSchedule/AmortizationScheduleDetail/AmortizedExpensesDesc'),
  (450818, NULL, NULL, 'Total Amortization Amt', 'CURRENCY', 'ReturnData/AmortizationSchedule/AmortizationScheduleDetail/TotalAmortizationAmt'),
  (450819, NULL, NULL, 'Current Year Amortization Amt', 'CURRENCY', 'ReturnData/AmortizationSchedule/AmortizationScheduleDetail/CurrentYearAmortizationAmt'),
  (450820, NULL, NULL, 'Acquired Completed Or Expended Dt', 'TEXT', 'ReturnData/AmortizationSchedule/AmortizationScheduleDetail/AcquiredCompletedOrExpendedDt'),
  (450821, NULL, NULL, 'Amortized Amt', 'CURRENCY', 'ReturnData/AmortizationSchedule/AmortizationScheduleDetail/AmortizedAmt'),
  (450822, NULL, NULL, 'Amortization Period Rt', 'PERCENT', 'ReturnData/AmortizationSchedule/AmortizationScheduleDetail/AmortizationPeriodRt'),
  (450823, NULL, NULL, 'Deduction For Prior Years Amt', 'CURRENCY', 'ReturnData/AmortizationSchedule/AmortizationScheduleDetail/DeductionForPriorYearsAmt'),
  (450824, NULL, NULL, 'Net Investment Income Amt', 'CURRENCY', 'ReturnData/AmortizationSchedule/AmortizationScheduleDetail/NetInvestmentIncomeAmt'),
  (450825, NULL, NULL, 'Adjusted Net Income Amt', 'CURRENCY', 'ReturnData/AmortizationSchedule/AmortizationScheduleDetail/AdjustedNetIncomeAmt');

-- 990PF / Loans From Officer Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (45058, 45, '059', 'Loans From Officer Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450826, 45058, '1', 'Lender Person Nm', 'TEXT'),
  (450827, 45058, '2', 'Loan Original Amt', 'CURRENCY'),
  (450828, 45058, '3', 'Balance Due Amt', 'CURRENCY'),
  (450829, 45058, '4', 'Loan Purpose Txt', 'TEXT'),
  (450830, 45058, '5', 'Title Txt', 'TEXT'),
  (450831, 45058, '6', 'Note Dt', 'TEXT'),
  (450832, 45058, '7', 'Repayment Terms Txt', 'TEXT'),
  (450833, 45058, '8', 'Security Provided Borrower Txt', 'TEXT'),
  (450834, 45058, '9', 'Lender Consideration Desc', 'TEXT'),
  (450835, 45058, '10', 'Loan Maturity Dt', 'TEXT'),
  (450836, 45058, '11', 'Interest Rt', 'PERCENT'),
  (450837, 45058, '12', 'Consideration FMV Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450826, NULL, NULL, 'Lender Person Nm', 'TEXT', 'ReturnData/LoansFromOfficersSchedule/LoansFromOfficerGrp/LenderPersonNm'),
  (450827, NULL, NULL, 'Loan Original Amt', 'CURRENCY', 'ReturnData/LoansFromOfficersSchedule/LoansFromOfficerGrp/LoanOriginalAmt'),
  (450828, NULL, NULL, 'Balance Due Amt', 'CURRENCY', 'ReturnData/LoansFromOfficersSchedule/LoansFromOfficerGrp/BalanceDueAmt'),
  (450829, NULL, NULL, 'Loan Purpose Txt', 'TEXT', 'ReturnData/LoansFromOfficersSchedule/LoansFromOfficerGrp/LoanPurposeTxt'),
  (450830, NULL, NULL, 'Title Txt', 'TEXT', 'ReturnData/LoansFromOfficersSchedule/LoansFromOfficerGrp/TitleTxt'),
  (450831, NULL, NULL, 'Note Dt', 'TEXT', 'ReturnData/LoansFromOfficersSchedule/LoansFromOfficerGrp/NoteDt'),
  (450832, NULL, NULL, 'Repayment Terms Txt', 'TEXT', 'ReturnData/LoansFromOfficersSchedule/LoansFromOfficerGrp/RepaymentTermsTxt'),
  (450833, NULL, NULL, 'Security Provided Borrower Txt', 'TEXT', 'ReturnData/LoansFromOfficersSchedule/LoansFromOfficerGrp/SecurityProvidedBorrowerTxt'),
  (450834, NULL, NULL, 'Lender Consideration Desc', 'TEXT', 'ReturnData/LoansFromOfficersSchedule/LoansFromOfficerGrp/LenderConsiderationDesc'),
  (450835, NULL, NULL, 'Loan Maturity Dt', 'TEXT', 'ReturnData/LoansFromOfficersSchedule/LoansFromOfficerGrp/LoanMaturityDt'),
  (450836, NULL, NULL, 'Interest Rt', 'PERCENT', 'ReturnData/LoansFromOfficersSchedule/LoansFromOfficerGrp/InterestRt'),
  (450837, NULL, NULL, 'Consideration FMV Amt', 'CURRENCY', 'ReturnData/LoansFromOfficersSchedule/LoansFromOfficerGrp/ConsiderationFMVAmt');

-- 990PF / Inventory Sale Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (45059, 45, '060', 'Inventory Sale Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450838, 45059, '1', 'Net Amt', 'CURRENCY'),
  (450839, 45059, '2', 'Gross Sales Amt', 'CURRENCY'),
  (450840, 45059, '3', 'Category Txt', 'TEXT'),
  (450841, 45059, '4', 'Cost Of Goods Sold Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450838, NULL, NULL, 'Net Amt', 'CURRENCY', 'ReturnData/SalesOfInventoryList/InventorySaleGrp/NetAmt'),
  (450839, NULL, NULL, 'Gross Sales Amt', 'CURRENCY', 'ReturnData/SalesOfInventoryList/InventorySaleGrp/GrossSalesAmt'),
  (450840, NULL, NULL, 'Category Txt', 'TEXT', 'ReturnData/SalesOfInventoryList/InventorySaleGrp/CategoryTxt'),
  (450841, NULL, NULL, 'Cost Of Goods Sold Amt', 'CURRENCY', 'ReturnData/SalesOfInventoryList/InventorySaleGrp/CostOfGoodsSoldAmt');

-- 990PF / Note Payable Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (45060, 45, '061', 'Note Payable Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450842, 45060, '1', 'Balance Due Amt', 'CURRENCY'),
  (450843, 45060, '2', 'Loan Original Amt', 'CURRENCY'),
  (450844, 45060, '3', 'Note Dt', 'TEXT'),
  (450845, 45060, '4', 'Loan Purpose Txt', 'TEXT'),
  (450846, 45060, '5', 'Interest Rt', 'PERCENT'),
  (450847, 45060, '6', 'Person Nm', 'TEXT'),
  (450848, 45060, '7', 'Security Provided Borrower Txt', 'TEXT'),
  (450849, 45060, '8', 'Loan Maturity Dt', 'TEXT'),
  (450850, 45060, '9', 'Repayment Terms Txt', 'TEXT'),
  (450851, 45060, '10', 'Insider Relationship Txt', 'TEXT'),
  (450852, 45060, '11', 'Business Name Line1 Txt', 'TEXT'),
  (450853, 45060, '12', 'Lender Consideration Desc', 'TEXT'),
  (450854, 45060, '13', 'Consideration FMV Amt', 'CURRENCY'),
  (450855, 45060, '14', 'Title Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450842, NULL, NULL, 'Balance Due Amt', 'CURRENCY', 'ReturnData/MortgagesAndNotesPayableSch/NotePayableGrp/BalanceDueAmt'),
  (450843, NULL, NULL, 'Loan Original Amt', 'CURRENCY', 'ReturnData/MortgagesAndNotesPayableSch/NotePayableGrp/LoanOriginalAmt'),
  (450844, NULL, NULL, 'Note Dt', 'TEXT', 'ReturnData/MortgagesAndNotesPayableSch/NotePayableGrp/NoteDt'),
  (450845, NULL, NULL, 'Loan Purpose Txt', 'TEXT', 'ReturnData/MortgagesAndNotesPayableSch/NotePayableGrp/LoanPurposeTxt'),
  (450846, NULL, NULL, 'Interest Rt', 'PERCENT', 'ReturnData/MortgagesAndNotesPayableSch/NotePayableGrp/InterestRt'),
  (450847, NULL, NULL, 'Person Nm', 'TEXT', 'ReturnData/MortgagesAndNotesPayableSch/NotePayableGrp/LenderNameGrp/PersonNm'),
  (450848, NULL, NULL, 'Security Provided Borrower Txt', 'TEXT', 'ReturnData/MortgagesAndNotesPayableSch/NotePayableGrp/SecurityProvidedBorrowerTxt'),
  (450849, NULL, NULL, 'Loan Maturity Dt', 'TEXT', 'ReturnData/MortgagesAndNotesPayableSch/NotePayableGrp/LoanMaturityDt'),
  (450850, NULL, NULL, 'Repayment Terms Txt', 'TEXT', 'ReturnData/MortgagesAndNotesPayableSch/NotePayableGrp/RepaymentTermsTxt'),
  (450851, NULL, NULL, 'Insider Relationship Txt', 'TEXT', 'ReturnData/MortgagesAndNotesPayableSch/NotePayableGrp/InsiderRelationshipTxt'),
  (450852, NULL, NULL, 'Business Name Line1 Txt', 'TEXT', 'ReturnData/MortgagesAndNotesPayableSch/NotePayableGrp/LenderNameGrp/BusinessName/BusinessNameLine1Txt'),
  (450853, NULL, NULL, 'Lender Consideration Desc', 'TEXT', 'ReturnData/MortgagesAndNotesPayableSch/NotePayableGrp/LenderConsiderationDesc'),
  (450854, NULL, NULL, 'Consideration FMV Amt', 'CURRENCY', 'ReturnData/MortgagesAndNotesPayableSch/NotePayableGrp/ConsiderationFMVAmt'),
  (450855, NULL, NULL, 'Title Txt', 'TEXT', 'ReturnData/MortgagesAndNotesPayableSch/NotePayableGrp/TitleTxt');

-- 990PF / Contributor Information Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (45061, 45, '062', 'Contributor Information Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450856, 45061, '1', 'Address Line1 Txt', 'TEXT'),
  (450857, 45061, '2', 'Country Cd', 'TEXT'),
  (450858, 45061, '3', 'City Nm', 'TEXT'),
  (450859, 45061, '4', 'Foreign Postal Cd', 'TEXT'),
  (450860, 45061, '5', 'Province Or State Nm', 'TEXT'),
  (450861, 45061, '6', 'Payroll Contribution Ind', 'BOOLEAN'),
  (450862, 45061, '7', 'Business Name Line2 Txt', 'TEXT'),
  (450863, 45061, '8', 'Address Line2 Txt', 'TEXT'),
  (450864, 45061, '9', 'Paid527j1 Ind', 'BOOLEAN');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450856, NULL, NULL, 'Address Line1 Txt', 'TEXT', 'ReturnData/IRS990ScheduleB/ContributorInformationGrp/ContributorForeignAddress/AddressLine1Txt'),
  (450857, NULL, NULL, 'Country Cd', 'TEXT', 'ReturnData/IRS990ScheduleB/ContributorInformationGrp/ContributorForeignAddress/CountryCd'),
  (450858, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990ScheduleB/ContributorInformationGrp/ContributorForeignAddress/CityNm'),
  (450859, NULL, NULL, 'Foreign Postal Cd', 'TEXT', 'ReturnData/IRS990ScheduleB/ContributorInformationGrp/ContributorForeignAddress/ForeignPostalCd'),
  (450860, NULL, NULL, 'Province Or State Nm', 'TEXT', 'ReturnData/IRS990ScheduleB/ContributorInformationGrp/ContributorForeignAddress/ProvinceOrStateNm'),
  (450861, NULL, NULL, 'Payroll Contribution Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleB/ContributorInformationGrp/PayrollContributionInd'),
  (450862, NULL, NULL, 'Business Name Line2 Txt', 'TEXT', 'ReturnData/IRS990ScheduleB/ContributorInformationGrp/ContributorBusinessName/BusinessNameLine2Txt'),
  (450863, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/IRS990ScheduleB/ContributorInformationGrp/ContributorForeignAddress/AddressLine2Txt'),
  (450864, NULL, NULL, 'Paid527j1 Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleB/ContributorInformationGrp/Paid527j1Ind');

-- 990PF / Substantial Contributor Detail
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (45062, 45, '063', 'Substantial Contributor Detail');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450865, 45062, '1', 'Business Name Line1 Txt', 'TEXT'),
  (450866, 45062, '2', 'Address Line2 Txt', 'TEXT'),
  (450867, 45062, '3', 'Address Line1 Txt', 'TEXT'),
  (450868, 45062, '4', 'Country Cd', 'TEXT'),
  (450869, 45062, '5', 'City Nm', 'TEXT'),
  (450870, 45062, '6', 'Foreign Postal Cd', 'TEXT'),
  (450871, 45062, '7', 'Province Or State Nm', 'TEXT'),
  (450872, 45062, '8', 'Business Name Line2 Txt', 'TEXT'),
  (450873, 45062, '9', 'Address Line2 Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450865, NULL, NULL, 'Business Name Line1 Txt', 'TEXT', 'ReturnData/SubstantialContributorsSch/SubstantialContributorDetail/BusinessName/BusinessNameLine1Txt'),
  (450866, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/SubstantialContributorsSch/SubstantialContributorDetail/USAddress/AddressLine2Txt'),
  (450867, NULL, NULL, 'Address Line1 Txt', 'TEXT', 'ReturnData/SubstantialContributorsSch/SubstantialContributorDetail/ForeignAddress/AddressLine1Txt'),
  (450868, NULL, NULL, 'Country Cd', 'TEXT', 'ReturnData/SubstantialContributorsSch/SubstantialContributorDetail/ForeignAddress/CountryCd'),
  (450869, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/SubstantialContributorsSch/SubstantialContributorDetail/ForeignAddress/CityNm'),
  (450870, NULL, NULL, 'Foreign Postal Cd', 'TEXT', 'ReturnData/SubstantialContributorsSch/SubstantialContributorDetail/ForeignAddress/ForeignPostalCd'),
  (450871, NULL, NULL, 'Province Or State Nm', 'TEXT', 'ReturnData/SubstantialContributorsSch/SubstantialContributorDetail/ForeignAddress/ProvinceOrStateNm'),
  (450872, NULL, NULL, 'Business Name Line2 Txt', 'TEXT', 'ReturnData/SubstantialContributorsSch/SubstantialContributorDetail/BusinessName/BusinessNameLine2Txt'),
  (450873, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/SubstantialContributorsSch/SubstantialContributorDetail/ForeignAddress/AddressLine2Txt');

-- 990PF / Sum Of Program Related Invst Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (45063, 45, '064', 'Sum Of Program Related Invst Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450874, 45063, '1', 'Description2 Txt', 'TEXT'),
  (450875, 45063, '2', 'Expenses2 Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450874, NULL, NULL, 'Description2 Txt', 'TEXT', 'ReturnData/IRS990PF/SumOfProgramRelatedInvstGrp/Description2Txt'),
  (450875, NULL, NULL, 'Expenses2 Amt', 'CURRENCY', 'ReturnData/IRS990PF/SumOfProgramRelatedInvstGrp/Expenses2Amt');

-- 990PF / Election Desc
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (45064, 45, '065', 'Election Desc');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450876, 45064, '1', 'Election Desc', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450876, NULL, NULL, 'Election Desc', 'TEXT', 'ReturnData/AppliedToPriorYearElection/ElectionDesc');

-- 990PF / Transfers From Controlled Ent Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (45065, 45, '066', 'Transfers From Controlled Ent Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450877, 45065, '1', 'Amt', 'CURRENCY'),
  (450878, 45065, '2', 'Business Name Line1 Txt', 'TEXT'),
  (450879, 45065, '3', 'Desc', 'TEXT'),
  (450880, 45065, '4', 'EIN', 'TEXT'),
  (450881, 45065, '5', 'Address Line1 Txt', 'TEXT'),
  (450882, 45065, '6', 'City Nm', 'TEXT'),
  (450883, 45065, '7', 'State Abbreviation Cd', 'TEXT'),
  (450884, 45065, '8', 'ZIP Cd', 'TEXT'),
  (450885, 45065, '9', 'Address Line1 Txt', 'TEXT'),
  (450886, 45065, '10', 'Country Cd', 'TEXT'),
  (450887, 45065, '11', 'City Nm', 'TEXT'),
  (450888, 45065, '12', 'Foreign Postal Cd', 'TEXT'),
  (450889, 45065, '13', 'Address Line2 Txt', 'TEXT'),
  (450890, 45065, '14', 'Address Line2 Txt', 'TEXT'),
  (450891, 45065, '15', 'Province Or State Nm', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450877, NULL, NULL, 'Amt', 'CURRENCY', 'ReturnData/TransfersFrmControlledEntities/TransfersFromControlledEntGrp/Amt'),
  (450878, NULL, NULL, 'Business Name Line1 Txt', 'TEXT', 'ReturnData/TransfersFrmControlledEntities/TransfersFromControlledEntGrp/BusinessName/BusinessNameLine1Txt'),
  (450879, NULL, NULL, 'Desc', 'TEXT', 'ReturnData/TransfersFrmControlledEntities/TransfersFromControlledEntGrp/Desc'),
  (450880, NULL, NULL, 'EIN', 'TEXT', 'ReturnData/TransfersFrmControlledEntities/TransfersFromControlledEntGrp/EIN'),
  (450881, NULL, NULL, 'Address Line1 Txt', 'TEXT', 'ReturnData/TransfersFrmControlledEntities/TransfersFromControlledEntGrp/USAddress/AddressLine1Txt'),
  (450882, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/TransfersFrmControlledEntities/TransfersFromControlledEntGrp/USAddress/CityNm'),
  (450883, NULL, NULL, 'State Abbreviation Cd', 'TEXT', 'ReturnData/TransfersFrmControlledEntities/TransfersFromControlledEntGrp/USAddress/StateAbbreviationCd'),
  (450884, NULL, NULL, 'ZIP Cd', 'TEXT', 'ReturnData/TransfersFrmControlledEntities/TransfersFromControlledEntGrp/USAddress/ZIPCd'),
  (450885, NULL, NULL, 'Address Line1 Txt', 'TEXT', 'ReturnData/TransfersFrmControlledEntities/TransfersFromControlledEntGrp/ForeignAddress/AddressLine1Txt'),
  (450886, NULL, NULL, 'Country Cd', 'TEXT', 'ReturnData/TransfersFrmControlledEntities/TransfersFromControlledEntGrp/ForeignAddress/CountryCd'),
  (450887, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/TransfersFrmControlledEntities/TransfersFromControlledEntGrp/ForeignAddress/CityNm'),
  (450888, NULL, NULL, 'Foreign Postal Cd', 'TEXT', 'ReturnData/TransfersFrmControlledEntities/TransfersFromControlledEntGrp/ForeignAddress/ForeignPostalCd'),
  (450889, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/TransfersFrmControlledEntities/TransfersFromControlledEntGrp/ForeignAddress/AddressLine2Txt'),
  (450890, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/TransfersFrmControlledEntities/TransfersFromControlledEntGrp/USAddress/AddressLine2Txt'),
  (450891, NULL, NULL, 'Province Or State Nm', 'TEXT', 'ReturnData/TransfersFrmControlledEntities/TransfersFromControlledEntGrp/ForeignAddress/ProvinceOrStateNm');

-- 990PF / Transfers To Controlled Ent Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (45066, 45, '067', 'Transfers To Controlled Ent Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450892, 45066, '1', 'Amt', 'CURRENCY'),
  (450893, 45066, '2', 'Business Name Line1 Txt', 'TEXT'),
  (450894, 45066, '3', 'Desc', 'TEXT'),
  (450895, 45066, '4', 'EIN', 'TEXT'),
  (450896, 45066, '5', 'Address Line1 Txt', 'TEXT'),
  (450897, 45066, '6', 'City Nm', 'TEXT'),
  (450898, 45066, '7', 'State Abbreviation Cd', 'TEXT'),
  (450899, 45066, '8', 'ZIP Cd', 'TEXT'),
  (450900, 45066, '9', 'Address Line1 Txt', 'TEXT'),
  (450901, 45066, '10', 'Country Cd', 'TEXT'),
  (450902, 45066, '11', 'City Nm', 'TEXT'),
  (450903, 45066, '12', 'Foreign Postal Cd', 'TEXT'),
  (450904, 45066, '13', 'Province Or State Nm', 'TEXT'),
  (450905, 45066, '14', 'Address Line2 Txt', 'TEXT'),
  (450906, 45066, '15', 'Address Line2 Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450892, NULL, NULL, 'Amt', 'CURRENCY', 'ReturnData/TransfersToControlledEntities/TransfersToControlledEntGrp/Amt'),
  (450893, NULL, NULL, 'Business Name Line1 Txt', 'TEXT', 'ReturnData/TransfersToControlledEntities/TransfersToControlledEntGrp/BusinessName/BusinessNameLine1Txt'),
  (450894, NULL, NULL, 'Desc', 'TEXT', 'ReturnData/TransfersToControlledEntities/TransfersToControlledEntGrp/Desc'),
  (450895, NULL, NULL, 'EIN', 'TEXT', 'ReturnData/TransfersToControlledEntities/TransfersToControlledEntGrp/EIN'),
  (450896, NULL, NULL, 'Address Line1 Txt', 'TEXT', 'ReturnData/TransfersToControlledEntities/TransfersToControlledEntGrp/USAddress/AddressLine1Txt'),
  (450897, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/TransfersToControlledEntities/TransfersToControlledEntGrp/USAddress/CityNm'),
  (450898, NULL, NULL, 'State Abbreviation Cd', 'TEXT', 'ReturnData/TransfersToControlledEntities/TransfersToControlledEntGrp/USAddress/StateAbbreviationCd'),
  (450899, NULL, NULL, 'ZIP Cd', 'TEXT', 'ReturnData/TransfersToControlledEntities/TransfersToControlledEntGrp/USAddress/ZIPCd'),
  (450900, NULL, NULL, 'Address Line1 Txt', 'TEXT', 'ReturnData/TransfersToControlledEntities/TransfersToControlledEntGrp/ForeignAddress/AddressLine1Txt'),
  (450901, NULL, NULL, 'Country Cd', 'TEXT', 'ReturnData/TransfersToControlledEntities/TransfersToControlledEntGrp/ForeignAddress/CountryCd'),
  (450902, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/TransfersToControlledEntities/TransfersToControlledEntGrp/ForeignAddress/CityNm'),
  (450903, NULL, NULL, 'Foreign Postal Cd', 'TEXT', 'ReturnData/TransfersToControlledEntities/TransfersToControlledEntGrp/ForeignAddress/ForeignPostalCd'),
  (450904, NULL, NULL, 'Province Or State Nm', 'TEXT', 'ReturnData/TransfersToControlledEntities/TransfersToControlledEntGrp/ForeignAddress/ProvinceOrStateNm'),
  (450905, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/TransfersToControlledEntities/TransfersToControlledEntGrp/USAddress/AddressLine2Txt'),
  (450906, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/TransfersToControlledEntities/TransfersToControlledEntGrp/ForeignAddress/AddressLine2Txt');

-- 990PF / Officer Other Rcvbl Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (45067, 45, '068', 'Officer Other Rcvbl Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450907, 45067, '1', 'Borrower Person Nm', 'TEXT'),
  (450908, 45067, '2', 'Balance Due Amt', 'CURRENCY'),
  (450909, 45067, '3', 'Loan Original Amt', 'CURRENCY'),
  (450910, 45067, '4', 'Loan Purpose Txt', 'TEXT'),
  (450911, 45067, '5', 'Note Dt', 'TEXT'),
  (450912, 45067, '6', 'Consideration FMV Amt', 'CURRENCY'),
  (450913, 45067, '7', 'Repayment Terms Txt', 'TEXT'),
  (450914, 45067, '8', 'Borrower Title Txt', 'TEXT'),
  (450915, 45067, '9', 'Security Provided Borrower Txt', 'TEXT'),
  (450916, 45067, '10', 'Interest Rt', 'PERCENT'),
  (450917, 45067, '11', 'Lender Consideration Desc', 'TEXT'),
  (450918, 45067, '12', 'Loan Maturity Dt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450907, NULL, NULL, 'Borrower Person Nm', 'TEXT', 'ReturnData/OtherReceivablesOfficersSch/OfficerOtherRcvblGrp/BorrowerPersonNm'),
  (450908, NULL, NULL, 'Balance Due Amt', 'CURRENCY', 'ReturnData/OtherReceivablesOfficersSch/OfficerOtherRcvblGrp/BalanceDueAmt'),
  (450909, NULL, NULL, 'Loan Original Amt', 'CURRENCY', 'ReturnData/OtherReceivablesOfficersSch/OfficerOtherRcvblGrp/LoanOriginalAmt'),
  (450910, NULL, NULL, 'Loan Purpose Txt', 'TEXT', 'ReturnData/OtherReceivablesOfficersSch/OfficerOtherRcvblGrp/LoanPurposeTxt'),
  (450911, NULL, NULL, 'Note Dt', 'TEXT', 'ReturnData/OtherReceivablesOfficersSch/OfficerOtherRcvblGrp/NoteDt'),
  (450912, NULL, NULL, 'Consideration FMV Amt', 'CURRENCY', 'ReturnData/OtherReceivablesOfficersSch/OfficerOtherRcvblGrp/ConsiderationFMVAmt'),
  (450913, NULL, NULL, 'Repayment Terms Txt', 'TEXT', 'ReturnData/OtherReceivablesOfficersSch/OfficerOtherRcvblGrp/RepaymentTermsTxt'),
  (450914, NULL, NULL, 'Borrower Title Txt', 'TEXT', 'ReturnData/OtherReceivablesOfficersSch/OfficerOtherRcvblGrp/BorrowerTitleTxt'),
  (450915, NULL, NULL, 'Security Provided Borrower Txt', 'TEXT', 'ReturnData/OtherReceivablesOfficersSch/OfficerOtherRcvblGrp/SecurityProvidedBorrowerTxt'),
  (450916, NULL, NULL, 'Interest Rt', 'PERCENT', 'ReturnData/OtherReceivablesOfficersSch/OfficerOtherRcvblGrp/InterestRt'),
  (450917, NULL, NULL, 'Lender Consideration Desc', 'TEXT', 'ReturnData/OtherReceivablesOfficersSch/OfficerOtherRcvblGrp/LenderConsiderationDesc'),
  (450918, NULL, NULL, 'Loan Maturity Dt', 'TEXT', 'ReturnData/OtherReceivablesOfficersSch/OfficerOtherRcvblGrp/LoanMaturityDt');

-- 990PF / Other Notes Loans Rcvbl Short Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (45068, 45, '069', 'Other Notes Loans Rcvbl Short Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450919, 45068, '1', 'Business Name Line1 Txt', 'TEXT'),
  (450920, 45068, '2', 'Balance Due Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450919, NULL, NULL, 'Business Name Line1 Txt', 'TEXT', 'ReturnData/OtherNotesLoansRcvblShortSch2/OtherNotesLoansRcvblShortGrp/Organization501c3Name/BusinessNameLine1Txt'),
  (450920, NULL, NULL, 'Balance Due Amt', 'CURRENCY', 'ReturnData/OtherNotesLoansRcvblShortSch2/OtherNotesLoansRcvblShortGrp/BalanceDueAmt');

-- 990PF / Cash Deemed Charitable Expln Stmt Direct Fields
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (45069, 45, '070', 'Cash Deemed Charitable Expln Stmt Direct Fields');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450921, 45069, '1', 'Short Explanation Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450921, NULL, NULL, 'Short Explanation Txt', 'TEXT', 'ReturnData/CashDeemedCharitableExplnStmt/ShortExplanationTxt');

-- 990PF / Contractor Comp Expln Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (45070, 45, '071', 'Contractor Comp Expln Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450922, 45070, '1', 'Explanation Txt', 'TEXT'),
  (450923, 45070, '2', 'Contractor Person Nm', 'TEXT'),
  (450924, 45070, '3', 'Business Name Line1 Txt', 'TEXT'),
  (450925, 45070, '4', 'Business Name Line2 Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450922, NULL, NULL, 'Explanation Txt', 'TEXT', 'ReturnData/ContractorCompensationExpln/ContractorCompExplnGrp/ExplanationTxt'),
  (450923, NULL, NULL, 'Contractor Person Nm', 'TEXT', 'ReturnData/ContractorCompensationExpln/ContractorCompExplnGrp/ContractorPersonNm'),
  (450924, NULL, NULL, 'Business Name Line1 Txt', 'TEXT', 'ReturnData/ContractorCompensationExpln/ContractorCompExplnGrp/ContractorBusinessName/BusinessNameLine1Txt'),
  (450925, NULL, NULL, 'Business Name Line2 Txt', 'TEXT', 'ReturnData/ContractorCompensationExpln/ContractorCompExplnGrp/ContractorBusinessName/BusinessNameLine2Txt');

-- 990PF / Charitable Contributions Detail
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (45071, 45, '072', 'Charitable Contributions Detail');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450926, 45071, '1', 'Contributor Num', 'INTEGER'),
  (450927, 45071, '2', 'Gift Purpose Txt', 'TEXT'),
  (450928, 45071, '3', 'Gift Use Txt', 'TEXT'),
  (450929, 45071, '4', 'How Gift Is Held Desc', 'TEXT'),
  (450930, 45071, '5', 'Address Line1 Txt', 'TEXT'),
  (450931, 45071, '6', 'City Nm', 'TEXT'),
  (450932, 45071, '7', 'State Abbreviation Cd', 'TEXT'),
  (450933, 45071, '8', 'ZIP Cd', 'TEXT'),
  (450934, 45071, '9', 'Rln Of Transferor To Transferee Txt', 'TEXT'),
  (450935, 45071, '10', 'Transferee Name Individual', 'TEXT'),
  (450936, 45071, '11', 'Business Name Line1 Txt', 'TEXT'),
  (450937, 45071, '12', 'Address Line1 Txt', 'TEXT'),
  (450938, 45071, '13', 'City Nm', 'TEXT'),
  (450939, 45071, '14', 'Country Cd', 'TEXT'),
  (450940, 45071, '15', 'Province Or State Nm', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450926, NULL, NULL, 'Contributor Num', 'INTEGER', 'ReturnData/IRS990ScheduleB/CharitableContributionsDetail/ContributorNum'),
  (450927, NULL, NULL, 'Gift Purpose Txt', 'TEXT', 'ReturnData/IRS990ScheduleB/CharitableContributionsDetail/GiftPurposeTxt'),
  (450928, NULL, NULL, 'Gift Use Txt', 'TEXT', 'ReturnData/IRS990ScheduleB/CharitableContributionsDetail/GiftUseTxt'),
  (450929, NULL, NULL, 'How Gift Is Held Desc', 'TEXT', 'ReturnData/IRS990ScheduleB/CharitableContributionsDetail/HowGiftIsHeldDesc'),
  (450930, NULL, NULL, 'Address Line1 Txt', 'TEXT', 'ReturnData/IRS990ScheduleB/CharitableContributionsDetail/TransfereeUSAddress/AddressLine1Txt'),
  (450931, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990ScheduleB/CharitableContributionsDetail/TransfereeUSAddress/CityNm'),
  (450932, NULL, NULL, 'State Abbreviation Cd', 'TEXT', 'ReturnData/IRS990ScheduleB/CharitableContributionsDetail/TransfereeUSAddress/StateAbbreviationCd'),
  (450933, NULL, NULL, 'ZIP Cd', 'TEXT', 'ReturnData/IRS990ScheduleB/CharitableContributionsDetail/TransfereeUSAddress/ZIPCd'),
  (450934, NULL, NULL, 'Rln Of Transferor To Transferee Txt', 'TEXT', 'ReturnData/IRS990ScheduleB/CharitableContributionsDetail/RlnOfTransferorToTransfereeTxt'),
  (450935, NULL, NULL, 'Transferee Name Individual', 'TEXT', 'ReturnData/IRS990ScheduleB/CharitableContributionsDetail/TransfereeNameIndividual'),
  (450936, NULL, NULL, 'Business Name Line1 Txt', 'TEXT', 'ReturnData/IRS990ScheduleB/CharitableContributionsDetail/TransfereeNameBusiness/BusinessNameLine1Txt'),
  (450937, NULL, NULL, 'Address Line1 Txt', 'TEXT', 'ReturnData/IRS990ScheduleB/CharitableContributionsDetail/TransfereeForeignAddress/AddressLine1Txt'),
  (450938, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990ScheduleB/CharitableContributionsDetail/TransfereeForeignAddress/CityNm'),
  (450939, NULL, NULL, 'Country Cd', 'TEXT', 'ReturnData/IRS990ScheduleB/CharitableContributionsDetail/TransfereeForeignAddress/CountryCd'),
  (450940, NULL, NULL, 'Province Or State Nm', 'TEXT', 'ReturnData/IRS990ScheduleB/CharitableContributionsDetail/TransfereeForeignAddress/ProvinceOrStateNm');

-- 990PF / Election Desc
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (45072, 45, '073', 'Election Desc');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450941, 45072, '1', 'Election Desc', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450941, NULL, NULL, 'Election Desc', 'TEXT', 'ReturnData/DistributionFromCorpusElection/ElectionDesc');

-- 990PF / Cash Distribution Expln Stmt Direct Fields
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (45073, 45, '074', 'Cash Distribution Expln Stmt Direct Fields');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450942, 45073, '1', 'Explanation Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450942, NULL, NULL, 'Explanation Txt', 'TEXT', 'ReturnData/CashDistributionExplnStmt/ExplanationTxt');

-- 990PF / Private Operating Foundations Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (45074, 45, '075', 'Private Operating Foundations Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450943, 45074, '1', 'Section4942j5 Ind', 'BOOLEAN');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450943, NULL, NULL, 'Section4942j5 Ind', 'BOOLEAN', 'ReturnData/IRS990PF/PrivateOperatingFoundationsGrp/Section4942j5Ind');

-- 990PF / Mortgages And Notes Payable Sch Direct Fields
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (45075, 45, '076', 'Mortgages And Notes Payable Sch Direct Fields');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450944, 45075, '1', 'Mortgage Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450944, NULL, NULL, 'Mortgage Amt', 'CURRENCY', 'ReturnData/MortgagesAndNotesPayableSch/MortgageAmt');

-- 990PF / Dissolution Information Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (45076, 45, '077', 'Dissolution Information Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450945, 45076, '1', 'Person Nm', 'TEXT'),
  (450946, 45076, '2', 'Business Name Line2 Txt', 'TEXT'),
  (450947, 45076, '3', 'Address Line2 Txt', 'TEXT'),
  (450948, 45076, '4', 'Address Line1 Txt', 'TEXT'),
  (450949, 45076, '5', 'Country Cd', 'TEXT'),
  (450950, 45076, '6', 'City Nm', 'TEXT'),
  (450951, 45076, '7', 'Province Or State Nm', 'TEXT'),
  (450952, 45076, '8', 'Foreign Postal Cd', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450945, NULL, NULL, 'Person Nm', 'TEXT', 'ReturnData/DissolutionStmt/DissolutionInformationGrp/PersonNm'),
  (450946, NULL, NULL, 'Business Name Line2 Txt', 'TEXT', 'ReturnData/DissolutionStmt/DissolutionInformationGrp/BusinessName/BusinessNameLine2Txt'),
  (450947, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/DissolutionStmt/DissolutionInformationGrp/USAddress/AddressLine2Txt'),
  (450948, NULL, NULL, 'Address Line1 Txt', 'TEXT', 'ReturnData/DissolutionStmt/DissolutionInformationGrp/ForeignAddress/AddressLine1Txt'),
  (450949, NULL, NULL, 'Country Cd', 'TEXT', 'ReturnData/DissolutionStmt/DissolutionInformationGrp/ForeignAddress/CountryCd'),
  (450950, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/DissolutionStmt/DissolutionInformationGrp/ForeignAddress/CityNm'),
  (450951, NULL, NULL, 'Province Or State Nm', 'TEXT', 'ReturnData/DissolutionStmt/DissolutionInformationGrp/ForeignAddress/ProvinceOrStateNm'),
  (450952, NULL, NULL, 'Foreign Postal Cd', 'TEXT', 'ReturnData/DissolutionStmt/DissolutionInformationGrp/ForeignAddress/ForeignPostalCd');

-- 990PF / IRS990 Schedule B Direct Fields
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (45077, 45, '078', 'IRS990 Schedule B Direct Fields');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450953, 45077, '1', 'Organization4947a1 Trtd PF Ind', 'BOOLEAN'),
  (450954, 45077, '2', 'Organization501c Ind', 'BOOLEAN'),
  (450955, 45077, '3', 'Organization501c3 Taxable PF Ind', 'BOOLEAN'),
  (450956, 45077, '4', 'Total Under1000 Contributions Amt', 'CURRENCY'),
  (450957, 45077, '5', 'Spcl Rule Met One3rd Suprt Test Ind', 'BOOLEAN');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450953, NULL, NULL, 'Organization4947a1 Trtd PF Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleB/Organization4947a1TrtdPFInd'),
  (450954, NULL, NULL, 'Organization501c Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleB/Organization501cInd'),
  (450955, NULL, NULL, 'Organization501c3 Taxable PF Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleB/Organization501c3TaxablePFInd'),
  (450956, NULL, NULL, 'Total Under1000 Contributions Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleB/TotalUnder1000ContributionsAmt'),
  (450957, NULL, NULL, 'Spcl Rule Met One3rd Suprt Test Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleB/SpclRuleMetOne3rdSuprtTestInd');

-- 990PF / Transfers To Controlled Entities Direct Fields
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (45078, 45, '079', 'Transfers To Controlled Entities Direct Fields');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450958, 45078, '1', 'Total Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450958, NULL, NULL, 'Total Amt', 'CURRENCY', 'ReturnData/TransfersToControlledEntities/TotalAmt');

-- 990PF / Reduction Explanation Statement Direct Fields
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (45079, 45, '080', 'Reduction Explanation Statement Direct Fields');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450959, 45079, '1', 'Short Explanation Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450959, NULL, NULL, 'Short Explanation Txt', 'TEXT', 'ReturnData/ReductionExplanationStatement/ShortExplanationTxt');

-- 990PF / Special Condition Desc
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (45080, 45, '081', 'Special Condition Desc');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450960, 45080, '1', 'Special Condition Desc', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450960, NULL, NULL, 'Special Condition Desc', 'TEXT', 'ReturnData/IRS990PF/SpecialConditionDesc');

-- 990PF / Transfers Frm Controlled Entities Direct Fields
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (45081, 45, '082', 'Transfers Frm Controlled Entities Direct Fields');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450961, 45081, '1', 'Total Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450961, NULL, NULL, 'Total Amt', 'CURRENCY', 'ReturnData/TransfersFrmControlledEntities/TotalAmt');

-- 990PF / Compensation Explanation Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (45082, 45, '083', 'Compensation Explanation Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450962, 45082, '1', 'Business Name Line2 Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450962, NULL, NULL, 'Business Name Line2 Txt', 'TEXT', 'ReturnData/CompensationExplanation/CompensationExplanationGrp/BusinessName/BusinessNameLine2Txt');

-- 990PF / Acty Not Previously Rpt Expln Direct Fields
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (45083, 45, '084', 'Acty Not Previously Rpt Expln Direct Fields');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450963, 45083, '1', 'Explanation Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450963, NULL, NULL, 'Explanation Txt', 'TEXT', 'ReturnData/ActyNotPreviouslyRptExpln/ExplanationTxt');

-- 990PF / Explan Of Legis Political Actvts Direct Fields
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (45084, 45, '085', 'Explan Of Legis Political Actvts Direct Fields');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450964, 45084, '1', 'Medium Explanation Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450964, NULL, NULL, 'Medium Explanation Txt', 'TEXT', 'ReturnData/ExplanOfLegisPoliticalActvts/MediumExplanationTxt');

-- 990PF / Borrowed Funds Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (45085, 45, '086', 'Borrowed Funds Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450965, 45085, '1', 'Address Line1 Txt', 'TEXT'),
  (450966, 45085, '2', 'City Nm', 'TEXT'),
  (450967, 45085, '3', 'State Abbreviation Cd', 'TEXT'),
  (450968, 45085, '4', 'ZIP Cd', 'TEXT'),
  (450969, 45085, '5', 'Borrowed Amt', 'CURRENCY'),
  (450970, 45085, '6', 'Person Nm', 'TEXT'),
  (450971, 45085, '7', 'Business Name Line1 Txt', 'TEXT'),
  (450972, 45085, '8', 'Use Of Borrowed Funds Txt', 'TEXT'),
  (450973, 45085, '9', 'Election Statement Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450965, NULL, NULL, 'Address Line1 Txt', 'TEXT', 'ReturnData/BorrowedFundsElection/BorrowedFundsGrp/USAddress/AddressLine1Txt'),
  (450966, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/BorrowedFundsElection/BorrowedFundsGrp/USAddress/CityNm'),
  (450967, NULL, NULL, 'State Abbreviation Cd', 'TEXT', 'ReturnData/BorrowedFundsElection/BorrowedFundsGrp/USAddress/StateAbbreviationCd'),
  (450968, NULL, NULL, 'ZIP Cd', 'TEXT', 'ReturnData/BorrowedFundsElection/BorrowedFundsGrp/USAddress/ZIPCd'),
  (450969, NULL, NULL, 'Borrowed Amt', 'CURRENCY', 'ReturnData/BorrowedFundsElection/BorrowedFundsGrp/BorrowedAmt'),
  (450970, NULL, NULL, 'Person Nm', 'TEXT', 'ReturnData/BorrowedFundsElection/BorrowedFundsGrp/PersonNm'),
  (450971, NULL, NULL, 'Business Name Line1 Txt', 'TEXT', 'ReturnData/BorrowedFundsElection/BorrowedFundsGrp/BusinessName/BusinessNameLine1Txt'),
  (450972, NULL, NULL, 'Use Of Borrowed Funds Txt', 'TEXT', 'ReturnData/BorrowedFundsElection/BorrowedFundsGrp/UseOfBorrowedFundsTxt'),
  (450973, NULL, NULL, 'Election Statement Txt', 'TEXT', 'ReturnData/BorrowedFundsElection/BorrowedFundsGrp/ElectionStatementTxt');

-- 990PF / Tax Under Section511 Statement Direct Fields
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (45086, 45, '087', 'Tax Under Section511 Statement Direct Fields');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450974, 45086, '1', 'Explanation Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450974, NULL, NULL, 'Explanation Txt', 'TEXT', 'ReturnData/TaxUnderSection511Statement/ExplanationTxt');

-- 990PF / Other Receivables Officers Sch Direct Fields
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (45087, 45, '088', 'Other Receivables Officers Sch Direct Fields');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (450975, 45087, '1', 'Officer Travel Advance Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (450975, NULL, NULL, 'Officer Travel Advance Amt', 'CURRENCY', 'ReturnData/OtherReceivablesOfficersSch/OfficerTravelAdvanceAmt');

