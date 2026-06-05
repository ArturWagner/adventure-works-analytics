-- View: vw_vendas_por_regiao
-- Purpose: Aggregate sales by territory and country for Looker Studio world map.
-- Uses dim_sales_territory only (1 row per territory) — avoids dim_geography fan-out.
-- country_region_code from dim_sales_territory is the clean 1:1 key per territory.
-- Idempotent: CREATE OR REPLACE VIEW — safe to re-run.
CREATE OR REPLACE VIEW `unigran-tcc.adventureworks.vw_vendas_por_regiao` AS
SELECT
  dst.territory_name AS territory_region,
  CASE dst.country_region_code
    WHEN 'US' THEN 'United States'
    WHEN 'CA' THEN 'Canada'
    WHEN 'AU' THEN 'Australia'
    WHEN 'FR' THEN 'France'
    WHEN 'DE' THEN 'Germany'
    WHEN 'GB' THEN 'United Kingdom'
    ELSE dst.country_region_code
  END AS country_region,
  SUM(combined.sales_amount) AS sales_amount,
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
GROUP BY 1, 2, 4;
