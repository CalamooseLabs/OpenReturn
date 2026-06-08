INSERT OR IGNORE INTO
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

INSERT OR IGNORE INTO
  form (code, name, description, supported)
VALUES
  (
    "990",
    "990",
    "Most common type of 990 form, typically used by larger organizations.",
    1
  ),
  (
    "990EZ",
    "990-EZ",
    "Used by medium sized organizations.",
    1
  ),
  (
    "990N",
    "990-N",
    "Used by small sized organizations.",
    1
  ),
  ("990PF", "990-PF", "Used by private foundations.", 1),
  (
    "990T",
    "990-T",
    "Used by organizations with unrelated business income.",
    1
  );

INSERT OR IGNORE INTO
  data_type
VALUES
  ('CURRENCY', 'Monetary amount in USD'),
  ('INTEGER', 'Whole number'),
  ('TEXT', 'Free-form text string'),
  ('BOOLEAN', 'True/false or yes/no indicator'),
  ('DATE', 'Calendar date'),
  ('PERCENT', 'Percentage value');

INSERT OR IGNORE INTO
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

INSERT OR IGNORE INTO
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
INSERT OR IGNORE INTO
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
INSERT OR IGNORE INTO
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
INSERT OR IGNORE INTO
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

INSERT OR IGNORE INTO
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
INSERT OR IGNORE INTO
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
INSERT OR IGNORE INTO
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
INSERT OR IGNORE INTO
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
INSERT OR IGNORE INTO
  line (
    line_id,
    section_id,
    line_number,
    line_label,
    data_type
  )
VALUES
  (8040, 804, '12', 'Total revenue', 'CURRENCY');

INSERT OR IGNORE INTO
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
INSERT OR IGNORE INTO
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

INSERT OR IGNORE INTO
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
INSERT OR IGNORE INTO
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

INSERT OR IGNORE INTO
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

-- =======================
-- 990-EZ
-- =======================
INSERT OR IGNORE INTO
  part (part_id, form_code, part_number, part_name)
VALUES
  (21, "990EZ", 'I',   'Revenue, Expenses, and Changes in Net Assets or Fund Balances'),
  (22, "990EZ", 'II',  'Balance Sheets'),
  (23, "990EZ", 'III', 'Statement of Program Service Accomplishments'),
  (24, "990EZ", 'V',   'Other Information');

INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (2100, 21, 'NONE', NULL),
  (2200, 22, 'NONE', NULL),
  (2300, 23, 'NONE', NULL),
  (2400, 24, 'NONE', NULL);

INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  -- Part I Revenue
  (21001, 2100, '1',   'Contributions, gifts, grants, and similar amounts received', 'CURRENCY'),
  (21002, 2100, '2',   'Program service revenue including government fees and contracts', 'CURRENCY'),
  (21003, 2100, '3',   'Membership dues and assessments', 'CURRENCY'),
  (21004, 2100, '4',   'Investment income', 'CURRENCY'),
  (21005, 2100, '5a',  'Gross amount from sale of assets excluding inventory', 'CURRENCY'),
  (21006, 2100, '5b',  'Less: cost or other basis and sales expenses', 'CURRENCY'),
  (21007, 2100, '5c',  'Gain or (loss) from sale of assets other than inventory', 'CURRENCY'),
  (21008, 2100, '6a',  'Gaming and fundraising events: gross income', 'CURRENCY'),
  (21009, 2100, '6b',  'Gaming and fundraising events: direct expenses', 'CURRENCY'),
  (21010, 2100, '6c',  'Net income (loss) from gaming and fundraising events', 'CURRENCY'),
  (21011, 2100, '7a',  'Gross sales of inventory, less returns and allowances', 'CURRENCY'),
  (21012, 2100, '7b',  'Less: cost of goods sold', 'CURRENCY'),
  (21013, 2100, '7c',  'Gross profit (loss) from sales of inventory', 'CURRENCY'),
  (21014, 2100, '8',   'Other revenue (describe in Schedule O)', 'CURRENCY'),
  (21015, 2100, '9',   'Total revenue', 'CURRENCY'),
  -- Part I Expenses
  (21016, 2100, '10',  'Grants and similar amounts paid', 'CURRENCY'),
  (21017, 2100, '11',  'Benefits paid to or for members', 'CURRENCY'),
  (21018, 2100, '12',  'Salaries, other compensation, and employee benefits', 'CURRENCY'),
  (21019, 2100, '13',  'Professional fees and other payments to independent contractors', 'CURRENCY'),
  (21020, 2100, '14',  'Occupancy, rent, utilities, and maintenance', 'CURRENCY'),
  (21021, 2100, '15',  'Printing, publications, postage, and shipping', 'CURRENCY'),
  (21022, 2100, '16',  'Other expenses (describe in Schedule O)', 'CURRENCY'),
  (21023, 2100, '17',  'Total expenses', 'CURRENCY'),
  (21024, 2100, '18',  'Excess or (deficit) for the year', 'CURRENCY'),
  (21025, 2100, '19',  'Net assets or fund balances at beginning of year', 'CURRENCY'),
  (21026, 2100, '20',  'Other changes in net assets or fund balances', 'CURRENCY'),
  (21027, 2100, '21',  'Net assets or fund balances at end of year', 'CURRENCY'),
  -- Part II Balance Sheet (end of year)
  (22001, 2200, '22',  'Cash, savings, and investments', 'CURRENCY'),
  (22002, 2200, '23',  'Land and buildings', 'CURRENCY'),
  (22003, 2200, '24',  'Other assets (describe in Schedule O)', 'CURRENCY'),
  (22004, 2200, '25',  'Total assets', 'CURRENCY'),
  (22005, 2200, '26',  'Total liabilities (describe in Schedule O)', 'CURRENCY'),
  -- Part III Program Service
  (23001, 2300, '32',  'Primary exempt purpose', 'TEXT'),
  -- Part V Other Information
  (24001, 2400, '33a', 'Number of employees', 'INTEGER');

