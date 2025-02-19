-- JOIN is used to combine rows from two or more tables based on a related column, allowing you to retrieve meaningful data across multiple tables. Common types include INNER JOIN, LEFT JOIN, RIGHT JOIN, and FULL JOIN, each defining how unmatched rows are handled.

-- Drop table employees
CREATE TABLE employees (
  id INT PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  department VARCHAR(50) NOT NULL
);

CREATE TABLE salaries (
  id INT PRIMARY KEY,
  employee_id INTEGER NOT NULL,
  salary INTEGER NOT NULL
);


INSERT INTO employees (id,name, department)
VALUES (1,'John Smith', 'Sales'),
       (2,'Jane Doe', 'Marketing'),
       (3,'Bob Brown', 'Sales'),
       (5,'Sarah Anderson', 'Marketing');

INSERT INTO salaries (id,employee_id, salary)
VALUES (1, 1, 50000),
       (2, 2, 60000),
       (3, 3, 70000),
	   (4, 4, 80000);

-----------INNER JOIN-------------
--The INNER JOIN combines rows from both tables where the join condition is true. In other words, it returns only the rows that have matching values in both tables.

SELECT employees.name, salaries.salary
FROM employees
INNER JOIN salaries ON employees.id = salaries.employee_id;

--Table Aliases (e and s) – Improves readability and performance, especially in complex queries with multiple joins.
SELECT e.name, s.salary
FROM employees AS e
INNER JOIN salaries AS s ON e.id = s.employee_id;



----------LEFT JOIN-----------------
--The LEFT JOIN returns all rows from the left table and matching rows from the right table. If there are no matching rows in the right table, the result will contain NULL values for the right table columns.

SELECT e.name, COALESCE(s.salary, 0) AS salary
FROM employees AS e
LEFT JOIN salaries AS s ON e.id = s.employee_id;

--Using COALESCE(s.salary, 0) replaces NULL with 0, ensuring meaningful results.


--------------RIGHT JOIN-----------------
---The RIGHT JOIN returns all rows from the right table and matching rows from the left table. If there are no matching rows in the left table, the result will contain NULL values for the left table columns.

SELECT COALESCE(e.name, 'Unknown') AS employee_name, s.salary
FROM salaries AS s
RIGHT JOIN employees AS e ON e.id = s.employee_id;

-----------------FULL OUTER JOIN------------------
--The FULL OUTER JOIN returns all rows from both tables. If there are no matching rows in one of the tables, the result will contain NULL values for the columns of the table that has no matching rows.

SELECT 
    COALESCE(e.name, 'Unknown Employee') AS employee_name, 
    COALESCE(s.salary, 0) AS salary
FROM employees AS e
FULL OUTER JOIN salaries AS s 
    ON e.id = s.employee_id;

------------------CROSS JOIN-----------------------
---CROSS JOIN returns the Cartesian product of both tables, meaning that it returns all possible combinations of rows from both tables.
--CROSS JOINs can lead to performance issues when dealing with large datasets

SELECT e.name, s.salary
FROM employees AS e
CROSS JOIN salaries AS s;

-------------------------Other Examples----------------

--Drop table customers
--Drop table orders

CREATE TABLE customers (
    id INT IDENTITY(1,1) PRIMARY KEY,  -- Auto-incrementing primary key
    name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE orders (
    id INT IDENTITY(1,1) PRIMARY KEY,  -- Auto-incrementing primary key
    customer_id INT NOT NULL,
    product VARCHAR(50) NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),  -- Ensures quantity is always positive
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0), -- Ensures price is non-negative
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE
);

INSERT INTO customers (name, email)
VALUES ('John Smith', 'john@example.com'),
       ('Jane Doe', 'jane@example.com'),
       ('Bob Brown', 'bob@example.com'),
       ('Sarah Anderson', 'sarah@example.com'),
       ('Dan Koe', 'dan@example.com');

INSERT INTO orders (customer_id, product, quantity, price)
VALUES (1,'iPhone', 2, 1000),
       (2,'MacBook', 1, 1500),
       (3,'iPad', 1, 800),
       (5,'iMac', 1, 2000);

Select * from customers;
Select * from orders;


--------------INNER JOIN---------------

--The INNER JOIN will return only the orders that have a corresponding customer in the customers table.

SELECT 
    o.id AS OrderID, 
    c.name AS CustomerName, 
    o.product, 
    o.quantity, 
    o.price
FROM orders AS o
INNER JOIN customers AS c ON o.customer_id = c.id;


