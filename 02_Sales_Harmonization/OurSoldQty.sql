-- ===========================================================================================================================================================
-- Query Name:
-- OurSoldQty

-- Purpose:
-- Combines all mapped products and modifiers into a single retail consumption dataset.

-- Business Value:
-- Creates a standardized dataset representing product consumption across all stores. The production version contains mappings for all menu items, while this
-- repository includes representative examples that demonstrate the overall ETL approach.

-- Used By:
-- AllSales_Union
-- ===========================================================================================================================================================

SELECT * FROM z_12ozcup_Template
UNION ALL
SELECT * FROM z_1CupBag_Template
UNION ALL
SELECT * FROM z_Granola;
