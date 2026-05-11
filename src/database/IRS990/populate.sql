INSERT INTO
  state
VALUES
  ('AL', 'Alabama'),
  ('AK', 'Alaska'),
  ('AZ', 'Arizona'),
  ('AR', 'Arkansas'),
  ('CA', 'California'),
  ('CO', 'Colorado'),
  ('CT', 'Connecticut'),
  ('DE', 'Delaware'),
  ('FL', 'Florida'),
  ('GA', 'Georgia'),
  ('HI', 'Hawaii'),
  ('ID', 'Idaho'),
  ('IL', 'Illinois'),
  ('IN', 'Indiana'),
  ('IA', 'Iowa'),
  ('KS', 'Kansas'),
  ('KY', 'Kentucky'),
  ('LA', 'Louisiana'),
  ('ME', 'Maine'),
  ('MD', 'Maryland'),
  ('MA', 'Massachusetts'),
  ('MI', 'Michigan'),
  ('MN', 'Minnesota'),
  ('MS', 'Mississippi'),
  ('MO', 'Missouri'),
  ('MT', 'Montana'),
  ('NE', 'Nebraska'),
  ('NV', 'Nevada'),
  ('NH', 'New Hampshire'),
  ('NJ', 'New Jersey'),
  ('NM', 'New Mexico'),
  ('NY', 'New York'),
  ('NC', 'North Carolina'),
  ('ND', 'North Dakota'),
  ('OH', 'Ohio'),
  ('OK', 'Oklahoma'),
  ('OR', 'Oregon'),
  ('PA', 'Pennsylvania'),
  ('RI', 'Rhode Island'),
  ('SC', 'South Carolina'),
  ('SD', 'South Dakota'),
  ('TN', 'Tennessee'),
  ('TX', 'Texas'),
  ('UT', 'Utah'),
  ('VT', 'Vermont'),
  ('VA', 'Virginia'),
  ('WA', 'Washington'),
  ('WV', 'West Virginia'),
  ('WI', 'Wisconsin'),
  ('WY', 'Wyoming');

INSERT INTO
  form (code, name, description)
VALUES
  (
    "990",
    "990",
    "Most common type of 990 form, typically used by larger organizations."
  ),
  (
    "990EZ",
    "990-EZ",
    "Used by medium sized organizations."
  ),
  (
    "990N",
    "990-N",
    "Used by small sized organizations."
  ),
  ("990PF", "990-PF", "Used by private foundations."),
  (
    "990T",
    "990-T",
    "Used by organizations with unrelated business income."
  );

INSERT INTO
  data_type
VALUES
  ('CURRENCY', 'Monetary amount in USD'),
  ('INTEGER', 'Whole number'),
  ('TEXT', 'Free-form text string'),
  ('BOOLEAN', 'True/false or yes/no indicator'),
  ('DATE', 'Calendar date'),
  ('PERCENT', 'Percentage value');

INSERT INTO
  part (part_id, form_code, part_number, part_name)
VALUES
  (1, "990", 'I', 'Summary'),
  (2, "990", 'II', 'Signature Block'),
  (
    3,
    "990",
    'III',
    'Statement of Program Service Accomplishments'
  ),
  (4, "990", 'IV', 'Checklist of Required Schedules'),
  (
    5,
    "990",
    'V',
    'Statements Regarding Other IRS Filings and Tax Compliance'
  ),
  (
    6,
    "990",
    'VI',
    'Governance, Management, and Disclosure'
  ),
  (
    7,
    "990",
    'VII',
    'Compensation of Officers, Directors, Trustees, Key Employees, Highest Compensated Employees, and Independent Contractors'
  ),
  (8, "990", 'VIII', 'Statement of Revenue'),
  (
    9,
    "990",
    'IX',
    'Statement of Functional Expenses'
  ),
  (10, "990", 'X', 'Balance Sheet'),
  (11, "990", 'XI', 'Reconciliation of Net Assets'),
  (
    12,
    "990",
    'XII',
    'Financial Statements and Reporting'
  );

INSERT INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  -- Part I
  (100, 1, 'NONE', NULL),
  -- Part II
  (200, 2, 'NONE', NULL),
  -- Part III
  (300, 3, 'NONE', NULL),
  -- Part IV
  (400, 4, 'NONE', NULL),
  -- Part V
  (500, 5, 'NONE', NULL),
  -- Part VI
  (600, 6, 'NONE', NULL),
  -- Part VII
  (700, 7, 'NONE', NULL),
  -- Part VIII
  (
    801,
    8,
    'A',
    'Contributions, Gifts, Grants and Other Similar Amounts'
  ),
  (802, 8, 'B', 'Program Service Revenue'),
  (803, 8, 'C', 'Other Revenue'),
  (804, 8, 'D', 'Total Revenue'),
  -- Part IX
  (900, 9, 'NONE', NULL),
  -- Part X
  (1000, 10, 'NONE', NULL),
  -- Part XI
  (1100, 11, 'NONE', NULL),
  -- Part XII
  (1200, 12, 'NONE', NULL);

-- =======================
-- PART I — SUMMARY
-- =======================
INSERT INTO
  line (
    line_id,
    section_id,
    line_number,
    line_label,
    data_type
  )
VALUES
  (
    1001,
    100,
    '1',
    'Briefly describe the organization''s mission or most significant activities',
    'TEXT'
  ),
  (
    1002,
    100,
    '2',
    'Check if the organization discontinued its operations or disposed of more than 25% of its net assets',
    'BOOLEAN'
  ),
  (
    1003,
    100,
    '3',
    'Number of voting members of the governing body',
    'INTEGER'
  ),
  (
    1004,
    100,
    '4',
    'Number of independent voting members of the governing body',
    'INTEGER'
  ),
  (
    1005,
    100,
    '5',
    'Total number of individuals employed in calendar year',
    'INTEGER'
  ),
  (
    1006,
    100,
    '6',
    'Total number of volunteers',
    'INTEGER'
  ),
  (
    1007,
    100,
    '7a',
    'Total unrelated business revenue from Part VIII, column (C), line 12',
    'CURRENCY'
  ),
  (
    1008,
    100,
    '7b',
    'Net unrelated business taxable income from Form 990-T',
    'CURRENCY'
  ),
  (
    1009,
    100,
    '8',
    'Contributions and grants',
    'CURRENCY'
  ),
  (
    1010,
    100,
    '9',
    'Program service revenue',
    'CURRENCY'
  ),
  (1011, 100, '10', 'Investment income', 'CURRENCY'),
  (1012, 100, '11', 'Other revenue', 'CURRENCY'),
  (1013, 100, '12', 'Total revenue', 'CURRENCY'),
  (
    1014,
    100,
    '13',
    'Grants and similar amounts paid',
    'CURRENCY'
  ),
  (
    1015,
    100,
    '14',
    'Benefits paid to or for members',
    'CURRENCY'
  ),
  (
    1016,
    100,
    '15',
    'Salaries, other compensation, employee benefits',
    'CURRENCY'
  ),
  (
    1017,
    100,
    '16',
    'Professional fundraising fees',
    'CURRENCY'
  ),
  (1018, 100, '17', 'Other expenses', 'CURRENCY'),
  (1019, 100, '18', 'Total expenses', 'CURRENCY'),
  (
    1020,
    100,
    '19',
    'Revenue less expenses',
    'CURRENCY'
  ),
  (1021, 100, '20', 'Total assets', 'CURRENCY'),
  (1022, 100, '21', 'Total liabilities', 'CURRENCY'),
  (
    1023,
    100,
    '22',
    'Net assets or fund balances',
    'CURRENCY'
  );

-- Part I fields (lines with Prior Year / Current Year columns)
-- Lines 8-19: columns A=Prior Year, B=Current Year
-- Lines 20-22: columns A=Beginning of Year, B=End of Year
INSERT INTO
  field (
    line_id,
    sub_letter,
    column_code,
    box_label,
    data_type,
    xml_path
  )
VALUES
  -- Line 1 (single value)
  (
    1001,
    NULL,
    NULL,
    'Mission or most significant activities',
    'TEXT',
    'ReturnData/IRS990/ActivityOrMissionDesc'
  ),
  -- Line 2 (single boolean)
  (
    1002,
    NULL,
    NULL,
    'Discontinued operations indicator',
    'BOOLEAN',
    'ReturnData/IRS990/ContractTerminationInd'
  ),
  -- Line 3
  (
    1003,
    NULL,
    NULL,
    'Number of voting members of governing body',
    'INTEGER',
    'ReturnData/IRS990/VotingMembersGoverningBodyCnt'
  ),
  -- Line 4
  (
    1004,
    NULL,
    NULL,
    'Number of independent voting members of governing body',
    'INTEGER',
    'ReturnData/IRS990/VotingMembersIndependentCnt'
  ),
  -- Line 5
  (
    1005,
    NULL,
    NULL,
    'Total number of employees',
    'INTEGER',
    'ReturnData/IRS990/TotalEmployeeCnt'
  ),
  -- Line 6
  (
    1006,
    NULL,
    NULL,
    'Total number of volunteers',
    'INTEGER',
    'ReturnData/IRS990/TotalVolunteersCnt'
  ),
  -- Line 7a
  (
    1007,
    NULL,
    NULL,
    'Total unrelated business revenue',
    'CURRENCY',
    'ReturnData/IRS990/TotalGrossUBIAmt'
  ),
  -- Line 7b
  (
    1008,
    NULL,
    NULL,
    'Net unrelated business taxable income',
    'CURRENCY',
    'ReturnData/IRS990/NetUnrelatedBusTxblIncmAmt'
  ),
  -- Line 8 — Contributions and grants
  (
    1009,
    NULL,
    'A',
    'Contributions and grants — Prior Year',
    'CURRENCY',
    'ReturnData/IRS990/PYContributionsGrantsAmt'
  ),
  (
    1009,
    NULL,
    'B',
    'Contributions and grants — Current Year',
    'CURRENCY',
    'ReturnData/IRS990/CYContributionsGrantsAmt'
  ),
  -- Line 9 — Program service revenue
  (
    1010,
    NULL,
    'A',
    'Program service revenue — Prior Year',
    'CURRENCY',
    'ReturnData/IRS990/PYProgramServiceRevenueAmt'
  ),
  (
    1010,
    NULL,
    'B',
    'Program service revenue — Current Year',
    'CURRENCY',
    'ReturnData/IRS990/CYProgramServiceRevenueAmt'
  ),
  -- Line 10 — Investment income
  (
    1011,
    NULL,
    'A',
    'Investment income — Prior Year',
    'CURRENCY',
    'ReturnData/IRS990/PYInvestmentIncomeAmt'
  ),
  (
    1011,
    NULL,
    'B',
    'Investment income — Current Year',
    'CURRENCY',
    'ReturnData/IRS990/CYInvestmentIncomeAmt'
  ),
  -- Line 11 — Other revenue
  (
    1012,
    NULL,
    'A',
    'Other revenue — Prior Year',
    'CURRENCY',
    'ReturnData/IRS990/PYOtherRevenueAmt'
  ),
  (
    1012,
    NULL,
    'B',
    'Other revenue — Current Year',
    'CURRENCY',
    'ReturnData/IRS990/CYOtherRevenueAmt'
  ),
  -- Line 12 — Total revenue
  (
    1013,
    NULL,
    'A',
    'Total revenue — Prior Year',
    'CURRENCY',
    'ReturnData/IRS990/PYTotalRevenueAmt'
  ),
  (
    1013,
    NULL,
    'B',
    'Total revenue — Current Year',
    'CURRENCY',
    'ReturnData/IRS990/CYTotalRevenueAmt'
  ),
  -- Line 13 — Grants and similar amounts paid
  (
    1014,
    NULL,
    'A',
    'Grants and similar amounts paid — Prior Year',
    'CURRENCY',
    'ReturnData/IRS990/PYGrantsAndSimilarPaidAmt'
  ),
  (
    1014,
    NULL,
    'B',
    'Grants and similar amounts paid — Current Year',
    'CURRENCY',
    'ReturnData/IRS990/CYGrantsAndSimilarPaidAmt'
  ),
  -- Line 14 — Benefits paid to or for members
  (
    1015,
    NULL,
    'A',
    'Benefits paid to or for members — Prior Year',
    'CURRENCY',
    'ReturnData/IRS990/PYBenefitsPaidToMembersAmt'
  ),
  (
    1015,
    NULL,
    'B',
    'Benefits paid to or for members — Current Year',
    'CURRENCY',
    'ReturnData/IRS990/CYBenefitsPaidToMembersAmt'
  ),
  -- Line 15 — Salaries, compensation, employee benefits
  (
    1016,
    NULL,
    'A',
    'Salaries, compensation, employee benefits — Prior Year',
    'CURRENCY',
    'ReturnData/IRS990/PYSalariesCompEmpBnftPaidAmt'
  ),
  (
    1016,
    NULL,
    'B',
    'Salaries, compensation, employee benefits — Current Year',
    'CURRENCY',
    'ReturnData/IRS990/CYSalariesCompEmpBnftPaidAmt'
  ),
  -- Line 16 — Professional fundraising fees
  (
    1017,
    NULL,
    'A',
    'Professional fundraising fees — Prior Year',
    'CURRENCY',
    'ReturnData/IRS990/PYTotalProfFndrsngExpnsAmt'
  ),
  (
    1017,
    NULL,
    'B',
    'Professional fundraising fees — Current Year',
    'CURRENCY',
    'ReturnData/IRS990/CYTotalProfFndrsngExpnsAmt'
  ),
  -- Line 17 — Other expenses
  (
    1018,
    NULL,
    'A',
    'Other expenses — Prior Year',
    'CURRENCY',
    'ReturnData/IRS990/PYOtherExpensesAmt'
  ),
  (
    1018,
    NULL,
    'B',
    'Other expenses — Current Year',
    'CURRENCY',
    'ReturnData/IRS990/CYOtherExpensesAmt'
  ),
  -- Line 18 — Total expenses
  (
    1019,
    NULL,
    'A',
    'Total expenses — Prior Year',
    'CURRENCY',
    'ReturnData/IRS990/PYTotalExpensesAmt'
  ),
  (
    1019,
    NULL,
    'B',
    'Total expenses — Current Year',
    'CURRENCY',
    'ReturnData/IRS990/CYTotalExpensesAmt'
  ),
  -- Line 19 — Revenue less expenses
  (
    1020,
    NULL,
    'A',
    'Revenue less expenses — Prior Year',
    'CURRENCY',
    'ReturnData/IRS990/PYRevenuesLessExpensesAmt'
  ),
  (
    1020,
    NULL,
    'B',
    'Revenue less expenses — Current Year',
    'CURRENCY',
    'ReturnData/IRS990/CYRevenuesLessExpensesAmt'
  ),
  -- Line 20 — Total assets
  (
    1021,
    NULL,
    'A',
    'Total assets — Beginning of Year',
    'CURRENCY',
    'ReturnData/IRS990/TotalAssetsBOYAmt'
  ),
  (
    1021,
    NULL,
    'B',
    'Total assets — End of Year',
    'CURRENCY',
    'ReturnData/IRS990/TotalAssetsEOYAmt'
  ),
  -- Line 21 — Total liabilities
  (
    1022,
    NULL,
    'A',
    'Total liabilities — Beginning of Year',
    'CURRENCY',
    'ReturnData/IRS990/TotalLiabilitiesBOYAmt'
  ),
  (
    1022,
    NULL,
    'B',
    'Total liabilities — End of Year',
    'CURRENCY',
    'ReturnData/IRS990/TotalLiabilitiesEOYAmt'
  ),
  -- Line 22 — Net assets or fund balances
  (
    1023,
    NULL,
    'A',
    'Net assets or fund balances — Beginning of Year',
    'CURRENCY',
    'ReturnData/IRS990/NetAssetsOrFundBalancesBOYAmt'
  ),
  (
    1023,
    NULL,
    'B',
    'Net assets or fund balances — End of Year',
    'CURRENCY',
    'ReturnData/IRS990/NetAssetsOrFundBalancesEOYAmt'
  );

