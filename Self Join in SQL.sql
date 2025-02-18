--A self join in SQL is a join where a table is joined with itself to compare rows within the same table. It is commonly used for hierarchical relationships, such as an employee-manager structure, where each row references another row in the same table.

--Drop table employee


CREATE TABLE Employee (
    emp_id INT IDENTITY(1,1) PRIMARY KEY,  -- Auto-increment primary key
    emp_name VARCHAR(50) NOT NULL,         -- Employee name (ensures no NULL values)
    emp_manager_id INT NULL,               -- Manager ID (nullable, since some employees may not have a manager)
);


INSERT INTO Employee (emp_name, emp_manager_id) VALUES
('John', NULL),
('Jane', 1),
('Bob', 2),
('Alice', 2),
('Mike', 3);

Select * from employee


------------Employee Self Join-----------

--Suppose we want to find the names of all employees and their managers. We can use self join to achieve this. The query will be:

SELECT 
    e1.emp_name AS Employee, 
    COALESCE(e2.emp_name, 'No Manager') AS Manager
FROM Employee AS e1
LEFT JOIN Employee AS e2 ON e1.emp_manager_id = e2.emp_id;


CREATE TABLE Ecommerce (
    order_id int identity(1,1) PRIMARY KEY,
    user_id INTEGER,
    product VARCHAR(50)
);

INSERT INTO Ecommerce (user_id, product) VALUES
(1, 'Shoes'),
(2, 'T-Shirt'),
(3, 'Jeans'),
(1, 'Socks'),
(2, 'Pants'),
(1, 'Hat');

Select * from Ecommerce

----------------Ecommerce Self Join--------------

--Suppose we want to find the products bought by each user. We can use self join to achieve this. The query will be:


SELECT 
    e1.user_id, 
    e1.product AS First_Product, 
    COALESCE(e2.product, 'No Other Purchase') AS Second_Product
FROM Ecommerce AS e1
LEFT JOIN Ecommerce AS e2 
    ON e1.user_id = e2.user_id 
    AND e1.order_id <> e2.order_id;


CREATE TABLE Student (
    student_id int identity(1,1) PRIMARY KEY,
    student_name VARCHAR(50),
    student_class VARCHAR(10),
    student_teacher VARCHAR(50)
);

INSERT INTO Student (student_name, student_class, student_teacher) VALUES
('John', '10A', 'Mr. Smith'),
('Jane', '10B', 'Mrs. Jones'),
('Bob', '10A', 'Mr. Smith'),
('Alice', '10B', 'Mrs. Jones'),
('Mike', '10C', 'Mr. Brown');

Select * from Student

-----------------Student Self Join---------------
--Suppose we want to find the students who have the same teacher. We can use self join to achieve this. The query will be:

SELECT 
    s1.student_name AS Student, 
    COALESCE(s2.student_name, 'No Classmate') AS Classmate,
	s2.student_teacher
FROM Student AS s1
LEFT JOIN Student AS s2 
    ON s1.student_teacher = s2.student_teacher 
    AND s1.student_id <> s2.student_id;
