-- 03_first_insights.sql
-- First answers to the business question, straight from SQL.

-- Q1: How many customers ever come back?
WITH orders_per_customer AS (
    SELECT customer_unique_id, COUNT(*) AS n_orders
    FROM fct_orders
    WHERE order_status = 'delivered'
    GROUP BY customer_unique_id
)
SELECT
    COUNT(*)                                             AS customers,
    COUNT_IF(n_orders >= 2)                              AS repeat_customers,
    ROUND(100.0 * AVG(CASE WHEN n_orders >= 2 THEN 1 ELSE 0 END), 2) AS repeat_rate_pct
FROM orders_per_customer;

-- Q2: Late deliveries vs review score
SELECT
    CASE WHEN is_late = 1 THEN 'late' ELSE 'on time' END AS delivery,
    COUNT(*)                                     AS orders,
    ROUND(AVG(review_score), 2)                  AS avg_review,
    ROUND(100.0 * AVG(CASE WHEN review_score = 1 THEN 1 ELSE 0 END), 1) AS one_star_pct
FROM fct_orders
WHERE order_status = 'delivered' AND delivered_at IS NOT NULL
GROUP BY 1
ORDER BY 1;

-- Q3: Top 5 states by late-delivery rate (min 500 orders)
SELECT
    customer_state,
    COUNT(*)                         AS orders,
    ROUND(100.0 * AVG(is_late), 1)   AS late_rate_pct,
    ROUND(AVG(review_score), 2)      AS avg_review
FROM fct_orders
WHERE order_status = 'delivered' AND delivered_at IS NOT NULL
GROUP BY customer_state
HAVING COUNT(*) >= 500
ORDER BY late_rate_pct DESC
LIMIT 5;
