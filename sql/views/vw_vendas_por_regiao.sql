-- View: vw_vendas_por_regiao
-- Purpose: Aggregate sales by geography and sales territory for Looker Studio.
-- Source tables: fact_internet_sales, fact_reseller_sales, dim_sales_territory, dim_geography
-- Idempotent: CREATE OR REPLACE VIEW — safe to re-run.
-- Note: city maps to state_province (most granular geographic unit in dim_geography).
-- LEFT JOIN on geography ensures rows without a matching state/province are still included.
CREATE OR REPLACE VIEW `unigran-tcc.adventureworks.vw_vendas_por_regiao` AS
SELECT
  dg.state_province                AS city,
  dst.territory_name               AS territory_region,
  SUM(combined.sales_amount)       AS sales_amount,
  combined.order_date
FROM (
  SELECT sales_territory_key, sales_amount, order_date
  FROM `unigran-tcc.adventureworks.fact_internet_sales`
  UNION ALL
  SELECT sales_territory_key, sales_amount, order_date
  FROM `unigran-tcc.adventureworks.fact_reseller_sales`
) AS combined
INNER JOIN `unigran-tcc.adventureworks.dim_sales_territory` AS dst
  ON combined.sales_territory_key = dst.sales_territory_key
LEFT JOIN `unigran-tcc.adventureworks.dim_geography` AS dg
  ON dst.sales_territory_key = dg.territory_key
GROUP BY
  dg.state_province,
  dst.territory_name,
  combined.order_date;
