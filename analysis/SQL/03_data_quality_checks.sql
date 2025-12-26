USE cloudflow_billing;

-- Duplicate ID Check

SELECT invoice_id, COUNT(*) 
FROM invoices 
GROUP BY invoice_id 
HAVING COUNT(*) > 1;

-- Payment before Invoice?

SELECT count(*) as Invalid_Payment_Dates 
FROM payments p 
JOIN invoices i 
ON p.invoice_id = i.invoice_id 
WHERE p.payment_date < i.invoice_date;

--  Payments with no Invoice?

SELECT count(*) as Orphan_Payments 
FROM payments p 
LEFT JOIN invoices i 
ON p.invoice_id = i.invoice_id 
WHERE i.invoice_id IS NULL;

-- Total Collected should be LESS than Total Invoiced (due to unpaid bills)

SELECT 
    SUM(amount) as total_invoiced, 
    SUM(amount_paid) as total_collected,
    (SUM(amount) - SUM(amount_paid)) as Variance_Uncollected
FROM invoices i
LEFT JOIN payments p 
ON i.invoice_id = p.invoice_id;

-- Partial Payments Presence

SELECT count(*) as Partial_Payment_Count 
FROM payments p 
JOIN invoices i 
ON p.invoice_id = i.invoice_id 
WHERE p.amount_paid < i.amount;

-- Unpaid Invoices Presence

SELECT count(*) as Unpaid_Invoice_Count 
FROM invoices i 
LEFT JOIN payments p 
ON i.invoice_id = p.invoice_id 
WHERE p.payment_id IS NULL;