-- =======================
-- PART VIII — STATEMENT OF REVENUE
-- Columns: A=Total, B=Related/Exempt, C=Unrelated Business, D=Excluded
-- =======================
-- Section A: Contributions
INSERT INTO
  line (
    line_id,
    section_id,
    line_number,
    line_label,
    data_type
  )
VALUES
  (
    8001,
    801,
    '1a',
    'Federated campaigns',
    'CURRENCY'
  ),
  (8002, 801, '1b', 'Membership dues', 'CURRENCY'),
  (8003, 801, '1c', 'Fundraising events', 'CURRENCY'),
  (
    8004,
    801,
    '1d',
    'Related organizations',
    'CURRENCY'
  ),
  (
    8005,
    801,
    '1e',
    'Government grants (contributions)',
    'CURRENCY'
  ),
  (
    8006,
    801,
    '1f',
    'All other contributions, gifts, grants',
    'CURRENCY'
  ),
  (
    8007,
    801,
    '1g',
    'Noncash contributions included in 1a-1f (memo only)',
    'CURRENCY'
  ),
  (
    8008,
    801,
    '1h',
    'Total contributions and grants',
    'CURRENCY'
  );

INSERT INTO
  field (
    line_id,
    sub_letter,
    column_code,
    box_label,
    data_type,
    xml_path
  )
VALUES
  (
    8001,
    NULL,
    NULL,
    'Federated campaigns',
    'CURRENCY',
    'ReturnData/IRS990/FederatedCampaignsAmt'
  ),
  (
    8002,
    NULL,
    NULL,
    'Membership dues',
    'CURRENCY',
    'ReturnData/IRS990/MembershipDuesAmt'
  ),
  (
    8003,
    NULL,
    NULL,
    'Fundraising events contributions',
    'CURRENCY',
    'ReturnData/IRS990/FundraisingAmt'
  ),
  (
    8004,
    NULL,
    NULL,
    'Related organizations contributions',
    'CURRENCY',
    'ReturnData/IRS990/RelatedOrganizationsAmt'
  ),
  (
    8005,
    NULL,
    NULL,
    'Government grants',
    'CURRENCY',
    'ReturnData/IRS990/GovernmentGrantsAmt'
  ),
  (
    8006,
    NULL,
    NULL,
    'All other contributions',
    'CURRENCY',
    'ReturnData/IRS990/AllOtherContributionsAmt'
  ),
  (
    8007,
    NULL,
    NULL,
    'Noncash contributions (memo only)',
    'CURRENCY',
    'ReturnData/IRS990/NoncashContributionsAmt'
  ),
  (
    8008,
    NULL,
    NULL,
    'Total contributions and grants',
    'CURRENCY',
    'ReturnData/IRS990/TotalContributionsAmt'
  );

-- Section B: Program Service Revenue (lines 2a-2e are named entries, 2f=all other, 2g=total)
INSERT INTO
  line (
    line_id,
    section_id,
    line_number,
    line_label,
    data_type
  )
VALUES
  (
    8010,
    802,
    '2',
    'Program service revenue',
    'CURRENCY'
  ),
  (
    8011,
    802,
    '2g',
    'Total program service revenue',
    'CURRENCY'
  );

-- Lines 2a-2e: sub_letter a-e, each with columns A-D
-- Line 2f: all other program service revenue
-- Line 2g: total
INSERT INTO
  field (
    line_id,
    sub_letter,
    column_code,
    box_label,
    data_type,
    xml_path
  )
VALUES
  -- 2a
  (
    8010,
    'a',
    'A',
    'Program service revenue A — Total',
    'CURRENCY',
    'ReturnData/IRS990/ProgramServiceRevenueGrp/TotalRevenueColumnAmt'
  ),
  (
    8010,
    'a',
    'B',
    'Program service revenue A — Related/Exempt',
    'CURRENCY',
    'ReturnData/IRS990/ProgramServiceRevenueGrp/RelatedOrExemptFuncIncomeAmt'
  ),
  (
    8010,
    'a',
    'C',
    'Program service revenue A — Unrelated',
    'CURRENCY',
    'ReturnData/IRS990/ProgramServiceRevenueGrp/UnrelatedBusinessRevenueAmt'
  ),
  (
    8010,
    'a',
    'D',
    'Program service revenue A — Excluded',
    'CURRENCY',
    'ReturnData/IRS990/ProgramServiceRevenueGrp/ExclusionAmt'
  ),
  -- 2b
  (
    8010,
    'b',
    'A',
    'Program service revenue B — Total',
    'CURRENCY',
    'ReturnData/IRS990/ProgramServiceRevenueGrp/TotalRevenueColumnAmt'
  ),
  (
    8010,
    'b',
    'B',
    'Program service revenue B — Related/Exempt',
    'CURRENCY',
    'ReturnData/IRS990/ProgramServiceRevenueGrp/RelatedOrExemptFuncIncomeAmt'
  ),
  (
    8010,
    'b',
    'C',
    'Program service revenue B — Unrelated',
    'CURRENCY',
    'ReturnData/IRS990/ProgramServiceRevenueGrp/UnrelatedBusinessRevenueAmt'
  ),
  (
    8010,
    'b',
    'D',
    'Program service revenue B — Excluded',
    'CURRENCY',
    'ReturnData/IRS990/ProgramServiceRevenueGrp/ExclusionAmt'
  ),
  -- 2c
  (
    8010,
    'c',
    'A',
    'Program service revenue C — Total',
    'CURRENCY',
    'ReturnData/IRS990/ProgramServiceRevenueGrp/TotalRevenueColumnAmt'
  ),
  (
    8010,
    'c',
    'B',
    'Program service revenue C — Related/Exempt',
    'CURRENCY',
    'ReturnData/IRS990/ProgramServiceRevenueGrp/RelatedOrExemptFuncIncomeAmt'
  ),
  (
    8010,
    'c',
    'C',
    'Program service revenue C — Unrelated',
    'CURRENCY',
    'ReturnData/IRS990/ProgramServiceRevenueGrp/UnrelatedBusinessRevenueAmt'
  ),
  (
    8010,
    'c',
    'D',
    'Program service revenue C — Excluded',
    'CURRENCY',
    'ReturnData/IRS990/ProgramServiceRevenueGrp/ExclusionAmt'
  ),
  -- 2d
  (
    8010,
    'd',
    'A',
    'Program service revenue D — Total',
    'CURRENCY',
    'ReturnData/IRS990/ProgramServiceRevenueGrp/TotalRevenueColumnAmt'
  ),
  (
    8010,
    'd',
    'B',
    'Program service revenue D — Related/Exempt',
    'CURRENCY',
    'ReturnData/IRS990/ProgramServiceRevenueGrp/RelatedOrExemptFuncIncomeAmt'
  ),
  (
    8010,
    'd',
    'C',
    'Program service revenue D — Unrelated',
    'CURRENCY',
    'ReturnData/IRS990/ProgramServiceRevenueGrp/UnrelatedBusinessRevenueAmt'
  ),
  (
    8010,
    'd',
    'D',
    'Program service revenue D — Excluded',
    'CURRENCY',
    'ReturnData/IRS990/ProgramServiceRevenueGrp/ExclusionAmt'
  ),
  -- 2e
  (
    8010,
    'e',
    'A',
    'Program service revenue E — Total',
    'CURRENCY',
    'ReturnData/IRS990/ProgramServiceRevenueGrp/TotalRevenueColumnAmt'
  ),
  (
    8010,
    'e',
    'B',
    'Program service revenue E — Related/Exempt',
    'CURRENCY',
    'ReturnData/IRS990/ProgramServiceRevenueGrp/RelatedOrExemptFuncIncomeAmt'
  ),
  (
    8010,
    'e',
    'C',
    'Program service revenue E — Unrelated',
    'CURRENCY',
    'ReturnData/IRS990/ProgramServiceRevenueGrp/UnrelatedBusinessRevenueAmt'
  ),
  (
    8010,
    'e',
    'D',
    'Program service revenue E — Excluded',
    'CURRENCY',
    'ReturnData/IRS990/ProgramServiceRevenueGrp/ExclusionAmt'
  ),
  -- 2f all other
  (
    8010,
    'f',
    'A',
    'All other program service revenue — Total',
    'CURRENCY',
    'ReturnData/IRS990/TotalOthProgramServiceRevGrp/TotalRevenueColumnAmt'
  ),
  (
    8010,
    'f',
    'B',
    'All other program service revenue — Related/Exempt',
    'CURRENCY',
    'ReturnData/IRS990/TotalOthProgramServiceRevGrp/RelatedOrExemptFuncIncomeAmt'
  ),
  (
    8010,
    'f',
    'C',
    'All other program service revenue — Unrelated',
    'CURRENCY',
    'ReturnData/IRS990/TotalOthProgramServiceRevGrp/UnrelatedBusinessRevenueAmt'
  ),
  (
    8010,
    'f',
    'D',
    'All other program service revenue — Excluded',
    'CURRENCY',
    'ReturnData/IRS990/TotalOthProgramServiceRevGrp/ExclusionAmt'
  ),
  -- 2g total
  (
    8011,
    NULL,
    NULL,
    'Total program service revenue',
    'CURRENCY',
    'ReturnData/IRS990/TotalProgramServiceRevenueAmt'
  );

