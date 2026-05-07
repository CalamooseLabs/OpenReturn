CREATE TABLE IF NOT EXISTS organization (
  ein CHARACTER(10) PRIMARY KEY,
  name TEXT NOT NULL,
  business_address_id CHARACTER(36),
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (business_address_id) REFERENCES address (uuid)
);

CREATE TABLE IF NOT EXISTS address (
  uuid CHARACTER(36) PRIMARY KEY,
  street TEXT NOT NULL,
  city TEXT NOT NULL,
  state_code CHARACTER(2) NOT NULL,
  zipcode CHARACTER(5) NOT NULL,
  FOREIGN KEY (state_code) REFERENCES state (code)
);

DROP TABLE IF EXISTS state;
CREATE TABLE state (
  code CHARACTER(2) PRIMARY KEY,
  name TEXT NOT NULL
);

INSERT INTO state VALUES
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

DROP TABLE IF EXISTS form_type;
CREATE TABLE IF NOT EXISTS form_type (
  code TEXT PRIMARY KEY,
  description TEXT
);

INSERT INTO form_type VALUES
  ("990", "Most common type of 990 form, typically used by larger organizations."),
  ("990-EZ", "Used by medium sized organizations."),
  ("990-N", "Used by small sized organizations."),
  ("990-PF", "Used by private foundations."),
  ("990-T", "Used by organizations with unrelated business income.");

CREATE TABLE IF NOT EXISTS organization_type (
  code TEXT PRIMARY KEY,
  description TEXT
);

CREATE TABLE IF NOT EXISTS summary (
  id INTEGER PRIMARY KEY AUTOINCREMENT,

  gross_receipts INTEGER,

  -- Activities & Governance (Lines 1–7)
  mission_or_significant_activities TEXT,            -- Line 1
  discontinued_operations BOOLEAN,                  -- Line 2 (checkbox)
  num_voting_governing_body_members INTEGER,         -- Line 3
  num_independent_voting_members INTEGER,            -- Line 4
  num_employees INTEGER,                             -- Line 5
  num_volunteers INTEGER,                            -- Line 6
  total_unrelated_business_revenue INTEGER,          -- Line 7a
  net_unrelated_business_taxable_income INTEGER,     -- Line 7b

  -- Revenue (Lines 8–12) — Prior Year & Current Year
  contributions_and_grants_prior INTEGER,            -- Line 8
  contributions_and_grants_current INTEGER,

  program_service_revenue_prior INTEGER,             -- Line 9
  program_service_revenue_current INTEGER,

  investment_income_prior INTEGER,                   -- Line 10
  investment_income_current INTEGER,

  other_revenue_prior INTEGER,                       -- Line 11
  other_revenue_current INTEGER,

  total_revenue_prior INTEGER,                       -- Line 12
  total_revenue_current INTEGER,

  -- Expenses (Lines 13–19) — Prior Year & Current Year
  grants_and_similar_amounts_paid_prior INTEGER,     -- Line 13
  grants_and_similar_amounts_paid_current INTEGER,

  benefits_paid_to_members_prior INTEGER,            -- Line 14
  benefits_paid_to_members_current INTEGER,

  salaries_compensation_benefits_prior INTEGER,      -- Line 15
  salaries_compensation_benefits_current INTEGER,

  professional_fundraising_fees_prior INTEGER,       -- Line 16a
  professional_fundraising_fees_current INTEGER,

  total_fundraising_expenses_current INTEGER,        -- Line 16b (current year only — no prior year column on form)

  other_expenses_prior INTEGER,                      -- Line 17
  other_expenses_current INTEGER,

  total_expenses_prior INTEGER,                      -- Line 18
  total_expenses_current INTEGER,

  revenue_less_expenses_prior INTEGER,               -- Line 19
  revenue_less_expenses_current INTEGER,

  -- Net Assets / Fund Balances (Lines 20–22) — Beginning of Year & End of Year
  total_assets_boy INTEGER,                          -- Line 20
  total_assets_eoy INTEGER,

  total_liabilities_boy INTEGER,                     -- Line 21
  total_liabilities_eoy INTEGER,

  net_assets_or_fund_balances_boy INTEGER,           -- Line 22
  net_assets_or_fund_balances_eoy INTEGER
);

