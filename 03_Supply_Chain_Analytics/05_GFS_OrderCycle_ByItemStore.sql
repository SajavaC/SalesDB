-- =================================================================================
-- Query Name: 05_GFS_OrderCycle_ByItemStore
-- Description: Compiles the final supply chain order lead-time variance table, calculating 
--              average and maximum inventory procurement cycles per store-item combination.
-- Business Context: This is the ultimate analytical dashboard view. By synthesizing the 
--                   Cartesian grid (y_AllStoreItem) and the look-ahead sequence table (y_GFS_OrderGaps), 
--                   it isolates the Average Gap (Order Frequency) and Maximum Gap (Peak Supply Risk). 
--                   This enables supply chain managers to optimize safety stock parameters, auditing 
--                   distributor MOQ compliance while red-flagging locations at high risk of stockouts.
-- =================================================================================

SELECT
    y_AllStoreItem.StoreCode,
    y_AllStoreItem.GFSName AS StoreName,
    y_AllStoreItem.ItemCode,
    y_AllStoreItem.ItemName,
    ROUND(Stats.AvgGapMonths, 1) AS AvgGapMonths,
    Stats.MaxGapMonths,
    Nz(Stats.SampleSize, 0) AS SampleSize
FROM
    y_AllStoreItem
LEFT JOIN
    (
        -- Aggregates intervals between sequential order placements using DateDiff
        SELECT
            y_GFS_OrderGaps.StoreCode,
            y_GFS_OrderGaps.ItemCode,
            AVG(DateDiff("m", ThisMonth, NextOrderMonth)) AS AvgGapMonths,
            MAX(DateDiff("m", ThisMonth, NextOrderMonth)) AS MaxGapMonths,
            COUNT(*) AS SampleSize
        FROM 
            y_GFS_OrderGaps
        WHERE 
            NextOrderMonth IS NOT NULL
        GROUP BY 
            y_GFS_OrderGaps.StoreCode, 
            y_GFS_OrderGaps.ItemCode
    ) AS Stats 
    ON y_AllStoreItem.StoreCode = Stats.StoreCode
    AND y_AllStoreItem.ItemCode = Stats.ItemCode
ORDER BY 
    y_AllStoreItem.StoreCode, 
    y_AllStoreItem.ItemCode;
