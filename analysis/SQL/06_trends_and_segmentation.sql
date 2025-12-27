USE cloudflow_billing;

-- Monthly trend of total revenue leakage and error volume
SELECT 
    DATE_FORMAT(leakage_date, '%Y-%m') AS month,
    COUNT(*) AS total_errors,
    SUM(leakage_amount) AS total_lost_revenue
FROM leakage_report
GROUP BY DATE_FORMAT(leakage_date, '%Y-%m')
ORDER BY month;

-- Revenue leakage contribution by failure category
SELECT 
    leakage_category,
    COUNT(*) AS error_count,
    SUM(leakage_amount) AS total_lost_revenue,
    ROUND(
        SUM(leakage_amount) * 100.0 / 
        (SELECT SUM(leakage_amount) FROM leakage_report), 
        2
    ) AS pct_of_total_leakage
FROM leakage_report
GROUP BY leakage_category
ORDER BY total_lost_revenue DESC;

-- Revenue leakage aggregated by subscription plan
WITH normalized_leakage AS (
    SELECT 
        s.sub_id,
        lr.leakage_amount
    FROM leakage_report lr
    JOIN invoices i 
        ON lr.source_type = 'Invoice'
       AND lr.source_id = i.invoice_id
    JOIN subscriptions s 
        ON i.sub_id = s.sub_id

    UNION ALL

    SELECT 
        lr.source_id AS sub_id,
        lr.leakage_amount
    FROM leakage_report lr
    WHERE lr.source_type = 'Subscription'
)
SELECT 
    p.plan_name,
    SUM(nl.leakage_amount) AS total_lost_revenue
FROM normalized_leakage nl
JOIN subscriptions s 
    ON nl.sub_id = s.sub_id
JOIN plans p 
    ON s.plan_id = p.plan_id
GROUP BY p.plan_name
ORDER BY total_lost_revenue DESC;
