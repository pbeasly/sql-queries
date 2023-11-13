-- File generates some scripts to perform queries
-- First a simple query to view the brands.
SELECT *
FROM brands;

-- Answer following questions:
-- Which staff members made the greatest number of sales?
SELECT 
    staffs.first_name, 
    staffs.last_name, 
    COUNT(order_id) AS num_sales
FROM staffs
JOIN orders ON staffs.staff_id = orders.staff_id
GROUP BY staffs.first_name, staffs.last_name
ORDER BY num_sales DESC;

-- What was the total sales revenue for each staff member?
-- practice multiple joins
SELECT 
    s.first_name, 
    SUM(oi.list_price) AS revenue
FROM staffs AS s
JOIN orders AS o
USING(staff_id)
JOIN order_items AS oi
USING(order_id)
GROUP BY s.first_name
ORDER BY revenue DESC;


-- Which brand sold the most models and made the most revenue?
SELECT
    b.brand_name,
    COUNT(o.order_id) AS num_sold,
    -- need to calculate the final sales price with discount
    SUM(oi.list_price*(1-oi.discount)) AS revenue_with_discount
FROM brands AS b
JOIN products as p
USING(brand_id)
JOIN order_items AS oi
USING(product_id)
JOIN orders AS o
USING(order_id)
GROUP BY b.brand_name;


-- How many orders where shipped each month in each year?
SELECT 
    EXTRACT(YEAR FROM shipped_date) AS year,
    EXTRACT(MONTH FROM shipped_date) AS month,
    COUNT(order_id) AS orders_shipped
FROM orders
WHERE EXTRACT(YEAR FROM shipped_date) IN (2016, 2017, 2018)
GROUP BY year, month
ORDER BY year, month;

-- What was the revenue each year?
SELECT 
    EXTRACT(YEAR FROM o.shipped_date) AS year,
    EXTRACT(MONTH FROM o.shipped_date) AS month,
    SUM(o_i.list_price*(1-o_i.discount)) AS revenue
FROM orders AS o
JOIN order_items AS o_i
USING(order_id)
WHERE o.shipped_date IS NOT NULL
GROUP BY year, month
ORDER BY year, month;

-- Pracice using CASE operation:
-- Which brand had highest sales in the month with most revenue?
SELECT 
    EXTRACT(YEAR FROM o.shipped_date) AS year,
    EXTRACT(MONTH FROM o.shipped_date) AS month,
    SUM(o_i.list_price*(1-o_i.discount)) AS revenue
FROM orders AS o
JOIN order_items AS o_i
USING(order_id)
WHERE o.shipped_date IS NOT NULL AND EXTRACT(YEAR FROM o.shipped_date) = 2017
GROUP BY year, month
ORDER BY year, month;

-- create script that determines brand with highest revenue
-- include some case statements
SELECT 
    EXTRACT(YEAR FROM o.shipped_date) AS year,
    b.brand_name,
    SUM(o_i.list_price*(1-o_i.discount)) AS revenue
FROM brands as b
JOIN products as p 
USING(brand_id)
JOIN order_items as o_i
USING (product_id)
JOIN orders AS o 
USING(order_id)
WHERE EXTRACT(YEAR FROM o.shipped_date) IN(2016, 2017)
GROUP BY EXTRACT(YEAR FROM o.shipped_date), b.brand_name
ORDER BY year ASC, revenue DESC;