INSERT OR IGNORE INTO
  field (
    line_id,
    sub_letter,
    column_code,
    box_label,
    data_type,
    xml_path
  )
VALUES
  -- Part I Revenue
  (21001, NULL, NULL, 'Contributions, gifts, grants', 'CURRENCY', 'ReturnData/IRS990EZ/ContributionsGiftsGrantsEtcAmt'),
  (21002, NULL, NULL, 'Program service revenue', 'CURRENCY', 'ReturnData/IRS990EZ/ProgramServiceRevenueAmt'),
  (21003, NULL, NULL, 'Membership dues', 'CURRENCY', 'ReturnData/IRS990EZ/MembershipDuesAmt'),
  (21004, NULL, NULL, 'Investment income', 'CURRENCY', 'ReturnData/IRS990EZ/InvestmentIncomeAmt'),
  (21005, NULL, NULL, 'Gross amount from sale of assets', 'CURRENCY', 'ReturnData/IRS990EZ/GrossAmountSaleAssetsAmt'),
  (21006, NULL, NULL, 'Cost basis and sales expenses', 'CURRENCY', 'ReturnData/IRS990EZ/CostBasisAndSalesExpensesAmt'),
  (21007, NULL, NULL, 'Gain or loss from sale of assets', 'CURRENCY', 'ReturnData/IRS990EZ/GainOrLossFromSaleOfAssetsAmt'),
  (21008, NULL, NULL, 'Gaming gross income', 'CURRENCY', 'ReturnData/IRS990EZ/GamingGrossIncomeAmt'),
  (21009, NULL, NULL, 'Gaming direct expenses', 'CURRENCY', 'ReturnData/IRS990EZ/GamingDirectExpensesAmt'),
  (21010, NULL, NULL, 'Net income from gaming and fundraising', 'CURRENCY', 'ReturnData/IRS990EZ/GamingOrFundraisingNtIncmAmt'),
  (21011, NULL, NULL, 'Gross sales of inventory', 'CURRENCY', 'ReturnData/IRS990EZ/GrossSalesOfInventoryAmt'),
  (21012, NULL, NULL, 'Cost of goods sold', 'CURRENCY', 'ReturnData/IRS990EZ/CostOfGoodsSoldAmt'),
  (21013, NULL, NULL, 'Gross profit from inventory', 'CURRENCY', 'ReturnData/IRS990EZ/GrossProftLossSlsOfInvntryAmt'),
  (21014, NULL, NULL, 'Other revenue', 'CURRENCY', 'ReturnData/IRS990EZ/OtherRevenueTotalAmt'),
  (21015, NULL, NULL, 'Total revenue', 'CURRENCY', 'ReturnData/IRS990EZ/TotalRevenueAmt'),
  -- Part I Expenses
  (21016, NULL, NULL, 'Grants and similar amounts paid', 'CURRENCY', 'ReturnData/IRS990EZ/GrantsAndSimilarAmountsPaidAmt'),
  (21017, NULL, NULL, 'Benefits paid to members', 'CURRENCY', 'ReturnData/IRS990EZ/BenefitsPaidToOrForMembersAmt'),
  (21018, NULL, NULL, 'Salaries and employee benefits', 'CURRENCY', 'ReturnData/IRS990EZ/SalariesOtherCompEmpBnftsAmt'),
  (21019, NULL, NULL, 'Professional fees and contractor payments', 'CURRENCY', 'ReturnData/IRS990EZ/FeesAndOtherPymtToIndCntrctAmt'),
  (21020, NULL, NULL, 'Occupancy, rent, utilities, and maintenance', 'CURRENCY', 'ReturnData/IRS990EZ/OccupancyRentUtltsAndMaintAmt'),
  (21021, NULL, NULL, 'Printing, publications, postage', 'CURRENCY', 'ReturnData/IRS990EZ/PrintingPublicationsPostageAmt'),
  (21022, NULL, NULL, 'Other expenses', 'CURRENCY', 'ReturnData/IRS990EZ/OtherExpensesTotalAmt'),
  (21023, NULL, NULL, 'Total expenses', 'CURRENCY', 'ReturnData/IRS990EZ/TotalExpensesAmt'),
  (21024, NULL, NULL, 'Excess or deficit for the year', 'CURRENCY', 'ReturnData/IRS990EZ/ExcessOrDeficitForYearAmt'),
  (21025, NULL, NULL, 'Net assets beginning of year', 'CURRENCY', 'ReturnData/IRS990EZ/NetAssetsOrFundBalancesBOYAmt'),
  (21026, NULL, NULL, 'Other changes in net assets', 'CURRENCY', 'ReturnData/IRS990EZ/OtherChangesInNetAssetsAmt'),
  (21027, NULL, NULL, 'Net assets end of year', 'CURRENCY', 'ReturnData/IRS990EZ/NetAssetsOrFundBalancesEOYAmt'),
  -- Part II Balance Sheet
  (22001, NULL, NULL, 'Cash, savings, and investments', 'CURRENCY', 'ReturnData/IRS990EZ/CashSavingsAndInvestmentsEOYAmt'),
  (22002, NULL, NULL, 'Land and buildings', 'CURRENCY', 'ReturnData/IRS990EZ/LandAndBuildingsEOYAmt'),
  (22003, NULL, NULL, 'Other assets', 'CURRENCY', 'ReturnData/IRS990EZ/OtherAssetsEOYAmt'),
  (22004, NULL, NULL, 'Total assets', 'CURRENCY', 'ReturnData/IRS990EZ/TotalAssetsEOYAmt'),
  (22005, NULL, NULL, 'Total liabilities', 'CURRENCY', 'ReturnData/IRS990EZ/TotalLiabilitiesEOYAmt'),
  -- Part III Mission
  (23001, NULL, NULL, 'Primary exempt purpose', 'TEXT', 'ReturnData/IRS990EZ/PrimaryExemptPurposeTxt'),
  -- Part V Other
  (24001, NULL, NULL, 'Total employees', 'INTEGER', 'ReturnData/IRS990EZ/TotalEmployeeCnt');

