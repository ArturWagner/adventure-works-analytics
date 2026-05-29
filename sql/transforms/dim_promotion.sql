-- dim_promotion.sql
-- Extract and transform DimPromotion from AdventureWorks2022
-- Target: adventureworks.dim_promotion (BigQuery)
-- Strategy: full load (WRITE_TRUNCATE)

SELECT
    PromotionKey                    AS promotion_key,
    PromotionAlternateKey           AS promotion_alternate_key,
    EnglishPromotionName            AS promotion_name,
    EnglishPromotionType            AS promotion_type,
    EnglishPromotionCategory        AS promotion_category,
    StartDate                       AS start_date,
    EndDate                         AS end_date,
    MinQty                          AS min_qty,
    MaxQty                          AS max_qty,
    DiscountPct                     AS discount_pct
FROM AdventureWorks2022.dbo.DimPromotion
