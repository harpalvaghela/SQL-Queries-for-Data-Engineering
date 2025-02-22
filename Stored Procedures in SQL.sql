--A Stored Procedure in SQL Server is a precompiled collection of one or more SQL statements which is stored on the database server. 
--Stored procedures can be used to encapsulate repetitive or complex database operations, allowing them to be executed by applications or users more efficiently. 

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(100),
    Position VARCHAR(100),
    Department VARCHAR(100)
);


INSERT INTO Employees (EmployeeID, Name, Position, Department) VALUES
(1, 'John Doe', 'Software Engineer', 'Engineering'),
(2, 'Jane Smith', 'Project Manager', 'Product'),
(3, 'Alice Johnson', 'Data Analyst', 'Marketing'),
(4, 'Mike Brown', 'UX Designer', 'Design');

Select * from Employees


---------------- Creating the Stored Procedure---------------
CREATE PROCEDURE GetEmployeeInfo
    @EmployeeID INT
AS
BEGIN
    SELECT Name, Position, Department
    FROM Employees
    WHERE EmployeeID = @EmployeeID;
END;
GO

-- Executing the Stored Procedure
EXEC GetEmployeeInfo @EmployeeID = 3;

--Example:

--Drop table sales;

CREATE TABLE sales (
  id INT IDENTITY(1,1) PRIMARY KEY,
  product_name VARCHAR(255),         
  category VARCHAR(100),             
  price NUMERIC(10, 2),              
  quantity INTEGER,                  
  sale_date DATE                     
);

INSERT INTO sales (product_name, category, price, quantity, sale_date)
VALUES
  ('iPad', 'Electronics', 799, 3, '2022-01-01'),
  ('MacBook', 'Electronics', 1299, 2, '2022-01-02'),
  ('iPhone', 'Electronics', 699, 5, '2022-01-03'),
  ('Samsung TV', 'Electronics', 999, 1, '2022-01-04'),
  ('Nike Shoes', 'Apparel', 99, 10, '2022-01-05');

Select * from sales;


--SQL Server uses T-SQL to define functions
-- Task: calculating total sales for a specific product and month

CREATE FUNCTION get_total_sales (@product_name VARCHAR(255), @month VARCHAR(20))
RETURNS NUMERIC
AS
BEGIN
    DECLARE @first_day_of_month DATE
    SET @first_day_of_month = CAST('01 ' + @month AS DATE) -- Converts 'Month Year' to date
    
    RETURN (
        SELECT SUM(price * quantity) AS TotalSales
        FROM sales
        WHERE product_name = @product_name 
        AND sale_date >= @first_day_of_month -- on or after the first day of the given month 
        AND sale_date < DATEADD(MONTH, 1, @first_day_of_month) --only sales before the first day of the next month are included
    )
END
GO

----
SELECT dbo.get_total_sales('iPad', 'January 2022') AS TotalSales;

--------------------------Other Examples--------------------

CREATE PROCEDURE GetSalesByProduct
    @ProductName VARCHAR(255)
AS
BEGIN
    SELECT id, product_name, category, price, quantity, sale_date
    FROM sales
    WHERE product_name = @ProductName;
END;
GO

--------
EXEC GetSalesByProduct @ProductName = 'iPad';

--------------------- Insert new Rows------------------

CREATE PROCEDURE InsertSale
    @ProductName VARCHAR(255),
    @Category VARCHAR(100),
    @Price NUMERIC(10,2),
    @Quantity INT,
    @SaleDate DATE
AS
BEGIN
    INSERT INTO sales (product_name, category, price, quantity, sale_date)
    VALUES (@ProductName, @Category, @Price, @Quantity, @SaleDate);
END;
GO

-----------

EXEC InsertSale 
    @ProductName = 'MacBook Air',
    @Category = 'Electronics',
    @Price = 999.99,
    @Quantity = 3,
    @SaleDate = '2024-02-01';

-----------
Select * from sales;