-- Section C: Other Revenue
INSERT INTO
  line (
    line_id,
    section_id,
    line_number,
    line_label,
    data_type
  )
VALUES
  (8020, 803, '3', 'Investment income', 'CURRENCY'),
  (
    8021,
    803,
    '4',
    'Income from investment of tax-exempt bond proceeds',
    'CURRENCY'
  ),
  (8022, 803, '5', 'Royalties', 'CURRENCY'),
  (8023, 803, '6', 'Rental income/loss', 'CURRENCY'),
  (
    8024,
    803,
    '7',
    'Net gain/loss on sales of assets',
    'CURRENCY'
  ),
  (
    8025,
    803,
    '8',
    'Net income/loss from fundraising events',
    'CURRENCY'
  ),
  (
    8026,
    803,
    '9',
    'Net income/loss from gaming activities',
    'CURRENCY'
  ),
  (
    8027,
    803,
    '10',
    'Net income/loss from sales of inventory',
    'CURRENCY'
  ),
  (
    8028,
    803,
    '11a',
    'Miscellaneous revenue A',
    'CURRENCY'
  ),
  (
    8029,
    803,
    '11b',
    'Miscellaneous revenue B',
    'CURRENCY'
  ),
  (
    8030,
    803,
    '11c',
    'Miscellaneous revenue C',
    'CURRENCY'
  ),
  (
    8031,
    803,
    '11d',
    'All other miscellaneous revenue',
    'CURRENCY'
  ),
  (
    8032,
    803,
    '11e',
    'Total miscellaneous revenue',
    'CURRENCY'
  );

-- Section D: Total Revenue (line 12)
INSERT INTO
  line (
    line_id,
    section_id,
    line_number,
    line_label,
    data_type
  )
VALUES
  (8040, 804, '12', 'Total revenue', 'CURRENCY');

INSERT INTO
  field (
    line_id,
    sub_letter,
    column_code,
    box_label,
    data_type,
    xml_path
  )
VALUES
  -- Line 3: Investment income
  (
    8020,
    NULL,
    'A',
    'Investment income — Total',
    'CURRENCY',
    'ReturnData/IRS990/InvestmentIncomeGrp/TotalRevenueColumnAmt'
  ),
  (
    8020,
    NULL,
    'B',
    'Investment income — Related/Exempt',
    'CURRENCY',
    'ReturnData/IRS990/InvestmentIncomeGrp/RelatedOrExemptFuncIncomeAmt'
  ),
  (
    8020,
    NULL,
    'C',
    'Investment income — Unrelated',
    'CURRENCY',
    'ReturnData/IRS990/InvestmentIncomeGrp/UnrelatedBusinessRevenueAmt'
  ),
  (
    8020,
    NULL,
    'D',
    'Investment income — Excluded',
    'CURRENCY',
    'ReturnData/IRS990/InvestmentIncomeGrp/ExclusionAmt'
  ),
  -- Line 4: Tax-exempt bond proceeds income
  (
    8021,
    NULL,
    'A',
    'Tax-exempt bond proceeds income — Total',
    'CURRENCY',
    'ReturnData/IRS990/IncmFromInvestBondProceedsGrp/TotalRevenueColumnAmt'
  ),
  (
    8021,
    NULL,
    'B',
    'Tax-exempt bond proceeds income — Related/Exempt',
    'CURRENCY',
    'ReturnData/IRS990/IncmFromInvestBondProceedsGrp/RelatedOrExemptFuncIncomeAmt'
  ),
  (
    8021,
    NULL,
    'C',
    'Tax-exempt bond proceeds income — Unrelated',
    'CURRENCY',
    'ReturnData/IRS990/IncmFromInvestBondProceedsGrp/UnrelatedBusinessRevenueAmt'
  ),
  (
    8021,
    NULL,
    'D',
    'Tax-exempt bond proceeds income — Excluded',
    'CURRENCY',
    'ReturnData/IRS990/IncmFromInvestBondProceedsGrp/ExclusionAmt'
  ),
  -- Line 5: Royalties
  (
    8022,
    NULL,
    'A',
    'Royalties — Total',
    'CURRENCY',
    'ReturnData/IRS990/RoyaltiesRevenueGrp/TotalRevenueColumnAmt'
  ),
  (
    8022,
    NULL,
    'B',
    'Royalties — Related/Exempt',
    'CURRENCY',
    'ReturnData/IRS990/RoyaltiesRevenueGrp/RelatedOrExemptFuncIncomeAmt'
  ),
  (
    8022,
    NULL,
    'C',
    'Royalties — Unrelated',
    'CURRENCY',
    'ReturnData/IRS990/RoyaltiesRevenueGrp/UnrelatedBusinessRevenueAmt'
  ),
  (
    8022,
    NULL,
    'D',
    'Royalties — Excluded',
    'CURRENCY',
    'ReturnData/IRS990/RoyaltiesRevenueGrp/ExclusionAmt'
  ),
  -- Line 6: Rental income — sub-letters for gross/expenses/net, then columns
  -- 6a gross rents
  (
    8023,
    'a',
    'i',
    'Gross rents — Real property',
    'CURRENCY',
    'ReturnData/IRS990/GrossRentsGrp/RealAmt'
  ),
  (
    8023,
    'a',
    'ii',
    'Gross rents — Personal property',
    'CURRENCY',
    'ReturnData/IRS990/GrossRentsGrp/PersonalAmt'
  ),
  -- 6b rental expenses
  (
    8023,
    'b',
    'i',
    'Rental expenses — Real property',
    'CURRENCY',
    'ReturnData/IRS990/LessRentalExpensesGrp/RealAmt'
  ),
  (
    8023,
    'b',
    'ii',
    'Rental expenses — Personal property',
    'CURRENCY',
    'ReturnData/IRS990/LessRentalExpensesGrp/PersonalAmt'
  ),
  -- 6c rental income or loss
  (
    8023,
    'c',
    'i',
    'Rental income or loss — Real property',
    'CURRENCY',
    'ReturnData/IRS990/RentalIncomeOrLossGrp/RealAmt'
  ),
  (
    8023,
    'c',
    'ii',
    'Rental income or loss — Personal property',
    'CURRENCY',
    'ReturnData/IRS990/RentalIncomeOrLossGrp/PersonalAmt'
  ),
  -- 6d net rental income (columns A-D)
  (
    8023,
    'd',
    'A',
    'Net rental income — Total',
    'CURRENCY',
    'ReturnData/IRS990/NetRentalIncomeOrLossGrp/TotalRevenueColumnAmt'
  ),
  (
    8023,
    'd',
    'B',
    'Net rental income — Related/Exempt',
    'CURRENCY',
    'ReturnData/IRS990/NetRentalIncomeOrLossGrp/RelatedOrExemptFuncIncomeAmt'
  ),
  (
    8023,
    'd',
    'C',
    'Net rental income — Unrelated',
    'CURRENCY',
    'ReturnData/IRS990/NetRentalIncomeOrLossGrp/UnrelatedBusinessRevenueAmt'
  ),
  (
    8023,
    'd',
    'D',
    'Net rental income — Excluded',
    'CURRENCY',
    'ReturnData/IRS990/NetRentalIncomeOrLossGrp/ExclusionAmt'
  ),
  -- Line 7: Net gain/loss on sales of assets
  -- 7a gross sales
  (
    8024,
    'a',
    'i',
    'Gross sales of assets — Securities',
    'CURRENCY',
    'ReturnData/IRS990/GrossAmountSalesAssetsGrp/SecuritiesAmt'
  ),
  (
    8024,
    'a',
    'ii',
    'Gross sales of assets — Other assets',
    'CURRENCY',
    'ReturnData/IRS990/GrossAmountSalesAssetsGrp/OtherAmt'
  ),
  -- 7b cost basis
  (
    8024,
    'b',
    'i',
    'Cost basis of assets sold — Securities',
    'CURRENCY',
    'ReturnData/IRS990/LessCostOthBasisSalesExpnssGrp/SecuritiesAmt'
  ),
  (
    8024,
    'b',
    'ii',
    'Cost basis of assets sold — Other assets',
    'CURRENCY',
    'ReturnData/IRS990/LessCostOthBasisSalesExpnssGrp/OtherAmt'
  ),
  -- 7c gain or loss
  (
    8024,
    'c',
    'i',
    'Gain or loss — Securities',
    'CURRENCY',
    'ReturnData/IRS990/GainOrLossGrp/SecuritiesAmt'
  ),
  (
    8024,
    'c',
    'ii',
    'Gain or loss — Other assets',
    'CURRENCY',
    'ReturnData/IRS990/GainOrLossGrp/OtherAmt'
  ),
  -- 7d net gain (columns A-D)
  (
    8024,
    'd',
    'A',
    'Net gain/loss on sales — Total',
    'CURRENCY',
    'ReturnData/IRS990/NetGainOrLossInvestmentsGrp/TotalRevenueColumnAmt'
  ),
  (
    8024,
    'd',
    'B',
    'Net gain/loss on sales — Related/Exempt',
    'CURRENCY',
    'ReturnData/IRS990/NetGainOrLossInvestmentsGrp/RelatedOrExemptFuncIncomeAmt'
  ),
  (
    8024,
    'd',
    'C',
    'Net gain/loss on sales — Unrelated',
    'CURRENCY',
    'ReturnData/IRS990/NetGainOrLossInvestmentsGrp/UnrelatedBusinessRevenueAmt'
  ),
  (
    8024,
    'd',
    'D',
    'Net gain/loss on sales — Excluded',
    'CURRENCY',
    'ReturnData/IRS990/NetGainOrLossInvestmentsGrp/ExclusionAmt'
  ),
  -- Line 8: Fundraising events
  (
    8025,
    'a',
    NULL,
    'Gross income from fundraising events',
    'CURRENCY',
    'ReturnData/IRS990/FundraisingGrossIncomeAmt'
  ),
  (
    8025,
    'b',
    NULL,
    'Direct expenses from fundraising events',
    'CURRENCY',
    'ReturnData/IRS990/FundraisingDirectExpensesAmt'
  ),
  (
    8025,
    'c',
    'A',
    'Net income from fundraising events — Total',
    'CURRENCY',
    'ReturnData/IRS990/NetIncmFromFundraisingEvtGrp/TotalRevenueColumnAmt'
  ),
  (
    8025,
    'c',
    'B',
    'Net income from fundraising events — Related/Exempt',
    'CURRENCY',
    'ReturnData/IRS990/NetIncmFromFundraisingEvtGrp/RelatedOrExemptFuncIncomeAmt'
  ),
  (
    8025,
    'c',
    'C',
    'Net income from fundraising events — Unrelated',
    'CURRENCY',
    'ReturnData/IRS990/NetIncmFromFundraisingEvtGrp/UnrelatedBusinessRevenueAmt'
  ),
  (
    8025,
    'c',
    'D',
    'Net income from fundraising events — Excluded',
    'CURRENCY',
    'ReturnData/IRS990/NetIncmFromFundraisingEvtGrp/ExclusionAmt'
  ),
  -- Line 9: Gaming activities
  (
    8026,
    'a',
    NULL,
    'Gross income from gaming',
    'CURRENCY',
    'ReturnData/IRS990/GamingGrossIncomeAmt'
  ),
  (
    8026,
    'b',
    NULL,
    'Direct expenses from gaming',
    'CURRENCY',
    'ReturnData/IRS990/GamingDirectExpensesAmt'
  ),
  (
    8026,
    'c',
    'A',
    'Net income from gaming — Total',
    'CURRENCY',
    'ReturnData/IRS990/NetIncomeFromGamingGrp/TotalRevenueColumnAmt'
  ),
  (
    8026,
    'c',
    'B',
    'Net income from gaming — Related/Exempt',
    'CURRENCY',
    'ReturnData/IRS990/NetIncomeFromGamingGrp/RelatedOrExemptFuncIncomeAmt'
  ),
  (
    8026,
    'c',
    'C',
    'Net income from gaming — Unrelated',
    'CURRENCY',
    'ReturnData/IRS990/NetIncomeFromGamingGrp/UnrelatedBusinessRevenueAmt'
  ),
  (
    8026,
    'c',
    'D',
    'Net income from gaming — Excluded',
    'CURRENCY',
    'ReturnData/IRS990/NetIncomeFromGamingGrp/ExclusionAmt'
  ),
  -- Line 10: Sales of inventory
  (
    8027,
    'a',
    NULL,
    'Gross sales of inventory',
    'CURRENCY',
    'ReturnData/IRS990/GrossSalesOfInventoryAmt'
  ),
  (
    8027,
    'b',
    NULL,
    'Cost of goods sold',
    'CURRENCY',
    'ReturnData/IRS990/CostOfGoodsSoldAmt'
  ),
  (
    8027,
    'c',
    'A',
    'Net income from inventory sales — Total',
    'CURRENCY',
    'ReturnData/IRS990/NetIncomeOrLossGrp/TotalRevenueColumnAmt'
  ),
  (
    8027,
    'c',
    'B',
    'Net income from inventory sales — Related/Exempt',
    'CURRENCY',
    'ReturnData/IRS990/NetIncomeOrLossGrp/RelatedOrExemptFuncIncomeAmt'
  ),
  (
    8027,
    'c',
    'C',
    'Net income from inventory sales — Unrelated',
    'CURRENCY',
    'ReturnData/IRS990/NetIncomeOrLossGrp/UnrelatedBusinessRevenueAmt'
  ),
  (
    8027,
    'c',
    'D',
    'Net income from inventory sales — Excluded',
    'CURRENCY',
    'ReturnData/IRS990/NetIncomeOrLossGrp/ExclusionAmt'
  ),
  -- Lines 11a-11c: Miscellaneous revenue named entries (A-D columns each)
  (
    8028,
    NULL,
    'A',
    'Miscellaneous revenue A — Total',
    'CURRENCY',
    'ReturnData/IRS990/OtherRevenueMiscGrp/TotalRevenueColumnAmt'
  ),
  (
    8028,
    NULL,
    'B',
    'Miscellaneous revenue A — Related/Exempt',
    'CURRENCY',
    'ReturnData/IRS990/OtherRevenueMiscGrp/RelatedOrExemptFuncIncomeAmt'
  ),
  (
    8028,
    NULL,
    'C',
    'Miscellaneous revenue A — Unrelated',
    'CURRENCY',
    'ReturnData/IRS990/OtherRevenueMiscGrp/UnrelatedBusinessRevenueAmt'
  ),
  (
    8028,
    NULL,
    'D',
    'Miscellaneous revenue A — Excluded',
    'CURRENCY',
    'ReturnData/IRS990/OtherRevenueMiscGrp/ExclusionAmt'
  ),
  (
    8029,
    NULL,
    'A',
    'Miscellaneous revenue B — Total',
    'CURRENCY',
    'ReturnData/IRS990/OtherRevenueMiscGrp/TotalRevenueColumnAmt'
  ),
  (
    8029,
    NULL,
    'B',
    'Miscellaneous revenue B — Related/Exempt',
    'CURRENCY',
    'ReturnData/IRS990/OtherRevenueMiscGrp/RelatedOrExemptFuncIncomeAmt'
  ),
  (
    8029,
    NULL,
    'C',
    'Miscellaneous revenue B — Unrelated',
    'CURRENCY',
    'ReturnData/IRS990/OtherRevenueMiscGrp/UnrelatedBusinessRevenueAmt'
  ),
  (
    8029,
    NULL,
    'D',
    'Miscellaneous revenue B — Excluded',
    'CURRENCY',
    'ReturnData/IRS990/OtherRevenueMiscGrp/ExclusionAmt'
  ),
  (
    8030,
    NULL,
    'A',
    'Miscellaneous revenue C — Total',
    'CURRENCY',
    'ReturnData/IRS990/OtherRevenueMiscGrp/TotalRevenueColumnAmt'
  ),
  (
    8030,
    NULL,
    'B',
    'Miscellaneous revenue C — Related/Exempt',
    'CURRENCY',
    'ReturnData/IRS990/OtherRevenueMiscGrp/RelatedOrExemptFuncIncomeAmt'
  ),
  (
    8030,
    NULL,
    'C',
    'Miscellaneous revenue C — Unrelated',
    'CURRENCY',
    'ReturnData/IRS990/OtherRevenueMiscGrp/UnrelatedBusinessRevenueAmt'
  ),
  (
    8030,
    NULL,
    'D',
    'Miscellaneous revenue C — Excluded',
    'CURRENCY',
    'ReturnData/IRS990/OtherRevenueMiscGrp/ExclusionAmt'
  ),
  -- 11d all other miscellaneous
  (
    8031,
    NULL,
    'A',
    'All other miscellaneous revenue — Total',
    'CURRENCY',
    'ReturnData/IRS990/MiscellaneousRevenueGrp/TotalRevenueColumnAmt'
  ),
  (
    8031,
    NULL,
    'B',
    'All other miscellaneous revenue — Related/Exempt',
    'CURRENCY',
    'ReturnData/IRS990/MiscellaneousRevenueGrp/RelatedOrExemptFuncIncomeAmt'
  ),
  (
    8031,
    NULL,
    'C',
    'All other miscellaneous revenue — Unrelated',
    'CURRENCY',
    'ReturnData/IRS990/MiscellaneousRevenueGrp/UnrelatedBusinessRevenueAmt'
  ),
  (
    8031,
    NULL,
    'D',
    'All other miscellaneous revenue — Excluded',
    'CURRENCY',
    'ReturnData/IRS990/MiscellaneousRevenueGrp/ExclusionAmt'
  ),
  -- 11e total miscellaneous
  (
    8032,
    NULL,
    'A',
    'Total miscellaneous revenue — Total',
    'CURRENCY',
    'ReturnData/IRS990/OtherRevenueTotalAmt/TotalRevenueColumnAmt'
  ),
  (
    8032,
    NULL,
    'B',
    'Total miscellaneous revenue — Related/Exempt',
    'CURRENCY',
    'ReturnData/IRS990/OtherRevenueTotalAmt/RelatedOrExemptFuncIncomeAmt'
  ),
  (
    8032,
    NULL,
    'C',
    'Total miscellaneous revenue — Unrelated',
    'CURRENCY',
    'ReturnData/IRS990/OtherRevenueTotalAmt/UnrelatedBusinessRevenueAmt'
  ),
  (
    8032,
    NULL,
    'D',
    'Total miscellaneous revenue — Excluded',
    'CURRENCY',
    'ReturnData/IRS990/OtherRevenueTotalAmt/ExclusionAmt'
  ),
  -- Line 12: Total revenue
  (
    8040,
    NULL,
    'A',
    'Total revenue — Total',
    'CURRENCY',
    'ReturnData/IRS990/TotalRevenueGrp/TotalRevenueColumnAmt'
  ),
  (
    8040,
    NULL,
    'B',
    'Total revenue — Related/Exempt',
    'CURRENCY',
    'ReturnData/IRS990/TotalRevenueGrp/RelatedOrExemptFuncIncomeAmt'
  ),
  (
    8040,
    NULL,
    'C',
    'Total revenue — Unrelated',
    'CURRENCY',
    'ReturnData/IRS990/TotalRevenueGrp/UnrelatedBusinessRevenueAmt'
  ),
  (
    8040,
    NULL,
    'D',
    'Total revenue — Excluded',
    'CURRENCY',
    'ReturnData/IRS990/TotalRevenueGrp/ExclusionAmt'
  );

