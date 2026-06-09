INSERT OR IGNORE INTO score_model (version, description) VALUES (1, 'Initial scoring model');

INSERT OR IGNORE INTO score_factor
  (model_id, name, weight, formula_type, inputs, direction, benchmark_lo, benchmark_hi, formula_description)
  VALUES (
    (SELECT model_id FROM score_model WHERE version = 1),
    'Program Expense', 0.05, 'ratio', '["prog","total_exp"]', 'higher', 0.60, 0.85,
    'Average Program Expenses ÷ Average Total Expenses'
  );

INSERT OR IGNORE INTO score_factor
  (model_id, name, weight, formula_type, inputs, direction, benchmark_lo, benchmark_hi, formula_description)
  VALUES (
    (SELECT model_id FROM score_model WHERE version = 1),
    'Admin Expense', 0.05, 'ratio', '["admin","total_exp"]', 'lower', 0.10, 0.30,
    'Average Administrative Expenses ÷ Average Total Expenses'
  );

INSERT OR IGNORE INTO score_factor
  (model_id, name, weight, formula_type, inputs, direction, benchmark_lo, benchmark_hi, formula_description)
  VALUES (
    (SELECT model_id FROM score_model WHERE version = 1),
    'Fundraising Expense', 0.05, 'ratio', '["fund","total_exp"]', 'lower', 0.05, 0.30,
    'Average Fundraising Expenses ÷ Average Total Expenses'
  );

INSERT OR IGNORE INTO score_factor
  (model_id, name, weight, formula_type, inputs, direction, benchmark_lo, benchmark_hi, formula_description)
  VALUES (
    (SELECT model_id FROM score_model WHERE version = 1),
    'Fundraising Efficiency', 0.10, 'ratio', '["fund","contrib"]', 'lower', 0.05, 0.35,
    'Average Fundraising Expenses ÷ Average Total Contributions'
  );

INSERT OR IGNORE INTO score_factor
  (model_id, name, weight, formula_type, inputs, direction, benchmark_lo, benchmark_hi, formula_description)
  VALUES (
    (SELECT model_id FROM score_model WHERE version = 1),
    'Program Expense Growth', 0.05, 'growth', '["cy_grants","py_grants"]', 'higher', -0.20, 0.20,
    '(Yn / Y0)^(1/(n+1)) - 1'
  );

INSERT OR IGNORE INTO score_factor
  (model_id, name, weight, formula_type, inputs, direction, benchmark_lo, benchmark_hi, formula_description)
  VALUES (
    (SELECT model_id FROM score_model WHERE version = 1),
    'Assets to Liabilities Ratio', 0.15, 'ratio', '["liabilities","assets"]', 'lower', 0.10, 0.75,
    'Total Liabilities ÷ Total Assets'
  );

INSERT OR IGNORE INTO score_factor
  (model_id, name, weight, formula_type, inputs, direction, benchmark_lo, benchmark_hi, formula_description)
  VALUES (
    (SELECT model_id FROM score_model WHERE version = 1),
    'Debt to Equity Ratio', 0.10, 'ratio_positive', '["liabilities","equity"]', 'lower', 0.10, 2.00,
    'Total Liabilities ÷ Equity'
  );

INSERT OR IGNORE INTO score_factor
  (model_id, name, weight, formula_type, inputs, direction, benchmark_lo, benchmark_hi, formula_description)
  VALUES (
    (SELECT model_id FROM score_model WHERE version = 1),
    'Working Capital Ratio', 0.10, 'working_capital', '["cash","savings","accts_pay","cy_exp"]', 'higher', 0.00, 0.50,
    'Working Capital ÷ Average Total Expenses'
  );

INSERT OR IGNORE INTO score_factor
  (model_id, name, weight, formula_type, inputs, direction, benchmark_lo, benchmark_hi, formula_description)
  VALUES (
    (SELECT model_id FROM score_model WHERE version = 1),
    'Government Reliance', 0.05, 'ratio', '["gov_grants","contrib"]', 'lower', 0.00, 0.75,
    'Gov. Grants ÷ Total Contributions'
  );

INSERT OR IGNORE INTO score_factor
  (model_id, name, weight, formula_type, inputs, direction, benchmark_lo, benchmark_hi, formula_description)
  VALUES (
    (SELECT model_id FROM score_model WHERE version = 1),
    'Excess/Deficit at Year End', 0.05, 'ratio', '["cy_rev","cy_exp"]', 'higher', 0.90, 1.10,
    'Total Revenue ÷ Total Expenses'
  );

INSERT OR IGNORE INTO score_factor
  (model_id, name, weight, formula_type, inputs, direction, benchmark_lo, benchmark_hi, formula_description)
  VALUES (
    (SELECT model_id FROM score_model WHERE version = 1),
    '% Gift is of Revenue', 0.05, 'ratio', '["contrib","cy_rev"]', 'higher', 0.40, 0.95,
    'Gift or Ask Amount ÷ Total Contributions'
  );

INSERT OR IGNORE INTO score_factor
  (model_id, name, weight, formula_type, inputs, direction, benchmark_lo, benchmark_hi, formula_description)
  VALUES (
    (SELECT model_id FROM score_model WHERE version = 1),
    'Dependence on Gifts/Grants', 0.10, 'ratio', '["contrib","cy_exp"]', 'higher', 0.50, 1.20,
    'Total Contributions ÷ Total Expenses'
  );

INSERT OR IGNORE INTO score_factor
  (model_id, name, weight, formula_type, inputs, direction, benchmark_lo, benchmark_hi, formula_description)
  VALUES (
    (SELECT model_id FROM score_model WHERE version = 1),
    'Return on Investments', 0.05, 'ratio', '["invest_inc","invest_val"]', 'higher', 0.00, 0.10,
    'Investment Income ÷ Investment Made'
  );

INSERT OR IGNORE INTO score_factor
  (model_id, name, weight, formula_type, inputs, direction, benchmark_lo, benchmark_hi, formula_description)
  VALUES (
    (SELECT model_id FROM score_model WHERE version = 1),
    'Admin Cost Ratio', 0.05, 'sum_ratio', '["admin","fund","total_exp"]', 'lower', 0.10, 0.40,
    '(Total Fundraising + General and Admin Expense) ÷ Total Expenses'
  );
