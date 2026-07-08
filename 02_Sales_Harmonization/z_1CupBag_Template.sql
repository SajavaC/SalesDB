-- =================================================================================
-- Query Name: z_1CupBag_Template
-- Description: Harmonizes multi-channel packaging consumption by consolidating retail 
--              bag sales and modifier selections into a single standardized GFS ItemCode.
-- Business Context: In a smoothie chain, packaging (like reusable or paper bags) can be 
--                   triggered either as a main line item or as a checkout modifier. This 
--                   query unifies both revenue streams into GFS Item '1519483' and applies 
--                   an operational formula to convert front-of-house usage to supply chain metrics.
-- =================================================================================

SELECT
    Store.StoreCode AS StoreCode,
    Store.City AS City,
    Store.Province AS Province,
    A.ItemCode,
    A.Month,
    ROUND((SUM(A.Qty2) * 2) / 3) AS Qty
FROM (
    -- Section 1: Extract bag usage from main line-item retail sales
    SELECT 
        StoreCode, 
        Month,
        '1519483' AS ItemCode,
        SUM(Oursales_items.[Units sold]) AS Qty2
    FROM Oursales_items
    WHERE (Item LIKE '*Reusable OAK BAG*') OR (Item LIKE '*OakBerry Bag*')
    GROUP BY StoreCode, Month

    UNION ALL

    -- Section 2: Extract bag usage from customer transaction modifiers
    SELECT 
        StoreCode, 
        Month,
        '1519483' AS ItemCode,
        SUM([Qty sold]) AS Qty2
    FROM Oursales_modifiers 
    WHERE Modifier LIKE '*YES*BAG*'
    GROUP BY StoreCode, Month
) AS A 
INNER JOIN Store ON Store.StoreCode = A.StoreCode
GROUP BY
    Store.StoreCode, 
    Store.City, 
    Store.Province, 
    A.ItemCode, 
    A.Month;
