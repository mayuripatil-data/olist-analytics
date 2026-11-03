# KPI Definitions

Every metric used in the analysis and dashboard, defined once so numbers are consistent.

| KPI | Definition | Notes |
|---|---|---|
| Orders | Count of distinct `order_id` with status `delivered` | Cancelled/unavailable excluded |
| Revenue (GMV) | Sum of `price` + `freight_value` from order items | In BRL |
| AOV | Revenue ÷ Orders | Average order value |
| Customers | Count of distinct `customer_unique_id` | Not `customer_id` (that is per order) |
| Repeat rate | Customers with ≥ 2 orders ÷ all customers | Core retention KPI |
| Delivery delay (days) | `order_delivered_customer_date` − `order_estimated_delivery_date` | Positive = late |
| Late-delivery rate | Delivered orders with delay > 0 ÷ delivered orders | |
| Avg review score | Mean `review_score` (1–5) | |
