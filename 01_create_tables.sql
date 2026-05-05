-- ============================================
-- IndiaCart SQL Project
-- File: 01_create_tables.sql
-- Description: Create all tables for the project
-- ============================================


-- Step 1: Create Customers Table

CREATE TABLE Customers (
    customer_id  INT PRIMARY KEY,
    first_name   VARCHAR(20),
    last_name    VARCHAR(20),
    email        VARCHAR(50),
    city         VARCHAR(20),
    country      VARCHAR(20),
    age          INT,
    signup_date  DATE
);


-- Step 2: Create Products Table

CREATE TABLE Products (
    product_id       INT PRIMARY KEY,
    product_name     VARCHAR(50),
    category         VARCHAR(20),
    price            NUMERIC(10,2),
    stock_quantity   INT,
    supplier         VARCHAR(30)
);


-- Step 3: Create Orders Table
-- (Must be created AFTER Customers and Products)

CREATE TABLE Orders (
    order_id      INT PRIMARY KEY,
    customer_id   INT REFERENCES Customers(customer_id),
    product_id    INT REFERENCES Products(product_id),
    order_date    DATE,
    quantity      INT,
    total_amount  NUMERIC(10,2),
    status        VARCHAR(20)
);


-- Step 4: Create Employees Table
-- (manager_id is a Self JOIN — references employee_id in same table)

CREATE TABLE Employees (
    employee_id   INT PRIMARY KEY,
    first_name    VARCHAR(20),
    last_name     VARCHAR(20),
    department    VARCHAR(20),
    job_title     VARCHAR(30),
    salary        NUMERIC(10,2),
    hire_date     DATE,
    manager_id    INT REFERENCES Employees(employee_id)
);


-- Verify all tables created successfully
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public';