-- =======================
-- 990-N (e-Postcard)
-- =======================
INSERT OR IGNORE INTO
  part (part_id, form_code, part_number, part_name)
VALUES
  (31, "990N", 'I', 'Organization Information');

INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (3100, 31, 'NONE', NULL);

INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (31001, 3100, '1', 'Gross receipts not greater than $50,000', 'BOOLEAN'),
  (31002, 3100, '2', '501(c)(3) organization indicator', 'BOOLEAN'),
  (31003, 3100, '3', 'Organization terminated indicator', 'BOOLEAN'),
  (31004, 3100, '4', 'Website address', 'TEXT'),
  (31005, 3100, '5', 'Principal officer name', 'TEXT');

INSERT OR IGNORE INTO
  field (
    line_id,
    sub_letter,
    column_code,
    box_label,
    data_type,
    xml_path
  )
VALUES
  (31001, NULL, NULL, 'Gross receipts not greater than $50,000', 'BOOLEAN', 'ReturnData/IRS990N/GrossReceiptsNotGreaterThan50000Ind'),
  (31002, NULL, NULL, '501(c)(3) organization', 'BOOLEAN', 'ReturnData/IRS990N/Organization501c3Ind'),
  (31003, NULL, NULL, 'Organization terminated', 'BOOLEAN', 'ReturnData/IRS990N/OrganizationTerminatedInd'),
  (31004, NULL, NULL, 'Website address', 'TEXT', 'ReturnData/IRS990N/WebsiteAddressTxt'),
  (31005, NULL, NULL, 'Principal officer name', 'TEXT', 'ReturnData/IRS990N/PrincipalOfficerNm');

