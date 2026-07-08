-- =================================================================================
-- Query Name: OurSoldQty
-- Description: Consolidates all independently mapped retail products and modifiers 
--              into a single unified retail sales depletion dataset.
-- Architecture Note [CRITICAL]: 
--   In the production environment, this query performs a comprehensive UNION ALL 
--   across dozens of item-level mappings (z_queries). For the purpose of this 
--   GitHub repository, we have selected three core architectural pillars as a 
--   demonstrative slice:
--     1. Packaging/Main Item Layer (z_1CupBag)
--     2. Volume-to-Unit Layer (z_12ozcup)
--     3. Recipe Modifier/Topping Layer (z_Granola)
--   This provides full transparency into our ETL methodologies without redundant code.
-- =================================================================================

SELECT * FROM z_12ozcup_Template
UNION ALL
SELECT * FROM z_1CupBag_Template
UNION ALL
SELECT * FROM z_Granola;
