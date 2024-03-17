{{
    config(
        materialized='incremental',
        table_type='iceberg',
        incremental_strategy='merge',
        unique_key=["ss_item_sk", "ss_ticket_number"],
    )
}}

{% if is_incremental() %}

    SELECT *
    FROM {{ ref('store_sales_raw') }}
    WHERE extraction_timestamp > (SELECT MAX(extraction_timestamp) FROM {{ this }})

{% else %}

    SELECT *
    FROM {{ ref('store_sales_raw') }}

{% endif %}
