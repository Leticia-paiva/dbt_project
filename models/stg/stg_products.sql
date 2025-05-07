{{ config(
    materialized='incremental',
    unique_key='product_id'
) }}

SELECT *, current_timestamp() as load_at
FROM {{ source('raw', 'products') }}
{% if is_incremental() %}
WHERE product_id NOT IN (SELECT product_id FROM {{ this }})
{% endif %}