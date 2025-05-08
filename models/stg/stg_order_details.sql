{{ config(
    materialized='incremental',
    incremental_strategy = 'merge',
    unique_key=['order_id', 'product_id']
)}}

SELECT *, current_timestamp() as load_at
FROM {{ source('raw', 'order_details_raw') }}
{% if is_incremental() %}
WHERE updated_at > (SELECT max(updated_at) FROM {{ this }})
{% endif %}
QUALIFY ROW_NUMBER() OVER (PARTITION BY order_id, product_id ORDER BY updated_at DESC) = 1