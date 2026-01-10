DROP DATABASE IF EXISTS zepto_sql_project;
CREATE DATABASE IF NOT EXISTS zepto_sql_project;

USE zepto_sql_project;

DROP TABLE IF EXISTS zepto;
CREATE TABLE zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outofstock BOOLEAN,
quantity INTEGER
);

####### DATA EXPLORATION #######
-- Count of rows
SELECT COUNT(*) FROM zepto;

-- Sampel data
SELECT * FROM zepto
LIMIT 10;

-- Null values
 SELECT * FROM zepto
 WHERE category IS NULL 
 or
 name IS NULL
 or
 mrp IS NULL
 OR
 discountPercent IS NULL
 or
 availableQuantity IS NULL
 or
 discountedSellingPrice IS NULL
 or
 weightInGms IS NULL
 or
 outofStock IS NULL
 or
 quantity IS NULl;
 
 -- Different Product Categories
 SELECT DISTINCT category
 FROM zepto
 ORDER BY category;
 
 -- Products in stock vs out of stock
 SELECT outOfStock, COUNT(sku_id) 
 FROM zepto
 GROUP BY outOfStock;
 
 -- Product name present multiple times
 SELECT name, COUNT(sku_id) AS "Number of SKUs"
 FROM zepto
 GROUP BY name
 HAVING COUNT(sku_id) > 1
 ORDER BY COUNT(sku_id) DESC;
 
-- Data cleaning

-- Product with price = 0
SELECT * FROM zepto
WHERE mrp = 0 OR discountedSellingPrice = 0;

DELETE FROM zepto
WHERE mrp = 0;

-- Convert paise to rupees
UPDATE zepto
SET mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;

SELECT mrp, discountedSellingPrice FROM zepto;

# 1) Find out the top 10 best value product based on the discount percentage?
SELECT name, mrp, discountpercent FROM zepto 
ORDER BY discountpercent DESC
LIMIT 10;

# 2) What are the products with high mrp but out of stock?
SELECT DISTINCT name, mrp 
FROM zepto
WHERE outofstock = 1 AND mrp > 300
ORDER BY mrp DESC;

# 3) Calculate estimated revenue for each category?
SELECT category,
SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue;

# 4) Find all product where mrp is greater than 500 and discount is less then 10%?
SELECT  DISTINCT name, mrp, discountPercent 
FROM zepto
WHERE mrp > 500 AND discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC;

# 5) Identify the top 5 categories offering the highest average discount percentage?
SELECT category, 
ROUND(AVG(discountPercent),2) AS avg_discount 
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

# 6) Find the price per gram for products above 100gms and sort by best value?
SELECT DISTINCT name, discountedSellingPrice, weightInGms, 
ROUND(discountedSellingPrice/weightInGms) AS price_per_gms
FROM zepto
WHERE weightInGms >= 100
ORDER BY price_per_gms;

# 7) Group the products into categories like low, medium, bulk?
SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'LOW'
	 WHEN weightInGms < 5000 THEN 'MEDIUM'
     ELSE 'BULK'
     END AS weight_category
FROM zepto;

# 8) What is the total inventory weight per category?
SELECT category,
SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;

 

