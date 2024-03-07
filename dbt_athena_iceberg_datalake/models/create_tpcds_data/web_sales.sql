select *, 
CAST('2022-01-01' as timestamp) AS extraction_timestamp,
'I' AS op
from {{source('tpcds','web_sales')}}
