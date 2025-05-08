{{ config(
    materialized='incremental',
    unique_key='product_id',
    incremental_strategy = 'merge'
) }}

SELECT *, current_timestamp() as load_at
FROM {{ source('raw', 'products_raw') }}
{% if is_incremental() %}
WHERE product_id NOT IN (SELECT product_id FROM {{ this }})
{% endif %}