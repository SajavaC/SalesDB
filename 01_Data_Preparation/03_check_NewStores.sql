-- =================================================================================
-- Query Name: check_NewStores
-- Description: Exception monitoring query that identifies unmapped retail locations
--              where StoreCode remains NULL after the update process.
-- Business Context: Serves as an automated data governance check. If a new store opens 
--                   or a store name changes in GoParrot, this query flags it immediately, 
--                   preventing incomplete data from corrupting downstream inventory reconciliation.
-- =================================================================================

SELECT 
    Location, 
    Month
FROM Oursales_items
WHERE StoreCode IS NULL
GROUP BY 
    Location, 
    Month;
