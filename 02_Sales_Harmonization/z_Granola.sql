/*******************************************************************************
Query Name:
z_Granola

Purpose:
Converts Granola modifier sales into standardized inventory consumption.

Business Value:
Aggregates topping selections from POS transactions into estimated raw material
usage, allowing ingredient consumption to be compared with purchasing records.

Used By:
OurSoldQty
*******************************************************************************/

SELECT
    Store.StoreCode AS StoreCode,
    Store.City AS City,
    Store.Province AS Province,
    'Demo_Code_003' AS ItemCode,
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
