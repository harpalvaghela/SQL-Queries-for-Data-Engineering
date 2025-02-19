-- Views in SQL

-- In SQL, a view acts as a virtual table that is created from the results of an SQL statement.

-- Like a physical table, a view consists of rows and columns. The columns in a view are derived from fields in one or more actual tables in the database.

-- You can incorporate SQL statements and functions into a view, allowing you to display data as though it all originates from a single table.


CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name TEXT,
    last_name TEXT
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    item TEXT,
    quantity INT,
    price NUMERIC(10,2)
);


INSERT INTO customers (customer_id, first_name, last_name)
VALUES (101, 'John', 'Doe');

INSERT INTO orders (order_id, customer_id, order_date, item, quantity, price)
VALUES (1, 101, '2022-01-01', 'Shoes', 2, 50);

-- suppose we have this join query
select c.customer_id, c.first_name, c.last_name, o.order_date, o.item, o.quantity, o.price from customers c
join orders o on c.customer_id = o.customer_id;

-- Creating a view
Create VIEW customer_order_view AS
select c.customer_id, c.first_name, c.last_name, o.order_date, o.item, o.quantity, o.price from customers c
join orders o on c.customer_id = o.customer_id;

-- Executing a view 
select * from customer_order_view;


-- Let's insert more data

INSERT INTO customers (customer_id, first_name, last_name)
VALUES (102, 'Jigar', 'Patel');

INSERT INTO orders (order_id, customer_id, order_date, item, quantity, price)
VALUES (2, 102, '2023-01-02', 'Watch', 1, 5000);


select * from customer_order_view;

-- Whenever we make changes in backend tables, it will automatically reflected in the view.


-------------------------------------------------
--Things to Remember in Views in SQL
-------------------------------------------------

--A View is a virtual table that provides a stored query result but does not store data itself. It simplifies complex queries, enhances security, and improves reusability.

--1. Views Store Queries, Not Data
--A view is not a physical table; it retrieves live data whenever accessed.
--Changes in underlying tables immediately reflect in the view.

CREATE VIEW CustomerOrders AS
SELECT c.customer_id, c.first_name, c.last_name, o.order_id, o.order_date, o.item, o.quantity, o.price
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id;

--Whenever queried, this view will always show updated customer orders.


--2. Views Cannot Have ORDER BY (Unless Used with TOP)
--A VIEW does not guarantee sorting unless used with TOP or OFFSET.

CREATE VIEW SortedOrders AS
SELECT TOP 100 PERCENT * FROM orders ORDER BY order_date;


--3. Views Cannot Modify Data If They Contain Joins, Aggregations, or Distinct
--A view is updateable only if it contains a single table without aggregations or joins.

CREATE VIEW SimpleOrders AS
SELECT order_id, item, quantity, price FROM orders;

UPDATE SimpleOrders SET price = 60 WHERE order_id = 1; -- Works!


--4. Views Improve Security by Restricting Column Access
--Views help limit access to sensitive columns.
CREATE VIEW CustomerSales AS
SELECT customer_id, order_id, order_date, item, quantity, price
FROM orders;

--Users accessing CustomerSales won’t see first_name or last_name.

--5. Use WITH SCHEMABINDING to Prevent Underlying Table Modifications
--SCHEMABINDING prevents accidental changes to the underlying table.

CREATE VIEW SecureOrders WITH SCHEMABINDING AS
SELECT order_id, order_date, item, quantity, price
FROM dbo.orders;

--Now, dropping the orders table will fail unless the view is removed first.
