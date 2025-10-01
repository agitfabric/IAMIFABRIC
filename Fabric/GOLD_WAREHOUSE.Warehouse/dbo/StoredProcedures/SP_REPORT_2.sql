CREATE PROCEDURE [dbo].[SP_REPORT_2]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

-- Inisialisasi tanggal
DECLARE @GetMaxRunningDate DATE = ISNULL((SELECT MAX(CAST(tanggal_invoice AS DATE)) FROM Report_2), '2019-09-01');
DECLARE @GetCurrentDate DATE = CAST(DATEADD(HOUR, 7, GETDATE()) AS DATE);

-- Ambil daftar YearMonth yang akan diproses
WITH YearMonths AS (
    SELECT DISTINCT LEFT(CONVERT(CHAR(8), DatePhysical, 112), 6) AS YearMonth
    FROM SILVER_WAREHOUSE.dbo.InventTrans
    WHERE dataAreaId COLLATE Latin1_General_CI_AS != 'kzu' COLLATE Latin1_General_CI_AS
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
        DATEADD(HOUR, 7, GETDATE()) AS Last_Update,
        po.MaskedName as MaskingName
    FROM SILVER_WAREHOUSE.dbo.ZCustInvoiceTrans a
        INNER JOIN (
            SELECT 
                a.dataAreaId, a.InvoiceAccount, a.SalesId, a.ZCreatedDateTime, a.ZSalesType, a.InventSiteId,
                b.SalesOrderLineStatus, b.InventTransIdReturn, b.ItemNumber
            FROM SILVER_WAREHOUSE.dbo.ZSalesOrderHeader a
            INNER JOIN SILVER_WAREHOUSE.dbo.ZSalesOrderLine b 
                ON b.SalesOrderNumber COLLATE Latin1_General_CI_AS = a.SalesId COLLATE Latin1_General_CI_AS 
                AND b.SalesOrderLineStatus COLLATE Latin1_General_CI_AS = 'Invoiced' COLLATE Latin1_General_CI_AS
            INNER JOIN SILVER_WAREHOUSE.dbo.InventItemGroupItem c 
                ON c.ItemId COLLATE Latin1_General_CI_AS = b.ItemNumber COLLATE Latin1_General_CI_AS 
                AND c.ItemDataAreaId COLLATE Latin1_General_CI_AS = b.dataAreaId COLLATE Latin1_General_CI_AS 
                AND c.ItemGroupId COLLATE Latin1_General_CI_AS = 'FU01' COLLATE Latin1_General_CI_AS
            WHERE a.SalesOrderPoolId COLLATE Latin1_General_CI_AS = 'FU' COLLATE Latin1_General_CI_AS 
              AND a.ZSalesType COLLATE Latin1_General_CI_AS = 'Return FU' COLLATE Latin1_General_CI_AS
        ) b ON b.SalesId COLLATE Latin1_General_CI_AS = a.SalesId COLLATE Latin1_General_CI_AS
        INNER JOIN SILVER_WAREHOUSE.dbo.InventItemGroupItem c 
            ON c.ItemId COLLATE Latin1_General_CI_AS = a.ItemId COLLATE Latin1_General_CI_AS 
            AND c.ItemDataAreaId COLLATE Latin1_General_CI_AS = a.dataAreaId COLLATE Latin1_General_CI_AS 
            AND c.ItemGroupId COLLATE Latin1_General_CI_AS = 'FU01' COLLATE Latin1_General_CI_AS
        LEFT JOIN SILVER_WAREHOUSE.dbo.DeviceModel DM 
            ON c.ItemId COLLATE Latin1_General_CI_AS = DM.ModelId COLLATE Latin1_General_CI_AS
        LEFT JOIN SILVER_WAREHOUSE.dbo.ZInventSites d 
            ON d.SiteId COLLATE Latin1_General_CI_AS = b.InventSiteId COLLATE Latin1_General_CI_AS
        LEFT JOIN SILVER_WAREHOUSE.dbo.ZSalesOrderLine e 
            ON e.InventTransId COLLATE Latin1_General_CI_AS = b.InventTransIdReturn COLLATE Latin1_General_CI_AS
        LEFT JOIN SILVER_WAREHOUSE.dbo.ZSalesOrderHeader f 
            ON f.SalesId COLLATE Latin1_General_CI_AS = e.SalesOrderNumber COLLATE Latin1_General_CI_AS 
            AND f.SalesOrderPoolId COLLATE Latin1_General_CI_AS = 'FU' COLLATE Latin1_General_CI_AS 
            AND f.ZSalesType COLLATE Latin1_General_CI_AS != 'Return FU' COLLATE Latin1_General_CI_AS
        LEFT JOIN SILVER_WAREHOUSE.dbo.ZCustInvoiceTrans g 
            ON g.SalesId COLLATE Latin1_General_CI_AS = e.SalesOrderNumber COLLATE Latin1_General_CI_AS 
            AND g.ItemId COLLATE Latin1_General_CI_AS = a.ItemId COLLATE Latin1_General_CI_AS
        LEFT JOIN SILVER_WAREHOUSE.dbo.SalesQuotationTable h 
            ON h.SalesQuotationNumber COLLATE Latin1_General_CI_AS = f.QuotationNumber COLLATE Latin1_General_CI_AS
        LEFT JOIN SILVER_WAREHOUSE.dbo.OpportunityTable i 
            ON i.OpportunityId COLLATE Latin1_General_CI_AS = h.OpportunityId COLLATE Latin1_General_CI_AS
        LEFT JOIN SILVER_WAREHOUSE.dbo.Worker o1 
            ON o1.PersonnelNumber COLLATE Latin1_General_CI_AS = f.ZSupervisor COLLATE Latin1_General_CI_AS
        LEFT JOIN SILVER_WAREHOUSE.dbo.DirPartyTable o2 ON o2.RecordId = o1.Person1
        LEFT JOIN SILVER_WAREHOUSE.dbo.Worker p1 
            ON p1.PersonnelNumber COLLATE Latin1_General_CI_AS = f.ZSalesman COLLATE Latin1_General_CI_AS
        LEFT JOIN SILVER_WAREHOUSE.dbo.DirPartyTable p2 ON p2.RecordId = p1.Person1
        LEFT JOIN SILVER_WAREHOUSE.dbo.ZCustomers j 
            ON j.AccountNum COLLATE Latin1_General_CI_AS = b.InvoiceAccount COLLATE Latin1_General_CI_AS 
            AND j.dataAreaId COLLATE Latin1_General_CI_AS = b.dataAreaId COLLATE Latin1_General_CI_AS
        LEFT JOIN SILVER_WAREHOUSE.dbo.DirPartyTable j1 ON j1.RecordId = j.Party
        LEFT JOIN SILVER_WAREHOUSE.dbo.ZInventTables k 
            ON k.ItemId COLLATE Latin1_General_CI_AS = a.ItemId COLLATE Latin1_General_CI_AS 
            AND k.dataAreaId COLLATE Latin1_General_CI_AS = a.dataAreaId COLLATE Latin1_General_CI_AS
        LEFT JOIN SILVER_WAREHOUSE.dbo.Dim l 
            ON l.inventDimId COLLATE Latin1_General_CI_AS = a.InventDimId COLLATE Latin1_General_CI_AS 
            AND l.dataAreaId COLLATE Latin1_General_CI_AS = a.dataAreaId COLLATE Latin1_General_CI_AS
        LEFT JOIN SILVER_WAREHOUSE.dbo.DeviceTableMasters m 
            ON m.MasterId COLLATE Latin1_General_CI_AS = l.InventDimension1 COLLATE Latin1_General_CI_AS
        LEFT JOIN SILVER_WAREHOUSE.dbo.DeviceTable n 
            ON n.DeviceId COLLATE Latin1_General_CI_AS = l.InventDimension1 COLLATE Latin1_General_CI_AS 
            AND n.dataAreaId COLLATE Latin1_General_CI_AS = l.dataAreaId COLLATE Latin1_General_CI_AS
        LEFT JOIN SILVER_WAREHOUSE.dbo.DeviceGroup o 
            ON o.DeviceGroupId COLLATE Latin1_General_CI_AS = n.DeviceGroupId COLLATE Latin1_General_CI_AS 
            AND o.dataAreaId COLLATE Latin1_General_CI_AS = n.dataAreaId COLLATE Latin1_General_CI_AS
        LEFT JOIN SILVER_WAREHOUSE.dbo.ZCustomers q 
            ON q.AccountNum COLLATE Latin1_General_CI_AS = f.ZLeasing COLLATE Latin1_General_CI_AS 
            AND q.dataAreaId COLLATE Latin1_General_CI_AS = f.dataAreaId COLLATE Latin1_General_CI_AS
        LEFT JOIN SILVER_WAREHOUSE.dbo.DirPartyTable q2 ON q2.RecordId = q.Party
        LEFT JOIN SILVER_WAREHOUSE.dbo.PurchaseOrderLineV2 r 
            ON r.InventRefId COLLATE Latin1_General_CI_AS = f.SalesId COLLATE Latin1_General_CI_AS 
            AND LEFT(r.ItemNumber, 4) COLLATE Latin1_General_CI_AS IN ('FU02') 
            AND r.InventRefId != ''
        LEFT JOIN SILVER_WAREHOUSE.dbo.PurchaseOrderHeaderV2 s 
            ON s.PurchId COLLATE Latin1_General_CI_AS = r.PurchaseOrderNumber COLLATE Latin1_General_CI_AS 
            AND r.dataAreaId COLLATE Latin1_General_CI_AS = s.dataAreaId COLLATE Latin1_General_CI_AS
        LEFT JOIN SILVER_WAREHOUSE.dbo.VendTable s2 
            ON s2.VendorAccountNumber COLLATE Latin1_General_CI_AS = s.OrderAccount COLLATE Latin1_General_CI_AS 
            AND s2.dataAreaId COLLATE Latin1_General_CI_AS = s.dataAreaId COLLATE Latin1_General_CI_AS
        LEFT JOIN SILVER_WAREHOUSE.dbo.DirPartyTable s3 ON s3.RecordId = s2.Party
        CROSS APPLY SILVER_WAREHOUSE.dbo.name_masking_function(j1.Name) as po
    WHERE CAST(a.InvoiceDate AS DATE) BETWEEN @StarDate AND @MaxDate;

    DELETE FROM #TempYearMonth WHERE YearMonth = @LoopYearMonth;
END

-- Bersihkan tabel sementara
DROP TABLE #TempYearMonth

END