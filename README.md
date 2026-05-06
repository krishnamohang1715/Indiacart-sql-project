# 🛒 IndiaCart — End to End SQL Analytics Project

## Project Overview
## Project Title: IndiaCart Sales Analysis
## Level: Beginner
## Database:
    SalesOrders

A beginner to advanced SQL project built on a simulated Indian e-commerce and HR dataset.This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a SaleOrders database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives
1. Set up a SaleOrders database : Create and populate a SaleOrders database with the provided datasets.
2. Data Cleaning : Identify and remove any records with missing or null values.
3. Exploratory Data Analysis (EDA) : Perform basic exploratory data analysis to understand the dataset.
4. Business Analysis : Use SQL to answer specific business questions and derive insights from the sales data.

---

## 📁 Project Structure

```
IndiaCart-SQL-Project/
│
├── README.md
├── findings.md
├── datasets/
│   ├── customers.csv
│   ├── products.csv
│   ├── orders.csv
│   └── employees.csv
│
├── sql/
│   ├── 01_create_tables.sql
│   ├── 02_basic_queries.sql
│   ├── 03_intermediate_queries.sql
│   └── 04_advanced_queries.sql
│
```

---
### 1. Database Setup

Database Creation: The project starts by creating a database named SaleOrders.
Table Creation: Created tables of customers, products, orders, and employees to store the sales data. The table structure includes columns for customer ID, email, product ID, stock quantity, order ID, total amount.

```sql 

CREATE DATABASE SaleOrders;

CREATE TABLE Customers (
             customer_id INT PRIMARY KEY,
			 first_name VARCHAR(20),
			 last_name VARCHAR(20),
			 email VARCHAR(30) UNIQUE,
			 city VARCHAR(15),
			 country VARCHAR(15),
			 age INT,
			 signup_date DATE
);

CREATE TABLE Products (
             product_id INT PRIMARY KEY,
			 product_name VARCHAR(20),
			 category VARCHAR(20),
			 price NUMERIC (10,0),
			 stock_quantity INT,
			 supplier VARCHAR(15)
);

CREATE TABLE Employees (
             employee_id INT PRIMARY KEY,
			 first_name VARCHAR(20),
			 last_name VARCHAR(20),
			 department VARCHAR(20),
			 job_title VARCHAR(20),
			 salary NUMERIC(10,0),
			 hire_date DATE,
			 manager_id INT
);

CREATE TABLE Orders (
          order_id INT PRIMARY KEY,
	      customer_id INT REFERENCES Customers(customer_id),
          product_id  INT REFERENCES Products(product_id),
	      order_date DATE,
	      quantity INT,
	      total_amount NUMERIC (10,0),
	      status VARCHAR(20)
);

SELECT * FROM Orders ;
SELECT * FROM Customers ;
SELECT * FROM Products ;
SELECT * FROM Employees ;

```

### 2. Data Exploration & Cleaning
- Record Count: Determine the total number of records in the dataset.
- Customer Count: Find out how many unique customers are in the dataset.
- Category Count: Identify all unique product categories in the dataset.
```
SELECT COUNT(*) FROM Orders ;
SELECT COUNT(DISTINCT customer_id) FROM Customers ;
SELECT DISTINCT category FROM Products ;
```
## 🔗 Table Relationships
```
customers ──< orders >── products

employees ──< employees (Self JOIN via manager_id)
```
- One customer can place many orders
- One product can appear in many orders
- orders is the bridge table between customers and products
- employees references itself for manager hierarchy
---
### 3. Data Analysis & Findings
The following SQL queries were developed to answer specific business questions
##### SELECT & WHERE — Filtering data