CREATE TABLE IF NOT EXISTS statement_of_revenue (
  id INTEGER PRIMARY KEY AUTOINCREMENT,

  -- Line 1: Contributions, Gifts, Grants (no B/C/D columns — only amounts)
  contributions_federated_campaigns INTEGER,         -- 1a
  contributions_membership_dues INTEGER,             -- 1b
  contributions_fundraising_events INTEGER,          -- 1c
  contributions_related_organizations INTEGER,       -- 1d
  contributions_government_grants INTEGER,           -- 1e
  contributions_all_other INTEGER,                   -- 1f
  contributions_noncash INTEGER,                     -- 1g (included in 1a–1f, not added to total)
  contributions_total INTEGER,                       -- 1h (sum of 1a–1f)

  -- Line 2: Program Service Revenue (has B/C/D columns; 2a–2f are itemized)
  -- 2a–2e are filer-labeled; store desc + 4 columns each
  program_service_revenue_a_desc VARCHAR(255),
  program_service_revenue_a_total INTEGER,
  program_service_revenue_a_related INTEGER,
  program_service_revenue_a_unrelated INTEGER,
  program_service_revenue_a_excluded INTEGER,

  program_service_revenue_b_desc VARCHAR(255),
  program_service_revenue_b_total INTEGER,
  program_service_revenue_b_related INTEGER,
  program_service_revenue_b_unrelated INTEGER,
  program_service_revenue_b_excluded INTEGER,

  program_service_revenue_c_desc VARCHAR(255),
  program_service_revenue_c_total INTEGER,
  program_service_revenue_c_related INTEGER,
  program_service_revenue_c_unrelated INTEGER,
  program_service_revenue_c_excluded INTEGER,

  program_service_revenue_d_desc VARCHAR(255),
  program_service_revenue_d_total INTEGER,
  program_service_revenue_d_related INTEGER,
  program_service_revenue_d_unrelated INTEGER,
  program_service_revenue_d_excluded INTEGER,

  program_service_revenue_e_desc VARCHAR(255),
  program_service_revenue_e_total INTEGER,
  program_service_revenue_e_related INTEGER,
  program_service_revenue_e_unrelated INTEGER,
  program_service_revenue_e_excluded INTEGER,

  -- 2f: All other program service revenue
  program_service_revenue_other_total INTEGER,
  program_service_revenue_other_related INTEGER,
  program_service_revenue_other_unrelated INTEGER,
  program_service_revenue_other_excluded INTEGER,

  -- 2g: Total program service revenue
  program_service_revenue_total INTEGER,
  program_service_revenue_total_related INTEGER,
  program_service_revenue_total_unrelated INTEGER,
  program_service_revenue_total_excluded INTEGER,

  -- Line 3: Investment income (dividends, interest, etc.)
  investment_income_total INTEGER,
  investment_income_related INTEGER,
  investment_income_unrelated INTEGER,
  investment_income_excluded INTEGER,

  -- Line 4: Income from investment of tax-exempt bond proceeds
  tax_exempt_bond_proceeds_income_total INTEGER,
  tax_exempt_bond_proceeds_income_related INTEGER,
  tax_exempt_bond_proceeds_income_unrelated INTEGER,
  tax_exempt_bond_proceeds_income_excluded INTEGER,

  -- Line 5: Royalties
  royalties_total INTEGER,
  royalties_related INTEGER,
  royalties_unrelated INTEGER,
  royalties_excluded INTEGER,

  -- Line 6: Rental revenue (split by real vs. personal property)
  gross_rents_real INTEGER,                          -- 6a(i)
  gross_rents_personal INTEGER,                      -- 6a(ii)
  rental_expenses_real INTEGER,                      -- 6b(i)
  rental_expenses_personal INTEGER,                  -- 6b(ii)
  rental_income_or_loss_real INTEGER,                -- 6c(i)
  rental_income_or_loss_personal INTEGER,            -- 6c(ii)
  net_rental_income_or_loss_total INTEGER,           -- 6d (A)
  net_rental_income_or_loss_related INTEGER,         -- 6d (B)
  net_rental_income_or_loss_unrelated INTEGER,       -- 6d (C)
  net_rental_income_or_loss_excluded INTEGER,        -- 6d (D)

  -- Line 7: Gain/loss from sale of assets (split by securities vs. other)
  gross_sales_securities INTEGER,                    -- 7a(i)
  gross_sales_other_assets INTEGER,                  -- 7a(ii)
  cost_basis_securities INTEGER,                     -- 7b(i)
  cost_basis_other_assets INTEGER,                   -- 7b(ii)
  gain_or_loss_securities INTEGER,                   -- 7c(i)
  gain_or_loss_other_assets INTEGER,                 -- 7c(ii)
  net_gain_or_loss_total INTEGER,                    -- 7d (A)
  net_gain_or_loss_related INTEGER,                  -- 7d (B)
  net_gain_or_loss_unrelated INTEGER,                -- 7d (C)
  net_gain_or_loss_excluded INTEGER,                 -- 7d (D)

  -- Line 8: Fundraising events
  gross_income_fundraising_events INTEGER,           -- 8a
  direct_expenses_fundraising_events INTEGER,        -- 8b
  net_income_fundraising_events_total INTEGER,       -- 8c (A)
  net_income_fundraising_events_related INTEGER,     -- 8c (B)
  net_income_fundraising_events_unrelated INTEGER,   -- 8c (C)
  net_income_fundraising_events_excluded INTEGER,    -- 8c (D)

  -- Line 9: Gaming activities
  gross_income_gaming INTEGER,                       -- 9a
  direct_expenses_gaming INTEGER,                    -- 9b
  net_income_gaming_total INTEGER,                   -- 9c (A)
  net_income_gaming_related INTEGER,                 -- 9c (B)
  net_income_gaming_unrelated INTEGER,               -- 9c (C)
  net_income_gaming_excluded INTEGER,                -- 9c (D)

  -- Line 10: Sales of inventory
  gross_sales_inventory INTEGER,                     -- 10a
  cost_of_goods_sold INTEGER,                        -- 10b
  net_income_sales_inventory_total INTEGER,          -- 10c (A)
  net_income_sales_inventory_related INTEGER,        -- 10c (B)
  net_income_sales_inventory_unrelated INTEGER,      -- 10c (C)
  net_income_sales_inventory_excluded INTEGER,       -- 10c (D)

  -- Line 11: Miscellaneous revenue (11a–11c are filer-labeled)
  miscellaneous_revenue_a_desc VARCHAR(255),
  miscellaneous_revenue_a_total INTEGER,
  miscellaneous_revenue_a_related INTEGER,
  miscellaneous_revenue_a_unrelated INTEGER,
  miscellaneous_revenue_a_excluded INTEGER,

  miscellaneous_revenue_b_desc VARCHAR(255),
  miscellaneous_revenue_b_total INTEGER,
  miscellaneous_revenue_b_related INTEGER,
  miscellaneous_revenue_b_unrelated INTEGER,
  miscellaneous_revenue_b_excluded INTEGER,

  miscellaneous_revenue_c_desc VARCHAR(255),
  miscellaneous_revenue_c_total INTEGER,
  miscellaneous_revenue_c_related INTEGER,
  miscellaneous_revenue_c_unrelated INTEGER,
  miscellaneous_revenue_c_excluded INTEGER,

  -- 11d: All other revenue
  all_other_revenue_total INTEGER,
  all_other_revenue_related INTEGER,
  all_other_revenue_unrelated INTEGER,
  all_other_revenue_excluded INTEGER,

  -- 11e: Total miscellaneous revenue
  miscellaneous_revenue_total INTEGER,
  miscellaneous_revenue_total_related INTEGER,
  miscellaneous_revenue_total_unrelated INTEGER,
  miscellaneous_revenue_total_excluded INTEGER,

  -- Line 12: Total revenue (sum of 1h, 2g, 3–5, 6d, 7d, 8c, 9c, 10c, 11e)
  total_revenue INTEGER,                             -- 12 (A)
  total_revenue_related INTEGER,                     -- 12 (B)
  total_revenue_unrelated INTEGER,                   -- 12 (C)
  total_revenue_excluded INTEGER                     -- 12 (D)
);

