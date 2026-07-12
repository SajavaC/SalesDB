-- ====================================================================================================================
-- Query Name:
-- y_Distributor_TotalStats

-- Purpose:
-- Summarizes total purchase quantities and total order counts for each product at each store.

-- Business Value:
-- Provides baseline purchasing statistics used to calculate ordering frequency, average purchasing volume, and long-term purchasing behavior.

-- Used By:
-- Distributor_OrderCycle_ByItemStore.sql
-- ====================================================================================================================

SELECT
    StoreCode,
    ItemCode,
    COUNT(*) AS OrderCount,
    SUM(Qty) AS TotalQty
FROM 
    Distributorsales
GROUP BY 
    StoreCode, 
    ItemCode;
