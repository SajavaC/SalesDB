-- ==================================================================================================================================================
-- Query Name:
-- Update_Oursales_items

-- Purpose:
-- Updates StoreCode in the imported POS main item sales table by matching store names with the master Store table.

-- Business Value:
-- Standardizes store identifiers so retail sales data can be accurately compared with distributor's purchasing records during downstream analysis.

-- Used By:
-- Oursales_items Table
-- ==================================================================================================================================================

UPDATE Oursales_items
INNER JOIN Store ON Oursales_items.Location = Store.OurName
SET Oursales_items.StoreCode = Store.StoreCode;
