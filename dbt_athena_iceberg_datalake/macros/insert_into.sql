
{% macro insert_into() %}

    {{
        config(
            materialized='view',
            post_hook="INSERT INTO {{ ref('store_sales_raw') }}
                      SELECT {{ dbt_utils.star(from=ref('store_sales_raw')) }}
                      FROM {{ this }}"
        )
    }}

    {% set node_name = model.name %}
    {% set shift = node_name.split('__')[-1] %}

    WITH increment AS (
        SELECT MAX(ss_ticket_number) AS increment 
        FROM {{ ref('store_sales_source') }}
    )

    SELECT 
        {{ dbt_utils.star(from=ref('store_sales_source'), except=['ss_ticket_number']) }},
        (SELECT increment FROM increment) * {{ shift}} + ss_ticket_number AS ss_ticket_number,
        '2022-01-01' AS extraction_timestamp,
        'I' AS op
    FROM {{ ref('store_sales_source') }}

{% endmacro %}