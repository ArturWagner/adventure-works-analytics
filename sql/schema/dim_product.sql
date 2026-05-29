-- Source: sql/transforms/dim_product.sql
-- Aplicar via: bq query --project_id=unigran-tcc < sql/schema/dim_product.sql
CREATE TABLE IF NOT EXISTS `unigran-tcc.adventureworks.dim_product` (
  product_key      INT64    NOT NULL,
  product_name     STRING,
  product_number   STRING,
  color            STRING,
  size             STRING,
  weight           FLOAT64,
  list_price       NUMERIC,
  standard_cost    NUMERIC,
  product_line     STRING,
  subcategory_name STRING,
  category_name    STRING,
  subcategory_key  INT64,
  category_key     INT64,
  sell_start_date  DATETIME,
  sell_end_date    DATETIME
);