-----------------LEFT JOIN--------------------

--The LEFT JOIN will return all orders, even if the corresponding customer has been deleted from the customers table.

SELECT 
    o.id AS OrderID, 
    COALESCE(c.name, 'Unknown') AS CustomerName, 
    o.product, 
    o.quantity, 
    o.price
FROM orders AS o
LEFT JOIN customers AS c ON o.customer_id = c.id;

--------------------RIGHT JOIN---------------------

--The RIGHT JOIN will return all customers, even if they have not placed an order.

SELECT 
    COALESCE(o.id, 0) AS OrderID, 
    c.name AS CustomerName, 
    COALESCE(o.product, 'No Orders') AS Product, 
    COALESCE(o.quantity, 0) AS Quantity, 
    COALESCE(o.price, 0.00) AS Price
FROM customers AS c
RIGHT JOIN orders AS o ON o.customer_id = c.id;

-----------------------FULL OUTER JOIN--------------

--The FULL OUTER JOIN will return all orders and customers, including those where either the order or the customer has been deleted.

SELECT 
    COALESCE(o.id, 0) AS OrderID, 
    COALESCE(c.name, 'Unknown Customer') AS CustomerName, 
    COALESCE(o.product, 'No Orders') AS Product, 
    COALESCE(o.quantity, 0) AS Quantity, 
    COALESCE(o.price, 0.00) AS Price
FROM orders AS o
FULL OUTER JOIN customers AS c ON o.customer_id = c.id;

-------------------------SELF JOIN------------------------
--A self join is used to join a table to itself. This can be useful in situations where you need to compare rows within a single table.

--Suppose we have a table called employees with the following columns:

-- Drop table employees
CREATE TABLE employees (
  id INT PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  manager_id INT
);
INSERT INTO employees (id,name, manager_id)
VALUES (1,'John Smith',2 ),
       (2,'Jane Doe', 3),
       (3,'Bob Brown', 2),
       (5,'Sarah Anderson',2);


--The manager_id column contains the ID of the manager for each employee. We can use a self join to find the name of each employee and their manager's name.

SELECT 
    e.name AS EmployeeName, 
    COALESCE(m.name, 'No Manager') AS ManagerName
FROM employees AS e
INNER JOIN employees AS m ON e.manager_id = m.id;


----------------------------------------------------------------------
--Things to Remember in Joins in SQL
----------------------------------------------------------------------
 --1. Always Use ON Instead of USING for Joins in SQL Server

SELECT employees.name, salaries.salary
FROM employees 
INNER JOIN salaries ON employees.id = salaries.employee_id;

--2. Use INNER JOIN to Retrieve Only Matching Records
--INNER JOIN returns only rows where there is a match in both tables.
SELECT e.name, s.salary
FROM employees AS e
INNER JOIN salaries AS s ON e.id = s.employee_id;


--3. Use LEFT JOIN to Keep All Records from One Table
--LEFT JOIN returns all rows from the left table and matching rows from the right table.
SELECT e.name, COALESCE(s.salary, 0) AS salary
FROM employees AS e
LEFT JOIN salaries AS s ON e.id = s.employee_id;

--4. Be Careful with RIGHT JOIN (Use LEFT JOIN Instead for Readability)
--RIGHT JOIN is rarely used because it can be rewritten as LEFT JOIN by swapping tables.
SELECT o.id AS OrderID, c.name AS CustomerName
FROM customers AS c
LEFT JOIN orders AS o ON c.id = o.customer_id;
--This is easier to read and maintain than using RIGHT JOIN.


--5. Use FULL OUTER JOIN to Keep All Records from Both Tables
--FULL OUTER JOIN combines LEFT JOIN and RIGHT JOIN, keeping unmatched records from both tables.
SELECT c.name AS CustomerName, o.product, o.quantity
FROM customers AS c
FULL OUTER JOIN orders AS o ON c.id = o.customer_id;
--Tip: Use COALESCE() to handle NULL values for missing data.

--6. Use SELF JOIN for Hierarchical Data (e.g., Employee-Manager Relationship)
--A self-join is when a table joins with itself, typically used for hierarchical relationships.
--Example: Find Each Employee’s Manager

SELECT e.name AS Employee, COALESCE(m.name, 'No Manager') AS Manager
FROM employees AS e
LEFT JOIN employees AS m ON e.manager_id = m.id;

--7. Use Indexing for Faster Joins in Large Tables
--Indexing on foreign keys speeds up joins significantly.
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
