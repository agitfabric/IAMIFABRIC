CREATE PROCEDURE [dbo].[SP_CleansingSOUnit]
AS
BEGIN
    SET NOCOUNT ON;

    -- Temp table to hold relevant InventTransIdReturn values
     -- Temp table to hold relevant InventTransIdReturn values
  SELECT DISTINCT 
    a.InventTransIdReturn,
    zol.SalesOrderNumber AS salesId,
    zor.SalesOrderNumber AS salesIdreturned
INTO #ReturnData
FROM ZSalesOrderLine a
LEFT JOIN InventItemGroupItem b 
    ON b.ItemDataAreaId = a.dataAreaId 
    AND b.ItemId = a.ItemNumber
LEFT JOIN ZSalesOrderLine zol 
    ON zol.InventTransIdReturn = a.InventTransIdReturn
LEFT JOIN ZSalesOrderLine zor 
    ON zor.InventTransId = a.InventTransIdReturn
WHERE a.dataAreaId != 'kzu' 
    AND b.ItemGroupId = 'FU01' 
    AND a.InventTransIdReturn != '' 
    AND CAST(a.ModifiedDateTime1 AS DATE) >= DATEADD(DAY, -800, GETDATE());

-- STEP 2: Update ZSalesOrderLine
UPDATE zol
SET zol.IsReturn = 1
FROM ZSalesOrderLine zol
INNER JOIN #ReturnData r 
    ON zol.InventTransIdReturn = r.InventTransIdReturn
WHERE zol.IsReturn = 0;

-- STEP 3: Update Report_1 by salesId
UPDATE r1
SET r1.IsReturn = 1
FROM GOLD_WAREHOUSE.dbo.Report_1 r1
INNER JOIN #ReturnData r 
    ON r1.nomer_SO = r.salesId
WHERE r1.IsReturn = 0;

-- STEP 4: Update Report_1 by salesIdreturned
UPDATE r1
SET r1.IsReturn = 1
FROM GOLD_WAREHOUSE.dbo.Report_1 r1
INNER JOIN #ReturnData r 
    ON r1.nomer_SO = r.salesIdreturned
WHERE r1.IsReturn = 0;

-- OPTIONAL: Bersihkan temp table
DROP TABLE IF EXISTS #ReturnData;

END