-- 01_load_raw.sql
-- Load the 9 Olist CSVs into DuckDB as raw tables (no changes to the data).

CREATE OR REPLACE TABLE raw_orders      AS SELECT * FROM read_csv_auto('data/raw/olist_orders_dataset.csv');
CREATE OR REPLACE TABLE raw_customers   AS SELECT * FROM read_csv_auto('data/raw/olist_customers_dataset.csv');
CREATE OR REPLACE TABLE raw_order_items AS SELECT * FROM read_csv_auto('data/raw/olist_order_items_dataset.csv');
CREATE OR REPLACE TABLE raw_payments    AS SELECT * FROM read_csv_auto('data/raw/olist_order_payments_dataset.csv');
CREATE OR REPLACE TABLE raw_reviews     AS SELECT * FROM read_csv_auto('data/raw/olist_order_reviews_dataset.csv');
CREATE OR REPLACE TABLE raw_products    AS SELECT * FROM read_csv_auto('data/raw/olist_products_dataset.csv');
CREATE OR REPLACE TABLE raw_sellers     AS SELECT * FROM read_csv_auto('data/raw/olist_sellers_dataset.csv');
CREATE OR REPLACE TABLE raw_geolocation AS SELECT * FROM read_csv_auto('data/raw/olist_geolocation_dataset.csv');
CREATE OR REPLACE TABLE raw_category_translation AS SELECT * FROM read_csv_auto('data/raw/product_category_name_translation.csv');
