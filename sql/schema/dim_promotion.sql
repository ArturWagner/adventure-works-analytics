-- Source: sql/transforms/dim_promotion.sql
-- Aplicar via: bq query --project_id=unigran-tcc < sql/schema/dim_promotion.sql
CREATE TABLE IF NOT EXISTS `unigran-tcc.adventureworks.dim_promotion` (
  promotion_key      INT64    NOT NULL,
  promotion_name     STRING,
  discount_pct       NUMERIC,
  promotion_type     STRING,
  promotion_category STRING,
  start_date         DATETIME,
  end_date           DATETIME,
  min_qty            INT64,
  max_qty            INT64
);
