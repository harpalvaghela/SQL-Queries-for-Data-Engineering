-- SQL Server offers a wide range of date and time functions that enable you to manipulate and retrieve date and time values in various ways. T

SELECT GETDATE() as Current_Date_And_Time;  -- Returns current date and time

SELECT SYSDATETIME();  -- Returns current date and time with higher precision

-- This function is used to extract a specific part from a date or time value.

SELECT DATEPART(year, GETDATE()) AS Year;  -- Returns the current year
SELECT DATEPART(month, GETDATE()) AS Month;  -- Returns the current month
SELECT DATEPART(day, GETDATE()) AS Day;  -- Returns the current day


--Adds a specified number of units to a particular date part of a date.
SELECT DATEADD(year, 1, GETDATE()) AS NextYear;  -- Adds 1 year to the current date
SELECT DATEADD(month, -1, GETDATE()) AS LastMonth;  -- Subtracts 1 month from the current date


-- Calculates the difference between two dates.

SELECT DATEDIFF(year, '2021-01-01', '2022-01-01') AS DiffYears;  -- Returns 1
SELECT DATEDIFF(day, '2025-01-01', GETDATE()) AS DiffDays;  -- Returns the number of days from Jan 1, 2025 to today

--Used for formatting date and time values into a specific format.
SELECT CONVERT(VARCHAR, GETDATE(), 103) AS FormattedDate;  -- Converts date to DD/MM/YYYY format

--FORMAT(): More versatile and uses .NET Framework format strings.
SELECT FORMAT(GETDATE(), 'yyyy-MM-dd') AS FormattedDate;  -- Uses custom format strings

--Returns the last day of the month that contains the specified date, with an optional offset.
SELECT EOMONTH(GETDATE()) AS EndOfMonth;  -- Returns the last day of the current month
SELECT EOMONTH(GETDATE(), 1) AS EndOfNextMonth;  -- Returns the last day of the next month

--These functions extract the corresponding day, month, and year integers from a date.
SELECT DAY(GETDATE()) AS Day, MONTH(GETDATE()) AS Month, YEAR(GETDATE()) AS Year;

--Determines if a given expression is a valid date.
SELECT ISDATE('2022-01-01') AS IsValid;  -- Returns 1 for valid, 0 for invalid

-- DROP TABLE ORDERS;
CREATE TABLE orders (
    id int identity(1,1) PRIMARY KEY,
    order_date DATETIME,
    customer_name VARCHAR(255),
    total_amount NUMERIC(10,2)
);


INSERT INTO orders (order_date, customer_name, total_amount) VALUES
('2022-01-01 10:00:00', 'John Doe', 100.00),
('2022-01-02 12:30:00', 'Jane Smith', 200.50),
('2022-01-03 14:45:00', 'Bob Johnson', 50.25),
('2022-01-04 20:15:00', 'Sara Lee', 75.80);

Select * from orders;

SELECT
  id,
  order_date AS order_datetime,
  order_date AT TIME ZONE 'UTC' AT TIME ZONE 'Eastern Standard Time' AS order_datetime_ny
FROM orders;


--If you're using a version of SQL Server that does not support AT TIME ZONE, you will need to manually calculate time zone differences.
SELECT
  id,
  order_date AS order_datetime,
  DATEADD(HOUR, -5, order_date) AS order_datetime_ny -- Assuming EST is UTC-5
FROM orders;

--Other Examples
SELECT 
  id, 
  CAST(order_date AS DATE) AS order_date 
FROM orders;


SELECT 
	id, 
	cast(order_date as time) AS order_time 
FROM orders;

SELECT
  id,
  order_date,
  DATEPART(HOUR, order_date) AS order_hour,
  DATEPART(MINUTE, order_date) AS order_minute,
  DATEPART(DAY, order_date) AS order_day,
  DATEPART(MONTH, order_date) AS order_month,
  DATEPART(YEAR, order_date) AS order_year
FROM orders;

-- SQL query to convert a UTC time to Pacific Time (which accounts for both Pacific Standard Time and Pacific Daylight Time depending on the date):
SELECT
  id,
  order_date as order_date_UTC,
  CAST(order_date AS DATETIMEOFFSET) AT TIME ZONE 'UTC' AT TIME ZONE 'Pacific Standard Time' AS order_date_pst
FROM orders;






--------------------------------------------------------
--Things to Remember 
--------------------------------------------------------
--1. GETDATE() Returns the Current Date and Time
--Use GETDATE() to get the system’s current date and time.

SELECT GETDATE() AS CurrentDateTime;

--Use SYSDATETIME() for Higher Precision (More Milliseconds):

SELECT SYSDATETIME() AS HighPrecisionDateTime;

-- 2. Use DATEPART() to Extract Specific Date Components
--DATEPART() extracts parts of a date (year, month, day, hour, etc.).

SELECT 
    GETDATE() AS CurrentDate,
    DATEPART(YEAR, GETDATE()) AS Year,
    DATEPART(MONTH, GETDATE()) AS Month,
    DATEPART(DAY, GETDATE()) AS Day;

--3. Use DATEDIFF() to Calculate the Difference Between Dates
--DATEDIFF() calculates the difference between two dates in years, months, days, etc.

SELECT DATEDIFF(DAY, '2025-01-01', GETDATE()) AS DaysDifference;

SELECT DATEDIFF(YEAR, '1998-11-11', GETDATE()) AS Age;

--4. Use DATEADD() to Add or Subtract Time Intervals
--DATEADD() helps to add or subtract days, months, years, etc. from a date.

--Get Date 7 Days from Today
SELECT DATEADD(DAY, 7, GETDATE()) AS NextWeek;

--Get Date 1 Month Ago
SELECT DATEADD(MONTH, -1, GETDATE()) AS LastMonth;


--5. Be Careful with DATETIME Precision, Use DATETIME2 for Accuracy
--DATETIME has a precision of 3.33 milliseconds, while DATETIME2 has better accuracy.
--For high-precision timestamps, prefer DATETIME2.

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    OrderDate DATETIME2 DEFAULT SYSDATETIME()
);

select * from Orders;