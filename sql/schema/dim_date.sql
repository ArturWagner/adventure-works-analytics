-- Source: sql/transforms/dim_date.sql
-- Aplicar via: bq query --project_id=unigran-tcc < sql/schema/dim_date.sql
CREATE TABLE IF NOT EXISTS `unigran-tcc.adventureworks.dim_date` (
  date_key          INT64   NOT NULL,
  full_date         DATE    NOT NULL,
  day_of_week       INT64,
  day_name          STRING,
  day_of_month      INT64,
  day_of_year       INT64,
  week_of_year      INT64,
  month_number      INT64,
  month_name        STRING,
  calendar_quarter  INT64,
  calendar_year     INT64,
  calendar_semester INT64,
  fiscal_quarter    INT64,
  fiscal_year       INT64,
  fiscal_semester   INT64
);
