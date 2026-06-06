-- fact_internet_sales.sql
-- Vendas online (OnlineOrderFlag=1): Sales.SalesOrderHeader + SalesOrderDetail

SELECT
    od.ProductID                                                        AS product_key,
    CONVERT(INT, CONVERT(VARCHAR, oh.OrderDate, 112))                  AS order_date_key,
    CONVERT(INT, CONVERT(VARCHAR, oh.DueDate, 112))                    AS due_date_key,
    CONVERT(INT, CONVERT(VARCHAR, oh.ShipDate, 112))                   AS ship_date_key,
    oh.CustomerID                                                       AS customer_key,
    ISNULL(sop.SpecialOfferID, 1)                                      AS promotion_key,
    ISNULL(
        (SELECT TOP 1 ToCurrencyCode FROM Sales.CurrencyRate
         WHERE CurrencyRateID = oh.CurrencyRateID), 'USD')             AS currency_key,
    oh.TerritoryID                                                      AS sales_territory_key,
    oh.SalesOrderNumber                                                 AS sales_order_number,
    od.SalesOrderDetailID                                               AS sales_order_line,
    od.OrderQty                                                         AS order_quantity,
    od.UnitPrice                                                        AS unit_price,
    od.UnitPrice * od.OrderQty                                         AS extended_amount,
    od.UnitPrice * (1 - od.UnitPriceDiscount) * od.OrderQty           AS sales_amount,
    oh.TaxAmt / NULLIF(oh.SubTotal, 0) * od.LineTotal                 AS tax_amount,
    oh.Freight   / NULLIF(oh.SubTotal, 0) * od.LineTotal              AS freight,
    p.StandardCost * od.OrderQty                                       AS total_product_cost,
    oh.OrderDate                                                        AS order_date,
    oh.DueDate                                                          AS due_date,
    oh.ShipDate                                                         AS ship_date
FROM Sales.SalesOrderHeader oh
INNER JOIN Sales.SalesOrderDetail od
    ON oh.SalesOrderID = od.SalesOrderID
INNER JOIN Sales.SpecialOfferProduct sop
    ON od.ProductID = sop.ProductID
    AND od.SpecialOfferID = sop.SpecialOfferID
INNER JOIN Production.Product p
    ON od.ProductID = p.ProductID
WHERE oh.OnlineOrderFlag = 1
