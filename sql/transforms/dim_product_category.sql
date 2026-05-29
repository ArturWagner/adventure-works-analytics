-- dim_product_category.sql
-- Extract and transform DimProductCategory from AdventureWorks2022
-- Target: adventureworks.dim_product_category (BigQuery)
-- Strategy: full load (WRITE_TRUNCATE)

SELECT
    ProductCategoryKey              AS product_category_key,
    ProductCategoryAlternateKey     AS product_category_alternate_key,
    EnglishProductCategoryName      AS category_name
FROM AdventureWorks2022.dbo.DimProductCategory
