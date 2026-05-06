-- ============================================
-- IndiaCart SQL Project
-- File: 04_advanced_queries.sql
-- Description: Window Functions, CTEs,
--              Subqueries, Running Totals
-- ============================================


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
