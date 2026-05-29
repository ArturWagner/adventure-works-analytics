-- Source: sql/transforms/dim_geography.sql
-- Aplicar via: bq query --project_id=unigran-tcc < sql/schema/dim_geography.sql
CREATE TABLE IF NOT EXISTS `unigran-tcc.adventureworks.dim_geography` (
  geography_key       INT64  NOT NULL,
  state_province      STRING,
  state_province_code STRING,
  country_region      STRING,
  country_region_code STRING,
  territory_key       INT64
);
