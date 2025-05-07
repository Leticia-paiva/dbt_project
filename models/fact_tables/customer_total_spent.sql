{{ config(materialized='view') }}

SELECT
  c.customer_name,
  sum(fo.total_price) as total_amount_spent
FROM {{ ref('stg_customers') }} c
JOIN {{ ref('fact_orders') }} fo
  ON c.customer_id = fo.customer_id
GROUP BY c.customer_id, c.customer_name
