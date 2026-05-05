# 📊 IndiaCart — Business Insights & Findings

All insights derived from SQL queries on the IndiaCart database.

---

## 🛍️ Sales & Revenue Insights

### Total Revenue from Delivered Orders
```sql
SELECT SUM(total_amount) AS total_revenue
FROM orders
WHERE status = 'Delivered';
```
**Result:** ₹42,772 total revenue from delivered orders

---

### Revenue Breakdown by Order Status
```sql
SELECT status,
       COUNT(order_id) AS num_orders,
       SUM(total_amount) AS revenue
FROM orders
GROUP BY status
ORDER BY revenue DESC;
```
| Status | Orders | Revenue |
|---|---|---|
| Delivered | 15 | ₹42,772 |
| Shipped | 3 | ₹8,693 |
| Processing | 2 | ₹9,298 |

**Finding:** 75% of orders are delivered. 2 orders worth ₹9,298 are still processing.

---

### Top 3 Highest Value Orders
```sql
SELECT o.order_id,
       c.first_name || ' ' || c.last_name AS customer_name,
       p.product_name,
       o.total_amount
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON o.product_id = p.product_id
ORDER BY o.total_amount DESC
LIMIT 3;
```
| Order | Customer | Product | Amount |
|---|---|---|---|
| 1007 | Sneha Patel | Air Fryer | ₹5,999 |
| 1011 | Aarav Sharma | Running Shoes | ₹3,499 |
| 1004 | Vikram Nair | Running Shoes | ₹3,499 |

**Finding:** Air Fryer is the single highest value order in the dataset.

---

## 👥 Customer Insights

### Top 5 Customers by Total Spending
```sql
SELECT c.first_name || ' ' || c.last_name AS customer_name,
       c.city,
       COUNT(o.order_id) AS total_orders,
       SUM(o.total_amount) AS total_spent
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.city
ORDER BY total_spent DESC
LIMIT 5;
```
| Customer | City | Orders | Total Spent |
|---|---|---|---|
| Aarav Sharma | Hyderabad | 2 | ₹5,998 |
| Sneha Patel | Bangalore | 2 | ₹7,198 |
| Vikram Nair | Chennai | 1 | ₹3,499 |
| Priya Reddy | Mumbai | 2 | ₹3,196 |
| Kiran Mehta | Kolkata | 2 | ₹4,797 |

**Finding:** Sneha Patel is the highest spender with ₹7,198 across 2 orders.

---

### Top Spending Customer in Each City
```sql
WITH city_rankings AS (
    SELECT c.customer_id,
           c.first_name || ' ' || c.last_name AS customer_name,
           c.city,
           SUM(o.total_amount) AS total_spends,
           RANK() OVER(PARTITION BY c.city ORDER BY SUM(o.total_amount) DESC) AS city_rank
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name, c.city
)
SELECT customer_name, city, total_spends
FROM city_rankings
WHERE city_rank = 1
ORDER BY total_spends DESC;
```
| Customer | City | Total Spent |
|---|---|---|
| Sneha Patel | Bangalore | ₹7,198 |
| Aarav Sharma | Hyderabad | ₹5,998 |
| Kiran Mehta | Kolkata | ₹4,797 |
| Vikram Nair | Chennai | ₹3,499 |
| Priya Reddy | Mumbai | ₹3,196 |
| Rahul Gupta | Delhi | ₹2,498 |

---

## 🛒 Product Insights

### Average Price by Category
```sql
SELECT category,
       COUNT(*) AS total_products,
       AVG(price) AS avg_price
FROM products
GROUP BY category
ORDER BY avg_price DESC;
```
| Category | Products | Avg Price |
|---|---|---|
| Appliances | 2 | ₹4,649 |
| Electronics | 2 | ₹2,249 |
| Accessories | 2 | ₹1,399 |
| Sports | 4 | ₹1,361 |
| Clothing | 2 | ₹899 |
| Education | 2 | ₹624 |
| Stationery | 1 | ₹199 |

**Finding:** Appliances is the most expensive category on average at ₹4,649.

---

### Product Price Labels
```sql
SELECT product_name, price,
       CASE
           WHEN price > 2000 THEN 'Expensive'
           WHEN price BETWEEN 500 AND 2000 THEN 'Medium'
           ELSE 'Cheap'
       END AS price_category
FROM products
ORDER BY price DESC;
```
**Finding:** 4 products are Expensive, 8 are Medium, 3 are Cheap.

---

## 👔 Employee Insights

### Average Salary by Department
```sql
SELECT department,
       COUNT(*) AS total_employees,
       AVG(salary) AS avg_salary,
       MAX(salary) AS highest_salary,
       MIN(salary) AS lowest_salary
FROM employees
GROUP BY department
ORDER BY avg_salary DESC;
```
| Department | Employees | Avg Salary | Highest | Lowest |
|---|---|---|---|---|
| Engineering | 5 | ₹1,09,400 | ₹1,80,000 | ₹70,000 |
| Finance | 3 | ₹85,667 | ₹1,05,000 | ₹72,000 |
| Sales | 3 | ₹80,667 | ₹1,10,000 | ₹65,000 |
| HR | 2 | ₹77,500 | ₹95,000 | ₹60,000 |
| Marketing | 2 | ₹78,000 | ₹98,000 | ₹58,000 |

**Finding:** Engineering has the highest average salary at ₹1,09,400.

---

### Employee Rankings by Salary Within Department
```sql
SELECT first_name, department, salary,
       DENSE_RANK() OVER(PARTITION BY department ORDER BY salary DESC) AS salary_rank
FROM employees
ORDER BY department, salary_rank;
```
**Finding:** Ravi Shankar (VP Engineering) is the highest paid employee at ₹1,80,000.

---

### Manager Hierarchy
```sql
SELECT e.first_name || ' ' || e.last_name AS employee_name,
       e.job_title,
       COALESCE(m.first_name || ' ' || m.last_name, 'No Manager') AS manager_name
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.employee_id
ORDER BY e.employee_id;
```
**Finding:** 4 employees have no manager — they are the department heads.

---

### Most Experienced Employees
```sql
SELECT first_name, last_name, hire_date,
       AGE(CURRENT_DATE, hire_date) AS experience
FROM employees
ORDER BY hire_date ASC
LIMIT 3;
```
**Finding:** Ravi Shankar is the most experienced employee, having joined in March 2015.

---

## 📅 Order Trends

### Orders by Month
```sql
SELECT EXTRACT(MONTH FROM order_date) AS month,
       EXTRACT(YEAR FROM order_date) AS year,
       COUNT(*) AS total_orders,
       SUM(total_amount) AS monthly_revenue
FROM orders
GROUP BY year, month
ORDER BY year, month;
```
**Finding:** Orders are spread across January to July 2023 with consistent monthly activity.

---

### Running Total of Revenue
```sql
SELECT order_id, order_date, total_amount,
       SUM(total_amount) OVER(ORDER BY order_date) AS running_total
FROM orders
ORDER BY order_date;
```
**Finding:** Revenue crossed ₹40,000 mark by June 2023.

---

## 🔑 Summary of Key Findings

| Metric | Value |
|---|---|
| Total Customers | 15 |
| Total Products | 15 |
| Total Orders | 20 |
| Total Employees | 15 |
| Total Delivered Revenue | ₹42,772 |
| Top Customer | Sneha Patel (₹7,198) |
| Top Category by Price | Appliances (₹4,649 avg) |
| Top Department by Salary | Engineering (₹1,09,400 avg) |
| Most Experienced Employee | Ravi Shankar (since 2015) |
| City with Most Customers | Hyderabad |
