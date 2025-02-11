-------------------------
-- Primary Key
-------------------------

--A primary key consists of one or more columns that uniquely determine each row within a table.
--It serves to guarantee that each row can be uniquely distinguished and retrieved. 
-- The primary key constraint guarantees the uniqueness of the primary key column(s) across all rows in the table.

CREATE TABLE students (
  id int PRIMARY KEY,
  name varchar(50),
  age int,
  gender varchar(10)
);


CREATE TABLE courses (
  id int PRIMARY KEY,
  course_name varchar(100),
  course_description text,
  instructor_name varchar(50)
);

-------------------------
--Foreign Key
-------------------------

-- A foreign key is one or more columns in a table that link to the primary key columns of another table.
--This key establishes a linkage between two tables. The foreign key constraint guarantees that values in the 
-- foreign key columns of one table correspond to the values in the primary key columns of another table.


-- To create a link between the `students` and `courses` tables, we can introduce a foreign key column in the `students` table that points to the primary key column in the `courses` table. 
-- SQL command to construct the `students` table incorporating a foreign key column:

CREATE TABLE students (
  id int PRIMARY KEY,
  name varchar(50),
  age int,
  gender varchar(10),
  course_id int,
  FOREIGN KEY (course_id) REFERENCES courses(id)
);
--In this scenario, the `course_id` column in the `students` table acts as the foreign key that links to the `id` column of the `courses` table.


-------------------------
--Composite Key
-------------------------

-- A composite key consists of two or more columns used together to uniquely identify each row within a table. 
-- This type of key is utilized when no single column is sufficient to uniquely identify a row, yet the combination of several columns does. 
-- The composite key constraint guarantees that the set of values across these columns is unique for each row in the table.

CREATE TABLE employees (
  employee_id int,
  department_id int,
  name varchar(50),
  age int,
  gender varchar(10),
  PRIMARY KEY (employee_id, department_id)
);


-- In this scenario, the `employee_id` and `department_id` columns together constitute the composite key for the 'employees' table. The `PRIMARY KEY` keyword is employed to establish the composite key constraint, ensuring the uniqueness of each row based on the combination of these two columns.

-------------------------
--Unique Key
-------------------------

--A unique key consists of one or more columns where each column combination must have a unique value across all rows in a table. This key is utilized to impose a unique constraint on a table, ensuring that no two rows have the same value in the specified columns.


CREATE TABLE employees (
  employee_id  int PRIMARY KEY,
  email varchar(50) UNIQUE,
  phone varchar(20),
  ssn varchar(15)
);


-------------------------
--Candidate Key
-------------------------

--A candidate key comprises one or more columns capable of uniquely identifying each row within a table. A table may possess several candidate keys, each of which can potentially serve as the primary key for the table.


CREATE TABLE employees (
  employee_id INT,
  email VARCHAR(50),
  phone VARCHAR(20),
  ssn VARCHAR(15),
  PRIMARY KEY (employee_id),
  CONSTRAINT UQ_employees_email UNIQUE (email),
  CONSTRAINT UQ_employees_phone UNIQUE (phone),
  CONSTRAINT UQ_employees_ssn UNIQUE (ssn)
);

--In this example, the `email`, `phone`, and `ssn` columns are considered candidate keys for the 'employees' table. Each of these columns has a UNIQUE constraint applied to it, ensuring that the values contained within each column are unique across all rows in the table. This ensures that any of these columns can uniquely identify a record within the table, making them suitable as candidate keys.


--------------------------
-- Super Key
-------------------------
-- A super key is a set of one or more attributes (columns) that can uniquely identify a row in a table. A super key may consist of a single column or a combination of multiple columns. The key characteristic of a super key is that it must uniquely determine each row in a table, but it can contain additional attributes that are not necessary for uniqueness.

CREATE TABLE sales (
  sales_id INT,                  
  product_id INT,                
  customer_id INT,               
  sales_date DATE,               
  sales_amount DECIMAL(10,2),    
  PRIMARY KEY (sales_id),        
  UNIQUE (product_id, customer_id, sales_date)  -- A unique constraint that makes this combination a super key.
);

-- In this scenario, the grouping of the `product_id`, `customer_id`, and `sales_date` columns creates a super key for the `sales` table.


--------------------------
-- Alternate Key
-------------------------
--An alternate key is a set of one or more columns that can uniquely identify each row in a table, but is not chosen as the primary key. It can be used as a unique identifier for the table.


CREATE TABLE Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    Email VARCHAR(255) UNIQUE,
    SSN CHAR(9) UNIQUE,
    FirstName VARCHAR(100),
    LastName VARCHAR(100)
);


-- Email and SSN. Both are enforced with UNIQUE constraints to ensure their eligibility as alternate keys.
-- Ensuring that no two employees can register with the same email or SSN.
-- While SQL Server does not have specific syntax to designate a column as an "alternate key," using the UNIQUE constraint effectively creates alternate keys. This setup is essential for maintaining data integrity and providing flexible, efficient data access paths in a relational database