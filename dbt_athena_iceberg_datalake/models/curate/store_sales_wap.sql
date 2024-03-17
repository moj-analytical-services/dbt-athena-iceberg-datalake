{{
    config(
        materialized='incremental',
        table_type='iceberg',
        incremental_strategy='merge',
        unique_key=["ss_item_sk", "ss_ticket_number"],
    )
}}


SELECT *
FROM {{ ref('store_sales_raw') }}

{% if is_incremental() %}

    WHERE extraction_timestamp > (SELECT MAX(extraction_timestamp) FROM {{ this }})

{% endif %}
