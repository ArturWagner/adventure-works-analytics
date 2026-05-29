-- View: vw_vendas_por_categoria
-- Purpose: Aggregate sales by product category and subcategory for Looker Studio.
-- Source tables: fact_internet_sales, fact_reseller_sales, dim_product
-- Idempotent: CREATE OR REPLACE VIEW — safe to re-run.
CREATE OR REPLACE VIEW `unigran-tcc.adventureworks.vw_vendas_por_categoria` AS
SELECT
  dp.category_name,
  dp.subcategory_name,
  SUM(combined.sales_amount) AS sales_amount,
  combined.order_date
FROM (
  SELECT product_key, sales_amount, order_date
  FROM `unigran-tcc.adventureworks.fact_internet_sales`
  UNION ALL
  SELECT product_key, sales_amount, order_date
  FROM `unigran-tcc.adventureworks.fact_reseller_sales`
) AS combined
INNER JOIN `unigran-tcc.adventureworks.dim_product` AS dp
  ON combined.product_key = dp.product_key
GROUP BY
  dp.category_name,
  dp.subcategory_name,
  combined.order_date;
