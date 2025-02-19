-- Database constraints are rules enforced on data in the database to maintain accuracy and integrity.

--PRIMARY KEY Constraint
-- Ensures that a column or a group of columns contains a unique identifier for each row in the table.

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(100),
    Department VARCHAR(50)
);

SELECT * from Employees

-- FOREIGN KEY Constraint
-- The value in a column or a set of columns matches a value in a primary key or a unique key 
-- in another table, establishing a link between the data in the two tables.

-- DROP TABLE EMPLOYEES
-- DROP TABLE DEPARTMENTS

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100)
);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(100),
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);


-- UNIQUE Constraint
--  Ensures that all values in a column or a set of columns are unique across the dataset.
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Email VARCHAR(100) UNIQUE,
    Name VARCHAR(100)
);

-- CHECK Constraint
-- All values in a column satisfy a specific condition.

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    Price DECIMAL NOT NULL,
    CHECK (Price > 0)
);


-- DEFAULT Constraint
-- A default value for a column when none is specified.

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(100),
    Department VARCHAR(50),
    Status VARCHAR(20) DEFAULT 'Active'
);


-- NOT NULL Constraint
-- A column cannot have a NULL value.

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Department VARCHAR(50) NOT NULL
);

-- INDEX (not a constraint, but related to constraints)
-- While not a constraint, indexes are often mentioned in discussions about constraints because they can enforce 
-- uniqueness like the UNIQUE constraint and improve the performance of queries involving foreign keys.

CREATE UNIQUE INDEX UX_Email ON Employees (Email);


-- Multiple Constraints in a Single Table
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    DepartmentID INT,
    Status VARCHAR(20) DEFAULT 'Active',
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID),
    CHECK (Name <> '')
);


-- Inserting data into the Departments table
INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
(1, 'Human Resources'),
(2, 'Information Technology');

-- Inserting data into the Employees table
INSERT INTO Employees (EmployeeID, Name, DepartmentID) VALUES
(1, 'John Doe', 1),
(2, 'Jane Smith', 2);

-- Attempting to insert an employee into a non-existent department
-- This will fail because there is no DepartmentID 3 in the Departments table.

INSERT INTO Employees (EmployeeID, Name, DepartmentID) VALUES
(3, 'Alice Johnson', 3);  


SELECT * from Employees
SELECT * from Departments

-- Another Example

DROP TABLE PRODUCTS;

CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName VARCHAR(100) UNIQUE,
    Price DECIMAL(10, 2) CHECK (Price > 0),
    Stock INT DEFAULT 100, -- Sets default stock level to 100 if no value is specified
    Description VARCHAR(255)  -- Optional description of the product
);


-- Inserting data into the Products table, specifying some fields and omitting others to trigger the DEFAULT constraint
INSERT INTO Products (ProductName, Price, Description) VALUES
('Laptop', 1200.00, 'High-performance laptop'),
('Smartphone', 700.00, 'Latest model smartphone');

-- Inserting a product without specifying the stock to demonstrate the DEFAULT constraint
INSERT INTO Products (ProductName, Price) VALUES
('Tablet', 450.00);

Select * from Products;


-------------------------------------------------------------------------
--Things to Remember in Constraints in SQL
-------------------------------------------------------------------------
--1. Use PRIMARY KEY to Uniquely Identify Each Row
--A PRIMARY KEY constraint ensures each row is unique and not NULL.

--2. FOREIGN KEY Enforces Referential Integrity
--A FOREIGN KEY ensures only valid references exist between related tables.
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(100),
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

--Tip: Use ON DELETE CASCADE to automatically remove dependent records:
FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID) ON DELETE CASCADE;

-- 3. UNIQUE Constraint Ensures No Duplicate Values
--Use UNIQUE to enforce distinct values in a column.


--4. CHECK Constraint Validates Data Before Insertion
--The CHECK constraint ensures values meet specific conditions.


--5. Use NOT NULL to Prevent Missing Data
--The NOT NULL constraint ensures important fields are never left empty.

--6. DEFAULT Assigns a Value When None is Provided
--The DEFAULT constraint provides a fallback value when no value is inserted.
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Status VARCHAR(20) DEFAULT 'Active' -- If no value is inserted, 'Active' is used
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100) UNIQUE,
    Stock INT DEFAULT 100 -- If stock is not specified, it's set to 100
);

--7. ALTER TABLE to Add or Remove Constraints Carefully
--Constraints can be added or removed later, but doing so incorrectly can cause data loss or errors.
ALTER TABLE Employees ADD CONSTRAINT chk_age CHECK (age > 18);
ALTER TABLE Employees DROP CONSTRAINT chk_age;
