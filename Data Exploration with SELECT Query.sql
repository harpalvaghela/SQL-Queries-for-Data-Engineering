CREATE TABLE sales (
  id INT,
  sale_date DATE,
  product VARCHAR(50),
  quantity INT,
  revenue DECIMAL(10,2)
);


INSERT INTO sales (id, sale_date, product, quantity, revenue)
VALUES
  (1, '2022-02-01', 'Widget X', 12, 120.00),
  (2, '2022-02-02', 'Widget Y', 7, 70.00),
  (3, '2022-02-03', 'Widget Z', 20, 200.00),
  (4, '2022-02-04', 'Widget X', 9, 90.00),
  (5, '2022-02-05', 'Widget Y', 15, 150.00),
  (6, '2022-02-06', 'Widget Z', 25, 250.00),
  (7, '2022-02-07', 'Widget X', 5, 50.00),
  (8, '2022-02-08', 'Widget Y', 10, 100.00),
  (9, '2022-02-09', 'Widget Z', 14, 140.00),
  (10, '2022-02-10', 'Widget X', 8, 80.00);

--> Explore the Sales Data

-- Retrieve all the data from the sales table:
SELECT * FROM sales;

-- Retrieve data only for a specific product, such as "Widget Y":
SELECT * FROM sales WHERE product = 'Widget Y';

-- Retrieve the total revenue for each day:
SELECT sale_date, SUM(revenue) FROM sales GROUP BY sale_date;

-- Retrieve the total revenue for each product:
SELECT product, SUM(revenue) FROM sales GROUP BY product;

-- Retrieve the top-selling products in descending order by quantity sold:
SELECT product, SUM(quantity) FROM sales GROUP BY product ORDER BY SUM(quantity) DESC;

-- These queries offer various perspectives on the sales data, like identifying top-selling products, pinpointing days with peak revenue, and determining which products yield the highest profits. Armed with this information, you can suggest strategies to enhance the company's sales outcomes, such as amplifying marketing initiatives for well-received products or revising pricing strategies for underperforming items.

-----------------------
-- Operators
-----------------------
SELECT * FROM sales WHERE product = 'Widget Z' AND quantity > 5 

SELECT * FROM sales WHERE product = 'Widget Y' OR product = 'Widget X'

SELECT * FROM sales WHERE NOT product = 'Widget Y'

SELECT * FROM sales WHERE product LIKE '%Y%'

SELECT * FROM sales WHERE product IN ('Widget Y', 'Widget Z')

SELECT * FROM sales WHERE revenue BETWEEN 50 AND 100


-- Other Queries

-- Which products were sold on Feb 4th?
SELECT product FROM sales WHERE sale_date = '2022-02-04';

-- What was the total revenue for Widget Y?
SELECT SUM(revenue) FROM sales WHERE product = 'Widget Y';

-- Which days had revenue greater than $150?
SELECT sale_date FROM sales WHERE revenue > 150;

-- Which products had a total quantity sold greater than 50?
SELECT product FROM sales GROUP BY product HAVING SUM(quantity) > 50;

-- What was the average revenue per sale for Widget X?
SELECT AVG(revenue) FROM sales WHERE product = 'Widget X';

-- Which products had a revenue per sale greater than $100?
SELECT product FROM sales GROUP BY product HAVING AVG(revenue) > 100;