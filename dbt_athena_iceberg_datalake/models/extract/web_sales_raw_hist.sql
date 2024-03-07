{{
    config(
        materialized='incremental'
    )
}}

{% if is_incremental() %}
    select *, 
    '2022-01-02' AS extraction_timestamp,
    'U' AS op
    from {{ source('tpcds','web_sales') }}
    LIMIT 10000

{% else %}

    select *, 
    '2022-01-01' AS extraction_timestamp,
    'I' AS op
    from {{ source('tpcds','web_sales') }}

{% endif %}