-- =======================
-- 990-PF
-- =======================
INSERT OR IGNORE INTO
  part (part_id, form_code, part_number, part_name)
VALUES
  (41, "990PF", 'I',   'Analysis of Revenue and Expenses'),
  (42, "990PF", 'II',  'Balance Sheets'),
  (43, "990PF", 'VI',  'Excise Tax Based on Investment Income'),
  (44, "990PF", 'XII', 'Qualifying Distributions');

INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (4100, 41, 'NONE', NULL),
  (4200, 42, 'NONE', NULL),
  (4300, 43, 'NONE', NULL),
  (4400, 44, 'NONE', NULL);

INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  -- Part I Revenue (per books column)
  (41001, 4100, '1',   'Contributions, gifts, grants received', 'CURRENCY'),
  (41002, 4100, '2',   'Distributions from split-interest trusts', 'CURRENCY'),
  (41003, 4100, '3',   'Interest on savings and temporary cash investments', 'CURRENCY'),
  (41004, 4100, '4',   'Dividends and interest from securities', 'CURRENCY'),
  (41005, 4100, '5a',  'Gross rents', 'CURRENCY'),
  (41006, 4100, '6a',  'Net gain or (loss) from sale of assets not on line 10', 'CURRENCY'),
  (41007, 4100, '10',  'Gross profit or (loss) from sales of inventory', 'CURRENCY'),
  (41008, 4100, '11',  'Other income', 'CURRENCY'),
  (41009, 4100, '12',  'Total revenue', 'CURRENCY'),
  -- Part I Expenses
  (41010, 4100, '13',  'Compensation of officers, directors, trustees, etc.', 'CURRENCY'),
  (41011, 4100, '14',  'Other employee salaries and wages', 'CURRENCY'),
  (41012, 4100, '15',  'Pension plans, employee benefits', 'CURRENCY'),
  (41013, 4100, '16a', 'Legal fees', 'CURRENCY'),
  (41014, 4100, '16b', 'Accounting fees', 'CURRENCY'),
  (41015, 4100, '16c', 'Other professional fees', 'CURRENCY'),
  (41016, 4100, '17',  'Interest', 'CURRENCY'),
  (41017, 4100, '18',  'Taxes', 'CURRENCY'),
  (41018, 4100, '19',  'Depreciation and depletion', 'CURRENCY'),
  (41019, 4100, '20',  'Occupancy', 'CURRENCY'),
  (41020, 4100, '21',  'Travel, conferences, and meetings', 'CURRENCY'),
  (41021, 4100, '22',  'Printing and publications', 'CURRENCY'),
  (41022, 4100, '23',  'Other expenses', 'CURRENCY'),
  (41023, 4100, '24',  'Total operating and administrative expenses', 'CURRENCY'),
  (41024, 4100, '25',  'Contributions, gifts, grants paid', 'CURRENCY'),
  (41025, 4100, '26',  'Total expenses and disbursements', 'CURRENCY'),
  (41026, 4100, '27a', 'Excess of revenue over expenses and disbursements', 'CURRENCY'),
  -- Part II Balance Sheet
  (42001, 4200, '16',  'Total assets', 'CURRENCY'),
  (42002, 4200, '22',  'Total liabilities', 'CURRENCY'),
  (42003, 4200, '24',  'Net assets or fund balances', 'CURRENCY'),
  -- Part VI Excise Tax
  (43001, 4300, '5',   'Domestic foundations subject to 1.39% tax', 'CURRENCY'),
  -- Part XII Qualifying Distributions
  (44001, 4400, '4',   'Qualifying distributions (total)', 'CURRENCY');

INSERT OR IGNORE INTO
  field (
    line_id,
    sub_letter,
    column_code,
    box_label,
    data_type,
    xml_path
  )
