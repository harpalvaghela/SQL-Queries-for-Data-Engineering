--Casting and converting data types in SQL Server is essential for ensuring compatibility between different data types and avoiding errors when performing operations. SQL Server provides several functions like CAST(), CONVERT(), TRY_CAST(), TRY_CONVERT(), and PARSE() for data conversion.

--DROP TABLE STUDENTS 
CREATE TABLE students (
  id int identity(1,1) PRIMARY KEY,
  name VARCHAR(50),
  age INTEGER,
  marks FLOAT(2)
);

INSERT INTO students (name, age, marks) VALUES
  ('John', 20, 78.5),
  ('Jane', 22, 89.2),
  ('Peter', 21, 92.3),
  ('Mary', 23, 86.7),
  ('David', 19, 73.9);


select * from students;

-- Casting as INT
SELECT name, CAST(age AS INT) AS age
FROM students;

-- Casting as NUMERIC
SELECT name, CAST(marks AS NUMERIC) AS marks
FROM students;

-- Casting as VARCHAR(10) string
SELECT name, CAST(age AS VARCHAR(10)) AS age_text
FROM students;

SELECT name, CONVERT(VARCHAR(10), age) AS age_text
FROM students;

-- DATE

SELECT CAST('2022-01-01' AS DATE) AS DateValue;
SELECT CONVERT(DATE, '2022-01-01 12:30:00') AS DateValue;

-- DATETIME
SELECT CAST('2022-01-01 12:30:00' AS DATETIME) AS DateTimeValue;
SELECT CONVERT(DATETIME, '2022-01-01 12:30:00') AS DateTimeValue;

-- Casting to DECIMAL
SELECT CAST(123.4567 AS DECIMAL(5,2));

-- Other examples
SELECT CAST('123' AS INT);

SELECT CONVERT(DATETIME, '2023-01-01', 101);  -- MM/DD/YYYY format
SELECT CONVERT(VARCHAR, GETDATE(), 106);  -- 'dd mon yyyy' format


--------------------------------------------------
-- TRY_CAST and TRY_CONVERT Concept
--------------------------------------------------
--These functions are variations of CAST() and CONVERT() that return NULL instead of an error if the conversion fails, which is useful for handling data that may not always be formatted consistently.

SELECT TRY_CAST('abc' AS INT);  -- Returns NULL

SELECT TRY_CONVERT(DATETIME, 'invalid date');  -- Returns NULL

-----------------------------
-- PARSE Function
------------------------------
--Convert a string to a date with culture-specific handling

-- Syntax: PARSE(string_value AS data_type USING culture)

SELECT PARSE('January 1, 2023' AS DATE USING 'en-US');






----------------------------------------------------------------------
--Things to Remember in Casting into Different Formats in SQL Server
-----------------------------------------------------------------------

--1. Use CAST() for Standard Type Conversion, CONVERT() for Format-Specific Conversion

--CAST() is ANSI-compliant and works across different database systems.
--CONVERT() is SQL Server-specific and allows formatting options for date/time conversions.

--Casting Marks as Numeric
SELECT name, CAST(marks AS NUMERIC(5,2)) AS marks_numeric FROM students;

--Using CONVERT() to Format Dates
SELECT CONVERT(VARCHAR, GETDATE(), 106) AS formatted_date; -- 'dd mon yyyy' format



--2. TRY_CAST() and TRY_CONVERT() Prevent Errors by Returning NULL on Failure

--CAST() and CONVERT() throw an error if the conversion fails.
--TRY_CAST() and TRY_CONVERT() return NULL instead of an error, preventing query failures.

--Avoiding Errors in Invalid Conversions
SELECT TRY_CAST('abc' AS INT) AS result;  -- Returns NULL instead of error
SELECT TRY_CONVERT(DATETIME, 'invalid date') AS date_result;  -- Returns NULL



--3. Be Careful When Casting Between Numeric and String Data Types

--Converting from a larger data type to a smaller one can cause truncation.
--Ensure that text-based numbers can be converted safely into numeric types.

--Preserving Decimal Precision
SELECT CAST(123.456 AS DECIMAL(5,2));  -- Returns 123.46 (Rounded)

--Safe String to Integer Conversion
SELECT CAST('123' AS INT);  -- Works fine
SELECT TRY_CAST('abc' AS INT);  -- Returns NULL (Safe)



--4. Use PARSE() for Culture-Specific Date and Number Formatting

--PARSE() is useful when working with international formats, but it is slower than CAST() and CONVERT().

--Parsing Date in UK Format dd/MM/yyyy
SELECT PARSE('31/12/2022' AS DATE USING 'en-GB') AS UKDate;

--Parsing Currency as Numeric
SELECT PARSE('$1,234.56' AS NUMERIC(10,2) USING 'en-US') AS ParsedAmount;

--Note: PARSE() only works with VARCHAR/NVARCHAR inputs.



--5. CONVERT() with Style Codes is Useful for Date Formatting

--CONVERT() is the best way to display date formats in SQL Server
--Using CONVERT() with Style Codes for Different Formats
SELECT CONVERT(VARCHAR, GETDATE(), 101) AS US_Format;   -- MM/DD/YYYY
SELECT CONVERT(VARCHAR, GETDATE(), 103) AS UK_Format;   -- DD/MM/YYYY
SELECT CONVERT(VARCHAR, GETDATE(), 106) AS Long_Format; -- DD Mon YYYY
