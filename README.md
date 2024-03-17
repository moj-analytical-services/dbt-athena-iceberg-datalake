# dbt-athena-iceberg-datalake

> [!WARNING]
> Work in Progress

This repository utilises [Amazon Athena](https://aws.amazon.com/athena/) query engine along with the [Apache Iceberg](https://iceberg.apache.org/) table format, managed by [dbt-athena](https://github.com/dbt-athena/dbt-athena), to implement a data lakehouse for the [TPCDS](https://www.tpc.org/tpcds/) `store_sales` table.

#### Source

A scale = 10 `store_sales_source` table is generated using the Athena TPC-DS [connector](https://docs.aws.amazon.com/athena/latest/ug/connectors-tpcds.html). This is the largest table that can be created using the connector without the lambda function timing out.

#### Extract

The source table is inserted as many times as required into the `store_sales_raw` table. dbt enforces a model per table rule, which means that a model needs to be created for every insert. This is currently set to 0, but you can insert more data by copying the base file. The inserts run concurrently.

#### Curate

The `store_sales_wap` table first is created from the `store_sales_raw` table using CTAS. New rows from the `store_sales_raw` table are then merged into the `store_sales_wap` table. The `store_sales` view is only refreshed if all tests pass against `store_sales_wap`. 

#### Instructions

1. Deploy the connector to your AWS account and call it `athena_tpcds_connector`

2. Update the `profiles.yml` to reference buckets in your AWS account:

```
      s3_data_dir: s3://dbt-tables-sandbox
      s3_staging_dir: s3://dbt-query-dump-sandbox/dbt-athena-iceberg-datalake
```

3. Authenticate with AWS credentials

4. Run the following code to generate the equivalent of the scale = 3000 `store_sales` table:

```bash
for i in {1..300}; do cp models/extract/store_sales_raw__0.sql models/extract/store_sales_raw__${i}.sql; done
dbt run --select source
dbt run --full-refresh --select extract
dbt run --full-refresh --select curate
dbt run --select "config.materialized:incremental"
dbt run --select store_sales
```