{{ config(materialized='view') }}

SELECT
  o.order_id,
  o.customer_id,
  od.product_id,
  od.quantity,
  p.price,
  od.quantity * p.price as total_price
FROM {{ ref('stg_orders') }} o
JOIN {{ ref('stg_order_details') }} od
  ON o.order_id = od.order_id
JOIN {{ ref('stg_products') }} p
  on od.product_id = p.product_id
