-- ======================================================================================================================================================
-- Query Name:
-- check_NewStores

-- Purpose:
-- Identifies imported POS records whose store names cannot be matched to the master Store table.

-- Business Value:
-- Helps detect newly opened stores or store name changes before running monthly reports, preventing incomplete store mappings from affecting analysis.

-- Used By:
-- Manual data validation
-- ======================================================================================================================================================

SELECT 
    Location, 
    Month
FROM Oursales_items
WHERE StoreCode IS NULL
GROUP BY 
    Location, 
    Month;
