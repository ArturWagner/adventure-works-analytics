SELECT ps.ProductSubcategoryID AS product_subcategory_key, ps.Name AS subcategory_name,
       pc.ProductCategoryID AS category_key, pc.Name AS category_name
FROM Production.ProductSubcategory ps
INNER JOIN Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
