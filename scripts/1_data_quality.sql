
/* ===========================================================================================
	1 - DATA OVERVIEW & DATA QUALITY
   ===========================================================================================*/

-- data preview
SELECT *
FROM ecommerce_customer;
 

-- columns present in the dataset
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS;


-- Null values check
SELECT *
FROM  ecommerce_customer
WHERE age IS  NULL 
OR gender IS NULL
OR country IS NULL
OR region IS NULL
OR signup_date IS NULL
OR last_purchase_date IS NULL
OR total_orders IS NULL
OR total_spent_usd IS NULL
OR avg_order_value_usd IS NULL
OR discount_usage_rate IS NULL
OR return_rate IS NULL
OR satisfaction_score IS NULL
OR loyalty_tier IS NULL;

-- total customers in the business
SELECT 
	COUNT(*) AS total_customers
FROM ecommerce_customer;