-- 1.Get all customers from Hyderabad ?
```
SELECT * FROM Customers 
WHERE city = 'Hyderabad' ;
```
-- 2.Find all products that cost more than ₹1000 ?
```
SELECT * FROM Products
WHERE price > 1000 ;
```
-- 3.Show all orders that have status 'Delivered' ?
```
SELECT * FROM Orders
WHERE status = 'Delivered' ;
```
-- 4.Find all employees in the 'Engineering' department ?
```
SELECT * FROM Employees 
WHERE department IN ('Engineering', 'HR') ;
```
##### ORDER BY & LIMIT — Sorting data
-- 5.List all products from most expensive to cheapest ?
```
SELECT product_name, price,
        CASE 
		    WHEN price > 3000 THEN 'MostExpensive'
			WHEN price >= 1000 THEN 'Expensive'
			WHEN price > 600 THEN 'Medium'
			ELSE 'cheapest'
	    END AS Price_Category
FROM Products ;
```
-- 6.Show the 5 most recently hired employees ?
```
SELECT employee_id, first_name, COALESCE(CAST(manager_id AS VARCHAR), 'No Manager')
FROM Employees ;

SELECT employee_id, first_name, hire_date
FROM Employees
ORDER BY hire_date DESC 
LIMIT 5;
```
-- Replaced NULL values with NO MANAGER 
```
SELECT employee_id, first_name, hire_date, COALESCE(CAST(manager_id AS VARCHAR), 'No Manager')
FROM Employees
ORDER BY 3 DESC 
LIMIT 5;
SELECT * FROM Employees ;
```
-- 7.Get the 3 most recent orders by order date ?
```
SELECT order_id FROM Orders 
ORDER BY order_date DESC
LIMIT 3 ;

SELECT * FROM Products 
SELECT * FROM Orders

SELECT o.order_id, o.product_id, p.product_id, p.product_name
FROM Orders o 
JOIN Products p 
ON o.product_id = p.product_id
ORDER BY o.order_date DESC
LIMIT 3 ;
```
##### GROUP BY & Aggregate functions
-- 8.How many orders did each customer place ?
```
SELECT * FROM Products 
SELECT * FROM Orders
SELECT * FROM Customers

SELECT c.customer_id, c.first_name, COUNT(o.order_id) AS Total_Orders
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name
ORDER BY total_orders DESC;
```
-- 9.What is the total revenue from all delivered orders ?
```
SELECT * FROM Orders
SELECT SUM(total_amount) AS Total_Revenue
FROM Orders
WHERE status = 'Delivered'
```
-- 10.What is the average salary per department ?
```
SELECT * FROM Employees
SELECT department, AVG(salary) AS Averege_salary
FROM Employees
GROUP BY department ;
```
-- 11.Which product category has the highest average price ?
```
SELECT * FROM Products
SELECT category, AVG(price) AS Highest_avg 
FROM Products
GROUP BY category 
ORDER BY Highest_avg DESC
LIMIT 1;
```
##### JOINs — Combining tables
-- 12.Show each order along with the customer's full name ?
```
SELECT * FROM Orders
SELECT * FROM Customers
SELECT * FROM Products


SELECT o.order_id, 
       c.first_name || ' ' || c.last_name AS customer_name,
       o.order_date,
       o.total_amount,
       o.status
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
ORDER BY o.order_id;	
```
-- 13.Show each order with both the customer name and product name ?
```
SELECT o.order_id, 
       c.first_name || ' ' || c.last_name AS customer_name,
	   p.product_name,
       o.order_date,
       o.total_amount,
       o.status
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON o.product_id = p.product_id
ORDER BY o.order_id;	
```
-- 14.List all customers and how much they have spent in total ?
```
SELECT * FROM Customers 
SELECT * FROM Orders

SELECT c.customer_id,
       c.first_name || ' ' || c.last_name AS customer_name,
       COUNT(o.order_id) AS total_orders,
       SUM(o.total_amount) AS total_spent
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC;
```
-- 15.Show each employee along with their manager's name ?
```
SELECT e.employee_id,
       e.first_name || ' ' || e.last_name AS employee_name,
       COALESCE(m.first_name || ' ' || m.last_name, 'No Manager') AS manager_name
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.employee_id
ORDER BY e.employee_id;
```
##### CASE WHEN — Conditional logic
-- 16.Label each product as 'Expensive', 'Medium', or 'Cheap' based on price ?
```
SELECT product_name, price,
        CASE 
		    WHEN price > 2000 THEN 'Expensive'
			WHEN price BETWEEN 500 AND 2000 THEN 'Medium'
			ELSE 'cheapest'
	    END AS Price_Category
FROM Products ;
```
-- 17.Label each order as 'High Value' or 'Low Value' based on total_amount above or below ₹2000 ?
```
SELECT * FROM Orders

1.    SELECT order_id, total_amount,
        CASE 
		    WHEN total_amount > 2000 THEN 'HighValue'
			ELSE 'LowValue'
	    END AS Price_Category
FROM Orders ;

2.  SELECT 
    CASE 
        WHEN total_amount > 2000 THEN 'High Value'
        ELSE 'Low Value'
    END AS order_category,
    COUNT(*) AS total_orders,
    SUM(total_amount) AS revenue
FROM orders
GROUP BY order_category
ORDER BY revenue DESC;
```
##### String Funtions
-- 18.Show all customer emails in UPPERCASE ?
```
SELECT * FROM Customers

SELECT UPPER(email) FROM Customers ;
SELECT LOWER(email) FROM Customers ;
```
-- 19.Find the length of each product name and sort by longest name first ?
```
SELECT * FROM Products

SELECT product_name, LENGTH(product_name) AS name_length
FROM Products
ORDER BY name_length DESC ;
```
-- 20.Extract only the domain from customer emails (e.g. gmail.com from abc@gmail.com)
```
SELECT * FROM Customers

1. SELECT first_name,
       email,
       SUBSTRING(email, POSITION('@' IN email) + 1) AS domain
FROM Customers;

2. SELECT first_name,
       email,
       LEFT(email, POSITION('@' IN email) - 1) AS username,
       SUBSTRING(email, POSITION('@' IN email) + 1) AS domain
FROM Customers;
```
##### Date Funtions
-- 21.Find how many days ago each order was placed from today ?
```
SELECT * FROM Orders ;
SELECT * FROM Customers ;
SELECT * FROM Employees ;

SELECT order_id, order_date, CURRENT_DATE,
       CURRENT_DATE-order_date AS Days_diff
FROM Orders 
ORDER BY Days_diff DESC;
```
-- 22.Show all orders placed in the month of January 2023 ?
```
1. SELECT order_id, order_date FROM Orders
   WHERE order_date BETWEEN '2023-01-01' AND '2023-01-31'
   ORDER BY order_date ;
 
2. SELECT order_id, order_date
   FROM Orders
      WHERE EXTRACT(MONTH FROM order_date) = 1
      AND   EXTRACT(YEAR FROM order_date) = 2023
   ORDER BY order_date;

3. SELECT order_id, order_date
   FROM Orders
   WHERE DATE_TRUNC('month', order_date) = '2023-01-01'
   ORDER BY order_date;
```
-- 23.Find how many years each employee has been working in the company ?
```
SELECT * FROM Employees
SELECT employee_id, first_name, last_name, hire_date,CURRENT_DATE,
       AGE(CURRENT_DATE, hire_date) AS Experience
FROM Employees
ORDER BY Experience DESC;
```
##### WINDOW Funtions
-- 24.Rank employees by salary within each department ?
-- Used RANK() OVER()
```
SELECT first_name, department, salary,
RANK() OVER(PARTITION BY department ORDER BY salary DESC) AS Emp_Rank
FROM Employees ;
```
-- Used DENSE_RANK
```
SELECT first_name, department, salary,
DENSE_RANK() OVER(PARTITION BY department ORDER BY salary DESC) AS Emp_Dense_Rank
FROM Employees ;
```
-- Used ROW_NUMBER
```
SELECT first_name, department, salary,
ROW_NUMBER() OVER(PARTITION BY department ORDER BY salary DESC) AS Emp_Row_num
FROM Employees ;
```
-- Used all together
```SELECT first_name, department, salary,
       ROW_NUMBER()  OVER(PARTITION BY department ORDER BY salary DESC) AS row_num,
       RANK()        OVER(PARTITION BY department ORDER BY salary DESC) AS rank_num,
       DENSE_RANK()  OVER(PARTITION BY department ORDER BY salary DESC) AS dense_num
FROM Employees
ORDER BY department, salary DESC;
```
-- 25.Show running total of revenue ordered by order date ?
-- Used SUM() OVER()
```
1. SELECT order_id, order_date, total_amount,
   SUM(total_amount) OVER(ORDER BY order_date) AS Running_total 
   FROM Orders ;
```
-- Used AVG() OVER()
``` 
2. SELECT order_id, order_date, total_amount,
   AVG(total_amount) OVER(ORDER BY order_date) AS Avg_total 
   FROM Orders ;
```
--Used Aggregate WINDOW FUNCTIONS
```
3. SELECT order_id, order_date, total_amount,
       SUM(total_amount)   OVER(ORDER BY order_date) AS running_total,
       AVG(total_amount)   OVER(ORDER BY order_date) AS running_avg,
       MAX(total_amount)   OVER(ORDER BY order_date) AS running_max,
       MIN(total_amount)   OVER(ORDER BY order_date) AS running_min,
       COUNT(order_id)     OVER(ORDER BY order_date) AS running_count
   FROM Orders
   ORDER BY order_date;
```
-- 26.Find the top spending customer in each city ?
```
1. SELECT c.customer_id, c.first_name, c.last_name, c.city,
        SUM(o.total_amount) AS Total_Spends
   FROM Customers c
   JOIN Orders o
   ON c.customer_id = o.customer_id
   GROUP BY c.customer_id, c.first_name, c.last_name, c.city
   ORDER BY Total_Spends DESC ;
```
-- Used CTE
```
2. WITH city_rankings AS (
    SELECT c.customer_id, 
           c.first_name, 
           c.last_name, 
           c.city,
           SUM(o.total_amount) AS total_spends,
           RANK() OVER(PARTITION BY c.city ORDER BY SUM(o.total_amount) DESC) AS city_rank
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name, c.city
)
SELECT customer_id, first_name, last_name, city, total_spends
FROM city_rankings
WHERE city_rank = 1
ORDER BY total_spends DESC;
```

