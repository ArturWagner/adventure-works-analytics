-- dim_currency.sql
-- Extract and transform DimCurrency from AdventureWorks2022
-- Target: adventureworks.dim_currency (BigQuery)
-- Strategy: full load (WRITE_TRUNCATE)

SELECT
    CurrencyKey                     AS currency_key,
    CurrencyAlternateKey            AS currency_alternate_key,
    CurrencyName                    AS currency_name
FROM AdventureWorks2022.dbo.DimCurrency
