-- =================================================================================
-- Query Name: 01_Avg2Month_Rolling
-- Description: Calculates a 60-day rolling moving average for multi-channel sales volume
--              by executing a controlled Self-Join on the combined sales dataset.
-- Business Context: Retail consumption and wholesale ordering are notoriously volatile 
--                   due to shipping delays and batch ordering patterns. This query applies 
--                   data smoothing logic, pairing the current month with the previous month 
--                   and utilizing the Nz() function to handle cold-start edge cases, providing 
--                   the supply chain with a stable baseline for inventory audits.
-- =================================================================================

SELECT
    A.StoreCode,
    A.StoreName,
    A.City,
    A.Province,
    A.OrderedBy,
    A.ItemCode,
    A.ItemName,
    A.Month,
    B.Month AS PrevMonth,
    B.SoldQty AS PrevQty,
    A.SoldQty,
    ROUND((A.SoldQty + Nz(B.SoldQty, 0)) / 2, 2) AS Avg2Month
FROM
    AllSales AS A
LEFT JOIN
    AllSales AS B 
ON 
    A.StoreCode = B.StoreCode
    AND A.OrderedBy = B.OrderedBy
    AND A.ItemCode = B.ItemCode
    AND B.Month = DateAdd("m", -1, A.Month);
