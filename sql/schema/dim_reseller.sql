-- Source: sql/transforms/dim_reseller.sql
-- Aplicar via: bq query --project_id=unigran-tcc < sql/schema/dim_reseller.sql
CREATE TABLE IF NOT EXISTS `unigran-tcc.adventureworks.dim_reseller` (
  reseller_key        INT64  NOT NULL,
  reseller_name       STRING,
  city                STRING,
  state_province      STRING,
  country_region      STRING,
  country_region_code STRING,
  territory_key       INT64
);
