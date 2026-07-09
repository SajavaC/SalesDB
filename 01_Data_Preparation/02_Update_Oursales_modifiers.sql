-- ==============================================================================
-- Query Name:
-- Update_Oursales_modifiers

-- Purpose:
-- Updates StoreCode in the imported POS modifier sales table by matching store
-- names with the master Store table.

-- Business Value:
-- Ensures modifier sales are assigned to the correct stores, allowing ingredient
-- consumption to be analyzed together with purchasing data.

-- Used By:
-- AllSales_Union
-- ==============================================================================

UPDATE Oursales_modifiers
INNER JOIN Store ON Oursales_modifiers.Location = Store.OurName
SET Oursales_modifiers.StoreCode = Store.StoreCode;
