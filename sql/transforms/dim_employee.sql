SELECT e.BusinessEntityID AS employee_key,
       p.FirstName AS first_name, p.LastName AS last_name,
       p.FirstName + ' ' + p.LastName AS full_name, e.JobTitle AS job_title,
       e.HireDate AS hire_date, e.Gender AS gender,
       ISNULL(sp.TerritoryID, 0) AS territory_key,
       ISNULL(sp.SalesQuota, 0) AS sales_quota,
       ISNULL(sp.SalesYTD, 0) AS sales_ytd,
       ISNULL(sp.SalesLastYear, 0) AS sales_last_year
FROM HumanResources.Employee e
INNER JOIN Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
LEFT JOIN Sales.SalesPerson sp ON e.BusinessEntityID = sp.BusinessEntityID
