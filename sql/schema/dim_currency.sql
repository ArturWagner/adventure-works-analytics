-- Source: sql/transforms/dim_currency.sql
-- currency_key is a 3-letter ISO code (e.g. 'USD'), NOT an integer.
-- Aplicar via: bq query --project_id=unigran-tcc < sql/schema/dim_currency.sql
CREATE TABLE IF NOT EXISTS `unigran-tcc.adventureworks.dim_currency` (
  currency_key  STRING NOT NULL,
  currency_name STRING
);
