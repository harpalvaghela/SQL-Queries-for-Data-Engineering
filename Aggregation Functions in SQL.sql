--Aggregation functions in SQL Server are used to perform calculations on multiple rows and return a single summarized value. 
--Common functions include SUM() (total), COUNT() (row count), AVG() (average), MAX() (highest value), and MIN() (lowest value), typically used with GROUP BY for data analysis.

--drop table sales
CREATE TABLE sales (
    id int identity (1,1) PRIMARY KEY,
    product_name VARCHAR(50),
    sales_date DATE,
    sales_amount NUMERIC(10,2)
);

INSERT INTO sales (product_name, sales_date, sales_amount)
VALUES
    ('Product A', '2022-01-01', 100.50),
    ('Product B', '2022-01-01', 150.25),
    ('Product C', '2022-01-02', 75.00),
    ('Product A', '2022-01-02', 50.75),
    ('Product B', '2022-01-03', 200.00),
    ('Product C', '2022-01-03', 125.50);


-- SUM() – Total Sales Amount
SELECT SUM(sales_amount) AS total_sales
FROM sales;

-- COUNT() – Number of Sales Transactions
SELECT COUNT(*) AS total_transactions
FROM sales;

-- AVG() – Average Sales Amount
SELECT AVG(sales_amount) AS avg_sales
FROM sales;

-- MAX() – Highest Sales Amount
SELECT MAX(sales_amount) AS highest_sale
FROM sales;

--MIN() – Lowest Sales Amount
SELECT MIN(sales_amount) AS lowest_sale
FROM sales;

--COUNT(DISTINCT) – Unique Product Count
SELECT COUNT(DISTINCT product_name) AS unique_products
FROM sales;

--GROUP BY with Aggregation Functions (Sales by Product)
SELECT product_name, 
       SUM(sales_amount) AS total_sales, 
       COUNT(*) AS sales_count, 
       AVG(sales_amount) AS avg_sales
FROM sales
GROUP BY product_name;


--HAVING with Aggregation – Show Products with Sales > $200
SELECT product_name, SUM(sales_amount) AS total_sales
FROM sales
GROUP BY product_name
HAVING SUM(sales_amount) > 200;

-- Sales Per Day (Using GROUP BY on sales_date)
SELECT sales_date, SUM(sales_amount) AS daily_sales
FROM sales
GROUP BY sales_date
ORDER BY sales_date;


--STDEV() – Standard Deviation of Sales Amounts
SELECT STDEV(sales_amount) AS sales_std_dev
FROM sales;

--VAR() – Variance of Sales Amounts
SELECT VAR(sales_amount) AS sales_variance
FROM sales;

--STRING_AGG() – List Products Sold
SELECT STRING_AGG(product_name, ', ') AS products_sold
FROM sales;


----------------------------------------------------------------
-- Things to remember in aggregation functions
----------------------------------------------------------------

--1. Use GROUP BY When Selecting Non-Aggregated Columns

--2. HAVING Filters Aggregated Results, WHERE Filters Rows Before Aggregation

--3. COUNT(*) vs. COUNT(column_name)

-- COUNT(*) → Counts all rows, including NULL values.
-- COUNT(column_name) → Counts only non-NULL values in the specified column.

--4. Aggregation Functions Ignore NULL Values (Except COUNT(*))

--5. DISTINCT Can Be Used Inside Aggregation Functions

-- Example: SELECT COUNT(DISTINCT customer_id) AS unique_customers FROM sales;
