-- dim_geography.sql
-- Extract and transform DimGeography from AdventureWorks2022
-- Target: adventureworks.dim_geography (BigQuery)
-- Strategy: full load (WRITE_TRUNCATE)

SELECT
    GeographyKey                    AS geography_key,
    City                            AS city,
    StateProvinceCode               AS state_province_code,
    StateProvinceName               AS state_province_name,
    CountryRegionCode               AS country_region_code,
    EnglishCountryRegionName        AS country_region_name,
    PostalCode                      AS postal_code,
    SalesTerritoryKey               AS sales_territory_key,
    IpAddressLocator                AS ip_address_locator
FROM AdventureWorks2022.dbo.DimGeography