------------------- Update Sale Record---------------------

CREATE PROCEDURE UpdateSale
    @SaleID INT,
    @NewPrice NUMERIC(10,2),
    @NewQuantity INT
AS
BEGIN
    UPDATE sales
    SET price = @NewPrice, quantity = @NewQuantity
    WHERE id = @SaleID;
END;
GO

--------

EXEC UpdateSale 
    @SaleID = 2, 
    @NewPrice = 1200, 
    @NewQuantity = 5;

Select * from sales;

------------------- Delete a Sale Record-----------------

CREATE PROCEDURE DeleteSale
    @SaleID INT
AS
BEGIN
    DELETE FROM sales WHERE id = @SaleID;
END;
GO

---------
EXEC DeleteSale @SaleID = 5;

Select * from sales;

----------------------Get Sales Within a Date Range-----------------

CREATE PROCEDURE GetSalesByDateRange
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SELECT id, product_name, category, price, quantity, sale_date
    FROM sales
    WHERE sale_date BETWEEN @StartDate AND @EndDate;
END;
GO

------------
EXEC GetSalesByDateRange 
    @StartDate = '2022-01-01', 
    @EndDate = '2022-01-31';




-------------------------------------------------------------
--Things to Remember in Stored Procedures 
-------------------------------------------------------------

--1. Always Use SET NOCOUNT ON to Improve Performance
--By default, SQL Server returns the number of rows affected after each statement.
--Using SET NOCOUNT ON prevents unnecessary messages, improving performance.

CREATE PROCEDURE GetStudents
AS
BEGIN
    SET NOCOUNT ON; -- Prevents unnecessary messages

    SELECT * FROM students;
END;

--Avoids "XX rows affected" messages after execution.


--2. Always Use Parameters to Make Stored Procedures Flexible
--Parameters allow stored procedures to handle dynamic input values

CREATE PROCEDURE GetStudentsByAge @MinAge INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM students WHERE age >= @MinAge;
END;

--Executing the Procedure with Input Parameter

EXEC GetStudentsByAge 20;


-- 3. Use OUTPUT Parameters to Return Values
--Stored procedures can return computed values using OUTPUT parameters.

CREATE PROCEDURE GetStudentCount @TotalStudents INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT @TotalStudents = COUNT(*) FROM students;
END;

--Executing the Procedure with an OUTPUT Parameter:

DECLARE @Count INT;
EXEC GetStudentCount @Count OUTPUT;
PRINT 'Total Students: ' + CAST(@Count AS VARCHAR);

--Stores the result in @Count and prints it.

--4. Always Handle Errors Using TRY...CATCH Blocks
--Prevent runtime failures by handling exceptions properly.

CREATE PROCEDURE InsertStudent
@name VARCHAR(50),
@age INT,
@marks FLOAT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO students (name, age, marks) VALUES (@name, @age, @marks);
    END TRY
    BEGIN CATCH
        PRINT 'Error Occurred: ' + ERROR_MESSAGE();
    END CATCH
END;

--If an error occurs (e.g., inserting NULL in a NOT NULL column), it is caught and printed instead of failing.

-- 5. Avoid Using SELECT *, Always Specify Columns for Better Performance
--Using SELECT * increases memory usage and decreases performance.

CREATE PROCEDURE GetAllStudents
AS
BEGIN
    SELECT * FROM students; -- NOT Recommended
END;

----
CREATE PROCEDURE GetStudentNames
AS
BEGIN
    SELECT id, name FROM students; -- Recommended
END;


-- 6. Use WITH RECOMPILE for Queries That Change Frequently
--Stored procedures are compiled and optimized once.
--If data changes frequently, use WITH RECOMPILE to re-optimize queries on each execution.

CREATE PROCEDURE GetTopStudents
WITH RECOMPILE
AS
BEGIN
    SELECT TOP 5 * FROM students ORDER BY marks DESC;
END;

--Ensures that SQL Server optimizes execution every time.