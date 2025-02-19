CREATE TABLE sales (
  date DATE,
  salesperson VARCHAR(50),
  sales_amount INT
);

INSERT INTO sales (date, salesperson, sales_amount)
VALUES
  ('2022-01-01', 'Alice', 1000),
  ('2022-01-01', 'Bob', 1500),
  ('2022-01-02', 'Alice', 2000),
  ('2022-01-02', 'Bob', 2500),
  ('2022-01-03', 'Alice', 3000),
  ('2022-01-03', 'Bob', 3500),
  ('2022-01-04', 'Alice', 4000),
  ('2022-01-04', 'Bob', 4500),
  ('2022-01-05', 'Alice', 5000),
  ('2022-01-05', 'Bob', 5500);

SELECT * from sales;

-- Window Function is a type of function that performs a calculation across a set of table rows that are somehow related to the current row.

--Example

--Suppose we want to calculate the running total of sales over time for each salesperson. We can use a window function to achieve this. 

select 
date,
salesperson,
sales_amount,
SUM(sales_amount) OVER (PARTITION BY salesperson ORDER BY date ASC) as Running_Total
from sales

-- This above query uses the SUM window function to calculate the running total of sales for each salesperson. The PARTITION BY clause divides the rows into partitions based on the salesperson column, and the ORDER BY clause orders the rows within each partition by date. The SUM function then calculates the running total for each row within each partition.

select 
date,
salesperson,
sales_amount,
AVG(sales_amount) OVER (PARTITION BY salesperson ORDER BY date ASC) as AVG_Running_Total
from sales

---Suppose we want to calculate the percentage of total sales for each salesperson and for each day. 

SELECT
  date,
  salesperson,
  sales_amount,
  100.0 * sales_amount / SUM(sales_amount) OVER (PARTITION BY salesperson, date) AS percentage_total
FROM sales;


------------------------------------------------------------------
--Things to Remember in Window Functions in SQL
------------------------------------------------------------------
--Window functions perform calculations across a set of rows related to the current row without collapsing the result into a single aggregate value. They are useful for ranking, running totals, moving averages, and partition-based calculations.

--1. Always Use OVER() for Window Functions
--Unlike aggregate functions (SUM(), AVG(), etc.), window functions require the OVER() clause to define the window of rows they operate on.
SELECT salesperson, sales_amount, SUM(sales_amount) OVER() AS total_sales
FROM sales;

-- 2. Use PARTITION BY to Calculate Values Within Groups
--PARTITION BY creates subgroups within the dataset to perform calculations within each group.

SELECT salesperson, date, sales_amount,
       SUM(sales_amount) OVER(PARTITION BY salesperson) AS total_sales_per_person
FROM sales;

--Computes total sales for each salesperson separately without affecting other salespeople.


--3. Use ORDER BY Inside OVER() for Running Totals and Rankings
--ORDER BY inside OVER() determines how window functions process rows sequentially.

SELECT salesperson, date, sales_amount,
       SUM(sales_amount) OVER(PARTITION BY salesperson ORDER BY date) AS running_total
FROM sales;

--Keeps track of cumulative sales for each salesperson over time.

--4. Use ROW_NUMBER(), RANK(), and DENSE_RANK() Carefully
--These functions assign row numbers based on sorting criteria, but behave differently when dealing with duplicate values.

SELECT salesperson, date, sales_amount,
       ROW_NUMBER() OVER(PARTITION BY date ORDER BY sales_amount DESC) AS row_num,
       RANK() OVER(PARTITION BY date ORDER BY sales_amount DESC) AS rank_num,
       DENSE_RANK() OVER(PARTITION BY date ORDER BY sales_amount DESC) AS dense_rank_num
FROM sales;

--ROW_NUMBER() → Assigns a unique number to each row (no duplicates).
--RANK() → Assigns the same rank to duplicate values but skips the next rank number.
--DENSE_RANK() → Assigns the same rank to duplicates but does not skip rank numbers.


--5. Window Functions Do Not Filter Data – Use WHERE or FILTER() Instead
--Window functions do not remove rows; they only perform calculations on them.
--If filtering is needed, use WHERE before or FILTER() inside the function.

--Top 2 Sales per Day Using FILTER()
SELECT salesperson, date, sales_amount,
       RANK() OVER(PARTITION BY date ORDER BY sales_amount DESC) AS sales_rank
FROM sales
WHERE sales_rank <= 2; -- ERROR: Cannot use alias directly in WHERE

--Fix: Use a Subquery Instead

WITH SalesRank AS (
    SELECT salesperson, date, sales_amount,
           RANK() OVER(PARTITION BY date ORDER BY sales_amount DESC) AS sales_rank
    FROM sales
)
SELECT * FROM SalesRank WHERE sales_rank <= 2;

--Ensures only the top 2 sales per day are returned.
