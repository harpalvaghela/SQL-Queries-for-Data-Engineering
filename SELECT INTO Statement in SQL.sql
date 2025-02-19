--  CTAS (Create Table As Select)
-- The CREATE TABLE AS SELECT (CTAS) operation is a powerful way to create a new table based on the output of a SELECT statement. This operation allows you to define the structure of the new table using the result set of a query, making it very useful for duplicating tables, creating backup copies, or generating summary tables that require periodic updating.
-- However, it's important to note that SQL Server does not support the CREATE TABLE AS SELECT syntax directly as some other SQL database systems like Oracle or PostgreSQL do. Instead, SQL Server uses a similar but slightly different approach using the SELECT INTO statement to achieve the same result.


--DROP TABLE EMPLOYEES;

CREATE TABLE employees (
  id int identity(1,1) PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  department VARCHAR(50) NOT NULL,
  salary INTEGER NOT NULL
);

INSERT INTO employees (name, department, salary) VALUES
('John Doe', 'Sales', 50000),
('Jane Smith', 'Marketing', 60000),
('Bob Johnson', 'Finance', 70000),
('Karen Williams', 'Sales', 55000),
('Mike Johnson', 'Marketing', 65000),
('Sarah Lee', 'Finance', 75000);

select  * from employees;

-- Example
SELECT id, name, department, salary
into high_paid_employees
FROM employees
WHERE salary >= 70000;

select * from high_paid_employees;
-- This table (high_paid_employees) is not dependent on particular query. if we insert more data, it will not reflect.

INSERT INTO employees (name, department, salary) VALUES
('Jaydeep Patel', 'Sales', 90000),
('Kunjal Chavda', 'Marketing', 72000);


select * from high_paid_employees;

---------------------------------------------------------
--Things to Remember in SELECT INTO Statements in SQL Server
---------------------------------------------------------
--The SELECT INTO statement creates a new table and inserts data from an existing table in one step. It is useful for backups, temporary tables, and quick data copying.

--1. SELECT INTO Creates a New Table, It Cannot Insert into an Existing Table
--If the target table already exists, SELECT INTO will fail.

SELECT id, name, department, salary 
INTO high_paid_employees
FROM employees
WHERE salary >= 70000;

--The table high_paid_employees is created automatically.

-- 2. SELECT INTO Copies Column Structure and Data, But Not Constraints or Indexes
--The new table inherits column names and data types but not primary keys, foreign keys, indexes, or constraints.

--Check Missing Constraints in high_paid_employees
EXEC sp_help high_paid_employees;
--If constraints are needed, they must be added manually:
ALTER TABLE high_paid_employees ADD PRIMARY KEY (id);


--3. Use WHERE to Filter Data and Avoid Copying Unnecessary Rows
--Without WHERE, SELECT INTO copies all data from the source table.
SELECT id, name, department, salary 
INTO high_paid_employees
FROM employees
WHERE salary >= 70000;

--Ensures only high-salary employees are copied, reducing storage usage.


--4. SELECT INTO Cannot Be Used with JOIN, Use INSERT INTO ... SELECT Instead
--SELECT INTO only works with a single table.


CREATE TABLE department_employees (
    id INT,
    name VARCHAR(50),
    department_name VARCHAR(50)
);

INSERT INTO department_employees (id, name, department_name)
SELECT e.id, e.name, d.department_name
FROM employees e
JOIN departments d ON e.department = d.department_id;


-- 5. If Needed, Use TEMP TABLES for Temporary Data Processing

--If the copied table is only needed for a session, use a #temp table.

SELECT id, name, department, salary 
INTO #temp_high_paid_employees
FROM employees
WHERE salary >= 70000;

--Temporary tables (#temp_table) automatically drop when the session ends.
