-- ============================================================================================================================
-- Query Name:
-- z_1CupBag_Template

-- Purpose:
-- Consolidates bag sales recorded as either main menu items or POS modifiers into a single inventory item.

-- Used By:
-- OurSoldQty.sql
-- ============================================================================================================================

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
        'Demo_Code_002' AS ItemCode,
        SUM(Oursales_items.[Units sold]) AS Qty2
    FROM Oursales_items
    WHERE (Item LIKE '*Reusable OAK BAG*') OR (Item LIKE '*OakBerry Bag*')
    GROUP BY StoreCode, Month

    UNION ALL

    -- Section 2: Extract bag usage from customer transaction modifiers
    SELECT 
        StoreCode, 
        Month,
        'Demo_Code_002' AS ItemCode,
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
