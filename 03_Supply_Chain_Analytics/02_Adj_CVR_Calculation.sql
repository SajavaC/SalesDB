-- =================================================================================
-- Query Name: 02_Adj_CVR_Calculation
-- Description: Computes the dynamic conversion rate (Adj_CVR) per dollar of net sales 
--              over a trailing 3-month window, incorporating operational adjustment factors.
-- Business Context: Translates micro-level ingredient consumption into macro financial metrics.
--                   By dividing total physical material usage (adjusted via AdjFactor for store
--                   waste and variance) by aggregate net revenue, this metric determines the 
--                   exact material footprint per dollar of sales, providing an automated foundation 
--                   for rolling inventory demand forecasting.
-- =================================================================================

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
