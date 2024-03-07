{{
    config(
        materialized='incremental',
        table_type='iceberg',
        incremental_strategy='merge',
        unique_key=["ws_item_sk", "ws_order_number"],
        update_condition="src.extraction_timestamp >= '2022-01-02'",
    )
}}

select *
from {{ ref('web_sales_raw_hist') }}
