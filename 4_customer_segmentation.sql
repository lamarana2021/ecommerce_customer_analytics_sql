
/* ================================================================================================
	4 - Customer Segmentation: 
		Explore how customer value differs across demographic and behavioral segments.
   ================================================================================================*/


-- classify age groups and find their spending behavior 
WITH age_grouping AS(
SELECT  
		CASE 
			WHEN age BETWEEN 18 AND 25 THEN '18 - 25'
			WHEN age BETWEEN 26 AND 35 THEN '26 - 35'
			WHEN age BETWEEN 36 AND 45 THEN '36 - 45'
			WHEN age BETWEEN 46 AND 55 THEN '46 - 55'
			ELSE 'Above 55'
		END AS age_group,
		customer_lifetime_days,
		total_orders,
		total_spent_usd
FROM ecommerce_customer
)
SELECT	
		age_group,
		COUNT(*) AS customers,
		ROUND(AVG(total_spent_usd), 2) AS avg_spending,
		AVG(total_orders) AS avg_orders,
		AVG(customer_lifetime_days) AS avg_lifetime		
FROM age_grouping
GROUP BY age_group
ORDER BY avg_spending DESC;


-- Income bracket distribution
SELECT 
	loyalty_tier, 
	income_bracket, 
	COUNT(*) AS  income_distribution
FROM ecommerce_customer
GROUP BY loyalty_tier, income_bracket
ORDER BY loyalty_tier, income_distribution DESC;


-- In each income bracket, which loyalty tier has the highest customers?
WITH loyalty_counts AS(
SELECT 
	income_bracket,
	loyalty_tier,
	COUNT(*) AS customers,
	100.0 * COUNT(*)/SUM(COUNT(*)) OVER(PARTITION BY income_bracket) AS percentage_loyalty,
	DENSE_RANK() OVER(PARTITION BY income_bracket ORDER BY COUNT(*) DESC) AS loyalty_ranking
FROM ecommerce_customer
GROUP BY income_bracket, loyalty_tier
)
SELECT 
	income_bracket,
	loyalty_tier,
	customers
FROM loyalty_counts
WHERE loyalty_ranking = 1
ORDER BY income_bracket ;


-- Identify the three most preferred product categories within each loyalty tier.
WITH category_rank AS (
select 
	loyalty_tier, 
	preferred_category, 
	COUNT(*) AS category_count,
	DENSE_RANK() OVER(PARTITION BY loyalty_tier ORDER BY COUNT(*) DESC ) AS ranking
FROM ecommerce_customer
GROUP BY loyalty_tier, preferred_category
)
-- Top 3 categories for each loyalty tier
SELECT loyalty_tier, 
	preferred_category,
	category_count
FROM category_rank
WHERE ranking <=3
ORDER BY loyalty_tier DESC;


-- Analyse how loyalty tier distribution varies across income groups.
SELECT 
	income_bracket,
	loyalty_tier,
	COUNT(*) AS customers,
	CAST( ROUND(100.0 * COUNT(*)/SUM(COUNT(*)) 
				OVER(PARTITION BY income_bracket), 2) AS DECIMAL(5,2)) AS percentage_loyalty
FROM ecommerce_customer
GROUP BY income_bracket, loyalty_tier
ORDER BY income_bracket DESC, customers DESC