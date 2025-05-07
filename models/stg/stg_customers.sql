{{ config(
    materialized='incremental',
    unique_key='customer_id'
) }}

SELECT *, current_timestamp() as load_at
FROM {{ source('raw', 'customers_raw') }}
{% if is_incremental() %}
WHERE updated_at > (SELECT max(updated_at) FROM {{ this }})
{% endif %}
QUALIFY ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY updated_at DESC) = 1