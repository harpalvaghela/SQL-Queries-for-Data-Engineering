-- The CASE statement in SQL Server is a powerful expression that allows conditional logic to be implemented directly within SQL queries. 
-- The CASE expression can be used in SELECT, INSERT, UPDATE, and DELETE statements, making it incredibly versatile.


-------------- Simple Syntax:

--CASE input_expression
--    WHEN condition1 THEN result1
--    WHEN condition2 THEN result2
--    ...
--    ELSE default_result
--END


--------------Searched CASE Expression:

--CASE
--    WHEN boolean_condition1 THEN result1
--    WHEN boolean_condition2 THEN result2
--    ...
--    ELSE default_result
--END


-- Example: Simple CASE Expression


--SELECT ProductID, ProductName,
--    CASE CategoryID
--        WHEN 1 THEN 'Beverage'
--        WHEN 2 THEN 'Food'
--        WHEN 3 THEN 'Electronics'
--        ELSE 'Other'
--    END AS CategoryName
--FROM Products;

select * from products;

-- Example: Searched CASE Expression
SELECT id, name, salary,
    CASE
        WHEN Salary < 40000 THEN 'Entry Level'
        WHEN Salary BETWEEN 40000 AND 80000 THEN 'Mid Level'
        WHEN Salary > 80000 THEN 'Senior Level'
        ELSE 'Unspecified'
    END AS SalaryLevel
FROM Employees;


------------------------------------------------------
--Drop table employees;

CREATE TABLE employee (
  id int identity(1,1) PRIMARY KEY,
  name VARCHAR(50),
  age INTEGER,
  salary NUMERIC,
  position VARCHAR(50)
);

INSERT INTO employee (name, age, salary, position) VALUES
('John Doe', 25, 2500, 'Developer'),
('Jane Smith', 30, 3500, 'Manager'),
('Bob Johnson', 45, 5000, 'Director'),
('Mike Brown', 22, 2000, 'Intern');

-- Example: Basic CASE Statement
SELECT name, salary,
  CASE
    WHEN salary < 3000 THEN 'Low'
    WHEN salary BETWEEN 3000 AND 4000 THEN 'Medium'
    ELSE 'High'
  END AS salary_category
FROM employee;

-- This will give error in SQL Server:
SELECT
  CASE
    WHEN salary < 3000 THEN 'Low'
    WHEN salary BETWEEN 3000 AND 4000 THEN 'Medium'
    ELSE 'High'
  END AS salary_category,
  COUNT(*) as count
FROM employee
GROUP BY salary_category; -- wrong assignment of CASE statement

-- We can't use alias of CASE expression in group by clause, so we need to write as below:
--- Example: Case Statement with Aggregation

SELECT
    CASE
        WHEN salary < 3000 THEN 'Low'
        WHEN salary BETWEEN 3000 AND 4000 THEN 'Medium'
        ELSE 'High'
    END AS salary_category,
    COUNT(*) AS count
FROM employee
GROUP BY
    CASE
        WHEN salary < 3000 THEN 'Low'
        WHEN salary BETWEEN 3000 AND 4000 THEN 'Medium'
        ELSE 'High'
    END;


-----Example: Case Statement with Multiple Conditions

SELECT name, age, salary,
  CASE
    WHEN age < 25 AND salary < 2500 THEN 'Junior Developer'
    WHEN age BETWEEN 25 AND 35 AND salary BETWEEN 2500 AND 3500 THEN 'Developer'
    WHEN age > 35 AND salary > 3500 THEN 'Senior Developer'
    ELSE 'Other'
  END AS position
FROM employee;


CREATE TABLE students (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    age INT NOT NULL,
    marks FLOAT(2) NOT NULL
);

INSERT INTO students (name, age, marks) VALUES
    ('John Doe', 17, 78.5),    
    ('Jane Smith', 22, 89.2),  
    ('Peter Parker', 21, 92.3),
    ('Mary Johnson', 23, 86.7),
    ('David Brown', 19, 73.9), 
    ('Alice Green', 25, 95.0), 
   ('Michael Scott', 27, 60.5),
    ('Sarah Lee', 29, 88.0),   
    ('Tom Hardy', 16, 55.0),   
    ('Emma Watson', 18, 80.2); 

Select * from students;


-------------------------------------------------------
--Things to Remember in CASE Statement
-------------------------------------------------------

-- 1. CASE Must Have a THEN for Each WHEN, and an ELSE for Safety

--Every WHEN condition must have a THEN statement.
--Always include ELSE to handle unexpected cases.


SELECT name, age,
       CASE 
           WHEN age < 18 THEN 'Minor'
           WHEN age >= 18 AND age < 60 THEN 'Adult'
           ELSE 'Senior'
       END AS AgeCategory
FROM students;


-- 2. CASE Can Be Used in SELECT, WHERE, ORDER BY, and GROUP BY
--CASE works in multiple SQL clauses.

SELECT name, age,
       CASE 
           WHEN age < 18 THEN 'Underage'
           ELSE 'Eligible'
       END AS Status
FROM students;

----

SELECT * FROM students
WHERE 
    CASE 
        WHEN age < 18 THEN 'Minor'
        ELSE 'Adult'
    END = 'Adult'; -- ERROR: This is incorrect!

--- CASE should be inside a condition
	SELECT * FROM students 
WHERE (age < 18 AND 'Minor' = 'Minor') OR (age >= 18 AND 'Adult' = 'Adult');



-- 3. CASE Can Be Used for Calculations Inside Queries
--Use CASE to apply different logic based on column values.


SELECT name, marks,
       CASE 
           WHEN marks >= 90 THEN marks * 0.10  -- 10% discount
           WHEN marks >= 80 THEN marks * 0.05  -- 5% discount
           ELSE 0
       END AS Discount
FROM students;


--4. CASE Can Be Nested Inside Another CASE
--You can nest CASE inside another CASE for more complex logic.

SELECT name, marks,
       CASE 
           WHEN marks >= 90 THEN 'A+'
           WHEN marks >= 80 THEN 
               CASE 
                   WHEN marks >= 85 THEN 'A'
                   ELSE 'B+'
               END
           ELSE 'C'
       END AS Grade
FROM students;


--5. CASE in ORDER BY for Custom Sorting
--Use CASE to sort based on conditions dynamically.

SELECT name, age 
FROM students
ORDER BY 
    CASE 
        WHEN age < 18 THEN 1
        WHEN age BETWEEN 18 AND 25 THEN 2
        ELSE 3
    END;
--Sorts minors first, then young adults, then older students.


--6. CASE Can Be Used for Conditional Aggregations
--Use CASE inside SUM(), COUNT(), AVG(), etc.

SELECT 
    SUM(CASE WHEN age < 18 THEN 1 ELSE 0 END) AS Minors,
    SUM(CASE WHEN age >= 18 AND age < 25 THEN 1 ELSE 0 END) AS YoungAdults,
    SUM(CASE WHEN age >= 25 THEN 1 ELSE 0 END) AS Adults
FROM students;
