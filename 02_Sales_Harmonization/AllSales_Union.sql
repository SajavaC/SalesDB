-- =================================================================================
-- Query Name: AllSales_Union
-- Description: Unifies multi-channel data flows by aligning B2C retail POS consumption 
--              with B2B wholesaler (GFS) physical shipment volumes.
-- Business Context: This is the core analytics data engine. It bridges front-of-house 
--                   sales and back-of-house logistics. Most importantly, it executes a 
--                   supply chain formulation—ROUND((Qty * Serving) / Size, 1)—to convert 
--                   retail portion servings into standardized wholesale case units (Cases), 
--                   enabling a true apples-to-apples quantity comparison.
-- =================================================================================

-- Channel 1: B2C Retail Sales Stream (Converted from portions into wholesale case equivalents)
SELECT 
    OurSoldQty.StoreCode AS StoreCode, 
    Store.GFSName AS StoreName,
    OurSoldQty.City AS City, 
    OurSoldQty.Province AS Province, 
    'OurSold' AS OrderedBy,
    OurSoldQty.ItemCode AS ItemCode,
    Item.ItemName AS ItemName,
    OurSoldQty.Month AS Month,
    ROUND((OurSoldQty.Qty * Item.Serving) / Item.Size, 1) AS SoldQty
FROM 
    (OurSoldQty 
    LEFT JOIN Store ON OurSoldQty.StoreCode = Store.StoreCode)
    LEFT JOIN Item ON OurSoldQty.ItemCode = Item.ItemCode

UNION ALL

-- Channel 2: B2B Wholesaler Distribution Stream (Actual inventory cases shipped)
SELECT
    GFSsales.StoreCode AS StoreCode,
    Store.GFSName AS StoreName,
    Store.City AS City,
    Store.Province AS Province,
    'GFSSold' AS OrderedBy,
    GFSsales.ItemCode AS ItemCode,
    Item.ItemName AS ItemName,
    GFSsales.Month AS Month,
    GFSsales.Qty AS SoldQty
FROM
    (GFSsales
    LEFT JOIN Store ON GFSsales.StoreCode = Store.StoreCode)
    LEFT JOIN Item ON GFSsales.ItemCode = Item.ItemCode;
