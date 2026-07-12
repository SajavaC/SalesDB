-- ===============================================================================================================================================================================================
-- Query Name:
-- Distributor_OrderCycle_ByItem_6M

-- Purpose:
-- Summarizes purchasing behavior for each product across all stores over the most recent six months, including ordering frequency, purchasing intervals, and average purchasing volumes.

-- Business Value:
-- Provides a high-level view of product purchasing trends, supporting inventory planning, procurement decisions, and demand forecasting.

-- Note:
-- Monthly and weekly averages are calculated using a fixed six-month period. Stores that opened recently may have slightly lower averages because inactive months are included in the calculation.

-- Used By:
-- Monthly Product Purchasing Summary Report
-- ===============================================================================================================================================================================================

SELECT
    -- Product Identification
    y_Distributor_OrderGaps.ItemCode,
    Item.ItemName,
    
    -- Aggregate Order Gap Analytics (Rolling Window)
    ROUND(AVG(DATEDIFF("m", ThisMonth, NextOrderMonth)), 1) AS AvgGapMonths,
    MAX(DATEDIFF("m", ThisMonth, NextOrderMonth)) AS MaxGapMonths,
    COUNT(*) AS SampleSize,
    
    -- Rolling 6-Month Volumetric Baselines
    NZ(Totals.OrderCount, 0) AS OrderCount,
    NZ(Totals.TotalQty, 0) AS TotalQty,
    
    -- Fixed-Window Velocity Calculations (Macro Baseline)
    ROUND(NZ(Totals.TotalQty, 0) / 6, 2) AS AvgQtyPerMonth,
    ROUND(NZ(Totals.TotalQty, 0) / (6 * 4.33), 2) AS AvgQtyPerWeek

FROM
    (
        (
            y_Distributor_OrderGaps
            LEFT JOIN Item 
                ON y_Distributor_OrderGaps.ItemCode = Item.ItemCode
        )
        INNER JOIN Store 
            ON y_Distributor_OrderGaps.StoreCode = Store.StoreCode
    )
    LEFT JOIN
        (
            SELECT
                G.ItemCode,
                COUNT(*) AS OrderCount,
                SUM(G.Qty) AS TotalQty
            FROM 
                Distributorsales AS G
                INNER JOIN Store AS S 
                    ON G.StoreCode = S.StoreCode
            WHERE 
                S.Active IS NOT NULL
                AND G.Month >= DATEADD("m", -5, (SELECT MAX(Month) FROM Distributorsales))
            GROUP BY 
                G.ItemCode
        ) AS Totals
            ON y_Distributor_OrderGaps.ItemCode = Totals.ItemCode

WHERE
    y_Distributor_OrderGaps.NextOrderMonth IS NOT NULL
    AND Store.Active IS NOT NULL
    AND y_Distributor_OrderGaps.ThisMonth >= DATEADD("m", -5, (SELECT MAX(Month) FROM Distributorsales))

GROUP BY
    y_Distributor_OrderGaps.ItemCode, 
    Item.ItemName, 
    Totals.OrderCount, 
    Totals.TotalQty;
