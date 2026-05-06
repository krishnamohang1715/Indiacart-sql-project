-- ============================================
-- IndiaCart SQL Project
-- File: 03_intermediate_queries.sql
-- Description: JOINs, CASE WHEN, Subqueries,
--              String Functions, Date Functions
-- ============================================


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
