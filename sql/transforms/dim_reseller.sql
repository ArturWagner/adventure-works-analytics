-- dim_reseller.sql
-- Extract and transform DimReseller from AdventureWorks2022
-- Target: adventureworks.dim_reseller (BigQuery)
-- Strategy: full load (WRITE_TRUNCATE)

SELECT
    ResellerKey                     AS reseller_key,
    GeographyKey                    AS geography_key,
    ResellerAlternateKey            AS reseller_alternate_key,
    Phone                           AS phone,
    BusinessType                    AS business_type,
    ResellerName                    AS reseller_name,
    NumberEmployees                 AS number_employees,
    OrderFrequency                  AS order_frequency,
    OrderMonth                      AS order_month,
    FirstOrderYear                  AS first_order_year,
    LastOrderYear                   AS last_order_year,
    ProductLine                     AS product_line,
    AddressLine1                    AS address_line1,
    AddressLine2                    AS address_line2,
    AnnualSales                     AS annual_sales,
    BankName                        AS bank_name,
    MinPaymentType                  AS min_payment_type,
    MinPaymentAmount                AS min_payment_amount,
    AnnualRevenue                   AS annual_revenue,
    YearOpened                      AS year_opened
FROM AdventureWorks2022.dbo.DimReseller
