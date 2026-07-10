-- ================================================================================================================================
-- Query Name:
-- z_12ozcup_Template

-- Purpose:
-- Converts qualifying 12oz beverage sales into estimated 12oz cold cup consumption.

-- Used By:
-- OurSoldQty
-- ================================================================================================================================

SELECT
    Store.StoreCode AS StoreCode,
    Store.City AS City,
    Store.Province AS Province,
    'Demo_Code_001' AS ItemCode,
    Oursales_items.Month AS Month,
    SUM(Oursales_items.[Units sold]) AS Qty
FROM Oursales_items 
INNER JOIN Store ON Store.StoreCode = Oursales_items.StoreCode
WHERE
    (Oursales_items.Item LIKE '*12 oz*' OR Oursales_items.Item LIKE '*12oz*')
    AND Oursales_items.Category NOT LIKE '*Hot Drinks*'
    AND Oursales_items.Category NOT LIKE '*OAKOFFEE*'
GROUP BY
    Store.StoreCode, 
    Store.City, 
    Store.Province, 
    Oursales_items.Month;