## 🧠 SQL Concepts Covered

| Level | Concepts |
|---|---|
| Beginner | SELECT, WHERE, ORDER BY, LIMIT, DISTINCT |
| Beginner | GROUP BY, COUNT, SUM, AVG, MAX, MIN |
| Intermediate | INNER JOIN, LEFT JOIN, Self JOIN |
| Intermediate | CASE WHEN, COALESCE, Subqueries |
| Intermediate | String Functions — UPPER, LOWER, LENGTH, SUBSTRING, POSITION |
| Intermediate | Date Functions — CURRENT_DATE, EXTRACT, AGE, DATE_TRUNC |
| Advanced | Window Functions — RANK, DENSE_RANK, ROW_NUMBER |
| Advanced | Running totals and averages with OVER() |
| Advanced | CTE (Common Table Expressions) |

## 📊 Key Business Insights

- 🏆 Appliances is the highest average price category at ₹4,649
- 👑 Aarav Sharma is the top spender overall with ₹5,998
- 📦 15 out of 20 orders are Delivered, 3 are Shipped, 2 are Processing
- 💰 Total revenue from delivered orders is ₹42,772
- 👔 Engineering department has the highest average salary
- 🏙️ Hyderabad has the most customers in the dataset

---

## 🛠️ Tools Used

- **Database** — PostgreSQL
- **GUI Tool** — pgAdmin 4
- **Data Format** — CSV files

---

## 🚀 How to Run

1. Install PostgreSQL and pgAdmin
2. Create a new database called `SaleOrders`
3. Run `01_create_tables.sql` to create all tables
4. Import CSV files 
5. Run query files in order from `02` to `04` to see the outputs

---

## 👨‍💻 Author

##### Krishna Mohan
Built as a personal SQL learning project — covering beginner to advanced concepts using a real world themed Indian e-commerce dataset. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

📧 mohangaganam1167@gmail.com
🔗 www.linkedin.com/in/krishna-mohan-94a897218
