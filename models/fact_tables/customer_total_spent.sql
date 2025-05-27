{{ config(materialized='view')}}

WITH customer_order_items AS (
  SELECT
    fo.customer_id,
    item.total_price
  FROM {{ ref('fact_orders') }} fo,
  UNNEST(fo.items) AS item
)
SELECT
  c.customer_name,
  SUM(coi.total_price) AS total_amount_spent
FROM {{ ref('stg_customers') }} c
JOIN customer_order_items coi
  ON c.customer_id = coi.customer_id
GROUP BY
  c.customer_id,
  c.customer_name