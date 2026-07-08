-- =================================================================================
-- Query Name: Update_Oursales_items
-- Description: Enforces relational integrity post-import by populating the B2B StoreCode
--              into the B2C retail main product sales table (Oursales_items).
-- Business Context: Maps the messy frontend POS location names to standardized GFS distributor
--                   store codes, sealing data gaps before supply chain analysis begins.
-- =================================================================================

UPDATE Oursales_items
INNER JOIN Store ON Oursales_items.Location = Store.OurName
SET Oursales_items.StoreCode = Store.StoreCode;
