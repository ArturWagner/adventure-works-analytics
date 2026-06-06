-- dim_product.sql
SELECT
    p.ProductID                                     AS product_key,
    p.Name                                          AS product_name,
    p.ProductNumber                                 AS product_number,
    ISNULL(p.Color, 'N/A')                         AS color,
    ISNULL(p.Size, 'N/A')                          AS size,
    ISNULL(CAST(p.Weight AS FLOAT), 0)             AS weight,
    p.ListPrice                                     AS list_price,
    p.StandardCost                                  AS standard_cost,
    ISNULL(p.ProductLine, 'N/A')                   AS product_line,
    ISNULL(ps.Name, 'N/A')                         AS subcategory_name,
    ISNULL(pc.Name, 'N/A')                         AS category_name,
    ISNULL(ps.ProductSubcategoryID, 0)             AS subcategory_key,
    ISNULL(pc.ProductCategoryID, 0)                AS category_key,
    p.SellStartDate                                 AS sell_start_date,
    p.SellEndDate                                   AS sell_end_date
FROM Production.Product p
LEFT JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
LEFT JOIN Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
