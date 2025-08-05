CREATE PROCEDURE SP_REPORT_32 AS

DECLARE @GetMaxRunningDate DATE = ISNULL(
    (SELECT MAX(CAST(PO_Date AS DATE)) FROM GOLD_WAREHOUSE.dbo.Report_32 WHERE DealerCategory = 'NON-AI'),
    '2019-09-01'
);
DECLARE @GetCurrentDate DATE = CAST(GETDATE() AS DATE);

-- Ambil daftar YearMonth
WITH YearMonths AS (
    SELECT DISTINCT LEFT(CONVERT(CHAR(8), DatePhysical, 112), 6) AS YearMonth
    FROM SILVER_WAREHOUSE.dbo.InventTrans
    WHERE dataAreaId != 'kzu'
      AND CAST(DatePhysical AS DATE) BETWEEN @GetMaxRunningDate AND @GetCurrentDate
)
SELECT * INTO #TempYearMonth FROM YearMonths;

-- Inisialisasi variabel loop
DECLARE @LoopYearMonth CHAR(6);
DECLARE @StarDate DATE, @MaxDate DATE;

-- Looping per bulan
WHILE EXISTS (SELECT TOP 1 1 FROM #TempYearMonth)
BEGIN
    SELECT TOP 1 @LoopYearMonth = YearMonth FROM #TempYearMonth ORDER BY YearMonth;

    SET @StarDate = DATEADD(MONTH, 1, DATEADD(YEAR, -1, DATEADD(MONTH, DATEDIFF(MONTH, '19000101', @LoopYearMonth + '01'), '19000101')));
    SET @MaxDate  = DATEADD(DAY, -1, DATEADD(MONTH, 1, @LoopYearMonth + '01'));

    DELETE FROM Report_32 
    WHERE CAST(PO_Date AS DATE) BETWEEN @StarDate AND @MaxDate
      AND DealerCategory = 'NON-AI';

    INSERT INTO Report_32
    SELECT  
        a.ORDERACCOUNT AS Vendor_ID, 
        a.PURCHNAME AS Vendor_Name, 
        a.CreatedDateTime1 AS PO_Date, 
        a.PURCHID AS PO_Number,
        'NON-AI' AS DealerCategory,
        a.dataAreaId AS dealer,
        l.Description AS nama_dealer,
        a.INVENTSITEID AS Outlet,	
        f.Name AS Nama_outlet,
        b.PurchaseOrderLineStatus AS StatusPO,
        b.ItemNumber AS Part_Number, 
        b.LineDescription AS Description, 
        b.OrderedPurchaseQuantity AS Qty_PO, 
        c.InvoiceId,
        c.Origpurchid,
        c.PurchaseLineLineNumber,
        c.Qty AS Qty_Invoice_GR, 
        i.DocumentDateGMTPlus7 AS Invoice_Date,
        i.TransDateGMTPlus7 AS GR_Date,
        e.Description AS Type_Order,
        f.ZIAMIArea AS Area, 
        GETDATE() AS Last_Update,
        b.LineAmount AS Amount_PO					
    FROM SILVER_WAREHOUSE.dbo.PurchaseOrderHeaderV2 a
    LEFT JOIN SILVER_WAREHOUSE.dbo.PurchaseOrderLineV2 b 
        ON b.PurchaseOrderNumber = a.PurchId AND b.dataAreaId = a.dataAreaId 
    LEFT JOIN (
        SELECT DISTINCT 
            x.OrigPurchId, x.dataAreaId, x.PurchaseLineLineNumber, x.Qty, x.InvoiceId
        FROM ZVendInvoiceTrans x 
        INNER JOIN ZVendInvoiceJours y ON x.InvoiceId = y.InvoiceId
    ) c ON c.OrigPurchId = b.PurchaseOrderNumber 
        AND c.dataAreaId = b.dataAreaId 
        AND c.PurchaseLineLineNumber = b.LineNumber
    LEFT JOIN PurchaseType e 
        ON e.PurchaseOrderType = a.ZPurchaseType AND e.dataAreaId = a.dataAreaId
    LEFT JOIN (
        SELECT o.ZIAMIArea , o.SiteId, o.Name 
        FROM ZInventSites o 
        INNER JOIN AddressState p ON o.ZProvinsi = p.State
    ) f ON f.SiteId = a.InventSiteId 
    LEFT JOIN SILVER_WAREHOUSE.dbo.ledger l ON l.name = a.dataAreaId 
    LEFT JOIN SILVER_WAREHOUSE.dbo.ZVendInvoiceInfoTable i ON i.Num = c.InvoiceId
    WHERE b.PurchaseOrderLineStatus = 'Invoiced'
      AND a.PurchaseOrderPoolId IN ('SP') 
      AND CAST(a.CreatedDateTime1 AS DATE) BETWEEN @StarDate AND @MaxDate;

    DELETE FROM GOLD_WAREHOUSE.dbo.Report_32_Summary 
    WHERE PO_Date BETWEEN @StarDate AND @MaxDate;

    INSERT INTO GOLD_WAREHOUSE.dbo.Report_32_Summary
    SELECT 
        PO_Date, Outlet, PurchID, Description, DealerCategory,
        Vendor_Name, Part_Number, SUM(Amount_PO) AS Amount_PO
    FROM GOLD_WAREHOUSE.dbo.Report_32
    WHERE PO_Date BETWEEN @StarDate AND @MaxDate
      AND DealerCategory = 'NON-AI'
    GROUP BY PO_Date, Outlet, PurchID, Description, DealerCategory, Vendor_Name, Part_Number;

    -- Hapus yearmonth yang sudah diproses
    DELETE FROM #TempYearMonth WHERE YearMonth = @LoopYearMonth;
END

DROP TABLE #TempYearMonth;