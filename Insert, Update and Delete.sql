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

