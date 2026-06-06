-- dim_date.sql
-- Gera dimensão de datas a partir das datas de pedido do OLTP
-- Cobre todo o intervalo de OrderDate presente em Sales.SalesOrderHeader

WITH DateRange AS (
    SELECT
        CAST(MIN(OrderDate) AS DATE) AS min_date,
        CAST(MAX(OrderDate) AS DATE) AS max_date
    FROM Sales.SalesOrderHeader
),
Dates AS (
    SELECT min_date AS date_val FROM DateRange
    UNION ALL
    SELECT DATEADD(DAY, 1, date_val)
    FROM Dates
    WHERE date_val < (SELECT max_date FROM DateRange)
)
SELECT
    CONVERT(INT, CONVERT(VARCHAR, date_val, 112))   AS date_key,
    date_val                                         AS full_date,
    DATEPART(WEEKDAY, date_val)                      AS day_of_week,
    DATENAME(WEEKDAY, date_val)                      AS day_name,
    DAY(date_val)                                    AS day_of_month,
    DATEPART(DAYOFYEAR, date_val)                    AS day_of_year,
    DATEPART(WEEK, date_val)                         AS week_of_year,
    MONTH(date_val)                                  AS month_number,
    DATENAME(MONTH, date_val)                        AS month_name,
    DATEPART(QUARTER, date_val)                      AS calendar_quarter,
    YEAR(date_val)                                   AS calendar_year,
    CASE WHEN MONTH(date_val) <= 6 THEN 1 ELSE 2 END AS calendar_semester,
    DATEPART(QUARTER, date_val)                      AS fiscal_quarter,
    YEAR(date_val)                                   AS fiscal_year,
    CASE WHEN MONTH(date_val) <= 6 THEN 1 ELSE 2 END AS fiscal_semester
FROM Dates
OPTION (MAXRECURSION 10000)
