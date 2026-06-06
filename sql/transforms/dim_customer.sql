-- dim_customer.sql
-- Clientes: Sales.Customer + Person.Person + Person.Address + geolocalização

SELECT
    c.CustomerID                                    AS customer_key,
    p.FirstName                                     AS first_name,
    p.LastName                                      AS last_name,
    p.FirstName + ' ' + p.LastName                 AS full_name,
    ISNULL(ea.EmailAddress, '')                     AS email_address,
    ISNULL(a.City, '')                              AS city,
    ISNULL(sp.Name, '')                             AS state_province,
    ISNULL(cr.Name, '')                             AS country_region,
    ISNULL(sp.CountryRegionCode, '')                AS country_region_code,
    ISNULL(a.PostalCode, '')                        AS postal_code,
    c.TerritoryID                                   AS territory_key
FROM Sales.Customer c
LEFT JOIN Person.Person p
    ON c.PersonID = p.BusinessEntityID
LEFT JOIN Person.EmailAddress ea
    ON p.BusinessEntityID = ea.BusinessEntityID
LEFT JOIN Person.BusinessEntityAddress bea
    ON p.BusinessEntityID = bea.BusinessEntityID
    AND bea.AddressTypeID = 2
LEFT JOIN Person.Address a
    ON bea.AddressID = a.AddressID
LEFT JOIN Person.StateProvince sp
    ON a.StateProvinceID = sp.StateProvinceID
LEFT JOIN Person.CountryRegion cr
    ON sp.CountryRegionCode = cr.CountryRegionCode
WHERE c.PersonID IS NOT NULL
