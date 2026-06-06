SELECT TerritoryID AS sales_territory_key, Name AS territory_name,
       CountryRegionCode AS country_region_code, [Group] AS territory_group,
       SalesYTD AS sales_ytd, SalesLastYear AS sales_last_year
FROM Sales.SalesTerritory
