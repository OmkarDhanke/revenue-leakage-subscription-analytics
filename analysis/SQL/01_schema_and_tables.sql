CREATE DATABASE PRoject;
USE Project;


CREATE TABLE customers(
    customers_id INT PRIMARY KEY ,
    customers_name VARCHAR(50),
    Email VARCHAR(100),
    Region VARCHAR(50)
);

CREATE TABLE plans(
    plan_id INT PRIMARY KEY,
    plans_name VARCHAR(50),
    monthly_price DECIMAL(10,2)
);


CREATE TABLE subscriptions(
	Sub_id INT PRIMARY KEY,
    customers_id INT,
    Plan_id INT,
    Start_Date DATE,
    End_date Date ,
    Status VARCHAR(50),
    FOREIGN KEY (customers_id) REFERENCES customers(customers_id),
    FOREIGN KEY (Plan_id) REFERENCES plans(Plan_id)
);

CREATE TABLE invoices(
	invoice_id INT PRIMARY KEY,
    Sub_id INT,
    invoice_date DATE,
    due_date DATE,
    amount DECIMAL(10,2),
    FOREIGN KEY (Sub_id) REFERENCES subscriptions(Sub_id)
);

CREATE TABLE payments(
	payment_id INT PRIMARY KEY,
    invoice_id INT,
    payment_date DATE,
    amount_paid DECIMAL(10,2),
    FOREIGN KEY (invoice_id) REFERENCES invoices(invoice_id)
);

