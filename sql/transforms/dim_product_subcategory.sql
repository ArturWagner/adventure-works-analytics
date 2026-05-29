-- dim_product_subcategory.sql
-- Extract and transform DimProductSubcategory from AdventureWorks2022
-- Target: adventureworks.dim_product_subcategory (BigQuery)
-- Strategy: full load (WRITE_TRUNCATE)

SELECT
    ProductSubcategoryKey           AS product_subcategory_key,
    ProductSubcategoryAlternateKey  AS product_subcategory_alternate_key,
    ProductCategoryKey              AS product_category_key,
    EnglishProductSubcategoryName   AS subcategory_name
FROM AdventureWorks2022.dbo.DimProductSubcategory
