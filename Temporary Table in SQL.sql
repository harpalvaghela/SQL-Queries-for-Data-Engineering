--- Temporary Table in SQL
--Temporary tables are typically stored in a special area of the database, usually referred to as the “tempdb.”

CREATE TABLE #temp_employee (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    age INT NOT NULL,
    department VARCHAR(100) NOT NULL
);

INSERT INTO #temp_employee (name, age, department)
VALUES
    ('John Doe', 30, 'Sales'),
    ('Jane Smith', 25, 'Marketing'),
    ('Bob Johnson', 45, 'IT');

SELECT * FROM #temp_employee;


---------------------------------------------------------------
--Things to Remember in Temporary Table Concept in SQL
---------------------------------------------------------------
--1. Temporary Tables Are Session-Specific and Automatically Dropped When the Session Ends
--Temporary tables exist only within the session or connection that created them.
--If you disconnect or restart SQL Server, the table is automatically removed.

CREATE TABLE #temp_employee (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    age INT NOT NULL,
    department VARCHAR(100) NOT NULL
);

INSERT INTO #temp_employee (name, age, department)
VALUES ('Alice Brown', 28, 'HR');

SELECT * FROM #temp_employee;
--The table is deleted when the session ends.


--2. Use ##GlobalTempTable for Cross-Session Usage
--If a temporary table needs to be shared across multiple sessions, use a global temporary table (##temp_table).

CREATE TABLE ##global_temp_employee (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    age INT NOT NULL
);

INSERT INTO ##global_temp_employee (name, age)
VALUES ('Sarah Lee', 35);

SELECT * FROM ##global_temp_employee;

--A global temporary table is shared among all users but is dropped when the last session using it ends.


--3. Explicitly Drop Temporary Tables If Needed
--Even though temporary tables auto-delete after the session ends, it’s a good practice to drop them explicitly when they are no longer needed.

DROP TABLE IF EXISTS #temp_employee;
--Prevents errors if the table does not exist.


--4. Indexes and Constraints Can Be Added to Temporary Tables
--Temporary tables support primary keys, indexes, and constraints, improving performance for large datasets.

CREATE TABLE #temp_employee (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    age INT NOT NULL,
    department VARCHAR(100) NOT NULL
);

CREATE INDEX idx_temp_employee_age ON #temp_employee(age);
--Adding indexes improves query speed for filtering and joins.

--5. Use TABLE VARIABLE (@table_variable) for Small Data Sets Instead
--For smaller temporary data sets, use @table_variable instead of #temp_table as it has less overhead.

DECLARE @table_employee TABLE (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    age INT NOT NULL
);

INSERT INTO @table_employee (name, age)
VALUES ('Michael Scott', 40);

SELECT * FROM @table_employee;

--Table variables do not support CREATE INDEX, but they perform better for small datasets.