-- =================================================================================
-- Query Name: z_12ozcup_Template
-- Description: Translates beverage portion size sales into physical cold cup inventory
--              depletion under GFS ItemCode '1519306'.
-- Business Context: In a smoothie chain, a 12oz beverage sale directly corresponds to 
--                   the depletion of a 12oz cold cup packaging unit. This query filters 
--                   all 12oz retail transactions while applying strict exclusion rules 
--                   (omitting hot drinks and coffee) to isolate cold-beverage plastic cup consumption.
-- =================================================================================

SELECT
    Store.StoreCode AS StoreCode,
    Store.City AS City,
    Store.Province AS Province,
    '1519306' AS ItemCode,
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
