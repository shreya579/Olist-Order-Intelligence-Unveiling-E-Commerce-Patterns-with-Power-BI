CREATE DATABASE ECOMMERCE_DOMAIN;

USE ECOMMERCE_DOMAIN;

SELECT * FROM CUSTOMERS_REVIEW_TABLE;

SELECT * FROM CUSTOMERS_TABLE;

SELECT * FROM ORDER_ITEMS_TABLE;

SELECT * FROM ORDERS_TABLE;

SELECT * FROM PAYMENTS_TABLE;

SELECT * FROM PRODUCTS_TABLE;

SELECT * FROM SELLERS_TABLE;

-- CHECK DUPLICATES

SELECT COUNT(*) FROM CUSTOMERS_REVIEW_TABLE;
SELECT DISTINCT COUNT(*) FROM CUSTOMERS_REVIEW_TABLE;

SELECT COUNT(*) FROM CUSTOMERS_TABLE;
SELECT DISTINCT COUNT(*) FROM CUSTOMERS_TABLE;

SELECT COUNT(*) FROM ORDER_ITEMS_TABLE;
SELECT DISTINCT COUNT(*) FROM ORDER_ITEMS_TABLE;

SELECT COUNT(*) FROM ORDERS_TABLE;
SELECT DISTINCT COUNT(*) FROM ORDERS_TABLE;

SELECT COUNT(*) FROM PAYMENTS_TABLE;
SELECT DISTINCT COUNT(*) FROM PAYMENTS_TABLE;

SELECT COUNT(*) FROM PRODUCTS_TABLE;
SELECT DISTINCT COUNT(*) FROM PRODUCTS_TABLE;

SELECT COUNT(*) FROM SELLERS_TABLE;
SELECT DISTINCT COUNT(*) FROM SELLERS_TABLE;

-- 1. How much total money has the platform made so far, and how has it changed over time?

SELECT 
    ROUND(SUM(PAYMENT_VALUE),2) AS TOTAL_REVENUE
FROM 
    PAYMENTS_TABLE;

-- Index on ORDER_ID in PAYMENTS_TABLE
CREATE NONCLUSTERED INDEX IX_PAYMENTS_ORDER_ID 
ON PAYMENTS_TABLE (ORDER_ID);

-- Index on ORDER_ID and ORDER_PURCHASE_TIMESTAMP in ORDERS_TABLE
CREATE NONCLUSTERED INDEX IX_ORDERS_ORDER_ID_TIMESTAMP 
ON ORDERS_TABLE (ORDER_ID, ORDER_PURCHASE_TIMESTAMP);


SELECT 
    FORMAT(O.ORDER_PURCHASE_TIMESTAMP, 'yyyy-MM') AS PURCHASE_MONTH,
    SUM(P.PAYMENT_VALUE) AS MONTHLY_REVENUE
FROM 
    PAYMENTS_TABLE P
JOIN 
    ORDERS_TABLE O ON P.ORDER_ID = O.ORDER_ID
GROUP BY 
    FORMAT(O.ORDER_PURCHASE_TIMESTAMP, 'yyyy-MM')
ORDER BY 
    PURCHASE_MONTH;

-- INSIGHTS:
-- Monthly Revenue Insights (Sep 2016 – Oct 2018)
-- Total Revenue: ₹16M+
-- Launch Phase: Sep–Dec 2016 (very low revenue)
-- Growth Phase: Jan 2017 – Aug 2018 (stable growth, \~₹1M/month)
-- Peak Revenue: Apr 2018 (₹1.16M)
-- Sharp Drop: Sep–Oct 2018 (~99% fall) – likely data cutoff or shutdown
-- Seasonal Spike: Nov 2017 & early 2018 show high sales (likely festive impact)

-- 2. Which product categories are the most popular, and how do their sales numbers compare?


SELECT TOP 10
    P.PRODUCT_CATEGORY_NAME,
    COUNT(OI.ORDER_ID) AS TOTAL_QUANTITY_SOLD,
	ROUND(SUM(OI.PRICE),0) AS TOTAL_REVENUE
FROM 
    ORDER_ITEMS_TABLE OI
JOIN 
    ORDERS_TABLE O ON OI.ORDER_ID = O.ORDER_ID
JOIN 
    PRODUCTS_TABLE P ON OI.PRODUCT_ID = P.PRODUCT_ID
WHERE 
    O.ORDER_STATUS = 'DELIVERED'
GROUP BY 
    P.PRODUCT_CATEGORY_NAME
ORDER BY 2 DESC;


-- INSIGHTS:
-- Most Ordered: Bed, Table & Bath (10,953 orders) – daily essentials.
-- Top Revenue: Beauty & Health (₹1.23M) – high-value products.
-- Watches & Gifts: Fewer orders (5,859), but high revenue (₹1.16M) – premium items.
-- Niche Value: Automotive & Garden Tools have lower orders but decent revenue.

-- 3. What is the average amount spent per order, and how does it change depending on the product category or payment method?

CREATE NONCLUSTERED INDEX IX_PAYMENT_VALUES 
ON PAYMENTS_TABLE (PAYMENT_VALUE);

