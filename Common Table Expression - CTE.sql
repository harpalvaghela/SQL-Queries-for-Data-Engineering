CREATE TABLE employees (
   id int PRIMARY KEY,
   name VARCHAR(255) NOT NULL,
   salary INTEGER NOT NULL
);


INSERT INTO employees (id, name, salary) VALUES
   (1, 'John Doe', 45000),
   (2, 'Jane Smith', 55000),
   (3, 'Bob Johnson', 65000),
   (4, 'Alice Lee', 75000);


-- To create a CTE, we use the WITH clause, followed by the name of the CTE and a SELECT statement that defines the result set. 
WITH high_salary_employees AS (
   SELECT name, salary
   FROM employees
   WHERE salary >= 50000
)
SELECT * FROM high_salary_employees;

-------------------------------------------------
--Suppose we have a table named books that contains information about books in a library. We can create a CTE that selects all books published after 2000.


CREATE TABLE books (
   id int identity (1,2) PRIMARY KEY,
   title VARCHAR(255) NOT NULL,
   author VARCHAR(255) NOT NULL,
   published_year INTEGER NOT NULL
);

INSERT INTO books (title, author, published_year) VALUES
   ('The Catcher in the Rye', 'J.D. Salinger', 1951),
   ('To Kill a Mockingbird', 'Harper Lee', 1960),
   ('1984', 'George Orwell', 1949),
   ('The Great Gatsby', 'F. Scott Fitzgerald', 1925),
   ('The Lord of the Rings', 'J.R.R. Tolkien', 1954),
   ('The Da Vinci Code', 'Dan Brown', 2003);

WITH new_books AS (
   SELECT title, author, published_year
   FROM books
   WHERE published_year > 2000
)
SELECT * FROM new_books;

-----------------------------

-- drop table employees
-- drop table departments


CREATE TABLE departments (
   id int identity(1,1) PRIMARY KEY,
   name VARCHAR(255) NOT NULL
);

INSERT INTO departments (name) VALUES
   ('Sales'),
   ('Marketing'),
   ('IT');

CREATE TABLE employees (
   id int identity(1,1) PRIMARY KEY,
   name VARCHAR(255) NOT NULL,
   department_id INTEGER NOT NULL
);

INSERT INTO employees (name, department_id) VALUES
   ('John Doe', 1),
   ('Jane Smith', 2),
   ('Bob Johnson', 1),
   ('Alice Lee', 3);


WITH employee_departments AS (
   SELECT e.name, d.name AS department_name
   FROM employees e
   JOIN departments d ON e.department_id = d.id
)
SELECT * FROM employee_departments;

--Multiple CTE

CREATE TABLE items (
  id int identity(1,1) PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  price INTEGER NOT NULL
);

--drop table sales

CREATE TABLE sales (
  id int identity(1,1) PRIMARY KEY,
  item_id INTEGER NOT NULL,
  quantity INTEGER NOT NULL,
  sale_date DATE NOT NULL
);

INSERT INTO items (name, price) VALUES
  ('Product A', 100),
  ('Product B', 200),
  ('Product C', 300);

INSERT INTO sales (item_id, quantity, sale_date) VALUES
  (1, 10, '2022-01-01'),
  (2, 5, '2022-01-01'),
  (3, 2, '2022-01-01'),
  (1, 20, '2022-02-01'),
  (2, 10, '2022-02-01'),
  (3, 4, '2022-02-01'),
  (1, 30, '2022-03-01'),
  (2, 15, '2022-03-01'),
  (3, 6, '2022-03-01');

---
WITH monthly_sales AS (
  SELECT    
    DATEADD(MONTH, DATEDIFF(MONTH, 0, s.sale_date), 0) AS month,
    SUM(s.quantity) AS total_quantity,
    SUM(s.quantity * i.price) AS total_revenue
  FROM sales s
  JOIN items i ON s.item_id = i.id
  GROUP BY DATEADD(MONTH, DATEDIFF(MONTH, 0, sale_date), 0)  -- Must repeat the expression exactly as in SELECT
),
monthly_items_sold AS (
  SELECT
    DATEADD(MONTH, DATEDIFF(MONTH, 0, sale_date), 0) AS month,
    SUM(quantity) AS total_items_sold
  FROM sales
  GROUP BY DATEADD(MONTH, DATEDIFF(MONTH, 0, sale_date), 0)  -- Must repeat the expression exactly as in SELECT
)
SELECT
  ms.month,
  mis.total_items_sold,
  ms.total_revenue
FROM monthly_sales ms
JOIN monthly_items_sold mis ON ms.month = mis.month;




----------------------------------------------------------------------------
--Things to Remember in Common Table Expressions (CTE) in SQL
----------------------------------------------------------------------------
--A Common Table Expression (CTE) is a temporary result set that makes queries more readable, reusable, and structured. It is created using the WITH statement.


--1. CTE Must Be Defined Before the Main Query
--A CTE must be declared before the SELECT, UPDATE, or DELETE statement that uses it.
WITH EmployeeCTE AS (
    SELECT emp_id, emp_name FROM Employee
)
SELECT * FROM EmployeeCTE;


--2. CTE Exists Only for the Duration of the Query
--A CTE is temporary and only exists during query execution.
--CTEs are not stored in the database like regular tables or views.


WITH ManagerCTE AS (
    SELECT e1.emp_name AS Employee, e2.emp_name AS Manager
    FROM Employee e1
    LEFT JOIN Employee e2 ON e1.emp_manager_id = e2.emp_id
)
SELECT * FROM ManagerCTE;

--Once executed, ManagerCTE disappears.

--3. CTEs Cannot Be Used Outside Their Query Scope
--CTEs cannot be referenced in multiple queries unless redefined.
WITH EmployeeCTE AS (
    SELECT emp_id, emp_name FROM Employee
)
SELECT * FROM EmployeeCTE;

--4. Use Recursive CTEs for Hierarchical Data (e.g., Employee Hierarchies)
--Recursive CTEs allow processing hierarchical relationships (e.g., employees & managers).
-- Example: Finds employees and their reporting hierarchy.


WITH EmployeeHierarchy AS (
    SELECT emp_id, emp_name, emp_manager_id, 1 AS Level
    FROM Employee
    WHERE emp_manager_id IS NULL  -- Get top-level managers
    UNION ALL
    SELECT e.emp_id, e.emp_name, e.emp_manager_id, eh.Level + 1
    FROM Employee e
    JOIN EmployeeHierarchy eh ON e.emp_manager_id = eh.emp_id
)
SELECT * FROM EmployeeHierarchy;


--5. Use CTEs to Improve Readability in Complex Queries
--CTEs make complex queries more structured and readable.

WITH SalesSummary AS (
    SELECT user_id, SUM(price * quantity) AS total_spent
    FROM Ecommerce
    GROUP BY user_id
)
SELECT user_id, total_spent
FROM SalesSummary
WHERE total_spent > 500;

--Makes query easier to read compared to multiple nested subqueries.