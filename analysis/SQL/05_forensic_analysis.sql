-- STEP 1: Identify Zombies & Leaky Buckets 
SELECT 
    i.invoice_id,
    s.customer_id,         
    i.amount AS invoice_amount,
    COALESCE(p.amount_paid, 0) AS amount_paid,
    (i.amount - COALESCE(p.amount_paid, 0)) AS leakage_amount,
    CASE 
        WHEN p.payment_id IS NULL THEN 'Zombie Account (Unpaid)'
        WHEN p.amount_paid < i.amount THEN 'Leaky Bucket (Partial)'
        ELSE 'Normal'
    END AS leakage_type
FROM invoices i
LEFT JOIN payments p 
ON i.invoice_id = p.invoice_id
JOIN subscriptions s 
ON i.Sub_id = s.Sub_id 
WHERE 
    p.payment_id IS NULL 
    OR p.amount_paid < i.amount
ORDER BY leakage_amount DESC;


-- STEP 2: Identify Ghost Subscribers 
SELECT 
    s.Sub_id,
    s.customer_id,
    pl.plan_name,     
    pl.monthly_price AS potential_revenue_lost,
    'Ghost Subscriber (Missing Invoice)' AS leakage_type
FROM subscriptions s
JOIN plans pl ON s.Plan_id = pl.plan_id
LEFT JOIN invoices i 
    ON s.Sub_id = i.Sub_id
    AND i.invoice_date BETWEEN '2024-09-01' AND '2024-09-30'
WHERE 
    s.Start_Date <= '2024-09-30'
    AND s.End_date >= '2024-09-01'
    AND i.invoice_id IS NULL;


-- STEP 3: CREATE THE MASTER TABLE (leakage_report)
CREATE TABLE leakage_report AS
SELECT 
    i.invoice_date AS leakage_date,
    'Invoice' AS source_type,
    i.invoice_id AS source_id,
    CASE 
        WHEN p.payment_id IS NULL THEN 'Unpaid Invoice'
        WHEN p.amount_paid < i.amount THEN 'Partial Payment'
    END AS leakage_category,
    (i.amount - COALESCE(p.amount_paid, 0)) AS leakage_amount
FROM invoices i
LEFT JOIN payments p 
ON i.invoice_id = p.invoice_id
WHERE 
    p.payment_id IS NULL 
    OR p.amount_paid < i.amount
    
UNION ALL

SELECT 
    DATE('2024-09-30') AS leakage_date, 
    'Subscription' AS source_type,
    s.Sub_id AS source_id,
    'Missing Invoice' AS leakage_category,
    pl.monthly_price AS leakage_amount
FROM subscriptions s
JOIN plans pl 
ON s.Plan_id = pl.plan_id
LEFT JOIN invoices i 
    ON s.Sub_id = i.Sub_id
    AND i.invoice_date BETWEEN '2024-09-01' AND '2024-09-30'
WHERE 
    s.Start_Date <= '2024-09-30'
    AND s.End_date >= '2024-09-01'
    AND i.invoice_id IS NULL;

-- Verify the final table
SELECT * FROM leakage_report LIMIT 10;