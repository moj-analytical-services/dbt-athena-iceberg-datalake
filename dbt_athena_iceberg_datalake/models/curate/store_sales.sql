{{
    config(
        materialized='view'
    )
}}

{% set current_timestamp = modules.datetime.datetime.now() %}

SELECT * 
FROM {{ ref('store_sales_wap') }}
FOR TIMESTAMP AS OF TIMESTAMP '{{ current_timestamp }} UTC'
