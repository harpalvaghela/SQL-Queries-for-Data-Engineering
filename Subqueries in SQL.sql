--A subquery in SQL Server is a nested query inside another query that returns a single value or a result set to be used in the main query. 
--It is commonly used in `SELECT`, `WHERE`, and `HAVING` clauses for filtering, comparisons, or calculations.



CREATE TABLE customers2 (
    customer_id int identity(1,1) PRIMARY KEY,
    customer_name VARCHAR(50) NOT NULL,
    customer_email VARCHAR(50) NOT NULL
);

CREATE TABLE order2 (
    order_id int identity(1,1) PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    order_date DATE NOT NULL,
    order_amount DECIMAL(10,2) NOT NULL
);

INSERT INTO customers2 (customer_name, customer_email) VALUES
    ('John Doe', 'johndoe@example.com'),
    ('Jane Smith', 'janesmith@example.com'),
    ('Bob Johnson', 'bobjohnson@example.com');

INSERT INTO order2 (customer_id, order_date, order_amount) VALUES
    (1, '2021-01-01', 50.00),
    (1, '2021-02-01', 75.00),
    (2, '2021-02-15', 125.00),
    (3, '2021-03-01', 200.00);

-- subquery
SELECT customer_name
FROM customers2
WHERE customer_id IN (SELECT customer_id FROM order2 WHERE order_amount > 100);

--Find Each Customer’s Total Orders
SELECT customer_name, 
       (SELECT COUNT(*) FROM order2 WHERE order2.customer_id = customers2.customer_id) AS total_orders
FROM customers2;

--Find Customers Who Placed Orders Over $100
SELECT customer_name
FROM customers2
WHERE customer_id IN (SELECT DISTINCT customer_id FROM order2 WHERE order_amount > 100);

--Average Order Amount Per Customer
SELECT customer_name, avg_order_amount
FROM 
    (SELECT customer_id, AVG(order_amount) AS avg_order_amount FROM order2 GROUP BY customer_id) AS subquery
JOIN customers2 ON subquery.customer_id = customers2.customer_id;

--Find Customers Who Placed More Than One Order
SELECT customer_name
FROM customers2
WHERE EXISTS (
    SELECT 1 FROM order2 WHERE order2.customer_id = customers2.customer_id GROUP BY customer_id HAVING COUNT(*) > 1
);

--Finds customers whose total orders exceed the average order amount.
SELECT customer_id
FROM order2
GROUP BY customer_id
HAVING SUM(order_amount) > (SELECT AVG(order_amount) FROM order2);

--Find Customers Who Have Not Placed Any Orders
SELECT customer_name
FROM customers2
WHERE customer_id NOT IN (SELECT DISTINCT customer_id FROM order2);

--Find Customers with Maximum Order Amount
SELECT customer_name
FROM customers2
WHERE customer_id = (SELECT customer_id FROM order2 WHERE order_amount = (SELECT MAX(order_amount) FROM order2));

--Increase Order Amount by 10% for Customers Who Have Placed More Than One Order
UPDATE order2
SET order_amount = order_amount * 1.1
WHERE customer_id IN (
    SELECT customer_id FROM order2 GROUP BY customer_id HAVING COUNT(*) > 1
);

Select * from order2

--Delete Orders of Customers Who Have Placed Less Than 2 Orders
DELETE FROM order2
WHERE customer_id IN (
    SELECT customer_id FROM order2 GROUP BY customer_id HAVING COUNT(*) < 2
);

Select * from order2

--Add a New Customer with the Highest Order Value
INSERT INTO customers2 (customer_name, customer_email)
SELECT 'VIP Customer', 'vip@example.com'
WHERE NOT EXISTS (SELECT 1 FROM customers2 WHERE customer_name = 'VIP Customer');

----------------------------------------------------------
--Things to Remember in Subqueries in SQL
---------------------------------------------------------


-- 1. Ensure Subqueries Return the Correct Number of Columns

--A subquery used in SELECT must return a single column.
--A subquery in IN or EXISTS should return one column but multiple rows.

-- Example:
SELECT customer_name, 
       (SELECT MAX(order_date) FROM order2 WHERE order2.customer_id = customers2.customer_id) AS last_order_date
FROM customers2;


--2. Use IN for Multi-Row Subqueries and = for Single-Value Subqueries
--When a subquery returns multiple values, use IN instead of =
-- Example: 
SELECT customer_name FROM customers2 WHERE customer_id IN (SELECT customer_id FROM order2 WHERE order_amount > 100);

--3. Use EXISTS Instead of IN for Better Performance in Large Datasets
--EXISTS is faster than IN for large datasets because it stops searching once a match is found.
--Example: 
SELECT customer_name 
FROM customers2 c
WHERE EXISTS (SELECT 1 FROM order2 o WHERE o.customer_id = c.customer_id);

-- 4. Avoid Using Correlated Subqueries Unnecessarily
--Correlated subqueries execute once per row, making them slower than non-correlated subqueries.


-- Faster Alternative (Using JOIN)
--The JOIN approach fetches all data at once, while the subquery runs for every row, slowing performance.
SELECT c.customer_name, COUNT(o.order_id) AS total_orders
FROM customers2 c
LEFT JOIN order2 o ON c.customer_id = o.customer_id
GROUP BY c.customer_name;

--5. Always Test Subqueries Separately Before Using Them in a Query
--A subquery should return the expected result before using it inside a larger query.

--Test the subquery first
SELECT customer_id FROM order2 WHERE order_amount > 100;

-- Then use it in a main query:
SELECT customer_name FROM customers2 
WHERE customer_id IN (SELECT customer_id FROM order2 WHERE order_amount > 100);



