-- Create a table named employees with four columns: id, name, age, and salary. The id column is set as an auto-incrementing primary key, ensuring each employee has a unique identifier.

CREATE TABLE employees (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(20),
    age INTEGER,
    salary NUMERIC
);

-- The INSERT query adds new records to a database table. 

-- syntax
INSERT INTO table_name (column1, column2, column3, ...)
VALUES (value1, value2, value3, ...);

-- example
INSERT INTO employees (name, age, salary)
VALUES ('Sam Patel', 25, 55000);

-- Select * from employees 


-- The UPDATE query modifies existing records in a database table.

-- syntax
UPDATE table_name
SET column1 = value1, column2 = value2, ...
WHERE condition;

-- example
UPDATE employees
SET salary = 60000
WHERE name = 'Sam Patel';


-- Delete Query removes rows from a table based on a specified condition.

-- syntax
DELETE FROM table_name
WHERE condition;


DELETE FROM employees
WHERE name = 'Sam Patel';


---------------------------------------------------------------------
--Things to Remember in INSERT, UPDATE, and DELETE Queries
---------------------------------------------------------------------
--1. Use INSERT with Explicit Column Names to Avoid Errors
--Always specify column names when using INSERT to prevent errors when table structure changes in the future.
INSERT INTO employees (name, age, salary) VALUES ('Sam Patel', 25, 55000);

--2. Use UPDATE with WHERE to Avoid Unintended Changes
--Without a WHERE clause, UPDATE affects all rows, which can cause data loss.
UPDATE employees SET salary = 60000 WHERE id = 1; -- Updates only one employee

--3. Always Check DELETE with SELECT Before Execution
--Running DELETE without a WHERE clause removes all records from the table.
--Before deleting, run SELECT to verify affected rows.

--Example: Filter specific employees
DELETE FROM employees WHERE id = 3;

SELECT * FROM employees WHERE age < 25;
DELETE FROM employees WHERE age < 25;

--4. Use OUTPUT to Track Changes in INSERT, UPDATE, and DELETE
--Use OUTPUT to return the affected rows for logging or auditing purposes.
INSERT INTO employees (name, age, salary)
OUTPUT inserted.*
VALUES ('John Doe', 30, 70000);

UPDATE employees
SET salary = 75000
OUTPUT deleted.salary AS OldSalary, inserted.salary AS NewSalary
WHERE id = 2;

--5. Use Transactions (BEGIN TRAN) for Safe UPDATE and DELETE
--If updating or deleting multiple rows, use transactions (BEGIN TRAN) to ensure you can roll back in case of mistakes.

--Example (Safe Delete with Rollback Option)
BEGIN TRAN;
DELETE FROM employees WHERE age < 22;
-- Check affected rows before committing
ROLLBACK; -- Use COMMIT if satisfied

--Example (Safe Update with Commit Option):
BEGIN TRAN;
UPDATE employees SET salary = salary * 1.1 WHERE age > 30;
-- Review the update
COMMIT; -- Use ROLLBACK to undo if needed

--6. Handle NULL Values Properly to Prevent Errors
--Ensure NULL values do not break your INSERT or UPDATE queries.

--Example (Using COALESCE() to Handle NULLs)
INSERT INTO employees (name, age, salary)
VALUES ('Alice Brown', 28, COALESCE(NULL, 50000)); -- Defaults salary to 50000 if NULL

--Example (Avoiding NULL Updates)
UPDATE employees
SET salary = COALESCE(salary, 50000)
WHERE id = 2; -- If salary is NULL, set to 50000

--7. Use MERGE for Efficient INSERT, UPDATE, and DELETE in One Query, upsert (insert + update)
--MERGE allows inserting, updating, and deleting records in one operation.
MERGE INTO employees AS target
USING (SELECT 'Sam Patel' AS name, 26 AS age, 60000 AS salary) AS source
ON target.name = source.name
WHEN MATCHED THEN
  UPDATE SET target.salary = source.salary
WHEN NOT MATCHED THEN
  INSERT (name, age, salary) VALUES (source.name, source.age, source.salary);
