-- fact_reseller_sales.sql
-- Extract and transform FactResellerSales from AdventureWorks2022
-- Target: adventureworks.fact_reseller_sales (BigQuery)
-- Strategy: full load (WRITE_TRUNCATE)
-- Partitioning: OrderDateKey (configured in BigQuery schema)

SELECT
    ProductKey                      AS product_key,
    OrderDateKey                    AS order_date_key,
    DueDateKey                      AS due_date_key,
    ShipDateKey                     AS ship_date_key,
    ResellerKey                     AS reseller_key,
    EmployeeKey                     AS employee_key,
    PromotionKey                    AS promotion_key,
    CurrencyKey                     AS currency_key,
    SalesTerritoryKey               AS sales_territory_key,
    SalesOrderNumber                AS sales_order_number,
    SalesOrderLineNumber            AS sales_order_line,
    RevisionNumber                  AS revision_number,
    OrderQuantity                   AS order_quantity,
    UnitPrice                       AS unit_price,
    ExtendedAmount                  AS extended_amount,
    UnitPriceDiscountPct            AS unit_price_discount_pct,
    DiscountAmount                  AS discount_amount,
    ProductStandardCost             AS product_standard_cost,
    TotalProductCost                AS total_product_cost,
    SalesAmount                     AS sales_amount,
    TaxAmt                          AS tax_amount,
    Freight                         AS freight,
    CarrierTrackingNumber           AS carrier_tracking_number,
    CustomerPONumber                AS customer_po_number,
    OrderDate                       AS order_date,
    DueDate                         AS due_date,
    ShipDate                        AS ship_date
FROM AdventureWorks2022.dbo.FactResellerSales
