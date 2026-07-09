/*******************************************************************************
Query Name:
y_AllStoreItem

Purpose:
Generates every possible combination of active stores and inventory items.

Business Value:
Ensures stores with no purchasing activity are still included in downstream
analysis, making it possible to identify missing orders and calculate ordering
patterns accurately.

Used By:
Distributor_OrderCycle_ByItemStore
*******************************************************************************/

SELECT
    Store.StoreCode,
    Store.DistributorName,
    Item.ItemCode,
    Item.ItemName
FROM 
    Store, 
    Item;
