{{
    config(
        materialized='incremental'
    )
}}

{% if is_incremental() %}
    SELECT *, 
    '2022-01-02' AS extraction_timestamp,
    'U' AS op
    FROM {{ source('tpcds','store_sales') }}
    LIMIT 10000

{% else %}

    SELECT *, 
    '2022-01-01' AS extraction_timestamp,
    'I' AS op
    FROM {{ source('tpcds','store_sales') }}
    LIMIT 0

{% endif %}