VALUES
  -- Part I Revenue (per books column, column A)
  (41001, NULL, 'A', 'Contributions received — per books', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisRevExpnssGrp/ContriRcvdRevAndExpnssGrp/RevenueAndExpensesPerBooksAmt'),
  (41003, NULL, 'A', 'Interest income — per books', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisRevExpnssGrp/IntrstRcvdRevAndExpnssGrp/RevenueAndExpensesPerBooksAmt'),
  (41004, NULL, 'A', 'Dividends and interest from securities — per books', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisRevExpnssGrp/DividendsRevAndExpnssGrp/RevenueAndExpensesPerBooksAmt'),
  (41009, NULL, 'A', 'Total revenue — per books', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisRevExpnssGrp/TotalRevAndExpnssGrp/RevenueAndExpensesPerBooksAmt'),
  (41009, NULL, 'B', 'Total revenue — net investment income', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisRevExpnssGrp/TotalRevAndExpnssGrp/NetInvestmentIncomeAmt'),
  -- Part I Expenses (per books column)
  (41010, NULL, 'A', 'Officer compensation — per books', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisRevExpnssGrp/OfficerDirTrstKeyEmplInfoGrp/CompOfHghstPdEmplOrNoEmplInd'),
  (41025, NULL, 'A', 'Total expenses — per books', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisRevExpnssGrp/TotExpnsAndDsbrsmntsGrp/RevenueAndExpensesPerBooksAmt'),
  (41025, NULL, 'B', 'Total expenses — net investment income', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisRevExpnssGrp/TotExpnsAndDsbrsmntsGrp/NetInvestmentIncomeAmt'),
  (41026, NULL, 'A', 'Excess of revenue over expenses — per books', 'CURRENCY', 'ReturnData/IRS990PF/AnalysisRevExpnssGrp/ExcessRevenueOverExpnssGrp/RevenueAndExpensesPerBooksAmt'),
  -- Part II Balance Sheet (end of year)
  (42001, NULL, 'B', 'Total assets — end of year', 'CURRENCY', 'ReturnData/IRS990PF/TotalAssetsEOYAmt'),
  (42002, NULL, 'B', 'Total liabilities — end of year', 'CURRENCY', 'ReturnData/IRS990PF/TotalLiabilitiesEOYAmt'),
  (42003, NULL, 'B', 'Net assets or fund balances — end of year', 'CURRENCY', 'ReturnData/IRS990PF/TotNetAstOrFundBalancesEOYAmt'),
  -- Part XII Qualifying Distributions
  (44001, NULL, NULL, 'Total qualifying distributions', 'CURRENCY', 'ReturnData/IRS990PF/TotalQualifyingDistribtnsAmt');

-- =======================
-- 990-T
-- =======================
INSERT OR IGNORE INTO
  part (part_id, form_code, part_number, part_name)
VALUES
  (51, "990T", 'I',  'Unrelated Trade or Business Income'),
  (52, "990T", 'II', 'Deductions Not Taken Elsewhere'),
  (53, "990T", 'IV', 'Tax Computation');

INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (5100, 51, 'NONE', NULL),
  (5200, 52, 'NONE', NULL),
  (5300, 53, 'NONE', NULL);

INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  -- Part I UBI
  (51001, 5100, '13', 'Total of unrelated business income', 'CURRENCY'),
  (51002, 5100, '14', 'Deductions', 'CURRENCY'),
  (51003, 5100, '15', 'Unrelated business taxable income before NOL deduction', 'CURRENCY'),
  (51004, 5100, '16', 'Net operating loss deduction', 'CURRENCY'),
  (51005, 5100, '17', 'Unrelated business taxable income', 'CURRENCY'),
  -- Part IV Tax Computation
  (53001, 5300, '1',  'Unrelated business taxable income', 'CURRENCY'),
  (53002, 5300, '2',  'Tax', 'CURRENCY'),
  (53003, 5300, '10', 'Total tax', 'CURRENCY');

INSERT OR IGNORE INTO
  field (
    line_id,
    sub_letter,
    column_code,
    box_label,
    data_type,
    xml_path
  )
VALUES
  -- Part I UBI
  (51001, NULL, NULL, 'Total gross income from unrelated trade or business', 'CURRENCY', 'ReturnData/IRS990T/TotalGrossUBIAmt'),
  (51002, NULL, NULL, 'Total deductions', 'CURRENCY', 'ReturnData/IRS990T/TotalDeductionsAmt'),
  (51003, NULL, NULL, 'Unrelated business taxable income before NOL', 'CURRENCY', 'ReturnData/IRS990T/UBIBeforeNOLDedAmt'),
  (51004, NULL, NULL, 'Net operating loss deduction', 'CURRENCY', 'ReturnData/IRS990T/NetOperatingLossDeductionAmt'),
  (51005, NULL, NULL, 'Unrelated business taxable income', 'CURRENCY', 'ReturnData/IRS990T/UnrelatedBusinessTaxableIncm'),
  -- Part IV Tax
  (53001, NULL, NULL, 'Unrelated business taxable income', 'CURRENCY', 'ReturnData/IRS990T/TaxableIncome990TAmt'),
  (53002, NULL, NULL, 'Tax on unrelated business taxable income', 'CURRENCY', 'ReturnData/IRS990T/TaxOnUBIAmt'),
  (53003, NULL, NULL, 'Total tax', 'CURRENCY', 'ReturnData/IRS990T/TotalTaxAmt');
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