-- =================================================================================
-- Description: Generates a comprehensive Cartesian Product (CROSS JOIN) encompassing 
--              every active store location and every master inventory item.
-- Business Context: Serves as the critical baseline structural scaffold for advanced windowing 
--                   analytics. By forcing a complete grid of all Store-to-Item combinations, 
--                   it ensures that downstream analytics can detect 'zero-order periods' (Data Gaps). 
--                   Without this cross-joined base table, skipped orders would disappear from logs, 
--                   severely corrupting store order frequency calculations.
-- USED BY:        GFS_OrderCycle_ByItemStore
-- =================================================================================

SELECT
    Store.StoreCode,
    Store.GFSName,
    Item.ItemCode,
    Item.ItemName
FROM 
    Store, 
    Item;
