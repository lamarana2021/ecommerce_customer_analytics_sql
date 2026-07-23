

/* ================================================================================================
	5 - Churn Analysis: Explore behavioural characteristics associated with churn
   ================================================================================================*/

-- Compare purchasing behaviour and lifetime between churned and retained customers
SELECT 
    churn,
    COUNT(*) AS customers,
	CAST(
		100.0 * COUNT(*) / SUM(COUNT(*)) OVER()
		AS DECIMAL(5,2)
		) AS churn_percent,
    ROUND(AVG(total_spent_usd),2) AS avg_spending,
    ROUND(AVG(total_orders),2) AS avg_orders,
    ROUND(AVG(customer_lifetime_days),0) AS avg_lifetime,
    ROUND(AVG(days_since_last_purchase),0) AS avg_days_since_purchase,
    ROUND(AVG(satisfaction_score),2) AS avg_satisfaction
FROM ecommerce_customer
GROUP BY churn;



-- Churn rate by loyalty tier
SELECT 
    loyalty_tier,
    COUNT(*) AS total_customers,
    CAST(
        100.0 * SUM(CASE WHEN churn = 1 THEN 1 ELSE 0 END) / COUNT(*)
        AS DECIMAL(5,2)
    ) AS churn_percentage,
    ROUND(
        SUM(CASE WHEN churn = 1 THEN total_spent_usd ELSE 0 END),2
        ) AS total_churn_revenue,
        CAST(
        100.0 * SUM(CASE WHEN churn = 0 THEN 1 ELSE 0 END) / COUNT(*)
        AS DECIMAL(5,2)
    ) AS retained_percentage,
    ROUND(
        SUM(CASE WHEN churn = 0 THEN total_spent_usd ELSE 0 END),2
        ) AS total_retained_revenue
FROM ecommerce_customer
GROUP BY loyalty_tier
ORDER BY churn_percentage DESC;


-- Churned customers by income bracket
SELECT
    income_bracket,
    SUM(CASE WHEN churn = 1 THEN 1 ELSE 0 END) AS churned_customers,
    CAST(
    100.0 * SUM(CASE WHEN churn = 1 THEN 1 ELSE 0 END) / COUNT(*)
    AS DECIMAL(5,2)
    ) AS churned_percentage,
    SUM(CASE WHEN churn = 0 THEN 1 ELSE 0 END) AS retained_customers
FROM ecommerce_customer
GROUP BY income_bracket
ORDER BY churned_customers DESC, retained_customers DESC

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
	COUNT(*) AS customers
FROM ecommerce_customer
GROUP BY churn, newsletter_subscribed
ORDER BY churn, customers DESC


-- referral source and churn
SELECT 
	churn,
	referral_source,
	COUNT(*) customers
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


-- Session engagement and churn
SELECT
    churn,
    ROUND(AVG(avg_session_duration_min),2) AS avg_session_duration,
    ROUND(AVG(avg_pages_per_session),2) AS avg_pages_per_session
FROM ecommerce_customer
GROUP BY churn;

