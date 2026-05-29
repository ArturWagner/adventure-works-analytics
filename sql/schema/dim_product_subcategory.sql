-- Source: sql/transforms/dim_product_subcategory.sql
-- Aplicar via: bq query --project_id=unigran-tcc < sql/schema/dim_product_subcategory.sql
CREATE TABLE IF NOT EXISTS `unigran-tcc.adventureworks.dim_product_subcategory` (
  product_subcategory_key INT64  NOT NULL,
  subcategory_name        STRING,
  category_key            INT64,
  category_name           STRING
);
