# Project Phase 5: Database Provisioning & Data Loading


## 1.0 Environment Setup

* **Database Name:** `cloudflow_billing`
* **Tool:** MySQL Workbench / DBeaver / Command Line
* **Goal:** Create a persistent storage layer for the 11,000+ records generated in Phase 4.


## 2.0 DDL Scripts (Create Tables)

*Note on Foreign Keys:*  
The order of creation matters. Parent tables must be created before child tables to satisfy referential integrity.

```sql
CREATE DATABASE IF NOT EXISTS cloudflow_billing;
USE cloudflow_billing;

-- 1. Customers (Parent)
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    region VARCHAR(50)
);

-- 2. Plans (Parent)
CREATE TABLE plans (
    plan_id INT PRIMARY KEY,
    plan_name VARCHAR(50),
    monthly_price DECIMAL(10, 2)
);

-- 3. Subscriptions (Child: Customers, Plans)
CREATE TABLE subscriptions (
    sub_id INT PRIMARY KEY,
    customer_id INT,
    plan_id INT,
    start_date DATE,
    end_date DATE,
    status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (plan_id) REFERENCES plans(plan_id)
);

-- 4. Invoices (Child: Subscriptions)
CREATE TABLE invoices (
    invoice_id INT PRIMARY KEY,
    sub_id INT,
    invoice_date DATE,
    due_date DATE,
    amount DECIMAL(10, 2),
    FOREIGN KEY (sub_id) REFERENCES subscriptions(sub_id)
);

-- 5. Payments (Child: Invoices)
CREATE TABLE payments (
    payment_id INT PRIMARY KEY,
    invoice_id INT,
    payment_date DATE,
    amount_paid DECIMAL(10, 2),
    FOREIGN KEY (invoice_id) REFERENCES invoices(invoice_id)
);
``` 

## 3.0 Data Loading Strategy (CSV Import)

Once all tables are created, import the CSV files generated in Phase 4.

### Required Import Order

To avoid foreign key constraint failures, import data in this exact sequence:

1. `customers.csv` → `customers`
2. `plans.csv` → `plans`
3. `subscriptions.csv` → `subscriptions`
4. `invoices.csv` → `invoices`
5. `payments.csv` → `payments`

**Tool Tip:**  
If using MySQL Workbench’s *Table Data Import Wizard*, manually verify column mappings — especially `customer_id`, `plan_id`, and `sub_id` — if auto-detection fails.


## 4.0 Verification & Integrity Check

Run the following SQL queries after data import to validate correctness.


### Query 1: Row Count Validation

**Expected Results:**
- Customers ≈ 1,000  
- Invoices ≈ 11,000+  
- Payments < Invoices (intentional revenue leakage)

``` sql 

SELECT 'Customers' AS Table_Name, COUNT(*) AS Total_Rows FROM customers
UNION ALL
SELECT 'Subscriptions', COUNT(*) FROM subscriptions
UNION ALL
SELECT 'Invoices', COUNT(*) FROM invoices
UNION ALL
SELECT 'Payments', COUNT(*) FROM payments;
``` 

### Query 2: Relationship Integrity Test

**Confirm joins work from Payments → Customers.**

```SQL
SELECT 
    c.customer_name,
    p.plan_name,
    i.amount AS invoice_amount,
    pay.amount_paid
FROM customers c
JOIN subscriptions s ON c.customer_id = s.customer_id
JOIN plans p ON s.plan_id = p.plan_id
JOIN invoices i ON s.sub_id = i.sub_id
LEFT JOIN payments pay ON i.invoice_id = pay.invoice_id
LIMIT 5;

``` 