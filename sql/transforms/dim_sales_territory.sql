-- dim_sales_territory.sql
-- Extract and transform DimSalesTerritory from AdventureWorks2022
-- Target: adventureworks.dim_sales_territory (BigQuery)
-- Strategy: full load (WRITE_TRUNCATE)

SELECT
    SalesTerritoryKey               AS sales_territory_key,
    SalesTerritoryAlternateKey      AS sales_territory_alternate_key,
    SalesTerritoryRegion            AS territory_region,
    SalesTerritoryCountry           AS territory_country,
    SalesTerritoryGroup             AS territory_group,
    SalesTerritoryImage             AS territory_image
FROM AdventureWorks2022.dbo.DimSalesTerritory
