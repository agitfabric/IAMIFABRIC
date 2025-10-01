CREATE     procedure SP_REPORT_11 as
--DECLARE @GetMaxRunningDate DATE = ISNULL((SELECT MAX(CAST(tgl_invoice AS DATE)) FROM GOLD_WAREHOUSE.dbo.report_11), '2019-09-01');
DECLARE @GetMaxRunningDate DATE = ISNULL((SELECT MAX(CAST(tgl_invoice AS DATE)) FROM report_11), '2019-09-01');
DECLARE @GetCurrentDate DATE = CAST(GETDATE() AS DATE);

-- Ambil daftar YearMonth dari DatePhysical
-- Ambil daftar YearMonth dari DatePhysical
WITH YearMonths AS (
    SELECT DISTINCT LEFT(CONVERT(CHAR(8), DatePhysical, 112), 6) AS YearMonth
    FROM SILVER_WAREHOUSE.dbo.InventTrans
    WHERE dataAreaId != 'kzu'
      AND CAST(DatePhysical AS DATE) BETWEEN @GetMaxRunningDate AND @GetCurrentDate
)
SELECT * INTO #TempYearMonthsReport11 FROM YearMonths;
--
DECLARE @YearMonth CHAR(6), @StartDate DATE, @MaxDate DATE;

--
WHILE EXISTS (SELECT 1 FROM #TempYearMonthsReport11)
BEGIN
    SELECT TOP 1 @YearMonth = YearMonth FROM #TempYearMonthsReport11 ORDER BY YearMonth;

    SET @StartDate = DATEADD(MONTH, 1, DATEADD(YEAR, -1, DATEADD(MONTH, DATEDIFF(MONTH, '19000101', @YearMonth + '01'), '19000101')));
    SET @MaxDate = DATEADD(DAY, -1, DATEADD(MONTH, 1, @YearMonth + '01'));

    DELETE FROM report_11 WHERE CAST(tgl_invoice AS DATE) BETWEEN @StartDate AND @MaxDate;

    INSERT INTO report_11
    SELECT
        A.dataAreaId dealer, 
        e.ZDealerAfterSales nama_dealer, 
        c.InventSiteId outlet, 
        e.Name nama_outlet, 
        e.AreaCode + '-' + e.ZIAMIArea as Area, 
        e.Group_Dealer,
        A.InvoiceDate tgl_invoice,
        A.OrderAccount kode_customer, 
        i2.NameAlias nama_customer, 
        h.NameAlias nama_tipe, 
        h.AMItemMajorGroupId cv_lcv,
        c.ZPaymentType cara_bayar, 
        c.ZLeasing kode_leasing,
        ISNULL(g.NameAlias, '') nama_leasing,
        B.Qty jumlah_total,
        case when c.ZPaymentType = 'Cash' then B.Qty else 0 end jumlah_cash,
        case when c.ZPaymentType = 'Leasing' then B.Qty else 0 end jumlah_leasing,
        h.AMItemMinorGroupId as series, 
        f.ZLeasingType AS tipe_leasing,
        CASE 
            WHEN f.ZLeasingType = 'Mou' THEN 1
            WHEN f.ZLeasingType = 'NonMOU' THEN 2
            WHEN f.ZLeasingType = 'None' THEN 3
            ELSE 4 
        end as TL_ID,
        f.CustClassificationId as leasing_group, 
        ISNULL(i3.PartyType, 'Organization') as jenis_customer,
        c2.ZSegmentation as segmen_description, 
        i1.AccountNum, 
        GETDATE() as Last_Update,
        m.MaskedName as MaskingName
   from SILVER_WAREHOUSE.dbo.CustInvoiceJour A
    Left join SILVER_WAREHOUSE.dbo.ZCustInvoiceTrans B on LOWER(B.InvoiceId) = LOWER(A.InvoiceId)
    Left join SILVER_WAREHOUSE.dbo.ZSalesOrderHeader c on LOWER(c.SalesId) = LOWER(A.SalesId)
    Left join SILVER_WAREHOUSE.dbo.SalesQuotationTable c1 on LOWER(c1.SalesQuotationNumber) = LOWER(c.QuotationNumber)
    Left join SILVER_WAREHOUSE.dbo.OpportunityTable c2 on LOWER(c2.OpportunityId) = LOWER(c1.OpportunityId) and LOWER(c2.dataAreaId) = LOWER(c1.dataAreaId)
    Left join SILVER_WAREHOUSE.dbo.InventItemGroupItem d on LOWER(d.ItemId) = LOWER(B.ItemId) and LOWER(d.ItemDataAreaId) = LOWER(B.dataAreaId)
    Left join SILVER_WAREHOUSE.dbo.ZInventSites e on LOWER(e.SiteId) = LOWER(c.InventSiteId)
    Left join SILVER_WAREHOUSE.dbo.ZCustomers f on LOWER(f.AccountNum) = LOWER(c.ZLeasing) and LOWER(f.dataAreaId) = LOWER(c.dataAreaId)
    Left join SILVER_WAREHOUSE.dbo.DirPartyTable g on LOWER(g.RecordId) = LOWER(f.Party)
    Left join SILVER_WAREHOUSE.dbo.ZInventTables h on LOWER(h.ItemId) = LOWER(B.ItemId) and LOWER(h.dataAreaId) = LOWER(B.dataAreaId)
    Left join SILVER_WAREHOUSE.dbo.ZCustomers i1 on LOWER(i1.AccountNum) = LOWER(A.OrderAccount) and LOWER(i1.dataAreaId) = LOWER(A.dataAreaId)
    Left join SILVER_WAREHOUSE.dbo.DirPartyTable i2 on LOWER(i2.RecordId)= LOWER(i1.Party)
    Left join SILVER_WAREHOUSE.dbo.DirPersonBaseEntity i3 on LOWER(i3.PartyNumber) = LOWER(i2.PartyNumber)
    CROSS APPLY SILVER_WAREHOUSE.dbo.name_masking_function(i2.NameAlias) as m
    where c.ZSalesType = 'FU' 
      and d.ItemGroupId = 'FU01'
      AND CAST(A.InvoiceDate AS DATE) BETWEEN @StartDate AND @MaxDate
    ORDER BY c.InventSiteId;

    DELETE FROM #TempYearMonthsReport11 WHERE YearMonth = @YearMonth;
END

-- Cleanup
DROP TABLE #TempYearMonthsReport11;
--