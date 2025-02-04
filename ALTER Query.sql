-- In SQL Server, the ALTER TABLE statement is used to modify the structure of an existing table. 
-- You can use it to add new columns, change existing columns, add or modify constraints, or drop columns and constraints


-- Create a table

CREATE TABLE users (
    id int IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(50),
    email VARCHAR(50),
    age INTEGER
);

-- Insert data into the table

INSERT INTO users (name, email, age) VALUES
    ('Amit Sharma', 'amit.sharma@yahoo.com', 28),
    ('Priya Singh', 'priya.singh@gmail.com', 32),
    ('Rohan Patel', 'rohan.patel@yahoo.com', 35);

-- Altering a table and adding new column here

ALTER TABLE users ADD city varchar(25);
ALTER TABLE users ADD phone VARCHAR(20);

-- Modifying an existing column's data type
ALTER TABLE users ALTER COLUMN age SMALLINT;

-- Modifying an Existing Column
ALTER TABLE users ALTER COLUMN name VARCHAR(100);

SELECT * from users;

-- Deleting a column from a table

ALTER TABLE users DROP COLUMN phone;
SELECT * from users;


-- SQL Server does not directly allow renaming a column with an ALTER TABLE ... ALTER COLUMN syntax. Instead, you use the sp_rename stored procedure.
-- Renaming the column
EXEC sp_rename 'users.email', 'user_email', 'COLUMN';
-- Changing the data type
ALTER TABLE users ALTER COLUMN user_email NVARCHAR(255);

SELECT * from users;


--Adding a Default Value
-- You can set a default value for a new or existing column. For instance, if you want to ensure that every new user has a default age set when none is provided:
ALTER TABLE users ADD CONSTRAINT DF_Users_Age DEFAULT 25 FOR age;

INSERT INTO users (name, user_email, age) VALUES
    ('Amit Patel', 'amit.patel@yahoo.com', 26)

INSERT INTO users (name, user_email, age) VALUES
    ('Amit Patel', 'amit.patel@yahoo.com', DEFAULT)

-- Adding Constraints
-- To enforce rules on the data, you can add constraints. For example, adding a unique constraint to the email column to ensure all emails are unique:
ALTER TABLE users ADD CONSTRAINT UQ_Users_Email UNIQUE (user_email);

SELECT * from users;

-- Dropping Constraints
ALTER TABLE users DROP CONSTRAINT UQ_Users_Email;