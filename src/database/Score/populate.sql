INSERT OR IGNORE INTO score_model (version) VALUES (1);

INSERT OR IGNORE INTO score_factor (model_id, name, weight, formula_description) VALUES
  ((SELECT model_id FROM score_model WHERE version = 1), 'Program Expense',            0.05, 'Average Program Expenses ÷ Average Total Expenses'),
  ((SELECT model_id FROM score_model WHERE version = 1), 'Admin Expense',              0.05, 'Average Administrative Expenses ÷ Average Total Expenses'),
  ((SELECT model_id FROM score_model WHERE version = 1), 'Fundraising Expense',        0.05, 'Average Fundraising Expenses ÷ Average Total Expenses'),
  ((SELECT model_id FROM score_model WHERE version = 1), 'Fundraising Efficiency',     0.10, 'Average Fundraising Expenses ÷ Average Total Contributions'),
  ((SELECT model_id FROM score_model WHERE version = 1), 'Program Expense Growth',     0.05, '(Yn / Y0)^(1/(n+1)) - 1'),
  ((SELECT model_id FROM score_model WHERE version = 1), 'Assets to Liabilities Ratio',0.15, 'Total Liabilities ÷ Total Assets'),
  ((SELECT model_id FROM score_model WHERE version = 1), 'Debt to Equity Ratio',       0.10, 'Total Liabilities ÷ Equity'),
  ((SELECT model_id FROM score_model WHERE version = 1), 'Working Capital Ratio',      0.10, 'Working Capital ÷ Average Total Expenses'),
  ((SELECT model_id FROM score_model WHERE version = 1), 'Government Reliance',        0.05, 'Gov. Grants ÷ Total Contributions'),
  ((SELECT model_id FROM score_model WHERE version = 1), 'Excess/Deficit at Year End', 0.05, 'Total Revenue ÷ Total Expenses'),
  ((SELECT model_id FROM score_model WHERE version = 1), '% Gift is of Revenue',       0.05, 'Gift or Ask Amount ÷ Total Contributions'),
  ((SELECT model_id FROM score_model WHERE version = 1), 'Dependence on Gifts/Grants', 0.10, 'Total Contributions ÷ Total Expenses'),
  ((SELECT model_id FROM score_model WHERE version = 1), 'Return on Investments',      0.05, 'Investment Income ÷ Investment Made'),
  ((SELECT model_id FROM score_model WHERE version = 1), 'Admin Cost Ratio',           0.05, '(Total Fundraising + General and Admin Expense) ÷ Total Expenses');
