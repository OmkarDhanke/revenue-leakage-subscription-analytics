#  Row Count Validation

SELECT 'Customers' AS Table_Name, COUNT(*) AS Total_Rows FROM customers
UNION ALL
SELECT 'Subscriptions', COUNT(*) FROM subscriptions
UNION ALL
SELECT 'Invoices', COUNT(*) FROM invoices
UNION ALL
SELECT 'Payments', COUNT(*) FROM payments;

# Relationship Integrity Test

SELECT 
    c.customers_name,
    p.plans_name,
    i.amount AS invoice_amount,
    pay.amount_paid
FROM customers c
JOIN subscriptions s ON c.customers_id = s.customers_id
JOIN plans p ON s.plan_id = p.plan_id
JOIN invoices i ON s.sub_id = i.sub_id
LEFT JOIN payments pay ON i.invoice_id = pay.invoice_id
LIMIT 5;
