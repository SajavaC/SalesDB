-- ===========================================================================================================================================================
-- Query Name:
-- Distributor_OrderCycle_ByItemStore

-- Purpose:
-- Analyzes purchasing behavior for each product at the individual store level, including ordering frequency, purchasing intervals, total purchases, and
-- average weekly and monthly purchasing volumes.

-- Business Value:
-- Provides store-level purchasing insights that help identify unusual ordering patterns, long gaps between purchases, and differences in purchasing behavior
-- across stores. Newly opened stores are also flagged to avoid misleading comparisons.

-- Used By:
-- Expected_Demand_Pattern.sql
-- No_Demand_Items.sql
-- Store purchasing behavior analysis
-- ===========================================================================================================================================================

SELECT
    -- Basic Identification
    y_AllStoreItem.StoreCode,
    y_AllStoreItem.DistributorName AS StoreName,
    y_AllStoreItem.ItemCode,
    y_AllStoreItem.ItemName,
    
    -- Temporal Lifespan Metrics
    Store.Start AS StoreOpenDate,
    DATEDIFF("m", Store.Start, (SELECT MAX(Month) FROM Distributorsales)) + 1 AS MonthsSinceOpen,
    
    -- Order Gap Analytics
    ROUND(Stats.AvgGapMonths, 1) AS AvgGapMonths,
    Stats.MaxGapMonths,
    NZ(Stats.SampleSize, 0) AS SampleSize,
    
    -- Volumetric Baselines
    NZ(Totals.OrderCount, 0) AS OrderCount,
    NZ(Totals.TotalQty, 0) AS TotalQty,
    
    -- Dynamic Demand Velocity Formulas (Normalized by Store Age)
    IIF(DATEDIFF("m", Store.Start, (SELECT MAX(Month) FROM Distributorsales)) + 1 <= 0, 
        NULL,
        ROUND(NZ(Totals.TotalQty, 0) / (DATEDIFF("m", Store.Start, (SELECT MAX(Month) FROM Distributorsales)) + 1), 2)
    ) AS AvgQtyPerMonth,
    
    IIF(DATEDIFF("m", Store.Start, (SELECT MAX(Month) FROM Distributorsales)) + 1 <= 0, 
        NULL,
        ROUND(NZ(Totals.TotalQty, 0) / ((DATEDIFF("m", Store.Start, (SELECT MAX(Month) FROM Distributorsales)) + 1) * 4.33), 2)
    ) AS AvgQtyPerWeek,
    
    -- Automated Exception Guardrail & Store Lifecycle Flagging
    IIF(NZ(Stats.SampleSize, 0) = 0,
        IIF(DATEDIFF("m", Store.Start, (SELECT MAX(Month) FROM Distributorsales)) < 3,
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
                    y_Distributor_OrderGaps.StoreCode,
                    y_Distributor_OrderGaps.ItemCode,
                    AVG(DATEDIFF("m", ThisMonth, NextOrderMonth)) AS AvgGapMonths,
                    MAX(DATEDIFF("m", ThisMonth, NextOrderMonth)) AS MaxGapMonths,
                    COUNT(*) AS SampleSize
                FROM 
                    y_Distributor_OrderGaps
                WHERE 
                    NextOrderMonth IS NOT NULL
                GROUP BY 
                    y_Distributor_OrderGaps.StoreCode, 
                    y_Distributor_OrderGaps.ItemCode
            ) AS Stats
                ON y_AllStoreItem.StoreCode = Stats.StoreCode
                AND y_AllStoreItem.ItemCode = Stats.ItemCode
    )
    LEFT JOIN y_Distributor_TotalStats AS Totals
        ON y_AllStoreItem.StoreCode = Totals.StoreCode
        AND y_AllStoreItem.ItemCode = Totals.ItemCode

WHERE
    Store.Active IS NOT NULL

ORDER BY 
    y_AllStoreItem.StoreCode, 
    y_AllStoreItem.ItemCode;
