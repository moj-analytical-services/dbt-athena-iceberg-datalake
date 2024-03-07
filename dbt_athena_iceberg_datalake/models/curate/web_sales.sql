{{
    config(
        materialized='incremental'
    )
}}

select * from {{ ref('web_sales_raw_hist')}}

{% if is_incremental() %}
    where extraction_timestamp >= CAST('2022-01-02' as timestamp)
{% endif %}