-- =======================
-- PART IX — STATEMENT OF FUNCTIONAL EXPENSES
-- Columns: A=Total, B=Program Services, C=Management & General, D=Fundraising
-- =======================
INSERT INTO
  line (
    line_id,
    section_id,
    line_number,
    line_label,
    data_type
  )
VALUES
  (
    9001,
    900,
    '1',
    'Grants to domestic organizations and governments',
    'CURRENCY'
  ),
  (
    9002,
    900,
    '2',
    'Grants to domestic individuals',
    'CURRENCY'
  ),
  (
    9003,
    900,
    '3',
    'Grants to foreign organizations, governments, and individuals',
    'CURRENCY'
  ),
  (
    9004,
    900,
    '4',
    'Benefits paid to or for members',
    'CURRENCY'
  ),
  (
    9005,
    900,
    '5',
    'Compensation of current officers, directors, trustees, key employees',
    'CURRENCY'
  ),
  (
    9006,
    900,
    '6',
    'Compensation not included above to disqualified persons',
    'CURRENCY'
  ),
  (
    9007,
    900,
    '7',
    'Other salaries and wages',
    'CURRENCY'
  ),
  (
    9008,
    900,
    '8',
    'Pension plan accruals and contributions',
    'CURRENCY'
  ),
  (
    9009,
    900,
    '9',
    'Other employee benefits',
    'CURRENCY'
  ),
  (9010, 900, '10', 'Payroll taxes', 'CURRENCY'),
  (
    9011,
    900,
    '11a',
    'Fees for services — Management',
    'CURRENCY'
  ),
  (
    9012,
    900,
    '11b',
    'Fees for services — Legal',
    'CURRENCY'
  ),
  (
    9013,
    900,
    '11c',
    'Fees for services — Accounting',
    'CURRENCY'
  ),
  (
    9014,
    900,
    '11d',
    'Fees for services — Lobbying',
    'CURRENCY'
  ),
  (
    9015,
    900,
    '11e',
    'Fees for services — Professional fundraising',
    'CURRENCY'
  ),
  (
    9016,
    900,
    '11f',
    'Fees for services — Investment management',
    'CURRENCY'
  ),
  (
    9017,
    900,
    '11g',
    'Fees for services — Other',
    'CURRENCY'
  ),
  (
    9018,
    900,
    '12',
    'Advertising and promotion',
    'CURRENCY'
  ),
  (9019, 900, '13', 'Office expenses', 'CURRENCY'),
  (
    9020,
    900,
    '14',
    'Information technology',
    'CURRENCY'
  ),
  (9021, 900, '15', 'Royalties', 'CURRENCY'),
  (9022, 900, '16', 'Occupancy', 'CURRENCY'),
  (9023, 900, '17', 'Travel', 'CURRENCY'),
  (
    9024,
    900,
    '18',
    'Payments of travel or entertainment for public officials',
    'CURRENCY'
  ),
  (
    9025,
    900,
    '19',
    'Conferences, conventions, and meetings',
    'CURRENCY'
  ),
  (9026, 900, '20', 'Interest', 'CURRENCY'),
  (
    9027,
    900,
    '21',
    'Payments to affiliates',
    'CURRENCY'
  ),
  (
    9028,
    900,
    '22',
    'Depreciation, depletion, and amortization',
    'CURRENCY'
  ),
  (9029, 900, '23', 'Insurance', 'CURRENCY'),
  (9030, 900, '24a', 'Other expenses A', 'CURRENCY'),
  (9031, 900, '24b', 'Other expenses B', 'CURRENCY'),
  (9032, 900, '24c', 'Other expenses C', 'CURRENCY'),
  (9033, 900, '24d', 'Other expenses D', 'CURRENCY'),
  (
    9034,
    900,
    '24e',
    'All other expenses',
    'CURRENCY'
  ),
  (
    9035,
    900,
    '25',
    'Total functional expenses',
    'CURRENCY'
  );

INSERT INTO
  field (
    line_id,
    sub_letter,
    column_code,
    box_label,
    data_type,
    xml_path
  )
