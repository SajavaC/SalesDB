-- ==============================================================================================================
-- Query Name:
-- Expected_Demand_Pattern
--
-- Purpose:
-- Calculates the average purchasing pattern for each product based on stores with normal ordering behavior.
--
-- Business Value:
-- Establishes a baseline purchasing pattern for each product, supporting demand forecasting and helping identify
-- stores whose purchasing behavior differs from the typical network average.
--
-- Used By:
-- Demand forecasting
-- ==============================================================================================================

SELECT 
    ItemName,
    ROUND(AVG(AvgGapMonths), 1)   AS AvgGapMonths_ALL,
    ROUND(AVG(AvgQtyPerMonth), 1) AS AvgQtyPerMonth_ALL,
    ROUND(AVG(AvgQtyPerWeek), 1)  AS AvgQtyPerWeek_ALL
FROM 
    Distributor_OrderCycle_ByItemStore
WHERE 
    Flag = "" 
GROUP BY 
    ItemName
ORDER BY 
    ROUND(AVG(AvgGapMonths), 1) DESC;
