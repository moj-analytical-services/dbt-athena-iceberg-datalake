SELECT *
FROM {{ source('tpcds','store_sales') }}