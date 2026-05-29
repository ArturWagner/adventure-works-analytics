-- Source: sql/transforms/fact_reseller_sales.sql (21 columns)
-- Particionada por order_date (DATE) para filtros de intervalo de datas no Looker Studio.
-- Aplicar via: bq query --project_id=unigran-tcc < sql/schema/fact_reseller_sales.sql
CREATE TABLE IF NOT EXISTS `unigran-tcc.adventureworks.fact_reseller_sales` (
  product_key         INT64,
  order_date_key      INT64,
  due_date_key        INT64,
  ship_date_key       INT64,
  reseller_key        INT64,
  employee_key        INT64,
  promotion_key       INT64,
  currency_key        STRING,
  sales_territory_key INT64,
  sales_order_number  STRING,
  sales_order_line    INT64,
  order_quantity      INT64,
  unit_price          NUMERIC,
  extended_amount     NUMERIC,
  sales_amount        NUMERIC,
  tax_amount          NUMERIC,
  freight             NUMERIC,
  total_product_cost  NUMERIC,
  order_date          DATE    NOT NULL,
  due_date            DATE,
  ship_date           DATE
)
PARTITION BY order_date;
