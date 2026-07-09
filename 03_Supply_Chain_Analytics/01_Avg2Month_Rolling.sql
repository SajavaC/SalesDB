-- ====================================================================================================================================================
-- Query Name:
-- Avg2Month_Rolling

-- Purpose:
-- Calculates a rolling two-month average for product quantities by combining the current month's data with the previous month's results.

-- Business Value:
-- Reduces the impact of monthly purchasing fluctuations, providing a more stable baseline for comparing product consumption with purchasing activity.

-- Used By:
-- Monthly Sales vs Purchasing Analysis
-- ====================================================================================================================================================

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
