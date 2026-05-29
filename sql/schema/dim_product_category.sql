-- Source: sql/transforms/dim_product_category.sql
-- Aplicar via: bq query --project_id=unigran-tcc < sql/schema/dim_product_category.sql
CREATE TABLE IF NOT EXISTS `unigran-tcc.adventureworks.dim_product_category` (
  product_category_key INT64  NOT NULL,
  category_name        STRING
);
