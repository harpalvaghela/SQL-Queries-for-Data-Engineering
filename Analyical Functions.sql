--Analytical Functions

CREATE TABLE sales_data (
    id int identity(1,1) PRIMARY KEY,
    date DATE,
    item TEXT,
    units_sold INTEGER,
    price_per_unit NUMERIC(10, 2)
);

INSERT INTO sales_data (date, item, units_sold, price_per_unit)
VALUES
    ('2021-01-01', 'apple', 10, 1.50),
    ('2021-01-02', 'banana', 20, 0.75),
    ('2021-01-03', 'orange', 15, 1.00),
    ('2021-01-04', 'apple', 12, 1.50),
    ('2021-01-05', 'banana', 18, 0.75),
    ('2021-01-06', 'orange', 20, 1.00),
    ('2021-01-07', 'apple', 8, 1.50),
    ('2021-01-08', 'banana', 22, 0.75),
    ('2021-01-09', 'orange', 10, 1.00);

Select * from sales_data;

--Analytical functions are commonly used in data analysis and reporting tasks. 

-- Ranking and sorting data based on one or more columns
-- Calculating moving averages and other rolling aggregates
-- Finding trends and patterns in data over time
-- Performing cohort analysis and other types of segmentation
-- Calculating percentiles and other statistical measures
-- Performing lead and lag analysis on time series data


-- 1) RANK()
-- The RANK() function assigns a rank to each row within a result set, with ties receiving the same rank and leaving gaps.

select item, units_sold, RANK() OVER (ORDER BY units_sold ASC) as rank from sales_data;


--The SELECT statement retrieves data from a table. Here, it's selecting the item and units_sold columns from the "sales_data" table. The RANK() function ranks each row according to the units_sold column. The OVER clause defines how to partition and order the data for the ranking. In this example, rows are ordered by the units_sold column in descending order.



-- 2) DENSE_RANK()
-- The DENSE_RANK() function is similar to the RANK() function but does not leave gaps in the ranking even if there are ties, meaning rows with the same value will have the same rank.

select item, units_sold, DENSE_RANK() OVER (ORDER by units_sold desc) as dense_rank from sales_data;

-- The SELECT statement retrieves data from a table. Here, it's used to select the item and units_sold columns from the "sales_data" table. The DENSE_RANK() function assigns a rank to each row based on the units_sold column and does not leave gaps between ranks, even with ties. The OVER clause specifies how to partition and order the data for ranking. In this example, rows are ordered by the units_sold column in descending order.

-- Checking both in same table to better understand

select 
item, 
units_sold, 
RANK() OVER (ORDER BY units_sold ASC) as rank,
DENSE_RANK() OVER (ORDER by units_sold asc) as dense_rank from sales_data;


-- 3. ROW_NUMBER()
-- The ROW_NUMBER() function assigns a unique number to each row within a result set.

select 
item, 
units_sold, 
RANK() OVER (ORDER BY units_sold ASC) as rank,
DENSE_RANK() OVER (ORDER by units_sold asc) as dense_rank,
ROW_NUMBER() OVER (ORDER by units_sold asc) as Row_Number 
from sales_data;


-- The SELECT statement retrieves data from a table. In this scenario, it is used to select the item and units_sold columns from the "sales_data" table. The ROW_NUMBER() function assigns a unique number to each row according to the units_sold column. The OVER clause determines how to partition and order the data for numbering. Here, rows are ordered by the units_sold column in descending order.


-- 4. LAG()
-- The LAG() function allows you to access a row that is a specific number of positions before the current row in a result set.

SELECT item, units_sold, LAG(units_sold) OVER (ORDER BY date) AS previous_units_sold
FROM sales_data;

--The SELECT statement retrieves data from a table. Here, it selects the item and units_sold columns from the "sales_data" table. The LAG() function accesses the units_sold value from the row immediately preceding the current row, based on the order of the date column. The OVER clause defines how to partition and order the data for this operation, with rows ordered by the date column in this example.

-- 5. LEAD()
--The LEAD() function provides access to a row at a given physical offset after the current row within a result set.

SELECT 
item, 
units_sold, 
LAG(units_sold) OVER (ORDER BY date) AS previous_units_sold,
LEAD(units_sold) OVER (ORDER BY date) AS next_units_sold
FROM sales_data;


-- The SELECT statement is used to fetch data from a table. In this instance, it's selecting the item and units_sold columns from the "sales_data" table. The LEAD() function is employed to access the units_sold value from the row immediately following the current row, determined by the order of the date column. The OVER clause specifies the partitioning and ordering of the data for this operation, organizing the rows by the date column.




--------------------------------------------------------------------------
--Things to Remember in Analytical Functions in SQL
--------------------------------------------------------------------------

--1. Always Use OVER() Clause with Analytical Functions
--Analytical functions must be used with OVER() to define their processing window.

--Analytical functions must be used with OVER() to define their processing window.

SELECT salesperson, sales_amount, RANK() OVER(ORDER BY sales_amount DESC) AS rank_num
FROM sales;

--Without OVER(), analytical functions will not work.


--2. Understand Differences Between ROW_NUMBER(), RANK(), and DENSE_RANK()
--These ranking functions behave differently when handling duplicates.

SELECT salesperson, sales_amount,
       ROW_NUMBER() OVER(ORDER BY sales_amount DESC) AS row_number,
       RANK() OVER(ORDER BY sales_amount DESC) AS rank_num,
       DENSE_RANK() OVER(ORDER BY sales_amount DESC) AS dense_rank_num
FROM sales;


--ROW_NUMBER() → Assigns a unique number to each row (no gaps).
--RANK() → Assigns the same rank for duplicates, but skips the next rank number.
--DENSE_RANK() → Assigns the same rank for duplicates, but does not skip rank numbers.


--3. Use LAG() and LEAD() for Row Comparisons
--LAG() gets the previous row’s value, while LEAD() gets the next row’s value.

SELECT salesperson, date, sales_amount,
       LAG(sales_amount) OVER(PARTITION BY salesperson ORDER BY date) AS previous_sales,
       LEAD(sales_amount) OVER(PARTITION BY salesperson ORDER BY date) AS next_sales
FROM sales;

--LAG() → Retrieves the previous row's value.
--LEAD() → Retrieves the next row's value.

--4. Use PARTITION BY to Group Calculations by Category

--PARTITION BY helps analyze data separately within groups (e.g., by salesperson, department, etc.).

SELECT salesperson, date, sales_amount,
       RANK() OVER(PARTITION BY salesperson ORDER BY sales_amount DESC) AS rank_in_sales
FROM sales;

--Each salesperson’s sales are ranked independently.

--5. Use FIRST_VALUE() and LAST_VALUE() to Retrieve the First/Last Row in a Group

--FIRST_VALUE() gets the first row’s value in the partition.
--LAST_VALUE() gets the last row’s value, but requires proper framing.

SELECT salesperson, date, sales_amount,
       FIRST_VALUE(sales_amount) OVER(PARTITION BY salesperson ORDER BY date) AS first_sale,
       LAST_VALUE(sales_amount) OVER(PARTITION BY salesperson ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_sale
FROM sales;

--Ensures the correct first and last values are retrieved.