VALUES
  -- Line 1: Grants to domestic orgs
  (
    9001,
    NULL,
    'A',
    'Grants to domestic orgs — Total',
    'CURRENCY',
    'ReturnData/IRS990/GrantsToDomesticOrgsGrp/TotalAmt'
  ),
  (
    9001,
    NULL,
    'B',
    'Grants to domestic orgs — Program',
    'CURRENCY',
    'ReturnData/IRS990/GrantsToDomesticOrgsGrp/ProgramServicesAmt'
  ),
  (
    9001,
    NULL,
    'C',
    'Grants to domestic orgs — Mgmt',
    'CURRENCY',
    'ReturnData/IRS990/GrantsToDomesticOrgsGrp/ManagementAndGeneralAmt'
  ),
  (
    9001,
    NULL,
    'D',
    'Grants to domestic orgs — Fundraising',
    'CURRENCY',
    'ReturnData/IRS990/GrantsToDomesticOrgsGrp/FundraisingAmt'
  ),
  -- Line 2: Grants to domestic individuals
  (
    9002,
    NULL,
    'A',
    'Grants to domestic individuals — Total',
    'CURRENCY',
    'ReturnData/IRS990/GrantsToDomesticIndividualsGrp/TotalAmt'
  ),
  (
    9002,
    NULL,
    'B',
    'Grants to domestic individuals — Program',
    'CURRENCY',
    'ReturnData/IRS990/GrantsToDomesticIndividualsGrp/ProgramServicesAmt'
  ),
  (
    9002,
    NULL,
    'C',
    'Grants to domestic individuals — Mgmt',
    'CURRENCY',
    'ReturnData/IRS990/GrantsToDomesticIndividualsGrp/ManagementAndGeneralAmt'
  ),
  (
    9002,
    NULL,
    'D',
    'Grants to domestic individuals — Fundraising',
    'CURRENCY',
    'ReturnData/IRS990/GrantsToDomesticIndividualsGrp/FundraisingAmt'
  ),
  -- Line 3: Foreign grants
  (
    9003,
    NULL,
    'A',
    'Foreign grants — Total',
    'CURRENCY',
    'ReturnData/IRS990/ForeignGrantsGrp/TotalAmt'
  ),
  (
    9003,
    NULL,
    'B',
    'Foreign grants — Program',
    'CURRENCY',
    'ReturnData/IRS990/ForeignGrantsGrp/ProgramServicesAmt'
  ),
  (
    9003,
    NULL,
    'C',
    'Foreign grants — Mgmt',
    'CURRENCY',
    'ReturnData/IRS990/ForeignGrantsGrp/ManagementAndGeneralAmt'
  ),
  (
    9003,
    NULL,
    'D',
    'Foreign grants — Fundraising',
    'CURRENCY',
    'ReturnData/IRS990/ForeignGrantsGrp/FundraisingAmt'
  ),
  -- Line 4: Benefits to members
  (
    9004,
    NULL,
    'A',
    'Benefits to members — Total',
    'CURRENCY',
    'ReturnData/IRS990/BenefitsToMembersGrp/TotalAmt'
  ),
  (
    9004,
    NULL,
    'B',
    'Benefits to members — Program',
    'CURRENCY',
    'ReturnData/IRS990/BenefitsToMembersGrp/ProgramServicesAmt'
  ),
  (
    9004,
    NULL,
    'C',
    'Benefits to members — Mgmt',
    'CURRENCY',
    'ReturnData/IRS990/BenefitsToMembersGrp/ManagementAndGeneralAmt'
  ),
  (
    9004,
    NULL,
    'D',
    'Benefits to members — Fundraising',
    'CURRENCY',
    'ReturnData/IRS990/BenefitsToMembersGrp/FundraisingAmt'
  ),
  -- Line 5: Compensation of officers
  (
    9005,
    NULL,
    'A',
    'Compensation of officers — Total',
    'CURRENCY',
    'ReturnData/IRS990/CompCurrentOfcrDirectorsGrp/TotalAmt'
  ),
  (
    9005,
    NULL,
    'B',
    'Compensation of officers — Program',
    'CURRENCY',
    'ReturnData/IRS990/CompCurrentOfcrDirectorsGrp/ProgramServicesAmt'
  ),
  (
    9005,
    NULL,
    'C',
    'Compensation of officers — Mgmt',
    'CURRENCY',
    'ReturnData/IRS990/CompCurrentOfcrDirectorsGrp/ManagementAndGeneralAmt'
  ),
  (
    9005,
    NULL,
    'D',
    'Compensation of officers — Fundraising',
    'CURRENCY',
    'ReturnData/IRS990/CompCurrentOfcrDirectorsGrp/FundraisingAmt'
  ),
  -- Line 6: Compensation to disqualified persons
  (
    9006,
    NULL,
    'A',
    'Compensation disqualified persons — Total',
    'CURRENCY',
    'ReturnData/IRS990/CompDisqualPersonsGrp/TotalAmt'
  ),
  (
    9006,
    NULL,
    'B',
    'Compensation disqualified persons — Program',
    'CURRENCY',
    'ReturnData/IRS990/CompDisqualPersonsGrp/ProgramServicesAmt'
  ),
  (
    9006,
    NULL,
    'C',
    'Compensation disqualified persons — Mgmt',
    'CURRENCY',
    'ReturnData/IRS990/CompDisqualPersonsGrp/ManagementAndGeneralAmt'
  ),
  (
    9006,
    NULL,
    'D',
    'Compensation disqualified persons — Fundraising',
    'CURRENCY',
    'ReturnData/IRS990/CompDisqualPersonsGrp/FundraisingAmt'
  ),
  -- Line 7: Other salaries and wages
  (
    9007,
    NULL,
    'A',
    'Other salaries and wages — Total',
    'CURRENCY',
    'ReturnData/IRS990/OtherSalariesAndWagesGrp/TotalAmt'
  ),
  (
    9007,
    NULL,
    'B',
    'Other salaries and wages — Program',
    'CURRENCY',
    'ReturnData/IRS990/OtherSalariesAndWagesGrp/ProgramServicesAmt'
  ),
  (
    9007,
    NULL,
    'C',
    'Other salaries and wages — Mgmt',
    'CURRENCY',
    'ReturnData/IRS990/OtherSalariesAndWagesGrp/ManagementAndGeneralAmt'
  ),
  (
    9007,
    NULL,
    'D',
    'Other salaries and wages — Fundraising',
    'CURRENCY',
    'ReturnData/IRS990/OtherSalariesAndWagesGrp/FundraisingAmt'
  ),
  -- Line 8: Pension plan contributions
  (
    9008,
    NULL,
    'A',
    'Pension plan contributions — Total',
    'CURRENCY',
    'ReturnData/IRS990/PensionPlanContributionsGrp/TotalAmt'
  ),
  (
    9008,
    NULL,
    'B',
    'Pension plan contributions — Program',
    'CURRENCY',
    'ReturnData/IRS990/PensionPlanContributionsGrp/ProgramServicesAmt'
  ),
  (
    9008,
    NULL,
    'C',
    'Pension plan contributions — Mgmt',
    'CURRENCY',
    'ReturnData/IRS990/PensionPlanContributionsGrp/ManagementAndGeneralAmt'
  ),
  (
    9008,
    NULL,
    'D',
    'Pension plan contributions — Fundraising',
    'CURRENCY',
    'ReturnData/IRS990/PensionPlanContributionsGrp/FundraisingAmt'
  ),
  -- Line 9: Other employee benefits
  (
    9009,
    NULL,
    'A',
    'Other employee benefits — Total',
    'CURRENCY',
    'ReturnData/IRS990/OtherEmployeeBenefitsGrp/TotalAmt'
  ),
  (
    9009,
    NULL,
    'B',
    'Other employee benefits — Program',
    'CURRENCY',
    'ReturnData/IRS990/OtherEmployeeBenefitsGrp/ProgramServicesAmt'
  ),
  (
    9009,
    NULL,
    'C',
    'Other employee benefits — Mgmt',
    'CURRENCY',
    'ReturnData/IRS990/OtherEmployeeBenefitsGrp/ManagementAndGeneralAmt'
  ),
  (
    9009,
    NULL,
    'D',
    'Other employee benefits — Fundraising',
    'CURRENCY',
    'ReturnData/IRS990/OtherEmployeeBenefitsGrp/FundraisingAmt'
  ),
  -- Line 10: Payroll taxes
  (
    9010,
    NULL,
    'A',
    'Payroll taxes — Total',
    'CURRENCY',
    'ReturnData/IRS990/PayrollTaxesGrp/TotalAmt'
  ),
  (
    9010,
    NULL,
    'B',
    'Payroll taxes — Program',
    'CURRENCY',
    'ReturnData/IRS990/PayrollTaxesGrp/ProgramServicesAmt'
  ),
  (
    9010,
    NULL,
    'C',
    'Payroll taxes — Mgmt',
    'CURRENCY',
    'ReturnData/IRS990/PayrollTaxesGrp/ManagementAndGeneralAmt'
  ),
  (
    9010,
    NULL,
    'D',
    'Payroll taxes — Fundraising',
    'CURRENCY',
    'ReturnData/IRS990/PayrollTaxesGrp/FundraisingAmt'
  ),
  -- Line 11a: Fees — Management
  (
    9011,
    NULL,
    'A',
    'Fees for services management — Total',
    'CURRENCY',
    'ReturnData/IRS990/FeesForServicesManagementGrp/TotalAmt'
  ),
  (
    9011,
    NULL,
    'B',
    'Fees for services management — Program',
    'CURRENCY',
    'ReturnData/IRS990/FeesForServicesManagementGrp/ProgramServicesAmt'
  ),
  (
    9011,
    NULL,
    'C',
    'Fees for services management — Mgmt',
    'CURRENCY',
    'ReturnData/IRS990/FeesForServicesManagementGrp/ManagementAndGeneralAmt'
  ),
  (
    9011,
    NULL,
    'D',
    'Fees for services management — Fundraising',
    'CURRENCY',
    'ReturnData/IRS990/FeesForServicesManagementGrp/FundraisingAmt'
  ),
  -- Line 11b: Fees — Legal
  (
    9012,
    NULL,
    'A',
    'Fees for services legal — Total',
    'CURRENCY',
    'ReturnData/IRS990/FeesForServicesLegalGrp/TotalAmt'
  ),
  (
    9012,
    NULL,
    'B',
    'Fees for services legal — Program',
    'CURRENCY',
    'ReturnData/IRS990/FeesForServicesLegalGrp/ProgramServicesAmt'
  ),
  (
    9012,
    NULL,
    'C',
    'Fees for services legal — Mgmt',
    'CURRENCY',
    'ReturnData/IRS990/FeesForServicesLegalGrp/ManagementAndGeneralAmt'
  ),
  (
    9012,
    NULL,
    'D',
    'Fees for services legal — Fundraising',
    'CURRENCY',
    'ReturnData/IRS990/FeesForServicesLegalGrp/FundraisingAmt'
  ),
  -- Line 11c: Fees — Accounting
  (
    9013,
    NULL,
    'A',
    'Fees for services accounting — Total',
    'CURRENCY',
    'ReturnData/IRS990/FeesForServicesAccountingGrp/TotalAmt'
  ),
  (
    9013,
    NULL,
    'B',
    'Fees for services accounting — Program',
    'CURRENCY',
    'ReturnData/IRS990/FeesForServicesAccountingGrp/ProgramServicesAmt'
  ),
  (
    9013,
    NULL,
    'C',
    'Fees for services accounting — Mgmt',
    'CURRENCY',
    'ReturnData/IRS990/FeesForServicesAccountingGrp/ManagementAndGeneralAmt'
  ),
  (
    9013,
    NULL,
    'D',
    'Fees for services accounting — Fundraising',
    'CURRENCY',
    'ReturnData/IRS990/FeesForServicesAccountingGrp/FundraisingAmt'
  ),
  -- Line 11d: Fees — Lobbying
  (
    9014,
    NULL,
    'A',
    'Fees for services lobbying — Total',
    'CURRENCY',
    'ReturnData/IRS990/FeesForServicesLobbyingGrp/TotalAmt'
  ),
  (
    9014,
    NULL,
    'B',
    'Fees for services lobbying — Program',
    'CURRENCY',
    'ReturnData/IRS990/FeesForServicesLobbyingGrp/ProgramServicesAmt'
  ),
  (
    9014,
    NULL,
    'C',
    'Fees for services lobbying — Mgmt',
    'CURRENCY',
    'ReturnData/IRS990/FeesForServicesLobbyingGrp/ManagementAndGeneralAmt'
  ),
  (
    9014,
    NULL,
    'D',
    'Fees for services lobbying — Fundraising',
    'CURRENCY',
    'ReturnData/IRS990/FeesForServicesLobbyingGrp/FundraisingAmt'
  ),
  -- Line 11e: Fees — Professional fundraising
  (
    9015,
    NULL,
    'A',
    'Fees for services prof fundraising — Total',
    'CURRENCY',
    'ReturnData/IRS990/FeesForServicesProfFundraising/TotalAmt'
  ),
  (
    9015,
    NULL,
    'B',
    'Fees for services prof fundraising — Program',
    'CURRENCY',
    'ReturnData/IRS990/FeesForServicesProfFundraising/ProgramServicesAmt'
  ),
  (
    9015,
    NULL,
    'C',
    'Fees for services prof fundraising — Mgmt',
    'CURRENCY',
    'ReturnData/IRS990/FeesForServicesProfFundraising/ManagementAndGeneralAmt'
  ),
  (
    9015,
    NULL,
    'D',
    'Fees for services prof fundraising — Fundraising',
    'CURRENCY',
    'ReturnData/IRS990/FeesForServicesProfFundraising/FundraisingAmt'
  ),
  -- Line 11f: Fees — Investment management
  (
    9016,
    NULL,
    'A',
    'Fees for services investment mgmt — Total',
    'CURRENCY',
    'ReturnData/IRS990/FeesForSrvcInvstMgmntFeesGrp/TotalAmt'
  ),
  (
    9016,
    NULL,
    'B',
    'Fees for services investment mgmt — Program',
    'CURRENCY',
    'ReturnData/IRS990/FeesForSrvcInvstMgmntFeesGrp/ProgramServicesAmt'
  ),
  (
    9016,
    NULL,
    'C',
    'Fees for services investment mgmt — Mgmt',
    'CURRENCY',
    'ReturnData/IRS990/FeesForSrvcInvstMgmntFeesGrp/ManagementAndGeneralAmt'
  ),
  (
    9016,
    NULL,
    'D',
    'Fees for services investment mgmt — Fundraising',
    'CURRENCY',
    'ReturnData/IRS990/FeesForSrvcInvstMgmntFeesGrp/FundraisingAmt'
  ),
  -- Line 11g: Fees — Other
  (
    9017,
    NULL,
    'A',
    'Fees for services other — Total',
    'CURRENCY',
    'ReturnData/IRS990/FeesForServicesOtherGrp/TotalAmt'
  ),
  (
    9017,
    NULL,
    'B',
    'Fees for services other — Program',
    'CURRENCY',
    'ReturnData/IRS990/FeesForServicesOtherGrp/ProgramServicesAmt'
  ),
  (
    9017,
    NULL,
    'C',
    'Fees for services other — Mgmt',
    'CURRENCY',
    'ReturnData/IRS990/FeesForServicesOtherGrp/ManagementAndGeneralAmt'
  ),
  (
    9017,
    NULL,
    'D',
    'Fees for services other — Fundraising',
    'CURRENCY',
    'ReturnData/IRS990/FeesForServicesOtherGrp/FundraisingAmt'
  ),
  -- Line 12: Advertising and promotion
  (
    9018,
    NULL,
    'A',
    'Advertising and promotion — Total',
    'CURRENCY',
    'ReturnData/IRS990/AdvertisingGrp/TotalAmt'
  ),
  (
    9018,
    NULL,
    'B',
    'Advertising and promotion — Program',
    'CURRENCY',
    'ReturnData/IRS990/AdvertisingGrp/ProgramServicesAmt'
  ),
  (
    9018,
    NULL,
    'C',
    'Advertising and promotion — Mgmt',
    'CURRENCY',
    'ReturnData/IRS990/AdvertisingGrp/ManagementAndGeneralAmt'
  ),
  (
    9018,
    NULL,
    'D',
    'Advertising and promotion — Fundraising',
    'CURRENCY',
    'ReturnData/IRS990/AdvertisingGrp/FundraisingAmt'
  ),
  -- Line 13: Office expenses
  (
    9019,
    NULL,
    'A',
    'Office expenses — Total',
    'CURRENCY',
    'ReturnData/IRS990/OfficeExpensesGrp/TotalAmt'
  ),
  (
    9019,
    NULL,
    'B',
    'Office expenses — Program',
    'CURRENCY',
    'ReturnData/IRS990/OfficeExpensesGrp/ProgramServicesAmt'
  ),
  (
    9019,
    NULL,
    'C',
    'Office expenses — Mgmt',
    'CURRENCY',
    'ReturnData/IRS990/OfficeExpensesGrp/ManagementAndGeneralAmt'
  ),
  (
    9019,
    NULL,
    'D',
    'Office expenses — Fundraising',
    'CURRENCY',
    'ReturnData/IRS990/OfficeExpensesGrp/FundraisingAmt'
  ),
  -- Line 14: Information technology
  (
    9020,
    NULL,
    'A',
    'Information technology — Total',
    'CURRENCY',
    'ReturnData/IRS990/InformationTechnologyGrp/TotalAmt'
  ),
  (
    9020,
    NULL,
    'B',
    'Information technology — Program',
    'CURRENCY',
    'ReturnData/IRS990/InformationTechnologyGrp/ProgramServicesAmt'
  ),
  (
    9020,
    NULL,
    'C',
    'Information technology — Mgmt',
    'CURRENCY',
    'ReturnData/IRS990/InformationTechnologyGrp/ManagementAndGeneralAmt'
  ),
  (
    9020,
    NULL,
    'D',
    'Information technology — Fundraising',
    'CURRENCY',
    'ReturnData/IRS990/InformationTechnologyGrp/FundraisingAmt'
  ),
  -- Line 15: Royalties
  (
    9021,
    NULL,
    'A',
    'Royalties — Total',
    'CURRENCY',
    'ReturnData/IRS990/RoyaltiesGrp/TotalAmt'
  ),
  (
    9021,
    NULL,
    'B',
    'Royalties — Program',
    'CURRENCY',
    'ReturnData/IRS990/RoyaltiesGrp/ProgramServicesAmt'
  ),
  (
    9021,
    NULL,
    'C',
    'Royalties — Mgmt',
    'CURRENCY',
    'ReturnData/IRS990/RoyaltiesGrp/ManagementAndGeneralAmt'
  ),
  (
    9021,
    NULL,
    'D',
    'Royalties — Fundraising',
    'CURRENCY',
    'ReturnData/IRS990/RoyaltiesGrp/FundraisingAmt'
  ),
  -- Line 16: Occupancy
  (
    9022,
    NULL,
    'A',
    'Occupancy — Total',
    'CURRENCY',
    'ReturnData/IRS990/OccupancyGrp/TotalAmt'
  ),
  (
    9022,
    NULL,
    'B',
    'Occupancy — Program',
    'CURRENCY',
    'ReturnData/IRS990/OccupancyGrp/ProgramServicesAmt'
  ),
  (
    9022,
    NULL,
    'C',
    'Occupancy — Mgmt',
    'CURRENCY',
    'ReturnData/IRS990/OccupancyGrp/ManagementAndGeneralAmt'
  ),
  (
    9022,
    NULL,
    'D',
    'Occupancy — Fundraising',
    'CURRENCY',
    'ReturnData/IRS990/OccupancyGrp/FundraisingAmt'
  ),
  -- Line 17: Travel
  (
    9023,
    NULL,
    'A',
    'Travel — Total',
    'CURRENCY',
    'ReturnData/IRS990/TravelGrp/TotalAmt'
  ),
  (
    9023,
    NULL,
    'B',
    'Travel — Program',
    'CURRENCY',
    'ReturnData/IRS990/TravelGrp/ProgramServicesAmt'
  ),
  (
    9023,
    NULL,
    'C',
    'Travel — Mgmt',
    'CURRENCY',
    'ReturnData/IRS990/TravelGrp/ManagementAndGeneralAmt'
  ),
  (
    9023,
    NULL,
    'D',
    'Travel — Fundraising',
    'CURRENCY',
    'ReturnData/IRS990/TravelGrp/FundraisingAmt'
  ),
  -- Line 18: Travel/entertainment for public officials
  (
    9024,
    NULL,
    'A',
    'Travel/entertainment public officials — Total',
    'CURRENCY',
    'ReturnData/IRS990/PymtTravelEntrtnmntPubOfclGrp/TotalAmt'
  ),
  (
    9024,
    NULL,
    'B',
    'Travel/entertainment public officials — Program',
    'CURRENCY',
    'ReturnData/IRS990/PymtTravelEntrtnmntPubOfclGrp/ProgramServicesAmt'
  ),
  (
    9024,
    NULL,
    'C',
    'Travel/entertainment public officials — Mgmt',
    'CURRENCY',
    'ReturnData/IRS990/PymtTravelEntrtnmntPubOfclGrp/ManagementAndGeneralAmt'
  ),
  (
    9024,
    NULL,
    'D',
    'Travel/entertainment public officials — Fundraising',
    'CURRENCY',
    'ReturnData/IRS990/PymtTravelEntrtnmntPubOfclGrp/FundraisingAmt'
  ),
  -- Line 19: Conferences, conventions, meetings
  (
    9025,
    NULL,
    'A',
    'Conferences, conventions, meetings — Total',
    'CURRENCY',
    'ReturnData/IRS990/ConferencesMeetingsGrp/TotalAmt'
  ),
  (
    9025,
    NULL,
    'B',
    'Conferences, conventions, meetings — Program',
    'CURRENCY',
    'ReturnData/IRS990/ConferencesMeetingsGrp/ProgramServicesAmt'
  ),
  (
    9025,
    NULL,
    'C',
    'Conferences, conventions, meetings — Mgmt',
    'CURRENCY',
    'ReturnData/IRS990/ConferencesMeetingsGrp/ManagementAndGeneralAmt'
  ),
  (
    9025,
    NULL,
    'D',
    'Conferences, conventions, meetings — Fundraising',
    'CURRENCY',
    'ReturnData/IRS990/ConferencesMeetingsGrp/FundraisingAmt'
  ),
  -- Line 20: Interest
  (
    9026,
    NULL,
    'A',
    'Interest — Total',
    'CURRENCY',
    'ReturnData/IRS990/InterestGrp/TotalAmt'
  ),
  (
    9026,
    NULL,
    'B',
    'Interest — Program',
    'CURRENCY',
    'ReturnData/IRS990/InterestGrp/ProgramServicesAmt'
  ),
  (
    9026,
    NULL,
    'C',
    'Interest — Mgmt',
    'CURRENCY',
    'ReturnData/IRS990/InterestGrp/ManagementAndGeneralAmt'
  ),
  (
    9026,
    NULL,
    'D',
    'Interest — Fundraising',
    'CURRENCY',
    'ReturnData/IRS990/InterestGrp/FundraisingAmt'
  ),
  -- Line 21: Payments to affiliates
  (
    9027,
    NULL,
    'A',
    'Payments to affiliates — Total',
    'CURRENCY',
    'ReturnData/IRS990/PaymentsToAffiliatesGrp/TotalAmt'
  ),
  (
    9027,
    NULL,
    'B',
    'Payments to affiliates — Program',
    'CURRENCY',
    'ReturnData/IRS990/PaymentsToAffiliatesGrp/ProgramServicesAmt'
  ),
  (
    9027,
    NULL,
    'C',
    'Payments to affiliates — Mgmt',
    'CURRENCY',
    'ReturnData/IRS990/PaymentsToAffiliatesGrp/ManagementAndGeneralAmt'
  ),
  (
    9027,
    NULL,
    'D',
    'Payments to affiliates — Fundraising',
    'CURRENCY',
    'ReturnData/IRS990/PaymentsToAffiliatesGrp/FundraisingAmt'
  ),
  -- Line 22: Depreciation, depletion, amortization
  (
    9028,
    NULL,
    'A',
    'Depreciation, depletion, amortization — Total',
    'CURRENCY',
    'ReturnData/IRS990/DepreciationDepletionGrp/TotalAmt'
  ),
  (
    9028,
    NULL,
    'B',
    'Depreciation, depletion, amortization — Program',
    'CURRENCY',
    'ReturnData/IRS990/DepreciationDepletionGrp/ProgramServicesAmt'
  ),
  (
    9028,
    NULL,
    'C',
    'Depreciation, depletion, amortization — Mgmt',
    'CURRENCY',
    'ReturnData/IRS990/DepreciationDepletionGrp/ManagementAndGeneralAmt'
  ),
  (
    9028,
    NULL,
    'D',
    'Depreciation, depletion, amortization — Fundraising',
    'CURRENCY',
    'ReturnData/IRS990/DepreciationDepletionGrp/FundraisingAmt'
  ),
  -- Line 23: Insurance
  (
    9029,
    NULL,
    'A',
    'Insurance — Total',
    'CURRENCY',
    'ReturnData/IRS990/InsuranceGrp/TotalAmt'
  ),
  (
    9029,
    NULL,
    'B',
    'Insurance — Program',
    'CURRENCY',
    'ReturnData/IRS990/InsuranceGrp/ProgramServicesAmt'
  ),
  (
    9029,
    NULL,
    'C',
    'Insurance — Mgmt',
    'CURRENCY',
    'ReturnData/IRS990/InsuranceGrp/ManagementAndGeneralAmt'
  ),
  (
    9029,
    NULL,
    'D',
    'Insurance — Fundraising',
    'CURRENCY',
    'ReturnData/IRS990/InsuranceGrp/FundraisingAmt'
  ),
  -- Lines 24a-24d: Other expenses A-D
  (
    9030,
    NULL,
    'DESC',
    'Ohher expenses A — Description',
    'CURRENCY',
    'ReturnData/IRS990/OtherExpensesGrp/Desc'
  ),
  (
    9030,
    NULL,
    'A',
    'Other expenses A — Total',
    'CURRENCY',
    'ReturnData/IRS990/OtherExpensesGrp/TotalAmt'
  ),
  (
    9030,
    NULL,
    'B',
    'Other expenses A — Program',
    'CURRENCY',
    'ReturnData/IRS990/OtherExpensesGrp/ProgramServicesAmt'
  ),
  (
    9030,
    NULL,
    'C',
    'Other expenses A — Mgmt',
    'CURRENCY',
    'ReturnData/IRS990/OtherExpensesGrp/ManagementAndGeneralAmt'
  ),
  (
    9030,
    NULL,
    'D',
    'Other expenses A — Fundraising',
    'CURRENCY',
    'ReturnData/IRS990/OtherExpensesGrp/FundraisingAmt'
  ),
  (
    9031,
    NULL,
    'A',
    'Other expenses B — Total',
    'CURRENCY',
    'ReturnData/IRS990/OtherExpensesGrp/TotalAmt'
  ),
  (
    9031,
    NULL,
    'B',
    'Other expenses B — Program',
    'CURRENCY',
    'ReturnData/IRS990/OtherExpensesGrp/ProgramServicesAmt'
  ),
  (
    9031,
    NULL,
    'C',
    'Other expenses B — Mgmt',
    'CURRENCY',
    'ReturnData/IRS990/OtherExpensesGrp/ManagementAndGeneralAmt'
  ),
  (
    9031,
    NULL,
    'D',
    'Other expenses B — Fundraising',
    'CURRENCY',
    'ReturnData/IRS990/OtherExpensesGrp/FundraisingAmt'
  ),
  (
    9032,
    NULL,
    'A',
    'Other expenses C — Total',
    'CURRENCY',
    'ReturnData/IRS990/OtherExpensesGrp/TotalAmt'
  ),
  (
    9032,
    NULL,
    'B',
    'Other expenses C — Program',
    'CURRENCY',
    'ReturnData/IRS990/OtherExpensesGrp/ProgramServicesAmt'
  ),
  (
    9032,
    NULL,
    'C',
    'Other expenses C — Mgmt',
    'CURRENCY',
    'ReturnData/IRS990/OtherExpensesGrp/ManagementAndGeneralAmt'
  ),
  (
    9032,
    NULL,
    'D',
    'Other expenses C — Fundraising',
    'CURRENCY',
    'ReturnData/IRS990/OtherExpensesGrp/FundraisingAmt'
  ),
  (
    9033,
    NULL,
    'A',
    'Other expenses D — Total',
    'CURRENCY',
    'ReturnData/IRS990/OtherExpensesGrp/TotalAmt'
  ),
  (
    9033,
    NULL,
    'B',
    'Other expenses D — Program',
    'CURRENCY',
    'ReturnData/IRS990/OtherExpensesGrp/ProgramServicesAmt'
  ),
  (
    9033,
    NULL,
    'C',
    'Other expenses D — Mgmt',
    'CURRENCY',
    'ReturnData/IRS990/OtherExpensesGrp/ManagementAndGeneralAmt'
  ),
  (
    9033,
    NULL,
    'D',
    'Other expenses D — Fundraising',
    'CURRENCY',
    'ReturnData/IRS990/OtherExpensesGrp/FundraisingAmt'
  ),
  -- Line 24e: All other expenses
  (
    9034,
    NULL,
    'A',
    'All other expenses — Total',
    'CURRENCY',
    'ReturnData/IRS990/AllOtherExpensesGrp/TotalAmt'
  ),
  (
    9034,
    NULL,
    'B',
    'All other expenses — Program',
    'CURRENCY',
    'ReturnData/IRS990/AllOtherExpensesGrp/ProgramServicesAmt'
  ),
  (
    9034,
    NULL,
    'C',
    'All other expenses — Mgmt',
    'CURRENCY',
    'ReturnData/IRS990/AllOtherExpensesGrp/ManagementAndGeneralAmt'
  ),
  (
    9034,
    NULL,
    'D',
    'All other expenses — Fundraising',
    'CURRENCY',
    'ReturnData/IRS990/AllOtherExpensesGrp/FundraisingAmt'
  ),
  -- Line 25: Total functional expenses
  (
    9035,
    NULL,
    'A',
    'Total functional expenses — Total',
    'CURRENCY',
    'ReturnData/IRS990/TotalFunctionalExpensesGrp/TotalAmt'
  ),
  (
    9035,
    NULL,
    'B',
    'Total functional expenses — Program',
    'CURRENCY',
    'ReturnData/IRS990/TotalFunctionalExpensesGrp/ProgramServicesAmt'
  ),
  (
    9035,
    NULL,
    'C',
    'Total functional expenses — Mgmt',
    'CURRENCY',
    'ReturnData/IRS990/TotalFunctionalExpensesGrp/ManagementAndGeneralAmt'
  ),
  (
    9035,
    NULL,
    'D',
    'Total functional expenses — Fundraising',
    'CURRENCY',
    'ReturnData/IRS990/TotalFunctionalExpensesGrp/FundraisingAmt'
  );