SELECT 
    ROUND(AVG(PAYMENT_VALUE),2) AS AVG_AMOUNT_PER_ORDER
FROM 
    PAYMENTS_TABLE;


SELECT 
    P.PRODUCT_CATEGORY_NAME,
    PM.PAYMENT_TYPE,
    ROUND(AVG(OI.PRICE), 2) AS AVG_SPENT_PER_ITEM
FROM 
    ORDER_ITEMS_TABLE OI
JOIN 
    PRODUCTS_TABLE P ON OI.PRODUCT_ID = P.PRODUCT_ID
JOIN 
    PAYMENTS_TABLE PM ON OI.ORDER_ID = PM.ORDER_ID
GROUP BY 
    P.PRODUCT_CATEGORY_NAME,
    PM.PAYMENT_TYPE
ORDER BY 
    P.PRODUCT_CATEGORY_NAME,
    AVG_SPENT_PER_ITEM DESC;

-- Overall average order amount: 154.1
-- Credit cards generally dominate average spend but vouchers outperform credit cards in specific categories (e.g., Music Instruments, PCS, Women’s Fashion).
-- Debit cards sometimes lead in spend for niche categories like Air Conditioning and Fixed Telephony.
-- Boleto generally ranks third or fourth but still shows competitive spends in categories like Agriculture and PCS.

-- 4. How many active sellers are there on the platform, and does this number go up or down over time?

SELECT 
    COUNT(DISTINCT SELLER_ID) AS ACTIVE_SELLERS
FROM 
    ORDER_ITEMS_TABLE;

SELECT 
    FORMAT(O.ORDER_PURCHASE_TIMESTAMP, 'yyyy-MM') AS PURCHASE_MONTH,
    COUNT(DISTINCT OI.SELLER_ID) AS ACTIVE_SELLERS
FROM 
    ORDER_ITEMS_TABLE OI
JOIN 
    ORDERS_TABLE O ON OI.ORDER_ID = O.ORDER_ID
WHERE 
    O.ORDER_STATUS = 'delivered'
GROUP BY 
    FORMAT(O.ORDER_PURCHASE_TIMESTAMP, 'yyyy-MM')
ORDER BY 
    PURCHASE_MONTH;

--Total Active Sellers: 3095
--Strong Growth: From 219 in Jan 2017 to 1261 in Aug 2018
--2017: Rapid seller onboarding — consistent month-over-month growth.
--2018: Growth continued but started to slow down after June.
--2016: Minimal activity — likely platform launch or incomplete data.
--Peak Month: Aug 2018 with 1261 active sellers


-- 5. Which products sell the most, and how have their sales changed over time?


SELECT TOP 10
    P.PRODUCT_CATEGORY_NAME,
    COUNT(OI.ORDER_ID) AS TOTAL_QUANTITY_SOLD
FROM 
    ORDER_ITEMS_TABLE OI
JOIN 
    ORDERS_TABLE O ON OI.ORDER_ID = O.ORDER_ID
JOIN 
    PRODUCTS_TABLE P ON OI.PRODUCT_ID = P.PRODUCT_ID
WHERE 
    O.ORDER_STATUS = 'DELIVERED'
GROUP BY 
    P.PRODUCT_CATEGORY_NAME
ORDER BY 2 DESC;


SELECT 
    FORMAT(O.ORDER_PURCHASE_TIMESTAMP, 'yyyy-MM') AS MONTH,
    P.PRODUCT_CATEGORY_NAME,
    COUNT(OI.ORDER_ID) AS TOTAL_QUANTITY_SOLD
FROM 
    ORDER_ITEMS_TABLE OI
JOIN 
    ORDERS_TABLE O ON OI.ORDER_ID = O.ORDER_ID
JOIN 
    PRODUCTS_TABLE P ON OI.PRODUCT_ID = P.PRODUCT_ID
WHERE 
    O.ORDER_STATUS = 'DELIVERED' AND P.PRODUCT_CATEGORY_NAME IS NOT NULL
GROUP BY 
    FORMAT(O.ORDER_PURCHASE_TIMESTAMP, 'yyyy-MM'),
    P.PRODUCT_CATEGORY_NAME
ORDER BY 3 desc;


-- 6. Do customer reviews and ratings help products sell more or perform better on the platform?
--    (Check sales with higher or lower ratings and identify if any correlation is there)


SELECT 
    R.REVIEW_SCORE,
    COUNT(OI.ORDER_ID) AS TOTAL_ORDERS,
    COUNT(DISTINCT OI.PRODUCT_ID) AS DISTINCT_PRODUCTS,
    SUM(OI.PRICE) AS TOTAL_REVENUE,
    AVG(OI.PRICE) AS AVG_PRICE
FROM 
    CUSTOMERS_REVIEW_TABLE R
JOIN 
    ORDER_ITEMS_TABLE OI ON R.ORDER_ID = OI.ORDER_ID
GROUP BY 
    R.REVIEW_SCORE
ORDER BY 
    R.REVIEW_SCORE;

-- 5-star reviews drive the most sales: highest orders (63.5k) and revenue (₹7.7M).
-- Higher ratings = higher revenue & avg price.
-- Low-rated (1–2 star) orders are fewer and earn much less.




