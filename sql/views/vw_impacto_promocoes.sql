-- View: vw_impacto_promocoes
-- Purpose: Aggregate internet sales by promotion and product category for Looker Studio.
-- Source tables: fact_internet_sales, dim_promotion, dim_product
-- Idempotent: CREATE OR REPLACE VIEW — safe to re-run.
-- Note: Uses only fact_internet_sales (promotions are applied to internet channel only).
-- LEFT JOIN on dim_promotion: some sales may have no active promotion (promotion_key = 1).
CREATE OR REPLACE VIEW `unigran-tcc.adventureworks.vw_impacto_promocoes` AS
SELECT
  dp_promo.promotion_name,
  dp_prod.category_name,
  SUM(fis.sales_amount) AS sales_amount,
  fis.order_date
FROM `unigran-tcc.adventureworks.fact_internet_sales` AS fis
LEFT JOIN `unigran-tcc.adventureworks.dim_promotion` AS dp_promo
  ON fis.promotion_key = dp_promo.promotion_key
INNER JOIN `unigran-tcc.adventureworks.dim_product` AS dp_prod
  ON fis.product_key = dp_prod.product_key
GROUP BY
  dp_promo.promotion_name,
  dp_prod.category_name,
  fis.order_date;
