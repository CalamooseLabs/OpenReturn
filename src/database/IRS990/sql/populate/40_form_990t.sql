-- Form 990-T — extended field mappings (part 54 EXT).

-- ========================================================================
-- FORM 990T — 204 new field mappings
-- ========================================================================

INSERT OR IGNORE INTO
  part (part_id, form_code, part_number, part_name)
VALUES
  (54, '990T', 'EXT', 'Extended Fields');

INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54000, 54, '001', 'Direct Form Fields'),
  (54001, 54, '002', 'Advertising Incm Periodical Group'),
  (54002, 54, '003', 'Books In Care Of Detail'),
  (54003, 54, '004', 'Estate Or Trust Cap Gain Or Loss Group'),
  (54004, 54, '005', 'Itmzd Supplemental Info Group'),
  (54005, 54, '006', 'Long Term Capital Gain And Loss Group'),
  (54006, 54, '007', 'Officer Dir Trst Comp Group'),
  (54007, 54, '008', 'Organization501Indicator Group'),
  (54008, 54, '009', 'Overpayment Section'),
  (54009, 54, '010', 'Post2017NOL Carryover Group'),
  (54010, 54, '011', 'Rent Income Property Group'),
  (54011, 54, '012', 'Short Term Capital Gain And Loss Group'),
  (54012, 54, '013', 'Total Capital Gain Or Loss Group'),
  (54013, 54, '014', 'Total LTCGL1099B Not Received Group'),
  (54014, 54, '015', 'Total STCGL1099B Not Received Group'),
  (54015, 54, '016', 'Unrelated Debt Financed Prop Group');

-- 990T / Direct Form Fields
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (540001, 54000, '1', 'Capital Loss Limitation Amt', 'CURRENCY'),
  (540002, 54000, '2', 'Diff Of Smaller Amt', 'CURRENCY'),
  (540003, 54000, '3', 'Diff Of Smllr Plus Smllr Of Calc Amt', 'CURRENCY'),
  (540004, 54000, '4', 'Dispose Investment QOF Ind', 'BOOLEAN'),
  (540005, 54000, '5', 'Gain Less Included Amt', 'CURRENCY'),
  (540006, 54000, '6', 'Gain Plus Dividends Amt', 'CURRENCY'),
  (540007, 54000, '7', 'Investment Income Election Amt', 'CURRENCY'),
  (540008, 54000, '8', 'Net Gains Tax Amt', 'CURRENCY'),
  (540009, 54000, '9', 'Net Income Minus Smaller Amt', 'CURRENCY'),
  (540010, 54000, '10', 'Net LT Capital Gain Or Loss Amt', 'CURRENCY'),
  (540011, 54000, '11', 'Net LT Gain Or Loss From Sch K1Amt', 'CURRENCY'),
  (540012, 54000, '12', 'Net Smaller Amt', 'CURRENCY'),
  (540013, 54000, '13', 'Net Times Percent Amt', 'CURRENCY'),
  (540014, 54000, '14', 'Qlfy Dividends Estate Trust Amt', 'CURRENCY'),
  (540015, 54000, '15', 'Smaller Gain Amt', 'CURRENCY'),
  (540016, 54000, '16', 'Smaller Of Calc Amt', 'CURRENCY'),
  (540017, 54000, '17', 'Smaller Taxable Incm Or Allowed Amt', 'CURRENCY'),
  (540018, 54000, '18', 'Smaller Taxable Income Or Net Amt', 'CURRENCY'),
  (540019, 54000, '19', 'Smaller Times Percent Amt', 'CURRENCY'),
  (540020, 54000, '20', 'Smllr Txbl Incm Or Oth Allowed Amt', 'CURRENCY'),
  (540021, 54000, '21', 'Smllr Txi Less Gain Or Txi Or Allw Amt', 'CURRENCY'),
  (540022, 54000, '22', 'Smllr Txi Or Allw Less Smllr Amt', 'CURRENCY'),
  (540023, 54000, '23', 'Tax Amt', 'CURRENCY'),
  (540024, 54000, '24', 'Tax On Taxable Income Amt', 'CURRENCY'),
  (540025, 54000, '25', 'Tax Plus Time Percent Amt', 'CURRENCY'),
  (540026, 54000, '26', 'Taxable Income Amt', 'CURRENCY'),
  (540027, 54000, '27', 'Taxable Income Less Gain Amt', 'CURRENCY'),
  (540028, 54000, '28', 'Txi Less Gain Plus Diff Of Smll Amt', 'CURRENCY'),
  (540029, 54000, '29', 'Capital Gain Net Income Amt', 'CURRENCY'),
  (540030, 54000, '30', 'Exc Net ST Gain Over Net LT Loss Amt', 'CURRENCY'),
  (540031, 54000, '31', 'Form4797Gain Or Loss Amt', 'CURRENCY'),
  (540032, 54000, '32', 'Net Capital Gain Amt', 'CURRENCY'),
  (540033, 54000, '33', 'Net LT Capital Gain Or Loss Amt', 'CURRENCY'),
  (540034, 54000, '34', 'Net ST Capital Gain Or Loss Amt', 'CURRENCY'),
  (540035, 54000, '35', 'Business Or Activity Txt', 'TEXT'),
  (540036, 54000, '36', 'Maximum Dollar Limitation Amt', 'CURRENCY'),
  (540037, 54000, '37', 'Other Depreciation Amt', 'CURRENCY'),
  (540038, 54000, '38', 'Threshold Cost Of Sect179Prop Amt', 'CURRENCY'),
  (540039, 54000, '39', 'Total Depreciation Amt', 'CURRENCY'),
  (540040, 54000, '40', 'Amended Return Ind', 'BOOLEAN'),
  (540041, 54000, '41', 'Avlbl Pre2018NOL Carryover Amt', 'CURRENCY'),
  (540042, 54000, '42', 'Backup Withholding Amt', 'CURRENCY'),
  (540043, 54000, '43', 'Balance Due Amt', 'CURRENCY'),
  (540044, 54000, '44', 'Book Value Assets EOY Amt', 'CURRENCY'),
  (540045, 54000, '45', 'CY Gen Business Credit Allowed Amt', 'CURRENCY'),
  (540046, 54000, '46', 'Change In Method Of Accounting Ind', 'BOOLEAN'),
  (540047, 54000, '47', 'Charitable Contributions Ded Amt', 'CURRENCY'),
  (540048, 54000, '48', 'ES Penalty Amt', 'CURRENCY'),
  (540049, 54000, '49', 'Estimated Tax Payments Amt', 'CURRENCY'),
  (540050, 54000, '50', 'Extsn Request Income Tax Paid Amt', 'CURRENCY'),
  (540051, 54000, '51', 'Foreign Accounts Question Ind', 'BOOLEAN'),
  (540052, 54000, '52', 'Foreign Trust Question Ind', 'BOOLEAN'),
  (540053, 54000, '53', 'Form1041Schedule D Ind', 'BOOLEAN'),
  (540054, 54000, '54', 'Form2220Attached Ind', 'BOOLEAN'),
  (540055, 54000, '55', 'Form990T Schedule A Attached Cnt', 'INTEGER'),
  (540056, 54000, '56', 'Noncompliant Facility Incm Tax Amt', 'CURRENCY'),
  (540057, 54000, '57', 'Org State College University Ind', 'BOOLEAN'),
  (540058, 54000, '58', 'Organization501c Corporation Ind', 'BOOLEAN'),
  (540059, 54000, '59', 'Organization501c Trust Ind', 'BOOLEAN'),
  (540060, 54000, '60', 'Other Tax Amt', 'CURRENCY'),
  (540061, 54000, '61', 'Other Taxes Amt', 'CURRENCY'),
  (540062, 54000, '62', 'Paid Tax Liability Amt', 'CURRENCY'),
  (540063, 54000, '63', 'Prior Year Overpayment Credit Amt', 'CURRENCY'),
  (540064, 54000, '64', 'Section199A Deduction Amt', 'CURRENCY'),
  (540065, 54000, '65', 'Specific Deduction Amt', 'CURRENCY'),
  (540066, 54000, '66', 'Subsidiary Corporation Ind', 'BOOLEAN'),
  (540067, 54000, '67', 'Tax Exempt Interest Amt', 'CURRENCY'),
  (540068, 54000, '68', 'Tax Less Credits Amt', 'CURRENCY'),
  (540069, 54000, '69', 'Tax Rate Schedule Ind', 'BOOLEAN'),
  (540070, 54000, '70', 'Taxable Corporation Amt', 'CURRENCY'),
  (540071, 54000, '71', 'Taxable Trust Amt', 'CURRENCY'),
  (540072, 54000, '72', 'Total Credits Amt', 'CURRENCY'),
  (540073, 54000, '73', 'Total Deduction Amt', 'CURRENCY'),
  (540074, 54000, '74', 'Total Payments Amt', 'CURRENCY'),
  (540075, 54000, '75', 'Total Tax Computation Amt', 'CURRENCY'),
  (540076, 54000, '76', 'Total UBTI Amt', 'CURRENCY'),
  (540077, 54000, '77', 'Total UBTI Before NOL Specific Amt', 'CURRENCY'),
  (540078, 54000, '78', 'Total UBTI Before Section199A Amt', 'CURRENCY'),
  (540079, 54000, '79', 'Total UBTI Computed Amt', 'CURRENCY'),
  (540080, 54000, '80', 'Additional Section263A Costs Amt', 'CURRENCY'),
  (540081, 54000, '81', 'Bad Debt Expense Amt', 'CURRENCY'),
  (540082, 54000, '82', 'Beginning Of Year Inventory Amt', 'CURRENCY'),
  (540083, 54000, '83', 'Capital Gain Net Income Amt', 'CURRENCY'),
  (540084, 54000, '84', 'Cost Of Goods Sold Amt', 'CURRENCY'),
  (540085, 54000, '85', 'Cost Of Labor Amt', 'CURRENCY'),
  (540086, 54000, '86', 'Depletion Amt', 'CURRENCY'),
  (540087, 54000, '87', 'Depreciation Clm Elsewhere Amt', 'CURRENCY'),
  (540088, 54000, '88', 'Depreciation Net Amt', 'CURRENCY'),
  (540089, 54000, '89', 'End Of Year Inventory Amt', 'CURRENCY'),
  (540090, 54000, '90', 'Exploited Activity Desc', 'TEXT'),
  (540091, 54000, '91', 'Exploited Activity Net Income Amt', 'CURRENCY'),
  (540092, 54000, '92', 'Exploited Excess Exempt Expnss Amt', 'CURRENCY'),
  (540093, 54000, '93', 'Exploited Exempt Activity Incm Amt', 'CURRENCY'),
  (540094, 54000, '94', 'Exploited Expnss Cnnct UBI Amt', 'CURRENCY'),
  (540095, 54000, '95', 'Gross Income Acty Not UBI Amt', 'CURRENCY'),
  (540096, 54000, '96', 'Gross Income Acty Not UBI Expns Amt', 'CURRENCY'),
  (540097, 54000, '97', 'Gross Profit Amt', 'CURRENCY'),
  (540098, 54000, '98', 'Gross Receipts Or Sales Amt', 'CURRENCY'),
  (540099, 54000, '99', 'Interest Deduction Amt', 'CURRENCY'),
  (540100, 54000, '100', 'Inventory Valuation Method Cd', 'TEXT'),
  (540101, 54000, '101', 'Net Advertising Income Amt', 'CURRENCY'),
  (540102, 54000, '102', 'Net Exploited Activity Income Amt', 'CURRENCY'),
  (540103, 54000, '103', 'Net Gross Receipts Or Sales Amt', 'CURRENCY'),
  (540104, 54000, '104', 'Net Investment Income Amt', 'CURRENCY'),
  (540105, 54000, '105', 'Net Operating Loss Deduction Amt', 'CURRENCY'),
  (540106, 54000, '106', 'Net Rent Income Amt', 'CURRENCY'),
  (540107, 54000, '107', 'Net Unrelated Debt Fincd Incm Amt', 'CURRENCY'),
  (540108, 54000, '108', 'Other Costs Amt', 'CURRENCY'),
  (540109, 54000, '109', 'Other Deductions Amt', 'CURRENCY'),
  (540110, 54000, '110', 'Other Income Amt', 'CURRENCY'),
  (540111, 54000, '111', 'Principal Business Activity Cd', 'TEXT'),
  (540112, 54000, '112', 'Purchases Amt', 'CURRENCY'),
  (540113, 54000, '113', 'Repairs And Maintenance Amt', 'CURRENCY'),
  (540114, 54000, '114', 'Salaries And Wages Amt', 'CURRENCY'),
  (540115, 54000, '115', 'Section263A Rules Apply Ind', 'BOOLEAN'),
  (540116, 54000, '116', 'Sequence Reference Num', 'INTEGER'),
  (540117, 54000, '117', 'Sequence Total Num', 'INTEGER'),
  (540118, 54000, '118', 'Taxes And Licenses Amt', 'CURRENCY'),
  (540119, 54000, '119', 'Tot Excess Readership Costs Ded Amt', 'CURRENCY'),
  (540120, 54000, '120', 'Tot Net Unrlt Trd Bus Incm Amt', 'CURRENCY'),
  (540121, 54000, '121', 'Tot Unrlt Trd Bus Incm Amt', 'CURRENCY'),
  (540122, 54000, '122', 'Tot Unrlt Trd Bus Incm Expnss Amt', 'CURRENCY'),
  (540123, 54000, '123', 'Total Allocable Deductions Amt', 'CURRENCY'),
  (540124, 54000, '124', 'Total Cost Goods Sold Amt', 'CURRENCY'),
  (540125, 54000, '125', 'Total Ctrl Org Deduction Amt', 'CURRENCY'),
  (540126, 54000, '126', 'Total Ctrl Org Pymt Gross Incm Amt', 'CURRENCY'),
  (540127, 54000, '127', 'Total Deduction Set Asides Amt', 'CURRENCY'),
  (540128, 54000, '128', 'Total Deductions Amt', 'CURRENCY'),
  (540129, 54000, '129', 'Total Depreciation Amt', 'CURRENCY'),
  (540130, 54000, '130', 'Total Direct Advertising Cost Amt', 'CURRENCY'),
  (540131, 54000, '131', 'Total Dividends Received Ded Amt', 'CURRENCY'),
  (540132, 54000, '132', 'Total Gross Advertising Income Amt', 'CURRENCY'),
  (540133, 54000, '133', 'Total Gross Debt Financed Incm Amt', 'CURRENCY'),
  (540134, 54000, '134', 'Total Investment Income Amt', 'CURRENCY'),
  (540135, 54000, '135', 'Total Ordinary Gain Loss Amt', 'CURRENCY'),
  (540136, 54000, '136', 'Total Prtshp S Corp Income Amt', 'CURRENCY'),
  (540137, 54000, '137', 'Total Rent Deductions Amt', 'CURRENCY'),
  (540138, 54000, '138', 'Total Rent Income Amt', 'CURRENCY'),
  (540139, 54000, '139', 'Total Unrelated Business Comp Amt', 'CURRENCY'),
  (540140, 54000, '140', 'Trade Or Business Desc', 'TEXT'),
  (540141, 54000, '141', 'UBI Before NOL Ded Amt', 'CURRENCY'),
  (540142, 54000, '142', 'Unrelated Business Taxbl Incm Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (540001, NULL, NULL, 'Capital Loss Limitation Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/CapitalLossLimitationAmt'),
  (540002, NULL, NULL, 'Diff Of Smaller Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/DiffOfSmallerAmt'),
  (540003, NULL, NULL, 'Diff Of Smllr Plus Smllr Of Calc Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/DiffOfSmllrPlusSmllrOfCalcAmt'),
  (540004, NULL, NULL, 'Dispose Investment QOF Ind', 'BOOLEAN', 'ReturnData/IRS1041ScheduleD/DisposeInvestmentQOFInd'),
  (540005, NULL, NULL, 'Gain Less Included Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/GainLessIncludedAmt'),
  (540006, NULL, NULL, 'Gain Plus Dividends Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/GainPlusDividendsAmt'),
  (540007, NULL, NULL, 'Investment Income Election Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/InvestmentIncomeElectionAmt'),
  (540008, NULL, NULL, 'Net Gains Tax Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/NetGainsTaxAmt'),
  (540009, NULL, NULL, 'Net Income Minus Smaller Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/NetIncomeMinusSmallerAmt'),
  (540010, NULL, NULL, 'Net LT Capital Gain Or Loss Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/NetLTCapitalGainOrLossAmt'),
  (540011, NULL, NULL, 'Net LT Gain Or Loss From Sch K1Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/NetLTGainOrLossFromSchK1Amt'),
  (540012, NULL, NULL, 'Net Smaller Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/NetSmallerAmt'),
  (540013, NULL, NULL, 'Net Times Percent Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/NetTimesPercentAmt'),
  (540014, NULL, NULL, 'Qlfy Dividends Estate Trust Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/QlfyDividendsEstateTrustAmt'),
  (540015, NULL, NULL, 'Smaller Gain Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/SmallerGainAmt'),
  (540016, NULL, NULL, 'Smaller Of Calc Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/SmallerOfCalcAmt'),
  (540017, NULL, NULL, 'Smaller Taxable Incm Or Allowed Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/SmallerTaxableIncmOrAllowedAmt'),
  (540018, NULL, NULL, 'Smaller Taxable Income Or Net Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/SmallerTaxableIncomeOrNetAmt'),
  (540019, NULL, NULL, 'Smaller Times Percent Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/SmallerTimesPercentAmt'),
  (540020, NULL, NULL, 'Smllr Txbl Incm Or Oth Allowed Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/SmllrTxblIncmOrOthAllowedAmt'),
  (540021, NULL, NULL, 'Smllr Txi Less Gain Or Txi Or Allw Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/SmllrTxiLessGainOrTxiOrAllwAmt'),
  (540022, NULL, NULL, 'Smllr Txi Or Allw Less Smllr Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/SmllrTxiOrAllwLessSmllrAmt'),
  (540023, NULL, NULL, 'Tax Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/TaxAmt'),
  (540024, NULL, NULL, 'Tax On Taxable Income Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/TaxOnTaxableIncomeAmt'),
  (540025, NULL, NULL, 'Tax Plus Time Percent Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/TaxPlusTimePercentAmt'),
  (540026, NULL, NULL, 'Taxable Income Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/TaxableIncomeAmt'),
  (540027, NULL, NULL, 'Taxable Income Less Gain Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/TaxableIncomeLessGainAmt'),
  (540028, NULL, NULL, 'Txi Less Gain Plus Diff Of Smll Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/TxiLessGainPlusDiffOfSmllAmt'),
  (540029, NULL, NULL, 'Capital Gain Net Income Amt', 'CURRENCY', 'ReturnData/IRS1120ScheduleD/CapitalGainNetIncomeAmt'),
  (540030, NULL, NULL, 'Exc Net ST Gain Over Net LT Loss Amt', 'CURRENCY', 'ReturnData/IRS1120ScheduleD/ExcNetSTGainOverNetLTLossAmt'),
  (540031, NULL, NULL, 'Form4797Gain Or Loss Amt', 'CURRENCY', 'ReturnData/IRS1120ScheduleD/Form4797GainOrLossAmt'),
  (540032, NULL, NULL, 'Net Capital Gain Amt', 'CURRENCY', 'ReturnData/IRS1120ScheduleD/NetCapitalGainAmt'),
  (540033, NULL, NULL, 'Net LT Capital Gain Or Loss Amt', 'CURRENCY', 'ReturnData/IRS1120ScheduleD/NetLTCapitalGainOrLossAmt'),
  (540034, NULL, NULL, 'Net ST Capital Gain Or Loss Amt', 'CURRENCY', 'ReturnData/IRS1120ScheduleD/NetSTCapitalGainOrLossAmt'),
  (540035, NULL, NULL, 'Business Or Activity Txt', 'TEXT', 'ReturnData/IRS4562/BusinessOrActivityTxt'),
  (540036, NULL, NULL, 'Maximum Dollar Limitation Amt', 'CURRENCY', 'ReturnData/IRS4562/MaximumDollarLimitationAmt'),
  (540037, NULL, NULL, 'Other Depreciation Amt', 'CURRENCY', 'ReturnData/IRS4562/OtherDepreciationAmt'),
  (540038, NULL, NULL, 'Threshold Cost Of Sect179Prop Amt', 'CURRENCY', 'ReturnData/IRS4562/ThresholdCostOfSect179PropAmt'),
  (540039, NULL, NULL, 'Total Depreciation Amt', 'CURRENCY', 'ReturnData/IRS4562/TotalDepreciationAmt'),
  (540040, NULL, NULL, 'Amended Return Ind', 'BOOLEAN', 'ReturnData/IRS990T/AmendedReturnInd'),
  (540041, NULL, NULL, 'Avlbl Pre2018NOL Carryover Amt', 'CURRENCY', 'ReturnData/IRS990T/AvlblPre2018NOLCarryoverAmt'),
  (540042, NULL, NULL, 'Backup Withholding Amt', 'CURRENCY', 'ReturnData/IRS990T/BackupWithholdingAmt'),
  (540043, NULL, NULL, 'Balance Due Amt', 'CURRENCY', 'ReturnData/IRS990T/BalanceDueAmt'),
  (540044, NULL, NULL, 'Book Value Assets EOY Amt', 'CURRENCY', 'ReturnData/IRS990T/BookValueAssetsEOYAmt'),
  (540045, NULL, NULL, 'CY Gen Business Credit Allowed Amt', 'CURRENCY', 'ReturnData/IRS990T/CYGenBusinessCreditAllowedAmt'),
  (540046, NULL, NULL, 'Change In Method Of Accounting Ind', 'BOOLEAN', 'ReturnData/IRS990T/ChangeInMethodOfAccountingInd'),
  (540047, NULL, NULL, 'Charitable Contributions Ded Amt', 'CURRENCY', 'ReturnData/IRS990T/CharitableContributionsDedAmt'),
  (540048, NULL, NULL, 'ES Penalty Amt', 'CURRENCY', 'ReturnData/IRS990T/ESPenaltyAmt'),
  (540049, NULL, NULL, 'Estimated Tax Payments Amt', 'CURRENCY', 'ReturnData/IRS990T/EstimatedTaxPaymentsAmt'),
  (540050, NULL, NULL, 'Extsn Request Income Tax Paid Amt', 'CURRENCY', 'ReturnData/IRS990T/ExtsnRequestIncomeTaxPaidAmt'),
  (540051, NULL, NULL, 'Foreign Accounts Question Ind', 'BOOLEAN', 'ReturnData/IRS990T/ForeignAccountsQuestionInd'),
  (540052, NULL, NULL, 'Foreign Trust Question Ind', 'BOOLEAN', 'ReturnData/IRS990T/ForeignTrustQuestionInd'),
  (540053, NULL, NULL, 'Form1041Schedule D Ind', 'BOOLEAN', 'ReturnData/IRS990T/Form1041ScheduleDInd'),
  (540054, NULL, NULL, 'Form2220Attached Ind', 'BOOLEAN', 'ReturnData/IRS990T/Form2220AttachedInd'),
  (540055, NULL, NULL, 'Form990T Schedule A Attached Cnt', 'INTEGER', 'ReturnData/IRS990T/Form990TScheduleAAttachedCnt'),
  (540056, NULL, NULL, 'Noncompliant Facility Incm Tax Amt', 'CURRENCY', 'ReturnData/IRS990T/NoncompliantFacilityIncmTaxAmt'),
  (540057, NULL, NULL, 'Org State College University Ind', 'BOOLEAN', 'ReturnData/IRS990T/OrgStateCollegeUniversityInd'),
  (540058, NULL, NULL, 'Organization501c Corporation Ind', 'BOOLEAN', 'ReturnData/IRS990T/Organization501cCorporationInd'),
  (540059, NULL, NULL, 'Organization501c Trust Ind', 'BOOLEAN', 'ReturnData/IRS990T/Organization501cTrustInd'),
  (540060, NULL, NULL, 'Other Tax Amt', 'CURRENCY', 'ReturnData/IRS990T/OtherTaxAmt'),
  (540061, NULL, NULL, 'Other Taxes Amt', 'CURRENCY', 'ReturnData/IRS990T/OtherTaxesAmt'),
  (540062, NULL, NULL, 'Paid Tax Liability Amt', 'CURRENCY', 'ReturnData/IRS990T/PaidTaxLiabilityAmt'),
  (540063, NULL, NULL, 'Prior Year Overpayment Credit Amt', 'CURRENCY', 'ReturnData/IRS990T/PriorYearOverpaymentCreditAmt'),
  (540064, NULL, NULL, 'Section199A Deduction Amt', 'CURRENCY', 'ReturnData/IRS990T/Section199ADeductionAmt'),
  (540065, NULL, NULL, 'Specific Deduction Amt', 'CURRENCY', 'ReturnData/IRS990T/SpecificDeductionAmt'),
  (540066, NULL, NULL, 'Subsidiary Corporation Ind', 'BOOLEAN', 'ReturnData/IRS990T/SubsidiaryCorporationInd'),
  (540067, NULL, NULL, 'Tax Exempt Interest Amt', 'CURRENCY', 'ReturnData/IRS990T/TaxExemptInterestAmt'),
  (540068, NULL, NULL, 'Tax Less Credits Amt', 'CURRENCY', 'ReturnData/IRS990T/TaxLessCreditsAmt'),
  (540069, NULL, NULL, 'Tax Rate Schedule Ind', 'BOOLEAN', 'ReturnData/IRS990T/TaxRateScheduleInd'),
  (540070, NULL, NULL, 'Taxable Corporation Amt', 'CURRENCY', 'ReturnData/IRS990T/TaxableCorporationAmt'),
  (540071, NULL, NULL, 'Taxable Trust Amt', 'CURRENCY', 'ReturnData/IRS990T/TaxableTrustAmt'),
  (540072, NULL, NULL, 'Total Credits Amt', 'CURRENCY', 'ReturnData/IRS990T/TotalCreditsAmt'),
  (540073, NULL, NULL, 'Total Deduction Amt', 'CURRENCY', 'ReturnData/IRS990T/TotalDeductionAmt'),
  (540074, NULL, NULL, 'Total Payments Amt', 'CURRENCY', 'ReturnData/IRS990T/TotalPaymentsAmt'),
  (540075, NULL, NULL, 'Total Tax Computation Amt', 'CURRENCY', 'ReturnData/IRS990T/TotalTaxComputationAmt'),
  (540076, NULL, NULL, 'Total UBTI Amt', 'CURRENCY', 'ReturnData/IRS990T/TotalUBTIAmt'),
  (540077, NULL, NULL, 'Total UBTI Before NOL Specific Amt', 'CURRENCY', 'ReturnData/IRS990T/TotalUBTIBeforeNOLSpecificAmt'),
  (540078, NULL, NULL, 'Total UBTI Before Section199A Amt', 'CURRENCY', 'ReturnData/IRS990T/TotalUBTIBeforeSection199AAmt'),
  (540079, NULL, NULL, 'Total UBTI Computed Amt', 'CURRENCY', 'ReturnData/IRS990T/TotalUBTIComputedAmt'),
  (540080, NULL, NULL, 'Additional Section263A Costs Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/AdditionalSection263ACostsAmt'),
  (540081, NULL, NULL, 'Bad Debt Expense Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/BadDebtExpenseAmt'),
  (540082, NULL, NULL, 'Beginning Of Year Inventory Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/BeginningOfYearInventoryAmt'),
  (540083, NULL, NULL, 'Capital Gain Net Income Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/CapitalGainNetIncomeAmt'),
  (540084, NULL, NULL, 'Cost Of Goods Sold Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/CostOfGoodsSoldAmt'),
  (540085, NULL, NULL, 'Cost Of Labor Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/CostOfLaborAmt'),
  (540086, NULL, NULL, 'Depletion Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/DepletionAmt'),
  (540087, NULL, NULL, 'Depreciation Clm Elsewhere Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/DepreciationClmElsewhereAmt'),
  (540088, NULL, NULL, 'Depreciation Net Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/DepreciationNetAmt'),
  (540089, NULL, NULL, 'End Of Year Inventory Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/EndOfYearInventoryAmt'),
  (540090, NULL, NULL, 'Exploited Activity Desc', 'TEXT', 'ReturnData/IRS990TScheduleA/ExploitedActivityDesc'),
  (540091, NULL, NULL, 'Exploited Activity Net Income Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/ExploitedActivityNetIncomeAmt'),
  (540092, NULL, NULL, 'Exploited Excess Exempt Expnss Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/ExploitedExcessExemptExpnssAmt'),
  (540093, NULL, NULL, 'Exploited Exempt Activity Incm Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/ExploitedExemptActivityIncmAmt'),
  (540094, NULL, NULL, 'Exploited Expnss Cnnct UBI Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/ExploitedExpnssCnnctUBIAmt'),
  (540095, NULL, NULL, 'Gross Income Acty Not UBI Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/GrossIncomeActyNotUBIAmt'),
  (540096, NULL, NULL, 'Gross Income Acty Not UBI Expns Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/GrossIncomeActyNotUBIExpnsAmt'),
  (540097, NULL, NULL, 'Gross Profit Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/GrossProfitAmt'),
  (540098, NULL, NULL, 'Gross Receipts Or Sales Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/GrossReceiptsOrSalesAmt'),
  (540099, NULL, NULL, 'Interest Deduction Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/InterestDeductionAmt'),
  (540100, NULL, NULL, 'Inventory Valuation Method Cd', 'TEXT', 'ReturnData/IRS990TScheduleA/InventoryValuationMethodCd'),
  (540101, NULL, NULL, 'Net Advertising Income Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/NetAdvertisingIncomeAmt'),
  (540102, NULL, NULL, 'Net Exploited Activity Income Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/NetExploitedActivityIncomeAmt'),
  (540103, NULL, NULL, 'Net Gross Receipts Or Sales Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/NetGrossReceiptsOrSalesAmt'),
  (540104, NULL, NULL, 'Net Investment Income Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/NetInvestmentIncomeAmt'),
  (540105, NULL, NULL, 'Net Operating Loss Deduction Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/NetOperatingLossDeductionAmt'),
  (540106, NULL, NULL, 'Net Rent Income Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/NetRentIncomeAmt'),
  (540107, NULL, NULL, 'Net Unrelated Debt Fincd Incm Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/NetUnrelatedDebtFincdIncmAmt'),
  (540108, NULL, NULL, 'Other Costs Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/OtherCostsAmt'),
  (540109, NULL, NULL, 'Other Deductions Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/OtherDeductionsAmt'),
  (540110, NULL, NULL, 'Other Income Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/OtherIncomeAmt'),
  (540111, NULL, NULL, 'Principal Business Activity Cd', 'TEXT', 'ReturnData/IRS990TScheduleA/PrincipalBusinessActivityCd'),
  (540112, NULL, NULL, 'Purchases Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/PurchasesAmt'),
  (540113, NULL, NULL, 'Repairs And Maintenance Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/RepairsAndMaintenanceAmt'),
  (540114, NULL, NULL, 'Salaries And Wages Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/SalariesAndWagesAmt'),
  (540115, NULL, NULL, 'Section263A Rules Apply Ind', 'BOOLEAN', 'ReturnData/IRS990TScheduleA/Section263ARulesApplyInd'),
  (540116, NULL, NULL, 'Sequence Reference Num', 'INTEGER', 'ReturnData/IRS990TScheduleA/SequenceReferenceNum'),
  (540117, NULL, NULL, 'Sequence Total Num', 'INTEGER', 'ReturnData/IRS990TScheduleA/SequenceTotalNum'),
  (540118, NULL, NULL, 'Taxes And Licenses Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/TaxesAndLicensesAmt'),
  (540119, NULL, NULL, 'Tot Excess Readership Costs Ded Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/TotExcessReadershipCostsDedAmt'),
  (540120, NULL, NULL, 'Tot Net Unrlt Trd Bus Incm Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/TotNetUnrltTrdBusIncmAmt'),
  (540121, NULL, NULL, 'Tot Unrlt Trd Bus Incm Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/TotUnrltTrdBusIncmAmt'),
  (540122, NULL, NULL, 'Tot Unrlt Trd Bus Incm Expnss Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/TotUnrltTrdBusIncmExpnssAmt'),
  (540123, NULL, NULL, 'Total Allocable Deductions Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/TotalAllocableDeductionsAmt'),
  (540124, NULL, NULL, 'Total Cost Goods Sold Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/TotalCostGoodsSoldAmt'),
  (540125, NULL, NULL, 'Total Ctrl Org Deduction Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/TotalCtrlOrgDeductionAmt'),
  (540126, NULL, NULL, 'Total Ctrl Org Pymt Gross Incm Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/TotalCtrlOrgPymtGrossIncmAmt'),
  (540127, NULL, NULL, 'Total Deduction Set Asides Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/TotalDeductionSetAsidesAmt'),
  (540128, NULL, NULL, 'Total Deductions Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/TotalDeductionsAmt'),
  (540129, NULL, NULL, 'Total Depreciation Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/TotalDepreciationAmt'),
  (540130, NULL, NULL, 'Total Direct Advertising Cost Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/TotalDirectAdvertisingCostAmt'),
  (540131, NULL, NULL, 'Total Dividends Received Ded Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/TotalDividendsReceivedDedAmt'),
  (540132, NULL, NULL, 'Total Gross Advertising Income Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/TotalGrossAdvertisingIncomeAmt'),
  (540133, NULL, NULL, 'Total Gross Debt Financed Incm Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/TotalGrossDebtFinancedIncmAmt'),
  (540134, NULL, NULL, 'Total Investment Income Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/TotalInvestmentIncomeAmt'),
  (540135, NULL, NULL, 'Total Ordinary Gain Loss Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/TotalOrdinaryGainLossAmt'),
  (540136, NULL, NULL, 'Total Prtshp S Corp Income Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/TotalPrtshpSCorpIncomeAmt'),
  (540137, NULL, NULL, 'Total Rent Deductions Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/TotalRentDeductionsAmt'),
  (540138, NULL, NULL, 'Total Rent Income Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/TotalRentIncomeAmt'),
  (540139, NULL, NULL, 'Total Unrelated Business Comp Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/TotalUnrelatedBusinessCompAmt'),
  (540140, NULL, NULL, 'Trade Or Business Desc', 'TEXT', 'ReturnData/IRS990TScheduleA/TradeOrBusinessDesc'),
  (540141, NULL, NULL, 'UBI Before NOL Ded Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/UBIBeforeNOLDedAmt'),
  (540142, NULL, NULL, 'Unrelated Business Taxbl Incm Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/UnrelatedBusinessTaxblIncmAmt');

-- 990T / Advertising Incm Periodical Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (540143, 54001, '1', 'Advertised Periodical Name Txt', 'TEXT'),
  (540144, 54001, '2', 'Advertising Gain Loss Amt', 'CURRENCY'),
  (540145, 54001, '3', 'Direct Advertising Cost Amt', 'CURRENCY'),
  (540146, 54001, '4', 'Excess Readership Costs Amt', 'CURRENCY'),
  (540147, 54001, '5', 'Excess Readership Costs Ded Amt', 'CURRENCY'),
  (540148, 54001, '6', 'Gross Advertising Income Amt', 'CURRENCY'),
  (540149, 54001, '7', 'Readership Costs Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (540143, NULL, NULL, 'Advertised Periodical Name Txt', 'TEXT', 'ReturnData/IRS990TScheduleA/AdvertisingIncmPeriodicalGrp/AdvertisedPeriodicalNameTxt'),
  (540144, NULL, NULL, 'Advertising Gain Loss Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/AdvertisingIncmPeriodicalGrp/AdvertisingGainLossAmt'),
  (540145, NULL, NULL, 'Direct Advertising Cost Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/AdvertisingIncmPeriodicalGrp/DirectAdvertisingCostAmt'),
  (540146, NULL, NULL, 'Excess Readership Costs Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/AdvertisingIncmPeriodicalGrp/ExcessReadershipCostsAmt'),
  (540147, NULL, NULL, 'Excess Readership Costs Ded Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/AdvertisingIncmPeriodicalGrp/ExcessReadershipCostsDedAmt'),
  (540148, NULL, NULL, 'Gross Advertising Income Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/AdvertisingIncmPeriodicalGrp/GrossAdvertisingIncomeAmt'),
  (540149, NULL, NULL, 'Readership Costs Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/AdvertisingIncmPeriodicalGrp/ReadershipCostsAmt');

-- 990T / Books In Care Of Detail
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (540150, 54002, '1', 'Business Name Line1Txt', 'TEXT'),
  (540151, 54002, '2', 'Person Nm', 'TEXT'),
  (540152, 54002, '3', 'Phone Num', 'TEXT'),
  (540153, 54002, '4', 'Address Line1Txt', 'TEXT'),
  (540154, 54002, '5', 'City Nm', 'TEXT'),
  (540155, 54002, '6', 'State Abbreviation Cd', 'TEXT'),
  (540156, 54002, '7', 'ZIP Cd', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (540150, NULL, NULL, 'Business Name Line1Txt', 'TEXT', 'ReturnData/IRS990T/BooksInCareOfDetail/BusinessName/BusinessNameLine1Txt'),
  (540151, NULL, NULL, 'Person Nm', 'TEXT', 'ReturnData/IRS990T/BooksInCareOfDetail/PersonNm'),
  (540152, NULL, NULL, 'Phone Num', 'TEXT', 'ReturnData/IRS990T/BooksInCareOfDetail/PhoneNum'),
  (540153, NULL, NULL, 'Address Line1Txt', 'TEXT', 'ReturnData/IRS990T/BooksInCareOfDetail/USAddress/AddressLine1Txt'),
  (540154, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990T/BooksInCareOfDetail/USAddress/CityNm'),
  (540155, NULL, NULL, 'State Abbreviation Cd', 'TEXT', 'ReturnData/IRS990T/BooksInCareOfDetail/USAddress/StateAbbreviationCd'),
  (540156, NULL, NULL, 'ZIP Cd', 'TEXT', 'ReturnData/IRS990T/BooksInCareOfDetail/USAddress/ZIPCd');

-- 990T / Estate Or Trust Cap Gain Or Loss Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (540157, 54003, '1', 'Total For Year Amt', 'CURRENCY'),
  (540158, 54003, '2', 'Total Net Gain Or Loss Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (540157, NULL, NULL, 'Total For Year Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/EstateOrTrustCapGainOrLossGrp/NetLongTermGainOrLossGrp/TotalForYearAmt'),
  (540158, NULL, NULL, 'Total Net Gain Or Loss Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/EstateOrTrustCapGainOrLossGrp/TotalNetGainOrLossAmt');

-- 990T / Itmzd Supplemental Info Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (540159, 54004, '1', 'Explanation Txt', 'TEXT'),
  (540160, 54004, '2', 'Line Num', 'INTEGER'),
  (540161, 54004, '3', 'Part Num', 'INTEGER');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (540159, NULL, NULL, 'Explanation Txt', 'TEXT', 'ReturnData/IRS990T/ItmzdSupplementalInfoGrp/ExplanationTxt'),
  (540160, NULL, NULL, 'Line Num', 'INTEGER', 'ReturnData/IRS990T/ItmzdSupplementalInfoGrp/LineNum'),
  (540161, NULL, NULL, 'Part Num', 'INTEGER', 'ReturnData/IRS990T/ItmzdSupplementalInfoGrp/PartNum');

-- 990T / Long Term Capital Gain And Loss Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (540162, 54005, '1', 'Gain Or Loss Amt', 'CURRENCY'),
  (540163, 54005, '2', 'Property Desc', 'TEXT'),
  (540164, 54005, '3', 'Total Gain Or Loss Amt', 'CURRENCY'),
  (540165, 54005, '4', 'Transactions Not Rpted On1099B Ind', 'BOOLEAN');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (540162, NULL, NULL, 'Gain Or Loss Amt', 'CURRENCY', 'ReturnData/IRS8949/LongTermCapitalGainAndLossGrp/CapitalGainAndLossAssetGrp/GainOrLossAmt'),
  (540163, NULL, NULL, 'Property Desc', 'TEXT', 'ReturnData/IRS8949/LongTermCapitalGainAndLossGrp/CapitalGainAndLossAssetGrp/PropertyDesc'),
  (540164, NULL, NULL, 'Total Gain Or Loss Amt', 'CURRENCY', 'ReturnData/IRS8949/LongTermCapitalGainAndLossGrp/TotalGainOrLossAmt'),
  (540165, NULL, NULL, 'Transactions Not Rpted On1099B Ind', 'BOOLEAN', 'ReturnData/IRS8949/LongTermCapitalGainAndLossGrp/TransactionsNotRptedOn1099BInd');

-- 990T / Officer Dir Trst Comp Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (540166, 54006, '1', 'Person Nm', 'TEXT'),
  (540167, 54006, '2', 'Time Devoted To Business Pct', 'PERCENT'),
  (540168, 54006, '3', 'Title Txt', 'TEXT'),
  (540169, 54006, '4', 'Unrelated Business Comp Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (540166, NULL, NULL, 'Person Nm', 'TEXT', 'ReturnData/IRS990TScheduleA/OfficerDirTrstCompGrp/PersonNm'),
  (540167, NULL, NULL, 'Time Devoted To Business Pct', 'PERCENT', 'ReturnData/IRS990TScheduleA/OfficerDirTrstCompGrp/TimeDevotedToBusinessPct'),
  (540168, NULL, NULL, 'Title Txt', 'TEXT', 'ReturnData/IRS990TScheduleA/OfficerDirTrstCompGrp/TitleTxt'),
  (540169, NULL, NULL, 'Unrelated Business Comp Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/OfficerDirTrstCompGrp/UnrelatedBusinessCompAmt');

-- 990T / Organization501Indicator Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (540170, 54007, '1', 'Organization501Ind', 'BOOLEAN'),
  (540171, 54007, '2', 'Organization501c Type Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (540170, NULL, NULL, 'Organization501Ind', 'BOOLEAN', 'ReturnData/IRS990T/Organization501IndicatorGrp/Organization501Ind'),
  (540171, NULL, NULL, 'Organization501c Type Txt', 'TEXT', 'ReturnData/IRS990T/Organization501IndicatorGrp/Organization501cTypeTxt');

-- 990T / Overpayment Section
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (540172, 54008, '1', 'Applied To ES Tax Amt', 'CURRENCY'),
  (540173, 54008, '2', 'Overpayment Amt', 'CURRENCY'),
  (540174, 54008, '3', 'Refund Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (540172, NULL, NULL, 'Applied To ES Tax Amt', 'CURRENCY', 'ReturnData/IRS990T/OverpaymentSection/AppliedToESTaxAmt'),
  (540173, NULL, NULL, 'Overpayment Amt', 'CURRENCY', 'ReturnData/IRS990T/OverpaymentSection/OverpaymentAmt'),
  (540174, NULL, NULL, 'Refund Amt', 'CURRENCY', 'ReturnData/IRS990T/OverpaymentSection/RefundAmt');

-- 990T / Post2017NOL Carryover Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (540175, 54009, '1', 'Avlbl Post2017NOL Carryover Amt', 'CURRENCY'),
  (540176, 54009, '2', 'Principal Business Activity Cd', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (540175, NULL, NULL, 'Avlbl Post2017NOL Carryover Amt', 'CURRENCY', 'ReturnData/IRS990T/Post2017NOLCarryoverGrp/AvlblPost2017NOLCarryoverAmt'),
  (540176, NULL, NULL, 'Principal Business Activity Cd', 'TEXT', 'ReturnData/IRS990T/Post2017NOLCarryoverGrp/PrincipalBusinessActivityCd');

-- 990T / Rent Income Property Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (540177, 54010, '1', 'Deductions Connected Rent Incm Amt', 'CURRENCY'),
  (540178, 54010, '2', 'Dual Use Ind', 'BOOLEAN'),
  (540179, 54010, '3', 'Rent Personal Property Amt', 'CURRENCY'),
  (540180, 54010, '4', 'Rent Real Personal Property Amt', 'CURRENCY'),
  (540181, 54010, '5', 'Total Rents By Property Amt', 'CURRENCY'),
  (540182, 54010, '6', 'Address Line1Txt', 'TEXT'),
  (540183, 54010, '7', 'City Nm', 'TEXT'),
  (540184, 54010, '8', 'State Abbreviation Cd', 'TEXT'),
  (540185, 54010, '9', 'ZIP Cd', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (540177, NULL, NULL, 'Deductions Connected Rent Incm Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/RentIncomePropertyGrp/DeductionsConnectedRentIncmAmt'),
  (540178, NULL, NULL, 'Dual Use Ind', 'BOOLEAN', 'ReturnData/IRS990TScheduleA/RentIncomePropertyGrp/DualUseInd'),
  (540179, NULL, NULL, 'Rent Personal Property Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/RentIncomePropertyGrp/RentPersonalPropertyAmt'),
  (540180, NULL, NULL, 'Rent Real Personal Property Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/RentIncomePropertyGrp/RentRealPersonalPropertyAmt'),
  (540181, NULL, NULL, 'Total Rents By Property Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/RentIncomePropertyGrp/TotalRentsByPropertyAmt'),
  (540182, NULL, NULL, 'Address Line1Txt', 'TEXT', 'ReturnData/IRS990TScheduleA/RentIncomePropertyGrp/USAddress/AddressLine1Txt'),
  (540183, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990TScheduleA/RentIncomePropertyGrp/USAddress/CityNm'),
  (540184, NULL, NULL, 'State Abbreviation Cd', 'TEXT', 'ReturnData/IRS990TScheduleA/RentIncomePropertyGrp/USAddress/StateAbbreviationCd'),
  (540185, NULL, NULL, 'ZIP Cd', 'TEXT', 'ReturnData/IRS990TScheduleA/RentIncomePropertyGrp/USAddress/ZIPCd');

-- 990T / Short Term Capital Gain And Loss Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (540186, 54011, '1', 'Gain Or Loss Amt', 'CURRENCY'),
  (540187, 54011, '2', 'Property Desc', 'TEXT'),
  (540188, 54011, '3', 'Total Gain Or Loss Amt', 'CURRENCY'),
  (540189, 54011, '4', 'Transactions Not Rpted On1099B Ind', 'BOOLEAN');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (540186, NULL, NULL, 'Gain Or Loss Amt', 'CURRENCY', 'ReturnData/IRS8949/ShortTermCapitalGainAndLossGrp/CapitalGainAndLossAssetGrp/GainOrLossAmt'),
  (540187, NULL, NULL, 'Property Desc', 'TEXT', 'ReturnData/IRS8949/ShortTermCapitalGainAndLossGrp/CapitalGainAndLossAssetGrp/PropertyDesc'),
  (540188, NULL, NULL, 'Total Gain Or Loss Amt', 'CURRENCY', 'ReturnData/IRS8949/ShortTermCapitalGainAndLossGrp/TotalGainOrLossAmt'),
  (540189, NULL, NULL, 'Transactions Not Rpted On1099B Ind', 'BOOLEAN', 'ReturnData/IRS8949/ShortTermCapitalGainAndLossGrp/TransactionsNotRptedOn1099BInd');

-- 990T / Total Capital Gain Or Loss Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (540190, 54012, '1', 'Total For Year Amt', 'CURRENCY'),
  (540191, 54012, '2', 'Total Net Gain Or Loss Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (540190, NULL, NULL, 'Total For Year Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/TotalCapitalGainOrLossGrp/NetLongTermGainOrLossGrp/TotalForYearAmt'),
  (540191, NULL, NULL, 'Total Net Gain Or Loss Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/TotalCapitalGainOrLossGrp/TotalNetGainOrLossAmt');

-- 990T / Total LTCGL1099B Not Received Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (540192, 54013, '1', 'Total Gain Or Loss Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (540192, NULL, NULL, 'Total Gain Or Loss Amt', 'CURRENCY', 'ReturnData/IRS1120ScheduleD/TotalLTCGL1099BNotReceivedGrp/TotalGainOrLossAmt');

-- 990T / Total STCGL1099B Not Received Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (540193, 54014, '1', 'Total Gain Or Loss Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (540193, NULL, NULL, 'Total Gain Or Loss Amt', 'CURRENCY', 'ReturnData/IRS1120ScheduleD/TotalSTCGL1099BNotReceivedGrp/TotalGainOrLossAmt');

-- 990T / Unrelated Debt Financed Prop Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (540194, 54015, '1', 'Allocable Deduction Amt', 'CURRENCY'),
  (540195, 54015, '2', 'Average Acquisition Adj Basis Pct', 'PERCENT'),
  (540196, 54015, '3', 'Average Acquisition Debt Amt', 'CURRENCY'),
  (540197, 54015, '4', 'Average Adjusted Basis Amt', 'CURRENCY'),
  (540198, 54015, '5', 'Dual Use Ind', 'BOOLEAN'),
  (540199, 54015, '6', 'Gross Income Amt', 'CURRENCY'),
  (540200, 54015, '7', 'Gross Income Reportable Amt', 'CURRENCY'),
  (540201, 54015, '8', 'Other Debt Financed Deduction Amt', 'CURRENCY'),
  (540202, 54015, '9', 'Property Desc', 'TEXT'),
  (540203, 54015, '10', 'Straight Line Depreciation Ded Amt', 'CURRENCY'),
  (540204, 54015, '11', 'Total Debt Financed Deduction Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (540194, NULL, NULL, 'Allocable Deduction Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/UnrelatedDebtFinancedPropGrp/AllocableDeductionAmt'),
  (540195, NULL, NULL, 'Average Acquisition Adj Basis Pct', 'PERCENT', 'ReturnData/IRS990TScheduleA/UnrelatedDebtFinancedPropGrp/AverageAcquisitionAdjBasisPct'),
  (540196, NULL, NULL, 'Average Acquisition Debt Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/UnrelatedDebtFinancedPropGrp/AverageAcquisitionDebtAmt'),
  (540197, NULL, NULL, 'Average Adjusted Basis Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/UnrelatedDebtFinancedPropGrp/AverageAdjustedBasisAmt'),
  (540198, NULL, NULL, 'Dual Use Ind', 'BOOLEAN', 'ReturnData/IRS990TScheduleA/UnrelatedDebtFinancedPropGrp/DualUseInd'),
  (540199, NULL, NULL, 'Gross Income Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/UnrelatedDebtFinancedPropGrp/GrossIncomeAmt'),
  (540200, NULL, NULL, 'Gross Income Reportable Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/UnrelatedDebtFinancedPropGrp/GrossIncomeReportableAmt'),
  (540201, NULL, NULL, 'Other Debt Financed Deduction Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/UnrelatedDebtFinancedPropGrp/OtherDebtFinancedDeductionAmt'),
  (540202, NULL, NULL, 'Property Desc', 'TEXT', 'ReturnData/IRS990TScheduleA/UnrelatedDebtFinancedPropGrp/PropertyDesc'),
  (540203, NULL, NULL, 'Straight Line Depreciation Ded Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/UnrelatedDebtFinancedPropGrp/StraightLineDepreciationDedAmt'),
  (540204, NULL, NULL, 'Total Debt Financed Deduction Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/UnrelatedDebtFinancedPropGrp/TotalDebtFinancedDeductionAmt');

-- ========================================================================
-- FORM 990T — Extended field mappings (Round 2)
-- ========================================================================

-- 990T / IRS3800 Direct Fields
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54016, 54, '017', 'IRS3800 Direct Fields');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (540205, 54016, '1', 'Current Year Credit Allowed Amt', 'CURRENCY'),
  (540206, 54016, '2', 'Net Income Tax Amt', 'CURRENCY'),
  (540207, 54016, '3', 'Net Income Tax Less Pct Excess Amt', 'CURRENCY'),
  (540208, 54016, '4', 'Adjusted Net Income Tax Amt', 'CURRENCY'),
  (540209, 54016, '5', 'Net Smllr And Empwr Zn Emplmn Cr Amt', 'CURRENCY'),
  (540210, 54016, '6', 'Regular Tax Before Credits Amt', 'CURRENCY'),
  (540211, 54016, '7', 'Empwr Zone And Com Employment Cr Amt', 'CURRENCY'),
  (540212, 54016, '8', 'CAMT And BEAT Ind', 'BOOLEAN'),
  (540213, 54016, '9', 'Tot Allw Gen And Elig Smll Bus Cr Amt', 'CURRENCY'),
  (540214, 54016, '10', 'Adjusted Reg Tax Before Credit Amt', 'CURRENCY'),
  (540215, 54016, '11', 'Allw Gen Bus Cr From Non Pssv Acty Amt', 'CURRENCY'),
  (540216, 54016, '12', 'Alternative Minimum Tax Amt', 'CURRENCY'),
  (540217, 54016, '13', 'CY Credits Not Allw Against TMT Amt', 'CURRENCY'),
  (540218, 54016, '14', 'Sum Smllr Empwr Zn Emplmn Cr Amt', 'CURRENCY'),
  (540219, 54016, '15', 'Smllr CY Not Allw TMT Or Tot Adj Amt', 'CURRENCY'),
  (540220, 54016, '16', 'Smllr Gen Bus Cr Or Tot Gen Elig Cr Amt', 'CURRENCY'),
  (540221, 54016, '17', 'Net Regular Tax Amt', 'CURRENCY'),
  (540222, 54016, '18', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (540223, 54016, '19', 'Adjusted Excess Net Regular Tax Amt', 'CURRENCY'),
  (540224, 54016, '20', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (540225, 54016, '21', 'Excess Net Regular Tax Amt', 'CURRENCY'),
  (540226, 54016, '22', 'Gen Bus Elig Smll Bus Pssv Acty Cr Amt', 'CURRENCY'),
  (540227, 54016, '23', 'Allw Gen And Elig Smll Bus Cfwd Cr Amt', 'CURRENCY'),
  (540228, 54016, '24', 'Net Incm Tax Less Greater Excess Amt', 'CURRENCY'),
  (540229, 54016, '25', 'Sub Smllr From Net Less Greater Amt', 'CURRENCY'),
  (540230, 54016, '26', 'Total Passive Activity Credit Amt', 'CURRENCY'),
  (540231, 54016, '27', 'Greater Excess Or Times Pct Amt', 'CURRENCY'),
  (540232, 54016, '28', 'Tot Empwr Zone Gen Bus Credits Amt', 'CURRENCY'),
  (540233, 54016, '29', 'Tentative Minimun Tax Times Pct Amt', 'CURRENCY'),
  (540234, 54016, '30', 'GBC From Pssv Acty All Parts Amt', 'CURRENCY'),
  (540235, 54016, '31', 'Total Tax Credits Amt', 'CURRENCY'),
  (540236, 54016, '32', 'Allw Gen And Elig Smll Bus Cybk Cr Amt', 'CURRENCY'),
  (540237, 54016, '33', 'Carry Back General Business Cr Amt', 'CURRENCY'),
  (540238, 54016, '34', 'Tentative Minimum Tax Amt', 'CURRENCY'),
  (540239, 54016, '35', 'Pssv Acty For Gen Bus Cr Allowed Amt', 'CURRENCY'),
  (540240, 54016, '36', 'Curr Year Passive Acty Credits Amt', 'CURRENCY'),
  (540241, 54016, '37', 'Other Specified Allw Gen Bus Cr Amt', 'CURRENCY'),
  (540242, 54016, '38', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (540243, 54016, '39', 'Foreign Tax Credit Amt', 'CURRENCY'),
  (540244, 54016, '40', 'Passive Acty Allowed For TY Amt', 'CURRENCY'),
  (540245, 54016, '41', 'Certain Allowable Credits Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (540205, NULL, NULL, 'Current Year Credit Allowed Amt', 'CURRENCY', 'ReturnData/IRS3800/CurrentYearCreditAllowedAmt'),
  (540206, NULL, NULL, 'Net Income Tax Amt', 'CURRENCY', 'ReturnData/IRS3800/NetIncomeTaxAmt'),
  (540207, NULL, NULL, 'Net Income Tax Less Pct Excess Amt', 'CURRENCY', 'ReturnData/IRS3800/NetIncomeTaxLessPctExcessAmt'),
  (540208, NULL, NULL, 'Adjusted Net Income Tax Amt', 'CURRENCY', 'ReturnData/IRS3800/AdjustedNetIncomeTaxAmt'),
  (540209, NULL, NULL, 'Net Smllr And Empwr Zn Emplmn Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/NetSmllrAndEmpwrZnEmplmnCrAmt'),
  (540210, NULL, NULL, 'Regular Tax Before Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/RegularTaxBeforeCreditsAmt'),
  (540211, NULL, NULL, 'Empwr Zone And Com Employment Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/EmpwrZoneAndComEmploymentCrAmt'),
  (540212, NULL, NULL, 'CAMT And BEAT Ind', 'BOOLEAN', 'ReturnData/IRS3800/CAMTAndBEATInd'),
  (540213, NULL, NULL, 'Tot Allw Gen And Elig Smll Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/TotAllwGenAndEligSmllBusCrAmt'),
  (540214, NULL, NULL, 'Adjusted Reg Tax Before Credit Amt', 'CURRENCY', 'ReturnData/IRS3800/AdjustedRegTaxBeforeCreditAmt'),
  (540215, NULL, NULL, 'Allw Gen Bus Cr From Non Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/AllwGenBusCrFromNonPssvActyAmt'),
  (540216, NULL, NULL, 'Alternative Minimum Tax Amt', 'CURRENCY', 'ReturnData/IRS3800/AlternativeMinimumTaxAmt'),
  (540217, NULL, NULL, 'CY Credits Not Allw Against TMT Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCreditsNotAllwAgainstTMTAmt'),
  (540218, NULL, NULL, 'Sum Smllr Empwr Zn Emplmn Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/SumSmllrEmpwrZnEmplmnCrAmt'),
  (540219, NULL, NULL, 'Smllr CY Not Allw TMT Or Tot Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/SmllrCYNotAllwTMTOrTotAdjAmt'),
  (540220, NULL, NULL, 'Smllr Gen Bus Cr Or Tot Gen Elig Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/SmllrGenBusCrOrTotGenEligCrAmt'),
  (540221, NULL, NULL, 'Net Regular Tax Amt', 'CURRENCY', 'ReturnData/IRS3800/NetRegularTaxAmt'),
  (540222, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/GeneralBusCrFromNnPssvActyAmt'),
  (540223, NULL, NULL, 'Adjusted Excess Net Regular Tax Amt', 'CURRENCY', 'ReturnData/IRS3800/AdjustedExcessNetRegularTaxAmt'),
  (540224, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/CYGeneralBusCrCarryforwardAmt'),
  (540225, NULL, NULL, 'Excess Net Regular Tax Amt', 'CURRENCY', 'ReturnData/IRS3800/ExcessNetRegularTaxAmt'),
  (540226, NULL, NULL, 'Gen Bus Elig Smll Bus Pssv Acty Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusEligSmllBusPssvActyCrAmt'),
  (540227, NULL, NULL, 'Allw Gen And Elig Smll Bus Cfwd Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/AllwGenAndEligSmllBusCfwdCrAmt'),
  (540228, NULL, NULL, 'Net Incm Tax Less Greater Excess Amt', 'CURRENCY', 'ReturnData/IRS3800/NetIncmTaxLessGreaterExcessAmt'),
  (540229, NULL, NULL, 'Sub Smllr From Net Less Greater Amt', 'CURRENCY', 'ReturnData/IRS3800/SubSmllrFromNetLessGreaterAmt'),
  (540230, NULL, NULL, 'Total Passive Activity Credit Amt', 'CURRENCY', 'ReturnData/IRS3800/TotalPassiveActivityCreditAmt'),
  (540231, NULL, NULL, 'Greater Excess Or Times Pct Amt', 'CURRENCY', 'ReturnData/IRS3800/GreaterExcessOrTimesPctAmt'),
  (540232, NULL, NULL, 'Tot Empwr Zone Gen Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/TotEmpwrZoneGenBusCreditsAmt'),
  (540233, NULL, NULL, 'Tentative Minimun Tax Times Pct Amt', 'CURRENCY', 'ReturnData/IRS3800/TentativeMinimunTaxTimesPctAmt'),
  (540234, NULL, NULL, 'GBC From Pssv Acty All Parts Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCFromPssvActyAllPartsAmt'),
  (540235, NULL, NULL, 'Total Tax Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/TotalTaxCreditsAmt'),
  (540236, NULL, NULL, 'Allw Gen And Elig Smll Bus Cybk Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/AllwGenAndEligSmllBusCybkCrAmt'),
  (540237, NULL, NULL, 'Carry Back General Business Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/CarryBackGeneralBusinessCrAmt'),
  (540238, NULL, NULL, 'Tentative Minimum Tax Amt', 'CURRENCY', 'ReturnData/IRS3800/TentativeMinimumTaxAmt'),
  (540239, NULL, NULL, 'Pssv Acty For Gen Bus Cr Allowed Amt', 'CURRENCY', 'ReturnData/IRS3800/PssvActyForGenBusCrAllowedAmt'),
  (540240, NULL, NULL, 'Curr Year Passive Acty Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/CurrYearPassiveActyCreditsAmt'),
  (540241, NULL, NULL, 'Other Specified Allw Gen Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/OtherSpecifiedAllwGenBusCrAmt'),
  (540242, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/CrSubjToPassiveActyLmtAmt'),
  (540243, NULL, NULL, 'Foreign Tax Credit Amt', 'CURRENCY', 'ReturnData/IRS3800/ForeignTaxCreditAmt'),
  (540244, NULL, NULL, 'Passive Acty Allowed For TY Amt', 'CURRENCY', 'ReturnData/IRS3800/PassiveActyAllowedForTYAmt'),
  (540245, NULL, NULL, 'Certain Allowable Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/CertainAllowableCreditsAmt');

-- 990T / IRS990 T Direct Fields
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54017, 54, '018', 'IRS990 T Direct Fields');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (540246, 54017, '1', 'Other Credits Amt', 'CURRENCY'),
  (540247, 54017, '2', 'Prnt Corporation Name Control Txt', 'TEXT'),
  (540248, 54017, '3', 'Parent Corporation EIN', 'TEXT'),
  (540249, 54017, '4', 'Address Change Ind', 'BOOLEAN'),
  (540250, 54017, '5', 'Group Exemption Num', 'INTEGER'),
  (540251, 54017, '6', 'Foreign Tax Credit Amt', 'CURRENCY'),
  (540252, 54017, '7', 'Foreign Tax Pd Withheld At Srce Amt', 'CURRENCY'),
  (540253, 54017, '8', 'Foreign Country Cd', 'TEXT'),
  (540254, 54017, '9', 'Alternative Minimum Tax Amt', 'CURRENCY'),
  (540255, 54017, '10', 'Elective Payment Amt', 'CURRENCY'),
  (540256, 54017, '11', 'Total Fuel Tax Credit Amt', 'CURRENCY'),
  (540257, 54017, '12', 'Int Due Und Lkbck Mthd Incm Frcst Amt', 'CURRENCY'),
  (540258, 54017, '13', 'Net Amt Of Interest Owed Amt', 'CURRENCY'),
  (540259, 54017, '14', 'Recapture Tax Amt', 'CURRENCY'),
  (540260, 54017, '15', 'Name Change Ind', 'BOOLEAN'),
  (540261, 54017, '16', 'Elective Payment Ind', 'BOOLEAN'),
  (540262, 54017, '17', 'Other Amt', 'CURRENCY'),
  (540263, 54017, '18', 'Credits Adj Payment Other Amt', 'CURRENCY'),
  (540264, 54017, '19', 'Total Undistributed LT Cap Gain Amt', 'CURRENCY'),
  (540265, 54017, '20', 'Total Chapter1 Tax Amt', 'CURRENCY'),
  (540266, 54017, '21', 'Total Increase In Tax Amt', 'CURRENCY'),
  (540267, 54017, '22', 'Total Other Credits Adj Payment Amt', 'CURRENCY'),
  (540268, 54017, '23', 'Smll Emplr HIP Tax Exempt Credit Amt', 'CURRENCY'),
  (540269, 54017, '24', 'Total Non Chapter1 Tax Amt', 'CURRENCY'),
  (540270, 54017, '25', 'Current Year Minimum Tax Credit Amt', 'CURRENCY'),
  (540271, 54017, '26', 'Proxy Tax Amt', 'CURRENCY'),
  (540272, 54017, '27', 'Credits Adj Payment Other Ind', 'BOOLEAN'),
  (540273, 54017, '28', 'Section6417d1 A Entity Ind', 'BOOLEAN'),
  (540274, 54017, '29', 'Claim Refund Form2439 Ind', 'BOOLEAN'),
  (540275, 54017, '30', 'Organization401a Trust Ind', 'BOOLEAN'),
  (540276, 54017, '31', 'Prov Change Method Of Acct Desc Ind', 'BOOLEAN'),
  (540277, 54017, '32', 'Section643g Election Ind', 'BOOLEAN'),
  (540278, 54017, '33', 'Claim Credit Form8941 Ind', 'BOOLEAN'),
  (540279, 54017, '34', 'Consolidated Return501c3c2 Ind', 'BOOLEAN'),
  (540280, 54017, '35', 'Other Ind', 'BOOLEAN'),
  (540281, 54017, '36', 'Form4136 Ind', 'BOOLEAN'),
  (540282, 54017, '37', 'Section1294 Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (540246, NULL, NULL, 'Other Credits Amt', 'CURRENCY', 'ReturnData/IRS990T/OtherCreditsAmt'),
  (540247, NULL, NULL, 'Prnt Corporation Name Control Txt', 'TEXT', 'ReturnData/IRS990T/PrntCorporationNameControlTxt'),
  (540248, NULL, NULL, 'Parent Corporation EIN', 'TEXT', 'ReturnData/IRS990T/ParentCorporationEIN'),
  (540249, NULL, NULL, 'Address Change Ind', 'BOOLEAN', 'ReturnData/IRS990T/AddressChangeInd'),
  (540250, NULL, NULL, 'Group Exemption Num', 'INTEGER', 'ReturnData/IRS990T/GroupExemptionNum'),
  (540251, NULL, NULL, 'Foreign Tax Credit Amt', 'CURRENCY', 'ReturnData/IRS990T/ForeignTaxCreditAmt'),
  (540252, NULL, NULL, 'Foreign Tax Pd Withheld At Srce Amt', 'CURRENCY', 'ReturnData/IRS990T/ForeignTaxPdWithheldAtSrceAmt'),
  (540253, NULL, NULL, 'Foreign Country Cd', 'TEXT', 'ReturnData/IRS990T/ForeignCountryCd'),
  (540254, NULL, NULL, 'Alternative Minimum Tax Amt', 'CURRENCY', 'ReturnData/IRS990T/AlternativeMinimumTaxAmt'),
  (540255, NULL, NULL, 'Elective Payment Amt', 'CURRENCY', 'ReturnData/IRS990T/ElectivePaymentAmt'),
  (540256, NULL, NULL, 'Total Fuel Tax Credit Amt', 'CURRENCY', 'ReturnData/IRS990T/TotalFuelTaxCreditAmt'),
  (540257, NULL, NULL, 'Int Due Und Lkbck Mthd Incm Frcst Amt', 'CURRENCY', 'ReturnData/IRS990T/IntDueUndLkbckMthdIncmFrcstAmt'),
  (540258, NULL, NULL, 'Net Amt Of Interest Owed Amt', 'CURRENCY', 'ReturnData/IRS990T/NetAmtOfInterestOwedAmt'),
  (540259, NULL, NULL, 'Recapture Tax Amt', 'CURRENCY', 'ReturnData/IRS990T/RecaptureTaxAmt'),
  (540260, NULL, NULL, 'Name Change Ind', 'BOOLEAN', 'ReturnData/IRS990T/NameChangeInd'),
  (540261, NULL, NULL, 'Elective Payment Ind', 'BOOLEAN', 'ReturnData/IRS990T/ElectivePaymentInd'),
  (540262, NULL, NULL, 'Other Amt', 'CURRENCY', 'ReturnData/IRS990T/OtherAmt'),
  (540263, NULL, NULL, 'Credits Adj Payment Other Amt', 'CURRENCY', 'ReturnData/IRS990T/CreditsAdjPaymentOtherAmt'),
  (540264, NULL, NULL, 'Total Undistributed LT Cap Gain Amt', 'CURRENCY', 'ReturnData/IRS990T/TotalUndistributedLTCapGainAmt'),
  (540265, NULL, NULL, 'Total Chapter1 Tax Amt', 'CURRENCY', 'ReturnData/IRS990T/TotalChapter1TaxAmt'),
  (540266, NULL, NULL, 'Total Increase In Tax Amt', 'CURRENCY', 'ReturnData/IRS990T/TotalIncreaseInTaxAmt'),
  (540267, NULL, NULL, 'Total Other Credits Adj Payment Amt', 'CURRENCY', 'ReturnData/IRS990T/TotalOtherCreditsAdjPaymentAmt'),
  (540268, NULL, NULL, 'Smll Emplr HIP Tax Exempt Credit Amt', 'CURRENCY', 'ReturnData/IRS990T/SmllEmplrHIPTaxExemptCreditAmt'),
  (540269, NULL, NULL, 'Total Non Chapter1 Tax Amt', 'CURRENCY', 'ReturnData/IRS990T/TotalNonChapter1TaxAmt'),
  (540270, NULL, NULL, 'Current Year Minimum Tax Credit Amt', 'CURRENCY', 'ReturnData/IRS990T/CurrentYearMinimumTaxCreditAmt'),
  (540271, NULL, NULL, 'Proxy Tax Amt', 'CURRENCY', 'ReturnData/IRS990T/ProxyTaxAmt'),
  (540272, NULL, NULL, 'Credits Adj Payment Other Ind', 'BOOLEAN', 'ReturnData/IRS990T/CreditsAdjPaymentOtherInd'),
  (540273, NULL, NULL, 'Section6417d1 A Entity Ind', 'BOOLEAN', 'ReturnData/IRS990T/Section6417d1AEntityInd'),
  (540274, NULL, NULL, 'Claim Refund Form2439 Ind', 'BOOLEAN', 'ReturnData/IRS990T/ClaimRefundForm2439Ind'),
  (540275, NULL, NULL, 'Organization401a Trust Ind', 'BOOLEAN', 'ReturnData/IRS990T/Organization401aTrustInd'),
  (540276, NULL, NULL, 'Prov Change Method Of Acct Desc Ind', 'BOOLEAN', 'ReturnData/IRS990T/ProvChangeMethodOfAcctDescInd'),
  (540277, NULL, NULL, 'Section643g Election Ind', 'BOOLEAN', 'ReturnData/IRS990T/Section643gElectionInd'),
  (540278, NULL, NULL, 'Claim Credit Form8941 Ind', 'BOOLEAN', 'ReturnData/IRS990T/ClaimCreditForm8941Ind'),
  (540279, NULL, NULL, 'Consolidated Return501c3c2 Ind', 'BOOLEAN', 'ReturnData/IRS990T/ConsolidatedReturn501c3c2Ind'),
  (540280, NULL, NULL, 'Other Ind', 'BOOLEAN', 'ReturnData/IRS990T/OtherInd'),
  (540281, NULL, NULL, 'Form4136 Ind', 'BOOLEAN', 'ReturnData/IRS990T/Form4136Ind'),
  (540282, NULL, NULL, 'Section1294 Amt', 'CURRENCY', 'ReturnData/IRS990T/Section1294Amt');

-- 990T / GBC Breakdown CY Aggrgt Amt Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54018, 54, '019', 'GBC Breakdown CY Aggrgt Amt Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (540283, 54018, '1', 'Pass Through Entity EIN', 'TEXT'),
  (540284, 54018, '2', 'Net Elective Pymt Election Amt', 'CURRENCY'),
  (540285, 54018, '3', 'Net Elective Pymt Election Amt', 'CURRENCY'),
  (540286, 54018, '4', 'Pass Through Entity EIN', 'TEXT'),
  (540287, 54018, '5', 'Net Elective Pymt Election Amt', 'CURRENCY'),
  (540288, 54018, '6', 'Gross Elective Pymt Election Amt', 'CURRENCY'),
  (540289, 54018, '7', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (540290, 54018, '8', 'Net Elective Pymt Election Amt', 'CURRENCY'),
  (540291, 54018, '9', 'Gross Elective Pymt Election Amt', 'CURRENCY'),
  (540292, 54018, '10', 'Gross Elective Pymt Election Amt', 'CURRENCY'),
  (540293, 54018, '11', 'EPE Eligible Cr App Tx Amt', 'CURRENCY'),
  (540294, 54018, '12', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (540295, 54018, '13', 'Net Elective Pymt Election Amt', 'CURRENCY'),
  (540296, 54018, '14', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (540297, 54018, '15', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (540298, 54018, '16', 'EPE Eligible Cr App Tx Amt', 'CURRENCY'),
  (540299, 54018, '17', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (540300, 54018, '18', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (540301, 54018, '19', 'EPE Eligible Cr App Tx Amt', 'CURRENCY'),
  (540302, 54018, '20', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (540303, 54018, '21', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (540304, 54018, '22', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (540305, 54018, '23', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (540306, 54018, '24', 'EPE Eligible Cr App Tx Amt', 'CURRENCY'),
  (540307, 54018, '25', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (540308, 54018, '26', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (540309, 54018, '27', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (540310, 54018, '28', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (540311, 54018, '29', 'EPE Eligible Cr App Tx Amt', 'CURRENCY'),
  (540312, 54018, '30', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (540313, 54018, '31', 'EPE Eligible Cr App Tx Amt', 'CURRENCY'),
  (540314, 54018, '32', 'Net Elective Pymt Election Amt', 'CURRENCY'),
  (540315, 54018, '33', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (540316, 54018, '34', 'EPE Eligible Cr App Tx Amt', 'CURRENCY'),
  (540317, 54018, '35', 'Net Elective Pymt Election Amt', 'CURRENCY'),
  (540318, 54018, '36', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (540319, 54018, '37', 'EPE Eligible Cr App Tx Amt', 'CURRENCY'),
  (540320, 54018, '38', 'Net Elective Pymt Election Amt', 'CURRENCY'),
  (540321, 54018, '39', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (540322, 54018, '40', 'EPE Eligible Cr App Tx Amt', 'CURRENCY'),
  (540323, 54018, '41', 'EPE Eligible Cr App Tx Amt', 'CURRENCY'),
  (540324, 54018, '42', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (540325, 54018, '43', 'EPE Eligible Cr App Tx Amt', 'CURRENCY'),
  (540326, 54018, '44', 'EPE Eligible Cr App Tx Amt', 'CURRENCY'),
  (540327, 54018, '45', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (540328, 54018, '46', 'EPE Eligible Cr App Tx Amt', 'CURRENCY'),
  (540329, 54018, '47', 'Net Elective Pymt Election Amt', 'CURRENCY'),
  (540330, 54018, '48', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (540331, 54018, '49', 'EPE Eligible Cr App Tx Amt', 'CURRENCY'),
  (540332, 54018, '50', 'Net Elective Pymt Election Amt', 'CURRENCY'),
  (540333, 54018, '51', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (540334, 54018, '52', 'EPE Eligible Cr App Tx Amt', 'CURRENCY'),
  (540335, 54018, '53', 'Net Elective Pymt Election Amt', 'CURRENCY'),
  (540336, 54018, '54', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (540337, 54018, '55', 'EPE Eligible Cr App Tx Amt', 'CURRENCY'),
  (540338, 54018, '56', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (540339, 54018, '57', 'EPE Eligible Cr App Tx Amt', 'CURRENCY'),
  (540340, 54018, '58', 'Net Elective Pymt Election Amt', 'CURRENCY'),
  (540341, 54018, '59', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (540342, 54018, '60', 'EPE Eligible Cr App Tx Amt', 'CURRENCY'),
  (540343, 54018, '61', 'Net Elective Pymt Election Amt', 'CURRENCY'),
  (540344, 54018, '62', 'EPE Eligible Cr App Tx Amt', 'CURRENCY'),
  (540345, 54018, '63', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (540346, 54018, '64', 'EPE Eligible Cr App Tx Amt', 'CURRENCY'),
  (540347, 54018, '65', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (540348, 54018, '66', 'EPE Eligible Cr App Tx Amt', 'CURRENCY'),
  (540349, 54018, '67', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (540350, 54018, '68', 'EPE Eligible Cr App Tx Amt', 'CURRENCY'),
  (540351, 54018, '69', 'EPE Eligible Cr App Tx Amt', 'CURRENCY'),
  (540352, 54018, '70', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (540353, 54018, '71', 'EPE Eligible Cr App Tx Amt', 'CURRENCY'),
  (540354, 54018, '72', 'Net Elective Pymt Election Amt', 'CURRENCY'),
  (540355, 54018, '73', 'EPE Eligible Cr App Tx Amt', 'CURRENCY'),
  (540356, 54018, '74', 'EPE Eligible Cr App Tx Amt', 'CURRENCY'),
  (540357, 54018, '75', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (540358, 54018, '76', 'EPE Eligible Cr App Tx Amt', 'CURRENCY'),
  (540359, 54018, '77', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (540360, 54018, '78', 'EPE Eligible Cr App Tx Amt', 'CURRENCY'),
  (540361, 54018, '79', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (540362, 54018, '80', 'EPE Eligible Cr App Tx Amt', 'CURRENCY'),
  (540363, 54018, '81', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (540364, 54018, '82', 'EPE Eligible Cr App Tx Amt', 'CURRENCY'),
  (540365, 54018, '83', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (540366, 54018, '84', 'EPE Eligible Cr App Tx Amt', 'CURRENCY'),
  (540367, 54018, '85', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (540368, 54018, '86', 'EPE Eligible Cr App Tx Amt', 'CURRENCY'),
  (540369, 54018, '87', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (540370, 54018, '88', 'EPE Eligible Cr App Tx Amt', 'CURRENCY'),
  (540371, 54018, '89', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (540372, 54018, '90', 'EPE Eligible Cr App Tx Amt', 'CURRENCY'),
  (540373, 54018, '91', 'EPE Eligible Cr App Tx Amt', 'CURRENCY'),
  (540374, 54018, '92', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (540375, 54018, '93', 'EPE Eligible Cr App Tx Amt', 'CURRENCY'),
  (540376, 54018, '94', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (540377, 54018, '95', 'EPE Eligible Cr App Tx Amt', 'CURRENCY'),
  (540378, 54018, '96', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (540379, 54018, '97', 'EPE Eligible Cr App Tx Amt', 'CURRENCY'),
  (540380, 54018, '98', 'Net Elective Pymt Election Amt', 'CURRENCY'),
  (540381, 54018, '99', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (540382, 54018, '100', 'EPE Eligible Cr App Tx Amt', 'CURRENCY'),
  (540383, 54018, '101', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (540384, 54018, '102', 'EPE Eligible Cr App Tx Amt', 'CURRENCY'),
  (540385, 54018, '103', 'Net Elective Pymt Election Amt', 'CURRENCY'),
  (540386, 54018, '104', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (540387, 54018, '105', 'EPE Eligible Cr App Tx Amt', 'CURRENCY'),
  (540388, 54018, '106', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (540389, 54018, '107', 'EPE Eligible Cr App Tx Amt', 'CURRENCY'),
  (540390, 54018, '108', 'EPE Eligible Cr App Tx Amt', 'CURRENCY'),
  (540391, 54018, '109', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (540392, 54018, '110', 'EPE Eligible Cr App Tx Amt', 'CURRENCY'),
  (540393, 54018, '111', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (540394, 54018, '112', 'EPE Eligible Cr App Tx Amt', 'CURRENCY'),
  (540395, 54018, '113', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (540396, 54018, '114', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (540397, 54018, '115', 'Gross Elective Pymt Election Amt', 'CURRENCY'),
  (540398, 54018, '116', 'Elective Payment Registration Num', 'INTEGER'),
  (540399, 54018, '117', 'Total General Bus Credits Amt', 'CURRENCY'),
  (540400, 54018, '118', 'Passive Activity Cr Before Lmt Amt', 'CURRENCY'),
  (540401, 54018, '119', 'Passive Activity Cr Before Lmt Amt', 'CURRENCY'),
  (540402, 54018, '120', 'Passive Activity Cr Before Lmt Amt', 'CURRENCY'),
  (540403, 54018, '121', 'Oth Thn Cr Trnsfr Elect Cr No Lmt Amt', 'CURRENCY'),
  (540404, 54018, '122', 'Passive Activity Cr Before Lmt Amt', 'CURRENCY'),
  (540405, 54018, '123', 'Total GBC Less Gross EPE App Tx Amt', 'CURRENCY'),
  (540406, 54018, '124', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (540407, 54018, '125', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (540408, 54018, '126', 'Cr Trnsfr Elect Cr Allw Aftr Lmt Amt', 'CURRENCY'),
  (540409, 54018, '127', 'EPE Eligible Cr App Tx Amt', 'CURRENCY'),
  (540410, 54018, '128', 'Oth Thn Cr Trnsfr Elect Cr Bfr Lmt Amt', 'CURRENCY'),
  (540411, 54018, '129', 'Oth Thn Cr Trnsfr Elect Cr No Lmt Amt', 'CURRENCY'),
  (540412, 54018, '130', 'PY Pssv Activity Cr Allwbl CY Amt', 'CURRENCY'),
  (540413, 54018, '131', 'Total GBC Less Gross EPE Amt', 'CURRENCY'),
  (540414, 54018, '132', 'Total GBC Less Gross EPE App Tx Amt', 'CURRENCY'),
  (540415, 54018, '133', 'Total General Bus Credits Amt', 'CURRENCY'),
  (540416, 54018, '134', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (540417, 54018, '135', 'Cr Trnsfr Elect Cr Allw Aftr Lmt Amt', 'CURRENCY'),
  (540418, 54018, '136', 'EPE Eligible Cr App Tx Amt', 'CURRENCY'),
  (540419, 54018, '137', 'Oth Thn Cr Trnsfr Elect Cr Bfr Lmt Amt', 'CURRENCY'),
  (540420, 54018, '138', 'Oth Thn Cr Trnsfr Elect Cr No Lmt Amt', 'CURRENCY'),
  (540421, 54018, '139', 'PY Pssv Activity Cr Allwbl CY Amt', 'CURRENCY'),
  (540422, 54018, '140', 'Total GBC Less Gross EPE Amt', 'CURRENCY'),
  (540423, 54018, '141', 'Total GBC Less Gross EPE App Tx Amt', 'CURRENCY'),
  (540424, 54018, '142', 'Total General Bus Credits Amt', 'CURRENCY'),
  (540425, 54018, '143', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (540426, 54018, '144', 'Cr Trnsfr Elect Cr Allw Aftr Lmt Amt', 'CURRENCY'),
  (540427, 54018, '145', 'EPE Eligible Cr App Tx Amt', 'CURRENCY'),
  (540428, 54018, '146', 'Oth Thn Cr Trnsfr Elect Cr Bfr Lmt Amt', 'CURRENCY'),
  (540429, 54018, '147', 'Oth Thn Cr Trnsfr Elect Cr No Lmt Amt', 'CURRENCY'),
  (540430, 54018, '148', 'PY Pssv Activity Cr Allwbl CY Amt', 'CURRENCY'),
  (540431, 54018, '149', 'Total GBC Less Gross EPE Amt', 'CURRENCY'),
  (540432, 54018, '150', 'Total GBC Less Gross EPE App Tx Amt', 'CURRENCY'),
  (540433, 54018, '151', 'Total General Bus Credits Amt', 'CURRENCY'),
  (540434, 54018, '152', 'Credit Transfer Election Amt', 'CURRENCY'),
  (540435, 54018, '153', 'Credit Transfer Election Amt', 'CURRENCY'),
  (540436, 54018, '154', 'Credit Transfer Election Amt', 'CURRENCY'),
  (540437, 54018, '155', 'Pass Through Entity EIN', 'TEXT'),
  (540438, 54018, '156', 'Pass Through Entity EIN', 'TEXT'),
  (540439, 54018, '157', 'Passive Activity Cr Before Lmt Amt', 'CURRENCY'),
  (540440, 54018, '158', 'Oth Thn Cr Trnsfr Elect Cr No Lmt Amt', 'CURRENCY'),
  (540441, 54018, '159', 'Total General Bus Credits Amt', 'CURRENCY'),
  (540442, 54018, '160', 'Total GBC Less Gross EPE Amt', 'CURRENCY'),
  (540443, 54018, '161', 'Total GBC Less Gross EPE App Tx Amt', 'CURRENCY'),
  (540444, 54018, '162', 'Total General Bus Credits Amt', 'CURRENCY'),
  (540445, 54018, '163', 'Total GBC Less Gross EPE App Tx Amt', 'CURRENCY'),
  (540446, 54018, '164', 'Oth Thn Cr Trnsfr Elect Cr No Lmt Amt', 'CURRENCY'),
  (540447, 54018, '165', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (540448, 54018, '166', 'Pass Through Entity EIN', 'TEXT'),
  (540449, 54018, '167', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (540450, 54018, '168', 'Elective Payment Registration Num', 'INTEGER'),
  (540451, 54018, '169', 'Total GBC Less Gross EPE App Tx Amt', 'CURRENCY'),
  (540452, 54018, '170', 'Total General Bus Credits Amt', 'CURRENCY'),
  (540453, 54018, '171', 'Oth Thn Cr Trnsfr Elect Cr Bfr Lmt Amt', 'CURRENCY'),
  (540454, 54018, '172', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (540455, 54018, '173', 'Total GBC Less Gross EPE App Tx Amt', 'CURRENCY'),
  (540456, 54018, '174', 'Total General Bus Credits Amt', 'CURRENCY'),
  (540457, 54018, '175', 'Oth Thn Cr Trnsfr Elect Cr No Lmt Amt', 'CURRENCY'),
  (540458, 54018, '176', 'Oth Thn Cr Trnsfr Elect Cr Bfr Lmt Amt', 'CURRENCY'),
  (540459, 54018, '177', 'Gross Elective Pymt Election Amt', 'CURRENCY'),
  (540460, 54018, '178', 'Passive Activity Cr Before Lmt Amt', 'CURRENCY'),
  (540461, 54018, '179', 'Passive Activity Cr Before Lmt Amt', 'CURRENCY'),
  (540462, 54018, '180', 'Oth Thn Cr Trnsfr Elect Cr Bfr Lmt Amt', 'CURRENCY'),
  (540463, 54018, '181', 'PY Pssv Activity Cr Allwbl CY Amt', 'CURRENCY'),
  (540464, 54018, '182', 'Oth Thn Cr Trnsfr Elect Cr No Lmt Amt', 'CURRENCY'),
  (540465, 54018, '183', 'Passive Activity Cr Before Lmt Amt', 'CURRENCY'),
  (540466, 54018, '184', 'Pass Through Entity EIN', 'TEXT'),
  (540467, 54018, '185', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (540468, 54018, '186', 'Total GBC Less Gross EPE App Tx Amt', 'CURRENCY'),
  (540469, 54018, '187', 'Total General Bus Credits Amt', 'CURRENCY'),
  (540470, 54018, '188', 'Oth Thn Cr Trnsfr Elect Cr No Lmt Amt', 'CURRENCY'),
  (540471, 54018, '189', 'Total GBC Less Gross EPE App Tx Amt', 'CURRENCY'),
  (540472, 54018, '190', 'Total General Bus Credits Amt', 'CURRENCY'),
  (540473, 54018, '191', 'Pass Through Entity EIN', 'TEXT'),
  (540474, 54018, '192', 'Pass Through Entity EIN', 'TEXT'),
  (540475, 54018, '193', 'Oth Thn Cr Trnsfr Elect Cr No Lmt Amt', 'CURRENCY'),
  (540476, 54018, '194', 'PY Pssv Activity Cr Allwbl CY Amt', 'CURRENCY'),
  (540477, 54018, '195', 'Oth Thn Cr Trnsfr Elect Cr No Lmt Amt', 'CURRENCY'),
  (540478, 54018, '196', 'Total GBC Less Gross EPE App Tx Amt', 'CURRENCY'),
  (540479, 54018, '197', 'Total General Bus Credits Amt', 'CURRENCY'),
  (540480, 54018, '198', 'Pass Through Entity EIN', 'TEXT'),
  (540481, 54018, '199', 'Cr Trnsfr Elect Cr Allw Aftr Lmt Amt', 'CURRENCY'),
  (540482, 54018, '200', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (540483, 54018, '201', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (540484, 54018, '202', 'Pass Through Entity EIN', 'TEXT'),
  (540485, 54018, '203', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (540486, 54018, '204', 'Passive Activity Cr Before Lmt Amt', 'CURRENCY'),
  (540487, 54018, '205', 'Passive Activity Cr Before Lmt Amt', 'CURRENCY'),
  (540488, 54018, '206', 'Transfer Credit Entity EIN', 'TEXT'),
  (540489, 54018, '207', 'Oth Thn Cr Trnsfr Elect Cr Bfr Lmt Amt', 'CURRENCY'),
  (540490, 54018, '208', 'Cr Trnsfr Elect Cr Allw Aftr Lmt Amt', 'CURRENCY'),
  (540491, 54018, '209', 'PY Pssv Activity Cr Allwbl CY Amt', 'CURRENCY'),
  (540492, 54018, '210', 'Pass Through Entity EIN', 'TEXT'),
  (540493, 54018, '211', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (540494, 54018, '212', 'Pass Through Entity EIN', 'TEXT'),
  (540495, 54018, '213', 'Oth Thn Cr Trnsfr Elect Cr No Lmt Amt', 'CURRENCY'),
  (540496, 54018, '214', 'Total GBC Less Gross EPE Amt', 'CURRENCY'),
  (540497, 54018, '215', 'Total GBC Less Gross EPE App Tx Amt', 'CURRENCY'),
  (540498, 54018, '216', 'Total General Bus Credits Amt', 'CURRENCY'),
  (540499, 54018, '217', 'Cr Trnsfr Elect Cr Prchs Bfr Lmt Amt', 'CURRENCY'),
  (540500, 54018, '218', 'Cr Trnsfr Elect Cr Sold Bfr Lmt Amt', 'CURRENCY'),
  (540501, 54018, '219', 'Prchs Trnsfr Elect Cr No Lmt Amt', 'CURRENCY'),
  (540502, 54018, '220', 'Trnsfr Elect Cr Sold No Lmt Amt', 'CURRENCY'),
  (540503, 54018, '221', 'Cr Trnsfr Elect Cr Prchs Bfr Lmt Amt', 'CURRENCY'),
  (540504, 54018, '222', 'Cr Trnsfr Elect Cr Sold Bfr Lmt Amt', 'CURRENCY'),
  (540505, 54018, '223', 'Prchs Trnsfr Elect Cr No Lmt Amt', 'CURRENCY'),
  (540506, 54018, '224', 'Trnsfr Elect Cr Sold No Lmt Amt', 'CURRENCY'),
  (540507, 54018, '225', 'Pass Through Entity EIN', 'TEXT'),
  (540508, 54018, '226', 'Cr Trnsfr Elect Cr Prchs Bfr Lmt Amt', 'CURRENCY'),
  (540509, 54018, '227', 'Cr Trnsfr Elect Cr Sold Bfr Lmt Amt', 'CURRENCY'),
  (540510, 54018, '228', 'Prchs Trnsfr Elect Cr No Lmt Amt', 'CURRENCY'),
  (540511, 54018, '229', 'Trnsfr Elect Cr Sold No Lmt Amt', 'CURRENCY'),
  (540512, 54018, '230', 'Cr Trnsfr Elect Cr Allw Aftr Lmt Amt', 'CURRENCY'),
  (540513, 54018, '231', 'Cr Trnsfr Elect Cr Prchs Bfr Lmt Amt', 'CURRENCY'),
  (540514, 54018, '232', 'Cr Trnsfr Elect Cr Sold Bfr Lmt Amt', 'CURRENCY'),
  (540515, 54018, '233', 'Oth Thn Cr Trnsfr Elect Cr Bfr Lmt Amt', 'CURRENCY'),
  (540516, 54018, '234', 'Prchs Trnsfr Elect Cr No Lmt Amt', 'CURRENCY'),
  (540517, 54018, '235', 'Trnsfr Elect Cr Sold No Lmt Amt', 'CURRENCY'),
  (540518, 54018, '236', 'Pass Through Entity EIN', 'TEXT'),
  (540519, 54018, '237', 'Passive Activity Cr Before Lmt Amt', 'CURRENCY'),
  (540520, 54018, '238', 'Oth Thn Cr Trnsfr Elect Cr Bfr Lmt Amt', 'CURRENCY'),
  (540521, 54018, '239', 'Pass Through Entity EIN', 'TEXT'),
  (540522, 54018, '240', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (540523, 54018, '241', 'Passive Activity Cr Before Lmt Amt', 'CURRENCY'),
  (540524, 54018, '242', 'Elective Payment Registration Num', 'INTEGER'),
  (540525, 54018, '243', 'Net Elective Pymt Election Amt', 'CURRENCY'),
  (540526, 54018, '244', 'Cr Trnsfr Elect Cr Allw Aftr Lmt Amt', 'CURRENCY'),
  (540527, 54018, '245', 'Pass Through Entity EIN', 'TEXT'),
  (540528, 54018, '246', 'Cr Trnsfr Elect Cr Allw Aftr Lmt Amt', 'CURRENCY'),
  (540529, 54018, '247', 'Oth Thn Cr Trnsfr Elect Cr No Lmt Amt', 'CURRENCY'),
  (540530, 54018, '248', 'Total General Bus Credits Amt', 'CURRENCY'),
  (540531, 54018, '249', 'Oth Thn Cr Trnsfr Elect Cr No Lmt Amt', 'CURRENCY'),
  (540532, 54018, '250', 'Total GBC Less Gross EPE App Tx Amt', 'CURRENCY'),
  (540533, 54018, '251', 'Total General Bus Credits Amt', 'CURRENCY'),
  (540534, 54018, '252', 'Cr Trnsfr Elect Cr Allw Aftr Lmt Amt', 'CURRENCY'),
  (540535, 54018, '253', 'Oth Thn Cr Trnsfr Elect Cr No Lmt Amt', 'CURRENCY'),
  (540536, 54018, '254', 'Pass Through Entity EIN', 'TEXT'),
  (540537, 54018, '255', 'Total GBC Less Gross EPE App Tx Amt', 'CURRENCY'),
  (540538, 54018, '256', 'Total General Bus Credits Amt', 'CURRENCY'),
  (540539, 54018, '257', 'Passive Activity Cr Before Lmt Amt', 'CURRENCY'),
  (540540, 54018, '258', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (540541, 54018, '259', 'Oth Thn Cr Trnsfr Elect Cr Bfr Lmt Amt', 'CURRENCY'),
  (540542, 54018, '260', 'Total GBC Less Gross EPE App Tx Amt', 'CURRENCY'),
  (540543, 54018, '261', 'Total General Bus Credits Amt', 'CURRENCY'),
  (540544, 54018, '262', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (540545, 54018, '263', 'Passive Activity Cr Before Lmt Amt', 'CURRENCY'),
  (540546, 54018, '264', 'Pass Through Entity EIN', 'TEXT'),
  (540547, 54018, '265', 'Passive Activity Cr Before Lmt Amt', 'CURRENCY'),
  (540548, 54018, '266', 'Pass Through Entity EIN', 'TEXT'),
  (540549, 54018, '267', 'Passive Activity Cr Before Lmt Amt', 'CURRENCY'),
  (540550, 54018, '268', 'PY Pssv Activity Cr Allwbl CY Amt', 'CURRENCY'),
  (540551, 54018, '269', 'PY Pssv Activity Cr Allwbl CY Amt', 'CURRENCY'),
  (540552, 54018, '270', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (540553, 54018, '271', 'Passive Activity Cr Before Lmt Amt', 'CURRENCY'),
  (540554, 54018, '272', 'PY Pssv Activity Cr Allwbl CY Amt', 'CURRENCY'),
  (540555, 54018, '273', 'Pass Through Entity EIN', 'TEXT'),
  (540556, 54018, '274', 'Passive Activity Cr Before Lmt Amt', 'CURRENCY'),
  (540557, 54018, '275', 'Oth Thn Cr Trnsfr Elect Cr No Lmt Amt', 'CURRENCY'),
  (540558, 54018, '276', 'Pass Through Entity EIN', 'TEXT'),
  (540559, 54018, '277', 'Total GBC Less Gross EPE Amt', 'CURRENCY'),
  (540560, 54018, '278', 'Total GBC Less Gross EPE App Tx Amt', 'CURRENCY'),
  (540561, 54018, '279', 'Total General Bus Credits Amt', 'CURRENCY'),
  (540562, 54018, '280', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (540563, 54018, '281', 'Total GBC Less Gross EPE App Tx Amt', 'CURRENCY'),
  (540564, 54018, '282', 'Passive Activity Cr Before Lmt Amt', 'CURRENCY'),
  (540565, 54018, '283', 'Oth Thn Cr Trnsfr Elect Cr No Lmt Amt', 'CURRENCY'),
  (540566, 54018, '284', 'Pass Through Entity EIN', 'TEXT'),
  (540567, 54018, '285', 'Total GBC Less Gross EPE App Tx Amt', 'CURRENCY'),
  (540568, 54018, '286', 'Total General Bus Credits Amt', 'CURRENCY'),
  (540569, 54018, '287', 'Pass Through Entity EIN', 'TEXT'),
  (540570, 54018, '288', 'Passive Activity Cr Before Lmt Amt', 'CURRENCY'),
  (540571, 54018, '289', 'Pass Through Entity EIN', 'TEXT'),
  (540572, 54018, '290', 'Oth Thn Cr Trnsfr Elect Cr Bfr Lmt Amt', 'CURRENCY'),
  (540573, 54018, '291', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (540574, 54018, '292', 'Oth Thn Cr Trnsfr Elect Cr No Lmt Amt', 'CURRENCY'),
  (540575, 54018, '293', 'PY Pssv Activity Cr Allwbl CY Amt', 'CURRENCY'),
  (540576, 54018, '294', 'Total GBC Less Gross EPE App Tx Amt', 'CURRENCY'),
  (540577, 54018, '295', 'Total General Bus Credits Amt', 'CURRENCY'),
  (540578, 54018, '296', 'Elective Payment Registration Num', 'INTEGER'),
  (540579, 54018, '297', 'Gross Elective Pymt Election Amt', 'CURRENCY'),
  (540580, 54018, '298', 'Oth Thn Cr Trnsfr Elect Cr No Lmt Amt', 'CURRENCY'),
  (540581, 54018, '299', 'Total GBC Less Gross EPE Amt', 'CURRENCY'),
  (540582, 54018, '300', 'Total GBC Less Gross EPE App Tx Amt', 'CURRENCY'),
  (540583, 54018, '301', 'Total General Bus Credits Amt', 'CURRENCY'),
  (540584, 54018, '302', 'Gross Elective Pymt Election Amt', 'CURRENCY'),
  (540585, 54018, '303', 'Cr Trnsfr Elect Cr Allw Aftr Lmt Amt', 'CURRENCY'),
  (540586, 54018, '304', 'Cr Trnsfr Elect Cr Prchs Bfr Lmt Amt', 'CURRENCY'),
  (540587, 54018, '305', 'Cr Trnsfr Elect Cr Sold Bfr Lmt Amt', 'CURRENCY'),
  (540588, 54018, '306', 'Missing EIN Reason Cd', 'TEXT'),
  (540589, 54018, '307', 'Oth Thn Cr Trnsfr Elect Cr Bfr Lmt Amt', 'CURRENCY'),
  (540590, 54018, '308', 'PY Pssv Activity Cr Allwbl CY Amt', 'CURRENCY'),
  (540591, 54018, '309', 'Cr Trnsfr Elect Cr Allw Aftr Lmt Amt', 'CURRENCY'),
  (540592, 54018, '310', 'Oth Thn Cr Trnsfr Elect Cr No Lmt Amt', 'CURRENCY'),
  (540593, 54018, '311', 'PY Pssv Activity Cr Allwbl CY Amt', 'CURRENCY'),
  (540594, 54018, '312', 'PY Pssv Activity Cr Allwbl CY Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (540283, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm6765CYAggrgtAmtGrp/PassThroughEntityEIN'),
  (540284, NULL, NULL, 'Net Elective Pymt Election Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm3468PartVICYAggrgtAmtGrp/NetElectivePymtElectionAmt'),
  (540285, NULL, NULL, 'Net Elective Pymt Election Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/TotGenBusCYAggrgtAmtGrp/NetElectivePymtElectionAmt'),
  (540286, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8846CYAggrgtAmtGrp/PassThroughEntityEIN'),
  (540287, NULL, NULL, 'Net Elective Pymt Election Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/GenBusCYAggrgtSubTotGrp/NetElectivePymtElectionAmt'),
  (540288, NULL, NULL, 'Gross Elective Pymt Election Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/TotGenBusCYAggrgtAmtGrp/GrossElectivePymtElectionAmt'),
  (540289, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm6765CYAggrgtAmtGrp/CarryforwardGeneralBusCrAmt'),
  (540290, NULL, NULL, 'Net Elective Pymt Election Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/GenBusCYAggrgtSubTot2Grp/NetElectivePymtElectionAmt'),
  (540291, NULL, NULL, 'Gross Elective Pymt Election Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/GenBusCYAggrgtSubTot2Grp/GrossElectivePymtElectionAmt'),
  (540292, NULL, NULL, 'Gross Elective Pymt Election Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/GenBusCYAggrgtSubTotGrp/GrossElectivePymtElectionAmt'),
  (540293, NULL, NULL, 'EPE Eligible Cr App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm3468PartVICYAggrgtAmtGrp/EPEEligibleCrAppTxAmt'),
  (540294, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm3468PartVICYAggrgtAmtGrp/CarryforwardGeneralBusCrAmt'),
  (540295, NULL, NULL, 'Net Elective Pymt Election Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8936PartVCYAggrgtAmtGrp/NetElectivePymtElectionAmt'),
  (540296, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8846CYAggrgtAmtGrp/CarryforwardGeneralBusCrAmt'),
  (540297, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm5884CYAggrgtAmtGrp/CarryforwardGeneralBusCrAmt'),
  (540298, NULL, NULL, 'EPE Eligible Cr App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm6765CYAggrgtAmtGrp/EPEEligibleCrAppTxAmt'),
  (540299, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8586CYAggrgtAmtGrp/CarryforwardGeneralBusCrAmt'),
  (540300, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8936PartVCYAggrgtAmtGrp/CarryforwardGeneralBusCrAmt'),
  (540301, NULL, NULL, 'EPE Eligible Cr App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8936PartVCYAggrgtAmtGrp/EPEEligibleCrAppTxAmt'),
  (540302, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8904CYAggrgtAmtGrp/CarryforwardGeneralBusCrAmt'),
  (540303, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8835PartIICYAggrgtAmtGrp/CarryforwardGeneralBusCrAmt'),
  (540304, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm6765ESBCYAggrgtAmtGrp/CarryforwardGeneralBusCrAmt'),
  (540305, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8844CYAggrgtAmtGrp/CarryforwardGeneralBusCrAmt'),
  (540306, NULL, NULL, 'EPE Eligible Cr App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8846CYAggrgtAmtGrp/EPEEligibleCrAppTxAmt'),
  (540307, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8864CYAggrgtAmtGrp/CarryforwardGeneralBusCrAmt'),
  (540308, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8994CYAggrgtAmtGrp/CarryforwardGeneralBusCrAmt'),
  (540309, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/TotGenBusCYAggrgtAmtGrp/GeneralBusCrFromNnPssvActyAmt'),
  (540310, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm3468PartIICYAggrgtAmtGrp/CarryforwardGeneralBusCrAmt'),
  (540311, NULL, NULL, 'EPE Eligible Cr App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm3468PartIICYAggrgtAmtGrp/EPEEligibleCrAppTxAmt'),
  (540312, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm3468PartIIICYAggrgtAmtGrp/CarryforwardGeneralBusCrAmt'),
  (540313, NULL, NULL, 'EPE Eligible Cr App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm3468PartIIICYAggrgtAmtGrp/EPEEligibleCrAppTxAmt'),
  (540314, NULL, NULL, 'Net Elective Pymt Election Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm3468PartIIICYAggrgtAmtGrp/NetElectivePymtElectionAmt'),
  (540315, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm3468PartIVCYAggrgtAmtGrp/CarryforwardGeneralBusCrAmt'),
  (540316, NULL, NULL, 'EPE Eligible Cr App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm3468PartIVCYAggrgtAmtGrp/EPEEligibleCrAppTxAmt'),
  (540317, NULL, NULL, 'Net Elective Pymt Election Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm3468PartIVCYAggrgtAmtGrp/NetElectivePymtElectionAmt'),
  (540318, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm3468PartVCYAggrgtAmtGrp/CarryforwardGeneralBusCrAmt'),
  (540319, NULL, NULL, 'EPE Eligible Cr App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm3468PartVCYAggrgtAmtGrp/EPEEligibleCrAppTxAmt'),
  (540320, NULL, NULL, 'Net Elective Pymt Election Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm3468PartVCYAggrgtAmtGrp/NetElectivePymtElectionAmt'),
  (540321, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm3468PartVIICYAggrgtAmtGrp/CarryforwardGeneralBusCrAmt'),
  (540322, NULL, NULL, 'EPE Eligible Cr App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm3468PartVIICYAggrgtAmtGrp/EPEEligibleCrAppTxAmt'),
  (540323, NULL, NULL, 'EPE Eligible Cr App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm5884CYAggrgtAmtGrp/EPEEligibleCrAppTxAmt'),
  (540324, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm6478CYSpcfdCrAggrgtGrp/CarryforwardGeneralBusCrAmt'),
  (540325, NULL, NULL, 'EPE Eligible Cr App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm6478CYSpcfdCrAggrgtGrp/EPEEligibleCrAppTxAmt'),
  (540326, NULL, NULL, 'EPE Eligible Cr App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm6765ESBCYAggrgtAmtGrp/EPEEligibleCrAppTxAmt'),
  (540327, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm7207CYAggrgtAmtGrp/CarryforwardGeneralBusCrAmt'),
  (540328, NULL, NULL, 'EPE Eligible Cr App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm7207CYAggrgtAmtGrp/EPEEligibleCrAppTxAmt'),
  (540329, NULL, NULL, 'Net Elective Pymt Election Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm7207CYAggrgtAmtGrp/NetElectivePymtElectionAmt'),
  (540330, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm7210CYAggrgtAmtGrp/CarryforwardGeneralBusCrAmt'),
  (540331, NULL, NULL, 'EPE Eligible Cr App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm7210CYAggrgtAmtGrp/EPEEligibleCrAppTxAmt'),
  (540332, NULL, NULL, 'Net Elective Pymt Election Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm7210CYAggrgtAmtGrp/NetElectivePymtElectionAmt'),
  (540333, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm7211PartIICYAggrgtAmtGrp/CarryforwardGeneralBusCrAmt'),
  (540334, NULL, NULL, 'EPE Eligible Cr App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm7211PartIICYAggrgtAmtGrp/EPEEligibleCrAppTxAmt'),
  (540335, NULL, NULL, 'Net Elective Pymt Election Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm7211PartIICYAggrgtAmtGrp/NetElectivePymtElectionAmt'),
  (540336, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm7213PartICYAggrgtAmtGrp/CarryforwardGeneralBusCrAmt'),
  (540337, NULL, NULL, 'EPE Eligible Cr App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm7213PartICYAggrgtAmtGrp/EPEEligibleCrAppTxAmt'),
  (540338, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm7213PartIICYAggrgtAmtGrp/CarryforwardGeneralBusCrAmt'),
  (540339, NULL, NULL, 'EPE Eligible Cr App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm7213PartIICYAggrgtAmtGrp/EPEEligibleCrAppTxAmt'),
  (540340, NULL, NULL, 'Net Elective Pymt Election Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm7213PartIICYAggrgtAmtGrp/NetElectivePymtElectionAmt'),
  (540341, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm7218PartIICYAggrgtAmtGrp/CarryforwardGeneralBusCrAmt'),
  (540342, NULL, NULL, 'EPE Eligible Cr App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm7218PartIICYAggrgtAmtGrp/EPEEligibleCrAppTxAmt'),
  (540343, NULL, NULL, 'Net Elective Pymt Election Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm7218PartIICYAggrgtAmtGrp/NetElectivePymtElectionAmt'),
  (540344, NULL, NULL, 'EPE Eligible Cr App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8586CYAggrgtAmtGrp/EPEEligibleCrAppTxAmt'),
  (540345, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8820CYAggrgtAmtGrp/CarryforwardGeneralBusCrAmt'),
  (540346, NULL, NULL, 'EPE Eligible Cr App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8820CYAggrgtAmtGrp/EPEEligibleCrAppTxAmt'),
  (540347, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8826CYAggrgtAmtGrp/CarryforwardGeneralBusCrAmt'),
  (540348, NULL, NULL, 'EPE Eligible Cr App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8826CYAggrgtAmtGrp/EPEEligibleCrAppTxAmt'),
  (540349, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8830CYAggrgtAmtGrp/CarryforwardGeneralBusCrAmt'),
  (540350, NULL, NULL, 'EPE Eligible Cr App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8830CYAggrgtAmtGrp/EPEEligibleCrAppTxAmt'),
  (540351, NULL, NULL, 'EPE Eligible Cr App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8835PartIICYAggrgtAmtGrp/EPEEligibleCrAppTxAmt'),
  (540352, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8835PartIICYSpcfdAmtGrp/CarryforwardGeneralBusCrAmt'),
  (540353, NULL, NULL, 'EPE Eligible Cr App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8835PartIICYSpcfdAmtGrp/EPEEligibleCrAppTxAmt'),
  (540354, NULL, NULL, 'Net Elective Pymt Election Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8835PartIICYSpcfdAmtGrp/NetElectivePymtElectionAmt'),
  (540355, NULL, NULL, 'EPE Eligible Cr App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8844CYAggrgtAmtGrp/EPEEligibleCrAppTxAmt'),
  (540356, NULL, NULL, 'EPE Eligible Cr App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8864CYAggrgtAmtGrp/EPEEligibleCrAppTxAmt'),
  (540357, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8864SAFCYAggrgtAmtGrp/CarryforwardGeneralBusCrAmt'),
  (540358, NULL, NULL, 'EPE Eligible Cr App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8864SAFCYAggrgtAmtGrp/EPEEligibleCrAppTxAmt'),
  (540359, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8874CYAggrgtAmtGrp/CarryforwardGeneralBusCrAmt'),
  (540360, NULL, NULL, 'EPE Eligible Cr App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8874CYAggrgtAmtGrp/EPEEligibleCrAppTxAmt'),
  (540361, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8881PartICYAggrgtAmtGrp/CarryforwardGeneralBusCrAmt'),
  (540362, NULL, NULL, 'EPE Eligible Cr App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8881PartICYAggrgtAmtGrp/EPEEligibleCrAppTxAmt'),
  (540363, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8881PartIICYAggrgtAmtGrp/CarryforwardGeneralBusCrAmt'),
  (540364, NULL, NULL, 'EPE Eligible Cr App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8881PartIICYAggrgtAmtGrp/EPEEligibleCrAppTxAmt'),
  (540365, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8881PartIIICYAggrgtAmtGrp/CarryforwardGeneralBusCrAmt'),
  (540366, NULL, NULL, 'EPE Eligible Cr App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8881PartIIICYAggrgtAmtGrp/EPEEligibleCrAppTxAmt'),
  (540367, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8882CYAggrgtAmtGrp/CarryforwardGeneralBusCrAmt'),
  (540368, NULL, NULL, 'EPE Eligible Cr App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8882CYAggrgtAmtGrp/EPEEligibleCrAppTxAmt'),
  (540369, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8896CYAggrgtAmtGrp/CarryforwardGeneralBusCrAmt'),
  (540370, NULL, NULL, 'EPE Eligible Cr App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8896CYAggrgtAmtGrp/EPEEligibleCrAppTxAmt'),
  (540371, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8900CYAggrgtAmtGrp/CarryforwardGeneralBusCrAmt'),
  (540372, NULL, NULL, 'EPE Eligible Cr App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8900CYAggrgtAmtGrp/EPEEligibleCrAppTxAmt'),
  (540373, NULL, NULL, 'EPE Eligible Cr App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8904CYAggrgtAmtGrp/EPEEligibleCrAppTxAmt'),
  (540374, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8906CYAggrgtAmtGrp/CarryforwardGeneralBusCrAmt'),
  (540375, NULL, NULL, 'EPE Eligible Cr App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8906CYAggrgtAmtGrp/EPEEligibleCrAppTxAmt'),
  (540376, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8908CYAggrgtAmtGrp/CarryforwardGeneralBusCrAmt'),
  (540377, NULL, NULL, 'EPE Eligible Cr App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8908CYAggrgtAmtGrp/EPEEligibleCrAppTxAmt'),
  (540378, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8911PartICYAggrgtAmtGrp/CarryforwardGeneralBusCrAmt'),
  (540379, NULL, NULL, 'EPE Eligible Cr App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8911PartICYAggrgtAmtGrp/EPEEligibleCrAppTxAmt'),
  (540380, NULL, NULL, 'Net Elective Pymt Election Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8911PartICYAggrgtAmtGrp/NetElectivePymtElectionAmt'),
  (540381, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8932CYAggrgtAmtGrp/CarryforwardGeneralBusCrAmt'),
  (540382, NULL, NULL, 'EPE Eligible Cr App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8932CYAggrgtAmtGrp/EPEEligibleCrAppTxAmt'),
  (540383, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8933CYAggrgtAmtGrp/CarryforwardGeneralBusCrAmt'),
  (540384, NULL, NULL, 'EPE Eligible Cr App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8933CYAggrgtAmtGrp/EPEEligibleCrAppTxAmt'),
  (540385, NULL, NULL, 'Net Elective Pymt Election Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8933CYAggrgtAmtGrp/NetElectivePymtElectionAmt'),
  (540386, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8936PartIICYAggrgtAmtGrp/CarryforwardGeneralBusCrAmt'),
  (540387, NULL, NULL, 'EPE Eligible Cr App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8936PartIICYAggrgtAmtGrp/EPEEligibleCrAppTxAmt'),
  (540388, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8941CYAggrgtAmtGrp/CarryforwardGeneralBusCrAmt'),
  (540389, NULL, NULL, 'EPE Eligible Cr App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8941CYAggrgtAmtGrp/EPEEligibleCrAppTxAmt'),
  (540390, NULL, NULL, 'EPE Eligible Cr App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8994CYAggrgtAmtGrp/EPEEligibleCrAppTxAmt'),
  (540391, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/GenBusOthSpcfdCrCYAggrgtAmtGrp/CarryforwardGeneralBusCrAmt'),
  (540392, NULL, NULL, 'EPE Eligible Cr App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/GenBusOthSpcfdCrCYAggrgtAmtGrp/EPEEligibleCrAppTxAmt'),
  (540393, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/GenBusOtherCrCYAggrgtAmtGrp/CarryforwardGeneralBusCrAmt'),
  (540394, NULL, NULL, 'EPE Eligible Cr App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/GenBusOtherCrCYAggrgtAmtGrp/EPEEligibleCrAppTxAmt'),
  (540395, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/GenBusCYAggrgtSubTotGrp/GeneralBusCrFromNnPssvActyAmt'),
  (540396, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/GenBusCYAggrgtSubTot2Grp/GeneralBusCrFromNnPssvActyAmt'),
  (540397, NULL, NULL, 'Gross Elective Pymt Election Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm3468PartVICYAggrgtAmtGrp/GrossElectivePymtElectionAmt'),
  (540398, NULL, NULL, 'Elective Payment Registration Num', 'INTEGER', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm3468PartVICYAggrgtAmtGrp/ElectivePaymentRegistrationNum'),
  (540399, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm6765CYAggrgtAmtGrp/TotalGeneralBusCreditsAmt'),
  (540400, NULL, NULL, 'Passive Activity Cr Before Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/GenBusCYAggrgtSubTotGrp/PassiveActivityCrBeforeLmtAmt'),
  (540401, NULL, NULL, 'Passive Activity Cr Before Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/TotGenBusCYAggrgtAmtGrp/PassiveActivityCrBeforeLmtAmt'),
  (540402, NULL, NULL, 'Passive Activity Cr Before Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/GenBusCYAggrgtSubTot2Grp/PassiveActivityCrBeforeLmtAmt'),
  (540403, NULL, NULL, 'Oth Thn Cr Trnsfr Elect Cr No Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm6765CYAggrgtAmtGrp/OthThnCrTrnsfrElectCrNoLmtAmt'),
  (540404, NULL, NULL, 'Passive Activity Cr Before Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm6765CYAggrgtAmtGrp/PassiveActivityCrBeforeLmtAmt'),
  (540405, NULL, NULL, 'Total GBC Less Gross EPE App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm6765CYAggrgtAmtGrp/TotalGBCLessGrossEPEAppTxAmt'),
  (540406, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm6765CYAggrgtAmtGrp/GeneralBusCrFromNnPssvActyAmt'),
  (540407, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/GenBusCYAggrgtSubTot2Grp/CarryforwardGeneralBusCrAmt'),
  (540408, NULL, NULL, 'Cr Trnsfr Elect Cr Allw Aftr Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/GenBusCYAggrgtSubTot2Grp/CrTrnsfrElectCrAllwAftrLmtAmt'),
  (540409, NULL, NULL, 'EPE Eligible Cr App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/GenBusCYAggrgtSubTot2Grp/EPEEligibleCrAppTxAmt'),
  (540410, NULL, NULL, 'Oth Thn Cr Trnsfr Elect Cr Bfr Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/GenBusCYAggrgtSubTot2Grp/OthThnCrTrnsfrElectCrBfrLmtAmt'),
  (540411, NULL, NULL, 'Oth Thn Cr Trnsfr Elect Cr No Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/GenBusCYAggrgtSubTot2Grp/OthThnCrTrnsfrElectCrNoLmtAmt'),
  (540412, NULL, NULL, 'PY Pssv Activity Cr Allwbl CY Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/GenBusCYAggrgtSubTot2Grp/PYPssvActivityCrAllwblCYAmt'),
  (540413, NULL, NULL, 'Total GBC Less Gross EPE Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/GenBusCYAggrgtSubTot2Grp/TotalGBCLessGrossEPEAmt'),
  (540414, NULL, NULL, 'Total GBC Less Gross EPE App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/GenBusCYAggrgtSubTot2Grp/TotalGBCLessGrossEPEAppTxAmt'),
  (540415, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/GenBusCYAggrgtSubTot2Grp/TotalGeneralBusCreditsAmt'),
  (540416, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/GenBusCYAggrgtSubTotGrp/CarryforwardGeneralBusCrAmt'),
  (540417, NULL, NULL, 'Cr Trnsfr Elect Cr Allw Aftr Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/GenBusCYAggrgtSubTotGrp/CrTrnsfrElectCrAllwAftrLmtAmt'),
  (540418, NULL, NULL, 'EPE Eligible Cr App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/GenBusCYAggrgtSubTotGrp/EPEEligibleCrAppTxAmt'),
  (540419, NULL, NULL, 'Oth Thn Cr Trnsfr Elect Cr Bfr Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/GenBusCYAggrgtSubTotGrp/OthThnCrTrnsfrElectCrBfrLmtAmt'),
  (540420, NULL, NULL, 'Oth Thn Cr Trnsfr Elect Cr No Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/GenBusCYAggrgtSubTotGrp/OthThnCrTrnsfrElectCrNoLmtAmt'),
  (540421, NULL, NULL, 'PY Pssv Activity Cr Allwbl CY Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/GenBusCYAggrgtSubTotGrp/PYPssvActivityCrAllwblCYAmt'),
  (540422, NULL, NULL, 'Total GBC Less Gross EPE Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/GenBusCYAggrgtSubTotGrp/TotalGBCLessGrossEPEAmt'),
  (540423, NULL, NULL, 'Total GBC Less Gross EPE App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/GenBusCYAggrgtSubTotGrp/TotalGBCLessGrossEPEAppTxAmt'),
  (540424, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/GenBusCYAggrgtSubTotGrp/TotalGeneralBusCreditsAmt'),
  (540425, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/TotGenBusCYAggrgtAmtGrp/CarryforwardGeneralBusCrAmt'),
  (540426, NULL, NULL, 'Cr Trnsfr Elect Cr Allw Aftr Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/TotGenBusCYAggrgtAmtGrp/CrTrnsfrElectCrAllwAftrLmtAmt'),
  (540427, NULL, NULL, 'EPE Eligible Cr App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/TotGenBusCYAggrgtAmtGrp/EPEEligibleCrAppTxAmt'),
  (540428, NULL, NULL, 'Oth Thn Cr Trnsfr Elect Cr Bfr Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/TotGenBusCYAggrgtAmtGrp/OthThnCrTrnsfrElectCrBfrLmtAmt'),
  (540429, NULL, NULL, 'Oth Thn Cr Trnsfr Elect Cr No Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/TotGenBusCYAggrgtAmtGrp/OthThnCrTrnsfrElectCrNoLmtAmt'),
  (540430, NULL, NULL, 'PY Pssv Activity Cr Allwbl CY Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/TotGenBusCYAggrgtAmtGrp/PYPssvActivityCrAllwblCYAmt'),
  (540431, NULL, NULL, 'Total GBC Less Gross EPE Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/TotGenBusCYAggrgtAmtGrp/TotalGBCLessGrossEPEAmt'),
  (540432, NULL, NULL, 'Total GBC Less Gross EPE App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/TotGenBusCYAggrgtAmtGrp/TotalGBCLessGrossEPEAppTxAmt'),
  (540433, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/TotGenBusCYAggrgtAmtGrp/TotalGeneralBusCreditsAmt'),
  (540434, NULL, NULL, 'Credit Transfer Election Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/GenBusCYAggrgtSubTot2Grp/CreditTransferElectionAmt'),
  (540435, NULL, NULL, 'Credit Transfer Election Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/GenBusCYAggrgtSubTotGrp/CreditTransferElectionAmt'),
  (540436, NULL, NULL, 'Credit Transfer Election Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/TotGenBusCYAggrgtAmtGrp/CreditTransferElectionAmt'),
  (540437, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm6765ESBCYAggrgtAmtGrp/PassThroughEntityEIN'),
  (540438, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm5884CYAggrgtAmtGrp/PassThroughEntityEIN'),
  (540439, NULL, NULL, 'Passive Activity Cr Before Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8846CYAggrgtAmtGrp/PassiveActivityCrBeforeLmtAmt'),
  (540440, NULL, NULL, 'Oth Thn Cr Trnsfr Elect Cr No Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm3468PartVICYAggrgtAmtGrp/OthThnCrTrnsfrElectCrNoLmtAmt'),
  (540441, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm3468PartVICYAggrgtAmtGrp/TotalGeneralBusCreditsAmt'),
  (540442, NULL, NULL, 'Total GBC Less Gross EPE Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm3468PartVICYAggrgtAmtGrp/TotalGBCLessGrossEPEAmt'),
  (540443, NULL, NULL, 'Total GBC Less Gross EPE App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm3468PartVICYAggrgtAmtGrp/TotalGBCLessGrossEPEAppTxAmt'),
  (540444, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8846CYAggrgtAmtGrp/TotalGeneralBusCreditsAmt'),
  (540445, NULL, NULL, 'Total GBC Less Gross EPE App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8846CYAggrgtAmtGrp/TotalGBCLessGrossEPEAppTxAmt'),
  (540446, NULL, NULL, 'Oth Thn Cr Trnsfr Elect Cr No Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8846CYAggrgtAmtGrp/OthThnCrTrnsfrElectCrNoLmtAmt'),
  (540447, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8846CYAggrgtAmtGrp/GeneralBusCrFromNnPssvActyAmt'),
  (540448, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8586CYAggrgtAmtGrp/PassThroughEntityEIN'),
  (540449, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm3468PartVICYAggrgtAmtGrp/GeneralBusCrFromNnPssvActyAmt'),
  (540450, NULL, NULL, 'Elective Payment Registration Num', 'INTEGER', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8936PartVCYAggrgtAmtGrp/ElectivePaymentRegistrationNum'),
  (540451, NULL, NULL, 'Total GBC Less Gross EPE App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm5884CYAggrgtAmtGrp/TotalGBCLessGrossEPEAppTxAmt'),
  (540452, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm5884CYAggrgtAmtGrp/TotalGeneralBusCreditsAmt'),
  (540453, NULL, NULL, 'Oth Thn Cr Trnsfr Elect Cr Bfr Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm6765CYAggrgtAmtGrp/OthThnCrTrnsfrElectCrBfrLmtAmt'),
  (540454, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8936PartVCYAggrgtAmtGrp/GeneralBusCrFromNnPssvActyAmt'),
  (540455, NULL, NULL, 'Total GBC Less Gross EPE App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm6765ESBCYAggrgtAmtGrp/TotalGBCLessGrossEPEAppTxAmt'),
  (540456, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm6765ESBCYAggrgtAmtGrp/TotalGeneralBusCreditsAmt'),
  (540457, NULL, NULL, 'Oth Thn Cr Trnsfr Elect Cr No Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm5884CYAggrgtAmtGrp/OthThnCrTrnsfrElectCrNoLmtAmt'),
  (540458, NULL, NULL, 'Oth Thn Cr Trnsfr Elect Cr Bfr Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm6765ESBCYAggrgtAmtGrp/OthThnCrTrnsfrElectCrBfrLmtAmt'),
  (540459, NULL, NULL, 'Gross Elective Pymt Election Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8936PartVCYAggrgtAmtGrp/GrossElectivePymtElectionAmt'),
  (540460, NULL, NULL, 'Passive Activity Cr Before Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm5884CYAggrgtAmtGrp/PassiveActivityCrBeforeLmtAmt'),
  (540461, NULL, NULL, 'Passive Activity Cr Before Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm6765ESBCYAggrgtAmtGrp/PassiveActivityCrBeforeLmtAmt'),
  (540462, NULL, NULL, 'Oth Thn Cr Trnsfr Elect Cr Bfr Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8846CYAggrgtAmtGrp/OthThnCrTrnsfrElectCrBfrLmtAmt'),
  (540463, NULL, NULL, 'PY Pssv Activity Cr Allwbl CY Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm6765CYAggrgtAmtGrp/PYPssvActivityCrAllwblCYAmt'),
  (540464, NULL, NULL, 'Oth Thn Cr Trnsfr Elect Cr No Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm6765ESBCYAggrgtAmtGrp/OthThnCrTrnsfrElectCrNoLmtAmt'),
  (540465, NULL, NULL, 'Passive Activity Cr Before Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8586CYAggrgtAmtGrp/PassiveActivityCrBeforeLmtAmt'),
  (540466, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8904CYAggrgtAmtGrp/PassThroughEntityEIN'),
  (540467, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm5884CYAggrgtAmtGrp/GeneralBusCrFromNnPssvActyAmt'),
  (540468, NULL, NULL, 'Total GBC Less Gross EPE App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8586CYAggrgtAmtGrp/TotalGBCLessGrossEPEAppTxAmt'),
  (540469, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8586CYAggrgtAmtGrp/TotalGeneralBusCreditsAmt'),
  (540470, NULL, NULL, 'Oth Thn Cr Trnsfr Elect Cr No Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8904CYAggrgtAmtGrp/OthThnCrTrnsfrElectCrNoLmtAmt'),
  (540471, NULL, NULL, 'Total GBC Less Gross EPE App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8904CYAggrgtAmtGrp/TotalGBCLessGrossEPEAppTxAmt'),
  (540472, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8904CYAggrgtAmtGrp/TotalGeneralBusCreditsAmt'),
  (540473, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8994CYAggrgtAmtGrp/PassThroughEntityEIN'),
  (540474, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm3468PartVICYAggrgtAmtGrp/PassThroughEntityEIN'),
  (540475, NULL, NULL, 'Oth Thn Cr Trnsfr Elect Cr No Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8586CYAggrgtAmtGrp/OthThnCrTrnsfrElectCrNoLmtAmt'),
  (540476, NULL, NULL, 'PY Pssv Activity Cr Allwbl CY Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8846CYAggrgtAmtGrp/PYPssvActivityCrAllwblCYAmt'),
  (540477, NULL, NULL, 'Oth Thn Cr Trnsfr Elect Cr No Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8882CYAggrgtAmtGrp/OthThnCrTrnsfrElectCrNoLmtAmt'),
  (540478, NULL, NULL, 'Total GBC Less Gross EPE App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8882CYAggrgtAmtGrp/TotalGBCLessGrossEPEAppTxAmt'),
  (540479, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8882CYAggrgtAmtGrp/TotalGeneralBusCreditsAmt'),
  (540480, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8936PartVCYAggrgtAmtGrp/PassThroughEntityEIN'),
  (540481, NULL, NULL, 'Cr Trnsfr Elect Cr Allw Aftr Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm6765CYAggrgtAmtGrp/CrTrnsfrElectCrAllwAftrLmtAmt'),
  (540482, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm6765ESBCYAggrgtAmtGrp/GeneralBusCrFromNnPssvActyAmt'),
  (540483, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8586CYAggrgtAmtGrp/GeneralBusCrFromNnPssvActyAmt'),
  (540484, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8844CYAggrgtAmtGrp/PassThroughEntityEIN'),
  (540485, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8882CYAggrgtAmtGrp/GeneralBusCrFromNnPssvActyAmt'),
  (540486, NULL, NULL, 'Passive Activity Cr Before Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8994CYAggrgtAmtGrp/PassiveActivityCrBeforeLmtAmt'),
  (540487, NULL, NULL, 'Passive Activity Cr Before Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm3468PartVICYAggrgtAmtGrp/PassiveActivityCrBeforeLmtAmt'),
  (540488, NULL, NULL, 'Transfer Credit Entity EIN', 'TEXT', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm3468PartVICYAggrgtAmtGrp/TransferCreditEntityEIN'),
  (540489, NULL, NULL, 'Oth Thn Cr Trnsfr Elect Cr Bfr Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm5884CYAggrgtAmtGrp/OthThnCrTrnsfrElectCrBfrLmtAmt'),
  (540490, NULL, NULL, 'Cr Trnsfr Elect Cr Allw Aftr Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm6765ESBCYAggrgtAmtGrp/CrTrnsfrElectCrAllwAftrLmtAmt'),
  (540491, NULL, NULL, 'PY Pssv Activity Cr Allwbl CY Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8586CYAggrgtAmtGrp/PYPssvActivityCrAllwblCYAmt'),
  (540492, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8908CYAggrgtAmtGrp/PassThroughEntityEIN'),
  (540493, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8911PartIICYAggrgtAmtGrp/GeneralBusCrFromNnPssvActyAmt'),
  (540494, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8911PartIICYAggrgtAmtGrp/PassThroughEntityEIN'),
  (540495, NULL, NULL, 'Oth Thn Cr Trnsfr Elect Cr No Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8936PartVCYAggrgtAmtGrp/OthThnCrTrnsfrElectCrNoLmtAmt'),
  (540496, NULL, NULL, 'Total GBC Less Gross EPE Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8936PartVCYAggrgtAmtGrp/TotalGBCLessGrossEPEAmt'),
  (540497, NULL, NULL, 'Total GBC Less Gross EPE App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8936PartVCYAggrgtAmtGrp/TotalGBCLessGrossEPEAppTxAmt'),
  (540498, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8936PartVCYAggrgtAmtGrp/TotalGeneralBusCreditsAmt'),
  (540499, NULL, NULL, 'Cr Trnsfr Elect Cr Prchs Bfr Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/GenBusCYAggrgtSubTot2Grp/CrTrnsfrElectCrPrchsBfrLmtAmt'),
  (540500, NULL, NULL, 'Cr Trnsfr Elect Cr Sold Bfr Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/GenBusCYAggrgtSubTot2Grp/CrTrnsfrElectCrSoldBfrLmtAmt'),
  (540501, NULL, NULL, 'Prchs Trnsfr Elect Cr No Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/GenBusCYAggrgtSubTot2Grp/PrchsTrnsfrElectCrNoLmtAmt'),
  (540502, NULL, NULL, 'Trnsfr Elect Cr Sold No Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/GenBusCYAggrgtSubTot2Grp/TrnsfrElectCrSoldNoLmtAmt'),
  (540503, NULL, NULL, 'Cr Trnsfr Elect Cr Prchs Bfr Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/GenBusCYAggrgtSubTotGrp/CrTrnsfrElectCrPrchsBfrLmtAmt'),
  (540504, NULL, NULL, 'Cr Trnsfr Elect Cr Sold Bfr Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/GenBusCYAggrgtSubTotGrp/CrTrnsfrElectCrSoldBfrLmtAmt'),
  (540505, NULL, NULL, 'Prchs Trnsfr Elect Cr No Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/GenBusCYAggrgtSubTotGrp/PrchsTrnsfrElectCrNoLmtAmt'),
  (540506, NULL, NULL, 'Trnsfr Elect Cr Sold No Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/GenBusCYAggrgtSubTotGrp/TrnsfrElectCrSoldNoLmtAmt'),
  (540507, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/GenBusOthSpcfdCrCYAggrgtAmtGrp/PassThroughEntityEIN'),
  (540508, NULL, NULL, 'Cr Trnsfr Elect Cr Prchs Bfr Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/TotGenBusCYAggrgtAmtGrp/CrTrnsfrElectCrPrchsBfrLmtAmt'),
  (540509, NULL, NULL, 'Cr Trnsfr Elect Cr Sold Bfr Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/TotGenBusCYAggrgtAmtGrp/CrTrnsfrElectCrSoldBfrLmtAmt'),
  (540510, NULL, NULL, 'Prchs Trnsfr Elect Cr No Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/TotGenBusCYAggrgtAmtGrp/PrchsTrnsfrElectCrNoLmtAmt'),
  (540511, NULL, NULL, 'Trnsfr Elect Cr Sold No Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/TotGenBusCYAggrgtAmtGrp/TrnsfrElectCrSoldNoLmtAmt'),
  (540512, NULL, NULL, 'Cr Trnsfr Elect Cr Allw Aftr Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm3468PartVICYAggrgtAmtGrp/CrTrnsfrElectCrAllwAftrLmtAmt'),
  (540513, NULL, NULL, 'Cr Trnsfr Elect Cr Prchs Bfr Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm3468PartVICYAggrgtAmtGrp/CrTrnsfrElectCrPrchsBfrLmtAmt'),
  (540514, NULL, NULL, 'Cr Trnsfr Elect Cr Sold Bfr Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm3468PartVICYAggrgtAmtGrp/CrTrnsfrElectCrSoldBfrLmtAmt'),
  (540515, NULL, NULL, 'Oth Thn Cr Trnsfr Elect Cr Bfr Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm3468PartVICYAggrgtAmtGrp/OthThnCrTrnsfrElectCrBfrLmtAmt'),
  (540516, NULL, NULL, 'Prchs Trnsfr Elect Cr No Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm3468PartVICYAggrgtAmtGrp/PrchsTrnsfrElectCrNoLmtAmt'),
  (540517, NULL, NULL, 'Trnsfr Elect Cr Sold No Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm3468PartVICYAggrgtAmtGrp/TrnsfrElectCrSoldNoLmtAmt'),
  (540518, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm3468PartVIICYAggrgtAmtGrp/PassThroughEntityEIN'),
  (540519, NULL, NULL, 'Passive Activity Cr Before Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm3468PartVIICYAggrgtAmtGrp/PassiveActivityCrBeforeLmtAmt'),
  (540520, NULL, NULL, 'Oth Thn Cr Trnsfr Elect Cr Bfr Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8586CYAggrgtAmtGrp/OthThnCrTrnsfrElectCrBfrLmtAmt'),
  (540521, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8835PartIICYAggrgtAmtGrp/PassThroughEntityEIN'),
  (540522, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8844CYAggrgtAmtGrp/GeneralBusCrFromNnPssvActyAmt'),
  (540523, NULL, NULL, 'Passive Activity Cr Before Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8908CYAggrgtAmtGrp/PassiveActivityCrBeforeLmtAmt'),
  (540524, NULL, NULL, 'Elective Payment Registration Num', 'INTEGER', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8911PartIICYAggrgtAmtGrp/ElectivePaymentRegistrationNum'),
  (540525, NULL, NULL, 'Net Elective Pymt Election Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8911PartIICYAggrgtAmtGrp/NetElectivePymtElectionAmt'),
  (540526, NULL, NULL, 'Cr Trnsfr Elect Cr Allw Aftr Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm5884CYAggrgtAmtGrp/CrTrnsfrElectCrAllwAftrLmtAmt'),
  (540527, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm6478CYSpcfdCrAggrgtGrp/PassThroughEntityEIN'),
  (540528, NULL, NULL, 'Cr Trnsfr Elect Cr Allw Aftr Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8586CYAggrgtAmtGrp/CrTrnsfrElectCrAllwAftrLmtAmt'),
  (540529, NULL, NULL, 'Oth Thn Cr Trnsfr Elect Cr No Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8835PartIICYAggrgtAmtGrp/OthThnCrTrnsfrElectCrNoLmtAmt'),
  (540530, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8835PartIICYAggrgtAmtGrp/TotalGeneralBusCreditsAmt'),
  (540531, NULL, NULL, 'Oth Thn Cr Trnsfr Elect Cr No Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8844CYAggrgtAmtGrp/OthThnCrTrnsfrElectCrNoLmtAmt'),
  (540532, NULL, NULL, 'Total GBC Less Gross EPE App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8844CYAggrgtAmtGrp/TotalGBCLessGrossEPEAppTxAmt'),
  (540533, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8844CYAggrgtAmtGrp/TotalGeneralBusCreditsAmt'),
  (540534, NULL, NULL, 'Cr Trnsfr Elect Cr Allw Aftr Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8846CYAggrgtAmtGrp/CrTrnsfrElectCrAllwAftrLmtAmt'),
  (540535, NULL, NULL, 'Oth Thn Cr Trnsfr Elect Cr No Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8900CYAggrgtAmtGrp/OthThnCrTrnsfrElectCrNoLmtAmt'),
  (540536, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8900CYAggrgtAmtGrp/PassThroughEntityEIN'),
  (540537, NULL, NULL, 'Total GBC Less Gross EPE App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8900CYAggrgtAmtGrp/TotalGBCLessGrossEPEAppTxAmt'),
  (540538, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8900CYAggrgtAmtGrp/TotalGeneralBusCreditsAmt'),
  (540539, NULL, NULL, 'Passive Activity Cr Before Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8936PartVCYAggrgtAmtGrp/PassiveActivityCrBeforeLmtAmt'),
  (540540, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8994CYAggrgtAmtGrp/GeneralBusCrFromNnPssvActyAmt'),
  (540541, NULL, NULL, 'Oth Thn Cr Trnsfr Elect Cr Bfr Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8994CYAggrgtAmtGrp/OthThnCrTrnsfrElectCrBfrLmtAmt'),
  (540542, NULL, NULL, 'Total GBC Less Gross EPE App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8994CYAggrgtAmtGrp/TotalGBCLessGrossEPEAppTxAmt'),
  (540543, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8994CYAggrgtAmtGrp/TotalGeneralBusCreditsAmt'),
  (540544, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/GenBusOthSpcfdCrCYAggrgtAmtGrp/GeneralBusCrFromNnPssvActyAmt'),
  (540545, NULL, NULL, 'Passive Activity Cr Before Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/GenBusOthSpcfdCrCYAggrgtAmtGrp/PassiveActivityCrBeforeLmtAmt'),
  (540546, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm3468PartIICYAggrgtAmtGrp/PassThroughEntityEIN'),
  (540547, NULL, NULL, 'Passive Activity Cr Before Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm3468PartIICYAggrgtAmtGrp/PassiveActivityCrBeforeLmtAmt'),
  (540548, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm3468PartIIICYAggrgtAmtGrp/PassThroughEntityEIN'),
  (540549, NULL, NULL, 'Passive Activity Cr Before Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm3468PartIIICYAggrgtAmtGrp/PassiveActivityCrBeforeLmtAmt'),
  (540550, NULL, NULL, 'PY Pssv Activity Cr Allwbl CY Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm3468PartVICYAggrgtAmtGrp/PYPssvActivityCrAllwblCYAmt'),
  (540551, NULL, NULL, 'PY Pssv Activity Cr Allwbl CY Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm5884CYAggrgtAmtGrp/PYPssvActivityCrAllwblCYAmt'),
  (540552, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm6478CYSpcfdCrAggrgtGrp/GeneralBusCrFromNnPssvActyAmt'),
  (540553, NULL, NULL, 'Passive Activity Cr Before Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm6478CYSpcfdCrAggrgtGrp/PassiveActivityCrBeforeLmtAmt'),
  (540554, NULL, NULL, 'PY Pssv Activity Cr Allwbl CY Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm6765ESBCYAggrgtAmtGrp/PYPssvActivityCrAllwblCYAmt'),
  (540555, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm7213PartICYAggrgtAmtGrp/PassThroughEntityEIN'),
  (540556, NULL, NULL, 'Passive Activity Cr Before Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm7213PartICYAggrgtAmtGrp/PassiveActivityCrBeforeLmtAmt'),
  (540557, NULL, NULL, 'Oth Thn Cr Trnsfr Elect Cr No Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm7213PartIICYAggrgtAmtGrp/OthThnCrTrnsfrElectCrNoLmtAmt'),
  (540558, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm7213PartIICYAggrgtAmtGrp/PassThroughEntityEIN'),
  (540559, NULL, NULL, 'Total GBC Less Gross EPE Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm7213PartIICYAggrgtAmtGrp/TotalGBCLessGrossEPEAmt'),
  (540560, NULL, NULL, 'Total GBC Less Gross EPE App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm7213PartIICYAggrgtAmtGrp/TotalGBCLessGrossEPEAppTxAmt'),
  (540561, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm7213PartIICYAggrgtAmtGrp/TotalGeneralBusCreditsAmt'),
  (540562, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8835PartIICYAggrgtAmtGrp/GeneralBusCrFromNnPssvActyAmt'),
  (540563, NULL, NULL, 'Total GBC Less Gross EPE App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8835PartIICYAggrgtAmtGrp/TotalGBCLessGrossEPEAppTxAmt'),
  (540564, NULL, NULL, 'Passive Activity Cr Before Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8844CYAggrgtAmtGrp/PassiveActivityCrBeforeLmtAmt'),
  (540565, NULL, NULL, 'Oth Thn Cr Trnsfr Elect Cr No Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8864CYAggrgtAmtGrp/OthThnCrTrnsfrElectCrNoLmtAmt'),
  (540566, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8864CYAggrgtAmtGrp/PassThroughEntityEIN'),
  (540567, NULL, NULL, 'Total GBC Less Gross EPE App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8864CYAggrgtAmtGrp/TotalGBCLessGrossEPEAppTxAmt'),
  (540568, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8864CYAggrgtAmtGrp/TotalGeneralBusCreditsAmt'),
  (540569, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8881PartICYAggrgtAmtGrp/PassThroughEntityEIN'),
  (540570, NULL, NULL, 'Passive Activity Cr Before Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8881PartICYAggrgtAmtGrp/PassiveActivityCrBeforeLmtAmt'),
  (540571, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8882CYAggrgtAmtGrp/PassThroughEntityEIN'),
  (540572, NULL, NULL, 'Oth Thn Cr Trnsfr Elect Cr Bfr Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8904CYAggrgtAmtGrp/OthThnCrTrnsfrElectCrBfrLmtAmt'),
  (540573, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8908CYAggrgtAmtGrp/GeneralBusCrFromNnPssvActyAmt'),
  (540574, NULL, NULL, 'Oth Thn Cr Trnsfr Elect Cr No Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8908CYAggrgtAmtGrp/OthThnCrTrnsfrElectCrNoLmtAmt'),
  (540575, NULL, NULL, 'PY Pssv Activity Cr Allwbl CY Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8908CYAggrgtAmtGrp/PYPssvActivityCrAllwblCYAmt'),
  (540576, NULL, NULL, 'Total GBC Less Gross EPE App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8908CYAggrgtAmtGrp/TotalGBCLessGrossEPEAppTxAmt'),
  (540577, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8908CYAggrgtAmtGrp/TotalGeneralBusCreditsAmt'),
  (540578, NULL, NULL, 'Elective Payment Registration Num', 'INTEGER', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8911PartICYAggrgtAmtGrp/ElectivePaymentRegistrationNum'),
  (540579, NULL, NULL, 'Gross Elective Pymt Election Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8911PartICYAggrgtAmtGrp/GrossElectivePymtElectionAmt'),
  (540580, NULL, NULL, 'Oth Thn Cr Trnsfr Elect Cr No Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8911PartICYAggrgtAmtGrp/OthThnCrTrnsfrElectCrNoLmtAmt'),
  (540581, NULL, NULL, 'Total GBC Less Gross EPE Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8911PartICYAggrgtAmtGrp/TotalGBCLessGrossEPEAmt'),
  (540582, NULL, NULL, 'Total GBC Less Gross EPE App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8911PartICYAggrgtAmtGrp/TotalGBCLessGrossEPEAppTxAmt'),
  (540583, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8911PartICYAggrgtAmtGrp/TotalGeneralBusCreditsAmt'),
  (540584, NULL, NULL, 'Gross Elective Pymt Election Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8911PartIICYAggrgtAmtGrp/GrossElectivePymtElectionAmt'),
  (540585, NULL, NULL, 'Cr Trnsfr Elect Cr Allw Aftr Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8936PartVCYAggrgtAmtGrp/CrTrnsfrElectCrAllwAftrLmtAmt'),
  (540586, NULL, NULL, 'Cr Trnsfr Elect Cr Prchs Bfr Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8936PartVCYAggrgtAmtGrp/CrTrnsfrElectCrPrchsBfrLmtAmt'),
  (540587, NULL, NULL, 'Cr Trnsfr Elect Cr Sold Bfr Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8936PartVCYAggrgtAmtGrp/CrTrnsfrElectCrSoldBfrLmtAmt'),
  (540588, NULL, NULL, 'Missing EIN Reason Cd', 'TEXT', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8936PartVCYAggrgtAmtGrp/MissingEINReasonCd'),
  (540589, NULL, NULL, 'Oth Thn Cr Trnsfr Elect Cr Bfr Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8936PartVCYAggrgtAmtGrp/OthThnCrTrnsfrElectCrBfrLmtAmt'),
  (540590, NULL, NULL, 'PY Pssv Activity Cr Allwbl CY Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8936PartVCYAggrgtAmtGrp/PYPssvActivityCrAllwblCYAmt'),
  (540591, NULL, NULL, 'Cr Trnsfr Elect Cr Allw Aftr Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8994CYAggrgtAmtGrp/CrTrnsfrElectCrAllwAftrLmtAmt'),
  (540592, NULL, NULL, 'Oth Thn Cr Trnsfr Elect Cr No Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8994CYAggrgtAmtGrp/OthThnCrTrnsfrElectCrNoLmtAmt'),
  (540593, NULL, NULL, 'PY Pssv Activity Cr Allwbl CY Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/Frm8994CYAggrgtAmtGrp/PYPssvActivityCrAllwblCYAmt'),
  (540594, NULL, NULL, 'PY Pssv Activity Cr Allwbl CY Amt', 'CURRENCY', 'ReturnData/IRS3800/GBCBreakdownCYAggrgtAmtGrp/GenBusOthSpcfdCrCYAggrgtAmtGrp/PYPssvActivityCrAllwblCYAmt');

-- 990T / IRS4562 Direct Fields
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54019, 54, '020', 'IRS4562 Direct Fields');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (540595, 54019, '1', 'MACRS Ded For Ast In Srvc Bfr PY Amt', 'CURRENCY'),
  (540596, 54019, '2', 'Total Amortization Amt', 'CURRENCY'),
  (540597, 54019, '3', 'Amortization Costs Before TY Amt', 'CURRENCY'),
  (540598, 54019, '4', 'Special Allowance Amt', 'CURRENCY'),
  (540599, 54019, '5', 'Total Listed Depreciation Amt', 'CURRENCY'),
  (540600, 54019, '6', 'Dollar Limitation For Tax Year Amt', 'CURRENCY'),
  (540601, 54019, '7', 'Section179 Expense Deduction Amt', 'CURRENCY'),
  (540602, 54019, '8', 'Tentative Deduction Amt', 'CURRENCY'),
  (540603, 54019, '9', 'Total Elected Cost Sect179 Prop Amt', 'CURRENCY'),
  (540604, 54019, '10', 'Business Income Limitation Amt', 'CURRENCY'),
  (540605, 54019, '11', 'Total Cost Of Section179 Prop Amt', 'CURRENCY'),
  (540606, 54019, '12', 'Reduction In Limitation Amt', 'CURRENCY'),
  (540607, 54019, '13', 'Next Year Carryover Amt', 'CURRENCY'),
  (540608, 54019, '14', 'Disallowed Deduction Cyov Amt', 'CURRENCY'),
  (540609, 54019, '15', 'Total Special Deprec Allwnc Amt', 'CURRENCY'),
  (540610, 54019, '16', 'Total Section179 Expense Amt', 'CURRENCY'),
  (540611, 54019, '17', 'Section168f1 Elected Property Amt', 'CURRENCY'),
  (540612, 54019, '18', 'Section263 A Current Year Cost Amt', 'CURRENCY'),
  (540613, 54019, '19', 'Evidence To Support Deduction Ind', 'BOOLEAN'),
  (540614, 54019, '20', 'Evidence Written Ind', 'BOOLEAN'),
  (540615, 54019, '21', 'Meet Rqr For Auto Demo Use Ind', 'BOOLEAN'),
  (540616, 54019, '22', 'Policy No Prsnl Exc Cmmtng Use Ind', 'BOOLEAN'),
  (540617, 54019, '23', 'Policy No Prsnl Or Cmmtng Use Ind', 'BOOLEAN'),
  (540618, 54019, '24', 'Provide Over Num Veh And Have Rec Ind', 'BOOLEAN'),
  (540619, 54019, '25', 'Treat All Veh Use As Prsnl Use Ind', 'BOOLEAN'),
  (540620, 54019, '26', 'General Asset Account Election Ind', 'BOOLEAN');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (540595, NULL, NULL, 'MACRS Ded For Ast In Srvc Bfr PY Amt', 'CURRENCY', 'ReturnData/IRS4562/MACRSDedForAstInSrvcBfrPYAmt'),
  (540596, NULL, NULL, 'Total Amortization Amt', 'CURRENCY', 'ReturnData/IRS4562/TotalAmortizationAmt'),
  (540597, NULL, NULL, 'Amortization Costs Before TY Amt', 'CURRENCY', 'ReturnData/IRS4562/AmortizationCostsBeforeTYAmt'),
  (540598, NULL, NULL, 'Special Allowance Amt', 'CURRENCY', 'ReturnData/IRS4562/SpecialAllowanceAmt'),
  (540599, NULL, NULL, 'Total Listed Depreciation Amt', 'CURRENCY', 'ReturnData/IRS4562/TotalListedDepreciationAmt'),
  (540600, NULL, NULL, 'Dollar Limitation For Tax Year Amt', 'CURRENCY', 'ReturnData/IRS4562/DollarLimitationForTaxYearAmt'),
  (540601, NULL, NULL, 'Section179 Expense Deduction Amt', 'CURRENCY', 'ReturnData/IRS4562/Section179ExpenseDeductionAmt'),
  (540602, NULL, NULL, 'Tentative Deduction Amt', 'CURRENCY', 'ReturnData/IRS4562/TentativeDeductionAmt'),
  (540603, NULL, NULL, 'Total Elected Cost Sect179 Prop Amt', 'CURRENCY', 'ReturnData/IRS4562/TotalElectedCostSect179PropAmt'),
  (540604, NULL, NULL, 'Business Income Limitation Amt', 'CURRENCY', 'ReturnData/IRS4562/BusinessIncomeLimitationAmt'),
  (540605, NULL, NULL, 'Total Cost Of Section179 Prop Amt', 'CURRENCY', 'ReturnData/IRS4562/TotalCostOfSection179PropAmt'),
  (540606, NULL, NULL, 'Reduction In Limitation Amt', 'CURRENCY', 'ReturnData/IRS4562/ReductionInLimitationAmt'),
  (540607, NULL, NULL, 'Next Year Carryover Amt', 'CURRENCY', 'ReturnData/IRS4562/NextYearCarryoverAmt'),
  (540608, NULL, NULL, 'Disallowed Deduction Cyov Amt', 'CURRENCY', 'ReturnData/IRS4562/DisallowedDeductionCyovAmt'),
  (540609, NULL, NULL, 'Total Special Deprec Allwnc Amt', 'CURRENCY', 'ReturnData/IRS4562/TotalSpecialDeprecAllwncAmt'),
  (540610, NULL, NULL, 'Total Section179 Expense Amt', 'CURRENCY', 'ReturnData/IRS4562/TotalSection179ExpenseAmt'),
  (540611, NULL, NULL, 'Section168f1 Elected Property Amt', 'CURRENCY', 'ReturnData/IRS4562/Section168f1ElectedPropertyAmt'),
  (540612, NULL, NULL, 'Section263 A Current Year Cost Amt', 'CURRENCY', 'ReturnData/IRS4562/Section263ACurrentYearCostAmt'),
  (540613, NULL, NULL, 'Evidence To Support Deduction Ind', 'BOOLEAN', 'ReturnData/IRS4562/EvidenceToSupportDeductionInd'),
  (540614, NULL, NULL, 'Evidence Written Ind', 'BOOLEAN', 'ReturnData/IRS4562/EvidenceWrittenInd'),
  (540615, NULL, NULL, 'Meet Rqr For Auto Demo Use Ind', 'BOOLEAN', 'ReturnData/IRS4562/MeetRqrForAutoDemoUseInd'),
  (540616, NULL, NULL, 'Policy No Prsnl Exc Cmmtng Use Ind', 'BOOLEAN', 'ReturnData/IRS4562/PolicyNoPrsnlExcCmmtngUseInd'),
  (540617, NULL, NULL, 'Policy No Prsnl Or Cmmtng Use Ind', 'BOOLEAN', 'ReturnData/IRS4562/PolicyNoPrsnlOrCmmtngUseInd'),
  (540618, NULL, NULL, 'Provide Over Num Veh And Have Rec Ind', 'BOOLEAN', 'ReturnData/IRS4562/ProvideOverNumVehAndHaveRecInd'),
  (540619, NULL, NULL, 'Treat All Veh Use As Prsnl Use Ind', 'BOOLEAN', 'ReturnData/IRS4562/TreatAllVehUseAsPrsnlUseInd'),
  (540620, NULL, NULL, 'General Asset Account Election Ind', 'BOOLEAN', 'ReturnData/IRS4562/GeneralAssetAccountElectionInd');

-- 990T / IRS990 T Schedule A Direct Fields
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54020, 54, '021', 'IRS990 T Schedule A Direct Fields');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (540621, 54020, '1', 'Employee Benefit Program Amt', 'CURRENCY'),
  (540622, 54020, '2', 'Returns And Allowances Amt', 'CURRENCY'),
  (540623, 54020, '3', 'Deferred Compensation Plan Amt', 'CURRENCY'),
  (540624, 54020, '4', 'Net Ctrl Org Int Annts Rylts Rnts Amt', 'CURRENCY'),
  (540625, 54020, '5', 'Oth Inventory Valuation Method Cd', 'TEXT'),
  (540626, 54020, '6', 'Capital Loss Limitation Amt', 'CURRENCY'),
  (540627, 54020, '7', 'Exploited Consolidated Acty Cd', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (540621, NULL, NULL, 'Employee Benefit Program Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/EmployeeBenefitProgramAmt'),
  (540622, NULL, NULL, 'Returns And Allowances Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/ReturnsAndAllowancesAmt'),
  (540623, NULL, NULL, 'Deferred Compensation Plan Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/DeferredCompensationPlanAmt'),
  (540624, NULL, NULL, 'Net Ctrl Org Int Annts Rylts Rnts Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/NetCtrlOrgIntAnntsRyltsRntsAmt'),
  (540625, NULL, NULL, 'Oth Inventory Valuation Method Cd', 'TEXT', 'ReturnData/IRS990TScheduleA/OthInventoryValuationMethodCd'),
  (540626, NULL, NULL, 'Capital Loss Limitation Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/CapitalLossLimitationAmt'),
  (540627, NULL, NULL, 'Exploited Consolidated Acty Cd', 'TEXT', 'ReturnData/IRS990TScheduleA/ExploitedConsolidatedActyCd');

-- 990T / Unrelated Debt Financed Prop Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54021, 54, '022', 'Unrelated Debt Financed Prop Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (540628, 54021, '1', 'Address Line1 Txt', 'TEXT'),
  (540629, 54021, '2', 'City Nm', 'TEXT'),
  (540630, 54021, '3', 'State Abbreviation Cd', 'TEXT'),
  (540631, 54021, '4', 'ZIP Cd', 'TEXT'),
  (540632, 54021, '5', 'Address Line2 Txt', 'TEXT'),
  (540633, 54021, '6', 'Address Line1 Txt', 'TEXT'),
  (540634, 54021, '7', 'City Nm', 'TEXT'),
  (540635, 54021, '8', 'Country Cd', 'TEXT'),
  (540636, 54021, '9', 'Foreign Postal Cd', 'TEXT'),
  (540637, 54021, '10', 'Province Or State Nm', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (540628, NULL, NULL, 'Address Line1 Txt', 'TEXT', 'ReturnData/IRS990TScheduleA/UnrelatedDebtFinancedPropGrp/USAddress/AddressLine1Txt'),
  (540629, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990TScheduleA/UnrelatedDebtFinancedPropGrp/USAddress/CityNm'),
  (540630, NULL, NULL, 'State Abbreviation Cd', 'TEXT', 'ReturnData/IRS990TScheduleA/UnrelatedDebtFinancedPropGrp/USAddress/StateAbbreviationCd'),
  (540631, NULL, NULL, 'ZIP Cd', 'TEXT', 'ReturnData/IRS990TScheduleA/UnrelatedDebtFinancedPropGrp/USAddress/ZIPCd'),
  (540632, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/IRS990TScheduleA/UnrelatedDebtFinancedPropGrp/USAddress/AddressLine2Txt'),
  (540633, NULL, NULL, 'Address Line1 Txt', 'TEXT', 'ReturnData/IRS990TScheduleA/UnrelatedDebtFinancedPropGrp/ForeignAddress/AddressLine1Txt'),
  (540634, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990TScheduleA/UnrelatedDebtFinancedPropGrp/ForeignAddress/CityNm'),
  (540635, NULL, NULL, 'Country Cd', 'TEXT', 'ReturnData/IRS990TScheduleA/UnrelatedDebtFinancedPropGrp/ForeignAddress/CountryCd'),
  (540636, NULL, NULL, 'Foreign Postal Cd', 'TEXT', 'ReturnData/IRS990TScheduleA/UnrelatedDebtFinancedPropGrp/ForeignAddress/ForeignPostalCd'),
  (540637, NULL, NULL, 'Province Or State Nm', 'TEXT', 'ReturnData/IRS990TScheduleA/UnrelatedDebtFinancedPropGrp/ForeignAddress/ProvinceOrStateNm');

-- 990T / IRS1041 Schedule I Direct Fields
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54022, 54, '023', 'IRS1041 Schedule I Direct Fields');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (540638, 54022, '1', 'Adj Alternative Min Taxable Inc Amt', 'CURRENCY'),
  (540639, 54022, '2', 'Alternative Min Taxable Income Amt', 'CURRENCY'),
  (540640, 54022, '3', 'Adjusted Total Income Amt', 'CURRENCY'),
  (540641, 54022, '4', 'Estate Or Trust Shr Less Exempt Amt', 'CURRENCY'),
  (540642, 54022, '5', 'Tentative Alternative Min Tax Amt', 'CURRENCY'),
  (540643, 54022, '6', 'Maximum Capital Gains Or Net Amt', 'CURRENCY'),
  (540644, 54022, '7', 'Alternative Minimum Tax Amt', 'CURRENCY'),
  (540645, 54022, '8', 'Adjusted Regular Tax Amt', 'CURRENCY'),
  (540646, 54022, '9', 'Passive Activity Amt', 'CURRENCY'),
  (540647, 54022, '10', 'Net Exemption Amt', 'CURRENCY'),
  (540648, 54022, '11', 'Sum Threshold Applcbl Wrksht Amt', 'CURRENCY'),
  (540649, 54022, '12', 'Net Alt Min Txbl Inc Times FS Pct Amt', 'CURRENCY'),
  (540650, 54022, '13', 'Smaller Of Alt Min Txbl Inc Or Sum Amt', 'CURRENCY'),
  (540651, 54022, '14', 'Smllr Of Adjusted Alt Min Or Sch D Amt', 'CURRENCY'),
  (540652, 54022, '15', 'FS Amt Less Inc Above Threshold Amt', 'CURRENCY'),
  (540653, 54022, '16', 'Net Share Alt Min Taxble Income Amt', 'CURRENCY'),
  (540654, 54022, '17', 'Net Share Alt Min Txbl Incm X Pct Amt', 'CURRENCY'),
  (540655, 54022, '18', 'Sum Of Alt Min Tax Percentages Amt', 'CURRENCY'),
  (540656, 54022, '19', 'Tax On Alternative Minimum Gain Amt', 'CURRENCY'),
  (540657, 54022, '20', 'Smllr Net Adj Alt Min Or Net Gain Amt', 'CURRENCY'),
  (540658, 54022, '21', 'Capital Gains Worksheet Amt', 'CURRENCY'),
  (540659, 54022, '22', 'Sum Plus Unrecaptured Sect1250 Amt', 'CURRENCY'),
  (540660, 54022, '23', 'Excess Of Sum Amt', 'CURRENCY'),
  (540661, 54022, '24', 'Excess Of Sum Times Pct Amt', 'CURRENCY'),
  (540662, 54022, '25', 'Income Above Threshold Worksht Amt', 'CURRENCY'),
  (540663, 54022, '26', 'Sum Of Smllr Amt', 'CURRENCY'),
  (540664, 54022, '27', 'Flng Thrshld Less Theshold Sum Amt', 'CURRENCY'),
  (540665, 54022, '28', 'Net Alt Min Taxable Inc Times Pct Amt', 'CURRENCY'),
  (540666, 54022, '29', 'Smllr Adj Net Gain Or Txbl Inc Amt', 'CURRENCY'),
  (540667, 54022, '30', 'Smllr Abv Thrshld Or Alt Min Gain Amt', 'CURRENCY'),
  (540668, 54022, '31', 'Net Operating Loss Deduction Amt', 'CURRENCY'),
  (540669, 54022, '32', 'Adj Alt Min Taxable Inc Less Gain Amt', 'CURRENCY'),
  (540670, 54022, '33', 'Net Adj Alt Min Txbl Inc Times Pct Amt', 'CURRENCY'),
  (540671, 54022, '34', 'Alt Tax Net Operating Loss Ded Amt', 'CURRENCY'),
  (540672, 54022, '35', 'Applcbl Cap Gains Or Sch D Wrksht Amt', 'CURRENCY'),
  (540673, 54022, '36', 'Related Adjustment Amt', 'CURRENCY'),
  (540674, 54022, '37', 'Distributable Net AMT Income Amt', 'CURRENCY'),
  (540675, 54022, '38', 'Tentative Incm Distri Int Ded Amt', 'CURRENCY'),
  (540676, 54022, '39', 'Modified Alt Min Txbl Incm Amt', 'CURRENCY'),
  (540677, 54022, '40', 'Cap Gains Cmpt Minimum Tax Basis Amt', 'CURRENCY'),
  (540678, 54022, '41', 'Income And Estate Deduction Amt', 'CURRENCY'),
  (540679, 54022, '42', 'Income Distribution Deduction Amt', 'CURRENCY'),
  (540680, 54022, '43', 'Taxes Amt', 'CURRENCY'),
  (540681, 54022, '44', 'Total Refund Received Amt', 'CURRENCY'),
  (540682, 54022, '45', 'Installment Sale Income Amt', 'CURRENCY'),
  (540683, 54022, '46', 'Depreciation Amt', 'CURRENCY'),
  (540684, 54022, '47', 'Total Net Amt', 'CURRENCY'),
  (540685, 54022, '48', 'Property Disposition Amt', 'CURRENCY'),
  (540686, 54022, '49', 'Tentative Incm Distri Ded Amt', 'CURRENCY'),
  (540687, 54022, '50', 'Total Distribution Amt', 'CURRENCY'),
  (540688, 54022, '51', 'Adjusted Tax Exempt Interest Amt', 'CURRENCY'),
  (540689, 54022, '52', 'Net Sch D Or Adj Net Gain Times Pct Amt', 'CURRENCY'),
  (540690, 54022, '53', 'Net Smaller Sch D Or Adj Net Gain Amt', 'CURRENCY'),
  (540691, 54022, '54', 'Total Net Gain Or Loss Amt', 'CURRENCY'),
  (540692, 54022, '55', 'Tax Exempt Income Amt', 'CURRENCY'),
  (540693, 54022, '56', 'Depletion Amt', 'CURRENCY'),
  (540694, 54022, '57', 'AMT Foreign Tax Credit Amt', 'CURRENCY'),
  (540695, 54022, '58', 'Intangible Drilling Cost Amt', 'CURRENCY'),
  (540696, 54022, '59', 'Interest Amt', 'CURRENCY'),
  (540697, 54022, '60', 'Unrecaptured Section1250 Gain Amt', 'CURRENCY'),
  (540698, 54022, '61', 'Mining Costs Amt', 'CURRENCY'),
  (540699, 54022, '62', 'Research Experimental Cost Amt', 'CURRENCY'),
  (540700, 54022, '63', 'Cap Loss Cmpt Minimum Tax Basis Amt', 'CURRENCY'),
  (540701, 54022, '64', 'Estate Tax Deduction Amt', 'CURRENCY'),
  (540702, 54022, '65', 'Exempt Private Activity Bonds Amt', 'CURRENCY'),
  (540703, 54022, '66', 'Second Tier Distribution Amt', 'CURRENCY'),
  (540704, 54022, '67', 'Section1202 Exclusion Amt', 'CURRENCY'),
  (540705, 54022, '68', 'Capital Gain Corpus Charity Amt', 'CURRENCY'),
  (540706, 54022, '69', 'Capital Gain Pd For Chrtbl Prps Amt', 'CURRENCY'),
  (540707, 54022, '70', 'Circulation Cost Amt', 'CURRENCY'),
  (540708, 54022, '71', 'Estates And Trusts Amt', 'CURRENCY'),
  (540709, 54022, '72', 'First Tier Distribution Amt', 'CURRENCY'),
  (540710, 54022, '73', 'Incentive Stock Options Amt', 'CURRENCY'),
  (540711, 54022, '74', 'Long Term Contract Amt', 'CURRENCY'),
  (540712, 54022, '75', 'Loss Limitation Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (540638, NULL, NULL, 'Adj Alternative Min Taxable Inc Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/AdjAlternativeMinTaxableIncAmt'),
  (540639, NULL, NULL, 'Alternative Min Taxable Income Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/AlternativeMinTaxableIncomeAmt'),
  (540640, NULL, NULL, 'Adjusted Total Income Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/AdjustedTotalIncomeAmt'),
  (540641, NULL, NULL, 'Estate Or Trust Shr Less Exempt Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/EstateOrTrustShrLessExemptAmt'),
  (540642, NULL, NULL, 'Tentative Alternative Min Tax Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/TentativeAlternativeMinTaxAmt'),
  (540643, NULL, NULL, 'Maximum Capital Gains Or Net Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/MaximumCapitalGainsOrNetAmt'),
  (540644, NULL, NULL, 'Alternative Minimum Tax Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/AlternativeMinimumTaxAmt'),
  (540645, NULL, NULL, 'Adjusted Regular Tax Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/AdjustedRegularTaxAmt'),
  (540646, NULL, NULL, 'Passive Activity Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/PassiveActivityAmt'),
  (540647, NULL, NULL, 'Net Exemption Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/NetExemptionAmt'),
  (540648, NULL, NULL, 'Sum Threshold Applcbl Wrksht Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/SumThresholdApplcblWrkshtAmt'),
  (540649, NULL, NULL, 'Net Alt Min Txbl Inc Times FS Pct Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/NetAltMinTxblIncTimesFSPctAmt'),
  (540650, NULL, NULL, 'Smaller Of Alt Min Txbl Inc Or Sum Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/SmallerOfAltMinTxblIncOrSumAmt'),
  (540651, NULL, NULL, 'Smllr Of Adjusted Alt Min Or Sch D Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/SmllrOfAdjustedAltMinOrSchDAmt'),
  (540652, NULL, NULL, 'FS Amt Less Inc Above Threshold Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/FSAmtLessIncAboveThresholdAmt'),
  (540653, NULL, NULL, 'Net Share Alt Min Taxble Income Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/NetShareAltMinTaxbleIncomeAmt'),
  (540654, NULL, NULL, 'Net Share Alt Min Txbl Incm X Pct Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/NetShareAltMinTxblIncmXPctAmt'),
  (540655, NULL, NULL, 'Sum Of Alt Min Tax Percentages Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/SumOfAltMinTaxPercentagesAmt'),
  (540656, NULL, NULL, 'Tax On Alternative Minimum Gain Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/TaxOnAlternativeMinimumGainAmt'),
  (540657, NULL, NULL, 'Smllr Net Adj Alt Min Or Net Gain Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/SmllrNetAdjAltMinOrNetGainAmt'),
  (540658, NULL, NULL, 'Capital Gains Worksheet Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/CapitalGainsWorksheetAmt'),
  (540659, NULL, NULL, 'Sum Plus Unrecaptured Sect1250 Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/SumPlusUnrecapturedSect1250Amt'),
  (540660, NULL, NULL, 'Excess Of Sum Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/ExcessOfSumAmt'),
  (540661, NULL, NULL, 'Excess Of Sum Times Pct Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/ExcessOfSumTimesPctAmt'),
  (540662, NULL, NULL, 'Income Above Threshold Worksht Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/IncomeAboveThresholdWorkshtAmt'),
  (540663, NULL, NULL, 'Sum Of Smllr Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/SumOfSmllrAmt'),
  (540664, NULL, NULL, 'Flng Thrshld Less Theshold Sum Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/FlngThrshldLessThesholdSumAmt'),
  (540665, NULL, NULL, 'Net Alt Min Taxable Inc Times Pct Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/NetAltMinTaxableIncTimesPctAmt'),
  (540666, NULL, NULL, 'Smllr Adj Net Gain Or Txbl Inc Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/SmllrAdjNetGainOrTxblIncAmt'),
  (540667, NULL, NULL, 'Smllr Abv Thrshld Or Alt Min Gain Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/SmllrAbvThrshldOrAltMinGainAmt'),
  (540668, NULL, NULL, 'Net Operating Loss Deduction Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/NetOperatingLossDeductionAmt'),
  (540669, NULL, NULL, 'Adj Alt Min Taxable Inc Less Gain Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/AdjAltMinTaxableIncLessGainAmt'),
  (540670, NULL, NULL, 'Net Adj Alt Min Txbl Inc Times Pct Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/NetAdjAltMinTxblIncTimesPctAmt'),
  (540671, NULL, NULL, 'Alt Tax Net Operating Loss Ded Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/AltTaxNetOperatingLossDedAmt'),
  (540672, NULL, NULL, 'Applcbl Cap Gains Or Sch D Wrksht Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/ApplcblCapGainsOrSchDWrkshtAmt'),
  (540673, NULL, NULL, 'Related Adjustment Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/RelatedAdjustmentAmt'),
  (540674, NULL, NULL, 'Distributable Net AMT Income Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/DistributableNetAMTIncomeAmt'),
  (540675, NULL, NULL, 'Tentative Incm Distri Int Ded Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/TentativeIncmDistriIntDedAmt'),
  (540676, NULL, NULL, 'Modified Alt Min Txbl Incm Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/ModifiedAltMinTxblIncmAmt'),
  (540677, NULL, NULL, 'Cap Gains Cmpt Minimum Tax Basis Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/CapGainsCmptMinimumTaxBasisAmt'),
  (540678, NULL, NULL, 'Income And Estate Deduction Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/IncomeAndEstateDeductionAmt'),
  (540679, NULL, NULL, 'Income Distribution Deduction Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/IncomeDistributionDeductionAmt'),
  (540680, NULL, NULL, 'Taxes Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/TaxesAmt'),
  (540681, NULL, NULL, 'Total Refund Received Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/TotalRefundReceivedAmt'),
  (540682, NULL, NULL, 'Installment Sale Income Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/InstallmentSaleIncomeAmt'),
  (540683, NULL, NULL, 'Depreciation Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/DepreciationAmt'),
  (540684, NULL, NULL, 'Total Net Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/TotalNetAmt'),
  (540685, NULL, NULL, 'Property Disposition Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/PropertyDispositionAmt'),
  (540686, NULL, NULL, 'Tentative Incm Distri Ded Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/TentativeIncmDistriDedAmt'),
  (540687, NULL, NULL, 'Total Distribution Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/TotalDistributionAmt'),
  (540688, NULL, NULL, 'Adjusted Tax Exempt Interest Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/AdjustedTaxExemptInterestAmt'),
  (540689, NULL, NULL, 'Net Sch D Or Adj Net Gain Times Pct Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/NetSchDOrAdjNetGainTimesPctAmt'),
  (540690, NULL, NULL, 'Net Smaller Sch D Or Adj Net Gain Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/NetSmallerSchDOrAdjNetGainAmt'),
  (540691, NULL, NULL, 'Total Net Gain Or Loss Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/TotalNetGainOrLossAmt'),
  (540692, NULL, NULL, 'Tax Exempt Income Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/TaxExemptIncomeAmt'),
  (540693, NULL, NULL, 'Depletion Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/DepletionAmt'),
  (540694, NULL, NULL, 'AMT Foreign Tax Credit Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/AMTForeignTaxCreditAmt'),
  (540695, NULL, NULL, 'Intangible Drilling Cost Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/IntangibleDrillingCostAmt'),
  (540696, NULL, NULL, 'Interest Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/InterestAmt'),
  (540697, NULL, NULL, 'Unrecaptured Section1250 Gain Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/UnrecapturedSection1250GainAmt'),
  (540698, NULL, NULL, 'Mining Costs Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/MiningCostsAmt'),
  (540699, NULL, NULL, 'Research Experimental Cost Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/ResearchExperimentalCostAmt'),
  (540700, NULL, NULL, 'Cap Loss Cmpt Minimum Tax Basis Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/CapLossCmptMinimumTaxBasisAmt'),
  (540701, NULL, NULL, 'Estate Tax Deduction Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/EstateTaxDeductionAmt'),
  (540702, NULL, NULL, 'Exempt Private Activity Bonds Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/ExemptPrivateActivityBondsAmt'),
  (540703, NULL, NULL, 'Second Tier Distribution Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/SecondTierDistributionAmt'),
  (540704, NULL, NULL, 'Section1202 Exclusion Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/Section1202ExclusionAmt'),
  (540705, NULL, NULL, 'Capital Gain Corpus Charity Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/CapitalGainCorpusCharityAmt'),
  (540706, NULL, NULL, 'Capital Gain Pd For Chrtbl Prps Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/CapitalGainPdForChrtblPrpsAmt'),
  (540707, NULL, NULL, 'Circulation Cost Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/CirculationCostAmt'),
  (540708, NULL, NULL, 'Estates And Trusts Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/EstatesAndTrustsAmt'),
  (540709, NULL, NULL, 'First Tier Distribution Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/FirstTierDistributionAmt'),
  (540710, NULL, NULL, 'Incentive Stock Options Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/IncentiveStockOptionsAmt'),
  (540711, NULL, NULL, 'Long Term Contract Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/LongTermContractAmt'),
  (540712, NULL, NULL, 'Loss Limitation Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleI/LossLimitationAmt');

-- 990T / General Depreciation System
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54023, 54, '024', 'General Depreciation System');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (540713, 54023, '1', 'Depreciation Deduction Amt', 'CURRENCY'),
  (540714, 54023, '2', 'Basis For Depreciation Amt', 'CURRENCY'),
  (540715, 54023, '3', 'Depreciation Convention Cd', 'TEXT'),
  (540716, 54023, '4', 'Recovery Prd', 'TEXT'),
  (540717, 54023, '5', 'Depreciation Method Cd', 'TEXT'),
  (540718, 54023, '6', 'Recovery Prd', 'TEXT'),
  (540719, 54023, '7', 'Basis For Depreciation Amt', 'CURRENCY'),
  (540720, 54023, '8', 'Depreciation Convention Cd', 'TEXT'),
  (540721, 54023, '9', 'Depreciation Deduction Amt', 'CURRENCY'),
  (540722, 54023, '10', 'Depreciation Method Cd', 'TEXT'),
  (540723, 54023, '11', 'Basis For Depreciation Amt', 'CURRENCY'),
  (540724, 54023, '12', 'Depreciation Deduction Amt', 'CURRENCY'),
  (540725, 54023, '13', 'Month And Year Placed In Service Dt', 'TEXT'),
  (540726, 54023, '14', 'Basis For Depreciation Amt', 'CURRENCY'),
  (540727, 54023, '15', 'Depreciation Deduction Amt', 'CURRENCY'),
  (540728, 54023, '16', 'Recovery Prd', 'TEXT'),
  (540729, 54023, '17', 'Depreciation Convention Cd', 'TEXT'),
  (540730, 54023, '18', 'Depreciation Method Cd', 'TEXT'),
  (540731, 54023, '19', 'Depreciation Deduction Amt', 'CURRENCY'),
  (540732, 54023, '20', 'Basis For Depreciation Amt', 'CURRENCY'),
  (540733, 54023, '21', 'Recovery Prd', 'TEXT'),
  (540734, 54023, '22', 'Depreciation Deduction Amt', 'CURRENCY'),
  (540735, 54023, '23', 'Basis For Depreciation Amt', 'CURRENCY'),
  (540736, 54023, '24', 'Basis For Depreciation Amt', 'CURRENCY'),
  (540737, 54023, '25', 'Depreciation Convention Cd', 'TEXT'),
  (540738, 54023, '26', 'Depreciation Method Cd', 'TEXT'),
  (540739, 54023, '27', 'Recovery Prd', 'TEXT'),
  (540740, 54023, '28', 'Depreciation Deduction Amt', 'CURRENCY'),
  (540741, 54023, '29', 'Month And Year Placed In Service Dt', 'TEXT'),
  (540742, 54023, '30', 'Month And Year Placed In Service Dt', 'TEXT'),
  (540743, 54023, '31', 'Basis For Depreciation Amt', 'CURRENCY'),
  (540744, 54023, '32', 'Depreciation Convention Cd', 'TEXT'),
  (540745, 54023, '33', 'Depreciation Deduction Amt', 'CURRENCY'),
  (540746, 54023, '34', 'Depreciation Method Cd', 'TEXT'),
  (540747, 54023, '35', 'Recovery Prd', 'TEXT'),
  (540748, 54023, '36', 'Basis For Depreciation Amt', 'CURRENCY'),
  (540749, 54023, '37', 'Depreciation Convention Cd', 'TEXT'),
  (540750, 54023, '38', 'Depreciation Deduction Amt', 'CURRENCY'),
  (540751, 54023, '39', 'Depreciation Method Cd', 'TEXT'),
  (540752, 54023, '40', 'Recovery Prd', 'TEXT'),
  (540753, 54023, '41', 'Basis For Depreciation Amt', 'CURRENCY'),
  (540754, 54023, '42', 'Depreciation Convention Cd', 'TEXT'),
  (540755, 54023, '43', 'Depreciation Deduction Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (540713, NULL, NULL, 'Depreciation Deduction Amt', 'CURRENCY', 'ReturnData/IRS4562/GeneralDepreciationSystem/GDS5YearProperty/DepreciationDeductionAmt'),
  (540714, NULL, NULL, 'Basis For Depreciation Amt', 'CURRENCY', 'ReturnData/IRS4562/GeneralDepreciationSystem/GDS5YearProperty/BasisForDepreciationAmt'),
  (540715, NULL, NULL, 'Depreciation Convention Cd', 'TEXT', 'ReturnData/IRS4562/GeneralDepreciationSystem/GDS5YearProperty/DepreciationConventionCd'),
  (540716, NULL, NULL, 'Recovery Prd', 'TEXT', 'ReturnData/IRS4562/GeneralDepreciationSystem/GDS5YearProperty/RecoveryPrd'),
  (540717, NULL, NULL, 'Depreciation Method Cd', 'TEXT', 'ReturnData/IRS4562/GeneralDepreciationSystem/GDS5YearProperty/DepreciationMethodCd'),
  (540718, NULL, NULL, 'Recovery Prd', 'TEXT', 'ReturnData/IRS4562/GeneralDepreciationSystem/GDS7YearProperty/RecoveryPrd'),
  (540719, NULL, NULL, 'Basis For Depreciation Amt', 'CURRENCY', 'ReturnData/IRS4562/GeneralDepreciationSystem/GDS7YearProperty/BasisForDepreciationAmt'),
  (540720, NULL, NULL, 'Depreciation Convention Cd', 'TEXT', 'ReturnData/IRS4562/GeneralDepreciationSystem/GDS7YearProperty/DepreciationConventionCd'),
  (540721, NULL, NULL, 'Depreciation Deduction Amt', 'CURRENCY', 'ReturnData/IRS4562/GeneralDepreciationSystem/GDS7YearProperty/DepreciationDeductionAmt'),
  (540722, NULL, NULL, 'Depreciation Method Cd', 'TEXT', 'ReturnData/IRS4562/GeneralDepreciationSystem/GDS7YearProperty/DepreciationMethodCd'),
  (540723, NULL, NULL, 'Basis For Depreciation Amt', 'CURRENCY', 'ReturnData/IRS4562/GeneralDepreciationSystem/GDSNonRsdntlRealProp/BasisForDepreciationAmt'),
  (540724, NULL, NULL, 'Depreciation Deduction Amt', 'CURRENCY', 'ReturnData/IRS4562/GeneralDepreciationSystem/GDSNonRsdntlRealProp/DepreciationDeductionAmt'),
  (540725, NULL, NULL, 'Month And Year Placed In Service Dt', 'TEXT', 'ReturnData/IRS4562/GeneralDepreciationSystem/GDSNonRsdntlRealProp/MonthAndYearPlacedInServiceDt'),
  (540726, NULL, NULL, 'Basis For Depreciation Amt', 'CURRENCY', 'ReturnData/IRS4562/GeneralDepreciationSystem/GDS15YearProperty/BasisForDepreciationAmt'),
  (540727, NULL, NULL, 'Depreciation Deduction Amt', 'CURRENCY', 'ReturnData/IRS4562/GeneralDepreciationSystem/GDS15YearProperty/DepreciationDeductionAmt'),
  (540728, NULL, NULL, 'Recovery Prd', 'TEXT', 'ReturnData/IRS4562/GeneralDepreciationSystem/GDS15YearProperty/RecoveryPrd'),
  (540729, NULL, NULL, 'Depreciation Convention Cd', 'TEXT', 'ReturnData/IRS4562/GeneralDepreciationSystem/GDS15YearProperty/DepreciationConventionCd'),
  (540730, NULL, NULL, 'Depreciation Method Cd', 'TEXT', 'ReturnData/IRS4562/GeneralDepreciationSystem/GDS15YearProperty/DepreciationMethodCd'),
  (540731, NULL, NULL, 'Depreciation Deduction Amt', 'CURRENCY', 'ReturnData/IRS4562/GeneralDepreciationSystem/GDSNonRsdntlRealPropSpecify/DepreciationDeductionAmt'),
  (540732, NULL, NULL, 'Basis For Depreciation Amt', 'CURRENCY', 'ReturnData/IRS4562/GeneralDepreciationSystem/GDSNonRsdntlRealPropSpecify/BasisForDepreciationAmt'),
  (540733, NULL, NULL, 'Recovery Prd', 'TEXT', 'ReturnData/IRS4562/GeneralDepreciationSystem/GDSNonRsdntlRealPropSpecify/RecoveryPrd'),
  (540734, NULL, NULL, 'Depreciation Deduction Amt', 'CURRENCY', 'ReturnData/IRS4562/GeneralDepreciationSystem/GDS10YearProperty/DepreciationDeductionAmt'),
  (540735, NULL, NULL, 'Basis For Depreciation Amt', 'CURRENCY', 'ReturnData/IRS4562/GeneralDepreciationSystem/GDS10YearProperty/BasisForDepreciationAmt'),
  (540736, NULL, NULL, 'Basis For Depreciation Amt', 'CURRENCY', 'ReturnData/IRS4562/GeneralDepreciationSystem/GDSResidentialRentalProperty/BasisForDepreciationAmt'),
  (540737, NULL, NULL, 'Depreciation Convention Cd', 'TEXT', 'ReturnData/IRS4562/GeneralDepreciationSystem/GDS10YearProperty/DepreciationConventionCd'),
  (540738, NULL, NULL, 'Depreciation Method Cd', 'TEXT', 'ReturnData/IRS4562/GeneralDepreciationSystem/GDS10YearProperty/DepreciationMethodCd'),
  (540739, NULL, NULL, 'Recovery Prd', 'TEXT', 'ReturnData/IRS4562/GeneralDepreciationSystem/GDS10YearProperty/RecoveryPrd'),
  (540740, NULL, NULL, 'Depreciation Deduction Amt', 'CURRENCY', 'ReturnData/IRS4562/GeneralDepreciationSystem/GDSResidentialRentalProperty/DepreciationDeductionAmt'),
  (540741, NULL, NULL, 'Month And Year Placed In Service Dt', 'TEXT', 'ReturnData/IRS4562/GeneralDepreciationSystem/GDSResidentialRentalProperty/MonthAndYearPlacedInServiceDt'),
  (540742, NULL, NULL, 'Month And Year Placed In Service Dt', 'TEXT', 'ReturnData/IRS4562/GeneralDepreciationSystem/GDSNonRsdntlRealPropSpecify/MonthAndYearPlacedInServiceDt'),
  (540743, NULL, NULL, 'Basis For Depreciation Amt', 'CURRENCY', 'ReturnData/IRS4562/GeneralDepreciationSystem/GDS3YearProperty/BasisForDepreciationAmt'),
  (540744, NULL, NULL, 'Depreciation Convention Cd', 'TEXT', 'ReturnData/IRS4562/GeneralDepreciationSystem/GDS3YearProperty/DepreciationConventionCd'),
  (540745, NULL, NULL, 'Depreciation Deduction Amt', 'CURRENCY', 'ReturnData/IRS4562/GeneralDepreciationSystem/GDS3YearProperty/DepreciationDeductionAmt'),
  (540746, NULL, NULL, 'Depreciation Method Cd', 'TEXT', 'ReturnData/IRS4562/GeneralDepreciationSystem/GDS3YearProperty/DepreciationMethodCd'),
  (540747, NULL, NULL, 'Recovery Prd', 'TEXT', 'ReturnData/IRS4562/GeneralDepreciationSystem/GDS3YearProperty/RecoveryPrd'),
  (540748, NULL, NULL, 'Basis For Depreciation Amt', 'CURRENCY', 'ReturnData/IRS4562/GeneralDepreciationSystem/GDS20YearProperty/BasisForDepreciationAmt'),
  (540749, NULL, NULL, 'Depreciation Convention Cd', 'TEXT', 'ReturnData/IRS4562/GeneralDepreciationSystem/GDS20YearProperty/DepreciationConventionCd'),
  (540750, NULL, NULL, 'Depreciation Deduction Amt', 'CURRENCY', 'ReturnData/IRS4562/GeneralDepreciationSystem/GDS20YearProperty/DepreciationDeductionAmt'),
  (540751, NULL, NULL, 'Depreciation Method Cd', 'TEXT', 'ReturnData/IRS4562/GeneralDepreciationSystem/GDS20YearProperty/DepreciationMethodCd'),
  (540752, NULL, NULL, 'Recovery Prd', 'TEXT', 'ReturnData/IRS4562/GeneralDepreciationSystem/GDS20YearProperty/RecoveryPrd'),
  (540753, NULL, NULL, 'Basis For Depreciation Amt', 'CURRENCY', 'ReturnData/IRS4562/GeneralDepreciationSystem/GDS25YearProperty/BasisForDepreciationAmt'),
  (540754, NULL, NULL, 'Depreciation Convention Cd', 'TEXT', 'ReturnData/IRS4562/GeneralDepreciationSystem/GDS25YearProperty/DepreciationConventionCd'),
  (540755, NULL, NULL, 'Depreciation Deduction Amt', 'CURRENCY', 'ReturnData/IRS4562/GeneralDepreciationSystem/GDS25YearProperty/DepreciationDeductionAmt');

-- 990T / Long Term Capital Gain And Loss Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54024, 54, '025', 'Long Term Capital Gain And Loss Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (540756, 54024, '1', 'Total Proceeds Sales Price Amt', 'CURRENCY'),
  (540757, 54024, '2', 'Proceeds Sales Price Amt', 'CURRENCY'),
  (540758, 54024, '3', 'Total Cost Or Other Basis Amt', 'CURRENCY'),
  (540759, 54024, '4', 'Cost Or Other Basis Amt', 'CURRENCY'),
  (540760, 54024, '5', 'Tot Adjustments To Gain Or Loss Amt', 'CURRENCY'),
  (540761, 54024, '6', 'Adjustments To Gain Or Loss Amt', 'CURRENCY'),
  (540762, 54024, '7', 'Date Acquired Inherited Cd', 'TEXT'),
  (540763, 54024, '8', 'Sold Or Disposed Dt', 'TEXT'),
  (540764, 54024, '9', 'Acquired Dt', 'TEXT'),
  (540765, 54024, '10', 'Trans Rpt On1099 B That Show Bss Ind', 'BOOLEAN'),
  (540766, 54024, '11', 'Trans Rpt On1099 B Not Show Basis Ind', 'BOOLEAN'),
  (540767, 54024, '12', 'Adjustments To Gain Or Loss Cd', 'TEXT'),
  (540768, 54024, '13', 'EIN', 'TEXT'),
  (540769, 54024, '14', 'Sold Or Disposed Cd', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (540756, NULL, NULL, 'Total Proceeds Sales Price Amt', 'CURRENCY', 'ReturnData/IRS8949/LongTermCapitalGainAndLossGrp/TotalProceedsSalesPriceAmt'),
  (540757, NULL, NULL, 'Proceeds Sales Price Amt', 'CURRENCY', 'ReturnData/IRS8949/LongTermCapitalGainAndLossGrp/CapitalGainAndLossAssetGrp/ProceedsSalesPriceAmt'),
  (540758, NULL, NULL, 'Total Cost Or Other Basis Amt', 'CURRENCY', 'ReturnData/IRS8949/LongTermCapitalGainAndLossGrp/TotalCostOrOtherBasisAmt'),
  (540759, NULL, NULL, 'Cost Or Other Basis Amt', 'CURRENCY', 'ReturnData/IRS8949/LongTermCapitalGainAndLossGrp/CapitalGainAndLossAssetGrp/CostOrOtherBasisAmt'),
  (540760, NULL, NULL, 'Tot Adjustments To Gain Or Loss Amt', 'CURRENCY', 'ReturnData/IRS8949/LongTermCapitalGainAndLossGrp/TotAdjustmentsToGainOrLossAmt'),
  (540761, NULL, NULL, 'Adjustments To Gain Or Loss Amt', 'CURRENCY', 'ReturnData/IRS8949/LongTermCapitalGainAndLossGrp/CapitalGainAndLossAssetGrp/AdjustmentsToGainOrLossAmt'),
  (540762, NULL, NULL, 'Date Acquired Inherited Cd', 'TEXT', 'ReturnData/IRS8949/LongTermCapitalGainAndLossGrp/CapitalGainAndLossAssetGrp/DateAcquiredInheritedCd'),
  (540763, NULL, NULL, 'Sold Or Disposed Dt', 'TEXT', 'ReturnData/IRS8949/LongTermCapitalGainAndLossGrp/CapitalGainAndLossAssetGrp/SoldOrDisposedDt'),
  (540764, NULL, NULL, 'Acquired Dt', 'TEXT', 'ReturnData/IRS8949/LongTermCapitalGainAndLossGrp/CapitalGainAndLossAssetGrp/AcquiredDt'),
  (540765, NULL, NULL, 'Trans Rpt On1099 B That Show Bss Ind', 'BOOLEAN', 'ReturnData/IRS8949/LongTermCapitalGainAndLossGrp/TransRptOn1099BThatShowBssInd'),
  (540766, NULL, NULL, 'Trans Rpt On1099 B Not Show Basis Ind', 'BOOLEAN', 'ReturnData/IRS8949/LongTermCapitalGainAndLossGrp/TransRptOn1099BNotShowBasisInd'),
  (540767, NULL, NULL, 'Adjustments To Gain Or Loss Cd', 'TEXT', 'ReturnData/IRS8949/LongTermCapitalGainAndLossGrp/CapitalGainAndLossAssetGrp/AdjustmentsToGainOrLossCd'),
  (540768, NULL, NULL, 'EIN', 'TEXT', 'ReturnData/IRS8949/LongTermCapitalGainAndLossGrp/CapitalGainAndLossAssetGrp/EIN'),
  (540769, NULL, NULL, 'Sold Or Disposed Cd', 'TEXT', 'ReturnData/IRS8949/LongTermCapitalGainAndLossGrp/CapitalGainAndLossAssetGrp/SoldOrDisposedCd');

-- 990T / Short Term Capital Gain And Loss Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54025, 54, '026', 'Short Term Capital Gain And Loss Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (540770, 54025, '1', 'Total Proceeds Sales Price Amt', 'CURRENCY'),
  (540771, 54025, '2', 'Proceeds Sales Price Amt', 'CURRENCY'),
  (540772, 54025, '3', 'Total Cost Or Other Basis Amt', 'CURRENCY'),
  (540773, 54025, '4', 'Tot Adjustments To Gain Or Loss Amt', 'CURRENCY'),
  (540774, 54025, '5', 'Adjustments To Gain Or Loss Amt', 'CURRENCY'),
  (540775, 54025, '6', 'Cost Or Other Basis Amt', 'CURRENCY'),
  (540776, 54025, '7', 'Date Acquired Inherited Cd', 'TEXT'),
  (540777, 54025, '8', 'Sold Or Disposed Dt', 'TEXT'),
  (540778, 54025, '9', 'Trans Rpt On1099 B That Show Bss Ind', 'BOOLEAN'),
  (540779, 54025, '10', 'Acquired Dt', 'TEXT'),
  (540780, 54025, '11', 'Trans Rpt On1099 B Not Show Basis Ind', 'BOOLEAN'),
  (540781, 54025, '12', 'Adjustments To Gain Or Loss Cd', 'TEXT'),
  (540782, 54025, '13', 'EIN', 'TEXT'),
  (540783, 54025, '14', 'Sold Or Disposed Cd', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (540770, NULL, NULL, 'Total Proceeds Sales Price Amt', 'CURRENCY', 'ReturnData/IRS8949/ShortTermCapitalGainAndLossGrp/TotalProceedsSalesPriceAmt'),
  (540771, NULL, NULL, 'Proceeds Sales Price Amt', 'CURRENCY', 'ReturnData/IRS8949/ShortTermCapitalGainAndLossGrp/CapitalGainAndLossAssetGrp/ProceedsSalesPriceAmt'),
  (540772, NULL, NULL, 'Total Cost Or Other Basis Amt', 'CURRENCY', 'ReturnData/IRS8949/ShortTermCapitalGainAndLossGrp/TotalCostOrOtherBasisAmt'),
  (540773, NULL, NULL, 'Tot Adjustments To Gain Or Loss Amt', 'CURRENCY', 'ReturnData/IRS8949/ShortTermCapitalGainAndLossGrp/TotAdjustmentsToGainOrLossAmt'),
  (540774, NULL, NULL, 'Adjustments To Gain Or Loss Amt', 'CURRENCY', 'ReturnData/IRS8949/ShortTermCapitalGainAndLossGrp/CapitalGainAndLossAssetGrp/AdjustmentsToGainOrLossAmt'),
  (540775, NULL, NULL, 'Cost Or Other Basis Amt', 'CURRENCY', 'ReturnData/IRS8949/ShortTermCapitalGainAndLossGrp/CapitalGainAndLossAssetGrp/CostOrOtherBasisAmt'),
  (540776, NULL, NULL, 'Date Acquired Inherited Cd', 'TEXT', 'ReturnData/IRS8949/ShortTermCapitalGainAndLossGrp/CapitalGainAndLossAssetGrp/DateAcquiredInheritedCd'),
  (540777, NULL, NULL, 'Sold Or Disposed Dt', 'TEXT', 'ReturnData/IRS8949/ShortTermCapitalGainAndLossGrp/CapitalGainAndLossAssetGrp/SoldOrDisposedDt'),
  (540778, NULL, NULL, 'Trans Rpt On1099 B That Show Bss Ind', 'BOOLEAN', 'ReturnData/IRS8949/ShortTermCapitalGainAndLossGrp/TransRptOn1099BThatShowBssInd'),
  (540779, NULL, NULL, 'Acquired Dt', 'TEXT', 'ReturnData/IRS8949/ShortTermCapitalGainAndLossGrp/CapitalGainAndLossAssetGrp/AcquiredDt'),
  (540780, NULL, NULL, 'Trans Rpt On1099 B Not Show Basis Ind', 'BOOLEAN', 'ReturnData/IRS8949/ShortTermCapitalGainAndLossGrp/TransRptOn1099BNotShowBasisInd'),
  (540781, NULL, NULL, 'Adjustments To Gain Or Loss Cd', 'TEXT', 'ReturnData/IRS8949/ShortTermCapitalGainAndLossGrp/CapitalGainAndLossAssetGrp/AdjustmentsToGainOrLossCd'),
  (540782, NULL, NULL, 'EIN', 'TEXT', 'ReturnData/IRS8949/ShortTermCapitalGainAndLossGrp/CapitalGainAndLossAssetGrp/EIN'),
  (540783, NULL, NULL, 'Sold Or Disposed Cd', 'TEXT', 'ReturnData/IRS8949/ShortTermCapitalGainAndLossGrp/CapitalGainAndLossAssetGrp/SoldOrDisposedCd');

-- 990T / Tot Gen Bus CY Credit Amt Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54026, 54, '027', 'Tot Gen Bus CY Credit Amt Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (540784, 54026, '1', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (540785, 54026, '2', 'Total General Bus Credits Amt', 'CURRENCY'),
  (540786, 54026, '3', 'Net Elective Pymt Election Amt', 'CURRENCY'),
  (540787, 54026, '4', 'Gross Elective Pymt Election Amt', 'CURRENCY'),
  (540788, 54026, '5', 'CY General Business Cr Item Cnt', 'INTEGER'),
  (540789, 54026, '6', 'Total General Bus Credits App Tx Amt', 'CURRENCY'),
  (540790, 54026, '7', 'Credit Transfer Election Amt', 'CURRENCY'),
  (540791, 54026, '8', 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY'),
  (540792, 54026, '9', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (540784, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/TotGenBusCYCreditAmtGrp/GeneralBusCrFromNnPssvActyAmt'),
  (540785, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/TotGenBusCYCreditAmtGrp/TotalGeneralBusCreditsAmt'),
  (540786, NULL, NULL, 'Net Elective Pymt Election Amt', 'CURRENCY', 'ReturnData/IRS3800/TotGenBusCYCreditAmtGrp/NetElectivePymtElectionAmt'),
  (540787, NULL, NULL, 'Gross Elective Pymt Election Amt', 'CURRENCY', 'ReturnData/IRS3800/TotGenBusCYCreditAmtGrp/GrossElectivePymtElectionAmt'),
  (540788, NULL, NULL, 'CY General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/TotGenBusCYCreditAmtGrp/CYGeneralBusinessCrItemCnt'),
  (540789, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/TotGenBusCYCreditAmtGrp/TotalGeneralBusCreditsAppTxAmt'),
  (540790, NULL, NULL, 'Credit Transfer Election Amt', 'CURRENCY', 'ReturnData/IRS3800/TotGenBusCYCreditAmtGrp/CreditTransferElectionAmt'),
  (540791, NULL, NULL, 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY', 'ReturnData/IRS3800/TotGenBusCYCreditAmtGrp/CYAndPYPassiveActyCrAllwCYAmt'),
  (540792, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/TotGenBusCYCreditAmtGrp/CrSubjToPassiveActyLmtAmt');

-- 990T / IRS1120 Schedule D Direct Fields
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54027, 54, '028', 'IRS1120 Schedule D Direct Fields');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (540793, 54027, '1', 'Dispose Investment QOF Ind', 'BOOLEAN'),
  (540794, 54027, '2', 'Unused Capital Loss Carryover Amt', 'CURRENCY'),
  (540795, 54027, '3', 'Capital Gain Distributions Amt', 'CURRENCY'),
  (540796, 54027, '4', 'LT Cap Gain Instal Sls Amt', 'CURRENCY'),
  (540797, 54027, '5', 'ST Cap Gain Instal Sls Amt', 'CURRENCY'),
  (540798, 54027, '6', 'LT Cap Gain Loss Like Kind Exch Amt', 'CURRENCY'),
  (540799, 54027, '7', 'ST Cap Gain Loss Like Kind Exch Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (540793, NULL, NULL, 'Dispose Investment QOF Ind', 'BOOLEAN', 'ReturnData/IRS1120ScheduleD/DisposeInvestmentQOFInd'),
  (540794, NULL, NULL, 'Unused Capital Loss Carryover Amt', 'CURRENCY', 'ReturnData/IRS1120ScheduleD/UnusedCapitalLossCarryoverAmt'),
  (540795, NULL, NULL, 'Capital Gain Distributions Amt', 'CURRENCY', 'ReturnData/IRS1120ScheduleD/CapitalGainDistributionsAmt'),
  (540796, NULL, NULL, 'LT Cap Gain Instal Sls Amt', 'CURRENCY', 'ReturnData/IRS1120ScheduleD/LTCapGainInstalSlsAmt'),
  (540797, NULL, NULL, 'ST Cap Gain Instal Sls Amt', 'CURRENCY', 'ReturnData/IRS1120ScheduleD/STCapGainInstalSlsAmt'),
  (540798, NULL, NULL, 'LT Cap Gain Loss Like Kind Exch Amt', 'CURRENCY', 'ReturnData/IRS1120ScheduleD/LTCapGainLossLikeKindExchAmt'),
  (540799, NULL, NULL, 'ST Cap Gain Loss Like Kind Exch Amt', 'CURRENCY', 'ReturnData/IRS1120ScheduleD/STCapGainLossLikeKindExchAmt');

-- 990T / Gen Bus CY Credits Sub Tot2 Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54028, 54, '029', 'Gen Bus CY Credits Sub Tot2 Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (540800, 54028, '1', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (540801, 54028, '2', 'Total General Bus Credits Amt', 'CURRENCY'),
  (540802, 54028, '3', 'Net Elective Pymt Election Amt', 'CURRENCY'),
  (540803, 54028, '4', 'Gross Elective Pymt Election Amt', 'CURRENCY'),
  (540804, 54028, '5', 'Total General Bus Credits App Tx Amt', 'CURRENCY'),
  (540805, 54028, '6', 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY'),
  (540806, 54028, '7', 'Credit Transfer Election Amt', 'CURRENCY'),
  (540807, 54028, '8', 'CY General Business Cr Item Cnt', 'INTEGER'),
  (540808, 54028, '9', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (540800, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCYCreditsSubTot2Grp/GeneralBusCrFromNnPssvActyAmt'),
  (540801, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCYCreditsSubTot2Grp/TotalGeneralBusCreditsAmt'),
  (540802, NULL, NULL, 'Net Elective Pymt Election Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCYCreditsSubTot2Grp/NetElectivePymtElectionAmt'),
  (540803, NULL, NULL, 'Gross Elective Pymt Election Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCYCreditsSubTot2Grp/GrossElectivePymtElectionAmt'),
  (540804, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCYCreditsSubTot2Grp/TotalGeneralBusCreditsAppTxAmt'),
  (540805, NULL, NULL, 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCYCreditsSubTot2Grp/CYAndPYPassiveActyCrAllwCYAmt'),
  (540806, NULL, NULL, 'Credit Transfer Election Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCYCreditsSubTot2Grp/CreditTransferElectionAmt'),
  (540807, NULL, NULL, 'CY General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/GenBusCYCreditsSubTot2Grp/CYGeneralBusinessCrItemCnt'),
  (540808, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCYCreditsSubTot2Grp/CrSubjToPassiveActyLmtAmt');

-- 990T / Int Annts Rylts Rent Ctrl Org Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54029, 54, '030', 'Int Annts Rylts Rent Ctrl Org Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (540809, 54029, '1', 'Business Name Line1 Txt', 'TEXT'),
  (540810, 54029, '2', 'Nnxmpt Ctrl Org Pymt Gross Incm Amt', 'CURRENCY'),
  (540811, 54029, '3', 'EIN', 'TEXT'),
  (540812, 54029, '4', 'Exmpt Ctrl Org Pymt Gross Incm Amt', 'CURRENCY'),
  (540813, 54029, '5', 'Nnxmpt Ctrl Org Tot Spcfd Pymt Amt', 'CURRENCY'),
  (540814, 54029, '6', 'Nnxmpt Ctrl Org Deduction Amt', 'CURRENCY'),
  (540815, 54029, '7', 'Exmpt Ctrl Org Tot Spcfd Pymt Amt', 'CURRENCY'),
  (540816, 54029, '8', 'Exmpt Ctrl Org Deduction Amt', 'CURRENCY'),
  (540817, 54029, '9', 'Nnxmpt Ctrl Org Net Unrlt Incm Amt', 'CURRENCY'),
  (540818, 54029, '10', 'Nnxmpt Ctrl Org Taxable Income Amt', 'CURRENCY'),
  (540819, 54029, '11', 'Exmpt Ctrl Org Net Unrlt Incm Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (540809, NULL, NULL, 'Business Name Line1 Txt', 'TEXT', 'ReturnData/IRS990TScheduleA/IntAnntsRyltsRentCtrlOrgGrp/BusinessName/BusinessNameLine1Txt'),
  (540810, NULL, NULL, 'Nnxmpt Ctrl Org Pymt Gross Incm Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/IntAnntsRyltsRentCtrlOrgGrp/NnxmptCtrlOrgPymtGrossIncmAmt'),
  (540811, NULL, NULL, 'EIN', 'TEXT', 'ReturnData/IRS990TScheduleA/IntAnntsRyltsRentCtrlOrgGrp/EIN'),
  (540812, NULL, NULL, 'Exmpt Ctrl Org Pymt Gross Incm Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/IntAnntsRyltsRentCtrlOrgGrp/ExmptCtrlOrgPymtGrossIncmAmt'),
  (540813, NULL, NULL, 'Nnxmpt Ctrl Org Tot Spcfd Pymt Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/IntAnntsRyltsRentCtrlOrgGrp/NnxmptCtrlOrgTotSpcfdPymtAmt'),
  (540814, NULL, NULL, 'Nnxmpt Ctrl Org Deduction Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/IntAnntsRyltsRentCtrlOrgGrp/NnxmptCtrlOrgDeductionAmt'),
  (540815, NULL, NULL, 'Exmpt Ctrl Org Tot Spcfd Pymt Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/IntAnntsRyltsRentCtrlOrgGrp/ExmptCtrlOrgTotSpcfdPymtAmt'),
  (540816, NULL, NULL, 'Exmpt Ctrl Org Deduction Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/IntAnntsRyltsRentCtrlOrgGrp/ExmptCtrlOrgDeductionAmt'),
  (540817, NULL, NULL, 'Nnxmpt Ctrl Org Net Unrlt Incm Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/IntAnntsRyltsRentCtrlOrgGrp/NnxmptCtrlOrgNetUnrltIncmAmt'),
  (540818, NULL, NULL, 'Nnxmpt Ctrl Org Taxable Income Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/IntAnntsRyltsRentCtrlOrgGrp/NnxmptCtrlOrgTaxableIncomeAmt'),
  (540819, NULL, NULL, 'Exmpt Ctrl Org Net Unrlt Incm Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/IntAnntsRyltsRentCtrlOrgGrp/ExmptCtrlOrgNetUnrltIncmAmt');

-- 990T / Investment Incm Sect501c7917 Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54030, 54, '031', 'Investment Incm Sect501c7917 Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (540820, 54030, '1', 'Income Type Desc', 'TEXT'),
  (540821, 54030, '2', 'Investment Income Amt', 'CURRENCY'),
  (540822, 54030, '3', 'Deduction Set Asides Amt', 'CURRENCY'),
  (540823, 54030, '4', 'Investment Income Deduction Amt', 'CURRENCY'),
  (540824, 54030, '5', 'Investment Income Set Asides Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (540820, NULL, NULL, 'Income Type Desc', 'TEXT', 'ReturnData/IRS990TScheduleA/InvestmentIncmSect501c7917Grp/IncomeTypeDesc'),
  (540821, NULL, NULL, 'Investment Income Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/InvestmentIncmSect501c7917Grp/InvestmentIncomeAmt'),
  (540822, NULL, NULL, 'Deduction Set Asides Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/InvestmentIncmSect501c7917Grp/DeductionSetAsidesAmt'),
  (540823, NULL, NULL, 'Investment Income Deduction Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/InvestmentIncmSect501c7917Grp/InvestmentIncomeDeductionAmt'),
  (540824, NULL, NULL, 'Investment Income Set Asides Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/InvestmentIncmSect501c7917Grp/InvestmentIncomeSetAsidesAmt');

-- 990T / Gen Bus CY Credits Sub Tot Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54031, 54, '032', 'Gen Bus CY Credits Sub Tot Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (540825, 54031, '1', 'Total General Bus Credits Amt', 'CURRENCY'),
  (540826, 54031, '2', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (540827, 54031, '3', 'Net Elective Pymt Election Amt', 'CURRENCY'),
  (540828, 54031, '4', 'Total General Bus Credits App Tx Amt', 'CURRENCY'),
  (540829, 54031, '5', 'Gross Elective Pymt Election Amt', 'CURRENCY'),
  (540830, 54031, '6', 'CY General Business Cr Item Cnt', 'INTEGER'),
  (540831, 54031, '7', 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY'),
  (540832, 54031, '8', 'Credit Transfer Election Amt', 'CURRENCY'),
  (540833, 54031, '9', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (540825, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCYCreditsSubTotGrp/TotalGeneralBusCreditsAmt'),
  (540826, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCYCreditsSubTotGrp/GeneralBusCrFromNnPssvActyAmt'),
  (540827, NULL, NULL, 'Net Elective Pymt Election Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCYCreditsSubTotGrp/NetElectivePymtElectionAmt'),
  (540828, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCYCreditsSubTotGrp/TotalGeneralBusCreditsAppTxAmt'),
  (540829, NULL, NULL, 'Gross Elective Pymt Election Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCYCreditsSubTotGrp/GrossElectivePymtElectionAmt'),
  (540830, NULL, NULL, 'CY General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/GenBusCYCreditsSubTotGrp/CYGeneralBusinessCrItemCnt'),
  (540831, NULL, NULL, 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCYCreditsSubTotGrp/CYAndPYPassiveActyCrAllwCYAmt'),
  (540832, NULL, NULL, 'Credit Transfer Election Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCYCreditsSubTotGrp/CreditTransferElectionAmt'),
  (540833, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCYCreditsSubTotGrp/CrSubjToPassiveActyLmtAmt');

-- 990T / Form3468 Part VICY Credits Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54032, 54, '033', 'Form3468 Part VICY Credits Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (540834, 54032, '1', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (540835, 54032, '2', 'Gross Elective Pymt Election Amt', 'CURRENCY'),
  (540836, 54032, '3', 'Net Elective Pymt Election Amt', 'CURRENCY'),
  (540837, 54032, '4', 'Total General Bus Credits Amt', 'CURRENCY'),
  (540838, 54032, '5', 'Elective Payment Registration Num', 'INTEGER'),
  (540839, 54032, '6', 'CY General Business Cr Item Cnt', 'INTEGER'),
  (540840, 54032, '7', 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY'),
  (540841, 54032, '8', 'Credit Transfer Election Amt', 'CURRENCY'),
  (540842, 54032, '9', 'Total General Bus Credits App Tx Amt', 'CURRENCY'),
  (540843, 54032, '10', 'Pass Through Entity EIN', 'TEXT'),
  (540844, 54032, '11', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (540845, 54032, '12', 'Transfer Registration Num', 'INTEGER'),
  (540846, 54032, '13', 'Transfer Credit Entity EIN', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (540834, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Form3468PartVICYCreditsGrp/GeneralBusCrFromNnPssvActyAmt'),
  (540835, NULL, NULL, 'Gross Elective Pymt Election Amt', 'CURRENCY', 'ReturnData/IRS3800/Form3468PartVICYCreditsGrp/GrossElectivePymtElectionAmt'),
  (540836, NULL, NULL, 'Net Elective Pymt Election Amt', 'CURRENCY', 'ReturnData/IRS3800/Form3468PartVICYCreditsGrp/NetElectivePymtElectionAmt'),
  (540837, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/Form3468PartVICYCreditsGrp/TotalGeneralBusCreditsAmt'),
  (540838, NULL, NULL, 'Elective Payment Registration Num', 'INTEGER', 'ReturnData/IRS3800/Form3468PartVICYCreditsGrp/ElectivePaymentRegistrationNum'),
  (540839, NULL, NULL, 'CY General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Form3468PartVICYCreditsGrp/CYGeneralBusinessCrItemCnt'),
  (540840, NULL, NULL, 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY', 'ReturnData/IRS3800/Form3468PartVICYCreditsGrp/CYAndPYPassiveActyCrAllwCYAmt'),
  (540841, NULL, NULL, 'Credit Transfer Election Amt', 'CURRENCY', 'ReturnData/IRS3800/Form3468PartVICYCreditsGrp/CreditTransferElectionAmt'),
  (540842, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Form3468PartVICYCreditsGrp/TotalGeneralBusCreditsAppTxAmt'),
  (540843, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Form3468PartVICYCreditsGrp/PassThroughEntityEIN'),
  (540844, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Form3468PartVICYCreditsGrp/CrSubjToPassiveActyLmtAmt'),
  (540845, NULL, NULL, 'Transfer Registration Num', 'INTEGER', 'ReturnData/IRS3800/Form3468PartVICYCreditsGrp/TransferRegistrationNum'),
  (540846, NULL, NULL, 'Transfer Credit Entity EIN', 'TEXT', 'ReturnData/IRS3800/Form3468PartVICYCreditsGrp/TransferCreditEntityEIN');

-- 990T / More Than Half Business Use Prop
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54033, 54, '034', 'More Than Half Business Use Prop');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (540847, 54033, '1', 'Placed In Service Dt', 'TEXT'),
  (540848, 54033, '2', 'Property Desc', 'TEXT'),
  (540849, 54033, '3', 'Cost Or Other Basis Amt', 'CURRENCY'),
  (540850, 54033, '4', 'Business Investment Use Pct', 'PERCENT'),
  (540851, 54033, '5', 'Recovery Prd', 'TEXT'),
  (540852, 54033, '6', 'Basis For Depreciation Amt', 'CURRENCY'),
  (540853, 54033, '7', 'Deprec Mthd And Convention Type Cd', 'TEXT'),
  (540854, 54033, '8', 'Depreciation Deduction Amt', 'CURRENCY'),
  (540855, 54033, '9', 'Elected Section179 Cost Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (540847, NULL, NULL, 'Placed In Service Dt', 'TEXT', 'ReturnData/IRS4562/MoreThanHalfBusinessUseProp/PlacedInServiceDt'),
  (540848, NULL, NULL, 'Property Desc', 'TEXT', 'ReturnData/IRS4562/MoreThanHalfBusinessUseProp/PropertyDesc'),
  (540849, NULL, NULL, 'Cost Or Other Basis Amt', 'CURRENCY', 'ReturnData/IRS4562/MoreThanHalfBusinessUseProp/CostOrOtherBasisAmt'),
  (540850, NULL, NULL, 'Business Investment Use Pct', 'PERCENT', 'ReturnData/IRS4562/MoreThanHalfBusinessUseProp/BusinessInvestmentUsePct'),
  (540851, NULL, NULL, 'Recovery Prd', 'TEXT', 'ReturnData/IRS4562/MoreThanHalfBusinessUseProp/RecoveryPrd'),
  (540852, NULL, NULL, 'Basis For Depreciation Amt', 'CURRENCY', 'ReturnData/IRS4562/MoreThanHalfBusinessUseProp/BasisForDepreciationAmt'),
  (540853, NULL, NULL, 'Deprec Mthd And Convention Type Cd', 'TEXT', 'ReturnData/IRS4562/MoreThanHalfBusinessUseProp/DeprecMthdAndConventionTypeCd'),
  (540854, NULL, NULL, 'Depreciation Deduction Amt', 'CURRENCY', 'ReturnData/IRS4562/MoreThanHalfBusinessUseProp/DepreciationDeductionAmt'),
  (540855, NULL, NULL, 'Elected Section179 Cost Amt', 'CURRENCY', 'ReturnData/IRS4562/MoreThanHalfBusinessUseProp/ElectedSection179CostAmt');

-- 990T / IRS8801 Direct Fields
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54034, 54, '035', 'IRS8801 Direct Fields');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (540856, 54034, '1', 'Min Tax Credit Exemption Amt', 'CURRENCY'),
  (540857, 54034, '2', 'Min Tax Credit Phase Out Amt', 'CURRENCY'),
  (540858, 54034, '3', 'AMT Carryforward Plus Negative Amt', 'CURRENCY'),
  (540859, 54034, '4', 'Net Min Tax Less Loss And Ded Amt', 'CURRENCY'),
  (540860, 54034, '5', 'Net Min Tax On Exclusion Items Amt', 'CURRENCY'),
  (540861, 54034, '6', 'Sum Min Tax Credit Loss And Ded Amt', 'CURRENCY'),
  (540862, 54034, '7', 'Net Min Tax Cr Minus Phase Out Amt', 'CURRENCY'),
  (540863, 54034, '8', 'Net Min Tax Minus Exemption Amt', 'CURRENCY'),
  (540864, 54034, '9', 'Tent Min Tax Minus Reg Tax Liab Amt', 'CURRENCY'),
  (540865, 54034, '10', 'AMT Cr Carryforward To Next Year Amt', 'CURRENCY'),
  (540866, 54034, '11', 'AMT Prior Year Carryforward Amt', 'CURRENCY'),
  (540867, 54034, '12', 'Filing Threshold Amt', 'CURRENCY'),
  (540868, 54034, '13', 'Max Cap Gains Applicable Limit Amt', 'CURRENCY'),
  (540869, 54034, '14', 'Sum Threshold Applcbl Wrksht Amt', 'CURRENCY'),
  (540870, 54034, '15', 'CY Reg Tax Liabi Minus Allwbl Cr Amt', 'CURRENCY'),
  (540871, 54034, '16', 'PY Min Tax Applicable Cap Gain Amt', 'CURRENCY'),
  (540872, 54034, '17', 'Smaller PY Sch D Gain Or Wrksht Amt', 'CURRENCY'),
  (540873, 54034, '18', 'CY Tentative Minimum Tax Amt', 'CURRENCY'),
  (540874, 54034, '19', 'Net Alternative Minimum Tax Amt', 'CURRENCY'),
  (540875, 54034, '20', 'PY Alternative Minimum Tax Amt', 'CURRENCY'),
  (540876, 54034, '21', 'Flng Thrshld Less Theshold Sum Amt', 'CURRENCY'),
  (540877, 54034, '22', 'Net Alt Min Txbl Inc Times FS Pct Amt', 'CURRENCY'),
  (540878, 54034, '23', 'Net Min Tax Less Deductions Amt', 'CURRENCY'),
  (540879, 54034, '24', 'PY Min Tax Applicable Rtn Tax Amt', 'CURRENCY'),
  (540880, 54034, '25', 'Max Cap Gain Minus Applcbl Limit Amt', 'CURRENCY'),
  (540881, 54034, '26', 'Net Min Tax Times Tax Rate Amt', 'CURRENCY'),
  (540882, 54034, '27', 'Smaller Net AMT Or Gain Amt', 'CURRENCY'),
  (540883, 54034, '28', 'Smllr Net Min Tax Or Applcbl Gain Amt', 'CURRENCY'),
  (540884, 54034, '29', 'Sum Of Alt Min Tax Percentages Amt', 'CURRENCY'),
  (540885, 54034, '30', 'Tax On Alternative Minimum Gain Amt', 'CURRENCY'),
  (540886, 54034, '31', 'Tentative Min Tax On Excl Items Amt', 'CURRENCY'),
  (540887, 54034, '32', 'Gain Minus Smaller Net Amt', 'CURRENCY'),
  (540888, 54034, '33', 'Excess Of Sum Amt', 'CURRENCY'),
  (540889, 54034, '34', 'Excess Of Sum Times Pct Amt', 'CURRENCY'),
  (540890, 54034, '35', 'Applcbl Cap Gains Or Sch D Wrksht Amt', 'CURRENCY'),
  (540891, 54034, '36', 'Min AMT Cr Amt', 'CURRENCY'),
  (540892, 54034, '37', 'Net Min Tax Cr Times Decimal Amt', 'CURRENCY'),
  (540893, 54034, '38', 'AMT Prior Year Applicable Gain Amt', 'CURRENCY'),
  (540894, 54034, '39', 'Sum Of Smllr Amt', 'CURRENCY'),
  (540895, 54034, '40', 'Net Alt Min Taxable Inc Times Pct Amt', 'CURRENCY'),
  (540896, 54034, '41', 'Smllr Adj Net Gain Or Txbl Inc Amt', 'CURRENCY'),
  (540897, 54034, '42', 'Smaller Calculated Net Or Gain Amt', 'CURRENCY'),
  (540898, 54034, '43', 'AMT Less Smaller Of Tax Or Gain Amt', 'CURRENCY'),
  (540899, 54034, '44', 'Net Adj AMT Txbl Inc Times Pct Amt', 'CURRENCY'),
  (540900, 54034, '45', 'Net Min Tax Exclusion Items Amt', 'CURRENCY'),
  (540901, 54034, '46', 'Net Min Tax Taxable Income Loss Amt', 'CURRENCY'),
  (540902, 54034, '47', 'Min Tax Credit Net Opr Loss Ded Amt', 'CURRENCY'),
  (540903, 54034, '48', 'PY Unrecaptured S1250 Gain Amt', 'CURRENCY'),
  (540904, 54034, '49', 'Total Net Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (540856, NULL, NULL, 'Min Tax Credit Exemption Amt', 'CURRENCY', 'ReturnData/IRS8801/MinTaxCreditExemptionAmt'),
  (540857, NULL, NULL, 'Min Tax Credit Phase Out Amt', 'CURRENCY', 'ReturnData/IRS8801/MinTaxCreditPhaseOutAmt'),
  (540858, NULL, NULL, 'AMT Carryforward Plus Negative Amt', 'CURRENCY', 'ReturnData/IRS8801/AMTCarryforwardPlusNegativeAmt'),
  (540859, NULL, NULL, 'Net Min Tax Less Loss And Ded Amt', 'CURRENCY', 'ReturnData/IRS8801/NetMinTaxLessLossAndDedAmt'),
  (540860, NULL, NULL, 'Net Min Tax On Exclusion Items Amt', 'CURRENCY', 'ReturnData/IRS8801/NetMinTaxOnExclusionItemsAmt'),
  (540861, NULL, NULL, 'Sum Min Tax Credit Loss And Ded Amt', 'CURRENCY', 'ReturnData/IRS8801/SumMinTaxCreditLossAndDedAmt'),
  (540862, NULL, NULL, 'Net Min Tax Cr Minus Phase Out Amt', 'CURRENCY', 'ReturnData/IRS8801/NetMinTaxCrMinusPhaseOutAmt'),
  (540863, NULL, NULL, 'Net Min Tax Minus Exemption Amt', 'CURRENCY', 'ReturnData/IRS8801/NetMinTaxMinusExemptionAmt'),
  (540864, NULL, NULL, 'Tent Min Tax Minus Reg Tax Liab Amt', 'CURRENCY', 'ReturnData/IRS8801/TentMinTaxMinusRegTaxLiabAmt'),
  (540865, NULL, NULL, 'AMT Cr Carryforward To Next Year Amt', 'CURRENCY', 'ReturnData/IRS8801/AMTCrCarryforwardToNextYearAmt'),
  (540866, NULL, NULL, 'AMT Prior Year Carryforward Amt', 'CURRENCY', 'ReturnData/IRS8801/AMTPriorYearCarryforwardAmt'),
  (540867, NULL, NULL, 'Filing Threshold Amt', 'CURRENCY', 'ReturnData/IRS8801/FilingThresholdAmt'),
  (540868, NULL, NULL, 'Max Cap Gains Applicable Limit Amt', 'CURRENCY', 'ReturnData/IRS8801/MaxCapGainsApplicableLimitAmt'),
  (540869, NULL, NULL, 'Sum Threshold Applcbl Wrksht Amt', 'CURRENCY', 'ReturnData/IRS8801/SumThresholdApplcblWrkshtAmt'),
  (540870, NULL, NULL, 'CY Reg Tax Liabi Minus Allwbl Cr Amt', 'CURRENCY', 'ReturnData/IRS8801/CYRegTaxLiabiMinusAllwblCrAmt'),
  (540871, NULL, NULL, 'PY Min Tax Applicable Cap Gain Amt', 'CURRENCY', 'ReturnData/IRS8801/PYMinTaxApplicableCapGainAmt'),
  (540872, NULL, NULL, 'Smaller PY Sch D Gain Or Wrksht Amt', 'CURRENCY', 'ReturnData/IRS8801/SmallerPYSchDGainOrWrkshtAmt'),
  (540873, NULL, NULL, 'CY Tentative Minimum Tax Amt', 'CURRENCY', 'ReturnData/IRS8801/CYTentativeMinimumTaxAmt'),
  (540874, NULL, NULL, 'Net Alternative Minimum Tax Amt', 'CURRENCY', 'ReturnData/IRS8801/NetAlternativeMinimumTaxAmt'),
  (540875, NULL, NULL, 'PY Alternative Minimum Tax Amt', 'CURRENCY', 'ReturnData/IRS8801/PYAlternativeMinimumTaxAmt'),
  (540876, NULL, NULL, 'Flng Thrshld Less Theshold Sum Amt', 'CURRENCY', 'ReturnData/IRS8801/FlngThrshldLessThesholdSumAmt'),
  (540877, NULL, NULL, 'Net Alt Min Txbl Inc Times FS Pct Amt', 'CURRENCY', 'ReturnData/IRS8801/NetAltMinTxblIncTimesFSPctAmt'),
  (540878, NULL, NULL, 'Net Min Tax Less Deductions Amt', 'CURRENCY', 'ReturnData/IRS8801/NetMinTaxLessDeductionsAmt'),
  (540879, NULL, NULL, 'PY Min Tax Applicable Rtn Tax Amt', 'CURRENCY', 'ReturnData/IRS8801/PYMinTaxApplicableRtnTaxAmt'),
  (540880, NULL, NULL, 'Max Cap Gain Minus Applcbl Limit Amt', 'CURRENCY', 'ReturnData/IRS8801/MaxCapGainMinusApplcblLimitAmt'),
  (540881, NULL, NULL, 'Net Min Tax Times Tax Rate Amt', 'CURRENCY', 'ReturnData/IRS8801/NetMinTaxTimesTaxRateAmt'),
  (540882, NULL, NULL, 'Smaller Net AMT Or Gain Amt', 'CURRENCY', 'ReturnData/IRS8801/SmallerNetAMTOrGainAmt'),
  (540883, NULL, NULL, 'Smllr Net Min Tax Or Applcbl Gain Amt', 'CURRENCY', 'ReturnData/IRS8801/SmllrNetMinTaxOrApplcblGainAmt'),
  (540884, NULL, NULL, 'Sum Of Alt Min Tax Percentages Amt', 'CURRENCY', 'ReturnData/IRS8801/SumOfAltMinTaxPercentagesAmt'),
  (540885, NULL, NULL, 'Tax On Alternative Minimum Gain Amt', 'CURRENCY', 'ReturnData/IRS8801/TaxOnAlternativeMinimumGainAmt'),
  (540886, NULL, NULL, 'Tentative Min Tax On Excl Items Amt', 'CURRENCY', 'ReturnData/IRS8801/TentativeMinTaxOnExclItemsAmt'),
  (540887, NULL, NULL, 'Gain Minus Smaller Net Amt', 'CURRENCY', 'ReturnData/IRS8801/GainMinusSmallerNetAmt'),
  (540888, NULL, NULL, 'Excess Of Sum Amt', 'CURRENCY', 'ReturnData/IRS8801/ExcessOfSumAmt'),
  (540889, NULL, NULL, 'Excess Of Sum Times Pct Amt', 'CURRENCY', 'ReturnData/IRS8801/ExcessOfSumTimesPctAmt'),
  (540890, NULL, NULL, 'Applcbl Cap Gains Or Sch D Wrksht Amt', 'CURRENCY', 'ReturnData/IRS8801/ApplcblCapGainsOrSchDWrkshtAmt'),
  (540891, NULL, NULL, 'Min AMT Cr Amt', 'CURRENCY', 'ReturnData/IRS8801/MinAMTCrAmt'),
  (540892, NULL, NULL, 'Net Min Tax Cr Times Decimal Amt', 'CURRENCY', 'ReturnData/IRS8801/NetMinTaxCrTimesDecimalAmt'),
  (540893, NULL, NULL, 'AMT Prior Year Applicable Gain Amt', 'CURRENCY', 'ReturnData/IRS8801/AMTPriorYearApplicableGainAmt'),
  (540894, NULL, NULL, 'Sum Of Smllr Amt', 'CURRENCY', 'ReturnData/IRS8801/SumOfSmllrAmt'),
  (540895, NULL, NULL, 'Net Alt Min Taxable Inc Times Pct Amt', 'CURRENCY', 'ReturnData/IRS8801/NetAltMinTaxableIncTimesPctAmt'),
  (540896, NULL, NULL, 'Smllr Adj Net Gain Or Txbl Inc Amt', 'CURRENCY', 'ReturnData/IRS8801/SmllrAdjNetGainOrTxblIncAmt'),
  (540897, NULL, NULL, 'Smaller Calculated Net Or Gain Amt', 'CURRENCY', 'ReturnData/IRS8801/SmallerCalculatedNetOrGainAmt'),
  (540898, NULL, NULL, 'AMT Less Smaller Of Tax Or Gain Amt', 'CURRENCY', 'ReturnData/IRS8801/AMTLessSmallerOfTaxOrGainAmt'),
  (540899, NULL, NULL, 'Net Adj AMT Txbl Inc Times Pct Amt', 'CURRENCY', 'ReturnData/IRS8801/NetAdjAMTTxblIncTimesPctAmt'),
  (540900, NULL, NULL, 'Net Min Tax Exclusion Items Amt', 'CURRENCY', 'ReturnData/IRS8801/NetMinTaxExclusionItemsAmt'),
  (540901, NULL, NULL, 'Net Min Tax Taxable Income Loss Amt', 'CURRENCY', 'ReturnData/IRS8801/NetMinTaxTaxableIncomeLossAmt'),
  (540902, NULL, NULL, 'Min Tax Credit Net Opr Loss Ded Amt', 'CURRENCY', 'ReturnData/IRS8801/MinTaxCreditNetOprLossDedAmt'),
  (540903, NULL, NULL, 'PY Unrecaptured S1250 Gain Amt', 'CURRENCY', 'ReturnData/IRS8801/PYUnrecapturedS1250GainAmt'),
  (540904, NULL, NULL, 'Total Net Amt', 'CURRENCY', 'ReturnData/IRS8801/TotalNetAmt');

-- 990T / Parent Corporation Name
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54035, 54, '036', 'Parent Corporation Name');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (540905, 54035, '1', 'Business Name Line1 Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (540905, NULL, NULL, 'Business Name Line1 Txt', 'TEXT', 'ReturnData/IRS990T/ParentCorporationName/BusinessNameLine1Txt');

-- 990T / IRS4136 Direct Fields
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54036, 54, '037', 'IRS4136 Direct Fields');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (540906, 54036, '1', 'Total Fuel Tax Credit Amt', 'CURRENCY'),
  (540907, 54036, '2', 'Nontaxable Use Of Gasoline Cr Amt', 'CURRENCY'),
  (540908, 54036, '3', 'Farm Prps Undyed Dsl Fuel Cr Amt', 'CURRENCY'),
  (540909, 54036, '4', 'Non Tx Krsn Used In Avn Txd244 Cr Amt', 'CURRENCY'),
  (540910, 54036, '5', 'Aviation Nontx Gas Cr Amt', 'CURRENCY'),
  (540911, 54036, '6', 'Non Tx Krsn Used In Avn Txd219 Cr Amt', 'CURRENCY'),
  (540912, 54036, '7', 'Liquefied Petroleum Gas Cr Amt', 'CURRENCY'),
  (540913, 54036, '8', 'Nontx Liquefied Ptrlm Gas Cr Amt', 'CURRENCY'),
  (540914, 54036, '9', 'Aviation Gasoline Credit Amt', 'CURRENCY'),
  (540915, 54036, '10', 'Compressed Natural Gas Credit Amt', 'CURRENCY'),
  (540916, 54036, '11', 'Exp Nontx Aviation Gas Cr Amt', 'CURRENCY'),
  (540917, 54036, '12', 'Exported Nontx Use Of Gas Cr Amt', 'CURRENCY'),
  (540918, 54036, '13', 'Agri Biodiesel Mixture Credit Amt', 'CURRENCY'),
  (540919, 54036, '14', 'Biodiesel Mixture Credit Amt', 'CURRENCY'),
  (540920, 54036, '15', 'Blndr Cr Use Dsl Wtr Emulsion Cr Amt', 'CURRENCY'),
  (540921, 54036, '16', 'Bus Use Of Undyed Diesel Credit Amt', 'CURRENCY'),
  (540922, 54036, '17', 'Bus Use Of Undyed Kerosene Cr Amt', 'CURRENCY'),
  (540923, 54036, '18', 'Compressed Gas Biomass Credit Amt', 'CURRENCY'),
  (540924, 54036, '19', 'Dsl Fuel Sold St Local Govt Cr Amt', 'CURRENCY'),
  (540925, 54036, '20', 'Exp Nontx Use Dsl Wtr Emulsion Cr Amt', 'CURRENCY'),
  (540926, 54036, '21', 'Exp Undyed Diesel Fuel Credit Amt', 'CURRENCY'),
  (540927, 54036, '22', 'Exported Dyed Diesel Fuel Cr Amt', 'CURRENCY'),
  (540928, 54036, '23', 'Exported Dyed Kerosene Credit Amt', 'CURRENCY'),
  (540929, 54036, '24', 'Exported Undyed Kerosene Cr Amt', 'CURRENCY'),
  (540930, 54036, '25', 'Farm Prps Undyed Kerosene Cr Amt', 'CURRENCY'),
  (540931, 54036, '26', 'Kerosene Used In Avn Txd219 Cr Amt', 'CURRENCY'),
  (540932, 54036, '27', 'Kerosene Used In Avn Txd244 Cr Amt', 'CURRENCY'),
  (540933, 54036, '28', 'Krsn Avn Sold St Local Govt Cr Amt', 'CURRENCY'),
  (540934, 54036, '29', 'Krsn Fuel Sold St Local Govt Cr Amt', 'CURRENCY'),
  (540935, 54036, '30', 'LUST Tx Avn Fuel Frgn Trade Cr Amt', 'CURRENCY'),
  (540936, 54036, '31', 'LUST Tx Krsn Avn Frgn Trd Cr Amt', 'CURRENCY'),
  (540937, 54036, '32', 'LUST Tx Sls Krsn Avn Frgn Trd Cr Amt', 'CURRENCY'),
  (540938, 54036, '33', 'Liquefied Gas Der Biomass Cr Amt', 'CURRENCY'),
  (540939, 54036, '34', 'Liquefied Hydrogen Credit Amt', 'CURRENCY'),
  (540940, 54036, '35', 'Liquefied Natural Gas Credit Amt', 'CURRENCY'),
  (540941, 54036, '36', 'Liquid Fuel Der Biomass Cr Amt', 'CURRENCY'),
  (540942, 54036, '37', 'Liquid Fuel Der From Coal Credit Amt', 'CURRENCY'),
  (540943, 54036, '38', 'Nontx Compressed Natural Gas Cr Amt', 'CURRENCY'),
  (540944, 54036, '39', 'Nontx Liq Fuel Der Biomass Cr Amt', 'CURRENCY'),
  (540945, 54036, '40', 'Nontx Liqfd Fuel Der From Coal Cr Amt', 'CURRENCY'),
  (540946, 54036, '41', 'Nontx Liquefied Gas Biomass Cr Amt', 'CURRENCY'),
  (540947, 54036, '42', 'Nontx Liquefied Hydrogen Cr Amt', 'CURRENCY'),
  (540948, 54036, '43', 'Nontx Liquefied Natural Gas Cr Amt', 'CURRENCY'),
  (540949, 54036, '44', 'Nontx P Series Fuels Credit Amt', 'CURRENCY'),
  (540950, 54036, '45', 'Nontx Use Diesel Wtr Emulsion Cr Amt', 'CURRENCY'),
  (540951, 54036, '46', 'Nontx Use Undyed Krsn Txd044 Cr Amt', 'CURRENCY'),
  (540952, 54036, '47', 'Nontx Use Undyed Krsn Txd219 Cr Amt', 'CURRENCY'),
  (540953, 54036, '48', 'P Series Fuels Credit Amt', 'CURRENCY'),
  (540954, 54036, '49', 'Renewable Diesel Mixture Cr Amt', 'CURRENCY'),
  (540955, 54036, '50', 'Sls Krsn Nnxmpt Use In Avn Cr Amt', 'CURRENCY'),
  (540956, 54036, '51', 'Sls Krsn Oth Nontx Txd219 Cr Amt', 'CURRENCY'),
  (540957, 54036, '52', 'Sls Krsn Oth Nontx Txd244 Cr Amt', 'CURRENCY'),
  (540958, 54036, '53', 'Sls Krsn Used In Avn Txd219 Cr Amt', 'CURRENCY'),
  (540959, 54036, '54', 'Sls Krsn Used In Avn Txd244 Cr Amt', 'CURRENCY'),
  (540960, 54036, '55', 'Sls Undyed Diesel Use Bus Cr Amt', 'CURRENCY'),
  (540961, 54036, '56', 'Sls Undyed Dsl Use St Lcl Govt Cr Amt', 'CURRENCY'),
  (540962, 54036, '57', 'Sls Undyed Krsn Block Pump Cr Amt', 'CURRENCY'),
  (540963, 54036, '58', 'Sls Undyed Krsn Use Bus Cr Amt', 'CURRENCY'),
  (540964, 54036, '59', 'Train Use Of Undyed Diesel Cr Amt', 'CURRENCY'),
  (540965, 54036, '60', 'Sustainable Aviation Fuel Cr Amt', 'CURRENCY'),
  (540966, 54036, '61', 'Alternative Fuel Registration Num', 'INTEGER');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (540906, NULL, NULL, 'Total Fuel Tax Credit Amt', 'CURRENCY', 'ReturnData/IRS4136/TotalFuelTaxCreditAmt'),
  (540907, NULL, NULL, 'Nontaxable Use Of Gasoline Cr Amt', 'CURRENCY', 'ReturnData/IRS4136/NontaxableUseOfGasolineCrAmt'),
  (540908, NULL, NULL, 'Farm Prps Undyed Dsl Fuel Cr Amt', 'CURRENCY', 'ReturnData/IRS4136/FarmPrpsUndyedDslFuelCrAmt'),
  (540909, NULL, NULL, 'Non Tx Krsn Used In Avn Txd244 Cr Amt', 'CURRENCY', 'ReturnData/IRS4136/NonTxKrsnUsedInAvnTxd244CrAmt'),
  (540910, NULL, NULL, 'Aviation Nontx Gas Cr Amt', 'CURRENCY', 'ReturnData/IRS4136/AviationNontxGasCrAmt'),
  (540911, NULL, NULL, 'Non Tx Krsn Used In Avn Txd219 Cr Amt', 'CURRENCY', 'ReturnData/IRS4136/NonTxKrsnUsedInAvnTxd219CrAmt'),
  (540912, NULL, NULL, 'Liquefied Petroleum Gas Cr Amt', 'CURRENCY', 'ReturnData/IRS4136/LiquefiedPetroleumGasCrAmt'),
  (540913, NULL, NULL, 'Nontx Liquefied Ptrlm Gas Cr Amt', 'CURRENCY', 'ReturnData/IRS4136/NontxLiquefiedPtrlmGasCrAmt'),
  (540914, NULL, NULL, 'Aviation Gasoline Credit Amt', 'CURRENCY', 'ReturnData/IRS4136/AviationGasolineCreditAmt'),
  (540915, NULL, NULL, 'Compressed Natural Gas Credit Amt', 'CURRENCY', 'ReturnData/IRS4136/CompressedNaturalGasCreditAmt'),
  (540916, NULL, NULL, 'Exp Nontx Aviation Gas Cr Amt', 'CURRENCY', 'ReturnData/IRS4136/ExpNontxAviationGasCrAmt'),
  (540917, NULL, NULL, 'Exported Nontx Use Of Gas Cr Amt', 'CURRENCY', 'ReturnData/IRS4136/ExportedNontxUseOfGasCrAmt'),
  (540918, NULL, NULL, 'Agri Biodiesel Mixture Credit Amt', 'CURRENCY', 'ReturnData/IRS4136/AgriBiodieselMixtureCreditAmt'),
  (540919, NULL, NULL, 'Biodiesel Mixture Credit Amt', 'CURRENCY', 'ReturnData/IRS4136/BiodieselMixtureCreditAmt'),
  (540920, NULL, NULL, 'Blndr Cr Use Dsl Wtr Emulsion Cr Amt', 'CURRENCY', 'ReturnData/IRS4136/BlndrCrUseDslWtrEmulsionCrAmt'),
  (540921, NULL, NULL, 'Bus Use Of Undyed Diesel Credit Amt', 'CURRENCY', 'ReturnData/IRS4136/BusUseOfUndyedDieselCreditAmt'),
  (540922, NULL, NULL, 'Bus Use Of Undyed Kerosene Cr Amt', 'CURRENCY', 'ReturnData/IRS4136/BusUseOfUndyedKeroseneCrAmt'),
  (540923, NULL, NULL, 'Compressed Gas Biomass Credit Amt', 'CURRENCY', 'ReturnData/IRS4136/CompressedGasBiomassCreditAmt'),
  (540924, NULL, NULL, 'Dsl Fuel Sold St Local Govt Cr Amt', 'CURRENCY', 'ReturnData/IRS4136/DslFuelSoldStLocalGovtCrAmt'),
  (540925, NULL, NULL, 'Exp Nontx Use Dsl Wtr Emulsion Cr Amt', 'CURRENCY', 'ReturnData/IRS4136/ExpNontxUseDslWtrEmulsionCrAmt'),
  (540926, NULL, NULL, 'Exp Undyed Diesel Fuel Credit Amt', 'CURRENCY', 'ReturnData/IRS4136/ExpUndyedDieselFuelCreditAmt'),
  (540927, NULL, NULL, 'Exported Dyed Diesel Fuel Cr Amt', 'CURRENCY', 'ReturnData/IRS4136/ExportedDyedDieselFuelCrAmt'),
  (540928, NULL, NULL, 'Exported Dyed Kerosene Credit Amt', 'CURRENCY', 'ReturnData/IRS4136/ExportedDyedKeroseneCreditAmt'),
  (540929, NULL, NULL, 'Exported Undyed Kerosene Cr Amt', 'CURRENCY', 'ReturnData/IRS4136/ExportedUndyedKeroseneCrAmt'),
  (540930, NULL, NULL, 'Farm Prps Undyed Kerosene Cr Amt', 'CURRENCY', 'ReturnData/IRS4136/FarmPrpsUndyedKeroseneCrAmt'),
  (540931, NULL, NULL, 'Kerosene Used In Avn Txd219 Cr Amt', 'CURRENCY', 'ReturnData/IRS4136/KeroseneUsedInAvnTxd219CrAmt'),
  (540932, NULL, NULL, 'Kerosene Used In Avn Txd244 Cr Amt', 'CURRENCY', 'ReturnData/IRS4136/KeroseneUsedInAvnTxd244CrAmt'),
  (540933, NULL, NULL, 'Krsn Avn Sold St Local Govt Cr Amt', 'CURRENCY', 'ReturnData/IRS4136/KrsnAvnSoldStLocalGovtCrAmt'),
  (540934, NULL, NULL, 'Krsn Fuel Sold St Local Govt Cr Amt', 'CURRENCY', 'ReturnData/IRS4136/KrsnFuelSoldStLocalGovtCrAmt'),
  (540935, NULL, NULL, 'LUST Tx Avn Fuel Frgn Trade Cr Amt', 'CURRENCY', 'ReturnData/IRS4136/LUSTTxAvnFuelFrgnTradeCrAmt'),
  (540936, NULL, NULL, 'LUST Tx Krsn Avn Frgn Trd Cr Amt', 'CURRENCY', 'ReturnData/IRS4136/LUSTTxKrsnAvnFrgnTrdCrAmt'),
  (540937, NULL, NULL, 'LUST Tx Sls Krsn Avn Frgn Trd Cr Amt', 'CURRENCY', 'ReturnData/IRS4136/LUSTTxSlsKrsnAvnFrgnTrdCrAmt'),
  (540938, NULL, NULL, 'Liquefied Gas Der Biomass Cr Amt', 'CURRENCY', 'ReturnData/IRS4136/LiquefiedGasDerBiomassCrAmt'),
  (540939, NULL, NULL, 'Liquefied Hydrogen Credit Amt', 'CURRENCY', 'ReturnData/IRS4136/LiquefiedHydrogenCreditAmt'),
  (540940, NULL, NULL, 'Liquefied Natural Gas Credit Amt', 'CURRENCY', 'ReturnData/IRS4136/LiquefiedNaturalGasCreditAmt'),
  (540941, NULL, NULL, 'Liquid Fuel Der Biomass Cr Amt', 'CURRENCY', 'ReturnData/IRS4136/LiquidFuelDerBiomassCrAmt'),
  (540942, NULL, NULL, 'Liquid Fuel Der From Coal Credit Amt', 'CURRENCY', 'ReturnData/IRS4136/LiquidFuelDerFromCoalCreditAmt'),
  (540943, NULL, NULL, 'Nontx Compressed Natural Gas Cr Amt', 'CURRENCY', 'ReturnData/IRS4136/NontxCompressedNaturalGasCrAmt'),
  (540944, NULL, NULL, 'Nontx Liq Fuel Der Biomass Cr Amt', 'CURRENCY', 'ReturnData/IRS4136/NontxLiqFuelDerBiomassCrAmt'),
  (540945, NULL, NULL, 'Nontx Liqfd Fuel Der From Coal Cr Amt', 'CURRENCY', 'ReturnData/IRS4136/NontxLiqfdFuelDerFromCoalCrAmt'),
  (540946, NULL, NULL, 'Nontx Liquefied Gas Biomass Cr Amt', 'CURRENCY', 'ReturnData/IRS4136/NontxLiquefiedGasBiomassCrAmt'),
  (540947, NULL, NULL, 'Nontx Liquefied Hydrogen Cr Amt', 'CURRENCY', 'ReturnData/IRS4136/NontxLiquefiedHydrogenCrAmt'),
  (540948, NULL, NULL, 'Nontx Liquefied Natural Gas Cr Amt', 'CURRENCY', 'ReturnData/IRS4136/NontxLiquefiedNaturalGasCrAmt'),
  (540949, NULL, NULL, 'Nontx P Series Fuels Credit Amt', 'CURRENCY', 'ReturnData/IRS4136/NontxPSeriesFuelsCreditAmt'),
  (540950, NULL, NULL, 'Nontx Use Diesel Wtr Emulsion Cr Amt', 'CURRENCY', 'ReturnData/IRS4136/NontxUseDieselWtrEmulsionCrAmt'),
  (540951, NULL, NULL, 'Nontx Use Undyed Krsn Txd044 Cr Amt', 'CURRENCY', 'ReturnData/IRS4136/NontxUseUndyedKrsnTxd044CrAmt'),
  (540952, NULL, NULL, 'Nontx Use Undyed Krsn Txd219 Cr Amt', 'CURRENCY', 'ReturnData/IRS4136/NontxUseUndyedKrsnTxd219CrAmt'),
  (540953, NULL, NULL, 'P Series Fuels Credit Amt', 'CURRENCY', 'ReturnData/IRS4136/PSeriesFuelsCreditAmt'),
  (540954, NULL, NULL, 'Renewable Diesel Mixture Cr Amt', 'CURRENCY', 'ReturnData/IRS4136/RenewableDieselMixtureCrAmt'),
  (540955, NULL, NULL, 'Sls Krsn Nnxmpt Use In Avn Cr Amt', 'CURRENCY', 'ReturnData/IRS4136/SlsKrsnNnxmptUseInAvnCrAmt'),
  (540956, NULL, NULL, 'Sls Krsn Oth Nontx Txd219 Cr Amt', 'CURRENCY', 'ReturnData/IRS4136/SlsKrsnOthNontxTxd219CrAmt'),
  (540957, NULL, NULL, 'Sls Krsn Oth Nontx Txd244 Cr Amt', 'CURRENCY', 'ReturnData/IRS4136/SlsKrsnOthNontxTxd244CrAmt'),
  (540958, NULL, NULL, 'Sls Krsn Used In Avn Txd219 Cr Amt', 'CURRENCY', 'ReturnData/IRS4136/SlsKrsnUsedInAvnTxd219CrAmt'),
  (540959, NULL, NULL, 'Sls Krsn Used In Avn Txd244 Cr Amt', 'CURRENCY', 'ReturnData/IRS4136/SlsKrsnUsedInAvnTxd244CrAmt'),
  (540960, NULL, NULL, 'Sls Undyed Diesel Use Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS4136/SlsUndyedDieselUseBusCrAmt'),
  (540961, NULL, NULL, 'Sls Undyed Dsl Use St Lcl Govt Cr Amt', 'CURRENCY', 'ReturnData/IRS4136/SlsUndyedDslUseStLclGovtCrAmt'),
  (540962, NULL, NULL, 'Sls Undyed Krsn Block Pump Cr Amt', 'CURRENCY', 'ReturnData/IRS4136/SlsUndyedKrsnBlockPumpCrAmt'),
  (540963, NULL, NULL, 'Sls Undyed Krsn Use Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS4136/SlsUndyedKrsnUseBusCrAmt'),
  (540964, NULL, NULL, 'Train Use Of Undyed Diesel Cr Amt', 'CURRENCY', 'ReturnData/IRS4136/TrainUseOfUndyedDieselCrAmt'),
  (540965, NULL, NULL, 'Sustainable Aviation Fuel Cr Amt', 'CURRENCY', 'ReturnData/IRS4136/SustainableAviationFuelCrAmt'),
  (540966, NULL, NULL, 'Alternative Fuel Registration Num', 'INTEGER', 'ReturnData/IRS4136/AlternativeFuelRegistrationNum');

-- 990T / Total LTCGL1099 B Not Received Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54037, 54, '038', 'Total LTCGL1099 B Not Received Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (540967, 54037, '1', 'Total Proceeds Sales Price Amt', 'CURRENCY'),
  (540968, 54037, '2', 'Total Cost Or Other Basis Amt', 'CURRENCY'),
  (540969, 54037, '3', 'Tot Adjustments To Gain Or Loss Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (540967, NULL, NULL, 'Total Proceeds Sales Price Amt', 'CURRENCY', 'ReturnData/IRS1120ScheduleD/TotalLTCGL1099BNotReceivedGrp/TotalProceedsSalesPriceAmt'),
  (540968, NULL, NULL, 'Total Cost Or Other Basis Amt', 'CURRENCY', 'ReturnData/IRS1120ScheduleD/TotalLTCGL1099BNotReceivedGrp/TotalCostOrOtherBasisAmt'),
  (540969, NULL, NULL, 'Tot Adjustments To Gain Or Loss Amt', 'CURRENCY', 'ReturnData/IRS1120ScheduleD/TotalLTCGL1099BNotReceivedGrp/TotAdjustmentsToGainOrLossAmt');

-- 990T / Total STCGL1099 B Not Received Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54038, 54, '039', 'Total STCGL1099 B Not Received Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (540970, 54038, '1', 'Total Proceeds Sales Price Amt', 'CURRENCY'),
  (540971, 54038, '2', 'Total Cost Or Other Basis Amt', 'CURRENCY'),
  (540972, 54038, '3', 'Tot Adjustments To Gain Or Loss Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (540970, NULL, NULL, 'Total Proceeds Sales Price Amt', 'CURRENCY', 'ReturnData/IRS1120ScheduleD/TotalSTCGL1099BNotReceivedGrp/TotalProceedsSalesPriceAmt'),
  (540971, NULL, NULL, 'Total Cost Or Other Basis Amt', 'CURRENCY', 'ReturnData/IRS1120ScheduleD/TotalSTCGL1099BNotReceivedGrp/TotalCostOrOtherBasisAmt'),
  (540972, NULL, NULL, 'Tot Adjustments To Gain Or Loss Amt', 'CURRENCY', 'ReturnData/IRS1120ScheduleD/TotalSTCGL1099BNotReceivedGrp/TotAdjustmentsToGainOrLossAmt');

-- 990T / IRS1041 Schedule D Direct Fields
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54039, 54, '040', 'IRS1041 Schedule D Direct Fields');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (540973, 54039, '1', 'Net ST Capital Gain Or Loss Amt', 'CURRENCY'),
  (540974, 54039, '2', 'Net ST Gain Or Loss From Sch K1 Amt', 'CURRENCY'),
  (540975, 54039, '3', 'Form4797 Gain Or Loss Amt', 'CURRENCY'),
  (540976, 54039, '4', 'LT Capital Loss Carryover Amt', 'CURRENCY'),
  (540977, 54039, '5', 'ST Capital Loss Carryover Amt', 'CURRENCY'),
  (540978, 54039, '6', 'LT Gain Or Loss From Forms Amt', 'CURRENCY'),
  (540979, 54039, '7', 'ST Gain Or Loss From Forms Amt', 'CURRENCY'),
  (540980, 54039, '8', 'Capital Gain Distributions Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (540973, NULL, NULL, 'Net ST Capital Gain Or Loss Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/NetSTCapitalGainOrLossAmt'),
  (540974, NULL, NULL, 'Net ST Gain Or Loss From Sch K1 Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/NetSTGainOrLossFromSchK1Amt'),
  (540975, NULL, NULL, 'Form4797 Gain Or Loss Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/Form4797GainOrLossAmt'),
  (540976, NULL, NULL, 'LT Capital Loss Carryover Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/LTCapitalLossCarryoverAmt'),
  (540977, NULL, NULL, 'ST Capital Loss Carryover Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/STCapitalLossCarryoverAmt'),
  (540978, NULL, NULL, 'LT Gain Or Loss From Forms Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/LTGainOrLossFromFormsAmt'),
  (540979, NULL, NULL, 'ST Gain Or Loss From Forms Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/STGainOrLossFromFormsAmt'),
  (540980, NULL, NULL, 'Capital Gain Distributions Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/CapitalGainDistributionsAmt');

-- 990T / Form6765 CY Credits Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54040, 54, '041', 'Form6765 CY Credits Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (540981, 54040, '1', 'Total General Bus Credits Amt', 'CURRENCY'),
  (540982, 54040, '2', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (540983, 54040, '3', 'CY General Business Cr Item Cnt', 'INTEGER'),
  (540984, 54040, '4', 'Pass Through Entity EIN', 'TEXT'),
  (540985, 54040, '5', 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY'),
  (540986, 54040, '6', 'Total General Bus Credits App Tx Amt', 'CURRENCY'),
  (540987, 54040, '7', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (540988, 54040, '8', 'Transfer Credit Entity EIN', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (540981, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/Form6765CYCreditsGrp/TotalGeneralBusCreditsAmt'),
  (540982, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Form6765CYCreditsGrp/GeneralBusCrFromNnPssvActyAmt'),
  (540983, NULL, NULL, 'CY General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Form6765CYCreditsGrp/CYGeneralBusinessCrItemCnt'),
  (540984, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Form6765CYCreditsGrp/PassThroughEntityEIN'),
  (540985, NULL, NULL, 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY', 'ReturnData/IRS3800/Form6765CYCreditsGrp/CYAndPYPassiveActyCrAllwCYAmt'),
  (540986, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Form6765CYCreditsGrp/TotalGeneralBusCreditsAppTxAmt'),
  (540987, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Form6765CYCreditsGrp/CrSubjToPassiveActyLmtAmt'),
  (540988, NULL, NULL, 'Transfer Credit Entity EIN', 'TEXT', 'ReturnData/IRS3800/Form6765CYCreditsGrp/TransferCreditEntityEIN');

-- 990T / Advertising Incm Periodical Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54041, 54, '042', 'Advertising Incm Periodical Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (540989, 54041, '1', 'Circulation Income Amt', 'CURRENCY'),
  (540990, 54041, '2', 'Consolidated Periodical Ind', 'BOOLEAN');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (540989, NULL, NULL, 'Circulation Income Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/AdvertisingIncmPeriodicalGrp/CirculationIncomeAmt'),
  (540990, NULL, NULL, 'Consolidated Periodical Ind', 'BOOLEAN', 'ReturnData/IRS990TScheduleA/AdvertisingIncmPeriodicalGrp/ConsolidatedPeriodicalInd');

-- 990T / Form8846 CY Credits Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54042, 54, '043', 'Form8846 CY Credits Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (540991, 54042, '1', 'Total General Bus Credits Amt', 'CURRENCY'),
  (540992, 54042, '2', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (540993, 54042, '3', 'CY General Business Cr Item Cnt', 'INTEGER'),
  (540994, 54042, '4', 'Pass Through Entity EIN', 'TEXT'),
  (540995, 54042, '5', 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY'),
  (540996, 54042, '6', 'Total General Bus Credits App Tx Amt', 'CURRENCY'),
  (540997, 54042, '7', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (540991, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8846CYCreditsGrp/TotalGeneralBusCreditsAmt'),
  (540992, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8846CYCreditsGrp/GeneralBusCrFromNnPssvActyAmt'),
  (540993, NULL, NULL, 'CY General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Form8846CYCreditsGrp/CYGeneralBusinessCrItemCnt'),
  (540994, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Form8846CYCreditsGrp/PassThroughEntityEIN'),
  (540995, NULL, NULL, 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8846CYCreditsGrp/CYAndPYPassiveActyCrAllwCYAmt'),
  (540996, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8846CYCreditsGrp/TotalGeneralBusCreditsAppTxAmt'),
  (540997, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8846CYCreditsGrp/CrSubjToPassiveActyLmtAmt');

-- 990T / Itmzd Supplemental Info Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54043, 54, '044', 'Itmzd Supplemental Info Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (540998, 54043, '1', 'Explanation Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (540998, NULL, NULL, 'Explanation Amt', 'CURRENCY', 'ReturnData/IRS990T/ItmzdSupplementalInfoGrp/ExplanationAmt');

-- 990T / Form8936 Part VCY Credits Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54044, 54, '045', 'Form8936 Part VCY Credits Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (540999, 54044, '1', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541000, 54044, '2', 'Net Elective Pymt Election Amt', 'CURRENCY'),
  (541001, 54044, '3', 'Total General Bus Credits Amt', 'CURRENCY'),
  (541002, 54044, '4', 'Gross Elective Pymt Election Amt', 'CURRENCY'),
  (541003, 54044, '5', 'CY General Business Cr Item Cnt', 'INTEGER'),
  (541004, 54044, '6', 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY'),
  (541005, 54044, '7', 'Elective Payment Registration Num', 'INTEGER'),
  (541006, 54044, '8', 'Total General Bus Credits App Tx Amt', 'CURRENCY'),
  (541007, 54044, '9', 'Pass Through Entity EIN', 'TEXT'),
  (541008, 54044, '10', 'Transfer Registration Num', 'INTEGER'),
  (541009, 54044, '11', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (541010, 54044, '12', 'Missing EIN Reason Cd', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (540999, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8936PartVCYCreditsGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541000, NULL, NULL, 'Net Elective Pymt Election Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8936PartVCYCreditsGrp/NetElectivePymtElectionAmt'),
  (541001, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8936PartVCYCreditsGrp/TotalGeneralBusCreditsAmt'),
  (541002, NULL, NULL, 'Gross Elective Pymt Election Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8936PartVCYCreditsGrp/GrossElectivePymtElectionAmt'),
  (541003, NULL, NULL, 'CY General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Form8936PartVCYCreditsGrp/CYGeneralBusinessCrItemCnt'),
  (541004, NULL, NULL, 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8936PartVCYCreditsGrp/CYAndPYPassiveActyCrAllwCYAmt'),
  (541005, NULL, NULL, 'Elective Payment Registration Num', 'INTEGER', 'ReturnData/IRS3800/Form8936PartVCYCreditsGrp/ElectivePaymentRegistrationNum'),
  (541006, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8936PartVCYCreditsGrp/TotalGeneralBusCreditsAppTxAmt'),
  (541007, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Form8936PartVCYCreditsGrp/PassThroughEntityEIN'),
  (541008, NULL, NULL, 'Transfer Registration Num', 'INTEGER', 'ReturnData/IRS3800/Form8936PartVCYCreditsGrp/TransferRegistrationNum'),
  (541009, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8936PartVCYCreditsGrp/CrSubjToPassiveActyLmtAmt'),
  (541010, NULL, NULL, 'Missing EIN Reason Cd', 'TEXT', 'ReturnData/IRS3800/Form8936PartVCYCreditsGrp/MissingEINReasonCd');

-- 990T / Itmzd Supplemental Info Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54045, 54, '046', 'Itmzd Supplemental Info Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541011, 54045, '1', 'Explanation Txt', 'TEXT'),
  (541012, 54045, '2', 'Line Num', 'INTEGER'),
  (541013, 54045, '3', 'Part Num', 'INTEGER'),
  (541014, 54045, '4', 'Explanation Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541011, NULL, NULL, 'Explanation Txt', 'TEXT', 'ReturnData/IRS990TScheduleA/ItmzdSupplementalInfoGrp/ExplanationTxt'),
  (541012, NULL, NULL, 'Line Num', 'INTEGER', 'ReturnData/IRS990TScheduleA/ItmzdSupplementalInfoGrp/LineNum'),
  (541013, NULL, NULL, 'Part Num', 'INTEGER', 'ReturnData/IRS990TScheduleA/ItmzdSupplementalInfoGrp/PartNum'),
  (541014, NULL, NULL, 'Explanation Amt', 'CURRENCY', 'ReturnData/IRS990TScheduleA/ItmzdSupplementalInfoGrp/ExplanationAmt');

-- 990T / Form8911 Part IICY Credits Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54046, 54, '047', 'Form8911 Part IICY Credits Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541015, 54046, '1', 'Total General Bus Credits Amt', 'CURRENCY'),
  (541016, 54046, '2', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541017, 54046, '3', 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY'),
  (541018, 54046, '4', 'Net Elective Pymt Election Amt', 'CURRENCY'),
  (541019, 54046, '5', 'CY General Business Cr Item Cnt', 'INTEGER'),
  (541020, 54046, '6', 'Gross Elective Pymt Election Amt', 'CURRENCY'),
  (541021, 54046, '7', 'Credit Transfer Election Amt', 'CURRENCY'),
  (541022, 54046, '8', 'Pass Through Entity EIN', 'TEXT'),
  (541023, 54046, '9', 'Elective Payment Registration Num', 'INTEGER'),
  (541024, 54046, '10', 'Transfer Registration Num', 'INTEGER'),
  (541025, 54046, '11', 'Transfer Credit Entity EIN', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541015, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8911PartIICYCreditsGrp/TotalGeneralBusCreditsAmt'),
  (541016, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8911PartIICYCreditsGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541017, NULL, NULL, 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8911PartIICYCreditsGrp/CYAndPYPassiveActyCrAllwCYAmt'),
  (541018, NULL, NULL, 'Net Elective Pymt Election Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8911PartIICYCreditsGrp/NetElectivePymtElectionAmt'),
  (541019, NULL, NULL, 'CY General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Form8911PartIICYCreditsGrp/CYGeneralBusinessCrItemCnt'),
  (541020, NULL, NULL, 'Gross Elective Pymt Election Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8911PartIICYCreditsGrp/GrossElectivePymtElectionAmt'),
  (541021, NULL, NULL, 'Credit Transfer Election Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8911PartIICYCreditsGrp/CreditTransferElectionAmt'),
  (541022, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Form8911PartIICYCreditsGrp/PassThroughEntityEIN'),
  (541023, NULL, NULL, 'Elective Payment Registration Num', 'INTEGER', 'ReturnData/IRS3800/Form8911PartIICYCreditsGrp/ElectivePaymentRegistrationNum'),
  (541024, NULL, NULL, 'Transfer Registration Num', 'INTEGER', 'ReturnData/IRS3800/Form8911PartIICYCreditsGrp/TransferRegistrationNum'),
  (541025, NULL, NULL, 'Transfer Credit Entity EIN', 'TEXT', 'ReturnData/IRS3800/Form8911PartIICYCreditsGrp/TransferCreditEntityEIN');

-- 990T / Form3468 Part IIICY Credits Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54047, 54, '048', 'Form3468 Part IIICY Credits Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541026, 54047, '1', 'Total General Bus Credits Amt', 'CURRENCY'),
  (541027, 54047, '2', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541028, 54047, '3', 'Net Elective Pymt Election Amt', 'CURRENCY'),
  (541029, 54047, '4', 'Gross Elective Pymt Election Amt', 'CURRENCY'),
  (541030, 54047, '5', 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY'),
  (541031, 54047, '6', 'CY General Business Cr Item Cnt', 'INTEGER'),
  (541032, 54047, '7', 'Credit Transfer Election Amt', 'CURRENCY'),
  (541033, 54047, '8', 'Pass Through Entity EIN', 'TEXT'),
  (541034, 54047, '9', 'Elective Payment Registration Num', 'INTEGER'),
  (541035, 54047, '10', 'Total General Bus Credits App Tx Amt', 'CURRENCY'),
  (541036, 54047, '11', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (541037, 54047, '12', 'Transfer Credit Entity EIN', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541026, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/Form3468PartIIICYCreditsGrp/TotalGeneralBusCreditsAmt'),
  (541027, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Form3468PartIIICYCreditsGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541028, NULL, NULL, 'Net Elective Pymt Election Amt', 'CURRENCY', 'ReturnData/IRS3800/Form3468PartIIICYCreditsGrp/NetElectivePymtElectionAmt'),
  (541029, NULL, NULL, 'Gross Elective Pymt Election Amt', 'CURRENCY', 'ReturnData/IRS3800/Form3468PartIIICYCreditsGrp/GrossElectivePymtElectionAmt'),
  (541030, NULL, NULL, 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY', 'ReturnData/IRS3800/Form3468PartIIICYCreditsGrp/CYAndPYPassiveActyCrAllwCYAmt'),
  (541031, NULL, NULL, 'CY General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Form3468PartIIICYCreditsGrp/CYGeneralBusinessCrItemCnt'),
  (541032, NULL, NULL, 'Credit Transfer Election Amt', 'CURRENCY', 'ReturnData/IRS3800/Form3468PartIIICYCreditsGrp/CreditTransferElectionAmt'),
  (541033, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Form3468PartIIICYCreditsGrp/PassThroughEntityEIN'),
  (541034, NULL, NULL, 'Elective Payment Registration Num', 'INTEGER', 'ReturnData/IRS3800/Form3468PartIIICYCreditsGrp/ElectivePaymentRegistrationNum'),
  (541035, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Form3468PartIIICYCreditsGrp/TotalGeneralBusCreditsAppTxAmt'),
  (541036, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Form3468PartIIICYCreditsGrp/CrSubjToPassiveActyLmtAmt'),
  (541037, NULL, NULL, 'Transfer Credit Entity EIN', 'TEXT', 'ReturnData/IRS3800/Form3468PartIIICYCreditsGrp/TransferCreditEntityEIN');

-- 990T / Form5884 CY Credits Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54048, 54, '049', 'Form5884 CY Credits Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541038, 54048, '1', 'Total General Bus Credits Amt', 'CURRENCY'),
  (541039, 54048, '2', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541040, 54048, '3', 'CY General Business Cr Item Cnt', 'INTEGER'),
  (541041, 54048, '4', 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY'),
  (541042, 54048, '5', 'Pass Through Entity EIN', 'TEXT'),
  (541043, 54048, '6', 'Total General Bus Credits App Tx Amt', 'CURRENCY'),
  (541044, 54048, '7', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541038, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/Form5884CYCreditsGrp/TotalGeneralBusCreditsAmt'),
  (541039, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Form5884CYCreditsGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541040, NULL, NULL, 'CY General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Form5884CYCreditsGrp/CYGeneralBusinessCrItemCnt'),
  (541041, NULL, NULL, 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY', 'ReturnData/IRS3800/Form5884CYCreditsGrp/CYAndPYPassiveActyCrAllwCYAmt'),
  (541042, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Form5884CYCreditsGrp/PassThroughEntityEIN'),
  (541043, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Form5884CYCreditsGrp/TotalGeneralBusCreditsAppTxAmt'),
  (541044, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Form5884CYCreditsGrp/CrSubjToPassiveActyLmtAmt');

-- 990T / Tot CYGBC Or ESBC Amt Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54049, 54, '050', 'Tot CYGBC Or ESBC Amt Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541045, 54049, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (541046, 54049, '2', 'ESBC Carryforward Amt', 'CURRENCY'),
  (541047, 54049, '3', 'Carry Back General Business Cr Amt', 'CURRENCY'),
  (541048, 54049, '4', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541049, 54049, '5', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (541050, 54049, '6', 'Total General Bus Credits App Tx Amt', 'CURRENCY'),
  (541051, 54049, '7', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (541052, 54049, '8', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (541053, 54049, '9', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (541054, 54049, '10', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (541055, 54049, '11', 'Missing EIN Reason Cd', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541045, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/TotCYGBCOrESBCAmtGrp/CYGeneralBusCrCarryforwardAmt'),
  (541046, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/TotCYGBCOrESBCAmtGrp/ESBCCarryforwardAmt'),
  (541047, NULL, NULL, 'Carry Back General Business Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/TotCYGBCOrESBCAmtGrp/CarryBackGeneralBusinessCrAmt'),
  (541048, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/TotCYGBCOrESBCAmtGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541049, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/TotCYGBCOrESBCAmtGrp/CarryforwardGeneralBusCrAmt'),
  (541050, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/TotCYGBCOrESBCAmtGrp/TotalGeneralBusCreditsAppTxAmt'),
  (541051, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/TotCYGBCOrESBCAmtGrp/CyovGeneralBusinessCrItemCnt'),
  (541052, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/TotCYGBCOrESBCAmtGrp/PassiveActivityCrAfterLmtAmt'),
  (541053, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/TotCYGBCOrESBCAmtGrp/CrSubjToPassiveActyLmtAmt'),
  (541054, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/TotCYGBCOrESBCAmtGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (541055, NULL, NULL, 'Missing EIN Reason Cd', 'TEXT', 'ReturnData/IRS3800/TotCYGBCOrESBCAmtGrp/MissingEINReasonCd');

-- 990T / Form7213 Part IICY Credits Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54050, 54, '051', 'Form7213 Part IICY Credits Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541056, 54050, '1', 'CY General Business Cr Item Cnt', 'INTEGER'),
  (541057, 54050, '2', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541058, 54050, '3', 'Total General Bus Credits Amt', 'CURRENCY'),
  (541059, 54050, '4', 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY'),
  (541060, 54050, '5', 'Credit Transfer Election Amt', 'CURRENCY'),
  (541061, 54050, '6', 'Gross Elective Pymt Election Amt', 'CURRENCY'),
  (541062, 54050, '7', 'Net Elective Pymt Election Amt', 'CURRENCY'),
  (541063, 54050, '8', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (541064, 54050, '9', 'Pass Through Entity EIN', 'TEXT'),
  (541065, 54050, '10', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541056, NULL, NULL, 'CY General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Form7213PartIICYCreditsGrp/CYGeneralBusinessCrItemCnt'),
  (541057, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Form7213PartIICYCreditsGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541058, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/Form7213PartIICYCreditsGrp/TotalGeneralBusCreditsAmt'),
  (541059, NULL, NULL, 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY', 'ReturnData/IRS3800/Form7213PartIICYCreditsGrp/CYAndPYPassiveActyCrAllwCYAmt'),
  (541060, NULL, NULL, 'Credit Transfer Election Amt', 'CURRENCY', 'ReturnData/IRS3800/Form7213PartIICYCreditsGrp/CreditTransferElectionAmt'),
  (541061, NULL, NULL, 'Gross Elective Pymt Election Amt', 'CURRENCY', 'ReturnData/IRS3800/Form7213PartIICYCreditsGrp/GrossElectivePymtElectionAmt'),
  (541062, NULL, NULL, 'Net Elective Pymt Election Amt', 'CURRENCY', 'ReturnData/IRS3800/Form7213PartIICYCreditsGrp/NetElectivePymtElectionAmt'),
  (541063, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Form7213PartIICYCreditsGrp/CrSubjToPassiveActyLmtAmt'),
  (541064, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Form7213PartIICYCreditsGrp/PassThroughEntityEIN'),
  (541065, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Form7213PartIICYCreditsGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / Form8933 CY Credits Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54051, 54, '052', 'Form8933 CY Credits Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541066, 54051, '1', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541067, 54051, '2', 'Total General Bus Credits Amt', 'CURRENCY'),
  (541068, 54051, '3', 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY'),
  (541069, 54051, '4', 'CY General Business Cr Item Cnt', 'INTEGER'),
  (541070, 54051, '5', 'Credit Transfer Election Amt', 'CURRENCY'),
  (541071, 54051, '6', 'Gross Elective Pymt Election Amt', 'CURRENCY'),
  (541072, 54051, '7', 'Net Elective Pymt Election Amt', 'CURRENCY'),
  (541073, 54051, '8', 'Pass Through Entity EIN', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541066, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8933CYCreditsGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541067, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8933CYCreditsGrp/TotalGeneralBusCreditsAmt'),
  (541068, NULL, NULL, 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8933CYCreditsGrp/CYAndPYPassiveActyCrAllwCYAmt'),
  (541069, NULL, NULL, 'CY General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Form8933CYCreditsGrp/CYGeneralBusinessCrItemCnt'),
  (541070, NULL, NULL, 'Credit Transfer Election Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8933CYCreditsGrp/CreditTransferElectionAmt'),
  (541071, NULL, NULL, 'Gross Elective Pymt Election Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8933CYCreditsGrp/GrossElectivePymtElectionAmt'),
  (541072, NULL, NULL, 'Net Elective Pymt Election Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8933CYCreditsGrp/NetElectivePymtElectionAmt'),
  (541073, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Form8933CYCreditsGrp/PassThroughEntityEIN');

-- 990T / Frm8835 Part IICY Spcfd Credits Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54052, 54, '053', 'Frm8835 Part IICY Spcfd Credits Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541074, 54052, '1', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541075, 54052, '2', 'Total General Bus Credits Amt', 'CURRENCY'),
  (541076, 54052, '3', 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY'),
  (541077, 54052, '4', 'CY General Business Cr Item Cnt', 'INTEGER'),
  (541078, 54052, '5', 'Credit Transfer Election Amt', 'CURRENCY'),
  (541079, 54052, '6', 'Gross Elective Pymt Election Amt', 'CURRENCY'),
  (541080, 54052, '7', 'Net Elective Pymt Election Amt', 'CURRENCY'),
  (541081, 54052, '8', 'Pass Through Entity EIN', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541074, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8835PartIICYSpcfdCreditsGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541075, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8835PartIICYSpcfdCreditsGrp/TotalGeneralBusCreditsAmt'),
  (541076, NULL, NULL, 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8835PartIICYSpcfdCreditsGrp/CYAndPYPassiveActyCrAllwCYAmt'),
  (541077, NULL, NULL, 'CY General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm8835PartIICYSpcfdCreditsGrp/CYGeneralBusinessCrItemCnt'),
  (541078, NULL, NULL, 'Credit Transfer Election Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8835PartIICYSpcfdCreditsGrp/CreditTransferElectionAmt'),
  (541079, NULL, NULL, 'Gross Elective Pymt Election Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8835PartIICYSpcfdCreditsGrp/GrossElectivePymtElectionAmt'),
  (541080, NULL, NULL, 'Net Elective Pymt Election Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8835PartIICYSpcfdCreditsGrp/NetElectivePymtElectionAmt'),
  (541081, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Frm8835PartIICYSpcfdCreditsGrp/PassThroughEntityEIN');

-- 990T / Form7207 CY Credits Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54053, 54, '054', 'Form7207 CY Credits Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541082, 54053, '1', 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY'),
  (541083, 54053, '2', 'CY General Business Cr Item Cnt', 'INTEGER'),
  (541084, 54053, '3', 'Credit Transfer Election Amt', 'CURRENCY'),
  (541085, 54053, '4', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541086, 54053, '5', 'Gross Elective Pymt Election Amt', 'CURRENCY'),
  (541087, 54053, '6', 'Net Elective Pymt Election Amt', 'CURRENCY'),
  (541088, 54053, '7', 'Total General Bus Credits Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541082, NULL, NULL, 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY', 'ReturnData/IRS3800/Form7207CYCreditsGrp/CYAndPYPassiveActyCrAllwCYAmt'),
  (541083, NULL, NULL, 'CY General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Form7207CYCreditsGrp/CYGeneralBusinessCrItemCnt'),
  (541084, NULL, NULL, 'Credit Transfer Election Amt', 'CURRENCY', 'ReturnData/IRS3800/Form7207CYCreditsGrp/CreditTransferElectionAmt'),
  (541085, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Form7207CYCreditsGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541086, NULL, NULL, 'Gross Elective Pymt Election Amt', 'CURRENCY', 'ReturnData/IRS3800/Form7207CYCreditsGrp/GrossElectivePymtElectionAmt'),
  (541087, NULL, NULL, 'Net Elective Pymt Election Amt', 'CURRENCY', 'ReturnData/IRS3800/Form7207CYCreditsGrp/NetElectivePymtElectionAmt'),
  (541088, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/Form7207CYCreditsGrp/TotalGeneralBusCreditsAmt');

-- 990T / Form7210 CY Credits Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54054, 54, '055', 'Form7210 CY Credits Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541089, 54054, '1', 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY'),
  (541090, 54054, '2', 'CY General Business Cr Item Cnt', 'INTEGER'),
  (541091, 54054, '3', 'Credit Transfer Election Amt', 'CURRENCY'),
  (541092, 54054, '4', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541093, 54054, '5', 'Gross Elective Pymt Election Amt', 'CURRENCY'),
  (541094, 54054, '6', 'Net Elective Pymt Election Amt', 'CURRENCY'),
  (541095, 54054, '7', 'Total General Bus Credits Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541089, NULL, NULL, 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY', 'ReturnData/IRS3800/Form7210CYCreditsGrp/CYAndPYPassiveActyCrAllwCYAmt'),
  (541090, NULL, NULL, 'CY General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Form7210CYCreditsGrp/CYGeneralBusinessCrItemCnt'),
  (541091, NULL, NULL, 'Credit Transfer Election Amt', 'CURRENCY', 'ReturnData/IRS3800/Form7210CYCreditsGrp/CreditTransferElectionAmt'),
  (541092, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Form7210CYCreditsGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541093, NULL, NULL, 'Gross Elective Pymt Election Amt', 'CURRENCY', 'ReturnData/IRS3800/Form7210CYCreditsGrp/GrossElectivePymtElectionAmt'),
  (541094, NULL, NULL, 'Net Elective Pymt Election Amt', 'CURRENCY', 'ReturnData/IRS3800/Form7210CYCreditsGrp/NetElectivePymtElectionAmt'),
  (541095, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/Form7210CYCreditsGrp/TotalGeneralBusCreditsAmt');

-- 990T / Books In Care Of Detail
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54055, 54, '056', 'Books In Care Of Detail');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541096, 54055, '1', 'Address Line2 Txt', 'TEXT'),
  (541097, 54055, '2', 'Business Name Line2 Txt', 'TEXT'),
  (541098, 54055, '3', 'Address Line1 Txt', 'TEXT'),
  (541099, 54055, '4', 'Country Cd', 'TEXT'),
  (541100, 54055, '5', 'City Nm', 'TEXT'),
  (541101, 54055, '6', 'Foreign Postal Cd', 'TEXT'),
  (541102, 54055, '7', 'Province Or State Nm', 'TEXT'),
  (541103, 54055, '8', 'Foreign Phone Num', 'INTEGER'),
  (541104, 54055, '9', 'Address Line2 Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541096, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/IRS990T/BooksInCareOfDetail/USAddress/AddressLine2Txt'),
  (541097, NULL, NULL, 'Business Name Line2 Txt', 'TEXT', 'ReturnData/IRS990T/BooksInCareOfDetail/BusinessName/BusinessNameLine2Txt'),
  (541098, NULL, NULL, 'Address Line1 Txt', 'TEXT', 'ReturnData/IRS990T/BooksInCareOfDetail/ForeignAddress/AddressLine1Txt'),
  (541099, NULL, NULL, 'Country Cd', 'TEXT', 'ReturnData/IRS990T/BooksInCareOfDetail/ForeignAddress/CountryCd'),
  (541100, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990T/BooksInCareOfDetail/ForeignAddress/CityNm'),
  (541101, NULL, NULL, 'Foreign Postal Cd', 'TEXT', 'ReturnData/IRS990T/BooksInCareOfDetail/ForeignAddress/ForeignPostalCd'),
  (541102, NULL, NULL, 'Province Or State Nm', 'TEXT', 'ReturnData/IRS990T/BooksInCareOfDetail/ForeignAddress/ProvinceOrStateNm'),
  (541103, NULL, NULL, 'Foreign Phone Num', 'INTEGER', 'ReturnData/IRS990T/BooksInCareOfDetail/ForeignPhoneNum'),
  (541104, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/IRS990T/BooksInCareOfDetail/ForeignAddress/AddressLine2Txt');

-- 990T / Form3468 Part IVCY Credits Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54056, 54, '057', 'Form3468 Part IVCY Credits Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541105, 54056, '1', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541106, 54056, '2', 'Total General Bus Credits Amt', 'CURRENCY'),
  (541107, 54056, '3', 'Gross Elective Pymt Election Amt', 'CURRENCY'),
  (541108, 54056, '4', 'Net Elective Pymt Election Amt', 'CURRENCY'),
  (541109, 54056, '5', 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY'),
  (541110, 54056, '6', 'CY General Business Cr Item Cnt', 'INTEGER'),
  (541111, 54056, '7', 'Elective Payment Registration Num', 'INTEGER'),
  (541112, 54056, '8', 'Pass Through Entity EIN', 'TEXT'),
  (541113, 54056, '9', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (541114, 54056, '10', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541105, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Form3468PartIVCYCreditsGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541106, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/Form3468PartIVCYCreditsGrp/TotalGeneralBusCreditsAmt'),
  (541107, NULL, NULL, 'Gross Elective Pymt Election Amt', 'CURRENCY', 'ReturnData/IRS3800/Form3468PartIVCYCreditsGrp/GrossElectivePymtElectionAmt'),
  (541108, NULL, NULL, 'Net Elective Pymt Election Amt', 'CURRENCY', 'ReturnData/IRS3800/Form3468PartIVCYCreditsGrp/NetElectivePymtElectionAmt'),
  (541109, NULL, NULL, 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY', 'ReturnData/IRS3800/Form3468PartIVCYCreditsGrp/CYAndPYPassiveActyCrAllwCYAmt'),
  (541110, NULL, NULL, 'CY General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Form3468PartIVCYCreditsGrp/CYGeneralBusinessCrItemCnt'),
  (541111, NULL, NULL, 'Elective Payment Registration Num', 'INTEGER', 'ReturnData/IRS3800/Form3468PartIVCYCreditsGrp/ElectivePaymentRegistrationNum'),
  (541112, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Form3468PartIVCYCreditsGrp/PassThroughEntityEIN'),
  (541113, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Form3468PartIVCYCreditsGrp/CrSubjToPassiveActyLmtAmt'),
  (541114, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Form3468PartIVCYCreditsGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / Form6765 ESBCY Credits Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54057, 54, '058', 'Form6765 ESBCY Credits Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541115, 54057, '1', 'Total General Bus Credits Amt', 'CURRENCY'),
  (541116, 54057, '2', 'CY General Business Cr Item Cnt', 'INTEGER'),
  (541117, 54057, '3', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541118, 54057, '4', 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY'),
  (541119, 54057, '5', 'Pass Through Entity EIN', 'TEXT'),
  (541120, 54057, '6', 'Total General Bus Credits App Tx Amt', 'CURRENCY'),
  (541121, 54057, '7', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541115, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/Form6765ESBCYCreditsGrp/TotalGeneralBusCreditsAmt'),
  (541116, NULL, NULL, 'CY General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Form6765ESBCYCreditsGrp/CYGeneralBusinessCrItemCnt'),
  (541117, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Form6765ESBCYCreditsGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541118, NULL, NULL, 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY', 'ReturnData/IRS3800/Form6765ESBCYCreditsGrp/CYAndPYPassiveActyCrAllwCYAmt'),
  (541119, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Form6765ESBCYCreditsGrp/PassThroughEntityEIN'),
  (541120, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Form6765ESBCYCreditsGrp/TotalGeneralBusCreditsAppTxAmt'),
  (541121, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Form6765ESBCYCreditsGrp/CrSubjToPassiveActyLmtAmt');

-- 990T / Total Capital Gain Or Loss Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54058, 54, '059', 'Total Capital Gain Or Loss Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541122, 54058, '1', 'Net ST Capital Gain Or Loss Amt', 'CURRENCY'),
  (541123, 54058, '2', 'Unrecaptured Section1250 Gain Amt', 'CURRENCY'),
  (541124, 54058, '3', 'Collectibles28 Percent Gain Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541122, NULL, NULL, 'Net ST Capital Gain Or Loss Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/TotalCapitalGainOrLossGrp/NetSTCapitalGainOrLossAmt'),
  (541123, NULL, NULL, 'Unrecaptured Section1250 Gain Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/TotalCapitalGainOrLossGrp/NetLongTermGainOrLossGrp/UnrecapturedSection1250GainAmt'),
  (541124, NULL, NULL, 'Collectibles28 Percent Gain Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/TotalCapitalGainOrLossGrp/NetLongTermGainOrLossGrp/Collectibles28PercentGainAmt');

-- 990T / Frm6765 CY Cyov Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54059, 54, '060', 'Frm6765 CY Cyov Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541125, 54059, '1', 'Yr', 'TEXT'),
  (541126, 54059, '2', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (541127, 54059, '3', 'Pass Through Entity EIN', 'TEXT'),
  (541128, 54059, '4', 'Carry Back General Business Cr Amt', 'CURRENCY'),
  (541129, 54059, '5', 'ESBC Carryforward Amt', 'CURRENCY'),
  (541130, 54059, '6', 'Non Passive Ind', 'BOOLEAN'),
  (541131, 54059, '7', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (541132, 54059, '8', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541133, 54059, '9', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (541134, 54059, '10', 'Total General Bus Credits App Tx Amt', 'CURRENCY'),
  (541135, 54059, '11', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (541136, 54059, '12', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (541137, 54059, '13', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (541138, 54059, '14', 'Missing EIN Reason Cd', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541125, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/Frm6765CYCyovCrGrp/Yr'),
  (541126, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm6765CYCyovCrGrp/CYGeneralBusCrCarryforwardAmt'),
  (541127, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Frm6765CYCyovCrGrp/PassThroughEntityEIN'),
  (541128, NULL, NULL, 'Carry Back General Business Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm6765CYCyovCrGrp/CarryBackGeneralBusinessCrAmt'),
  (541129, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm6765CYCyovCrGrp/ESBCCarryforwardAmt'),
  (541130, NULL, NULL, 'Non Passive Ind', 'BOOLEAN', 'ReturnData/IRS3800/Frm6765CYCyovCrGrp/NonPassiveInd'),
  (541131, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm6765CYCyovCrGrp/CyovGeneralBusinessCrItemCnt'),
  (541132, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm6765CYCyovCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541133, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm6765CYCyovCrGrp/CarryforwardGeneralBusCrAmt'),
  (541134, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm6765CYCyovCrGrp/TotalGeneralBusCreditsAppTxAmt'),
  (541135, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm6765CYCyovCrGrp/PassiveActivityCrAfterLmtAmt'),
  (541136, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm6765CYCyovCrGrp/CrSubjToPassiveActyLmtAmt'),
  (541137, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm6765CYCyovCrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (541138, NULL, NULL, 'Missing EIN Reason Cd', 'TEXT', 'ReturnData/IRS3800/Frm6765CYCyovCrGrp/MissingEINReasonCd');

-- 990T / CY Other Spcfd Credits Sub Tot Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54060, 54, '061', 'CY Other Spcfd Credits Sub Tot Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541139, 54060, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (541140, 54060, '2', 'ESBC Carryforward Amt', 'CURRENCY'),
  (541141, 54060, '3', 'Carry Back General Business Cr Amt', 'CURRENCY'),
  (541142, 54060, '4', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (541143, 54060, '5', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541144, 54060, '6', 'Missing EIN Reason Cd', 'TEXT'),
  (541145, 54060, '7', 'Total General Bus Credits App Tx Amt', 'CURRENCY'),
  (541146, 54060, '8', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (541147, 54060, '9', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (541148, 54060, '10', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (541149, 54060, '11', 'Cyov General Business Cr Item Cnt', 'INTEGER');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541139, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/CYOtherSpcfdCreditsSubTotGrp/CYGeneralBusCrCarryforwardAmt'),
  (541140, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/CYOtherSpcfdCreditsSubTotGrp/ESBCCarryforwardAmt'),
  (541141, NULL, NULL, 'Carry Back General Business Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/CYOtherSpcfdCreditsSubTotGrp/CarryBackGeneralBusinessCrAmt'),
  (541142, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/CYOtherSpcfdCreditsSubTotGrp/CarryforwardGeneralBusCrAmt'),
  (541143, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/CYOtherSpcfdCreditsSubTotGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541144, NULL, NULL, 'Missing EIN Reason Cd', 'TEXT', 'ReturnData/IRS3800/CYOtherSpcfdCreditsSubTotGrp/MissingEINReasonCd'),
  (541145, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/CYOtherSpcfdCreditsSubTotGrp/TotalGeneralBusCreditsAppTxAmt'),
  (541146, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/CYOtherSpcfdCreditsSubTotGrp/CrSubjToPassiveActyLmtAmt'),
  (541147, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/CYOtherSpcfdCreditsSubTotGrp/PassiveActivityCrAfterLmtAmt'),
  (541148, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/CYOtherSpcfdCreditsSubTotGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (541149, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/CYOtherSpcfdCreditsSubTotGrp/CyovGeneralBusinessCrItemCnt');

-- 990T / Form8835 Part IICY Credits Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54061, 54, '062', 'Form8835 Part IICY Credits Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541150, 54061, '1', 'Total General Bus Credits Amt', 'CURRENCY'),
  (541151, 54061, '2', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541152, 54061, '3', 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY'),
  (541153, 54061, '4', 'CY General Business Cr Item Cnt', 'INTEGER'),
  (541154, 54061, '5', 'Credit Transfer Election Amt', 'CURRENCY'),
  (541155, 54061, '6', 'Pass Through Entity EIN', 'TEXT'),
  (541156, 54061, '7', 'Total General Bus Credits App Tx Amt', 'CURRENCY'),
  (541157, 54061, '8', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541150, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8835PartIICYCreditsGrp/TotalGeneralBusCreditsAmt'),
  (541151, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8835PartIICYCreditsGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541152, NULL, NULL, 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8835PartIICYCreditsGrp/CYAndPYPassiveActyCrAllwCYAmt'),
  (541153, NULL, NULL, 'CY General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Form8835PartIICYCreditsGrp/CYGeneralBusinessCrItemCnt'),
  (541154, NULL, NULL, 'Credit Transfer Election Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8835PartIICYCreditsGrp/CreditTransferElectionAmt'),
  (541155, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Form8835PartIICYCreditsGrp/PassThroughEntityEIN'),
  (541156, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8835PartIICYCreditsGrp/TotalGeneralBusCreditsAppTxAmt'),
  (541157, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8835PartIICYCreditsGrp/CrSubjToPassiveActyLmtAmt');

-- 990T / Form8586 CY Credits Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54062, 54, '063', 'Form8586 CY Credits Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541158, 54062, '1', 'Total General Bus Credits Amt', 'CURRENCY'),
  (541159, 54062, '2', 'CY General Business Cr Item Cnt', 'INTEGER'),
  (541160, 54062, '3', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541161, 54062, '4', 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY'),
  (541162, 54062, '5', 'Pass Through Entity EIN', 'TEXT'),
  (541163, 54062, '6', 'Total General Bus Credits App Tx Amt', 'CURRENCY'),
  (541164, 54062, '7', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541158, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8586CYCreditsGrp/TotalGeneralBusCreditsAmt'),
  (541159, NULL, NULL, 'CY General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Form8586CYCreditsGrp/CYGeneralBusinessCrItemCnt'),
  (541160, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8586CYCreditsGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541161, NULL, NULL, 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8586CYCreditsGrp/CYAndPYPassiveActyCrAllwCYAmt'),
  (541162, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Form8586CYCreditsGrp/PassThroughEntityEIN'),
  (541163, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8586CYCreditsGrp/TotalGeneralBusCreditsAppTxAmt'),
  (541164, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8586CYCreditsGrp/CrSubjToPassiveActyLmtAmt');

-- 990T / Estate Or Trust Cap Gain Or Loss Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54063, 54, '064', 'Estate Or Trust Cap Gain Or Loss Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541165, 54063, '1', 'Net ST Capital Gain Or Loss Amt', 'CURRENCY'),
  (541166, 54063, '2', 'Unrecaptured Section1250 Gain Amt', 'CURRENCY'),
  (541167, 54063, '3', 'Collectibles28 Percent Gain Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541165, NULL, NULL, 'Net ST Capital Gain Or Loss Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/EstateOrTrustCapGainOrLossGrp/NetSTCapitalGainOrLossAmt'),
  (541166, NULL, NULL, 'Unrecaptured Section1250 Gain Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/EstateOrTrustCapGainOrLossGrp/NetLongTermGainOrLossGrp/UnrecapturedSection1250GainAmt'),
  (541167, NULL, NULL, 'Collectibles28 Percent Gain Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/EstateOrTrustCapGainOrLossGrp/NetLongTermGainOrLossGrp/Collectibles28PercentGainAmt');

-- 990T / Form8904 CY Credits Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54064, 54, '065', 'Form8904 CY Credits Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541168, 54064, '1', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541169, 54064, '2', 'Total General Bus Credits Amt', 'CURRENCY'),
  (541170, 54064, '3', 'CY General Business Cr Item Cnt', 'INTEGER'),
  (541171, 54064, '4', 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY'),
  (541172, 54064, '5', 'Total General Bus Credits App Tx Amt', 'CURRENCY'),
  (541173, 54064, '6', 'Pass Through Entity EIN', 'TEXT'),
  (541174, 54064, '7', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541168, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8904CYCreditsGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541169, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8904CYCreditsGrp/TotalGeneralBusCreditsAmt'),
  (541170, NULL, NULL, 'CY General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Form8904CYCreditsGrp/CYGeneralBusinessCrItemCnt'),
  (541171, NULL, NULL, 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8904CYCreditsGrp/CYAndPYPassiveActyCrAllwCYAmt'),
  (541172, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8904CYCreditsGrp/TotalGeneralBusCreditsAppTxAmt'),
  (541173, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Form8904CYCreditsGrp/PassThroughEntityEIN'),
  (541174, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8904CYCreditsGrp/CrSubjToPassiveActyLmtAmt');

-- 990T / Form8882 CY Credits Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54065, 54, '066', 'Form8882 CY Credits Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541175, 54065, '1', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541176, 54065, '2', 'Total General Bus Credits Amt', 'CURRENCY'),
  (541177, 54065, '3', 'CY General Business Cr Item Cnt', 'INTEGER'),
  (541178, 54065, '4', 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY'),
  (541179, 54065, '5', 'Total General Bus Credits App Tx Amt', 'CURRENCY'),
  (541180, 54065, '6', 'Pass Through Entity EIN', 'TEXT'),
  (541181, 54065, '7', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541175, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8882CYCreditsGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541176, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8882CYCreditsGrp/TotalGeneralBusCreditsAmt'),
  (541177, NULL, NULL, 'CY General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Form8882CYCreditsGrp/CYGeneralBusinessCrItemCnt'),
  (541178, NULL, NULL, 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8882CYCreditsGrp/CYAndPYPassiveActyCrAllwCYAmt'),
  (541179, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8882CYCreditsGrp/TotalGeneralBusCreditsAppTxAmt'),
  (541180, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Form8882CYCreditsGrp/PassThroughEntityEIN'),
  (541181, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8882CYCreditsGrp/CrSubjToPassiveActyLmtAmt');

-- 990T / Form8844 CY Credits Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54066, 54, '067', 'Form8844 CY Credits Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541182, 54066, '1', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541183, 54066, '2', 'Total General Bus Credits Amt', 'CURRENCY'),
  (541184, 54066, '3', 'CY General Business Cr Item Cnt', 'INTEGER'),
  (541185, 54066, '4', 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY'),
  (541186, 54066, '5', 'Pass Through Entity EIN', 'TEXT'),
  (541187, 54066, '6', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541182, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8844CYCreditsGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541183, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8844CYCreditsGrp/TotalGeneralBusCreditsAmt'),
  (541184, NULL, NULL, 'CY General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Form8844CYCreditsGrp/CYGeneralBusinessCrItemCnt'),
  (541185, NULL, NULL, 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8844CYCreditsGrp/CYAndPYPassiveActyCrAllwCYAmt'),
  (541186, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Form8844CYCreditsGrp/PassThroughEntityEIN'),
  (541187, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8844CYCreditsGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / Form8994 CY Credits Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54067, 54, '068', 'Form8994 CY Credits Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541188, 54067, '1', 'Total General Bus Credits Amt', 'CURRENCY'),
  (541189, 54067, '2', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541190, 54067, '3', 'CY General Business Cr Item Cnt', 'INTEGER'),
  (541191, 54067, '4', 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY'),
  (541192, 54067, '5', 'Pass Through Entity EIN', 'TEXT'),
  (541193, 54067, '6', 'Total General Bus Credits App Tx Amt', 'CURRENCY'),
  (541194, 54067, '7', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541188, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8994CYCreditsGrp/TotalGeneralBusCreditsAmt'),
  (541189, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8994CYCreditsGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541190, NULL, NULL, 'CY General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Form8994CYCreditsGrp/CYGeneralBusinessCrItemCnt'),
  (541191, NULL, NULL, 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8994CYCreditsGrp/CYAndPYPassiveActyCrAllwCYAmt'),
  (541192, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Form8994CYCreditsGrp/PassThroughEntityEIN'),
  (541193, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8994CYCreditsGrp/TotalGeneralBusCreditsAppTxAmt'),
  (541194, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8994CYCreditsGrp/CrSubjToPassiveActyLmtAmt');

-- 990T / Form8908 CY Credits Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54068, 54, '069', 'Form8908 CY Credits Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541195, 54068, '1', 'Total General Bus Credits Amt', 'CURRENCY'),
  (541196, 54068, '2', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541197, 54068, '3', 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY'),
  (541198, 54068, '4', 'CY General Business Cr Item Cnt', 'INTEGER'),
  (541199, 54068, '5', 'Pass Through Entity EIN', 'TEXT'),
  (541200, 54068, '6', 'Total General Bus Credits App Tx Amt', 'CURRENCY'),
  (541201, 54068, '7', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541195, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8908CYCreditsGrp/TotalGeneralBusCreditsAmt'),
  (541196, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8908CYCreditsGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541197, NULL, NULL, 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8908CYCreditsGrp/CYAndPYPassiveActyCrAllwCYAmt'),
  (541198, NULL, NULL, 'CY General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Form8908CYCreditsGrp/CYGeneralBusinessCrItemCnt'),
  (541199, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Form8908CYCreditsGrp/PassThroughEntityEIN'),
  (541200, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8908CYCreditsGrp/TotalGeneralBusCreditsAppTxAmt'),
  (541201, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8908CYCreditsGrp/CrSubjToPassiveActyLmtAmt');

-- 990T / Tot CYGBC Or ESBC Amt Aggrgt Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54069, 54, '070', 'Tot CYGBC Or ESBC Amt Aggrgt Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541202, 54069, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (541203, 54069, '2', 'ESBC Carryforward Amt', 'CURRENCY'),
  (541204, 54069, '3', 'Carry Back General Business Cr Amt', 'CURRENCY'),
  (541205, 54069, '4', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (541206, 54069, '5', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (541207, 54069, '6', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (541208, 54069, '7', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541209, 54069, '8', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (541210, 54069, '9', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541202, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/TotCYGBCOrESBCAmtAggrgtGrp/CYGeneralBusCrCarryforwardAmt'),
  (541203, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/TotCYGBCOrESBCAmtAggrgtGrp/ESBCCarryforwardAmt'),
  (541204, NULL, NULL, 'Carry Back General Business Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/TotCYGBCOrESBCAmtAggrgtGrp/CarryBackGeneralBusinessCrAmt'),
  (541205, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/TotCYGBCOrESBCAmtAggrgtGrp/CarryforwardGeneralBusCrAmt'),
  (541206, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/TotCYGBCOrESBCAmtAggrgtGrp/CrSubjToPassiveActyLmtAmt'),
  (541207, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/TotCYGBCOrESBCAmtAggrgtGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (541208, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/TotCYGBCOrESBCAmtAggrgtGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541209, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/TotCYGBCOrESBCAmtAggrgtGrp/PassiveActivityCrAfterLmtAmt'),
  (541210, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/TotCYGBCOrESBCAmtAggrgtGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / CY Other Spcfd Cr Sub Tot Aggrgt Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54070, 54, '071', 'CY Other Spcfd Cr Sub Tot Aggrgt Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541211, 54070, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (541212, 54070, '2', 'ESBC Carryforward Amt', 'CURRENCY'),
  (541213, 54070, '3', 'Carry Back General Business Cr Amt', 'CURRENCY'),
  (541214, 54070, '4', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (541215, 54070, '5', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (541216, 54070, '6', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (541217, 54070, '7', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541218, 54070, '8', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (541219, 54070, '9', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541211, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/CYOtherSpcfdCrSubTotAggrgtGrp/CYGeneralBusCrCarryforwardAmt'),
  (541212, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/CYOtherSpcfdCrSubTotAggrgtGrp/ESBCCarryforwardAmt'),
  (541213, NULL, NULL, 'Carry Back General Business Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/CYOtherSpcfdCrSubTotAggrgtGrp/CarryBackGeneralBusinessCrAmt'),
  (541214, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/CYOtherSpcfdCrSubTotAggrgtGrp/CarryforwardGeneralBusCrAmt'),
  (541215, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/CYOtherSpcfdCrSubTotAggrgtGrp/CrSubjToPassiveActyLmtAmt'),
  (541216, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/CYOtherSpcfdCrSubTotAggrgtGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (541217, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/CYOtherSpcfdCrSubTotAggrgtGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541218, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/CYOtherSpcfdCrSubTotAggrgtGrp/PassiveActivityCrAfterLmtAmt'),
  (541219, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/CYOtherSpcfdCrSubTotAggrgtGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / Frm8846 CY Spcfd Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54071, 54, '072', 'Frm8846 CY Spcfd Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541220, 54071, '1', 'Yr', 'TEXT'),
  (541221, 54071, '2', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (541222, 54071, '3', 'Pass Through Entity EIN', 'TEXT'),
  (541223, 54071, '4', 'ESBC Carryforward Amt', 'CURRENCY'),
  (541224, 54071, '5', 'Carry Back General Business Cr Amt', 'CURRENCY'),
  (541225, 54071, '6', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (541226, 54071, '7', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (541227, 54071, '8', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541228, 54071, '9', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (541229, 54071, '10', 'Total General Bus Credits App Tx Amt', 'CURRENCY'),
  (541230, 54071, '11', 'Non Passive Ind', 'BOOLEAN'),
  (541231, 54071, '12', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (541232, 54071, '13', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (541233, 54071, '14', 'Missing EIN Reason Cd', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541220, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/Frm8846CYSpcfdCrGrp/Yr'),
  (541221, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8846CYSpcfdCrGrp/CYGeneralBusCrCarryforwardAmt'),
  (541222, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Frm8846CYSpcfdCrGrp/PassThroughEntityEIN'),
  (541223, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8846CYSpcfdCrGrp/ESBCCarryforwardAmt'),
  (541224, NULL, NULL, 'Carry Back General Business Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8846CYSpcfdCrGrp/CarryBackGeneralBusinessCrAmt'),
  (541225, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8846CYSpcfdCrGrp/CarryforwardGeneralBusCrAmt'),
  (541226, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm8846CYSpcfdCrGrp/CyovGeneralBusinessCrItemCnt'),
  (541227, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8846CYSpcfdCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541228, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8846CYSpcfdCrGrp/CrSubjToPassiveActyLmtAmt'),
  (541229, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8846CYSpcfdCrGrp/TotalGeneralBusCreditsAppTxAmt'),
  (541230, NULL, NULL, 'Non Passive Ind', 'BOOLEAN', 'ReturnData/IRS3800/Frm8846CYSpcfdCrGrp/NonPassiveInd'),
  (541231, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8846CYSpcfdCrGrp/PassiveActivityCrAfterLmtAmt'),
  (541232, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8846CYSpcfdCrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (541233, NULL, NULL, 'Missing EIN Reason Cd', 'TEXT', 'ReturnData/IRS3800/Frm8846CYSpcfdCrGrp/MissingEINReasonCd');

-- 990T / Form3468 Part VIICY Credits Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54072, 54, '073', 'Form3468 Part VIICY Credits Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541234, 54072, '1', 'Total General Bus Credits Amt', 'CURRENCY'),
  (541235, 54072, '2', 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY'),
  (541236, 54072, '3', 'CY General Business Cr Item Cnt', 'INTEGER'),
  (541237, 54072, '4', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541238, 54072, '5', 'Pass Through Entity EIN', 'TEXT'),
  (541239, 54072, '6', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (541240, 54072, '7', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541234, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/Form3468PartVIICYCreditsGrp/TotalGeneralBusCreditsAmt'),
  (541235, NULL, NULL, 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY', 'ReturnData/IRS3800/Form3468PartVIICYCreditsGrp/CYAndPYPassiveActyCrAllwCYAmt'),
  (541236, NULL, NULL, 'CY General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Form3468PartVIICYCreditsGrp/CYGeneralBusinessCrItemCnt'),
  (541237, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Form3468PartVIICYCreditsGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541238, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Form3468PartVIICYCreditsGrp/PassThroughEntityEIN'),
  (541239, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Form3468PartVIICYCreditsGrp/CrSubjToPassiveActyLmtAmt'),
  (541240, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Form3468PartVIICYCreditsGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / Form6478 CY Credits Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54073, 54, '074', 'Form6478 CY Credits Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541241, 54073, '1', 'Total General Bus Credits Amt', 'CURRENCY'),
  (541242, 54073, '2', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541243, 54073, '3', 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY'),
  (541244, 54073, '4', 'CY General Business Cr Item Cnt', 'INTEGER'),
  (541245, 54073, '5', 'Pass Through Entity EIN', 'TEXT'),
  (541246, 54073, '6', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (541247, 54073, '7', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541241, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/Form6478CYCreditsGrp/TotalGeneralBusCreditsAmt'),
  (541242, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Form6478CYCreditsGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541243, NULL, NULL, 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY', 'ReturnData/IRS3800/Form6478CYCreditsGrp/CYAndPYPassiveActyCrAllwCYAmt'),
  (541244, NULL, NULL, 'CY General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Form6478CYCreditsGrp/CYGeneralBusinessCrItemCnt'),
  (541245, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Form6478CYCreditsGrp/PassThroughEntityEIN'),
  (541246, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Form6478CYCreditsGrp/CrSubjToPassiveActyLmtAmt'),
  (541247, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Form6478CYCreditsGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / Gen Bus Other Specified CY Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54074, 54, '075', 'Gen Bus Other Specified CY Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541248, 54074, '1', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541249, 54074, '2', 'Total General Bus Credits Amt', 'CURRENCY'),
  (541250, 54074, '3', 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY'),
  (541251, 54074, '4', 'CY General Business Cr Item Cnt', 'INTEGER'),
  (541252, 54074, '5', 'Pass Through Entity EIN', 'TEXT'),
  (541253, 54074, '6', 'Total General Bus Credits App Tx Amt', 'CURRENCY'),
  (541254, 54074, '7', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541248, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusOtherSpecifiedCYCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541249, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusOtherSpecifiedCYCrGrp/TotalGeneralBusCreditsAmt'),
  (541250, NULL, NULL, 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusOtherSpecifiedCYCrGrp/CYAndPYPassiveActyCrAllwCYAmt'),
  (541251, NULL, NULL, 'CY General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/GenBusOtherSpecifiedCYCrGrp/CYGeneralBusinessCrItemCnt'),
  (541252, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/GenBusOtherSpecifiedCYCrGrp/PassThroughEntityEIN'),
  (541253, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusOtherSpecifiedCYCrGrp/TotalGeneralBusCreditsAppTxAmt'),
  (541254, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusOtherSpecifiedCYCrGrp/CrSubjToPassiveActyLmtAmt');

-- 990T / Form8881 Part ICY Credits Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54075, 54, '076', 'Form8881 Part ICY Credits Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541255, 54075, '1', 'Total General Bus Credits Amt', 'CURRENCY'),
  (541256, 54075, '2', 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY'),
  (541257, 54075, '3', 'CY General Business Cr Item Cnt', 'INTEGER'),
  (541258, 54075, '4', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541259, 54075, '5', 'Pass Through Entity EIN', 'TEXT'),
  (541260, 54075, '6', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541255, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8881PartICYCreditsGrp/TotalGeneralBusCreditsAmt'),
  (541256, NULL, NULL, 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8881PartICYCreditsGrp/CYAndPYPassiveActyCrAllwCYAmt'),
  (541257, NULL, NULL, 'CY General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Form8881PartICYCreditsGrp/CYGeneralBusinessCrItemCnt'),
  (541258, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8881PartICYCreditsGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541259, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Form8881PartICYCreditsGrp/PassThroughEntityEIN'),
  (541260, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8881PartICYCreditsGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / Form8864 CY Credits Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54076, 54, '077', 'Form8864 CY Credits Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541261, 54076, '1', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541262, 54076, '2', 'Total General Bus Credits Amt', 'CURRENCY'),
  (541263, 54076, '3', 'CY General Business Cr Item Cnt', 'INTEGER'),
  (541264, 54076, '4', 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY'),
  (541265, 54076, '5', 'Pass Through Entity EIN', 'TEXT'),
  (541266, 54076, '6', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541261, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8864CYCreditsGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541262, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8864CYCreditsGrp/TotalGeneralBusCreditsAmt'),
  (541263, NULL, NULL, 'CY General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Form8864CYCreditsGrp/CYGeneralBusinessCrItemCnt'),
  (541264, NULL, NULL, 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8864CYCreditsGrp/CYAndPYPassiveActyCrAllwCYAmt'),
  (541265, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Form8864CYCreditsGrp/PassThroughEntityEIN'),
  (541266, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8864CYCreditsGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / Form8900 CY Credits Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54077, 54, '078', 'Form8900 CY Credits Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541267, 54077, '1', 'CY General Business Cr Item Cnt', 'INTEGER'),
  (541268, 54077, '2', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541269, 54077, '3', 'Total General Bus Credits Amt', 'CURRENCY'),
  (541270, 54077, '4', 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY'),
  (541271, 54077, '5', 'Pass Through Entity EIN', 'TEXT'),
  (541272, 54077, '6', 'Total General Bus Credits App Tx Amt', 'CURRENCY'),
  (541273, 54077, '7', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541267, NULL, NULL, 'CY General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Form8900CYCreditsGrp/CYGeneralBusinessCrItemCnt'),
  (541268, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8900CYCreditsGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541269, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8900CYCreditsGrp/TotalGeneralBusCreditsAmt'),
  (541270, NULL, NULL, 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8900CYCreditsGrp/CYAndPYPassiveActyCrAllwCYAmt'),
  (541271, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Form8900CYCreditsGrp/PassThroughEntityEIN'),
  (541272, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8900CYCreditsGrp/TotalGeneralBusCreditsAppTxAmt'),
  (541273, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8900CYCreditsGrp/CrSubjToPassiveActyLmtAmt');

-- 990T / Form8936 Part IICY Credits Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54078, 54, '079', 'Form8936 Part IICY Credits Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541274, 54078, '1', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541275, 54078, '2', 'Total General Bus Credits Amt', 'CURRENCY'),
  (541276, 54078, '3', 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY'),
  (541277, 54078, '4', 'CY General Business Cr Item Cnt', 'INTEGER'),
  (541278, 54078, '5', 'Pass Through Entity EIN', 'TEXT'),
  (541279, 54078, '6', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541274, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8936PartIICYCreditsGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541275, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8936PartIICYCreditsGrp/TotalGeneralBusCreditsAmt'),
  (541276, NULL, NULL, 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8936PartIICYCreditsGrp/CYAndPYPassiveActyCrAllwCYAmt'),
  (541277, NULL, NULL, 'CY General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Form8936PartIICYCreditsGrp/CYGeneralBusinessCrItemCnt'),
  (541278, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Form8936PartIICYCreditsGrp/PassThroughEntityEIN'),
  (541279, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8936PartIICYCreditsGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / Form8830 CY Credits Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54079, 54, '080', 'Form8830 CY Credits Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541280, 54079, '1', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541281, 54079, '2', 'Total General Bus Credits Amt', 'CURRENCY'),
  (541282, 54079, '3', 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY'),
  (541283, 54079, '4', 'CY General Business Cr Item Cnt', 'INTEGER'),
  (541284, 54079, '5', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (541285, 54079, '6', 'Pass Through Entity EIN', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541280, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8830CYCreditsGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541281, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8830CYCreditsGrp/TotalGeneralBusCreditsAmt'),
  (541282, NULL, NULL, 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8830CYCreditsGrp/CYAndPYPassiveActyCrAllwCYAmt'),
  (541283, NULL, NULL, 'CY General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Form8830CYCreditsGrp/CYGeneralBusinessCrItemCnt'),
  (541284, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8830CYCreditsGrp/CrSubjToPassiveActyLmtAmt'),
  (541285, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Form8830CYCreditsGrp/PassThroughEntityEIN');

-- 990T / Form8881 Part IICY Credits Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54080, 54, '081', 'Form8881 Part IICY Credits Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541286, 54080, '1', 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY'),
  (541287, 54080, '2', 'Total General Bus Credits Amt', 'CURRENCY'),
  (541288, 54080, '3', 'CY General Business Cr Item Cnt', 'INTEGER'),
  (541289, 54080, '4', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541290, 54080, '5', 'Pass Through Entity EIN', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541286, NULL, NULL, 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8881PartIICYCreditsGrp/CYAndPYPassiveActyCrAllwCYAmt'),
  (541287, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8881PartIICYCreditsGrp/TotalGeneralBusCreditsAmt'),
  (541288, NULL, NULL, 'CY General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Form8881PartIICYCreditsGrp/CYGeneralBusinessCrItemCnt'),
  (541289, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8881PartIICYCreditsGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541290, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Form8881PartIICYCreditsGrp/PassThroughEntityEIN');

-- 990T / Form8932 CY Credits Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54081, 54, '082', 'Form8932 CY Credits Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541291, 54081, '1', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541292, 54081, '2', 'Total General Bus Credits Amt', 'CURRENCY'),
  (541293, 54081, '3', 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY'),
  (541294, 54081, '4', 'CY General Business Cr Item Cnt', 'INTEGER'),
  (541295, 54081, '5', 'Pass Through Entity EIN', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541291, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8932CYCreditsGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541292, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8932CYCreditsGrp/TotalGeneralBusCreditsAmt'),
  (541293, NULL, NULL, 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8932CYCreditsGrp/CYAndPYPassiveActyCrAllwCYAmt'),
  (541294, NULL, NULL, 'CY General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Form8932CYCreditsGrp/CYGeneralBusinessCrItemCnt'),
  (541295, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Form8932CYCreditsGrp/PassThroughEntityEIN');

-- 990T / Form3468 Part IICY Credits Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54082, 54, '083', 'Form3468 Part IICY Credits Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541296, 54082, '1', 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY'),
  (541297, 54082, '2', 'CY General Business Cr Item Cnt', 'INTEGER'),
  (541298, 54082, '3', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541299, 54082, '4', 'Total General Bus Credits Amt', 'CURRENCY'),
  (541300, 54082, '5', 'Pass Through Entity EIN', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541296, NULL, NULL, 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY', 'ReturnData/IRS3800/Form3468PartIICYCreditsGrp/CYAndPYPassiveActyCrAllwCYAmt'),
  (541297, NULL, NULL, 'CY General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Form3468PartIICYCreditsGrp/CYGeneralBusinessCrItemCnt'),
  (541298, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Form3468PartIICYCreditsGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541299, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/Form3468PartIICYCreditsGrp/TotalGeneralBusCreditsAmt'),
  (541300, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Form3468PartIICYCreditsGrp/PassThroughEntityEIN');

-- 990T / Form7213 Part ICY Credits Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54083, 54, '084', 'Form7213 Part ICY Credits Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541301, 54083, '1', 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY'),
  (541302, 54083, '2', 'CY General Business Cr Item Cnt', 'INTEGER'),
  (541303, 54083, '3', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541304, 54083, '4', 'Total General Bus Credits Amt', 'CURRENCY'),
  (541305, 54083, '5', 'Pass Through Entity EIN', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541301, NULL, NULL, 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY', 'ReturnData/IRS3800/Form7213PartICYCreditsGrp/CYAndPYPassiveActyCrAllwCYAmt'),
  (541302, NULL, NULL, 'CY General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Form7213PartICYCreditsGrp/CYGeneralBusinessCrItemCnt'),
  (541303, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Form7213PartICYCreditsGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541304, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/Form7213PartICYCreditsGrp/TotalGeneralBusCreditsAmt'),
  (541305, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Form7213PartICYCreditsGrp/PassThroughEntityEIN');

-- 990T / Form8820 CY Credits Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54084, 54, '085', 'Form8820 CY Credits Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541306, 54084, '1', 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY'),
  (541307, 54084, '2', 'CY General Business Cr Item Cnt', 'INTEGER'),
  (541308, 54084, '3', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541309, 54084, '4', 'Total General Bus Credits Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541306, NULL, NULL, 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8820CYCreditsGrp/CYAndPYPassiveActyCrAllwCYAmt'),
  (541307, NULL, NULL, 'CY General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Form8820CYCreditsGrp/CYGeneralBusinessCrItemCnt'),
  (541308, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8820CYCreditsGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541309, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8820CYCreditsGrp/TotalGeneralBusCreditsAmt');

-- 990T / Form8826 CY Credits Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54085, 54, '086', 'Form8826 CY Credits Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541310, 54085, '1', 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY'),
  (541311, 54085, '2', 'CY General Business Cr Item Cnt', 'INTEGER'),
  (541312, 54085, '3', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541313, 54085, '4', 'Total General Bus Credits Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541310, NULL, NULL, 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8826CYCreditsGrp/CYAndPYPassiveActyCrAllwCYAmt'),
  (541311, NULL, NULL, 'CY General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Form8826CYCreditsGrp/CYGeneralBusinessCrItemCnt'),
  (541312, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8826CYCreditsGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541313, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8826CYCreditsGrp/TotalGeneralBusCreditsAmt');

-- 990T / Form8874 CY Credits Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54086, 54, '087', 'Form8874 CY Credits Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541314, 54086, '1', 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY'),
  (541315, 54086, '2', 'CY General Business Cr Item Cnt', 'INTEGER'),
  (541316, 54086, '3', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541317, 54086, '4', 'Total General Bus Credits Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541314, NULL, NULL, 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8874CYCreditsGrp/CYAndPYPassiveActyCrAllwCYAmt'),
  (541315, NULL, NULL, 'CY General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Form8874CYCreditsGrp/CYGeneralBusinessCrItemCnt'),
  (541316, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8874CYCreditsGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541317, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8874CYCreditsGrp/TotalGeneralBusCreditsAmt');

-- 990T / Form8881 Part IIICY Credits Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54087, 54, '088', 'Form8881 Part IIICY Credits Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541318, 54087, '1', 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY'),
  (541319, 54087, '2', 'CY General Business Cr Item Cnt', 'INTEGER'),
  (541320, 54087, '3', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541321, 54087, '4', 'Total General Bus Credits Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541318, NULL, NULL, 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8881PartIIICYCreditsGrp/CYAndPYPassiveActyCrAllwCYAmt'),
  (541319, NULL, NULL, 'CY General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Form8881PartIIICYCreditsGrp/CYGeneralBusinessCrItemCnt'),
  (541320, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8881PartIIICYCreditsGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541321, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8881PartIIICYCreditsGrp/TotalGeneralBusCreditsAmt');

-- 990T / Form8896 CY Credits Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54088, 54, '089', 'Form8896 CY Credits Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541322, 54088, '1', 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY'),
  (541323, 54088, '2', 'CY General Business Cr Item Cnt', 'INTEGER'),
  (541324, 54088, '3', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541325, 54088, '4', 'Total General Bus Credits Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541322, NULL, NULL, 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8896CYCreditsGrp/CYAndPYPassiveActyCrAllwCYAmt'),
  (541323, NULL, NULL, 'CY General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Form8896CYCreditsGrp/CYGeneralBusinessCrItemCnt'),
  (541324, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8896CYCreditsGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541325, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8896CYCreditsGrp/TotalGeneralBusCreditsAmt');

-- 990T / Form8906 CY Credits Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54089, 54, '090', 'Form8906 CY Credits Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541326, 54089, '1', 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY'),
  (541327, 54089, '2', 'CY General Business Cr Item Cnt', 'INTEGER'),
  (541328, 54089, '3', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541329, 54089, '4', 'Total General Bus Credits Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541326, NULL, NULL, 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8906CYCreditsGrp/CYAndPYPassiveActyCrAllwCYAmt'),
  (541327, NULL, NULL, 'CY General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Form8906CYCreditsGrp/CYGeneralBusinessCrItemCnt'),
  (541328, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8906CYCreditsGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541329, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8906CYCreditsGrp/TotalGeneralBusCreditsAmt');

-- 990T / Form8910 CY Credits Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54090, 54, '091', 'Form8910 CY Credits Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541330, 54090, '1', 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY'),
  (541331, 54090, '2', 'CY General Business Cr Item Cnt', 'INTEGER'),
  (541332, 54090, '3', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541333, 54090, '4', 'Total General Bus Credits Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541330, NULL, NULL, 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8910CYCreditsGrp/CYAndPYPassiveActyCrAllwCYAmt'),
  (541331, NULL, NULL, 'CY General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Form8910CYCreditsGrp/CYGeneralBusinessCrItemCnt'),
  (541332, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8910CYCreditsGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541333, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8910CYCreditsGrp/TotalGeneralBusCreditsAmt');

-- 990T / Form8941 CY Credits Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54091, 54, '092', 'Form8941 CY Credits Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541334, 54091, '1', 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY'),
  (541335, 54091, '2', 'CY General Business Cr Item Cnt', 'INTEGER'),
  (541336, 54091, '3', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541337, 54091, '4', 'Total General Bus Credits Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541334, NULL, NULL, 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8941CYCreditsGrp/CYAndPYPassiveActyCrAllwCYAmt'),
  (541335, NULL, NULL, 'CY General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Form8941CYCreditsGrp/CYGeneralBusinessCrItemCnt'),
  (541336, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8941CYCreditsGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541337, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8941CYCreditsGrp/TotalGeneralBusCreditsAmt');

-- 990T / Frm8864 SAFCY Credits Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54092, 54, '093', 'Frm8864 SAFCY Credits Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541338, 54092, '1', 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY'),
  (541339, 54092, '2', 'CY General Business Cr Item Cnt', 'INTEGER'),
  (541340, 54092, '3', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541341, 54092, '4', 'Total General Bus Credits Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541338, NULL, NULL, 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8864SAFCYCreditsGrp/CYAndPYPassiveActyCrAllwCYAmt'),
  (541339, NULL, NULL, 'CY General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm8864SAFCYCreditsGrp/CYGeneralBusinessCrItemCnt'),
  (541340, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8864SAFCYCreditsGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541341, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8864SAFCYCreditsGrp/TotalGeneralBusCreditsAmt');

-- 990T / Gen Bus CY Other Credits Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54093, 54, '094', 'Gen Bus CY Other Credits Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541342, 54093, '1', 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY'),
  (541343, 54093, '2', 'CY General Business Cr Item Cnt', 'INTEGER'),
  (541344, 54093, '3', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541345, 54093, '4', 'Total General Bus Credits Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541342, NULL, NULL, 'CY And PY Passive Acty Cr Allw CY Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCYOtherCreditsGrp/CYAndPYPassiveActyCrAllwCYAmt'),
  (541343, NULL, NULL, 'CY General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/GenBusCYOtherCreditsGrp/CYGeneralBusinessCrItemCnt'),
  (541344, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCYOtherCreditsGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541345, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCYOtherCreditsGrp/TotalGeneralBusCreditsAmt');

-- 990T / Frm6765 CY Cyov Cr Aggrgt Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54094, 54, '095', 'Frm6765 CY Cyov Cr Aggrgt Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541346, 54094, '1', 'Yr', 'TEXT'),
  (541347, 54094, '2', 'Pass Through Entity EIN', 'TEXT'),
  (541348, 54094, '3', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (541349, 54094, '4', 'Nonpassive Ind', 'BOOLEAN'),
  (541350, 54094, '5', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (541351, 54094, '6', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541352, 54094, '7', 'Total General Bus Credits App Tx Amt', 'CURRENCY'),
  (541353, 54094, '8', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (541354, 54094, '9', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (541355, 54094, '10', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (541356, 54094, '11', 'ESBC Carryforward Amt', 'CURRENCY'),
  (541357, 54094, '12', 'Missing EIN Reason Cd', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541346, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/Frm6765CYCyovCrAggrgtGrp/Yr'),
  (541347, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Frm6765CYCyovCrAggrgtGrp/PassThroughEntityEIN'),
  (541348, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm6765CYCyovCrAggrgtGrp/CYGeneralBusCrCarryforwardAmt'),
  (541349, NULL, NULL, 'Nonpassive Ind', 'BOOLEAN', 'ReturnData/IRS3800/Frm6765CYCyovCrAggrgtGrp/NonpassiveInd'),
  (541350, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm6765CYCyovCrAggrgtGrp/CarryforwardGeneralBusCrAmt'),
  (541351, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm6765CYCyovCrAggrgtGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541352, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm6765CYCyovCrAggrgtGrp/TotalGeneralBusCreditsAppTxAmt'),
  (541353, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm6765CYCyovCrAggrgtGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (541354, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm6765CYCyovCrAggrgtGrp/PassiveActivityCrAfterLmtAmt'),
  (541355, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm6765CYCyovCrAggrgtGrp/CrSubjToPassiveActyLmtAmt'),
  (541356, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm6765CYCyovCrAggrgtGrp/ESBCCarryforwardAmt'),
  (541357, NULL, NULL, 'Missing EIN Reason Cd', 'TEXT', 'ReturnData/IRS3800/Frm6765CYCyovCrAggrgtGrp/MissingEINReasonCd');

-- 990T / Elected Property
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54095, 54, '096', 'Elected Property');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541358, 54095, '1', 'Elected Cost Amt', 'CURRENCY'),
  (541359, 54095, '2', 'Cost For Business Use Only Amt', 'CURRENCY'),
  (541360, 54095, '3', 'Property Desc', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541358, NULL, NULL, 'Elected Cost Amt', 'CURRENCY', 'ReturnData/IRS4562/ElectedProperty/ElectedCostAmt'),
  (541359, NULL, NULL, 'Cost For Business Use Only Amt', 'CURRENCY', 'ReturnData/IRS4562/ElectedProperty/CostForBusinessUseOnlyAmt'),
  (541360, NULL, NULL, 'Property Desc', 'TEXT', 'ReturnData/IRS4562/ElectedProperty/PropertyDesc');

-- 990T / CY Cyov Cfwd GBC Sub Tot Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54096, 54, '097', 'CY Cyov Cfwd GBC Sub Tot Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541361, 54096, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (541362, 54096, '2', 'Carry Back General Business Cr Amt', 'CURRENCY'),
  (541363, 54096, '3', 'ESBC Carryforward Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541361, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCyovCfwdGBCSubTotGrp/CYGeneralBusCrCarryforwardAmt'),
  (541362, NULL, NULL, 'Carry Back General Business Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCyovCfwdGBCSubTotGrp/CarryBackGeneralBusinessCrAmt'),
  (541363, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCyovCfwdGBCSubTotGrp/ESBCCarryforwardAmt');

-- 990T / CY Cyov Cfwd GBC Sub Tot Aggrgt Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54097, 54, '098', 'CY Cyov Cfwd GBC Sub Tot Aggrgt Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541364, 54097, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (541365, 54097, '2', 'Carry Back General Business Cr Amt', 'CURRENCY'),
  (541366, 54097, '3', 'ESBC Carryforward Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541364, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCyovCfwdGBCSubTotAggrgtGrp/CYGeneralBusCrCarryforwardAmt'),
  (541365, NULL, NULL, 'Carry Back General Business Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCyovCfwdGBCSubTotAggrgtGrp/CarryBackGeneralBusinessCrAmt'),
  (541366, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCyovCfwdGBCSubTotAggrgtGrp/ESBCCarryforwardAmt');

-- 990T / Tot8844 Oth Spcfd GBC Or ESBC Amt Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54098, 54, '099', 'Tot8844 Oth Spcfd GBC Or ESBC Amt Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541367, 54098, '1', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541368, 54098, '2', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (541369, 54098, '3', 'Total General Bus Credits App Tx Amt', 'CURRENCY'),
  (541370, 54098, '4', 'Missing EIN Reason Cd', 'TEXT'),
  (541371, 54098, '5', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (541372, 54098, '6', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (541373, 54098, '7', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (541374, 54098, '8', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541367, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Tot8844OthSpcfdGBCOrESBCAmtGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541368, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Tot8844OthSpcfdGBCOrESBCAmtGrp/CarryforwardGeneralBusCrAmt'),
  (541369, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Tot8844OthSpcfdGBCOrESBCAmtGrp/TotalGeneralBusCreditsAppTxAmt'),
  (541370, NULL, NULL, 'Missing EIN Reason Cd', 'TEXT', 'ReturnData/IRS3800/Tot8844OthSpcfdGBCOrESBCAmtGrp/MissingEINReasonCd'),
  (541371, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Tot8844OthSpcfdGBCOrESBCAmtGrp/CyovGeneralBusinessCrItemCnt'),
  (541372, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Tot8844OthSpcfdGBCOrESBCAmtGrp/CrSubjToPassiveActyLmtAmt'),
  (541373, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Tot8844OthSpcfdGBCOrESBCAmtGrp/PassiveActivityCrAfterLmtAmt'),
  (541374, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Tot8844OthSpcfdGBCOrESBCAmtGrp/GeneralBusCrCyovRcptrAdjAmt');

-- 990T / Amortization Info
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54099, 54, '100', 'Amortization Info');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541375, 54099, '1', 'Amortization This Year Amt', 'CURRENCY'),
  (541376, 54099, '2', 'Cost Desc', 'TEXT'),
  (541377, 54099, '3', 'Amortizable Amt', 'CURRENCY'),
  (541378, 54099, '4', 'Amortization Period Or Pct Txt', 'TEXT'),
  (541379, 54099, '5', 'Amortization Begin Dt', 'TEXT'),
  (541380, 54099, '6', 'Code Section Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541375, NULL, NULL, 'Amortization This Year Amt', 'CURRENCY', 'ReturnData/IRS4562/AmortizationInfo/AmortizationInfoTable/AmortizationThisYearAmt'),
  (541376, NULL, NULL, 'Cost Desc', 'TEXT', 'ReturnData/IRS4562/AmortizationInfo/AmortizationInfoTable/CostDesc'),
  (541377, NULL, NULL, 'Amortizable Amt', 'CURRENCY', 'ReturnData/IRS4562/AmortizationInfo/AmortizationInfoTable/AmortizableAmt'),
  (541378, NULL, NULL, 'Amortization Period Or Pct Txt', 'TEXT', 'ReturnData/IRS4562/AmortizationInfo/AmortizationInfoTable/AmortizationPeriodOrPctTxt'),
  (541379, NULL, NULL, 'Amortization Begin Dt', 'TEXT', 'ReturnData/IRS4562/AmortizationInfo/AmortizationInfoTable/AmortizationBeginDt'),
  (541380, NULL, NULL, 'Code Section Txt', 'TEXT', 'ReturnData/IRS4562/AmortizationInfo/AmortizationInfoTable/CodeSectionTxt');

-- 990T / Frm8846 CY Spcfd Cr Aggrgt Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54100, 54, '101', 'Frm8846 CY Spcfd Cr Aggrgt Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541381, 54100, '1', 'Yr', 'TEXT'),
  (541382, 54100, '2', 'Pass Through Entity EIN', 'TEXT'),
  (541383, 54100, '3', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (541384, 54100, '4', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (541385, 54100, '5', 'Nonpassive Ind', 'BOOLEAN'),
  (541386, 54100, '6', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541387, 54100, '7', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (541388, 54100, '8', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (541389, 54100, '9', 'Total General Bus Credits App Tx Amt', 'CURRENCY'),
  (541390, 54100, '10', 'ESBC Carryforward Amt', 'CURRENCY'),
  (541391, 54100, '11', 'Missing EIN Reason Cd', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541381, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/Frm8846CYSpcfdCrAggrgtGrp/Yr'),
  (541382, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Frm8846CYSpcfdCrAggrgtGrp/PassThroughEntityEIN'),
  (541383, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8846CYSpcfdCrAggrgtGrp/CYGeneralBusCrCarryforwardAmt'),
  (541384, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8846CYSpcfdCrAggrgtGrp/CarryforwardGeneralBusCrAmt'),
  (541385, NULL, NULL, 'Nonpassive Ind', 'BOOLEAN', 'ReturnData/IRS3800/Frm8846CYSpcfdCrAggrgtGrp/NonpassiveInd'),
  (541386, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8846CYSpcfdCrAggrgtGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541387, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8846CYSpcfdCrAggrgtGrp/CrSubjToPassiveActyLmtAmt'),
  (541388, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8846CYSpcfdCrAggrgtGrp/PassiveActivityCrAfterLmtAmt'),
  (541389, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8846CYSpcfdCrAggrgtGrp/TotalGeneralBusCreditsAppTxAmt'),
  (541390, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8846CYSpcfdCrAggrgtGrp/ESBCCarryforwardAmt'),
  (541391, NULL, NULL, 'Missing EIN Reason Cd', 'TEXT', 'ReturnData/IRS3800/Frm8846CYSpcfdCrAggrgtGrp/MissingEINReasonCd');

-- 990T / Gen Bus Cr Or Elig Smll Bus Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54101, 54, '102', 'Gen Bus Cr Or Elig Smll Bus Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541392, 54101, '1', 'Credit For Employer SS Medcr Tx Amt', 'CURRENCY'),
  (541393, 54101, '2', 'Sum Of Allowable General Bus Cr Amt', 'CURRENCY'),
  (541394, 54101, '3', 'Total Business Credits Amt', 'CURRENCY'),
  (541395, 54101, '4', 'General Bus Cr From Nnpssv Acty Ind', 'BOOLEAN'),
  (541396, 54101, '5', 'CY Increasing Research Cr Amt', 'CURRENCY'),
  (541397, 54101, '6', 'Current Year General Bus Cr Amt', 'CURRENCY'),
  (541398, 54101, '7', 'Total Business Credits Amt', 'CURRENCY'),
  (541399, 54101, '8', 'Consolidated Section Ind', 'BOOLEAN'),
  (541400, 54101, '9', 'Pass Through Entity EIN', 'TEXT'),
  (541401, 54101, '10', 'Current Year Renewable Elec Cr Amt', 'CURRENCY'),
  (541402, 54101, '11', 'Credit For Employer SS Medcr Tx Amt', 'CURRENCY'),
  (541403, 54101, '12', 'Sum Of Allowable General Bus Cr Amt', 'CURRENCY'),
  (541404, 54101, '13', 'Current Year General Bus Cr Amt', 'CURRENCY'),
  (541405, 54101, '14', 'Agricultural Chemicals Credit Amt', 'CURRENCY'),
  (541406, 54101, '15', 'Allowable Qualified Elec Veh Amt', 'CURRENCY'),
  (541407, 54101, '16', 'Biofuel Producer Credit Amt', 'CURRENCY'),
  (541408, 54101, '17', 'Advnc Manufacturing Prod Cr Amt', 'CURRENCY'),
  (541409, 54101, '18', 'Current Year Alt Mtr Veh Cr Amt', 'CURRENCY'),
  (541410, 54101, '19', 'Current Year Alt Refueling Cr Amt', 'CURRENCY'),
  (541411, 54101, '20', 'Biodiesel Rnwbl Avn Fuel Cr Amt', 'CURRENCY'),
  (541412, 54101, '21', 'CY Emplr Prov Chld Care Fclts Cr Amt', 'CURRENCY'),
  (541413, 54101, '22', 'CY Engy Efficient Appliance Amt', 'CURRENCY'),
  (541414, 54101, '23', 'Current Yr Engy Efficient Hm Cr Amt', 'CURRENCY'),
  (541415, 54101, '24', 'Enhanced Oil Recovery Credit Amt', 'CURRENCY'),
  (541416, 54101, '25', 'CY Gen Bus Cr Electing Lge Prtshp Amt', 'CURRENCY'),
  (541417, 54101, '26', 'Current Year Low Income Hsng Cr Amt', 'CURRENCY'),
  (541418, 54101, '27', 'Current Year Low Sulfur Dsl Cr Amt', 'CURRENCY'),
  (541419, 54101, '28', 'Current Year Nnconv Fuel Cr Amt', 'CURRENCY'),
  (541420, 54101, '29', 'Current Yr Smll Emplr Pnsn Plan Amt', 'CURRENCY'),
  (541421, 54101, '30', 'Carbon Dioxide Credit Amt', 'CURRENCY'),
  (541422, 54101, '31', 'Current Year Disabled Access Cr Amt', 'CURRENCY'),
  (541423, 54101, '32', 'CY Indian Employment Credit Amt', 'CURRENCY'),
  (541424, 54101, '33', 'Current Year Investment Credit Amt', 'CURRENCY'),
  (541425, 54101, '34', 'Current Year New Markets Credit Amt', 'CURRENCY'),
  (541426, 54101, '35', 'Current Year Orphan Drug Credit Amt', 'CURRENCY'),
  (541427, 54101, '36', 'Differential Wage Payments Cr Amt', 'CURRENCY'),
  (541428, 54101, '37', 'Distilled Spirits Credit Amt', 'CURRENCY'),
  (541429, 54101, '38', 'Employee Retention Credit Amt', 'CURRENCY'),
  (541430, 54101, '39', 'Emplr Cr Pd Family Med Leave Amt', 'CURRENCY'),
  (541431, 54101, '40', 'Enter Amount From F8844 Amt', 'CURRENCY'),
  (541432, 54101, '41', 'Research Activities Incr Cr Amt', 'CURRENCY'),
  (541433, 54101, '42', 'Investment Credit Amt', 'CURRENCY'),
  (541434, 54101, '43', 'Low Income Housing Credit Amt', 'CURRENCY'),
  (541435, 54101, '44', 'Mine Rescue Team Training Cr Amt', 'CURRENCY'),
  (541436, 54101, '45', 'Other Current Year Credit Amt', 'CURRENCY'),
  (541437, 54101, '46', 'Other Specified Credit Amt', 'CURRENCY'),
  (541438, 54101, '47', 'Qlfy Plug In Elec Drive Mtr Veh Cr Amt', 'CURRENCY'),
  (541439, 54101, '48', 'Qualified Railroad Track Maint Amt', 'CURRENCY'),
  (541440, 54101, '49', 'Renewable Electricity Prod Cr Amt', 'CURRENCY'),
  (541441, 54101, '50', 'Small Employer HIP Credit Amt', 'CURRENCY'),
  (541442, 54101, '51', 'Work Opportunity Cr From5884 Amt', 'CURRENCY'),
  (541443, 54101, '52', 'CY Increasing Research Cr Amt', 'CURRENCY'),
  (541444, 54101, '53', 'Pass Through Entity EIN', 'TEXT'),
  (541445, 54101, '54', 'Investment Credit Amt', 'CURRENCY'),
  (541446, 54101, '55', 'Pass Through Entity EIN', 'TEXT'),
  (541447, 54101, '56', 'Work Opportunity Cr From5884 Amt', 'CURRENCY'),
  (541448, 54101, '57', 'CY Increasing Research Cr Amt', 'CURRENCY'),
  (541449, 54101, '58', 'Pass Through Entity EIN', 'TEXT'),
  (541450, 54101, '59', 'Current Year Renewable Elec Cr Amt', 'CURRENCY'),
  (541451, 54101, '60', 'Pass Through Entity EIN', 'TEXT'),
  (541452, 54101, '61', 'Current Year General Bus Cr Amt', 'CURRENCY'),
  (541453, 54101, '62', 'Total Business Credits Amt', 'CURRENCY'),
  (541454, 54101, '63', 'General Bus Cr From Passive Acty Ind', 'BOOLEAN'),
  (541455, 54101, '64', 'Current Year Disabled Access Cr Amt', 'CURRENCY'),
  (541456, 54101, '65', 'Current Year General Bus Cr Amt', 'CURRENCY'),
  (541457, 54101, '66', 'Research Activities Incr Cr Amt', 'CURRENCY'),
  (541458, 54101, '67', 'Total Business Credits Amt', 'CURRENCY'),
  (541459, 54101, '68', 'General Bus Cr Carrybacks Ind', 'BOOLEAN'),
  (541460, 54101, '69', 'Current Yr Engy Efficient Hm Cr Amt', 'CURRENCY'),
  (541461, 54101, '70', 'Pass Through Entity EIN', 'TEXT'),
  (541462, 54101, '71', 'Pass Through Entity EIN', 'TEXT'),
  (541463, 54101, '72', 'Research Activities Incr Cr Amt', 'CURRENCY'),
  (541464, 54101, '73', 'Other Specified Credit Amt', 'CURRENCY'),
  (541465, 54101, '74', 'Pass Through Entity EIN', 'TEXT'),
  (541466, 54101, '75', 'Sum Of Allowable General Bus Cr Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541392, NULL, NULL, 'Credit For Employer SS Medcr Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/GeneralBusCrFromNnpssvActyGrp/BusinessCreditsGrp/CrForEmployerSSMedicareTaxGrp/CreditForEmployerSSMedcrTxAmt'),
  (541393, NULL, NULL, 'Sum Of Allowable General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/GeneralBusCrFromNnpssvActyGrp/BusinessCreditsGrp/SumOfAllowableGeneralBusCrAmt'),
  (541394, NULL, NULL, 'Total Business Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/GeneralBusCrFromNnpssvActyGrp/BusinessCreditsGrp/TotalBusinessCreditsAmt'),
  (541395, NULL, NULL, 'General Bus Cr From Nnpssv Acty Ind', 'BOOLEAN', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/GeneralBusCrFromNnpssvActyGrp/GeneralBusCrFromNnpssvActyInd'),
  (541396, NULL, NULL, 'CY Increasing Research Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/ConsolidatedBusinessCreditsGrp/BusinessCreditsGrp/CYIncreasingResearchCrGrp/CYIncreasingResearchCrAmt'),
  (541397, NULL, NULL, 'Current Year General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/ConsolidatedBusinessCreditsGrp/BusinessCreditsGrp/CurrentYearGeneralBusCrAmt'),
  (541398, NULL, NULL, 'Total Business Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/ConsolidatedBusinessCreditsGrp/BusinessCreditsGrp/TotalBusinessCreditsAmt'),
  (541399, NULL, NULL, 'Consolidated Section Ind', 'BOOLEAN', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/ConsolidatedBusinessCreditsGrp/ConsolidatedSectionInd'),
  (541400, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/GeneralBusCrFromNnpssvActyGrp/BusinessCreditsGrp/CrForEmployerSSMedicareTaxGrp/PassThroughEntityEIN'),
  (541401, NULL, NULL, 'Current Year Renewable Elec Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/ConsolidatedBusinessCreditsGrp/BusinessCreditsGrp/CYRenewableElectricityCrGrp/CurrentYearRenewableElecCrAmt'),
  (541402, NULL, NULL, 'Credit For Employer SS Medcr Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/ConsolidatedBusinessCreditsGrp/BusinessCreditsGrp/CrForEmployerSSMedicareTaxGrp/CreditForEmployerSSMedcrTxAmt'),
  (541403, NULL, NULL, 'Sum Of Allowable General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/ConsolidatedBusinessCreditsGrp/BusinessCreditsGrp/SumOfAllowableGeneralBusCrAmt'),
  (541404, NULL, NULL, 'Current Year General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/GeneralBusCrFromNnpssvActyGrp/BusinessCreditsGrp/CurrentYearGeneralBusCrAmt'),
  (541405, NULL, NULL, 'Agricultural Chemicals Credit Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/ConsolidatedBusinessCreditsGrp/BusinessCreditsGrp/AgriculturalChemicalsCreditGrp/AgriculturalChemicalsCreditAmt'),
  (541406, NULL, NULL, 'Allowable Qualified Elec Veh Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/ConsolidatedBusinessCreditsGrp/BusinessCreditsGrp/AllowableQlfyElectricVehGrp/AllowableQualifiedElecVehAmt'),
  (541407, NULL, NULL, 'Biofuel Producer Credit Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/ConsolidatedBusinessCreditsGrp/BusinessCreditsGrp/BiofuelProducerCreditGrp/BiofuelProducerCreditAmt'),
  (541408, NULL, NULL, 'Advnc Manufacturing Prod Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/ConsolidatedBusinessCreditsGrp/BusinessCreditsGrp/CYAdvncManufacturingProdCrGrp/AdvncManufacturingProdCrAmt'),
  (541409, NULL, NULL, 'Current Year Alt Mtr Veh Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/ConsolidatedBusinessCreditsGrp/BusinessCreditsGrp/CYAlternativeMotorVehicleCrGrp/CurrentYearAltMtrVehCrAmt'),
  (541410, NULL, NULL, 'Current Year Alt Refueling Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/ConsolidatedBusinessCreditsGrp/BusinessCreditsGrp/CYAlternativeRefuelingCrGrp/CurrentYearAltRefuelingCrAmt'),
  (541411, NULL, NULL, 'Biodiesel Rnwbl Avn Fuel Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/ConsolidatedBusinessCreditsGrp/BusinessCreditsGrp/CYBiodieselRnwblAvnFuelCrGrp/BiodieselRnwblAvnFuelCrAmt'),
  (541412, NULL, NULL, 'CY Emplr Prov Chld Care Fclts Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/ConsolidatedBusinessCreditsGrp/BusinessCreditsGrp/CYEmplrProvChildCareFcltsCrGrp/CYEmplrProvChldCareFcltsCrAmt'),
  (541413, NULL, NULL, 'CY Engy Efficient Appliance Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/ConsolidatedBusinessCreditsGrp/BusinessCreditsGrp/CYEnergyEfficientApplianceGrp/CYEngyEfficientApplianceAmt'),
  (541414, NULL, NULL, 'Current Yr Engy Efficient Hm Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/ConsolidatedBusinessCreditsGrp/BusinessCreditsGrp/CYEnergyEfficientHomeCreditGrp/CurrentYrEngyEfficientHmCrAmt'),
  (541415, NULL, NULL, 'Enhanced Oil Recovery Credit Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/ConsolidatedBusinessCreditsGrp/BusinessCreditsGrp/CYEnhancedOilRecoveryCreditGrp/EnhancedOilRecoveryCreditAmt'),
  (541416, NULL, NULL, 'CY Gen Bus Cr Electing Lge Prtshp Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/ConsolidatedBusinessCreditsGrp/BusinessCreditsGrp/CYGenBusCrElectingLgePrtshpGrp/CYGenBusCrElectingLgePrtshpAmt'),
  (541417, NULL, NULL, 'Current Year Low Income Hsng Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/ConsolidatedBusinessCreditsGrp/BusinessCreditsGrp/CYLowIncomeHousingCrGrp/CurrentYearLowIncomeHsngCrAmt'),
  (541418, NULL, NULL, 'Current Year Low Sulfur Dsl Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/ConsolidatedBusinessCreditsGrp/BusinessCreditsGrp/CYLowSulfurDieselCreditGrp/CurrentYearLowSulfurDslCrAmt'),
  (541419, NULL, NULL, 'Current Year Nnconv Fuel Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/ConsolidatedBusinessCreditsGrp/BusinessCreditsGrp/CYNonconventionalFuelCreditGrp/CurrentYearNnconvFuelCrAmt'),
  (541420, NULL, NULL, 'Current Yr Smll Emplr Pnsn Plan Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/ConsolidatedBusinessCreditsGrp/BusinessCreditsGrp/CYSmallEmployerPensionPlanGrp/CurrentYrSmllEmplrPnsnPlanAmt'),
  (541421, NULL, NULL, 'Carbon Dioxide Credit Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/ConsolidatedBusinessCreditsGrp/BusinessCreditsGrp/CarbonDioxideCreditGrp/CarbonDioxideCreditAmt'),
  (541422, NULL, NULL, 'Current Year Disabled Access Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/ConsolidatedBusinessCreditsGrp/BusinessCreditsGrp/CurrentYearDisabledAccessCrGrp/CurrentYearDisabledAccessCrAmt'),
  (541423, NULL, NULL, 'CY Indian Employment Credit Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/ConsolidatedBusinessCreditsGrp/BusinessCreditsGrp/CurrentYearIndianEmplmnCrGrp/CYIndianEmploymentCreditAmt'),
  (541424, NULL, NULL, 'Current Year Investment Credit Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/ConsolidatedBusinessCreditsGrp/BusinessCreditsGrp/CurrentYearInvestmentCreditGrp/CurrentYearInvestmentCreditAmt'),
  (541425, NULL, NULL, 'Current Year New Markets Credit Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/ConsolidatedBusinessCreditsGrp/BusinessCreditsGrp/CurrentYearNewMarketsCreditGrp/CurrentYearNewMarketsCreditAmt'),
  (541426, NULL, NULL, 'Current Year Orphan Drug Credit Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/ConsolidatedBusinessCreditsGrp/BusinessCreditsGrp/CurrentYearOrphanDrugCreditGrp/CurrentYearOrphanDrugCreditAmt'),
  (541427, NULL, NULL, 'Differential Wage Payments Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/ConsolidatedBusinessCreditsGrp/BusinessCreditsGrp/DifferentialWagePaymentsCrGrp/DifferentialWagePaymentsCrAmt'),
  (541428, NULL, NULL, 'Distilled Spirits Credit Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/ConsolidatedBusinessCreditsGrp/BusinessCreditsGrp/DistilledSpiritsCreditGrp/DistilledSpiritsCreditAmt'),
  (541429, NULL, NULL, 'Employee Retention Credit Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/ConsolidatedBusinessCreditsGrp/BusinessCreditsGrp/EmployeeRetentionCreditGrp/EmployeeRetentionCreditAmt'),
  (541430, NULL, NULL, 'Emplr Cr Pd Family Med Leave Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/ConsolidatedBusinessCreditsGrp/BusinessCreditsGrp/EmplrCrPdFamilyMedLeaveGrp/EmplrCrPdFamilyMedLeaveAmt'),
  (541431, NULL, NULL, 'Enter Amount From F8844 Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/ConsolidatedBusinessCreditsGrp/BusinessCreditsGrp/EnterAmountFromF8844Grp/EnterAmountFromF8844Amt'),
  (541432, NULL, NULL, 'Research Activities Incr Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/ConsolidatedBusinessCreditsGrp/BusinessCreditsGrp/IncreasingResearchCrGrp/ResearchActivitiesIncrCrAmt'),
  (541433, NULL, NULL, 'Investment Credit Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/ConsolidatedBusinessCreditsGrp/BusinessCreditsGrp/InvestmentCreditGrp/InvestmentCreditAmt'),
  (541434, NULL, NULL, 'Low Income Housing Credit Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/ConsolidatedBusinessCreditsGrp/BusinessCreditsGrp/LowIncomeHousingCreditGrp/LowIncomeHousingCreditAmt'),
  (541435, NULL, NULL, 'Mine Rescue Team Training Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/ConsolidatedBusinessCreditsGrp/BusinessCreditsGrp/MineRescueTeamTrainingCrGrp/MineRescueTeamTrainingCrAmt'),
  (541436, NULL, NULL, 'Other Current Year Credit Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/ConsolidatedBusinessCreditsGrp/BusinessCreditsGrp/OtherCurrentYearCreditAmtGrp/OtherCurrentYearCreditAmt'),
  (541437, NULL, NULL, 'Other Specified Credit Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/ConsolidatedBusinessCreditsGrp/BusinessCreditsGrp/OtherSpecifiedCreditAmtGrp/OtherSpecifiedCreditAmt'),
  (541438, NULL, NULL, 'Qlfy Plug In Elec Drive Mtr Veh Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/ConsolidatedBusinessCreditsGrp/BusinessCreditsGrp/QlfyPlugInElecDriveMtrVehCrGrp/QlfyPlugInElecDriveMtrVehCrAmt'),
  (541439, NULL, NULL, 'Qualified Railroad Track Maint Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/ConsolidatedBusinessCreditsGrp/BusinessCreditsGrp/QualifiedRailroadTrackMaintGrp/QualifiedRailroadTrackMaintAmt'),
  (541440, NULL, NULL, 'Renewable Electricity Prod Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/ConsolidatedBusinessCreditsGrp/BusinessCreditsGrp/RenewableElectricityProdCrGrp/RenewableElectricityProdCrAmt'),
  (541441, NULL, NULL, 'Small Employer HIP Credit Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/ConsolidatedBusinessCreditsGrp/BusinessCreditsGrp/SmallEmployerHIPCreditAmtGrp/SmallEmployerHIPCreditAmt'),
  (541442, NULL, NULL, 'Work Opportunity Cr From5884 Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/ConsolidatedBusinessCreditsGrp/BusinessCreditsGrp/WorkOpportunityCrFrom5884Grp/WorkOpportunityCrFrom5884Amt'),
  (541443, NULL, NULL, 'CY Increasing Research Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/GeneralBusCrFromNnpssvActyGrp/BusinessCreditsGrp/CYIncreasingResearchCrGrp/CYIncreasingResearchCrAmt'),
  (541444, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/GeneralBusCrFromNnpssvActyGrp/BusinessCreditsGrp/CYIncreasingResearchCrGrp/PassThroughEntityEIN'),
  (541445, NULL, NULL, 'Investment Credit Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/GeneralBusCrFromNnpssvActyGrp/BusinessCreditsGrp/InvestmentCreditGrp/InvestmentCreditAmt'),
  (541446, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/GeneralBusCrFromNnpssvActyGrp/BusinessCreditsGrp/WorkOpportunityCrFrom5884Grp/PassThroughEntityEIN'),
  (541447, NULL, NULL, 'Work Opportunity Cr From5884 Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/GeneralBusCrFromNnpssvActyGrp/BusinessCreditsGrp/WorkOpportunityCrFrom5884Grp/WorkOpportunityCrFrom5884Amt'),
  (541448, NULL, NULL, 'CY Increasing Research Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/GeneralBusCrFromPassiveActyGrp/BusinessCreditsGrp/CYIncreasingResearchCrGrp/CYIncreasingResearchCrAmt'),
  (541449, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/GeneralBusCrFromPassiveActyGrp/BusinessCreditsGrp/CYIncreasingResearchCrGrp/PassThroughEntityEIN'),
  (541450, NULL, NULL, 'Current Year Renewable Elec Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/GeneralBusCrFromPassiveActyGrp/BusinessCreditsGrp/CYRenewableElectricityCrGrp/CurrentYearRenewableElecCrAmt'),
  (541451, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/GeneralBusCrFromPassiveActyGrp/BusinessCreditsGrp/CYRenewableElectricityCrGrp/PassThroughEntityEIN'),
  (541452, NULL, NULL, 'Current Year General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/GeneralBusCrFromPassiveActyGrp/BusinessCreditsGrp/CurrentYearGeneralBusCrAmt'),
  (541453, NULL, NULL, 'Total Business Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/GeneralBusCrFromPassiveActyGrp/BusinessCreditsGrp/TotalBusinessCreditsAmt'),
  (541454, NULL, NULL, 'General Bus Cr From Passive Acty Ind', 'BOOLEAN', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/GeneralBusCrFromPassiveActyGrp/GeneralBusCrFromPassiveActyInd'),
  (541455, NULL, NULL, 'Current Year Disabled Access Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/GeneralBusCrCarrybacksGrp/BusinessCreditsGrp/CurrentYearDisabledAccessCrGrp/CurrentYearDisabledAccessCrAmt'),
  (541456, NULL, NULL, 'Current Year General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/GeneralBusCrCarrybacksGrp/BusinessCreditsGrp/CurrentYearGeneralBusCrAmt'),
  (541457, NULL, NULL, 'Research Activities Incr Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/GeneralBusCrCarrybacksGrp/BusinessCreditsGrp/IncreasingResearchCrGrp/ResearchActivitiesIncrCrAmt'),
  (541458, NULL, NULL, 'Total Business Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/GeneralBusCrCarrybacksGrp/BusinessCreditsGrp/TotalBusinessCreditsAmt'),
  (541459, NULL, NULL, 'General Bus Cr Carrybacks Ind', 'BOOLEAN', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/GeneralBusCrCarrybacksGrp/GeneralBusCrCarrybacksInd'),
  (541460, NULL, NULL, 'Current Yr Engy Efficient Hm Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/GeneralBusCrFromNnpssvActyGrp/BusinessCreditsGrp/CYEnergyEfficientHomeCreditGrp/CurrentYrEngyEfficientHmCrAmt'),
  (541461, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/GeneralBusCrFromNnpssvActyGrp/BusinessCreditsGrp/CYEnergyEfficientHomeCreditGrp/PassThroughEntityEIN'),
  (541462, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/GeneralBusCrFromNnpssvActyGrp/BusinessCreditsGrp/IncreasingResearchCrGrp/PassThroughEntityEIN'),
  (541463, NULL, NULL, 'Research Activities Incr Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/GeneralBusCrFromNnpssvActyGrp/BusinessCreditsGrp/IncreasingResearchCrGrp/ResearchActivitiesIncrCrAmt'),
  (541464, NULL, NULL, 'Other Specified Credit Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/GeneralBusCrFromNnpssvActyGrp/BusinessCreditsGrp/OtherSpecifiedCreditAmtGrp/OtherSpecifiedCreditAmt'),
  (541465, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/GeneralBusCrFromNnpssvActyGrp/BusinessCreditsGrp/OtherSpecifiedCreditAmtGrp/PassThroughEntityEIN'),
  (541466, NULL, NULL, 'Sum Of Allowable General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/GenBusCrOrEligSmllBusCrGrp/GeneralBusCrFromPassiveActyGrp/BusinessCreditsGrp/SumOfAllowableGeneralBusCrAmt');

-- 990T / Frm8882 CY Cyov Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54102, 54, '103', 'Frm8882 CY Cyov Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541467, 54102, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (541468, 54102, '2', 'Carry Back General Business Cr Amt', 'CURRENCY'),
  (541469, 54102, '3', 'ESBC Carryforward Amt', 'CURRENCY'),
  (541470, 54102, '4', 'Yr', 'TEXT'),
  (541471, 54102, '5', 'Non Passive Ind', 'BOOLEAN'),
  (541472, 54102, '6', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (541473, 54102, '7', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (541474, 54102, '8', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541475, 54102, '9', 'Total General Bus Credits App Tx Amt', 'CURRENCY'),
  (541476, 54102, '10', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (541477, 54102, '11', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (541478, 54102, '12', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (541479, 54102, '13', 'Pass Through Entity EIN', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541467, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8882CYCyovCrGrp/CYGeneralBusCrCarryforwardAmt'),
  (541468, NULL, NULL, 'Carry Back General Business Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8882CYCyovCrGrp/CarryBackGeneralBusinessCrAmt'),
  (541469, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8882CYCyovCrGrp/ESBCCarryforwardAmt'),
  (541470, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/Frm8882CYCyovCrGrp/Yr'),
  (541471, NULL, NULL, 'Non Passive Ind', 'BOOLEAN', 'ReturnData/IRS3800/Frm8882CYCyovCrGrp/NonPassiveInd'),
  (541472, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8882CYCyovCrGrp/CarryforwardGeneralBusCrAmt'),
  (541473, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm8882CYCyovCrGrp/CyovGeneralBusinessCrItemCnt'),
  (541474, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8882CYCyovCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541475, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8882CYCyovCrGrp/TotalGeneralBusCreditsAppTxAmt'),
  (541476, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8882CYCyovCrGrp/CrSubjToPassiveActyLmtAmt'),
  (541477, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8882CYCyovCrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (541478, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8882CYCyovCrGrp/PassiveActivityCrAfterLmtAmt'),
  (541479, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Frm8882CYCyovCrGrp/PassThroughEntityEIN');

-- 990T / Frm6765 ESBCY Spcfd Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54103, 54, '104', 'Frm6765 ESBCY Spcfd Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541480, 54103, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (541481, 54103, '2', 'Carry Back General Business Cr Amt', 'CURRENCY'),
  (541482, 54103, '3', 'ESBC Carryforward Amt', 'CURRENCY'),
  (541483, 54103, '4', 'Yr', 'TEXT'),
  (541484, 54103, '5', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (541485, 54103, '6', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (541486, 54103, '7', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541487, 54103, '8', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (541488, 54103, '9', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (541489, 54103, '10', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (541490, 54103, '11', 'Total General Bus Credits App Tx Amt', 'CURRENCY'),
  (541491, 54103, '12', 'Pass Through Entity EIN', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541480, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm6765ESBCYSpcfdCrGrp/CYGeneralBusCrCarryforwardAmt'),
  (541481, NULL, NULL, 'Carry Back General Business Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm6765ESBCYSpcfdCrGrp/CarryBackGeneralBusinessCrAmt'),
  (541482, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm6765ESBCYSpcfdCrGrp/ESBCCarryforwardAmt'),
  (541483, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/Frm6765ESBCYSpcfdCrGrp/Yr'),
  (541484, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm6765ESBCYSpcfdCrGrp/CyovGeneralBusinessCrItemCnt'),
  (541485, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm6765ESBCYSpcfdCrGrp/CarryforwardGeneralBusCrAmt'),
  (541486, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm6765ESBCYSpcfdCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541487, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm6765ESBCYSpcfdCrGrp/CrSubjToPassiveActyLmtAmt'),
  (541488, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm6765ESBCYSpcfdCrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (541489, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm6765ESBCYSpcfdCrGrp/PassiveActivityCrAfterLmtAmt'),
  (541490, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm6765ESBCYSpcfdCrGrp/TotalGeneralBusCreditsAppTxAmt'),
  (541491, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Frm6765ESBCYSpcfdCrGrp/PassThroughEntityEIN');

-- 990T / Total LTCGL1099 B Shows Basis Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54104, 54, '105', 'Total LTCGL1099 B Shows Basis Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541492, 54104, '1', 'Total Gain Or Loss Amt', 'CURRENCY'),
  (541493, 54104, '2', 'Total Proceeds Sales Price Amt', 'CURRENCY'),
  (541494, 54104, '3', 'Total Cost Or Other Basis Amt', 'CURRENCY'),
  (541495, 54104, '4', 'Tot Adjustments To Gain Or Loss Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541492, NULL, NULL, 'Total Gain Or Loss Amt', 'CURRENCY', 'ReturnData/IRS1120ScheduleD/TotalLTCGL1099BShowsBasisGrp/TotalGainOrLossAmt'),
  (541493, NULL, NULL, 'Total Proceeds Sales Price Amt', 'CURRENCY', 'ReturnData/IRS1120ScheduleD/TotalLTCGL1099BShowsBasisGrp/TotalProceedsSalesPriceAmt'),
  (541494, NULL, NULL, 'Total Cost Or Other Basis Amt', 'CURRENCY', 'ReturnData/IRS1120ScheduleD/TotalLTCGL1099BShowsBasisGrp/TotalCostOrOtherBasisAmt'),
  (541495, NULL, NULL, 'Tot Adjustments To Gain Or Loss Amt', 'CURRENCY', 'ReturnData/IRS1120ScheduleD/TotalLTCGL1099BShowsBasisGrp/TotAdjustmentsToGainOrLossAmt');

-- 990T / Total LTCGL1099 B Not Received Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54105, 54, '106', 'Total LTCGL1099 B Not Received Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541496, 54105, '1', 'Total Gain Or Loss Amt', 'CURRENCY'),
  (541497, 54105, '2', 'Total Proceeds Sales Price Amt', 'CURRENCY'),
  (541498, 54105, '3', 'Total Cost Or Other Basis Amt', 'CURRENCY'),
  (541499, 54105, '4', 'Tot Adjustments To Gain Or Loss Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541496, NULL, NULL, 'Total Gain Or Loss Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/TotalLTCGL1099BNotReceivedGrp/TotalGainOrLossAmt'),
  (541497, NULL, NULL, 'Total Proceeds Sales Price Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/TotalLTCGL1099BNotReceivedGrp/TotalProceedsSalesPriceAmt'),
  (541498, NULL, NULL, 'Total Cost Or Other Basis Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/TotalLTCGL1099BNotReceivedGrp/TotalCostOrOtherBasisAmt'),
  (541499, NULL, NULL, 'Tot Adjustments To Gain Or Loss Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/TotalLTCGL1099BNotReceivedGrp/TotAdjustmentsToGainOrLossAmt');

-- 990T / Nontaxable Use Of Undyed Diesel
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54106, 54, '107', 'Nontaxable Use Of Undyed Diesel');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541500, 54106, '1', 'Gallons Qty', 'TEXT'),
  (541501, 54106, '2', 'Nontaxable Use Of Fuel Type Cd', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541500, NULL, NULL, 'Gallons Qty', 'TEXT', 'ReturnData/IRS4136/NontaxableUseOfUndyedDiesel/GallonsQty'),
  (541501, NULL, NULL, 'Nontaxable Use Of Fuel Type Cd', 'TEXT', 'ReturnData/IRS4136/NontaxableUseOfUndyedDiesel/NontaxableUseOfFuelTypeCd');

-- 990T / Frm5884 BCY Cfwd Allw Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54107, 54, '108', 'Frm5884 BCY Cfwd Allw Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541502, 54107, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (541503, 54107, '2', 'ESBC Carryforward Amt', 'CURRENCY'),
  (541504, 54107, '3', 'Yr', 'TEXT'),
  (541505, 54107, '4', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (541506, 54107, '5', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541507, 54107, '6', 'Total General Bus Credits App Tx Amt', 'CURRENCY'),
  (541508, 54107, '7', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (541509, 54107, '8', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (541510, 54107, '9', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (541511, 54107, '10', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (541512, 54107, '11', 'Pass Through Entity EIN', 'TEXT'),
  (541513, 54107, '12', 'Nonpassive Ind', 'BOOLEAN'),
  (541514, 54107, '13', 'Missing EIN Reason Cd', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541502, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm5884BCYCfwdAllwCrGrp/CYGeneralBusCrCarryforwardAmt'),
  (541503, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm5884BCYCfwdAllwCrGrp/ESBCCarryforwardAmt'),
  (541504, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/Frm5884BCYCfwdAllwCrGrp/Yr'),
  (541505, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm5884BCYCfwdAllwCrGrp/CarryforwardGeneralBusCrAmt'),
  (541506, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm5884BCYCfwdAllwCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541507, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm5884BCYCfwdAllwCrGrp/TotalGeneralBusCreditsAppTxAmt'),
  (541508, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm5884BCYCfwdAllwCrGrp/CrSubjToPassiveActyLmtAmt'),
  (541509, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm5884BCYCfwdAllwCrGrp/CyovGeneralBusinessCrItemCnt'),
  (541510, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm5884BCYCfwdAllwCrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (541511, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm5884BCYCfwdAllwCrGrp/PassiveActivityCrAfterLmtAmt'),
  (541512, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Frm5884BCYCfwdAllwCrGrp/PassThroughEntityEIN'),
  (541513, NULL, NULL, 'Nonpassive Ind', 'BOOLEAN', 'ReturnData/IRS3800/Frm5884BCYCfwdAllwCrGrp/NonpassiveInd'),
  (541514, NULL, NULL, 'Missing EIN Reason Cd', 'TEXT', 'ReturnData/IRS3800/Frm5884BCYCfwdAllwCrGrp/MissingEINReasonCd');

-- 990T / IRS2439 Direct Fields
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54108, 54, '109', 'IRS2439 Direct Fields');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541515, 54108, '1', 'RIC Or REITEIN', 'TEXT'),
  (541516, 54108, '2', 'Shareholder EIN', 'TEXT'),
  (541517, 54108, '3', 'Tax Paid By RIC Or REIT Amt', 'CURRENCY'),
  (541518, 54108, '4', 'Total Undistributed LT Cap Gain Amt', 'CURRENCY'),
  (541519, 54108, '5', 'Tax Period Begin Dt', 'TEXT'),
  (541520, 54108, '6', 'Tax Period End Dt', 'TEXT'),
  (541521, 54108, '7', 'Capital Gain Sect1202 Amt', 'CURRENCY'),
  (541522, 54108, '8', 'Collectibles28 Percent Gain Amt', 'CURRENCY'),
  (541523, 54108, '9', 'Unrecaptured Section1250 Gain Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541515, NULL, NULL, 'RIC Or REITEIN', 'TEXT', 'ReturnData/IRS2439/RICOrREITEIN'),
  (541516, NULL, NULL, 'Shareholder EIN', 'TEXT', 'ReturnData/IRS2439/ShareholderEIN'),
  (541517, NULL, NULL, 'Tax Paid By RIC Or REIT Amt', 'CURRENCY', 'ReturnData/IRS2439/TaxPaidByRICOrREITAmt'),
  (541518, NULL, NULL, 'Total Undistributed LT Cap Gain Amt', 'CURRENCY', 'ReturnData/IRS2439/TotalUndistributedLTCapGainAmt'),
  (541519, NULL, NULL, 'Tax Period Begin Dt', 'TEXT', 'ReturnData/IRS2439/TaxPeriodBeginDt'),
  (541520, NULL, NULL, 'Tax Period End Dt', 'TEXT', 'ReturnData/IRS2439/TaxPeriodEndDt'),
  (541521, NULL, NULL, 'Capital Gain Sect1202 Amt', 'CURRENCY', 'ReturnData/IRS2439/CapitalGainSect1202Amt'),
  (541522, NULL, NULL, 'Collectibles28 Percent Gain Amt', 'CURRENCY', 'ReturnData/IRS2439/Collectibles28PercentGainAmt'),
  (541523, NULL, NULL, 'Unrecaptured Section1250 Gain Amt', 'CURRENCY', 'ReturnData/IRS2439/UnrecapturedSection1250GainAmt');

-- 990T / Frm5884 CY Spcfd Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54109, 54, '110', 'Frm5884 CY Spcfd Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541524, 54109, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (541525, 54109, '2', 'Carry Back General Business Cr Amt', 'CURRENCY'),
  (541526, 54109, '3', 'ESBC Carryforward Amt', 'CURRENCY'),
  (541527, 54109, '4', 'Yr', 'TEXT'),
  (541528, 54109, '5', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (541529, 54109, '6', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (541530, 54109, '7', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541531, 54109, '8', 'Pass Through Entity EIN', 'TEXT'),
  (541532, 54109, '9', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (541533, 54109, '10', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (541534, 54109, '11', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (541535, 54109, '12', 'Total General Bus Credits App Tx Amt', 'CURRENCY'),
  (541536, 54109, '13', 'Missing EIN Reason Cd', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541524, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm5884CYSpcfdCrGrp/CYGeneralBusCrCarryforwardAmt'),
  (541525, NULL, NULL, 'Carry Back General Business Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm5884CYSpcfdCrGrp/CarryBackGeneralBusinessCrAmt'),
  (541526, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm5884CYSpcfdCrGrp/ESBCCarryforwardAmt'),
  (541527, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/Frm5884CYSpcfdCrGrp/Yr'),
  (541528, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm5884CYSpcfdCrGrp/CarryforwardGeneralBusCrAmt'),
  (541529, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm5884CYSpcfdCrGrp/CyovGeneralBusinessCrItemCnt'),
  (541530, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm5884CYSpcfdCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541531, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Frm5884CYSpcfdCrGrp/PassThroughEntityEIN'),
  (541532, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm5884CYSpcfdCrGrp/CrSubjToPassiveActyLmtAmt'),
  (541533, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm5884CYSpcfdCrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (541534, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm5884CYSpcfdCrGrp/PassiveActivityCrAfterLmtAmt'),
  (541535, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm5884CYSpcfdCrGrp/TotalGeneralBusCreditsAppTxAmt'),
  (541536, NULL, NULL, 'Missing EIN Reason Cd', 'TEXT', 'ReturnData/IRS3800/Frm5884CYSpcfdCrGrp/MissingEINReasonCd');

-- 990T / Alternative Depreciation System
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54110, 54, '111', 'Alternative Depreciation System');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541537, 54110, '1', 'Depreciation Convention Cd', 'TEXT'),
  (541538, 54110, '2', 'Depreciation Deduction Amt', 'CURRENCY'),
  (541539, 54110, '3', 'Recovery Prd', 'TEXT'),
  (541540, 54110, '4', 'Basis For Depreciation Amt', 'CURRENCY'),
  (541541, 54110, '5', 'Basis For Depreciation Amt', 'CURRENCY'),
  (541542, 54110, '6', 'Depreciation Deduction Amt', 'CURRENCY'),
  (541543, 54110, '7', 'Basis For Depreciation Amt', 'CURRENCY'),
  (541544, 54110, '8', 'Depreciation Deduction Amt', 'CURRENCY'),
  (541545, 54110, '9', 'Month And Year Placed In Service Dt', 'TEXT'),
  (541546, 54110, '10', 'Basis For Depreciation Amt', 'CURRENCY'),
  (541547, 54110, '11', 'Depreciation Convention Cd', 'TEXT'),
  (541548, 54110, '12', 'Depreciation Deduction Amt', 'CURRENCY'),
  (541549, 54110, '13', 'Month And Year Placed In Service Dt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541537, NULL, NULL, 'Depreciation Convention Cd', 'TEXT', 'ReturnData/IRS4562/AlternativeDepreciationSystem/ADSClassLifeProperty/DepreciationConventionCd'),
  (541538, NULL, NULL, 'Depreciation Deduction Amt', 'CURRENCY', 'ReturnData/IRS4562/AlternativeDepreciationSystem/ADSClassLifeProperty/DepreciationDeductionAmt'),
  (541539, NULL, NULL, 'Recovery Prd', 'TEXT', 'ReturnData/IRS4562/AlternativeDepreciationSystem/ADSClassLifeProperty/RecoveryPrd'),
  (541540, NULL, NULL, 'Basis For Depreciation Amt', 'CURRENCY', 'ReturnData/IRS4562/AlternativeDepreciationSystem/ADSClassLifeProperty/BasisForDepreciationAmt'),
  (541541, NULL, NULL, 'Basis For Depreciation Amt', 'CURRENCY', 'ReturnData/IRS4562/AlternativeDepreciationSystem/ADS30YearProperty/BasisForDepreciationAmt'),
  (541542, NULL, NULL, 'Depreciation Deduction Amt', 'CURRENCY', 'ReturnData/IRS4562/AlternativeDepreciationSystem/ADS30YearProperty/DepreciationDeductionAmt'),
  (541543, NULL, NULL, 'Basis For Depreciation Amt', 'CURRENCY', 'ReturnData/IRS4562/AlternativeDepreciationSystem/ADS40YearProperty/BasisForDepreciationAmt'),
  (541544, NULL, NULL, 'Depreciation Deduction Amt', 'CURRENCY', 'ReturnData/IRS4562/AlternativeDepreciationSystem/ADS40YearProperty/DepreciationDeductionAmt'),
  (541545, NULL, NULL, 'Month And Year Placed In Service Dt', 'TEXT', 'ReturnData/IRS4562/AlternativeDepreciationSystem/ADS40YearProperty/MonthAndYearPlacedInServiceDt'),
  (541546, NULL, NULL, 'Basis For Depreciation Amt', 'CURRENCY', 'ReturnData/IRS4562/AlternativeDepreciationSystem/ADS12YearProperty/BasisForDepreciationAmt'),
  (541547, NULL, NULL, 'Depreciation Convention Cd', 'TEXT', 'ReturnData/IRS4562/AlternativeDepreciationSystem/ADS12YearProperty/DepreciationConventionCd'),
  (541548, NULL, NULL, 'Depreciation Deduction Amt', 'CURRENCY', 'ReturnData/IRS4562/AlternativeDepreciationSystem/ADS12YearProperty/DepreciationDeductionAmt'),
  (541549, NULL, NULL, 'Month And Year Placed In Service Dt', 'TEXT', 'ReturnData/IRS4562/AlternativeDepreciationSystem/ADS30YearProperty/MonthAndYearPlacedInServiceDt');

-- 990T / Total STCGL1099 B Shows Basis Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54111, 54, '112', 'Total STCGL1099 B Shows Basis Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541550, 54111, '1', 'Total Gain Or Loss Amt', 'CURRENCY'),
  (541551, 54111, '2', 'Total Proceeds Sales Price Amt', 'CURRENCY'),
  (541552, 54111, '3', 'Total Cost Or Other Basis Amt', 'CURRENCY'),
  (541553, 54111, '4', 'Tot Adjustments To Gain Or Loss Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541550, NULL, NULL, 'Total Gain Or Loss Amt', 'CURRENCY', 'ReturnData/IRS1120ScheduleD/TotalSTCGL1099BShowsBasisGrp/TotalGainOrLossAmt'),
  (541551, NULL, NULL, 'Total Proceeds Sales Price Amt', 'CURRENCY', 'ReturnData/IRS1120ScheduleD/TotalSTCGL1099BShowsBasisGrp/TotalProceedsSalesPriceAmt'),
  (541552, NULL, NULL, 'Total Cost Or Other Basis Amt', 'CURRENCY', 'ReturnData/IRS1120ScheduleD/TotalSTCGL1099BShowsBasisGrp/TotalCostOrOtherBasisAmt'),
  (541553, NULL, NULL, 'Tot Adjustments To Gain Or Loss Amt', 'CURRENCY', 'ReturnData/IRS1120ScheduleD/TotalSTCGL1099BShowsBasisGrp/TotAdjustmentsToGainOrLossAmt');

-- 990T / Frm8586 CY Spcfd Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54112, 54, '113', 'Frm8586 CY Spcfd Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541554, 54112, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (541555, 54112, '2', 'Carry Back General Business Cr Amt', 'CURRENCY'),
  (541556, 54112, '3', 'ESBC Carryforward Amt', 'CURRENCY'),
  (541557, 54112, '4', 'Yr', 'TEXT'),
  (541558, 54112, '5', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (541559, 54112, '6', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (541560, 54112, '7', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (541561, 54112, '8', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (541562, 54112, '9', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541563, 54112, '10', 'Pass Through Entity EIN', 'TEXT'),
  (541564, 54112, '11', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (541565, 54112, '12', 'Total General Bus Credits App Tx Amt', 'CURRENCY'),
  (541566, 54112, '13', 'Non Passive Ind', 'BOOLEAN');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541554, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8586CYSpcfdCrGrp/CYGeneralBusCrCarryforwardAmt'),
  (541555, NULL, NULL, 'Carry Back General Business Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8586CYSpcfdCrGrp/CarryBackGeneralBusinessCrAmt'),
  (541556, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8586CYSpcfdCrGrp/ESBCCarryforwardAmt'),
  (541557, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/Frm8586CYSpcfdCrGrp/Yr'),
  (541558, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8586CYSpcfdCrGrp/CarryforwardGeneralBusCrAmt'),
  (541559, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8586CYSpcfdCrGrp/CrSubjToPassiveActyLmtAmt'),
  (541560, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm8586CYSpcfdCrGrp/CyovGeneralBusinessCrItemCnt'),
  (541561, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8586CYSpcfdCrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (541562, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8586CYSpcfdCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541563, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Frm8586CYSpcfdCrGrp/PassThroughEntityEIN'),
  (541564, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8586CYSpcfdCrGrp/PassiveActivityCrAfterLmtAmt'),
  (541565, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8586CYSpcfdCrGrp/TotalGeneralBusCreditsAppTxAmt'),
  (541566, NULL, NULL, 'Non Passive Ind', 'BOOLEAN', 'ReturnData/IRS3800/Frm8586CYSpcfdCrGrp/NonPassiveInd');

-- 990T / Frm8844 CY Crov Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54113, 54, '114', 'Frm8844 CY Crov Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541567, 54113, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (541568, 54113, '2', 'ESBC Carryforward Amt', 'CURRENCY'),
  (541569, 54113, '3', 'Carry Back General Business Cr Amt', 'CURRENCY'),
  (541570, 54113, '4', 'Yr', 'TEXT'),
  (541571, 54113, '5', 'Pass Through Entity EIN', 'TEXT'),
  (541572, 54113, '6', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (541573, 54113, '7', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (541574, 54113, '8', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541575, 54113, '9', 'Non Passive Ind', 'BOOLEAN'),
  (541576, 54113, '10', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (541577, 54113, '11', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (541578, 54113, '12', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (541579, 54113, '13', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541567, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8844CYCrovCrGrp/CYGeneralBusCrCarryforwardAmt'),
  (541568, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8844CYCrovCrGrp/ESBCCarryforwardAmt'),
  (541569, NULL, NULL, 'Carry Back General Business Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8844CYCrovCrGrp/CarryBackGeneralBusinessCrAmt'),
  (541570, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/Frm8844CYCrovCrGrp/Yr'),
  (541571, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Frm8844CYCrovCrGrp/PassThroughEntityEIN'),
  (541572, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8844CYCrovCrGrp/CarryforwardGeneralBusCrAmt'),
  (541573, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm8844CYCrovCrGrp/CyovGeneralBusinessCrItemCnt'),
  (541574, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8844CYCrovCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541575, NULL, NULL, 'Non Passive Ind', 'BOOLEAN', 'ReturnData/IRS3800/Frm8844CYCrovCrGrp/NonPassiveInd'),
  (541576, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8844CYCrovCrGrp/CrSubjToPassiveActyLmtAmt'),
  (541577, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8844CYCrovCrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (541578, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8844CYCrovCrGrp/PassiveActivityCrAfterLmtAmt'),
  (541579, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8844CYCrovCrGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / CY Other Spcfd Credits Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54114, 54, '115', 'CY Other Spcfd Credits Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541580, 54114, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (541581, 54114, '2', 'Carry Back General Business Cr Amt', 'CURRENCY'),
  (541582, 54114, '3', 'ESBC Carryforward Amt', 'CURRENCY'),
  (541583, 54114, '4', 'Yr', 'TEXT'),
  (541584, 54114, '5', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (541585, 54114, '6', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (541586, 54114, '7', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (541587, 54114, '8', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (541588, 54114, '9', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (541589, 54114, '10', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541590, 54114, '11', 'Pass Through Entity EIN', 'TEXT'),
  (541591, 54114, '12', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541580, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/CYOtherSpcfdCreditsGrp/CYGeneralBusCrCarryforwardAmt'),
  (541581, NULL, NULL, 'Carry Back General Business Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/CYOtherSpcfdCreditsGrp/CarryBackGeneralBusinessCrAmt'),
  (541582, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/CYOtherSpcfdCreditsGrp/ESBCCarryforwardAmt'),
  (541583, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/CYOtherSpcfdCreditsGrp/Yr'),
  (541584, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/CYOtherSpcfdCreditsGrp/CarryforwardGeneralBusCrAmt'),
  (541585, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/CYOtherSpcfdCreditsGrp/CrSubjToPassiveActyLmtAmt'),
  (541586, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/CYOtherSpcfdCreditsGrp/CyovGeneralBusinessCrItemCnt'),
  (541587, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/CYOtherSpcfdCreditsGrp/PassiveActivityCrAfterLmtAmt'),
  (541588, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/CYOtherSpcfdCreditsGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (541589, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/CYOtherSpcfdCreditsGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541590, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/CYOtherSpcfdCreditsGrp/PassThroughEntityEIN'),
  (541591, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/CYOtherSpcfdCreditsGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / CY Cyov Other Bus Credits Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54115, 54, '116', 'CY Cyov Other Bus Credits Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541592, 54115, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (541593, 54115, '2', 'Carry Back General Business Cr Amt', 'CURRENCY'),
  (541594, 54115, '3', 'ESBC Carryforward Amt', 'CURRENCY'),
  (541595, 54115, '4', 'Yr', 'TEXT'),
  (541596, 54115, '5', 'Pass Through Entity EIN', 'TEXT'),
  (541597, 54115, '6', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (541598, 54115, '7', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541599, 54115, '8', 'Total General Bus Credits App Tx Amt', 'CURRENCY'),
  (541600, 54115, '9', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (541601, 54115, '10', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (541602, 54115, '11', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (541603, 54115, '12', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (541604, 54115, '13', 'Non Passive Ind', 'BOOLEAN');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541592, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCyovOtherBusCreditsGrp/CYGeneralBusCrCarryforwardAmt'),
  (541593, NULL, NULL, 'Carry Back General Business Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCyovOtherBusCreditsGrp/CarryBackGeneralBusinessCrAmt'),
  (541594, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCyovOtherBusCreditsGrp/ESBCCarryforwardAmt'),
  (541595, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/CYCyovOtherBusCreditsGrp/Yr'),
  (541596, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/CYCyovOtherBusCreditsGrp/PassThroughEntityEIN'),
  (541597, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCyovOtherBusCreditsGrp/CarryforwardGeneralBusCrAmt'),
  (541598, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCyovOtherBusCreditsGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541599, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCyovOtherBusCreditsGrp/TotalGeneralBusCreditsAppTxAmt'),
  (541600, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCyovOtherBusCreditsGrp/CrSubjToPassiveActyLmtAmt'),
  (541601, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/CYCyovOtherBusCreditsGrp/CyovGeneralBusinessCrItemCnt'),
  (541602, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCyovOtherBusCreditsGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (541603, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCyovOtherBusCreditsGrp/PassiveActivityCrAfterLmtAmt'),
  (541604, NULL, NULL, 'Non Passive Ind', 'BOOLEAN', 'ReturnData/IRS3800/CYCyovOtherBusCreditsGrp/NonPassiveInd');

-- 990T / Frm8908 CY Cyov Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54116, 54, '117', 'Frm8908 CY Cyov Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541605, 54116, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (541606, 54116, '2', 'Carry Back General Business Cr Amt', 'CURRENCY'),
  (541607, 54116, '3', 'ESBC Carryforward Amt', 'CURRENCY'),
  (541608, 54116, '4', 'Yr', 'TEXT'),
  (541609, 54116, '5', 'Pass Through Entity EIN', 'TEXT'),
  (541610, 54116, '6', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (541611, 54116, '7', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541612, 54116, '8', 'Non Passive Ind', 'BOOLEAN'),
  (541613, 54116, '9', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (541614, 54116, '10', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (541615, 54116, '11', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (541616, 54116, '12', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (541617, 54116, '13', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541605, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8908CYCyovCrGrp/CYGeneralBusCrCarryforwardAmt'),
  (541606, NULL, NULL, 'Carry Back General Business Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8908CYCyovCrGrp/CarryBackGeneralBusinessCrAmt'),
  (541607, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8908CYCyovCrGrp/ESBCCarryforwardAmt'),
  (541608, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/Frm8908CYCyovCrGrp/Yr'),
  (541609, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Frm8908CYCyovCrGrp/PassThroughEntityEIN'),
  (541610, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8908CYCyovCrGrp/CarryforwardGeneralBusCrAmt'),
  (541611, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8908CYCyovCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541612, NULL, NULL, 'Non Passive Ind', 'BOOLEAN', 'ReturnData/IRS3800/Frm8908CYCyovCrGrp/NonPassiveInd'),
  (541613, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8908CYCyovCrGrp/CrSubjToPassiveActyLmtAmt'),
  (541614, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm8908CYCyovCrGrp/CyovGeneralBusinessCrItemCnt'),
  (541615, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8908CYCyovCrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (541616, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8908CYCyovCrGrp/PassiveActivityCrAfterLmtAmt'),
  (541617, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8908CYCyovCrGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / RIC Or REITUS Address
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54117, 54, '118', 'RIC Or REITUS Address');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541618, 54117, '1', 'Address Line1 Txt', 'TEXT'),
  (541619, 54117, '2', 'City Nm', 'TEXT'),
  (541620, 54117, '3', 'State Abbreviation Cd', 'TEXT'),
  (541621, 54117, '4', 'ZIP Cd', 'TEXT'),
  (541622, 54117, '5', 'Address Line2 Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541618, NULL, NULL, 'Address Line1 Txt', 'TEXT', 'ReturnData/IRS2439/RICOrREITUSAddress/AddressLine1Txt'),
  (541619, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS2439/RICOrREITUSAddress/CityNm'),
  (541620, NULL, NULL, 'State Abbreviation Cd', 'TEXT', 'ReturnData/IRS2439/RICOrREITUSAddress/StateAbbreviationCd'),
  (541621, NULL, NULL, 'ZIP Cd', 'TEXT', 'ReturnData/IRS2439/RICOrREITUSAddress/ZIPCd'),
  (541622, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/IRS2439/RICOrREITUSAddress/AddressLine2Txt');

-- 990T / Shareholder US Address
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54118, 54, '119', 'Shareholder US Address');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541623, 54118, '1', 'Address Line1 Txt', 'TEXT'),
  (541624, 54118, '2', 'City Nm', 'TEXT'),
  (541625, 54118, '3', 'State Abbreviation Cd', 'TEXT'),
  (541626, 54118, '4', 'ZIP Cd', 'TEXT'),
  (541627, 54118, '5', 'Address Line2 Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541623, NULL, NULL, 'Address Line1 Txt', 'TEXT', 'ReturnData/IRS2439/ShareholderUSAddress/AddressLine1Txt'),
  (541624, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS2439/ShareholderUSAddress/CityNm'),
  (541625, NULL, NULL, 'State Abbreviation Cd', 'TEXT', 'ReturnData/IRS2439/ShareholderUSAddress/StateAbbreviationCd'),
  (541626, NULL, NULL, 'ZIP Cd', 'TEXT', 'ReturnData/IRS2439/ShareholderUSAddress/ZIPCd'),
  (541627, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/IRS2439/ShareholderUSAddress/AddressLine2Txt');

-- 990T / Frm3468 Part VICY Spcfd Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54119, 54, '120', 'Frm3468 Part VICY Spcfd Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541628, 54119, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (541629, 54119, '2', 'Carry Back General Business Cr Amt', 'CURRENCY'),
  (541630, 54119, '3', 'ESBC Carryforward Amt', 'CURRENCY'),
  (541631, 54119, '4', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (541632, 54119, '5', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (541633, 54119, '6', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (541634, 54119, '7', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541635, 54119, '8', 'Total General Bus Credits App Tx Amt', 'CURRENCY'),
  (541636, 54119, '9', 'Yr', 'TEXT'),
  (541637, 54119, '10', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (541638, 54119, '11', 'Pass Through Entity EIN', 'TEXT'),
  (541639, 54119, '12', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (541640, 54119, '13', 'Missing EIN Reason Cd', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541628, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm3468PartVICYSpcfdCrGrp/CYGeneralBusCrCarryforwardAmt'),
  (541629, NULL, NULL, 'Carry Back General Business Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm3468PartVICYSpcfdCrGrp/CarryBackGeneralBusinessCrAmt'),
  (541630, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm3468PartVICYSpcfdCrGrp/ESBCCarryforwardAmt'),
  (541631, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm3468PartVICYSpcfdCrGrp/CrSubjToPassiveActyLmtAmt'),
  (541632, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm3468PartVICYSpcfdCrGrp/CarryforwardGeneralBusCrAmt'),
  (541633, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm3468PartVICYSpcfdCrGrp/CyovGeneralBusinessCrItemCnt'),
  (541634, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm3468PartVICYSpcfdCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541635, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm3468PartVICYSpcfdCrGrp/TotalGeneralBusCreditsAppTxAmt'),
  (541636, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/Frm3468PartVICYSpcfdCrGrp/Yr'),
  (541637, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm3468PartVICYSpcfdCrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (541638, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Frm3468PartVICYSpcfdCrGrp/PassThroughEntityEIN'),
  (541639, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm3468PartVICYSpcfdCrGrp/PassiveActivityCrAfterLmtAmt'),
  (541640, NULL, NULL, 'Missing EIN Reason Cd', 'TEXT', 'ReturnData/IRS3800/Frm3468PartVICYSpcfdCrGrp/MissingEINReasonCd');

-- 990T / Other Nontaxable Use Of Gasoline
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54120, 54, '121', 'Other Nontaxable Use Of Gasoline');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541641, 54120, '1', 'Gallons Qty', 'TEXT'),
  (541642, 54120, '2', 'Nontaxable Use Of Fuel Type Cd', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541641, NULL, NULL, 'Gallons Qty', 'TEXT', 'ReturnData/IRS4136/OtherNontaxableUseOfGasoline/GallonsQty'),
  (541642, NULL, NULL, 'Nontaxable Use Of Fuel Type Cd', 'TEXT', 'ReturnData/IRS4136/OtherNontaxableUseOfGasoline/NontaxableUseOfFuelTypeCd');

-- 990T / Total STCGL1099 B Not Show Basis Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54121, 54, '122', 'Total STCGL1099 B Not Show Basis Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541643, 54121, '1', 'Total Gain Or Loss Amt', 'CURRENCY'),
  (541644, 54121, '2', 'Total Proceeds Sales Price Amt', 'CURRENCY'),
  (541645, 54121, '3', 'Total Cost Or Other Basis Amt', 'CURRENCY'),
  (541646, 54121, '4', 'Tot Adjustments To Gain Or Loss Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541643, NULL, NULL, 'Total Gain Or Loss Amt', 'CURRENCY', 'ReturnData/IRS1120ScheduleD/TotalSTCGL1099BNotShowBasisGrp/TotalGainOrLossAmt'),
  (541644, NULL, NULL, 'Total Proceeds Sales Price Amt', 'CURRENCY', 'ReturnData/IRS1120ScheduleD/TotalSTCGL1099BNotShowBasisGrp/TotalProceedsSalesPriceAmt'),
  (541645, NULL, NULL, 'Total Cost Or Other Basis Amt', 'CURRENCY', 'ReturnData/IRS1120ScheduleD/TotalSTCGL1099BNotShowBasisGrp/TotalCostOrOtherBasisAmt'),
  (541646, NULL, NULL, 'Tot Adjustments To Gain Or Loss Amt', 'CURRENCY', 'ReturnData/IRS1120ScheduleD/TotalSTCGL1099BNotShowBasisGrp/TotAdjustmentsToGainOrLossAmt');

-- 990T / Frm8910 CY Cyov Cr Aggrgt Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54122, 54, '123', 'Frm8910 CY Cyov Cr Aggrgt Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541647, 54122, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (541648, 54122, '2', 'Yr', 'TEXT'),
  (541649, 54122, '3', 'Pass Through Entity EIN', 'TEXT'),
  (541650, 54122, '4', 'Nonpassive Ind', 'BOOLEAN'),
  (541651, 54122, '5', 'ESBC Carryforward Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541647, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8910CYCyovCrAggrgtGrp/CYGeneralBusCrCarryforwardAmt'),
  (541648, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/Frm8910CYCyovCrAggrgtGrp/Yr'),
  (541649, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Frm8910CYCyovCrAggrgtGrp/PassThroughEntityEIN'),
  (541650, NULL, NULL, 'Nonpassive Ind', 'BOOLEAN', 'ReturnData/IRS3800/Frm8910CYCyovCrAggrgtGrp/NonpassiveInd'),
  (541651, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8910CYCyovCrAggrgtGrp/ESBCCarryforwardAmt');

-- 990T / Frm5884 ACY Cfwd Allw Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54123, 54, '124', 'Frm5884 ACY Cfwd Allw Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541652, 54123, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (541653, 54123, '2', 'ESBC Carryforward Amt', 'CURRENCY'),
  (541654, 54123, '3', 'Yr', 'TEXT'),
  (541655, 54123, '4', 'Nonpassive Ind', 'BOOLEAN'),
  (541656, 54123, '5', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (541657, 54123, '6', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541658, 54123, '7', 'Pass Through Entity EIN', 'TEXT'),
  (541659, 54123, '8', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (541660, 54123, '9', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (541661, 54123, '10', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (541662, 54123, '11', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (541663, 54123, '12', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541652, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm5884ACYCfwdAllwCrGrp/CYGeneralBusCrCarryforwardAmt'),
  (541653, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm5884ACYCfwdAllwCrGrp/ESBCCarryforwardAmt'),
  (541654, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/Frm5884ACYCfwdAllwCrGrp/Yr'),
  (541655, NULL, NULL, 'Nonpassive Ind', 'BOOLEAN', 'ReturnData/IRS3800/Frm5884ACYCfwdAllwCrGrp/NonpassiveInd'),
  (541656, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm5884ACYCfwdAllwCrGrp/CarryforwardGeneralBusCrAmt'),
  (541657, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm5884ACYCfwdAllwCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541658, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Frm5884ACYCfwdAllwCrGrp/PassThroughEntityEIN'),
  (541659, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm5884ACYCfwdAllwCrGrp/CrSubjToPassiveActyLmtAmt'),
  (541660, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm5884ACYCfwdAllwCrGrp/CyovGeneralBusinessCrItemCnt'),
  (541661, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm5884ACYCfwdAllwCrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (541662, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm5884ACYCfwdAllwCrGrp/PassiveActivityCrAfterLmtAmt'),
  (541663, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm5884ACYCfwdAllwCrGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / Total LTCGL1099 B Not Show Basis Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54124, 54, '125', 'Total LTCGL1099 B Not Show Basis Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541664, 54124, '1', 'Total Gain Or Loss Amt', 'CURRENCY'),
  (541665, 54124, '2', 'Total Proceeds Sales Price Amt', 'CURRENCY'),
  (541666, 54124, '3', 'Total Cost Or Other Basis Amt', 'CURRENCY'),
  (541667, 54124, '4', 'Tot Adjustments To Gain Or Loss Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541664, NULL, NULL, 'Total Gain Or Loss Amt', 'CURRENCY', 'ReturnData/IRS1120ScheduleD/TotalLTCGL1099BNotShowBasisGrp/TotalGainOrLossAmt'),
  (541665, NULL, NULL, 'Total Proceeds Sales Price Amt', 'CURRENCY', 'ReturnData/IRS1120ScheduleD/TotalLTCGL1099BNotShowBasisGrp/TotalProceedsSalesPriceAmt'),
  (541666, NULL, NULL, 'Total Cost Or Other Basis Amt', 'CURRENCY', 'ReturnData/IRS1120ScheduleD/TotalLTCGL1099BNotShowBasisGrp/TotalCostOrOtherBasisAmt'),
  (541667, NULL, NULL, 'Tot Adjustments To Gain Or Loss Amt', 'CURRENCY', 'ReturnData/IRS1120ScheduleD/TotalLTCGL1099BNotShowBasisGrp/TotAdjustmentsToGainOrLossAmt');

-- 990T / Frm8835 Part IICY Cyov Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54125, 54, '126', 'Frm8835 Part IICY Cyov Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541668, 54125, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (541669, 54125, '2', 'Carry Back General Business Cr Amt', 'CURRENCY'),
  (541670, 54125, '3', 'Yr', 'TEXT'),
  (541671, 54125, '4', 'Nonpassive Ind', 'BOOLEAN'),
  (541672, 54125, '5', 'Pass Through Entity EIN', 'TEXT'),
  (541673, 54125, '6', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (541674, 54125, '7', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541675, 54125, '8', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (541676, 54125, '9', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (541677, 54125, '10', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (541678, 54125, '11', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (541679, 54125, '12', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541668, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8835PartIICYCyovCrGrp/CYGeneralBusCrCarryforwardAmt'),
  (541669, NULL, NULL, 'Carry Back General Business Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8835PartIICYCyovCrGrp/CarryBackGeneralBusinessCrAmt'),
  (541670, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/Frm8835PartIICYCyovCrGrp/Yr'),
  (541671, NULL, NULL, 'Nonpassive Ind', 'BOOLEAN', 'ReturnData/IRS3800/Frm8835PartIICYCyovCrGrp/NonpassiveInd'),
  (541672, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Frm8835PartIICYCyovCrGrp/PassThroughEntityEIN'),
  (541673, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8835PartIICYCyovCrGrp/CarryforwardGeneralBusCrAmt'),
  (541674, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8835PartIICYCyovCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541675, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8835PartIICYCyovCrGrp/CrSubjToPassiveActyLmtAmt'),
  (541676, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm8835PartIICYCyovCrGrp/CyovGeneralBusinessCrItemCnt'),
  (541677, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8835PartIICYCyovCrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (541678, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8835PartIICYCyovCrGrp/PassiveActivityCrAfterLmtAmt'),
  (541679, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8835PartIICYCyovCrGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / Frm8835 CY Spcfd Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54126, 54, '127', 'Frm8835 CY Spcfd Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541680, 54126, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (541681, 54126, '2', 'Carry Back General Business Cr Amt', 'CURRENCY'),
  (541682, 54126, '3', 'ESBC Carryforward Amt', 'CURRENCY'),
  (541683, 54126, '4', 'Yr', 'TEXT'),
  (541684, 54126, '5', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (541685, 54126, '6', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (541686, 54126, '7', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (541687, 54126, '8', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (541688, 54126, '9', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541689, 54126, '10', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (541690, 54126, '11', 'Total General Bus Credits App Tx Amt', 'CURRENCY'),
  (541691, 54126, '12', 'Pass Through Entity EIN', 'TEXT'),
  (541692, 54126, '13', 'Non Passive Ind', 'BOOLEAN');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541680, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8835CYSpcfdCrGrp/CYGeneralBusCrCarryforwardAmt'),
  (541681, NULL, NULL, 'Carry Back General Business Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8835CYSpcfdCrGrp/CarryBackGeneralBusinessCrAmt'),
  (541682, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8835CYSpcfdCrGrp/ESBCCarryforwardAmt'),
  (541683, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/Frm8835CYSpcfdCrGrp/Yr'),
  (541684, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8835CYSpcfdCrGrp/CarryforwardGeneralBusCrAmt'),
  (541685, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8835CYSpcfdCrGrp/CrSubjToPassiveActyLmtAmt'),
  (541686, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm8835CYSpcfdCrGrp/CyovGeneralBusinessCrItemCnt'),
  (541687, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8835CYSpcfdCrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (541688, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8835CYSpcfdCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541689, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8835CYSpcfdCrGrp/PassiveActivityCrAfterLmtAmt'),
  (541690, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8835CYSpcfdCrGrp/TotalGeneralBusCreditsAppTxAmt'),
  (541691, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Frm8835CYSpcfdCrGrp/PassThroughEntityEIN'),
  (541692, NULL, NULL, 'Non Passive Ind', 'BOOLEAN', 'ReturnData/IRS3800/Frm8835CYSpcfdCrGrp/NonPassiveInd');

-- 990T / Rent Income Property Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54127, 54, '128', 'Rent Income Property Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541693, 54127, '1', 'Address Line2 Txt', 'TEXT'),
  (541694, 54127, '2', 'Address Line1 Txt', 'TEXT'),
  (541695, 54127, '3', 'Country Cd', 'TEXT'),
  (541696, 54127, '4', 'City Nm', 'TEXT'),
  (541697, 54127, '5', 'Foreign Postal Cd', 'TEXT'),
  (541698, 54127, '6', 'Province Or State Nm', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541693, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/IRS990TScheduleA/RentIncomePropertyGrp/USAddress/AddressLine2Txt'),
  (541694, NULL, NULL, 'Address Line1 Txt', 'TEXT', 'ReturnData/IRS990TScheduleA/RentIncomePropertyGrp/ForeignAddress/AddressLine1Txt'),
  (541695, NULL, NULL, 'Country Cd', 'TEXT', 'ReturnData/IRS990TScheduleA/RentIncomePropertyGrp/ForeignAddress/CountryCd'),
  (541696, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990TScheduleA/RentIncomePropertyGrp/ForeignAddress/CityNm'),
  (541697, NULL, NULL, 'Foreign Postal Cd', 'TEXT', 'ReturnData/IRS990TScheduleA/RentIncomePropertyGrp/ForeignAddress/ForeignPostalCd'),
  (541698, NULL, NULL, 'Province Or State Nm', 'TEXT', 'ReturnData/IRS990TScheduleA/RentIncomePropertyGrp/ForeignAddress/ProvinceOrStateNm');

-- 990T / Frm8830 CY Cyov Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54128, 54, '129', 'Frm8830 CY Cyov Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541699, 54128, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (541700, 54128, '2', 'Carry Back General Business Cr Amt', 'CURRENCY'),
  (541701, 54128, '3', 'ESBC Carryforward Amt', 'CURRENCY'),
  (541702, 54128, '4', 'Yr', 'TEXT'),
  (541703, 54128, '5', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541704, 54128, '6', 'Non Passive Ind', 'BOOLEAN'),
  (541705, 54128, '7', 'Pass Through Entity EIN', 'TEXT'),
  (541706, 54128, '8', 'Total General Bus Credits App Tx Amt', 'CURRENCY'),
  (541707, 54128, '9', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (541708, 54128, '10', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (541709, 54128, '11', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (541710, 54128, '12', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (541711, 54128, '13', 'Passive Activity Cr After Lmt Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541699, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8830CYCyovCrGrp/CYGeneralBusCrCarryforwardAmt'),
  (541700, NULL, NULL, 'Carry Back General Business Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8830CYCyovCrGrp/CarryBackGeneralBusinessCrAmt'),
  (541701, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8830CYCyovCrGrp/ESBCCarryforwardAmt'),
  (541702, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/Frm8830CYCyovCrGrp/Yr'),
  (541703, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8830CYCyovCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541704, NULL, NULL, 'Non Passive Ind', 'BOOLEAN', 'ReturnData/IRS3800/Frm8830CYCyovCrGrp/NonPassiveInd'),
  (541705, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Frm8830CYCyovCrGrp/PassThroughEntityEIN'),
  (541706, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8830CYCyovCrGrp/TotalGeneralBusCreditsAppTxAmt'),
  (541707, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8830CYCyovCrGrp/CarryforwardGeneralBusCrAmt'),
  (541708, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8830CYCyovCrGrp/CrSubjToPassiveActyLmtAmt'),
  (541709, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm8830CYCyovCrGrp/CyovGeneralBusinessCrItemCnt'),
  (541710, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8830CYCyovCrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (541711, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8830CYCyovCrGrp/PassiveActivityCrAfterLmtAmt');

-- 990T / Frm8994 CY Spcfd Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54129, 54, '130', 'Frm8994 CY Spcfd Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541712, 54129, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (541713, 54129, '2', 'Carry Back General Business Cr Amt', 'CURRENCY'),
  (541714, 54129, '3', 'ESBC Carryforward Amt', 'CURRENCY'),
  (541715, 54129, '4', 'Yr', 'TEXT'),
  (541716, 54129, '5', 'Non Passive Ind', 'BOOLEAN'),
  (541717, 54129, '6', 'Pass Through Entity EIN', 'TEXT'),
  (541718, 54129, '7', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (541719, 54129, '8', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (541720, 54129, '9', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (541721, 54129, '10', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (541722, 54129, '11', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541723, 54129, '12', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (541724, 54129, '13', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541712, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8994CYSpcfdCrGrp/CYGeneralBusCrCarryforwardAmt'),
  (541713, NULL, NULL, 'Carry Back General Business Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8994CYSpcfdCrGrp/CarryBackGeneralBusinessCrAmt'),
  (541714, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8994CYSpcfdCrGrp/ESBCCarryforwardAmt'),
  (541715, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/Frm8994CYSpcfdCrGrp/Yr'),
  (541716, NULL, NULL, 'Non Passive Ind', 'BOOLEAN', 'ReturnData/IRS3800/Frm8994CYSpcfdCrGrp/NonPassiveInd'),
  (541717, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Frm8994CYSpcfdCrGrp/PassThroughEntityEIN'),
  (541718, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8994CYSpcfdCrGrp/CarryforwardGeneralBusCrAmt'),
  (541719, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8994CYSpcfdCrGrp/CrSubjToPassiveActyLmtAmt'),
  (541720, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm8994CYSpcfdCrGrp/CyovGeneralBusinessCrItemCnt'),
  (541721, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8994CYSpcfdCrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (541722, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8994CYSpcfdCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541723, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8994CYSpcfdCrGrp/PassiveActivityCrAfterLmtAmt'),
  (541724, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8994CYSpcfdCrGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / Total STCGL1099 B Not Received Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54130, 54, '131', 'Total STCGL1099 B Not Received Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541725, 54130, '1', 'Total Gain Or Loss Amt', 'CURRENCY'),
  (541726, 54130, '2', 'Total Proceeds Sales Price Amt', 'CURRENCY'),
  (541727, 54130, '3', 'Total Cost Or Other Basis Amt', 'CURRENCY'),
  (541728, 54130, '4', 'Tot Adjustments To Gain Or Loss Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541725, NULL, NULL, 'Total Gain Or Loss Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/TotalSTCGL1099BNotReceivedGrp/TotalGainOrLossAmt'),
  (541726, NULL, NULL, 'Total Proceeds Sales Price Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/TotalSTCGL1099BNotReceivedGrp/TotalProceedsSalesPriceAmt'),
  (541727, NULL, NULL, 'Total Cost Or Other Basis Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/TotalSTCGL1099BNotReceivedGrp/TotalCostOrOtherBasisAmt'),
  (541728, NULL, NULL, 'Tot Adjustments To Gain Or Loss Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/TotalSTCGL1099BNotReceivedGrp/TotAdjustmentsToGainOrLossAmt');

-- 990T / CY Cfwd Allw Other Bus Credits Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54131, 54, '132', 'CY Cfwd Allw Other Bus Credits Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541729, 54131, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (541730, 54131, '2', 'ESBC Carryforward Amt', 'CURRENCY'),
  (541731, 54131, '3', 'Yr', 'TEXT'),
  (541732, 54131, '4', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541733, 54131, '5', 'Nonpassive Ind', 'BOOLEAN'),
  (541734, 54131, '6', 'Total General Bus Credits App Tx Amt', 'CURRENCY'),
  (541735, 54131, '7', 'Pass Through Entity EIN', 'TEXT'),
  (541736, 54131, '8', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (541737, 54131, '9', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (541738, 54131, '10', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (541739, 54131, '11', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (541740, 54131, '12', 'Passive Activity Cr After Lmt Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541729, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCfwdAllwOtherBusCreditsGrp/CYGeneralBusCrCarryforwardAmt'),
  (541730, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCfwdAllwOtherBusCreditsGrp/ESBCCarryforwardAmt'),
  (541731, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/CYCfwdAllwOtherBusCreditsGrp/Yr'),
  (541732, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCfwdAllwOtherBusCreditsGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541733, NULL, NULL, 'Nonpassive Ind', 'BOOLEAN', 'ReturnData/IRS3800/CYCfwdAllwOtherBusCreditsGrp/NonpassiveInd'),
  (541734, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCfwdAllwOtherBusCreditsGrp/TotalGeneralBusCreditsAppTxAmt'),
  (541735, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/CYCfwdAllwOtherBusCreditsGrp/PassThroughEntityEIN'),
  (541736, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCfwdAllwOtherBusCreditsGrp/CarryforwardGeneralBusCrAmt'),
  (541737, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/CYCfwdAllwOtherBusCreditsGrp/CyovGeneralBusinessCrItemCnt'),
  (541738, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCfwdAllwOtherBusCreditsGrp/CrSubjToPassiveActyLmtAmt'),
  (541739, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCfwdAllwOtherBusCreditsGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (541740, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCfwdAllwOtherBusCreditsGrp/PassiveActivityCrAfterLmtAmt');

-- 990T / IRS8827 Direct Fields
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54132, 54, '133', 'IRS8827 Direct Fields');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541741, 54132, '1', 'Prior Year Minimum Tax Credit Amt', 'CURRENCY'),
  (541742, 54132, '2', 'Minimum Tax Credit Carryfoward Amt', 'CURRENCY'),
  (541743, 54132, '3', 'Current Year Minimum Tax Credit Amt', 'CURRENCY'),
  (541744, 54132, '4', 'CY Reg Tax Liabi Minus Allwbl Cr Amt', 'CURRENCY'),
  (541745, 54132, '5', 'PY Corp Alternative Minimum Tax Amt', 'CURRENCY'),
  (541746, 54132, '6', 'Tentative Minimum Tax Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541741, NULL, NULL, 'Prior Year Minimum Tax Credit Amt', 'CURRENCY', 'ReturnData/IRS8827/PriorYearMinimumTaxCreditAmt'),
  (541742, NULL, NULL, 'Minimum Tax Credit Carryfoward Amt', 'CURRENCY', 'ReturnData/IRS8827/MinimumTaxCreditCarryfowardAmt'),
  (541743, NULL, NULL, 'Current Year Minimum Tax Credit Amt', 'CURRENCY', 'ReturnData/IRS8827/CurrentYearMinimumTaxCreditAmt'),
  (541744, NULL, NULL, 'CY Reg Tax Liabi Minus Allwbl Cr Amt', 'CURRENCY', 'ReturnData/IRS8827/CYRegTaxLiabiMinusAllwblCrAmt'),
  (541745, NULL, NULL, 'PY Corp Alternative Minimum Tax Amt', 'CURRENCY', 'ReturnData/IRS8827/PYCorpAlternativeMinimumTaxAmt'),
  (541746, NULL, NULL, 'Tentative Minimum Tax Amt', 'CURRENCY', 'ReturnData/IRS8827/TentativeMinimumTaxAmt');

-- 990T / Frm8846 CY Cfwd Allw Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54133, 54, '134', 'Frm8846 CY Cfwd Allw Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541747, 54133, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (541748, 54133, '2', 'ESBC Carryforward Amt', 'CURRENCY'),
  (541749, 54133, '3', 'Yr', 'TEXT'),
  (541750, 54133, '4', 'Pass Through Entity EIN', 'TEXT'),
  (541751, 54133, '5', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (541752, 54133, '6', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541753, 54133, '7', 'Total General Bus Credits App Tx Amt', 'CURRENCY'),
  (541754, 54133, '8', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (541755, 54133, '9', 'Nonpassive Ind', 'BOOLEAN'),
  (541756, 54133, '10', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (541757, 54133, '11', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (541758, 54133, '12', 'Passive Activity Cr After Lmt Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541747, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8846CYCfwdAllwCrGrp/CYGeneralBusCrCarryforwardAmt'),
  (541748, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8846CYCfwdAllwCrGrp/ESBCCarryforwardAmt'),
  (541749, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/Frm8846CYCfwdAllwCrGrp/Yr'),
  (541750, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Frm8846CYCfwdAllwCrGrp/PassThroughEntityEIN'),
  (541751, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm8846CYCfwdAllwCrGrp/CyovGeneralBusinessCrItemCnt'),
  (541752, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8846CYCfwdAllwCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541753, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8846CYCfwdAllwCrGrp/TotalGeneralBusCreditsAppTxAmt'),
  (541754, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8846CYCfwdAllwCrGrp/CarryforwardGeneralBusCrAmt'),
  (541755, NULL, NULL, 'Nonpassive Ind', 'BOOLEAN', 'ReturnData/IRS3800/Frm8846CYCfwdAllwCrGrp/NonpassiveInd'),
  (541756, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8846CYCfwdAllwCrGrp/CrSubjToPassiveActyLmtAmt'),
  (541757, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8846CYCfwdAllwCrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (541758, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8846CYCfwdAllwCrGrp/PassiveActivityCrAfterLmtAmt');

-- 990T / Frm6478 CY Spcfd Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54134, 54, '135', 'Frm6478 CY Spcfd Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541759, 54134, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (541760, 54134, '2', 'Carry Back General Business Cr Amt', 'CURRENCY'),
  (541761, 54134, '3', 'ESBC Carryforward Amt', 'CURRENCY'),
  (541762, 54134, '4', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (541763, 54134, '5', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541764, 54134, '6', 'Pass Through Entity EIN', 'TEXT'),
  (541765, 54134, '7', 'Yr', 'TEXT'),
  (541766, 54134, '8', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (541767, 54134, '9', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (541768, 54134, '10', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (541769, 54134, '11', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (541770, 54134, '12', 'Total General Bus Credits App Tx Amt', 'CURRENCY'),
  (541771, 54134, '13', 'Non Passive Ind', 'BOOLEAN');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541759, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm6478CYSpcfdCrGrp/CYGeneralBusCrCarryforwardAmt'),
  (541760, NULL, NULL, 'Carry Back General Business Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm6478CYSpcfdCrGrp/CarryBackGeneralBusinessCrAmt'),
  (541761, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm6478CYSpcfdCrGrp/ESBCCarryforwardAmt'),
  (541762, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm6478CYSpcfdCrGrp/CarryforwardGeneralBusCrAmt'),
  (541763, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm6478CYSpcfdCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541764, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Frm6478CYSpcfdCrGrp/PassThroughEntityEIN'),
  (541765, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/Frm6478CYSpcfdCrGrp/Yr'),
  (541766, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm6478CYSpcfdCrGrp/CrSubjToPassiveActyLmtAmt'),
  (541767, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm6478CYSpcfdCrGrp/CyovGeneralBusinessCrItemCnt'),
  (541768, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm6478CYSpcfdCrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (541769, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm6478CYSpcfdCrGrp/PassiveActivityCrAfterLmtAmt'),
  (541770, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm6478CYSpcfdCrGrp/TotalGeneralBusCreditsAppTxAmt'),
  (541771, NULL, NULL, 'Non Passive Ind', 'BOOLEAN', 'ReturnData/IRS3800/Frm6478CYSpcfdCrGrp/NonPassiveInd');

-- 990T / Total LTCGL1099 B Bss Rpt No Adj Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54135, 54, '136', 'Total LTCGL1099 B Bss Rpt No Adj Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541772, 54135, '1', 'Total Proceeds Sales Price Amt', 'CURRENCY'),
  (541773, 54135, '2', 'Total Gain Or Loss Amt', 'CURRENCY'),
  (541774, 54135, '3', 'Total Cost Or Other Basis Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541772, NULL, NULL, 'Total Proceeds Sales Price Amt', 'CURRENCY', 'ReturnData/IRS1120ScheduleD/TotalLTCGL1099BBssRptNoAdjGrp/TotalProceedsSalesPriceAmt'),
  (541773, NULL, NULL, 'Total Gain Or Loss Amt', 'CURRENCY', 'ReturnData/IRS1120ScheduleD/TotalLTCGL1099BBssRptNoAdjGrp/TotalGainOrLossAmt'),
  (541774, NULL, NULL, 'Total Cost Or Other Basis Amt', 'CURRENCY', 'ReturnData/IRS1120ScheduleD/TotalLTCGL1099BBssRptNoAdjGrp/TotalCostOrOtherBasisAmt');

-- 990T / Total LTCGL1099 B Shows Basis Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54136, 54, '137', 'Total LTCGL1099 B Shows Basis Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541775, 54136, '1', 'Total Gain Or Loss Amt', 'CURRENCY'),
  (541776, 54136, '2', 'Total Proceeds Sales Price Amt', 'CURRENCY'),
  (541777, 54136, '3', 'Total Cost Or Other Basis Amt', 'CURRENCY'),
  (541778, 54136, '4', 'Tot Adjustments To Gain Or Loss Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541775, NULL, NULL, 'Total Gain Or Loss Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/TotalLTCGL1099BShowsBasisGrp/TotalGainOrLossAmt'),
  (541776, NULL, NULL, 'Total Proceeds Sales Price Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/TotalLTCGL1099BShowsBasisGrp/TotalProceedsSalesPriceAmt'),
  (541777, NULL, NULL, 'Total Cost Or Other Basis Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/TotalLTCGL1099BShowsBasisGrp/TotalCostOrOtherBasisAmt'),
  (541778, NULL, NULL, 'Tot Adjustments To Gain Or Loss Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/TotalLTCGL1099BShowsBasisGrp/TotAdjustmentsToGainOrLossAmt');

-- 990T / Frm8864 Biodiesel CY Credits Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54137, 54, '138', 'Frm8864 Biodiesel CY Credits Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541779, 54137, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (541780, 54137, '2', 'Carry Back General Business Cr Amt', 'CURRENCY'),
  (541781, 54137, '3', 'ESBC Carryforward Amt', 'CURRENCY'),
  (541782, 54137, '4', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (541783, 54137, '5', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (541784, 54137, '6', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (541785, 54137, '7', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (541786, 54137, '8', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541787, 54137, '9', 'Non Passive Ind', 'BOOLEAN'),
  (541788, 54137, '10', 'Pass Through Entity EIN', 'TEXT'),
  (541789, 54137, '11', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (541790, 54137, '12', 'Total General Bus Credits App Tx Amt', 'CURRENCY'),
  (541791, 54137, '13', 'Yr', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541779, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8864BiodieselCYCreditsGrp/CYGeneralBusCrCarryforwardAmt'),
  (541780, NULL, NULL, 'Carry Back General Business Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8864BiodieselCYCreditsGrp/CarryBackGeneralBusinessCrAmt'),
  (541781, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8864BiodieselCYCreditsGrp/ESBCCarryforwardAmt'),
  (541782, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8864BiodieselCYCreditsGrp/CarryforwardGeneralBusCrAmt'),
  (541783, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8864BiodieselCYCreditsGrp/CrSubjToPassiveActyLmtAmt'),
  (541784, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm8864BiodieselCYCreditsGrp/CyovGeneralBusinessCrItemCnt'),
  (541785, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8864BiodieselCYCreditsGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (541786, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8864BiodieselCYCreditsGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541787, NULL, NULL, 'Non Passive Ind', 'BOOLEAN', 'ReturnData/IRS3800/Frm8864BiodieselCYCreditsGrp/NonPassiveInd'),
  (541788, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Frm8864BiodieselCYCreditsGrp/PassThroughEntityEIN'),
  (541789, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8864BiodieselCYCreditsGrp/PassiveActivityCrAfterLmtAmt'),
  (541790, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8864BiodieselCYCreditsGrp/TotalGeneralBusCreditsAppTxAmt'),
  (541791, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/Frm8864BiodieselCYCreditsGrp/Yr');

-- 990T / Frm3468 Part VIICY Spcfd Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54138, 54, '139', 'Frm3468 Part VIICY Spcfd Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541792, 54138, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (541793, 54138, '2', 'Carry Back General Business Cr Amt', 'CURRENCY'),
  (541794, 54138, '3', 'ESBC Carryforward Amt', 'CURRENCY'),
  (541795, 54138, '4', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541796, 54138, '5', 'Pass Through Entity EIN', 'TEXT'),
  (541797, 54138, '6', 'Yr', 'TEXT'),
  (541798, 54138, '7', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (541799, 54138, '8', 'Total General Bus Credits App Tx Amt', 'CURRENCY'),
  (541800, 54138, '9', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (541801, 54138, '10', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (541802, 54138, '11', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (541803, 54138, '12', 'Passive Activity Cr After Lmt Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541792, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm3468PartVIICYSpcfdCrGrp/CYGeneralBusCrCarryforwardAmt'),
  (541793, NULL, NULL, 'Carry Back General Business Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm3468PartVIICYSpcfdCrGrp/CarryBackGeneralBusinessCrAmt'),
  (541794, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm3468PartVIICYSpcfdCrGrp/ESBCCarryforwardAmt'),
  (541795, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm3468PartVIICYSpcfdCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541796, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Frm3468PartVIICYSpcfdCrGrp/PassThroughEntityEIN'),
  (541797, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/Frm3468PartVIICYSpcfdCrGrp/Yr'),
  (541798, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm3468PartVIICYSpcfdCrGrp/CarryforwardGeneralBusCrAmt'),
  (541799, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm3468PartVIICYSpcfdCrGrp/TotalGeneralBusCreditsAppTxAmt'),
  (541800, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm3468PartVIICYSpcfdCrGrp/CrSubjToPassiveActyLmtAmt'),
  (541801, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm3468PartVIICYSpcfdCrGrp/CyovGeneralBusinessCrItemCnt'),
  (541802, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm3468PartVIICYSpcfdCrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (541803, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm3468PartVIICYSpcfdCrGrp/PassiveActivityCrAfterLmtAmt');

-- 990T / Frm8882 CY Cyov Cr Aggrgt Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54139, 54, '140', 'Frm8882 CY Cyov Cr Aggrgt Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541804, 54139, '1', 'Yr', 'TEXT'),
  (541805, 54139, '2', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (541806, 54139, '3', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (541807, 54139, '4', 'Nonpassive Ind', 'BOOLEAN'),
  (541808, 54139, '5', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541809, 54139, '6', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (541810, 54139, '7', 'Pass Through Entity EIN', 'TEXT'),
  (541811, 54139, '8', 'Total General Bus Credits App Tx Amt', 'CURRENCY'),
  (541812, 54139, '9', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (541813, 54139, '10', 'Passive Activity Cr After Lmt Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541804, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/Frm8882CYCyovCrAggrgtGrp/Yr'),
  (541805, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8882CYCyovCrAggrgtGrp/CYGeneralBusCrCarryforwardAmt'),
  (541806, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8882CYCyovCrAggrgtGrp/CarryforwardGeneralBusCrAmt'),
  (541807, NULL, NULL, 'Nonpassive Ind', 'BOOLEAN', 'ReturnData/IRS3800/Frm8882CYCyovCrAggrgtGrp/NonpassiveInd'),
  (541808, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8882CYCyovCrAggrgtGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541809, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8882CYCyovCrAggrgtGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (541810, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Frm8882CYCyovCrAggrgtGrp/PassThroughEntityEIN'),
  (541811, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8882CYCyovCrAggrgtGrp/TotalGeneralBusCreditsAppTxAmt'),
  (541812, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8882CYCyovCrAggrgtGrp/CrSubjToPassiveActyLmtAmt'),
  (541813, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8882CYCyovCrAggrgtGrp/PassiveActivityCrAfterLmtAmt');

-- 990T / Frm8904 CY Cyov Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54140, 54, '141', 'Frm8904 CY Cyov Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541814, 54140, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (541815, 54140, '2', 'Carry Back General Business Cr Amt', 'CURRENCY'),
  (541816, 54140, '3', 'ESBC Carryforward Amt', 'CURRENCY'),
  (541817, 54140, '4', 'Non Passive Ind', 'BOOLEAN'),
  (541818, 54140, '5', 'Pass Through Entity EIN', 'TEXT'),
  (541819, 54140, '6', 'Yr', 'TEXT'),
  (541820, 54140, '7', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (541821, 54140, '8', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (541822, 54140, '9', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (541823, 54140, '10', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (541824, 54140, '11', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541825, 54140, '12', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (541826, 54140, '13', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541814, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8904CYCyovCrGrp/CYGeneralBusCrCarryforwardAmt'),
  (541815, NULL, NULL, 'Carry Back General Business Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8904CYCyovCrGrp/CarryBackGeneralBusinessCrAmt'),
  (541816, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8904CYCyovCrGrp/ESBCCarryforwardAmt'),
  (541817, NULL, NULL, 'Non Passive Ind', 'BOOLEAN', 'ReturnData/IRS3800/Frm8904CYCyovCrGrp/NonPassiveInd'),
  (541818, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Frm8904CYCyovCrGrp/PassThroughEntityEIN'),
  (541819, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/Frm8904CYCyovCrGrp/Yr'),
  (541820, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8904CYCyovCrGrp/CarryforwardGeneralBusCrAmt'),
  (541821, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8904CYCyovCrGrp/CrSubjToPassiveActyLmtAmt'),
  (541822, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm8904CYCyovCrGrp/CyovGeneralBusinessCrItemCnt'),
  (541823, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8904CYCyovCrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (541824, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8904CYCyovCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541825, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8904CYCyovCrGrp/PassiveActivityCrAfterLmtAmt'),
  (541826, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8904CYCyovCrGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / Frm8941 CY Spcfd Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54141, 54, '142', 'Frm8941 CY Spcfd Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541827, 54141, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (541828, 54141, '2', 'Carry Back General Business Cr Amt', 'CURRENCY'),
  (541829, 54141, '3', 'ESBC Carryforward Amt', 'CURRENCY'),
  (541830, 54141, '4', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (541831, 54141, '5', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (541832, 54141, '6', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (541833, 54141, '7', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (541834, 54141, '8', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541835, 54141, '9', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (541836, 54141, '10', 'Total General Bus Credits App Tx Amt', 'CURRENCY'),
  (541837, 54141, '11', 'Yr', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541827, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8941CYSpcfdCrGrp/CYGeneralBusCrCarryforwardAmt'),
  (541828, NULL, NULL, 'Carry Back General Business Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8941CYSpcfdCrGrp/CarryBackGeneralBusinessCrAmt'),
  (541829, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8941CYSpcfdCrGrp/ESBCCarryforwardAmt'),
  (541830, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8941CYSpcfdCrGrp/CarryforwardGeneralBusCrAmt'),
  (541831, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8941CYSpcfdCrGrp/CrSubjToPassiveActyLmtAmt'),
  (541832, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm8941CYSpcfdCrGrp/CyovGeneralBusinessCrItemCnt'),
  (541833, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8941CYSpcfdCrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (541834, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8941CYSpcfdCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541835, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8941CYSpcfdCrGrp/PassiveActivityCrAfterLmtAmt'),
  (541836, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8941CYSpcfdCrGrp/TotalGeneralBusCreditsAppTxAmt'),
  (541837, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/Frm8941CYSpcfdCrGrp/Yr');

-- 990T / Frm6765 ESBCY Spcfd Cr Aggrgt Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54142, 54, '143', 'Frm6765 ESBCY Spcfd Cr Aggrgt Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541838, 54142, '1', 'Pass Through Entity EIN', 'TEXT'),
  (541839, 54142, '2', 'Yr', 'TEXT'),
  (541840, 54142, '3', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (541841, 54142, '4', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (541842, 54142, '5', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541843, 54142, '6', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (541844, 54142, '7', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (541845, 54142, '8', 'ESBC Carryforward Amt', 'CURRENCY'),
  (541846, 54142, '9', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541838, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Frm6765ESBCYSpcfdCrAggrgtGrp/PassThroughEntityEIN'),
  (541839, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/Frm6765ESBCYSpcfdCrAggrgtGrp/Yr'),
  (541840, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm6765ESBCYSpcfdCrAggrgtGrp/CarryforwardGeneralBusCrAmt'),
  (541841, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm6765ESBCYSpcfdCrAggrgtGrp/CYGeneralBusCrCarryforwardAmt'),
  (541842, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm6765ESBCYSpcfdCrAggrgtGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541843, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm6765ESBCYSpcfdCrAggrgtGrp/PassiveActivityCrAfterLmtAmt'),
  (541844, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm6765ESBCYSpcfdCrAggrgtGrp/CrSubjToPassiveActyLmtAmt'),
  (541845, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm6765ESBCYSpcfdCrAggrgtGrp/ESBCCarryforwardAmt'),
  (541846, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm6765ESBCYSpcfdCrAggrgtGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / Frm8826 CY Cyov Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54143, 54, '144', 'Frm8826 CY Cyov Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541847, 54143, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (541848, 54143, '2', 'Carry Back General Business Cr Amt', 'CURRENCY'),
  (541849, 54143, '3', 'ESBC Carryforward Amt', 'CURRENCY'),
  (541850, 54143, '4', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (541851, 54143, '5', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541852, 54143, '6', 'Total General Bus Credits App Tx Amt', 'CURRENCY'),
  (541853, 54143, '7', 'Yr', 'TEXT'),
  (541854, 54143, '8', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (541855, 54143, '9', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (541856, 54143, '10', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (541857, 54143, '11', 'Pass Through Entity EIN', 'TEXT'),
  (541858, 54143, '12', 'Passive Activity Cr After Lmt Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541847, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8826CYCyovCrGrp/CYGeneralBusCrCarryforwardAmt'),
  (541848, NULL, NULL, 'Carry Back General Business Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8826CYCyovCrGrp/CarryBackGeneralBusinessCrAmt'),
  (541849, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8826CYCyovCrGrp/ESBCCarryforwardAmt'),
  (541850, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8826CYCyovCrGrp/CarryforwardGeneralBusCrAmt'),
  (541851, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8826CYCyovCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541852, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8826CYCyovCrGrp/TotalGeneralBusCreditsAppTxAmt'),
  (541853, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/Frm8826CYCyovCrGrp/Yr'),
  (541854, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8826CYCyovCrGrp/CrSubjToPassiveActyLmtAmt'),
  (541855, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm8826CYCyovCrGrp/CyovGeneralBusinessCrItemCnt'),
  (541856, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8826CYCyovCrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (541857, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Frm8826CYCyovCrGrp/PassThroughEntityEIN'),
  (541858, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8826CYCyovCrGrp/PassiveActivityCrAfterLmtAmt');

-- 990T / Frm8874 CY Cyov Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54144, 54, '145', 'Frm8874 CY Cyov Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541859, 54144, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (541860, 54144, '2', 'Carry Back General Business Cr Amt', 'CURRENCY'),
  (541861, 54144, '3', 'ESBC Carryforward Amt', 'CURRENCY'),
  (541862, 54144, '4', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (541863, 54144, '5', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (541864, 54144, '6', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (541865, 54144, '7', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (541866, 54144, '8', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541867, 54144, '9', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (541868, 54144, '10', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541859, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8874CYCyovCrGrp/CYGeneralBusCrCarryforwardAmt'),
  (541860, NULL, NULL, 'Carry Back General Business Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8874CYCyovCrGrp/CarryBackGeneralBusinessCrAmt'),
  (541861, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8874CYCyovCrGrp/ESBCCarryforwardAmt'),
  (541862, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8874CYCyovCrGrp/CarryforwardGeneralBusCrAmt'),
  (541863, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8874CYCyovCrGrp/CrSubjToPassiveActyLmtAmt'),
  (541864, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm8874CYCyovCrGrp/CyovGeneralBusinessCrItemCnt'),
  (541865, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8874CYCyovCrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (541866, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8874CYCyovCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541867, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8874CYCyovCrGrp/PassiveActivityCrAfterLmtAmt'),
  (541868, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8874CYCyovCrGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / Frm8586 CY Cfwd Allw Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54145, 54, '146', 'Frm8586 CY Cfwd Allw Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541869, 54145, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (541870, 54145, '2', 'ESBC Carryforward Amt', 'CURRENCY'),
  (541871, 54145, '3', 'Yr', 'TEXT'),
  (541872, 54145, '4', 'Nonpassive Ind', 'BOOLEAN'),
  (541873, 54145, '5', 'Pass Through Entity EIN', 'TEXT'),
  (541874, 54145, '6', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (541875, 54145, '7', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (541876, 54145, '8', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (541877, 54145, '9', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (541878, 54145, '10', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541879, 54145, '11', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (541880, 54145, '12', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541869, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8586CYCfwdAllwCrGrp/CYGeneralBusCrCarryforwardAmt'),
  (541870, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8586CYCfwdAllwCrGrp/ESBCCarryforwardAmt'),
  (541871, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/Frm8586CYCfwdAllwCrGrp/Yr'),
  (541872, NULL, NULL, 'Nonpassive Ind', 'BOOLEAN', 'ReturnData/IRS3800/Frm8586CYCfwdAllwCrGrp/NonpassiveInd'),
  (541873, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Frm8586CYCfwdAllwCrGrp/PassThroughEntityEIN'),
  (541874, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8586CYCfwdAllwCrGrp/CarryforwardGeneralBusCrAmt'),
  (541875, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8586CYCfwdAllwCrGrp/CrSubjToPassiveActyLmtAmt'),
  (541876, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm8586CYCfwdAllwCrGrp/CyovGeneralBusinessCrItemCnt'),
  (541877, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8586CYCfwdAllwCrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (541878, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8586CYCfwdAllwCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541879, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8586CYCfwdAllwCrGrp/PassiveActivityCrAfterLmtAmt'),
  (541880, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8586CYCfwdAllwCrGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / Frm3468 Part IICY Cyov Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54146, 54, '147', 'Frm3468 Part IICY Cyov Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541881, 54146, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (541882, 54146, '2', 'Carry Back General Business Cr Amt', 'CURRENCY'),
  (541883, 54146, '3', 'ESBC Carryforward Amt', 'CURRENCY'),
  (541884, 54146, '4', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (541885, 54146, '5', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (541886, 54146, '6', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (541887, 54146, '7', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (541888, 54146, '8', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541889, 54146, '9', 'Non Passive Ind', 'BOOLEAN'),
  (541890, 54146, '10', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (541891, 54146, '11', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541881, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm3468PartIICYCyovCrGrp/CYGeneralBusCrCarryforwardAmt'),
  (541882, NULL, NULL, 'Carry Back General Business Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm3468PartIICYCyovCrGrp/CarryBackGeneralBusinessCrAmt'),
  (541883, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm3468PartIICYCyovCrGrp/ESBCCarryforwardAmt'),
  (541884, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm3468PartIICYCyovCrGrp/CarryforwardGeneralBusCrAmt'),
  (541885, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm3468PartIICYCyovCrGrp/CrSubjToPassiveActyLmtAmt'),
  (541886, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm3468PartIICYCyovCrGrp/CyovGeneralBusinessCrItemCnt'),
  (541887, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm3468PartIICYCyovCrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (541888, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm3468PartIICYCyovCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541889, NULL, NULL, 'Non Passive Ind', 'BOOLEAN', 'ReturnData/IRS3800/Frm3468PartIICYCyovCrGrp/NonPassiveInd'),
  (541890, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm3468PartIICYCyovCrGrp/PassiveActivityCrAfterLmtAmt'),
  (541891, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm3468PartIICYCyovCrGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / Frm8911 Part IICY Cyov Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54147, 54, '148', 'Frm8911 Part IICY Cyov Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541892, 54147, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (541893, 54147, '2', 'Carry Back General Business Cr Amt', 'CURRENCY'),
  (541894, 54147, '3', 'ESBC Carryforward Amt', 'CURRENCY'),
  (541895, 54147, '4', 'Non Passive Ind', 'BOOLEAN'),
  (541896, 54147, '5', 'Pass Through Entity EIN', 'TEXT'),
  (541897, 54147, '6', 'Yr', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541892, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8911PartIICYCyovCrGrp/CYGeneralBusCrCarryforwardAmt'),
  (541893, NULL, NULL, 'Carry Back General Business Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8911PartIICYCyovCrGrp/CarryBackGeneralBusinessCrAmt'),
  (541894, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8911PartIICYCyovCrGrp/ESBCCarryforwardAmt'),
  (541895, NULL, NULL, 'Non Passive Ind', 'BOOLEAN', 'ReturnData/IRS3800/Frm8911PartIICYCyovCrGrp/NonPassiveInd'),
  (541896, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Frm8911PartIICYCyovCrGrp/PassThroughEntityEIN'),
  (541897, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/Frm8911PartIICYCyovCrGrp/Yr');

-- 990T / Frm8845 CY Cfwd Allw Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54148, 54, '149', 'Frm8845 CY Cfwd Allw Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541898, 54148, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (541899, 54148, '2', 'ESBC Carryforward Amt', 'CURRENCY'),
  (541900, 54148, '3', 'Yr', 'TEXT'),
  (541901, 54148, '4', 'Pass Through Entity EIN', 'TEXT'),
  (541902, 54148, '5', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (541903, 54148, '6', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541904, 54148, '7', 'Nonpassive Ind', 'BOOLEAN'),
  (541905, 54148, '8', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (541906, 54148, '9', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (541907, 54148, '10', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (541908, 54148, '11', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (541909, 54148, '12', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541898, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8845CYCfwdAllwCrGrp/CYGeneralBusCrCarryforwardAmt'),
  (541899, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8845CYCfwdAllwCrGrp/ESBCCarryforwardAmt'),
  (541900, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/Frm8845CYCfwdAllwCrGrp/Yr'),
  (541901, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Frm8845CYCfwdAllwCrGrp/PassThroughEntityEIN'),
  (541902, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8845CYCfwdAllwCrGrp/CarryforwardGeneralBusCrAmt'),
  (541903, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8845CYCfwdAllwCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541904, NULL, NULL, 'Nonpassive Ind', 'BOOLEAN', 'ReturnData/IRS3800/Frm8845CYCfwdAllwCrGrp/NonpassiveInd'),
  (541905, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8845CYCfwdAllwCrGrp/CrSubjToPassiveActyLmtAmt'),
  (541906, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm8845CYCfwdAllwCrGrp/CyovGeneralBusinessCrItemCnt'),
  (541907, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8845CYCfwdAllwCrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (541908, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8845CYCfwdAllwCrGrp/PassiveActivityCrAfterLmtAmt'),
  (541909, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8845CYCfwdAllwCrGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / Form8911 Part ICY Credits Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54149, 54, '150', 'Form8911 Part ICY Credits Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541910, 54149, '1', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541911, 54149, '2', 'Total General Bus Credits Amt', 'CURRENCY'),
  (541912, 54149, '3', 'Total General Bus Credits App Tx Amt', 'CURRENCY'),
  (541913, 54149, '4', 'Elective Payment Registration Num', 'INTEGER'),
  (541914, 54149, '5', 'Gross Elective Pymt Election Amt', 'CURRENCY'),
  (541915, 54149, '6', 'Net Elective Pymt Election Amt', 'CURRENCY'),
  (541916, 54149, '7', 'Pass Through Entity EIN', 'TEXT'),
  (541917, 54149, '8', 'CY General Business Cr Item Cnt', 'INTEGER');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541910, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8911PartICYCreditsGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541911, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8911PartICYCreditsGrp/TotalGeneralBusCreditsAmt'),
  (541912, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8911PartICYCreditsGrp/TotalGeneralBusCreditsAppTxAmt'),
  (541913, NULL, NULL, 'Elective Payment Registration Num', 'INTEGER', 'ReturnData/IRS3800/Form8911PartICYCreditsGrp/ElectivePaymentRegistrationNum'),
  (541914, NULL, NULL, 'Gross Elective Pymt Election Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8911PartICYCreditsGrp/GrossElectivePymtElectionAmt'),
  (541915, NULL, NULL, 'Net Elective Pymt Election Amt', 'CURRENCY', 'ReturnData/IRS3800/Form8911PartICYCreditsGrp/NetElectivePymtElectionAmt'),
  (541916, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Form8911PartICYCreditsGrp/PassThroughEntityEIN'),
  (541917, NULL, NULL, 'CY General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Form8911PartICYCreditsGrp/CYGeneralBusinessCrItemCnt');

-- 990T / Frm8820 CY Cyov Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54150, 54, '151', 'Frm8820 CY Cyov Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541918, 54150, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (541919, 54150, '2', 'Carry Back General Business Cr Amt', 'CURRENCY'),
  (541920, 54150, '3', 'ESBC Carryforward Amt', 'CURRENCY'),
  (541921, 54150, '4', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (541922, 54150, '5', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (541923, 54150, '6', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (541924, 54150, '7', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (541925, 54150, '8', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541926, 54150, '9', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (541927, 54150, '10', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541918, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8820CYCyovCrGrp/CYGeneralBusCrCarryforwardAmt'),
  (541919, NULL, NULL, 'Carry Back General Business Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8820CYCyovCrGrp/CarryBackGeneralBusinessCrAmt'),
  (541920, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8820CYCyovCrGrp/ESBCCarryforwardAmt'),
  (541921, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8820CYCyovCrGrp/CarryforwardGeneralBusCrAmt'),
  (541922, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8820CYCyovCrGrp/CrSubjToPassiveActyLmtAmt'),
  (541923, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm8820CYCyovCrGrp/CyovGeneralBusinessCrItemCnt'),
  (541924, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8820CYCyovCrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (541925, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8820CYCyovCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541926, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8820CYCyovCrGrp/PassiveActivityCrAfterLmtAmt'),
  (541927, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8820CYCyovCrGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / Frm8881 Part ICY Cyov Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54151, 54, '152', 'Frm8881 Part ICY Cyov Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541928, 54151, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (541929, 54151, '2', 'Carry Back General Business Cr Amt', 'CURRENCY'),
  (541930, 54151, '3', 'ESBC Carryforward Amt', 'CURRENCY'),
  (541931, 54151, '4', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (541932, 54151, '5', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (541933, 54151, '6', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (541934, 54151, '7', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (541935, 54151, '8', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541936, 54151, '9', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (541937, 54151, '10', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541928, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8881PartICYCyovCrGrp/CYGeneralBusCrCarryforwardAmt'),
  (541929, NULL, NULL, 'Carry Back General Business Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8881PartICYCyovCrGrp/CarryBackGeneralBusinessCrAmt'),
  (541930, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8881PartICYCyovCrGrp/ESBCCarryforwardAmt'),
  (541931, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8881PartICYCyovCrGrp/CarryforwardGeneralBusCrAmt'),
  (541932, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8881PartICYCyovCrGrp/CrSubjToPassiveActyLmtAmt'),
  (541933, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm8881PartICYCyovCrGrp/CyovGeneralBusinessCrItemCnt'),
  (541934, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8881PartICYCyovCrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (541935, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8881PartICYCyovCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541936, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8881PartICYCyovCrGrp/PassiveActivityCrAfterLmtAmt'),
  (541937, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8881PartICYCyovCrGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / Frm8896 CY Cyov Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54152, 54, '153', 'Frm8896 CY Cyov Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541938, 54152, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (541939, 54152, '2', 'Carry Back General Business Cr Amt', 'CURRENCY'),
  (541940, 54152, '3', 'ESBC Carryforward Amt', 'CURRENCY'),
  (541941, 54152, '4', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (541942, 54152, '5', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (541943, 54152, '6', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (541944, 54152, '7', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (541945, 54152, '8', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541946, 54152, '9', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (541947, 54152, '10', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541938, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8896CYCyovCrGrp/CYGeneralBusCrCarryforwardAmt'),
  (541939, NULL, NULL, 'Carry Back General Business Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8896CYCyovCrGrp/CarryBackGeneralBusinessCrAmt'),
  (541940, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8896CYCyovCrGrp/ESBCCarryforwardAmt'),
  (541941, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8896CYCyovCrGrp/CarryforwardGeneralBusCrAmt'),
  (541942, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8896CYCyovCrGrp/CrSubjToPassiveActyLmtAmt'),
  (541943, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm8896CYCyovCrGrp/CyovGeneralBusinessCrItemCnt'),
  (541944, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8896CYCyovCrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (541945, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8896CYCyovCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541946, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8896CYCyovCrGrp/PassiveActivityCrAfterLmtAmt'),
  (541947, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8896CYCyovCrGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / Frm8900 CY Spcfd Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54153, 54, '154', 'Frm8900 CY Spcfd Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541948, 54153, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (541949, 54153, '2', 'Carry Back General Business Cr Amt', 'CURRENCY'),
  (541950, 54153, '3', 'ESBC Carryforward Amt', 'CURRENCY'),
  (541951, 54153, '4', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (541952, 54153, '5', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (541953, 54153, '6', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (541954, 54153, '7', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (541955, 54153, '8', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541956, 54153, '9', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (541957, 54153, '10', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541948, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8900CYSpcfdCrGrp/CYGeneralBusCrCarryforwardAmt'),
  (541949, NULL, NULL, 'Carry Back General Business Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8900CYSpcfdCrGrp/CarryBackGeneralBusinessCrAmt'),
  (541950, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8900CYSpcfdCrGrp/ESBCCarryforwardAmt'),
  (541951, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8900CYSpcfdCrGrp/CarryforwardGeneralBusCrAmt'),
  (541952, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8900CYSpcfdCrGrp/CrSubjToPassiveActyLmtAmt'),
  (541953, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm8900CYSpcfdCrGrp/CyovGeneralBusinessCrItemCnt'),
  (541954, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8900CYSpcfdCrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (541955, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8900CYSpcfdCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541956, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8900CYSpcfdCrGrp/PassiveActivityCrAfterLmtAmt'),
  (541957, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8900CYSpcfdCrGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / Frm8906 CY Cyov Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54154, 54, '155', 'Frm8906 CY Cyov Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541958, 54154, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (541959, 54154, '2', 'Carry Back General Business Cr Amt', 'CURRENCY'),
  (541960, 54154, '3', 'ESBC Carryforward Amt', 'CURRENCY'),
  (541961, 54154, '4', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (541962, 54154, '5', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (541963, 54154, '6', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (541964, 54154, '7', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (541965, 54154, '8', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541966, 54154, '9', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (541967, 54154, '10', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541958, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8906CYCyovCrGrp/CYGeneralBusCrCarryforwardAmt'),
  (541959, NULL, NULL, 'Carry Back General Business Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8906CYCyovCrGrp/CarryBackGeneralBusinessCrAmt'),
  (541960, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8906CYCyovCrGrp/ESBCCarryforwardAmt'),
  (541961, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8906CYCyovCrGrp/CarryforwardGeneralBusCrAmt'),
  (541962, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8906CYCyovCrGrp/CrSubjToPassiveActyLmtAmt'),
  (541963, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm8906CYCyovCrGrp/CyovGeneralBusinessCrItemCnt'),
  (541964, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8906CYCyovCrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (541965, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8906CYCyovCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541966, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8906CYCyovCrGrp/PassiveActivityCrAfterLmtAmt'),
  (541967, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8906CYCyovCrGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / Frm8932 CY Cyov Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54155, 54, '156', 'Frm8932 CY Cyov Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541968, 54155, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (541969, 54155, '2', 'Carry Back General Business Cr Amt', 'CURRENCY'),
  (541970, 54155, '3', 'ESBC Carryforward Amt', 'CURRENCY'),
  (541971, 54155, '4', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (541972, 54155, '5', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (541973, 54155, '6', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (541974, 54155, '7', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (541975, 54155, '8', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541976, 54155, '9', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (541977, 54155, '10', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541968, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8932CYCyovCrGrp/CYGeneralBusCrCarryforwardAmt'),
  (541969, NULL, NULL, 'Carry Back General Business Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8932CYCyovCrGrp/CarryBackGeneralBusinessCrAmt'),
  (541970, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8932CYCyovCrGrp/ESBCCarryforwardAmt'),
  (541971, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8932CYCyovCrGrp/CarryforwardGeneralBusCrAmt'),
  (541972, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8932CYCyovCrGrp/CrSubjToPassiveActyLmtAmt'),
  (541973, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm8932CYCyovCrGrp/CyovGeneralBusinessCrItemCnt'),
  (541974, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8932CYCyovCrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (541975, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8932CYCyovCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541976, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8932CYCyovCrGrp/PassiveActivityCrAfterLmtAmt'),
  (541977, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8932CYCyovCrGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / Frm8933 CY Cyov Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54156, 54, '157', 'Frm8933 CY Cyov Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541978, 54156, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (541979, 54156, '2', 'Carry Back General Business Cr Amt', 'CURRENCY'),
  (541980, 54156, '3', 'ESBC Carryforward Amt', 'CURRENCY'),
  (541981, 54156, '4', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (541982, 54156, '5', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (541983, 54156, '6', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (541984, 54156, '7', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (541985, 54156, '8', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541986, 54156, '9', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (541987, 54156, '10', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541978, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8933CYCyovCrGrp/CYGeneralBusCrCarryforwardAmt'),
  (541979, NULL, NULL, 'Carry Back General Business Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8933CYCyovCrGrp/CarryBackGeneralBusinessCrAmt'),
  (541980, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8933CYCyovCrGrp/ESBCCarryforwardAmt'),
  (541981, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8933CYCyovCrGrp/CarryforwardGeneralBusCrAmt'),
  (541982, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8933CYCyovCrGrp/CrSubjToPassiveActyLmtAmt'),
  (541983, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm8933CYCyovCrGrp/CyovGeneralBusinessCrItemCnt'),
  (541984, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8933CYCyovCrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (541985, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8933CYCyovCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541986, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8933CYCyovCrGrp/PassiveActivityCrAfterLmtAmt'),
  (541987, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8933CYCyovCrGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / Frm5884 BCY Cfwd Allw Cr Aggrgt Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54157, 54, '158', 'Frm5884 BCY Cfwd Allw Cr Aggrgt Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541988, 54157, '1', 'Yr', 'TEXT'),
  (541989, 54157, '2', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (541990, 54157, '3', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (541991, 54157, '4', 'Pass Through Entity EIN', 'TEXT'),
  (541992, 54157, '5', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (541993, 54157, '6', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (541994, 54157, '7', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (541995, 54157, '8', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (541996, 54157, '9', 'Total General Bus Credits App Tx Amt', 'CURRENCY'),
  (541997, 54157, '10', 'Missing EIN Reason Cd', 'TEXT'),
  (541998, 54157, '11', 'Nonpassive Ind', 'BOOLEAN');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541988, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/Frm5884BCYCfwdAllwCrAggrgtGrp/Yr'),
  (541989, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm5884BCYCfwdAllwCrAggrgtGrp/CarryforwardGeneralBusCrAmt'),
  (541990, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm5884BCYCfwdAllwCrAggrgtGrp/GeneralBusCrFromNnPssvActyAmt'),
  (541991, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Frm5884BCYCfwdAllwCrAggrgtGrp/PassThroughEntityEIN'),
  (541992, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm5884BCYCfwdAllwCrAggrgtGrp/CYGeneralBusCrCarryforwardAmt'),
  (541993, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm5884BCYCfwdAllwCrAggrgtGrp/CrSubjToPassiveActyLmtAmt'),
  (541994, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm5884BCYCfwdAllwCrAggrgtGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (541995, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm5884BCYCfwdAllwCrAggrgtGrp/PassiveActivityCrAfterLmtAmt'),
  (541996, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm5884BCYCfwdAllwCrAggrgtGrp/TotalGeneralBusCreditsAppTxAmt'),
  (541997, NULL, NULL, 'Missing EIN Reason Cd', 'TEXT', 'ReturnData/IRS3800/Frm5884BCYCfwdAllwCrAggrgtGrp/MissingEINReasonCd'),
  (541998, NULL, NULL, 'Nonpassive Ind', 'BOOLEAN', 'ReturnData/IRS3800/Frm5884BCYCfwdAllwCrAggrgtGrp/NonpassiveInd');

-- 990T / Frm3468 Part IIICY Cyov Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54158, 54, '159', 'Frm3468 Part IIICY Cyov Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (541999, 54158, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (542000, 54158, '2', 'Carry Back General Business Cr Amt', 'CURRENCY'),
  (542001, 54158, '3', 'Nonpassive Ind', 'BOOLEAN'),
  (542002, 54158, '4', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (542003, 54158, '5', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (542004, 54158, '6', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (542005, 54158, '7', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (542006, 54158, '8', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (542007, 54158, '9', 'Pass Through Entity EIN', 'TEXT'),
  (542008, 54158, '10', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (542009, 54158, '11', 'Total General Bus Credits App Tx Amt', 'CURRENCY'),
  (542010, 54158, '12', 'Yr', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (541999, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm3468PartIIICYCyovCrGrp/CYGeneralBusCrCarryforwardAmt'),
  (542000, NULL, NULL, 'Carry Back General Business Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm3468PartIIICYCyovCrGrp/CarryBackGeneralBusinessCrAmt'),
  (542001, NULL, NULL, 'Nonpassive Ind', 'BOOLEAN', 'ReturnData/IRS3800/Frm3468PartIIICYCyovCrGrp/NonpassiveInd'),
  (542002, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm3468PartIIICYCyovCrGrp/CarryforwardGeneralBusCrAmt'),
  (542003, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm3468PartIIICYCyovCrGrp/CrSubjToPassiveActyLmtAmt'),
  (542004, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm3468PartIIICYCyovCrGrp/CyovGeneralBusinessCrItemCnt'),
  (542005, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm3468PartIIICYCyovCrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (542006, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm3468PartIIICYCyovCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (542007, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Frm3468PartIIICYCyovCrGrp/PassThroughEntityEIN'),
  (542008, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm3468PartIIICYCyovCrGrp/PassiveActivityCrAfterLmtAmt'),
  (542009, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm3468PartIIICYCyovCrGrp/TotalGeneralBusCreditsAppTxAmt'),
  (542010, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/Frm3468PartIIICYCyovCrGrp/Yr');

-- 990T / Frm5884 CY Cfwd Allw Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54159, 54, '160', 'Frm5884 CY Cfwd Allw Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542011, 54159, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (542012, 54159, '2', 'ESBC Carryforward Amt', 'CURRENCY'),
  (542013, 54159, '3', 'Yr', 'TEXT'),
  (542014, 54159, '4', 'Pass Through Entity EIN', 'TEXT'),
  (542015, 54159, '5', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (542016, 54159, '6', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (542017, 54159, '7', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (542018, 54159, '8', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (542019, 54159, '9', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (542020, 54159, '10', 'Nonpassive Ind', 'BOOLEAN'),
  (542021, 54159, '11', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (542022, 54159, '12', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542011, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm5884CYCfwdAllwCrGrp/CYGeneralBusCrCarryforwardAmt'),
  (542012, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm5884CYCfwdAllwCrGrp/ESBCCarryforwardAmt'),
  (542013, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/Frm5884CYCfwdAllwCrGrp/Yr'),
  (542014, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Frm5884CYCfwdAllwCrGrp/PassThroughEntityEIN'),
  (542015, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm5884CYCfwdAllwCrGrp/CarryforwardGeneralBusCrAmt'),
  (542016, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm5884CYCfwdAllwCrGrp/CrSubjToPassiveActyLmtAmt'),
  (542017, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm5884CYCfwdAllwCrGrp/CyovGeneralBusinessCrItemCnt'),
  (542018, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm5884CYCfwdAllwCrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (542019, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm5884CYCfwdAllwCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (542020, NULL, NULL, 'Nonpassive Ind', 'BOOLEAN', 'ReturnData/IRS3800/Frm5884CYCfwdAllwCrGrp/NonpassiveInd'),
  (542021, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm5884CYCfwdAllwCrGrp/PassiveActivityCrAfterLmtAmt'),
  (542022, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm5884CYCfwdAllwCrGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / Frm8910 CY Cyov Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54160, 54, '161', 'Frm8910 CY Cyov Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542023, 54160, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (542024, 54160, '2', 'Carry Back General Business Cr Amt', 'CURRENCY'),
  (542025, 54160, '3', 'ESBC Carryforward Amt', 'CURRENCY'),
  (542026, 54160, '4', 'Non Passive Ind', 'BOOLEAN');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542023, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8910CYCyovCrGrp/CYGeneralBusCrCarryforwardAmt'),
  (542024, NULL, NULL, 'Carry Back General Business Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8910CYCyovCrGrp/CarryBackGeneralBusinessCrAmt'),
  (542025, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8910CYCyovCrGrp/ESBCCarryforwardAmt'),
  (542026, NULL, NULL, 'Non Passive Ind', 'BOOLEAN', 'ReturnData/IRS3800/Frm8910CYCyovCrGrp/NonPassiveInd');

-- 990T / Total STCGL1099 B Shows Basis Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54161, 54, '162', 'Total STCGL1099 B Shows Basis Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542027, 54161, '1', 'Total Gain Or Loss Amt', 'CURRENCY'),
  (542028, 54161, '2', 'Total Proceeds Sales Price Amt', 'CURRENCY'),
  (542029, 54161, '3', 'Total Cost Or Other Basis Amt', 'CURRENCY'),
  (542030, 54161, '4', 'Tot Adjustments To Gain Or Loss Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542027, NULL, NULL, 'Total Gain Or Loss Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/TotalSTCGL1099BShowsBasisGrp/TotalGainOrLossAmt'),
  (542028, NULL, NULL, 'Total Proceeds Sales Price Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/TotalSTCGL1099BShowsBasisGrp/TotalProceedsSalesPriceAmt'),
  (542029, NULL, NULL, 'Total Cost Or Other Basis Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/TotalSTCGL1099BShowsBasisGrp/TotalCostOrOtherBasisAmt'),
  (542030, NULL, NULL, 'Tot Adjustments To Gain Or Loss Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/TotalSTCGL1099BShowsBasisGrp/TotAdjustmentsToGainOrLossAmt');

-- 990T / Sustainable Aviation Fuel Detail
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54162, 54, '163', 'Sustainable Aviation Fuel Detail');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542031, 54162, '1', 'Gallons Qty', 'TEXT'),
  (542032, 54162, '2', 'Rt', 'PERCENT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542031, NULL, NULL, 'Gallons Qty', 'TEXT', 'ReturnData/IRS4136/SustainableAviationFuelDetail/GallonsQty'),
  (542032, NULL, NULL, 'Rt', 'PERCENT', 'ReturnData/IRS4136/SustainableAviationFuelDetail/Rt');

-- 990T / Vehicle Usage
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54163, 54, '164', 'Vehicle Usage');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542033, 54163, '1', 'Another Vehicle For Prsnl Use Ind', 'BOOLEAN'),
  (542034, 54163, '2', 'Total Miles Cnt', 'INTEGER'),
  (542035, 54163, '3', 'Used Primarily By Owner Ind', 'BOOLEAN'),
  (542036, 54163, '4', 'Vehicle Available Off Duty Hrs Ind', 'BOOLEAN'),
  (542037, 54163, '5', 'Business Miles Cnt', 'INTEGER'),
  (542038, 54163, '6', 'Commuting Miles Cnt', 'INTEGER'),
  (542039, 54163, '7', 'Other Personal Miles Cnt', 'INTEGER');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542033, NULL, NULL, 'Another Vehicle For Prsnl Use Ind', 'BOOLEAN', 'ReturnData/IRS4562/VehicleUsage/AnotherVehicleForPrsnlUseInd'),
  (542034, NULL, NULL, 'Total Miles Cnt', 'INTEGER', 'ReturnData/IRS4562/VehicleUsage/TotalMilesCnt'),
  (542035, NULL, NULL, 'Used Primarily By Owner Ind', 'BOOLEAN', 'ReturnData/IRS4562/VehicleUsage/UsedPrimarilyByOwnerInd'),
  (542036, NULL, NULL, 'Vehicle Available Off Duty Hrs Ind', 'BOOLEAN', 'ReturnData/IRS4562/VehicleUsage/VehicleAvailableOffDutyHrsInd'),
  (542037, NULL, NULL, 'Business Miles Cnt', 'INTEGER', 'ReturnData/IRS4562/VehicleUsage/BusinessMilesCnt'),
  (542038, NULL, NULL, 'Commuting Miles Cnt', 'INTEGER', 'ReturnData/IRS4562/VehicleUsage/CommutingMilesCnt'),
  (542039, NULL, NULL, 'Other Personal Miles Cnt', 'INTEGER', 'ReturnData/IRS4562/VehicleUsage/OtherPersonalMilesCnt');

-- 990T / Total STCGL1099 B Bss Rpt No Adj Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54164, 54, '165', 'Total STCGL1099 B Bss Rpt No Adj Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542040, 54164, '1', 'Total Cost Or Other Basis Amt', 'CURRENCY'),
  (542041, 54164, '2', 'Total Proceeds Sales Price Amt', 'CURRENCY'),
  (542042, 54164, '3', 'Total Gain Or Loss Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542040, NULL, NULL, 'Total Cost Or Other Basis Amt', 'CURRENCY', 'ReturnData/IRS1120ScheduleD/TotalSTCGL1099BBssRptNoAdjGrp/TotalCostOrOtherBasisAmt'),
  (542041, NULL, NULL, 'Total Proceeds Sales Price Amt', 'CURRENCY', 'ReturnData/IRS1120ScheduleD/TotalSTCGL1099BBssRptNoAdjGrp/TotalProceedsSalesPriceAmt'),
  (542042, NULL, NULL, 'Total Gain Or Loss Amt', 'CURRENCY', 'ReturnData/IRS1120ScheduleD/TotalSTCGL1099BBssRptNoAdjGrp/TotalGainOrLossAmt');

-- 990T / Total LTCGL1099 B Not Show Basis Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54165, 54, '166', 'Total LTCGL1099 B Not Show Basis Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542043, 54165, '1', 'Total Gain Or Loss Amt', 'CURRENCY'),
  (542044, 54165, '2', 'Total Cost Or Other Basis Amt', 'CURRENCY'),
  (542045, 54165, '3', 'Total Proceeds Sales Price Amt', 'CURRENCY'),
  (542046, 54165, '4', 'Tot Adjustments To Gain Or Loss Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542043, NULL, NULL, 'Total Gain Or Loss Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/TotalLTCGL1099BNotShowBasisGrp/TotalGainOrLossAmt'),
  (542044, NULL, NULL, 'Total Cost Or Other Basis Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/TotalLTCGL1099BNotShowBasisGrp/TotalCostOrOtherBasisAmt'),
  (542045, NULL, NULL, 'Total Proceeds Sales Price Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/TotalLTCGL1099BNotShowBasisGrp/TotalProceedsSalesPriceAmt'),
  (542046, NULL, NULL, 'Tot Adjustments To Gain Or Loss Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/TotalLTCGL1099BNotShowBasisGrp/TotAdjustmentsToGainOrLossAmt');

-- 990T / Frm8884 CY Cfwd Allw Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54166, 54, '167', 'Frm8884 CY Cfwd Allw Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542047, 54166, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (542048, 54166, '2', 'ESBC Carryforward Amt', 'CURRENCY'),
  (542049, 54166, '3', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (542050, 54166, '4', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (542051, 54166, '5', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (542052, 54166, '6', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (542053, 54166, '7', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (542054, 54166, '8', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (542055, 54166, '9', 'Total General Bus Credits App Tx Amt', 'CURRENCY'),
  (542056, 54166, '10', 'Yr', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542047, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8884CYCfwdAllwCrGrp/CYGeneralBusCrCarryforwardAmt'),
  (542048, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8884CYCfwdAllwCrGrp/ESBCCarryforwardAmt'),
  (542049, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8884CYCfwdAllwCrGrp/CarryforwardGeneralBusCrAmt'),
  (542050, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8884CYCfwdAllwCrGrp/CrSubjToPassiveActyLmtAmt'),
  (542051, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm8884CYCfwdAllwCrGrp/CyovGeneralBusinessCrItemCnt'),
  (542052, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8884CYCfwdAllwCrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (542053, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8884CYCfwdAllwCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (542054, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8884CYCfwdAllwCrGrp/PassiveActivityCrAfterLmtAmt'),
  (542055, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8884CYCfwdAllwCrGrp/TotalGeneralBusCreditsAppTxAmt'),
  (542056, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/Frm8884CYCfwdAllwCrGrp/Yr');

-- 990T / CY Cfwd Allw Cr Emplr Affct Hrrcn Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54167, 54, '168', 'CY Cfwd Allw Cr Emplr Affct Hrrcn Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542057, 54167, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (542058, 54167, '2', 'ESBC Carryforward Amt', 'CURRENCY'),
  (542059, 54167, '3', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (542060, 54167, '4', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (542061, 54167, '5', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (542062, 54167, '6', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (542063, 54167, '7', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (542064, 54167, '8', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (542065, 54167, '9', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542057, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCfwdAllwCrEmplrAffctHrrcnGrp/CYGeneralBusCrCarryforwardAmt'),
  (542058, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCfwdAllwCrEmplrAffctHrrcnGrp/ESBCCarryforwardAmt'),
  (542059, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCfwdAllwCrEmplrAffctHrrcnGrp/CarryforwardGeneralBusCrAmt'),
  (542060, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCfwdAllwCrEmplrAffctHrrcnGrp/CrSubjToPassiveActyLmtAmt'),
  (542061, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/CYCfwdAllwCrEmplrAffctHrrcnGrp/CyovGeneralBusinessCrItemCnt'),
  (542062, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCfwdAllwCrEmplrAffctHrrcnGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (542063, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCfwdAllwCrEmplrAffctHrrcnGrp/GeneralBusCrFromNnPssvActyAmt'),
  (542064, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCfwdAllwCrEmplrAffctHrrcnGrp/PassiveActivityCrAfterLmtAmt'),
  (542065, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCfwdAllwCrEmplrAffctHrrcnGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / CY Cfwd Allw Cr Emplr Hsng Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54168, 54, '169', 'CY Cfwd Allw Cr Emplr Hsng Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542066, 54168, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (542067, 54168, '2', 'ESBC Carryforward Amt', 'CURRENCY'),
  (542068, 54168, '3', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (542069, 54168, '4', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (542070, 54168, '5', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (542071, 54168, '6', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (542072, 54168, '7', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (542073, 54168, '8', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (542074, 54168, '9', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542066, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCfwdAllwCrEmplrHsngGrp/CYGeneralBusCrCarryforwardAmt'),
  (542067, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCfwdAllwCrEmplrHsngGrp/ESBCCarryforwardAmt'),
  (542068, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCfwdAllwCrEmplrHsngGrp/CarryforwardGeneralBusCrAmt'),
  (542069, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCfwdAllwCrEmplrHsngGrp/CrSubjToPassiveActyLmtAmt'),
  (542070, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/CYCfwdAllwCrEmplrHsngGrp/CyovGeneralBusinessCrItemCnt'),
  (542071, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCfwdAllwCrEmplrHsngGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (542072, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCfwdAllwCrEmplrHsngGrp/GeneralBusCrFromNnPssvActyAmt'),
  (542073, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCfwdAllwCrEmplrHsngGrp/PassiveActivityCrAfterLmtAmt'),
  (542074, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCfwdAllwCrEmplrHsngGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / CY Cfwd Allw Cr Hrrcn Ktrn Hsng Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54169, 54, '170', 'CY Cfwd Allw Cr Hrrcn Ktrn Hsng Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542075, 54169, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (542076, 54169, '2', 'ESBC Carryforward Amt', 'CURRENCY'),
  (542077, 54169, '3', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (542078, 54169, '4', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (542079, 54169, '5', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (542080, 54169, '6', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (542081, 54169, '7', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (542082, 54169, '8', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (542083, 54169, '9', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542075, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCfwdAllwCrHrrcnKtrnHsngGrp/CYGeneralBusCrCarryforwardAmt'),
  (542076, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCfwdAllwCrHrrcnKtrnHsngGrp/ESBCCarryforwardAmt'),
  (542077, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCfwdAllwCrHrrcnKtrnHsngGrp/CarryforwardGeneralBusCrAmt'),
  (542078, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCfwdAllwCrHrrcnKtrnHsngGrp/CrSubjToPassiveActyLmtAmt'),
  (542079, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/CYCfwdAllwCrHrrcnKtrnHsngGrp/CyovGeneralBusinessCrItemCnt'),
  (542080, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCfwdAllwCrHrrcnKtrnHsngGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (542081, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCfwdAllwCrHrrcnKtrnHsngGrp/GeneralBusCrFromNnPssvActyAmt'),
  (542082, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCfwdAllwCrHrrcnKtrnHsngGrp/PassiveActivityCrAfterLmtAmt'),
  (542083, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCfwdAllwCrHrrcnKtrnHsngGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / CY Cfwd Allw Cr Mwd Dsstr Emplr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54170, 54, '171', 'CY Cfwd Allw Cr Mwd Dsstr Emplr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542084, 54170, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (542085, 54170, '2', 'ESBC Carryforward Amt', 'CURRENCY'),
  (542086, 54170, '3', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (542087, 54170, '4', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (542088, 54170, '5', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (542089, 54170, '6', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (542090, 54170, '7', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (542091, 54170, '8', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (542092, 54170, '9', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542084, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCfwdAllwCrMwdDsstrEmplrGrp/CYGeneralBusCrCarryforwardAmt'),
  (542085, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCfwdAllwCrMwdDsstrEmplrGrp/ESBCCarryforwardAmt'),
  (542086, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCfwdAllwCrMwdDsstrEmplrGrp/CarryforwardGeneralBusCrAmt'),
  (542087, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCfwdAllwCrMwdDsstrEmplrGrp/CrSubjToPassiveActyLmtAmt'),
  (542088, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/CYCfwdAllwCrMwdDsstrEmplrGrp/CyovGeneralBusinessCrItemCnt'),
  (542089, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCfwdAllwCrMwdDsstrEmplrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (542090, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCfwdAllwCrMwdDsstrEmplrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (542091, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCfwdAllwCrMwdDsstrEmplrGrp/PassiveActivityCrAfterLmtAmt'),
  (542092, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCfwdAllwCrMwdDsstrEmplrGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / CY Cfwd Allw Cr Trans AK Pipeline Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54171, 54, '172', 'CY Cfwd Allw Cr Trans AK Pipeline Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542093, 54171, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (542094, 54171, '2', 'ESBC Carryforward Amt', 'CURRENCY'),
  (542095, 54171, '3', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (542096, 54171, '4', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (542097, 54171, '5', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (542098, 54171, '6', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (542099, 54171, '7', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (542100, 54171, '8', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (542101, 54171, '9', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542093, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCfwdAllwCrTransAKPipelineGrp/CYGeneralBusCrCarryforwardAmt'),
  (542094, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCfwdAllwCrTransAKPipelineGrp/ESBCCarryforwardAmt'),
  (542095, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCfwdAllwCrTransAKPipelineGrp/CarryforwardGeneralBusCrAmt'),
  (542096, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCfwdAllwCrTransAKPipelineGrp/CrSubjToPassiveActyLmtAmt'),
  (542097, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/CYCfwdAllwCrTransAKPipelineGrp/CyovGeneralBusinessCrItemCnt'),
  (542098, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCfwdAllwCrTransAKPipelineGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (542099, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCfwdAllwCrTransAKPipelineGrp/GeneralBusCrFromNnPssvActyAmt'),
  (542100, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCfwdAllwCrTransAKPipelineGrp/PassiveActivityCrAfterLmtAmt'),
  (542101, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCfwdAllwCrTransAKPipelineGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / Frm1065 BCY Cfwd Allw Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54172, 54, '173', 'Frm1065 BCY Cfwd Allw Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542102, 54172, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (542103, 54172, '2', 'ESBC Carryforward Amt', 'CURRENCY'),
  (542104, 54172, '3', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (542105, 54172, '4', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (542106, 54172, '5', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (542107, 54172, '6', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (542108, 54172, '7', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (542109, 54172, '8', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (542110, 54172, '9', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542102, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm1065BCYCfwdAllwCrGrp/CYGeneralBusCrCarryforwardAmt'),
  (542103, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm1065BCYCfwdAllwCrGrp/ESBCCarryforwardAmt'),
  (542104, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm1065BCYCfwdAllwCrGrp/CarryforwardGeneralBusCrAmt'),
  (542105, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm1065BCYCfwdAllwCrGrp/CrSubjToPassiveActyLmtAmt'),
  (542106, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm1065BCYCfwdAllwCrGrp/CyovGeneralBusinessCrItemCnt'),
  (542107, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm1065BCYCfwdAllwCrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (542108, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm1065BCYCfwdAllwCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (542109, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm1065BCYCfwdAllwCrGrp/PassiveActivityCrAfterLmtAmt'),
  (542110, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm1065BCYCfwdAllwCrGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / Frm3468 Part IVCY Cyov Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54173, 54, '174', 'Frm3468 Part IVCY Cyov Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542111, 54173, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (542112, 54173, '2', 'Carry Back General Business Cr Amt', 'CURRENCY'),
  (542113, 54173, '3', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (542114, 54173, '4', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (542115, 54173, '5', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (542116, 54173, '6', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (542117, 54173, '7', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (542118, 54173, '8', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (542119, 54173, '9', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542111, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm3468PartIVCYCyovCrGrp/CYGeneralBusCrCarryforwardAmt'),
  (542112, NULL, NULL, 'Carry Back General Business Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm3468PartIVCYCyovCrGrp/CarryBackGeneralBusinessCrAmt'),
  (542113, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm3468PartIVCYCyovCrGrp/CarryforwardGeneralBusCrAmt'),
  (542114, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm3468PartIVCYCyovCrGrp/CrSubjToPassiveActyLmtAmt'),
  (542115, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm3468PartIVCYCyovCrGrp/CyovGeneralBusinessCrItemCnt'),
  (542116, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm3468PartIVCYCyovCrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (542117, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm3468PartIVCYCyovCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (542118, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm3468PartIVCYCyovCrGrp/PassiveActivityCrAfterLmtAmt'),
  (542119, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm3468PartIVCYCyovCrGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / Frm6478 CY Cfwd Allw Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54174, 54, '175', 'Frm6478 CY Cfwd Allw Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542120, 54174, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (542121, 54174, '2', 'ESBC Carryforward Amt', 'CURRENCY'),
  (542122, 54174, '3', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (542123, 54174, '4', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (542124, 54174, '5', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (542125, 54174, '6', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (542126, 54174, '7', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (542127, 54174, '8', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (542128, 54174, '9', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542120, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm6478CYCfwdAllwCrGrp/CYGeneralBusCrCarryforwardAmt'),
  (542121, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm6478CYCfwdAllwCrGrp/ESBCCarryforwardAmt'),
  (542122, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm6478CYCfwdAllwCrGrp/CarryforwardGeneralBusCrAmt'),
  (542123, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm6478CYCfwdAllwCrGrp/CrSubjToPassiveActyLmtAmt'),
  (542124, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm6478CYCfwdAllwCrGrp/CyovGeneralBusinessCrItemCnt'),
  (542125, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm6478CYCfwdAllwCrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (542126, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm6478CYCfwdAllwCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (542127, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm6478CYCfwdAllwCrGrp/PassiveActivityCrAfterLmtAmt'),
  (542128, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm6478CYCfwdAllwCrGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / Frm7207 CY Cyov Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54175, 54, '176', 'Frm7207 CY Cyov Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542129, 54175, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (542130, 54175, '2', 'Carry Back General Business Cr Amt', 'CURRENCY'),
  (542131, 54175, '3', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (542132, 54175, '4', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (542133, 54175, '5', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (542134, 54175, '6', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (542135, 54175, '7', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (542136, 54175, '8', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (542137, 54175, '9', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542129, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm7207CYCyovCrGrp/CYGeneralBusCrCarryforwardAmt'),
  (542130, NULL, NULL, 'Carry Back General Business Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm7207CYCyovCrGrp/CarryBackGeneralBusinessCrAmt'),
  (542131, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm7207CYCyovCrGrp/CarryforwardGeneralBusCrAmt'),
  (542132, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm7207CYCyovCrGrp/CrSubjToPassiveActyLmtAmt'),
  (542133, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm7207CYCyovCrGrp/CyovGeneralBusinessCrItemCnt'),
  (542134, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm7207CYCyovCrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (542135, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm7207CYCyovCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (542136, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm7207CYCyovCrGrp/PassiveActivityCrAfterLmtAmt'),
  (542137, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm7207CYCyovCrGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / Frm7210 CY Cyov Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54176, 54, '177', 'Frm7210 CY Cyov Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542138, 54176, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (542139, 54176, '2', 'Carry Back General Business Cr Amt', 'CURRENCY'),
  (542140, 54176, '3', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (542141, 54176, '4', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (542142, 54176, '5', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (542143, 54176, '6', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (542144, 54176, '7', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (542145, 54176, '8', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (542146, 54176, '9', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542138, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm7210CYCyovCrGrp/CYGeneralBusCrCarryforwardAmt'),
  (542139, NULL, NULL, 'Carry Back General Business Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm7210CYCyovCrGrp/CarryBackGeneralBusinessCrAmt'),
  (542140, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm7210CYCyovCrGrp/CarryforwardGeneralBusCrAmt'),
  (542141, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm7210CYCyovCrGrp/CrSubjToPassiveActyLmtAmt'),
  (542142, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm7210CYCyovCrGrp/CyovGeneralBusinessCrItemCnt'),
  (542143, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm7210CYCyovCrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (542144, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm7210CYCyovCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (542145, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm7210CYCyovCrGrp/PassiveActivityCrAfterLmtAmt'),
  (542146, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm7210CYCyovCrGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / Frm7213 Part ICY Cyov Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54177, 54, '178', 'Frm7213 Part ICY Cyov Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542147, 54177, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (542148, 54177, '2', 'Carry Back General Business Cr Amt', 'CURRENCY'),
  (542149, 54177, '3', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (542150, 54177, '4', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (542151, 54177, '5', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (542152, 54177, '6', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (542153, 54177, '7', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (542154, 54177, '8', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (542155, 54177, '9', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542147, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm7213PartICYCyovCrGrp/CYGeneralBusCrCarryforwardAmt'),
  (542148, NULL, NULL, 'Carry Back General Business Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm7213PartICYCyovCrGrp/CarryBackGeneralBusinessCrAmt'),
  (542149, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm7213PartICYCyovCrGrp/CarryforwardGeneralBusCrAmt'),
  (542150, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm7213PartICYCyovCrGrp/CrSubjToPassiveActyLmtAmt'),
  (542151, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm7213PartICYCyovCrGrp/CyovGeneralBusinessCrItemCnt'),
  (542152, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm7213PartICYCyovCrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (542153, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm7213PartICYCyovCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (542154, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm7213PartICYCyovCrGrp/PassiveActivityCrAfterLmtAmt'),
  (542155, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm7213PartICYCyovCrGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / Frm7213 Part IICY Cyov Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54178, 54, '179', 'Frm7213 Part IICY Cyov Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542156, 54178, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (542157, 54178, '2', 'Carry Back General Business Cr Amt', 'CURRENCY'),
  (542158, 54178, '3', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (542159, 54178, '4', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (542160, 54178, '5', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (542161, 54178, '6', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (542162, 54178, '7', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (542163, 54178, '8', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (542164, 54178, '9', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542156, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm7213PartIICYCyovCrGrp/CYGeneralBusCrCarryforwardAmt'),
  (542157, NULL, NULL, 'Carry Back General Business Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm7213PartIICYCyovCrGrp/CarryBackGeneralBusinessCrAmt'),
  (542158, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm7213PartIICYCyovCrGrp/CarryforwardGeneralBusCrAmt'),
  (542159, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm7213PartIICYCyovCrGrp/CrSubjToPassiveActyLmtAmt'),
  (542160, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm7213PartIICYCyovCrGrp/CyovGeneralBusinessCrItemCnt'),
  (542161, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm7213PartIICYCyovCrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (542162, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm7213PartIICYCyovCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (542163, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm7213PartIICYCyovCrGrp/PassiveActivityCrAfterLmtAmt'),
  (542164, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm7213PartIICYCyovCrGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / Frm8834 Part ICY Cfwd Allw Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54179, 54, '180', 'Frm8834 Part ICY Cfwd Allw Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542165, 54179, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (542166, 54179, '2', 'ESBC Carryforward Amt', 'CURRENCY'),
  (542167, 54179, '3', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (542168, 54179, '4', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (542169, 54179, '5', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (542170, 54179, '6', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (542171, 54179, '7', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (542172, 54179, '8', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (542173, 54179, '9', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542165, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8834PartICYCfwdAllwCrGrp/CYGeneralBusCrCarryforwardAmt'),
  (542166, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8834PartICYCfwdAllwCrGrp/ESBCCarryforwardAmt'),
  (542167, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8834PartICYCfwdAllwCrGrp/CarryforwardGeneralBusCrAmt'),
  (542168, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8834PartICYCfwdAllwCrGrp/CrSubjToPassiveActyLmtAmt'),
  (542169, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm8834PartICYCfwdAllwCrGrp/CyovGeneralBusinessCrItemCnt'),
  (542170, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8834PartICYCfwdAllwCrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (542171, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8834PartICYCfwdAllwCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (542172, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8834PartICYCfwdAllwCrGrp/PassiveActivityCrAfterLmtAmt'),
  (542173, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8834PartICYCfwdAllwCrGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / Frm8847 CY Cfwd Allw Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54180, 54, '181', 'Frm8847 CY Cfwd Allw Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542174, 54180, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (542175, 54180, '2', 'ESBC Carryforward Amt', 'CURRENCY'),
  (542176, 54180, '3', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (542177, 54180, '4', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (542178, 54180, '5', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (542179, 54180, '6', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (542180, 54180, '7', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (542181, 54180, '8', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (542182, 54180, '9', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542174, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8847CYCfwdAllwCrGrp/CYGeneralBusCrCarryforwardAmt'),
  (542175, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8847CYCfwdAllwCrGrp/ESBCCarryforwardAmt'),
  (542176, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8847CYCfwdAllwCrGrp/CarryforwardGeneralBusCrAmt'),
  (542177, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8847CYCfwdAllwCrGrp/CrSubjToPassiveActyLmtAmt'),
  (542178, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm8847CYCfwdAllwCrGrp/CyovGeneralBusinessCrItemCnt'),
  (542179, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8847CYCfwdAllwCrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (542180, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8847CYCfwdAllwCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (542181, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8847CYCfwdAllwCrGrp/PassiveActivityCrAfterLmtAmt'),
  (542182, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8847CYCfwdAllwCrGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / Frm8861 CY Cfwd Allw Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54181, 54, '182', 'Frm8861 CY Cfwd Allw Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542183, 54181, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (542184, 54181, '2', 'ESBC Carryforward Amt', 'CURRENCY'),
  (542185, 54181, '3', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (542186, 54181, '4', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (542187, 54181, '5', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (542188, 54181, '6', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (542189, 54181, '7', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (542190, 54181, '8', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (542191, 54181, '9', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542183, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8861CYCfwdAllwCrGrp/CYGeneralBusCrCarryforwardAmt'),
  (542184, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8861CYCfwdAllwCrGrp/ESBCCarryforwardAmt'),
  (542185, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8861CYCfwdAllwCrGrp/CarryforwardGeneralBusCrAmt'),
  (542186, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8861CYCfwdAllwCrGrp/CrSubjToPassiveActyLmtAmt'),
  (542187, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm8861CYCfwdAllwCrGrp/CyovGeneralBusinessCrItemCnt'),
  (542188, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8861CYCfwdAllwCrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (542189, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8861CYCfwdAllwCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (542190, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8861CYCfwdAllwCrGrp/PassiveActivityCrAfterLmtAmt'),
  (542191, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8861CYCfwdAllwCrGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / Frm8864 SAFCY Cyov Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54182, 54, '183', 'Frm8864 SAFCY Cyov Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542192, 54182, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (542193, 54182, '2', 'Carry Back General Business Cr Amt', 'CURRENCY'),
  (542194, 54182, '3', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (542195, 54182, '4', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (542196, 54182, '5', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (542197, 54182, '6', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (542198, 54182, '7', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (542199, 54182, '8', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (542200, 54182, '9', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542192, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8864SAFCYCyovCrGrp/CYGeneralBusCrCarryforwardAmt'),
  (542193, NULL, NULL, 'Carry Back General Business Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8864SAFCYCyovCrGrp/CarryBackGeneralBusinessCrAmt'),
  (542194, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8864SAFCYCyovCrGrp/CarryforwardGeneralBusCrAmt'),
  (542195, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8864SAFCYCyovCrGrp/CrSubjToPassiveActyLmtAmt'),
  (542196, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm8864SAFCYCyovCrGrp/CyovGeneralBusinessCrItemCnt'),
  (542197, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8864SAFCYCyovCrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (542198, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8864SAFCYCyovCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (542199, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8864SAFCYCyovCrGrp/PassiveActivityCrAfterLmtAmt'),
  (542200, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8864SAFCYCyovCrGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / Frm8881 Part IICY Cyov Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54183, 54, '184', 'Frm8881 Part IICY Cyov Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542201, 54183, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (542202, 54183, '2', 'Carry Back General Business Cr Amt', 'CURRENCY'),
  (542203, 54183, '3', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (542204, 54183, '4', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (542205, 54183, '5', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (542206, 54183, '6', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (542207, 54183, '7', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (542208, 54183, '8', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (542209, 54183, '9', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542201, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8881PartIICYCyovCrGrp/CYGeneralBusCrCarryforwardAmt'),
  (542202, NULL, NULL, 'Carry Back General Business Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8881PartIICYCyovCrGrp/CarryBackGeneralBusinessCrAmt'),
  (542203, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8881PartIICYCyovCrGrp/CarryforwardGeneralBusCrAmt'),
  (542204, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8881PartIICYCyovCrGrp/CrSubjToPassiveActyLmtAmt'),
  (542205, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm8881PartIICYCyovCrGrp/CyovGeneralBusinessCrItemCnt'),
  (542206, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8881PartIICYCyovCrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (542207, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8881PartIICYCyovCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (542208, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8881PartIICYCyovCrGrp/PassiveActivityCrAfterLmtAmt'),
  (542209, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8881PartIICYCyovCrGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / Frm8881 Part IIICY Cyov Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54184, 54, '185', 'Frm8881 Part IIICY Cyov Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542210, 54184, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (542211, 54184, '2', 'Carry Back General Business Cr Amt', 'CURRENCY'),
  (542212, 54184, '3', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (542213, 54184, '4', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (542214, 54184, '5', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (542215, 54184, '6', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (542216, 54184, '7', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (542217, 54184, '8', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (542218, 54184, '9', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542210, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8881PartIIICYCyovCrGrp/CYGeneralBusCrCarryforwardAmt'),
  (542211, NULL, NULL, 'Carry Back General Business Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8881PartIIICYCyovCrGrp/CarryBackGeneralBusinessCrAmt'),
  (542212, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8881PartIIICYCyovCrGrp/CarryforwardGeneralBusCrAmt'),
  (542213, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8881PartIIICYCyovCrGrp/CrSubjToPassiveActyLmtAmt'),
  (542214, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm8881PartIIICYCyovCrGrp/CyovGeneralBusinessCrItemCnt'),
  (542215, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8881PartIIICYCyovCrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (542216, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8881PartIIICYCyovCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (542217, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8881PartIIICYCyovCrGrp/PassiveActivityCrAfterLmtAmt'),
  (542218, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8881PartIIICYCyovCrGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / Frm8900 CY Cfwd Allw Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54185, 54, '186', 'Frm8900 CY Cfwd Allw Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542219, 54185, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (542220, 54185, '2', 'ESBC Carryforward Amt', 'CURRENCY'),
  (542221, 54185, '3', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (542222, 54185, '4', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (542223, 54185, '5', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (542224, 54185, '6', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (542225, 54185, '7', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (542226, 54185, '8', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (542227, 54185, '9', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542219, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8900CYCfwdAllwCrGrp/CYGeneralBusCrCarryforwardAmt'),
  (542220, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8900CYCfwdAllwCrGrp/ESBCCarryforwardAmt'),
  (542221, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8900CYCfwdAllwCrGrp/CarryforwardGeneralBusCrAmt'),
  (542222, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8900CYCfwdAllwCrGrp/CrSubjToPassiveActyLmtAmt'),
  (542223, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm8900CYCfwdAllwCrGrp/CyovGeneralBusinessCrItemCnt'),
  (542224, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8900CYCfwdAllwCrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (542225, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8900CYCfwdAllwCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (542226, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8900CYCfwdAllwCrGrp/PassiveActivityCrAfterLmtAmt'),
  (542227, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8900CYCfwdAllwCrGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / Frm8907 CY Cfwd Allw Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54186, 54, '187', 'Frm8907 CY Cfwd Allw Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542228, 54186, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (542229, 54186, '2', 'ESBC Carryforward Amt', 'CURRENCY'),
  (542230, 54186, '3', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (542231, 54186, '4', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (542232, 54186, '5', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (542233, 54186, '6', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (542234, 54186, '7', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (542235, 54186, '8', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (542236, 54186, '9', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542228, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8907CYCfwdAllwCrGrp/CYGeneralBusCrCarryforwardAmt'),
  (542229, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8907CYCfwdAllwCrGrp/ESBCCarryforwardAmt'),
  (542230, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8907CYCfwdAllwCrGrp/CarryforwardGeneralBusCrAmt'),
  (542231, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8907CYCfwdAllwCrGrp/CrSubjToPassiveActyLmtAmt'),
  (542232, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm8907CYCfwdAllwCrGrp/CyovGeneralBusinessCrItemCnt'),
  (542233, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8907CYCfwdAllwCrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (542234, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8907CYCfwdAllwCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (542235, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8907CYCfwdAllwCrGrp/PassiveActivityCrAfterLmtAmt'),
  (542236, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8907CYCfwdAllwCrGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / Frm8909 CY Cfwd Allw Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54187, 54, '188', 'Frm8909 CY Cfwd Allw Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542237, 54187, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (542238, 54187, '2', 'ESBC Carryforward Amt', 'CURRENCY'),
  (542239, 54187, '3', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (542240, 54187, '4', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (542241, 54187, '5', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (542242, 54187, '6', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (542243, 54187, '7', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (542244, 54187, '8', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (542245, 54187, '9', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542237, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8909CYCfwdAllwCrGrp/CYGeneralBusCrCarryforwardAmt'),
  (542238, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8909CYCfwdAllwCrGrp/ESBCCarryforwardAmt'),
  (542239, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8909CYCfwdAllwCrGrp/CarryforwardGeneralBusCrAmt'),
  (542240, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8909CYCfwdAllwCrGrp/CrSubjToPassiveActyLmtAmt'),
  (542241, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm8909CYCfwdAllwCrGrp/CyovGeneralBusinessCrItemCnt'),
  (542242, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8909CYCfwdAllwCrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (542243, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8909CYCfwdAllwCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (542244, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8909CYCfwdAllwCrGrp/PassiveActivityCrAfterLmtAmt'),
  (542245, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8909CYCfwdAllwCrGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / Frm8923 CY Cfwd Allw Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54188, 54, '189', 'Frm8923 CY Cfwd Allw Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542246, 54188, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (542247, 54188, '2', 'ESBC Carryforward Amt', 'CURRENCY'),
  (542248, 54188, '3', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (542249, 54188, '4', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (542250, 54188, '5', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (542251, 54188, '6', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (542252, 54188, '7', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (542253, 54188, '8', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (542254, 54188, '9', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542246, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8923CYCfwdAllwCrGrp/CYGeneralBusCrCarryforwardAmt'),
  (542247, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8923CYCfwdAllwCrGrp/ESBCCarryforwardAmt'),
  (542248, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8923CYCfwdAllwCrGrp/CarryforwardGeneralBusCrAmt'),
  (542249, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8923CYCfwdAllwCrGrp/CrSubjToPassiveActyLmtAmt'),
  (542250, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm8923CYCfwdAllwCrGrp/CyovGeneralBusinessCrItemCnt'),
  (542251, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8923CYCfwdAllwCrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (542252, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8923CYCfwdAllwCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (542253, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8923CYCfwdAllwCrGrp/PassiveActivityCrAfterLmtAmt'),
  (542254, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8923CYCfwdAllwCrGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / Frm8931 CY Cfwd Allw Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54189, 54, '190', 'Frm8931 CY Cfwd Allw Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542255, 54189, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (542256, 54189, '2', 'ESBC Carryforward Amt', 'CURRENCY'),
  (542257, 54189, '3', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (542258, 54189, '4', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (542259, 54189, '5', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (542260, 54189, '6', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (542261, 54189, '7', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (542262, 54189, '8', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (542263, 54189, '9', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542255, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8931CYCfwdAllwCrGrp/CYGeneralBusCrCarryforwardAmt'),
  (542256, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8931CYCfwdAllwCrGrp/ESBCCarryforwardAmt'),
  (542257, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8931CYCfwdAllwCrGrp/CarryforwardGeneralBusCrAmt'),
  (542258, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8931CYCfwdAllwCrGrp/CrSubjToPassiveActyLmtAmt'),
  (542259, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm8931CYCfwdAllwCrGrp/CyovGeneralBusinessCrItemCnt'),
  (542260, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8931CYCfwdAllwCrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (542261, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8931CYCfwdAllwCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (542262, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8931CYCfwdAllwCrGrp/PassiveActivityCrAfterLmtAmt'),
  (542263, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8931CYCfwdAllwCrGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / Frm8936 Part IICY Cyov Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54190, 54, '191', 'Frm8936 Part IICY Cyov Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542264, 54190, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (542265, 54190, '2', 'Carry Back General Business Cr Amt', 'CURRENCY'),
  (542266, 54190, '3', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (542267, 54190, '4', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (542268, 54190, '5', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (542269, 54190, '6', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (542270, 54190, '7', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (542271, 54190, '8', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (542272, 54190, '9', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542264, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8936PartIICYCyovCrGrp/CYGeneralBusCrCarryforwardAmt'),
  (542265, NULL, NULL, 'Carry Back General Business Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8936PartIICYCyovCrGrp/CarryBackGeneralBusinessCrAmt'),
  (542266, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8936PartIICYCyovCrGrp/CarryforwardGeneralBusCrAmt'),
  (542267, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8936PartIICYCyovCrGrp/CrSubjToPassiveActyLmtAmt'),
  (542268, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm8936PartIICYCyovCrGrp/CyovGeneralBusinessCrItemCnt'),
  (542269, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8936PartIICYCyovCrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (542270, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8936PartIICYCyovCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (542271, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8936PartIICYCyovCrGrp/PassiveActivityCrAfterLmtAmt'),
  (542272, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8936PartIICYCyovCrGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / Frm8942 CY Cfwd Allw Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54191, 54, '192', 'Frm8942 CY Cfwd Allw Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542273, 54191, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (542274, 54191, '2', 'ESBC Carryforward Amt', 'CURRENCY'),
  (542275, 54191, '3', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (542276, 54191, '4', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (542277, 54191, '5', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (542278, 54191, '6', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (542279, 54191, '7', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (542280, 54191, '8', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (542281, 54191, '9', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542273, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8942CYCfwdAllwCrGrp/CYGeneralBusCrCarryforwardAmt'),
  (542274, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8942CYCfwdAllwCrGrp/ESBCCarryforwardAmt'),
  (542275, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8942CYCfwdAllwCrGrp/CarryforwardGeneralBusCrAmt'),
  (542276, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8942CYCfwdAllwCrGrp/CrSubjToPassiveActyLmtAmt'),
  (542277, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm8942CYCfwdAllwCrGrp/CyovGeneralBusinessCrItemCnt'),
  (542278, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8942CYCfwdAllwCrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (542279, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8942CYCfwdAllwCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (542280, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8942CYCfwdAllwCrGrp/PassiveActivityCrAfterLmtAmt'),
  (542281, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8942CYCfwdAllwCrGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / Off Hwy Bus Use Gasoline Gals Qty
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54192, 54, '193', 'Off Hwy Bus Use Gasoline Gals Qty');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542282, 54192, '1', 'Off Hwy Bus Use Gasoline Gals Qty', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542282, NULL, NULL, 'Off Hwy Bus Use Gasoline Gals Qty', 'TEXT', 'ReturnData/IRS4136/OffHwyBusUseGasolineGalsQty');

-- 990T / Frm8846 CY Cfwd Allw Cr Aggrgt Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54193, 54, '194', 'Frm8846 CY Cfwd Allw Cr Aggrgt Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542283, 54193, '1', 'Yr', 'TEXT'),
  (542284, 54193, '2', 'Pass Through Entity EIN', 'TEXT'),
  (542285, 54193, '3', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (542286, 54193, '4', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (542287, 54193, '5', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (542288, 54193, '6', 'Total General Bus Credits App Tx Amt', 'CURRENCY'),
  (542289, 54193, '7', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (542290, 54193, '8', 'Nonpassive Ind', 'BOOLEAN');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542283, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/Frm8846CYCfwdAllwCrAggrgtGrp/Yr'),
  (542284, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Frm8846CYCfwdAllwCrAggrgtGrp/PassThroughEntityEIN'),
  (542285, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8846CYCfwdAllwCrAggrgtGrp/CarryforwardGeneralBusCrAmt'),
  (542286, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8846CYCfwdAllwCrAggrgtGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (542287, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8846CYCfwdAllwCrAggrgtGrp/GeneralBusCrFromNnPssvActyAmt'),
  (542288, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8846CYCfwdAllwCrAggrgtGrp/TotalGeneralBusCreditsAppTxAmt'),
  (542289, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8846CYCfwdAllwCrAggrgtGrp/CYGeneralBusCrCarryforwardAmt'),
  (542290, NULL, NULL, 'Nonpassive Ind', 'BOOLEAN', 'ReturnData/IRS3800/Frm8846CYCfwdAllwCrAggrgtGrp/NonpassiveInd');

-- 990T / Frm8844 CY Cyov Cr Aggrgt Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54194, 54, '195', 'Frm8844 CY Cyov Cr Aggrgt Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542291, 54194, '1', 'Yr', 'TEXT'),
  (542292, 54194, '2', 'Pass Through Entity EIN', 'TEXT'),
  (542293, 54194, '3', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (542294, 54194, '4', 'Nonpassive Ind', 'BOOLEAN'),
  (542295, 54194, '5', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (542296, 54194, '6', 'ESBC Carryforward Amt', 'CURRENCY'),
  (542297, 54194, '7', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (542298, 54194, '8', 'Passive Activity Cr After Lmt Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542291, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/Frm8844CYCyovCrAggrgtGrp/Yr'),
  (542292, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Frm8844CYCyovCrAggrgtGrp/PassThroughEntityEIN'),
  (542293, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8844CYCyovCrAggrgtGrp/CYGeneralBusCrCarryforwardAmt'),
  (542294, NULL, NULL, 'Nonpassive Ind', 'BOOLEAN', 'ReturnData/IRS3800/Frm8844CYCyovCrAggrgtGrp/NonpassiveInd'),
  (542295, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8844CYCyovCrAggrgtGrp/CarryforwardGeneralBusCrAmt'),
  (542296, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8844CYCyovCrAggrgtGrp/ESBCCarryforwardAmt'),
  (542297, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8844CYCyovCrAggrgtGrp/GeneralBusCrFromNnPssvActyAmt'),
  (542298, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8844CYCyovCrAggrgtGrp/PassiveActivityCrAfterLmtAmt');

-- 990T / Frm8908 CY Cyov Cr Aggrgt Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54195, 54, '196', 'Frm8908 CY Cyov Cr Aggrgt Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542299, 54195, '1', 'Yr', 'TEXT'),
  (542300, 54195, '2', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (542301, 54195, '3', 'Pass Through Entity EIN', 'TEXT'),
  (542302, 54195, '4', 'Nonpassive Ind', 'BOOLEAN'),
  (542303, 54195, '5', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (542304, 54195, '6', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542299, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/Frm8908CYCyovCrAggrgtGrp/Yr'),
  (542300, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8908CYCyovCrAggrgtGrp/CYGeneralBusCrCarryforwardAmt'),
  (542301, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Frm8908CYCyovCrAggrgtGrp/PassThroughEntityEIN'),
  (542302, NULL, NULL, 'Nonpassive Ind', 'BOOLEAN', 'ReturnData/IRS3800/Frm8908CYCyovCrAggrgtGrp/NonpassiveInd'),
  (542303, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8908CYCyovCrAggrgtGrp/CarryforwardGeneralBusCrAmt'),
  (542304, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8908CYCyovCrAggrgtGrp/GeneralBusCrFromNnPssvActyAmt');

-- 990T / Frm8586 CY Spcfd Cr Aggrgt Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54196, 54, '197', 'Frm8586 CY Spcfd Cr Aggrgt Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542305, 54196, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (542306, 54196, '2', 'Yr', 'TEXT'),
  (542307, 54196, '3', 'Pass Through Entity EIN', 'TEXT'),
  (542308, 54196, '4', 'Nonpassive Ind', 'BOOLEAN'),
  (542309, 54196, '5', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (542310, 54196, '6', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (542311, 54196, '7', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542305, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8586CYSpcfdCrAggrgtGrp/CYGeneralBusCrCarryforwardAmt'),
  (542306, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/Frm8586CYSpcfdCrAggrgtGrp/Yr'),
  (542307, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Frm8586CYSpcfdCrAggrgtGrp/PassThroughEntityEIN'),
  (542308, NULL, NULL, 'Nonpassive Ind', 'BOOLEAN', 'ReturnData/IRS3800/Frm8586CYSpcfdCrAggrgtGrp/NonpassiveInd'),
  (542309, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8586CYSpcfdCrAggrgtGrp/CarryforwardGeneralBusCrAmt'),
  (542310, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8586CYSpcfdCrAggrgtGrp/CrSubjToPassiveActyLmtAmt'),
  (542311, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8586CYSpcfdCrAggrgtGrp/GeneralBusCrFromNnPssvActyAmt');

-- 990T / Less Than Half Business Use Prop
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54197, 54, '198', 'Less Than Half Business Use Prop');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542312, 54197, '1', 'Property Desc', 'TEXT'),
  (542313, 54197, '2', 'Placed In Service Dt', 'TEXT'),
  (542314, 54197, '3', 'Recovery Prd', 'TEXT'),
  (542315, 54197, '4', 'Basis For Depreciation Amt', 'CURRENCY'),
  (542316, 54197, '5', 'Business Investment Use Pct', 'PERCENT'),
  (542317, 54197, '6', 'Cost Or Other Basis Amt', 'CURRENCY'),
  (542318, 54197, '7', 'Depreciation Convention And Pre Cd', 'TEXT'),
  (542319, 54197, '8', 'Depreciation Deduction Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542312, NULL, NULL, 'Property Desc', 'TEXT', 'ReturnData/IRS4562/LessThanHalfBusinessUseProp/PropertyDesc'),
  (542313, NULL, NULL, 'Placed In Service Dt', 'TEXT', 'ReturnData/IRS4562/LessThanHalfBusinessUseProp/PlacedInServiceDt'),
  (542314, NULL, NULL, 'Recovery Prd', 'TEXT', 'ReturnData/IRS4562/LessThanHalfBusinessUseProp/RecoveryPrd'),
  (542315, NULL, NULL, 'Basis For Depreciation Amt', 'CURRENCY', 'ReturnData/IRS4562/LessThanHalfBusinessUseProp/BasisForDepreciationAmt'),
  (542316, NULL, NULL, 'Business Investment Use Pct', 'PERCENT', 'ReturnData/IRS4562/LessThanHalfBusinessUseProp/BusinessInvestmentUsePct'),
  (542317, NULL, NULL, 'Cost Or Other Basis Amt', 'CURRENCY', 'ReturnData/IRS4562/LessThanHalfBusinessUseProp/CostOrOtherBasisAmt'),
  (542318, NULL, NULL, 'Depreciation Convention And Pre Cd', 'TEXT', 'ReturnData/IRS4562/LessThanHalfBusinessUseProp/DepreciationConventionAndPreCd'),
  (542319, NULL, NULL, 'Depreciation Deduction Amt', 'CURRENCY', 'ReturnData/IRS4562/LessThanHalfBusinessUseProp/DepreciationDeductionAmt');

-- 990T / Total STCGL1099 B Bss Rpt No Adj Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54198, 54, '199', 'Total STCGL1099 B Bss Rpt No Adj Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542320, 54198, '1', 'Total Gain Or Loss Amt', 'CURRENCY'),
  (542321, 54198, '2', 'Total Cost Or Other Basis Amt', 'CURRENCY'),
  (542322, 54198, '3', 'Total Proceeds Sales Price Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542320, NULL, NULL, 'Total Gain Or Loss Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/TotalSTCGL1099BBssRptNoAdjGrp/TotalGainOrLossAmt'),
  (542321, NULL, NULL, 'Total Cost Or Other Basis Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/TotalSTCGL1099BBssRptNoAdjGrp/TotalCostOrOtherBasisAmt'),
  (542322, NULL, NULL, 'Total Proceeds Sales Price Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/TotalSTCGL1099BBssRptNoAdjGrp/TotalProceedsSalesPriceAmt');

-- 990T / Shareholder Business Name
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54199, 54, '200', 'Shareholder Business Name');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542323, 54199, '1', 'Business Name Line1 Txt', 'TEXT'),
  (542324, 54199, '2', 'Business Name Line2 Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542323, NULL, NULL, 'Business Name Line1 Txt', 'TEXT', 'ReturnData/IRS2439/ShareholderBusinessName/BusinessNameLine1Txt'),
  (542324, NULL, NULL, 'Business Name Line2 Txt', 'TEXT', 'ReturnData/IRS2439/ShareholderBusinessName/BusinessNameLine2Txt');

-- 990T / Frm5884 ACY Cfwd Allw Cr Aggrgt Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54200, 54, '201', 'Frm5884 ACY Cfwd Allw Cr Aggrgt Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542325, 54200, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (542326, 54200, '2', 'Yr', 'TEXT'),
  (542327, 54200, '3', 'Nonpassive Ind', 'BOOLEAN'),
  (542328, 54200, '4', 'Pass Through Entity EIN', 'TEXT'),
  (542329, 54200, '5', 'Carryforward General Bus Cr Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542325, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm5884ACYCfwdAllwCrAggrgtGrp/CYGeneralBusCrCarryforwardAmt'),
  (542326, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/Frm5884ACYCfwdAllwCrAggrgtGrp/Yr'),
  (542327, NULL, NULL, 'Nonpassive Ind', 'BOOLEAN', 'ReturnData/IRS3800/Frm5884ACYCfwdAllwCrAggrgtGrp/NonpassiveInd'),
  (542328, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Frm5884ACYCfwdAllwCrAggrgtGrp/PassThroughEntityEIN'),
  (542329, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm5884ACYCfwdAllwCrAggrgtGrp/CarryforwardGeneralBusCrAmt');

-- 990T / Frm8835 Part IICY Cyov Cr Aggrgt Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54201, 54, '202', 'Frm8835 Part IICY Cyov Cr Aggrgt Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542330, 54201, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (542331, 54201, '2', 'Yr', 'TEXT'),
  (542332, 54201, '3', 'Nonpassive Ind', 'BOOLEAN'),
  (542333, 54201, '4', 'Pass Through Entity EIN', 'TEXT'),
  (542334, 54201, '5', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (542335, 54201, '6', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542330, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8835PartIICYCyovCrAggrgtGrp/CYGeneralBusCrCarryforwardAmt'),
  (542331, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/Frm8835PartIICYCyovCrAggrgtGrp/Yr'),
  (542332, NULL, NULL, 'Nonpassive Ind', 'BOOLEAN', 'ReturnData/IRS3800/Frm8835PartIICYCyovCrAggrgtGrp/NonpassiveInd'),
  (542333, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Frm8835PartIICYCyovCrAggrgtGrp/PassThroughEntityEIN'),
  (542334, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8835PartIICYCyovCrAggrgtGrp/CarryforwardGeneralBusCrAmt'),
  (542335, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8835PartIICYCyovCrAggrgtGrp/GeneralBusCrFromNnPssvActyAmt');

-- 990T / Frm5884 CY Spcfd Cr Aggrgt Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54202, 54, '203', 'Frm5884 CY Spcfd Cr Aggrgt Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542336, 54202, '1', 'Yr', 'TEXT'),
  (542337, 54202, '2', 'Pass Through Entity EIN', 'TEXT'),
  (542338, 54202, '3', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (542339, 54202, '4', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (542340, 54202, '5', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (542341, 54202, '6', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542336, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/Frm5884CYSpcfdCrAggrgtGrp/Yr'),
  (542337, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Frm5884CYSpcfdCrAggrgtGrp/PassThroughEntityEIN'),
  (542338, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm5884CYSpcfdCrAggrgtGrp/CYGeneralBusCrCarryforwardAmt'),
  (542339, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm5884CYSpcfdCrAggrgtGrp/CarryforwardGeneralBusCrAmt'),
  (542340, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm5884CYSpcfdCrAggrgtGrp/GeneralBusCrFromNnPssvActyAmt'),
  (542341, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm5884CYSpcfdCrAggrgtGrp/CrSubjToPassiveActyLmtAmt');

-- 990T / Total STCGL1099 B Not Show Basis Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54203, 54, '204', 'Total STCGL1099 B Not Show Basis Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542342, 54203, '1', 'Total Gain Or Loss Amt', 'CURRENCY'),
  (542343, 54203, '2', 'Total Proceeds Sales Price Amt', 'CURRENCY'),
  (542344, 54203, '3', 'Total Cost Or Other Basis Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542342, NULL, NULL, 'Total Gain Or Loss Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/TotalSTCGL1099BNotShowBasisGrp/TotalGainOrLossAmt'),
  (542343, NULL, NULL, 'Total Proceeds Sales Price Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/TotalSTCGL1099BNotShowBasisGrp/TotalProceedsSalesPriceAmt'),
  (542344, NULL, NULL, 'Total Cost Or Other Basis Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/TotalSTCGL1099BNotShowBasisGrp/TotalCostOrOtherBasisAmt');

-- 990T / CY Cyov Other Bus Credits Aggrgt Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54204, 54, '205', 'CY Cyov Other Bus Credits Aggrgt Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542345, 54204, '1', 'Yr', 'TEXT'),
  (542346, 54204, '2', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (542347, 54204, '3', 'Pass Through Entity EIN', 'TEXT'),
  (542348, 54204, '4', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (542349, 54204, '5', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (542350, 54204, '6', 'Nonpassive Ind', 'BOOLEAN');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542345, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/CYCyovOtherBusCreditsAggrgtGrp/Yr'),
  (542346, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCyovOtherBusCreditsAggrgtGrp/CYGeneralBusCrCarryforwardAmt'),
  (542347, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/CYCyovOtherBusCreditsAggrgtGrp/PassThroughEntityEIN'),
  (542348, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCyovOtherBusCreditsAggrgtGrp/CarryforwardGeneralBusCrAmt'),
  (542349, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCyovOtherBusCreditsAggrgtGrp/GeneralBusCrFromNnPssvActyAmt'),
  (542350, NULL, NULL, 'Nonpassive Ind', 'BOOLEAN', 'ReturnData/IRS3800/CYCyovOtherBusCreditsAggrgtGrp/NonpassiveInd');

-- 990T / CY Other Spcfd Credits Aggrgt Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54205, 54, '206', 'CY Other Spcfd Credits Aggrgt Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542351, 54205, '1', 'Pass Through Entity EIN', 'TEXT'),
  (542352, 54205, '2', 'Yr', 'TEXT'),
  (542353, 54205, '3', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (542354, 54205, '4', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (542355, 54205, '5', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (542356, 54205, '6', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (542357, 54205, '7', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542351, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/CYOtherSpcfdCreditsAggrgtGrp/PassThroughEntityEIN'),
  (542352, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/CYOtherSpcfdCreditsAggrgtGrp/Yr'),
  (542353, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/CYOtherSpcfdCreditsAggrgtGrp/CYGeneralBusCrCarryforwardAmt'),
  (542354, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/CYOtherSpcfdCreditsAggrgtGrp/CarryforwardGeneralBusCrAmt'),
  (542355, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/CYOtherSpcfdCreditsAggrgtGrp/CrSubjToPassiveActyLmtAmt'),
  (542356, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/CYOtherSpcfdCreditsAggrgtGrp/PassiveActivityCrAfterLmtAmt'),
  (542357, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/CYOtherSpcfdCreditsAggrgtGrp/GeneralBusCrFromNnPssvActyAmt');

-- 990T / Reg Invst Co Or Re Invst Trust Name
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54206, 54, '207', 'Reg Invst Co Or Re Invst Trust Name');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542358, 54206, '1', 'Business Name Line1 Txt', 'TEXT'),
  (542359, 54206, '2', 'Business Name Line2 Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542358, NULL, NULL, 'Business Name Line1 Txt', 'TEXT', 'ReturnData/IRS2439/RegInvstCoOrReInvstTrustName/BusinessNameLine1Txt'),
  (542359, NULL, NULL, 'Business Name Line2 Txt', 'TEXT', 'ReturnData/IRS2439/RegInvstCoOrReInvstTrustName/BusinessNameLine2Txt');

-- 990T / Beneficiaries Cap Gain Or Loss Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54207, 54, '208', 'Beneficiaries Cap Gain Or Loss Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542360, 54207, '1', 'Total Net Gain Or Loss Amt', 'CURRENCY'),
  (542361, 54207, '2', 'Unrecaptured Section1250 Gain Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542360, NULL, NULL, 'Total Net Gain Or Loss Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/BeneficiariesCapGainOrLossGrp/TotalNetGainOrLossAmt'),
  (542361, NULL, NULL, 'Unrecaptured Section1250 Gain Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/BeneficiariesCapGainOrLossGrp/NetLongTermGainOrLossGrp/UnrecapturedSection1250GainAmt');

-- 990T / Form3468 Part VCY Credits Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54208, 54, '209', 'Form3468 Part VCY Credits Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542362, 54208, '1', 'Elective Payment Registration Num', 'INTEGER'),
  (542363, 54208, '2', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (542364, 54208, '3', 'Gross Elective Pymt Election Amt', 'CURRENCY'),
  (542365, 54208, '4', 'Net Elective Pymt Election Amt', 'CURRENCY'),
  (542366, 54208, '5', 'Total General Bus Credits Amt', 'CURRENCY'),
  (542367, 54208, '6', 'Total General Bus Credits App Tx Amt', 'CURRENCY'),
  (542368, 54208, '7', 'CY General Business Cr Item Cnt', 'INTEGER'),
  (542369, 54208, '8', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (542370, 54208, '9', 'Credit Transfer Election Amt', 'CURRENCY'),
  (542371, 54208, '10', 'Pass Through Entity EIN', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542362, NULL, NULL, 'Elective Payment Registration Num', 'INTEGER', 'ReturnData/IRS3800/Form3468PartVCYCreditsGrp/ElectivePaymentRegistrationNum'),
  (542363, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Form3468PartVCYCreditsGrp/GeneralBusCrFromNnPssvActyAmt'),
  (542364, NULL, NULL, 'Gross Elective Pymt Election Amt', 'CURRENCY', 'ReturnData/IRS3800/Form3468PartVCYCreditsGrp/GrossElectivePymtElectionAmt'),
  (542365, NULL, NULL, 'Net Elective Pymt Election Amt', 'CURRENCY', 'ReturnData/IRS3800/Form3468PartVCYCreditsGrp/NetElectivePymtElectionAmt'),
  (542366, NULL, NULL, 'Total General Bus Credits Amt', 'CURRENCY', 'ReturnData/IRS3800/Form3468PartVCYCreditsGrp/TotalGeneralBusCreditsAmt'),
  (542367, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Form3468PartVCYCreditsGrp/TotalGeneralBusCreditsAppTxAmt'),
  (542368, NULL, NULL, 'CY General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Form3468PartVCYCreditsGrp/CYGeneralBusinessCrItemCnt'),
  (542369, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Form3468PartVCYCreditsGrp/CrSubjToPassiveActyLmtAmt'),
  (542370, NULL, NULL, 'Credit Transfer Election Amt', 'CURRENCY', 'ReturnData/IRS3800/Form3468PartVCYCreditsGrp/CreditTransferElectionAmt'),
  (542371, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Form3468PartVCYCreditsGrp/PassThroughEntityEIN');

-- 990T / Total LTCGL1099 B Bss Rpt No Adj Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54209, 54, '210', 'Total LTCGL1099 B Bss Rpt No Adj Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542372, 54209, '1', 'Total Gain Or Loss Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542372, NULL, NULL, 'Total Gain Or Loss Amt', 'CURRENCY', 'ReturnData/IRS1041ScheduleD/TotalLTCGL1099BBssRptNoAdjGrp/TotalGainOrLossAmt');

-- 990T / Frm8994 CY Spcfd Cr Aggrgt Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54210, 54, '211', 'Frm8994 CY Spcfd Cr Aggrgt Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542373, 54210, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (542374, 54210, '2', 'Pass Through Entity EIN', 'TEXT'),
  (542375, 54210, '3', 'Yr', 'TEXT'),
  (542376, 54210, '4', 'Nonpassive Ind', 'BOOLEAN');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542373, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8994CYSpcfdCrAggrgtGrp/CYGeneralBusCrCarryforwardAmt'),
  (542374, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Frm8994CYSpcfdCrAggrgtGrp/PassThroughEntityEIN'),
  (542375, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/Frm8994CYSpcfdCrAggrgtGrp/Yr'),
  (542376, NULL, NULL, 'Nonpassive Ind', 'BOOLEAN', 'ReturnData/IRS3800/Frm8994CYSpcfdCrAggrgtGrp/NonpassiveInd');

-- 990T / CY Cfwd Allw Other Bus Cr Aggrgt Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54211, 54, '212', 'CY Cfwd Allw Other Bus Cr Aggrgt Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542377, 54211, '1', 'Yr', 'TEXT'),
  (542378, 54211, '2', 'Pass Through Entity EIN', 'TEXT'),
  (542379, 54211, '3', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (542380, 54211, '4', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (542381, 54211, '5', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (542382, 54211, '6', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (542383, 54211, '7', 'Nonpassive Ind', 'BOOLEAN'),
  (542384, 54211, '8', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542377, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/CYCfwdAllwOtherBusCrAggrgtGrp/Yr'),
  (542378, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/CYCfwdAllwOtherBusCrAggrgtGrp/PassThroughEntityEIN'),
  (542379, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCfwdAllwOtherBusCrAggrgtGrp/CYGeneralBusCrCarryforwardAmt'),
  (542380, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCfwdAllwOtherBusCrAggrgtGrp/CarryforwardGeneralBusCrAmt'),
  (542381, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCfwdAllwOtherBusCrAggrgtGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (542382, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCfwdAllwOtherBusCrAggrgtGrp/GeneralBusCrFromNnPssvActyAmt'),
  (542383, NULL, NULL, 'Nonpassive Ind', 'BOOLEAN', 'ReturnData/IRS3800/CYCfwdAllwOtherBusCrAggrgtGrp/NonpassiveInd'),
  (542384, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/CYCfwdAllwOtherBusCrAggrgtGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / Officer Dir Trst Comp Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54212, 54, '213', 'Officer Dir Trst Comp Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542385, 54212, '1', 'Business Name Line1 Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542385, NULL, NULL, 'Business Name Line1 Txt', 'TEXT', 'ReturnData/IRS990TScheduleA/OfficerDirTrstCompGrp/BusinessName/BusinessNameLine1Txt');

-- 990T / Aviation Nontx Use Gas Gals Qty
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54213, 54, '214', 'Aviation Nontx Use Gas Gals Qty');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542386, 54213, '1', 'Gallons Qty', 'TEXT'),
  (542387, 54213, '2', 'Nontaxable Use Of Fuel Type Cd', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542386, NULL, NULL, 'Gallons Qty', 'TEXT', 'ReturnData/IRS4136/AviationNontxUseGasGalsQty/GallonsQty'),
  (542387, NULL, NULL, 'Nontaxable Use Of Fuel Type Cd', 'TEXT', 'ReturnData/IRS4136/AviationNontxUseGasGalsQty/NontaxableUseOfFuelTypeCd');

-- 990T / Frm8830 CY Cyov Cr Aggrgt Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54214, 54, '215', 'Frm8830 CY Cyov Cr Aggrgt Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542388, 54214, '1', 'Yr', 'TEXT'),
  (542389, 54214, '2', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (542390, 54214, '3', 'Nonpassive Ind', 'BOOLEAN'),
  (542391, 54214, '4', 'Pass Through Entity EIN', 'TEXT'),
  (542392, 54214, '5', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (542393, 54214, '6', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542388, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/Frm8830CYCyovCrAggrgtGrp/Yr'),
  (542389, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8830CYCyovCrAggrgtGrp/CYGeneralBusCrCarryforwardAmt'),
  (542390, NULL, NULL, 'Nonpassive Ind', 'BOOLEAN', 'ReturnData/IRS3800/Frm8830CYCyovCrAggrgtGrp/NonpassiveInd'),
  (542391, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Frm8830CYCyovCrAggrgtGrp/PassThroughEntityEIN'),
  (542392, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8830CYCyovCrAggrgtGrp/CarryforwardGeneralBusCrAmt'),
  (542393, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8830CYCyovCrAggrgtGrp/GeneralBusCrFromNnPssvActyAmt');

-- 990T / Frm8835 CY Spcfd Cr Aggrgt Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54215, 54, '216', 'Frm8835 CY Spcfd Cr Aggrgt Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542394, 54215, '1', 'Yr', 'TEXT'),
  (542395, 54215, '2', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (542396, 54215, '3', 'Pass Through Entity EIN', 'TEXT'),
  (542397, 54215, '4', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (542398, 54215, '5', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (542399, 54215, '6', 'Nonpassive Ind', 'BOOLEAN'),
  (542400, 54215, '7', 'Passive Activity Cr After Lmt Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542394, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/Frm8835CYSpcfdCrAggrgtGrp/Yr'),
  (542395, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8835CYSpcfdCrAggrgtGrp/CYGeneralBusCrCarryforwardAmt'),
  (542396, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Frm8835CYSpcfdCrAggrgtGrp/PassThroughEntityEIN'),
  (542397, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8835CYSpcfdCrAggrgtGrp/CarryforwardGeneralBusCrAmt'),
  (542398, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8835CYSpcfdCrAggrgtGrp/GeneralBusCrFromNnPssvActyAmt'),
  (542399, NULL, NULL, 'Nonpassive Ind', 'BOOLEAN', 'ReturnData/IRS3800/Frm8835CYSpcfdCrAggrgtGrp/NonpassiveInd'),
  (542400, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8835CYSpcfdCrAggrgtGrp/PassiveActivityCrAfterLmtAmt');

-- 990T / Non Tx Krsn Used In Avn Txd244
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54216, 54, '217', 'Non Tx Krsn Used In Avn Txd244');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542401, 54216, '1', 'Gallons Qty', 'TEXT'),
  (542402, 54216, '2', 'Nontaxable Use Of Fuel Type Cd', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542401, NULL, NULL, 'Gallons Qty', 'TEXT', 'ReturnData/IRS4136/NonTxKrsnUsedInAvnTxd244/GallonsQty'),
  (542402, NULL, NULL, 'Nontaxable Use Of Fuel Type Cd', 'TEXT', 'ReturnData/IRS4136/NonTxKrsnUsedInAvnTxd244/NontaxableUseOfFuelTypeCd');

-- 990T / Frm8845 CY Cfwd Allw Cr Aggrgt Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54217, 54, '218', 'Frm8845 CY Cfwd Allw Cr Aggrgt Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542403, 54217, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (542404, 54217, '2', 'Yr', 'TEXT'),
  (542405, 54217, '3', 'Pass Through Entity EIN', 'TEXT'),
  (542406, 54217, '4', 'Nonpassive Ind', 'BOOLEAN');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542403, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8845CYCfwdAllwCrAggrgtGrp/CYGeneralBusCrCarryforwardAmt'),
  (542404, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/Frm8845CYCfwdAllwCrAggrgtGrp/Yr'),
  (542405, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Frm8845CYCfwdAllwCrAggrgtGrp/PassThroughEntityEIN'),
  (542406, NULL, NULL, 'Nonpassive Ind', 'BOOLEAN', 'ReturnData/IRS3800/Frm8845CYCfwdAllwCrAggrgtGrp/NonpassiveInd');

-- 990T / Frm8936 Part VCY Cyov Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54218, 54, '219', 'Frm8936 Part VCY Cyov Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542407, 54218, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (542408, 54218, '2', 'Carry Back General Business Cr Amt', 'CURRENCY'),
  (542409, 54218, '3', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (542410, 54218, '4', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (542411, 54218, '5', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (542412, 54218, '6', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (542413, 54218, '7', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (542414, 54218, '8', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (542415, 54218, '9', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542407, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8936PartVCYCyovCrGrp/CYGeneralBusCrCarryforwardAmt'),
  (542408, NULL, NULL, 'Carry Back General Business Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8936PartVCYCyovCrGrp/CarryBackGeneralBusinessCrAmt'),
  (542409, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8936PartVCYCyovCrGrp/CarryforwardGeneralBusCrAmt'),
  (542410, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8936PartVCYCyovCrGrp/CrSubjToPassiveActyLmtAmt'),
  (542411, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm8936PartVCYCyovCrGrp/CyovGeneralBusinessCrItemCnt'),
  (542412, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8936PartVCYCyovCrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (542413, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8936PartVCYCyovCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (542414, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8936PartVCYCyovCrGrp/PassiveActivityCrAfterLmtAmt'),
  (542415, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8936PartVCYCyovCrGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / ESCBCY Credits Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54219, 54, '220', 'ESCBCY Credits Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542416, 54219, '1', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (542417, 54219, '2', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (542418, 54219, '3', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (542419, 54219, '4', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (542420, 54219, '5', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (542421, 54219, '6', 'Pass Through Entity EIN', 'TEXT'),
  (542422, 54219, '7', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (542423, 54219, '8', 'Total General Bus Credits App Tx Amt', 'CURRENCY'),
  (542424, 54219, '9', 'Yr', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542416, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/ESCBCYCreditsGrp/CarryforwardGeneralBusCrAmt'),
  (542417, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/ESCBCYCreditsGrp/CyovGeneralBusinessCrItemCnt'),
  (542418, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/ESCBCYCreditsGrp/GeneralBusCrFromNnPssvActyAmt'),
  (542419, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/ESCBCYCreditsGrp/CrSubjToPassiveActyLmtAmt'),
  (542420, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/ESCBCYCreditsGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (542421, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/ESCBCYCreditsGrp/PassThroughEntityEIN'),
  (542422, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/ESCBCYCreditsGrp/PassiveActivityCrAfterLmtAmt'),
  (542423, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/ESCBCYCreditsGrp/TotalGeneralBusCreditsAppTxAmt'),
  (542424, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/ESCBCYCreditsGrp/Yr');

-- 990T / Frm3468 Part VICY Spfd Cr Aggrgt Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54220, 54, '221', 'Frm3468 Part VICY Spfd Cr Aggrgt Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542425, 54220, '1', 'Pass Through Entity EIN', 'TEXT'),
  (542426, 54220, '2', 'Yr', 'TEXT'),
  (542427, 54220, '3', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (542428, 54220, '4', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (542429, 54220, '5', 'ESBC Carryforward Amt', 'CURRENCY'),
  (542430, 54220, '6', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (542431, 54220, '7', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (542432, 54220, '8', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542425, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Frm3468PartVICYSpfdCrAggrgtGrp/PassThroughEntityEIN'),
  (542426, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/Frm3468PartVICYSpfdCrAggrgtGrp/Yr'),
  (542427, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm3468PartVICYSpfdCrAggrgtGrp/CYGeneralBusCrCarryforwardAmt'),
  (542428, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm3468PartVICYSpfdCrAggrgtGrp/CarryforwardGeneralBusCrAmt'),
  (542429, NULL, NULL, 'ESBC Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm3468PartVICYSpfdCrAggrgtGrp/ESBCCarryforwardAmt'),
  (542430, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm3468PartVICYSpfdCrAggrgtGrp/GeneralBusCrFromNnPssvActyAmt'),
  (542431, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm3468PartVICYSpfdCrAggrgtGrp/PassiveActivityCrAfterLmtAmt'),
  (542432, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm3468PartVICYSpfdCrAggrgtGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / Frm8586 CY Cfwd Allw Cr Aggrgt Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54221, 54, '222', 'Frm8586 CY Cfwd Allw Cr Aggrgt Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542433, 54221, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (542434, 54221, '2', 'Yr', 'TEXT'),
  (542435, 54221, '3', 'Nonpassive Ind', 'BOOLEAN'),
  (542436, 54221, '4', 'Pass Through Entity EIN', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542433, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8586CYCfwdAllwCrAggrgtGrp/CYGeneralBusCrCarryforwardAmt'),
  (542434, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/Frm8586CYCfwdAllwCrAggrgtGrp/Yr'),
  (542435, NULL, NULL, 'Nonpassive Ind', 'BOOLEAN', 'ReturnData/IRS3800/Frm8586CYCfwdAllwCrAggrgtGrp/NonpassiveInd'),
  (542436, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Frm8586CYCfwdAllwCrAggrgtGrp/PassThroughEntityEIN');

-- 990T / Non Tx Krsn Used In Avn Txd219
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54222, 54, '223', 'Non Tx Krsn Used In Avn Txd219');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542437, 54222, '1', 'Gallons Qty', 'TEXT'),
  (542438, 54222, '2', 'Nontaxable Use Of Fuel Type Cd', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542437, NULL, NULL, 'Gallons Qty', 'TEXT', 'ReturnData/IRS4136/NonTxKrsnUsedInAvnTxd219/GallonsQty'),
  (542438, NULL, NULL, 'Nontaxable Use Of Fuel Type Cd', 'TEXT', 'ReturnData/IRS4136/NonTxKrsnUsedInAvnTxd219/NontaxableUseOfFuelTypeCd');

-- 990T / Frm5884 CY Cfwd Allw Cr Aggrgt Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54223, 54, '224', 'Frm5884 CY Cfwd Allw Cr Aggrgt Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542439, 54223, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (542440, 54223, '2', 'Yr', 'TEXT'),
  (542441, 54223, '3', 'Pass Through Entity EIN', 'TEXT'),
  (542442, 54223, '4', 'Nonpassive Ind', 'BOOLEAN');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542439, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm5884CYCfwdAllwCrAggrgtGrp/CYGeneralBusCrCarryforwardAmt'),
  (542440, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/Frm5884CYCfwdAllwCrAggrgtGrp/Yr'),
  (542441, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Frm5884CYCfwdAllwCrAggrgtGrp/PassThroughEntityEIN'),
  (542442, NULL, NULL, 'Nonpassive Ind', 'BOOLEAN', 'ReturnData/IRS3800/Frm5884CYCfwdAllwCrAggrgtGrp/NonpassiveInd');

-- 990T / Frm8864 Bdsl CY Cyov Cr Aggrgt Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54224, 54, '225', 'Frm8864 Bdsl CY Cyov Cr Aggrgt Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542443, 54224, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (542444, 54224, '2', 'Nonpassive Ind', 'BOOLEAN'),
  (542445, 54224, '3', 'Pass Through Entity EIN', 'TEXT'),
  (542446, 54224, '4', 'Yr', 'TEXT'),
  (542447, 54224, '5', 'Carryforward General Bus Cr Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542443, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8864BdslCYCyovCrAggrgtGrp/CYGeneralBusCrCarryforwardAmt'),
  (542444, NULL, NULL, 'Nonpassive Ind', 'BOOLEAN', 'ReturnData/IRS3800/Frm8864BdslCYCyovCrAggrgtGrp/NonpassiveInd'),
  (542445, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Frm8864BdslCYCyovCrAggrgtGrp/PassThroughEntityEIN'),
  (542446, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/Frm8864BdslCYCyovCrAggrgtGrp/Yr'),
  (542447, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8864BdslCYCyovCrAggrgtGrp/CarryforwardGeneralBusCrAmt');

-- 990T / Frm8904 CY Cyov Cr Aggrgt Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54225, 54, '226', 'Frm8904 CY Cyov Cr Aggrgt Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542448, 54225, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (542449, 54225, '2', 'Nonpassive Ind', 'BOOLEAN'),
  (542450, 54225, '3', 'Pass Through Entity EIN', 'TEXT'),
  (542451, 54225, '4', 'Yr', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542448, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8904CYCyovCrAggrgtGrp/CYGeneralBusCrCarryforwardAmt'),
  (542449, NULL, NULL, 'Nonpassive Ind', 'BOOLEAN', 'ReturnData/IRS3800/Frm8904CYCyovCrAggrgtGrp/NonpassiveInd'),
  (542450, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Frm8904CYCyovCrAggrgtGrp/PassThroughEntityEIN'),
  (542451, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/Frm8904CYCyovCrAggrgtGrp/Yr');

-- 990T / Nontx Liquified Petroleum Gas
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54226, 54, '227', 'Nontx Liquified Petroleum Gas');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542452, 54226, '1', 'Gallons Qty', 'TEXT'),
  (542453, 54226, '2', 'Nontaxable Use Of Fuel Type Cd', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542452, NULL, NULL, 'Gallons Qty', 'TEXT', 'ReturnData/IRS4136/NontxLiquifiedPetroleumGas/GallonsQty'),
  (542453, NULL, NULL, 'Nontaxable Use Of Fuel Type Cd', 'TEXT', 'ReturnData/IRS4136/NontxLiquifiedPetroleumGas/NontaxableUseOfFuelTypeCd');

-- 990T / Frm3468 Part III Cyov Cr Aggrgt Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54227, 54, '228', 'Frm3468 Part III Cyov Cr Aggrgt Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542454, 54227, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (542455, 54227, '2', 'Nonpassive Ind', 'BOOLEAN'),
  (542456, 54227, '3', 'Pass Through Entity EIN', 'TEXT'),
  (542457, 54227, '4', 'Yr', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542454, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm3468PartIIICyovCrAggrgtGrp/CYGeneralBusCrCarryforwardAmt'),
  (542455, NULL, NULL, 'Nonpassive Ind', 'BOOLEAN', 'ReturnData/IRS3800/Frm3468PartIIICyovCrAggrgtGrp/NonpassiveInd'),
  (542456, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Frm3468PartIIICyovCrAggrgtGrp/PassThroughEntityEIN'),
  (542457, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/Frm3468PartIIICyovCrAggrgtGrp/Yr');

-- 990T / Frm8910 CY Cfwd Allw Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54228, 54, '229', 'Frm8910 CY Cfwd Allw Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542458, 54228, '1', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (542459, 54228, '2', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (542460, 54228, '3', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (542461, 54228, '4', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (542462, 54228, '5', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (542463, 54228, '6', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (542464, 54228, '7', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542458, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8910CYCfwdAllwCrGrp/CarryforwardGeneralBusCrAmt'),
  (542459, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8910CYCfwdAllwCrGrp/CrSubjToPassiveActyLmtAmt'),
  (542460, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm8910CYCfwdAllwCrGrp/CyovGeneralBusinessCrItemCnt'),
  (542461, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8910CYCfwdAllwCrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (542462, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8910CYCfwdAllwCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (542463, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8910CYCfwdAllwCrGrp/PassiveActivityCrAfterLmtAmt'),
  (542464, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8910CYCfwdAllwCrGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / Frm8911 CY Cyov Cr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54229, 54, '230', 'Frm8911 CY Cyov Cr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542465, 54229, '1', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (542466, 54229, '2', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (542467, 54229, '3', 'Cyov General Business Cr Item Cnt', 'INTEGER'),
  (542468, 54229, '4', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (542469, 54229, '5', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (542470, 54229, '6', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (542471, 54229, '7', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542465, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8911CYCyovCrGrp/CarryforwardGeneralBusCrAmt'),
  (542466, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8911CYCyovCrGrp/CrSubjToPassiveActyLmtAmt'),
  (542467, NULL, NULL, 'Cyov General Business Cr Item Cnt', 'INTEGER', 'ReturnData/IRS3800/Frm8911CYCyovCrGrp/CyovGeneralBusinessCrItemCnt'),
  (542468, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8911CYCyovCrGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (542469, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8911CYCyovCrGrp/GeneralBusCrFromNnPssvActyAmt'),
  (542470, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8911CYCyovCrGrp/PassiveActivityCrAfterLmtAmt'),
  (542471, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8911CYCyovCrGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / Frm6478 CY Spcfd Cr Aggrgt Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54230, 54, '231', 'Frm6478 CY Spcfd Cr Aggrgt Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542472, 54230, '1', 'Pass Through Entity EIN', 'TEXT'),
  (542473, 54230, '2', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (542474, 54230, '3', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (542475, 54230, '4', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (542476, 54230, '5', 'Yr', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542472, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Frm6478CYSpcfdCrAggrgtGrp/PassThroughEntityEIN'),
  (542473, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm6478CYSpcfdCrAggrgtGrp/CYGeneralBusCrCarryforwardAmt'),
  (542474, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm6478CYSpcfdCrAggrgtGrp/CarryforwardGeneralBusCrAmt'),
  (542475, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm6478CYSpcfdCrAggrgtGrp/PassiveActivityCrAfterLmtAmt'),
  (542476, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/Frm6478CYSpcfdCrAggrgtGrp/Yr');

-- 990T / Tot8844 GBC Or ESBC Aggrgt Amt Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54231, 54, '232', 'Tot8844 GBC Or ESBC Aggrgt Amt Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542477, 54231, '1', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (542478, 54231, '2', 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY'),
  (542479, 54231, '3', 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY'),
  (542480, 54231, '4', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (542481, 54231, '5', 'Passive Activity Cr After Lmt Amt', 'CURRENCY'),
  (542482, 54231, '6', 'Total General Bus Credits App Tx Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542477, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Tot8844GBCOrESBCAggrgtAmtGrp/CarryforwardGeneralBusCrAmt'),
  (542478, NULL, NULL, 'Cr Subj To Passive Acty Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Tot8844GBCOrESBCAggrgtAmtGrp/CrSubjToPassiveActyLmtAmt'),
  (542479, NULL, NULL, 'General Bus Cr Cyov Rcptr Adj Amt', 'CURRENCY', 'ReturnData/IRS3800/Tot8844GBCOrESBCAggrgtAmtGrp/GeneralBusCrCyovRcptrAdjAmt'),
  (542480, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Tot8844GBCOrESBCAggrgtAmtGrp/GeneralBusCrFromNnPssvActyAmt'),
  (542481, NULL, NULL, 'Passive Activity Cr After Lmt Amt', 'CURRENCY', 'ReturnData/IRS3800/Tot8844GBCOrESBCAggrgtAmtGrp/PassiveActivityCrAfterLmtAmt'),
  (542482, NULL, NULL, 'Total General Bus Credits App Tx Amt', 'CURRENCY', 'ReturnData/IRS3800/Tot8844GBCOrESBCAggrgtAmtGrp/TotalGeneralBusCreditsAppTxAmt');

-- 990T / Liquefied Petroleum Gas Gals Qty
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54232, 54, '233', 'Liquefied Petroleum Gas Gals Qty');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542483, 54232, '1', 'Liquefied Petroleum Gas Gals Qty', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542483, NULL, NULL, 'Liquefied Petroleum Gas Gals Qty', 'TEXT', 'ReturnData/IRS4136/LiquefiedPetroleumGasGalsQty');

-- 990T / Exp Nontx Aviation Gas Gals Qty
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54233, 54, '234', 'Exp Nontx Aviation Gas Gals Qty');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542484, 54233, '1', 'Exp Nontx Aviation Gas Gals Qty', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542484, NULL, NULL, 'Exp Nontx Aviation Gas Gals Qty', 'TEXT', 'ReturnData/IRS4136/ExpNontxAviationGasGalsQty');

-- 990T / Frm8911 Part IICY Cyov Cr Aggrgt Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54234, 54, '235', 'Frm8911 Part IICY Cyov Cr Aggrgt Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542485, 54234, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (542486, 54234, '2', 'Nonpassive Ind', 'BOOLEAN'),
  (542487, 54234, '3', 'Pass Through Entity EIN', 'TEXT'),
  (542488, 54234, '4', 'Yr', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542485, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8911PartIICYCyovCrAggrgtGrp/CYGeneralBusCrCarryforwardAmt'),
  (542486, NULL, NULL, 'Nonpassive Ind', 'BOOLEAN', 'ReturnData/IRS3800/Frm8911PartIICYCyovCrAggrgtGrp/NonpassiveInd'),
  (542487, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Frm8911PartIICYCyovCrAggrgtGrp/PassThroughEntityEIN'),
  (542488, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/Frm8911PartIICYCyovCrAggrgtGrp/Yr');

-- 990T / Farming Purposes Gasoline Gals Qty
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54235, 54, '236', 'Farming Purposes Gasoline Gals Qty');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542489, 54235, '1', 'Farming Purposes Gasoline Gals Qty', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542489, NULL, NULL, 'Farming Purposes Gasoline Gals Qty', 'TEXT', 'ReturnData/IRS4136/FarmingPurposesGasolineGalsQty');

-- 990T / Krsn Avn Sold St Local Govt Gals Qty
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54236, 54, '237', 'Krsn Avn Sold St Local Govt Gals Qty');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542490, 54236, '1', 'Krsn Avn Sold St Local Govt Gals Qty', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542490, NULL, NULL, 'Krsn Avn Sold St Local Govt Gals Qty', 'TEXT', 'ReturnData/IRS4136/KrsnAvnSoldStLocalGovtGalsQty');

-- 990T / Sls Undyed Krsn St Lcl Govt Gals Qty
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54237, 54, '238', 'Sls Undyed Krsn St Lcl Govt Gals Qty');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542491, 54237, '1', 'Sls Undyed Krsn St Lcl Govt Gals Qty', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542491, NULL, NULL, 'Sls Undyed Krsn St Lcl Govt Gals Qty', 'TEXT', 'ReturnData/IRS4136/SlsUndyedKrsnStLclGovtGalsQty');

-- 990T / Organization Other Trust Ind Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54238, 54, '239', 'Organization Other Trust Ind Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542492, 54238, '1', 'Organization Other Trust Ind', 'BOOLEAN'),
  (542493, 54238, '2', 'Other Trust Type Cd', 'TEXT'),
  (542494, 54238, '3', 'Other Trust Type Desc', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542492, NULL, NULL, 'Organization Other Trust Ind', 'BOOLEAN', 'ReturnData/IRS990T/OrganizationOtherTrustIndGrp/OrganizationOtherTrustInd'),
  (542493, NULL, NULL, 'Other Trust Type Cd', 'TEXT', 'ReturnData/IRS990T/OrganizationOtherTrustIndGrp/OtherTrustTypeCd'),
  (542494, NULL, NULL, 'Other Trust Type Desc', 'TEXT', 'ReturnData/IRS990T/OrganizationOtherTrustIndGrp/OtherTrustTypeDesc');

-- 990T / Special Condition Desc
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54239, 54, '240', 'Special Condition Desc');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542495, 54239, '1', 'Special Condition Desc', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542495, NULL, NULL, 'Special Condition Desc', 'TEXT', 'ReturnData/IRS990T/SpecialConditionDesc');

-- 990T / Frm8826 CY Cyov Cr Aggrgt Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54240, 54, '241', 'Frm8826 CY Cyov Cr Aggrgt Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542496, 54240, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (542497, 54240, '2', 'Pass Through Entity EIN', 'TEXT'),
  (542498, 54240, '3', 'Yr', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542496, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8826CYCyovCrAggrgtGrp/CYGeneralBusCrCarryforwardAmt'),
  (542497, NULL, NULL, 'Pass Through Entity EIN', 'TEXT', 'ReturnData/IRS3800/Frm8826CYCyovCrAggrgtGrp/PassThroughEntityEIN'),
  (542498, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/Frm8826CYCyovCrAggrgtGrp/Yr');

-- 990T / Frm8941 CY Spcfd Cr Aggrgt Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54241, 54, '242', 'Frm8941 CY Spcfd Cr Aggrgt Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542499, 54241, '1', 'Carryforward General Bus Cr Amt', 'CURRENCY'),
  (542500, 54241, '2', 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY'),
  (542501, 54241, '3', 'Yr', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542499, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8941CYSpcfdCrAggrgtGrp/CarryforwardGeneralBusCrAmt'),
  (542500, NULL, NULL, 'General Bus Cr From Nn Pssv Acty Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm8941CYSpcfdCrAggrgtGrp/GeneralBusCrFromNnPssvActyAmt'),
  (542501, NULL, NULL, 'Yr', 'TEXT', 'ReturnData/IRS3800/Frm8941CYSpcfdCrAggrgtGrp/Yr');

-- 990T / Aviation Gasoline Gallons Qty
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54242, 54, '243', 'Aviation Gasoline Gallons Qty');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542502, 54242, '1', 'Aviation Gasoline Gallons Qty', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542502, NULL, NULL, 'Aviation Gasoline Gallons Qty', 'TEXT', 'ReturnData/IRS4136/AviationGasolineGallonsQty');

-- 990T / Frm3468 Part IICY Cyov Cr Aggrgt Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54243, 54, '244', 'Frm3468 Part IICY Cyov Cr Aggrgt Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542503, 54243, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY'),
  (542504, 54243, '2', 'Nonpassive Ind', 'BOOLEAN');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542503, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm3468PartIICYCyovCrAggrgtGrp/CYGeneralBusCrCarryforwardAmt'),
  (542504, NULL, NULL, 'Nonpassive Ind', 'BOOLEAN', 'ReturnData/IRS3800/Frm3468PartIICYCyovCrAggrgtGrp/NonpassiveInd');

-- 990T / Farm Prps Undyed Dsl Fuel Gals Qty
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54244, 54, '245', 'Farm Prps Undyed Dsl Fuel Gals Qty');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542505, 54244, '1', 'Farm Prps Undyed Dsl Fuel Gals Qty', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542505, NULL, NULL, 'Farm Prps Undyed Dsl Fuel Gals Qty', 'TEXT', 'ReturnData/IRS4136/FarmPrpsUndyedDslFuelGalsQty');

-- 990T / Nontaxable Use Of Undyed Kerosene
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54245, 54, '246', 'Nontaxable Use Of Undyed Kerosene');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542506, 54245, '1', 'Gallons Qty', 'TEXT'),
  (542507, 54245, '2', 'Nontaxable Use Of Fuel Type Cd', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542506, NULL, NULL, 'Gallons Qty', 'TEXT', 'ReturnData/IRS4136/NontaxableUseOfUndyedKerosene/GallonsQty'),
  (542507, NULL, NULL, 'Nontaxable Use Of Fuel Type Cd', 'TEXT', 'ReturnData/IRS4136/NontaxableUseOfUndyedKerosene/NontaxableUseOfFuelTypeCd');

-- 990T / Frm3468 Part IVCY Cyov Cr Aggrgt Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54246, 54, '247', 'Frm3468 Part IVCY Cyov Cr Aggrgt Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542508, 54246, '1', 'Carryforward General Bus Cr Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542508, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm3468PartIVCYCyovCrAggrgtGrp/CarryforwardGeneralBusCrAmt');

-- 990T / Frm3468 VIICY Spcfd Cr Aggrgt Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54247, 54, '248', 'Frm3468 VIICY Spcfd Cr Aggrgt Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542509, 54247, '1', 'CY General Bus Cr Carryforward Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542509, NULL, NULL, 'CY General Bus Cr Carryforward Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm3468VIICYSpcfdCrAggrgtGrp/CYGeneralBusCrCarryforwardAmt');

-- 990T / Frm7207 CY Cyov Cr Aggrgt Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54248, 54, '249', 'Frm7207 CY Cyov Cr Aggrgt Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542510, 54248, '1', 'Carryforward General Bus Cr Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542510, NULL, NULL, 'Carryforward General Bus Cr Amt', 'CURRENCY', 'ReturnData/IRS3800/Frm7207CYCyovCrAggrgtGrp/CarryforwardGeneralBusCrAmt');

-- 990T / Frm8936 Part IICY Cyov Cr Aggrgt Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54249, 54, '250', 'Frm8936 Part IICY Cyov Cr Aggrgt Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542511, 54249, '1', 'Nonpassive Ind', 'BOOLEAN');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542511, NULL, NULL, 'Nonpassive Ind', 'BOOLEAN', 'ReturnData/IRS3800/Frm8936PartIICYCyovCrAggrgtGrp/NonpassiveInd');

-- 990T / Compressed Natural Gas Gals Qty
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (54250, 54, '251', 'Compressed Natural Gas Gals Qty');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (542512, 54250, '1', 'Compressed Natural Gas Gals Qty', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (542512, NULL, NULL, 'Compressed Natural Gas Gals Qty', 'TEXT', 'ReturnData/IRS4136/CompressedNaturalGasGalsQty');

