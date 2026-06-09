-- Form 990 — extended field mappings (parts 13 EXT1 / 14 EXT2).
-- Defines parts 13 & 14, which 50_return_header.sql also depends on.

-- ===========================================================================
-- EXTENDED FIELD MAPPINGS — generated from IRS TEOS 2025 XML sampling
-- Global dedup: each xml_path appears at most once across all forms.
-- IDs: parts ≥13, sections ≥13000, lines ≥130001
-- ===========================================================================

-- ========================================================================
-- FORM 990 — 827 new field mappings
-- ========================================================================

INSERT OR IGNORE INTO
  part (part_id, form_code, part_number, part_name)
VALUES
  (13, '990', 'EXT1', 'Extended Fields (1)');

INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13000, 13, '001', 'Direct Form Fields'),
  (13001, 13, '002', 'Acct Compile Or Review Basis Group'),
  (13002, 13, '003', 'Adjusted Net Income Group'),
  (13003, 13, '004', 'Amounts Rcvd Dsqlfy Person Group'),
  (13004, 13, '005', 'Books In Care Of Detail'),
  (13005, 13, '006', 'Buildings Group'),
  (13006, 13, '007', 'CY Endwmt Fund Group'),
  (13007, 13, '008', 'CY Minus1Yr Endwmt Fund Group'),
  (13008, 13, '009', 'CY Minus2Yr Endwmt Fund Group'),
  (13009, 13, '010', 'CY Minus3Yr Endwmt Fund Group'),
  (13010, 13, '011', 'CY Minus4Yr Endwmt Fund Group'),
  (13011, 13, '012', 'Contractor Compensation Group'),
  (13012, 13, '013', 'Contributor Information Group'),
  (13013, 13, '014', 'Disposition Of Assets Detail'),
  (13014, 13, '015', 'Distributable Amount Group'),
  (13015, 13, '016', 'Distribution Allocations Group'),
  (13016, 13, '017', 'Distributions Group'),
  (13017, 13, '018', 'Doing Business As Name'),
  (13018, 13, '019', 'Drugs And Medical Supplies Group'),
  (13019, 13, '020', 'Equipment Group'),
  (13020, 13, '021', 'FS Audited Basis Group'),
  (13021, 13, '022', 'Food Inventory Group'),
  (13022, 13, '023', 'Form990Part VII Section A Group'),
  (13023, 13, '024', 'Form990Sch A Supporting Org Group'),
  (13024, 13, '025', 'Form990Sch A Type1Suprt Org Group'),
  (13025, 13, '026', 'Form990Sch A Type3Sprt Org All Group'),
  (13026, 13, '027', 'Form990Schedule A Part VI Group'),
  (13027, 13, '028', 'Fundraising Event Information Group'),
  (13028, 13, '029', 'Gaming Information Group'),
  (13029, 13, '030', 'Gifts Grants Contri Rcvd170 Group'),
  (13030, 13, '031', 'Gifts Grants Contris Rcvd509 Group'),
  (13031, 13, '032', 'Govt Furn Srvc Fclts Vl170 Group'),
  (13032, 13, '033', 'Govt Furn Srvc Fclts Vl509 Group'),
  (13033, 13, '034', 'Grants Other Asst To Indiv In US Group'),
  (13034, 13, '035', 'Grnt Asst Bnft Interested Prsn Group'),
  (13035, 13, '036', 'Gross Investment Income170 Group'),
  (13036, 13, '037', 'Gross Investment Income509 Group'),
  (13037, 13, '038', 'Gross Receipts Admissions Group'),
  (13038, 13, '039', 'Gross Receipts Non Unrlt Bus Group'),
  (13039, 13, '040', 'Id Related Org Txbl Corp Tr Group'),
  (13040, 13, '041', 'Id Related Tax Exempt Org Group'),
  (13041, 13, '042', 'Investment Income And UBTI Group'),
  (13042, 13, '043', 'Land Group'),
  (13043, 13, '044', 'Leasehold Improvements Group'),
  (13044, 13, '045', 'Minimum Asset Amount Group'),
  (13045, 13, '046', 'Net Income From Other UBI Group'),
  (13046, 13, '047', 'Other Assets Org Group'),
  (13047, 13, '048', 'Other Income170 Group'),
  (13048, 13, '049', 'Other Income509 Group'),
  (13049, 13, '050', 'Other Land Buildings Group');

-- 990 / Direct Form Fields
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130001, 13000, '1', 'Accountant Compile Or Review Ind', 'BOOLEAN'),
  (130002, 13000, '2', 'Activities Conducted Prtshp Ind', 'BOOLEAN'),
  (130003, 13000, '3', 'Address Change Ind', 'BOOLEAN'),
  (130004, 13000, '4', 'Amended Return Ind', 'BOOLEAN'),
  (130005, 13000, '5', 'Annual Disclosure Covered Prsn Ind', 'BOOLEAN'),
  (130006, 13000, '6', 'Audit Committee Ind', 'BOOLEAN'),
  (130007, 13000, '7', 'Backup Wthld Compliance Ind', 'BOOLEAN'),
  (130008, 13000, '8', 'Business Rln With35Ctrl Ent Ind', 'BOOLEAN'),
  (130009, 13000, '9', 'Business Rln With Fam Mem Ind', 'BOOLEAN'),
  (130010, 13000, '10', 'Business Rln With Org Mem Ind', 'BOOLEAN'),
  (130011, 13000, '11', 'CY Total Fundraising Expense Amt', 'CURRENCY'),
  (130012, 13000, '12', 'Change To Org Documents Ind', 'BOOLEAN'),
  (130013, 13000, '13', 'Cntrct Rcvd Greater Than100K Cnt', 'INTEGER'),
  (130014, 13000, '14', 'Collections Of Art Ind', 'BOOLEAN'),
  (130015, 13000, '15', 'Compensation From Other Srcs Ind', 'BOOLEAN'),
  (130016, 13000, '16', 'Compensation Process CEO Ind', 'BOOLEAN'),
  (130017, 13000, '17', 'Compensation Process Other Ind', 'BOOLEAN'),
  (130018, 13000, '18', 'Conflict Of Interest Policy Ind', 'BOOLEAN'),
  (130019, 13000, '19', 'Conservation Easements Ind', 'BOOLEAN'),
  (130020, 13000, '20', 'Consolidated Audit Fincl Stmt Ind', 'BOOLEAN'),
  (130021, 13000, '21', 'Contri Rpt Fundraising Event Amt', 'CURRENCY'),
  (130022, 13000, '22', 'Credit Counseling Ind', 'BOOLEAN'),
  (130023, 13000, '23', 'DAF Excess Business Holdings Ind', 'BOOLEAN'),
  (130024, 13000, '24', 'Decisions Subject To Approva Ind', 'BOOLEAN'),
  (130025, 13000, '25', 'Deductible Art Contribution Ind', 'BOOLEAN'),
  (130026, 13000, '26', 'Deductible Non Cash Contri Ind', 'BOOLEAN'),
  (130027, 13000, '27', 'Delegation Of Mgmt Duties Ind', 'BOOLEAN'),
  (130028, 13000, '28', 'Desc', 'TEXT'),
  (130029, 13000, '29', 'Described In Section501c3Ind', 'BOOLEAN'),
  (130030, 13000, '30', 'Disregarded Entity Ind', 'BOOLEAN'),
  (130031, 13000, '31', 'Distribution To Donor Ind', 'BOOLEAN'),
  (130032, 13000, '32', 'Document Retention Policy Ind', 'BOOLEAN'),
  (130033, 13000, '33', 'Donated Services And Use Fclts Amt', 'CURRENCY'),
  (130034, 13000, '34', 'Donor Advised Fund Ind', 'BOOLEAN'),
  (130035, 13000, '35', 'Donor Rstr Or Quasi Endowments Ind', 'BOOLEAN'),
  (130036, 13000, '36', 'Election Of Board Members Ind', 'BOOLEAN'),
  (130037, 13000, '37', 'Employee Cnt', 'INTEGER'),
  (130038, 13000, '38', 'Employment Tax Returns Filed Ind', 'BOOLEAN'),
  (130039, 13000, '39', 'Engaged In Excess Benefit Trans Ind', 'BOOLEAN'),
  (130040, 13000, '40', 'Escrow Account Ind', 'BOOLEAN'),
  (130041, 13000, '41', 'Expense Amt', 'CURRENCY'),
  (130042, 13000, '42', 'FS Audited Ind', 'BOOLEAN'),
  (130043, 13000, '43', 'Family Or Business Rln Ind', 'BOOLEAN'),
  (130044, 13000, '44', 'Federal Grant Audit Performed Ind', 'BOOLEAN'),
  (130045, 13000, '45', 'Federal Grant Audit Required Ind', 'BOOLEAN'),
  (130046, 13000, '46', 'Foreign Activities Ind', 'BOOLEAN'),
  (130047, 13000, '47', 'Foreign Financial Account Ind', 'BOOLEAN'),
  (130048, 13000, '48', 'Foreign Office Ind', 'BOOLEAN'),
  (130049, 13000, '49', 'Form1098C Filed Ind', 'BOOLEAN'),
  (130050, 13000, '50', 'Form8282Filed Cnt', 'INTEGER'),
  (130051, 13000, '51', 'Form8282Property Disposed Of Ind', 'BOOLEAN'),
  (130052, 13000, '52', 'Form8899Filedind', 'TEXT'),
  (130053, 13000, '53', 'Form990Provided To Gvrn Body Ind', 'BOOLEAN'),
  (130054, 13000, '54', 'Form990T Filed Ind', 'BOOLEAN'),
  (130055, 13000, '55', 'Formation Yr', 'TEXT'),
  (130056, 13000, '56', 'Former Ofcr Employees Listed Ind', 'BOOLEAN'),
  (130057, 13000, '57', 'Fundraising Activities Ind', 'BOOLEAN'),
  (130058, 13000, '58', 'Gaming Activities Ind', 'BOOLEAN'),
  (130059, 13000, '59', 'Governing Body Voting Members Cnt', 'INTEGER'),
  (130060, 13000, '60', 'Grant Amt', 'CURRENCY'),
  (130061, 13000, '61', 'Grant To Related Person Ind', 'BOOLEAN'),
  (130062, 13000, '62', 'Grants To Individuals Ind', 'BOOLEAN'),
  (130063, 13000, '63', 'Grants To Organizations Ind', 'BOOLEAN'),
  (130064, 13000, '64', 'Gross Receipts Amt', 'CURRENCY'),
  (130065, 13000, '65', 'Group Return For Affiliates Ind', 'BOOLEAN'),
  (130066, 13000, '66', 'IRP Document Cnt', 'INTEGER'),
  (130067, 13000, '67', 'IRP Document W2G Cnt', 'INTEGER'),
  (130068, 13000, '68', 'Include FIN48Footnote Ind', 'BOOLEAN'),
  (130069, 13000, '69', 'Independent Audit Fincl Stmt Ind', 'BOOLEAN'),
  (130070, 13000, '70', 'Independent Voting Member Cnt', 'INTEGER'),
  (130071, 13000, '71', 'Indiv Rcvd Greater Than100K Cnt', 'INTEGER'),
  (130072, 13000, '72', 'Indoor Tanning Services Ind', 'BOOLEAN'),
  (130073, 13000, '73', 'Info In Schedule O Part III Ind', 'BOOLEAN'),
  (130074, 13000, '74', 'Info In Schedule O Part IX Ind', 'BOOLEAN'),
  (130075, 13000, '75', 'Info In Schedule O Part VII Ind', 'BOOLEAN'),
  (130076, 13000, '76', 'Info In Schedule O Part VI Ind', 'BOOLEAN'),
  (130077, 13000, '77', 'Info In Schedule O Part XII Ind', 'BOOLEAN'),
  (130078, 13000, '78', 'Info In Schedule O Part XI Ind', 'BOOLEAN'),
  (130079, 13000, '79', 'Invest Tax Exempt Bonds Ind', 'BOOLEAN'),
  (130080, 13000, '80', 'Investment Expense Amt', 'CURRENCY'),
  (130081, 13000, '81', 'Investment In Joint Venture Ind', 'BOOLEAN'),
  (130082, 13000, '82', 'Legal Domicile State Cd', 'TEXT'),
  (130083, 13000, '83', 'Loan Outstanding Ind', 'BOOLEAN'),
  (130084, 13000, '84', 'Lobbying Activities Ind', 'BOOLEAN'),
  (130085, 13000, '85', 'Local Chapters Ind', 'BOOLEAN'),
  (130086, 13000, '86', 'Material Diversion Or Misuse Ind', 'BOOLEAN'),
  (130087, 13000, '87', 'Members And Shr Gross Income Amt', 'CURRENCY'),
  (130088, 13000, '88', 'Members Or Stockholders Ind', 'BOOLEAN'),
  (130089, 13000, '89', 'Method Of Accounting Accrual Ind', 'BOOLEAN'),
  (130090, 13000, '90', 'Method Of Accounting Cash Ind', 'BOOLEAN'),
  (130091, 13000, '91', 'Method Of Accounting Other Ind', 'BOOLEAN'),
  (130092, 13000, '92', 'Minutes Of Committees Ind', 'BOOLEAN'),
  (130093, 13000, '93', 'Minutes Of Governing Body Ind', 'BOOLEAN'),
  (130094, 13000, '94', 'Mission Desc', 'TEXT'),
  (130095, 13000, '95', 'More Than5000K To Individuals Ind', 'BOOLEAN'),
  (130096, 13000, '96', 'More Than5000K To Org Ind', 'BOOLEAN'),
  (130097, 13000, '97', 'Net Unrlzd Gains Losses Invst Amt', 'CURRENCY'),
  (130098, 13000, '98', 'No Listed Persons Compensated Ind', 'BOOLEAN'),
  (130099, 13000, '99', 'Nondeductible Contributions Ind', 'BOOLEAN'),
  (130100, 13000, '100', 'Officer Mailing Address Ind', 'BOOLEAN'),
  (130101, 13000, '101', 'On Behalf Of Issuer Ind', 'BOOLEAN'),
  (130102, 13000, '102', 'Operate Hospital Ind', 'BOOLEAN'),
  (130103, 13000, '103', 'Org Does Not Follow FASB117Ind', 'BOOLEAN'),
  (130104, 13000, '104', 'Organization501c3Ind', 'BOOLEAN'),
  (130105, 13000, '105', 'Organization501c Ind', 'BOOLEAN'),
  (130106, 13000, '106', 'Organization Follows FASB117Ind', 'BOOLEAN'),
  (130107, 13000, '107', 'Other Changes In Net Assets Amt', 'CURRENCY'),
  (130108, 13000, '108', 'Other Revenue Total Amt', 'CURRENCY'),
  (130109, 13000, '109', 'Other Sources Gross Income Amt', 'CURRENCY'),
  (130110, 13000, '110', 'Other Website Ind', 'BOOLEAN'),
  (130111, 13000, '111', 'Own Website Ind', 'BOOLEAN'),
  (130112, 13000, '112', 'PY Excess Benefit Trans Ind', 'BOOLEAN'),
  (130113, 13000, '113', 'Partial Liquidation Ind', 'BOOLEAN'),
  (130114, 13000, '114', 'Pay Premiums Prsnl Bnft Cntrct Ind', 'BOOLEAN'),
  (130115, 13000, '115', 'Policies Reference Chapters Ind', 'BOOLEAN'),
  (130116, 13000, '116', 'Political Campaign Acty Ind', 'BOOLEAN'),
  (130117, 13000, '117', 'Principal Officer Nm', 'TEXT'),
  (130118, 13000, '118', 'Prior Period Adjustments Amt', 'CURRENCY'),
  (130119, 13000, '119', 'Professional Fundraising Ind', 'BOOLEAN'),
  (130120, 13000, '120', 'Prohibited Tax Shelter Trans Ind', 'BOOLEAN'),
  (130121, 13000, '121', 'Quid Pro Quo Contri Discl Ind', 'BOOLEAN'),
  (130122, 13000, '122', 'Quid Pro Quo Contributions Ind', 'BOOLEAN'),
  (130123, 13000, '123', 'Rcv Fnds To Pay Prsnl Bnft Cntrct Ind', 'BOOLEAN'),
  (130124, 13000, '124', 'Reconcilation Revenue Expnss Amt', 'CURRENCY'),
  (130125, 13000, '125', 'Regular Monitoring Enfrc Ind', 'BOOLEAN'),
  (130126, 13000, '126', 'Related Entity Ind', 'BOOLEAN'),
  (130127, 13000, '127', 'Related Organization Ctrl Ent Ind', 'BOOLEAN'),
  (130128, 13000, '128', 'Report Investments Other Sec Ind', 'BOOLEAN'),
  (130129, 13000, '129', 'Report Land Building Equipment Ind', 'BOOLEAN'),
  (130130, 13000, '130', 'Report Other Assets Ind', 'BOOLEAN'),
  (130131, 13000, '131', 'Report Other Liabilities Ind', 'BOOLEAN'),
  (130132, 13000, '132', 'Report Program Related Invst Ind', 'BOOLEAN'),
  (130133, 13000, '133', 'Revenue Amt', 'CURRENCY'),
  (130134, 13000, '134', 'Schedule B Required Ind', 'BOOLEAN'),
  (130135, 13000, '135', 'Schedule J Required Ind', 'BOOLEAN'),
  (130136, 13000, '136', 'Schedule O Required Ind', 'BOOLEAN'),
  (130137, 13000, '137', 'School Operating Ind', 'BOOLEAN'),
  (130138, 13000, '138', 'Significant Change Ind', 'BOOLEAN'),
  (130139, 13000, '139', 'Significant New Program Srvc Ind', 'BOOLEAN'),
  (130140, 13000, '140', 'States Where Copy Of Return Is Fld Cd', 'TEXT'),
  (130141, 13000, '141', 'Subj To Tax Rmnrtn Ex Prcht Pymt Ind', 'BOOLEAN'),
  (130142, 13000, '142', 'Subject To Excs Tax Net Invst Inc Ind', 'BOOLEAN'),
  (130143, 13000, '143', 'Subject To Proxy Tax Ind', 'BOOLEAN'),
  (130144, 13000, '144', 'Tax Exempt Bonds Ind', 'BOOLEAN'),
  (130145, 13000, '145', 'Taxable Distributions Ind', 'BOOLEAN'),
  (130146, 13000, '146', 'Taxable Party Notification Ind', 'BOOLEAN'),
  (130147, 13000, '147', 'Terminate Operations Ind', 'BOOLEAN'),
  (130148, 13000, '148', 'Tot Reportable Comp Rltd Org Amt', 'CURRENCY'),
  (130149, 13000, '149', 'Total Comp Greater Than150K Ind', 'BOOLEAN'),
  (130150, 13000, '150', 'Total Other Compensation Amt', 'CURRENCY'),
  (130151, 13000, '151', 'Total Other Prog Srvc Expense Amt', 'CURRENCY'),
  (130152, 13000, '152', 'Total Other Prog Srvc Grant Amt', 'CURRENCY'),
  (130153, 13000, '153', 'Total Other Prog Srvc Revenue Amt', 'CURRENCY'),
  (130154, 13000, '154', 'Total Program Service Expenses Amt', 'CURRENCY'),
  (130155, 13000, '155', 'Total Reportable Comp From Org Amt', 'CURRENCY'),
  (130156, 13000, '156', 'Transaction With Control Ent Ind', 'BOOLEAN'),
  (130157, 13000, '157', 'Trnsfr Exmpt Non Chrtbl Rltd Org Ind', 'BOOLEAN'),
  (130158, 13000, '158', 'Type Of Organization Assoc Ind', 'BOOLEAN'),
  (130159, 13000, '159', 'Type Of Organization Corp Ind', 'BOOLEAN'),
  (130160, 13000, '160', 'Type Of Organization Trust Ind', 'BOOLEAN'),
  (130161, 13000, '161', 'Unrelated Bus Incm Over Limit Ind', 'BOOLEAN'),
  (130162, 13000, '162', 'Upon Request Ind', 'BOOLEAN'),
  (130163, 13000, '163', 'Website Address Txt', 'TEXT'),
  (130164, 13000, '164', 'Whistleblower Policy Ind', 'BOOLEAN'),
  (130165, 13000, '165', 'First5Years170Ind', 'BOOLEAN'),
  (130166, 13000, '166', 'First5Years509Ind', 'BOOLEAN'),
  (130167, 13000, '167', 'Gross Receipts Rltd Activities Amt', 'CURRENCY'),
  (130168, 13000, '168', 'Investment Income CY Pct', 'PERCENT'),
  (130169, 13000, '169', 'Investment Income PY Pct', 'PERCENT'),
  (130170, 13000, '170', 'Other Support Sum Amt', 'CURRENCY'),
  (130171, 13000, '171', 'Public Organization170Ind', 'BOOLEAN'),
  (130172, 13000, '172', 'Public Support CY170Pct', 'PERCENT'),
  (130173, 13000, '173', 'Public Support CY509Pct', 'PERCENT'),
  (130174, 13000, '174', 'Public Support PY170Pct', 'PERCENT'),
  (130175, 13000, '175', 'Public Support PY509Pct', 'PERCENT'),
  (130176, 13000, '176', 'Public Support Total170Amt', 'CURRENCY'),
  (130177, 13000, '177', 'Public Support Total509Amt', 'CURRENCY'),
  (130178, 13000, '178', 'Publicly Supported Org509a2Ind', 'BOOLEAN'),
  (130179, 13000, '179', 'School Ind', 'BOOLEAN'),
  (130180, 13000, '180', 'Substantial Contributors Tot Amt', 'CURRENCY'),
  (130181, 13000, '181', 'Support Sum Amt', 'CURRENCY'),
  (130182, 13000, '182', 'Supported Organizations Cnt', 'INTEGER'),
  (130183, 13000, '183', 'Supported Organizations Total Cnt', 'INTEGER'),
  (130184, 13000, '184', 'Supporting Org Type1Ind', 'BOOLEAN'),
  (130185, 13000, '185', 'Supporting Org Type3Non Func Ind', 'BOOLEAN'),
  (130186, 13000, '186', 'Supporting Organization509a3Ind', 'BOOLEAN'),
  (130187, 13000, '187', 'Thirty Thr Pct Suprt Tests CY170Ind', 'BOOLEAN'),
  (130188, 13000, '188', 'Thirty Thr Pct Suprt Tests CY509Ind', 'BOOLEAN'),
  (130189, 13000, '189', 'Total Support Amt', 'CURRENCY'),
  (130190, 13000, '190', 'Aggregate Reported Dues Ntc Amt', 'CURRENCY'),
  (130191, 13000, '191', 'Agree Carryover Prior Year Ind', 'BOOLEAN'),
  (130192, 13000, '192', 'Direct Contact Legislators Amt', 'CURRENCY'),
  (130193, 13000, '193', 'Direct Contact Legislators Ind', 'BOOLEAN'),
  (130194, 13000, '194', 'Dues Assessments Amt', 'CURRENCY'),
  (130195, 13000, '195', 'Grants Other Organizations Amt', 'CURRENCY'),
  (130196, 13000, '196', 'Grants Other Organizations Ind', 'BOOLEAN'),
  (130197, 13000, '197', 'Mailings Members Ind', 'BOOLEAN'),
  (130198, 13000, '198', 'Media Advertisements Ind', 'BOOLEAN'),
  (130199, 13000, '199', 'Non Ded Lbbyng Pltcl Cyov Amt', 'CURRENCY'),
  (130200, 13000, '200', 'Non Deductible Lbbyng Pltcl CY Amt', 'CURRENCY'),
  (130201, 13000, '201', 'Non Deductible Lbbyng Pltcl Tot Amt', 'CURRENCY'),
  (130202, 13000, '202', 'Not Described Section501c3Ind', 'BOOLEAN'),
  (130203, 13000, '203', 'Only In House Lobbying Ind', 'BOOLEAN'),
  (130204, 13000, '204', 'Other Activities Amt', 'CURRENCY'),
  (130205, 13000, '205', 'Other Activities Ind', 'BOOLEAN'),
  (130206, 13000, '206', 'Paid Staff Or Management Ind', 'BOOLEAN'),
  (130207, 13000, '207', 'Publications Or Broadcast Ind', 'BOOLEAN'),
  (130208, 13000, '208', 'Rallies Demonstrations Ind', 'BOOLEAN'),
  (130209, 13000, '209', 'Substantially All Dues Nonded Ind', 'BOOLEAN'),
  (130210, 13000, '210', 'Taxable Amt', 'CURRENCY'),
  (130211, 13000, '211', 'Total Lobbying Expenditures Amt', 'CURRENCY'),
  (130212, 13000, '212', 'Volunteers Ind', 'BOOLEAN'),
  (130213, 13000, '213', 'Agent Trustee Etc Ind', 'BOOLEAN'),
  (130214, 13000, '214', 'Board Designated Balance EOY Pct', 'PERCENT'),
  (130215, 13000, '215', 'Donated Services And Use Fclts Amt', 'CURRENCY'),
  (130216, 13000, '216', 'Donated Services Use Fclts Amt', 'CURRENCY'),
  (130217, 13000, '217', 'Endowments Held Related Org Ind', 'BOOLEAN'),
  (130218, 13000, '218', 'Endowments Held Unrelated Org Ind', 'BOOLEAN'),
  (130219, 13000, '219', 'Expenses Not Reported Amt', 'CURRENCY'),
  (130220, 13000, '220', 'Expenses Not Rpt Fincl Stmt Amt', 'CURRENCY'),
  (130221, 13000, '221', 'Expenses Subtotal Amt', 'CURRENCY'),
  (130222, 13000, '222', 'Footnote Text Ind', 'BOOLEAN'),
  (130223, 13000, '223', 'Incl Escrow Custodial Acct Liab Ind', 'BOOLEAN'),
  (130224, 13000, '224', 'Investment Expenses Not Incld2Amt', 'CURRENCY'),
  (130225, 13000, '225', 'Investment Expenses Not Incld Amt', 'CURRENCY'),
  (130226, 13000, '226', 'Net Unrealized Gains Invst Amt', 'CURRENCY'),
  (130227, 13000, '227', 'Other Expenses Included Amt', 'CURRENCY'),
  (130228, 13000, '228', 'Other Revenue Amt', 'CURRENCY'),
  (130229, 13000, '229', 'Prmnnt Endowment Balance EOY Pct', 'PERCENT'),
  (130230, 13000, '230', 'Revenue Not Reported Amt', 'CURRENCY'),
  (130231, 13000, '231', 'Revenue Not Reported Fincl Stmt Amt', 'CURRENCY'),
  (130232, 13000, '232', 'Revenue Subtotal Amt', 'CURRENCY'),
  (130233, 13000, '233', 'Term Endowment Balance EOY Pct', 'PERCENT'),
  (130234, 13000, '234', 'Tot Expns Etc Audited Fincl Stmt Amt', 'CURRENCY'),
  (130235, 13000, '235', 'Total Book Value Land Buildings Amt', 'CURRENCY'),
  (130236, 13000, '236', 'Total Book Value Other Assets Amt', 'CURRENCY'),
  (130237, 13000, '237', 'Total Expenses Per Form990Amt', 'CURRENCY'),
  (130238, 13000, '238', 'Total Liability Amt', 'CURRENCY'),
  (130239, 13000, '239', 'Total Rev Etc Audited Fincl Stmt Amt', 'CURRENCY'),
  (130240, 13000, '240', 'Total Revenue Per Form990Amt', 'CURRENCY'),
  (130241, 13000, '241', 'Compliance With Rev Proc7550Ind', 'BOOLEAN'),
  (130242, 13000, '242', 'Discriminate Race Admiss Plcy Ind', 'BOOLEAN'),
  (130243, 13000, '243', 'Discriminate Race Athlt Prog Ind', 'BOOLEAN'),
  (130244, 13000, '244', 'Discriminate Race Educ Plcy Ind', 'BOOLEAN'),
  (130245, 13000, '245', 'Discriminate Race Emplm Fculty Ind', 'BOOLEAN'),
  (130246, 13000, '246', 'Discriminate Race Other Acty Ind', 'BOOLEAN'),
  (130247, 13000, '247', 'Discriminate Race Schs Ind', 'BOOLEAN'),
  (130248, 13000, '248', 'Discriminate Race Stdnts Rghts Ind', 'BOOLEAN'),
  (130249, 13000, '249', 'Discriminate Race Use Of Fclts Ind', 'BOOLEAN'),
  (130250, 13000, '250', 'Government Financial Aid Rcvd Ind', 'BOOLEAN'),
  (130251, 13000, '251', 'Government Financial Aid Rvkd Ind', 'BOOLEAN'),
  (130252, 13000, '252', 'Maintain Cpy Of All Sol Ind', 'BOOLEAN'),
  (130253, 13000, '253', 'Maintain Cpy Of Brochures Etc Ind', 'BOOLEAN'),
  (130254, 13000, '254', 'Maintain Racial Comp Recs Ind', 'BOOLEAN'),
  (130255, 13000, '255', 'Maintain Scholarships Recs Ind', 'BOOLEAN'),
  (130256, 13000, '256', 'Nondiscriminatory Policy Stmt Ind', 'BOOLEAN'),
  (130257, 13000, '257', 'Plcy Pblczd Via Broadcast Media Ind', 'BOOLEAN'),
  (130258, 13000, '258', 'Policy Stmt In Brochures Etc Ind', 'BOOLEAN'),
  (130259, 13000, '259', 'Agrmt Prof Fundraising Acty Ind', 'BOOLEAN'),
  (130260, 13000, '260', 'Charitable Distribution Rqr Ind', 'BOOLEAN'),
  (130261, 13000, '261', 'Cntrct With3rd Prty For Game Rev Ind', 'BOOLEAN'),
  (130262, 13000, '262', 'Gaming Own Facility Pct', 'PERCENT'),
  (130263, 13000, '263', 'Gaming With Nonmembers Ind', 'BOOLEAN'),
  (130264, 13000, '264', 'License Suspended Etc Ind', 'BOOLEAN'),
  (130265, 13000, '265', 'Licensed Ind', 'BOOLEAN'),
  (130266, 13000, '266', 'Member Of Other Entity Ind', 'BOOLEAN'),
  (130267, 13000, '267', 'States Where Gaming Conducted Cd', 'TEXT'),
  (130268, 13000, '268', 'Grant Records Maintained Ind', 'BOOLEAN'),
  (130269, 13000, '269', 'Total501c3Org Cnt', 'INTEGER'),
  (130270, 13000, '270', 'Total Other Org Cnt', 'INTEGER'),
  (130271, 13000, '271', 'Any Non Fixed Payments Ind', 'BOOLEAN'),
  (130272, 13000, '272', 'Board Or Committee Approval Ind', 'BOOLEAN'),
  (130273, 13000, '273', 'Club Dues Or Fees Ind', 'BOOLEAN'),
  (130274, 13000, '274', 'Comp Based On Revenue Of Flng Org Ind', 'BOOLEAN'),
  (130275, 13000, '275', 'Comp Bsd Net Earns Flng Org Ind', 'BOOLEAN'),
  (130276, 13000, '276', 'Comp Bsd Net Earns Rltd Orgs Ind', 'BOOLEAN'),
  (130277, 13000, '277', 'Comp Bsd On Rev Related Orgs Ind', 'BOOLEAN'),
  (130278, 13000, '278', 'Compensation Committee Ind', 'BOOLEAN'),
  (130279, 13000, '279', 'Compensation Survey Ind', 'BOOLEAN'),
  (130280, 13000, '280', 'Equity Based Comp Arrngm Ind', 'BOOLEAN'),
  (130281, 13000, '281', 'First Class Or Charter Travel Ind', 'BOOLEAN'),
  (130282, 13000, '282', 'Form990Of Other Organizations Ind', 'BOOLEAN'),
  (130283, 13000, '283', 'Independent Consultant Ind', 'BOOLEAN'),
  (130284, 13000, '284', 'Initial Contract Exception Ind', 'BOOLEAN'),
  (130285, 13000, '285', 'Severance Payment Ind', 'BOOLEAN'),
  (130286, 13000, '286', 'Substantiation Required Ind', 'BOOLEAN'),
  (130287, 13000, '287', 'Supplemental Nonqual Rtr Plan Ind', 'BOOLEAN'),
  (130288, 13000, '288', 'Written Employment Contract Ind', 'BOOLEAN'),
  (130289, 13000, '289', 'Written Policy Ref T And E Expnss Ind', 'BOOLEAN'),
  (130290, 13000, '290', 'Any Property That Must Be Held Ind', 'BOOLEAN'),
  (130291, 13000, '291', 'Form8283Received Cnt', 'INTEGER'),
  (130292, 13000, '292', 'Review Process Unusual NC Gifts Ind', 'BOOLEAN'),
  (130293, 13000, '293', 'Third Parties Used Ind', 'BOOLEAN'),
  (130294, 13000, '294', 'Director Of Successor2Ind', 'BOOLEAN'),
  (130295, 13000, '295', 'Employee Of Successor2Ind', 'BOOLEAN'),
  (130296, 13000, '296', 'Owner Of Successor2Ind', 'BOOLEAN'),
  (130297, 13000, '297', 'Receive Compensation2Ind', 'BOOLEAN'),
  (130298, 13000, '298', 'Asset Exchange Ind', 'BOOLEAN'),
  (130299, 13000, '299', 'Asset Purchase From Other Org Ind', 'BOOLEAN'),
  (130300, 13000, '300', 'Asset Sale To Other Org Ind', 'BOOLEAN'),
  (130301, 13000, '301', 'Div Related Organization Ind', 'BOOLEAN'),
  (130302, 13000, '302', 'Gift Grnt Cap Contri From Oth Org Ind', 'BOOLEAN'),
  (130303, 13000, '303', 'Gift Grnt Or Cap Contri To Oth Org Ind', 'BOOLEAN'),
  (130304, 13000, '304', 'Loans Or Guarantees From Oth Org Ind', 'BOOLEAN'),
  (130305, 13000, '305', 'Loans Or Guarantees To Other Org Ind', 'BOOLEAN'),
  (130306, 13000, '306', 'Paid Employees Sharing Ind', 'BOOLEAN'),
  (130307, 13000, '307', 'Perform Of Services By Other Org Ind', 'BOOLEAN'),
  (130308, 13000, '308', 'Perform Of Services For Oth Org Ind', 'BOOLEAN'),
  (130309, 13000, '309', 'Receipt Of Int Annts Rnts Rylts Ind', 'BOOLEAN'),
  (130310, 13000, '310', 'Reimbursement Paid By Other Org Ind', 'BOOLEAN'),
  (130311, 13000, '311', 'Reimbursement Paid To Other Org Ind', 'BOOLEAN'),
  (130312, 13000, '312', 'Rental Of Facilities To Oth Org Ind', 'BOOLEAN'),
  (130313, 13000, '313', 'Rental Of Fclts From Oth Org Ind', 'BOOLEAN'),
  (130314, 13000, '314', 'Sharing Of Facilities Ind', 'BOOLEAN'),
  (130315, 13000, '315', 'Transfer From Other Org Ind', 'BOOLEAN'),
  (130316, 13000, '316', 'Transfer To Other Org Ind', 'BOOLEAN');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130001, NULL, NULL, 'Accountant Compile Or Review Ind', 'BOOLEAN', 'ReturnData/IRS990/AccountantCompileOrReviewInd'),
  (130002, NULL, NULL, 'Activities Conducted Prtshp Ind', 'BOOLEAN', 'ReturnData/IRS990/ActivitiesConductedPrtshpInd'),
  (130003, NULL, NULL, 'Address Change Ind', 'BOOLEAN', 'ReturnData/IRS990/AddressChangeInd'),
  (130004, NULL, NULL, 'Amended Return Ind', 'BOOLEAN', 'ReturnData/IRS990/AmendedReturnInd'),
  (130005, NULL, NULL, 'Annual Disclosure Covered Prsn Ind', 'BOOLEAN', 'ReturnData/IRS990/AnnualDisclosureCoveredPrsnInd'),
  (130006, NULL, NULL, 'Audit Committee Ind', 'BOOLEAN', 'ReturnData/IRS990/AuditCommitteeInd'),
  (130007, NULL, NULL, 'Backup Wthld Compliance Ind', 'BOOLEAN', 'ReturnData/IRS990/BackupWthldComplianceInd'),
  (130008, NULL, NULL, 'Business Rln With35Ctrl Ent Ind', 'BOOLEAN', 'ReturnData/IRS990/BusinessRlnWith35CtrlEntInd'),
  (130009, NULL, NULL, 'Business Rln With Fam Mem Ind', 'BOOLEAN', 'ReturnData/IRS990/BusinessRlnWithFamMemInd'),
  (130010, NULL, NULL, 'Business Rln With Org Mem Ind', 'BOOLEAN', 'ReturnData/IRS990/BusinessRlnWithOrgMemInd'),
  (130011, NULL, NULL, 'CY Total Fundraising Expense Amt', 'CURRENCY', 'ReturnData/IRS990/CYTotalFundraisingExpenseAmt'),
  (130012, NULL, NULL, 'Change To Org Documents Ind', 'BOOLEAN', 'ReturnData/IRS990/ChangeToOrgDocumentsInd'),
  (130013, NULL, NULL, 'Cntrct Rcvd Greater Than100K Cnt', 'INTEGER', 'ReturnData/IRS990/CntrctRcvdGreaterThan100KCnt'),
  (130014, NULL, NULL, 'Collections Of Art Ind', 'BOOLEAN', 'ReturnData/IRS990/CollectionsOfArtInd'),
  (130015, NULL, NULL, 'Compensation From Other Srcs Ind', 'BOOLEAN', 'ReturnData/IRS990/CompensationFromOtherSrcsInd'),
  (130016, NULL, NULL, 'Compensation Process CEO Ind', 'BOOLEAN', 'ReturnData/IRS990/CompensationProcessCEOInd'),
  (130017, NULL, NULL, 'Compensation Process Other Ind', 'BOOLEAN', 'ReturnData/IRS990/CompensationProcessOtherInd'),
  (130018, NULL, NULL, 'Conflict Of Interest Policy Ind', 'BOOLEAN', 'ReturnData/IRS990/ConflictOfInterestPolicyInd'),
  (130019, NULL, NULL, 'Conservation Easements Ind', 'BOOLEAN', 'ReturnData/IRS990/ConservationEasementsInd'),
  (130020, NULL, NULL, 'Consolidated Audit Fincl Stmt Ind', 'BOOLEAN', 'ReturnData/IRS990/ConsolidatedAuditFinclStmtInd'),
  (130021, NULL, NULL, 'Contri Rpt Fundraising Event Amt', 'CURRENCY', 'ReturnData/IRS990/ContriRptFundraisingEventAmt'),
  (130022, NULL, NULL, 'Credit Counseling Ind', 'BOOLEAN', 'ReturnData/IRS990/CreditCounselingInd'),
  (130023, NULL, NULL, 'DAF Excess Business Holdings Ind', 'BOOLEAN', 'ReturnData/IRS990/DAFExcessBusinessHoldingsInd'),
  (130024, NULL, NULL, 'Decisions Subject To Approva Ind', 'BOOLEAN', 'ReturnData/IRS990/DecisionsSubjectToApprovaInd'),
  (130025, NULL, NULL, 'Deductible Art Contribution Ind', 'BOOLEAN', 'ReturnData/IRS990/DeductibleArtContributionInd'),
  (130026, NULL, NULL, 'Deductible Non Cash Contri Ind', 'BOOLEAN', 'ReturnData/IRS990/DeductibleNonCashContriInd'),
  (130027, NULL, NULL, 'Delegation Of Mgmt Duties Ind', 'BOOLEAN', 'ReturnData/IRS990/DelegationOfMgmtDutiesInd'),
  (130028, NULL, NULL, 'Desc', 'TEXT', 'ReturnData/IRS990/Desc'),
  (130029, NULL, NULL, 'Described In Section501c3Ind', 'BOOLEAN', 'ReturnData/IRS990/DescribedInSection501c3Ind'),
  (130030, NULL, NULL, 'Disregarded Entity Ind', 'BOOLEAN', 'ReturnData/IRS990/DisregardedEntityInd'),
  (130031, NULL, NULL, 'Distribution To Donor Ind', 'BOOLEAN', 'ReturnData/IRS990/DistributionToDonorInd'),
  (130032, NULL, NULL, 'Document Retention Policy Ind', 'BOOLEAN', 'ReturnData/IRS990/DocumentRetentionPolicyInd'),
  (130033, NULL, NULL, 'Donated Services And Use Fclts Amt', 'CURRENCY', 'ReturnData/IRS990/DonatedServicesAndUseFcltsAmt'),
  (130034, NULL, NULL, 'Donor Advised Fund Ind', 'BOOLEAN', 'ReturnData/IRS990/DonorAdvisedFundInd'),
  (130035, NULL, NULL, 'Donor Rstr Or Quasi Endowments Ind', 'BOOLEAN', 'ReturnData/IRS990/DonorRstrOrQuasiEndowmentsInd'),
  (130036, NULL, NULL, 'Election Of Board Members Ind', 'BOOLEAN', 'ReturnData/IRS990/ElectionOfBoardMembersInd'),
  (130037, NULL, NULL, 'Employee Cnt', 'INTEGER', 'ReturnData/IRS990/EmployeeCnt'),
  (130038, NULL, NULL, 'Employment Tax Returns Filed Ind', 'BOOLEAN', 'ReturnData/IRS990/EmploymentTaxReturnsFiledInd'),
  (130039, NULL, NULL, 'Engaged In Excess Benefit Trans Ind', 'BOOLEAN', 'ReturnData/IRS990/EngagedInExcessBenefitTransInd'),
  (130040, NULL, NULL, 'Escrow Account Ind', 'BOOLEAN', 'ReturnData/IRS990/EscrowAccountInd'),
  (130041, NULL, NULL, 'Expense Amt', 'CURRENCY', 'ReturnData/IRS990/ExpenseAmt'),
  (130042, NULL, NULL, 'FS Audited Ind', 'BOOLEAN', 'ReturnData/IRS990/FSAuditedInd'),
  (130043, NULL, NULL, 'Family Or Business Rln Ind', 'BOOLEAN', 'ReturnData/IRS990/FamilyOrBusinessRlnInd'),
  (130044, NULL, NULL, 'Federal Grant Audit Performed Ind', 'BOOLEAN', 'ReturnData/IRS990/FederalGrantAuditPerformedInd'),
  (130045, NULL, NULL, 'Federal Grant Audit Required Ind', 'BOOLEAN', 'ReturnData/IRS990/FederalGrantAuditRequiredInd'),
  (130046, NULL, NULL, 'Foreign Activities Ind', 'BOOLEAN', 'ReturnData/IRS990/ForeignActivitiesInd'),
  (130047, NULL, NULL, 'Foreign Financial Account Ind', 'BOOLEAN', 'ReturnData/IRS990/ForeignFinancialAccountInd'),
  (130048, NULL, NULL, 'Foreign Office Ind', 'BOOLEAN', 'ReturnData/IRS990/ForeignOfficeInd'),
  (130049, NULL, NULL, 'Form1098C Filed Ind', 'BOOLEAN', 'ReturnData/IRS990/Form1098CFiledInd'),
  (130050, NULL, NULL, 'Form8282Filed Cnt', 'INTEGER', 'ReturnData/IRS990/Form8282FiledCnt'),
  (130051, NULL, NULL, 'Form8282Property Disposed Of Ind', 'BOOLEAN', 'ReturnData/IRS990/Form8282PropertyDisposedOfInd'),
  (130052, NULL, NULL, 'Form8899Filedind', 'TEXT', 'ReturnData/IRS990/Form8899Filedind'),
  (130053, NULL, NULL, 'Form990Provided To Gvrn Body Ind', 'BOOLEAN', 'ReturnData/IRS990/Form990ProvidedToGvrnBodyInd'),
  (130054, NULL, NULL, 'Form990T Filed Ind', 'BOOLEAN', 'ReturnData/IRS990/Form990TFiledInd'),
  (130055, NULL, NULL, 'Formation Yr', 'TEXT', 'ReturnData/IRS990/FormationYr'),
  (130056, NULL, NULL, 'Former Ofcr Employees Listed Ind', 'BOOLEAN', 'ReturnData/IRS990/FormerOfcrEmployeesListedInd'),
  (130057, NULL, NULL, 'Fundraising Activities Ind', 'BOOLEAN', 'ReturnData/IRS990/FundraisingActivitiesInd'),
  (130058, NULL, NULL, 'Gaming Activities Ind', 'BOOLEAN', 'ReturnData/IRS990/GamingActivitiesInd'),
  (130059, NULL, NULL, 'Governing Body Voting Members Cnt', 'INTEGER', 'ReturnData/IRS990/GoverningBodyVotingMembersCnt'),
  (130060, NULL, NULL, 'Grant Amt', 'CURRENCY', 'ReturnData/IRS990/GrantAmt'),
  (130061, NULL, NULL, 'Grant To Related Person Ind', 'BOOLEAN', 'ReturnData/IRS990/GrantToRelatedPersonInd'),
  (130062, NULL, NULL, 'Grants To Individuals Ind', 'BOOLEAN', 'ReturnData/IRS990/GrantsToIndividualsInd'),
  (130063, NULL, NULL, 'Grants To Organizations Ind', 'BOOLEAN', 'ReturnData/IRS990/GrantsToOrganizationsInd'),
  (130064, NULL, NULL, 'Gross Receipts Amt', 'CURRENCY', 'ReturnData/IRS990/GrossReceiptsAmt'),
  (130065, NULL, NULL, 'Group Return For Affiliates Ind', 'BOOLEAN', 'ReturnData/IRS990/GroupReturnForAffiliatesInd'),
  (130066, NULL, NULL, 'IRP Document Cnt', 'INTEGER', 'ReturnData/IRS990/IRPDocumentCnt'),
  (130067, NULL, NULL, 'IRP Document W2G Cnt', 'INTEGER', 'ReturnData/IRS990/IRPDocumentW2GCnt'),
  (130068, NULL, NULL, 'Include FIN48Footnote Ind', 'BOOLEAN', 'ReturnData/IRS990/IncludeFIN48FootnoteInd'),
  (130069, NULL, NULL, 'Independent Audit Fincl Stmt Ind', 'BOOLEAN', 'ReturnData/IRS990/IndependentAuditFinclStmtInd'),
  (130070, NULL, NULL, 'Independent Voting Member Cnt', 'INTEGER', 'ReturnData/IRS990/IndependentVotingMemberCnt'),
  (130071, NULL, NULL, 'Indiv Rcvd Greater Than100K Cnt', 'INTEGER', 'ReturnData/IRS990/IndivRcvdGreaterThan100KCnt'),
  (130072, NULL, NULL, 'Indoor Tanning Services Ind', 'BOOLEAN', 'ReturnData/IRS990/IndoorTanningServicesInd'),
  (130073, NULL, NULL, 'Info In Schedule O Part III Ind', 'BOOLEAN', 'ReturnData/IRS990/InfoInScheduleOPartIIIInd'),
  (130074, NULL, NULL, 'Info In Schedule O Part IX Ind', 'BOOLEAN', 'ReturnData/IRS990/InfoInScheduleOPartIXInd'),
  (130075, NULL, NULL, 'Info In Schedule O Part VII Ind', 'BOOLEAN', 'ReturnData/IRS990/InfoInScheduleOPartVIIInd'),
  (130076, NULL, NULL, 'Info In Schedule O Part VI Ind', 'BOOLEAN', 'ReturnData/IRS990/InfoInScheduleOPartVIInd'),
  (130077, NULL, NULL, 'Info In Schedule O Part XII Ind', 'BOOLEAN', 'ReturnData/IRS990/InfoInScheduleOPartXIIInd'),
  (130078, NULL, NULL, 'Info In Schedule O Part XI Ind', 'BOOLEAN', 'ReturnData/IRS990/InfoInScheduleOPartXIInd'),
  (130079, NULL, NULL, 'Invest Tax Exempt Bonds Ind', 'BOOLEAN', 'ReturnData/IRS990/InvestTaxExemptBondsInd'),
  (130080, NULL, NULL, 'Investment Expense Amt', 'CURRENCY', 'ReturnData/IRS990/InvestmentExpenseAmt'),
  (130081, NULL, NULL, 'Investment In Joint Venture Ind', 'BOOLEAN', 'ReturnData/IRS990/InvestmentInJointVentureInd'),
  (130082, NULL, NULL, 'Legal Domicile State Cd', 'TEXT', 'ReturnData/IRS990/LegalDomicileStateCd'),
  (130083, NULL, NULL, 'Loan Outstanding Ind', 'BOOLEAN', 'ReturnData/IRS990/LoanOutstandingInd'),
  (130084, NULL, NULL, 'Lobbying Activities Ind', 'BOOLEAN', 'ReturnData/IRS990/LobbyingActivitiesInd'),
  (130085, NULL, NULL, 'Local Chapters Ind', 'BOOLEAN', 'ReturnData/IRS990/LocalChaptersInd'),
  (130086, NULL, NULL, 'Material Diversion Or Misuse Ind', 'BOOLEAN', 'ReturnData/IRS990/MaterialDiversionOrMisuseInd'),
  (130087, NULL, NULL, 'Members And Shr Gross Income Amt', 'CURRENCY', 'ReturnData/IRS990/MembersAndShrGrossIncomeAmt'),
  (130088, NULL, NULL, 'Members Or Stockholders Ind', 'BOOLEAN', 'ReturnData/IRS990/MembersOrStockholdersInd'),
  (130089, NULL, NULL, 'Method Of Accounting Accrual Ind', 'BOOLEAN', 'ReturnData/IRS990/MethodOfAccountingAccrualInd'),
  (130090, NULL, NULL, 'Method Of Accounting Cash Ind', 'BOOLEAN', 'ReturnData/IRS990/MethodOfAccountingCashInd'),
  (130091, NULL, NULL, 'Method Of Accounting Other Ind', 'BOOLEAN', 'ReturnData/IRS990/MethodOfAccountingOtherInd'),
  (130092, NULL, NULL, 'Minutes Of Committees Ind', 'BOOLEAN', 'ReturnData/IRS990/MinutesOfCommitteesInd'),
  (130093, NULL, NULL, 'Minutes Of Governing Body Ind', 'BOOLEAN', 'ReturnData/IRS990/MinutesOfGoverningBodyInd'),
  (130094, NULL, NULL, 'Mission Desc', 'TEXT', 'ReturnData/IRS990/MissionDesc'),
  (130095, NULL, NULL, 'More Than5000K To Individuals Ind', 'BOOLEAN', 'ReturnData/IRS990/MoreThan5000KToIndividualsInd'),
  (130096, NULL, NULL, 'More Than5000K To Org Ind', 'BOOLEAN', 'ReturnData/IRS990/MoreThan5000KToOrgInd'),
  (130097, NULL, NULL, 'Net Unrlzd Gains Losses Invst Amt', 'CURRENCY', 'ReturnData/IRS990/NetUnrlzdGainsLossesInvstAmt'),
  (130098, NULL, NULL, 'No Listed Persons Compensated Ind', 'BOOLEAN', 'ReturnData/IRS990/NoListedPersonsCompensatedInd'),
  (130099, NULL, NULL, 'Nondeductible Contributions Ind', 'BOOLEAN', 'ReturnData/IRS990/NondeductibleContributionsInd'),
  (130100, NULL, NULL, 'Officer Mailing Address Ind', 'BOOLEAN', 'ReturnData/IRS990/OfficerMailingAddressInd'),
  (130101, NULL, NULL, 'On Behalf Of Issuer Ind', 'BOOLEAN', 'ReturnData/IRS990/OnBehalfOfIssuerInd'),
  (130102, NULL, NULL, 'Operate Hospital Ind', 'BOOLEAN', 'ReturnData/IRS990/OperateHospitalInd'),
  (130103, NULL, NULL, 'Org Does Not Follow FASB117Ind', 'BOOLEAN', 'ReturnData/IRS990/OrgDoesNotFollowFASB117Ind'),
  (130104, NULL, NULL, 'Organization501c3Ind', 'BOOLEAN', 'ReturnData/IRS990/Organization501c3Ind'),
  (130105, NULL, NULL, 'Organization501c Ind', 'BOOLEAN', 'ReturnData/IRS990/Organization501cInd'),
  (130106, NULL, NULL, 'Organization Follows FASB117Ind', 'BOOLEAN', 'ReturnData/IRS990/OrganizationFollowsFASB117Ind'),
  (130107, NULL, NULL, 'Other Changes In Net Assets Amt', 'CURRENCY', 'ReturnData/IRS990/OtherChangesInNetAssetsAmt'),
  (130108, NULL, NULL, 'Other Revenue Total Amt', 'CURRENCY', 'ReturnData/IRS990/OtherRevenueTotalAmt'),
  (130109, NULL, NULL, 'Other Sources Gross Income Amt', 'CURRENCY', 'ReturnData/IRS990/OtherSourcesGrossIncomeAmt'),
  (130110, NULL, NULL, 'Other Website Ind', 'BOOLEAN', 'ReturnData/IRS990/OtherWebsiteInd'),
  (130111, NULL, NULL, 'Own Website Ind', 'BOOLEAN', 'ReturnData/IRS990/OwnWebsiteInd'),
  (130112, NULL, NULL, 'PY Excess Benefit Trans Ind', 'BOOLEAN', 'ReturnData/IRS990/PYExcessBenefitTransInd'),
  (130113, NULL, NULL, 'Partial Liquidation Ind', 'BOOLEAN', 'ReturnData/IRS990/PartialLiquidationInd'),
  (130114, NULL, NULL, 'Pay Premiums Prsnl Bnft Cntrct Ind', 'BOOLEAN', 'ReturnData/IRS990/PayPremiumsPrsnlBnftCntrctInd'),
  (130115, NULL, NULL, 'Policies Reference Chapters Ind', 'BOOLEAN', 'ReturnData/IRS990/PoliciesReferenceChaptersInd'),
  (130116, NULL, NULL, 'Political Campaign Acty Ind', 'BOOLEAN', 'ReturnData/IRS990/PoliticalCampaignActyInd'),
  (130117, NULL, NULL, 'Principal Officer Nm', 'TEXT', 'ReturnData/IRS990/PrincipalOfficerNm'),
  (130118, NULL, NULL, 'Prior Period Adjustments Amt', 'CURRENCY', 'ReturnData/IRS990/PriorPeriodAdjustmentsAmt'),
  (130119, NULL, NULL, 'Professional Fundraising Ind', 'BOOLEAN', 'ReturnData/IRS990/ProfessionalFundraisingInd'),
  (130120, NULL, NULL, 'Prohibited Tax Shelter Trans Ind', 'BOOLEAN', 'ReturnData/IRS990/ProhibitedTaxShelterTransInd'),
  (130121, NULL, NULL, 'Quid Pro Quo Contri Discl Ind', 'BOOLEAN', 'ReturnData/IRS990/QuidProQuoContriDisclInd'),
  (130122, NULL, NULL, 'Quid Pro Quo Contributions Ind', 'BOOLEAN', 'ReturnData/IRS990/QuidProQuoContributionsInd'),
  (130123, NULL, NULL, 'Rcv Fnds To Pay Prsnl Bnft Cntrct Ind', 'BOOLEAN', 'ReturnData/IRS990/RcvFndsToPayPrsnlBnftCntrctInd'),
  (130124, NULL, NULL, 'Reconcilation Revenue Expnss Amt', 'CURRENCY', 'ReturnData/IRS990/ReconcilationRevenueExpnssAmt'),
  (130125, NULL, NULL, 'Regular Monitoring Enfrc Ind', 'BOOLEAN', 'ReturnData/IRS990/RegularMonitoringEnfrcInd'),
  (130126, NULL, NULL, 'Related Entity Ind', 'BOOLEAN', 'ReturnData/IRS990/RelatedEntityInd'),
  (130127, NULL, NULL, 'Related Organization Ctrl Ent Ind', 'BOOLEAN', 'ReturnData/IRS990/RelatedOrganizationCtrlEntInd'),
  (130128, NULL, NULL, 'Report Investments Other Sec Ind', 'BOOLEAN', 'ReturnData/IRS990/ReportInvestmentsOtherSecInd'),
  (130129, NULL, NULL, 'Report Land Building Equipment Ind', 'BOOLEAN', 'ReturnData/IRS990/ReportLandBuildingEquipmentInd'),
  (130130, NULL, NULL, 'Report Other Assets Ind', 'BOOLEAN', 'ReturnData/IRS990/ReportOtherAssetsInd'),
  (130131, NULL, NULL, 'Report Other Liabilities Ind', 'BOOLEAN', 'ReturnData/IRS990/ReportOtherLiabilitiesInd'),
  (130132, NULL, NULL, 'Report Program Related Invst Ind', 'BOOLEAN', 'ReturnData/IRS990/ReportProgramRelatedInvstInd'),
  (130133, NULL, NULL, 'Revenue Amt', 'CURRENCY', 'ReturnData/IRS990/RevenueAmt'),
  (130134, NULL, NULL, 'Schedule B Required Ind', 'BOOLEAN', 'ReturnData/IRS990/ScheduleBRequiredInd'),
  (130135, NULL, NULL, 'Schedule J Required Ind', 'BOOLEAN', 'ReturnData/IRS990/ScheduleJRequiredInd'),
  (130136, NULL, NULL, 'Schedule O Required Ind', 'BOOLEAN', 'ReturnData/IRS990/ScheduleORequiredInd'),
  (130137, NULL, NULL, 'School Operating Ind', 'BOOLEAN', 'ReturnData/IRS990/SchoolOperatingInd'),
  (130138, NULL, NULL, 'Significant Change Ind', 'BOOLEAN', 'ReturnData/IRS990/SignificantChangeInd'),
  (130139, NULL, NULL, 'Significant New Program Srvc Ind', 'BOOLEAN', 'ReturnData/IRS990/SignificantNewProgramSrvcInd'),
  (130140, NULL, NULL, 'States Where Copy Of Return Is Fld Cd', 'TEXT', 'ReturnData/IRS990/StatesWhereCopyOfReturnIsFldCd'),
  (130141, NULL, NULL, 'Subj To Tax Rmnrtn Ex Prcht Pymt Ind', 'BOOLEAN', 'ReturnData/IRS990/SubjToTaxRmnrtnExPrchtPymtInd'),
  (130142, NULL, NULL, 'Subject To Excs Tax Net Invst Inc Ind', 'BOOLEAN', 'ReturnData/IRS990/SubjectToExcsTaxNetInvstIncInd'),
  (130143, NULL, NULL, 'Subject To Proxy Tax Ind', 'BOOLEAN', 'ReturnData/IRS990/SubjectToProxyTaxInd'),
  (130144, NULL, NULL, 'Tax Exempt Bonds Ind', 'BOOLEAN', 'ReturnData/IRS990/TaxExemptBondsInd'),
  (130145, NULL, NULL, 'Taxable Distributions Ind', 'BOOLEAN', 'ReturnData/IRS990/TaxableDistributionsInd'),
  (130146, NULL, NULL, 'Taxable Party Notification Ind', 'BOOLEAN', 'ReturnData/IRS990/TaxablePartyNotificationInd'),
  (130147, NULL, NULL, 'Terminate Operations Ind', 'BOOLEAN', 'ReturnData/IRS990/TerminateOperationsInd'),
  (130148, NULL, NULL, 'Tot Reportable Comp Rltd Org Amt', 'CURRENCY', 'ReturnData/IRS990/TotReportableCompRltdOrgAmt'),
  (130149, NULL, NULL, 'Total Comp Greater Than150K Ind', 'BOOLEAN', 'ReturnData/IRS990/TotalCompGreaterThan150KInd'),
  (130150, NULL, NULL, 'Total Other Compensation Amt', 'CURRENCY', 'ReturnData/IRS990/TotalOtherCompensationAmt'),
  (130151, NULL, NULL, 'Total Other Prog Srvc Expense Amt', 'CURRENCY', 'ReturnData/IRS990/TotalOtherProgSrvcExpenseAmt'),
  (130152, NULL, NULL, 'Total Other Prog Srvc Grant Amt', 'CURRENCY', 'ReturnData/IRS990/TotalOtherProgSrvcGrantAmt'),
  (130153, NULL, NULL, 'Total Other Prog Srvc Revenue Amt', 'CURRENCY', 'ReturnData/IRS990/TotalOtherProgSrvcRevenueAmt'),
  (130154, NULL, NULL, 'Total Program Service Expenses Amt', 'CURRENCY', 'ReturnData/IRS990/TotalProgramServiceExpensesAmt'),
  (130155, NULL, NULL, 'Total Reportable Comp From Org Amt', 'CURRENCY', 'ReturnData/IRS990/TotalReportableCompFromOrgAmt'),
  (130156, NULL, NULL, 'Transaction With Control Ent Ind', 'BOOLEAN', 'ReturnData/IRS990/TransactionWithControlEntInd'),
  (130157, NULL, NULL, 'Trnsfr Exmpt Non Chrtbl Rltd Org Ind', 'BOOLEAN', 'ReturnData/IRS990/TrnsfrExmptNonChrtblRltdOrgInd'),
  (130158, NULL, NULL, 'Type Of Organization Assoc Ind', 'BOOLEAN', 'ReturnData/IRS990/TypeOfOrganizationAssocInd'),
  (130159, NULL, NULL, 'Type Of Organization Corp Ind', 'BOOLEAN', 'ReturnData/IRS990/TypeOfOrganizationCorpInd'),
  (130160, NULL, NULL, 'Type Of Organization Trust Ind', 'BOOLEAN', 'ReturnData/IRS990/TypeOfOrganizationTrustInd'),
  (130161, NULL, NULL, 'Unrelated Bus Incm Over Limit Ind', 'BOOLEAN', 'ReturnData/IRS990/UnrelatedBusIncmOverLimitInd'),
  (130162, NULL, NULL, 'Upon Request Ind', 'BOOLEAN', 'ReturnData/IRS990/UponRequestInd'),
  (130163, NULL, NULL, 'Website Address Txt', 'TEXT', 'ReturnData/IRS990/WebsiteAddressTxt'),
  (130164, NULL, NULL, 'Whistleblower Policy Ind', 'BOOLEAN', 'ReturnData/IRS990/WhistleblowerPolicyInd'),
  (130165, NULL, NULL, 'First5Years170Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/First5Years170Ind'),
  (130166, NULL, NULL, 'First5Years509Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/First5Years509Ind'),
  (130167, NULL, NULL, 'Gross Receipts Rltd Activities Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/GrossReceiptsRltdActivitiesAmt'),
  (130168, NULL, NULL, 'Investment Income CY Pct', 'PERCENT', 'ReturnData/IRS990ScheduleA/InvestmentIncomeCYPct'),
  (130169, NULL, NULL, 'Investment Income PY Pct', 'PERCENT', 'ReturnData/IRS990ScheduleA/InvestmentIncomePYPct'),
  (130170, NULL, NULL, 'Other Support Sum Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/OtherSupportSumAmt'),
  (130171, NULL, NULL, 'Public Organization170Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/PublicOrganization170Ind'),
  (130172, NULL, NULL, 'Public Support CY170Pct', 'PERCENT', 'ReturnData/IRS990ScheduleA/PublicSupportCY170Pct'),
  (130173, NULL, NULL, 'Public Support CY509Pct', 'PERCENT', 'ReturnData/IRS990ScheduleA/PublicSupportCY509Pct'),
  (130174, NULL, NULL, 'Public Support PY170Pct', 'PERCENT', 'ReturnData/IRS990ScheduleA/PublicSupportPY170Pct'),
  (130175, NULL, NULL, 'Public Support PY509Pct', 'PERCENT', 'ReturnData/IRS990ScheduleA/PublicSupportPY509Pct'),
  (130176, NULL, NULL, 'Public Support Total170Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/PublicSupportTotal170Amt'),
  (130177, NULL, NULL, 'Public Support Total509Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/PublicSupportTotal509Amt'),
  (130178, NULL, NULL, 'Publicly Supported Org509a2Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/PubliclySupportedOrg509a2Ind'),
  (130179, NULL, NULL, 'School Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/SchoolInd'),
  (130180, NULL, NULL, 'Substantial Contributors Tot Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/SubstantialContributorsTotAmt'),
  (130181, NULL, NULL, 'Support Sum Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/SupportSumAmt'),
  (130182, NULL, NULL, 'Supported Organizations Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleA/SupportedOrganizationsCnt'),
  (130183, NULL, NULL, 'Supported Organizations Total Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleA/SupportedOrganizationsTotalCnt'),
  (130184, NULL, NULL, 'Supporting Org Type1Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/SupportingOrgType1Ind'),
  (130185, NULL, NULL, 'Supporting Org Type3Non Func Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/SupportingOrgType3NonFuncInd'),
  (130186, NULL, NULL, 'Supporting Organization509a3Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/SupportingOrganization509a3Ind'),
  (130187, NULL, NULL, 'Thirty Thr Pct Suprt Tests CY170Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/ThirtyThrPctSuprtTestsCY170Ind'),
  (130188, NULL, NULL, 'Thirty Thr Pct Suprt Tests CY509Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/ThirtyThrPctSuprtTestsCY509Ind'),
  (130189, NULL, NULL, 'Total Support Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/TotalSupportAmt'),
  (130190, NULL, NULL, 'Aggregate Reported Dues Ntc Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/AggregateReportedDuesNtcAmt'),
  (130191, NULL, NULL, 'Agree Carryover Prior Year Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleC/AgreeCarryoverPriorYearInd'),
  (130192, NULL, NULL, 'Direct Contact Legislators Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/DirectContactLegislatorsAmt'),
  (130193, NULL, NULL, 'Direct Contact Legislators Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleC/DirectContactLegislatorsInd'),
  (130194, NULL, NULL, 'Dues Assessments Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/DuesAssessmentsAmt'),
  (130195, NULL, NULL, 'Grants Other Organizations Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/GrantsOtherOrganizationsAmt'),
  (130196, NULL, NULL, 'Grants Other Organizations Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleC/GrantsOtherOrganizationsInd'),
  (130197, NULL, NULL, 'Mailings Members Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleC/MailingsMembersInd'),
  (130198, NULL, NULL, 'Media Advertisements Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleC/MediaAdvertisementsInd'),
  (130199, NULL, NULL, 'Non Ded Lbbyng Pltcl Cyov Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/NonDedLbbyngPltclCyovAmt'),
  (130200, NULL, NULL, 'Non Deductible Lbbyng Pltcl CY Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/NonDeductibleLbbyngPltclCYAmt'),
  (130201, NULL, NULL, 'Non Deductible Lbbyng Pltcl Tot Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/NonDeductibleLbbyngPltclTotAmt'),
  (130202, NULL, NULL, 'Not Described Section501c3Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleC/NotDescribedSection501c3Ind'),
  (130203, NULL, NULL, 'Only In House Lobbying Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleC/OnlyInHouseLobbyingInd'),
  (130204, NULL, NULL, 'Other Activities Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/OtherActivitiesAmt'),
  (130205, NULL, NULL, 'Other Activities Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleC/OtherActivitiesInd'),
  (130206, NULL, NULL, 'Paid Staff Or Management Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleC/PaidStaffOrManagementInd'),
  (130207, NULL, NULL, 'Publications Or Broadcast Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleC/PublicationsOrBroadcastInd'),
  (130208, NULL, NULL, 'Rallies Demonstrations Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleC/RalliesDemonstrationsInd'),
  (130209, NULL, NULL, 'Substantially All Dues Nonded Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleC/SubstantiallyAllDuesNondedInd'),
  (130210, NULL, NULL, 'Taxable Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/TaxableAmt'),
  (130211, NULL, NULL, 'Total Lobbying Expenditures Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/TotalLobbyingExpendituresAmt'),
  (130212, NULL, NULL, 'Volunteers Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleC/VolunteersInd'),
  (130213, NULL, NULL, 'Agent Trustee Etc Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleD/AgentTrusteeEtcInd'),
  (130214, NULL, NULL, 'Board Designated Balance EOY Pct', 'PERCENT', 'ReturnData/IRS990ScheduleD/BoardDesignatedBalanceEOYPct'),
  (130215, NULL, NULL, 'Donated Services And Use Fclts Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/DonatedServicesAndUseFcltsAmt'),
  (130216, NULL, NULL, 'Donated Services Use Fclts Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/DonatedServicesUseFcltsAmt'),
  (130217, NULL, NULL, 'Endowments Held Related Org Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleD/EndowmentsHeldRelatedOrgInd'),
  (130218, NULL, NULL, 'Endowments Held Unrelated Org Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleD/EndowmentsHeldUnrelatedOrgInd'),
  (130219, NULL, NULL, 'Expenses Not Reported Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/ExpensesNotReportedAmt'),
  (130220, NULL, NULL, 'Expenses Not Rpt Fincl Stmt Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/ExpensesNotRptFinclStmtAmt'),
  (130221, NULL, NULL, 'Expenses Subtotal Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/ExpensesSubtotalAmt'),
  (130222, NULL, NULL, 'Footnote Text Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleD/FootnoteTextInd'),
  (130223, NULL, NULL, 'Incl Escrow Custodial Acct Liab Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleD/InclEscrowCustodialAcctLiabInd'),
  (130224, NULL, NULL, 'Investment Expenses Not Incld2Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/InvestmentExpensesNotIncld2Amt'),
  (130225, NULL, NULL, 'Investment Expenses Not Incld Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/InvestmentExpensesNotIncldAmt'),
  (130226, NULL, NULL, 'Net Unrealized Gains Invst Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/NetUnrealizedGainsInvstAmt'),
  (130227, NULL, NULL, 'Other Expenses Included Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/OtherExpensesIncludedAmt'),
  (130228, NULL, NULL, 'Other Revenue Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/OtherRevenueAmt'),
  (130229, NULL, NULL, 'Prmnnt Endowment Balance EOY Pct', 'PERCENT', 'ReturnData/IRS990ScheduleD/PrmnntEndowmentBalanceEOYPct'),
  (130230, NULL, NULL, 'Revenue Not Reported Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/RevenueNotReportedAmt'),
  (130231, NULL, NULL, 'Revenue Not Reported Fincl Stmt Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/RevenueNotReportedFinclStmtAmt'),
  (130232, NULL, NULL, 'Revenue Subtotal Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/RevenueSubtotalAmt'),
  (130233, NULL, NULL, 'Term Endowment Balance EOY Pct', 'PERCENT', 'ReturnData/IRS990ScheduleD/TermEndowmentBalanceEOYPct'),
  (130234, NULL, NULL, 'Tot Expns Etc Audited Fincl Stmt Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/TotExpnsEtcAuditedFinclStmtAmt'),
  (130235, NULL, NULL, 'Total Book Value Land Buildings Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/TotalBookValueLandBuildingsAmt'),
  (130236, NULL, NULL, 'Total Book Value Other Assets Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/TotalBookValueOtherAssetsAmt'),
  (130237, NULL, NULL, 'Total Expenses Per Form990Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/TotalExpensesPerForm990Amt'),
  (130238, NULL, NULL, 'Total Liability Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/TotalLiabilityAmt'),
  (130239, NULL, NULL, 'Total Rev Etc Audited Fincl Stmt Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/TotalRevEtcAuditedFinclStmtAmt'),
  (130240, NULL, NULL, 'Total Revenue Per Form990Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/TotalRevenuePerForm990Amt'),
  (130241, NULL, NULL, 'Compliance With Rev Proc7550Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleE/ComplianceWithRevProc7550Ind'),
  (130242, NULL, NULL, 'Discriminate Race Admiss Plcy Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleE/DiscriminateRaceAdmissPlcyInd'),
  (130243, NULL, NULL, 'Discriminate Race Athlt Prog Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleE/DiscriminateRaceAthltProgInd'),
  (130244, NULL, NULL, 'Discriminate Race Educ Plcy Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleE/DiscriminateRaceEducPlcyInd'),
  (130245, NULL, NULL, 'Discriminate Race Emplm Fculty Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleE/DiscriminateRaceEmplmFcultyInd'),
  (130246, NULL, NULL, 'Discriminate Race Other Acty Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleE/DiscriminateRaceOtherActyInd'),
  (130247, NULL, NULL, 'Discriminate Race Schs Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleE/DiscriminateRaceSchsInd'),
  (130248, NULL, NULL, 'Discriminate Race Stdnts Rghts Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleE/DiscriminateRaceStdntsRghtsInd'),
  (130249, NULL, NULL, 'Discriminate Race Use Of Fclts Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleE/DiscriminateRaceUseOfFcltsInd'),
  (130250, NULL, NULL, 'Government Financial Aid Rcvd Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleE/GovernmentFinancialAidRcvdInd'),
  (130251, NULL, NULL, 'Government Financial Aid Rvkd Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleE/GovernmentFinancialAidRvkdInd'),
  (130252, NULL, NULL, 'Maintain Cpy Of All Sol Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleE/MaintainCpyOfAllSolInd'),
  (130253, NULL, NULL, 'Maintain Cpy Of Brochures Etc Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleE/MaintainCpyOfBrochuresEtcInd'),
  (130254, NULL, NULL, 'Maintain Racial Comp Recs Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleE/MaintainRacialCompRecsInd'),
  (130255, NULL, NULL, 'Maintain Scholarships Recs Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleE/MaintainScholarshipsRecsInd'),
  (130256, NULL, NULL, 'Nondiscriminatory Policy Stmt Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleE/NondiscriminatoryPolicyStmtInd'),
  (130257, NULL, NULL, 'Plcy Pblczd Via Broadcast Media Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleE/PlcyPblczdViaBroadcastMediaInd'),
  (130258, NULL, NULL, 'Policy Stmt In Brochures Etc Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleE/PolicyStmtInBrochuresEtcInd'),
  (130259, NULL, NULL, 'Agrmt Prof Fundraising Acty Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleG/AgrmtProfFundraisingActyInd'),
  (130260, NULL, NULL, 'Charitable Distribution Rqr Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleG/CharitableDistributionRqrInd'),
  (130261, NULL, NULL, 'Cntrct With3rd Prty For Game Rev Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleG/CntrctWith3rdPrtyForGameRevInd'),
  (130262, NULL, NULL, 'Gaming Own Facility Pct', 'PERCENT', 'ReturnData/IRS990ScheduleG/GamingOwnFacilityPct'),
  (130263, NULL, NULL, 'Gaming With Nonmembers Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleG/GamingWithNonmembersInd'),
  (130264, NULL, NULL, 'License Suspended Etc Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleG/LicenseSuspendedEtcInd'),
  (130265, NULL, NULL, 'Licensed Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleG/LicensedInd'),
  (130266, NULL, NULL, 'Member Of Other Entity Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleG/MemberOfOtherEntityInd'),
  (130267, NULL, NULL, 'States Where Gaming Conducted Cd', 'TEXT', 'ReturnData/IRS990ScheduleG/StatesWhereGamingConductedCd'),
  (130268, NULL, NULL, 'Grant Records Maintained Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleI/GrantRecordsMaintainedInd'),
  (130269, NULL, NULL, 'Total501c3Org Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleI/Total501c3OrgCnt'),
  (130270, NULL, NULL, 'Total Other Org Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleI/TotalOtherOrgCnt'),
  (130271, NULL, NULL, 'Any Non Fixed Payments Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleJ/AnyNonFixedPaymentsInd'),
  (130272, NULL, NULL, 'Board Or Committee Approval Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleJ/BoardOrCommitteeApprovalInd'),
  (130273, NULL, NULL, 'Club Dues Or Fees Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleJ/ClubDuesOrFeesInd'),
  (130274, NULL, NULL, 'Comp Based On Revenue Of Flng Org Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleJ/CompBasedOnRevenueOfFlngOrgInd'),
  (130275, NULL, NULL, 'Comp Bsd Net Earns Flng Org Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleJ/CompBsdNetEarnsFlngOrgInd'),
  (130276, NULL, NULL, 'Comp Bsd Net Earns Rltd Orgs Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleJ/CompBsdNetEarnsRltdOrgsInd'),
  (130277, NULL, NULL, 'Comp Bsd On Rev Related Orgs Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleJ/CompBsdOnRevRelatedOrgsInd'),
  (130278, NULL, NULL, 'Compensation Committee Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleJ/CompensationCommitteeInd'),
  (130279, NULL, NULL, 'Compensation Survey Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleJ/CompensationSurveyInd'),
  (130280, NULL, NULL, 'Equity Based Comp Arrngm Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleJ/EquityBasedCompArrngmInd'),
  (130281, NULL, NULL, 'First Class Or Charter Travel Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleJ/FirstClassOrCharterTravelInd'),
  (130282, NULL, NULL, 'Form990Of Other Organizations Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleJ/Form990OfOtherOrganizationsInd'),
  (130283, NULL, NULL, 'Independent Consultant Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleJ/IndependentConsultantInd'),
  (130284, NULL, NULL, 'Initial Contract Exception Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleJ/InitialContractExceptionInd'),
  (130285, NULL, NULL, 'Severance Payment Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleJ/SeverancePaymentInd'),
  (130286, NULL, NULL, 'Substantiation Required Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleJ/SubstantiationRequiredInd'),
  (130287, NULL, NULL, 'Supplemental Nonqual Rtr Plan Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleJ/SupplementalNonqualRtrPlanInd'),
  (130288, NULL, NULL, 'Written Employment Contract Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleJ/WrittenEmploymentContractInd'),
  (130289, NULL, NULL, 'Written Policy Ref T And E Expnss Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleJ/WrittenPolicyRefTAndEExpnssInd'),
  (130290, NULL, NULL, 'Any Property That Must Be Held Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleM/AnyPropertyThatMustBeHeldInd'),
  (130291, NULL, NULL, 'Form8283Received Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleM/Form8283ReceivedCnt'),
  (130292, NULL, NULL, 'Review Process Unusual NC Gifts Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleM/ReviewProcessUnusualNCGiftsInd'),
  (130293, NULL, NULL, 'Third Parties Used Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleM/ThirdPartiesUsedInd'),
  (130294, NULL, NULL, 'Director Of Successor2Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleN/DirectorOfSuccessor2Ind'),
  (130295, NULL, NULL, 'Employee Of Successor2Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleN/EmployeeOfSuccessor2Ind'),
  (130296, NULL, NULL, 'Owner Of Successor2Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleN/OwnerOfSuccessor2Ind'),
  (130297, NULL, NULL, 'Receive Compensation2Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleN/ReceiveCompensation2Ind'),
  (130298, NULL, NULL, 'Asset Exchange Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleR/AssetExchangeInd'),
  (130299, NULL, NULL, 'Asset Purchase From Other Org Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleR/AssetPurchaseFromOtherOrgInd'),
  (130300, NULL, NULL, 'Asset Sale To Other Org Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleR/AssetSaleToOtherOrgInd'),
  (130301, NULL, NULL, 'Div Related Organization Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleR/DivRelatedOrganizationInd'),
  (130302, NULL, NULL, 'Gift Grnt Cap Contri From Oth Org Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleR/GiftGrntCapContriFromOthOrgInd'),
  (130303, NULL, NULL, 'Gift Grnt Or Cap Contri To Oth Org Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleR/GiftGrntOrCapContriToOthOrgInd'),
  (130304, NULL, NULL, 'Loans Or Guarantees From Oth Org Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleR/LoansOrGuaranteesFromOthOrgInd'),
  (130305, NULL, NULL, 'Loans Or Guarantees To Other Org Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleR/LoansOrGuaranteesToOtherOrgInd'),
  (130306, NULL, NULL, 'Paid Employees Sharing Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleR/PaidEmployeesSharingInd'),
  (130307, NULL, NULL, 'Perform Of Services By Other Org Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleR/PerformOfServicesByOtherOrgInd'),
  (130308, NULL, NULL, 'Perform Of Services For Oth Org Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleR/PerformOfServicesForOthOrgInd'),
  (130309, NULL, NULL, 'Receipt Of Int Annts Rnts Rylts Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleR/ReceiptOfIntAnntsRntsRyltsInd'),
  (130310, NULL, NULL, 'Reimbursement Paid By Other Org Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleR/ReimbursementPaidByOtherOrgInd'),
  (130311, NULL, NULL, 'Reimbursement Paid To Other Org Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleR/ReimbursementPaidToOtherOrgInd'),
  (130312, NULL, NULL, 'Rental Of Facilities To Oth Org Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleR/RentalOfFacilitiesToOthOrgInd'),
  (130313, NULL, NULL, 'Rental Of Fclts From Oth Org Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleR/RentalOfFcltsFromOthOrgInd'),
  (130314, NULL, NULL, 'Sharing Of Facilities Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleR/SharingOfFacilitiesInd'),
  (130315, NULL, NULL, 'Transfer From Other Org Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleR/TransferFromOtherOrgInd'),
  (130316, NULL, NULL, 'Transfer To Other Org Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleR/TransferToOtherOrgInd');

-- 990 / Acct Compile Or Review Basis Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130317, 13001, '1', 'Separate Basis Fincl Stmt Ind', 'BOOLEAN');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130317, NULL, NULL, 'Separate Basis Fincl Stmt Ind', 'BOOLEAN', 'ReturnData/IRS990/AcctCompileOrReviewBasisGrp/SeparateBasisFinclStmtInd');

-- 990 / Adjusted Net Income Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130318, 13002, '1', 'Current Year Amt', 'CURRENCY'),
  (130319, 13002, '2', 'Prior Year Amt', 'CURRENCY'),
  (130320, 13002, '3', 'Current Year Amt', 'CURRENCY'),
  (130321, 13002, '4', 'Prior Year Amt', 'CURRENCY'),
  (130322, 13002, '5', 'Current Year Amt', 'CURRENCY'),
  (130323, 13002, '6', 'Prior Year Amt', 'CURRENCY'),
  (130324, 13002, '7', 'Current Year Amt', 'CURRENCY'),
  (130325, 13002, '8', 'Prior Year Amt', 'CURRENCY'),
  (130326, 13002, '9', 'Current Year Amt', 'CURRENCY'),
  (130327, 13002, '10', 'Prior Year Amt', 'CURRENCY'),
  (130328, 13002, '11', 'Current Year Amt', 'CURRENCY'),
  (130329, 13002, '12', 'Prior Year Amt', 'CURRENCY'),
  (130330, 13002, '13', 'Current Year Amt', 'CURRENCY'),
  (130331, 13002, '14', 'Prior Year Amt', 'CURRENCY'),
  (130332, 13002, '15', 'Current Year Amt', 'CURRENCY'),
  (130333, 13002, '16', 'Prior Year Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130318, NULL, NULL, 'Current Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/AdjustedNetIncomeGrp/AdjustedGrossIncomeGrp/CurrentYearAmt'),
  (130319, NULL, NULL, 'Prior Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/AdjustedNetIncomeGrp/AdjustedGrossIncomeGrp/PriorYearAmt'),
  (130320, NULL, NULL, 'Current Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/AdjustedNetIncomeGrp/DepreciationDepletionGrp/CurrentYearAmt'),
  (130321, NULL, NULL, 'Prior Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/AdjustedNetIncomeGrp/DepreciationDepletionGrp/PriorYearAmt'),
  (130322, NULL, NULL, 'Current Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/AdjustedNetIncomeGrp/NetSTCapitalGainAdjNetIncmGrp/CurrentYearAmt'),
  (130323, NULL, NULL, 'Prior Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/AdjustedNetIncomeGrp/NetSTCapitalGainAdjNetIncmGrp/PriorYearAmt'),
  (130324, NULL, NULL, 'Current Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/AdjustedNetIncomeGrp/OtherExpensesGrp/CurrentYearAmt'),
  (130325, NULL, NULL, 'Prior Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/AdjustedNetIncomeGrp/OtherExpensesGrp/PriorYearAmt'),
  (130326, NULL, NULL, 'Current Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/AdjustedNetIncomeGrp/OtherGrossIncomeGrp/CurrentYearAmt'),
  (130327, NULL, NULL, 'Prior Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/AdjustedNetIncomeGrp/OtherGrossIncomeGrp/PriorYearAmt'),
  (130328, NULL, NULL, 'Current Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/AdjustedNetIncomeGrp/ProductionIncomeGrp/CurrentYearAmt'),
  (130329, NULL, NULL, 'Prior Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/AdjustedNetIncomeGrp/ProductionIncomeGrp/PriorYearAmt'),
  (130330, NULL, NULL, 'Current Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/AdjustedNetIncomeGrp/RecoveriesPYDistributionsGrp/CurrentYearAmt'),
  (130331, NULL, NULL, 'Prior Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/AdjustedNetIncomeGrp/RecoveriesPYDistributionsGrp/PriorYearAmt'),
  (130332, NULL, NULL, 'Current Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/AdjustedNetIncomeGrp/TotalAdjustedNetIncomeGrp/CurrentYearAmt'),
  (130333, NULL, NULL, 'Prior Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/AdjustedNetIncomeGrp/TotalAdjustedNetIncomeGrp/PriorYearAmt');

-- 990 / Amounts Rcvd Dsqlfy Person Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130334, 13003, '1', 'Current Tax Year Amt', 'CURRENCY'),
  (130335, 13003, '2', 'Current Tax Year Minus1Year Amt', 'CURRENCY'),
  (130336, 13003, '3', 'Current Tax Year Minus2Years Amt', 'CURRENCY'),
  (130337, 13003, '4', 'Current Tax Year Minus3Years Amt', 'CURRENCY'),
  (130338, 13003, '5', 'Current Tax Year Minus4Years Amt', 'CURRENCY'),
  (130339, 13003, '6', 'Total Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130334, NULL, NULL, 'Current Tax Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/AmountsRcvdDsqlfyPersonGrp/CurrentTaxYearAmt'),
  (130335, NULL, NULL, 'Current Tax Year Minus1Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/AmountsRcvdDsqlfyPersonGrp/CurrentTaxYearMinus1YearAmt'),
  (130336, NULL, NULL, 'Current Tax Year Minus2Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/AmountsRcvdDsqlfyPersonGrp/CurrentTaxYearMinus2YearsAmt'),
  (130337, NULL, NULL, 'Current Tax Year Minus3Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/AmountsRcvdDsqlfyPersonGrp/CurrentTaxYearMinus3YearsAmt'),
  (130338, NULL, NULL, 'Current Tax Year Minus4Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/AmountsRcvdDsqlfyPersonGrp/CurrentTaxYearMinus4YearsAmt'),
  (130339, NULL, NULL, 'Total Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/AmountsRcvdDsqlfyPersonGrp/TotalAmt');

-- 990 / Books In Care Of Detail
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130340, 13004, '1', 'Business Name Line1Txt', 'TEXT'),
  (130341, 13004, '2', 'Person Nm', 'TEXT'),
  (130342, 13004, '3', 'Phone Num', 'TEXT'),
  (130343, 13004, '4', 'Address Line1Txt', 'TEXT'),
  (130344, 13004, '5', 'Address Line2Txt', 'TEXT'),
  (130345, 13004, '6', 'City Nm', 'TEXT'),
  (130346, 13004, '7', 'State Abbreviation Cd', 'TEXT'),
  (130347, 13004, '8', 'ZIP Cd', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130340, NULL, NULL, 'Business Name Line1Txt', 'TEXT', 'ReturnData/IRS990/BooksInCareOfDetail/BusinessName/BusinessNameLine1Txt'),
  (130341, NULL, NULL, 'Person Nm', 'TEXT', 'ReturnData/IRS990/BooksInCareOfDetail/PersonNm'),
  (130342, NULL, NULL, 'Phone Num', 'TEXT', 'ReturnData/IRS990/BooksInCareOfDetail/PhoneNum'),
  (130343, NULL, NULL, 'Address Line1Txt', 'TEXT', 'ReturnData/IRS990/BooksInCareOfDetail/USAddress/AddressLine1Txt'),
  (130344, NULL, NULL, 'Address Line2Txt', 'TEXT', 'ReturnData/IRS990/BooksInCareOfDetail/USAddress/AddressLine2Txt'),
  (130345, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990/BooksInCareOfDetail/USAddress/CityNm'),
  (130346, NULL, NULL, 'State Abbreviation Cd', 'TEXT', 'ReturnData/IRS990/BooksInCareOfDetail/USAddress/StateAbbreviationCd'),
  (130347, NULL, NULL, 'ZIP Cd', 'TEXT', 'ReturnData/IRS990/BooksInCareOfDetail/USAddress/ZIPCd');

-- 990 / Buildings Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130348, 13005, '1', 'Book Value Amt', 'CURRENCY'),
  (130349, 13005, '2', 'Depreciation Amt', 'CURRENCY'),
  (130350, 13005, '3', 'Investment Cost Or Other Basis Amt', 'CURRENCY'),
  (130351, 13005, '4', 'Other Cost Or Other Basis Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130348, NULL, NULL, 'Book Value Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/BuildingsGrp/BookValueAmt'),
  (130349, NULL, NULL, 'Depreciation Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/BuildingsGrp/DepreciationAmt'),
  (130350, NULL, NULL, 'Investment Cost Or Other Basis Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/BuildingsGrp/InvestmentCostOrOtherBasisAmt'),
  (130351, NULL, NULL, 'Other Cost Or Other Basis Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/BuildingsGrp/OtherCostOrOtherBasisAmt');

-- 990 / CY Endwmt Fund Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130352, 13006, '1', 'Beginning Year Balance Amt', 'CURRENCY'),
  (130353, 13006, '2', 'End Year Balance Amt', 'CURRENCY'),
  (130354, 13006, '3', 'Investment Earnings Or Losses Amt', 'CURRENCY'),
  (130355, 13006, '4', 'Other Expenditures Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130352, NULL, NULL, 'Beginning Year Balance Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/CYEndwmtFundGrp/BeginningYearBalanceAmt'),
  (130353, NULL, NULL, 'End Year Balance Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/CYEndwmtFundGrp/EndYearBalanceAmt'),
  (130354, NULL, NULL, 'Investment Earnings Or Losses Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/CYEndwmtFundGrp/InvestmentEarningsOrLossesAmt'),
  (130355, NULL, NULL, 'Other Expenditures Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/CYEndwmtFundGrp/OtherExpendituresAmt');

-- 990 / CY Minus1Yr Endwmt Fund Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130356, 13007, '1', 'Beginning Year Balance Amt', 'CURRENCY'),
  (130357, 13007, '2', 'End Year Balance Amt', 'CURRENCY'),
  (130358, 13007, '3', 'Investment Earnings Or Losses Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130356, NULL, NULL, 'Beginning Year Balance Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/CYMinus1YrEndwmtFundGrp/BeginningYearBalanceAmt'),
  (130357, NULL, NULL, 'End Year Balance Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/CYMinus1YrEndwmtFundGrp/EndYearBalanceAmt'),
  (130358, NULL, NULL, 'Investment Earnings Or Losses Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/CYMinus1YrEndwmtFundGrp/InvestmentEarningsOrLossesAmt');

-- 990 / CY Minus2Yr Endwmt Fund Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130359, 13008, '1', 'Beginning Year Balance Amt', 'CURRENCY'),
  (130360, 13008, '2', 'End Year Balance Amt', 'CURRENCY'),
  (130361, 13008, '3', 'Grants Or Scholarships Amt', 'CURRENCY'),
  (130362, 13008, '4', 'Investment Earnings Or Losses Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130359, NULL, NULL, 'Beginning Year Balance Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/CYMinus2YrEndwmtFundGrp/BeginningYearBalanceAmt'),
  (130360, NULL, NULL, 'End Year Balance Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/CYMinus2YrEndwmtFundGrp/EndYearBalanceAmt'),
  (130361, NULL, NULL, 'Grants Or Scholarships Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/CYMinus2YrEndwmtFundGrp/GrantsOrScholarshipsAmt'),
  (130362, NULL, NULL, 'Investment Earnings Or Losses Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/CYMinus2YrEndwmtFundGrp/InvestmentEarningsOrLossesAmt');

-- 990 / CY Minus3Yr Endwmt Fund Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130363, 13009, '1', 'Beginning Year Balance Amt', 'CURRENCY'),
  (130364, 13009, '2', 'End Year Balance Amt', 'CURRENCY'),
  (130365, 13009, '3', 'Grants Or Scholarships Amt', 'CURRENCY'),
  (130366, 13009, '4', 'Investment Earnings Or Losses Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130363, NULL, NULL, 'Beginning Year Balance Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/CYMinus3YrEndwmtFundGrp/BeginningYearBalanceAmt'),
  (130364, NULL, NULL, 'End Year Balance Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/CYMinus3YrEndwmtFundGrp/EndYearBalanceAmt'),
  (130365, NULL, NULL, 'Grants Or Scholarships Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/CYMinus3YrEndwmtFundGrp/GrantsOrScholarshipsAmt'),
  (130366, NULL, NULL, 'Investment Earnings Or Losses Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/CYMinus3YrEndwmtFundGrp/InvestmentEarningsOrLossesAmt');

-- 990 / CY Minus4Yr Endwmt Fund Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130367, 13010, '1', 'Beginning Year Balance Amt', 'CURRENCY'),
  (130368, 13010, '2', 'End Year Balance Amt', 'CURRENCY'),
  (130369, 13010, '3', 'Grants Or Scholarships Amt', 'CURRENCY'),
  (130370, 13010, '4', 'Investment Earnings Or Losses Amt', 'CURRENCY'),
  (130371, 13010, '5', 'Other Expenditures Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130367, NULL, NULL, 'Beginning Year Balance Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/CYMinus4YrEndwmtFundGrp/BeginningYearBalanceAmt'),
  (130368, NULL, NULL, 'End Year Balance Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/CYMinus4YrEndwmtFundGrp/EndYearBalanceAmt'),
  (130369, NULL, NULL, 'Grants Or Scholarships Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/CYMinus4YrEndwmtFundGrp/GrantsOrScholarshipsAmt'),
  (130370, NULL, NULL, 'Investment Earnings Or Losses Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/CYMinus4YrEndwmtFundGrp/InvestmentEarningsOrLossesAmt'),
  (130371, NULL, NULL, 'Other Expenditures Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/CYMinus4YrEndwmtFundGrp/OtherExpendituresAmt');

-- 990 / Contractor Compensation Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130372, 13011, '1', 'Compensation Amt', 'CURRENCY'),
  (130373, 13011, '2', 'Address Line1Txt', 'TEXT'),
  (130374, 13011, '3', 'City Nm', 'TEXT'),
  (130375, 13011, '4', 'State Abbreviation Cd', 'TEXT'),
  (130376, 13011, '5', 'ZIP Cd', 'TEXT'),
  (130377, 13011, '6', 'Business Name Line1Txt', 'TEXT'),
  (130378, 13011, '7', 'Services Desc', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130372, NULL, NULL, 'Compensation Amt', 'CURRENCY', 'ReturnData/IRS990/ContractorCompensationGrp/CompensationAmt'),
  (130373, NULL, NULL, 'Address Line1Txt', 'TEXT', 'ReturnData/IRS990/ContractorCompensationGrp/ContractorAddress/USAddress/AddressLine1Txt'),
  (130374, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990/ContractorCompensationGrp/ContractorAddress/USAddress/CityNm'),
  (130375, NULL, NULL, 'State Abbreviation Cd', 'TEXT', 'ReturnData/IRS990/ContractorCompensationGrp/ContractorAddress/USAddress/StateAbbreviationCd'),
  (130376, NULL, NULL, 'ZIP Cd', 'TEXT', 'ReturnData/IRS990/ContractorCompensationGrp/ContractorAddress/USAddress/ZIPCd'),
  (130377, NULL, NULL, 'Business Name Line1Txt', 'TEXT', 'ReturnData/IRS990/ContractorCompensationGrp/ContractorName/BusinessName/BusinessNameLine1Txt'),
  (130378, NULL, NULL, 'Services Desc', 'TEXT', 'ReturnData/IRS990/ContractorCompensationGrp/ServicesDesc');

-- 990 / Contributor Information Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130379, 13012, '1', 'Business Name Line1', 'TEXT'),
  (130380, 13012, '2', 'Contributor Num', 'INTEGER'),
  (130381, 13012, '3', 'Address Line1', 'TEXT'),
  (130382, 13012, '4', 'Address Line2', 'TEXT'),
  (130383, 13012, '5', 'City', 'TEXT'),
  (130384, 13012, '6', 'State', 'TEXT'),
  (130385, 13012, '7', 'ZIP Code', 'TEXT'),
  (130386, 13012, '8', 'Total Contributions Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130379, NULL, NULL, 'Business Name Line1', 'TEXT', 'ReturnData/IRS990ScheduleB/ContributorInformationGrp/ContributorBusinessName/BusinessNameLine1'),
  (130380, NULL, NULL, 'Contributor Num', 'INTEGER', 'ReturnData/IRS990ScheduleB/ContributorInformationGrp/ContributorNum'),
  (130381, NULL, NULL, 'Address Line1', 'TEXT', 'ReturnData/IRS990ScheduleB/ContributorInformationGrp/ContributorUSAddress/AddressLine1'),
  (130382, NULL, NULL, 'Address Line2', 'TEXT', 'ReturnData/IRS990ScheduleB/ContributorInformationGrp/ContributorUSAddress/AddressLine2'),
  (130383, NULL, NULL, 'City', 'TEXT', 'ReturnData/IRS990ScheduleB/ContributorInformationGrp/ContributorUSAddress/City'),
  (130384, NULL, NULL, 'State', 'TEXT', 'ReturnData/IRS990ScheduleB/ContributorInformationGrp/ContributorUSAddress/State'),
  (130385, NULL, NULL, 'ZIP Code', 'TEXT', 'ReturnData/IRS990ScheduleB/ContributorInformationGrp/ContributorUSAddress/ZIPCode'),
  (130386, NULL, NULL, 'Total Contributions Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleB/ContributorInformationGrp/TotalContributionsAmt');

-- 990 / Disposition Of Assets Detail
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130387, 13013, '1', 'Assets Distri Or Expnss Paid Desc', 'TEXT'),
  (130388, 13013, '2', 'Business Name Line1Txt', 'TEXT'),
  (130389, 13013, '3', 'Distribution Dt', 'DATE'),
  (130390, 13013, '4', 'EIN', 'TEXT'),
  (130391, 13013, '5', 'Fair Market Value Of Asset Amt', 'CURRENCY'),
  (130392, 13013, '6', 'IRC Section Txt', 'TEXT'),
  (130393, 13013, '7', 'Method Of FMV Determination Txt', 'TEXT'),
  (130394, 13013, '8', 'Person Nm', 'TEXT'),
  (130395, 13013, '9', 'Address Line1Txt', 'TEXT'),
  (130396, 13013, '10', 'City Nm', 'TEXT'),
  (130397, 13013, '11', 'State Abbreviation Cd', 'TEXT'),
  (130398, 13013, '12', 'ZIP Cd', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130387, NULL, NULL, 'Assets Distri Or Expnss Paid Desc', 'TEXT', 'ReturnData/IRS990ScheduleN/DispositionOfAssetsDetail/AssetsDistriOrExpnssPaidDesc'),
  (130388, NULL, NULL, 'Business Name Line1Txt', 'TEXT', 'ReturnData/IRS990ScheduleN/DispositionOfAssetsDetail/BusinessName/BusinessNameLine1Txt'),
  (130389, NULL, NULL, 'Distribution Dt', 'DATE', 'ReturnData/IRS990ScheduleN/DispositionOfAssetsDetail/DistributionDt'),
  (130390, NULL, NULL, 'EIN', 'TEXT', 'ReturnData/IRS990ScheduleN/DispositionOfAssetsDetail/EIN'),
  (130391, NULL, NULL, 'Fair Market Value Of Asset Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleN/DispositionOfAssetsDetail/FairMarketValueOfAssetAmt'),
  (130392, NULL, NULL, 'IRC Section Txt', 'TEXT', 'ReturnData/IRS990ScheduleN/DispositionOfAssetsDetail/IRCSectionTxt'),
  (130393, NULL, NULL, 'Method Of FMV Determination Txt', 'TEXT', 'ReturnData/IRS990ScheduleN/DispositionOfAssetsDetail/MethodOfFMVDeterminationTxt'),
  (130394, NULL, NULL, 'Person Nm', 'TEXT', 'ReturnData/IRS990ScheduleN/DispositionOfAssetsDetail/PersonNm'),
  (130395, NULL, NULL, 'Address Line1Txt', 'TEXT', 'ReturnData/IRS990ScheduleN/DispositionOfAssetsDetail/USAddress/AddressLine1Txt'),
  (130396, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990ScheduleN/DispositionOfAssetsDetail/USAddress/CityNm'),
  (130397, NULL, NULL, 'State Abbreviation Cd', 'TEXT', 'ReturnData/IRS990ScheduleN/DispositionOfAssetsDetail/USAddress/StateAbbreviationCd'),
  (130398, NULL, NULL, 'ZIP Cd', 'TEXT', 'ReturnData/IRS990ScheduleN/DispositionOfAssetsDetail/USAddress/ZIPCd');

-- 990 / Distributable Amount Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130399, 13014, '1', 'CY Adj Net Income Distributable Amt', 'CURRENCY'),
  (130400, 13014, '2', 'CY Distributable As Adjusted Amt', 'CURRENCY'),
  (130401, 13014, '3', 'CY Greater Adjusted Minimum Amt', 'CURRENCY'),
  (130402, 13014, '4', 'CY Income Tax Imposed PY Amt', 'CURRENCY'),
  (130403, 13014, '5', 'CY Pct85Adjusted Net Income Amt', 'CURRENCY'),
  (130404, 13014, '6', 'CY Total Min Ast Distributable Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130399, NULL, NULL, 'CY Adj Net Income Distributable Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/DistributableAmountGrp/CYAdjNetIncomeDistributableAmt'),
  (130400, NULL, NULL, 'CY Distributable As Adjusted Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/DistributableAmountGrp/CYDistributableAsAdjustedAmt'),
  (130401, NULL, NULL, 'CY Greater Adjusted Minimum Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/DistributableAmountGrp/CYGreaterAdjustedMinimumAmt'),
  (130402, NULL, NULL, 'CY Income Tax Imposed PY Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/DistributableAmountGrp/CYIncomeTaxImposedPYAmt'),
  (130403, NULL, NULL, 'CY Pct85Adjusted Net Income Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/DistributableAmountGrp/CYPct85AdjustedNetIncomeAmt'),
  (130404, NULL, NULL, 'CY Total Min Ast Distributable Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/DistributableAmountGrp/CYTotalMinAstDistributableAmt');

-- 990 / Distribution Allocations Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130405, 13015, '1', 'CY Distrib App Underdistri PY Amt', 'CURRENCY'),
  (130406, 13015, '2', 'CY Distributable As Adjusted Amt', 'CURRENCY'),
  (130407, 13015, '3', 'CY Total Annual Distributions Amt', 'CURRENCY'),
  (130408, 13015, '4', 'Carryover PY Not Applied Amt', 'CURRENCY'),
  (130409, 13015, '5', 'Cyov Applied Underdistr CPY Amt', 'CURRENCY'),
  (130410, 13015, '6', 'Cyov Applied Underdistri PY Amt', 'CURRENCY'),
  (130411, 13015, '7', 'Excess Distri Cyov To Next Yr Amt', 'CURRENCY'),
  (130412, 13015, '8', 'Excess Distribution Amt', 'CURRENCY'),
  (130413, 13015, '9', 'Excess Distribution Cyov Amt', 'CURRENCY'),
  (130414, 13015, '10', 'Excess Distribution Cyov Yr1Amt', 'CURRENCY'),
  (130415, 13015, '11', 'Excess Distribution Cyov Yr2Amt', 'CURRENCY'),
  (130416, 13015, '12', 'Excess Distribution Cyov Yr3Amt', 'CURRENCY'),
  (130417, 13015, '13', 'Excess Distribution Cyov Yr4Amt', 'CURRENCY'),
  (130418, 13015, '14', 'Excess Distribution Cyov Yr5Amt', 'CURRENCY'),
  (130419, 13015, '15', 'Excess From Year1Amt', 'CURRENCY'),
  (130420, 13015, '16', 'Excess From Year2Amt', 'CURRENCY'),
  (130421, 13015, '17', 'Excess From Year3Amt', 'CURRENCY'),
  (130422, 13015, '18', 'Excess From Year4Amt', 'CURRENCY'),
  (130423, 13015, '19', 'Excess From Year5Amt', 'CURRENCY'),
  (130424, 13015, '20', 'Remaining Underdistri CY Amt', 'CURRENCY'),
  (130425, 13015, '21', 'Remaining Underdistri PY Amt', 'CURRENCY'),
  (130426, 13015, '22', 'Total Excess Distribution Cyov Amt', 'CURRENCY'),
  (130427, 13015, '23', 'Underdistributions Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130405, NULL, NULL, 'CY Distrib App Underdistri PY Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/DistributionAllocationsGrp/CYDistribAppUnderdistriPYAmt'),
  (130406, NULL, NULL, 'CY Distributable As Adjusted Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/DistributionAllocationsGrp/CYDistributableAsAdjustedAmt'),
  (130407, NULL, NULL, 'CY Total Annual Distributions Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/DistributionAllocationsGrp/CYTotalAnnualDistributionsAmt'),
  (130408, NULL, NULL, 'Carryover PY Not Applied Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/DistributionAllocationsGrp/CarryoverPYNotAppliedAmt'),
  (130409, NULL, NULL, 'Cyov Applied Underdistr CPY Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/DistributionAllocationsGrp/CyovAppliedUnderdistrCPYAmt'),
  (130410, NULL, NULL, 'Cyov Applied Underdistri PY Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/DistributionAllocationsGrp/CyovAppliedUnderdistriPYAmt'),
  (130411, NULL, NULL, 'Excess Distri Cyov To Next Yr Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/DistributionAllocationsGrp/ExcessDistriCyovToNextYrAmt'),
  (130412, NULL, NULL, 'Excess Distribution Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/DistributionAllocationsGrp/ExcessDistributionAmt'),
  (130413, NULL, NULL, 'Excess Distribution Cyov Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/DistributionAllocationsGrp/ExcessDistributionCyovAmt'),
  (130414, NULL, NULL, 'Excess Distribution Cyov Yr1Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/DistributionAllocationsGrp/ExcessDistributionCyovYr1Amt'),
  (130415, NULL, NULL, 'Excess Distribution Cyov Yr2Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/DistributionAllocationsGrp/ExcessDistributionCyovYr2Amt'),
  (130416, NULL, NULL, 'Excess Distribution Cyov Yr3Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/DistributionAllocationsGrp/ExcessDistributionCyovYr3Amt'),
  (130417, NULL, NULL, 'Excess Distribution Cyov Yr4Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/DistributionAllocationsGrp/ExcessDistributionCyovYr4Amt'),
  (130418, NULL, NULL, 'Excess Distribution Cyov Yr5Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/DistributionAllocationsGrp/ExcessDistributionCyovYr5Amt'),
  (130419, NULL, NULL, 'Excess From Year1Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/DistributionAllocationsGrp/ExcessFromYear1Amt'),
  (130420, NULL, NULL, 'Excess From Year2Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/DistributionAllocationsGrp/ExcessFromYear2Amt'),
  (130421, NULL, NULL, 'Excess From Year3Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/DistributionAllocationsGrp/ExcessFromYear3Amt'),
  (130422, NULL, NULL, 'Excess From Year4Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/DistributionAllocationsGrp/ExcessFromYear4Amt'),
  (130423, NULL, NULL, 'Excess From Year5Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/DistributionAllocationsGrp/ExcessFromYear5Amt'),
  (130424, NULL, NULL, 'Remaining Underdistri CY Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/DistributionAllocationsGrp/RemainingUnderdistriCYAmt'),
  (130425, NULL, NULL, 'Remaining Underdistri PY Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/DistributionAllocationsGrp/RemainingUnderdistriPYAmt'),
  (130426, NULL, NULL, 'Total Excess Distribution Cyov Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/DistributionAllocationsGrp/TotalExcessDistributionCyovAmt'),
  (130427, NULL, NULL, 'Underdistributions Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/DistributionAllocationsGrp/UnderdistributionsAmt');

-- 990 / Distributions Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130428, 13016, '1', 'CY Administrative Expense Paid Amt', 'CURRENCY'),
  (130429, 13016, '2', 'CY Distri Attentive Suprt Org Amt', 'CURRENCY'),
  (130430, 13016, '3', 'CY Distributable As Adjusted Amt', 'CURRENCY'),
  (130431, 13016, '4', 'CY Distribution Yr Rt', 'PERCENT'),
  (130432, 13016, '5', 'CY Other Distributions Amt', 'CURRENCY'),
  (130433, 13016, '6', 'CY Paid Accomplish Exempt Prps Amt', 'CURRENCY'),
  (130434, 13016, '7', 'CY Pd In Excess Income Activity Amt', 'CURRENCY'),
  (130435, 13016, '8', 'CY Total Annual Distributions Amt', 'CURRENCY'),
  (130436, 13016, '9', 'Exempt Use Assets Acquis Paid Amt', 'CURRENCY'),
  (130437, 13016, '10', 'Qualified Set Aside Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130428, NULL, NULL, 'CY Administrative Expense Paid Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/DistributionsGrp/CYAdministrativeExpensePaidAmt'),
  (130429, NULL, NULL, 'CY Distri Attentive Suprt Org Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/DistributionsGrp/CYDistriAttentiveSuprtOrgAmt'),
  (130430, NULL, NULL, 'CY Distributable As Adjusted Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/DistributionsGrp/CYDistributableAsAdjustedAmt'),
  (130431, NULL, NULL, 'CY Distribution Yr Rt', 'PERCENT', 'ReturnData/IRS990ScheduleA/DistributionsGrp/CYDistributionYrRt'),
  (130432, NULL, NULL, 'CY Other Distributions Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/DistributionsGrp/CYOtherDistributionsAmt'),
  (130433, NULL, NULL, 'CY Paid Accomplish Exempt Prps Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/DistributionsGrp/CYPaidAccomplishExemptPrpsAmt'),
  (130434, NULL, NULL, 'CY Pd In Excess Income Activity Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/DistributionsGrp/CYPdInExcessIncomeActivityAmt'),
  (130435, NULL, NULL, 'CY Total Annual Distributions Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/DistributionsGrp/CYTotalAnnualDistributionsAmt'),
  (130436, NULL, NULL, 'Exempt Use Assets Acquis Paid Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/DistributionsGrp/ExemptUseAssetsAcquisPaidAmt'),
  (130437, NULL, NULL, 'Qualified Set Aside Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/DistributionsGrp/QualifiedSetAsideAmt');

-- 990 / Doing Business As Name
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130438, 13017, '1', 'Business Name Line1Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130438, NULL, NULL, 'Business Name Line1Txt', 'TEXT', 'ReturnData/IRS990/DoingBusinessAsName/BusinessNameLine1Txt');

-- 990 / Drugs And Medical Supplies Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130439, 13018, '1', 'Contribution Cnt', 'INTEGER'),
  (130440, 13018, '2', 'Method Of Determining Revenues Txt', 'TEXT'),
  (130441, 13018, '3', 'Non Cash Checkbox Ind', 'BOOLEAN'),
  (130442, 13018, '4', 'Noncash Contributions Rpt F990Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130439, NULL, NULL, 'Contribution Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleM/DrugsAndMedicalSuppliesGrp/ContributionCnt'),
  (130440, NULL, NULL, 'Method Of Determining Revenues Txt', 'TEXT', 'ReturnData/IRS990ScheduleM/DrugsAndMedicalSuppliesGrp/MethodOfDeterminingRevenuesTxt'),
  (130441, NULL, NULL, 'Non Cash Checkbox Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleM/DrugsAndMedicalSuppliesGrp/NonCashCheckboxInd'),
  (130442, NULL, NULL, 'Noncash Contributions Rpt F990Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleM/DrugsAndMedicalSuppliesGrp/NoncashContributionsRptF990Amt');

-- 990 / Equipment Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130443, 13019, '1', 'Book Value Amt', 'CURRENCY'),
  (130444, 13019, '2', 'Depreciation Amt', 'CURRENCY'),
  (130445, 13019, '3', 'Investment Cost Or Other Basis Amt', 'CURRENCY'),
  (130446, 13019, '4', 'Other Cost Or Other Basis Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130443, NULL, NULL, 'Book Value Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/EquipmentGrp/BookValueAmt'),
  (130444, NULL, NULL, 'Depreciation Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/EquipmentGrp/DepreciationAmt'),
  (130445, NULL, NULL, 'Investment Cost Or Other Basis Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/EquipmentGrp/InvestmentCostOrOtherBasisAmt'),
  (130446, NULL, NULL, 'Other Cost Or Other Basis Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/EquipmentGrp/OtherCostOrOtherBasisAmt');

-- 990 / FS Audited Basis Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130447, 13020, '1', 'Consolidated Basis Fincl Stmt Ind', 'BOOLEAN'),
  (130448, 13020, '2', 'Separate Basis Fincl Stmt Ind', 'BOOLEAN');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130447, NULL, NULL, 'Consolidated Basis Fincl Stmt Ind', 'BOOLEAN', 'ReturnData/IRS990/FSAuditedBasisGrp/ConsolidatedBasisFinclStmtInd'),
  (130448, NULL, NULL, 'Separate Basis Fincl Stmt Ind', 'BOOLEAN', 'ReturnData/IRS990/FSAuditedBasisGrp/SeparateBasisFinclStmtInd');

-- 990 / Food Inventory Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130449, 13021, '1', 'Contribution Cnt', 'INTEGER'),
  (130450, 13021, '2', 'Method Of Determining Revenues Txt', 'TEXT'),
  (130451, 13021, '3', 'Non Cash Checkbox Ind', 'BOOLEAN'),
  (130452, 13021, '4', 'Noncash Contributions Rpt F990Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130449, NULL, NULL, 'Contribution Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleM/FoodInventoryGrp/ContributionCnt'),
  (130450, NULL, NULL, 'Method Of Determining Revenues Txt', 'TEXT', 'ReturnData/IRS990ScheduleM/FoodInventoryGrp/MethodOfDeterminingRevenuesTxt'),
  (130451, NULL, NULL, 'Non Cash Checkbox Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleM/FoodInventoryGrp/NonCashCheckboxInd'),
  (130452, NULL, NULL, 'Noncash Contributions Rpt F990Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleM/FoodInventoryGrp/NoncashContributionsRptF990Amt');

-- 990 / Form990Part VII Section A Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130453, 13022, '1', 'Average Hours Per Week Rltd Org Rt', 'PERCENT'),
  (130454, 13022, '2', 'Average Hours Per Week Rt', 'PERCENT'),
  (130455, 13022, '3', 'Business Name Line1Txt', 'TEXT'),
  (130456, 13022, '4', 'Highest Compensated Employee Ind', 'BOOLEAN'),
  (130457, 13022, '5', 'Individual Trustee Or Director Ind', 'BOOLEAN'),
  (130458, 13022, '6', 'Key Employee Ind', 'BOOLEAN'),
  (130459, 13022, '7', 'Officer Ind', 'BOOLEAN'),
  (130460, 13022, '8', 'Other Compensation Amt', 'CURRENCY'),
  (130461, 13022, '9', 'Person Nm', 'TEXT'),
  (130462, 13022, '10', 'Reportable Comp From Org Amt', 'CURRENCY'),
  (130463, 13022, '11', 'Reportable Comp From Rltd Org Amt', 'CURRENCY'),
  (130464, 13022, '12', 'Title Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130453, NULL, NULL, 'Average Hours Per Week Rltd Org Rt', 'PERCENT', 'ReturnData/IRS990/Form990PartVIISectionAGrp/AverageHoursPerWeekRltdOrgRt'),
  (130454, NULL, NULL, 'Average Hours Per Week Rt', 'PERCENT', 'ReturnData/IRS990/Form990PartVIISectionAGrp/AverageHoursPerWeekRt'),
  (130455, NULL, NULL, 'Business Name Line1Txt', 'TEXT', 'ReturnData/IRS990/Form990PartVIISectionAGrp/BusinessName/BusinessNameLine1Txt'),
  (130456, NULL, NULL, 'Highest Compensated Employee Ind', 'BOOLEAN', 'ReturnData/IRS990/Form990PartVIISectionAGrp/HighestCompensatedEmployeeInd'),
  (130457, NULL, NULL, 'Individual Trustee Or Director Ind', 'BOOLEAN', 'ReturnData/IRS990/Form990PartVIISectionAGrp/IndividualTrusteeOrDirectorInd'),
  (130458, NULL, NULL, 'Key Employee Ind', 'BOOLEAN', 'ReturnData/IRS990/Form990PartVIISectionAGrp/KeyEmployeeInd'),
  (130459, NULL, NULL, 'Officer Ind', 'BOOLEAN', 'ReturnData/IRS990/Form990PartVIISectionAGrp/OfficerInd'),
  (130460, NULL, NULL, 'Other Compensation Amt', 'CURRENCY', 'ReturnData/IRS990/Form990PartVIISectionAGrp/OtherCompensationAmt'),
  (130461, NULL, NULL, 'Person Nm', 'TEXT', 'ReturnData/IRS990/Form990PartVIISectionAGrp/PersonNm'),
  (130462, NULL, NULL, 'Reportable Comp From Org Amt', 'CURRENCY', 'ReturnData/IRS990/Form990PartVIISectionAGrp/ReportableCompFromOrgAmt'),
  (130463, NULL, NULL, 'Reportable Comp From Rltd Org Amt', 'CURRENCY', 'ReturnData/IRS990/Form990PartVIISectionAGrp/ReportableCompFromRltdOrgAmt'),
  (130464, NULL, NULL, 'Title Txt', 'TEXT', 'ReturnData/IRS990/Form990PartVIISectionAGrp/TitleTxt');

-- 990 / Form990Sch A Supporting Org Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130465, 13023, '1', 'Contribution35Controlled Ind', 'BOOLEAN'),
  (130466, 13023, '2', 'Contribution Controller Ind', 'BOOLEAN'),
  (130467, 13023, '3', 'Contribution Family Ind', 'BOOLEAN'),
  (130468, 13023, '4', 'Controlled Disqualified Prsn Ind', 'BOOLEAN'),
  (130469, 13023, '5', 'Disqualified Prsn Controll Int Ind', 'BOOLEAN'),
  (130470, 13023, '6', 'Disqualified Prsn Ownr Int Ind', 'BOOLEAN'),
  (130471, 13023, '7', 'Excess Business Holdings Rules Ind', 'BOOLEAN'),
  (130472, 13023, '8', 'Listed By Name Governing Doc Ind', 'BOOLEAN'),
  (130473, 13023, '9', 'Loan Disqualified Person Ind', 'BOOLEAN'),
  (130474, 13023, '10', 'Organization Change Suprt Org Ind', 'BOOLEAN'),
  (130475, 13023, '11', 'Payment Substantial Contribtr Ind', 'BOOLEAN'),
  (130476, 13023, '12', 'Support Non Supported Org Ind', 'BOOLEAN'),
  (130477, 13023, '13', 'Supported Org Not Organized US Ind', 'BOOLEAN'),
  (130478, 13023, '14', 'Supported Org Qualified Ind', 'BOOLEAN'),
  (130479, 13023, '15', 'Supported Org Section C456Ind', 'BOOLEAN'),
  (130480, 13023, '16', 'Suprt Exclusively Sec170c2B Ind', 'BOOLEAN'),
  (130481, 13023, '17', 'Suprt Org No IRS Determination Ind', 'BOOLEAN');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130465, NULL, NULL, 'Contribution35Controlled Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/Form990SchASupportingOrgGrp/Contribution35ControlledInd'),
  (130466, NULL, NULL, 'Contribution Controller Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/Form990SchASupportingOrgGrp/ContributionControllerInd'),
  (130467, NULL, NULL, 'Contribution Family Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/Form990SchASupportingOrgGrp/ContributionFamilyInd'),
  (130468, NULL, NULL, 'Controlled Disqualified Prsn Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/Form990SchASupportingOrgGrp/ControlledDisqualifiedPrsnInd'),
  (130469, NULL, NULL, 'Disqualified Prsn Controll Int Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/Form990SchASupportingOrgGrp/DisqualifiedPrsnControllIntInd'),
  (130470, NULL, NULL, 'Disqualified Prsn Ownr Int Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/Form990SchASupportingOrgGrp/DisqualifiedPrsnOwnrIntInd'),
  (130471, NULL, NULL, 'Excess Business Holdings Rules Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/Form990SchASupportingOrgGrp/ExcessBusinessHoldingsRulesInd'),
  (130472, NULL, NULL, 'Listed By Name Governing Doc Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/Form990SchASupportingOrgGrp/ListedByNameGoverningDocInd'),
  (130473, NULL, NULL, 'Loan Disqualified Person Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/Form990SchASupportingOrgGrp/LoanDisqualifiedPersonInd'),
  (130474, NULL, NULL, 'Organization Change Suprt Org Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/Form990SchASupportingOrgGrp/OrganizationChangeSuprtOrgInd'),
  (130475, NULL, NULL, 'Payment Substantial Contribtr Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/Form990SchASupportingOrgGrp/PaymentSubstantialContribtrInd'),
  (130476, NULL, NULL, 'Support Non Supported Org Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/Form990SchASupportingOrgGrp/SupportNonSupportedOrgInd'),
  (130477, NULL, NULL, 'Supported Org Not Organized US Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/Form990SchASupportingOrgGrp/SupportedOrgNotOrganizedUSInd'),
  (130478, NULL, NULL, 'Supported Org Qualified Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/Form990SchASupportingOrgGrp/SupportedOrgQualifiedInd'),
  (130479, NULL, NULL, 'Supported Org Section C456Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/Form990SchASupportingOrgGrp/SupportedOrgSectionC456Ind'),
  (130480, NULL, NULL, 'Suprt Exclusively Sec170c2B Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/Form990SchASupportingOrgGrp/SuprtExclusivelySec170c2BInd'),
  (130481, NULL, NULL, 'Suprt Org No IRS Determination Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/Form990SchASupportingOrgGrp/SuprtOrgNoIRSDeterminationInd');

-- 990 / Form990Sch A Type1Suprt Org Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130482, 13024, '1', 'Operate Benefit Non Suprt Org Ind', 'BOOLEAN'),
  (130483, 13024, '2', 'Power Appoint Majority Dir Trst Ind', 'BOOLEAN');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130482, NULL, NULL, 'Operate Benefit Non Suprt Org Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/Form990SchAType1SuprtOrgGrp/OperateBenefitNonSuprtOrgInd'),
  (130483, NULL, NULL, 'Power Appoint Majority Dir Trst Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/Form990SchAType1SuprtOrgGrp/PowerAppointMajorityDirTrstInd');

-- 990 / Form990Sch A Type3Sprt Org All Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130484, 13025, '1', 'Officers Close Relationship Ind', 'BOOLEAN'),
  (130485, 13025, '2', 'Supported Org Voice Investment Ind', 'BOOLEAN'),
  (130486, 13025, '3', 'Timely Provided Documents Ind', 'BOOLEAN');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130484, NULL, NULL, 'Officers Close Relationship Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/Form990SchAType3SprtOrgAllGrp/OfficersCloseRelationshipInd'),
  (130485, NULL, NULL, 'Supported Org Voice Investment Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/Form990SchAType3SprtOrgAllGrp/SupportedOrgVoiceInvestmentInd'),
  (130486, NULL, NULL, 'Timely Provided Documents Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/Form990SchAType3SprtOrgAllGrp/TimelyProvidedDocumentsInd');

-- 990 / Form990Schedule A Part VI Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130487, 13026, '1', 'Explanation Txt', 'TEXT'),
  (130488, 13026, '2', 'Form And Line Reference Desc', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130487, NULL, NULL, 'Explanation Txt', 'TEXT', 'ReturnData/IRS990ScheduleA/Form990ScheduleAPartVIGrp/ExplanationTxt'),
  (130488, NULL, NULL, 'Form And Line Reference Desc', 'TEXT', 'ReturnData/IRS990ScheduleA/Form990ScheduleAPartVIGrp/FormAndLineReferenceDesc');

-- 990 / Fundraising Event Information Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130489, 13027, '1', 'Cash Prizes Event1Amt', 'CURRENCY'),
  (130490, 13027, '2', 'Cash Prizes Event2Amt', 'CURRENCY'),
  (130491, 13027, '3', 'Cash Prizes Other Events Amt', 'CURRENCY'),
  (130492, 13027, '4', 'Cash Prizes Total Events Amt', 'CURRENCY'),
  (130493, 13027, '5', 'Charitable Contri Event1Amt', 'CURRENCY'),
  (130494, 13027, '6', 'Charitable Contri Event2Amt', 'CURRENCY'),
  (130495, 13027, '7', 'Charitable Contri Other Events Amt', 'CURRENCY'),
  (130496, 13027, '8', 'Charitable Contributions Tot Amt', 'CURRENCY'),
  (130497, 13027, '9', 'Direct Expense Summary Events Amt', 'CURRENCY'),
  (130498, 13027, '10', 'Entertainment Event1Amt', 'CURRENCY'),
  (130499, 13027, '11', 'Entertainment Event2Amt', 'CURRENCY'),
  (130500, 13027, '12', 'Entertainment Other Events Amt', 'CURRENCY'),
  (130501, 13027, '13', 'Entertainment Total Events Amt', 'CURRENCY'),
  (130502, 13027, '14', 'Event1Nm', 'TEXT'),
  (130503, 13027, '15', 'Event2Nm', 'TEXT'),
  (130504, 13027, '16', 'Food And Beverage Event1Amt', 'CURRENCY'),
  (130505, 13027, '17', 'Food And Beverage Event2Amt', 'CURRENCY'),
  (130506, 13027, '18', 'Food And Beverage Other Events Amt', 'CURRENCY'),
  (130507, 13027, '19', 'Food And Beverage Total Events Amt', 'CURRENCY'),
  (130508, 13027, '20', 'Gross Receipts Event1Amt', 'CURRENCY'),
  (130509, 13027, '21', 'Gross Receipts Event2Amt', 'CURRENCY'),
  (130510, 13027, '22', 'Gross Receipts Other Events Amt', 'CURRENCY'),
  (130511, 13027, '23', 'Gross Receipts Total Amt', 'CURRENCY'),
  (130512, 13027, '24', 'Gross Revenue Event1Amt', 'CURRENCY'),
  (130513, 13027, '25', 'Gross Revenue Event2Amt', 'CURRENCY'),
  (130514, 13027, '26', 'Gross Revenue Other Events Amt', 'CURRENCY'),
  (130515, 13027, '27', 'Gross Revenue Total Events Amt', 'CURRENCY'),
  (130516, 13027, '28', 'Net Income Summary Amt', 'CURRENCY'),
  (130517, 13027, '29', 'Non Cash Prizes Event1Amt', 'CURRENCY'),
  (130518, 13027, '30', 'Non Cash Prizes Event2Amt', 'CURRENCY'),
  (130519, 13027, '31', 'Non Cash Prizes Other Events Amt', 'CURRENCY'),
  (130520, 13027, '32', 'Non Cash Prizes Total Events Amt', 'CURRENCY'),
  (130521, 13027, '33', 'Oth Direct Expnss Other Events Amt', 'CURRENCY'),
  (130522, 13027, '34', 'Oth Direct Expnss Total Events Amt', 'CURRENCY'),
  (130523, 13027, '35', 'Other Direct Expenses Event1Amt', 'CURRENCY'),
  (130524, 13027, '36', 'Other Direct Expenses Event2Amt', 'CURRENCY'),
  (130525, 13027, '37', 'Rent Facility Costs Event1Amt', 'CURRENCY'),
  (130526, 13027, '38', 'Rent Facility Costs Event2Amt', 'CURRENCY'),
  (130527, 13027, '39', 'Rent Fclty Costs Other Events Amt', 'CURRENCY'),
  (130528, 13027, '40', 'Rent Fclty Costs Total Events Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130489, NULL, NULL, 'Cash Prizes Event1Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/FundraisingEventInformationGrp/CashPrizesEvent1Amt'),
  (130490, NULL, NULL, 'Cash Prizes Event2Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/FundraisingEventInformationGrp/CashPrizesEvent2Amt'),
  (130491, NULL, NULL, 'Cash Prizes Other Events Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/FundraisingEventInformationGrp/CashPrizesOtherEventsAmt'),
  (130492, NULL, NULL, 'Cash Prizes Total Events Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/FundraisingEventInformationGrp/CashPrizesTotalEventsAmt'),
  (130493, NULL, NULL, 'Charitable Contri Event1Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/FundraisingEventInformationGrp/CharitableContriEvent1Amt'),
  (130494, NULL, NULL, 'Charitable Contri Event2Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/FundraisingEventInformationGrp/CharitableContriEvent2Amt'),
  (130495, NULL, NULL, 'Charitable Contri Other Events Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/FundraisingEventInformationGrp/CharitableContriOtherEventsAmt'),
  (130496, NULL, NULL, 'Charitable Contributions Tot Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/FundraisingEventInformationGrp/CharitableContributionsTotAmt'),
  (130497, NULL, NULL, 'Direct Expense Summary Events Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/FundraisingEventInformationGrp/DirectExpenseSummaryEventsAmt'),
  (130498, NULL, NULL, 'Entertainment Event1Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/FundraisingEventInformationGrp/EntertainmentEvent1Amt'),
  (130499, NULL, NULL, 'Entertainment Event2Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/FundraisingEventInformationGrp/EntertainmentEvent2Amt'),
  (130500, NULL, NULL, 'Entertainment Other Events Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/FundraisingEventInformationGrp/EntertainmentOtherEventsAmt'),
  (130501, NULL, NULL, 'Entertainment Total Events Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/FundraisingEventInformationGrp/EntertainmentTotalEventsAmt'),
  (130502, NULL, NULL, 'Event1Nm', 'TEXT', 'ReturnData/IRS990ScheduleG/FundraisingEventInformationGrp/Event1Nm'),
  (130503, NULL, NULL, 'Event2Nm', 'TEXT', 'ReturnData/IRS990ScheduleG/FundraisingEventInformationGrp/Event2Nm'),
  (130504, NULL, NULL, 'Food And Beverage Event1Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/FundraisingEventInformationGrp/FoodAndBeverageEvent1Amt'),
  (130505, NULL, NULL, 'Food And Beverage Event2Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/FundraisingEventInformationGrp/FoodAndBeverageEvent2Amt'),
  (130506, NULL, NULL, 'Food And Beverage Other Events Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/FundraisingEventInformationGrp/FoodAndBeverageOtherEventsAmt'),
  (130507, NULL, NULL, 'Food And Beverage Total Events Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/FundraisingEventInformationGrp/FoodAndBeverageTotalEventsAmt'),
  (130508, NULL, NULL, 'Gross Receipts Event1Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/FundraisingEventInformationGrp/GrossReceiptsEvent1Amt'),
  (130509, NULL, NULL, 'Gross Receipts Event2Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/FundraisingEventInformationGrp/GrossReceiptsEvent2Amt'),
  (130510, NULL, NULL, 'Gross Receipts Other Events Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/FundraisingEventInformationGrp/GrossReceiptsOtherEventsAmt'),
  (130511, NULL, NULL, 'Gross Receipts Total Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/FundraisingEventInformationGrp/GrossReceiptsTotalAmt'),
  (130512, NULL, NULL, 'Gross Revenue Event1Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/FundraisingEventInformationGrp/GrossRevenueEvent1Amt'),
  (130513, NULL, NULL, 'Gross Revenue Event2Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/FundraisingEventInformationGrp/GrossRevenueEvent2Amt'),
  (130514, NULL, NULL, 'Gross Revenue Other Events Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/FundraisingEventInformationGrp/GrossRevenueOtherEventsAmt'),
  (130515, NULL, NULL, 'Gross Revenue Total Events Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/FundraisingEventInformationGrp/GrossRevenueTotalEventsAmt'),
  (130516, NULL, NULL, 'Net Income Summary Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/FundraisingEventInformationGrp/NetIncomeSummaryAmt'),
  (130517, NULL, NULL, 'Non Cash Prizes Event1Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/FundraisingEventInformationGrp/NonCashPrizesEvent1Amt'),
  (130518, NULL, NULL, 'Non Cash Prizes Event2Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/FundraisingEventInformationGrp/NonCashPrizesEvent2Amt'),
  (130519, NULL, NULL, 'Non Cash Prizes Other Events Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/FundraisingEventInformationGrp/NonCashPrizesOtherEventsAmt'),
  (130520, NULL, NULL, 'Non Cash Prizes Total Events Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/FundraisingEventInformationGrp/NonCashPrizesTotalEventsAmt'),
  (130521, NULL, NULL, 'Oth Direct Expnss Other Events Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/FundraisingEventInformationGrp/OthDirectExpnssOtherEventsAmt'),
  (130522, NULL, NULL, 'Oth Direct Expnss Total Events Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/FundraisingEventInformationGrp/OthDirectExpnssTotalEventsAmt'),
  (130523, NULL, NULL, 'Other Direct Expenses Event1Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/FundraisingEventInformationGrp/OtherDirectExpensesEvent1Amt'),
  (130524, NULL, NULL, 'Other Direct Expenses Event2Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/FundraisingEventInformationGrp/OtherDirectExpensesEvent2Amt'),
  (130525, NULL, NULL, 'Rent Facility Costs Event1Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/FundraisingEventInformationGrp/RentFacilityCostsEvent1Amt'),
  (130526, NULL, NULL, 'Rent Facility Costs Event2Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/FundraisingEventInformationGrp/RentFacilityCostsEvent2Amt'),
  (130527, NULL, NULL, 'Rent Fclty Costs Other Events Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/FundraisingEventInformationGrp/RentFcltyCostsOtherEventsAmt'),
  (130528, NULL, NULL, 'Rent Fclty Costs Total Events Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/FundraisingEventInformationGrp/RentFcltyCostsTotalEventsAmt');

-- 990 / Gaming Information Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130529, 13028, '1', 'Cash Prizes Pull Tabs Amt', 'CURRENCY'),
  (130530, 13028, '2', 'Cash Prizes Total Gaming Amt', 'CURRENCY'),
  (130531, 13028, '3', 'Direct Expense Summary Gaming Amt', 'CURRENCY'),
  (130532, 13028, '4', 'Gross Revenue Pull Tabs Amt', 'CURRENCY'),
  (130533, 13028, '5', 'Gross Revenue Total Gaming Amt', 'CURRENCY'),
  (130534, 13028, '6', 'Net Gaming Income Summary Amt', 'CURRENCY'),
  (130535, 13028, '7', 'Oth Direct Expnss Total Gaming Amt', 'CURRENCY'),
  (130536, 13028, '8', 'Other Direct Expenses Pull Tabs Amt', 'CURRENCY'),
  (130537, 13028, '9', 'Volunteer Labor Pull Tabs Ind', 'BOOLEAN');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130529, NULL, NULL, 'Cash Prizes Pull Tabs Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/GamingInformationGrp/CashPrizesPullTabsAmt'),
  (130530, NULL, NULL, 'Cash Prizes Total Gaming Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/GamingInformationGrp/CashPrizesTotalGamingAmt'),
  (130531, NULL, NULL, 'Direct Expense Summary Gaming Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/GamingInformationGrp/DirectExpenseSummaryGamingAmt'),
  (130532, NULL, NULL, 'Gross Revenue Pull Tabs Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/GamingInformationGrp/GrossRevenuePullTabsAmt'),
  (130533, NULL, NULL, 'Gross Revenue Total Gaming Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/GamingInformationGrp/GrossRevenueTotalGamingAmt'),
  (130534, NULL, NULL, 'Net Gaming Income Summary Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/GamingInformationGrp/NetGamingIncomeSummaryAmt'),
  (130535, NULL, NULL, 'Oth Direct Expnss Total Gaming Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/GamingInformationGrp/OthDirectExpnssTotalGamingAmt'),
  (130536, NULL, NULL, 'Other Direct Expenses Pull Tabs Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/GamingInformationGrp/OtherDirectExpensesPullTabsAmt'),
  (130537, NULL, NULL, 'Volunteer Labor Pull Tabs Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleG/GamingInformationGrp/VolunteerLaborPullTabsInd');

-- 990 / Gifts Grants Contri Rcvd170 Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130538, 13029, '1', 'Current Tax Year Amt', 'CURRENCY'),
  (130539, 13029, '2', 'Current Tax Year Minus1Year Amt', 'CURRENCY'),
  (130540, 13029, '3', 'Current Tax Year Minus2Years Amt', 'CURRENCY'),
  (130541, 13029, '4', 'Current Tax Year Minus3Years Amt', 'CURRENCY'),
  (130542, 13029, '5', 'Current Tax Year Minus4Years Amt', 'CURRENCY'),
  (130543, 13029, '6', 'Total Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130538, NULL, NULL, 'Current Tax Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/GiftsGrantsContriRcvd170Grp/CurrentTaxYearAmt'),
  (130539, NULL, NULL, 'Current Tax Year Minus1Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/GiftsGrantsContriRcvd170Grp/CurrentTaxYearMinus1YearAmt'),
  (130540, NULL, NULL, 'Current Tax Year Minus2Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/GiftsGrantsContriRcvd170Grp/CurrentTaxYearMinus2YearsAmt'),
  (130541, NULL, NULL, 'Current Tax Year Minus3Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/GiftsGrantsContriRcvd170Grp/CurrentTaxYearMinus3YearsAmt'),
  (130542, NULL, NULL, 'Current Tax Year Minus4Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/GiftsGrantsContriRcvd170Grp/CurrentTaxYearMinus4YearsAmt'),
  (130543, NULL, NULL, 'Total Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/GiftsGrantsContriRcvd170Grp/TotalAmt');

-- 990 / Gifts Grants Contris Rcvd509 Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130544, 13030, '1', 'Current Tax Year Amt', 'CURRENCY'),
  (130545, 13030, '2', 'Current Tax Year Minus1Year Amt', 'CURRENCY'),
  (130546, 13030, '3', 'Current Tax Year Minus2Years Amt', 'CURRENCY'),
  (130547, 13030, '4', 'Current Tax Year Minus3Years Amt', 'CURRENCY'),
  (130548, 13030, '5', 'Current Tax Year Minus4Years Amt', 'CURRENCY'),
  (130549, 13030, '6', 'Total Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130544, NULL, NULL, 'Current Tax Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/GiftsGrantsContrisRcvd509Grp/CurrentTaxYearAmt'),
  (130545, NULL, NULL, 'Current Tax Year Minus1Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/GiftsGrantsContrisRcvd509Grp/CurrentTaxYearMinus1YearAmt'),
  (130546, NULL, NULL, 'Current Tax Year Minus2Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/GiftsGrantsContrisRcvd509Grp/CurrentTaxYearMinus2YearsAmt'),
  (130547, NULL, NULL, 'Current Tax Year Minus3Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/GiftsGrantsContrisRcvd509Grp/CurrentTaxYearMinus3YearsAmt'),
  (130548, NULL, NULL, 'Current Tax Year Minus4Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/GiftsGrantsContrisRcvd509Grp/CurrentTaxYearMinus4YearsAmt'),
  (130549, NULL, NULL, 'Total Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/GiftsGrantsContrisRcvd509Grp/TotalAmt');

-- 990 / Govt Furn Srvc Fclts Vl170 Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130550, 13031, '1', 'Total Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130550, NULL, NULL, 'Total Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/GovtFurnSrvcFcltsVl170Grp/TotalAmt');

-- 990 / Govt Furn Srvc Fclts Vl509 Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130551, 13032, '1', 'Total Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130551, NULL, NULL, 'Total Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/GovtFurnSrvcFcltsVl509Grp/TotalAmt');

-- 990 / Grants Other Asst To Indiv In US Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130552, 13033, '1', 'Cash Grant Amt', 'CURRENCY'),
  (130553, 13033, '2', 'Grant Type Txt', 'TEXT'),
  (130554, 13033, '3', 'Non Cash Assistance Amt', 'CURRENCY'),
  (130555, 13033, '4', 'Non Cash Assistance Desc', 'TEXT'),
  (130556, 13033, '5', 'Recipient Cnt', 'INTEGER'),
  (130557, 13033, '6', 'Valuation Method Used Desc', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130552, NULL, NULL, 'Cash Grant Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleI/GrantsOtherAsstToIndivInUSGrp/CashGrantAmt'),
  (130553, NULL, NULL, 'Grant Type Txt', 'TEXT', 'ReturnData/IRS990ScheduleI/GrantsOtherAsstToIndivInUSGrp/GrantTypeTxt'),
  (130554, NULL, NULL, 'Non Cash Assistance Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleI/GrantsOtherAsstToIndivInUSGrp/NonCashAssistanceAmt'),
  (130555, NULL, NULL, 'Non Cash Assistance Desc', 'TEXT', 'ReturnData/IRS990ScheduleI/GrantsOtherAsstToIndivInUSGrp/NonCashAssistanceDesc'),
  (130556, NULL, NULL, 'Recipient Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleI/GrantsOtherAsstToIndivInUSGrp/RecipientCnt'),
  (130557, NULL, NULL, 'Valuation Method Used Desc', 'TEXT', 'ReturnData/IRS990ScheduleI/GrantsOtherAsstToIndivInUSGrp/ValuationMethodUsedDesc');

-- 990 / Grnt Asst Bnft Interested Prsn Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130558, 13034, '1', 'Cash Grant Amt', 'CURRENCY'),
  (130559, 13034, '2', 'Person Nm', 'TEXT'),
  (130560, 13034, '3', 'Relationship With Org Txt', 'TEXT'),
  (130561, 13034, '4', 'Type Of Assistance Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130558, NULL, NULL, 'Cash Grant Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleL/GrntAsstBnftInterestedPrsnGrp/CashGrantAmt'),
  (130559, NULL, NULL, 'Person Nm', 'TEXT', 'ReturnData/IRS990ScheduleL/GrntAsstBnftInterestedPrsnGrp/PersonNm'),
  (130560, NULL, NULL, 'Relationship With Org Txt', 'TEXT', 'ReturnData/IRS990ScheduleL/GrntAsstBnftInterestedPrsnGrp/RelationshipWithOrgTxt'),
  (130561, NULL, NULL, 'Type Of Assistance Txt', 'TEXT', 'ReturnData/IRS990ScheduleL/GrntAsstBnftInterestedPrsnGrp/TypeOfAssistanceTxt');

-- 990 / Gross Investment Income170 Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130562, 13035, '1', 'Current Tax Year Amt', 'CURRENCY'),
  (130563, 13035, '2', 'Current Tax Year Minus1Year Amt', 'CURRENCY'),
  (130564, 13035, '3', 'Current Tax Year Minus2Years Amt', 'CURRENCY'),
  (130565, 13035, '4', 'Current Tax Year Minus3Years Amt', 'CURRENCY'),
  (130566, 13035, '5', 'Current Tax Year Minus4Years Amt', 'CURRENCY'),
  (130567, 13035, '6', 'Total Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130562, NULL, NULL, 'Current Tax Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/GrossInvestmentIncome170Grp/CurrentTaxYearAmt'),
  (130563, NULL, NULL, 'Current Tax Year Minus1Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/GrossInvestmentIncome170Grp/CurrentTaxYearMinus1YearAmt'),
  (130564, NULL, NULL, 'Current Tax Year Minus2Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/GrossInvestmentIncome170Grp/CurrentTaxYearMinus2YearsAmt'),
  (130565, NULL, NULL, 'Current Tax Year Minus3Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/GrossInvestmentIncome170Grp/CurrentTaxYearMinus3YearsAmt'),
  (130566, NULL, NULL, 'Current Tax Year Minus4Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/GrossInvestmentIncome170Grp/CurrentTaxYearMinus4YearsAmt'),
  (130567, NULL, NULL, 'Total Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/GrossInvestmentIncome170Grp/TotalAmt');

-- 990 / Gross Investment Income509 Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130568, 13036, '1', 'Current Tax Year Amt', 'CURRENCY'),
  (130569, 13036, '2', 'Current Tax Year Minus1Year Amt', 'CURRENCY'),
  (130570, 13036, '3', 'Current Tax Year Minus2Years Amt', 'CURRENCY'),
  (130571, 13036, '4', 'Current Tax Year Minus3Years Amt', 'CURRENCY'),
  (130572, 13036, '5', 'Current Tax Year Minus4Years Amt', 'CURRENCY'),
  (130573, 13036, '6', 'Total Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130568, NULL, NULL, 'Current Tax Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/GrossInvestmentIncome509Grp/CurrentTaxYearAmt'),
  (130569, NULL, NULL, 'Current Tax Year Minus1Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/GrossInvestmentIncome509Grp/CurrentTaxYearMinus1YearAmt'),
  (130570, NULL, NULL, 'Current Tax Year Minus2Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/GrossInvestmentIncome509Grp/CurrentTaxYearMinus2YearsAmt'),
  (130571, NULL, NULL, 'Current Tax Year Minus3Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/GrossInvestmentIncome509Grp/CurrentTaxYearMinus3YearsAmt'),
  (130572, NULL, NULL, 'Current Tax Year Minus4Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/GrossInvestmentIncome509Grp/CurrentTaxYearMinus4YearsAmt'),
  (130573, NULL, NULL, 'Total Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/GrossInvestmentIncome509Grp/TotalAmt');

-- 990 / Gross Receipts Admissions Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130574, 13037, '1', 'Current Tax Year Amt', 'CURRENCY'),
  (130575, 13037, '2', 'Current Tax Year Minus1Year Amt', 'CURRENCY'),
  (130576, 13037, '3', 'Current Tax Year Minus2Years Amt', 'CURRENCY'),
  (130577, 13037, '4', 'Current Tax Year Minus3Years Amt', 'CURRENCY'),
  (130578, 13037, '5', 'Current Tax Year Minus4Years Amt', 'CURRENCY'),
  (130579, 13037, '6', 'Total Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130574, NULL, NULL, 'Current Tax Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/GrossReceiptsAdmissionsGrp/CurrentTaxYearAmt'),
  (130575, NULL, NULL, 'Current Tax Year Minus1Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/GrossReceiptsAdmissionsGrp/CurrentTaxYearMinus1YearAmt'),
  (130576, NULL, NULL, 'Current Tax Year Minus2Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/GrossReceiptsAdmissionsGrp/CurrentTaxYearMinus2YearsAmt'),
  (130577, NULL, NULL, 'Current Tax Year Minus3Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/GrossReceiptsAdmissionsGrp/CurrentTaxYearMinus3YearsAmt'),
  (130578, NULL, NULL, 'Current Tax Year Minus4Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/GrossReceiptsAdmissionsGrp/CurrentTaxYearMinus4YearsAmt'),
  (130579, NULL, NULL, 'Total Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/GrossReceiptsAdmissionsGrp/TotalAmt');

-- 990 / Gross Receipts Non Unrlt Bus Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130580, 13038, '1', 'Total Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130580, NULL, NULL, 'Total Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/GrossReceiptsNonUnrltBusGrp/TotalAmt');

-- 990 / Id Related Org Txbl Corp Tr Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130581, 13039, '1', 'Controlled Organization Ind', 'BOOLEAN'),
  (130582, 13039, '2', 'Direct Controlling NA Cd', 'TEXT'),
  (130583, 13039, '3', 'EIN', 'TEXT'),
  (130584, 13039, '4', 'Entity Type Txt', 'TEXT'),
  (130585, 13039, '5', 'Legal Domicile State Cd', 'TEXT'),
  (130586, 13039, '6', 'Ownership Pct', 'PERCENT'),
  (130587, 13039, '7', 'Primary Activities Txt', 'TEXT'),
  (130588, 13039, '8', 'Business Name Line1Txt', 'TEXT'),
  (130589, 13039, '9', 'Address Line1Txt', 'TEXT'),
  (130590, 13039, '10', 'City Nm', 'TEXT'),
  (130591, 13039, '11', 'State Abbreviation Cd', 'TEXT'),
  (130592, 13039, '12', 'ZIP Cd', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130581, NULL, NULL, 'Controlled Organization Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleR/IdRelatedOrgTxblCorpTrGrp/ControlledOrganizationInd'),
  (130582, NULL, NULL, 'Direct Controlling NA Cd', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedOrgTxblCorpTrGrp/DirectControllingNACd'),
  (130583, NULL, NULL, 'EIN', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedOrgTxblCorpTrGrp/EIN'),
  (130584, NULL, NULL, 'Entity Type Txt', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedOrgTxblCorpTrGrp/EntityTypeTxt'),
  (130585, NULL, NULL, 'Legal Domicile State Cd', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedOrgTxblCorpTrGrp/LegalDomicileStateCd'),
  (130586, NULL, NULL, 'Ownership Pct', 'PERCENT', 'ReturnData/IRS990ScheduleR/IdRelatedOrgTxblCorpTrGrp/OwnershipPct'),
  (130587, NULL, NULL, 'Primary Activities Txt', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedOrgTxblCorpTrGrp/PrimaryActivitiesTxt'),
  (130588, NULL, NULL, 'Business Name Line1Txt', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedOrgTxblCorpTrGrp/RelatedOrganizationName/BusinessNameLine1Txt'),
  (130589, NULL, NULL, 'Address Line1Txt', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedOrgTxblCorpTrGrp/USAddress/AddressLine1Txt'),
  (130590, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedOrgTxblCorpTrGrp/USAddress/CityNm'),
  (130591, NULL, NULL, 'State Abbreviation Cd', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedOrgTxblCorpTrGrp/USAddress/StateAbbreviationCd'),
  (130592, NULL, NULL, 'ZIP Cd', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedOrgTxblCorpTrGrp/USAddress/ZIPCd');

-- 990 / Id Related Tax Exempt Org Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130593, 13040, '1', 'Controlled Organization Ind', 'BOOLEAN'),
  (130594, 13040, '2', 'Business Name Line1Txt', 'TEXT'),
  (130595, 13040, '3', 'Direct Controlling NA Cd', 'TEXT'),
  (130596, 13040, '4', 'Business Name Line1Txt', 'TEXT'),
  (130597, 13040, '5', 'EIN', 'TEXT'),
  (130598, 13040, '6', 'Exempt Code Section Txt', 'TEXT'),
  (130599, 13040, '7', 'Legal Domicile State Cd', 'TEXT'),
  (130600, 13040, '8', 'Primary Activities Txt', 'TEXT'),
  (130601, 13040, '9', 'Public Charity Status Txt', 'TEXT'),
  (130602, 13040, '10', 'Address Line1Txt', 'TEXT'),
  (130603, 13040, '11', 'City Nm', 'TEXT'),
  (130604, 13040, '12', 'State Abbreviation Cd', 'TEXT'),
  (130605, 13040, '13', 'ZIP Cd', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130593, NULL, NULL, 'Controlled Organization Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleR/IdRelatedTaxExemptOrgGrp/ControlledOrganizationInd'),
  (130594, NULL, NULL, 'Business Name Line1Txt', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedTaxExemptOrgGrp/DirectControllingEntityName/BusinessNameLine1Txt'),
  (130595, NULL, NULL, 'Direct Controlling NA Cd', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedTaxExemptOrgGrp/DirectControllingNACd'),
  (130596, NULL, NULL, 'Business Name Line1Txt', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedTaxExemptOrgGrp/DisregardedEntityName/BusinessNameLine1Txt'),
  (130597, NULL, NULL, 'EIN', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedTaxExemptOrgGrp/EIN'),
  (130598, NULL, NULL, 'Exempt Code Section Txt', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedTaxExemptOrgGrp/ExemptCodeSectionTxt'),
  (130599, NULL, NULL, 'Legal Domicile State Cd', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedTaxExemptOrgGrp/LegalDomicileStateCd'),
  (130600, NULL, NULL, 'Primary Activities Txt', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedTaxExemptOrgGrp/PrimaryActivitiesTxt'),
  (130601, NULL, NULL, 'Public Charity Status Txt', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedTaxExemptOrgGrp/PublicCharityStatusTxt'),
  (130602, NULL, NULL, 'Address Line1Txt', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedTaxExemptOrgGrp/USAddress/AddressLine1Txt'),
  (130603, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedTaxExemptOrgGrp/USAddress/CityNm'),
  (130604, NULL, NULL, 'State Abbreviation Cd', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedTaxExemptOrgGrp/USAddress/StateAbbreviationCd'),
  (130605, NULL, NULL, 'ZIP Cd', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedTaxExemptOrgGrp/USAddress/ZIPCd');

-- 990 / Investment Income And UBTI Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130606, 13041, '1', 'Current Tax Year Amt', 'CURRENCY'),
  (130607, 13041, '2', 'Current Tax Year Minus1Year Amt', 'CURRENCY'),
  (130608, 13041, '3', 'Current Tax Year Minus2Years Amt', 'CURRENCY'),
  (130609, 13041, '4', 'Current Tax Year Minus3Years Amt', 'CURRENCY'),
  (130610, 13041, '5', 'Current Tax Year Minus4Years Amt', 'CURRENCY'),
  (130611, 13041, '6', 'Total Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130606, NULL, NULL, 'Current Tax Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/InvestmentIncomeAndUBTIGrp/CurrentTaxYearAmt'),
  (130607, NULL, NULL, 'Current Tax Year Minus1Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/InvestmentIncomeAndUBTIGrp/CurrentTaxYearMinus1YearAmt'),
  (130608, NULL, NULL, 'Current Tax Year Minus2Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/InvestmentIncomeAndUBTIGrp/CurrentTaxYearMinus2YearsAmt'),
  (130609, NULL, NULL, 'Current Tax Year Minus3Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/InvestmentIncomeAndUBTIGrp/CurrentTaxYearMinus3YearsAmt'),
  (130610, NULL, NULL, 'Current Tax Year Minus4Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/InvestmentIncomeAndUBTIGrp/CurrentTaxYearMinus4YearsAmt'),
  (130611, NULL, NULL, 'Total Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/InvestmentIncomeAndUBTIGrp/TotalAmt');

-- 990 / Land Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130612, 13042, '1', 'Book Value Amt', 'CURRENCY'),
  (130613, 13042, '2', 'Investment Cost Or Other Basis Amt', 'CURRENCY'),
  (130614, 13042, '3', 'Other Cost Or Other Basis Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130612, NULL, NULL, 'Book Value Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/LandGrp/BookValueAmt'),
  (130613, NULL, NULL, 'Investment Cost Or Other Basis Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/LandGrp/InvestmentCostOrOtherBasisAmt'),
  (130614, NULL, NULL, 'Other Cost Or Other Basis Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/LandGrp/OtherCostOrOtherBasisAmt');

-- 990 / Leasehold Improvements Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130615, 13043, '1', 'Book Value Amt', 'CURRENCY'),
  (130616, 13043, '2', 'Depreciation Amt', 'CURRENCY'),
  (130617, 13043, '3', 'Investment Cost Or Other Basis Amt', 'CURRENCY'),
  (130618, 13043, '4', 'Other Cost Or Other Basis Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130615, NULL, NULL, 'Book Value Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/LeaseholdImprovementsGrp/BookValueAmt'),
  (130616, NULL, NULL, 'Depreciation Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/LeaseholdImprovementsGrp/DepreciationAmt'),
  (130617, NULL, NULL, 'Investment Cost Or Other Basis Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/LeaseholdImprovementsGrp/InvestmentCostOrOtherBasisAmt'),
  (130618, NULL, NULL, 'Other Cost Or Other Basis Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/LeaseholdImprovementsGrp/OtherCostOrOtherBasisAmt');

-- 990 / Minimum Asset Amount Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130619, 13044, '1', 'Current Year Amt', 'CURRENCY'),
  (130620, 13044, '2', 'Prior Year Amt', 'CURRENCY'),
  (130621, 13044, '3', 'Current Year Amt', 'CURRENCY'),
  (130622, 13044, '4', 'Prior Year Amt', 'CURRENCY'),
  (130623, 13044, '5', 'Current Year Amt', 'CURRENCY'),
  (130624, 13044, '6', 'Prior Year Amt', 'CURRENCY'),
  (130625, 13044, '7', 'Current Year Amt', 'CURRENCY'),
  (130626, 13044, '8', 'Prior Year Amt', 'CURRENCY'),
  (130627, 13044, '9', 'Current Year Amt', 'CURRENCY'),
  (130628, 13044, '10', 'Prior Year Amt', 'CURRENCY'),
  (130629, 13044, '11', 'Discount Claimed Amt', 'CURRENCY'),
  (130630, 13044, '12', 'Current Year Amt', 'CURRENCY'),
  (130631, 13044, '13', 'Prior Year Amt', 'CURRENCY'),
  (130632, 13044, '14', 'Current Year Amt', 'CURRENCY'),
  (130633, 13044, '15', 'Prior Year Amt', 'CURRENCY'),
  (130634, 13044, '16', 'Current Year Amt', 'CURRENCY'),
  (130635, 13044, '17', 'Prior Year Amt', 'CURRENCY'),
  (130636, 13044, '18', 'Current Year Amt', 'CURRENCY'),
  (130637, 13044, '19', 'Prior Year Amt', 'CURRENCY'),
  (130638, 13044, '20', 'Current Year Amt', 'CURRENCY'),
  (130639, 13044, '21', 'Prior Year Amt', 'CURRENCY'),
  (130640, 13044, '22', 'Current Year Amt', 'CURRENCY'),
  (130641, 13044, '23', 'Prior Year Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130619, NULL, NULL, 'Current Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/MinimumAssetAmountGrp/AcquisitionIndebtednessGrp/CurrentYearAmt'),
  (130620, NULL, NULL, 'Prior Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/MinimumAssetAmountGrp/AcquisitionIndebtednessGrp/PriorYearAmt'),
  (130621, NULL, NULL, 'Current Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/MinimumAssetAmountGrp/AdjustedFMVLessIndebtednessGrp/CurrentYearAmt'),
  (130622, NULL, NULL, 'Prior Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/MinimumAssetAmountGrp/AdjustedFMVLessIndebtednessGrp/PriorYearAmt'),
  (130623, NULL, NULL, 'Current Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/MinimumAssetAmountGrp/AverageMonthlyCashBalancesGrp/CurrentYearAmt'),
  (130624, NULL, NULL, 'Prior Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/MinimumAssetAmountGrp/AverageMonthlyCashBalancesGrp/PriorYearAmt'),
  (130625, NULL, NULL, 'Current Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/MinimumAssetAmountGrp/AverageMonthlyFMVOfSecGrp/CurrentYearAmt'),
  (130626, NULL, NULL, 'Prior Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/MinimumAssetAmountGrp/AverageMonthlyFMVOfSecGrp/PriorYearAmt'),
  (130627, NULL, NULL, 'Current Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/MinimumAssetAmountGrp/CashDeemedCharitableGrp/CurrentYearAmt'),
  (130628, NULL, NULL, 'Prior Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/MinimumAssetAmountGrp/CashDeemedCharitableGrp/PriorYearAmt'),
  (130629, NULL, NULL, 'Discount Claimed Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/MinimumAssetAmountGrp/DiscountClaimedAmt'),
  (130630, NULL, NULL, 'Current Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/MinimumAssetAmountGrp/FMVOtherNonExemptUseAssetGrp/CurrentYearAmt'),
  (130631, NULL, NULL, 'Prior Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/MinimumAssetAmountGrp/FMVOtherNonExemptUseAssetGrp/PriorYearAmt'),
  (130632, NULL, NULL, 'Current Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/MinimumAssetAmountGrp/NetVlNonExemptUseAssetsGrp/CurrentYearAmt'),
  (130633, NULL, NULL, 'Prior Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/MinimumAssetAmountGrp/NetVlNonExemptUseAssetsGrp/PriorYearAmt'),
  (130634, NULL, NULL, 'Current Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/MinimumAssetAmountGrp/PctOfNetVlNonExemptUseAstGrp/CurrentYearAmt'),
  (130635, NULL, NULL, 'Prior Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/MinimumAssetAmountGrp/PctOfNetVlNonExemptUseAstGrp/PriorYearAmt'),
  (130636, NULL, NULL, 'Current Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/MinimumAssetAmountGrp/RecoveriesPYDistriMinAssetGrp/CurrentYearAmt'),
  (130637, NULL, NULL, 'Prior Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/MinimumAssetAmountGrp/RecoveriesPYDistriMinAssetGrp/PriorYearAmt'),
  (130638, NULL, NULL, 'Current Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/MinimumAssetAmountGrp/TotalFMVOfNonExemptUseAssetGrp/CurrentYearAmt'),
  (130639, NULL, NULL, 'Prior Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/MinimumAssetAmountGrp/TotalFMVOfNonExemptUseAssetGrp/PriorYearAmt'),
  (130640, NULL, NULL, 'Current Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/MinimumAssetAmountGrp/TotalMinimumAssetGrp/CurrentYearAmt'),
  (130641, NULL, NULL, 'Prior Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/MinimumAssetAmountGrp/TotalMinimumAssetGrp/PriorYearAmt');

-- 990 / Net Income From Other UBI Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130642, 13045, '1', 'Current Tax Year Amt', 'CURRENCY'),
  (130643, 13045, '2', 'Current Tax Year Minus1Year Amt', 'CURRENCY'),
  (130644, 13045, '3', 'Current Tax Year Minus2Years Amt', 'CURRENCY'),
  (130645, 13045, '4', 'Current Tax Year Minus3Years Amt', 'CURRENCY'),
  (130646, 13045, '5', 'Current Tax Year Minus4Years Amt', 'CURRENCY'),
  (130647, 13045, '6', 'Total Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130642, NULL, NULL, 'Current Tax Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/NetIncomeFromOtherUBIGrp/CurrentTaxYearAmt'),
  (130643, NULL, NULL, 'Current Tax Year Minus1Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/NetIncomeFromOtherUBIGrp/CurrentTaxYearMinus1YearAmt'),
  (130644, NULL, NULL, 'Current Tax Year Minus2Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/NetIncomeFromOtherUBIGrp/CurrentTaxYearMinus2YearsAmt'),
  (130645, NULL, NULL, 'Current Tax Year Minus3Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/NetIncomeFromOtherUBIGrp/CurrentTaxYearMinus3YearsAmt'),
  (130646, NULL, NULL, 'Current Tax Year Minus4Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/NetIncomeFromOtherUBIGrp/CurrentTaxYearMinus4YearsAmt'),
  (130647, NULL, NULL, 'Total Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/NetIncomeFromOtherUBIGrp/TotalAmt');

-- 990 / Other Assets Org Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130648, 13046, '1', 'Book Value Amt', 'CURRENCY'),
  (130649, 13046, '2', 'Desc', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130648, NULL, NULL, 'Book Value Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/OtherAssetsOrgGrp/BookValueAmt'),
  (130649, NULL, NULL, 'Desc', 'TEXT', 'ReturnData/IRS990ScheduleD/OtherAssetsOrgGrp/Desc');

-- 990 / Other Income170 Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130650, 13047, '1', 'Current Tax Year Amt', 'CURRENCY'),
  (130651, 13047, '2', 'Current Tax Year Minus1Year Amt', 'CURRENCY'),
  (130652, 13047, '3', 'Current Tax Year Minus2Years Amt', 'CURRENCY'),
  (130653, 13047, '4', 'Current Tax Year Minus3Years Amt', 'CURRENCY'),
  (130654, 13047, '5', 'Current Tax Year Minus4Years Amt', 'CURRENCY'),
  (130655, 13047, '6', 'Total Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130650, NULL, NULL, 'Current Tax Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/OtherIncome170Grp/CurrentTaxYearAmt'),
  (130651, NULL, NULL, 'Current Tax Year Minus1Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/OtherIncome170Grp/CurrentTaxYearMinus1YearAmt'),
  (130652, NULL, NULL, 'Current Tax Year Minus2Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/OtherIncome170Grp/CurrentTaxYearMinus2YearsAmt'),
  (130653, NULL, NULL, 'Current Tax Year Minus3Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/OtherIncome170Grp/CurrentTaxYearMinus3YearsAmt'),
  (130654, NULL, NULL, 'Current Tax Year Minus4Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/OtherIncome170Grp/CurrentTaxYearMinus4YearsAmt'),
  (130655, NULL, NULL, 'Total Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/OtherIncome170Grp/TotalAmt');

-- 990 / Other Income509 Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130656, 13048, '1', 'Current Tax Year Amt', 'CURRENCY'),
  (130657, 13048, '2', 'Current Tax Year Minus1Year Amt', 'CURRENCY'),
  (130658, 13048, '3', 'Current Tax Year Minus2Years Amt', 'CURRENCY'),
  (130659, 13048, '4', 'Current Tax Year Minus3Years Amt', 'CURRENCY'),
  (130660, 13048, '5', 'Current Tax Year Minus4Years Amt', 'CURRENCY'),
  (130661, 13048, '6', 'Total Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130656, NULL, NULL, 'Current Tax Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/OtherIncome509Grp/CurrentTaxYearAmt'),
  (130657, NULL, NULL, 'Current Tax Year Minus1Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/OtherIncome509Grp/CurrentTaxYearMinus1YearAmt'),
  (130658, NULL, NULL, 'Current Tax Year Minus2Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/OtherIncome509Grp/CurrentTaxYearMinus2YearsAmt'),
  (130659, NULL, NULL, 'Current Tax Year Minus3Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/OtherIncome509Grp/CurrentTaxYearMinus3YearsAmt'),
  (130660, NULL, NULL, 'Current Tax Year Minus4Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/OtherIncome509Grp/CurrentTaxYearMinus4YearsAmt'),
  (130661, NULL, NULL, 'Total Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/OtherIncome509Grp/TotalAmt');

-- 990 / Other Land Buildings Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130662, 13049, '1', 'Book Value Amt', 'CURRENCY'),
  (130663, 13049, '2', 'Depreciation Amt', 'CURRENCY'),
  (130664, 13049, '3', 'Investment Cost Or Other Basis Amt', 'CURRENCY'),
  (130665, 13049, '4', 'Other Cost Or Other Basis Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130662, NULL, NULL, 'Book Value Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/OtherLandBuildingsGrp/BookValueAmt'),
  (130663, NULL, NULL, 'Depreciation Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/OtherLandBuildingsGrp/DepreciationAmt'),
  (130664, NULL, NULL, 'Investment Cost Or Other Basis Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/OtherLandBuildingsGrp/InvestmentCostOrOtherBasisAmt'),
  (130665, NULL, NULL, 'Other Cost Or Other Basis Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/OtherLandBuildingsGrp/OtherCostOrOtherBasisAmt');

INSERT OR IGNORE INTO
  part (part_id, form_code, part_number, part_name)
VALUES
  (14, '990', 'EXT2', 'Extended Fields (2)');

INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13050, 14, '001', 'Other Liabilities Org Group'),
  (13051, 14, '002', 'Other Non Cash Contri Table Group'),
  (13052, 14, '003', 'Other Revenue Misc Group'),
  (13053, 14, '004', 'Post1975UBTI Group'),
  (13054, 14, '005', 'Principal Ofcr Business Name'),
  (13055, 14, '006', 'Procedures Corrective Action Group'),
  (13056, 14, '007', 'Prog Srvc Accom Acty Other Group'),
  (13057, 14, '008', 'Prog Srvc Accom Acty2 Group'),
  (13058, 14, '009', 'Prog Srvc Accom Acty3 Group'),
  (13059, 14, '010', 'Program Service Revenue Group'),
  (13060, 14, '011', 'Real Estate Residential Group'),
  (13061, 14, '012', 'Recipient Table'),
  (13062, 14, '013', 'Rltd Org Officer Trst Key Empl Group'),
  (13063, 14, '014', 'Subst And Dsqlfy Prsns Tot Group'),
  (13064, 14, '015', 'Substantial Contributors Amt Group'),
  (13065, 14, '016', 'Supplemental Information Detail'),
  (13066, 14, '017', 'Supported Org Information Group'),
  (13067, 14, '018', 'Tax Exempt Bonds Arbitrage Group'),
  (13068, 14, '019', 'Tax Exempt Bonds Issues Group'),
  (13069, 14, '020', 'Tax Exempt Bonds Private Bus Use Group'),
  (13070, 14, '021', 'Tax Exempt Bonds Proceeds Group'),
  (13071, 14, '022', 'Tax Rev Levied Orgnztnl Bnft170 Group'),
  (13072, 14, '023', 'Tax Rev Levied Orgnztnl Bnft509 Group'),
  (13073, 14, '024', 'Total Calendar Year170 Group'),
  (13074, 14, '025', 'Total Joint Costs Group'),
  (13075, 14, '026', 'Total Support Calendar Year Group'),
  (13076, 14, '027', 'Total509 Group'),
  (13077, 14, '028', 'Transactions Related Org Group'),
  (13078, 14, '029', 'US Address'),
  (13079, 14, '030', 'Unrelated Business Net Incm170 Group');

-- 990 / Other Liabilities Org Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130666, 13050, '1', 'Amt', 'CURRENCY'),
  (130667, 13050, '2', 'Desc', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130666, NULL, NULL, 'Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/OtherLiabilitiesOrgGrp/Amt'),
  (130667, NULL, NULL, 'Desc', 'TEXT', 'ReturnData/IRS990ScheduleD/OtherLiabilitiesOrgGrp/Desc');

-- 990 / Other Non Cash Contri Table Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130668, 13051, '1', 'Contribution Cnt', 'INTEGER'),
  (130669, 13051, '2', 'Desc', 'TEXT'),
  (130670, 13051, '3', 'Method Of Determining Revenues Txt', 'TEXT'),
  (130671, 13051, '4', 'Non Cash Checkbox Ind', 'BOOLEAN'),
  (130672, 13051, '5', 'Noncash Contributions Rpt F990Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130668, NULL, NULL, 'Contribution Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleM/OtherNonCashContriTableGrp/ContributionCnt'),
  (130669, NULL, NULL, 'Desc', 'TEXT', 'ReturnData/IRS990ScheduleM/OtherNonCashContriTableGrp/Desc'),
  (130670, NULL, NULL, 'Method Of Determining Revenues Txt', 'TEXT', 'ReturnData/IRS990ScheduleM/OtherNonCashContriTableGrp/MethodOfDeterminingRevenuesTxt'),
  (130671, NULL, NULL, 'Non Cash Checkbox Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleM/OtherNonCashContriTableGrp/NonCashCheckboxInd'),
  (130672, NULL, NULL, 'Noncash Contributions Rpt F990Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleM/OtherNonCashContriTableGrp/NoncashContributionsRptF990Amt');

-- 990 / Other Revenue Misc Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130673, 13052, '1', 'Business Cd', 'TEXT'),
  (130674, 13052, '2', 'Desc', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130673, NULL, NULL, 'Business Cd', 'TEXT', 'ReturnData/IRS990/OtherRevenueMiscGrp/BusinessCd'),
  (130674, NULL, NULL, 'Desc', 'TEXT', 'ReturnData/IRS990/OtherRevenueMiscGrp/Desc');

-- 990 / Post1975UBTI Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130675, 13053, '1', 'Total Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130675, NULL, NULL, 'Total Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/Post1975UBTIGrp/TotalAmt');

-- 990 / Principal Ofcr Business Name
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130676, 13054, '1', 'Business Name Line1Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130676, NULL, NULL, 'Business Name Line1Txt', 'TEXT', 'ReturnData/IRS990/PrincipalOfcrBusinessName/BusinessNameLine1Txt');

-- 990 / Procedures Corrective Action Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130677, 13055, '1', 'Bond Reference Cd', 'TEXT'),
  (130678, 13055, '2', 'Procedures Corrective Action Ind', 'BOOLEAN');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130677, NULL, NULL, 'Bond Reference Cd', 'TEXT', 'ReturnData/IRS990ScheduleK/ProceduresCorrectiveActionGrp/BondReferenceCd'),
  (130678, NULL, NULL, 'Procedures Corrective Action Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleK/ProceduresCorrectiveActionGrp/ProceduresCorrectiveActionInd');

-- 990 / Prog Srvc Accom Acty Other Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130679, 13056, '1', 'Desc', 'TEXT'),
  (130680, 13056, '2', 'Expense Amt', 'CURRENCY'),
  (130681, 13056, '3', 'Grant Amt', 'CURRENCY'),
  (130682, 13056, '4', 'Revenue Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130679, NULL, NULL, 'Desc', 'TEXT', 'ReturnData/IRS990/ProgSrvcAccomActyOtherGrp/Desc'),
  (130680, NULL, NULL, 'Expense Amt', 'CURRENCY', 'ReturnData/IRS990/ProgSrvcAccomActyOtherGrp/ExpenseAmt'),
  (130681, NULL, NULL, 'Grant Amt', 'CURRENCY', 'ReturnData/IRS990/ProgSrvcAccomActyOtherGrp/GrantAmt'),
  (130682, NULL, NULL, 'Revenue Amt', 'CURRENCY', 'ReturnData/IRS990/ProgSrvcAccomActyOtherGrp/RevenueAmt');

-- 990 / Prog Srvc Accom Acty2 Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130683, 13057, '1', 'Desc', 'TEXT'),
  (130684, 13057, '2', 'Expense Amt', 'CURRENCY'),
  (130685, 13057, '3', 'Grant Amt', 'CURRENCY'),
  (130686, 13057, '4', 'Revenue Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130683, NULL, NULL, 'Desc', 'TEXT', 'ReturnData/IRS990/ProgSrvcAccomActy2Grp/Desc'),
  (130684, NULL, NULL, 'Expense Amt', 'CURRENCY', 'ReturnData/IRS990/ProgSrvcAccomActy2Grp/ExpenseAmt'),
  (130685, NULL, NULL, 'Grant Amt', 'CURRENCY', 'ReturnData/IRS990/ProgSrvcAccomActy2Grp/GrantAmt'),
  (130686, NULL, NULL, 'Revenue Amt', 'CURRENCY', 'ReturnData/IRS990/ProgSrvcAccomActy2Grp/RevenueAmt');

-- 990 / Prog Srvc Accom Acty3 Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130687, 13058, '1', 'Desc', 'TEXT'),
  (130688, 13058, '2', 'Expense Amt', 'CURRENCY'),
  (130689, 13058, '3', 'Grant Amt', 'CURRENCY'),
  (130690, 13058, '4', 'Revenue Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130687, NULL, NULL, 'Desc', 'TEXT', 'ReturnData/IRS990/ProgSrvcAccomActy3Grp/Desc'),
  (130688, NULL, NULL, 'Expense Amt', 'CURRENCY', 'ReturnData/IRS990/ProgSrvcAccomActy3Grp/ExpenseAmt'),
  (130689, NULL, NULL, 'Grant Amt', 'CURRENCY', 'ReturnData/IRS990/ProgSrvcAccomActy3Grp/GrantAmt'),
  (130690, NULL, NULL, 'Revenue Amt', 'CURRENCY', 'ReturnData/IRS990/ProgSrvcAccomActy3Grp/RevenueAmt');

-- 990 / Program Service Revenue Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130691, 13059, '1', 'Business Cd', 'TEXT'),
  (130692, 13059, '2', 'Desc', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130691, NULL, NULL, 'Business Cd', 'TEXT', 'ReturnData/IRS990/ProgramServiceRevenueGrp/BusinessCd'),
  (130692, NULL, NULL, 'Desc', 'TEXT', 'ReturnData/IRS990/ProgramServiceRevenueGrp/Desc');

-- 990 / Real Estate Residential Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130693, 13060, '1', 'Contribution Cnt', 'INTEGER'),
  (130694, 13060, '2', 'Method Of Determining Revenues Txt', 'TEXT'),
  (130695, 13060, '3', 'Non Cash Checkbox Ind', 'BOOLEAN'),
  (130696, 13060, '4', 'Noncash Contributions Rpt F990Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130693, NULL, NULL, 'Contribution Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleM/RealEstateResidentialGrp/ContributionCnt'),
  (130694, NULL, NULL, 'Method Of Determining Revenues Txt', 'TEXT', 'ReturnData/IRS990ScheduleM/RealEstateResidentialGrp/MethodOfDeterminingRevenuesTxt'),
  (130695, NULL, NULL, 'Non Cash Checkbox Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleM/RealEstateResidentialGrp/NonCashCheckboxInd'),
  (130696, NULL, NULL, 'Noncash Contributions Rpt F990Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleM/RealEstateResidentialGrp/NoncashContributionsRptF990Amt');

-- 990 / Recipient Table
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130697, 13061, '1', 'Cash Grant Amt', 'CURRENCY'),
  (130698, 13061, '2', 'IRC Section Desc', 'TEXT'),
  (130699, 13061, '3', 'Non Cash Assistance Amt', 'CURRENCY'),
  (130700, 13061, '4', 'Non Cash Assistance Desc', 'TEXT'),
  (130701, 13061, '5', 'Purpose Of Grant Txt', 'TEXT'),
  (130702, 13061, '6', 'Business Name Line1Txt', 'TEXT'),
  (130703, 13061, '7', 'Recipient EIN', 'TEXT'),
  (130704, 13061, '8', 'Address Line1Txt', 'TEXT'),
  (130705, 13061, '9', 'City Nm', 'TEXT'),
  (130706, 13061, '10', 'State Abbreviation Cd', 'TEXT'),
  (130707, 13061, '11', 'ZIP Cd', 'TEXT'),
  (130708, 13061, '12', 'Valuation Method Used Desc', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130697, NULL, NULL, 'Cash Grant Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleI/RecipientTable/CashGrantAmt'),
  (130698, NULL, NULL, 'IRC Section Desc', 'TEXT', 'ReturnData/IRS990ScheduleI/RecipientTable/IRCSectionDesc'),
  (130699, NULL, NULL, 'Non Cash Assistance Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleI/RecipientTable/NonCashAssistanceAmt'),
  (130700, NULL, NULL, 'Non Cash Assistance Desc', 'TEXT', 'ReturnData/IRS990ScheduleI/RecipientTable/NonCashAssistanceDesc'),
  (130701, NULL, NULL, 'Purpose Of Grant Txt', 'TEXT', 'ReturnData/IRS990ScheduleI/RecipientTable/PurposeOfGrantTxt'),
  (130702, NULL, NULL, 'Business Name Line1Txt', 'TEXT', 'ReturnData/IRS990ScheduleI/RecipientTable/RecipientBusinessName/BusinessNameLine1Txt'),
  (130703, NULL, NULL, 'Recipient EIN', 'TEXT', 'ReturnData/IRS990ScheduleI/RecipientTable/RecipientEIN'),
  (130704, NULL, NULL, 'Address Line1Txt', 'TEXT', 'ReturnData/IRS990ScheduleI/RecipientTable/USAddress/AddressLine1Txt'),
  (130705, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990ScheduleI/RecipientTable/USAddress/CityNm'),
  (130706, NULL, NULL, 'State Abbreviation Cd', 'TEXT', 'ReturnData/IRS990ScheduleI/RecipientTable/USAddress/StateAbbreviationCd'),
  (130707, NULL, NULL, 'ZIP Cd', 'TEXT', 'ReturnData/IRS990ScheduleI/RecipientTable/USAddress/ZIPCd'),
  (130708, NULL, NULL, 'Valuation Method Used Desc', 'TEXT', 'ReturnData/IRS990ScheduleI/RecipientTable/ValuationMethodUsedDesc');

-- 990 / Rltd Org Officer Trst Key Empl Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130709, 13062, '1', 'Base Compensation Filing Org Amt', 'CURRENCY'),
  (130710, 13062, '2', 'Bonus Filing Organization Amount', 'CURRENCY'),
  (130711, 13062, '3', 'Bonus Related Organizations Amt', 'CURRENCY'),
  (130712, 13062, '4', 'Comp Report Prior990Filing Org Amt', 'CURRENCY'),
  (130713, 13062, '5', 'Comp Report Prior990Rltd Orgs Amt', 'CURRENCY'),
  (130714, 13062, '6', 'Compensation Based On Rltd Orgs Amt', 'CURRENCY'),
  (130715, 13062, '7', 'Deferred Comp Rltd Orgs Amt', 'CURRENCY'),
  (130716, 13062, '8', 'Deferred Compensation Flng Org Amt', 'CURRENCY'),
  (130717, 13062, '9', 'Nontaxable Benefits Filing Org Amt', 'CURRENCY'),
  (130718, 13062, '10', 'Nontaxable Benefits Rltd Orgs Amt', 'CURRENCY'),
  (130719, 13062, '11', 'Other Compensation Filing Org Amt', 'CURRENCY'),
  (130720, 13062, '12', 'Other Compensation Rltd Orgs Amt', 'CURRENCY'),
  (130721, 13062, '13', 'Person Nm', 'TEXT'),
  (130722, 13062, '14', 'Title Txt', 'TEXT'),
  (130723, 13062, '15', 'Total Compensation Filing Org Amt', 'CURRENCY'),
  (130724, 13062, '16', 'Total Compensation Rltd Orgs Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130709, NULL, NULL, 'Base Compensation Filing Org Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleJ/RltdOrgOfficerTrstKeyEmplGrp/BaseCompensationFilingOrgAmt'),
  (130710, NULL, NULL, 'Bonus Filing Organization Amount', 'CURRENCY', 'ReturnData/IRS990ScheduleJ/RltdOrgOfficerTrstKeyEmplGrp/BonusFilingOrganizationAmount'),
  (130711, NULL, NULL, 'Bonus Related Organizations Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleJ/RltdOrgOfficerTrstKeyEmplGrp/BonusRelatedOrganizationsAmt'),
  (130712, NULL, NULL, 'Comp Report Prior990Filing Org Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleJ/RltdOrgOfficerTrstKeyEmplGrp/CompReportPrior990FilingOrgAmt'),
  (130713, NULL, NULL, 'Comp Report Prior990Rltd Orgs Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleJ/RltdOrgOfficerTrstKeyEmplGrp/CompReportPrior990RltdOrgsAmt'),
  (130714, NULL, NULL, 'Compensation Based On Rltd Orgs Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleJ/RltdOrgOfficerTrstKeyEmplGrp/CompensationBasedOnRltdOrgsAmt'),
  (130715, NULL, NULL, 'Deferred Comp Rltd Orgs Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleJ/RltdOrgOfficerTrstKeyEmplGrp/DeferredCompRltdOrgsAmt'),
  (130716, NULL, NULL, 'Deferred Compensation Flng Org Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleJ/RltdOrgOfficerTrstKeyEmplGrp/DeferredCompensationFlngOrgAmt'),
  (130717, NULL, NULL, 'Nontaxable Benefits Filing Org Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleJ/RltdOrgOfficerTrstKeyEmplGrp/NontaxableBenefitsFilingOrgAmt'),
  (130718, NULL, NULL, 'Nontaxable Benefits Rltd Orgs Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleJ/RltdOrgOfficerTrstKeyEmplGrp/NontaxableBenefitsRltdOrgsAmt'),
  (130719, NULL, NULL, 'Other Compensation Filing Org Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleJ/RltdOrgOfficerTrstKeyEmplGrp/OtherCompensationFilingOrgAmt'),
  (130720, NULL, NULL, 'Other Compensation Rltd Orgs Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleJ/RltdOrgOfficerTrstKeyEmplGrp/OtherCompensationRltdOrgsAmt'),
  (130721, NULL, NULL, 'Person Nm', 'TEXT', 'ReturnData/IRS990ScheduleJ/RltdOrgOfficerTrstKeyEmplGrp/PersonNm'),
  (130722, NULL, NULL, 'Title Txt', 'TEXT', 'ReturnData/IRS990ScheduleJ/RltdOrgOfficerTrstKeyEmplGrp/TitleTxt'),
  (130723, NULL, NULL, 'Total Compensation Filing Org Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleJ/RltdOrgOfficerTrstKeyEmplGrp/TotalCompensationFilingOrgAmt'),
  (130724, NULL, NULL, 'Total Compensation Rltd Orgs Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleJ/RltdOrgOfficerTrstKeyEmplGrp/TotalCompensationRltdOrgsAmt');

-- 990 / Subst And Dsqlfy Prsns Tot Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130725, 13063, '1', 'Current Tax Year Amt', 'CURRENCY'),
  (130726, 13063, '2', 'Current Tax Year Minus1Year Amt', 'CURRENCY'),
  (130727, 13063, '3', 'Current Tax Year Minus2Years Amt', 'CURRENCY'),
  (130728, 13063, '4', 'Current Tax Year Minus3Years Amt', 'CURRENCY'),
  (130729, 13063, '5', 'Current Tax Year Minus4Years Amt', 'CURRENCY'),
  (130730, 13063, '6', 'Total Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130725, NULL, NULL, 'Current Tax Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/SubstAndDsqlfyPrsnsTotGrp/CurrentTaxYearAmt'),
  (130726, NULL, NULL, 'Current Tax Year Minus1Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/SubstAndDsqlfyPrsnsTotGrp/CurrentTaxYearMinus1YearAmt'),
  (130727, NULL, NULL, 'Current Tax Year Minus2Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/SubstAndDsqlfyPrsnsTotGrp/CurrentTaxYearMinus2YearsAmt'),
  (130728, NULL, NULL, 'Current Tax Year Minus3Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/SubstAndDsqlfyPrsnsTotGrp/CurrentTaxYearMinus3YearsAmt'),
  (130729, NULL, NULL, 'Current Tax Year Minus4Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/SubstAndDsqlfyPrsnsTotGrp/CurrentTaxYearMinus4YearsAmt'),
  (130730, NULL, NULL, 'Total Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/SubstAndDsqlfyPrsnsTotGrp/TotalAmt');

-- 990 / Substantial Contributors Amt Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130731, 13064, '1', 'Current Tax Year Amt', 'CURRENCY'),
  (130732, 13064, '2', 'Current Tax Year Minus1Year Amt', 'CURRENCY'),
  (130733, 13064, '3', 'Current Tax Year Minus2Years Amt', 'CURRENCY'),
  (130734, 13064, '4', 'Current Tax Year Minus3Years Amt', 'CURRENCY'),
  (130735, 13064, '5', 'Current Tax Year Minus4Years Amt', 'CURRENCY'),
  (130736, 13064, '6', 'Total Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130731, NULL, NULL, 'Current Tax Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/SubstantialContributorsAmtGrp/CurrentTaxYearAmt'),
  (130732, NULL, NULL, 'Current Tax Year Minus1Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/SubstantialContributorsAmtGrp/CurrentTaxYearMinus1YearAmt'),
  (130733, NULL, NULL, 'Current Tax Year Minus2Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/SubstantialContributorsAmtGrp/CurrentTaxYearMinus2YearsAmt'),
  (130734, NULL, NULL, 'Current Tax Year Minus3Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/SubstantialContributorsAmtGrp/CurrentTaxYearMinus3YearsAmt'),
  (130735, NULL, NULL, 'Current Tax Year Minus4Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/SubstantialContributorsAmtGrp/CurrentTaxYearMinus4YearsAmt'),
  (130736, NULL, NULL, 'Total Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/SubstantialContributorsAmtGrp/TotalAmt');

-- 990 / Supplemental Information Detail
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130737, 13065, '1', 'Explanation Txt', 'TEXT'),
  (130738, 13065, '2', 'Form And Line Reference Desc', 'TEXT'),
  (130739, 13065, '3', 'Explanation Txt', 'TEXT'),
  (130740, 13065, '4', 'Form And Line Reference Desc', 'TEXT'),
  (130741, 13065, '5', 'Explanation Txt', 'TEXT'),
  (130742, 13065, '6', 'Form And Line Reference Desc', 'TEXT'),
  (130743, 13065, '7', 'Explanation Txt', 'TEXT'),
  (130744, 13065, '8', 'Form And Line Reference Desc', 'TEXT'),
  (130745, 13065, '9', 'Explanation Txt', 'TEXT'),
  (130746, 13065, '10', 'Form And Line Reference Desc', 'TEXT'),
  (130747, 13065, '11', 'Explanation Txt', 'TEXT'),
  (130748, 13065, '12', 'Form And Line Reference Desc', 'TEXT'),
  (130749, 13065, '13', 'Explanation Txt', 'TEXT'),
  (130750, 13065, '14', 'Form And Line Reference Desc', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130737, NULL, NULL, 'Explanation Txt', 'TEXT', 'ReturnData/IRS990ScheduleC/SupplementalInformationDetail/ExplanationTxt'),
  (130738, NULL, NULL, 'Form And Line Reference Desc', 'TEXT', 'ReturnData/IRS990ScheduleC/SupplementalInformationDetail/FormAndLineReferenceDesc'),
  (130739, NULL, NULL, 'Explanation Txt', 'TEXT', 'ReturnData/IRS990ScheduleD/SupplementalInformationDetail/ExplanationTxt'),
  (130740, NULL, NULL, 'Form And Line Reference Desc', 'TEXT', 'ReturnData/IRS990ScheduleD/SupplementalInformationDetail/FormAndLineReferenceDesc'),
  (130741, NULL, NULL, 'Explanation Txt', 'TEXT', 'ReturnData/IRS990ScheduleE/SupplementalInformationDetail/ExplanationTxt'),
  (130742, NULL, NULL, 'Form And Line Reference Desc', 'TEXT', 'ReturnData/IRS990ScheduleE/SupplementalInformationDetail/FormAndLineReferenceDesc'),
  (130743, NULL, NULL, 'Explanation Txt', 'TEXT', 'ReturnData/IRS990ScheduleI/SupplementalInformationDetail/ExplanationTxt'),
  (130744, NULL, NULL, 'Form And Line Reference Desc', 'TEXT', 'ReturnData/IRS990ScheduleI/SupplementalInformationDetail/FormAndLineReferenceDesc'),
  (130745, NULL, NULL, 'Explanation Txt', 'TEXT', 'ReturnData/IRS990ScheduleM/SupplementalInformationDetail/ExplanationTxt'),
  (130746, NULL, NULL, 'Form And Line Reference Desc', 'TEXT', 'ReturnData/IRS990ScheduleM/SupplementalInformationDetail/FormAndLineReferenceDesc'),
  (130747, NULL, NULL, 'Explanation Txt', 'TEXT', 'ReturnData/IRS990ScheduleO/SupplementalInformationDetail/ExplanationTxt'),
  (130748, NULL, NULL, 'Form And Line Reference Desc', 'TEXT', 'ReturnData/IRS990ScheduleO/SupplementalInformationDetail/FormAndLineReferenceDesc'),
  (130749, NULL, NULL, 'Explanation Txt', 'TEXT', 'ReturnData/IRS990ScheduleR/SupplementalInformationDetail/ExplanationTxt'),
  (130750, NULL, NULL, 'Form And Line Reference Desc', 'TEXT', 'ReturnData/IRS990ScheduleR/SupplementalInformationDetail/FormAndLineReferenceDesc');

-- 990 / Supported Org Information Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130751, 13066, '1', 'EIN', 'TEXT'),
  (130752, 13066, '2', 'Governing Document Listed Ind', 'BOOLEAN'),
  (130753, 13066, '3', 'Organization Type Cd', 'TEXT'),
  (130754, 13066, '4', 'Other Support Amt', 'CURRENCY'),
  (130755, 13066, '5', 'Support Amt', 'CURRENCY'),
  (130756, 13066, '6', 'Business Name Line1Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130751, NULL, NULL, 'EIN', 'TEXT', 'ReturnData/IRS990ScheduleA/SupportedOrgInformationGrp/EIN'),
  (130752, NULL, NULL, 'Governing Document Listed Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/SupportedOrgInformationGrp/GoverningDocumentListedInd'),
  (130753, NULL, NULL, 'Organization Type Cd', 'TEXT', 'ReturnData/IRS990ScheduleA/SupportedOrgInformationGrp/OrganizationTypeCd'),
  (130754, NULL, NULL, 'Other Support Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/SupportedOrgInformationGrp/OtherSupportAmt'),
  (130755, NULL, NULL, 'Support Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/SupportedOrgInformationGrp/SupportAmt'),
  (130756, NULL, NULL, 'Business Name Line1Txt', 'TEXT', 'ReturnData/IRS990ScheduleA/SupportedOrgInformationGrp/SupportedOrganizationName/BusinessNameLine1Txt');

-- 990 / Tax Exempt Bonds Arbitrage Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130757, 13067, '1', 'Bond Reference Cd', 'TEXT'),
  (130758, 13067, '2', 'Exception To Rebate Ind', 'BOOLEAN'),
  (130759, 13067, '3', 'Form8038T Filed Ind', 'BOOLEAN'),
  (130760, 13067, '4', 'Gross Proceeds Invested In GIC Ind', 'BOOLEAN'),
  (130761, 13067, '5', 'Gross Proceeds Invested Ind', 'BOOLEAN'),
  (130762, 13067, '6', 'Hedge Identified In Bks And Rec Ind', 'BOOLEAN'),
  (130763, 13067, '7', 'No Rebate Due Ind', 'BOOLEAN'),
  (130764, 13067, '8', 'Rebate Not Due Yet Ind', 'BOOLEAN'),
  (130765, 13067, '9', 'Variable Rate Issue Ind', 'BOOLEAN'),
  (130766, 13067, '10', 'Written Proc To Monitor Reqs Ind', 'BOOLEAN');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130757, NULL, NULL, 'Bond Reference Cd', 'TEXT', 'ReturnData/IRS990ScheduleK/TaxExemptBondsArbitrageGrp/BondReferenceCd'),
  (130758, NULL, NULL, 'Exception To Rebate Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleK/TaxExemptBondsArbitrageGrp/ExceptionToRebateInd'),
  (130759, NULL, NULL, 'Form8038T Filed Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleK/TaxExemptBondsArbitrageGrp/Form8038TFiledInd'),
  (130760, NULL, NULL, 'Gross Proceeds Invested In GIC Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleK/TaxExemptBondsArbitrageGrp/GrossProceedsInvestedInGICInd'),
  (130761, NULL, NULL, 'Gross Proceeds Invested Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleK/TaxExemptBondsArbitrageGrp/GrossProceedsInvestedInd'),
  (130762, NULL, NULL, 'Hedge Identified In Bks And Rec Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleK/TaxExemptBondsArbitrageGrp/HedgeIdentifiedInBksAndRecInd'),
  (130763, NULL, NULL, 'No Rebate Due Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleK/TaxExemptBondsArbitrageGrp/NoRebateDueInd'),
  (130764, NULL, NULL, 'Rebate Not Due Yet Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleK/TaxExemptBondsArbitrageGrp/RebateNotDueYetInd'),
  (130765, NULL, NULL, 'Variable Rate Issue Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleK/TaxExemptBondsArbitrageGrp/VariableRateIssueInd'),
  (130766, NULL, NULL, 'Written Proc To Monitor Reqs Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleK/TaxExemptBondsArbitrageGrp/WrittenProcToMonitorReqsInd');

-- 990 / Tax Exempt Bonds Issues Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130767, 13068, '1', 'Bond Issued Dt', 'DATE'),
  (130768, 13068, '2', 'Bond Issuer EIN', 'TEXT'),
  (130769, 13068, '3', 'Bond Reference Cd', 'TEXT'),
  (130770, 13068, '4', 'Defeased Ind', 'BOOLEAN'),
  (130771, 13068, '5', 'Issue Price Amt', 'CURRENCY'),
  (130772, 13068, '6', 'Business Name Line1Txt', 'TEXT'),
  (130773, 13068, '7', 'On Behalf Of Issuer Ind', 'BOOLEAN'),
  (130774, 13068, '8', 'Pool Financing Ind', 'BOOLEAN'),
  (130775, 13068, '9', 'Purpose Desc', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130767, NULL, NULL, 'Bond Issued Dt', 'DATE', 'ReturnData/IRS990ScheduleK/TaxExemptBondsIssuesGrp/BondIssuedDt'),
  (130768, NULL, NULL, 'Bond Issuer EIN', 'TEXT', 'ReturnData/IRS990ScheduleK/TaxExemptBondsIssuesGrp/BondIssuerEIN'),
  (130769, NULL, NULL, 'Bond Reference Cd', 'TEXT', 'ReturnData/IRS990ScheduleK/TaxExemptBondsIssuesGrp/BondReferenceCd'),
  (130770, NULL, NULL, 'Defeased Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleK/TaxExemptBondsIssuesGrp/DefeasedInd'),
  (130771, NULL, NULL, 'Issue Price Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleK/TaxExemptBondsIssuesGrp/IssuePriceAmt'),
  (130772, NULL, NULL, 'Business Name Line1Txt', 'TEXT', 'ReturnData/IRS990ScheduleK/TaxExemptBondsIssuesGrp/IssuerName/BusinessNameLine1Txt'),
  (130773, NULL, NULL, 'On Behalf Of Issuer Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleK/TaxExemptBondsIssuesGrp/OnBehalfOfIssuerInd'),
  (130774, NULL, NULL, 'Pool Financing Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleK/TaxExemptBondsIssuesGrp/PoolFinancingInd'),
  (130775, NULL, NULL, 'Purpose Desc', 'TEXT', 'ReturnData/IRS990ScheduleK/TaxExemptBondsIssuesGrp/PurposeDesc');

-- 990 / Tax Exempt Bonds Private Bus Use Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130776, 13069, '1', 'Any Lease Arrangements Ind', 'BOOLEAN'),
  (130777, 13069, '2', 'Any Research Agreements Ind', 'BOOLEAN'),
  (130778, 13069, '3', 'Bond Iss Meet Prvt Sec Pymt Test Ind', 'BOOLEAN'),
  (130779, 13069, '4', 'Bond Reference Cd', 'TEXT'),
  (130780, 13069, '5', 'Change In Use Bond Financed Prop Ind', 'BOOLEAN'),
  (130781, 13069, '6', 'Mgmt Contract Bond Fincd Prop Ind', 'BOOLEAN'),
  (130782, 13069, '7', 'Owning Bond Financed Property Ind', 'BOOLEAN'),
  (130783, 13069, '8', 'Procs Nonqualified Bond Remdtd Ind', 'BOOLEAN');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130776, NULL, NULL, 'Any Lease Arrangements Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleK/TaxExemptBondsPrivateBusUseGrp/AnyLeaseArrangementsInd'),
  (130777, NULL, NULL, 'Any Research Agreements Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleK/TaxExemptBondsPrivateBusUseGrp/AnyResearchAgreementsInd'),
  (130778, NULL, NULL, 'Bond Iss Meet Prvt Sec Pymt Test Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleK/TaxExemptBondsPrivateBusUseGrp/BondIssMeetPrvtSecPymtTestInd'),
  (130779, NULL, NULL, 'Bond Reference Cd', 'TEXT', 'ReturnData/IRS990ScheduleK/TaxExemptBondsPrivateBusUseGrp/BondReferenceCd'),
  (130780, NULL, NULL, 'Change In Use Bond Financed Prop Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleK/TaxExemptBondsPrivateBusUseGrp/ChangeInUseBondFinancedPropInd'),
  (130781, NULL, NULL, 'Mgmt Contract Bond Fincd Prop Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleK/TaxExemptBondsPrivateBusUseGrp/MgmtContractBondFincdPropInd'),
  (130782, NULL, NULL, 'Owning Bond Financed Property Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleK/TaxExemptBondsPrivateBusUseGrp/OwningBondFinancedPropertyInd'),
  (130783, NULL, NULL, 'Procs Nonqualified Bond Remdtd Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleK/TaxExemptBondsPrivateBusUseGrp/ProcsNonqualifiedBondRemdtdInd');

-- 990 / Tax Exempt Bonds Proceeds Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130784, 13070, '1', 'Adequate Books And Rec Maint Ind', 'BOOLEAN'),
  (130785, 13070, '2', 'Bond Reference Cd', 'TEXT'),
  (130786, 13070, '3', 'Capital Expenditures Amt', 'CURRENCY'),
  (130787, 13070, '4', 'Final Allocation Made Ind', 'BOOLEAN'),
  (130788, 13070, '5', 'Other Spent Proceeds Amt', 'CURRENCY'),
  (130789, 13070, '6', 'Refunding Tax Exempt Bonds Ind', 'BOOLEAN'),
  (130790, 13070, '7', 'Refunding Taxable Bonds Ind', 'BOOLEAN'),
  (130791, 13070, '8', 'Substantial Completion Yr', 'TEXT'),
  (130792, 13070, '9', 'Total Proceeds Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130784, NULL, NULL, 'Adequate Books And Rec Maint Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleK/TaxExemptBondsProceedsGrp/AdequateBooksAndRecMaintInd'),
  (130785, NULL, NULL, 'Bond Reference Cd', 'TEXT', 'ReturnData/IRS990ScheduleK/TaxExemptBondsProceedsGrp/BondReferenceCd'),
  (130786, NULL, NULL, 'Capital Expenditures Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleK/TaxExemptBondsProceedsGrp/CapitalExpendituresAmt'),
  (130787, NULL, NULL, 'Final Allocation Made Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleK/TaxExemptBondsProceedsGrp/FinalAllocationMadeInd'),
  (130788, NULL, NULL, 'Other Spent Proceeds Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleK/TaxExemptBondsProceedsGrp/OtherSpentProceedsAmt'),
  (130789, NULL, NULL, 'Refunding Tax Exempt Bonds Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleK/TaxExemptBondsProceedsGrp/RefundingTaxExemptBondsInd'),
  (130790, NULL, NULL, 'Refunding Taxable Bonds Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleK/TaxExemptBondsProceedsGrp/RefundingTaxableBondsInd'),
  (130791, NULL, NULL, 'Substantial Completion Yr', 'TEXT', 'ReturnData/IRS990ScheduleK/TaxExemptBondsProceedsGrp/SubstantialCompletionYr'),
  (130792, NULL, NULL, 'Total Proceeds Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleK/TaxExemptBondsProceedsGrp/TotalProceedsAmt');

-- 990 / Tax Rev Levied Orgnztnl Bnft170 Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130793, 13071, '1', 'Total Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130793, NULL, NULL, 'Total Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/TaxRevLeviedOrgnztnlBnft170Grp/TotalAmt');

-- 990 / Tax Rev Levied Orgnztnl Bnft509 Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130794, 13072, '1', 'Total Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130794, NULL, NULL, 'Total Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/TaxRevLeviedOrgnztnlBnft509Grp/TotalAmt');

-- 990 / Total Calendar Year170 Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130795, 13073, '1', 'Current Tax Year Amt', 'CURRENCY'),
  (130796, 13073, '2', 'Current Tax Year Minus1Year Amt', 'CURRENCY'),
  (130797, 13073, '3', 'Current Tax Year Minus2Years Amt', 'CURRENCY'),
  (130798, 13073, '4', 'Current Tax Year Minus3Years Amt', 'CURRENCY'),
  (130799, 13073, '5', 'Current Tax Year Minus4Years Amt', 'CURRENCY'),
  (130800, 13073, '6', 'Total Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130795, NULL, NULL, 'Current Tax Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/TotalCalendarYear170Grp/CurrentTaxYearAmt'),
  (130796, NULL, NULL, 'Current Tax Year Minus1Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/TotalCalendarYear170Grp/CurrentTaxYearMinus1YearAmt'),
  (130797, NULL, NULL, 'Current Tax Year Minus2Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/TotalCalendarYear170Grp/CurrentTaxYearMinus2YearsAmt'),
  (130798, NULL, NULL, 'Current Tax Year Minus3Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/TotalCalendarYear170Grp/CurrentTaxYearMinus3YearsAmt'),
  (130799, NULL, NULL, 'Current Tax Year Minus4Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/TotalCalendarYear170Grp/CurrentTaxYearMinus4YearsAmt'),
  (130800, NULL, NULL, 'Total Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/TotalCalendarYear170Grp/TotalAmt');

-- 990 / Total Joint Costs Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130801, 13074, '1', 'Fundraising Amt', 'CURRENCY'),
  (130802, 13074, '2', 'Management And General Amt', 'CURRENCY'),
  (130803, 13074, '3', 'Program Services Amt', 'CURRENCY'),
  (130804, 13074, '4', 'Total Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130801, NULL, NULL, 'Fundraising Amt', 'CURRENCY', 'ReturnData/IRS990/TotalJointCostsGrp/FundraisingAmt'),
  (130802, NULL, NULL, 'Management And General Amt', 'CURRENCY', 'ReturnData/IRS990/TotalJointCostsGrp/ManagementAndGeneralAmt'),
  (130803, NULL, NULL, 'Program Services Amt', 'CURRENCY', 'ReturnData/IRS990/TotalJointCostsGrp/ProgramServicesAmt'),
  (130804, NULL, NULL, 'Total Amt', 'CURRENCY', 'ReturnData/IRS990/TotalJointCostsGrp/TotalAmt');

-- 990 / Total Support Calendar Year Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130805, 13075, '1', 'Current Tax Year Amt', 'CURRENCY'),
  (130806, 13075, '2', 'Current Tax Year Minus1Year Amt', 'CURRENCY'),
  (130807, 13075, '3', 'Current Tax Year Minus2Years Amt', 'CURRENCY'),
  (130808, 13075, '4', 'Current Tax Year Minus3Years Amt', 'CURRENCY'),
  (130809, 13075, '5', 'Current Tax Year Minus4Years Amt', 'CURRENCY'),
  (130810, 13075, '6', 'Total Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130805, NULL, NULL, 'Current Tax Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/TotalSupportCalendarYearGrp/CurrentTaxYearAmt'),
  (130806, NULL, NULL, 'Current Tax Year Minus1Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/TotalSupportCalendarYearGrp/CurrentTaxYearMinus1YearAmt'),
  (130807, NULL, NULL, 'Current Tax Year Minus2Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/TotalSupportCalendarYearGrp/CurrentTaxYearMinus2YearsAmt'),
  (130808, NULL, NULL, 'Current Tax Year Minus3Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/TotalSupportCalendarYearGrp/CurrentTaxYearMinus3YearsAmt'),
  (130809, NULL, NULL, 'Current Tax Year Minus4Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/TotalSupportCalendarYearGrp/CurrentTaxYearMinus4YearsAmt'),
  (130810, NULL, NULL, 'Total Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/TotalSupportCalendarYearGrp/TotalAmt');

-- 990 / Total509 Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130811, 13076, '1', 'Current Tax Year Amt', 'CURRENCY'),
  (130812, 13076, '2', 'Current Tax Year Minus1Year Amt', 'CURRENCY'),
  (130813, 13076, '3', 'Current Tax Year Minus2Years Amt', 'CURRENCY'),
  (130814, 13076, '4', 'Current Tax Year Minus3Years Amt', 'CURRENCY'),
  (130815, 13076, '5', 'Current Tax Year Minus4Years Amt', 'CURRENCY'),
  (130816, 13076, '6', 'Total Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130811, NULL, NULL, 'Current Tax Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/Total509Grp/CurrentTaxYearAmt'),
  (130812, NULL, NULL, 'Current Tax Year Minus1Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/Total509Grp/CurrentTaxYearMinus1YearAmt'),
  (130813, NULL, NULL, 'Current Tax Year Minus2Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/Total509Grp/CurrentTaxYearMinus2YearsAmt'),
  (130814, NULL, NULL, 'Current Tax Year Minus3Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/Total509Grp/CurrentTaxYearMinus3YearsAmt'),
  (130815, NULL, NULL, 'Current Tax Year Minus4Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/Total509Grp/CurrentTaxYearMinus4YearsAmt'),
  (130816, NULL, NULL, 'Total Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/Total509Grp/TotalAmt');

-- 990 / Transactions Related Org Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130817, 13077, '1', 'Involved Amt', 'CURRENCY'),
  (130818, 13077, '2', 'Method Of Amount Determination Txt', 'TEXT'),
  (130819, 13077, '3', 'Business Name Line1Txt', 'TEXT'),
  (130820, 13077, '4', 'Transaction Type Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130817, NULL, NULL, 'Involved Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleR/TransactionsRelatedOrgGrp/InvolvedAmt'),
  (130818, NULL, NULL, 'Method Of Amount Determination Txt', 'TEXT', 'ReturnData/IRS990ScheduleR/TransactionsRelatedOrgGrp/MethodOfAmountDeterminationTxt'),
  (130819, NULL, NULL, 'Business Name Line1Txt', 'TEXT', 'ReturnData/IRS990ScheduleR/TransactionsRelatedOrgGrp/OtherOrganizationName/BusinessNameLine1Txt'),
  (130820, NULL, NULL, 'Transaction Type Txt', 'TEXT', 'ReturnData/IRS990ScheduleR/TransactionsRelatedOrgGrp/TransactionTypeTxt');

-- 990 / US Address
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130821, 13078, '1', 'Address Line1Txt', 'TEXT'),
  (130822, 13078, '2', 'Address Line2Txt', 'TEXT'),
  (130823, 13078, '3', 'City Nm', 'TEXT'),
  (130824, 13078, '4', 'State Abbreviation Cd', 'TEXT'),
  (130825, 13078, '5', 'ZIP Cd', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130821, NULL, NULL, 'Address Line1Txt', 'TEXT', 'ReturnData/IRS990/USAddress/AddressLine1Txt'),
  (130822, NULL, NULL, 'Address Line2Txt', 'TEXT', 'ReturnData/IRS990/USAddress/AddressLine2Txt'),
  (130823, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990/USAddress/CityNm'),
  (130824, NULL, NULL, 'State Abbreviation Cd', 'TEXT', 'ReturnData/IRS990/USAddress/StateAbbreviationCd'),
  (130825, NULL, NULL, 'ZIP Cd', 'TEXT', 'ReturnData/IRS990/USAddress/ZIPCd');

-- 990 / Unrelated Business Net Incm170 Group
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130826, 13079, '1', 'Current Tax Year Minus4Years Amt', 'CURRENCY'),
  (130827, 13079, '2', 'Total Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130826, NULL, NULL, 'Current Tax Year Minus4Years Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/UnrelatedBusinessNetIncm170Grp/CurrentTaxYearMinus4YearsAmt'),
  (130827, NULL, NULL, 'Total Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/UnrelatedBusinessNetIncm170Grp/TotalAmt');


-- ========================================================================
-- FORM 990 — Extended field mappings (Round 2)
-- ========================================================================

-- 990 / IRS990 Schedule F Direct Fields
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13080, 14, '031', 'IRS990 Schedule F Direct Fields');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130828, 13080, '1', 'Transfer To Foreign Corp Ind', 'BOOLEAN'),
  (130829, 13080, '2', 'Foreign Corp Ownership Ind', 'BOOLEAN'),
  (130830, 13080, '3', 'Interest In Foreign Trust Ind', 'BOOLEAN'),
  (130831, 13080, '4', 'Passive Foreign Investmest Co Ind', 'BOOLEAN'),
  (130832, 13080, '5', 'Foreign Partnership Ind', 'BOOLEAN'),
  (130833, 13080, '6', 'Boycott Countries Ind', 'BOOLEAN'),
  (130834, 13080, '7', 'Total Spent Amt', 'CURRENCY'),
  (130835, 13080, '8', 'Subtotal Spent Amt', 'CURRENCY'),
  (130836, 13080, '9', 'Total Employee Cnt', 'INTEGER'),
  (130837, 13080, '10', 'Total Office Cnt', 'INTEGER'),
  (130838, 13080, '11', 'Subtotal Employees Cnt', 'INTEGER'),
  (130839, 13080, '12', 'Subtotal Offices Cnt', 'INTEGER'),
  (130840, 13080, '13', 'Grant Records Maintained Ind', 'BOOLEAN'),
  (130841, 13080, '14', 'Continuation Spent Amt', 'CURRENCY'),
  (130842, 13080, '15', 'Continuation Total Employee Cnt', 'INTEGER'),
  (130843, 13080, '16', 'Continuation Total Office Cnt', 'INTEGER'),
  (130844, 13080, '17', 'Total501c3 Org Cnt', 'INTEGER'),
  (130845, 13080, '18', 'Total Other Org Cnt', 'INTEGER');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130828, NULL, NULL, 'Transfer To Foreign Corp Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleF/TransferToForeignCorpInd'),
  (130829, NULL, NULL, 'Foreign Corp Ownership Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleF/ForeignCorpOwnershipInd'),
  (130830, NULL, NULL, 'Interest In Foreign Trust Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleF/InterestInForeignTrustInd'),
  (130831, NULL, NULL, 'Passive Foreign Investmest Co Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleF/PassiveForeignInvestmestCoInd'),
  (130832, NULL, NULL, 'Foreign Partnership Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleF/ForeignPartnershipInd'),
  (130833, NULL, NULL, 'Boycott Countries Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleF/BoycottCountriesInd'),
  (130834, NULL, NULL, 'Total Spent Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleF/TotalSpentAmt'),
  (130835, NULL, NULL, 'Subtotal Spent Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleF/SubtotalSpentAmt'),
  (130836, NULL, NULL, 'Total Employee Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleF/TotalEmployeeCnt'),
  (130837, NULL, NULL, 'Total Office Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleF/TotalOfficeCnt'),
  (130838, NULL, NULL, 'Subtotal Employees Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleF/SubtotalEmployeesCnt'),
  (130839, NULL, NULL, 'Subtotal Offices Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleF/SubtotalOfficesCnt'),
  (130840, NULL, NULL, 'Grant Records Maintained Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleF/GrantRecordsMaintainedInd'),
  (130841, NULL, NULL, 'Continuation Spent Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleF/ContinuationSpentAmt'),
  (130842, NULL, NULL, 'Continuation Total Employee Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleF/ContinuationTotalEmployeeCnt'),
  (130843, NULL, NULL, 'Continuation Total Office Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleF/ContinuationTotalOfficeCnt'),
  (130844, NULL, NULL, 'Total501c3 Org Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleF/Total501c3OrgCnt'),
  (130845, NULL, NULL, 'Total Other Org Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleF/TotalOtherOrgCnt');

-- 990 / IRS990 Schedule D Direct Fields
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13081, 14, '032', 'IRS990 Schedule D Direct Fields');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130846, 13081, '1', 'Total Book Value Securities Amt', 'CURRENCY'),
  (130847, 13081, '2', 'Other Revenues Not Included Amt', 'CURRENCY'),
  (130848, 13081, '3', 'Other Expenses Not Included Amt', 'CURRENCY'),
  (130849, 13081, '4', 'Federal Income Tax Liability Amt', 'CURRENCY'),
  (130850, 13081, '5', 'Solicited Assets Sale Ind', 'BOOLEAN'),
  (130851, 13081, '6', 'Total Book Value Program Rltd Amt', 'CURRENCY'),
  (130852, 13081, '7', 'Related Org List Sch R Ind', 'BOOLEAN'),
  (130853, 13081, '8', 'Explanation Provided Ind', 'BOOLEAN'),
  (130854, 13081, '9', 'Collection Used Pub Exhibition Ind', 'BOOLEAN'),
  (130855, 13081, '10', 'Disclosed For Charitable Prps Ind', 'BOOLEAN'),
  (130856, 13081, '11', 'Collection Used Preservation Ind', 'BOOLEAN'),
  (130857, 13081, '12', 'Disclosed Org Leg Ctrl Ind', 'BOOLEAN'),
  (130858, 13081, '13', 'Written Policy Monitoring Ind', 'BOOLEAN'),
  (130859, 13081, '14', 'Prior Year Adjustments Amt', 'CURRENCY'),
  (130860, 13081, '15', 'Losses Reported Amt', 'CURRENCY'),
  (130861, 13081, '16', 'Recoveries Prior Year Grants Amt', 'CURRENCY'),
  (130862, 13081, '17', 'Coll Used Scholarly Rsrch Ind', 'BOOLEAN'),
  (130863, 13081, '18', 'Donor Advised Funds Held Cnt', 'INTEGER'),
  (130864, 13081, '19', 'Section170h Rqr Stsfd Ind', 'BOOLEAN'),
  (130865, 13081, '20', 'Donor Advised Funds Vl EOY Amt', 'CURRENCY'),
  (130866, 13081, '21', 'Ending Balance Amt', 'CURRENCY'),
  (130867, 13081, '22', 'Donor Advised Funds Contri Amt', 'CURRENCY'),
  (130868, 13081, '23', 'Donor Advised Funds Grants Amt', 'CURRENCY'),
  (130869, 13081, '24', 'States Easements Held Cnt', 'INTEGER'),
  (130870, 13081, '25', 'Total Easements Cnt', 'INTEGER'),
  (130871, 13081, '26', 'Total Acreage Cnt', 'INTEGER'),
  (130872, 13081, '27', 'Protection Natural Habitat Ind', 'BOOLEAN'),
  (130873, 13081, '28', 'Coll Used Loan Or Exch Prog Ind', 'BOOLEAN'),
  (130874, 13081, '29', 'Staff Hours Spent Enforcement Cnt', 'INTEGER'),
  (130875, 13081, '30', 'Beginning Balance Amt', 'CURRENCY'),
  (130876, 13081, '31', 'Preservation Open Space Ind', 'BOOLEAN'),
  (130877, 13081, '32', 'Expenses Incurred Enforcement Amt', 'CURRENCY'),
  (130878, 13081, '33', 'Preservation Public Use Ind', 'BOOLEAN'),
  (130879, 13081, '34', 'Funds And Other Accounts Held Cnt', 'INTEGER'),
  (130880, 13081, '35', 'Additions During Year Amt', 'CURRENCY'),
  (130881, 13081, '36', 'Distributions During Year Amt', 'CURRENCY'),
  (130882, 13081, '37', 'Funds And Other Accounts Vl EOY Amt', 'CURRENCY'),
  (130883, 13081, '38', 'Funds And Other Accounts Contri Amt', 'CURRENCY'),
  (130884, 13081, '39', 'Funds And Other Accounts Grants Amt', 'CURRENCY'),
  (130885, 13081, '40', 'Historic Structure Easements Cnt', 'INTEGER'),
  (130886, 13081, '41', 'Modified Easements Cnt', 'INTEGER'),
  (130887, 13081, '42', 'Historic Strctr Easements Aftr Cnt', 'INTEGER'),
  (130888, 13081, '43', 'Historic Land Area Ind', 'BOOLEAN'),
  (130889, 13081, '44', 'Historic Structure Ind', 'BOOLEAN');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130846, NULL, NULL, 'Total Book Value Securities Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/TotalBookValueSecuritiesAmt'),
  (130847, NULL, NULL, 'Other Revenues Not Included Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/OtherRevenuesNotIncludedAmt'),
  (130848, NULL, NULL, 'Other Expenses Not Included Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/OtherExpensesNotIncludedAmt'),
  (130849, NULL, NULL, 'Federal Income Tax Liability Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/FederalIncomeTaxLiabilityAmt'),
  (130850, NULL, NULL, 'Solicited Assets Sale Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleD/SolicitedAssetsSaleInd'),
  (130851, NULL, NULL, 'Total Book Value Program Rltd Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/TotalBookValueProgramRltdAmt'),
  (130852, NULL, NULL, 'Related Org List Sch R Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleD/RelatedOrgListSchRInd'),
  (130853, NULL, NULL, 'Explanation Provided Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleD/ExplanationProvidedInd'),
  (130854, NULL, NULL, 'Collection Used Pub Exhibition Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleD/CollectionUsedPubExhibitionInd'),
  (130855, NULL, NULL, 'Disclosed For Charitable Prps Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleD/DisclosedForCharitablePrpsInd'),
  (130856, NULL, NULL, 'Collection Used Preservation Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleD/CollectionUsedPreservationInd'),
  (130857, NULL, NULL, 'Disclosed Org Leg Ctrl Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleD/DisclosedOrgLegCtrlInd'),
  (130858, NULL, NULL, 'Written Policy Monitoring Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleD/WrittenPolicyMonitoringInd'),
  (130859, NULL, NULL, 'Prior Year Adjustments Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/PriorYearAdjustmentsAmt'),
  (130860, NULL, NULL, 'Losses Reported Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/LossesReportedAmt'),
  (130861, NULL, NULL, 'Recoveries Prior Year Grants Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/RecoveriesPriorYearGrantsAmt'),
  (130862, NULL, NULL, 'Coll Used Scholarly Rsrch Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleD/CollUsedScholarlyRsrchInd'),
  (130863, NULL, NULL, 'Donor Advised Funds Held Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleD/DonorAdvisedFundsHeldCnt'),
  (130864, NULL, NULL, 'Section170h Rqr Stsfd Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleD/Section170hRqrStsfdInd'),
  (130865, NULL, NULL, 'Donor Advised Funds Vl EOY Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/DonorAdvisedFundsVlEOYAmt'),
  (130866, NULL, NULL, 'Ending Balance Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/EndingBalanceAmt'),
  (130867, NULL, NULL, 'Donor Advised Funds Contri Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/DonorAdvisedFundsContriAmt'),
  (130868, NULL, NULL, 'Donor Advised Funds Grants Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/DonorAdvisedFundsGrantsAmt'),
  (130869, NULL, NULL, 'States Easements Held Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleD/StatesEasementsHeldCnt'),
  (130870, NULL, NULL, 'Total Easements Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleD/TotalEasementsCnt'),
  (130871, NULL, NULL, 'Total Acreage Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleD/TotalAcreageCnt'),
  (130872, NULL, NULL, 'Protection Natural Habitat Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleD/ProtectionNaturalHabitatInd'),
  (130873, NULL, NULL, 'Coll Used Loan Or Exch Prog Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleD/CollUsedLoanOrExchProgInd'),
  (130874, NULL, NULL, 'Staff Hours Spent Enforcement Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleD/StaffHoursSpentEnforcementCnt'),
  (130875, NULL, NULL, 'Beginning Balance Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/BeginningBalanceAmt'),
  (130876, NULL, NULL, 'Preservation Open Space Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleD/PreservationOpenSpaceInd'),
  (130877, NULL, NULL, 'Expenses Incurred Enforcement Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/ExpensesIncurredEnforcementAmt'),
  (130878, NULL, NULL, 'Preservation Public Use Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleD/PreservationPublicUseInd'),
  (130879, NULL, NULL, 'Funds And Other Accounts Held Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleD/FundsAndOtherAccountsHeldCnt'),
  (130880, NULL, NULL, 'Additions During Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/AdditionsDuringYearAmt'),
  (130881, NULL, NULL, 'Distributions During Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/DistributionsDuringYearAmt'),
  (130882, NULL, NULL, 'Funds And Other Accounts Vl EOY Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/FundsAndOtherAccountsVlEOYAmt'),
  (130883, NULL, NULL, 'Funds And Other Accounts Contri Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/FundsAndOtherAccountsContriAmt'),
  (130884, NULL, NULL, 'Funds And Other Accounts Grants Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/FundsAndOtherAccountsGrantsAmt'),
  (130885, NULL, NULL, 'Historic Structure Easements Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleD/HistoricStructureEasementsCnt'),
  (130886, NULL, NULL, 'Modified Easements Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleD/ModifiedEasementsCnt'),
  (130887, NULL, NULL, 'Historic Strctr Easements Aftr Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleD/HistoricStrctrEasementsAftrCnt'),
  (130888, NULL, NULL, 'Historic Land Area Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleD/HistoricLandAreaInd'),
  (130889, NULL, NULL, 'Historic Structure Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleD/HistoricStructureInd');

-- 990 / Id Related Org Txbl Partnership Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13082, 14, '033', 'Id Related Org Txbl Partnership Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130890, 13082, '1', 'Business Name Line1 Txt', 'TEXT'),
  (130891, 13082, '2', 'Address Line1 Txt', 'TEXT'),
  (130892, 13082, '3', 'City Nm', 'TEXT'),
  (130893, 13082, '4', 'State Abbreviation Cd', 'TEXT'),
  (130894, 13082, '5', 'ZIP Cd', 'TEXT'),
  (130895, 13082, '6', 'Primary Activities Txt', 'TEXT'),
  (130896, 13082, '7', 'Legal Domicile State Cd', 'TEXT'),
  (130897, 13082, '8', 'EIN', 'TEXT'),
  (130898, 13082, '9', 'Disproportionate Allocations Ind', 'BOOLEAN'),
  (130899, 13082, '10', 'General Or Managing Partner Ind', 'BOOLEAN'),
  (130900, 13082, '11', 'Direct Controlling NA Cd', 'TEXT'),
  (130901, 13082, '12', 'Predominant Income Type Txt', 'TEXT'),
  (130902, 13082, '13', 'Business Name Line1 Txt', 'TEXT'),
  (130903, 13082, '14', 'Ownership Pct', 'PERCENT'),
  (130904, 13082, '15', 'Share Of EOY Assets Amt', 'CURRENCY'),
  (130905, 13082, '16', 'Share Of Total Income Amt', 'CURRENCY'),
  (130906, 13082, '17', 'UBI Code V Amt', 'CURRENCY'),
  (130907, 13082, '18', 'Address Line2 Txt', 'TEXT'),
  (130908, 13082, '19', 'Legal Domicile Foreign Country Cd', 'TEXT'),
  (130909, 13082, '20', 'Address Line1 Txt', 'TEXT'),
  (130910, 13082, '21', 'Country Cd', 'TEXT'),
  (130911, 13082, '22', 'City Nm', 'TEXT'),
  (130912, 13082, '23', 'Foreign Postal Cd', 'TEXT'),
  (130913, 13082, '24', 'Province Or State Nm', 'TEXT'),
  (130914, 13082, '25', 'Business Name Line2 Txt', 'TEXT'),
  (130915, 13082, '26', 'Business Name Line2 Txt', 'TEXT'),
  (130916, 13082, '27', 'Address Line2 Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130890, NULL, NULL, 'Business Name Line1 Txt', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedOrgTxblPartnershipGrp/RelatedOrganizationName/BusinessNameLine1Txt'),
  (130891, NULL, NULL, 'Address Line1 Txt', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedOrgTxblPartnershipGrp/USAddress/AddressLine1Txt'),
  (130892, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedOrgTxblPartnershipGrp/USAddress/CityNm'),
  (130893, NULL, NULL, 'State Abbreviation Cd', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedOrgTxblPartnershipGrp/USAddress/StateAbbreviationCd'),
  (130894, NULL, NULL, 'ZIP Cd', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedOrgTxblPartnershipGrp/USAddress/ZIPCd'),
  (130895, NULL, NULL, 'Primary Activities Txt', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedOrgTxblPartnershipGrp/PrimaryActivitiesTxt'),
  (130896, NULL, NULL, 'Legal Domicile State Cd', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedOrgTxblPartnershipGrp/LegalDomicileStateCd'),
  (130897, NULL, NULL, 'EIN', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedOrgTxblPartnershipGrp/EIN'),
  (130898, NULL, NULL, 'Disproportionate Allocations Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleR/IdRelatedOrgTxblPartnershipGrp/DisproportionateAllocationsInd'),
  (130899, NULL, NULL, 'General Or Managing Partner Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleR/IdRelatedOrgTxblPartnershipGrp/GeneralOrManagingPartnerInd'),
  (130900, NULL, NULL, 'Direct Controlling NA Cd', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedOrgTxblPartnershipGrp/DirectControllingNACd'),
  (130901, NULL, NULL, 'Predominant Income Type Txt', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedOrgTxblPartnershipGrp/PredominantIncomeTypeTxt'),
  (130902, NULL, NULL, 'Business Name Line1 Txt', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedOrgTxblPartnershipGrp/DirectControllingEntityName/BusinessNameLine1Txt'),
  (130903, NULL, NULL, 'Ownership Pct', 'PERCENT', 'ReturnData/IRS990ScheduleR/IdRelatedOrgTxblPartnershipGrp/OwnershipPct'),
  (130904, NULL, NULL, 'Share Of EOY Assets Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleR/IdRelatedOrgTxblPartnershipGrp/ShareOfEOYAssetsAmt'),
  (130905, NULL, NULL, 'Share Of Total Income Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleR/IdRelatedOrgTxblPartnershipGrp/ShareOfTotalIncomeAmt'),
  (130906, NULL, NULL, 'UBI Code V Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleR/IdRelatedOrgTxblPartnershipGrp/UBICodeVAmt'),
  (130907, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedOrgTxblPartnershipGrp/USAddress/AddressLine2Txt'),
  (130908, NULL, NULL, 'Legal Domicile Foreign Country Cd', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedOrgTxblPartnershipGrp/LegalDomicileForeignCountryCd'),
  (130909, NULL, NULL, 'Address Line1 Txt', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedOrgTxblPartnershipGrp/ForeignAddress/AddressLine1Txt'),
  (130910, NULL, NULL, 'Country Cd', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedOrgTxblPartnershipGrp/ForeignAddress/CountryCd'),
  (130911, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedOrgTxblPartnershipGrp/ForeignAddress/CityNm'),
  (130912, NULL, NULL, 'Foreign Postal Cd', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedOrgTxblPartnershipGrp/ForeignAddress/ForeignPostalCd'),
  (130913, NULL, NULL, 'Province Or State Nm', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedOrgTxblPartnershipGrp/ForeignAddress/ProvinceOrStateNm'),
  (130914, NULL, NULL, 'Business Name Line2 Txt', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedOrgTxblPartnershipGrp/DirectControllingEntityName/BusinessNameLine2Txt'),
  (130915, NULL, NULL, 'Business Name Line2 Txt', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedOrgTxblPartnershipGrp/RelatedOrganizationName/BusinessNameLine2Txt'),
  (130916, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedOrgTxblPartnershipGrp/ForeignAddress/AddressLine2Txt');

-- 990 / Hospital Fclty Policies Prctc Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13083, 14, '034', 'Hospital Fclty Policies Prctc Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (130917, 13083, '1', 'Amounts Generally Billed Ind', 'BOOLEAN'),
  (130918, 13083, '2', 'App Financial Asst Expln Ind', 'BOOLEAN'),
  (130919, 13083, '3', 'CHNA Conducted Ind', 'BOOLEAN'),
  (130920, 13083, '4', 'Collection Activities Ind', 'BOOLEAN'),
  (130921, 13083, '5', 'Elig Criteria Explained Ind', 'BOOLEAN'),
  (130922, 13083, '6', 'Explained Basis Ind', 'BOOLEAN'),
  (130923, 13083, '7', 'FAP Actions On Nonpayment Ind', 'BOOLEAN'),
  (130924, 13083, '8', 'First Licensed CY Or PY Ind', 'BOOLEAN'),
  (130925, 13083, '9', 'Gross Charges Ind', 'BOOLEAN'),
  (130926, 13083, '10', 'Includes Publicity Measures Ind', 'BOOLEAN'),
  (130927, 13083, '11', 'Nondis Emergency Care Policy Ind', 'BOOLEAN'),
  (130928, 13083, '12', 'Tax Exempt Hospital CY Or PY Ind', 'BOOLEAN'),
  (130929, 13083, '13', 'Organization Incur Excise Tax Ind', 'BOOLEAN'),
  (130930, 13083, '14', 'Business Name Line1 Txt', 'TEXT'),
  (130931, 13083, '15', 'FPG Family Incm Lmt Free Dscnt Ind', 'BOOLEAN'),
  (130932, 13083, '16', 'Described Info Ind', 'BOOLEAN'),
  (130933, 13083, '17', 'FAP Avlbl On Request No Charge Ind', 'BOOLEAN'),
  (130934, 13083, '18', 'FPG Family Incm Lmt Free Care Pct', 'PERCENT'),
  (130935, 13083, '19', 'Described Suprt Doc Ind', 'BOOLEAN'),
  (130936, 13083, '20', 'CHNA Conducted With Other Fclts Ind', 'BOOLEAN'),
  (130937, 13083, '21', 'CHNA Report Widely Available Ind', 'BOOLEAN'),
  (130938, 13083, '22', 'Implementation Strategy Adopt Ind', 'BOOLEAN'),
  (130939, 13083, '23', 'Take Into Account Others Input Ind', 'BOOLEAN'),
  (130940, 13083, '24', 'CHNA Conducted With Non Fclts Ind', 'BOOLEAN'),
  (130941, 13083, '25', 'CHNA Conducted Yr', 'TEXT'),
  (130942, 13083, '26', 'Community Definition Ind', 'BOOLEAN'),
  (130943, 13083, '27', 'FAP App Avlbl On Request No Chrg Ind', 'BOOLEAN'),
  (130944, 13083, '28', 'How Data Obtained Ind', 'BOOLEAN'),
  (130945, 13083, '29', 'Community Demographics Ind', 'BOOLEAN'),
  (130946, 13083, '30', 'Community Hlth Needs Id Process Ind', 'BOOLEAN'),
  (130947, 13083, '31', 'FAP Available On Website Ind', 'BOOLEAN'),
  (130948, 13083, '32', 'FAP Available On Website URL Txt', 'TEXT'),
  (130949, 13083, '33', 'Implementation Strategy Adpt Yr', 'TEXT'),
  (130950, 13083, '34', 'Provided Hospital Contact Ind', 'BOOLEAN'),
  (130951, 13083, '35', 'Strategy Posted Website Ind', 'BOOLEAN'),
  (130952, 13083, '36', 'Consulting Process Ind', 'BOOLEAN'),
  (130953, 13083, '37', 'FAP Sum Avlbl On Request No Chrg Ind', 'BOOLEAN'),
  (130954, 13083, '38', 'Community Health Needs Ind', 'BOOLEAN'),
  (130955, 13083, '39', 'FAP App Available On Website Ind', 'BOOLEAN'),
  (130956, 13083, '40', 'FAP App Available On Website URL Txt', 'TEXT'),
  (130957, 13083, '41', 'Other Health Issues Ind', 'BOOLEAN'),
  (130958, 13083, '42', 'FAP Summary On Website Ind', 'BOOLEAN'),
  (130959, 13083, '43', 'FAP Summary On Website URL Txt', 'TEXT'),
  (130960, 13083, '44', 'Existing Resources Ind', 'BOOLEAN'),
  (130961, 13083, '45', 'Notified FAP Copy Bill Display Ind', 'BOOLEAN'),
  (130962, 13083, '46', 'Own Website URL Txt', 'TEXT'),
  (130963, 13083, '47', 'Rpt Available On Own Website Ind', 'BOOLEAN'),
  (130964, 13083, '48', 'Permit No Actions Ind', 'BOOLEAN'),
  (130965, 13083, '49', 'FPG Family Incm Lmt Dscnt Care Pct', 'PERCENT'),
  (130966, 13083, '50', 'Strategy Website URL Txt', 'TEXT'),
  (130967, 13083, '51', 'Made Effort Orally Notify Ind', 'BOOLEAN'),
  (130968, 13083, '52', 'Processed FAP Application Ind', 'BOOLEAN'),
  (130969, 13083, '53', 'Paper Copy Public Inspection Ind', 'BOOLEAN'),
  (130970, 13083, '54', 'Prior CHNA Impact Ind', 'BOOLEAN'),
  (130971, 13083, '55', 'Communtity Notified FAP Ind', 'BOOLEAN'),
  (130972, 13083, '56', 'Facility Num', 'INTEGER'),
  (130973, 13083, '57', 'Made Presumptive Elig Determ Ind', 'BOOLEAN'),
  (130974, 13083, '58', 'FAP Translated Ind', 'BOOLEAN'),
  (130975, 13083, '59', 'Provided Written Notice Ind', 'BOOLEAN'),
  (130976, 13083, '60', 'Medical Indigency Criteria Ind', 'BOOLEAN'),
  (130977, 13083, '61', 'Insurance Status Criteria Ind', 'BOOLEAN'),
  (130978, 13083, '62', 'Underinsurance Stat Criteria Ind', 'BOOLEAN'),
  (130979, 13083, '63', 'Asset Level Criteria Ind', 'BOOLEAN'),
  (130980, 13083, '64', 'Look Back Medicare Private Ind', 'BOOLEAN'),
  (130981, 13083, '65', 'Residency Criteria Ind', 'BOOLEAN'),
  (130982, 13083, '66', 'Provided Nonprofit Contact Ind', 'BOOLEAN'),
  (130983, 13083, '67', 'Other Criteria Ind', 'BOOLEAN'),
  (130984, 13083, '68', 'Other Publicity Ind', 'BOOLEAN'),
  (130985, 13083, '69', 'Income Level Criteria Ind', 'BOOLEAN'),
  (130986, 13083, '70', 'Rpt Available Thru Other Method Ind', 'BOOLEAN'),
  (130987, 13083, '71', 'Other Actions Taken Ind', 'BOOLEAN'),
  (130988, 13083, '72', 'Other Website URL Txt', 'TEXT'),
  (130989, 13083, '73', 'Look Back Medicaid Medcr Prvt Ind', 'BOOLEAN'),
  (130990, 13083, '74', 'Prospective Medicare Medicaid Ind', 'BOOLEAN'),
  (130991, 13083, '75', 'Other Website Ind', 'BOOLEAN'),
  (130992, 13083, '76', 'Look Back Medicare Ind', 'BOOLEAN'),
  (130993, 13083, '77', 'Strategy Attached Ind', 'BOOLEAN'),
  (130994, 13083, '78', 'Other Ind', 'BOOLEAN'),
  (130995, 13083, '79', 'Other Method Ind', 'BOOLEAN'),
  (130996, 13083, '80', 'No Emergency Care Ind', 'BOOLEAN'),
  (130997, 13083, '81', 'None Made Ind', 'BOOLEAN'),
  (130998, 13083, '82', 'Permit Report To Credit Agency Ind', 'BOOLEAN'),
  (130999, 13083, '83', 'Permit Legal Judicial Process Ind', 'BOOLEAN'),
  (131000, 13083, '84', 'Reporting To Credit Agency Ind', 'BOOLEAN'),
  (131001, 13083, '85', 'Other Reason Ind', 'BOOLEAN'),
  (131002, 13083, '86', 'Permit Other Actions Ind', 'BOOLEAN'),
  (131003, 13083, '87', 'Business Name Line2 Txt', 'TEXT'),
  (131004, 13083, '88', 'Form4720 Filed Ind', 'BOOLEAN'),
  (131005, 13083, '89', 'Other Actions Ind', 'BOOLEAN'),
  (131006, 13083, '90', 'Engaged Legal Judicial Process Ind', 'BOOLEAN'),
  (131007, 13083, '91', 'Excise Report Form4720 For All Amt', 'CURRENCY'),
  (131008, 13083, '92', 'Permit Selling Debt Ind', 'BOOLEAN'),
  (131009, 13083, '93', 'Engaged Selling Debt Ind', 'BOOLEAN'),
  (131010, 13083, '94', 'Permit Defer Deny Rqr Payment Ind', 'BOOLEAN'),
  (131011, 13083, '95', 'Engage Defer Deny Rqr Payment Ind', 'BOOLEAN'),
  (131012, 13083, '96', 'Emergency Care Limited Ind', 'BOOLEAN');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (130917, NULL, NULL, 'Amounts Generally Billed Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/AmountsGenerallyBilledInd'),
  (130918, NULL, NULL, 'App Financial Asst Expln Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/AppFinancialAsstExplnInd'),
  (130919, NULL, NULL, 'CHNA Conducted Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/CHNAConductedInd'),
  (130920, NULL, NULL, 'Collection Activities Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/CollectionActivitiesInd'),
  (130921, NULL, NULL, 'Elig Criteria Explained Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/EligCriteriaExplainedInd'),
  (130922, NULL, NULL, 'Explained Basis Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/ExplainedBasisInd'),
  (130923, NULL, NULL, 'FAP Actions On Nonpayment Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/FAPActionsOnNonpaymentInd'),
  (130924, NULL, NULL, 'First Licensed CY Or PY Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/FirstLicensedCYOrPYInd'),
  (130925, NULL, NULL, 'Gross Charges Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/GrossChargesInd'),
  (130926, NULL, NULL, 'Includes Publicity Measures Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/IncludesPublicityMeasuresInd'),
  (130927, NULL, NULL, 'Nondis Emergency Care Policy Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/NondisEmergencyCarePolicyInd'),
  (130928, NULL, NULL, 'Tax Exempt Hospital CY Or PY Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/TaxExemptHospitalCYOrPYInd'),
  (130929, NULL, NULL, 'Organization Incur Excise Tax Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/OrganizationIncurExciseTaxInd'),
  (130930, NULL, NULL, 'Business Name Line1 Txt', 'TEXT', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/HospitalFacilityName/BusinessNameLine1Txt'),
  (130931, NULL, NULL, 'FPG Family Incm Lmt Free Dscnt Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/FPGFamilyIncmLmtFreeDscntInd'),
  (130932, NULL, NULL, 'Described Info Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/DescribedInfoInd'),
  (130933, NULL, NULL, 'FAP Avlbl On Request No Charge Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/FAPAvlblOnRequestNoChargeInd'),
  (130934, NULL, NULL, 'FPG Family Incm Lmt Free Care Pct', 'PERCENT', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/FPGFamilyIncmLmtFreeCarePct'),
  (130935, NULL, NULL, 'Described Suprt Doc Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/DescribedSuprtDocInd'),
  (130936, NULL, NULL, 'CHNA Conducted With Other Fclts Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/CHNAConductedWithOtherFcltsInd'),
  (130937, NULL, NULL, 'CHNA Report Widely Available Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/CHNAReportWidelyAvailableInd'),
  (130938, NULL, NULL, 'Implementation Strategy Adopt Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/ImplementationStrategyAdoptInd'),
  (130939, NULL, NULL, 'Take Into Account Others Input Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/TakeIntoAccountOthersInputInd'),
  (130940, NULL, NULL, 'CHNA Conducted With Non Fclts Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/CHNAConductedWithNonFcltsInd'),
  (130941, NULL, NULL, 'CHNA Conducted Yr', 'TEXT', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/CHNAConductedYr'),
  (130942, NULL, NULL, 'Community Definition Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/CommunityDefinitionInd'),
  (130943, NULL, NULL, 'FAP App Avlbl On Request No Chrg Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/FAPAppAvlblOnRequestNoChrgInd'),
  (130944, NULL, NULL, 'How Data Obtained Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/HowDataObtainedInd'),
  (130945, NULL, NULL, 'Community Demographics Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/CommunityDemographicsInd'),
  (130946, NULL, NULL, 'Community Hlth Needs Id Process Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/CommunityHlthNeedsIdProcessInd'),
  (130947, NULL, NULL, 'FAP Available On Website Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/FAPAvailableOnWebsiteInd'),
  (130948, NULL, NULL, 'FAP Available On Website URL Txt', 'TEXT', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/FAPAvailableOnWebsiteURLTxt'),
  (130949, NULL, NULL, 'Implementation Strategy Adpt Yr', 'TEXT', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/ImplementationStrategyAdptYr'),
  (130950, NULL, NULL, 'Provided Hospital Contact Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/ProvidedHospitalContactInd'),
  (130951, NULL, NULL, 'Strategy Posted Website Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/StrategyPostedWebsiteInd'),
  (130952, NULL, NULL, 'Consulting Process Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/ConsultingProcessInd'),
  (130953, NULL, NULL, 'FAP Sum Avlbl On Request No Chrg Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/FAPSumAvlblOnRequestNoChrgInd'),
  (130954, NULL, NULL, 'Community Health Needs Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/CommunityHealthNeedsInd'),
  (130955, NULL, NULL, 'FAP App Available On Website Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/FAPAppAvailableOnWebsiteInd'),
  (130956, NULL, NULL, 'FAP App Available On Website URL Txt', 'TEXT', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/FAPAppAvailableOnWebsiteURLTxt'),
  (130957, NULL, NULL, 'Other Health Issues Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/OtherHealthIssuesInd'),
  (130958, NULL, NULL, 'FAP Summary On Website Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/FAPSummaryOnWebsiteInd'),
  (130959, NULL, NULL, 'FAP Summary On Website URL Txt', 'TEXT', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/FAPSummaryOnWebsiteURLTxt'),
  (130960, NULL, NULL, 'Existing Resources Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/ExistingResourcesInd'),
  (130961, NULL, NULL, 'Notified FAP Copy Bill Display Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/NotifiedFAPCopyBillDisplayInd'),
  (130962, NULL, NULL, 'Own Website URL Txt', 'TEXT', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/OwnWebsiteURLTxt'),
  (130963, NULL, NULL, 'Rpt Available On Own Website Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/RptAvailableOnOwnWebsiteInd'),
  (130964, NULL, NULL, 'Permit No Actions Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/PermitNoActionsInd'),
  (130965, NULL, NULL, 'FPG Family Incm Lmt Dscnt Care Pct', 'PERCENT', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/FPGFamilyIncmLmtDscntCarePct'),
  (130966, NULL, NULL, 'Strategy Website URL Txt', 'TEXT', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/StrategyWebsiteURLTxt'),
  (130967, NULL, NULL, 'Made Effort Orally Notify Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/MadeEffortOrallyNotifyInd'),
  (130968, NULL, NULL, 'Processed FAP Application Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/ProcessedFAPApplicationInd'),
  (130969, NULL, NULL, 'Paper Copy Public Inspection Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/PaperCopyPublicInspectionInd'),
  (130970, NULL, NULL, 'Prior CHNA Impact Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/PriorCHNAImpactInd'),
  (130971, NULL, NULL, 'Communtity Notified FAP Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/CommuntityNotifiedFAPInd'),
  (130972, NULL, NULL, 'Facility Num', 'INTEGER', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/FacilityNum'),
  (130973, NULL, NULL, 'Made Presumptive Elig Determ Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/MadePresumptiveEligDetermInd'),
  (130974, NULL, NULL, 'FAP Translated Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/FAPTranslatedInd'),
  (130975, NULL, NULL, 'Provided Written Notice Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/ProvidedWrittenNoticeInd'),
  (130976, NULL, NULL, 'Medical Indigency Criteria Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/MedicalIndigencyCriteriaInd'),
  (130977, NULL, NULL, 'Insurance Status Criteria Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/InsuranceStatusCriteriaInd'),
  (130978, NULL, NULL, 'Underinsurance Stat Criteria Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/UnderinsuranceStatCriteriaInd'),
  (130979, NULL, NULL, 'Asset Level Criteria Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/AssetLevelCriteriaInd'),
  (130980, NULL, NULL, 'Look Back Medicare Private Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/LookBackMedicarePrivateInd'),
  (130981, NULL, NULL, 'Residency Criteria Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/ResidencyCriteriaInd'),
  (130982, NULL, NULL, 'Provided Nonprofit Contact Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/ProvidedNonprofitContactInd'),
  (130983, NULL, NULL, 'Other Criteria Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/OtherCriteriaInd'),
  (130984, NULL, NULL, 'Other Publicity Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/OtherPublicityInd'),
  (130985, NULL, NULL, 'Income Level Criteria Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/IncomeLevelCriteriaInd'),
  (130986, NULL, NULL, 'Rpt Available Thru Other Method Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/RptAvailableThruOtherMethodInd'),
  (130987, NULL, NULL, 'Other Actions Taken Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/OtherActionsTakenInd'),
  (130988, NULL, NULL, 'Other Website URL Txt', 'TEXT', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/OtherWebsiteURLTxt'),
  (130989, NULL, NULL, 'Look Back Medicaid Medcr Prvt Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/LookBackMedicaidMedcrPrvtInd'),
  (130990, NULL, NULL, 'Prospective Medicare Medicaid Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/ProspectiveMedicareMedicaidInd'),
  (130991, NULL, NULL, 'Other Website Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/OtherWebsiteInd'),
  (130992, NULL, NULL, 'Look Back Medicare Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/LookBackMedicareInd'),
  (130993, NULL, NULL, 'Strategy Attached Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/StrategyAttachedInd'),
  (130994, NULL, NULL, 'Other Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/OtherInd'),
  (130995, NULL, NULL, 'Other Method Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/OtherMethodInd'),
  (130996, NULL, NULL, 'No Emergency Care Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/NoEmergencyCareInd'),
  (130997, NULL, NULL, 'None Made Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/NoneMadeInd'),
  (130998, NULL, NULL, 'Permit Report To Credit Agency Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/PermitReportToCreditAgencyInd'),
  (130999, NULL, NULL, 'Permit Legal Judicial Process Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/PermitLegalJudicialProcessInd'),
  (131000, NULL, NULL, 'Reporting To Credit Agency Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/ReportingToCreditAgencyInd'),
  (131001, NULL, NULL, 'Other Reason Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/OtherReasonInd'),
  (131002, NULL, NULL, 'Permit Other Actions Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/PermitOtherActionsInd'),
  (131003, NULL, NULL, 'Business Name Line2 Txt', 'TEXT', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/HospitalFacilityName/BusinessNameLine2Txt'),
  (131004, NULL, NULL, 'Form4720 Filed Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/Form4720FiledInd'),
  (131005, NULL, NULL, 'Other Actions Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/OtherActionsInd'),
  (131006, NULL, NULL, 'Engaged Legal Judicial Process Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/EngagedLegalJudicialProcessInd'),
  (131007, NULL, NULL, 'Excise Report Form4720 For All Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/ExciseReportForm4720ForAllAmt'),
  (131008, NULL, NULL, 'Permit Selling Debt Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/PermitSellingDebtInd'),
  (131009, NULL, NULL, 'Engaged Selling Debt Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/EngagedSellingDebtInd'),
  (131010, NULL, NULL, 'Permit Defer Deny Rqr Payment Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/PermitDeferDenyRqrPaymentInd'),
  (131011, NULL, NULL, 'Engage Defer Deny Rqr Payment Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/EngageDeferDenyRqrPaymentInd'),
  (131012, NULL, NULL, 'Emergency Care Limited Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFcltyPoliciesPrctcGrp/EmergencyCareLimitedInd');

-- 990 / IRS990 Direct Fields
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13084, 14, '035', 'IRS990 Direct Fields');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131013, 13084, '1', 'Nondeductible Contri Discl Ind', 'BOOLEAN'),
  (131014, 13084, '2', 'Excs Tax Sect4951 Or4952 Or4953 Ind', 'BOOLEAN'),
  (131015, 13084, '3', 'Group Exemption Num', 'INTEGER'),
  (131016, 13084, '4', 'Other Ind', 'BOOLEAN'),
  (131017, 13084, '5', 'Written Policy Or Procedure Ind', 'BOOLEAN'),
  (131018, 13084, '6', 'Type Of Organization Other Ind', 'BOOLEAN'),
  (131019, 13084, '7', 'Info In Schedule O Part V Ind', 'BOOLEAN'),
  (131020, 13084, '8', 'Initiation Fees And Cap Contri Amt', 'CURRENCY'),
  (131021, 13084, '9', 'Gross Receipts For Public Use Amt', 'CURRENCY'),
  (131022, 13084, '10', 'Licensed More Than One State Ind', 'BOOLEAN'),
  (131023, 13084, '11', 'Initial Return Ind', 'BOOLEAN'),
  (131024, 13084, '12', 'Foreign Country Cd', 'TEXT'),
  (131025, 13084, '13', 'Org Filed In Lieu Of Form1041 Ind', 'BOOLEAN'),
  (131026, 13084, '14', 'Form8886 T Filed Ind', 'BOOLEAN'),
  (131027, 13084, '15', 'Info In Schedule O Part X Ind', 'BOOLEAN'),
  (131028, 13084, '16', 'Form720 Filed Ind', 'BOOLEAN'),
  (131029, 13084, '17', 'Name Change Ind', 'BOOLEAN'),
  (131030, 13084, '18', 'Info In Schedule O Part VIII Ind', 'BOOLEAN'),
  (131031, 13084, '19', 'Final Return Ind', 'BOOLEAN'),
  (131032, 13084, '20', 'Audited Financial Stmt Att Ind', 'BOOLEAN'),
  (131033, 13084, '21', 'Joint Costs Ind', 'BOOLEAN'),
  (131034, 13084, '22', 'Tax Exempt Interest Amt', 'CURRENCY'),
  (131035, 13084, '23', 'All Affiliates Included Ind', 'BOOLEAN'),
  (131036, 13084, '24', 'State Required Reserves Amt', 'CURRENCY'),
  (131037, 13084, '25', 'Reserves Maintained Amt', 'CURRENCY'),
  (131038, 13084, '26', 'Application Pending Ind', 'BOOLEAN'),
  (131039, 13084, '27', 'Activity Cd', 'TEXT'),
  (131040, 13084, '28', 'Legal Domicile Country Cd', 'TEXT'),
  (131041, 13084, '29', 'Organization4947a1 Not PF Ind', 'BOOLEAN');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131013, NULL, NULL, 'Nondeductible Contri Discl Ind', 'BOOLEAN', 'ReturnData/IRS990/NondeductibleContriDisclInd'),
  (131014, NULL, NULL, 'Excs Tax Sect4951 Or4952 Or4953 Ind', 'BOOLEAN', 'ReturnData/IRS990/ExcsTaxSect4951Or4952Or4953Ind'),
  (131015, NULL, NULL, 'Group Exemption Num', 'INTEGER', 'ReturnData/IRS990/GroupExemptionNum'),
  (131016, NULL, NULL, 'Other Ind', 'BOOLEAN', 'ReturnData/IRS990/OtherInd'),
  (131017, NULL, NULL, 'Written Policy Or Procedure Ind', 'BOOLEAN', 'ReturnData/IRS990/WrittenPolicyOrProcedureInd'),
  (131018, NULL, NULL, 'Type Of Organization Other Ind', 'BOOLEAN', 'ReturnData/IRS990/TypeOfOrganizationOtherInd'),
  (131019, NULL, NULL, 'Info In Schedule O Part V Ind', 'BOOLEAN', 'ReturnData/IRS990/InfoInScheduleOPartVInd'),
  (131020, NULL, NULL, 'Initiation Fees And Cap Contri Amt', 'CURRENCY', 'ReturnData/IRS990/InitiationFeesAndCapContriAmt'),
  (131021, NULL, NULL, 'Gross Receipts For Public Use Amt', 'CURRENCY', 'ReturnData/IRS990/GrossReceiptsForPublicUseAmt'),
  (131022, NULL, NULL, 'Licensed More Than One State Ind', 'BOOLEAN', 'ReturnData/IRS990/LicensedMoreThanOneStateInd'),
  (131023, NULL, NULL, 'Initial Return Ind', 'BOOLEAN', 'ReturnData/IRS990/InitialReturnInd'),
  (131024, NULL, NULL, 'Foreign Country Cd', 'TEXT', 'ReturnData/IRS990/ForeignCountryCd'),
  (131025, NULL, NULL, 'Org Filed In Lieu Of Form1041 Ind', 'BOOLEAN', 'ReturnData/IRS990/OrgFiledInLieuOfForm1041Ind'),
  (131026, NULL, NULL, 'Form8886 T Filed Ind', 'BOOLEAN', 'ReturnData/IRS990/Form8886TFiledInd'),
  (131027, NULL, NULL, 'Info In Schedule O Part X Ind', 'BOOLEAN', 'ReturnData/IRS990/InfoInScheduleOPartXInd'),
  (131028, NULL, NULL, 'Form720 Filed Ind', 'BOOLEAN', 'ReturnData/IRS990/Form720FiledInd'),
  (131029, NULL, NULL, 'Name Change Ind', 'BOOLEAN', 'ReturnData/IRS990/NameChangeInd'),
  (131030, NULL, NULL, 'Info In Schedule O Part VIII Ind', 'BOOLEAN', 'ReturnData/IRS990/InfoInScheduleOPartVIIIInd'),
  (131031, NULL, NULL, 'Final Return Ind', 'BOOLEAN', 'ReturnData/IRS990/FinalReturnInd'),
  (131032, NULL, NULL, 'Audited Financial Stmt Att Ind', 'BOOLEAN', 'ReturnData/IRS990/AuditedFinancialStmtAttInd'),
  (131033, NULL, NULL, 'Joint Costs Ind', 'BOOLEAN', 'ReturnData/IRS990/JointCostsInd'),
  (131034, NULL, NULL, 'Tax Exempt Interest Amt', 'CURRENCY', 'ReturnData/IRS990/TaxExemptInterestAmt'),
  (131035, NULL, NULL, 'All Affiliates Included Ind', 'BOOLEAN', 'ReturnData/IRS990/AllAffiliatesIncludedInd'),
  (131036, NULL, NULL, 'State Required Reserves Amt', 'CURRENCY', 'ReturnData/IRS990/StateRequiredReservesAmt'),
  (131037, NULL, NULL, 'Reserves Maintained Amt', 'CURRENCY', 'ReturnData/IRS990/ReservesMaintainedAmt'),
  (131038, NULL, NULL, 'Application Pending Ind', 'BOOLEAN', 'ReturnData/IRS990/ApplicationPendingInd'),
  (131039, NULL, NULL, 'Activity Cd', 'TEXT', 'ReturnData/IRS990/ActivityCd'),
  (131040, NULL, NULL, 'Legal Domicile Country Cd', 'TEXT', 'ReturnData/IRS990/LegalDomicileCountryCd'),
  (131041, NULL, NULL, 'Organization4947a1 Not PF Ind', 'BOOLEAN', 'ReturnData/IRS990/Organization4947a1NotPFInd');

-- 990 / Id Disregarded Entities Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13085, 14, '036', 'Id Disregarded Entities Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131042, 13085, '1', 'Business Name Line1 Txt', 'TEXT'),
  (131043, 13085, '2', 'Primary Activities Txt', 'TEXT'),
  (131044, 13085, '3', 'Address Line1 Txt', 'TEXT'),
  (131045, 13085, '4', 'City Nm', 'TEXT'),
  (131046, 13085, '5', 'State Abbreviation Cd', 'TEXT'),
  (131047, 13085, '6', 'ZIP Cd', 'TEXT'),
  (131048, 13085, '7', 'Legal Domicile State Cd', 'TEXT'),
  (131049, 13085, '8', 'Business Name Line1 Txt', 'TEXT'),
  (131050, 13085, '9', 'EIN', 'TEXT'),
  (131051, 13085, '10', 'End Of Year Assets Amt', 'CURRENCY'),
  (131052, 13085, '11', 'Total Income Amt', 'CURRENCY'),
  (131053, 13085, '12', 'Direct Controlling NA Cd', 'TEXT'),
  (131054, 13085, '13', 'Legal Domicile Foreign Country Cd', 'TEXT'),
  (131055, 13085, '14', 'Business Name Line2 Txt', 'TEXT'),
  (131056, 13085, '15', 'Address Line1 Txt', 'TEXT'),
  (131057, 13085, '16', 'Country Cd', 'TEXT'),
  (131058, 13085, '17', 'Address Line2 Txt', 'TEXT'),
  (131059, 13085, '18', 'City Nm', 'TEXT'),
  (131060, 13085, '19', 'Foreign Postal Cd', 'TEXT'),
  (131061, 13085, '20', 'Province Or State Nm', 'TEXT'),
  (131062, 13085, '21', 'Business Name Line2 Txt', 'TEXT'),
  (131063, 13085, '22', 'Address Line2 Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131042, NULL, NULL, 'Business Name Line1 Txt', 'TEXT', 'ReturnData/IRS990ScheduleR/IdDisregardedEntitiesGrp/DisregardedEntityName/BusinessNameLine1Txt'),
  (131043, NULL, NULL, 'Primary Activities Txt', 'TEXT', 'ReturnData/IRS990ScheduleR/IdDisregardedEntitiesGrp/PrimaryActivitiesTxt'),
  (131044, NULL, NULL, 'Address Line1 Txt', 'TEXT', 'ReturnData/IRS990ScheduleR/IdDisregardedEntitiesGrp/USAddress/AddressLine1Txt'),
  (131045, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990ScheduleR/IdDisregardedEntitiesGrp/USAddress/CityNm'),
  (131046, NULL, NULL, 'State Abbreviation Cd', 'TEXT', 'ReturnData/IRS990ScheduleR/IdDisregardedEntitiesGrp/USAddress/StateAbbreviationCd'),
  (131047, NULL, NULL, 'ZIP Cd', 'TEXT', 'ReturnData/IRS990ScheduleR/IdDisregardedEntitiesGrp/USAddress/ZIPCd'),
  (131048, NULL, NULL, 'Legal Domicile State Cd', 'TEXT', 'ReturnData/IRS990ScheduleR/IdDisregardedEntitiesGrp/LegalDomicileStateCd'),
  (131049, NULL, NULL, 'Business Name Line1 Txt', 'TEXT', 'ReturnData/IRS990ScheduleR/IdDisregardedEntitiesGrp/DirectControllingEntityName/BusinessNameLine1Txt'),
  (131050, NULL, NULL, 'EIN', 'TEXT', 'ReturnData/IRS990ScheduleR/IdDisregardedEntitiesGrp/EIN'),
  (131051, NULL, NULL, 'End Of Year Assets Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleR/IdDisregardedEntitiesGrp/EndOfYearAssetsAmt'),
  (131052, NULL, NULL, 'Total Income Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleR/IdDisregardedEntitiesGrp/TotalIncomeAmt'),
  (131053, NULL, NULL, 'Direct Controlling NA Cd', 'TEXT', 'ReturnData/IRS990ScheduleR/IdDisregardedEntitiesGrp/DirectControllingNACd'),
  (131054, NULL, NULL, 'Legal Domicile Foreign Country Cd', 'TEXT', 'ReturnData/IRS990ScheduleR/IdDisregardedEntitiesGrp/LegalDomicileForeignCountryCd'),
  (131055, NULL, NULL, 'Business Name Line2 Txt', 'TEXT', 'ReturnData/IRS990ScheduleR/IdDisregardedEntitiesGrp/DirectControllingEntityName/BusinessNameLine2Txt'),
  (131056, NULL, NULL, 'Address Line1 Txt', 'TEXT', 'ReturnData/IRS990ScheduleR/IdDisregardedEntitiesGrp/ForeignAddress/AddressLine1Txt'),
  (131057, NULL, NULL, 'Country Cd', 'TEXT', 'ReturnData/IRS990ScheduleR/IdDisregardedEntitiesGrp/ForeignAddress/CountryCd'),
  (131058, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/IRS990ScheduleR/IdDisregardedEntitiesGrp/USAddress/AddressLine2Txt'),
  (131059, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990ScheduleR/IdDisregardedEntitiesGrp/ForeignAddress/CityNm'),
  (131060, NULL, NULL, 'Foreign Postal Cd', 'TEXT', 'ReturnData/IRS990ScheduleR/IdDisregardedEntitiesGrp/ForeignAddress/ForeignPostalCd'),
  (131061, NULL, NULL, 'Province Or State Nm', 'TEXT', 'ReturnData/IRS990ScheduleR/IdDisregardedEntitiesGrp/ForeignAddress/ProvinceOrStateNm'),
  (131062, NULL, NULL, 'Business Name Line2 Txt', 'TEXT', 'ReturnData/IRS990ScheduleR/IdDisregardedEntitiesGrp/DisregardedEntityName/BusinessNameLine2Txt'),
  (131063, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/IRS990ScheduleR/IdDisregardedEntitiesGrp/ForeignAddress/AddressLine2Txt');

-- 990 / IRS990 Schedule G Direct Fields
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13086, 14, '037', 'IRS990 Schedule G Direct Fields');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131064, 13086, '1', 'Special Fundraising Events Ind', 'BOOLEAN'),
  (131065, 13086, '2', 'Individual With Books Nm', 'TEXT'),
  (131066, 13086, '3', 'Email Solicitations Ind', 'BOOLEAN'),
  (131067, 13086, '4', 'Mail Solicitations Ind', 'BOOLEAN'),
  (131068, 13086, '5', 'In Person Solicitations Ind', 'BOOLEAN'),
  (131069, 13086, '6', 'Licensed States Cd', 'TEXT'),
  (131070, 13086, '7', 'Total Retained By Contractors Amt', 'CURRENCY'),
  (131071, 13086, '8', 'Solicitation Of Non Govt Grants Ind', 'BOOLEAN'),
  (131072, 13086, '9', 'Total Net To Organization Amt', 'CURRENCY'),
  (131073, 13086, '10', 'Gaming Manager Services Prov Txt', 'TEXT'),
  (131074, 13086, '11', 'Gaming Manager Person Nm', 'TEXT'),
  (131075, 13086, '12', 'Phone Solicitations Ind', 'BOOLEAN'),
  (131076, 13086, '13', 'Total Gross Receipts Amt', 'CURRENCY'),
  (131077, 13086, '14', 'Gaming Other Facility Pct', 'PERCENT'),
  (131078, 13086, '15', 'Solicitation Of Govt Grants Ind', 'BOOLEAN'),
  (131079, 13086, '16', 'Gaming Manager Is Director Ofcr Ind', 'BOOLEAN'),
  (131080, 13086, '17', 'Distributed Amt', 'CURRENCY'),
  (131081, 13086, '18', 'Gaming Manager Compensation Amt', 'CURRENCY'),
  (131082, 13086, '19', 'Gaming Manager Is Employee Ind', 'BOOLEAN'),
  (131083, 13086, '20', 'Explanation If No Txt', 'TEXT'),
  (131084, 13086, '21', 'Gaming Revenue Received By Org Amt', 'CURRENCY'),
  (131085, 13086, '22', 'Gaming Revenue Rtn By3 Prty Amt', 'CURRENCY'),
  (131086, 13086, '23', 'Gaming Manager Is Ind Cntrct Ind', 'BOOLEAN'),
  (131087, 13086, '24', 'All States Cd', 'TEXT'),
  (131088, 13086, '25', 'Third Party Person Nm', 'TEXT'),
  (131089, 13086, '26', 'Explanation If Yes Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131064, NULL, NULL, 'Special Fundraising Events Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleG/SpecialFundraisingEventsInd'),
  (131065, NULL, NULL, 'Individual With Books Nm', 'TEXT', 'ReturnData/IRS990ScheduleG/IndividualWithBooksNm'),
  (131066, NULL, NULL, 'Email Solicitations Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleG/EmailSolicitationsInd'),
  (131067, NULL, NULL, 'Mail Solicitations Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleG/MailSolicitationsInd'),
  (131068, NULL, NULL, 'In Person Solicitations Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleG/InPersonSolicitationsInd'),
  (131069, NULL, NULL, 'Licensed States Cd', 'TEXT', 'ReturnData/IRS990ScheduleG/LicensedStatesCd'),
  (131070, NULL, NULL, 'Total Retained By Contractors Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/TotalRetainedByContractorsAmt'),
  (131071, NULL, NULL, 'Solicitation Of Non Govt Grants Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleG/SolicitationOfNonGovtGrantsInd'),
  (131072, NULL, NULL, 'Total Net To Organization Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/TotalNetToOrganizationAmt'),
  (131073, NULL, NULL, 'Gaming Manager Services Prov Txt', 'TEXT', 'ReturnData/IRS990ScheduleG/GamingManagerServicesProvTxt'),
  (131074, NULL, NULL, 'Gaming Manager Person Nm', 'TEXT', 'ReturnData/IRS990ScheduleG/GamingManagerPersonNm'),
  (131075, NULL, NULL, 'Phone Solicitations Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleG/PhoneSolicitationsInd'),
  (131076, NULL, NULL, 'Total Gross Receipts Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/TotalGrossReceiptsAmt'),
  (131077, NULL, NULL, 'Gaming Other Facility Pct', 'PERCENT', 'ReturnData/IRS990ScheduleG/GamingOtherFacilityPct'),
  (131078, NULL, NULL, 'Solicitation Of Govt Grants Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleG/SolicitationOfGovtGrantsInd'),
  (131079, NULL, NULL, 'Gaming Manager Is Director Ofcr Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleG/GamingManagerIsDirectorOfcrInd'),
  (131080, NULL, NULL, 'Distributed Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/DistributedAmt'),
  (131081, NULL, NULL, 'Gaming Manager Compensation Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/GamingManagerCompensationAmt'),
  (131082, NULL, NULL, 'Gaming Manager Is Employee Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleG/GamingManagerIsEmployeeInd'),
  (131083, NULL, NULL, 'Explanation If No Txt', 'TEXT', 'ReturnData/IRS990ScheduleG/ExplanationIfNoTxt'),
  (131084, NULL, NULL, 'Gaming Revenue Received By Org Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/GamingRevenueReceivedByOrgAmt'),
  (131085, NULL, NULL, 'Gaming Revenue Rtn By3 Prty Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/GamingRevenueRtnBy3PrtyAmt'),
  (131086, NULL, NULL, 'Gaming Manager Is Ind Cntrct Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleG/GamingManagerIsIndCntrctInd'),
  (131087, NULL, NULL, 'All States Cd', 'TEXT', 'ReturnData/IRS990ScheduleG/AllStatesCd'),
  (131088, NULL, NULL, 'Third Party Person Nm', 'TEXT', 'ReturnData/IRS990ScheduleG/ThirdPartyPersonNm'),
  (131089, NULL, NULL, 'Explanation If Yes Txt', 'TEXT', 'ReturnData/IRS990ScheduleG/ExplanationIfYesTxt');

-- 990 / Account Activities Outside US Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13087, 14, '038', 'Account Activities Outside US Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131090, 13087, '1', 'Region Txt', 'TEXT'),
  (131091, 13087, '2', 'Type Of Activities Conducted Txt', 'TEXT'),
  (131092, 13087, '3', 'Region Total Expenditures Amt', 'CURRENCY'),
  (131093, 13087, '4', 'Employee Cnt', 'INTEGER'),
  (131094, 13087, '5', 'Offices Cnt', 'INTEGER'),
  (131095, 13087, '6', 'Specific Services Provided Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131090, NULL, NULL, 'Region Txt', 'TEXT', 'ReturnData/IRS990ScheduleF/AccountActivitiesOutsideUSGrp/RegionTxt'),
  (131091, NULL, NULL, 'Type Of Activities Conducted Txt', 'TEXT', 'ReturnData/IRS990ScheduleF/AccountActivitiesOutsideUSGrp/TypeOfActivitiesConductedTxt'),
  (131092, NULL, NULL, 'Region Total Expenditures Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleF/AccountActivitiesOutsideUSGrp/RegionTotalExpendituresAmt'),
  (131093, NULL, NULL, 'Employee Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleF/AccountActivitiesOutsideUSGrp/EmployeeCnt'),
  (131094, NULL, NULL, 'Offices Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleF/AccountActivitiesOutsideUSGrp/OfficesCnt'),
  (131095, NULL, NULL, 'Specific Services Provided Txt', 'TEXT', 'ReturnData/IRS990ScheduleF/AccountActivitiesOutsideUSGrp/SpecificServicesProvidedTxt');

-- 990 / Other Securities Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13088, 14, '039', 'Other Securities Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131096, 13088, '1', 'Desc', 'TEXT'),
  (131097, 13088, '2', 'Book Value Amt', 'CURRENCY'),
  (131098, 13088, '3', 'Method Valuation Cd', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131096, NULL, NULL, 'Desc', 'TEXT', 'ReturnData/IRS990ScheduleD/OtherSecuritiesGrp/Desc'),
  (131097, NULL, NULL, 'Book Value Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/OtherSecuritiesGrp/BookValueAmt'),
  (131098, NULL, NULL, 'Method Valuation Cd', 'TEXT', 'ReturnData/IRS990ScheduleD/OtherSecuritiesGrp/MethodValuationCd');

-- 990 / Gaming Information Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13089, 14, '040', 'Gaming Information Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131099, 13089, '1', 'Volunteer Labor Other Gaming Ind', 'BOOLEAN'),
  (131100, 13089, '2', 'Volunteer Labor Bingo Ind', 'BOOLEAN'),
  (131101, 13089, '3', 'Gross Revenue Other Gaming Amt', 'CURRENCY'),
  (131102, 13089, '4', 'Oth Direct Expnss Other Gaming Amt', 'CURRENCY'),
  (131103, 13089, '5', 'Gross Revenue Bingo Amt', 'CURRENCY'),
  (131104, 13089, '6', 'Other Direct Expenses Bingo Amt', 'CURRENCY'),
  (131105, 13089, '7', 'Cash Prizes Other Gaming Amt', 'CURRENCY'),
  (131106, 13089, '8', 'Cash Prizes Bingo Amt', 'CURRENCY'),
  (131107, 13089, '9', 'Rent Fclty Costs Total Gaming Amt', 'CURRENCY'),
  (131108, 13089, '10', 'Volunteer Labor Other Gaming Pct', 'PERCENT'),
  (131109, 13089, '11', 'Non Cash Prizes Total Gaming Amt', 'CURRENCY'),
  (131110, 13089, '12', 'Volunteer Labor Pull Tabs Pct', 'PERCENT'),
  (131111, 13089, '13', 'Rent Facility Costs Pull Tabs Amt', 'CURRENCY'),
  (131112, 13089, '14', 'Volunteer Labor Bingo Pct', 'PERCENT'),
  (131113, 13089, '15', 'Non Cash Prizes Other Gaming Amt', 'CURRENCY'),
  (131114, 13089, '16', 'Rent Facility Costs Bingo Amt', 'CURRENCY'),
  (131115, 13089, '17', 'Rent Fclty Costs Other Gaming Amt', 'CURRENCY'),
  (131116, 13089, '18', 'Non Cash Prizes Bingo Amt', 'CURRENCY'),
  (131117, 13089, '19', 'Non Cash Prizes Pull Tabs Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131099, NULL, NULL, 'Volunteer Labor Other Gaming Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleG/GamingInformationGrp/VolunteerLaborOtherGamingInd'),
  (131100, NULL, NULL, 'Volunteer Labor Bingo Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleG/GamingInformationGrp/VolunteerLaborBingoInd'),
  (131101, NULL, NULL, 'Gross Revenue Other Gaming Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/GamingInformationGrp/GrossRevenueOtherGamingAmt'),
  (131102, NULL, NULL, 'Oth Direct Expnss Other Gaming Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/GamingInformationGrp/OthDirectExpnssOtherGamingAmt'),
  (131103, NULL, NULL, 'Gross Revenue Bingo Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/GamingInformationGrp/GrossRevenueBingoAmt'),
  (131104, NULL, NULL, 'Other Direct Expenses Bingo Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/GamingInformationGrp/OtherDirectExpensesBingoAmt'),
  (131105, NULL, NULL, 'Cash Prizes Other Gaming Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/GamingInformationGrp/CashPrizesOtherGamingAmt'),
  (131106, NULL, NULL, 'Cash Prizes Bingo Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/GamingInformationGrp/CashPrizesBingoAmt'),
  (131107, NULL, NULL, 'Rent Fclty Costs Total Gaming Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/GamingInformationGrp/RentFcltyCostsTotalGamingAmt'),
  (131108, NULL, NULL, 'Volunteer Labor Other Gaming Pct', 'PERCENT', 'ReturnData/IRS990ScheduleG/GamingInformationGrp/VolunteerLaborOtherGamingPct'),
  (131109, NULL, NULL, 'Non Cash Prizes Total Gaming Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/GamingInformationGrp/NonCashPrizesTotalGamingAmt'),
  (131110, NULL, NULL, 'Volunteer Labor Pull Tabs Pct', 'PERCENT', 'ReturnData/IRS990ScheduleG/GamingInformationGrp/VolunteerLaborPullTabsPct'),
  (131111, NULL, NULL, 'Rent Facility Costs Pull Tabs Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/GamingInformationGrp/RentFacilityCostsPullTabsAmt'),
  (131112, NULL, NULL, 'Volunteer Labor Bingo Pct', 'PERCENT', 'ReturnData/IRS990ScheduleG/GamingInformationGrp/VolunteerLaborBingoPct'),
  (131113, NULL, NULL, 'Non Cash Prizes Other Gaming Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/GamingInformationGrp/NonCashPrizesOtherGamingAmt'),
  (131114, NULL, NULL, 'Rent Facility Costs Bingo Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/GamingInformationGrp/RentFacilityCostsBingoAmt'),
  (131115, NULL, NULL, 'Rent Fclty Costs Other Gaming Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/GamingInformationGrp/RentFcltyCostsOtherGamingAmt'),
  (131116, NULL, NULL, 'Non Cash Prizes Bingo Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/GamingInformationGrp/NonCashPrizesBingoAmt'),
  (131117, NULL, NULL, 'Non Cash Prizes Pull Tabs Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/GamingInformationGrp/NonCashPrizesPullTabsAmt');

-- 990 / Supplemental Information Detail
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13090, 14, '041', 'Supplemental Information Detail');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131118, 13090, '1', 'Form And Line Reference Desc', 'TEXT'),
  (131119, 13090, '2', 'Explanation Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131118, NULL, NULL, 'Form And Line Reference Desc', 'TEXT', 'ReturnData/IRS990ScheduleJ/SupplementalInformationDetail/FormAndLineReferenceDesc'),
  (131119, NULL, NULL, 'Explanation Txt', 'TEXT', 'ReturnData/IRS990ScheduleJ/SupplementalInformationDetail/ExplanationTxt');

-- 990 / Fundraiser Activity Info Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13091, 14, '042', 'Fundraiser Activity Info Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131120, 13091, '1', 'Fundraiser Control Of Funds Ind', 'BOOLEAN'),
  (131121, 13091, '2', 'Retained By Contractor Amt', 'CURRENCY'),
  (131122, 13091, '3', 'Activity Txt', 'TEXT'),
  (131123, 13091, '4', 'Address Line1 Txt', 'TEXT'),
  (131124, 13091, '5', 'City Nm', 'TEXT'),
  (131125, 13091, '6', 'State Abbreviation Cd', 'TEXT'),
  (131126, 13091, '7', 'ZIP Cd', 'TEXT'),
  (131127, 13091, '8', 'Net To Organization Amt', 'CURRENCY'),
  (131128, 13091, '9', 'Gross Receipts Amt', 'CURRENCY'),
  (131129, 13091, '10', 'Business Name Line1 Txt', 'TEXT'),
  (131130, 13091, '11', 'Person Nm', 'TEXT'),
  (131131, 13091, '12', 'Address Line2 Txt', 'TEXT'),
  (131132, 13091, '13', 'Address Line1 Txt', 'TEXT'),
  (131133, 13091, '14', 'Country Cd', 'TEXT'),
  (131134, 13091, '15', 'City Nm', 'TEXT'),
  (131135, 13091, '16', 'Foreign Postal Cd', 'TEXT'),
  (131136, 13091, '17', 'Province Or State Nm', 'TEXT'),
  (131137, 13091, '18', 'Business Name Line2 Txt', 'TEXT'),
  (131138, 13091, '19', 'Address Line2 Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131120, NULL, NULL, 'Fundraiser Control Of Funds Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleG/FundraiserActivityInfoGrp/FundraiserControlOfFundsInd'),
  (131121, NULL, NULL, 'Retained By Contractor Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/FundraiserActivityInfoGrp/RetainedByContractorAmt'),
  (131122, NULL, NULL, 'Activity Txt', 'TEXT', 'ReturnData/IRS990ScheduleG/FundraiserActivityInfoGrp/ActivityTxt'),
  (131123, NULL, NULL, 'Address Line1 Txt', 'TEXT', 'ReturnData/IRS990ScheduleG/FundraiserActivityInfoGrp/USAddress/AddressLine1Txt'),
  (131124, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990ScheduleG/FundraiserActivityInfoGrp/USAddress/CityNm'),
  (131125, NULL, NULL, 'State Abbreviation Cd', 'TEXT', 'ReturnData/IRS990ScheduleG/FundraiserActivityInfoGrp/USAddress/StateAbbreviationCd'),
  (131126, NULL, NULL, 'ZIP Cd', 'TEXT', 'ReturnData/IRS990ScheduleG/FundraiserActivityInfoGrp/USAddress/ZIPCd'),
  (131127, NULL, NULL, 'Net To Organization Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/FundraiserActivityInfoGrp/NetToOrganizationAmt'),
  (131128, NULL, NULL, 'Gross Receipts Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleG/FundraiserActivityInfoGrp/GrossReceiptsAmt'),
  (131129, NULL, NULL, 'Business Name Line1 Txt', 'TEXT', 'ReturnData/IRS990ScheduleG/FundraiserActivityInfoGrp/OrganizationBusinessName/BusinessNameLine1Txt'),
  (131130, NULL, NULL, 'Person Nm', 'TEXT', 'ReturnData/IRS990ScheduleG/FundraiserActivityInfoGrp/PersonNm'),
  (131131, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/IRS990ScheduleG/FundraiserActivityInfoGrp/USAddress/AddressLine2Txt'),
  (131132, NULL, NULL, 'Address Line1 Txt', 'TEXT', 'ReturnData/IRS990ScheduleG/FundraiserActivityInfoGrp/ForeignAddress/AddressLine1Txt'),
  (131133, NULL, NULL, 'Country Cd', 'TEXT', 'ReturnData/IRS990ScheduleG/FundraiserActivityInfoGrp/ForeignAddress/CountryCd'),
  (131134, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990ScheduleG/FundraiserActivityInfoGrp/ForeignAddress/CityNm'),
  (131135, NULL, NULL, 'Foreign Postal Cd', 'TEXT', 'ReturnData/IRS990ScheduleG/FundraiserActivityInfoGrp/ForeignAddress/ForeignPostalCd'),
  (131136, NULL, NULL, 'Province Or State Nm', 'TEXT', 'ReturnData/IRS990ScheduleG/FundraiserActivityInfoGrp/ForeignAddress/ProvinceOrStateNm'),
  (131137, NULL, NULL, 'Business Name Line2 Txt', 'TEXT', 'ReturnData/IRS990ScheduleG/FundraiserActivityInfoGrp/OrganizationBusinessName/BusinessNameLine2Txt'),
  (131138, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/IRS990ScheduleG/FundraiserActivityInfoGrp/ForeignAddress/AddressLine2Txt');

-- 990 / CY Minus1 Yr Endwmt Fund Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13092, 14, '043', 'CY Minus1 Yr Endwmt Fund Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131139, 13092, '1', 'Contributions Amt', 'CURRENCY'),
  (131140, 13092, '2', 'Other Expenditures Amt', 'CURRENCY'),
  (131141, 13092, '3', 'Administrative Expenses Amt', 'CURRENCY'),
  (131142, 13092, '4', 'Grants Or Scholarships Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131139, NULL, NULL, 'Contributions Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/CYMinus1YrEndwmtFundGrp/ContributionsAmt'),
  (131140, NULL, NULL, 'Other Expenditures Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/CYMinus1YrEndwmtFundGrp/OtherExpendituresAmt'),
  (131141, NULL, NULL, 'Administrative Expenses Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/CYMinus1YrEndwmtFundGrp/AdministrativeExpensesAmt'),
  (131142, NULL, NULL, 'Grants Or Scholarships Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/CYMinus1YrEndwmtFundGrp/GrantsOrScholarshipsAmt');

-- 990 / Loans Btwn Org Interested Prsn Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13093, 14, '044', 'Loans Btwn Org Interested Prsn Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131143, 13093, '1', 'Original Principal Amt', 'CURRENCY'),
  (131144, 13093, '2', 'Relationship With Org Txt', 'TEXT'),
  (131145, 13093, '3', 'Loan Purpose Txt', 'TEXT'),
  (131146, 13093, '4', 'Balance Due Amt', 'CURRENCY'),
  (131147, 13093, '5', 'Person Nm', 'TEXT'),
  (131148, 13093, '6', 'Loan To Organization Ind', 'BOOLEAN'),
  (131149, 13093, '7', 'Loan From Organization Ind', 'BOOLEAN'),
  (131150, 13093, '8', 'Business Name Line1 Txt', 'TEXT'),
  (131151, 13093, '9', 'Business Name Line2 Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131143, NULL, NULL, 'Original Principal Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleL/LoansBtwnOrgInterestedPrsnGrp/OriginalPrincipalAmt'),
  (131144, NULL, NULL, 'Relationship With Org Txt', 'TEXT', 'ReturnData/IRS990ScheduleL/LoansBtwnOrgInterestedPrsnGrp/RelationshipWithOrgTxt'),
  (131145, NULL, NULL, 'Loan Purpose Txt', 'TEXT', 'ReturnData/IRS990ScheduleL/LoansBtwnOrgInterestedPrsnGrp/LoanPurposeTxt'),
  (131146, NULL, NULL, 'Balance Due Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleL/LoansBtwnOrgInterestedPrsnGrp/BalanceDueAmt'),
  (131147, NULL, NULL, 'Person Nm', 'TEXT', 'ReturnData/IRS990ScheduleL/LoansBtwnOrgInterestedPrsnGrp/PersonNm'),
  (131148, NULL, NULL, 'Loan To Organization Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleL/LoansBtwnOrgInterestedPrsnGrp/LoanToOrganizationInd'),
  (131149, NULL, NULL, 'Loan From Organization Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleL/LoansBtwnOrgInterestedPrsnGrp/LoanFromOrganizationInd'),
  (131150, NULL, NULL, 'Business Name Line1 Txt', 'TEXT', 'ReturnData/IRS990ScheduleL/LoansBtwnOrgInterestedPrsnGrp/BusinessName/BusinessNameLine1Txt'),
  (131151, NULL, NULL, 'Business Name Line2 Txt', 'TEXT', 'ReturnData/IRS990ScheduleL/LoansBtwnOrgInterestedPrsnGrp/BusinessName/BusinessNameLine2Txt');

-- 990 / CY Minus2 Yr Endwmt Fund Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13094, 14, '045', 'CY Minus2 Yr Endwmt Fund Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131152, 13094, '1', 'Contributions Amt', 'CURRENCY'),
  (131153, 13094, '2', 'Other Expenditures Amt', 'CURRENCY'),
  (131154, 13094, '3', 'Administrative Expenses Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131152, NULL, NULL, 'Contributions Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/CYMinus2YrEndwmtFundGrp/ContributionsAmt'),
  (131153, NULL, NULL, 'Other Expenditures Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/CYMinus2YrEndwmtFundGrp/OtherExpendituresAmt'),
  (131154, NULL, NULL, 'Administrative Expenses Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/CYMinus2YrEndwmtFundGrp/AdministrativeExpensesAmt');

-- 990 / IRS990 Schedule H Direct Fields
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13095, 14, '046', 'IRS990 Schedule H Direct Fields');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131155, 13095, '1', 'Hospital Facilities Cnt', 'INTEGER'),
  (131156, 13095, '2', 'Financial Assistance Policy Ind', 'BOOLEAN'),
  (131157, 13095, '3', 'Written Policy Ind', 'BOOLEAN'),
  (131158, 13095, '4', 'FPG Reference Free Care Ind', 'BOOLEAN'),
  (131159, 13095, '5', 'Written Debt Collection Policy Ind', 'BOOLEAN'),
  (131160, 13095, '6', 'FPG Reference Discounted Care Ind', 'BOOLEAN'),
  (131161, 13095, '7', 'Bad Debt Expense Reported Ind', 'BOOLEAN'),
  (131162, 13095, '8', 'Financial Assistance Prvsn Ind', 'BOOLEAN'),
  (131163, 13095, '9', 'Reimbursed By Medicare Amt', 'CURRENCY'),
  (131164, 13095, '10', 'Cost Of Care Reimbursed By Medcr Amt', 'CURRENCY'),
  (131165, 13095, '11', 'Medicare Surplus Or Shortfall Amt', 'CURRENCY'),
  (131166, 13095, '12', 'Bad Debt Expense Amt', 'CURRENCY'),
  (131167, 13095, '13', 'Annual Community Bnft Report Ind', 'BOOLEAN'),
  (131168, 13095, '14', 'Financial Assistance Budget Ind', 'BOOLEAN'),
  (131169, 13095, '15', 'Free Care Medically Indigent Ind', 'BOOLEAN'),
  (131170, 13095, '16', 'Expenses Exceed Budget Ind', 'BOOLEAN'),
  (131171, 13095, '17', 'All Hospitals Policy Ind', 'BOOLEAN'),
  (131172, 13095, '18', 'Facility Num', 'INTEGER'),
  (131173, 13095, '19', 'Report Publically Available Ind', 'BOOLEAN'),
  (131174, 13095, '20', 'Bad Debt Expense Attributable Amt', 'CURRENCY'),
  (131175, 13095, '21', 'Unable To Provide Care Ind', 'BOOLEAN'),
  (131176, 13095, '22', 'Percent200 Ind', 'BOOLEAN'),
  (131177, 13095, '23', 'Percent400 Ind', 'BOOLEAN'),
  (131178, 13095, '24', 'Percent300 Ind', 'BOOLEAN'),
  (131179, 13095, '25', 'Percent100 Ind', 'BOOLEAN'),
  (131180, 13095, '26', 'Percent200 D Ind', 'BOOLEAN'),
  (131181, 13095, '27', 'Percent150 Ind', 'BOOLEAN'),
  (131182, 13095, '28', 'Percent250 Ind', 'BOOLEAN'),
  (131183, 13095, '29', 'Percent350 Ind', 'BOOLEAN'),
  (131184, 13095, '30', 'Most Hospitals Policy Ind', 'BOOLEAN'),
  (131185, 13095, '31', 'Indiv Hospital Tailored Policy Ind', 'BOOLEAN');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131155, NULL, NULL, 'Hospital Facilities Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleH/HospitalFacilitiesCnt'),
  (131156, NULL, NULL, 'Financial Assistance Policy Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/FinancialAssistancePolicyInd'),
  (131157, NULL, NULL, 'Written Policy Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/WrittenPolicyInd'),
  (131158, NULL, NULL, 'FPG Reference Free Care Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/FPGReferenceFreeCareInd'),
  (131159, NULL, NULL, 'Written Debt Collection Policy Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/WrittenDebtCollectionPolicyInd'),
  (131160, NULL, NULL, 'FPG Reference Discounted Care Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/FPGReferenceDiscountedCareInd'),
  (131161, NULL, NULL, 'Bad Debt Expense Reported Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/BadDebtExpenseReportedInd'),
  (131162, NULL, NULL, 'Financial Assistance Prvsn Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/FinancialAssistancePrvsnInd'),
  (131163, NULL, NULL, 'Reimbursed By Medicare Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/ReimbursedByMedicareAmt'),
  (131164, NULL, NULL, 'Cost Of Care Reimbursed By Medcr Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/CostOfCareReimbursedByMedcrAmt'),
  (131165, NULL, NULL, 'Medicare Surplus Or Shortfall Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/MedicareSurplusOrShortfallAmt'),
  (131166, NULL, NULL, 'Bad Debt Expense Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/BadDebtExpenseAmt'),
  (131167, NULL, NULL, 'Annual Community Bnft Report Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/AnnualCommunityBnftReportInd'),
  (131168, NULL, NULL, 'Financial Assistance Budget Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/FinancialAssistanceBudgetInd'),
  (131169, NULL, NULL, 'Free Care Medically Indigent Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/FreeCareMedicallyIndigentInd'),
  (131170, NULL, NULL, 'Expenses Exceed Budget Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/ExpensesExceedBudgetInd'),
  (131171, NULL, NULL, 'All Hospitals Policy Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/AllHospitalsPolicyInd'),
  (131172, NULL, NULL, 'Facility Num', 'INTEGER', 'ReturnData/IRS990ScheduleH/FacilityNum'),
  (131173, NULL, NULL, 'Report Publically Available Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/ReportPublicallyAvailableInd'),
  (131174, NULL, NULL, 'Bad Debt Expense Attributable Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/BadDebtExpenseAttributableAmt'),
  (131175, NULL, NULL, 'Unable To Provide Care Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/UnableToProvideCareInd'),
  (131176, NULL, NULL, 'Percent200 Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/Percent200Ind'),
  (131177, NULL, NULL, 'Percent400 Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/Percent400Ind'),
  (131178, NULL, NULL, 'Percent300 Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/Percent300Ind'),
  (131179, NULL, NULL, 'Percent100 Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/Percent100Ind'),
  (131180, NULL, NULL, 'Percent200 D Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/Percent200DInd'),
  (131181, NULL, NULL, 'Percent150 Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/Percent150Ind'),
  (131182, NULL, NULL, 'Percent250 Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/Percent250Ind'),
  (131183, NULL, NULL, 'Percent350 Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/Percent350Ind'),
  (131184, NULL, NULL, 'Most Hospitals Policy Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/MostHospitalsPolicyInd'),
  (131185, NULL, NULL, 'Indiv Hospital Tailored Policy Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/IndivHospitalTailoredPolicyInd');

-- 990 / CY Minus3 Yr Endwmt Fund Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13096, 14, '047', 'CY Minus3 Yr Endwmt Fund Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131186, 13096, '1', 'Contributions Amt', 'CURRENCY'),
  (131187, 13096, '2', 'Other Expenditures Amt', 'CURRENCY'),
  (131188, 13096, '3', 'Administrative Expenses Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131186, NULL, NULL, 'Contributions Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/CYMinus3YrEndwmtFundGrp/ContributionsAmt'),
  (131187, NULL, NULL, 'Other Expenditures Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/CYMinus3YrEndwmtFundGrp/OtherExpendituresAmt'),
  (131188, NULL, NULL, 'Administrative Expenses Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/CYMinus3YrEndwmtFundGrp/AdministrativeExpensesAmt');

-- 990 / Grants To Org Outside US Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13097, 14, '048', 'Grants To Org Outside US Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131189, 13097, '1', 'Purpose Of Grant Txt', 'TEXT'),
  (131190, 13097, '2', 'Cash Grant Amt', 'CURRENCY'),
  (131191, 13097, '3', 'Region Txt', 'TEXT'),
  (131192, 13097, '4', 'Manner Of Cash Disbursement Txt', 'TEXT'),
  (131193, 13097, '5', 'Non Cash Assistance Amt', 'CURRENCY'),
  (131194, 13097, '6', 'Valuation Method Used Desc', 'TEXT'),
  (131195, 13097, '7', 'Description Of Non Cash Asst Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131189, NULL, NULL, 'Purpose Of Grant Txt', 'TEXT', 'ReturnData/IRS990ScheduleF/GrantsToOrgOutsideUSGrp/PurposeOfGrantTxt'),
  (131190, NULL, NULL, 'Cash Grant Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleF/GrantsToOrgOutsideUSGrp/CashGrantAmt'),
  (131191, NULL, NULL, 'Region Txt', 'TEXT', 'ReturnData/IRS990ScheduleF/GrantsToOrgOutsideUSGrp/RegionTxt'),
  (131192, NULL, NULL, 'Manner Of Cash Disbursement Txt', 'TEXT', 'ReturnData/IRS990ScheduleF/GrantsToOrgOutsideUSGrp/MannerOfCashDisbursementTxt'),
  (131193, NULL, NULL, 'Non Cash Assistance Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleF/GrantsToOrgOutsideUSGrp/NonCashAssistanceAmt'),
  (131194, NULL, NULL, 'Valuation Method Used Desc', 'TEXT', 'ReturnData/IRS990ScheduleF/GrantsToOrgOutsideUSGrp/ValuationMethodUsedDesc'),
  (131195, NULL, NULL, 'Description Of Non Cash Asst Txt', 'TEXT', 'ReturnData/IRS990ScheduleF/GrantsToOrgOutsideUSGrp/DescriptionOfNonCashAsstTxt');

-- 990 / Securities Publicly Traded Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13098, 14, '049', 'Securities Publicly Traded Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131196, 13098, '1', 'Noncash Contributions Rpt F990 Amt', 'CURRENCY'),
  (131197, 13098, '2', 'Contribution Cnt', 'INTEGER'),
  (131198, 13098, '3', 'Non Cash Checkbox Ind', 'BOOLEAN'),
  (131199, 13098, '4', 'Method Of Determining Revenues Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131196, NULL, NULL, 'Noncash Contributions Rpt F990 Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleM/SecuritiesPubliclyTradedGrp/NoncashContributionsRptF990Amt'),
  (131197, NULL, NULL, 'Contribution Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleM/SecuritiesPubliclyTradedGrp/ContributionCnt'),
  (131198, NULL, NULL, 'Non Cash Checkbox Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleM/SecuritiesPubliclyTradedGrp/NonCashCheckboxInd'),
  (131199, NULL, NULL, 'Method Of Determining Revenues Txt', 'TEXT', 'ReturnData/IRS990ScheduleM/SecuritiesPubliclyTradedGrp/MethodOfDeterminingRevenuesTxt');

-- 990 / Persons With Books US Address
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13099, 14, '050', 'Persons With Books US Address');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131200, 13099, '1', 'Address Line1 Txt', 'TEXT'),
  (131201, 13099, '2', 'City Nm', 'TEXT'),
  (131202, 13099, '3', 'State Abbreviation Cd', 'TEXT'),
  (131203, 13099, '4', 'ZIP Cd', 'TEXT'),
  (131204, 13099, '5', 'Address Line2 Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131200, NULL, NULL, 'Address Line1 Txt', 'TEXT', 'ReturnData/IRS990ScheduleG/PersonsWithBooksUSAddress/AddressLine1Txt'),
  (131201, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990ScheduleG/PersonsWithBooksUSAddress/CityNm'),
  (131202, NULL, NULL, 'State Abbreviation Cd', 'TEXT', 'ReturnData/IRS990ScheduleG/PersonsWithBooksUSAddress/StateAbbreviationCd'),
  (131203, NULL, NULL, 'ZIP Cd', 'TEXT', 'ReturnData/IRS990ScheduleG/PersonsWithBooksUSAddress/ZIPCd'),
  (131204, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/IRS990ScheduleG/PersonsWithBooksUSAddress/AddressLine2Txt');

-- 990 / CY Endwmt Fund Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13100, 14, '051', 'CY Endwmt Fund Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131205, 13100, '1', 'Contributions Amt', 'CURRENCY'),
  (131206, 13100, '2', 'Administrative Expenses Amt', 'CURRENCY'),
  (131207, 13100, '3', 'Grants Or Scholarships Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131205, NULL, NULL, 'Contributions Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/CYEndwmtFundGrp/ContributionsAmt'),
  (131206, NULL, NULL, 'Administrative Expenses Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/CYEndwmtFundGrp/AdministrativeExpensesAmt'),
  (131207, NULL, NULL, 'Grants Or Scholarships Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/CYEndwmtFundGrp/GrantsOrScholarshipsAmt');

-- 990 / Id Related Org Txbl Corp Tr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13101, 14, '052', 'Id Related Org Txbl Corp Tr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131208, 13101, '1', 'Business Name Line1 Txt', 'TEXT'),
  (131209, 13101, '2', 'Share Of EOY Assets Amt', 'CURRENCY'),
  (131210, 13101, '3', 'Share Of Total Income Amt', 'CURRENCY'),
  (131211, 13101, '4', 'Legal Domicile Foreign Country Cd', 'TEXT'),
  (131212, 13101, '5', 'Address Line1 Txt', 'TEXT'),
  (131213, 13101, '6', 'Country Cd', 'TEXT'),
  (131214, 13101, '7', 'City Nm', 'TEXT'),
  (131215, 13101, '8', 'Foreign Postal Cd', 'TEXT'),
  (131216, 13101, '9', 'Province Or State Nm', 'TEXT'),
  (131217, 13101, '10', 'Address Line2 Txt', 'TEXT'),
  (131218, 13101, '11', 'Address Line2 Txt', 'TEXT'),
  (131219, 13101, '12', 'Business Name Line2 Txt', 'TEXT'),
  (131220, 13101, '13', 'Business Name Line2 Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131208, NULL, NULL, 'Business Name Line1 Txt', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedOrgTxblCorpTrGrp/DirectControllingEntityName/BusinessNameLine1Txt'),
  (131209, NULL, NULL, 'Share Of EOY Assets Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleR/IdRelatedOrgTxblCorpTrGrp/ShareOfEOYAssetsAmt'),
  (131210, NULL, NULL, 'Share Of Total Income Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleR/IdRelatedOrgTxblCorpTrGrp/ShareOfTotalIncomeAmt'),
  (131211, NULL, NULL, 'Legal Domicile Foreign Country Cd', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedOrgTxblCorpTrGrp/LegalDomicileForeignCountryCd'),
  (131212, NULL, NULL, 'Address Line1 Txt', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedOrgTxblCorpTrGrp/ForeignAddress/AddressLine1Txt'),
  (131213, NULL, NULL, 'Country Cd', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedOrgTxblCorpTrGrp/ForeignAddress/CountryCd'),
  (131214, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedOrgTxblCorpTrGrp/ForeignAddress/CityNm'),
  (131215, NULL, NULL, 'Foreign Postal Cd', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedOrgTxblCorpTrGrp/ForeignAddress/ForeignPostalCd'),
  (131216, NULL, NULL, 'Province Or State Nm', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedOrgTxblCorpTrGrp/ForeignAddress/ProvinceOrStateNm'),
  (131217, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedOrgTxblCorpTrGrp/USAddress/AddressLine2Txt'),
  (131218, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedOrgTxblCorpTrGrp/ForeignAddress/AddressLine2Txt'),
  (131219, NULL, NULL, 'Business Name Line2 Txt', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedOrgTxblCorpTrGrp/RelatedOrganizationName/BusinessNameLine2Txt'),
  (131220, NULL, NULL, 'Business Name Line2 Txt', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedOrgTxblCorpTrGrp/DirectControllingEntityName/BusinessNameLine2Txt');

-- 990 / IRS990 Schedule A Direct Fields
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13102, 14, '053', 'IRS990 Schedule A Direct Fields');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131221, 13102, '1', 'Church Ind', 'BOOLEAN'),
  (131222, 13102, '2', 'Hospital Ind', 'BOOLEAN'),
  (131223, 13102, '3', 'Majority Dir Trst Supported Org Ind', 'BOOLEAN'),
  (131224, 13102, '4', 'Supporting Org Type2 Ind', 'BOOLEAN'),
  (131225, 13102, '5', 'Thirty Thr Pct Suprt Tests PY170 Ind', 'BOOLEAN'),
  (131226, 13102, '6', 'Thirty Thr Pct Suprt Tests PY509 Ind', 'BOOLEAN'),
  (131227, 13102, '7', 'Supporting Org Type3 Func Int Ind', 'BOOLEAN'),
  (131228, 13102, '8', 'Community Trust Ind', 'BOOLEAN'),
  (131229, 13102, '9', 'Private Foundation170 Ind', 'BOOLEAN'),
  (131230, 13102, '10', 'College Organization Ind', 'BOOLEAN'),
  (131231, 13102, '11', 'Private Foundation509 Ind', 'BOOLEAN'),
  (131232, 13102, '12', 'Governmental Unit Ind', 'BOOLEAN'),
  (131233, 13102, '13', 'Test Public Safety Ind', 'BOOLEAN'),
  (131234, 13102, '14', 'Trust Integral Part Test Ind', 'BOOLEAN'),
  (131235, 13102, '15', 'Medical Research Organization Ind', 'BOOLEAN'),
  (131236, 13102, '16', 'Ten Pct Facts Crcmstncs Test PY Ind', 'BOOLEAN'),
  (131237, 13102, '17', 'Agricultural Research Org Ind', 'BOOLEAN');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131221, NULL, NULL, 'Church Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/ChurchInd'),
  (131222, NULL, NULL, 'Hospital Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/HospitalInd'),
  (131223, NULL, NULL, 'Majority Dir Trst Supported Org Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/MajorityDirTrstSupportedOrgInd'),
  (131224, NULL, NULL, 'Supporting Org Type2 Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/SupportingOrgType2Ind'),
  (131225, NULL, NULL, 'Thirty Thr Pct Suprt Tests PY170 Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/ThirtyThrPctSuprtTestsPY170Ind'),
  (131226, NULL, NULL, 'Thirty Thr Pct Suprt Tests PY509 Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/ThirtyThrPctSuprtTestsPY509Ind'),
  (131227, NULL, NULL, 'Supporting Org Type3 Func Int Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/SupportingOrgType3FuncIntInd'),
  (131228, NULL, NULL, 'Community Trust Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/CommunityTrustInd'),
  (131229, NULL, NULL, 'Private Foundation170 Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/PrivateFoundation170Ind'),
  (131230, NULL, NULL, 'College Organization Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/CollegeOrganizationInd'),
  (131231, NULL, NULL, 'Private Foundation509 Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/PrivateFoundation509Ind'),
  (131232, NULL, NULL, 'Governmental Unit Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/GovernmentalUnitInd'),
  (131233, NULL, NULL, 'Test Public Safety Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/TestPublicSafetyInd'),
  (131234, NULL, NULL, 'Trust Integral Part Test Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/TrustIntegralPartTestInd'),
  (131235, NULL, NULL, 'Medical Research Organization Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/MedicalResearchOrganizationInd'),
  (131236, NULL, NULL, 'Ten Pct Facts Crcmstncs Test PY Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/TenPctFactsCrcmstncsTestPYInd'),
  (131237, NULL, NULL, 'Agricultural Research Org Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/AgriculturalResearchOrgInd');

-- 990 / IRS990 Schedule C Direct Fields
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13103, 14, '054', 'IRS990 Schedule C Direct Fields');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131238, 13103, '1', 'Lobbying Ceiling Amt', 'CURRENCY'),
  (131239, 13103, '2', 'Grassroots Ceiling Amt', 'CURRENCY'),
  (131240, 13103, '3', 'Form1120 POL Filed Ind', 'BOOLEAN'),
  (131241, 13103, '4', 'Political Expenditures Amt', 'CURRENCY'),
  (131242, 13103, '5', 'Total Exempt Function Expend Amt', 'CURRENCY'),
  (131243, 13103, '6', 'Carried Over Amt', 'CURRENCY'),
  (131244, 13103, '7', 'Internal Funds Contributed Amt', 'CURRENCY'),
  (131245, 13103, '8', 'Form4720 Filed Section4955 Tax Ind', 'BOOLEAN'),
  (131246, 13103, '9', 'Correction Made Ind', 'BOOLEAN'),
  (131247, 13103, '10', 'Expended527 Activities Amt', 'CURRENCY'),
  (131248, 13103, '11', 'Volunteer Hours Cnt', 'INTEGER'),
  (131249, 13103, '12', 'Form4720 Filed Ind', 'BOOLEAN'),
  (131250, 13103, '13', 'Form4720 Filed4912 Tax Ind', 'BOOLEAN'),
  (131251, 13103, '14', 'Mailings Members Amt', 'CURRENCY'),
  (131252, 13103, '15', 'Organization Belongs Afflt Grp Ind', 'BOOLEAN'),
  (131253, 13103, '16', 'Rallies Demonstrations Amt', 'CURRENCY'),
  (131254, 13103, '17', 'Section4955 Organization Tax Amt', 'CURRENCY'),
  (131255, 13103, '18', 'Section4955 Managers Tax Amt', 'CURRENCY'),
  (131256, 13103, '19', 'Publications Or Broadcast Amt', 'CURRENCY'),
  (131257, 13103, '20', 'Media Advertisements Amt', 'CURRENCY'),
  (131258, 13103, '21', 'Limited Control Provisions App Ind', 'BOOLEAN'),
  (131259, 13103, '22', 'Managers4912 Tax Amt', 'CURRENCY'),
  (131260, 13103, '23', 'Tax4912 Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131238, NULL, NULL, 'Lobbying Ceiling Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/LobbyingCeilingAmt'),
  (131239, NULL, NULL, 'Grassroots Ceiling Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/GrassrootsCeilingAmt'),
  (131240, NULL, NULL, 'Form1120 POL Filed Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleC/Form1120POLFiledInd'),
  (131241, NULL, NULL, 'Political Expenditures Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/PoliticalExpendituresAmt'),
  (131242, NULL, NULL, 'Total Exempt Function Expend Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/TotalExemptFunctionExpendAmt'),
  (131243, NULL, NULL, 'Carried Over Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/CarriedOverAmt'),
  (131244, NULL, NULL, 'Internal Funds Contributed Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/InternalFundsContributedAmt'),
  (131245, NULL, NULL, 'Form4720 Filed Section4955 Tax Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleC/Form4720FiledSection4955TaxInd'),
  (131246, NULL, NULL, 'Correction Made Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleC/CorrectionMadeInd'),
  (131247, NULL, NULL, 'Expended527 Activities Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/Expended527ActivitiesAmt'),
  (131248, NULL, NULL, 'Volunteer Hours Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleC/VolunteerHoursCnt'),
  (131249, NULL, NULL, 'Form4720 Filed Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleC/Form4720FiledInd'),
  (131250, NULL, NULL, 'Form4720 Filed4912 Tax Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleC/Form4720Filed4912TaxInd'),
  (131251, NULL, NULL, 'Mailings Members Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/MailingsMembersAmt'),
  (131252, NULL, NULL, 'Organization Belongs Afflt Grp Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleC/OrganizationBelongsAffltGrpInd'),
  (131253, NULL, NULL, 'Rallies Demonstrations Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/RalliesDemonstrationsAmt'),
  (131254, NULL, NULL, 'Section4955 Organization Tax Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/Section4955OrganizationTaxAmt'),
  (131255, NULL, NULL, 'Section4955 Managers Tax Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/Section4955ManagersTaxAmt'),
  (131256, NULL, NULL, 'Publications Or Broadcast Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/PublicationsOrBroadcastAmt'),
  (131257, NULL, NULL, 'Media Advertisements Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/MediaAdvertisementsAmt'),
  (131258, NULL, NULL, 'Limited Control Provisions App Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleC/LimitedControlProvisionsAppInd'),
  (131259, NULL, NULL, 'Managers4912 Tax Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/Managers4912TaxAmt'),
  (131260, NULL, NULL, 'Tax4912 Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/Tax4912Amt');

-- 990 / CY Minus4 Yr Endwmt Fund Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13104, 14, '055', 'CY Minus4 Yr Endwmt Fund Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131261, 13104, '1', 'Contributions Amt', 'CURRENCY'),
  (131262, 13104, '2', 'Administrative Expenses Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131261, NULL, NULL, 'Contributions Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/CYMinus4YrEndwmtFundGrp/ContributionsAmt'),
  (131262, NULL, NULL, 'Administrative Expenses Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/CYMinus4YrEndwmtFundGrp/AdministrativeExpensesAmt');

-- 990 / Hospital Facilities Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13105, 14, '056', 'Hospital Facilities Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131263, 13105, '1', 'Facility Num', 'INTEGER'),
  (131264, 13105, '2', 'Business Name Line1 Txt', 'TEXT'),
  (131265, 13105, '3', 'Address Line1 Txt', 'TEXT'),
  (131266, 13105, '4', 'City Nm', 'TEXT'),
  (131267, 13105, '5', 'State Abbreviation Cd', 'TEXT'),
  (131268, 13105, '6', 'ZIP Cd', 'TEXT'),
  (131269, 13105, '7', 'Licensed Hospital Ind', 'BOOLEAN'),
  (131270, 13105, '8', 'Website Address Txt', 'TEXT'),
  (131271, 13105, '9', 'Emergency Room24 Hrs Ind', 'BOOLEAN'),
  (131272, 13105, '10', 'State License Num', 'INTEGER'),
  (131273, 13105, '11', 'General Medical And Surgical Ind', 'BOOLEAN'),
  (131274, 13105, '12', 'Critical Access Hospital Ind', 'BOOLEAN'),
  (131275, 13105, '13', 'Teaching Hospital Ind', 'BOOLEAN'),
  (131276, 13105, '14', 'Other Desc', 'TEXT'),
  (131277, 13105, '15', 'Facility Reporting Group Cd', 'TEXT'),
  (131278, 13105, '16', 'Research Facility Ind', 'BOOLEAN'),
  (131279, 13105, '17', 'Childrens Hospital Ind', 'BOOLEAN'),
  (131280, 13105, '18', 'Emergency Room Other Ind', 'BOOLEAN'),
  (131281, 13105, '19', 'Subordinate Hospital EIN', 'TEXT'),
  (131282, 13105, '20', 'Business Name Line2 Txt', 'TEXT'),
  (131283, 13105, '21', 'Business Name Line1 Txt', 'TEXT'),
  (131284, 13105, '22', 'Address Line2 Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131263, NULL, NULL, 'Facility Num', 'INTEGER', 'ReturnData/IRS990ScheduleH/HospitalFacilitiesGrp/FacilityNum'),
  (131264, NULL, NULL, 'Business Name Line1 Txt', 'TEXT', 'ReturnData/IRS990ScheduleH/HospitalFacilitiesGrp/BusinessName/BusinessNameLine1Txt'),
  (131265, NULL, NULL, 'Address Line1 Txt', 'TEXT', 'ReturnData/IRS990ScheduleH/HospitalFacilitiesGrp/USAddress/AddressLine1Txt'),
  (131266, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990ScheduleH/HospitalFacilitiesGrp/USAddress/CityNm'),
  (131267, NULL, NULL, 'State Abbreviation Cd', 'TEXT', 'ReturnData/IRS990ScheduleH/HospitalFacilitiesGrp/USAddress/StateAbbreviationCd'),
  (131268, NULL, NULL, 'ZIP Cd', 'TEXT', 'ReturnData/IRS990ScheduleH/HospitalFacilitiesGrp/USAddress/ZIPCd'),
  (131269, NULL, NULL, 'Licensed Hospital Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFacilitiesGrp/LicensedHospitalInd'),
  (131270, NULL, NULL, 'Website Address Txt', 'TEXT', 'ReturnData/IRS990ScheduleH/HospitalFacilitiesGrp/WebsiteAddressTxt'),
  (131271, NULL, NULL, 'Emergency Room24 Hrs Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFacilitiesGrp/EmergencyRoom24HrsInd'),
  (131272, NULL, NULL, 'State License Num', 'INTEGER', 'ReturnData/IRS990ScheduleH/HospitalFacilitiesGrp/StateLicenseNum'),
  (131273, NULL, NULL, 'General Medical And Surgical Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFacilitiesGrp/GeneralMedicalAndSurgicalInd'),
  (131274, NULL, NULL, 'Critical Access Hospital Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFacilitiesGrp/CriticalAccessHospitalInd'),
  (131275, NULL, NULL, 'Teaching Hospital Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFacilitiesGrp/TeachingHospitalInd'),
  (131276, NULL, NULL, 'Other Desc', 'TEXT', 'ReturnData/IRS990ScheduleH/HospitalFacilitiesGrp/OtherDesc'),
  (131277, NULL, NULL, 'Facility Reporting Group Cd', 'TEXT', 'ReturnData/IRS990ScheduleH/HospitalFacilitiesGrp/FacilityReportingGroupCd'),
  (131278, NULL, NULL, 'Research Facility Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFacilitiesGrp/ResearchFacilityInd'),
  (131279, NULL, NULL, 'Childrens Hospital Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFacilitiesGrp/ChildrensHospitalInd'),
  (131280, NULL, NULL, 'Emergency Room Other Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/HospitalFacilitiesGrp/EmergencyRoomOtherInd'),
  (131281, NULL, NULL, 'Subordinate Hospital EIN', 'TEXT', 'ReturnData/IRS990ScheduleH/HospitalFacilitiesGrp/SubordinateHospitalEIN'),
  (131282, NULL, NULL, 'Business Name Line2 Txt', 'TEXT', 'ReturnData/IRS990ScheduleH/HospitalFacilitiesGrp/BusinessName/BusinessNameLine2Txt'),
  (131283, NULL, NULL, 'Business Name Line1 Txt', 'TEXT', 'ReturnData/IRS990ScheduleH/HospitalFacilitiesGrp/SubordinateHospitalName/BusinessNameLine1Txt'),
  (131284, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/IRS990ScheduleH/HospitalFacilitiesGrp/USAddress/AddressLine2Txt');

-- 990 / Avg Lobbying Nontaxable Amount Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13106, 14, '057', 'Avg Lobbying Nontaxable Amount Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131285, 13106, '1', 'Total Amt', 'CURRENCY'),
  (131286, 13106, '2', 'Current Year Amt', 'CURRENCY'),
  (131287, 13106, '3', 'Current Year Minus1 Amt', 'CURRENCY'),
  (131288, 13106, '4', 'Current Year Minus2 Amt', 'CURRENCY'),
  (131289, 13106, '5', 'Current Year Minus3 Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131285, NULL, NULL, 'Total Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/AvgLobbyingNontaxableAmountGrp/TotalAmt'),
  (131286, NULL, NULL, 'Current Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/AvgLobbyingNontaxableAmountGrp/CurrentYearAmt'),
  (131287, NULL, NULL, 'Current Year Minus1 Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/AvgLobbyingNontaxableAmountGrp/CurrentYearMinus1Amt'),
  (131288, NULL, NULL, 'Current Year Minus2 Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/AvgLobbyingNontaxableAmountGrp/CurrentYearMinus2Amt'),
  (131289, NULL, NULL, 'Current Year Minus3 Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/AvgLobbyingNontaxableAmountGrp/CurrentYearMinus3Amt');

-- 990 / Avg Grassroots Nontaxable Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13107, 14, '058', 'Avg Grassroots Nontaxable Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131290, 13107, '1', 'Total Amt', 'CURRENCY'),
  (131291, 13107, '2', 'Current Year Amt', 'CURRENCY'),
  (131292, 13107, '3', 'Current Year Minus1 Amt', 'CURRENCY'),
  (131293, 13107, '4', 'Current Year Minus2 Amt', 'CURRENCY'),
  (131294, 13107, '5', 'Current Year Minus3 Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131290, NULL, NULL, 'Total Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/AvgGrassrootsNontaxableGrp/TotalAmt'),
  (131291, NULL, NULL, 'Current Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/AvgGrassrootsNontaxableGrp/CurrentYearAmt'),
  (131292, NULL, NULL, 'Current Year Minus1 Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/AvgGrassrootsNontaxableGrp/CurrentYearMinus1Amt'),
  (131293, NULL, NULL, 'Current Year Minus2 Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/AvgGrassrootsNontaxableGrp/CurrentYearMinus2Amt'),
  (131294, NULL, NULL, 'Current Year Minus3 Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/AvgGrassrootsNontaxableGrp/CurrentYearMinus3Amt');

-- 990 / Supplemental Information Detail
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13108, 14, '059', 'Supplemental Information Detail');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131295, 13108, '1', 'Form And Line Reference Desc', 'TEXT'),
  (131296, 13108, '2', 'Explanation Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131295, NULL, NULL, 'Form And Line Reference Desc', 'TEXT', 'ReturnData/IRS990ScheduleF/SupplementalInformationDetail/FormAndLineReferenceDesc'),
  (131296, NULL, NULL, 'Explanation Txt', 'TEXT', 'ReturnData/IRS990ScheduleF/SupplementalInformationDetail/ExplanationTxt');

-- 990 / Fundraising Event Information Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13109, 14, '060', 'Fundraising Event Information Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131297, 13109, '1', 'Other Events Total Cnt', 'INTEGER');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131297, NULL, NULL, 'Other Events Total Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleG/FundraisingEventInformationGrp/OtherEventsTotalCnt');

-- 990 / Avg Total Lobbying Expend Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13110, 14, '061', 'Avg Total Lobbying Expend Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131298, 13110, '1', 'Total Amt', 'CURRENCY'),
  (131299, 13110, '2', 'Current Year Amt', 'CURRENCY'),
  (131300, 13110, '3', 'Current Year Minus1 Amt', 'CURRENCY'),
  (131301, 13110, '4', 'Current Year Minus2 Amt', 'CURRENCY'),
  (131302, 13110, '5', 'Current Year Minus3 Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131298, NULL, NULL, 'Total Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/AvgTotalLobbyingExpendGrp/TotalAmt'),
  (131299, NULL, NULL, 'Current Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/AvgTotalLobbyingExpendGrp/CurrentYearAmt'),
  (131300, NULL, NULL, 'Current Year Minus1 Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/AvgTotalLobbyingExpendGrp/CurrentYearMinus1Amt'),
  (131301, NULL, NULL, 'Current Year Minus2 Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/AvgTotalLobbyingExpendGrp/CurrentYearMinus2Amt'),
  (131302, NULL, NULL, 'Current Year Minus3 Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/AvgTotalLobbyingExpendGrp/CurrentYearMinus3Amt');

-- 990 / IRS990 Schedule N Direct Fields
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13111, 14, '062', 'IRS990 Schedule N Direct Fields');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131303, 13111, '1', 'Receive Compensation Ind', 'BOOLEAN'),
  (131304, 13111, '2', 'Director Of Successor Ind', 'BOOLEAN'),
  (131305, 13111, '3', 'Employee Of Successor Ind', 'BOOLEAN'),
  (131306, 13111, '4', 'Owner Of Successor Ind', 'BOOLEAN'),
  (131307, 13111, '5', 'Assets Distributed Ind', 'BOOLEAN'),
  (131308, 13111, '6', 'Bonds Outstanding Ind', 'BOOLEAN'),
  (131309, 13111, '7', 'Required To Notify AG Ind', 'BOOLEAN'),
  (131310, 13111, '8', 'Liabilities Paid Ind', 'BOOLEAN'),
  (131311, 13111, '9', 'Attorney General Notified Ind', 'BOOLEAN'),
  (131312, 13111, '10', 'Bond Liabilities Discharged Ind', 'BOOLEAN');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131303, NULL, NULL, 'Receive Compensation Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleN/ReceiveCompensationInd'),
  (131304, NULL, NULL, 'Director Of Successor Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleN/DirectorOfSuccessorInd'),
  (131305, NULL, NULL, 'Employee Of Successor Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleN/EmployeeOfSuccessorInd'),
  (131306, NULL, NULL, 'Owner Of Successor Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleN/OwnerOfSuccessorInd'),
  (131307, NULL, NULL, 'Assets Distributed Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleN/AssetsDistributedInd'),
  (131308, NULL, NULL, 'Bonds Outstanding Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleN/BondsOutstandingInd'),
  (131309, NULL, NULL, 'Required To Notify AG Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleN/RequiredToNotifyAGInd'),
  (131310, NULL, NULL, 'Liabilities Paid Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleN/LiabilitiesPaidInd'),
  (131311, NULL, NULL, 'Attorney General Notified Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleN/AttorneyGeneralNotifiedInd'),
  (131312, NULL, NULL, 'Bond Liabilities Discharged Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleN/BondLiabilitiesDischargedInd');

-- 990 / Liquidation Of Assets Table Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13112, 14, '063', 'Liquidation Of Assets Table Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131313, 13112, '1', 'Assets Distri Or Expnss Paid Desc', 'TEXT'),
  (131314, 13112, '2', 'Distribution Dt', 'TEXT'),
  (131315, 13112, '3', 'Fair Market Value Of Asset Amt', 'CURRENCY'),
  (131316, 13112, '4', 'Address Line1 Txt', 'TEXT'),
  (131317, 13112, '5', 'City Nm', 'TEXT'),
  (131318, 13112, '6', 'State Abbreviation Cd', 'TEXT'),
  (131319, 13112, '7', 'ZIP Cd', 'TEXT'),
  (131320, 13112, '8', 'IRC Section Txt', 'TEXT'),
  (131321, 13112, '9', 'Method Of FMV Determination Txt', 'TEXT'),
  (131322, 13112, '10', 'EIN', 'TEXT'),
  (131323, 13112, '11', 'Business Name Line1 Txt', 'TEXT'),
  (131324, 13112, '12', 'Person Nm', 'TEXT'),
  (131325, 13112, '13', 'Address Line2 Txt', 'TEXT'),
  (131326, 13112, '14', 'Business Name Line2 Txt', 'TEXT'),
  (131327, 13112, '15', 'Address Line1 Txt', 'TEXT'),
  (131328, 13112, '16', 'Country Cd', 'TEXT'),
  (131329, 13112, '17', 'City Nm', 'TEXT'),
  (131330, 13112, '18', 'Province Or State Nm', 'TEXT'),
  (131331, 13112, '19', 'Foreign Postal Cd', 'TEXT'),
  (131332, 13112, '20', 'Address Line2 Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131313, NULL, NULL, 'Assets Distri Or Expnss Paid Desc', 'TEXT', 'ReturnData/IRS990ScheduleN/LiquidationOfAssetsTableGrp/LiquidationOfAssetsDetail/AssetsDistriOrExpnssPaidDesc'),
  (131314, NULL, NULL, 'Distribution Dt', 'TEXT', 'ReturnData/IRS990ScheduleN/LiquidationOfAssetsTableGrp/LiquidationOfAssetsDetail/DistributionDt'),
  (131315, NULL, NULL, 'Fair Market Value Of Asset Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleN/LiquidationOfAssetsTableGrp/LiquidationOfAssetsDetail/FairMarketValueOfAssetAmt'),
  (131316, NULL, NULL, 'Address Line1 Txt', 'TEXT', 'ReturnData/IRS990ScheduleN/LiquidationOfAssetsTableGrp/LiquidationOfAssetsDetail/USAddress/AddressLine1Txt'),
  (131317, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990ScheduleN/LiquidationOfAssetsTableGrp/LiquidationOfAssetsDetail/USAddress/CityNm'),
  (131318, NULL, NULL, 'State Abbreviation Cd', 'TEXT', 'ReturnData/IRS990ScheduleN/LiquidationOfAssetsTableGrp/LiquidationOfAssetsDetail/USAddress/StateAbbreviationCd'),
  (131319, NULL, NULL, 'ZIP Cd', 'TEXT', 'ReturnData/IRS990ScheduleN/LiquidationOfAssetsTableGrp/LiquidationOfAssetsDetail/USAddress/ZIPCd'),
  (131320, NULL, NULL, 'IRC Section Txt', 'TEXT', 'ReturnData/IRS990ScheduleN/LiquidationOfAssetsTableGrp/LiquidationOfAssetsDetail/IRCSectionTxt'),
  (131321, NULL, NULL, 'Method Of FMV Determination Txt', 'TEXT', 'ReturnData/IRS990ScheduleN/LiquidationOfAssetsTableGrp/LiquidationOfAssetsDetail/MethodOfFMVDeterminationTxt'),
  (131322, NULL, NULL, 'EIN', 'TEXT', 'ReturnData/IRS990ScheduleN/LiquidationOfAssetsTableGrp/LiquidationOfAssetsDetail/EIN'),
  (131323, NULL, NULL, 'Business Name Line1 Txt', 'TEXT', 'ReturnData/IRS990ScheduleN/LiquidationOfAssetsTableGrp/LiquidationOfAssetsDetail/BusinessName/BusinessNameLine1Txt'),
  (131324, NULL, NULL, 'Person Nm', 'TEXT', 'ReturnData/IRS990ScheduleN/LiquidationOfAssetsTableGrp/LiquidationOfAssetsDetail/PersonNm'),
  (131325, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/IRS990ScheduleN/LiquidationOfAssetsTableGrp/LiquidationOfAssetsDetail/USAddress/AddressLine2Txt'),
  (131326, NULL, NULL, 'Business Name Line2 Txt', 'TEXT', 'ReturnData/IRS990ScheduleN/LiquidationOfAssetsTableGrp/LiquidationOfAssetsDetail/BusinessName/BusinessNameLine2Txt'),
  (131327, NULL, NULL, 'Address Line1 Txt', 'TEXT', 'ReturnData/IRS990ScheduleN/LiquidationOfAssetsTableGrp/LiquidationOfAssetsDetail/ForeignAddress/AddressLine1Txt'),
  (131328, NULL, NULL, 'Country Cd', 'TEXT', 'ReturnData/IRS990ScheduleN/LiquidationOfAssetsTableGrp/LiquidationOfAssetsDetail/ForeignAddress/CountryCd'),
  (131329, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990ScheduleN/LiquidationOfAssetsTableGrp/LiquidationOfAssetsDetail/ForeignAddress/CityNm'),
  (131330, NULL, NULL, 'Province Or State Nm', 'TEXT', 'ReturnData/IRS990ScheduleN/LiquidationOfAssetsTableGrp/LiquidationOfAssetsDetail/ForeignAddress/ProvinceOrStateNm'),
  (131331, NULL, NULL, 'Foreign Postal Cd', 'TEXT', 'ReturnData/IRS990ScheduleN/LiquidationOfAssetsTableGrp/LiquidationOfAssetsDetail/ForeignAddress/ForeignPostalCd'),
  (131332, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/IRS990ScheduleN/LiquidationOfAssetsTableGrp/LiquidationOfAssetsDetail/ForeignAddress/AddressLine2Txt');

-- 990 / Foreign Individuals Grants Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13113, 14, '064', 'Foreign Individuals Grants Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131333, 13113, '1', 'Region Txt', 'TEXT'),
  (131334, 13113, '2', 'Type Of Assistance Txt', 'TEXT'),
  (131335, 13113, '3', 'Recipient Cnt', 'INTEGER'),
  (131336, 13113, '4', 'Cash Grant Amt', 'CURRENCY'),
  (131337, 13113, '5', 'Manner Of Cash Disbursement Txt', 'TEXT'),
  (131338, 13113, '6', 'Valuation Method Used Desc', 'TEXT'),
  (131339, 13113, '7', 'Non Cash Assistance Amt', 'CURRENCY'),
  (131340, 13113, '8', 'Description Of Non Cash Asst Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131333, NULL, NULL, 'Region Txt', 'TEXT', 'ReturnData/IRS990ScheduleF/ForeignIndividualsGrantsGrp/RegionTxt'),
  (131334, NULL, NULL, 'Type Of Assistance Txt', 'TEXT', 'ReturnData/IRS990ScheduleF/ForeignIndividualsGrantsGrp/TypeOfAssistanceTxt'),
  (131335, NULL, NULL, 'Recipient Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleF/ForeignIndividualsGrantsGrp/RecipientCnt'),
  (131336, NULL, NULL, 'Cash Grant Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleF/ForeignIndividualsGrantsGrp/CashGrantAmt'),
  (131337, NULL, NULL, 'Manner Of Cash Disbursement Txt', 'TEXT', 'ReturnData/IRS990ScheduleF/ForeignIndividualsGrantsGrp/MannerOfCashDisbursementTxt'),
  (131338, NULL, NULL, 'Valuation Method Used Desc', 'TEXT', 'ReturnData/IRS990ScheduleF/ForeignIndividualsGrantsGrp/ValuationMethodUsedDesc'),
  (131339, NULL, NULL, 'Non Cash Assistance Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleF/ForeignIndividualsGrantsGrp/NonCashAssistanceAmt'),
  (131340, NULL, NULL, 'Description Of Non Cash Asst Txt', 'TEXT', 'ReturnData/IRS990ScheduleF/ForeignIndividualsGrantsGrp/DescriptionOfNonCashAsstTxt');

-- 990 / Invst Program Related Org Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13114, 14, '065', 'Invst Program Related Org Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131341, 13114, '1', 'Book Value Amt', 'CURRENCY'),
  (131342, 13114, '2', 'Desc', 'TEXT'),
  (131343, 13114, '3', 'Method Valuation Cd', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131341, NULL, NULL, 'Book Value Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/InvstProgramRelatedOrgGrp/BookValueAmt'),
  (131342, NULL, NULL, 'Desc', 'TEXT', 'ReturnData/IRS990ScheduleD/InvstProgramRelatedOrgGrp/Desc'),
  (131343, NULL, NULL, 'Method Valuation Cd', 'TEXT', 'ReturnData/IRS990ScheduleD/InvstProgramRelatedOrgGrp/MethodValuationCd');

-- 990 / Section527 Political Org Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13115, 14, '066', 'Section527 Political Org Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131344, 13115, '1', 'Business Name Line1 Txt', 'TEXT'),
  (131345, 13115, '2', 'Address Line1 Txt', 'TEXT'),
  (131346, 13115, '3', 'City Nm', 'TEXT'),
  (131347, 13115, '4', 'State Abbreviation Cd', 'TEXT'),
  (131348, 13115, '5', 'ZIP Cd', 'TEXT'),
  (131349, 13115, '6', 'EIN', 'TEXT'),
  (131350, 13115, '7', 'Paid Internal Funds Amt', 'CURRENCY'),
  (131351, 13115, '8', 'Contributions Rcvd Dlvr Amt', 'CURRENCY'),
  (131352, 13115, '9', 'Business Name Line2 Txt', 'TEXT'),
  (131353, 13115, '10', 'Address Line2 Txt', 'TEXT'),
  (131354, 13115, '11', 'Address Line1 Txt', 'TEXT'),
  (131355, 13115, '12', 'City Nm', 'TEXT'),
  (131356, 13115, '13', 'Country Cd', 'TEXT'),
  (131357, 13115, '14', 'Foreign Postal Cd', 'TEXT'),
  (131358, 13115, '15', 'Province Or State Nm', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131344, NULL, NULL, 'Business Name Line1 Txt', 'TEXT', 'ReturnData/IRS990ScheduleC/Section527PoliticalOrgGrp/OrganizationBusinessName/BusinessNameLine1Txt'),
  (131345, NULL, NULL, 'Address Line1 Txt', 'TEXT', 'ReturnData/IRS990ScheduleC/Section527PoliticalOrgGrp/USAddress/AddressLine1Txt'),
  (131346, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990ScheduleC/Section527PoliticalOrgGrp/USAddress/CityNm'),
  (131347, NULL, NULL, 'State Abbreviation Cd', 'TEXT', 'ReturnData/IRS990ScheduleC/Section527PoliticalOrgGrp/USAddress/StateAbbreviationCd'),
  (131348, NULL, NULL, 'ZIP Cd', 'TEXT', 'ReturnData/IRS990ScheduleC/Section527PoliticalOrgGrp/USAddress/ZIPCd'),
  (131349, NULL, NULL, 'EIN', 'TEXT', 'ReturnData/IRS990ScheduleC/Section527PoliticalOrgGrp/EIN'),
  (131350, NULL, NULL, 'Paid Internal Funds Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/Section527PoliticalOrgGrp/PaidInternalFundsAmt'),
  (131351, NULL, NULL, 'Contributions Rcvd Dlvr Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/Section527PoliticalOrgGrp/ContributionsRcvdDlvrAmt'),
  (131352, NULL, NULL, 'Business Name Line2 Txt', 'TEXT', 'ReturnData/IRS990ScheduleC/Section527PoliticalOrgGrp/OrganizationBusinessName/BusinessNameLine2Txt'),
  (131353, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/IRS990ScheduleC/Section527PoliticalOrgGrp/USAddress/AddressLine2Txt'),
  (131354, NULL, NULL, 'Address Line1 Txt', 'TEXT', 'ReturnData/IRS990ScheduleC/Section527PoliticalOrgGrp/ForeignAddress/AddressLine1Txt'),
  (131355, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990ScheduleC/Section527PoliticalOrgGrp/ForeignAddress/CityNm'),
  (131356, NULL, NULL, 'Country Cd', 'TEXT', 'ReturnData/IRS990ScheduleC/Section527PoliticalOrgGrp/ForeignAddress/CountryCd'),
  (131357, NULL, NULL, 'Foreign Postal Cd', 'TEXT', 'ReturnData/IRS990ScheduleC/Section527PoliticalOrgGrp/ForeignAddress/ForeignPostalCd'),
  (131358, NULL, NULL, 'Province Or State Nm', 'TEXT', 'ReturnData/IRS990ScheduleC/Section527PoliticalOrgGrp/ForeignAddress/ProvinceOrStateNm');

-- 990 / Tax Exempt Bonds Proceeds Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13116, 14, '067', 'Tax Exempt Bonds Proceeds Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131359, 13116, '1', 'Issuance Costs From Proceeds Amt', 'CURRENCY'),
  (131360, 13116, '2', 'Retired Amt', 'CURRENCY'),
  (131361, 13116, '3', 'In Reserve Fund Amt', 'CURRENCY'),
  (131362, 13116, '4', 'Capitalized Interest Amt', 'CURRENCY'),
  (131363, 13116, '5', 'Unspent Amt', 'CURRENCY'),
  (131364, 13116, '6', 'Refunding Escrow Amt', 'CURRENCY'),
  (131365, 13116, '7', 'Working Capital Expenditures Amt', 'CURRENCY'),
  (131366, 13116, '8', 'Credit Enhancement Amt', 'CURRENCY'),
  (131367, 13116, '9', 'Bond Defeased Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131359, NULL, NULL, 'Issuance Costs From Proceeds Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleK/TaxExemptBondsProceedsGrp/IssuanceCostsFromProceedsAmt'),
  (131360, NULL, NULL, 'Retired Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleK/TaxExemptBondsProceedsGrp/RetiredAmt'),
  (131361, NULL, NULL, 'In Reserve Fund Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleK/TaxExemptBondsProceedsGrp/InReserveFundAmt'),
  (131362, NULL, NULL, 'Capitalized Interest Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleK/TaxExemptBondsProceedsGrp/CapitalizedInterestAmt'),
  (131363, NULL, NULL, 'Unspent Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleK/TaxExemptBondsProceedsGrp/UnspentAmt'),
  (131364, NULL, NULL, 'Refunding Escrow Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleK/TaxExemptBondsProceedsGrp/RefundingEscrowAmt'),
  (131365, NULL, NULL, 'Working Capital Expenditures Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleK/TaxExemptBondsProceedsGrp/WorkingCapitalExpendituresAmt'),
  (131366, NULL, NULL, 'Credit Enhancement Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleK/TaxExemptBondsProceedsGrp/CreditEnhancementAmt'),
  (131367, NULL, NULL, 'Bond Defeased Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleK/TaxExemptBondsProceedsGrp/BondDefeasedAmt');

-- 990 / Clothing And Household Goods Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13117, 14, '068', 'Clothing And Household Goods Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131368, 13117, '1', 'Noncash Contributions Rpt F990 Amt', 'CURRENCY'),
  (131369, 13117, '2', 'Non Cash Checkbox Ind', 'BOOLEAN'),
  (131370, 13117, '3', 'Method Of Determining Revenues Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131368, NULL, NULL, 'Noncash Contributions Rpt F990 Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleM/ClothingAndHouseholdGoodsGrp/NoncashContributionsRptF990Amt'),
  (131369, NULL, NULL, 'Non Cash Checkbox Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleM/ClothingAndHouseholdGoodsGrp/NonCashCheckboxInd'),
  (131370, NULL, NULL, 'Method Of Determining Revenues Txt', 'TEXT', 'ReturnData/IRS990ScheduleM/ClothingAndHouseholdGoodsGrp/MethodOfDeterminingRevenuesTxt');

-- 990 / Contractor Compensation Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13118, 14, '069', 'Contractor Compensation Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131371, 13118, '1', 'Person Nm', 'TEXT'),
  (131372, 13118, '2', 'Address Line2 Txt', 'TEXT'),
  (131373, 13118, '3', 'Address Line1 Txt', 'TEXT'),
  (131374, 13118, '4', 'Country Cd', 'TEXT'),
  (131375, 13118, '5', 'City Nm', 'TEXT'),
  (131376, 13118, '6', 'Foreign Postal Cd', 'TEXT'),
  (131377, 13118, '7', 'Province Or State Nm', 'TEXT'),
  (131378, 13118, '8', 'Business Name Line2 Txt', 'TEXT'),
  (131379, 13118, '9', 'Address Line2 Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131371, NULL, NULL, 'Person Nm', 'TEXT', 'ReturnData/IRS990/ContractorCompensationGrp/ContractorName/PersonNm'),
  (131372, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/IRS990/ContractorCompensationGrp/ContractorAddress/USAddress/AddressLine2Txt'),
  (131373, NULL, NULL, 'Address Line1 Txt', 'TEXT', 'ReturnData/IRS990/ContractorCompensationGrp/ContractorAddress/ForeignAddress/AddressLine1Txt'),
  (131374, NULL, NULL, 'Country Cd', 'TEXT', 'ReturnData/IRS990/ContractorCompensationGrp/ContractorAddress/ForeignAddress/CountryCd'),
  (131375, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990/ContractorCompensationGrp/ContractorAddress/ForeignAddress/CityNm'),
  (131376, NULL, NULL, 'Foreign Postal Cd', 'TEXT', 'ReturnData/IRS990/ContractorCompensationGrp/ContractorAddress/ForeignAddress/ForeignPostalCd'),
  (131377, NULL, NULL, 'Province Or State Nm', 'TEXT', 'ReturnData/IRS990/ContractorCompensationGrp/ContractorAddress/ForeignAddress/ProvinceOrStateNm'),
  (131378, NULL, NULL, 'Business Name Line2 Txt', 'TEXT', 'ReturnData/IRS990/ContractorCompensationGrp/ContractorName/BusinessName/BusinessNameLine2Txt'),
  (131379, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/IRS990/ContractorCompensationGrp/ContractorAddress/ForeignAddress/AddressLine2Txt');

-- 990 / Form990 Part VII Section A Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13119, 14, '070', 'Form990 Part VII Section A Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131380, 13119, '1', 'Former Ofcr Director Trustee Ind', 'BOOLEAN'),
  (131381, 13119, '2', 'Institutional Trustee Ind', 'BOOLEAN'),
  (131382, 13119, '3', 'Business Name Line2 Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131380, NULL, NULL, 'Former Ofcr Director Trustee Ind', 'BOOLEAN', 'ReturnData/IRS990/Form990PartVIISectionAGrp/FormerOfcrDirectorTrusteeInd'),
  (131381, NULL, NULL, 'Institutional Trustee Ind', 'BOOLEAN', 'ReturnData/IRS990/Form990PartVIISectionAGrp/InstitutionalTrusteeInd'),
  (131382, NULL, NULL, 'Business Name Line2 Txt', 'TEXT', 'ReturnData/IRS990/Form990PartVIISectionAGrp/BusinessName/BusinessNameLine2Txt');

-- 990 / Id Related Tax Exempt Org Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13120, 14, '071', 'Id Related Tax Exempt Org Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131383, 13120, '1', 'Business Name Line2 Txt', 'TEXT'),
  (131384, 13120, '2', 'Legal Domicile Foreign Country Cd', 'TEXT'),
  (131385, 13120, '3', 'Address Line2 Txt', 'TEXT'),
  (131386, 13120, '4', 'Address Line1 Txt', 'TEXT'),
  (131387, 13120, '5', 'Country Cd', 'TEXT'),
  (131388, 13120, '6', 'City Nm', 'TEXT'),
  (131389, 13120, '7', 'Business Name Line2 Txt', 'TEXT'),
  (131390, 13120, '8', 'Foreign Postal Cd', 'TEXT'),
  (131391, 13120, '9', 'Province Or State Nm', 'TEXT'),
  (131392, 13120, '10', 'Address Line2 Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131383, NULL, NULL, 'Business Name Line2 Txt', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedTaxExemptOrgGrp/DisregardedEntityName/BusinessNameLine2Txt'),
  (131384, NULL, NULL, 'Legal Domicile Foreign Country Cd', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedTaxExemptOrgGrp/LegalDomicileForeignCountryCd'),
  (131385, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedTaxExemptOrgGrp/USAddress/AddressLine2Txt'),
  (131386, NULL, NULL, 'Address Line1 Txt', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedTaxExemptOrgGrp/ForeignAddress/AddressLine1Txt'),
  (131387, NULL, NULL, 'Country Cd', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedTaxExemptOrgGrp/ForeignAddress/CountryCd'),
  (131388, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedTaxExemptOrgGrp/ForeignAddress/CityNm'),
  (131389, NULL, NULL, 'Business Name Line2 Txt', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedTaxExemptOrgGrp/DirectControllingEntityName/BusinessNameLine2Txt'),
  (131390, NULL, NULL, 'Foreign Postal Cd', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedTaxExemptOrgGrp/ForeignAddress/ForeignPostalCd'),
  (131391, NULL, NULL, 'Province Or State Nm', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedTaxExemptOrgGrp/ForeignAddress/ProvinceOrStateNm'),
  (131392, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/IRS990ScheduleR/IdRelatedTaxExemptOrgGrp/ForeignAddress/AddressLine2Txt');

-- 990 / Avg Grassroots Lobbying Expend Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13121, 14, '072', 'Avg Grassroots Lobbying Expend Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131393, 13121, '1', 'Total Amt', 'CURRENCY'),
  (131394, 13121, '2', 'Current Year Amt', 'CURRENCY'),
  (131395, 13121, '3', 'Current Year Minus1 Amt', 'CURRENCY'),
  (131396, 13121, '4', 'Current Year Minus2 Amt', 'CURRENCY'),
  (131397, 13121, '5', 'Current Year Minus3 Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131393, NULL, NULL, 'Total Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/AvgGrassrootsLobbyingExpendGrp/TotalAmt'),
  (131394, NULL, NULL, 'Current Year Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/AvgGrassrootsLobbyingExpendGrp/CurrentYearAmt'),
  (131395, NULL, NULL, 'Current Year Minus1 Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/AvgGrassrootsLobbyingExpendGrp/CurrentYearMinus1Amt'),
  (131396, NULL, NULL, 'Current Year Minus2 Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/AvgGrassrootsLobbyingExpendGrp/CurrentYearMinus2Amt'),
  (131397, NULL, NULL, 'Current Year Minus3 Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/AvgGrassrootsLobbyingExpendGrp/CurrentYearMinus3Amt');

-- 990 / Total Community Benefits Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13122, 14, '073', 'Total Community Benefits Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131398, 13122, '1', 'Net Community Benefit Expns Amt', 'CURRENCY'),
  (131399, 13122, '2', 'Total Community Benefit Expns Amt', 'CURRENCY'),
  (131400, 13122, '3', 'Total Expense Pct', 'PERCENT'),
  (131401, 13122, '4', 'Direct Offsetting Revenue Amt', 'CURRENCY'),
  (131402, 13122, '5', 'Persons Served Cnt', 'INTEGER'),
  (131403, 13122, '6', 'Activities Or Programs Cnt', 'INTEGER');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131398, NULL, NULL, 'Net Community Benefit Expns Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/TotalCommunityBenefitsGrp/NetCommunityBenefitExpnsAmt'),
  (131399, NULL, NULL, 'Total Community Benefit Expns Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/TotalCommunityBenefitsGrp/TotalCommunityBenefitExpnsAmt'),
  (131400, NULL, NULL, 'Total Expense Pct', 'PERCENT', 'ReturnData/IRS990ScheduleH/TotalCommunityBenefitsGrp/TotalExpensePct'),
  (131401, NULL, NULL, 'Direct Offsetting Revenue Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/TotalCommunityBenefitsGrp/DirectOffsettingRevenueAmt'),
  (131402, NULL, NULL, 'Persons Served Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleH/TotalCommunityBenefitsGrp/PersonsServedCnt'),
  (131403, NULL, NULL, 'Activities Or Programs Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleH/TotalCommunityBenefitsGrp/ActivitiesOrProgramsCnt');

-- 990 / Total Financial Assistance Typ
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13123, 14, '074', 'Total Financial Assistance Typ');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131404, 13123, '1', 'Total Community Benefit Expns Amt', 'CURRENCY'),
  (131405, 13123, '2', 'Net Community Benefit Expns Amt', 'CURRENCY'),
  (131406, 13123, '3', 'Total Expense Pct', 'PERCENT'),
  (131407, 13123, '4', 'Direct Offsetting Revenue Amt', 'CURRENCY'),
  (131408, 13123, '5', 'Persons Served Cnt', 'INTEGER'),
  (131409, 13123, '6', 'Activities Or Programs Cnt', 'INTEGER');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131404, NULL, NULL, 'Total Community Benefit Expns Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/TotalFinancialAssistanceTyp/TotalCommunityBenefitExpnsAmt'),
  (131405, NULL, NULL, 'Net Community Benefit Expns Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/TotalFinancialAssistanceTyp/NetCommunityBenefitExpnsAmt'),
  (131406, NULL, NULL, 'Total Expense Pct', 'PERCENT', 'ReturnData/IRS990ScheduleH/TotalFinancialAssistanceTyp/TotalExpensePct'),
  (131407, NULL, NULL, 'Direct Offsetting Revenue Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/TotalFinancialAssistanceTyp/DirectOffsettingRevenueAmt'),
  (131408, NULL, NULL, 'Persons Served Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleH/TotalFinancialAssistanceTyp/PersonsServedCnt'),
  (131409, NULL, NULL, 'Activities Or Programs Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleH/TotalFinancialAssistanceTyp/ActivitiesOrProgramsCnt');

-- 990 / Total Other Benefits Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13124, 14, '075', 'Total Other Benefits Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131410, 13124, '1', 'Net Community Benefit Expns Amt', 'CURRENCY'),
  (131411, 13124, '2', 'Total Expense Pct', 'PERCENT'),
  (131412, 13124, '3', 'Total Community Benefit Expns Amt', 'CURRENCY'),
  (131413, 13124, '4', 'Direct Offsetting Revenue Amt', 'CURRENCY'),
  (131414, 13124, '5', 'Persons Served Cnt', 'INTEGER'),
  (131415, 13124, '6', 'Activities Or Programs Cnt', 'INTEGER');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131410, NULL, NULL, 'Net Community Benefit Expns Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/TotalOtherBenefitsGrp/NetCommunityBenefitExpnsAmt'),
  (131411, NULL, NULL, 'Total Expense Pct', 'PERCENT', 'ReturnData/IRS990ScheduleH/TotalOtherBenefitsGrp/TotalExpensePct'),
  (131412, NULL, NULL, 'Total Community Benefit Expns Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/TotalOtherBenefitsGrp/TotalCommunityBenefitExpnsAmt'),
  (131413, NULL, NULL, 'Direct Offsetting Revenue Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/TotalOtherBenefitsGrp/DirectOffsettingRevenueAmt'),
  (131414, NULL, NULL, 'Persons Served Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleH/TotalOtherBenefitsGrp/PersonsServedCnt'),
  (131415, NULL, NULL, 'Activities Or Programs Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleH/TotalOtherBenefitsGrp/ActivitiesOrProgramsCnt');

-- 990 / Supplemental Information Detail
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13125, 14, '076', 'Supplemental Information Detail');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131416, 13125, '1', 'Form And Line Reference Desc', 'TEXT'),
  (131417, 13125, '2', 'Explanation Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131416, NULL, NULL, 'Form And Line Reference Desc', 'TEXT', 'ReturnData/IRS990ScheduleL/SupplementalInformationDetail/FormAndLineReferenceDesc'),
  (131417, NULL, NULL, 'Explanation Txt', 'TEXT', 'ReturnData/IRS990ScheduleL/SupplementalInformationDetail/ExplanationTxt');

-- 990 / Tax Exempt Bonds Private Bus Use Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13126, 14, '077', 'Tax Exempt Bonds Private Bus Use Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131418, 13126, '1', 'Total Private Business Use Pct', 'PERCENT'),
  (131419, 13126, '2', 'Private Bus Use By Others Pct', 'PERCENT'),
  (131420, 13126, '3', 'Private Bus Concerning UBI Pct', 'PERCENT'),
  (131421, 13126, '4', 'Engage Bond Counsel Contracts Ind', 'BOOLEAN'),
  (131422, 13126, '5', 'Engage Bond Counsel Research Ind', 'BOOLEAN'),
  (131423, 13126, '6', 'Remedial Action Taken Ind', 'BOOLEAN'),
  (131424, 13126, '7', 'Change In Use Bond Financed Prop Pct', 'PERCENT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131418, NULL, NULL, 'Total Private Business Use Pct', 'PERCENT', 'ReturnData/IRS990ScheduleK/TaxExemptBondsPrivateBusUseGrp/TotalPrivateBusinessUsePct'),
  (131419, NULL, NULL, 'Private Bus Use By Others Pct', 'PERCENT', 'ReturnData/IRS990ScheduleK/TaxExemptBondsPrivateBusUseGrp/PrivateBusUseByOthersPct'),
  (131420, NULL, NULL, 'Private Bus Concerning UBI Pct', 'PERCENT', 'ReturnData/IRS990ScheduleK/TaxExemptBondsPrivateBusUseGrp/PrivateBusConcerningUBIPct'),
  (131421, NULL, NULL, 'Engage Bond Counsel Contracts Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleK/TaxExemptBondsPrivateBusUseGrp/EngageBondCounselContractsInd'),
  (131422, NULL, NULL, 'Engage Bond Counsel Research Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleK/TaxExemptBondsPrivateBusUseGrp/EngageBondCounselResearchInd'),
  (131423, NULL, NULL, 'Remedial Action Taken Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleK/TaxExemptBondsPrivateBusUseGrp/RemedialActionTakenInd'),
  (131424, NULL, NULL, 'Change In Use Bond Financed Prop Pct', 'PERCENT', 'ReturnData/IRS990ScheduleK/TaxExemptBondsPrivateBusUseGrp/ChangeInUseBondFinancedPropPct');

-- 990 / Oth Hlth Care Fclts Not Hospital Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13127, 14, '078', 'Oth Hlth Care Fclts Not Hospital Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131425, 13127, '1', 'Business Name Line1 Txt', 'TEXT'),
  (131426, 13127, '2', 'Facility Txt', 'TEXT'),
  (131427, 13127, '3', 'Address Line1 Txt', 'TEXT'),
  (131428, 13127, '4', 'City Nm', 'TEXT'),
  (131429, 13127, '5', 'State Abbreviation Cd', 'TEXT'),
  (131430, 13127, '6', 'ZIP Cd', 'TEXT'),
  (131431, 13127, '7', 'Address Line2 Txt', 'TEXT'),
  (131432, 13127, '8', 'Business Name Line2 Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131425, NULL, NULL, 'Business Name Line1 Txt', 'TEXT', 'ReturnData/IRS990ScheduleH/OthHlthCareFcltsNotHospitalGrp/OthHlthCareFcltsGrp/BusinessName/BusinessNameLine1Txt'),
  (131426, NULL, NULL, 'Facility Txt', 'TEXT', 'ReturnData/IRS990ScheduleH/OthHlthCareFcltsNotHospitalGrp/OthHlthCareFcltsGrp/FacilityTxt'),
  (131427, NULL, NULL, 'Address Line1 Txt', 'TEXT', 'ReturnData/IRS990ScheduleH/OthHlthCareFcltsNotHospitalGrp/OthHlthCareFcltsGrp/USAddress/AddressLine1Txt'),
  (131428, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990ScheduleH/OthHlthCareFcltsNotHospitalGrp/OthHlthCareFcltsGrp/USAddress/CityNm'),
  (131429, NULL, NULL, 'State Abbreviation Cd', 'TEXT', 'ReturnData/IRS990ScheduleH/OthHlthCareFcltsNotHospitalGrp/OthHlthCareFcltsGrp/USAddress/StateAbbreviationCd'),
  (131430, NULL, NULL, 'ZIP Cd', 'TEXT', 'ReturnData/IRS990ScheduleH/OthHlthCareFcltsNotHospitalGrp/OthHlthCareFcltsGrp/USAddress/ZIPCd'),
  (131431, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/IRS990ScheduleH/OthHlthCareFcltsNotHospitalGrp/OthHlthCareFcltsGrp/USAddress/AddressLine2Txt'),
  (131432, NULL, NULL, 'Business Name Line2 Txt', 'TEXT', 'ReturnData/IRS990ScheduleH/OthHlthCareFcltsNotHospitalGrp/OthHlthCareFcltsGrp/BusinessName/BusinessNameLine2Txt');

-- 990 / IRS990 Schedule J Direct Fields
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13128, 14, '079', 'IRS990 Schedule J Direct Fields');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131433, 13128, '1', 'Housing Allowance Or Residence Ind', 'BOOLEAN'),
  (131434, 13128, '2', 'Travel For Companions Ind', 'BOOLEAN'),
  (131435, 13128, '3', 'Idemnification Gross Up Pmts Ind', 'BOOLEAN'),
  (131436, 13128, '4', 'Discretionary Spending Acct Ind', 'BOOLEAN'),
  (131437, 13128, '5', 'Rebuttable Presumption Proc Ind', 'BOOLEAN'),
  (131438, 13128, '6', 'Personal Services Ind', 'BOOLEAN'),
  (131439, 13128, '7', 'Payments For Use Of Residence Ind', 'BOOLEAN');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131433, NULL, NULL, 'Housing Allowance Or Residence Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleJ/HousingAllowanceOrResidenceInd'),
  (131434, NULL, NULL, 'Travel For Companions Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleJ/TravelForCompanionsInd'),
  (131435, NULL, NULL, 'Idemnification Gross Up Pmts Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleJ/IdemnificationGrossUpPmtsInd'),
  (131436, NULL, NULL, 'Discretionary Spending Acct Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleJ/DiscretionarySpendingAcctInd'),
  (131437, NULL, NULL, 'Rebuttable Presumption Proc Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleJ/RebuttablePresumptionProcInd'),
  (131438, NULL, NULL, 'Personal Services Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleJ/PersonalServicesInd'),
  (131439, NULL, NULL, 'Payments For Use Of Residence Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleJ/PaymentsForUseOfResidenceInd');

-- 990 / Unreimbursed Medicaid Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13129, 14, '080', 'Unreimbursed Medicaid Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131440, 13129, '1', 'Total Community Benefit Expns Amt', 'CURRENCY'),
  (131441, 13129, '2', 'Direct Offsetting Revenue Amt', 'CURRENCY'),
  (131442, 13129, '3', 'Total Expense Pct', 'PERCENT'),
  (131443, 13129, '4', 'Net Community Benefit Expns Amt', 'CURRENCY'),
  (131444, 13129, '5', 'Persons Served Cnt', 'INTEGER'),
  (131445, 13129, '6', 'Activities Or Programs Cnt', 'INTEGER');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131440, NULL, NULL, 'Total Community Benefit Expns Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/UnreimbursedMedicaidGrp/TotalCommunityBenefitExpnsAmt'),
  (131441, NULL, NULL, 'Direct Offsetting Revenue Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/UnreimbursedMedicaidGrp/DirectOffsettingRevenueAmt'),
  (131442, NULL, NULL, 'Total Expense Pct', 'PERCENT', 'ReturnData/IRS990ScheduleH/UnreimbursedMedicaidGrp/TotalExpensePct'),
  (131443, NULL, NULL, 'Net Community Benefit Expns Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/UnreimbursedMedicaidGrp/NetCommunityBenefitExpnsAmt'),
  (131444, NULL, NULL, 'Persons Served Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleH/UnreimbursedMedicaidGrp/PersonsServedCnt'),
  (131445, NULL, NULL, 'Activities Or Programs Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleH/UnreimbursedMedicaidGrp/ActivitiesOrProgramsCnt');

-- 990 / IRS990 Schedule L Direct Fields
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13130, 14, '081', 'IRS990 Schedule L Direct Fields');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131446, 13130, '1', 'Total Balance Due Amt', 'CURRENCY'),
  (131447, 13130, '2', 'Tax Imposed Amt', 'CURRENCY'),
  (131448, 13130, '3', 'Tax Reimbursed Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131446, NULL, NULL, 'Total Balance Due Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleL/TotalBalanceDueAmt'),
  (131447, NULL, NULL, 'Tax Imposed Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleL/TaxImposedAmt'),
  (131448, NULL, NULL, 'Tax Reimbursed Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleL/TaxReimbursedAmt');

-- 990 / Financial Assistance At Cost Typ
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13131, 14, '082', 'Financial Assistance At Cost Typ');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131449, 13131, '1', 'Total Community Benefit Expns Amt', 'CURRENCY'),
  (131450, 13131, '2', 'Net Community Benefit Expns Amt', 'CURRENCY'),
  (131451, 13131, '3', 'Total Expense Pct', 'PERCENT'),
  (131452, 13131, '4', 'Direct Offsetting Revenue Amt', 'CURRENCY'),
  (131453, 13131, '5', 'Persons Served Cnt', 'INTEGER'),
  (131454, 13131, '6', 'Activities Or Programs Cnt', 'INTEGER');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131449, NULL, NULL, 'Total Community Benefit Expns Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/FinancialAssistanceAtCostTyp/TotalCommunityBenefitExpnsAmt'),
  (131450, NULL, NULL, 'Net Community Benefit Expns Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/FinancialAssistanceAtCostTyp/NetCommunityBenefitExpnsAmt'),
  (131451, NULL, NULL, 'Total Expense Pct', 'PERCENT', 'ReturnData/IRS990ScheduleH/FinancialAssistanceAtCostTyp/TotalExpensePct'),
  (131452, NULL, NULL, 'Direct Offsetting Revenue Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/FinancialAssistanceAtCostTyp/DirectOffsettingRevenueAmt'),
  (131453, NULL, NULL, 'Persons Served Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleH/FinancialAssistanceAtCostTyp/PersonsServedCnt'),
  (131454, NULL, NULL, 'Activities Or Programs Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleH/FinancialAssistanceAtCostTyp/ActivitiesOrProgramsCnt');

-- 990 / Community Health Services Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13132, 14, '083', 'Community Health Services Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131455, 13132, '1', 'Net Community Benefit Expns Amt', 'CURRENCY'),
  (131456, 13132, '2', 'Total Expense Pct', 'PERCENT'),
  (131457, 13132, '3', 'Total Community Benefit Expns Amt', 'CURRENCY'),
  (131458, 13132, '4', 'Direct Offsetting Revenue Amt', 'CURRENCY'),
  (131459, 13132, '5', 'Persons Served Cnt', 'INTEGER'),
  (131460, 13132, '6', 'Activities Or Programs Cnt', 'INTEGER');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131455, NULL, NULL, 'Net Community Benefit Expns Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/CommunityHealthServicesGrp/NetCommunityBenefitExpnsAmt'),
  (131456, NULL, NULL, 'Total Expense Pct', 'PERCENT', 'ReturnData/IRS990ScheduleH/CommunityHealthServicesGrp/TotalExpensePct'),
  (131457, NULL, NULL, 'Total Community Benefit Expns Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/CommunityHealthServicesGrp/TotalCommunityBenefitExpnsAmt'),
  (131458, NULL, NULL, 'Direct Offsetting Revenue Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/CommunityHealthServicesGrp/DirectOffsettingRevenueAmt'),
  (131459, NULL, NULL, 'Persons Served Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleH/CommunityHealthServicesGrp/PersonsServedCnt'),
  (131460, NULL, NULL, 'Activities Or Programs Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleH/CommunityHealthServicesGrp/ActivitiesOrProgramsCnt');

-- 990 / Supplemental Information Detail
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13133, 14, '084', 'Supplemental Information Detail');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131461, 13133, '1', 'Form And Line Reference Desc', 'TEXT'),
  (131462, 13133, '2', 'Explanation Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131461, NULL, NULL, 'Form And Line Reference Desc', 'TEXT', 'ReturnData/IRS990ScheduleG/SupplementalInformationDetail/FormAndLineReferenceDesc'),
  (131462, NULL, NULL, 'Explanation Txt', 'TEXT', 'ReturnData/IRS990ScheduleG/SupplementalInformationDetail/ExplanationTxt');

-- 990 / Other Organization Dsc
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13134, 14, '085', 'Other Organization Dsc');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131463, 13134, '1', 'Other Organization Dsc', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131463, NULL, NULL, 'Other Organization Dsc', 'TEXT', 'ReturnData/IRS990/OtherOrganizationDsc');

-- 990 / Form990 Sch A Type3 Func Int Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13135, 14, '086', 'Form990 Sch A Type3 Func Int Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131464, 13135, '1', 'Activities Further Exempt Prps Ind', 'BOOLEAN'),
  (131465, 13135, '2', 'Activities Engaged Org Invlmnt Ind', 'BOOLEAN'),
  (131466, 13135, '3', 'Activities Test Ind', 'BOOLEAN'),
  (131467, 13135, '4', 'Governmental Entity Ind', 'BOOLEAN'),
  (131468, 13135, '5', 'Exercise Direction Policies Ind', 'BOOLEAN'),
  (131469, 13135, '6', 'Appoint Elect Majority Officer Ind', 'BOOLEAN'),
  (131470, 13135, '7', 'Parent Supported Org Ind', 'BOOLEAN');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131464, NULL, NULL, 'Activities Further Exempt Prps Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/Form990SchAType3FuncIntGrp/ActivitiesFurtherExemptPrpsInd'),
  (131465, NULL, NULL, 'Activities Engaged Org Invlmnt Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/Form990SchAType3FuncIntGrp/ActivitiesEngagedOrgInvlmntInd'),
  (131466, NULL, NULL, 'Activities Test Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/Form990SchAType3FuncIntGrp/ActivitiesTestInd'),
  (131467, NULL, NULL, 'Governmental Entity Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/Form990SchAType3FuncIntGrp/GovernmentalEntityInd'),
  (131468, NULL, NULL, 'Exercise Direction Policies Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/Form990SchAType3FuncIntGrp/ExerciseDirectionPoliciesInd'),
  (131469, NULL, NULL, 'Appoint Elect Majority Officer Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/Form990SchAType3FuncIntGrp/AppointElectMajorityOfficerInd'),
  (131470, NULL, NULL, 'Parent Supported Org Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/Form990SchAType3FuncIntGrp/ParentSupportedOrgInd');

-- 990 / Bus Tr Involve Interested Prsn Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13136, 14, '087', 'Bus Tr Involve Interested Prsn Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131471, 13136, '1', 'Business Name Line1 Txt', 'TEXT'),
  (131472, 13136, '2', 'Business Name Line2 Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131471, NULL, NULL, 'Business Name Line1 Txt', 'TEXT', 'ReturnData/IRS990ScheduleL/BusTrInvolveInterestedPrsnGrp/NameOfInterested/BusinessName/BusinessNameLine1Txt'),
  (131472, NULL, NULL, 'Business Name Line2 Txt', 'TEXT', 'ReturnData/IRS990ScheduleL/BusTrInvolveInterestedPrsnGrp/NameOfInterested/BusinessName/BusinessNameLine2Txt');

-- 990 / Recipient Table
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13137, 14, '088', 'Recipient Table');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131473, 13137, '1', 'Address Line2 Txt', 'TEXT'),
  (131474, 13137, '2', 'Business Name Line2 Txt', 'TEXT'),
  (131475, 13137, '3', 'Address Line1 Txt', 'TEXT'),
  (131476, 13137, '4', 'Country Cd', 'TEXT'),
  (131477, 13137, '5', 'City Nm', 'TEXT'),
  (131478, 13137, '6', 'Foreign Postal Cd', 'TEXT'),
  (131479, 13137, '7', 'Province Or State Nm', 'TEXT'),
  (131480, 13137, '8', 'Address Line2 Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131473, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/IRS990ScheduleI/RecipientTable/USAddress/AddressLine2Txt'),
  (131474, NULL, NULL, 'Business Name Line2 Txt', 'TEXT', 'ReturnData/IRS990ScheduleI/RecipientTable/RecipientBusinessName/BusinessNameLine2Txt'),
  (131475, NULL, NULL, 'Address Line1 Txt', 'TEXT', 'ReturnData/IRS990ScheduleI/RecipientTable/ForeignAddress/AddressLine1Txt'),
  (131476, NULL, NULL, 'Country Cd', 'TEXT', 'ReturnData/IRS990ScheduleI/RecipientTable/ForeignAddress/CountryCd'),
  (131477, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990ScheduleI/RecipientTable/ForeignAddress/CityNm'),
  (131478, NULL, NULL, 'Foreign Postal Cd', 'TEXT', 'ReturnData/IRS990ScheduleI/RecipientTable/ForeignAddress/ForeignPostalCd'),
  (131479, NULL, NULL, 'Province Or State Nm', 'TEXT', 'ReturnData/IRS990ScheduleI/RecipientTable/ForeignAddress/ProvinceOrStateNm'),
  (131480, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/IRS990ScheduleI/RecipientTable/ForeignAddress/AddressLine2Txt');

-- 990 / Health Professions Education Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13138, 14, '089', 'Health Professions Education Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131481, 13138, '1', 'Net Community Benefit Expns Amt', 'CURRENCY'),
  (131482, 13138, '2', 'Total Expense Pct', 'PERCENT'),
  (131483, 13138, '3', 'Total Community Benefit Expns Amt', 'CURRENCY'),
  (131484, 13138, '4', 'Direct Offsetting Revenue Amt', 'CURRENCY'),
  (131485, 13138, '5', 'Activities Or Programs Cnt', 'INTEGER'),
  (131486, 13138, '6', 'Persons Served Cnt', 'INTEGER');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131481, NULL, NULL, 'Net Community Benefit Expns Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/HealthProfessionsEducationGrp/NetCommunityBenefitExpnsAmt'),
  (131482, NULL, NULL, 'Total Expense Pct', 'PERCENT', 'ReturnData/IRS990ScheduleH/HealthProfessionsEducationGrp/TotalExpensePct'),
  (131483, NULL, NULL, 'Total Community Benefit Expns Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/HealthProfessionsEducationGrp/TotalCommunityBenefitExpnsAmt'),
  (131484, NULL, NULL, 'Direct Offsetting Revenue Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/HealthProfessionsEducationGrp/DirectOffsettingRevenueAmt'),
  (131485, NULL, NULL, 'Activities Or Programs Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleH/HealthProfessionsEducationGrp/ActivitiesOrProgramsCnt'),
  (131486, NULL, NULL, 'Persons Served Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleH/HealthProfessionsEducationGrp/PersonsServedCnt');

-- 990 / Total Communtity Building Acty Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13139, 14, '090', 'Total Communtity Building Acty Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131487, 13139, '1', 'Total Community Benefit Expns Amt', 'CURRENCY'),
  (131488, 13139, '2', 'Net Community Benefit Expns Amt', 'CURRENCY'),
  (131489, 13139, '3', 'Total Expense Pct', 'PERCENT'),
  (131490, 13139, '4', 'Activities Or Programs Cnt', 'INTEGER'),
  (131491, 13139, '5', 'Persons Served Cnt', 'INTEGER'),
  (131492, 13139, '6', 'Direct Offsetting Revenue Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131487, NULL, NULL, 'Total Community Benefit Expns Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/TotalCommuntityBuildingActyGrp/TotalCommunityBenefitExpnsAmt'),
  (131488, NULL, NULL, 'Net Community Benefit Expns Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/TotalCommuntityBuildingActyGrp/NetCommunityBenefitExpnsAmt'),
  (131489, NULL, NULL, 'Total Expense Pct', 'PERCENT', 'ReturnData/IRS990ScheduleH/TotalCommuntityBuildingActyGrp/TotalExpensePct'),
  (131490, NULL, NULL, 'Activities Or Programs Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleH/TotalCommuntityBuildingActyGrp/ActivitiesOrProgramsCnt'),
  (131491, NULL, NULL, 'Persons Served Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleH/TotalCommuntityBuildingActyGrp/PersonsServedCnt'),
  (131492, NULL, NULL, 'Direct Offsetting Revenue Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/TotalCommuntityBuildingActyGrp/DirectOffsettingRevenueAmt');

-- 990 / Books In Care Of Detail
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13140, 14, '091', 'Books In Care Of Detail');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131493, 13140, '1', 'Business Name Line2 Txt', 'TEXT'),
  (131494, 13140, '2', 'Address Line1 Txt', 'TEXT'),
  (131495, 13140, '3', 'Country Cd', 'TEXT'),
  (131496, 13140, '4', 'City Nm', 'TEXT'),
  (131497, 13140, '5', 'Foreign Postal Cd', 'TEXT'),
  (131498, 13140, '6', 'Province Or State Nm', 'TEXT'),
  (131499, 13140, '7', 'Address Line2 Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131493, NULL, NULL, 'Business Name Line2 Txt', 'TEXT', 'ReturnData/IRS990/BooksInCareOfDetail/BusinessName/BusinessNameLine2Txt'),
  (131494, NULL, NULL, 'Address Line1 Txt', 'TEXT', 'ReturnData/IRS990/BooksInCareOfDetail/ForeignAddress/AddressLine1Txt'),
  (131495, NULL, NULL, 'Country Cd', 'TEXT', 'ReturnData/IRS990/BooksInCareOfDetail/ForeignAddress/CountryCd'),
  (131496, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990/BooksInCareOfDetail/ForeignAddress/CityNm'),
  (131497, NULL, NULL, 'Foreign Postal Cd', 'TEXT', 'ReturnData/IRS990/BooksInCareOfDetail/ForeignAddress/ForeignPostalCd'),
  (131498, NULL, NULL, 'Province Or State Nm', 'TEXT', 'ReturnData/IRS990/BooksInCareOfDetail/ForeignAddress/ProvinceOrStateNm'),
  (131499, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/IRS990/BooksInCareOfDetail/ForeignAddress/AddressLine2Txt');

-- 990 / Cash And In Kind Contributions Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13141, 14, '092', 'Cash And In Kind Contributions Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131500, 13141, '1', 'Net Community Benefit Expns Amt', 'CURRENCY'),
  (131501, 13141, '2', 'Total Expense Pct', 'PERCENT'),
  (131502, 13141, '3', 'Total Community Benefit Expns Amt', 'CURRENCY'),
  (131503, 13141, '4', 'Direct Offsetting Revenue Amt', 'CURRENCY'),
  (131504, 13141, '5', 'Activities Or Programs Cnt', 'INTEGER'),
  (131505, 13141, '6', 'Persons Served Cnt', 'INTEGER');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131500, NULL, NULL, 'Net Community Benefit Expns Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/CashAndInKindContributionsGrp/NetCommunityBenefitExpnsAmt'),
  (131501, NULL, NULL, 'Total Expense Pct', 'PERCENT', 'ReturnData/IRS990ScheduleH/CashAndInKindContributionsGrp/TotalExpensePct'),
  (131502, NULL, NULL, 'Total Community Benefit Expns Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/CashAndInKindContributionsGrp/TotalCommunityBenefitExpnsAmt'),
  (131503, NULL, NULL, 'Direct Offsetting Revenue Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/CashAndInKindContributionsGrp/DirectOffsettingRevenueAmt'),
  (131504, NULL, NULL, 'Activities Or Programs Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleH/CashAndInKindContributionsGrp/ActivitiesOrProgramsCnt'),
  (131505, NULL, NULL, 'Persons Served Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleH/CashAndInKindContributionsGrp/PersonsServedCnt');

-- 990 / Subsidized Health Services Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13142, 14, '093', 'Subsidized Health Services Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131506, 13142, '1', 'Total Expense Pct', 'PERCENT'),
  (131507, 13142, '2', 'Net Community Benefit Expns Amt', 'CURRENCY'),
  (131508, 13142, '3', 'Total Community Benefit Expns Amt', 'CURRENCY'),
  (131509, 13142, '4', 'Direct Offsetting Revenue Amt', 'CURRENCY'),
  (131510, 13142, '5', 'Activities Or Programs Cnt', 'INTEGER'),
  (131511, 13142, '6', 'Persons Served Cnt', 'INTEGER');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131506, NULL, NULL, 'Total Expense Pct', 'PERCENT', 'ReturnData/IRS990ScheduleH/SubsidizedHealthServicesGrp/TotalExpensePct'),
  (131507, NULL, NULL, 'Net Community Benefit Expns Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/SubsidizedHealthServicesGrp/NetCommunityBenefitExpnsAmt'),
  (131508, NULL, NULL, 'Total Community Benefit Expns Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/SubsidizedHealthServicesGrp/TotalCommunityBenefitExpnsAmt'),
  (131509, NULL, NULL, 'Direct Offsetting Revenue Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/SubsidizedHealthServicesGrp/DirectOffsettingRevenueAmt'),
  (131510, NULL, NULL, 'Activities Or Programs Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleH/SubsidizedHealthServicesGrp/ActivitiesOrProgramsCnt'),
  (131511, NULL, NULL, 'Persons Served Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleH/SubsidizedHealthServicesGrp/PersonsServedCnt');

-- 990 / Lobbying Nontaxable Amount Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13143, 14, '094', 'Lobbying Nontaxable Amount Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131512, 13143, '1', 'Filing Organizations Total Amt', 'CURRENCY'),
  (131513, 13143, '2', 'Affiliated Group Total Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131512, NULL, NULL, 'Filing Organizations Total Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/LobbyingNontaxableAmountGrp/FilingOrganizationsTotalAmt'),
  (131513, NULL, NULL, 'Affiliated Group Total Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/LobbyingNontaxableAmountGrp/AffiliatedGroupTotalAmt');

-- 990 / FS Audited Basis Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13144, 14, '095', 'FS Audited Basis Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131514, 13144, '1', 'Consol And Sep Basis Fincl Stmt Ind', 'BOOLEAN');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131514, NULL, NULL, 'Consol And Sep Basis Fincl Stmt Ind', 'BOOLEAN', 'ReturnData/IRS990/FSAuditedBasisGrp/ConsolAndSepBasisFinclStmtInd');

-- 990 / Acct Compile Or Review Basis Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13145, 14, '096', 'Acct Compile Or Review Basis Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131515, 13145, '1', 'Consolidated Basis Fincl Stmt Ind', 'BOOLEAN'),
  (131516, 13145, '2', 'Consol And Sep Basis Fincl Stmt Ind', 'BOOLEAN');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131515, NULL, NULL, 'Consolidated Basis Fincl Stmt Ind', 'BOOLEAN', 'ReturnData/IRS990/AcctCompileOrReviewBasisGrp/ConsolidatedBasisFinclStmtInd'),
  (131516, NULL, NULL, 'Consol And Sep Basis Fincl Stmt Ind', 'BOOLEAN', 'ReturnData/IRS990/AcctCompileOrReviewBasisGrp/ConsolAndSepBasisFinclStmtInd');

-- 990 / Cars And Other Vehicles Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13146, 14, '097', 'Cars And Other Vehicles Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131517, 13146, '1', 'Noncash Contributions Rpt F990 Amt', 'CURRENCY'),
  (131518, 13146, '2', 'Contribution Cnt', 'INTEGER'),
  (131519, 13146, '3', 'Non Cash Checkbox Ind', 'BOOLEAN'),
  (131520, 13146, '4', 'Method Of Determining Revenues Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131517, NULL, NULL, 'Noncash Contributions Rpt F990 Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleM/CarsAndOtherVehiclesGrp/NoncashContributionsRptF990Amt'),
  (131518, NULL, NULL, 'Contribution Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleM/CarsAndOtherVehiclesGrp/ContributionCnt'),
  (131519, NULL, NULL, 'Non Cash Checkbox Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleM/CarsAndOtherVehiclesGrp/NonCashCheckboxInd'),
  (131520, NULL, NULL, 'Method Of Determining Revenues Txt', 'TEXT', 'ReturnData/IRS990ScheduleM/CarsAndOtherVehiclesGrp/MethodOfDeterminingRevenuesTxt');

-- 990 / Grassroots Nontaxable Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13147, 14, '098', 'Grassroots Nontaxable Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131521, 13147, '1', 'Filing Organizations Total Amt', 'CURRENCY'),
  (131522, 13147, '2', 'Affiliated Group Total Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131521, NULL, NULL, 'Filing Organizations Total Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/GrassrootsNontaxableGrp/FilingOrganizationsTotalAmt'),
  (131522, NULL, NULL, 'Affiliated Group Total Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/GrassrootsNontaxableGrp/AffiliatedGroupTotalAmt');

-- 990 / Total Exempt Purpose Expend Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13148, 14, '099', 'Total Exempt Purpose Expend Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131523, 13148, '1', 'Filing Organizations Total Amt', 'CURRENCY'),
  (131524, 13148, '2', 'Affiliated Group Total Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131523, NULL, NULL, 'Filing Organizations Total Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/TotalExemptPurposeExpendGrp/FilingOrganizationsTotalAmt'),
  (131524, NULL, NULL, 'Affiliated Group Total Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/TotalExemptPurposeExpendGrp/AffiliatedGroupTotalAmt');

-- 990 / Supplemental Information Detail
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13149, 14, '100', 'Supplemental Information Detail');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131525, 13149, '1', 'Form And Line Reference Desc', 'TEXT'),
  (131526, 13149, '2', 'Explanation Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131525, NULL, NULL, 'Form And Line Reference Desc', 'TEXT', 'ReturnData/IRS990ScheduleK/SupplementalInformationDetail/FormAndLineReferenceDesc'),
  (131526, NULL, NULL, 'Explanation Txt', 'TEXT', 'ReturnData/IRS990ScheduleK/SupplementalInformationDetail/ExplanationTxt');

-- 990 / Other Exempt Purpose Expend Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13150, 14, '101', 'Other Exempt Purpose Expend Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131527, 13150, '1', 'Filing Organizations Total Amt', 'CURRENCY'),
  (131528, 13150, '2', 'Affiliated Group Total Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131527, NULL, NULL, 'Filing Organizations Total Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/OtherExemptPurposeExpendGrp/FilingOrganizationsTotalAmt'),
  (131528, NULL, NULL, 'Affiliated Group Total Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/OtherExemptPurposeExpendGrp/AffiliatedGroupTotalAmt');

-- 990 / Works Of Art Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13151, 14, '102', 'Works Of Art Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131529, 13151, '1', 'Contribution Cnt', 'INTEGER'),
  (131530, 13151, '2', 'Non Cash Checkbox Ind', 'BOOLEAN'),
  (131531, 13151, '3', 'Noncash Contributions Rpt F990 Amt', 'CURRENCY'),
  (131532, 13151, '4', 'Method Of Determining Revenues Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131529, NULL, NULL, 'Contribution Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleM/WorksOfArtGrp/ContributionCnt'),
  (131530, NULL, NULL, 'Non Cash Checkbox Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleM/WorksOfArtGrp/NonCashCheckboxInd'),
  (131531, NULL, NULL, 'Noncash Contributions Rpt F990 Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleM/WorksOfArtGrp/NoncashContributionsRptF990Amt'),
  (131532, NULL, NULL, 'Method Of Determining Revenues Txt', 'TEXT', 'ReturnData/IRS990ScheduleM/WorksOfArtGrp/MethodOfDeterminingRevenuesTxt');

-- 990 / Total Lobbying Expend Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13152, 14, '103', 'Total Lobbying Expend Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131533, 13152, '1', 'Filing Organizations Total Amt', 'CURRENCY'),
  (131534, 13152, '2', 'Affiliated Group Total Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131533, NULL, NULL, 'Filing Organizations Total Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/TotalLobbyingExpendGrp/FilingOrganizationsTotalAmt'),
  (131534, NULL, NULL, 'Affiliated Group Total Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/TotalLobbyingExpendGrp/AffiliatedGroupTotalAmt');

-- 990 / Tax Exempt Bonds Arbitrage Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13153, 14, '104', 'Tax Exempt Bonds Arbitrage Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131535, 13153, '1', 'Hedge Terminated Ind', 'BOOLEAN'),
  (131536, 13153, '2', 'Superintegrated Hedge Ind', 'BOOLEAN'),
  (131537, 13153, '3', 'Term Of Hedge Pct', 'PERCENT'),
  (131538, 13153, '4', 'Business Name Line1 Txt', 'TEXT'),
  (131539, 13153, '5', 'Regulatory Safe Harbor Stsfd Ind', 'BOOLEAN'),
  (131540, 13153, '6', 'Term Of GIC Pct', 'PERCENT'),
  (131541, 13153, '7', 'Business Name Line1 Txt', 'TEXT'),
  (131542, 13153, '8', 'Business Name Line2 Txt', 'TEXT'),
  (131543, 13153, '9', 'Business Name Line2 Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131535, NULL, NULL, 'Hedge Terminated Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleK/TaxExemptBondsArbitrageGrp/HedgeTerminatedInd'),
  (131536, NULL, NULL, 'Superintegrated Hedge Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleK/TaxExemptBondsArbitrageGrp/SuperintegratedHedgeInd'),
  (131537, NULL, NULL, 'Term Of Hedge Pct', 'PERCENT', 'ReturnData/IRS990ScheduleK/TaxExemptBondsArbitrageGrp/TermOfHedgePct'),
  (131538, NULL, NULL, 'Business Name Line1 Txt', 'TEXT', 'ReturnData/IRS990ScheduleK/TaxExemptBondsArbitrageGrp/HedgeProviderName/BusinessNameLine1Txt'),
  (131539, NULL, NULL, 'Regulatory Safe Harbor Stsfd Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleK/TaxExemptBondsArbitrageGrp/RegulatorySafeHarborStsfdInd'),
  (131540, NULL, NULL, 'Term Of GIC Pct', 'PERCENT', 'ReturnData/IRS990ScheduleK/TaxExemptBondsArbitrageGrp/TermOfGICPct'),
  (131541, NULL, NULL, 'Business Name Line1 Txt', 'TEXT', 'ReturnData/IRS990ScheduleK/TaxExemptBondsArbitrageGrp/GICProviderName/BusinessNameLine1Txt'),
  (131542, NULL, NULL, 'Business Name Line2 Txt', 'TEXT', 'ReturnData/IRS990ScheduleK/TaxExemptBondsArbitrageGrp/HedgeProviderName/BusinessNameLine2Txt'),
  (131543, NULL, NULL, 'Business Name Line2 Txt', 'TEXT', 'ReturnData/IRS990ScheduleK/TaxExemptBondsArbitrageGrp/GICProviderName/BusinessNameLine2Txt');

-- 990 / Total Direct Lobbying Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13154, 14, '105', 'Total Direct Lobbying Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131544, 13154, '1', 'Filing Organizations Total Amt', 'CURRENCY'),
  (131545, 13154, '2', 'Affiliated Group Total Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131544, NULL, NULL, 'Filing Organizations Total Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/TotalDirectLobbyingGrp/FilingOrganizationsTotalAmt'),
  (131545, NULL, NULL, 'Affiliated Group Total Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/TotalDirectLobbyingGrp/AffiliatedGroupTotalAmt');

-- 990 / Supplemental Information Detail
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13155, 14, '106', 'Supplemental Information Detail');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131546, 13155, '1', 'Explanation Txt', 'TEXT'),
  (131547, 13155, '2', 'Form And Line Reference Desc', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131546, NULL, NULL, 'Explanation Txt', 'TEXT', 'ReturnData/IRS990ScheduleH/SupplementalInformationDetail/ExplanationTxt'),
  (131547, NULL, NULL, 'Form And Line Reference Desc', 'TEXT', 'ReturnData/IRS990ScheduleH/SupplementalInformationDetail/FormAndLineReferenceDesc');

-- 990 / Supplemental Information Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13156, 14, '107', 'Supplemental Information Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131548, 13156, '1', 'Explanation Txt', 'TEXT'),
  (131549, 13156, '2', 'Form And Line Reference Desc', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131548, NULL, NULL, 'Explanation Txt', 'TEXT', 'ReturnData/IRS990ScheduleH/SupplementalInformationGrp/ExplanationTxt'),
  (131549, NULL, NULL, 'Form And Line Reference Desc', 'TEXT', 'ReturnData/IRS990ScheduleH/SupplementalInformationGrp/FormAndLineReferenceDesc');

-- 990 / Tot Lbby Expend Mns Lbbyng Non Tx Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13157, 14, '108', 'Tot Lbby Expend Mns Lbbyng Non Tx Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131550, 13157, '1', 'Filing Organizations Total Amt', 'CURRENCY'),
  (131551, 13157, '2', 'Affiliated Group Total Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131550, NULL, NULL, 'Filing Organizations Total Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/TotLbbyExpendMnsLbbyngNonTxGrp/FilingOrganizationsTotalAmt'),
  (131551, NULL, NULL, 'Affiliated Group Total Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/TotLbbyExpendMnsLbbyngNonTxGrp/AffiliatedGroupTotalAmt');

-- 990 / Tot Lbbyng Grassroot Mns Non Tx Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13158, 14, '109', 'Tot Lbbyng Grassroot Mns Non Tx Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131552, 13158, '1', 'Filing Organizations Total Amt', 'CURRENCY'),
  (131553, 13158, '2', 'Affiliated Group Total Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131552, NULL, NULL, 'Filing Organizations Total Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/TotLbbyngGrassrootMnsNonTxGrp/FilingOrganizationsTotalAmt'),
  (131553, NULL, NULL, 'Affiliated Group Total Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/TotLbbyngGrassrootMnsNonTxGrp/AffiliatedGroupTotalAmt');

-- 990 / Affiliated Schedule Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13159, 14, '110', 'Affiliated Schedule Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131554, 13159, '1', 'Business Name Line1 Txt', 'TEXT'),
  (131555, 13159, '2', 'EIN', 'TEXT'),
  (131556, 13159, '3', 'Grassroots Nontx Amt', 'CURRENCY'),
  (131557, 13159, '4', 'Lobby Nontx Amt', 'CURRENCY'),
  (131558, 13159, '5', 'Other Exempt Purpose Expend Amt', 'CURRENCY'),
  (131559, 13159, '6', 'Share Excess Lobby Expend Amt', 'CURRENCY'),
  (131560, 13159, '7', 'Tot Lbby Expend Mns Lobby Nontx Amt', 'CURRENCY'),
  (131561, 13159, '8', 'Total Direct Lobby Amt', 'CURRENCY'),
  (131562, 13159, '9', 'Total Exempt Purpose Expend Amt', 'CURRENCY'),
  (131563, 13159, '10', 'Total Grassroots Lobby Amt', 'CURRENCY'),
  (131564, 13159, '11', 'Total Lobby Expenditure Amt', 'CURRENCY'),
  (131565, 13159, '12', 'Total Lobby Grssroot Mns Nontx Amt', 'CURRENCY'),
  (131566, 13159, '13', 'Address Line1 Txt', 'TEXT'),
  (131567, 13159, '14', 'City Nm', 'TEXT'),
  (131568, 13159, '15', 'State Abbreviation Cd', 'TEXT'),
  (131569, 13159, '16', 'ZIP Cd', 'TEXT'),
  (131570, 13159, '17', 'Electing Organization Ind', 'BOOLEAN'),
  (131571, 13159, '18', 'Address Line2 Txt', 'TEXT'),
  (131572, 13159, '19', 'Business Name Line2 Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131554, NULL, NULL, 'Business Name Line1 Txt', 'TEXT', 'ReturnData/AffiliatedGroupSchedule/AffiliatedScheduleGrp/BusinessName/BusinessNameLine1Txt'),
  (131555, NULL, NULL, 'EIN', 'TEXT', 'ReturnData/AffiliatedGroupSchedule/AffiliatedScheduleGrp/EIN'),
  (131556, NULL, NULL, 'Grassroots Nontx Amt', 'CURRENCY', 'ReturnData/AffiliatedGroupSchedule/AffiliatedScheduleGrp/GrassrootsNontxAmt'),
  (131557, NULL, NULL, 'Lobby Nontx Amt', 'CURRENCY', 'ReturnData/AffiliatedGroupSchedule/AffiliatedScheduleGrp/LobbyNontxAmt'),
  (131558, NULL, NULL, 'Other Exempt Purpose Expend Amt', 'CURRENCY', 'ReturnData/AffiliatedGroupSchedule/AffiliatedScheduleGrp/OtherExemptPurposeExpendAmt'),
  (131559, NULL, NULL, 'Share Excess Lobby Expend Amt', 'CURRENCY', 'ReturnData/AffiliatedGroupSchedule/AffiliatedScheduleGrp/ShareExcessLobbyExpendAmt'),
  (131560, NULL, NULL, 'Tot Lbby Expend Mns Lobby Nontx Amt', 'CURRENCY', 'ReturnData/AffiliatedGroupSchedule/AffiliatedScheduleGrp/TotLbbyExpendMnsLobbyNontxAmt'),
  (131561, NULL, NULL, 'Total Direct Lobby Amt', 'CURRENCY', 'ReturnData/AffiliatedGroupSchedule/AffiliatedScheduleGrp/TotalDirectLobbyAmt'),
  (131562, NULL, NULL, 'Total Exempt Purpose Expend Amt', 'CURRENCY', 'ReturnData/AffiliatedGroupSchedule/AffiliatedScheduleGrp/TotalExemptPurposeExpendAmt'),
  (131563, NULL, NULL, 'Total Grassroots Lobby Amt', 'CURRENCY', 'ReturnData/AffiliatedGroupSchedule/AffiliatedScheduleGrp/TotalGrassrootsLobbyAmt'),
  (131564, NULL, NULL, 'Total Lobby Expenditure Amt', 'CURRENCY', 'ReturnData/AffiliatedGroupSchedule/AffiliatedScheduleGrp/TotalLobbyExpenditureAmt'),
  (131565, NULL, NULL, 'Total Lobby Grssroot Mns Nontx Amt', 'CURRENCY', 'ReturnData/AffiliatedGroupSchedule/AffiliatedScheduleGrp/TotalLobbyGrssrootMnsNontxAmt'),
  (131566, NULL, NULL, 'Address Line1 Txt', 'TEXT', 'ReturnData/AffiliatedGroupSchedule/AffiliatedScheduleGrp/USAddress/AddressLine1Txt'),
  (131567, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/AffiliatedGroupSchedule/AffiliatedScheduleGrp/USAddress/CityNm'),
  (131568, NULL, NULL, 'State Abbreviation Cd', 'TEXT', 'ReturnData/AffiliatedGroupSchedule/AffiliatedScheduleGrp/USAddress/StateAbbreviationCd'),
  (131569, NULL, NULL, 'ZIP Cd', 'TEXT', 'ReturnData/AffiliatedGroupSchedule/AffiliatedScheduleGrp/USAddress/ZIPCd'),
  (131570, NULL, NULL, 'Electing Organization Ind', 'BOOLEAN', 'ReturnData/AffiliatedGroupSchedule/AffiliatedScheduleGrp/ElectingOrganizationInd'),
  (131571, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/AffiliatedGroupSchedule/AffiliatedScheduleGrp/USAddress/AddressLine2Txt'),
  (131572, NULL, NULL, 'Business Name Line2 Txt', 'TEXT', 'ReturnData/AffiliatedGroupSchedule/AffiliatedScheduleGrp/BusinessName/BusinessNameLine2Txt');

-- 990 / Tax Exempt Bonds Issues Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13160, 14, '111', 'Tax Exempt Bonds Issues Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131573, 13160, '1', 'CUSIP Num', 'INTEGER'),
  (131574, 13160, '2', 'Business Name Line2 Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131573, NULL, NULL, 'CUSIP Num', 'INTEGER', 'ReturnData/IRS990ScheduleK/TaxExemptBondsIssuesGrp/CUSIPNum'),
  (131574, NULL, NULL, 'Business Name Line2 Txt', 'TEXT', 'ReturnData/IRS990ScheduleK/TaxExemptBondsIssuesGrp/IssuerName/BusinessNameLine2Txt');

-- 990 / Real Estate Commercial Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13161, 14, '112', 'Real Estate Commercial Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131575, 13161, '1', 'Noncash Contributions Rpt F990 Amt', 'CURRENCY'),
  (131576, 13161, '2', 'Non Cash Checkbox Ind', 'BOOLEAN'),
  (131577, 13161, '3', 'Contribution Cnt', 'INTEGER'),
  (131578, 13161, '4', 'Method Of Determining Revenues Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131575, NULL, NULL, 'Noncash Contributions Rpt F990 Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleM/RealEstateCommercialGrp/NoncashContributionsRptF990Amt'),
  (131576, NULL, NULL, 'Non Cash Checkbox Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleM/RealEstateCommercialGrp/NonCashCheckboxInd'),
  (131577, NULL, NULL, 'Contribution Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleM/RealEstateCommercialGrp/ContributionCnt'),
  (131578, NULL, NULL, 'Method Of Determining Revenues Txt', 'TEXT', 'ReturnData/IRS990ScheduleM/RealEstateCommercialGrp/MethodOfDeterminingRevenuesTxt');

-- 990 / Total Grassroots Lobbying Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13162, 14, '113', 'Total Grassroots Lobbying Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131579, 13162, '1', 'Filing Organizations Total Amt', 'CURRENCY'),
  (131580, 13162, '2', 'Affiliated Group Total Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131579, NULL, NULL, 'Filing Organizations Total Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/TotalGrassrootsLobbyingGrp/FilingOrganizationsTotalAmt'),
  (131580, NULL, NULL, 'Affiliated Group Total Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleC/TotalGrassrootsLobbyingGrp/AffiliatedGroupTotalAmt');

-- 990 / Community Support Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13163, 14, '114', 'Community Support Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131581, 13163, '1', 'Net Community Benefit Expns Amt', 'CURRENCY'),
  (131582, 13163, '2', 'Total Expense Pct', 'PERCENT'),
  (131583, 13163, '3', 'Total Community Benefit Expns Amt', 'CURRENCY'),
  (131584, 13163, '4', 'Activities Or Programs Cnt', 'INTEGER'),
  (131585, 13163, '5', 'Direct Offsetting Revenue Amt', 'CURRENCY'),
  (131586, 13163, '6', 'Persons Served Cnt', 'INTEGER');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131581, NULL, NULL, 'Net Community Benefit Expns Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/CommunitySupportGrp/NetCommunityBenefitExpnsAmt'),
  (131582, NULL, NULL, 'Total Expense Pct', 'PERCENT', 'ReturnData/IRS990ScheduleH/CommunitySupportGrp/TotalExpensePct'),
  (131583, NULL, NULL, 'Total Community Benefit Expns Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/CommunitySupportGrp/TotalCommunityBenefitExpnsAmt'),
  (131584, NULL, NULL, 'Activities Or Programs Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleH/CommunitySupportGrp/ActivitiesOrProgramsCnt'),
  (131585, NULL, NULL, 'Direct Offsetting Revenue Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/CommunitySupportGrp/DirectOffsettingRevenueAmt'),
  (131586, NULL, NULL, 'Persons Served Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleH/CommunitySupportGrp/PersonsServedCnt');

-- 990 / Foreign Address
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13164, 14, '115', 'Foreign Address');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131587, 13164, '1', 'Address Line1 Txt', 'TEXT'),
  (131588, 13164, '2', 'Country Cd', 'TEXT'),
  (131589, 13164, '3', 'City Nm', 'TEXT'),
  (131590, 13164, '4', 'Foreign Postal Cd', 'TEXT'),
  (131591, 13164, '5', 'Province Or State Nm', 'TEXT'),
  (131592, 13164, '6', 'Address Line2 Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131587, NULL, NULL, 'Address Line1 Txt', 'TEXT', 'ReturnData/IRS990/ForeignAddress/AddressLine1Txt'),
  (131588, NULL, NULL, 'Country Cd', 'TEXT', 'ReturnData/IRS990/ForeignAddress/CountryCd'),
  (131589, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990/ForeignAddress/CityNm'),
  (131590, NULL, NULL, 'Foreign Postal Cd', 'TEXT', 'ReturnData/IRS990/ForeignAddress/ForeignPostalCd'),
  (131591, NULL, NULL, 'Province Or State Nm', 'TEXT', 'ReturnData/IRS990/ForeignAddress/ProvinceOrStateNm'),
  (131592, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/IRS990/ForeignAddress/AddressLine2Txt');

-- 990 / Unreimbursed Costs Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13165, 14, '116', 'Unreimbursed Costs Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131593, 13165, '1', 'Total Expense Pct', 'PERCENT'),
  (131594, 13165, '2', 'Net Community Benefit Expns Amt', 'CURRENCY'),
  (131595, 13165, '3', 'Total Community Benefit Expns Amt', 'CURRENCY'),
  (131596, 13165, '4', 'Direct Offsetting Revenue Amt', 'CURRENCY'),
  (131597, 13165, '5', 'Persons Served Cnt', 'INTEGER'),
  (131598, 13165, '6', 'Activities Or Programs Cnt', 'INTEGER');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131593, NULL, NULL, 'Total Expense Pct', 'PERCENT', 'ReturnData/IRS990ScheduleH/UnreimbursedCostsGrp/TotalExpensePct'),
  (131594, NULL, NULL, 'Net Community Benefit Expns Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/UnreimbursedCostsGrp/NetCommunityBenefitExpnsAmt'),
  (131595, NULL, NULL, 'Total Community Benefit Expns Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/UnreimbursedCostsGrp/TotalCommunityBenefitExpnsAmt'),
  (131596, NULL, NULL, 'Direct Offsetting Revenue Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/UnreimbursedCostsGrp/DirectOffsettingRevenueAmt'),
  (131597, NULL, NULL, 'Persons Served Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleH/UnreimbursedCostsGrp/PersonsServedCnt'),
  (131598, NULL, NULL, 'Activities Or Programs Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleH/UnreimbursedCostsGrp/ActivitiesOrProgramsCnt');

-- 990 / Real Estate Other Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13166, 14, '117', 'Real Estate Other Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131599, 13166, '1', 'Noncash Contributions Rpt F990 Amt', 'CURRENCY'),
  (131600, 13166, '2', 'Contribution Cnt', 'INTEGER'),
  (131601, 13166, '3', 'Non Cash Checkbox Ind', 'BOOLEAN'),
  (131602, 13166, '4', 'Method Of Determining Revenues Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131599, NULL, NULL, 'Noncash Contributions Rpt F990 Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleM/RealEstateOtherGrp/NoncashContributionsRptF990Amt'),
  (131600, NULL, NULL, 'Contribution Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleM/RealEstateOtherGrp/ContributionCnt'),
  (131601, NULL, NULL, 'Non Cash Checkbox Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleM/RealEstateOtherGrp/NonCashCheckboxInd'),
  (131602, NULL, NULL, 'Method Of Determining Revenues Txt', 'TEXT', 'ReturnData/IRS990ScheduleM/RealEstateOtherGrp/MethodOfDeterminingRevenuesTxt');

-- 990 / Books And Publications Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13167, 14, '118', 'Books And Publications Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131603, 13167, '1', 'Non Cash Checkbox Ind', 'BOOLEAN'),
  (131604, 13167, '2', 'Noncash Contributions Rpt F990 Amt', 'CURRENCY'),
  (131605, 13167, '3', 'Method Of Determining Revenues Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131603, NULL, NULL, 'Non Cash Checkbox Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleM/BooksAndPublicationsGrp/NonCashCheckboxInd'),
  (131604, NULL, NULL, 'Noncash Contributions Rpt F990 Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleM/BooksAndPublicationsGrp/NoncashContributionsRptF990Amt'),
  (131605, NULL, NULL, 'Method Of Determining Revenues Txt', 'TEXT', 'ReturnData/IRS990ScheduleM/BooksAndPublicationsGrp/MethodOfDeterminingRevenuesTxt');

-- 990 / Research Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13168, 14, '119', 'Research Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131606, 13168, '1', 'Net Community Benefit Expns Amt', 'CURRENCY'),
  (131607, 13168, '2', 'Total Expense Pct', 'PERCENT'),
  (131608, 13168, '3', 'Total Community Benefit Expns Amt', 'CURRENCY'),
  (131609, 13168, '4', 'Direct Offsetting Revenue Amt', 'CURRENCY'),
  (131610, 13168, '5', 'Activities Or Programs Cnt', 'INTEGER'),
  (131611, 13168, '6', 'Persons Served Cnt', 'INTEGER');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131606, NULL, NULL, 'Net Community Benefit Expns Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/ResearchGrp/NetCommunityBenefitExpnsAmt'),
  (131607, NULL, NULL, 'Total Expense Pct', 'PERCENT', 'ReturnData/IRS990ScheduleH/ResearchGrp/TotalExpensePct'),
  (131608, NULL, NULL, 'Total Community Benefit Expns Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/ResearchGrp/TotalCommunityBenefitExpnsAmt'),
  (131609, NULL, NULL, 'Direct Offsetting Revenue Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/ResearchGrp/DirectOffsettingRevenueAmt'),
  (131610, NULL, NULL, 'Activities Or Programs Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleH/ResearchGrp/ActivitiesOrProgramsCnt'),
  (131611, NULL, NULL, 'Persons Served Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleH/ResearchGrp/PersonsServedCnt');

-- 990 / Workforce Development Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13169, 14, '120', 'Workforce Development Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131612, 13169, '1', 'Net Community Benefit Expns Amt', 'CURRENCY'),
  (131613, 13169, '2', 'Total Expense Pct', 'PERCENT'),
  (131614, 13169, '3', 'Total Community Benefit Expns Amt', 'CURRENCY'),
  (131615, 13169, '4', 'Activities Or Programs Cnt', 'INTEGER'),
  (131616, 13169, '5', 'Persons Served Cnt', 'INTEGER'),
  (131617, 13169, '6', 'Direct Offsetting Revenue Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131612, NULL, NULL, 'Net Community Benefit Expns Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/WorkforceDevelopmentGrp/NetCommunityBenefitExpnsAmt'),
  (131613, NULL, NULL, 'Total Expense Pct', 'PERCENT', 'ReturnData/IRS990ScheduleH/WorkforceDevelopmentGrp/TotalExpensePct'),
  (131614, NULL, NULL, 'Total Community Benefit Expns Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/WorkforceDevelopmentGrp/TotalCommunityBenefitExpnsAmt'),
  (131615, NULL, NULL, 'Activities Or Programs Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleH/WorkforceDevelopmentGrp/ActivitiesOrProgramsCnt'),
  (131616, NULL, NULL, 'Persons Served Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleH/WorkforceDevelopmentGrp/PersonsServedCnt'),
  (131617, NULL, NULL, 'Direct Offsetting Revenue Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/WorkforceDevelopmentGrp/DirectOffsettingRevenueAmt');

-- 990 / Art Public Exhibition Amounts Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13170, 14, '121', 'Art Public Exhibition Amounts Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131618, 13170, '1', 'Assets Included Amt', 'CURRENCY'),
  (131619, 13170, '2', 'Revenues Included Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131618, NULL, NULL, 'Assets Included Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/ArtPublicExhibitionAmountsGrp/AssetsIncludedAmt'),
  (131619, NULL, NULL, 'Revenues Included Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/ArtPublicExhibitionAmountsGrp/RevenuesIncludedAmt');

-- 990 / Unrelated Org Txbl Partnership Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13171, 14, '122', 'Unrelated Org Txbl Partnership Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131620, 13171, '1', 'All Partners C3 S Ind', 'BOOLEAN'),
  (131621, 13171, '2', 'General Or Managing Partner Ind', 'BOOLEAN'),
  (131622, 13171, '3', 'Business Name Line1 Txt', 'TEXT'),
  (131623, 13171, '4', 'Disproportionate Allocations Ind', 'BOOLEAN'),
  (131624, 13171, '5', 'Address Line1 Txt', 'TEXT'),
  (131625, 13171, '6', 'City Nm', 'TEXT'),
  (131626, 13171, '7', 'State Abbreviation Cd', 'TEXT'),
  (131627, 13171, '8', 'ZIP Cd', 'TEXT'),
  (131628, 13171, '9', 'Legal Domicile State Cd', 'TEXT'),
  (131629, 13171, '10', 'EIN', 'TEXT'),
  (131630, 13171, '11', 'Ownership Pct', 'PERCENT'),
  (131631, 13171, '12', 'Primary Activities Txt', 'TEXT'),
  (131632, 13171, '13', 'Predominate Income Desc', 'TEXT'),
  (131633, 13171, '14', 'Share Of EOY Assets Amt', 'CURRENCY'),
  (131634, 13171, '15', 'Share Of Total Income Amt', 'CURRENCY'),
  (131635, 13171, '16', 'UBI Code V Amt', 'CURRENCY'),
  (131636, 13171, '17', 'Address Line2 Txt', 'TEXT'),
  (131637, 13171, '18', 'Address Line1 Txt', 'TEXT'),
  (131638, 13171, '19', 'Country Cd', 'TEXT'),
  (131639, 13171, '20', 'Foreign Postal Cd', 'TEXT'),
  (131640, 13171, '21', 'Legal Domicile Foreign Country Cd', 'TEXT'),
  (131641, 13171, '22', 'City Nm', 'TEXT'),
  (131642, 13171, '23', 'Province Or State Nm', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131620, NULL, NULL, 'All Partners C3 S Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleR/UnrelatedOrgTxblPartnershipGrp/AllPartnersC3SInd'),
  (131621, NULL, NULL, 'General Or Managing Partner Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleR/UnrelatedOrgTxblPartnershipGrp/GeneralOrManagingPartnerInd'),
  (131622, NULL, NULL, 'Business Name Line1 Txt', 'TEXT', 'ReturnData/IRS990ScheduleR/UnrelatedOrgTxblPartnershipGrp/BusinessName/BusinessNameLine1Txt'),
  (131623, NULL, NULL, 'Disproportionate Allocations Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleR/UnrelatedOrgTxblPartnershipGrp/DisproportionateAllocationsInd'),
  (131624, NULL, NULL, 'Address Line1 Txt', 'TEXT', 'ReturnData/IRS990ScheduleR/UnrelatedOrgTxblPartnershipGrp/USAddress/AddressLine1Txt'),
  (131625, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990ScheduleR/UnrelatedOrgTxblPartnershipGrp/USAddress/CityNm'),
  (131626, NULL, NULL, 'State Abbreviation Cd', 'TEXT', 'ReturnData/IRS990ScheduleR/UnrelatedOrgTxblPartnershipGrp/USAddress/StateAbbreviationCd'),
  (131627, NULL, NULL, 'ZIP Cd', 'TEXT', 'ReturnData/IRS990ScheduleR/UnrelatedOrgTxblPartnershipGrp/USAddress/ZIPCd'),
  (131628, NULL, NULL, 'Legal Domicile State Cd', 'TEXT', 'ReturnData/IRS990ScheduleR/UnrelatedOrgTxblPartnershipGrp/LegalDomicileStateCd'),
  (131629, NULL, NULL, 'EIN', 'TEXT', 'ReturnData/IRS990ScheduleR/UnrelatedOrgTxblPartnershipGrp/EIN'),
  (131630, NULL, NULL, 'Ownership Pct', 'PERCENT', 'ReturnData/IRS990ScheduleR/UnrelatedOrgTxblPartnershipGrp/OwnershipPct'),
  (131631, NULL, NULL, 'Primary Activities Txt', 'TEXT', 'ReturnData/IRS990ScheduleR/UnrelatedOrgTxblPartnershipGrp/PrimaryActivitiesTxt'),
  (131632, NULL, NULL, 'Predominate Income Desc', 'TEXT', 'ReturnData/IRS990ScheduleR/UnrelatedOrgTxblPartnershipGrp/PredominateIncomeDesc'),
  (131633, NULL, NULL, 'Share Of EOY Assets Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleR/UnrelatedOrgTxblPartnershipGrp/ShareOfEOYAssetsAmt'),
  (131634, NULL, NULL, 'Share Of Total Income Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleR/UnrelatedOrgTxblPartnershipGrp/ShareOfTotalIncomeAmt'),
  (131635, NULL, NULL, 'UBI Code V Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleR/UnrelatedOrgTxblPartnershipGrp/UBICodeVAmt'),
  (131636, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/IRS990ScheduleR/UnrelatedOrgTxblPartnershipGrp/USAddress/AddressLine2Txt'),
  (131637, NULL, NULL, 'Address Line1 Txt', 'TEXT', 'ReturnData/IRS990ScheduleR/UnrelatedOrgTxblPartnershipGrp/ForeignAddress/AddressLine1Txt'),
  (131638, NULL, NULL, 'Country Cd', 'TEXT', 'ReturnData/IRS990ScheduleR/UnrelatedOrgTxblPartnershipGrp/ForeignAddress/CountryCd'),
  (131639, NULL, NULL, 'Foreign Postal Cd', 'TEXT', 'ReturnData/IRS990ScheduleR/UnrelatedOrgTxblPartnershipGrp/ForeignAddress/ForeignPostalCd'),
  (131640, NULL, NULL, 'Legal Domicile Foreign Country Cd', 'TEXT', 'ReturnData/IRS990ScheduleR/UnrelatedOrgTxblPartnershipGrp/LegalDomicileForeignCountryCd'),
  (131641, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990ScheduleR/UnrelatedOrgTxblPartnershipGrp/ForeignAddress/CityNm'),
  (131642, NULL, NULL, 'Province Or State Nm', 'TEXT', 'ReturnData/IRS990ScheduleR/UnrelatedOrgTxblPartnershipGrp/ForeignAddress/ProvinceOrStateNm');

-- 990 / Third Party US Address
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13172, 14, '123', 'Third Party US Address');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131643, 13172, '1', 'Address Line1 Txt', 'TEXT'),
  (131644, 13172, '2', 'City Nm', 'TEXT'),
  (131645, 13172, '3', 'State Abbreviation Cd', 'TEXT'),
  (131646, 13172, '4', 'ZIP Cd', 'TEXT'),
  (131647, 13172, '5', 'Address Line2 Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131643, NULL, NULL, 'Address Line1 Txt', 'TEXT', 'ReturnData/IRS990ScheduleG/ThirdPartyUSAddress/AddressLine1Txt'),
  (131644, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990ScheduleG/ThirdPartyUSAddress/CityNm'),
  (131645, NULL, NULL, 'State Abbreviation Cd', 'TEXT', 'ReturnData/IRS990ScheduleG/ThirdPartyUSAddress/StateAbbreviationCd'),
  (131646, NULL, NULL, 'ZIP Cd', 'TEXT', 'ReturnData/IRS990ScheduleG/ThirdPartyUSAddress/ZIPCd'),
  (131647, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/IRS990ScheduleG/ThirdPartyUSAddress/AddressLine2Txt');

-- 990 / Closely Held Equity Interests Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13173, 14, '124', 'Closely Held Equity Interests Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131648, 13173, '1', 'Book Value Amt', 'CURRENCY'),
  (131649, 13173, '2', 'Method Valuation Cd', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131648, NULL, NULL, 'Book Value Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/CloselyHeldEquityInterestsGrp/BookValueAmt'),
  (131649, NULL, NULL, 'Method Valuation Cd', 'TEXT', 'ReturnData/IRS990ScheduleD/CloselyHeldEquityInterestsGrp/MethodValuationCd');

-- 990 / Coalition Building Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13174, 14, '125', 'Coalition Building Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131650, 13174, '1', 'Net Community Benefit Expns Amt', 'CURRENCY'),
  (131651, 13174, '2', 'Total Expense Pct', 'PERCENT'),
  (131652, 13174, '3', 'Total Community Benefit Expns Amt', 'CURRENCY'),
  (131653, 13174, '4', 'Activities Or Programs Cnt', 'INTEGER'),
  (131654, 13174, '5', 'Direct Offsetting Revenue Amt', 'CURRENCY'),
  (131655, 13174, '6', 'Persons Served Cnt', 'INTEGER');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131650, NULL, NULL, 'Net Community Benefit Expns Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/CoalitionBuildingGrp/NetCommunityBenefitExpnsAmt'),
  (131651, NULL, NULL, 'Total Expense Pct', 'PERCENT', 'ReturnData/IRS990ScheduleH/CoalitionBuildingGrp/TotalExpensePct'),
  (131652, NULL, NULL, 'Total Community Benefit Expns Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/CoalitionBuildingGrp/TotalCommunityBenefitExpnsAmt'),
  (131653, NULL, NULL, 'Activities Or Programs Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleH/CoalitionBuildingGrp/ActivitiesOrProgramsCnt'),
  (131654, NULL, NULL, 'Direct Offsetting Revenue Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/CoalitionBuildingGrp/DirectOffsettingRevenueAmt'),
  (131655, NULL, NULL, 'Persons Served Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleH/CoalitionBuildingGrp/PersonsServedCnt');

-- 990 / Health Improvement Advocacy Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13175, 14, '126', 'Health Improvement Advocacy Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131656, 13175, '1', 'Net Community Benefit Expns Amt', 'CURRENCY'),
  (131657, 13175, '2', 'Total Expense Pct', 'PERCENT'),
  (131658, 13175, '3', 'Total Community Benefit Expns Amt', 'CURRENCY'),
  (131659, 13175, '4', 'Direct Offsetting Revenue Amt', 'CURRENCY'),
  (131660, 13175, '5', 'Activities Or Programs Cnt', 'INTEGER'),
  (131661, 13175, '6', 'Persons Served Cnt', 'INTEGER');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131656, NULL, NULL, 'Net Community Benefit Expns Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/HealthImprovementAdvocacyGrp/NetCommunityBenefitExpnsAmt'),
  (131657, NULL, NULL, 'Total Expense Pct', 'PERCENT', 'ReturnData/IRS990ScheduleH/HealthImprovementAdvocacyGrp/TotalExpensePct'),
  (131658, NULL, NULL, 'Total Community Benefit Expns Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/HealthImprovementAdvocacyGrp/TotalCommunityBenefitExpnsAmt'),
  (131659, NULL, NULL, 'Direct Offsetting Revenue Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/HealthImprovementAdvocacyGrp/DirectOffsettingRevenueAmt'),
  (131660, NULL, NULL, 'Activities Or Programs Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleH/HealthImprovementAdvocacyGrp/ActivitiesOrProgramsCnt'),
  (131661, NULL, NULL, 'Persons Served Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleH/HealthImprovementAdvocacyGrp/PersonsServedCnt');

-- 990 / Economic Development Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13176, 14, '127', 'Economic Development Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131662, 13176, '1', 'Net Community Benefit Expns Amt', 'CURRENCY'),
  (131663, 13176, '2', 'Total Expense Pct', 'PERCENT'),
  (131664, 13176, '3', 'Total Community Benefit Expns Amt', 'CURRENCY'),
  (131665, 13176, '4', 'Activities Or Programs Cnt', 'INTEGER'),
  (131666, 13176, '5', 'Direct Offsetting Revenue Amt', 'CURRENCY'),
  (131667, 13176, '6', 'Persons Served Cnt', 'INTEGER');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131662, NULL, NULL, 'Net Community Benefit Expns Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/EconomicDevelopmentGrp/NetCommunityBenefitExpnsAmt'),
  (131663, NULL, NULL, 'Total Expense Pct', 'PERCENT', 'ReturnData/IRS990ScheduleH/EconomicDevelopmentGrp/TotalExpensePct'),
  (131664, NULL, NULL, 'Total Community Benefit Expns Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/EconomicDevelopmentGrp/TotalCommunityBenefitExpnsAmt'),
  (131665, NULL, NULL, 'Activities Or Programs Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleH/EconomicDevelopmentGrp/ActivitiesOrProgramsCnt'),
  (131666, NULL, NULL, 'Direct Offsetting Revenue Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/EconomicDevelopmentGrp/DirectOffsettingRevenueAmt'),
  (131667, NULL, NULL, 'Persons Served Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleH/EconomicDevelopmentGrp/PersonsServedCnt');

-- 990 / Costing Methodology Used Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13177, 14, '128', 'Costing Methodology Used Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131668, 13177, '1', 'Cost To Charge Ratio Ind', 'BOOLEAN'),
  (131669, 13177, '2', 'Other Ind', 'BOOLEAN'),
  (131670, 13177, '3', 'Cost Accounting System Ind', 'BOOLEAN');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131668, NULL, NULL, 'Cost To Charge Ratio Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/CostingMethodologyUsedGrp/CostToChargeRatioInd'),
  (131669, NULL, NULL, 'Other Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/CostingMethodologyUsedGrp/OtherInd'),
  (131670, NULL, NULL, 'Cost Accounting System Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/CostingMethodologyUsedGrp/CostAccountingSystemInd');

-- 990 / Supplemental Information Detail
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13178, 14, '129', 'Supplemental Information Detail');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131671, 13178, '1', 'Form And Line Reference Desc', 'TEXT'),
  (131672, 13178, '2', 'Explanation Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131671, NULL, NULL, 'Form And Line Reference Desc', 'TEXT', 'ReturnData/IRS990ScheduleN/SupplementalInformationDetail/FormAndLineReferenceDesc'),
  (131672, NULL, NULL, 'Explanation Txt', 'TEXT', 'ReturnData/IRS990ScheduleN/SupplementalInformationDetail/ExplanationTxt');

-- 990 / Leadership Development Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13179, 14, '130', 'Leadership Development Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131673, 13179, '1', 'Net Community Benefit Expns Amt', 'CURRENCY'),
  (131674, 13179, '2', 'Total Expense Pct', 'PERCENT'),
  (131675, 13179, '3', 'Total Community Benefit Expns Amt', 'CURRENCY'),
  (131676, 13179, '4', 'Direct Offsetting Revenue Amt', 'CURRENCY'),
  (131677, 13179, '5', 'Activities Or Programs Cnt', 'INTEGER'),
  (131678, 13179, '6', 'Persons Served Cnt', 'INTEGER');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131673, NULL, NULL, 'Net Community Benefit Expns Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/LeadershipDevelopmentGrp/NetCommunityBenefitExpnsAmt'),
  (131674, NULL, NULL, 'Total Expense Pct', 'PERCENT', 'ReturnData/IRS990ScheduleH/LeadershipDevelopmentGrp/TotalExpensePct'),
  (131675, NULL, NULL, 'Total Community Benefit Expns Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/LeadershipDevelopmentGrp/TotalCommunityBenefitExpnsAmt'),
  (131676, NULL, NULL, 'Direct Offsetting Revenue Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/LeadershipDevelopmentGrp/DirectOffsettingRevenueAmt'),
  (131677, NULL, NULL, 'Activities Or Programs Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleH/LeadershipDevelopmentGrp/ActivitiesOrProgramsCnt'),
  (131678, NULL, NULL, 'Persons Served Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleH/LeadershipDevelopmentGrp/PersonsServedCnt');

-- 990 / Physical Imprv And Housing Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13180, 14, '131', 'Physical Imprv And Housing Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131679, 13180, '1', 'Total Expense Pct', 'PERCENT'),
  (131680, 13180, '2', 'Net Community Benefit Expns Amt', 'CURRENCY'),
  (131681, 13180, '3', 'Total Community Benefit Expns Amt', 'CURRENCY'),
  (131682, 13180, '4', 'Direct Offsetting Revenue Amt', 'CURRENCY'),
  (131683, 13180, '5', 'Activities Or Programs Cnt', 'INTEGER'),
  (131684, 13180, '6', 'Persons Served Cnt', 'INTEGER');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131679, NULL, NULL, 'Total Expense Pct', 'PERCENT', 'ReturnData/IRS990ScheduleH/PhysicalImprvAndHousingGrp/TotalExpensePct'),
  (131680, NULL, NULL, 'Net Community Benefit Expns Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/PhysicalImprvAndHousingGrp/NetCommunityBenefitExpnsAmt'),
  (131681, NULL, NULL, 'Total Community Benefit Expns Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/PhysicalImprvAndHousingGrp/TotalCommunityBenefitExpnsAmt'),
  (131682, NULL, NULL, 'Direct Offsetting Revenue Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/PhysicalImprvAndHousingGrp/DirectOffsettingRevenueAmt'),
  (131683, NULL, NULL, 'Activities Or Programs Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleH/PhysicalImprvAndHousingGrp/ActivitiesOrProgramsCnt'),
  (131684, NULL, NULL, 'Persons Served Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleH/PhysicalImprvAndHousingGrp/PersonsServedCnt');

-- 990 / Environmental Improvements Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13181, 14, '132', 'Environmental Improvements Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131685, 13181, '1', 'Net Community Benefit Expns Amt', 'CURRENCY'),
  (131686, 13181, '2', 'Total Expense Pct', 'PERCENT'),
  (131687, 13181, '3', 'Total Community Benefit Expns Amt', 'CURRENCY'),
  (131688, 13181, '4', 'Direct Offsetting Revenue Amt', 'CURRENCY'),
  (131689, 13181, '5', 'Activities Or Programs Cnt', 'INTEGER'),
  (131690, 13181, '6', 'Persons Served Cnt', 'INTEGER');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131685, NULL, NULL, 'Net Community Benefit Expns Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/EnvironmentalImprovementsGrp/NetCommunityBenefitExpnsAmt'),
  (131686, NULL, NULL, 'Total Expense Pct', 'PERCENT', 'ReturnData/IRS990ScheduleH/EnvironmentalImprovementsGrp/TotalExpensePct'),
  (131687, NULL, NULL, 'Total Community Benefit Expns Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/EnvironmentalImprovementsGrp/TotalCommunityBenefitExpnsAmt'),
  (131688, NULL, NULL, 'Direct Offsetting Revenue Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/EnvironmentalImprovementsGrp/DirectOffsettingRevenueAmt'),
  (131689, NULL, NULL, 'Activities Or Programs Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleH/EnvironmentalImprovementsGrp/ActivitiesOrProgramsCnt'),
  (131690, NULL, NULL, 'Persons Served Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleH/EnvironmentalImprovementsGrp/PersonsServedCnt');

-- 990 / Other Communtity Building Acty Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13182, 14, '133', 'Other Communtity Building Acty Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131691, 13182, '1', 'Total Expense Pct', 'PERCENT'),
  (131692, 13182, '2', 'Net Community Benefit Expns Amt', 'CURRENCY'),
  (131693, 13182, '3', 'Total Community Benefit Expns Amt', 'CURRENCY'),
  (131694, 13182, '4', 'Direct Offsetting Revenue Amt', 'CURRENCY'),
  (131695, 13182, '5', 'Activities Or Programs Cnt', 'INTEGER'),
  (131696, 13182, '6', 'Persons Served Cnt', 'INTEGER');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131691, NULL, NULL, 'Total Expense Pct', 'PERCENT', 'ReturnData/IRS990ScheduleH/OtherCommuntityBuildingActyGrp/TotalExpensePct'),
  (131692, NULL, NULL, 'Net Community Benefit Expns Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/OtherCommuntityBuildingActyGrp/NetCommunityBenefitExpnsAmt'),
  (131693, NULL, NULL, 'Total Community Benefit Expns Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/OtherCommuntityBuildingActyGrp/TotalCommunityBenefitExpnsAmt'),
  (131694, NULL, NULL, 'Direct Offsetting Revenue Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleH/OtherCommuntityBuildingActyGrp/DirectOffsettingRevenueAmt'),
  (131695, NULL, NULL, 'Activities Or Programs Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleH/OtherCommuntityBuildingActyGrp/ActivitiesOrProgramsCnt'),
  (131696, NULL, NULL, 'Persons Served Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleH/OtherCommuntityBuildingActyGrp/PersonsServedCnt');

-- 990 / Collectibles Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13183, 14, '134', 'Collectibles Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131697, 13183, '1', 'Contribution Cnt', 'INTEGER'),
  (131698, 13183, '2', 'Non Cash Checkbox Ind', 'BOOLEAN'),
  (131699, 13183, '3', 'Noncash Contributions Rpt F990 Amt', 'CURRENCY'),
  (131700, 13183, '4', 'Method Of Determining Revenues Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131697, NULL, NULL, 'Contribution Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleM/CollectiblesGrp/ContributionCnt'),
  (131698, NULL, NULL, 'Non Cash Checkbox Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleM/CollectiblesGrp/NonCashCheckboxInd'),
  (131699, NULL, NULL, 'Noncash Contributions Rpt F990 Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleM/CollectiblesGrp/NoncashContributionsRptF990Amt'),
  (131700, NULL, NULL, 'Method Of Determining Revenues Txt', 'TEXT', 'ReturnData/IRS990ScheduleM/CollectiblesGrp/MethodOfDeterminingRevenuesTxt');

-- 990 / Management Co And Jnt Ventures Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13184, 14, '135', 'Management Co And Jnt Ventures Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131701, 13184, '1', 'Business Name Line1 Txt', 'TEXT'),
  (131702, 13184, '2', 'Primary Activities Txt', 'TEXT'),
  (131703, 13184, '3', 'Org Profit Or Ownership Pct', 'PERCENT'),
  (131704, 13184, '4', 'Physicians Profit Or Ownership Pct', 'PERCENT'),
  (131705, 13184, '5', 'Ofcr Etc Profit Or Ownership Pct', 'PERCENT'),
  (131706, 13184, '6', 'Business Name Line2 Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131701, NULL, NULL, 'Business Name Line1 Txt', 'TEXT', 'ReturnData/IRS990ScheduleH/ManagementCoAndJntVenturesGrp/EntityName/BusinessNameLine1Txt'),
  (131702, NULL, NULL, 'Primary Activities Txt', 'TEXT', 'ReturnData/IRS990ScheduleH/ManagementCoAndJntVenturesGrp/PrimaryActivitiesTxt'),
  (131703, NULL, NULL, 'Org Profit Or Ownership Pct', 'PERCENT', 'ReturnData/IRS990ScheduleH/ManagementCoAndJntVenturesGrp/OrgProfitOrOwnershipPct'),
  (131704, NULL, NULL, 'Physicians Profit Or Ownership Pct', 'PERCENT', 'ReturnData/IRS990ScheduleH/ManagementCoAndJntVenturesGrp/PhysiciansProfitOrOwnershipPct'),
  (131705, NULL, NULL, 'Ofcr Etc Profit Or Ownership Pct', 'PERCENT', 'ReturnData/IRS990ScheduleH/ManagementCoAndJntVenturesGrp/OfcrEtcProfitOrOwnershipPct'),
  (131706, NULL, NULL, 'Business Name Line2 Txt', 'TEXT', 'ReturnData/IRS990ScheduleH/ManagementCoAndJntVenturesGrp/EntityName/BusinessNameLine2Txt');

-- 990 / Free Care Oth Percentage Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13185, 14, '136', 'Free Care Oth Percentage Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131707, 13185, '1', 'Free Care Other Pct', 'PERCENT'),
  (131708, 13185, '2', 'Other Ind', 'BOOLEAN');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131707, NULL, NULL, 'Free Care Other Pct', 'PERCENT', 'ReturnData/IRS990ScheduleH/FreeCareOthPercentageGrp/FreeCareOtherPct'),
  (131708, NULL, NULL, 'Other Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/FreeCareOthPercentageGrp/OtherInd');

-- 990 / Distribution Allocations Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13186, 14, '137', 'Distribution Allocations Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131709, 13186, '1', 'CY Distri App Distributable Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131709, NULL, NULL, 'CY Distri App Distributable Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleA/DistributionAllocationsGrp/CYDistriAppDistributableAmt');

-- 990 / Persons With Books Name
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13187, 14, '138', 'Persons With Books Name');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131710, 13187, '1', 'Business Name Line1 Txt', 'TEXT'),
  (131711, 13187, '2', 'Business Name Line2 Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131710, NULL, NULL, 'Business Name Line1 Txt', 'TEXT', 'ReturnData/IRS990ScheduleG/PersonsWithBooksName/BusinessNameLine1Txt'),
  (131711, NULL, NULL, 'Business Name Line2 Txt', 'TEXT', 'ReturnData/IRS990ScheduleG/PersonsWithBooksName/BusinessNameLine2Txt');

-- 990 / Financial Derivatives Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13188, 14, '139', 'Financial Derivatives Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131712, 13188, '1', 'Book Value Amt', 'CURRENCY'),
  (131713, 13188, '2', 'Method Valuation Cd', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131712, NULL, NULL, 'Book Value Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/FinancialDerivativesGrp/BookValueAmt'),
  (131713, NULL, NULL, 'Method Valuation Cd', 'TEXT', 'ReturnData/IRS990ScheduleD/FinancialDerivativesGrp/MethodValuationCd');

-- 990 / Form990 Sch A Supporting Org Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13189, 14, '140', 'Form990 Sch A Supporting Org Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131714, 13189, '1', 'Excess Business Holdings Ind', 'BOOLEAN'),
  (131715, 13189, '2', 'Supported Org Class Designated Ind', 'BOOLEAN'),
  (131716, 13189, '3', 'Support Foreign Org No Determ Ind', 'BOOLEAN'),
  (131717, 13189, '4', 'Control Deciding Grnt Frgn Org Ind', 'BOOLEAN'),
  (131718, 13189, '5', 'Substitution Beyond Org Cntl Ind', 'BOOLEAN');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131714, NULL, NULL, 'Excess Business Holdings Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/Form990SchASupportingOrgGrp/ExcessBusinessHoldingsInd'),
  (131715, NULL, NULL, 'Supported Org Class Designated Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/Form990SchASupportingOrgGrp/SupportedOrgClassDesignatedInd'),
  (131716, NULL, NULL, 'Support Foreign Org No Determ Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/Form990SchASupportingOrgGrp/SupportForeignOrgNoDetermInd'),
  (131717, NULL, NULL, 'Control Deciding Grnt Frgn Org Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/Form990SchASupportingOrgGrp/ControlDecidingGrntFrgnOrgInd'),
  (131718, NULL, NULL, 'Substitution Beyond Org Cntl Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/Form990SchASupportingOrgGrp/SubstitutionBeyondOrgCntlInd');

-- 990 / Grnt Asst Bnft Interested Prsn Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13190, 14, '141', 'Grnt Asst Bnft Interested Prsn Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131719, 13190, '1', 'Assistance Purpose Txt', 'TEXT'),
  (131720, 13190, '2', 'Business Name Line1 Txt', 'TEXT'),
  (131721, 13190, '3', 'Business Name Line2 Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131719, NULL, NULL, 'Assistance Purpose Txt', 'TEXT', 'ReturnData/IRS990ScheduleL/GrntAsstBnftInterestedPrsnGrp/AssistancePurposeTxt'),
  (131720, NULL, NULL, 'Business Name Line1 Txt', 'TEXT', 'ReturnData/IRS990ScheduleL/GrntAsstBnftInterestedPrsnGrp/BusinessName/BusinessNameLine1Txt'),
  (131721, NULL, NULL, 'Business Name Line2 Txt', 'TEXT', 'ReturnData/IRS990ScheduleL/GrntAsstBnftInterestedPrsnGrp/BusinessName/BusinessNameLine2Txt');

-- 990 / Held Works Art Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13191, 14, '142', 'Held Works Art Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131722, 13191, '1', 'Assets Included Amt', 'CURRENCY'),
  (131723, 13191, '2', 'Revenues Included Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131722, NULL, NULL, 'Assets Included Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/HeldWorksArtGrp/AssetsIncludedAmt'),
  (131723, NULL, NULL, 'Revenues Included Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleD/HeldWorksArtGrp/RevenuesIncludedAmt');

-- 990 / Affiliate Listing Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13192, 14, '143', 'Affiliate Listing Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131724, 13192, '1', 'Business Name Line1 Txt', 'TEXT'),
  (131725, 13192, '2', 'Business Name Control Txt', 'TEXT'),
  (131726, 13192, '3', 'EIN', 'TEXT'),
  (131727, 13192, '4', 'Address Line1 Txt', 'TEXT'),
  (131728, 13192, '5', 'City Nm', 'TEXT'),
  (131729, 13192, '6', 'State Abbreviation Cd', 'TEXT'),
  (131730, 13192, '7', 'ZIP Cd', 'TEXT'),
  (131731, 13192, '8', 'Business Name Line2 Txt', 'TEXT'),
  (131732, 13192, '9', 'Address Line2 Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131724, NULL, NULL, 'Business Name Line1 Txt', 'TEXT', 'ReturnData/AffiliateListing/AffiliateListingGrp/BusinessName/BusinessNameLine1Txt'),
  (131725, NULL, NULL, 'Business Name Control Txt', 'TEXT', 'ReturnData/AffiliateListing/AffiliateListingGrp/BusinessNameControlTxt'),
  (131726, NULL, NULL, 'EIN', 'TEXT', 'ReturnData/AffiliateListing/AffiliateListingGrp/EIN'),
  (131727, NULL, NULL, 'Address Line1 Txt', 'TEXT', 'ReturnData/AffiliateListing/AffiliateListingGrp/USAddress/AddressLine1Txt'),
  (131728, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/AffiliateListing/AffiliateListingGrp/USAddress/CityNm'),
  (131729, NULL, NULL, 'State Abbreviation Cd', 'TEXT', 'ReturnData/AffiliateListing/AffiliateListingGrp/USAddress/StateAbbreviationCd'),
  (131730, NULL, NULL, 'ZIP Cd', 'TEXT', 'ReturnData/AffiliateListing/AffiliateListingGrp/USAddress/ZIPCd'),
  (131731, NULL, NULL, 'Business Name Line2 Txt', 'TEXT', 'ReturnData/AffiliateListing/AffiliateListingGrp/BusinessName/BusinessNameLine2Txt'),
  (131732, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/AffiliateListing/AffiliateListingGrp/USAddress/AddressLine2Txt');

-- 990 / Collection Used Other Purposes Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13193, 14, '144', 'Collection Used Other Purposes Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131733, 13193, '1', 'Collection Used Other Purposes Ind', 'BOOLEAN'),
  (131734, 13193, '2', 'Other Purposes Desc', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131733, NULL, NULL, 'Collection Used Other Purposes Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleD/CollectionUsedOtherPurposesGrp/CollectionUsedOtherPurposesInd'),
  (131734, NULL, NULL, 'Other Purposes Desc', 'TEXT', 'ReturnData/IRS990ScheduleD/CollectionUsedOtherPurposesGrp/OtherPurposesDesc');

-- 990 / Hospital Name And Address Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13194, 14, '145', 'Hospital Name And Address Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131735, 13194, '1', 'City Nm', 'TEXT'),
  (131736, 13194, '2', 'Business Name Line1 Txt', 'TEXT'),
  (131737, 13194, '3', 'State Abbreviation Cd', 'TEXT'),
  (131738, 13194, '4', 'Business Name Line2 Txt', 'TEXT'),
  (131739, 13194, '5', 'Country Cd', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131735, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990ScheduleA/HospitalNameAndAddressGrp/CityNm'),
  (131736, NULL, NULL, 'Business Name Line1 Txt', 'TEXT', 'ReturnData/IRS990ScheduleA/HospitalNameAndAddressGrp/SupportedOrganizationName/BusinessNameLine1Txt'),
  (131737, NULL, NULL, 'State Abbreviation Cd', 'TEXT', 'ReturnData/IRS990ScheduleA/HospitalNameAndAddressGrp/StateAbbreviationCd'),
  (131738, NULL, NULL, 'Business Name Line2 Txt', 'TEXT', 'ReturnData/IRS990ScheduleA/HospitalNameAndAddressGrp/SupportedOrganizationName/BusinessNameLine2Txt'),
  (131739, NULL, NULL, 'Country Cd', 'TEXT', 'ReturnData/IRS990ScheduleA/HospitalNameAndAddressGrp/CountryCd');

-- 990 / Securities Miscellaneous Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13195, 14, '146', 'Securities Miscellaneous Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131740, 13195, '1', 'Noncash Contributions Rpt F990 Amt', 'CURRENCY'),
  (131741, 13195, '2', 'Non Cash Checkbox Ind', 'BOOLEAN'),
  (131742, 13195, '3', 'Contribution Cnt', 'INTEGER'),
  (131743, 13195, '4', 'Method Of Determining Revenues Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131740, NULL, NULL, 'Noncash Contributions Rpt F990 Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleM/SecuritiesMiscellaneousGrp/NoncashContributionsRptF990Amt'),
  (131741, NULL, NULL, 'Non Cash Checkbox Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleM/SecuritiesMiscellaneousGrp/NonCashCheckboxInd'),
  (131742, NULL, NULL, 'Contribution Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleM/SecuritiesMiscellaneousGrp/ContributionCnt'),
  (131743, NULL, NULL, 'Method Of Determining Revenues Txt', 'TEXT', 'ReturnData/IRS990ScheduleM/SecuritiesMiscellaneousGrp/MethodOfDeterminingRevenuesTxt');

-- 990 / Securities Closely Held Stock Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13196, 14, '147', 'Securities Closely Held Stock Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131744, 13196, '1', 'Noncash Contributions Rpt F990 Amt', 'CURRENCY'),
  (131745, 13196, '2', 'Contribution Cnt', 'INTEGER'),
  (131746, 13196, '3', 'Method Of Determining Revenues Txt', 'TEXT'),
  (131747, 13196, '4', 'Non Cash Checkbox Ind', 'BOOLEAN');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131744, NULL, NULL, 'Noncash Contributions Rpt F990 Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleM/SecuritiesCloselyHeldStockGrp/NoncashContributionsRptF990Amt'),
  (131745, NULL, NULL, 'Contribution Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleM/SecuritiesCloselyHeldStockGrp/ContributionCnt'),
  (131746, NULL, NULL, 'Method Of Determining Revenues Txt', 'TEXT', 'ReturnData/IRS990ScheduleM/SecuritiesCloselyHeldStockGrp/MethodOfDeterminingRevenuesTxt'),
  (131747, NULL, NULL, 'Non Cash Checkbox Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleM/SecuritiesCloselyHeldStockGrp/NonCashCheckboxInd');

-- 990 / Special Condition Desc
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13197, 14, '148', 'Special Condition Desc');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131748, 13197, '1', 'Special Condition Desc', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131748, NULL, NULL, 'Special Condition Desc', 'TEXT', 'ReturnData/IRS990/SpecialConditionDesc');

-- 990 / Secur Prtnrshp Trust Intrsts Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13198, 14, '149', 'Secur Prtnrshp Trust Intrsts Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131749, 13198, '1', 'Noncash Contributions Rpt F990 Amt', 'CURRENCY'),
  (131750, 13198, '2', 'Contribution Cnt', 'INTEGER'),
  (131751, 13198, '3', 'Method Of Determining Revenues Txt', 'TEXT'),
  (131752, 13198, '4', 'Non Cash Checkbox Ind', 'BOOLEAN');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131749, NULL, NULL, 'Noncash Contributions Rpt F990 Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleM/SecurPrtnrshpTrustIntrstsGrp/NoncashContributionsRptF990Amt'),
  (131750, NULL, NULL, 'Contribution Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleM/SecurPrtnrshpTrustIntrstsGrp/ContributionCnt'),
  (131751, NULL, NULL, 'Method Of Determining Revenues Txt', 'TEXT', 'ReturnData/IRS990ScheduleM/SecurPrtnrshpTrustIntrstsGrp/MethodOfDeterminingRevenuesTxt'),
  (131752, NULL, NULL, 'Non Cash Checkbox Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleM/SecurPrtnrshpTrustIntrstsGrp/NonCashCheckboxInd');

-- 990 / Discounted Care Oth Percentage Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13199, 14, '150', 'Discounted Care Oth Percentage Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131753, 13199, '1', 'Discounted Care Other Pct', 'PERCENT'),
  (131754, 13199, '2', 'Other Ind', 'BOOLEAN');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131753, NULL, NULL, 'Discounted Care Other Pct', 'PERCENT', 'ReturnData/IRS990ScheduleH/DiscountedCareOthPercentageGrp/DiscountedCareOtherPct'),
  (131754, NULL, NULL, 'Other Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleH/DiscountedCareOthPercentageGrp/OtherInd');

-- 990 / Transactions Related Org Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13200, 14, '151', 'Transactions Related Org Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131755, 13200, '1', 'Business Name Line2 Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131755, NULL, NULL, 'Business Name Line2 Txt', 'TEXT', 'ReturnData/IRS990ScheduleR/TransactionsRelatedOrgGrp/OtherOrganizationName/BusinessNameLine2Txt');

-- 990 / Boats And Planes Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13201, 14, '152', 'Boats And Planes Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131756, 13201, '1', 'Noncash Contributions Rpt F990 Amt', 'CURRENCY'),
  (131757, 13201, '2', 'Contribution Cnt', 'INTEGER'),
  (131758, 13201, '3', 'Non Cash Checkbox Ind', 'BOOLEAN'),
  (131759, 13201, '4', 'Method Of Determining Revenues Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131756, NULL, NULL, 'Noncash Contributions Rpt F990 Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleM/BoatsAndPlanesGrp/NoncashContributionsRptF990Amt'),
  (131757, NULL, NULL, 'Contribution Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleM/BoatsAndPlanesGrp/ContributionCnt'),
  (131758, NULL, NULL, 'Non Cash Checkbox Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleM/BoatsAndPlanesGrp/NonCashCheckboxInd'),
  (131759, NULL, NULL, 'Method Of Determining Revenues Txt', 'TEXT', 'ReturnData/IRS990ScheduleM/BoatsAndPlanesGrp/MethodOfDeterminingRevenuesTxt');

-- 990 / Historical Artifacts Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13202, 14, '153', 'Historical Artifacts Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131760, 13202, '1', 'Non Cash Checkbox Ind', 'BOOLEAN'),
  (131761, 13202, '2', 'Contribution Cnt', 'INTEGER'),
  (131762, 13202, '3', 'Method Of Determining Revenues Txt', 'TEXT'),
  (131763, 13202, '4', 'Noncash Contributions Rpt F990 Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131760, NULL, NULL, 'Non Cash Checkbox Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleM/HistoricalArtifactsGrp/NonCashCheckboxInd'),
  (131761, NULL, NULL, 'Contribution Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleM/HistoricalArtifactsGrp/ContributionCnt'),
  (131762, NULL, NULL, 'Method Of Determining Revenues Txt', 'TEXT', 'ReturnData/IRS990ScheduleM/HistoricalArtifactsGrp/MethodOfDeterminingRevenuesTxt'),
  (131763, NULL, NULL, 'Noncash Contributions Rpt F990 Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleM/HistoricalArtifactsGrp/NoncashContributionsRptF990Amt');

-- 990 / Qualified Contrib Other Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13203, 14, '154', 'Qualified Contrib Other Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131764, 13203, '1', 'Contribution Cnt', 'INTEGER'),
  (131765, 13203, '2', 'Non Cash Checkbox Ind', 'BOOLEAN'),
  (131766, 13203, '3', 'Method Of Determining Revenues Txt', 'TEXT'),
  (131767, 13203, '4', 'Noncash Contributions Rpt F990 Amt', 'CURRENCY');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131764, NULL, NULL, 'Contribution Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleM/QualifiedContribOtherGrp/ContributionCnt'),
  (131765, NULL, NULL, 'Non Cash Checkbox Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleM/QualifiedContribOtherGrp/NonCashCheckboxInd'),
  (131766, NULL, NULL, 'Method Of Determining Revenues Txt', 'TEXT', 'ReturnData/IRS990ScheduleM/QualifiedContribOtherGrp/MethodOfDeterminingRevenuesTxt'),
  (131767, NULL, NULL, 'Noncash Contributions Rpt F990 Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleM/QualifiedContribOtherGrp/NoncashContributionsRptF990Amt');

-- 990 / Gaming Manager Business Name
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13204, 14, '155', 'Gaming Manager Business Name');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131768, 13204, '1', 'Business Name Line1 Txt', 'TEXT'),
  (131769, 13204, '2', 'Business Name Line2 Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131768, NULL, NULL, 'Business Name Line1 Txt', 'TEXT', 'ReturnData/IRS990ScheduleG/GamingManagerBusinessName/BusinessNameLine1Txt'),
  (131769, NULL, NULL, 'Business Name Line2 Txt', 'TEXT', 'ReturnData/IRS990ScheduleG/GamingManagerBusinessName/BusinessNameLine2Txt');

-- 990 / Third Party Business Name
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13205, 14, '156', 'Third Party Business Name');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131770, 13205, '1', 'Business Name Line1 Txt', 'TEXT'),
  (131771, 13205, '2', 'Business Name Line2 Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131770, NULL, NULL, 'Business Name Line1 Txt', 'TEXT', 'ReturnData/IRS990ScheduleG/ThirdPartyBusinessName/BusinessNameLine1Txt'),
  (131771, NULL, NULL, 'Business Name Line2 Txt', 'TEXT', 'ReturnData/IRS990ScheduleG/ThirdPartyBusinessName/BusinessNameLine2Txt');

-- 990 / Art Historical Treasures Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13206, 14, '157', 'Art Historical Treasures Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131772, 13206, '1', 'Non Cash Checkbox Ind', 'BOOLEAN'),
  (131773, 13206, '2', 'Contribution Cnt', 'INTEGER'),
  (131774, 13206, '3', 'Noncash Contributions Rpt F990 Amt', 'CURRENCY'),
  (131775, 13206, '4', 'Method Of Determining Revenues Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131772, NULL, NULL, 'Non Cash Checkbox Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleM/ArtHistoricalTreasuresGrp/NonCashCheckboxInd'),
  (131773, NULL, NULL, 'Contribution Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleM/ArtHistoricalTreasuresGrp/ContributionCnt'),
  (131774, NULL, NULL, 'Noncash Contributions Rpt F990 Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleM/ArtHistoricalTreasuresGrp/NoncashContributionsRptF990Amt'),
  (131775, NULL, NULL, 'Method Of Determining Revenues Txt', 'TEXT', 'ReturnData/IRS990ScheduleM/ArtHistoricalTreasuresGrp/MethodOfDeterminingRevenuesTxt');

-- 990 / Disqualified Person Ex Bnft Tr Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13207, 14, '158', 'Disqualified Person Ex Bnft Tr Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131776, 13207, '1', 'Rln Disqualified Person Org Txt', 'TEXT'),
  (131777, 13207, '2', 'Person Nm', 'TEXT'),
  (131778, 13207, '3', 'Transaction Desc', 'TEXT'),
  (131779, 13207, '4', 'Business Name Line1 Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131776, NULL, NULL, 'Rln Disqualified Person Org Txt', 'TEXT', 'ReturnData/IRS990ScheduleL/DisqualifiedPersonExBnftTrGrp/RlnDisqualifiedPersonOrgTxt'),
  (131777, NULL, NULL, 'Person Nm', 'TEXT', 'ReturnData/IRS990ScheduleL/DisqualifiedPersonExBnftTrGrp/PersonNm'),
  (131778, NULL, NULL, 'Transaction Desc', 'TEXT', 'ReturnData/IRS990ScheduleL/DisqualifiedPersonExBnftTrGrp/TransactionDesc'),
  (131779, NULL, NULL, 'Business Name Line1 Txt', 'TEXT', 'ReturnData/IRS990ScheduleL/DisqualifiedPersonExBnftTrGrp/BusinessName/BusinessNameLine1Txt');

-- 990 / Intellectual Property Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13208, 14, '159', 'Intellectual Property Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131780, 13208, '1', 'Non Cash Checkbox Ind', 'BOOLEAN'),
  (131781, 13208, '2', 'Noncash Contributions Rpt F990 Amt', 'CURRENCY'),
  (131782, 13208, '3', 'Contribution Cnt', 'INTEGER'),
  (131783, 13208, '4', 'Method Of Determining Revenues Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131780, NULL, NULL, 'Non Cash Checkbox Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleM/IntellectualPropertyGrp/NonCashCheckboxInd'),
  (131781, NULL, NULL, 'Noncash Contributions Rpt F990 Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleM/IntellectualPropertyGrp/NoncashContributionsRptF990Amt'),
  (131782, NULL, NULL, 'Contribution Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleM/IntellectualPropertyGrp/ContributionCnt'),
  (131783, NULL, NULL, 'Method Of Determining Revenues Txt', 'TEXT', 'ReturnData/IRS990ScheduleM/IntellectualPropertyGrp/MethodOfDeterminingRevenuesTxt');

-- 990 / Doing Business As Name
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13209, 14, '160', 'Doing Business As Name');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131784, 13209, '1', 'Business Name Line2 Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131784, NULL, NULL, 'Business Name Line2 Txt', 'TEXT', 'ReturnData/IRS990/DoingBusinessAsName/BusinessNameLine2Txt');

-- 990 / Prog Srvc Accom Acty2 Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13210, 14, '161', 'Prog Srvc Accom Acty2 Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131785, 13210, '1', 'Activity Cd', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131785, NULL, NULL, 'Activity Cd', 'TEXT', 'ReturnData/IRS990/ProgSrvcAccomActy2Grp/ActivityCd');

-- 990 / Rltd Org Officer Trst Key Empl Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13211, 14, '162', 'Rltd Org Officer Trst Key Empl Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131786, 13211, '1', 'Business Name Line1 Txt', 'TEXT'),
  (131787, 13211, '2', 'Business Name Line2 Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131786, NULL, NULL, 'Business Name Line1 Txt', 'TEXT', 'ReturnData/IRS990ScheduleJ/RltdOrgOfficerTrstKeyEmplGrp/BusinessName/BusinessNameLine1Txt'),
  (131787, NULL, NULL, 'Business Name Line2 Txt', 'TEXT', 'ReturnData/IRS990ScheduleJ/RltdOrgOfficerTrstKeyEmplGrp/BusinessName/BusinessNameLine2Txt');

-- 990 / Averaging Attachment Direct Fields
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13212, 14, '163', 'Averaging Attachment Direct Fields');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131788, 13212, '1', 'Explanation Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131788, NULL, NULL, 'Explanation Txt', 'TEXT', 'ReturnData/AveragingAttachment/ExplanationTxt');

-- 990 / Principal Ofcr Business Name
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13213, 14, '164', 'Principal Ofcr Business Name');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131789, 13213, '1', 'Business Name Line2 Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131789, NULL, NULL, 'Business Name Line2 Txt', 'TEXT', 'ReturnData/IRS990/PrincipalOfcrBusinessName/BusinessNameLine2Txt');

-- 990 / Prog Srvc Accom Acty3 Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13214, 14, '165', 'Prog Srvc Accom Acty3 Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131790, 13214, '1', 'Activity Cd', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131790, NULL, NULL, 'Activity Cd', 'TEXT', 'ReturnData/IRS990/ProgSrvcAccomActy3Grp/ActivityCd');

-- 990 / Disposition Of Assets Detail
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13215, 14, '166', 'Disposition Of Assets Detail');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131791, 13215, '1', 'Address Line2 Txt', 'TEXT'),
  (131792, 13215, '2', 'Business Name Line2 Txt', 'TEXT'),
  (131793, 13215, '3', 'Address Line1 Txt', 'TEXT'),
  (131794, 13215, '4', 'Country Cd', 'TEXT'),
  (131795, 13215, '5', 'City Nm', 'TEXT'),
  (131796, 13215, '6', 'Foreign Postal Cd', 'TEXT'),
  (131797, 13215, '7', 'Province Or State Nm', 'TEXT'),
  (131798, 13215, '8', 'Address Line2 Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131791, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/IRS990ScheduleN/DispositionOfAssetsDetail/USAddress/AddressLine2Txt'),
  (131792, NULL, NULL, 'Business Name Line2 Txt', 'TEXT', 'ReturnData/IRS990ScheduleN/DispositionOfAssetsDetail/BusinessName/BusinessNameLine2Txt'),
  (131793, NULL, NULL, 'Address Line1 Txt', 'TEXT', 'ReturnData/IRS990ScheduleN/DispositionOfAssetsDetail/ForeignAddress/AddressLine1Txt'),
  (131794, NULL, NULL, 'Country Cd', 'TEXT', 'ReturnData/IRS990ScheduleN/DispositionOfAssetsDetail/ForeignAddress/CountryCd'),
  (131795, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990ScheduleN/DispositionOfAssetsDetail/ForeignAddress/CityNm'),
  (131796, NULL, NULL, 'Foreign Postal Cd', 'TEXT', 'ReturnData/IRS990ScheduleN/DispositionOfAssetsDetail/ForeignAddress/ForeignPostalCd'),
  (131797, NULL, NULL, 'Province Or State Nm', 'TEXT', 'ReturnData/IRS990ScheduleN/DispositionOfAssetsDetail/ForeignAddress/ProvinceOrStateNm'),
  (131798, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/IRS990ScheduleN/DispositionOfAssetsDetail/ForeignAddress/AddressLine2Txt');

-- 990 / Scientific Specimens Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13216, 14, '167', 'Scientific Specimens Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131799, 13216, '1', 'Contribution Cnt', 'INTEGER'),
  (131800, 13216, '2', 'Non Cash Checkbox Ind', 'BOOLEAN'),
  (131801, 13216, '3', 'Noncash Contributions Rpt F990 Amt', 'CURRENCY'),
  (131802, 13216, '4', 'Method Of Determining Revenues Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131799, NULL, NULL, 'Contribution Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleM/ScientificSpecimensGrp/ContributionCnt'),
  (131800, NULL, NULL, 'Non Cash Checkbox Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleM/ScientificSpecimensGrp/NonCashCheckboxInd'),
  (131801, NULL, NULL, 'Noncash Contributions Rpt F990 Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleM/ScientificSpecimensGrp/NoncashContributionsRptF990Amt'),
  (131802, NULL, NULL, 'Method Of Determining Revenues Txt', 'TEXT', 'ReturnData/IRS990ScheduleM/ScientificSpecimensGrp/MethodOfDeterminingRevenuesTxt');

-- 990 / Taxidermy Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13217, 14, '168', 'Taxidermy Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131803, 13217, '1', 'Contribution Cnt', 'INTEGER'),
  (131804, 13217, '2', 'Non Cash Checkbox Ind', 'BOOLEAN'),
  (131805, 13217, '3', 'Noncash Contributions Rpt F990 Amt', 'CURRENCY'),
  (131806, 13217, '4', 'Method Of Determining Revenues Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131803, NULL, NULL, 'Contribution Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleM/TaxidermyGrp/ContributionCnt'),
  (131804, NULL, NULL, 'Non Cash Checkbox Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleM/TaxidermyGrp/NonCashCheckboxInd'),
  (131805, NULL, NULL, 'Noncash Contributions Rpt F990 Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleM/TaxidermyGrp/NoncashContributionsRptF990Amt'),
  (131806, NULL, NULL, 'Method Of Determining Revenues Txt', 'TEXT', 'ReturnData/IRS990ScheduleM/TaxidermyGrp/MethodOfDeterminingRevenuesTxt');

-- 990 / Archaeological Artifacts Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13218, 14, '169', 'Archaeological Artifacts Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131807, 13218, '1', 'Contribution Cnt', 'INTEGER'),
  (131808, 13218, '2', 'Non Cash Checkbox Ind', 'BOOLEAN'),
  (131809, 13218, '3', 'Noncash Contributions Rpt F990 Amt', 'CURRENCY'),
  (131810, 13218, '4', 'Method Of Determining Revenues Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131807, NULL, NULL, 'Contribution Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleM/ArchaeologicalArtifactsGrp/ContributionCnt'),
  (131808, NULL, NULL, 'Non Cash Checkbox Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleM/ArchaeologicalArtifactsGrp/NonCashCheckboxInd'),
  (131809, NULL, NULL, 'Noncash Contributions Rpt F990 Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleM/ArchaeologicalArtifactsGrp/NoncashContributionsRptF990Amt'),
  (131810, NULL, NULL, 'Method Of Determining Revenues Txt', 'TEXT', 'ReturnData/IRS990ScheduleM/ArchaeologicalArtifactsGrp/MethodOfDeterminingRevenuesTxt');

-- 990 / Agricultural Name And Address Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13219, 14, '170', 'Agricultural Name And Address Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131811, 13219, '1', 'City Nm', 'TEXT'),
  (131812, 13219, '2', 'Business Name Line1 Txt', 'TEXT'),
  (131813, 13219, '3', 'State Abbreviation Cd', 'TEXT'),
  (131814, 13219, '4', 'Business Name Line2 Txt', 'TEXT'),
  (131815, 13219, '5', 'Country Cd', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131811, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990ScheduleA/AgriculturalNameAndAddressGrp/CityNm'),
  (131812, NULL, NULL, 'Business Name Line1 Txt', 'TEXT', 'ReturnData/IRS990ScheduleA/AgriculturalNameAndAddressGrp/CollegeUniversityName/BusinessNameLine1Txt'),
  (131813, NULL, NULL, 'State Abbreviation Cd', 'TEXT', 'ReturnData/IRS990ScheduleA/AgriculturalNameAndAddressGrp/StateAbbreviationCd'),
  (131814, NULL, NULL, 'Business Name Line2 Txt', 'TEXT', 'ReturnData/IRS990ScheduleA/AgriculturalNameAndAddressGrp/CollegeUniversityName/BusinessNameLine2Txt'),
  (131815, NULL, NULL, 'Country Cd', 'TEXT', 'ReturnData/IRS990ScheduleA/AgriculturalNameAndAddressGrp/CountryCd');

-- 990 / Persons With Books Foreign Address
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13220, 14, '171', 'Persons With Books Foreign Address');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131816, 13220, '1', 'Address Line1 Txt', 'TEXT'),
  (131817, 13220, '2', 'City Nm', 'TEXT'),
  (131818, 13220, '3', 'Country Cd', 'TEXT'),
  (131819, 13220, '4', 'Foreign Postal Cd', 'TEXT'),
  (131820, 13220, '5', 'Province Or State Nm', 'TEXT'),
  (131821, 13220, '6', 'Address Line2 Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131816, NULL, NULL, 'Address Line1 Txt', 'TEXT', 'ReturnData/IRS990ScheduleG/PersonsWithBooksForeignAddress/AddressLine1Txt'),
  (131817, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990ScheduleG/PersonsWithBooksForeignAddress/CityNm'),
  (131818, NULL, NULL, 'Country Cd', 'TEXT', 'ReturnData/IRS990ScheduleG/PersonsWithBooksForeignAddress/CountryCd'),
  (131819, NULL, NULL, 'Foreign Postal Cd', 'TEXT', 'ReturnData/IRS990ScheduleG/PersonsWithBooksForeignAddress/ForeignPostalCd'),
  (131820, NULL, NULL, 'Province Or State Nm', 'TEXT', 'ReturnData/IRS990ScheduleG/PersonsWithBooksForeignAddress/ProvinceOrStateNm'),
  (131821, NULL, NULL, 'Address Line2 Txt', 'TEXT', 'ReturnData/IRS990ScheduleG/PersonsWithBooksForeignAddress/AddressLine2Txt');

-- 990 / Third Party Foreign Address
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13221, 14, '172', 'Third Party Foreign Address');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131822, 13221, '1', 'Address Line1 Txt', 'TEXT'),
  (131823, 13221, '2', 'Country Cd', 'TEXT'),
  (131824, 13221, '3', 'City Nm', 'TEXT'),
  (131825, 13221, '4', 'Province Or State Nm', 'TEXT'),
  (131826, 13221, '5', 'Foreign Postal Cd', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131822, NULL, NULL, 'Address Line1 Txt', 'TEXT', 'ReturnData/IRS990ScheduleG/ThirdPartyForeignAddress/AddressLine1Txt'),
  (131823, NULL, NULL, 'Country Cd', 'TEXT', 'ReturnData/IRS990ScheduleG/ThirdPartyForeignAddress/CountryCd'),
  (131824, NULL, NULL, 'City Nm', 'TEXT', 'ReturnData/IRS990ScheduleG/ThirdPartyForeignAddress/CityNm'),
  (131825, NULL, NULL, 'Province Or State Nm', 'TEXT', 'ReturnData/IRS990ScheduleG/ThirdPartyForeignAddress/ProvinceOrStateNm'),
  (131826, NULL, NULL, 'Foreign Postal Cd', 'TEXT', 'ReturnData/IRS990ScheduleG/ThirdPartyForeignAddress/ForeignPostalCd');

-- 990 / Qualified Contrib Hist Struct Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13222, 14, '173', 'Qualified Contrib Hist Struct Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131827, 13222, '1', 'Contribution Cnt', 'INTEGER'),
  (131828, 13222, '2', 'Non Cash Checkbox Ind', 'BOOLEAN'),
  (131829, 13222, '3', 'Noncash Contributions Rpt F990 Amt', 'CURRENCY'),
  (131830, 13222, '4', 'Method Of Determining Revenues Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131827, NULL, NULL, 'Contribution Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleM/QualifiedContribHistStructGrp/ContributionCnt'),
  (131828, NULL, NULL, 'Non Cash Checkbox Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleM/QualifiedContribHistStructGrp/NonCashCheckboxInd'),
  (131829, NULL, NULL, 'Noncash Contributions Rpt F990 Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleM/QualifiedContribHistStructGrp/NoncashContributionsRptF990Amt'),
  (131830, NULL, NULL, 'Method Of Determining Revenues Txt', 'TEXT', 'ReturnData/IRS990ScheduleM/QualifiedContribHistStructGrp/MethodOfDeterminingRevenuesTxt');

-- 990 / Art Fractional Interest Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13223, 14, '174', 'Art Fractional Interest Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131831, 13223, '1', 'Contribution Cnt', 'INTEGER'),
  (131832, 13223, '2', 'Non Cash Checkbox Ind', 'BOOLEAN'),
  (131833, 13223, '3', 'Noncash Contributions Rpt F990 Amt', 'CURRENCY'),
  (131834, 13223, '4', 'Method Of Determining Revenues Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131831, NULL, NULL, 'Contribution Cnt', 'INTEGER', 'ReturnData/IRS990ScheduleM/ArtFractionalInterestGrp/ContributionCnt'),
  (131832, NULL, NULL, 'Non Cash Checkbox Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleM/ArtFractionalInterestGrp/NonCashCheckboxInd'),
  (131833, NULL, NULL, 'Noncash Contributions Rpt F990 Amt', 'CURRENCY', 'ReturnData/IRS990ScheduleM/ArtFractionalInterestGrp/NoncashContributionsRptF990Amt'),
  (131834, NULL, NULL, 'Method Of Determining Revenues Txt', 'TEXT', 'ReturnData/IRS990ScheduleM/ArtFractionalInterestGrp/MethodOfDeterminingRevenuesTxt');

-- 990 / Prog Srvc Accom Acty Other Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13224, 14, '175', 'Prog Srvc Accom Acty Other Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131835, 13224, '1', 'Activity Cd', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131835, NULL, NULL, 'Activity Cd', 'TEXT', 'ReturnData/IRS990/ProgSrvcAccomActyOtherGrp/ActivityCd');

-- 990 / Distributable Amount Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13225, 14, '176', 'Distributable Amount Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131836, 13225, '1', 'First Year Type3 Non Func Ind', 'BOOLEAN');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131836, NULL, NULL, 'First Year Type3 Non Func Ind', 'BOOLEAN', 'ReturnData/IRS990ScheduleA/DistributableAmountGrp/FirstYearType3NonFuncInd');

-- 990 / Affiliated Group Attachment Direct Fields
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13226, 14, '177', 'Affiliated Group Attachment Direct Fields');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131837, 13226, '1', 'Meduim Explanation Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131837, NULL, NULL, 'Meduim Explanation Txt', 'TEXT', 'ReturnData/AffiliatedGroupAttachment/MeduimExplanationTxt');