CREATE TABLE IF NOT EXISTS statement_of_functional_expenses (
  id INTEGER PRIMARY KEY AUTOINCREMENT,

  -- Line 1: Grants to domestic orgs and governments
  grants_domestic_orgs_total INTEGER,
  grants_domestic_orgs_program INTEGER,
  grants_domestic_orgs_management INTEGER,
  grants_domestic_orgs_fundraising INTEGER,

  -- Line 2: Grants to domestic individuals
  grants_domestic_individuals_total INTEGER,
  grants_domestic_individuals_program INTEGER,
  grants_domestic_individuals_management INTEGER,
  grants_domestic_individuals_fundraising INTEGER,

  -- Line 3: Grants to foreign orgs, governments, and individuals
  grants_foreign_total INTEGER,
  grants_foreign_program INTEGER,
  grants_foreign_management INTEGER,
  grants_foreign_fundraising INTEGER,

  -- Line 4: Benefits paid to or for members
  benefits_paid_to_members_total INTEGER,
  benefits_paid_to_members_program INTEGER,
  benefits_paid_to_members_management INTEGER,
  benefits_paid_to_members_fundraising INTEGER,

  -- Line 5: Compensation of current officers, directors, trustees, key employees
  compensation_officers_total INTEGER,
  compensation_officers_program INTEGER,
  compensation_officers_management INTEGER,
  compensation_officers_fundraising INTEGER,

  -- Line 6: Compensation to disqualified persons
  compensation_disqualified_persons_total INTEGER,
  compensation_disqualified_persons_program INTEGER,
  compensation_disqualified_persons_management INTEGER,
  compensation_disqualified_persons_fundraising INTEGER,

  -- Line 7: Other salaries and wages
  other_salaries_and_wages_total INTEGER,
  other_salaries_and_wages_program INTEGER,
  other_salaries_and_wages_management INTEGER,
  other_salaries_and_wages_fundraising INTEGER,

  -- Line 8: Pension plan accruals and contributions
  pension_plan_contributions_total INTEGER,
  pension_plan_contributions_program INTEGER,
  pension_plan_contributions_management INTEGER,
  pension_plan_contributions_fundraising INTEGER,

  -- Line 9: Other employee benefits
  other_employee_benefits_total INTEGER,
  other_employee_benefits_program INTEGER,
  other_employee_benefits_management INTEGER,
  other_employee_benefits_fundraising INTEGER,

  -- Line 10: Payroll taxes
  payroll_taxes_total INTEGER,
  payroll_taxes_program INTEGER,
  payroll_taxes_management INTEGER,
  payroll_taxes_fundraising INTEGER,

  -- Line 11a: Fees for services - Management
  fees_for_services_management_total INTEGER,
  fees_for_services_management_program INTEGER,
  fees_for_services_management_mgmt INTEGER,
  fees_for_services_management_fundraising INTEGER,

  -- Line 11b: Fees for services - Legal
  fees_for_services_legal_total INTEGER,
  fees_for_services_legal_program INTEGER,
  fees_for_services_legal_management INTEGER,
  fees_for_services_legal_fundraising INTEGER,

  -- Line 11c: Fees for services - Accounting
  fees_for_services_accounting_total INTEGER,
  fees_for_services_accounting_program INTEGER,
  fees_for_services_accounting_management INTEGER,
  fees_for_services_accounting_fundraising INTEGER,

  -- Line 11d: Fees for services - Lobbying
  fees_for_services_lobbying_total INTEGER,
  fees_for_services_lobbying_program INTEGER,
  fees_for_services_lobbying_management INTEGER,
  fees_for_services_lobbying_fundraising INTEGER,

  -- Line 11e: Fees for services - Professional fundraising
  fees_for_services_prof_fundraising_total INTEGER,
  fees_for_services_prof_fundraising_program INTEGER,
  fees_for_services_prof_fundraising_management INTEGER,
  fees_for_services_prof_fundraising_fundraising INTEGER,

  -- Line 11f: Fees for services - Investment management
  fees_for_services_investment_mgmt_total INTEGER,
  fees_for_services_investment_mgmt_program INTEGER,
  fees_for_services_investment_mgmt_management INTEGER,
  fees_for_services_investment_mgmt_fundraising INTEGER,

  -- Line 11g: Fees for services - Other
  fees_for_services_other_total INTEGER,
  fees_for_services_other_program INTEGER,
  fees_for_services_other_management INTEGER,
  fees_for_services_other_fundraising INTEGER,

  -- Line 12: Advertising and promotion
  advertising_and_promotion_total INTEGER,
  advertising_and_promotion_program INTEGER,
  advertising_and_promotion_management INTEGER,
  advertising_and_promotion_fundraising INTEGER,

  -- Line 13: Office expenses
  office_expenses_total INTEGER,
  office_expenses_program INTEGER,
  office_expenses_management INTEGER,
  office_expenses_fundraising INTEGER,

  -- Line 14: Information technology
  information_technology_total INTEGER,
  information_technology_program INTEGER,
  information_technology_management INTEGER,
  information_technology_fundraising INTEGER,

  -- Line 15: Royalties
  royalties_total INTEGER,
  royalties_program INTEGER,
  royalties_management INTEGER,
  royalties_fundraising INTEGER,

  -- Line 16: Occupancy
  occupancy_total INTEGER,
  occupancy_program INTEGER,
  occupancy_management INTEGER,
  occupancy_fundraising INTEGER,

  -- Line 17: Travel
  travel_total INTEGER,
  travel_program INTEGER,
  travel_management INTEGER,
  travel_fundraising INTEGER,

  -- Line 18: Payments of travel/entertainment for public officials
  travel_entertainment_public_officials_total INTEGER,
  travel_entertainment_public_officials_program INTEGER,
  travel_entertainment_public_officials_management INTEGER,
  travel_entertainment_public_officials_fundraising INTEGER,

  -- Line 19: Conferences, conventions, and meetings
  conferences_conventions_meetings_total INTEGER,
  conferences_conventions_meetings_program INTEGER,
  conferences_conventions_meetings_management INTEGER,
  conferences_conventions_meetings_fundraising INTEGER,

  -- Line 20: Interest
  interest_total INTEGER,
  interest_program INTEGER,
  interest_management INTEGER,
  interest_fundraising INTEGER,

  -- Line 21: Payments to affiliates
  payments_to_affiliates_total INTEGER,
  payments_to_affiliates_program INTEGER,
  payments_to_affiliates_management INTEGER,
  payments_to_affiliates_fundraising INTEGER,

  -- Line 22: Depreciation, depletion, and amortization
  depreciation_depletion_amortization_total INTEGER,
  depreciation_depletion_amortization_program INTEGER,
  depreciation_depletion_amortization_management INTEGER,
  depreciation_depletion_amortization_fundraising INTEGER,

  -- Line 23: Insurance
  insurance_total INTEGER,
  insurance_program INTEGER,
  insurance_management INTEGER,
  insurance_fundraising INTEGER,

  -- Line 24a: Other expenses (itemized) - row a
  other_expenses_a_description TEXT,
  other_expenses_a_total INTEGER,
  other_expenses_a_program INTEGER,
  other_expenses_a_management INTEGER,
  other_expenses_a_fundraising INTEGER,

  -- Line 24b: Other expenses (itemized) - row b
  other_expenses_b_description TEXT,
  other_expenses_b_total INTEGER,
  other_expenses_b_program INTEGER,
  other_expenses_b_management INTEGER,
  other_expenses_b_fundraising INTEGER,

  -- Line 24c: Other expenses (itemized) - row c
  other_expenses_c_description TEXT,
  other_expenses_c_total INTEGER,
  other_expenses_c_program INTEGER,
  other_expenses_c_management INTEGER,
  other_expenses_c_fundraising INTEGER,

  -- Line 24d: Other expenses (itemized) - row d
  other_expenses_d_description TEXT,
  other_expenses_d_total INTEGER,
  other_expenses_d_program INTEGER,
  other_expenses_d_management INTEGER,
  other_expenses_d_fundraising INTEGER,

  -- Line 24e: All other expenses
  all_other_expenses_total INTEGER,
  all_other_expenses_program INTEGER,
  all_other_expenses_management INTEGER,
  all_other_expenses_fundraising INTEGER,

  -- Line 25: Total functional expenses
  total_functional_expenses_total INTEGER,
  total_functional_expenses_program INTEGER,
  total_functional_expenses_management INTEGER,
  total_functional_expenses_fundraising INTEGER
);

