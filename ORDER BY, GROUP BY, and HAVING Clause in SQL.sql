CREATE TABLE customer_orders (
order_id INT PRIMARY KEY,
customer_name VARCHAR(50),
order_date DATE,
order_amount DECIMAL(10,2)
);

INSERT INTO customer_orders (order_id, customer_name, order_date, order_amount)
VALUES
(1, 'John', '2021-01-01', 100),
(2, 'Jane', '2021-01-02', 200),
(3, 'John', '2021-01-03', 50),
(4, 'Jane', '2021-01-04', 300),
(5, 'John', '2021-01-05', 150);

Select * from customer_orders

--ORDER BY Clause
--The ORDER BY clause is used to sort the result set in either ascending (ASC) or descending (DESC) order based on one or more columns. By default, sorting is ascending (ASC) if no order is specified.

SELECT * FROM customer_orders
ORDER BY order_amount ASC;

SELECT * FROM customer_orders
ORDER BY order_amount DESC;

SELECT * FROM customer_orders
ORDER BY order_date DESC;

SELECT * FROM customer_orders
ORDER BY customer_name ASC;

--Order by Multiple Columns (Sort by Date, then by Amount)

SELECT * FROM customer_orders
ORDER BY order_date DESC, order_amount ASC;

-----------------GROUP BY Clause--------------------
--The GROUP BY clause is used to group rows based on one or more columns.

--To group the customer_orders table by customer_name and calculate the total order_amount for each customer, we can use the following SQL code:
SELECT customer_name, SUM(order_amount) AS total_order_amount FROM customer_orders
GROUP BY customer_name;

--Count of Orders per Customer
SELECT customer_name, COUNT(order_id) AS total_orders
FROM customer_orders
GROUP BY customer_name;

--Maximum Order Amount per Customer
SELECT customer_name, MAX(order_amount) AS max_order
FROM customer_orders
GROUP BY customer_name;

--Grouping by Order Date to Find Daily Sales
SELECT order_date, SUM(order_amount) AS daily_sales
FROM customer_orders
GROUP BY order_date
ORDER BY order_date;

--Average Order Value per Customer
SELECT customer_name, AVG(order_amount) AS avg_order_value
FROM customer_orders
GROUP BY customer_name;

----------------------HAVING Clause------------------------
--The HAVING clause is used to filter the result set based on a condition on a grouped column or an aggregate function.

--Customers Who Spent More Than $100
SELECT customer_name, SUM(order_amount) AS total_spent
FROM customer_orders
GROUP BY customer_name
HAVING SUM(order_amount) > 100;

--Customers Who Placed More Than 1 Order
SELECT customer_name, COUNT(order_id) AS total_orders
FROM customer_orders
GROUP BY customer_name
HAVING COUNT(order_id) > 1;

--Customers with an Average Order Value Above $100
SELECT customer_name, AVG(order_amount) AS avg_order_value
FROM customer_orders
GROUP BY customer_name
HAVING AVG(order_amount) > 100;


-- Show Order Dates Where Total Sales Exceeded $300
SELECT order_date, SUM(order_amount) AS daily_sales
FROM customer_orders
GROUP BY order_date
HAVING SUM(order_amount) > 300
ORDER BY order_date;


--Things to Remember for GROUP BY, ORDER BY, and HAVING Clause

-- 1. GROUP BY must include all non-aggregated columns
-- 2. HAVING can only be used after GROUP BY
-- 3. ORDER BY is always executed last
-- 4. Use WHERE for filtering before GROUP BY, and HAVING after
-- 5. ORDER BY can sort using aggregate functions, even without GROUP BY
