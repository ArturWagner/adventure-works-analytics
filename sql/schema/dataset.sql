-- Bootstrap do dataset AdventureWorks no BigQuery.
-- Aplicar via: bq query --project_id=unigran-tcc < sql/schema/dataset.sql
CREATE SCHEMA IF NOT EXISTS `unigran-tcc.adventureworks`;
