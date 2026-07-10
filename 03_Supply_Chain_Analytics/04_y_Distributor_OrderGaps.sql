-- ====================================================================================================================
-- Query Name:
-- y_Distributor_OrderGaps

-- Purpose:
-- Calculates the time between consecutive purchases for each product at each store.

-- Business Value:
-- Measures ordering intervals, providing the foundation for purchasing behavior analysis and order cycle calculations.

-- Used By:
-- Distributor_OrderCycle_ByItemStore
-- Distributor_OrderCycle_ByItem_6M
-- ====================================================================================================================

SELECT
    G1.StoreCode,
    G1.ItemCode,
    G1.Month AS ThisMonth,
    (
        -- Correlated Subquery acting as a simulated LEAD() window function
        SELECT MIN(G2.Month)
        FROM Distributorsales AS G2
        WHERE G2.StoreCode = G1.StoreCode
          AND G2.ItemCode = G1.ItemCode
          AND G2.Month > G1.Month
    ) AS NextOrderMonth
FROM 
    Distributorsales AS G1;
