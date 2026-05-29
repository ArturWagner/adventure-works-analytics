-- dim_date.sql
-- Extract and transform DimDate from AdventureWorks2022
-- Target: adventureworks.dim_date (BigQuery)
-- Strategy: full load (WRITE_TRUNCATE)

SELECT
    DateKey                         AS date_key,
    FullDateAlternateKey            AS full_date,
    DayNumberOfWeek                 AS day_of_week,
    EnglishDayNameOfWeek            AS day_name,
    DayNumberOfMonth                AS day_of_month,
    DayNumberOfYear                 AS day_of_year,
    WeekNumberOfYear                AS week_of_year,
    MonthNumberOfYear               AS month_number,
    EnglishMonthName                AS month_name,
    CalendarQuarter                 AS calendar_quarter,
    CalendarYear                    AS calendar_year,
    CalendarSemester                AS calendar_semester,
    FiscalQuarter                   AS fiscal_quarter,
    FiscalYear                      AS fiscal_year,
    FiscalSemester                  AS fiscal_semester
FROM AdventureWorks2022.dbo.DimDate
