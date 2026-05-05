# 🛒 IndiaCart — End to End SQL Analytics Project

## Project Overview
## Project Title: IndiaCart Sales Analysis
## Level: Beginner
## Database: SalesOrders

A beginner to advanced SQL project built on a simulated Indian e-commerce and HR dataset.This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a SaleOrders database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives
Set up a SaleOrders database: Create and populate a SaleOrders database with the provided datasets.
Data Cleaning: Identify and remove any records with missing or null values.
Exploratory Data Analysis (EDA): Perform basic exploratory data analysis to understand the dataset.
Business Analysis: Use SQL to answer specific business questions and derive insights from the sales data.

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
1. Database Setup
Database Creation: The project starts by creating a database named p1_retail_db.
Table Creation: A table named retail_sales is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.
```sql 

CREATE DATABASE p1_retail_db;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);

```
2. Data Exploration & Cle
## 🗄️ Database Schema

### customers
| Column | Type | Description |
|---|---|---|
| customer_id | INT (PK) | Unique customer ID |
| first_name | VARCHAR | First name |
| last_name | VARCHAR | Last name |
| email | VARCHAR | Email address |
| city | VARCHAR | City of residence |
| country | VARCHAR | Country |
| age | INT | Age of customer |
| signup_date | DATE | Date of registration |

### products
| Column | Type | Description |
|---|---|---|
| product_id | INT (PK) | Unique product ID |
| product_name | VARCHAR | Name of product |
| category | VARCHAR | Product category |
| price | NUMERIC | Price in INR (₹) |
| stock_quantity | INT | Available stock |
| supplier | VARCHAR | Supplier name |

### orders
| Column | Type | Description |
|---|---|---|
| order_id | INT (PK) | Unique order ID |
| customer_id | INT (FK) | References customers |
| product_id | INT (FK) | References products |
| order_date | DATE | Date of order |
| quantity | INT | Quantity ordered |
| total_amount | NUMERIC | Total price in INR (₹) |
| status | VARCHAR | Delivered / Shipped / Processing |

### employees
| Column | Type | Description |
|---|---|---|
| employee_id | INT (PK) | Unique employee ID |
| first_name | VARCHAR | First name |
| last_name | VARCHAR | Last name |
| department | VARCHAR | Department name |
| job_title | VARCHAR | Job role |
| salary | NUMERIC | Annual salary in INR (₹) |
| hire_date | DATE | Date of joining |
| manager_id | INT (FK) | References employee_id (Self JOIN) |

---

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
2. Create a new database called `indiacart`
3. Run `01_create_tables.sql` to create all tables
4. Import CSV files from the `datasets/` folder into each table
5. Run query files in order from `02` to `04`

---

## 👨‍💻 Author

**Krishna Mohan**
Built as a personal SQL learning project — covering beginner to advanced concepts
using a real world themed Indian e-commerce dataset.

📧 mohangaganam1167@gmail.com
🔗 www.linkedin.com/in/krishna-mohan-94a897218
