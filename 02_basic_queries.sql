-- ============================================
-- IndiaCart SQL Project
-- File: 02_basic_queries.sql
-- Description: Basic SELECT, WHERE, ORDER BY,
--              GROUP BY and Aggregate queries
-- ============================================


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
