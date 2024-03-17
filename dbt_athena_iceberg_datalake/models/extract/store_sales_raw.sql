{{
    config(
        materialized='incremental'
    )
}}

SELECT *, 
'2022-01-02' AS extraction_timestamp,
'U' AS op
FROM {{ source('tpcds','store_sales') }}

{% if is_incremental() %}

    LIMIT 10000

{% else %}

    LIMIT 0

{% endif %}
