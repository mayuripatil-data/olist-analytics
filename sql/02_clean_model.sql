-- 02_clean_model.sql
-- Clean the raw tables and build an analysis-ready star schema.
--   dim_customers, dim_products, dim_sellers  (who / what)
--   fct_orders                                (one row per order, with delivery + review metrics)

-- Customers: customer_id is per ORDER; customer_unique_id is the real person.
CREATE OR REPLACE TABLE dim_customers AS
SELECT DISTINCT
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix AS zip_prefix,
    customer_city            AS city,
    customer_state           AS state
FROM raw_customers;

-- Products with English category names.
CREATE OR REPLACE TABLE dim_products AS
SELECT
    p.product_id,
    COALESCE(t.product_category_name_english, p.product_category_name, 'unknown') AS category,
    p.product_weight_g AS weight_g
FROM raw_products p
LEFT JOIN raw_category_translation t USING (product_category_name);

CREATE OR REPLACE TABLE dim_sellers AS
SELECT seller_id, seller_city AS city, seller_state AS state
FROM raw_sellers;

-- Some orders have more than one review: keep only the latest per order.
CREATE OR REPLACE TABLE stg_reviews AS
WITH ranked AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY order_id
                              ORDER BY review_answer_timestamp DESC) AS rn
    FROM raw_reviews
)
SELECT order_id, review_score
FROM ranked
WHERE rn = 1;

-- Order items rolled up to one row per order.
CREATE OR REPLACE TABLE stg_order_totals AS
SELECT
    order_id,
    COUNT(*)                     AS n_items,
    COUNT(DISTINCT seller_id)    AS n_sellers,
    SUM(price)                   AS item_value,
    SUM(freight_value)           AS freight_value,
    SUM(price + freight_value)   AS order_value
FROM raw_order_items
GROUP BY order_id;

-- Fact table: one row per order.
CREATE OR REPLACE TABLE fct_orders AS
SELECT
    o.order_id,
    o.customer_id,
    c.customer_unique_id,
    c.state                                   AS customer_state,
    o.order_status,
    CAST(o.order_purchase_timestamp AS TIMESTAMP)      AS purchased_at,
    CAST(o.order_delivered_customer_date AS TIMESTAMP) AS delivered_at,
    CAST(o.order_estimated_delivery_date AS TIMESTAMP) AS estimated_at,
    DATE_TRUNC('month', CAST(o.order_purchase_timestamp AS TIMESTAMP)) AS purchase_month,
    DATE_DIFF('day', CAST(o.order_purchase_timestamp AS TIMESTAMP),
                     CAST(o.order_delivered_customer_date AS TIMESTAMP)) AS delivery_days,
    DATE_DIFF('day', CAST(o.order_estimated_delivery_date AS TIMESTAMP),
                     CAST(o.order_delivered_customer_date AS TIMESTAMP)) AS delay_days,
    CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
         THEN 1 ELSE 0 END                    AS is_late,
    t.n_items,
    t.n_sellers,
    t.item_value,
    t.freight_value,
    t.order_value,
    r.review_score
FROM raw_orders o
LEFT JOIN dim_customers    c USING (customer_id)
LEFT JOIN stg_order_totals t USING (order_id)
LEFT JOIN stg_reviews      r USING (order_id);
