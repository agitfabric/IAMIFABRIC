CREATE       PROCEDURE [dbo].[SP_REPORT_25] AS

DECLARE @GetMaxRunningDate DATE, @GetCurrentDate DATE
SELECT @GetMaxRunningDate =ISNULL(DATEADD(DAY,1,MAX(DatePhysical)), '2019-09-01'), @GetCurrentDate = CAST(DATEADD(hour,7,GETDATE() )AS DATE)
FROM GOLD_WAREHOUSE.dbo.Report_25 where kode_dealer != 'AI';

WITH temp_union AS (
    SELECT 
        a.DatePhysical AS DatePhysical,
        d.ZIAMIArea AS Area,
        a.dataAreaId AS kode_dealer,
        b.InventSiteId AS kode_outlet,
        e.Description AS Nama_Dealer,
        d.Name AS Nama_Outlet, -- Assuming the dealer name is the outlet name
        UPPER(f.ClassId) AS Segment_description,
        a.ItemId,
        UPPER(g.NameAlias) AS Type_Description,
        g.AMItemMinorGroupId AS Series,
        g.AMItemMajorGroupId AS cv_lcv,
        a.Qty AS Qty,
		f.ChassisNumber,
        c.ReferenceCategory,
        a.StatusReceipt,
        a.StatusIssue
    FROM SILVER_WAREHOUSE.dbo.InventTrans a
    INNER JOIN SILVER_WAREHOUSE.dbo.Dim b ON LOWER(a.inventDimId) = LOWER(b.inventDimId)
    INNER JOIN SILVER_WAREHOUSE.dbo.InventTransOrigin c ON LOWER(a.InventTransOrigin) = LOWER(c.RecId1)
    INNER JOIN SILVER_WAREHOUSE.dbo.ZInventSites d ON LOWER(b.InventSiteId) = LOWER(d.SiteId)
    INNER JOIN SILVER_WAREHOUSE.dbo.Ledger e ON LOWER(a.dataAreaId) = LOWER(e.Name)
    INNER JOIN SILVER_WAREHOUSE.dbo.DeviceTableMasters f ON LOWER(b.InventDimension1) = LOWER(f.MasterId)
    INNER JOIN (
        SELECT DISTINCT ItemId, AMItemMajorGroupId, AMItemMinorGroupId, dataAreaId, UPPER(NameAlias) AS NameAlias 
        FROM SILVER_WAREHOUSE.dbo.ZInventTables
    ) g ON LOWER(g.dataAreaId) = LOWER(a.dataAreaId) AND LOWER(g.ItemId) = LOWER(a.ItemId)
    WHERE 
       LOWER(a.dataAreaId) NOT IN ('kzu')

    UNION ALL
SELECT 
        k.BillingDate AS DatePhysical,
        b.ZIAMIArea AS Area,
        k.dataAreaId AS kode_dealer,
        k.Site AS kode_outlet,
        c.Description AS Nama_Dealer,
        b.Name AS Nama_Outlet,
        UPPER(g.ClassId) AS Segment_description,
        k.ItemId,
        UPPER(f.NameAlias) AS Type_Description,
        f.AMItemMinorGroupId AS Series,
        f.AMItemMajorGroupId AS cv_lcv,
        k.Qty AS Qty,
		g.ChassisNumber,
        NULL AS ReferenceCategory, -- No equivalent in DataBilling
        NULL AS StatusReceipt, -- No equivalent in DataBilling
        NULL AS StatusIssue -- No equivalent in DataBilling
    FROM SILVER_WAREHOUSE.dbo.ZDataBillingViews k
    LEFT JOIN SILVER_WAREHOUSE.dbo.ZInventSites b ON LOWER(k.dataAreaId) = LOWER(b.dataAreaId) AND LOWER(b.SiteId) = LOWER(k.Site)
    LEFT JOIN SILVER_WAREHOUSE.dbo.Ledger c ON LOWER(k.dataAreaId) = LOWER(c.Name)
    LEFT JOIN SILVER_WAREHOUSE.dbo.DeviceTableMasters g ON LOWER(g.MasterId) = LOWER(k.VIN )
    LEFT JOIN (
        SELECT DISTINCT ItemId, AMItemMajorGroupId, AMItemMinorGroupId, dataAreaId, NameAlias 
        FROM SILVER_WAREHOUSE.dbo.ZInventTables
    ) f ON LOWER(k.ItemId) = LOWER(f.ItemId) AND LOWER(f.dataAreaId) = LOWER(k.dataAreaId)
    WHERE 
        LOWER(k.dataAreaId) NOT IN ('kzu') 
        AND LOWER(k.IsCanceled) = 'no'),

    aggregated_stock AS (
    SELECT 
        DatePhysical,
        Area,
        kode_dealer,
        kode_outlet,
        Nama_Dealer,
        Nama_Outlet,
        Segment_description,
        ItemId,
        Type_Description,
        Series, 
        cv_lcv,
        ISNULL(SUM(CASE WHEN ReferenceCategory IS NULL THEN Qty END), 0) AS wholesale,
        ISNULL(SUM(CASE WHEN ReferenceCategory = 'Sales' THEN Qty END), 0) AS EUS,
        ISNULL(SUM(CASE WHEN ReferenceCategory = 'TransferOrderReceive' AND StatusReceipt = 'Purchased' THEN Qty END), 0) AS TransferIn,
        ISNULL(SUM(CASE WHEN ReferenceCategory = 'TransferOrderShip' AND StatusIssue = 'Sold' THEN Qty END), 0) AS TransferOut,
        ISNULL(SUM(CASE WHEN ReferenceCategory = 'InventTransaction' THEN Qty END), 0) AS Transactions
    FROM temp_union
    GROUP BY DatePhysical, Area, kode_dealer, kode_outlet, Nama_Dealer, Nama_Outlet, 
             Segment_description, ItemId, Type_Description, Series, cv_lcv
),

final_with_endstock AS (
    SELECT 
        *,
        (wholesale + EUS + TransferIn + TransferOut + Transactions) AS Endstock
    FROM aggregated_stock
),

final_with_beginstock AS (
    SELECT 
        *,
        LAG(Endstock) OVER (
            PARTITION BY Area, kode_dealer, kode_outlet, ItemId
            ORDER BY DatePhysical
        ) AS BeginStock
    FROM final_with_endstock
)

-- Final output
INSERT INTO GOLD_WAREHOUSE.dbo.Report_25
SELECT 
    DatePhysical,
    Area,
    Nama_Dealer,
    Nama_Outlet,
    Segment_description,
    ItemId,
    Type_Description,
    Series, 
    cv_lcv, 
    wholesale,
    EUS,
    TransferIn,
    TransferOut,
    Transactions,
    ISNULL(BeginStock, 0) AS BeginStock,
    ISNULL(BeginStock, 0) + wholesale + EUS + TransferIn + TransferOut + Transactions AS Endstock,
    GETDATE() as Last_update,
    kode_outlet,
    kode_dealer
FROM final_with_beginstock
where DatePhysical between @GetMaxRunningDate and @GetCurrentDate