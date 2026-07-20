

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
