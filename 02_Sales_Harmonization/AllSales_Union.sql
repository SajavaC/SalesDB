/*******************************************************************************
Query Name:
AllSales_Union

Purpose:
Combines POS sales data and distributor's purchasing records into a single standardized
dataset.

Business Value:
Converts retail sales into equivalent wholesale case quantities, making it
possible to compare product consumption with purchasing activity across stores.

Used By:
Avg2Month_Rolling
Adj_CVR_Calculation
*******************************************************************************/

-- Channel 1: B2C Retail Sales Stream (Converted from portions into wholesale case equivalents)
SELECT 
    OurSoldQty.StoreCode AS StoreCode, 
    Store.DistributorName AS StoreName,
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
    Distributorsales.StoreCode AS StoreCode,
    Store.DistributorName AS StoreName,
    Store.City AS City,
    Store.Province AS Province,
    'DistributorSold' AS OrderedBy,
    Distributorsales.ItemCode AS ItemCode,
    Item.ItemName AS ItemName,
    Distributorsales.Month AS Month,
    Distributorsales.Qty AS SoldQty
FROM
    (Distributorsales
    LEFT JOIN Store ON Distributorsales.StoreCode = Store.StoreCode)
    LEFT JOIN Item ON Distributorsales.ItemCode = Item.ItemCode;
