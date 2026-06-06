SELECT s.BusinessEntityID AS reseller_key, s.Name AS reseller_name,
       ISNULL(a.City, '') AS city, ISNULL(sp.Name, '') AS state_province,
       ISNULL(cr.Name, '') AS country_region,
       ISNULL(sp.CountryRegionCode, '') AS country_region_code,
       ISNULL(st.TerritoryID, 0) AS territory_key
FROM Sales.Store s
LEFT JOIN Person.BusinessEntityAddress bea ON s.BusinessEntityID = bea.BusinessEntityID AND bea.AddressTypeID = 3
LEFT JOIN Person.Address a ON bea.AddressID = a.AddressID
LEFT JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
LEFT JOIN Person.CountryRegion cr ON sp.CountryRegionCode = cr.CountryRegionCode
LEFT JOIN Sales.SalesTerritory st ON sp.TerritoryID = st.TerritoryID
