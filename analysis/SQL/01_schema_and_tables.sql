CREATE DATABASE cloudflow_billing;
USE cloudflow_billing;

-- customers
CREATE TABLE customers(
    customer_id INT PRIMARY KEY ,
    customer_name VARCHAR(50),
    Email VARCHAR(100),
    Region VARCHAR(50)
);

-- plans
CREATE TABLE plans(
    plan_id INT PRIMARY KEY,
    plan_name VARCHAR(50),
    monthly_price DECIMAL(10,2)
);

-- subscriptions
CREATE TABLE subscriptions(
	Sub_id INT PRIMARY KEY,
    customer_id INT,
    Plan_id INT,
    Start_Date DATE,
    End_date Date ,
    Status VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (Plan_id) REFERENCES plans(Plan_id)
);

-- invoices
CREATE TABLE invoices(
	invoice_id INT PRIMARY KEY,
    Sub_id INT,
    invoice_date DATE,
    due_date DATE,
    amount DECIMAL(10,2),
    FOREIGN KEY (Sub_id) REFERENCES subscriptions(Sub_id)
);

-- payments
CREATE TABLE payments(
	payment_id INT PRIMARY KEY,
    invoice_id INT,
    payment_date DATE,
    amount_paid DECIMAL(10,2),
    FOREIGN KEY (invoice_id) REFERENCES invoices(invoice_id)
);

