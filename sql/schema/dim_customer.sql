-- Source: sql/transforms/dim_customer.sql
-- Aplicar via: bq query --project_id=unigran-tcc < sql/schema/dim_customer.sql
CREATE TABLE IF NOT EXISTS `unigran-tcc.adventureworks.dim_customer` (
  customer_key        INT64  NOT NULL,
  first_name          STRING,
  last_name           STRING,
  full_name           STRING,
  email_address       STRING,
  city                STRING,
  state_province      STRING,
  country_region      STRING,
  country_region_code STRING,
  postal_code         STRING,
  territory_key       INT64
);
