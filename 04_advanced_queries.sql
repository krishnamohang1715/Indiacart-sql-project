-- ============================================
-- IndiaCart SQL Project
-- File: 04_advanced_queries.sql
-- Description: Window Functions, CTEs,
--              Subqueries, Running Totals
-- ============================================


-- ----------------------------------------
-- Window Functions — RANK, DENSE_RANK, ROW_NUMBER
-- ----------------------------------------

-- Q24. Rank employees by salary within each department
-- Using RANK()
SELECT first_name, department, salary,
       RANK() OVER(PARTITION BY department ORDER BY salary DESC) AS emp_rank
FROM Employees;


-- Using DENSE_RANK()
SELECT first_name, department, salary,
       DENSE_RANK() OVER(PARTITION BY department ORDER BY salary DESC) AS emp_dense_rank
FROM Employees;


-- Using ROW_NUMBER()
SELECT first_name, department, salary,
       ROW_NUMBER() OVER(PARTITION BY department ORDER BY salary DESC) AS emp_row_num
FROM Employees;


-- Q24b. Compare all three ranking functions side by side
SELECT first_name, department, salary,
       ROW_NUMBER()  OVER(PARTITION BY department ORDER BY salary DESC) AS row_num,
       RANK()        OVER(PARTITION BY department ORDER BY salary DESC) AS rank_num,
       DENSE_RANK()  OVER(PARTITION BY department ORDER BY salary DESC) AS dense_num
FROM Employees
ORDER BY department, salary DESC;


-- ----------------------------------------
-- Running Totals & Averages
-- ----------------------------------------

-- Q25. Show running total of revenue ordered by order date
SELECT order_id,
       order_date,
       total_amount,
       SUM(total_amount) OVER(ORDER BY order_date) AS running_total
FROM Orders
ORDER BY order_date;


-- Q25b. Show running average of revenue
SELECT order_id,
       order_date,
       total_amount,
       AVG(total_amount) OVER(ORDER BY order_date) AS running_avg
FROM Orders
ORDER BY order_date;


-- Q25c. Show all running calculations together
SELECT order_id,
       order_date,
       total_amount,
       SUM(total_amount)   OVER(ORDER BY order_date) AS running_total,
       AVG(total_amount)   OVER(ORDER BY order_date) AS running_avg,
       MAX(total_amount)   OVER(ORDER BY order_date) AS running_max,
       MIN(total_amount)   OVER(ORDER BY order_date) AS running_min,
       COUNT(order_id)     OVER(ORDER BY order_date) AS running_count
FROM Orders
ORDER BY order_date;


-- ----------------------------------------
-- CTE — Common Table Expressions
-- ----------------------------------------

-- Q26. Find the top spending customer in each city
-- Using CTE (recommended)
WITH city_rankings AS (
    SELECT c.customer_id,
           c.first_name || ' ' || c.last_name AS customer_name,
           c.city,
           SUM(o.total_amount) AS total_spends,
           RANK() OVER(PARTITION BY c.city ORDER BY SUM(o.total_amount) DESC) AS city_rank
    FROM Customers c
    JOIN Orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name, c.city
)
SELECT customer_name, city, total_spends
FROM city_rankings
WHERE city_rank = 1
ORDER BY total_spends DESC;


-- Q26b. Same query using Subquery (without CTE)
SELECT customer_name, city, total_spends
FROM (
    SELECT c.customer_id,
           c.first_name || ' ' || c.last_name AS customer_name,
           c.city,
           SUM(o.total_amount) AS total_spends,
           RANK() OVER(PARTITION BY c.city ORDER BY SUM(o.total_amount) DESC) AS city_rank
    FROM Customers c
    JOIN Orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name, c.city
) ranked
WHERE city_rank = 1
ORDER BY total_spends DESC;


-- Q26c. Using DISTINCT ON (PostgreSQL only — cleanest)
SELECT DISTINCT ON (c.city)
       c.first_name || ' ' || c.last_name AS customer_name,
       c.city,
       SUM(o.total_amount) AS total_spends
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.city
ORDER BY c.city, total_spends DESC;


-- ----------------------------------------
-- Subqueries
-- ----------------------------------------

-- Q27. Find all products priced above the average product price
SELECT product_name, price
FROM Products
WHERE price > (SELECT AVG(price) FROM Products)
ORDER BY price DESC;


-- Q28. Find customers who spent more than the average customer spending
SELECT customer_name, total_spent
FROM (
    SELECT c.first_name || ' ' || c.last_name AS customer_name,
           SUM(o.total_amount) AS total_spent
    FROM Customers c
    JOIN Orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name
) customer_totals
WHERE total_spent > (
    SELECT AVG(total_spent)
    FROM (
        SELECT SUM(total_amount) AS total_spent
        FROM Orders
        GROUP BY customer_id
    ) avg_calc
)
ORDER BY total_spent DESC;


-- Q29. Show employees who earn more than their department average
SELECT first_name, last_name, department, salary
FROM Employees e
WHERE salary > (
    SELECT AVG(salary)
    FROM Employees
    WHERE department = e.department
)
ORDER BY department, salary DESC;
