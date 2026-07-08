-- =================================================================================
-- Query Name: 02_Update_Oursales_modifiers
-- Description: Populates GFS StoreCodes into the B2C retail modifiers fact table 
--              (Oursales_modifiers) using an INNER JOIN with the Store master table.
-- Business Context: Aligns customizable add-on and topping sales data with the correct 
--                   distributor store codes, ensuring accurate cross-channel consumption gaps.
-- =================================================================================

UPDATE Oursales_modifiers
INNER JOIN Store ON Oursales_modifiers.Location = Store.OurName
SET Oursales_modifiers.StoreCode = Store.StoreCode;
