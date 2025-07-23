CREATE PROCEDURE [dbo].[SP_REPORT_32]
AS
BEGIN
SET NOCOUNT ON;

    DECLARE 
        @GetMaxRunningDate date = ISNULL(
            (SELECT MAX(CAST(PO_Date AS date)) FROM Report_32 WHERE DealerCategory = 'NON-AI'),
            '2019-09-01'
        ),
        @GetCurrentDate date = CAST(GETDATE() AS date);

    -- Generate all unique YearMonth values from InventTrans
    WITH YearMonths AS (
        SELECT DISTINCT LEFT(CONVERT(char, DatePhysical, 112), 6) AS YearMonth
        FROM SILVER_WAREHOUSE.dbo.InventTrans
        WHERE dataAreaId != 'kzu' 
          AND CAST(DatePhysical AS date) BETWEEN @GetMaxRunningDate AND @GetCurrentDate
    ),
    DateRanges AS (
        SELECT 
            ym.YearMonth,
            CAST(DATEADD(MONTH, 1, DATEADD(YEAR, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, ym.YearMonth + '01'), 0))) AS date) AS StartDate,
            CAST(DATEADD(DAY, -1, DATEADD(MONTH, 1, ym.YearMonth + '01')) AS date) AS EndDate
        FROM YearMonths ym
    ) 
     -- Delete and insert per month range
    DELETE r
    FROM Report_32 r
    JOIN DateRanges d ON CAST(r.PO_Date AS date) BETWEEN d.StartDate AND d.EndDate
    WHERE r.DealerCategory = 'NON-AI';

    INSERT INTO Report_32
    SELECT 
        a.OrderAccount AS Vendor_ID, 
        a.PurchName AS Vendor_Name, 
        a.CreatedDateTime1 AS PO_Date, 
        a.PurchId AS PO_Number,
        'NON-AI' AS DealerCategory,
        a.dataAreaId AS dealer,
        l.Description AS nama_dealer,
        a.InventSiteId AS Outlet,    
        f.Name AS Nama_outlet,
        b.PurchaseOrderLineStatus AS StatusPO,
        b.ItemNumber AS Part_Number, 
        b.LineDescription AS Description, 
        b.OrderedPurchaseQuantity AS Qty_PO, 
        c.InvoiceId,
        c.OrigPurchId,
        c.PurchaseLineLineNumber,
        c.Qty AS Qty_Invoice_GR, 
        null as Invoie_Date,--i.DocumentDateGMTPlus7 AS Invoice_Date,
        null as GR_Date,--i.TransDateGMTPlus7 AS GR_Date,
        e.Description AS Type_Order,
        f.ZIAMIArea AS Area, 
        GETDATE() AS Last_Update,
        b.LineAmount AS Amount_PO
    FROM SILVER_WAREHOUSE.dbo.PurchaseOrderHeaderV2 a
    LEFT JOIN SILVER_WAREHOUSE.dbo.PurchaseOrderLineV2 b 
        ON b.PurchaseOrderNumber = a.PurchId AND b.dataAreaId  = a.dataAreaId 
    LEFT JOIN (
        SELECT DISTINCT 
            x.OrigPurchId, x.dataAreaId, x.PurchaseLineLineNumber, x.Qty, y.InvoiceDate, x.InvoiceId
        FROM SILVER_WAREHOUSE.dbo.ZVendInvoiceTrans x
        INNER JOIN SILVER_WAREHOUSE.dbo.ZVendInvoiceJours y ON x.InvoiceId = y.InvoiceId
    ) c 
        ON c.OrigPurchId = b.PurchaseOrderNumber 
        AND c.dataAreaId = b.dataAreaId 
        AND c.PurchaseLineLineNumber = b.LineNumber
    LEFT JOIN SILVER_WAREHOUSE.dbo.PurchaseType e 
        ON e.PurchaseOrderType = a.ZPurchaseType AND e.dataAreaId = a.dataAreaId
    LEFT JOIN (
        SELECT o.ZIAMIArea, o.SiteId, o.Name 
        FROM SILVER_WAREHOUSE.dbo.ZInventSites o 
        INNER JOIN SILVER_WAREHOUSE.dbo.AddressState p ON o.ZProvinsi = p.State
    ) f 
        ON f.SiteId = a.InventSiteId 
    LEFT JOIN SILVER_WAREHOUSE.dbo.Ledger l 
        ON l.Name = a.dataAreaId 
    --LEFT JOIN SILVER_WAREHOUSE.dbo.ZVendInvoiceInfoTable i 
        --ON i.Num = c.InvoiceId
    --INNER JOIN DateRanges dr
        --ON CAST(a.CreatedDateTime1 AS date) BETWEEN dr.StartDate AND dr.EndDate
    WHERE b.PurchaseOrderLineStatus = 'Invoiced'
      AND a.PurchaseOrderPoolId IN ('SP');

    DELETE rs
    FROM Report_32_Summary rs
    JOIN DateRanges dr ON rs.PO_Date BETWEEN dr.StartDate AND dr.EndDate;

    INSERT INTO Report_32_Summary
    SELECT 
        PO_Date, 
        Outlet, 
        PurchID, 
        Description, 
        DealerCategory,
        Vendor_Name, 
        Part_Number, 
        SUM(Amount_PO) AS Amount_PO
    FROM Report_32
    WHERE DealerCategory = 'NON-AI'
      --AND PO_Date BETWEEN (SELECT MIN(StartDate) FROM DateRanges) AND (SELECT MAX(EndDate) FROM DateRanges)
    GROUP BY 
        PO_Date, 
        Outlet, 
        PurchID, 
        Description, 
        DealerCategory,
        Vendor_Name, 
        Part_Number;
END