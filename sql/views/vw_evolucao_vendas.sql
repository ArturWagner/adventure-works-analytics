-- View: vw_evolucao_vendas
-- Purpose: Time series of sales by channel (Internet vs Reseller) for Looker Studio.
-- Source tables: fact_internet_sales, fact_reseller_sales
-- Idempotent: CREATE OR REPLACE VIEW — safe to re-run.
-- Note: channel column distinguishes Internet from Reseller traffic via UNION ALL.
CREATE OR REPLACE VIEW `unigran-tcc.adventureworks.vw_evolucao_vendas` AS
SELECT
  order_date,
  SUM(sales_amount) AS sales_amount,
  'Internet' AS channel
FROM `unigran-tcc.adventureworks.fact_internet_sales`
GROUP BY
  order_date
UNION ALL
SELECT
  order_date,
  SUM(sales_amount) AS sales_amount,
  'Reseller' AS channel
FROM `unigran-tcc.adventureworks.fact_reseller_sales`
GROUP BY
  order_date;
