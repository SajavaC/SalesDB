-- ===================================================================================================================================================
-- Query Name:
-- No_Demand_Items
--
-- Purpose:
-- Identifies distributor items that have never been purchased by existing stores, excluding newly opened locations.
--
-- Business Value:
-- Highlights products with little or no demand across the store network, supporting assortment reviews, inventory planning, and purchasing decisions.
--
-- Used By:
-- Product demand analysis
-- Store purchasing behavior analysis
-- ===================================================================================================================================================

SELECT 
    ItemName,
    COUNT(OrderCount) AS NeverOrderedStoreCount
FROM 
    Distributor_OrderCycle_ByItemStore
WHERE 
    (Flag <> "Too New") 
    AND (OrderCount = 0)
GROUP BY 
    ItemName
ORDER BY 
    COUNT(OrderCount) DESC;
