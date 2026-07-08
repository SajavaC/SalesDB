/*******************************************************************************
OBJECT NAME:    GFS_OrderCycle_ByItemStore
DESCRIPTION:    Executive Supply Chain View. Dynamically tracks store-level ordering 
                gaps, lifetime volume, and normalized demand velocity (Monthly/Weekly).
                Integrates automated exception handling to flag expansion bias.
AUTHOR:         Sajava Chang
DATE:           2026-07
TYPE:           Core Supply Chain Analytics Pipeline
DEPENDENCIES:   y_AllStoreItem, Store, y_GFS_OrderGaps, y_GFS_TotalStats
*******************************************************************************/

SELECT
    -- Basic Identification
    y_AllStoreItem.StoreCode,
    y_AllStoreItem.GFSName AS StoreName,
    y_AllStoreItem.ItemCode,
    y_AllStoreItem.ItemName,
    
    -- Temporal Lifespan Metrics
    Store.Start AS StoreOpenDate,
    DATEDIFF("m", Store.Start, (SELECT MAX(Month) FROM GFSsales)) + 1 AS MonthsSinceOpen,
    
    -- Order Gap Analytics
    ROUND(Stats.AvgGapMonths, 1) AS AvgGapMonths,
    Stats.MaxGapMonths,
    NZ(Stats.SampleSize, 0) AS SampleSize,
    
    -- Volumetric Baselines
    NZ(Totals.OrderCount, 0) AS OrderCount,
    NZ(Totals.TotalQty, 0) AS TotalQty,
    
    -- Dynamic Demand Velocity Formulas (Normalized by Store Age)
    IIF(DATEDIFF("m", Store.Start, (SELECT MAX(Month) FROM GFSsales)) + 1 <= 0, 
        NULL,
        ROUND(NZ(Totals.TotalQty, 0) / (DATEDIFF("m", Store.Start, (SELECT MAX(Month) FROM GFSsales)) + 1), 2)
    ) AS AvgQtyPerMonth,
    
    IIF(DATEDIFF("m", Store.Start, (SELECT MAX(Month) FROM GFSsales)) + 1 <= 0, 
        NULL,
        ROUND(NZ(Totals.TotalQty, 0) / ((DATEDIFF("m", Store.Start, (SELECT MAX(Month) FROM GFSsales)) + 1) * 4.33), 2)
    ) AS AvgQtyPerWeek,
    
    -- Automated Exception Guardrail & Store Lifecycle Flagging
    IIF(NZ(Stats.SampleSize, 0) = 0,
        IIF(DATEDIFF("m", Store.Start, (SELECT MAX(Month) FROM GFSsales)) < 3,
            "Too New",
            "No Orders"
        ),
        ""
    ) AS Flag

FROM
    (
        (
            y_AllStoreItem
            LEFT JOIN Store 
                ON y_AllStoreItem.StoreCode = Store.StoreCode
        )
        LEFT JOIN
            (
                SELECT
                    y_GFS_OrderGaps.StoreCode,
                    y_GFS_OrderGaps.ItemCode,
                    AVG(DATEDIFF("m", ThisMonth, NextOrderMonth)) AS AvgGapMonths,
                    MAX(DATEDIFF("m", ThisMonth, NextOrderMonth)) AS MaxGapMonths,
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
    )
    LEFT JOIN y_GFS_TotalStats AS Totals
        ON y_AllStoreItem.StoreCode = Totals.StoreCode
        AND y_AllStoreItem.ItemCode = Totals.ItemCode

WHERE
    Store.Active IS NOT NULL

ORDER BY 
    y_AllStoreItem.StoreCode, 
    y_AllStoreItem.ItemCode;
