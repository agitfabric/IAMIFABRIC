CREATE PROCEDURE [dbo].[SP_REPORT_2]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

-- Inisialisasi tanggal
DECLARE @GetMaxRunningDate DATE = ISNULL((SELECT MAX(CAST(tanggal_invoice AS DATE)) FROM Report_2), '2019-09-01');
DECLARE @GetCurrentDate DATE = CAST(GETDATE() AS DATE);

-- Ambil daftar YearMonth yang akan diproses
WITH YearMonths AS (
    SELECT DISTINCT LEFT(CONVERT(CHAR(8), DatePhysical, 112), 6) AS YearMonth
    FROM InventTrans
    WHERE dataAreaId != 'kzu'
      AND CAST(DatePhysical AS DATE) BETWEEN @GetMaxRunningDate AND @GetCurrentDate
)
SELECT * INTO #TempYearMonth FROM YearMonths;

-- Variabel looping
DECLARE @LoopYearMonth CHAR(6);
DECLARE @StarDate DATE;
DECLARE @MaxDate DATE;

WHILE EXISTS (SELECT TOP 1 1 FROM #TempYearMonth)
BEGIN
    SELECT TOP 1 @LoopYearMonth = YearMonth FROM #TempYearMonth ORDER BY YearMonth ASC;

    SET @StarDate = DATEADD(MONTH, 1, DATEADD(YEAR, -1, DATEADD(MONTH, DATEDIFF(MONTH, '19000101', @LoopYearMonth + '01'), '19000101')));
    SET @MaxDate  = DATEADD(DAY, -1, DATEADD(MONTH, 1, @LoopYearMonth + '01'));

    DELETE FROM Report_2
    WHERE CAST(tanggal_invoice AS DATE) BETWEEN @StarDate AND @MaxDate;

    INSERT INTO Report_2
    SELECT 
        b.InventTransIdReturn, 
        a.SalesId, 
        b.ZSalesType, 
        a.dataAreaId, 
        d.ZDealerAfterSales, 
        b.InventSiteId, 
        d.Name, 
        d.AreaCode + '-' + d.ZIAMIArea AS Area, 
        b.SalesOrderLineStatus,
        a.SalesId AS SOReturn, 
        b.ZCreatedDateTime AS Tgl_SOReturn, 
        a.InvoiceDate AS tanggal_invoice, 
        a.InvoiceId AS No_InvoiceReturn,
        h.CreatedDateTime1 AS tanggalSPK, 
        h.SalesQuotationNumber AS SPK,
        f.ZSupervisor, 
        o2.Name AS nama_supervisor, 
        f.ZSalesman, 
        p2.Name AS nama_salesman, 
        j1.Name AS nama_customer, 
        i.ZSegmentation AS jenis_usaha,
        a.ItemId, 
        a.Qty, 
        k.AMItemMajorGroupId, 
        k.AMItemMinorGroupId AS tipe, 
        DM.ClassId,
        k.NameAlias AS nama_product, 
        o.Name AS warna, 
        m.EngineNumber AS no_mesin, 
        l.InventDimension1, 
        m.ChassisNumber AS no_rangka,
        f.ZLeasing, 
        q2.Name AS nama_leasing, 
        q.CustClassificationId AS group_leasing,
        s.OrderAccount AS kode_vendor_karoseri, 
        s3.Name AS Nama_Vendor_Karoseri, 
        e.ZKaroseriType AS jenis_karoseri, 
        g.InvoiceId AS NO_Referensi_Billing,
        g.InvoiceDate AS Tanggal_Invoice_yang_Dibatalkan, 
        GETDATE() AS Last_Update,
       ---[dbo].name_masking_function(j1.Name) AS MaskingName,
	    po.MaskedName as MaskingName
    FROM SILVER_WAREHOUSE.dbo.ZCustInvoiceTrans a
        INNER JOIN (
            SELECT 
                a.dataAreaId, a.InvoiceAccount, a.SalesId, a.ZCreatedDateTime, a.ZSalesType, a.InventSiteId,
                b.SalesOrderLineStatus, b.InventTransIdReturn, b.ItemNumber
            FROM SILVER_WAREHOUSE.dbo.ZSalesOrderHeader a
            INNER JOIN SILVER_WAREHOUSE.dbo.ZSalesOrderLine b ON b.SalesOrderNumber = a.SalesId AND b.SalesOrderLineStatus = 'Invoiced'
            INNER JOIN SILVER_WAREHOUSE.dbo.InventItemGroupItem c ON c.ItemId = b.ItemNumber AND c.ItemDataAreaId = b.dataAreaId AND c.ItemGroupId = 'FU01'
            WHERE a.SalesOrderPoolId = 'FU' AND a.ZSalesType = 'Return FU'
        ) b ON b.SalesId = a.SalesId
        INNER JOIN SILVER_WAREHOUSE.dbo.InventItemGroupItem c ON c.ItemId = a.ItemId AND c.ItemDataAreaId = a.dataAreaId AND c.ItemGroupId = 'FU01'
        LEFT JOIN SILVER_WAREHOUSE.dbo.DeviceModel DM ON c.ItemId = DM.ModelId
        LEFT JOIN SILVER_WAREHOUSE.dbo.ZInventSites d ON d.SiteId = b.InventSiteId
        LEFT JOIN SILVER_WAREHOUSE.dbo.ZSalesOrderLine e ON e.InventTransId = b.InventTransIdReturn
        LEFT JOIN SILVER_WAREHOUSE.dbo.ZSalesOrderHeader f ON f.SalesId = e.SalesOrderNumber AND f.SalesOrderPoolId = 'FU' AND f.ZSalesType != 'Return FU'
        LEFT JOIN SILVER_WAREHOUSE.dbo.ZCustInvoiceTrans g ON g.SalesId = e.SalesOrderNumber AND g.ItemId = a.ItemId
        LEFT JOIN SILVER_WAREHOUSE.dbo.SalesQuotationTable h ON h.SalesQuotationNumber = f.QuotationNumber
        LEFT JOIN SILVER_WAREHOUSE.dbo.OpportunityTable i ON i.OpportunityId = h.OpportunityId
        LEFT JOIN SILVER_WAREHOUSE.dbo.Worker o1 ON o1.PersonnelNumber = f.ZSupervisor
        LEFT JOIN SILVER_WAREHOUSE.dbo.DirPartyTable o2 ON o2.RecordId = o1.Person1
        LEFT JOIN SILVER_WAREHOUSE.dbo.Worker p1 ON p1.PersonnelNumber = f.ZSalesman
        LEFT JOIN SILVER_WAREHOUSE.dbo.DirPartyTable p2 ON p2.RecordId = p1.Person1
        LEFT JOIN SILVER_WAREHOUSE.dbo.ZCustomers j ON j.AccountNum = b.InvoiceAccount AND j.dataAreaId = b.dataAreaId
        LEFT JOIN SILVER_WAREHOUSE.dbo.DirPartyTable j1 ON j1.RecordId = j.Party
        LEFT JOIN SILVER_WAREHOUSE.dbo.ZInventTables k ON k.ItemId = a.ItemId AND k.dataAreaId = a.dataAreaId
        LEFT JOIN SILVER_WAREHOUSE.dbo.Dim l ON l.inventDimId = a.InventDimId AND l.dataAreaId = a.dataAreaId
        LEFT JOIN SILVER_WAREHOUSE.dbo.DeviceTableMasters m ON m.MasterId = l.InventDimension1
        LEFT JOIN SILVER_WAREHOUSE.dbo.DeviceTable n ON n.DeviceId = l.InventDimension1 AND n.dataAreaId = l.dataAreaId
        LEFT JOIN SILVER_WAREHOUSE.dbo.DeviceGroup o ON o.DeviceGroupId = n.DeviceGroupId AND o.dataAreaId = n.dataAreaId
        LEFT JOIN SILVER_WAREHOUSE.dbo.ZCustomers q ON q.AccountNum = f.ZLeasing AND q.dataAreaId = f.dataAreaId
        LEFT JOIN SILVER_WAREHOUSE.dbo.DirPartyTable q2 ON q2.RecordId = q.Party
        LEFT JOIN SILVER_WAREHOUSE.dbo.PurchaseOrderLineV2 r ON r.InventRefId = f.SalesId AND LEFT(r.ItemNumber, 4) IN ('FU02') AND r.InventRefId != ''
        LEFT JOIN SILVER_WAREHOUSE.dbo.PurchaseOrderHeaderV2 s ON s.PurchId = r.PurchaseOrderNumber AND r.dataAreaId = s.dataAreaId
        LEFT JOIN SILVER_WAREHOUSE.dbo.VendTable s2 ON s2.VendorAccountNumber = s.OrderAccount AND s2.dataAreaId = s.dataAreaId
        LEFT JOIN SILVER_WAREHOUSE.dbo.DirPartyTable s3 ON s3.RecordId = s2.Party
		CROSS APPLY SILVER_WAREHOUSE.dbo.name_masking_function(j1.Name) as po
    WHERE CAST(a.InvoiceDate AS DATE) BETWEEN @StarDate AND @MaxDate;

    DELETE FROM #TempYearMonth WHERE YearMonth = @LoopYearMonth;
END

-- Bersihkan tabel sementara
DROP TABLE #TempYearMonth

END