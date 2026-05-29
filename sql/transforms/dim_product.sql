-- dim_product.sql
-- Extract and transform DimProduct from AdventureWorks2022
-- Target: adventureworks.dim_product (BigQuery)
-- Strategy: full load (WRITE_TRUNCATE)

SELECT
    ProductKey                      AS product_key,
    ProductAlternateKey             AS product_alternate_key,
    ProductSubcategoryKey           AS product_subcategory_key,
    WeightUnitMeasureCode           AS weight_unit_measure_code,
    SizeUnitMeasureCode             AS size_unit_measure_code,
    EnglishProductName              AS product_name,
    StandardCost                    AS standard_cost,
    FinishedGoodsFlag               AS finished_goods_flag,
    Color                           AS color,
    SafetyStockLevel                AS safety_stock_level,
    ReorderPoint                    AS reorder_point,
    ListPrice                       AS list_price,
    Size                            AS size,
    SizeRange                       AS size_range,
    Weight                          AS weight,
    DaysToManufacture               AS days_to_manufacture,
    ProductLine                     AS product_line,
    DealerPrice                     AS dealer_price,
    Class                           AS class,
    Style                           AS style,
    EnglishDescription              AS description,
    StartDate                       AS start_date,
    EndDate                         AS end_date,
    Status                          AS status
FROM AdventureWorks2022.dbo.DimProduct
