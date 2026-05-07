import sqlite3

class Database:
  def __init__(self, name="IRS990") -> None:
    self.connection = sqlite3.connect(f"{name}.db")
    self.cursor = self.connection.cursor()

    with open(f'./database/{name}/tables.sql', 'r') as sql_file:
      sql_script = sql_file.read()

    self.cursor.executescript(sql_script)
    self.connection.commit()

  FIELD_MAP = {
    'Return Type Cd': 'return_type',
    'EIN': 'ein',
    'Business Name Line 1Txt': 'name',
    'Business Name Line 2Txt': 'name_line2',
    'Phone Num': 'phone',
    'Foreign Phone Num': 'foreign_phone',
    'In Care Of Nm': 'care_of',
    'Address Line 1Txt': 'address',
    'Address Line 1': 'address',
    'Address Line 2': 'address_line2',
    'City Nm': 'city',
    'City': 'city',
    'State Abbreviation Cd': 'state',
    'State': 'state',
    'ZIP Cd': 'zip',
    'ZIP Code': 'zip',
    'Tax Yr': 'tax_year',
    'Formation Yr': 'formation_year',
    'Legal Domicile State Cd': 'legal_domicile_state',
    'Website Address Txt': 'website',
    'Principal Officer Nm': 'principal_officer',
    'Activity Or Mission Desc': 'activity_description',
    'Mission Desc': 'mission',
    'Primary Activities Txt': 'primary_activities',
    'Primary Exempt Purpose Txt': 'primary_exempt_purpose',
    'Group Exemption Num': 'group_exemption_number',

    'Organization 501Ind': 'is_501_org',
    'Organization 501c Ind': 'is_501c_org',
    'Organization 501c 3Ind': 'is_501c3_org',
    'Organization 501c 3Exempt PF Ind': 'is_501c3_exempt_pf',
    'Organization 501c Type Txt': 'org_type',
    'Organization 501c Trust Ind': 'is_501c_trust',
    'Type Of Organization Corp Ind': 'is_corporation',
    'Type Of Organization Trust Ind': 'is_trust',
    'Type Of Organization Assoc Ind': 'is_association',
    'Type Of Organization Other Ind': 'is_other_org_type',
    'Type Of Organization Other Desc': 'other_org_type_desc',
    'Church Ind': 'is_church',
    'School Ind': 'is_school',
    'Private Operating Foundation Ind': 'is_private_operating_foundation',
    'Public Organization 170Ind': 'is_public_org_170',
    'Publicly Supported Org 509a 2Ind': 'is_publicly_supported_509a2',
    'Public Charity Status Txt': 'public_charity_status',
    'Exempt Code Section Txt': 'exempt_code_section',

    'Gross Receipts Amt': 'gross_receipts',
    'Total Revenue Amt': 'total_revenue',
    'Total Revenue Column Amt': 'total_revenue_column',
    'Total Expenses Amt': 'total_expenses',
    'Total Assets BOY Amt': 'total_assets_boy',
    'Total Assets EOY Amt': 'total_assets_eoy',
    'Total Assets EOYFMV Amt': 'total_assets_eoy_fmv',
    'Total Liabilities BOY Amt': 'total_liabilities_boy',
    'Total Liabilities EOY Amt': 'total_liabilities_eoy',
    'Net Assets Or Fund Balances BOY Amt': 'net_assets_boy',
    'Net Assets Or Fund Balances EOY Amt': 'net_assets_eoy',
    'Tot Net Ast Or Fund Balances EOY Amt': 'net_assets_eoy_alt',
    'Book Value Assets EOY Amt': 'book_value_assets_eoy',
    'FMV Assets EOY Amt': 'fmv_assets_eoy',

    'CY Contributions Grants Amt': 'cy_contributions_grants',
    'CY Program Service Revenue Amt': 'cy_program_service_revenue',
    'CY Investment Income Amt': 'cy_investment_income',
    'CY Other Revenue Amt': 'cy_other_revenue',
    'CY Total Revenue Amt': 'cy_total_revenue',
    'CY Grants And Similar Paid Amt': 'cy_grants_paid',
    'CY Benefits Paid To Members Amt': 'cy_benefits_paid_to_members',
    'CY Salaries Comp Emp Bnft Paid Amt': 'cy_salaries_benefits',
    'CY Total Prof Fndrsng Expns Amt': 'cy_professional_fundraising',
    'CY Total Fundraising Expense Amt': 'cy_total_fundraising',
    'CY Other Expenses Amt': 'cy_other_expenses',
    'CY Total Expenses Amt': 'cy_total_expenses',
    'CY Revenues Less Expenses Amt': 'cy_revenue_less_expenses',

    'PY Contributions Grants Amt': 'py_contributions_grants',
    'PY Program Service Revenue Amt': 'py_program_service_revenue',
    'PY Investment Income Amt': 'py_investment_income',
    'PY Other Revenue Amt': 'py_other_revenue',
    'PY Total Revenue Amt': 'py_total_revenue',
    'PY Grants And Similar Paid Amt': 'py_grants_paid',
    'PY Benefits Paid To Members Amt': 'py_benefits_paid_to_members',
    'PY Salaries Comp Emp Bnft Paid Amt': 'py_salaries_benefits',
    'PY Total Prof Fndrsng Expns Amt': 'py_professional_fundraising',
    'PY Other Expenses Amt': 'py_other_expenses',
    'PY Total Expenses Amt': 'py_total_expenses',
    'PY Revenues Less Expenses Amt': 'py_revenue_less_expenses',

    'Voting Members Governing Body Cnt': 'voting_members_governing_body',
    'Voting Members Independent Cnt': 'voting_members_independent',
    'Governing Body Voting Members Cnt': 'governing_body_voting_members',
    'Independent Voting Member Cnt': 'independent_voting_members',
    'Total Employee Cnt': 'total_employees',
    'Employee Cnt': 'employee_count',
    'Total Volunteers Cnt': 'total_volunteers',

    'Total Gross UBI Amt': 'total_gross_ubi',
    'Net Unrelated Bus Txbl Incm Amt': 'net_unrelated_business_income',
    'Unrelated Business Revenue Amt': 'unrelated_business_revenue',
    'Unrelated Business Taxbl Incm Amt': 'unrelated_business_taxable_income',
    'Organization Had UBI Ind': 'had_ubi',
    'Unrelated Bus Incm Over Limit Ind': 'ubi_over_limit',

    'Total Contributions Amt': 'total_contributions',
    'Federated Campaigns Amt': 'federated_campaigns',
    'Membership Dues Amt': 'membership_dues',
    'Fundraising Amt': 'fundraising',
    'Government Grants Amt': 'government_grants',
    'All Other Contributions Amt': 'all_other_contributions',
    'Noncash Contributions Amt': 'noncash_contributions',
    'Contributions Gifts Grants Etc Amt': 'contributions_gifts_grants',

    'Total Program Service Revenue Amt': 'total_program_service_revenue',
    'Program Service Revenue Amt': 'program_service_revenue',
    'Total Program Service Expenses Amt': 'total_program_service_expenses',
    'Program Service Expenses Amt': 'program_service_expenses',
    'Total Other Prog Srvc Revenue Amt': 'total_other_program_revenue',
    'Total Other Prog Srvc Expense Amt': 'total_other_program_expense',
    'Total Other Prog Srvc Grant Amt': 'total_other_program_grant',

    'Investment Income Amt': 'investment_income',
    'Total Investment Income Amt': 'total_investment_income',
    'Net Investment Income Amt': 'net_investment_income',
    'Total Net Invst Incm Amt': 'total_net_investment_income',
    'Investment Expense Amt': 'investment_expense',
    'Investment Income Election Amt': 'investment_income_election',
    'Investment Income Excise Tax Amt': 'investment_income_excise_tax',
    'Investment Income CY Pct': 'investment_income_cy_pct',
    'Investment Income PY Pct': 'investment_income_py_pct',

    'Grants And Similar Amounts Paid Amt': 'grants_paid',
    'Grants And Allocations Amt': 'grants_allocations',
    'Grant Amt': 'grant_amount',
    'Benefits Paid To Or For Members Amt': 'benefits_paid_to_members',
    'Salaries Other Comp Empl Bnft Amt': 'salaries_compensation_benefits',
    'Employee Benefit Program Amt': 'employee_benefit_program',
    'Fees And Other Pymt To Ind Cntrct Amt': 'fees_to_contractors',
    'Occupancy Rent Utlts And Maint Amt': 'occupancy_rent_utilities',
    'Printing Publications Postage Amt': 'printing_publications_postage',
    'Other Expenses Total Amt': 'other_expenses_total',

    'Fundraising Gross Income Amt': 'fundraising_gross_income',
    'Fundraising Direct Expenses Amt': 'fundraising_direct_expenses',
    'Gaming Gross Income Amt': 'gaming_gross_income',
    'Special Events Net Income Loss Amt': 'special_events_net_income',
    'Special Events Direct Expenses Amt': 'special_events_direct_expenses',

    'Gross Sales Of Inventory Amt': 'gross_sales_inventory',
    'Cost Of Goods Sold Amt': 'cost_of_goods_sold',
    'Gross Profit Loss Sls Of Invntry Amt': 'gross_profit_inventory',

    'Sale Of Assets Gross Amt': 'sale_of_assets_gross',
    'Cost Or Other Basis Expense Sale Amt': 'cost_basis_expense_sale',
    'Gain Or Loss From Sale Of Assets Amt': 'gain_loss_sale_of_assets',
    'Total Gain Or Loss Amt': 'total_gain_loss',
    'Total Net Gain Or Loss Amt': 'total_net_gain_loss',
    'Net Gains Tax Amt': 'net_gains_tax',
    'Net LT Capital Gain Or Loss Amt': 'net_lt_capital_gain_loss',
    'Capital Gain Net Income Amt': 'capital_gain_net_income',

    'Other Revenue Total Amt': 'other_revenue_total',
    'Initiation Fees And Cap Contri Amt': 'initiation_fees_capital_contributions',
    'Donated Services And Use Fclts Amt': 'donated_services_facilities',

    'Land Bldg Equip Cost Or Other Bss Amt': 'land_building_equipment_cost',
    'Land Bldg Equip Accum Deprec Amt': 'land_building_equipment_depreciation',
    'Total Book Value Land Buildings Amt': 'total_book_value_land_buildings',
    'Total Book Value Other Assets Amt': 'total_book_value_other_assets',
    'Investment Cost Or Other Basis Amt': 'investment_cost_basis',
    'Cost Or Other Basis Amt': 'cost_basis',
    'Total Cost Or Other Basis Amt': 'total_cost_basis',
    'Depreciation Amt': 'depreciation',
    'Book Value Amt': 'book_value',
    'Other Cost Or Other Basis Amt': 'other_cost_basis',

    'Total Liability Amt': 'total_liability',
    'Total Liabilities Net Ast BOY Amt': 'total_liabilities_net_assets_boy',
    'Total Liabilities Net Ast EOY Amt': 'total_liabilities_net_assets_eoy',

    'Reconcilation Revenue Expnss Amt': 'reconciliation_revenue_expenses',
    'Other Changes In Net Assets Amt': 'other_changes_net_assets',
    'Prior Period Adjustments Amt': 'prior_period_adjustments',
    'Net Unrlzd Gains Losses Invst Amt': 'net_unrealized_gains_losses',
    'Excess Or Deficit For Year Amt': 'excess_deficit_for_year',
    'Excess Revenue Over Expenses Amt': 'excess_revenue_over_expenses',

    'Total Support Amt': 'total_support',
    'Public Support Total 170Amt': 'public_support_total_170',
    'Public Support Total 509Amt': 'public_support_total_509',
    'Public Support CY 170Pct': 'public_support_cy_170_pct',
    'Public Support PY 170Pct': 'public_support_py_170_pct',
    'Public Support CY 509Pct': 'public_support_cy_509_pct',
    'Public Support PY 509Pct': 'public_support_py_509_pct',
    'Substantial Contributors Tot Amt': 'substantial_contributors_total',
    'Gross Receipts Rltd Activities Amt': 'gross_receipts_related_activities',
    'Current Tax Year Amt': 'current_tax_year_amount',
    'Current Tax Year Minus 1Year Amt': 'tax_year_minus_1_amount',
    'Current Tax Year Minus 2Years Amt': 'tax_year_minus_2_amount',
    'Current Tax Year Minus 3Years Amt': 'tax_year_minus_3_amount',
    'Current Tax Year Minus 4Years Amt': 'tax_year_minus_4_amount',

    'Total UBTI Computed Amt': 'total_ubti_computed',
    'Charitable Contributions Ded Amt': 'charitable_contributions_deduction',
    'Total UBTI Before NOL Specific Amt': 'ubti_before_nol_specific',
    'Total UBTI Before Section 199A Amt': 'ubti_before_section_199a',
    'Net Operating Loss Deduction Amt': 'nol_deduction',
    'Specific Deduction Amt': 'specific_deduction',
    'Total Deduction Amt': 'total_deduction',
    'Total Deductions Amt': 'total_deductions',
    'Total UBTI Amt': 'total_ubti',
    'Taxable Trust Amt': 'taxable_trust',
    'Total Tax Computation Amt': 'total_tax_computed',
    'Tax Less Credits Amt': 'tax_after_credits',
    'Other Taxes Amt': 'other_taxes',
    'Total Tax Amt': 'total_tax',
    'Balance Due Amt': 'balance_due',
    'Paid Tax Liability Amt': 'tax_paid',
    'Tax Due Amt': 'tax_due',
    'Tax Amt': 'tax_amount',
    'Tax On Taxable Income Amt': 'tax_on_taxable_income',
    'Taxable Income Amt': 'taxable_income',
    'Applied To ES Tax Amt': 'applied_to_es_tax',
    'ES Penalty Amt': 'es_penalty',

    'Foreign Accounts Question Ind': 'has_foreign_accounts',
    'Foreign Trust Question Ind': 'has_foreign_trust',
    'Foreign Financial Account Ind': 'has_foreign_financial_account',
    'Foreign Activities Ind': 'has_foreign_activities',
    'Foreign Office Ind': 'has_foreign_office',

    'Avlbl Pre 2018NOL Carryover Amt': 'pre_2018_nol_carryover',
    'Avlbl Post 2017NOL Carryover Amt': 'post_2017_nol_carryover',

    'Principal Business Activity Cd': 'activity_code',
    'Business Cd': 'business_code',
    'Trade Or Business Desc': 'business_description',
    'Sequence Reference Num': 'sequence_num',
    'Sequence Total Num': 'sequence_total',

    'Tot Unrlt Trd Bus Incm Amt': 'ubi_gross',
    'Tot Unrlt Trd Bus Incm Expnss Amt': 'ubi_expenses',
    'Tot Net Unrlt Trd Bus Incm Amt': 'ubi_net',
    'UBI Before NOL Ded Amt': 'ubi_before_nol',
    'Total Prtshp S Corp Income Amt': 'partnership_s_corp_income',

    'Total Rent Income Amt': 'total_rent_income',
    'Total Rent Deductions Amt': 'total_rent_deductions',
    'Total Gross Debt Financed Incm Amt': 'total_debt_financed_income',
    'Total Allocable Deductions Amt': 'total_allocable_deductions',
    'Total Dividends Received Ded Amt': 'total_dividends_received_deduction',
    'Total Ctrl Org Pymt Gross Incm Amt': 'total_controlled_org_income',
    'Total Ctrl Org Deduction Amt': 'total_controlled_org_deduction',
    'Total Deduction Set Asides Amt': 'total_deduction_set_asides',
    'Total Gross Advertising Income Amt': 'total_advertising_income',
    'Total Direct Advertising Cost Amt': 'total_advertising_cost',
    'Tot Excess Readership Costs Ded Amt': 'total_excess_readership_costs',
    'Total Unrelated Business Comp Amt': 'total_unrelated_business_comp',

    'Form 990T Schedule A Attached Cnt': 'schedule_a_count',
    'Subsidiary Corporation Ind': 'is_subsidiary',
    'Org State College University Ind': 'is_state_college_university',

    'Group Return For Affiliates Ind': 'is_group_return',
    'Schedule B Required Ind': 'schedule_b_required',
    'Schedule B Not Required Ind': 'schedule_b_not_required',
    'Schedule J Required Ind': 'schedule_j_required',
    'Schedule O Required Ind': 'schedule_o_required',

    'Political Campaign Acty Ind': 'has_political_campaign_activity',
    'Lobbying Activities Ind': 'has_lobbying_activities',
    'Subject To Proxy Tax Ind': 'subject_to_proxy_tax',
    'Donor Advised Fund Ind': 'has_donor_advised_fund',
    'Donor Advised Fnds Ind': 'has_donor_advised_funds',
    'Conservation Easements Ind': 'has_conservation_easements',
    'Collections Of Art Ind': 'has_art_collections',
    'Credit Counseling Ind': 'has_credit_counseling',
    'Donor Rstr Or Quasi Endowments Ind': 'has_donor_restricted_endowments',

    'Report Land Building Equipment Ind': 'report_land_building_equipment',
    'Report Investments Other Sec Ind': 'report_investments_other_securities',
    'Report Program Related Invst Ind': 'report_program_related_investments',
    'Report Other Assets Ind': 'report_other_assets',
    'Report Other Liabilities Ind': 'report_other_liabilities',
    'Include FIN 48Footnote Ind': 'include_fin48_footnote',

    'Independent Audit Fincl Stmt Ind': 'has_independent_audit',
    'Consolidated Audit Fincl Stmt Ind': 'has_consolidated_audit',
    'Accountant Compile Or Review Ind': 'has_accountant_review',
    'FS Audited Ind': 'financial_statements_audited',
    'Federal Grant Audit Required Ind': 'federal_grant_audit_required',
    'Separate Basis Fincl Stmt Ind': 'separate_basis_financial_stmt',
    'Consolidated Basis Fincl Stmt Ind': 'consolidated_basis_financial_stmt',

    'School Operating Ind': 'is_school_operating',
    'More Than 5000K To Org Ind': 'more_than_5000k_to_org',
    'More Than 5000K To Individuals Ind': 'more_than_5000k_to_individuals',
    'Professional Fundraising Ind': 'has_professional_fundraising',
    'Fundraising Activities Ind': 'has_fundraising_activities',
    'Gaming Activities Ind': 'has_gaming_activities',
    'Operate Hospital Ind': 'operates_hospital',
    'Grants To Organizations Ind': 'grants_to_organizations',
    'Grants To Individuals Ind': 'grants_to_individuals',

    'Tax Exempt Bonds Ind': 'has_tax_exempt_bonds',
    'Engaged In Excess Benefit Trans Ind': 'engaged_excess_benefit_trans',
    'PY Excess Benefit Trans Ind': 'py_excess_benefit_trans',
    'Loan Outstanding Ind': 'has_loan_outstanding',
    'Grant To Related Person Ind': 'grant_to_related_person',
    'Business Rln With Org Mem Ind': 'business_relationship_org_member',
    'Business Rln With Fam Mem Ind': 'business_relationship_family_member',
    'Business Rln With 35Ctrl Ent Ind': 'business_relationship_35_ctrl_entity',

    'Deductible Non Cash Contri Ind': 'has_deductible_noncash_contributions',
    'Deductible Art Contribution Ind': 'has_deductible_art_contributions',
    'Terminate Operations Ind': 'terminated_operations',
    'Partial Liquidation Ind': 'partial_liquidation',
    'Disregarded Entity Ind': 'is_disregarded_entity',
    'Related Entity Ind': 'is_related_entity',
    'Related Organization Ctrl Ent Ind': 'related_org_controlled_entity',
    'Trnsfr Exmpt Non Chrtbl Rltd Org Ind': 'transfer_exempt_non_charitable',
    'Activities Conducted Prtshp Ind': 'activities_conducted_partnership',

    'IRP Document Cnt': 'irp_document_count',
    'IRP Document W 2G Cnt': 'irp_document_w2g_count',
    'Backup Wthld Compliance Ind': 'backup_withholding_compliance',
    'Employment Tax Returns Filed Ind': 'employment_tax_returns_filed',

    'Prohibited Tax Shelter Trans Ind': 'prohibited_tax_shelter_trans',
    'Taxable Party Notification Ind': 'taxable_party_notification',
    'Nondeductible Contributions Ind': 'has_nondeductible_contributions',
    'Indoor Tanning Services Ind': 'has_indoor_tanning_services',
    'Tanning Services Provided Ind': 'tanning_services_provided',
    'Subj To Tax Rmnrtn Ex Prcht Pymt Ind': 'subject_to_tax_remuneration',
    'Subject To Excs Tax Net Invst Inc Ind': 'subject_to_excess_tax_net_investment',

    'Family Or Business Rln Ind': 'has_family_business_relationship',
    'Delegation Of Mgmt Duties Ind': 'has_delegation_mgmt_duties',
    'Change To Org Documents Ind': 'changed_org_documents',
    'Changes To Articles Or Bylaws Ind': 'changed_articles_bylaws',
    'Material Diversion Or Misuse Ind': 'has_material_diversion',
    'Members Or Stockholders Ind': 'has_members_stockholders',
    'Election Of Board Members Ind': 'has_election_board_members',
    'Decisions Subject To Approva Ind': 'decisions_subject_to_approval',
    'Minutes Of Governing Body Ind': 'has_minutes_governing_body',
    'Minutes Of Committees Ind': 'has_minutes_committees',
    'Officer Mailing Address Ind': 'officer_mailing_address',
    'Local Chapters Ind': 'has_local_chapters',
    'Form 990Provided To Gvrn Body Ind': 'form_990_provided_to_governing_body',
    'Conflict Of Interest Policy Ind': 'has_conflict_of_interest_policy',
    'Whistleblower Policy Ind': 'has_whistleblower_policy',
    'Document Retention Policy Ind': 'has_document_retention_policy',
    'Compensation Process CEO Ind': 'has_compensation_process_ceo',
    'Compensation Process Other Ind': 'has_compensation_process_other',
    'Investment In Joint Venture Ind': 'has_investment_joint_venture',

    'Upon Request Ind': 'available_upon_request',
    'No Listed Persons Compensated Ind': 'no_listed_persons_compensated',
    'Described In Section 501c 3Ind': 'described_in_501c3',
    'Significant New Program Srvc Ind': 'has_significant_new_program',
    'Significant Change Ind': 'has_significant_change',

    'Info In Schedule O Part I Ind': 'info_schedule_o_part_i',
    'Info In Schedule O Part II Ind': 'info_schedule_o_part_ii',
    'Info In Schedule O Part III Ind': 'info_schedule_o_part_iii',
    'Info In Schedule O Part V Ind': 'info_schedule_o_part_v',
    'Info In Schedule O Part VI Ind': 'info_schedule_o_part_vi',
    'Info In Schedule O Part VII Ind': 'info_schedule_o_part_vii',
    'Info In Schedule O Part IX Ind': 'info_schedule_o_part_ix',
    'Info In Schedule O Part XI Ind': 'info_schedule_o_part_xi',

    'Person Nm': 'person_name',
    'Title Txt': 'title',
    'Average Hours Per Week Rt': 'avg_hours_per_week',
    'Average Hours Per Week Rltd Org Rt': 'avg_hours_per_week_related_org',
    'Average Hrs Per Wk Devoted To Pos Rt': 'avg_hours_devoted_to_position',
    'Individual Trustee Or Director Ind': 'is_trustee_director',
    'Officer Ind': 'is_officer',
    'Reportable Comp From Org Amt': 'reportable_comp_from_org',
    'Reportable Comp From Rltd Org Amt': 'reportable_comp_from_related_org',
    'Other Compensation Amt': 'other_compensation',
    'Total Reportable Comp From Org Amt': 'total_reportable_comp_from_org',
    'Tot Reportable Comp Rltd Org Amt': 'total_reportable_comp_related_org',
    'Total Other Compensation Amt': 'total_other_compensation',
    'Indiv Rcvd Greater Than 100K Cnt': 'individuals_over_100k_count',
    'Former Ofcr Employees Listed Ind': 'former_officers_listed',
    'Total Comp Greater Than 150K Ind': 'total_comp_over_150k',
    'Compensation From Other Srcs Ind': 'compensation_from_other_sources',
    'Cntrct Rcvd Greater Than 100K Cnt': 'contractors_over_100k_count',

    'Base Compensation Filing Org Amt': 'base_compensation_filing_org',
    'Bonus Filing Organization Amount': 'bonus_filing_org',
    'Bonus Related Organizations Amt': 'bonus_related_orgs',
    'Other Compensation Filing Org Amt': 'other_compensation_filing_org',
    'Other Compensation Rltd Orgs Amt': 'other_compensation_related_orgs',
    'Deferred Compensation Flng Org Amt': 'deferred_compensation_filing_org',
    'Deferred Comp Rltd Orgs Amt': 'deferred_compensation_related_orgs',
    'Nontaxable Benefits Filing Org Amt': 'nontaxable_benefits_filing_org',
    'Nontaxable Benefits Rltd Orgs Amt': 'nontaxable_benefits_related_orgs',
    'Total Compensation Filing Org Amt': 'total_compensation_filing_org',
    'Total Compensation Rltd Orgs Amt': 'total_compensation_related_orgs',
    'Compensation Based On Rltd Orgs Amt': 'compensation_based_on_related_orgs',
    'Compensation Amt': 'compensation',
    'Comp Report Prior 990Filing Org Amt': 'comp_report_prior_990_filing_org',
    'Comp Report Prior 990Rltd Orgs Amt': 'comp_report_prior_990_related_orgs',

    'Comp Based On Revenue Of Flng Org Ind': 'comp_based_on_revenue_filing_org',
    'Comp Bsd Net Earns Flng Org Ind': 'comp_based_net_earnings_filing_org',
    'Comp Bsd Net Earns Rltd Orgs Ind': 'comp_based_net_earnings_related_orgs',
    'Comp Bsd On Rev Related Orgs Ind': 'comp_based_on_revenue_related_orgs',
    'Severance Payment Ind': 'has_severance_payment',
    'Supplemental Nonqual Rtr Plan Ind': 'has_supplemental_nonqual_retirement',
    'Equity Based Comp Arrngm Ind': 'has_equity_based_compensation',
    'Compensation Survey Ind': 'used_compensation_survey',
    'Board Or Committee Approval Ind': 'has_board_committee_approval',
    'Comp Of Hghst Pd Empl Or NONE Txt': 'highest_paid_employee_comp',
    'Comp Of Hghst Pd Cntrct Or NONE Txt': 'highest_paid_contractor_comp',
    'Part VI Of Comp Of Hghst Pd Empl Txt': 'part_vi_highest_paid_employee',
    'Part VI Hghst Pd Cntrct Prof Srvc Txt': 'part_vi_highest_paid_contractor',

    'Event 1Nm': 'event_1_name',
    'Gross Receipts Event 1Amt': 'event_1_gross_receipts',
    'Charitable Contri Event 1Amt': 'event_1_charitable_contributions',
    'Gross Revenue Event 1Amt': 'event_1_gross_revenue',
    'Non Cash Prizes Event 1Amt': 'event_1_noncash_prizes',
    'Food And Beverage Event 1Amt': 'event_1_food_beverage',
    'Entertainment Event 1Amt': 'event_1_entertainment',
    'Other Direct Expenses Event 1Amt': 'event_1_other_direct_expenses',
    'Gross Receipts Total Amt': 'events_gross_receipts_total',
    'Charitable Contributions Tot Amt': 'events_charitable_contributions_total',
    'Gross Revenue Total Events Amt': 'events_gross_revenue_total',
    'Non Cash Prizes Total Events Amt': 'events_noncash_prizes_total',
    'Food And Beverage Total Events Amt': 'events_food_beverage_total',
    'Entertainment Total Events Amt': 'events_entertainment_total',
    'Oth Direct Expnss Total Events Amt': 'events_other_direct_expenses_total',
    'Direct Expense Summary Events Amt': 'events_direct_expense_summary',
    'Net Income Summary Amt': 'events_net_income_summary',

    'Form And Line Reference Desc': 'form_line_reference',
    'Explanation Txt': 'explanation',
    'Description Program Srvc Accom Txt': 'program_service_accomplishment',
    'Declaration Desc': 'declaration',
    'Purpose Desc': 'purpose',
    'Desc': 'description',

    'Expense Amt': 'expense',
    'Revenue Amt': 'revenue',
    'Related Or Exempt Func Income Amt': 'related_exempt_function_income',
    'Exclusion Amt': 'exclusion',
    'Contri Rpt Fundraising Event Amt': 'contributions_reported_fundraising',
    'Total Amt': 'total_amount',
    'BOY Amt': 'boy_amount',
    'EOY Amt': 'eoy_amount',
    'Management And General Amt': 'management_general',
    'Program Services Amt': 'program_services',

    'Method Of Accounting Cash Ind': 'uses_cash_accounting',
    'Method Of Accounting Accrual Ind': 'uses_accrual_accounting',
    'Organization Follows FASB 117Ind': 'follows_fasb_117',
    'Org Does Not Follow FASB 117Ind': 'does_not_follow_fasb_117',

    'First 5Years 170Ind': 'first_5_years_170',
    'Thirty Thr Pct Suprt Tests CY 170Ind': 'thirty_three_pct_support_cy_170',
    'Thirty Thr Pct Suprt Tests CY 509Ind': 'thirty_three_pct_support_cy_509',

    'Contributor Num': 'contributor_number',
    'Business Name Line 1': 'contributor_name',

    'Tax Rate Schedule Ind': 'uses_tax_rate_schedule',
    'Taxable Corporation Amt': 'taxable_corporation',

    'Minimum Investment Return Amt': 'minimum_investment_return',
    'Distributable As Adjusted Amt': 'distributable_as_adjusted',
    'Undistributed Income CY Amt': 'undistributed_income_cy',
    'Undistributed Income PY Ind': 'undistributed_income_py',
    'Treated As Distri From Corpus Amt': 'treated_as_distribution_from_corpus',
    'Cash Deemed Charitable Amt': 'cash_deemed_charitable',
    'Net Vl Noncharitable Assets Amt': 'net_value_noncharitable_assets',
    'FMV All Other Noncharitable Ast Amt': 'fmv_other_noncharitable_assets',
    'Total FMV Of Unused Assets Amt': 'total_fmv_unused_assets',
    'Adjusted Total FMV Of Unused Ast Amt': 'adjusted_total_fmv_unused_assets',
    'Average Monthly Cash Balances Amt': 'avg_monthly_cash_balances',
    'Average Monthly FMV Of Sec Amt': 'avg_monthly_fmv_securities',

    'Contri Paid Dsbrs Chrtbl Amt': 'contributions_paid_disbursements_charitable',
    'Contri Paid Rev And Expnss Amt': 'contributions_paid_revenue_expenses',
    'Tot Opr Expenses Dsbrs Chrtbl Amt': 'total_operating_expenses_disbursements_charitable',
    'Tot Opr Expenses Net Invst Incm Amt': 'total_operating_expenses_net_investment',
    'Tot Opr Expenses Rev And Expnss Amt': 'total_operating_expenses_revenue_expenses',
    'Total Expenses Dsbrs Chrtbl Amt': 'total_expenses_disbursements_charitable',
    'Total Expenses Net Invst Incm Amt': 'total_expenses_net_investment',
    'Total Expenses Rev And Expnss Amt': 'total_expenses_revenue_expenses',
    'Total Rev And Expnss Amt': 'total_revenue_expenses',
    'Expenses And Contributions Amt': 'expenses_and_contributions',

    'Gain Less Included Amt': 'gain_less_included',
    'Gain Plus Dividends Amt': 'gain_plus_dividends',
    'Smaller Gain Amt': 'smaller_gain',
    'Smaller Of Calc Amt': 'smaller_of_calc',
    'Smaller Taxable Incm Or Allowed Amt': 'smaller_taxable_income_or_allowed',
    'Smaller Taxable Income Or Net Amt': 'smaller_taxable_income_or_net',
    'Smaller Times Percent Amt': 'smaller_times_percent',
    'Smllr Txbl Incm Or Oth Allowed Amt': 'smaller_taxable_income_or_other_allowed',
    'Smllr Txi Or Allw Less Smllr Amt': 'smaller_taxable_or_allowed_less_smaller',
    'Taxable Income Less Gain Amt': 'taxable_income_less_gain',
    'Net Income Minus Smaller Amt': 'net_income_minus_smaller',
    'Net Smaller Amt': 'net_smaller',
    'Net Times Percent Amt': 'net_times_percent',
    'Tax Plus Time Percent Amt': 'tax_plus_time_percent',
    'Txi Less Gain Plus Diff Of Smll Amt': 'taxable_income_less_gain_plus_diff',
    'Diff Of Smaller Amt': 'diff_of_smaller',
    'Diff Of Smllr Plus Smllr Of Calc Amt': 'diff_of_smaller_plus_smaller_of_calc',

    'Jeopardy Investments Ind': 'has_jeopardy_investments',
    'Uncorrected PY Jeopardy Invst Ind': 'uncorrected_py_jeopardy_investments',
    'Business Holdings Ind': 'has_business_holdings',
    'Noncharitable Purpose Ind': 'has_noncharitable_purpose',
    'Uncorrected Prior Acts Ind': 'has_uncorrected_prior_acts',
    'Acts Fail To Qlfy As Exceptions Ind': 'acts_fail_to_qualify_exceptions',
    'New Substantial Contributors Ind': 'has_new_substantial_contributors',
    'Own Controlled Entity Ind': 'owns_controlled_entity',
    'Controlled Organization Ind': 'is_controlled_organization',
    'Transaction With Control Ent Ind': 'has_transaction_with_controlled_entity',
    'Direct Controlling NA Cd': 'direct_controlling_na',

    'Sale Or Exch Disqualified Prsn Ind': 'sale_exchange_disqualified_person',
    'Brrw Or Lend Disqualified Prsn Ind': 'borrow_lend_disqualified_person',
    'Furn Goods Disqualified Prsn Ind': 'furnish_goods_disqualified_person',
    'Pay Comp Disqualified Prsn Ind': 'pay_comp_disqualified_person',
    'Transfer Ast Disqualified Prsn Ind': 'transfer_assets_disqualified_person',
    'Pay Premiums Prsnl Bnft Cntrct Ind': 'pay_premiums_personal_benefit_contract',
    'Payment To Government Official Ind': 'payment_to_government_official',

    'Loans Or Loan Guarantees Ind': 'has_loans_or_guarantees',
    'Loans Or Guarantees To Other Org Ind': 'loans_guarantees_to_other_org',
    'Loans Or Guarantees From Oth Org Ind': 'loans_guarantees_from_other_org',
    'Made Loans To From Officers Ind': 'made_loans_to_from_officers',
    'Div Related Organization Ind': 'dividends_related_organization',
    'Receipt Of Int Annts Rnts Rylts Ind': 'receipt_interest_annuities_rents_royalties',
    'Sharing Of Facilities Etc Ind': 'sharing_of_facilities',
    'Sharing Of Facilities Ind': 'sharing_facilities',
    'Paid Employees Sharing Ind': 'paid_employees_sharing',
    'Reimbursement Arrangements Ind': 'has_reimbursement_arrangements',
    'Reimbursement Paid By Other Org Ind': 'reimbursement_paid_by_other_org',
    'Reimbursement Paid To Other Org Ind': 'reimbursement_paid_to_other_org',
    'Performance Of Services Etc Ind': 'performance_of_services',
    'Perform Of Services By Other Org Ind': 'perform_services_by_other_org',
    'Perform Of Services For Oth Org Ind': 'perform_services_for_other_org',
    'Rental Of Facilities Oth Assets Ind': 'rental_of_facilities_other_assets',
    'Rental Of Facilities To Oth Org Ind': 'rental_facilities_to_other_org',
    'Rental Of Fclts From Oth Org Ind': 'rental_facilities_from_other_org',
    'Asset Exchange Ind': 'has_asset_exchange',
    'Asset Sale To Other Org Ind': 'asset_sale_to_other_org',
    'Asset Purchase From Other Org Ind': 'asset_purchase_from_other_org',
    'Sales Or Exchanges Of Assets Ind': 'sales_exchanges_of_assets',
    'Gift Grnt Or Cap Contri To Oth Org Ind': 'gift_grant_capital_to_other_org',
    'Gift Grnt Cap Contri From Oth Org Ind': 'gift_grant_capital_from_other_org',
    'Transfer To Other Org Ind': 'transfer_to_other_org',
    'Transfer From Other Org Ind': 'transfer_from_other_org',
    'Relationships Nonchrtbl EO Ind': 'relationships_noncharitable_eo',
    'Trnsfr Of Cash To Nonchrtbl EO Ind': 'transfer_cash_to_noncharitable_eo',
    'Trnsfr Other Asset Nonchrtbl EO Ind': 'transfer_other_asset_noncharitable_eo',
    'Purchase Of Assets Nonchrtbl EO Ind': 'purchase_assets_noncharitable_eo',

    'Influence Election Ind': 'influenced_election',
    'Influence Legislation Ind': 'influenced_legislation',
    'Legislative Political Acty Ind': 'has_legislative_political_activity',
    'Direct Indirect Pltcl Expend Amt': 'direct_indirect_political_expenditure',

    'Nondiscriminatory Policy Stmt Ind': 'has_nondiscriminatory_policy',
    'Policy Stmt In Brochures Etc Ind': 'policy_in_brochures',
    'Plcy Pblczd Via Broadcast Media Ind': 'policy_publicized_broadcast',
    'Maintain Racial Comp Recs Ind': 'maintains_racial_composition_records',
    'Maintain Scholarships Recs Ind': 'maintains_scholarship_records',
    'Maintain Cpy Of All Sol Ind': 'maintains_copy_solicitations',
    'Maintain Cpy Of Brochures Etc Ind': 'maintains_copy_brochures',
    'Discriminate Race Admiss Plcy Ind': 'discriminate_race_admissions',
    'Discriminate Race Athlt Prog Ind': 'discriminate_race_athletics',
    'Discriminate Race Educ Plcy Ind': 'discriminate_race_education',
    'Discriminate Race Emplm Fculty Ind': 'discriminate_race_employment',
    'Discriminate Race Other Acty Ind': 'discriminate_race_other',
    'Discriminate Race Schs Ind': 'discriminate_race_scholarships',
    'Discriminate Race Stdnts Rghts Ind': 'discriminate_race_student_rights',
    'Discriminate Race Use Of Fclts Ind': 'discriminate_race_facilities',
    'Government Financial Aid Rcvd Ind': 'received_government_financial_aid',
    'Government Financial Aid Rvkd Ind': 'government_financial_aid_revoked',
    'Compliance With Rev Proc 7550Ind': 'compliance_rev_proc_75_50',
    'Comply With Public Insp Rqr Ind': 'comply_public_inspection',

    'Invest Tax Exempt Bonds Ind': 'invest_tax_exempt_bonds',
    'Bond Issued Dt': 'bond_issued_date',
    'Bond Issuer EIN': 'bond_issuer_ein',
    'Bond Reference Cd': 'bond_reference_code',
    'Issue Price Amt': 'issue_price',
    'Defeased Ind': 'is_defeased',
    'On Behalf Of Issuer Ind': 'on_behalf_of_issuer',
    'Pool Financing Ind': 'is_pool_financing',
    'Refunding Tax Exempt Bonds Ind': 'refunding_tax_exempt_bonds',
    'Refunding Taxable Bonds Ind': 'refunding_taxable_bonds',
    'Refunding Escrow Amt': 'refunding_escrow',
    'Issuance Costs From Proceeds Amt': 'issuance_costs_from_proceeds',
    'Gross Proceeds Invested Ind': 'gross_proceeds_invested',
    'Gross Proceeds Invested In GIC Ind': 'gross_proceeds_invested_gic',
    'Escrow Account Ind': 'has_escrow_account',
    'Variable Rate Issue Ind': 'is_variable_rate_issue',
    'Hedge Identified In Bks And Rec Ind': 'hedge_identified_in_books',
    'Final Allocation Made Ind': 'final_allocation_made',
    'Adequate Books And Rec Maint Ind': 'adequate_books_records_maintained',
    'Substantial Completion Yr': 'substantial_completion_year',
    'Retired Amt': 'retired_amount',
    'Total Proceeds Amt': 'total_proceeds',
    'Total Proceeds Sales Price Amt': 'total_proceeds_sales_price',

    'CUSIP Num': 'cusip_number',
    'Securities Amt': 'securities_amount',
    'Property Desc': 'property_description',
    'Acquired Dt': 'acquired_date',
    'Sold Or Disposed Dt': 'sold_disposed_date',
    'Proceeds Sales Price Amt': 'proceeds_sales_price',
    'Gain Or Loss Amt': 'gain_loss',
    'Method Of Amount Determination Txt': 'method_of_determination',
    'Transaction Type Txt': 'transaction_type',
    'Transactions Not Rpted On 1099B Ind': 'transactions_not_reported_1099b',
    'Reduction Claimed Amt': 'reduction_claimed',
    'Amt': 'amount',
    'Real Amt': 'real_amount',
    'Personal Amt': 'personal_amount',
    'Other Amt': 'other_amount',
    'Related Organizations Amt': 'related_organizations_amount',
    'Total For Year Amt': 'total_for_year',

    'Form 990PF Filed With Atty Gen Ind': 'form_990pf_filed_with_attorney_general',
    'Form 1120POL Filed Ind': 'form_1120pol_filed',
    'Form 1120Pol Filed Ind': 'form_1120pol_filed_alt',
    'Form 8038T Filed Ind': 'form_8038t_filed',
    'Form 8282Filed Cnt': 'form_8282_filed_count',
    'Form 8282Property Disposed Of Ind': 'form_8282_property_disposed',
    'Form 8899Filedind': 'form_8899_filed',
    'Form 1098C Filed Ind': 'form_1098c_filed',
    'Form 1041Schedule D Ind': 'form_1041_schedule_d',
    'Filed Schedule A Ind': 'filed_schedule_a',

    'Quid Pro Quo Contributions Ind': 'has_quid_pro_quo_contributions',
    'Rcv Fnds To Pay Prsnl Bnft Cntrct Ind': 'received_funds_personal_benefit_contract',
    'More Than 100Spent Ind': 'more_than_100_spent',
    'At Least 5000In Assets Ind': 'at_least_5000_in_assets',
    'Organization Dissolved Etc Ind': 'organization_dissolved',
    'Section 508e Rqr Satisfied Ind': 'section_508e_satisfied',
    'Chg Made To Orgnzng Doc Not Rpt Ind': 'change_to_organizing_doc_not_reported',
    'Activities Not Previously Rpt Ind': 'activities_not_previously_reported',
    'Initial Return Ind': 'is_initial_return',
    'Address Change Ind': 'is_address_change',
    'Footnote Text Ind': 'has_footnote_text',
    'Audit Committee Ind': 'has_audit_committee',
    'Annual Disclosure Covered Prsn Ind': 'annual_disclosure_covered_persons',
    'Procedures Corrective Action Ind': 'has_procedures_corrective_action',
    'Regular Monitoring Enfrc Ind': 'has_regular_monitoring_enforcement',
    'Written Proc To Monitor Reqs Ind': 'has_written_procedures_monitor',
    'Any Non Fixed Payments Ind': 'has_non_fixed_payments',
    'Initial Contract Exception Ind': 'has_initial_contract_exception',
    'Gross Receipts For Public Use Amt': 'gross_receipts_public_use',
    'States Where Copy Of Return Is Fld Cd': 'states_return_filed',
    'Change In Method Of Accounting Ind': 'changed_accounting_method',
    'Tax Exempt Interest Amt': 'tax_exempt_interest',
  }

  TABLE_MAP = {
    'organizations': [
      'ein', 'name', 'name_line2', 'formation_year', 'legal_domicile_state',
      'website', 'mission', 'activity_description', 'primary_activities',
      'primary_exempt_purpose', 'group_exemption_number'
    ],
    'tax_returns': [
      'ein', 'tax_year', 'return_type', 'phone', 'foreign_phone', 'care_of',
      'address', 'address_line2', 'city', 'state', 'zip', 'principal_officer',
      'is_501_org', 'is_501c_org', 'is_501c3_org', 'is_501c3_exempt_pf',
      'org_type', 'is_501c_trust', 'is_corporation', 'is_trust', 'is_association',
      'is_other_org_type', 'other_org_type_desc', 'is_church', 'is_school',
      'is_private_operating_foundation', 'is_public_org_170',
      'is_publicly_supported_509a2', 'public_charity_status', 'exempt_code_section',
      'book_value_assets_eoy', 'schedule_a_count', 'is_subsidiary',
      'is_state_college_university', 'is_group_return', 'is_initial_return',
      'is_address_change', 'uses_cash_accounting', 'uses_accrual_accounting',
      'follows_fasb_117', 'does_not_follow_fasb_117'
    ],
    'tax_computations': [
      'return_id', 'total_ubti_computed', 'charitable_contributions_deduction',
      'ubti_before_nol_specific', 'ubti_before_section_199a', 'nol_deduction',
      'specific_deduction', 'total_deduction', 'total_deductions', 'total_ubti',
      'taxable_trust', 'taxable_corporation', 'uses_tax_rate_schedule',
      'total_tax_computed', 'general_business_credit', 'total_credits',
      'tax_after_credits', 'other_taxes', 'total_tax', 'balance_due', 'tax_paid',
      'tax_due', 'tax_amount', 'tax_on_taxable_income', 'taxable_income',
      'applied_to_es_tax', 'es_penalty'
    ],
    'return_questions': [
      'return_id', 'has_foreign_accounts', 'has_foreign_trust',
      'has_foreign_financial_account', 'has_foreign_activities', 'has_foreign_office',
      'tax_exempt_interest', 'changed_accounting_method'
    ],
    'nol_carryovers': [
      'return_id', 'pre_2018_nol_carryover', 'post_2017_nol_carryover'
    ],
    'financials': [
      'return_id', 'gross_receipts', 'total_revenue', 'total_revenue_column',
      'total_expenses', 'total_assets_boy', 'total_assets_eoy', 'total_assets_eoy_fmv',
      'total_liabilities_boy', 'total_liabilities_eoy', 'net_assets_boy',
      'net_assets_eoy', 'net_assets_eoy_alt', 'fmv_assets_eoy', 'total_liability',
      'total_liabilities_net_assets_boy', 'total_liabilities_net_assets_eoy',
      'reconciliation_revenue_expenses', 'other_changes_net_assets',
      'prior_period_adjustments', 'net_unrealized_gains_losses',
      'excess_deficit_for_year', 'excess_revenue_over_expenses'
    ],
    'revenue_cy': [
      'return_id', 'cy_contributions_grants', 'cy_program_service_revenue',
      'cy_investment_income', 'cy_other_revenue', 'cy_total_revenue'
    ],
    'expenses_cy': [
      'return_id', 'cy_grants_paid', 'cy_benefits_paid_to_members',
      'cy_salaries_benefits', 'cy_professional_fundraising', 'cy_total_fundraising',
      'cy_other_expenses', 'cy_total_expenses', 'cy_revenue_less_expenses'
    ],
    'revenue_py': [
      'return_id', 'py_contributions_grants', 'py_program_service_revenue',
      'py_investment_income', 'py_other_revenue', 'py_total_revenue'
    ],
    'expenses_py': [
      'return_id', 'py_grants_paid', 'py_benefits_paid_to_members',
      'py_salaries_benefits', 'py_professional_fundraising', 'py_other_expenses',
      'py_total_expenses', 'py_revenue_less_expenses'
    ],
    'governance': [
      'return_id', 'voting_members_governing_body', 'voting_members_independent',
      'governing_body_voting_members', 'independent_voting_members', 'total_employees',
      'employee_count', 'total_volunteers', 'has_family_business_relationship',
      'has_delegation_mgmt_duties', 'changed_org_documents', 'changed_articles_bylaws',
      'has_material_diversion', 'has_members_stockholders', 'has_election_board_members',
      'decisions_subject_to_approval', 'has_minutes_governing_body',
      'has_minutes_committees', 'officer_mailing_address', 'has_local_chapters',
      'form_990_provided_to_governing_body', 'has_conflict_of_interest_policy',
      'has_whistleblower_policy', 'has_document_retention_policy',
      'has_compensation_process_ceo', 'has_compensation_process_other',
      'has_investment_joint_venture', 'has_audit_committee',
      'annual_disclosure_covered_persons', 'has_procedures_corrective_action',
      'has_regular_monitoring_enforcement', 'has_written_procedures_monitor'
    ],
    'contributions': [
      'return_id', 'total_contributions', 'federated_campaigns', 'membership_dues',
      'fundraising', 'government_grants', 'all_other_contributions',
      'noncash_contributions', 'contributions_gifts_grants'
    ],
    'program_services': [
      'return_id', 'total_program_service_revenue', 'program_service_revenue',
      'total_program_service_expenses', 'program_service_expenses',
      'total_other_program_revenue', 'total_other_program_expense',
      'total_other_program_grant', 'program_service_accomplishment'
    ],
    'investment_income': [
      'return_id', 'investment_income', 'total_investment_income',
      'net_investment_income', 'total_net_investment_income', 'investment_expense',
      'investment_income_election', 'investment_income_excise_tax',
      'investment_income_cy_pct', 'investment_income_py_pct'
    ],
    'expense_details': [
      'return_id', 'grants_paid', 'grants_allocations', 'grant_amount',
      'benefits_paid_to_members', 'salaries_compensation_benefits',
      'employee_benefit_program', 'fees_to_contractors', 'occupancy_rent_utilities',
      'printing_publications_postage', 'other_expenses_total', 'management_general',
      'program_services'
    ],
    'fundraising': [
      'return_id', 'fundraising_gross_income', 'fundraising_direct_expenses',
      'gaming_gross_income', 'special_events_net_income', 'special_events_direct_expenses',
      'has_professional_fundraising', 'has_fundraising_activities', 'has_gaming_activities'
    ],
    'inventory_sales': [
      'return_id', 'gross_sales_inventory', 'cost_of_goods_sold', 'gross_profit_inventory'
    ],
    'asset_sales': [
      'return_id', 'sale_of_assets_gross', 'cost_basis_expense_sale',
      'gain_loss_sale_of_assets', 'total_gain_loss', 'total_net_gain_loss',
      'net_gains_tax', 'net_lt_capital_gain_loss', 'capital_gain_net_income'
    ],
    'assets': [
      'return_id', 'land_building_equipment_cost', 'land_building_equipment_depreciation',
      'total_book_value_land_buildings', 'total_book_value_other_assets',
      'investment_cost_basis', 'cost_basis', 'total_cost_basis', 'depreciation',
      'book_value', 'other_cost_basis'
    ],
    'public_support': [
      'return_id', 'total_support', 'public_support_total_170', 'public_support_total_509',
      'public_support_cy_170_pct', 'public_support_py_170_pct', 'public_support_cy_509_pct',
      'public_support_py_509_pct', 'substantial_contributors_total',
      'gross_receipts_related_activities', 'current_tax_year_amount',
      'tax_year_minus_1_amount', 'tax_year_minus_2_amount', 'tax_year_minus_3_amount',
      'tax_year_minus_4_amount', 'first_5_years_170', 'thirty_three_pct_support_cy_170',
      'thirty_three_pct_support_cy_509'
    ],
    'ubi': [
      'return_id', 'total_gross_ubi', 'net_unrelated_business_income',
      'unrelated_business_revenue', 'unrelated_business_taxable_income', 'had_ubi',
      'ubi_over_limit', 'ubi_gross', 'ubi_expenses', 'ubi_net', 'ubi_before_nol',
      'partnership_s_corp_income'
    ],
    'income_totals': [
      'return_id', 'total_rent_income', 'total_rent_deductions',
      'total_debt_financed_income', 'total_allocable_deductions',
      'total_dividends_received_deduction', 'total_controlled_org_income',
      'total_controlled_org_deduction', 'total_deduction_set_asides',
      'total_advertising_income', 'total_advertising_cost',
      'total_excess_readership_costs', 'total_unrelated_business_comp'
    ],
    'schedule_a': [
      'return_id', 'sequence_num', 'sequence_total', 'activity_code',
      'business_code', 'business_description'
    ],
    'compliance_indicators': [
      'return_id', 'schedule_b_required', 'schedule_b_not_required',
      'schedule_j_required', 'schedule_o_required', 'has_political_campaign_activity',
      'has_lobbying_activities', 'subject_to_proxy_tax', 'has_donor_advised_fund',
      'has_donor_advised_funds', 'has_conservation_easements', 'has_art_collections',
      'has_credit_counseling', 'has_donor_restricted_endowments',
      'report_land_building_equipment', 'report_investments_other_securities',
      'report_program_related_investments', 'report_other_assets',
      'report_other_liabilities', 'include_fin48_footnote', 'has_independent_audit',
      'has_consolidated_audit', 'has_accountant_review', 'financial_statements_audited',
      'federal_grant_audit_required', 'separate_basis_financial_stmt',
      'consolidated_basis_financial_stmt', 'is_school_operating',
      'more_than_5000k_to_org', 'more_than_5000k_to_individuals', 'operates_hospital',
      'grants_to_organizations', 'grants_to_individuals', 'has_tax_exempt_bonds',
      'engaged_excess_benefit_trans', 'py_excess_benefit_trans', 'has_loan_outstanding',
      'grant_to_related_person', 'business_relationship_org_member',
      'business_relationship_family_member', 'business_relationship_35_ctrl_entity',
      'has_deductible_noncash_contributions', 'has_deductible_art_contributions',
      'terminated_operations', 'partial_liquidation', 'is_disregarded_entity',
      'is_related_entity', 'related_org_controlled_entity',
      'transfer_exempt_non_charitable', 'activities_conducted_partnership',
      'irp_document_count', 'irp_document_w2g_count', 'backup_withholding_compliance',
      'employment_tax_returns_filed', 'prohibited_tax_shelter_trans',
      'taxable_party_notification', 'has_nondeductible_contributions',
      'has_indoor_tanning_services', 'tanning_services_provided',
      'subject_to_tax_remuneration', 'subject_to_excess_tax_net_investment',
      'available_upon_request', 'no_listed_persons_compensated', 'described_in_501c3',
      'has_significant_new_program', 'has_significant_change'
    ],
    'schedule_o': [
      'return_id', 'info_schedule_o_part_i', 'info_schedule_o_part_ii',
      'info_schedule_o_part_iii', 'info_schedule_o_part_v', 'info_schedule_o_part_vi',
      'info_schedule_o_part_vii', 'info_schedule_o_part_ix', 'info_schedule_o_part_xi',
      'form_line_reference', 'explanation'
    ],
    'officers_directors': [
      'return_id', 'person_name', 'title', 'avg_hours_per_week',
      'avg_hours_per_week_related_org', 'avg_hours_devoted_to_position',
      'is_trustee_director', 'is_officer', 'reportable_comp_from_org',
      'reportable_comp_from_related_org', 'other_compensation',
      'total_reportable_comp_from_org', 'total_reportable_comp_related_org',
      'total_other_compensation', 'individuals_over_100k_count', 'former_officers_listed',
      'total_comp_over_150k', 'compensation_from_other_sources', 'contractors_over_100k_count'
    ],
    'compensation_details': [
      'return_id', 'base_compensation_filing_org', 'bonus_filing_org',
      'bonus_related_orgs', 'other_compensation_filing_org',
      'other_compensation_related_orgs', 'deferred_compensation_filing_org',
      'deferred_compensation_related_orgs', 'nontaxable_benefits_filing_org',
      'nontaxable_benefits_related_orgs', 'total_compensation_filing_org',
      'total_compensation_related_orgs', 'compensation_based_on_related_orgs',
      'compensation', 'comp_report_prior_990_filing_org',
      'comp_report_prior_990_related_orgs', 'comp_based_on_revenue_filing_org',
      'comp_based_net_earnings_filing_org', 'comp_based_net_earnings_related_orgs',
      'comp_based_on_revenue_related_orgs', 'has_severance_payment',
      'has_supplemental_nonqual_retirement', 'has_equity_based_compensation',
      'used_compensation_survey', 'has_board_committee_approval',
      'highest_paid_employee_comp', 'highest_paid_contractor_comp',
      'part_vi_highest_paid_employee', 'part_vi_highest_paid_contractor'
    ],
    'special_events': [
      'return_id', 'event_1_name', 'event_1_gross_receipts',
      'event_1_charitable_contributions', 'event_1_gross_revenue',
      'event_1_noncash_prizes', 'event_1_food_beverage', 'event_1_entertainment',
      'event_1_other_direct_expenses', 'events_gross_receipts_total',
      'events_charitable_contributions_total', 'events_gross_revenue_total',
      'events_noncash_prizes_total', 'events_food_beverage_total',
      'events_entertainment_total', 'events_other_direct_expenses_total',
      'events_direct_expense_summary', 'events_net_income_summary'
    ],
    'private_foundation': [
      'return_id', 'minimum_investment_return', 'distributable_as_adjusted',
      'undistributed_income_cy', 'undistributed_income_py',
      'treated_as_distribution_from_corpus', 'cash_deemed_charitable',
      'net_value_noncharitable_assets', 'fmv_other_noncharitable_assets',
      'total_fmv_unused_assets', 'adjusted_total_fmv_unused_assets',
      'avg_monthly_cash_balances', 'avg_monthly_fmv_securities',
      'contributions_paid_disbursements_charitable', 'contributions_paid_revenue_expenses',
      'total_operating_expenses_disbursements_charitable',
      'total_operating_expenses_net_investment', 'total_operating_expenses_revenue_expenses',
      'total_expenses_disbursements_charitable', 'total_expenses_net_investment',
      'total_expenses_revenue_expenses', 'total_revenue_expenses',
      'expenses_and_contributions'
    ],
    'pf_tax_calculations': [
      'return_id', 'gain_less_included', 'gain_plus_dividends', 'smaller_gain',
      'smaller_of_calc', 'smaller_taxable_income_or_allowed',
      'smaller_taxable_income_or_net', 'smaller_times_percent',
      'smaller_taxable_income_or_other_allowed', 'smaller_taxable_or_allowed_less_smaller',
      'taxable_income_less_gain', 'net_income_minus_smaller', 'net_smaller',
      'net_times_percent', 'tax_plus_time_percent', 'taxable_income_less_gain_plus_diff',
      'diff_of_smaller', 'diff_of_smaller_plus_smaller_of_calc'
    ],
    'pf_compliance': [
      'return_id', 'has_jeopardy_investments', 'uncorrected_py_jeopardy_investments',
      'has_business_holdings', 'has_noncharitable_purpose', 'has_uncorrected_prior_acts',
      'acts_fail_to_qualify_exceptions', 'has_new_substantial_contributors',
      'owns_controlled_entity', 'is_controlled_organization',
      'has_transaction_with_controlled_entity', 'direct_controlling_na'
    ],
    'disqualified_person_transactions': [
      'return_id', 'sale_exchange_disqualified_person', 'borrow_lend_disqualified_person',
      'furnish_goods_disqualified_person', 'pay_comp_disqualified_person',
      'transfer_assets_disqualified_person', 'pay_premiums_personal_benefit_contract',
      'payment_to_government_official'
    ],
    'related_org_transactions': [
      'return_id', 'has_loans_or_guarantees', 'loans_guarantees_to_other_org',
      'loans_guarantees_from_other_org', 'made_loans_to_from_officers',
      'dividends_related_organization', 'receipt_interest_annuities_rents_royalties',
      'sharing_of_facilities', 'sharing_facilities', 'paid_employees_sharing',
      'has_reimbursement_arrangements', 'reimbursement_paid_by_other_org',
      'reimbursement_paid_to_other_org', 'performance_of_services',
      'perform_services_by_other_org', 'perform_services_for_other_org',
      'rental_of_facilities_other_assets', 'rental_facilities_to_other_org',
      'rental_facilities_from_other_org', 'has_asset_exchange',
      'asset_sale_to_other_org', 'asset_purchase_from_other_org',
      'sales_exchanges_of_assets', 'gift_grant_capital_to_other_org',
      'gift_grant_capital_from_other_org', 'transfer_to_other_org',
      'transfer_from_other_org', 'relationships_noncharitable_eo',
      'transfer_cash_to_noncharitable_eo', 'transfer_other_asset_noncharitable_eo',
      'purchase_assets_noncharitable_eo'
    ],
    'political_activities': [
      'return_id', 'influenced_election', 'influenced_legislation',
      'has_legislative_political_activity', 'direct_indirect_political_expenditure'
    ],
    'school_compliance': [
      'return_id', 'has_nondiscriminatory_policy', 'policy_in_brochures',
      'policy_publicized_broadcast', 'maintains_racial_composition_records',
      'maintains_scholarship_records', 'maintains_copy_solicitations',
      'maintains_copy_brochures', 'discriminate_race_admissions',
      'discriminate_race_athletics', 'discriminate_race_education',
      'discriminate_race_employment', 'discriminate_race_other',
      'discriminate_race_scholarships', 'discriminate_race_student_rights',
      'discriminate_race_facilities', 'received_government_financial_aid',
      'government_financial_aid_revoked', 'compliance_rev_proc_75_50',
      'comply_public_inspection'
    ],
    'tax_exempt_bonds': [
      'return_id', 'invest_tax_exempt_bonds', 'bond_issued_date', 'bond_issuer_ein',
      'bond_reference_code', 'issue_price', 'is_defeased', 'on_behalf_of_issuer',
      'is_pool_financing', 'refunding_tax_exempt_bonds', 'refunding_taxable_bonds',
      'refunding_escrow', 'issuance_costs_from_proceeds', 'gross_proceeds_invested',
      'gross_proceeds_invested_gic', 'has_escrow_account', 'is_variable_rate_issue',
      'hedge_identified_in_books', 'final_allocation_made',
      'adequate_books_records_maintained', 'substantial_completion_year',
      'retired_amount', 'total_proceeds', 'total_proceeds_sales_price'
    ],
    'securities_transactions': [
      'return_id', 'cusip_number', 'securities_amount', 'property_description',
      'acquired_date', 'sold_disposed_date', 'proceeds_sales_price', 'gain_loss',
      'method_of_determination', 'transaction_type', 'transactions_not_reported_1099b',
      'reduction_claimed'
    ],
    'forms_filed': [
      'return_id', 'form_990pf_filed_with_attorney_general', 'form_1120pol_filed',
      'form_1120pol_filed_alt', 'form_8038t_filed', 'form_8282_filed_count',
      'form_8282_property_disposed', 'form_8899_filed', 'form_1098c_filed',
      'form_1041_schedule_d', 'filed_schedule_a'
    ],
    'miscellaneous': [
      'return_id', 'has_quid_pro_quo_contributions', 'received_funds_personal_benefit_contract',
      'more_than_100_spent', 'at_least_5000_in_assets', 'organization_dissolved',
      'section_508e_satisfied', 'change_to_organizing_doc_not_reported',
      'activities_not_previously_reported', 'has_footnote_text', 'has_non_fixed_payments',
      'has_initial_contract_exception', 'gross_receipts_public_use', 'states_return_filed',
      'description', 'purpose', 'declaration', 'expense', 'revenue',
      'related_exempt_function_income', 'exclusion', 'contributions_reported_fundraising',
      'total_amount', 'boy_amount', 'eoy_amount', 'other_revenue_total',
      'initiation_fees_capital_contributions', 'donated_services_facilities',
      'amount', 'real_amount', 'personal_amount', 'other_amount',
      'related_organizations_amount', 'total_for_year'
    ],
    'contributors': [
      'return_id', 'contributor_number', 'contributor_name'
    ]
  }

  def map_field(self, original_key):
    return self.FIELD_MAP.get(original_key, original_key)

  def get_table_for_field(self, field_name):
    for table, fields in self.TABLE_MAP.items():
      if field_name in fields:
        return table
    return None

  def map_record(self, record):
    return {self.map_field(k): v for k, v in record.items()}

  def _insert_row(self, table, data):
    if not data:
      return None
    columns = ', '.join(data.keys())
    placeholders = ', '.join(['?' for _ in data])
    sql = f"INSERT OR IGNORE INTO {table} ({columns}) VALUES ({placeholders})"
    self.cursor.execute(sql, list(data.values()))
    return self.cursor.lastrowid

  def _update_or_insert(self, table, data, conflict_columns):
    if not data:
      return None
    columns = ', '.join(data.keys())
    placeholders = ', '.join(['?' for _ in data])
    update_clause = ', '.join([f"{k} = excluded.{k}" for k in data.keys() if k not in conflict_columns])
    conflict_cols = ', '.join(conflict_columns)
    sql = f"""
      INSERT INTO {table} ({columns}) VALUES ({placeholders})
      ON CONFLICT({conflict_cols}) DO UPDATE SET {update_clause}
    """
    self.cursor.execute(sql, list(data.values()))
    return self.cursor.lastrowid

  def _get_return_id(self, ein, tax_year):
    self.cursor.execute(
      "SELECT id FROM tax_returns WHERE ein = ? AND tax_year = ?",
      (ein, tax_year)
    )
    row = self.cursor.fetchone()
    return row['id'] if row else None

  def _ensure_lookup_values(self, mapped):
    state = mapped.get('state')
    if state:
      self.cursor.execute(
        "INSERT OR IGNORE INTO states (code, name) VALUES (?, ?)",
        (state, state)
      )

    org_type = mapped.get('org_type')
    if org_type:
      self.cursor.execute(
        "INSERT OR IGNORE INTO organization_types (code, description) VALUES (?, ?)",
        (org_type, org_type)
      )

    activity_code = mapped.get('activity_code')
    if activity_code:
      self.cursor.execute(
        "INSERT OR IGNORE INTO business_activity_codes (code, description) VALUES (?, ?)",
        (activity_code, activity_code)
      )

  def insert_record(self, record):
    mapped = self.map_record(record)

    ein = mapped.get('ein')
    tax_year = mapped.get('tax_year')

    if not ein or not tax_year:
      raise ValueError("Record must contain EIN and Tax Yr")

    self._ensure_lookup_values(mapped)

    org_data = {k: v for k, v in mapped.items() if k in self.TABLE_MAP['organizations']}
    self._update_or_insert('organizations', org_data, ['ein'])

    return_data = {k: v for k, v in mapped.items() if k in self.TABLE_MAP['tax_returns']}
    self._update_or_insert('tax_returns', return_data, ['ein', 'tax_year'])

    return_id = self._get_return_id(ein, tax_year)

    if not return_id:
      raise ValueError(f"Failed to get return_id for EIN {ein}, year {tax_year}")

    child_tables = [
      'tax_computations', 'return_questions', 'nol_carryovers', 'financials',
      'revenue_cy', 'expenses_cy', 'revenue_py', 'expenses_py', 'governance',
      'contributions', 'program_services', 'investment_income', 'expense_details',
      'fundraising', 'inventory_sales', 'asset_sales', 'assets', 'public_support',
      'ubi', 'income_totals', 'compliance_indicators', 'schedule_o',
      'compensation_details', 'special_events', 'private_foundation',
      'pf_tax_calculations', 'pf_compliance', 'disqualified_person_transactions',
      'related_org_transactions', 'political_activities', 'school_compliance',
      'tax_exempt_bonds', 'securities_transactions', 'forms_filed', 'miscellaneous'
    ]

    for table in child_tables:
      table_fields = self.TABLE_MAP.get(table, [])
      table_data = {k: v for k, v in mapped.items() if k in table_fields}
      if table_data:
        table_data['return_id'] = return_id
        self._update_or_insert(table, table_data, ['return_id'])

    schedule_a_fields = self.TABLE_MAP.get('schedule_a', [])
    schedule_a_data = {k: v for k, v in mapped.items() if k in schedule_a_fields}
    if schedule_a_data and schedule_a_data.get('sequence_num'):
      schedule_a_data['return_id'] = return_id
      self._update_or_insert('schedule_a', schedule_a_data, ['return_id', 'sequence_num'])

    self.connection.commit()
    return return_id

  def insert_records(self, records):
    return_ids = []
    for record in records:
      try:
        return_id = self.insert_record(record)
        return_ids.append(return_id)
      except Exception as e:
        print(f"Error inserting record: {e}")
        return_ids.append(None)
    return return_ids

  def close(self):
    if self.connection:
      self.connection.close()
