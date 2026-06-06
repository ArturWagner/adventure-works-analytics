SELECT SpecialOfferID AS promotion_key, Description AS promotion_name,
       DiscountPct AS discount_pct, Type AS promotion_type, Category AS promotion_category,
       StartDate AS start_date, EndDate AS end_date,
       MinQty AS min_qty, ISNULL(MaxQty, 0) AS max_qty
FROM Sales.SpecialOffer
