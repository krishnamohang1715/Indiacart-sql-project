-- ============================================
-- IndiaCart SQL Project
-- File: 03_intermediate_queries.sql
-- Description: JOINs, CASE WHEN, Subqueries,
--              String Functions, Date Functions
-- ============================================


-- ----------------------------------------
-- JOINs — Combining Tables
-- ----------------------------------------

-- Q12. Show each order along with the customer full name
SELECT o.order_id,
       c.first_name || ' ' || c.last_name AS customer_name,
       o.order_date,
       o.total_amount,
       o.status
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
ORDER BY o.order_id;


-- Q13. Show each order with both customer name and product name
SELECT o.order_id,
       c.first_name || ' ' || c.last_name AS customer_name,
       p.product_name,
       o.order_date,
       o.total_amount,
       o.status
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Products p  ON o.product_id  = p.product_id
ORDER BY o.order_id;


-- Q14. List all customers and how much they have spent in total
SELECT c.customer_id,
       c.first_name || ' ' || c.last_name AS customer_name,
       COUNT(o.order_id) AS total_orders,
       COALESCE(SUM(o.total_amount), 0) AS total_spent
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC;


-- Q15. Show each employee along with their manager name (Self JOIN)
SELECT e.employee_id,
       e.first_name || ' ' || e.last_name AS employee_name,
       e.job_title,
       COALESCE(m.first_name || ' ' || m.last_name, 'No Manager') AS manager_name
FROM Employees e
LEFT JOIN Employees m ON e.manager_id = m.employee_id
ORDER BY e.employee_id;


-- ----------------------------------------
-- CASE WHEN — Conditional Logic
-- ----------------------------------------

-- Q16. Label each product as Expensive, Medium, or Cheap
SELECT product_name, price,
       CASE
           WHEN price > 2000 THEN 'Expensive'
           WHEN price BETWEEN 500 AND 2000 THEN 'Medium'
           ELSE 'Cheap'
       END AS price_category
FROM Products
ORDER BY price DESC;


-- Q17. Label each order as High Value or Low Value
SELECT order_id, total_amount,
       CASE
           WHEN total_amount > 2000 THEN 'High Value'
           ELSE 'Low Value'
       END AS order_category
FROM Orders;


-- Q17b. Count High Value vs Low Value orders with revenue
SELECT
    CASE
        WHEN total_amount > 2000 THEN 'High Value'
        ELSE 'Low Value'
    END AS order_category,
    COUNT(*) AS total_orders,
    SUM(total_amount) AS revenue
FROM Orders
GROUP BY order_category
ORDER BY revenue DESC;


-- ----------------------------------------
-- String Functions
-- ----------------------------------------

-- Q18. Show all customer emails in UPPERCASE
SELECT first_name, last_name,
       UPPER(email) AS email_upper
FROM Customers;


-- Q18b. Show all customer emails in LOWERCASE
SELECT first_name, last_name,
       LOWER(email) AS email_lower
FROM Customers;


-- Q19. Find the length of each product name, sort by longest first
SELECT product_name,
       LENGTH(product_name) AS name_length
FROM Products
ORDER BY name_length DESC;


-- Q20. Extract only the domain from customer emails
SELECT first_name,
       email,
       SUBSTRING(email, POSITION('@' IN email) + 1) AS domain
FROM Customers;


-- Q20b. Extract both username and domain from emails
SELECT first_name,
       email,
       LEFT(email, POSITION('@' IN email) - 1) AS username,
       SUBSTRING(email, POSITION('@' IN email) + 1) AS domain
FROM Customers;


-- ----------------------------------------
-- Date Functions
-- ----------------------------------------

-- Q21. Find how many days ago each order was placed from today
SELECT order_id,
       order_date,
       CURRENT_DATE,
       CURRENT_DATE - order_date AS days_ago
FROM Orders
ORDER BY days_ago ASC;


-- Q22. Show all orders placed in the month of January 2023
-- Option 1: Using BETWEEN
SELECT order_id, order_date
FROM Orders
WHERE order_date BETWEEN '2023-01-01' AND '2023-01-31'
ORDER BY order_date;

-- Option 2: Using EXTRACT
SELECT order_id, order_date
FROM Orders
WHERE EXTRACT(MONTH FROM order_date) = 1
AND   EXTRACT(YEAR  FROM order_date) = 2023
ORDER BY order_date;

-- Option 3: Using DATE_TRUNC
SELECT order_id, order_date
FROM Orders
WHERE DATE_TRUNC('month', order_date) = '2023-01-01'
ORDER BY order_date;


-- Q23. Find how many years each employee has been working
SELECT employee_id,
       first_name,
       last_name,
       hire_date,
       AGE(CURRENT_DATE, hire_date) AS experience
FROM Employees
ORDER BY hire_date ASC;
