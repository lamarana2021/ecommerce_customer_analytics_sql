
/* ===========================================================================================
	2 - Customer Profile: Understanding who the customers are
   ===========================================================================================*/

-- customers present in each gender type
SELECT 
	gender,
	COUNT(*) AS customers
FROM ecommerce_customer
GROUP BY gender;


-- customers in each income bracket
SELECT 
	 income_bracket,
	COUNT(*) AS customers,
	CAST(
	100.0 * COUNT(*) / SUM(COUNT(*)) OVER()
	AS DECIMAL(5,2)
	) AS percentage
FROM ecommerce_customer
GROUP BY income_bracket
ORDER BY customers DESC;


-- number of customers in each country
SELECT  
	country, 
	COUNT(*)  as customers,
	CAST(
		100.0 * COUNT(*) / SUM(COUNT(*)) OVER()
		AS DECIMAL(5,2)
		) AS customer_percent
FROM ecommerce_customer
GROUP BY country
ORDER BY customers DESC;



-- customers in each region
SELECT 
	region,
	COUNT(*) AS customers,
	CAST(
		100.0 * COUNT(*) / SUM(COUNT(*))OVER()
		AS DECIMAL(5,2)
		) AS customer_percent
FROM ecommerce_customer
GROUP BY region
ORDER BY customers DESC;


-- customers in each loyalty tier
SELECT 
	loyalty_tier,
	COUNT(*) AS customers
FROM ecommerce_customer
GROUP BY loyalty_tier
ORDER BY customers DESC;