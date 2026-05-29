-- Source: sql/transforms/dim_sales_territory.sql
-- Aplicar via: bq query --project_id=unigran-tcc < sql/schema/dim_sales_territory.sql
CREATE TABLE IF NOT EXISTS `unigran-tcc.adventureworks.dim_sales_territory` (
  sales_territory_key INT64   NOT NULL,
  territory_name      STRING,
  country_region_code STRING,
  territory_group     STRING,
  sales_ytd           NUMERIC,
  sales_last_year     NUMERIC
);
