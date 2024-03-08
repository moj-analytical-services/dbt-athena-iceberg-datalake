{{
    config(
        materialized='view',
        post_hook="INSERT INTO {{ ref('web_sales_raw_hist') }}
                   SELECT {{ dbt_utils.star(from=ref('web_sales_raw_hist')) }}
                   FROM {{ this }}"
    )
}}

{% set node_name = model.name %}
{% set shift = node_name.split('__')[-1] %}

WITH increment AS (
    SELECT MAX(ws_order_number) as increment 
    FROM {{ ref('web_sales_raw_hist') }}
)

SELECT 
    {{ dbt_utils.star(from=ref('web_sales_raw_hist'), except=['ws_order_number', 'op', 'extraction_timestamp']) }},
    (SELECT increment FROM increment) * {{ shift }} + ws_order_number AS ws_order_number,
    '2022-01-01' AS extraction_timestamp,
    'I' AS op
FROM {{ source('tpcds','web_sales') }}
