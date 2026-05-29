-- Source: sql/transforms/dim_employee.sql
-- Aplicar via: bq query --project_id=unigran-tcc < sql/schema/dim_employee.sql
CREATE TABLE IF NOT EXISTS `unigran-tcc.adventureworks.dim_employee` (
  employee_key    INT64    NOT NULL,
  first_name      STRING,
  last_name       STRING,
  full_name       STRING,
  job_title       STRING,
  hire_date       DATE,
  gender          STRING,
  territory_key   INT64,
  sales_quota     NUMERIC,
  sales_ytd       NUMERIC,
  sales_last_year NUMERIC
);
