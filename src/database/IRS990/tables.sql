PRAGMA foreign_keys = ON;

CREATE TABLE states (
    code TEXT PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE business_activity_codes (
    code TEXT PRIMARY KEY,
    description TEXT
);

CREATE TABLE organization_types (
    code TEXT PRIMARY KEY,
    description TEXT
);

CREATE TABLE organizations (
    ein TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tax_returns (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    ein TEXT NOT NULL,
    tax_year INTEGER NOT NULL,
    return_type TEXT NOT NULL,
    phone TEXT,
    care_of TEXT,
    address TEXT,
    city TEXT,
    state TEXT,
    zip TEXT,
    is_501_org INTEGER DEFAULT 0,
    org_type TEXT,
    is_501c_trust INTEGER DEFAULT 0,
    is_state_college_university INTEGER DEFAULT 0,
    book_value_assets_eoy REAL,
    schedule_a_count INTEGER DEFAULT 0,
    is_subsidiary INTEGER DEFAULT 0,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(ein, tax_year),
    FOREIGN KEY (ein) REFERENCES organizations(ein) ON DELETE CASCADE,
    FOREIGN KEY (state) REFERENCES states(code),
    FOREIGN KEY (org_type) REFERENCES organization_types(code)
);

CREATE TABLE tax_computations (
    return_id INTEGER PRIMARY KEY,
    total_ubti_computed REAL DEFAULT 0,
    charitable_contributions_deduction REAL DEFAULT 0,
    ubti_before_nol_specific REAL DEFAULT 0,
    ubti_before_section_199a REAL,
    nol_deduction REAL DEFAULT 0,
    specific_deduction REAL DEFAULT 0,
    total_deductions REAL DEFAULT 0,
    total_ubti REAL DEFAULT 0,
    taxable_trust REAL DEFAULT 0,
    taxable_corporation REAL DEFAULT 0,
    uses_tax_rate_schedule INTEGER DEFAULT 0,
    total_tax_computed REAL DEFAULT 0,
    general_business_credit REAL DEFAULT 0,
    total_credits REAL DEFAULT 0,
    tax_after_credits REAL DEFAULT 0,
    other_taxes REAL DEFAULT 0,
    total_tax REAL DEFAULT 0,
    balance_due REAL,
    tax_paid REAL,
    FOREIGN KEY (return_id) REFERENCES tax_returns(id) ON DELETE CASCADE
);

CREATE TABLE return_questions (
    return_id INTEGER PRIMARY KEY,
    has_foreign_accounts INTEGER DEFAULT 0,
    has_foreign_trust INTEGER DEFAULT 0,
    tax_exempt_interest REAL DEFAULT 0,
    changed_accounting_method INTEGER DEFAULT 0,
    FOREIGN KEY (return_id) REFERENCES tax_returns(id) ON DELETE CASCADE
);

CREATE TABLE nol_carryovers (
    return_id INTEGER PRIMARY KEY,
    pre_2018_carryover REAL DEFAULT 0,
    post_2017_carryover REAL DEFAULT 0,
    FOREIGN KEY (return_id) REFERENCES tax_returns(id) ON DELETE CASCADE
);

CREATE TABLE income_totals (
    return_id INTEGER PRIMARY KEY,
    rent_income REAL DEFAULT 0,
    rent_deductions REAL DEFAULT 0,
    debt_financed_income REAL DEFAULT 0,
    debt_financed_deductions REAL DEFAULT 0,
    dividends_received_deduction REAL DEFAULT 0,
    controlled_org_income REAL DEFAULT 0,
    controlled_org_deductions REAL DEFAULT 0,
    investment_income REAL DEFAULT 0,
    set_aside_deductions REAL DEFAULT 0,
    advertising_income REAL DEFAULT 0,
    advertising_costs REAL DEFAULT 0,
    excess_readership_costs REAL DEFAULT 0,
    unrelated_business_compensation REAL DEFAULT 0,
    FOREIGN KEY (return_id) REFERENCES tax_returns(id) ON DELETE CASCADE
);

CREATE TABLE schedule_a (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    return_id INTEGER NOT NULL,
    sequence_num INTEGER NOT NULL,
    sequence_total INTEGER NOT NULL,
    activity_code TEXT,
    business_description TEXT,
    UNIQUE(return_id, sequence_num),
    FOREIGN KEY (return_id) REFERENCES tax_returns(id) ON DELETE CASCADE,
    FOREIGN KEY (activity_code) REFERENCES business_activity_codes(code)
);

CREATE TABLE schedule_a_income (
    schedule_a_id INTEGER PRIMARY KEY,
    gross_receipts REAL DEFAULT 0,
    cost_of_goods_sold REAL DEFAULT 0,
    total_cogs REAL DEFAULT 0,
    net_receipts REAL DEFAULT 0,
    gross_profit REAL DEFAULT 0,
    other_income REAL DEFAULT 0,
    ubi_gross REAL DEFAULT 0,
    ubi_expenses REAL DEFAULT 0,
    ubi_net REAL DEFAULT 0,
    salaries_wages REAL DEFAULT 0,
    depreciation REAL DEFAULT 0,
    total_deductions REAL DEFAULT 0,
    ubi_before_nol REAL DEFAULT 0,
    taxable_ubi REAL DEFAULT 0,
    debt_financed_income REAL DEFAULT 0,
    investment_income REAL DEFAULT 0,
    exploited_activity_income REAL DEFAULT 0,
    FOREIGN KEY (schedule_a_id) REFERENCES schedule_a(id) ON DELETE CASCADE
);

CREATE TABLE schedule_a_rental (
    schedule_a_id INTEGER PRIMARY KEY,
    rent_from_property REAL DEFAULT 0,
    total_rents REAL DEFAULT 0,
    rent_deductions REAL DEFAULT 0,
    net_rent_income REAL DEFAULT 0,
    FOREIGN KEY (schedule_a_id) REFERENCES schedule_a(id) ON DELETE CASCADE
);

CREATE INDEX idx_returns_ein ON tax_returns(ein);
CREATE INDEX idx_returns_year ON tax_returns(tax_year);
CREATE INDEX idx_returns_ein_year ON tax_returns(ein, tax_year);
CREATE INDEX idx_schedule_a_return ON schedule_a(return_id);
CREATE INDEX idx_schedule_a_activity ON schedule_a(activity_code);

CREATE VIEW v_full_return AS
SELECT
    tr.*,
    tc.total_ubti_computed,
    tc.charitable_contributions_deduction,
    tc.ubti_before_nol_specific,
    tc.ubti_before_section_199a,
    tc.nol_deduction,
    tc.specific_deduction,
    tc.total_deductions,
    tc.total_ubti,
    tc.taxable_trust,
    tc.taxable_corporation,
    tc.uses_tax_rate_schedule,
    tc.total_tax_computed,
    tc.general_business_credit,
    tc.total_credits,
    tc.tax_after_credits,
    tc.other_taxes,
    tc.total_tax,
    tc.balance_due,
    tc.tax_paid,
    rq.has_foreign_accounts,
    rq.has_foreign_trust,
    rq.tax_exempt_interest,
    rq.changed_accounting_method,
    nc.pre_2018_carryover,
    nc.post_2017_carryover
FROM tax_returns tr
LEFT JOIN tax_computations tc ON tr.id = tc.return_id
LEFT JOIN return_questions rq ON tr.id = rq.return_id
LEFT JOIN nol_carryovers nc ON tr.id = nc.return_id;

CREATE VIEW v_full_schedule_a AS
SELECT
    sa.*,
    sai.gross_receipts,
    sai.cost_of_goods_sold,
    sai.total_cogs,
    sai.net_receipts,
    sai.gross_profit,
    sai.other_income,
    sai.ubi_gross,
    sai.ubi_expenses,
    sai.ubi_net,
    sai.salaries_wages,
    sai.depreciation,
    sai.total_deductions,
    sai.ubi_before_nol,
    sai.taxable_ubi,
    sai.debt_financed_income,
    sai.investment_income,
    sai.exploited_activity_income,
    sar.rent_from_property,
    sar.total_rents,
    sar.rent_deductions,
    sar.net_rent_income
FROM schedule_a sa
LEFT JOIN schedule_a_income sai ON sa.id = sai.schedule_a_id
LEFT JOIN schedule_a_rental sar ON sa.id = sar.schedule_a_id;
