
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



/* ===========================================================================================
	2 - Customer Profile: Understanding who the customers are
   ===========================================================================================*/

-- customers present in each gender type
SELECT 
	gender,
	COUNT(*) AS customers
FROM ecommerce_customer
GROUP BY gender;


-- number of customers in each country
SELECT  
	country, 
	COUNT(*)  as customers
FROM ecommerce_customer
GROUP BY country
ORDER BY customers DESC;


-- customers in each income bracket
SELECT 
	 income_bracket,
	COUNT(*) AS customers
FROM ecommerce_customer
GROUP BY income_bracket
ORDER BY customers DESC;


-- customers in each region
SELECT 
	region,
	COUNT(*) AS customers
FROM ecommerce_customer
GROUP BY region
ORDER BY customers;


-- customers in each loyalty tier
SELECT 
	loyalty_tier,
	COUNT(*) AS customers
FROM ecommerce_customer
GROUP BY loyalty_tier
ORDER BY customers DESC;



/* ================================================================================================
	3 - Customer Value Analysis: Identifying the customer segments that generate the most revenue
   ================================================================================================*/

-- Compare purchasing behaviour across loyalty tiers
SELECT
	loyalty_tier, 
	AVG(total_orders) AS avg_orders,
	ROUND(AVG(total_spent_usd), 0) AS avg_spending,
	ROUND(SUM(total_spent_usd)/NULLIF(SUM(total_orders), 0), 2) AS average_order_value 
FROM ecommerce_customer
GROUP BY  loyalty_tier
ORDER BY avg_spending DESC;


-- Compare customer spending & lifetime by tier
SELECT
	loyalty_tier,
	COUNT(*) AS customers,
	AVG(customer_lifetime_days) AS Average_lifetime,
	AVG(total_orders) AS avg_orders,
	Round(SUM(total_spent_usd), 2) AS total_spending,
	Round(AVG(avg_order_value_usd), 2) AS Average_order_value
FROM ecommerce_customer
GROUP BY loyalty_tier
ORDER BY Average_lifetime DESC;


-- Country ranking based on Revenue generation and purchasing activities
WITH country_orders_spending AS (
	SELECT	country, 
			COUNT(*) AS customers,
			ROUND(SUM(total_spent_usd),2) AS total_revenue, 
			ROUND(SUM(total_spent_usd) / COUNT(*), 2) AS revenue_per_customer,
			SUM(total_orders)  AS country_orders,
			ROUND(SUM(total_spent_usd) / NULLIF(SUM(total_orders), 0), 2) AS average_order_value
	FROM ecommerce_customer 
	GROUP BY country
),
ranking AS (
	SELECT
		country,
		customers,
		total_revenue,
		revenue_per_customer,
		country_orders,
		average_order_value,
		DENSE_RANK() OVER(ORDER BY total_revenue DESC) AS revenue_rank,
		DENSE_RANK() OVER(ORDER BY country_orders DESC) AS order_rank
		FROM country_orders_spending
)
--  Identify countries that rank highest in revenue contribution or order volume
SELECT
	country,
	customers,
	total_revenue,
	revenue_per_customer,
	country_orders,
	average_order_value
FROM ranking
WHERE order_rank <= 5
OR revenue_rank <= 5
ORDER BY total_revenue DESC, country_orders DESC;



-- Identify countries with the highest value customers
WITH country_value AS (
    SELECT
        country,
        COUNT(*) AS customers,
        ROUND(SUM(total_spent_usd),2) AS total_revenue,
        ROUND(SUM(total_spent_usd) / COUNT(*),2) AS revenue_per_customer
    FROM ecommerce_customer
    GROUP BY country
)
SELECT
    country,
    customers,
    total_revenue,
    revenue_per_customer,
    DENSE_RANK() OVER(ORDER BY revenue_per_customer DESC) AS customer_value_rank
FROM country_value
ORDER BY customer_value_rank;




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
ORDER BY income_bracket DESC, customers DESC;




/* ================================================================================================
	5 - Churn Analysis: Explore behavioural characteristics associated with churn
   ================================================================================================*/


-- Churn Behaviour: How do churned customers differ from retained customers?
SELECT 
	churn,
	ROUND(AVG(total_spent_usd), 2) AS avg_spending,
	ROUND(AVG(total_orders), 2) AS avg_orders
FROM ecommerce_customer
GROUP BY churn;


-- Lifetimes: Do churned customers have shorter customer lifetimes?
SELECT
	churn,
	AVG(customer_lifetime_days) avg_churn_lifetime
FROM ecommerce_customer
GROUP BY churn;


-- Loyalty: Does churn vary across loyalty tiers?
SELECT 
	churn,
	loyalty_tier,
	COUNT(*) AS customers,
	ROUND(AVG(total_spent_usd),2) AS avg_spending,
    ROUND(AVG(total_orders),2) AS avg_orders
FROM ecommerce_customer
GROUP BY  loyalty_tier, churn
ORDER BY loyalty_tier desc, customers DESC;


-- Income: Are some income groups more prone to churn?
SELECT 
	churn,
	income_bracket,
	COUNT(*) AS income_gap_churned
	-- ROUND(AVG(total_spent_usd),2) AS avg_spending,
    -- ROUND(AVG(total_orders),2) AS avg_orders
FROM ecommerce_customer
GROUP BY churn,income_bracket
ORDER BY churn, income_gap_churned DESC;


-- Region: Are there regional differences in churn behaviour?
SELECT 
	churn,
	region,
	COUNT(*) AS region_churned,
	ROUND(AVG(total_spent_usd),2) AS avg_spending,
    ROUND(AVG(total_orders),2) AS avg_orders
FROM ecommerce_customer
GROUP BY churn, region
ORDER BY  region DESC;

-- Satisfaction: average satisaction of churn vs non churn
SELECT
    churn,
    ROUND(AVG(satisfaction_score),2) AS avg_satisfaction
FROM ecommerce_customer
GROUP BY churn;


-- Last Purchase: average days since last purchased and churn
SELECT
    churn,
    ROUND(AVG(days_since_last_purchase),0) AS avg_days_since_purchase
FROM ecommerce_customer
GROUP BY churn;


-- ========================================================================
-- ENGAGEMENT: Are engagement characteristics associated with churn?
-- ========================================================================

-- newsletter subscription and churn
SELECT 
	churn,
	newsletter_subscribed,
	COUNT(*) AS newsletter_count
FROM ecommerce_customer
GROUP BY churn, newsletter_subscribed
ORDER BY churn, newsletter_count DESC


-- referral source and churn
SELECT 
	churn,
	referral_source,
	COUNT(*) referral_count
FROM ecommerce_customer
GROUP BY churn, referral_source
ORDER BY  referral_source DESC


-- Churn: average Discount usage, return rate and lifetime
SELECT 
	churn,
	COUNT(*) AS customers,
	ROUND(100 * AVG(discount_usage_rate), 2) AS 'avg_discount_usage(%)',
	ROUND(100 * AVG(return_rate), 2) AS 'avg_return_rate(%)',
	AVG(customer_lifetime_days) avg_churn_lifetime
FROM ecommerce_customer
GROUP BY churn

-- End of project