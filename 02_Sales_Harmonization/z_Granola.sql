-- =================================================================================
-- Query Name: z_Granola
-- Description: Maps consumer-facing recipe modifier choices (Granola) to a standardized 
--              B2B inventory item identifier (GFS ItemCode '1004443').
-- Business Context: Granola is treated as a customizable topping/modifier at the retail POS. 
--                   This query aggregates total modifier quantities across all locations 
--                   and transactional months, converting unstructured modifier clicks 
--                   into a clear raw material depletion stream for supply chain audits.
-- =================================================================================

SELECT
    Store.StoreCode AS StoreCode,
    Store.City AS City,
    Store.Province AS Province,
    '1004443' AS ItemCode,
    Oursales_modifiers.Month AS Month,
    SUM(Oursales_modifiers.[Qty sold]) AS Qty
FROM Oursales_modifiers 
INNER JOIN Store ON Store.StoreCode = Oursales_modifiers.StoreCode
WHERE
    Oursales_modifiers.Modifier LIKE '*Granola*'
GROUP BY
    Store.StoreCode, 
    Store.City, 
    Store.Province, 
    Oursales_modifiers.Month;
