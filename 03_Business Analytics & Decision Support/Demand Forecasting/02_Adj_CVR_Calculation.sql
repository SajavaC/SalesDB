-- ====================================================================================================================================================
-- Query Name:
-- Adj_CVR_Calculation

-- Purpose:
-- Calculates the adjusted conversion rate using sales performance data from the latest three months.

-- Business Value:
-- Provides a consumption factor that estimates material usage based on recent sales performance, supporting demand forecasting and inventory planning.

-- Used By:
-- Monthly demand forecasting
-- ====================================================================================================================================================

SELECT 
    Item.ItemName,
    ROUND(
        (A.TotalQty * Item.Serving * Item.AdjFactor) / (
            -- Dynamic Subquery: Computes total net sales for the trailing 3 months
            SELECT SUM([Net sales]) AS TotalNetSales
            FROM Oursales_items
            WHERE Month >= DateAdd("m", -3, (SELECT MAX(Month) FROM Oursales_items))
              AND Month <= (SELECT MAX(Month) FROM Oursales_items)
        ), 4
    ) AS Adj_CVR
FROM Item 
LEFT JOIN (
    -- Aggregates physical consumption volume over the same trailing 3-month window
    SELECT 
        ItemCode, 
        SUM(Qty) AS TotalQty
    FROM OurSoldQty
    WHERE Month >= DateAdd("m", -3, (SELECT MAX(Month) FROM OurSoldQty))
      AND Month <= (SELECT MAX(Month) FROM OurSoldQty)
    GROUP BY ItemCode
) AS A ON A.ItemCode = Item.ItemCode;
