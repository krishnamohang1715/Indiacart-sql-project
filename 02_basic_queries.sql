-- ============================================
-- IndiaCart SQL Project
-- File: 02_basic_queries.sql
-- Description: Basic SELECT, WHERE, ORDER BY,
--              GROUP BY and Aggregate queries
-- ============================================


-- ----------------------------------------
-- SELECT & WHERE — Filtering Data
-- ----------------------------------------

-- Q1. Get all customers from Hyderabad
SELECT *
FROM Customers
WHERE city = 'Hyderabad';


-- Q2. Find all products that cost more than ₹1000
SELECT *
FROM Products
WHERE price > 1000;


-- Q3. Show all orders that have status 'Delivered'
SELECT *
FROM Orders
WHERE status = 'Delivered';


-- Q4. Find all employees in the Engineering department
SELECT *
FROM Employees
WHERE department = 'Engineering';


-- ----------------------------------------
-- ORDER BY & LIMIT — Sorting Data
-- ----------------------------------------

-- Q5. List all products from most expensive to cheapest
SELECT product_name, price
FROM Products
ORDER BY price DESC;


-- Q6. Show the 5 most recently hired employees
SELECT employee_id, first_name, last_name, hire_date,
       COALESCE(CAST(manager_id AS VARCHAR), 'No Manager') AS manager
FROM Employees
ORDER BY hire_date DESC
LIMIT 5;


-- Q7. Get the 3 most recent orders by order date
SELECT *
FROM Orders
ORDER BY order_date DESC
LIMIT 3;


-- ----------------------------------------
-- GROUP BY & Aggregate Functions
-- ----------------------------------------

-- Q8. How many orders did each customer place?
SELECT c.customer_id,
       c.first_name || ' ' || c.last_name AS customer_name,
       COUNT(o.order_id) AS total_orders
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_orders DESC;


-- Q9. What is the total revenue from all delivered orders?
SELECT SUM(total_amount) AS total_revenue
FROM Orders
WHERE status = 'Delivered';


-- Q10. What is the average salary per department?
SELECT department,
       AVG(salary) AS avg_salary
FROM Employees
GROUP BY department
ORDER BY avg_salary DESC;


-- Q11. Which product category has the highest average price?
SELECT category,
       AVG(price) AS avg_price
FROM Products
GROUP BY category
ORDER BY avg_price DESC;


-- Q11b. Show only the top category using LIMIT
SELECT category,
       AVG(price) AS avg_price
FROM Products
GROUP BY category
ORDER BY avg_price DESC
LIMIT 1;
