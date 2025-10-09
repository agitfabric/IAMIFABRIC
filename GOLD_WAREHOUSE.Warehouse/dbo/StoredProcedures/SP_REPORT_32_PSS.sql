CREATE     PROCEDURE SP_REPORT_32_PSS AS

DECLARE @GetMaxRunningDate DATE = ISNULL(
    (SELECT MAX(CAST(PO_Date AS DATE)) FROM GOLD_WAREHOUSE.dbo.Report_32 WHERE DealerCategory = 'AI'),
    '2019-09-01'
);
DECLARE @GetCurrentDate DATE = CAST(GETDATE() AS DATE);

-- Ambil daftar YearMonth dari InventTrans
WITH YearMonths AS (
    SELECT DISTINCT LEFT(CONVERT(CHAR(8), DatePhysical, 112), 6) AS YearMonth
    FROM SILVER_WAREHOUSE.dbo.InventTrans
    WHERE LOWER(dataAreaId) != 'kzu'
      AND CAST(DatePhysical AS DATE) BETWEEN @GetMaxRunningDate AND @GetCurrentDate
)
SELECT * INTO #TempYearMonth_32_PSS FROM YearMonths;

-- Inisialisasi variabel loop
DECLARE @LoopYearMonth CHAR(6);
DECLARE @StarDate DATE, @MaxDate DATE;

-- Loop per bulan
WHILE EXISTS (SELECT TOP 1 1 FROM #TempYearMonth_32_PSS)
BEGIN
    SELECT TOP 1 @LoopYearMonth = YearMonth FROM #TempYearMonth_32_PSS ORDER BY YearMonth;

    SET @StarDate = DATEADD(MONTH, 1, DATEADD(YEAR, -1, DATEADD(MONTH, DATEDIFF(MONTH, '19000101', @LoopYearMonth + '01'), '19000101')));
    SET @MaxDate  = DATEADD(DAY, -1, DATEADD(MONTH, 1, @LoopYearMonth + '01'));

    DELETE FROM GOLD_WAREHOUSE.dbo.Report_32 
    WHERE CAST(PO_Date AS DATE) BETWEEN @StarDate AND @MaxDate
      AND DealerCategory = 'AI';

    INSERT INTO GOLD_WAREHOUSE.dbo.Report_32
    SELECT  
        a.data_vendorNo AS Vendor_ID, 
        a.data_vendorName AS Vendor_Name,
        CAST(a.data_timestamp AS DATE) AS PO_Date, 
        a.data_poNo AS PO_Number, 
        'AI' AS DealerCategory,
        d.Dealer AS dealer,
        d.DealerName AS nama_dealer,  
        c.SiteCode AS Outlet, 
        d.SiteName AS Nama_outlet,
        a.data_poStatus AS StatusPO, 
        a.data_items_itemNo AS Part_Number, 
        LEFT(a.data_items_productName, 255) AS Description, 
        a.data_items_qty AS Qty_PO, 
        MAX(b.data_invoiceNo) AS InvoiceId, 
        a.data_poNo AS Origpurchid, 
        1 AS PurchaseLineLineNumber,
        ISNULL(SUM(b.data_items_qty), 0) AS Qty_Invoice_GR, 
        CAST(ISNULL(MAX(b.data_grDate), '1900-01-01') AS DATE) AS Invoice_Date,  
        CAST(ISNULL(MAX(b.data_grDate), '1900-01-01') AS DATE) AS GR_Date,
        e.Description AS Type_Order, 
        d.Area AS Area, 
        GETDATE() AS Last_update, 
        NULL AS Amount_PO
    FROM SILVER_WAREHOUSE.dbo.Sparepart_purchaseOrderPart a
    LEFT JOIN SILVER_WAREHOUSE.dbo.Sparepart_invoicePurchaseOrder b 
        ON LOWER(b.data_salesOrderNo) = LOWER(a.data_poNo)
       AND LOWER(b.data_items_item) = LOWER(a.data_items_itemNo)
    LEFT JOIN SILVER_WAREHOUSE.dbo.site_mapping c 
        ON LOWER(c.SiteCodePSS) = LOWER(a.data_site)
    LEFT JOIN SILVER_WAREHOUSE.dbo.ZAISITES d 
        ON LOWER(d.SiteCode) = LOWER(c.SiteCode)
    LEFT JOIN SILVER_WAREHOUSE.dbo.PurchaseType e 
        ON LOWER(e.PurchaseOrderType) = LOWER(a.data_poType) AND LOWER(e.dataAreaId) = 'zir'
    WHERE a.data_items_flagDeletion = 0 
      AND UPPER(a.data_items_itemGroup) = 'SP01'
      AND CAST(a.data_timestamp AS DATE) BETWEEN @StarDate AND @MaxDate
    GROUP BY 
        a.data_vendorNo, a.data_vendorName, CAST(a.data_timestamp AS DATE), a.data_poNo, 
        d.Dealer, d.DealerName, a.data_site, c.SiteCode, d.SiteName,
        a.data_poStatus, a.data_items_itemNo, a.data_items_productName, 
        a.data_items_qty, a.data_poNo, e.Description, d.Area
    ORDER BY c.SiteCode, CAST(a.data_timestamp AS DATE);

    -- Hapus YearMonth yang sudah diproses
    DELETE FROM #TempYearMonth_32_PSS WHERE YearMonth = @LoopYearMonth;
END

DROP TABLE #TempYearMonth_32_PSS;