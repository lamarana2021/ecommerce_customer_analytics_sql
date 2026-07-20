
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