CREATE TABLE IF NOT EXISTS balance_sheet (
  id INTEGER PRIMARY KEY AUTOINCREMENT,

  -- Line 1: Cash — non-interest-bearing
  cash_non_interest_bearing_boy INTEGER,
  cash_non_interest_bearing_eoy INTEGER,

  -- Line 2: Savings and temporary cash investments
  savings_and_temp_cash_investments_boy INTEGER,
  savings_and_temp_cash_investments_eoy INTEGER,

  -- Line 3: Pledges and grants receivable, net
  pledges_and_grants_receivable_net_boy INTEGER,
  pledges_and_grants_receivable_net_eoy INTEGER,

  -- Line 4: Accounts receivable, net
  accounts_receivable_net_boy INTEGER,
  accounts_receivable_net_eoy INTEGER,

  -- Line 5: Loans & receivables from officers/directors/trustees/key employees
  loans_receivable_from_officers_boy INTEGER,
  loans_receivable_from_officers_eoy INTEGER,

  -- Line 6: Loans & receivables from other disqualified persons
  loans_receivable_from_disqualified_persons_boy INTEGER,
  loans_receivable_from_disqualified_persons_eoy INTEGER,

  -- Line 7: Notes and loans receivable, net
  notes_and_loans_receivable_net_boy INTEGER,
  notes_and_loans_receivable_net_eoy INTEGER,

  -- Line 8: Inventories for sale or use
  inventories_for_sale_or_use_boy INTEGER,
  inventories_for_sale_or_use_eoy INTEGER,

  -- Line 9: Prepaid expenses and deferred charges
  prepaid_expenses_and_deferred_charges_boy INTEGER,
  prepaid_expenses_and_deferred_charges_eoy INTEGER,

  -- Line 10a: Land, buildings & equipment — cost or other basis (EOY only on form)
  land_buildings_equipment_cost_basis_eoy INTEGER,

  -- Line 10b: Less accumulated depreciation (EOY only on form)
  accumulated_depreciation_eoy INTEGER,

  -- Line 10c: Land, buildings & equipment, net
  land_buildings_equipment_net_boy INTEGER,
  land_buildings_equipment_net_eoy INTEGER,

  -- Line 11: Investments — publicly traded securities
  investments_publicly_traded_securities_boy INTEGER,
  investments_publicly_traded_securities_eoy INTEGER,

  -- Line 12: Investments — other securities
  investments_other_securities_boy INTEGER,
  investments_other_securities_eoy INTEGER,

  -- Line 13: Investments — program-related
  investments_program_related_boy INTEGER,
  investments_program_related_eoy INTEGER,

  -- Line 14: Intangible assets
  intangible_assets_boy INTEGER,
  intangible_assets_eoy INTEGER,

  -- Line 15: Other assets
  other_assets_boy INTEGER,
  other_assets_eoy INTEGER,

  -- Line 16: Total assets
  total_assets_boy INTEGER,
  total_assets_eoy INTEGER,

  -- Line 17: Accounts payable and accrued expenses
  accounts_payable_and_accrued_expenses_boy INTEGER,
  accounts_payable_and_accrued_expenses_eoy INTEGER,

  -- Line 18: Grants payable
  grants_payable_boy INTEGER,
  grants_payable_eoy INTEGER,

  -- Line 19: Deferred revenue
  deferred_revenue_boy INTEGER,
  deferred_revenue_eoy INTEGER,

  -- Line 20: Tax-exempt bond liabilities
  tax_exempt_bond_liabilities_boy INTEGER,
  tax_exempt_bond_liabilities_eoy INTEGER,

  -- Line 21: Escrow or custodial account liability
  escrow_or_custodial_account_liability_boy INTEGER,
  escrow_or_custodial_account_liability_eoy INTEGER,

  -- Line 22: Loans & payables to officers/directors/trustees/key employees
  loans_payable_to_officers_boy INTEGER,
  loans_payable_to_officers_eoy INTEGER,

  -- Line 23: Secured mortgages and notes payable to unrelated third parties
  secured_mortgages_and_notes_payable_boy INTEGER,
  secured_mortgages_and_notes_payable_eoy INTEGER,

  -- Line 24: Unsecured notes and loans payable to unrelated third parties
  unsecured_notes_and_loans_payable_boy INTEGER,
  unsecured_notes_and_loans_payable_eoy INTEGER,

  -- Line 25: Other liabilities
  other_liabilities_boy INTEGER,
  other_liabilities_eoy INTEGER,

  -- Line 26: Total liabilities
  total_liabilities_boy INTEGER,
  total_liabilities_eoy INTEGER,

  -- Line 27: Net assets without donor restrictions (FASB ASC 958 orgs)
  net_assets_without_donor_restrictions_boy INTEGER,
  net_assets_without_donor_restrictions_eoy INTEGER,

  -- Line 28: Net assets with donor restrictions (FASB ASC 958 orgs)
  net_assets_with_donor_restrictions_boy INTEGER,
  net_assets_with_donor_restrictions_eoy INTEGER,

  -- Line 29: Capital stock or trust principal, or current funds (non-FASB orgs)
  capital_stock_or_trust_principal_boy INTEGER,
  capital_stock_or_trust_principal_eoy INTEGER,

  -- Line 30: Paid-in or capital surplus (non-FASB orgs)
  paid_in_or_capital_surplus_boy INTEGER,
  paid_in_or_capital_surplus_eoy INTEGER,

  -- Line 31: Retained earnings, endowment, accumulated income (non-FASB orgs)
  retained_earnings_endowment_boy INTEGER,
  retained_earnings_endowment_eoy INTEGER,

  -- Line 32: Total net assets or fund balances
  total_net_assets_or_fund_balances_boy INTEGER,
  total_net_assets_or_fund_balances_eoy INTEGER,

  -- Line 33: Total liabilities and net assets/fund balances
  total_liabilities_and_net_assets_boy INTEGER,
  total_liabilities_and_net_assets_eoy INTEGER
);

CREATE TABLE IF NOT EXISTS tax_return (
  uuid CHARACTER(36) PRIMARY KEY,
  year SMALLINT NOT NULL,
  organization_id CHARACTER(10),
  summary_id INTEGER UNIQUE,
  functional_expenses_id INTEGER UNIQUE,
  revenue_id INTEGER UNIQUE,
  balance_sheet_id INTEGER UNIQUE,
  FOREIGN KEY (organization_id) REFERENCES organization (ein),
  FOREIGN KEY (summary_id) REFERENCES summary (id),
  FOREIGN KEY (functional_expenses_id) REFERENCES statement_of_functional_expenses (id),
  FOREIGN KEY (revenue_id) REFERENCES statement_of_revenue (id),
  FOREIGN KEY (balance_sheet_id) REFERENCES balance_sheet (id)
);
