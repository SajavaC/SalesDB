-- =================================================================================
-- Query Name: y_GFS_OrderGaps
-- Description: Simulates the SQL 'LEAD()' window function within an MS Access environment 
--              using a high-performance Correlated Subquery.
-- Business Context: In order cycle analysis, we must calculate the time elapsed between 
--                   a store's current order and its subsequent order. Since MS Access lacks 
--                   native window function support, this query programmatically looks ahead 
--                   by finding the absolute minimum month (MIN) that is strictly greater than 
--                   the active record's month, isolating the next chronological purchase event.
-- USED BY: GFS_OrderCycle_ByItemStore
-- =================================================================================

SELECT
    G1.StoreCode,
    G1.ItemCode,
    G1.Month AS ThisMonth,
    (
        -- Correlated Subquery acting as a simulated LEAD() window function
        SELECT MIN(G2.Month)
        FROM GFSsales AS G2
        WHERE G2.StoreCode = G1.StoreCode
          AND G2.ItemCode = G1.ItemCode
          AND G2.Month > G1.Month
    ) AS NextOrderMonth
FROM 
    GFSsales AS G1;
