{%- set relation = api.Relation.create(
    identifier='web_sales',
    schema='tpcds10',
    database='athena_tpcds_connector',
    type='table'
) -%}

select *, 
CAST('2022-01-02' as timestamp) AS extraction_timestamp,
'U' AS op
from {{relation}}
LIMIT 10000