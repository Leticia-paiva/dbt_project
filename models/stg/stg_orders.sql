{{ config(
    materialized='incremental',
    unique_key='order_id',
    incremental_strategy = 'merge'
)}}

SELECT *, current_timestamp() as load_at
FROM {{ source('raw', 'orders_raw') }}
{% if is_incremental() %}
WHERE updated_at > (SELECT max(updated_at) FROM {{ this }})
{% endif %}
QUALIFY ROW_NUMBER() OVER (PARTITION BY order_id ORDER BY updated_at DESC) = 1