-- =======================
-- PART X — BALANCE SHEET
-- Columns: A=Beginning of Year (BOY), B=End of Year (EOY)
-- =======================
INSERT INTO
  line (
    line_id,
    section_id,
    line_number,
    line_label,
    data_type
  )
VALUES
  -- Assets
  (
    10001,
    1000,
    '1',
    'Cash — non-interest-bearing',
    'CURRENCY'
  ),
  (
    10002,
    1000,
    '2',
    'Savings and temporary cash investments',
    'CURRENCY'
  ),
  (
    10003,
    1000,
    '3',
    'Pledges and grants receivable, net',
    'CURRENCY'
  ),
  (
    10004,
    1000,
    '4',
    'Accounts receivable, net',
    'CURRENCY'
  ),
  (
    10005,
    1000,
    '5',
    'Loans and other receivables from current/former officers, directors, trustees, key employees',
    'CURRENCY'
  ),
  (
    10006,
    1000,
    '6',
    'Loans and other receivables from other disqualified persons',
    'CURRENCY'
  ),
  (
    10007,
    1000,
    '7',
    'Notes and loans receivable, net',
    'CURRENCY'
  ),
  (
    10008,
    1000,
    '8',
    'Inventories for sale or use',
    'CURRENCY'
  ),
  (
    10009,
    1000,
    '9',
    'Prepaid expenses and deferred charges',
    'CURRENCY'
  ),
  (
    10010,
    1000,
    '10a',
    'Land, buildings, and equipment: cost or other basis',
    'CURRENCY'
  ),
  (
    10011,
    1000,
    '10b',
    'Less: accumulated depreciation',
    'CURRENCY'
  ),
  (
    10012,
    1000,
    '10c',
    'Land, buildings, and equipment, net',
    'CURRENCY'
  ),
  (
    10013,
    1000,
    '11',
    'Investments — publicly traded securities',
    'CURRENCY'
  ),
  (
    10014,
    1000,
    '12',
    'Investments — other securities',
    'CURRENCY'
  ),
  (
    10015,
    1000,
    '13',
    'Investments — program-related',
    'CURRENCY'
  ),
  (
    10016,
    1000,
    '14',
    'Intangible assets',
    'CURRENCY'
  ),
  (10017, 1000, '15', 'Other assets', 'CURRENCY'),
  (10018, 1000, '16', 'Total assets', 'CURRENCY'),
  -- Liabilities
  (
    10019,
    1000,
    '17',
    'Accounts payable and accrued expenses',
    'CURRENCY'
  ),
  (10020, 1000, '18', 'Grants payable', 'CURRENCY'),
  (10021, 1000, '19', 'Deferred revenue', 'CURRENCY'),
  (
    10022,
    1000,
    '20',
    'Tax-exempt bond liabilities',
    'CURRENCY'
  ),
  (
    10023,
    1000,
    '21',
    'Escrow or custodial account liability',
    'CURRENCY'
  ),
  (
    10024,
    1000,
    '22',
    'Loans and other payables to current/former officers, directors, trustees, key employees',
    'CURRENCY'
  ),
  (
    10025,
    1000,
    '23',
    'Secured mortgages and notes payable to unrelated third parties',
    'CURRENCY'
  ),
  (
    10026,
    1000,
    '24',
    'Unsecured notes and loans payable to unrelated third parties',
    'CURRENCY'
  ),
  (
    10027,
    1000,
    '25',
    'Other liabilities',
    'CURRENCY'
  ),
  (
    10028,
    1000,
    '26',
    'Total liabilities',
    'CURRENCY'
  ),
  -- Net Assets
  (
    10029,
    1000,
    '27',
    'Net assets without donor restrictions',
    'CURRENCY'
  ),
  (
    10030,
    1000,
    '28',
    'Net assets with donor restrictions',
    'CURRENCY'
  ),
  (
    10031,
    1000,
    '29',
    'Capital stock or trust principal, or current funds',
    'CURRENCY'
  ),
  (
    10032,
    1000,
    '30',
    'Paid-in or capital surplus',
    'CURRENCY'
  ),
  (
    10033,
    1000,
    '31',
    'Retained earnings, endowment, accumulated income, or other funds',
    'CURRENCY'
  ),
  (
    10034,
    1000,
    '32',
    'Total net assets or fund balances',
    'CURRENCY'
  ),
  (
    10035,
    1000,
    '33',
    'Total liabilities and net assets/fund balances',
    'CURRENCY'
  );

