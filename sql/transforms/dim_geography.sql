SELECT sp.StateProvinceID AS geography_key, sp.Name AS state_province,
       sp.StateProvinceCode AS state_province_code, cr.Name AS country_region,
       sp.CountryRegionCode AS country_region_code, ISNULL(st.TerritoryID, 0) AS territory_key
FROM Person.StateProvince sp
INNER JOIN Person.CountryRegion cr ON sp.CountryRegionCode = cr.CountryRegionCode
LEFT JOIN Sales.SalesTerritory st ON sp.TerritoryID = st.TerritoryID
