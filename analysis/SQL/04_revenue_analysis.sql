
-- TEST 1: Monthly Revenue Waterfall
-- Addition: Added a 'Status' column to instantly flag leaking months

SELECT 
    DATE_FORMAT(i.invoice_date, '%Y-%m') AS Month,
    SUM(i.amount) AS Total_Invoiced,
    SUM(COALESCE(p.amount_paid, 0)) AS Total_Received, 
    (SUM(i.amount) - SUM(COALESCE(p.amount_paid, 0))) AS Collection_Gap,
    CASE WHEN (SUM(i.amount) - SUM(COALESCE(p.amount_paid, 0))) > 0 THEN 'Leakage Detected' ELSE '✅ Healthy' END AS Audit_Status,
    ROUND((SUM(COALESCE(p.amount_paid, 0)) / SUM(i.amount)) * 100, 2) AS Recovery_Rate
FROM invoices i
LEFT JOIN payments p 
ON i.invoice_id = p.invoice_id
GROUP BY DATE_FORMAT(i.invoice_date, '%Y-%m')
ORDER BY Month;


-- TEST 2: September 2024 Generation Gap

-- Part A: Expected (Active Users)
SELECT 
    'September 2024' AS Period,
    'Expected Revenue' AS Metric_Type,
    SUM(pl.monthly_price) AS Amount
FROM subscriptions s
JOIN plans pl 
ON s.plan_id = pl.plan_id
WHERE s.start_date <= '2024-09-01' 
  AND (s.end_date >= '2024-09-30' OR s.status = 'Active'); 

-- Part B: Actual (Invoices Created)
SELECT 
    'September 2024' AS Period,
    'Actual Invoiced' AS Metric_Type, 
    SUM(amount) AS Amount
FROM invoices
WHERE invoice_date BETWEEN '2024-09-01' AND '2024-09-30';