INSERT INTO
  field (
    line_id,
    sub_letter,
    column_code,
    box_label,
    data_type,
    xml_path
  )
VALUES
  -- Line 1
  (
    10001,
    NULL,
    'A',
    'Cash non-interest-bearing — BOY',
    'CURRENCY',
    'ReturnData/IRS990/CashNonInterestBearingGrp/BOYAmt'
  ),
  (
    10001,
    NULL,
    'B',
    'Cash non-interest-bearing — EOY',
    'CURRENCY',
    'ReturnData/IRS990/CashNonInterestBearingGrp/EOYAmt'
  ),
  -- Line 2
  (
    10002,
    NULL,
    'A',
    'Savings and temp cash investments — BOY',
    'CURRENCY',
    'ReturnData/IRS990/SavingsAndTempCashInvstGrp/BOYAmt'
  ),
  (
    10002,
    NULL,
    'B',
    'Savings and temp cash investments — EOY',
    'CURRENCY',
    'ReturnData/IRS990/SavingsAndTempCashInvstGrp/EOYAmt'
  ),
  -- Line 3
  (
    10003,
    NULL,
    'A',
    'Pledges and grants receivable — BOY',
    'CURRENCY',
    'ReturnData/IRS990/PledgesAndGrantsReceivableGrp/BOYAmt'
  ),
  (
    10003,
    NULL,
    'B',
    'Pledges and grants receivable — EOY',
    'CURRENCY',
    'ReturnData/IRS990/PledgesAndGrantsReceivableGrp/EOYAmt'
  ),
  -- Line 4
  (
    10004,
    NULL,
    'A',
    'Accounts receivable — BOY',
    'CURRENCY',
    'ReturnData/IRS990/AccountsReceivableGrp/BOYAmt'
  ),
  (
    10004,
    NULL,
    'B',
    'Accounts receivable — EOY',
    'CURRENCY',
    'ReturnData/IRS990/AccountsReceivableGrp/EOYAmt'
  ),
  -- Line 5
  (
    10005,
    NULL,
    'A',
    'Loans receivable from officers — BOY',
    'CURRENCY',
    'ReturnData/IRS990/ReceivablesFromOfficersEtcGrp/BOYAmt'
  ),
  (
    10005,
    NULL,
    'B',
    'Loans receivable from officers — EOY',
    'CURRENCY',
    'ReturnData/IRS990/ReceivablesFromOfficersEtcGrp/EOYAmt'
  ),
  -- Line 6
  (
    10006,
    NULL,
    'A',
    'Loans receivable from disqualified persons — BOY',
    'CURRENCY',
    'ReturnData/IRS990/RcvblFromDisqualifiedPrsnGrp/BOYAmt'
  ),
  (
    10006,
    NULL,
    'B',
    'Loans receivable from disqualified persons — EOY',
    'CURRENCY',
    'ReturnData/IRS990/RcvblFromDisqualifiedPrsnGrp/EOYAmt'
  ),
  -- Line 7
  (
    10007,
    NULL,
    'A',
    'Notes and loans receivable — BOY',
    'CURRENCY',
    'ReturnData/IRS990/OthNotesLoansReceivableNetGrp/BOYAmt'
  ),
  (
    10007,
    NULL,
    'B',
    'Notes and loans receivable — EOY',
    'CURRENCY',
    'ReturnData/IRS990/OthNotesLoansReceivableNetGrp/EOYAmt'
  ),
  -- Line 8
  (
    10008,
    NULL,
    'A',
    'Inventories for sale or use — BOY',
    'CURRENCY',
    'ReturnData/IRS990/InventoriesForSaleOrUseGrp/BOYAmt'
  ),
  (
    10008,
    NULL,
    'B',
    'Inventories for sale or use — EOY',
    'CURRENCY',
    'ReturnData/IRS990/InventoriesForSaleOrUseGrp/EOYAmt'
  ),
  -- Line 9
  (
    10009,
    NULL,
    'A',
    'Prepaid expenses and deferred charges — BOY',
    'CURRENCY',
    'ReturnData/IRS990/PrepaidExpensesDefrdChargesGrp/BOYAmt'
  ),
  (
    10009,
    NULL,
    'B',
    'Prepaid expenses and deferred charges — EOY',
    'CURRENCY',
    'ReturnData/IRS990/PrepaidExpensesDefrdChargesGrp/EOYAmt'
  ),
  -- Line 10a (EOY only per form)
  (
    10010,
    NULL,
    'B',
    'Land, buildings, equipment cost basis — EOY',
    'CURRENCY',
    'ReturnData/IRS990/LandBldgEquipCostOrOtherBssAmt'
  ),
  -- Line 10b (EOY only)
  (
    10011,
    NULL,
    'B',
    'Accumulated depreciation — EOY',
    'CURRENCY',
    'ReturnData/IRS990/LandBldgEquipAccumDeprecAmt'
  ),
  -- Line 10c
  (
    10012,
    NULL,
    'A',
    'Land, buildings, equipment net — BOY',
    'CURRENCY',
    'ReturnData/IRS990/LandBldgEquipBasisNetGrp/BOYAmt'
  ),
  (
    10012,
    NULL,
    'B',
    'Land, buildings, equipment net — EOY',
    'CURRENCY',
    'ReturnData/IRS990/LandBldgEquipBasisNetGrp/EOYAmt'
  ),
  -- Line 11
  (
    10013,
    NULL,
    'A',
    'Investments publicly traded securities — BOY',
    'CURRENCY',
    'ReturnData/IRS990/InvestmentsPubTradedSecGrp/BOYAmt'
  ),
  (
    10013,
    NULL,
    'B',
    'Investments publicly traded securities — EOY',
    'CURRENCY',
    'ReturnData/IRS990/InvestmentsPubTradedSecGrp/EOYAmt'
  ),
  -- Line 12
  (
    10014,
    NULL,
    'A',
    'Investments other securities — BOY',
    'CURRENCY',
    'ReturnData/IRS990/InvestmentsOtherSecuritiesGrp/BOYAmt'
  ),
  (
    10014,
    NULL,
    'B',
    'Investments other securities — EOY',
    'CURRENCY',
    'ReturnData/IRS990/InvestmentsOtherSecuritiesGrp/EOYAmt'
  ),
  -- Line 13
  (
    10015,
    NULL,
    'A',
    'Investments program-related — BOY',
    'CURRENCY',
    'ReturnData/IRS990/InvestmentsProgramRelatedGrp/BOYAmt'
  ),
  (
    10015,
    NULL,
    'B',
    'Investments program-related — EOY',
    'CURRENCY',
    'ReturnData/IRS990/InvestmentsProgramRelatedGrp/EOYAmt'
  ),
  -- Line 14
  (
    10016,
    NULL,
    'A',
    'Intangible assets — BOY',
    'CURRENCY',
    'ReturnData/IRS990/IntangibleAssetsGrp/BOYAmt'
  ),
  (
    10016,
    NULL,
    'B',
    'Intangible assets — EOY',
    'CURRENCY',
    'ReturnData/IRS990/IntangibleAssetsGrp/EOYAmt'
  ),
  -- Line 15
  (
    10017,
    NULL,
    'A',
    'Other assets — BOY',
    'CURRENCY',
    'ReturnData/IRS990/OtherAssetsTotalGrp/BOYAmt'
  ),
  (
    10017,
    NULL,
    'B',
    'Other assets — EOY',
    'CURRENCY',
    'ReturnData/IRS990/OtherAssetsTotalGrp/EOYAmt'
  ),
  -- Line 16
  (
    10018,
    NULL,
    'A',
    'Total assets — BOY',
    'CURRENCY',
    'ReturnData/IRS990/TotalAssetsGrp/BOYAmt'
  ),
  (
    10018,
    NULL,
    'B',
    'Total assets — EOY',
    'CURRENCY',
    'ReturnData/IRS990/TotalAssetsGrp/EOYAmt'
  ),
  -- Line 17
  (
    10019,
    NULL,
    'A',
    'Accounts payable and accrued expenses — BOY',
    'CURRENCY',
    'ReturnData/IRS990/AccountsPayableAccrExpnssGrp/BOYAmt'
  ),
  (
    10019,
    NULL,
    'B',
    'Accounts payable and accrued expenses — EOY',
    'CURRENCY',
    'ReturnData/IRS990/AccountsPayableAccrExpnssGrp/EOYAmt'
  ),
  -- Line 18
  (
    10020,
    NULL,
    'A',
    'Grants payable — BOY',
    'CURRENCY',
    'ReturnData/IRS990/GrantsPayableGrp/BOYAmt'
  ),
  (
    10020,
    NULL,
    'B',
    'Grants payable — EOY',
    'CURRENCY',
    'ReturnData/IRS990/GrantsPayableGrp/EOYAmt'
  ),
  -- Line 19
  (
    10021,
    NULL,
    'A',
    'Deferred revenue — BOY',
    'CURRENCY',
    'ReturnData/IRS990/DeferredRevenueGrp/BOYAmt'
  ),
  (
    10021,
    NULL,
    'B',
    'Deferred revenue — EOY',
    'CURRENCY',
    'ReturnData/IRS990/DeferredRevenueGrp/EOYAmt'
  ),
  -- Line 20
  (
    10022,
    NULL,
    'A',
    'Tax-exempt bond liabilities — BOY',
    'CURRENCY',
    'ReturnData/IRS990/TaxExemptBondLiabilitiesGrp/BOYAmt'
  ),
  (
    10022,
    NULL,
    'B',
    'Tax-exempt bond liabilities — EOY',
    'CURRENCY',
    'ReturnData/IRS990/TaxExemptBondLiabilitiesGrp/EOYAmt'
  ),
  -- Line 21
  (
    10023,
    NULL,
    'A',
    'Escrow or custodial account liability — BOY',
    'CURRENCY',
    'ReturnData/IRS990/EscrowAccountLiabilityGrp/BOYAmt'
  ),
  (
    10023,
    NULL,
    'B',
    'Escrow or custodial account liability — EOY',
    'CURRENCY',
    'ReturnData/IRS990/EscrowAccountLiabilityGrp/EOYAmt'
  ),
  -- Line 22
  (
    10024,
    NULL,
    'A',
    'Loans payable to officers — BOY',
    'CURRENCY',
    'ReturnData/IRS990/LoansFromOfficersDirectorsGrp/BOYAmt'
  ),
  (
    10024,
    NULL,
    'B',
    'Loans payable to officers — EOY',
    'CURRENCY',
    'ReturnData/IRS990/LoansFromOfficersDirectorsGrp/EOYAmt'
  ),
  -- Line 23
  (
    10025,
    NULL,
    'A',
    'Secured mortgages and notes payable — BOY',
    'CURRENCY',
    'ReturnData/IRS990/MortgNotesPyblScrdInvstPropGrp/BOYAmt'
  ),
  (
    10025,
    NULL,
    'B',
    'Secured mortgages and notes payable — EOY',
    'CURRENCY',
    'ReturnData/IRS990/MortgNotesPyblScrdInvstPropGrp/EOYAmt'
  ),
  -- Line 24
  (
    10026,
    NULL,
    'A',
    'Unsecured notes and loans payable — BOY',
    'CURRENCY',
    'ReturnData/IRS990/UnsecuredNotesLoansPayableGrp/BOYAmt'
  ),
  (
    10026,
    NULL,
    'B',
    'Unsecured notes and loans payable — EOY',
    'CURRENCY',
    'ReturnData/IRS990/UnsecuredNotesLoansPayableGrp/EOYAmt'
  ),
  -- Line 25
  (
    10027,
    NULL,
    'A',
    'Other liabilities — BOY',
    'CURRENCY',
    'ReturnData/IRS990/OtherLiabilitiesGrp/BOYAmt'
  ),
  (
    10027,
    NULL,
    'B',
    'Other liabilities — EOY',
    'CURRENCY',
    'ReturnData/IRS990/OtherLiabilitiesGrp/EOYAmt'
  ),
  -- Line 26
  (
    10028,
    NULL,
    'A',
    'Total liabilities — BOY',
    'CURRENCY',
    'ReturnData/IRS990/TotalLiabilitiesGrp/BOYAmt'
  ),
  (
    10028,
    NULL,
    'B',
    'Total liabilities — EOY',
    'CURRENCY',
    'ReturnData/IRS990/TotalLiabilitiesGrp/EOYAmt'
  ),
  -- Line 27
  (
    10029,
    NULL,
    'A',
    'Net assets without donor restrictions — BOY',
    'CURRENCY',
    'ReturnData/IRS990/NoDonorRestrictionNetAssetsGrp/BOYAmt'
  ),
  (
    10029,
    NULL,
    'B',
    'Net assets without donor restrictions — EOY',
    'CURRENCY',
    'ReturnData/IRS990/NoDonorRestrictionNetAssetsGrp/EOYAmt'
  ),
  -- Line 28
  (
    10030,
    NULL,
    'A',
    'Net assets with donor restrictions — BOY',
    'CURRENCY',
    'ReturnData/IRS990/DonorRestrictionNetAssetsGrp/BOYAmt'
  ),
  (
    10030,
    NULL,
    'B',
    'Net assets with donor restrictions — EOY',
    'CURRENCY',
    'ReturnData/IRS990/DonorRestrictionNetAssetsGrp/EOYAmt'
  ),
  -- Line 29
  (
    10031,
    NULL,
    'A',
    'Capital stock or trust principal — BOY',
    'CURRENCY',
    'ReturnData/IRS990/CapStkTrPrinCurrentFundsGrp/BOYAmt'
  ),
  (
    10031,
    NULL,
    'B',
    'Capital stock or trust principal — EOY',
    'CURRENCY',
    'ReturnData/IRS990/CapStkTrPrinCurrentFundsGrp/EOYAmt'
  ),
  -- Line 30
  (
    10032,
    NULL,
    'A',
    'Paid-in or capital surplus — BOY',
    'CURRENCY',
    'ReturnData/IRS990/PdInCapSrplsLandBldgEqpFundGrp/BOYAmt'
  ),
  (
    10032,
    NULL,
    'B',
    'Paid-in or capital surplus — EOY',
    'CURRENCY',
    'ReturnData/IRS990/PdInCapSrplsLandBldgEqpFundGrp/EOYAmt'
  ),
  -- Line 31
  (
    10033,
    NULL,
    'A',
    'Retained earnings, endowment, accumulated income — BOY',
    'CURRENCY',
    'ReturnData/IRS990/RtnEarnEndowmentIncmOthFndsGrp/BOYAmt'
  ),
  (
    10033,
    NULL,
    'B',
    'Retained earnings, endowment, accumulated income — EOY',
    'CURRENCY',
    'ReturnData/IRS990/RtnEarnEndowmentIncmOthFndsGrp/EOYAmt'
  ),
  -- Line 32
  (
    10034,
    NULL,
    'A',
    'Total net assets or fund balances — BOY',
    'CURRENCY',
    'ReturnData/IRS990/TotalNetAssetsFundBalanceGrp/BOYAmt'
  ),
  (
    10034,
    NULL,
    'B',
    'Total net assets or fund balances — EOY',
    'CURRENCY',
    'ReturnData/IRS990/TotalNetAssetsFundBalanceGrp/EOYAmt'
  ),
  -- Line 33
  (
    10035,
    NULL,
    'A',
    'Total liabilities and net assets — BOY',
    'CURRENCY',
    'ReturnData/IRS990/TotLiabNetAssetsFundBalanceGrp/BOYAmt'
  ),
  (
    10035,
    NULL,
    'B',
    'Total liabilities and net assets — EOY',
    'CURRENCY',
    'ReturnData/IRS990/TotLiabNetAssetsFundBalanceGrp/EOYAmt'
  );
