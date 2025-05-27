{{ config(materialized='view') }}

with orders_items as (
  SELECT od.order_id, 
  array_agg(STRUCT(od.product_id,
    od.quantity,
    p.price,
    od.quantity * p.price as total_price)) as items
  FROM {{ ref('stg_order_details') }} od
  JOIN {{ ref('stg_products') }} p
  on od.product_id = p.product_id
  group by od.order_id
)
SELECT
  o.order_id,
  o.customer_id,
  items 
FROM {{ ref('stg_orders') }} o
JOIN orders_items oi
on o.order_id = oi.order_id

