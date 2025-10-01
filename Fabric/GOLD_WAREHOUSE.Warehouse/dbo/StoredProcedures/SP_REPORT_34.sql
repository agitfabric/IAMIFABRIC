CREATE   PROCEDURE [dbo].[SP_REPORT_34]
AS

    DECLARE @GetMaxRunningDate DATE = ISNULL(
    (SELECT MAX(CAST([SO/PKB_Date] AS DATE)) FROM Report_34), '2019-09-01'
);
DECLARE @GetCurrentDate DATE = CAST(GETDATE() AS DATE);

-- Ambil daftar YearMonth dari InventTrans
WITH YearMonths AS (
    SELECT DISTINCT LEFT(CONVERT(CHAR(8), DatePhysical, 112), 6) AS YearMonth
    FROM SILVER_WAREHOUSE.dbo.InventTrans
    WHERE dataAreaId != 'kzu'
      AND CAST(DatePhysical AS DATE) BETWEEN @GetMaxRunningDate AND @GetCurrentDate
)
SELECT * INTO #TempYearMonthReport34 FROM YearMonths;

-- Variabel loop
DECLARE @YearMonth CHAR(6);
DECLARE @StarDate DATE;
DECLARE @MaxDate DATE;

WHILE EXISTS (SELECT TOP 1 1 FROM #TempYearMonthReport34)
BEGIN
    SELECT TOP 1 @YearMonth = YearMonth FROM #TempYearMonthReport34 ORDER BY YearMonth ASC;

    -- Hitung batas tanggal
    SET @StarDate = DATEADD(MONTH, 1, DATEADD(YEAR, -1, DATEADD(MONTH, DATEDIFF(MONTH, '19000101', @YearMonth + '01'), '19000101')));
    SET @MaxDate = DATEADD(DAY, -1, DATEADD(MONTH, 1, @YearMonth + '01'));

    -- Hapus data existing
    DELETE FROM Report_34 WHERE CAST([SO/PKB_Date] AS DATE) BETWEEN @StarDate AND @MaxDate;

    -- Insert Sales Order
    INSERT INTO Report_34
    SELECT
        a.CustAccount AS Customer_ID, h.Name AS Customer_Name,
        a.SalesId AS [SO/PKB_no], a.ProjId AS PKB_no, a.SalesOrderPoolId,
        d.InvoiceId,
        CONVERT(VARCHAR(10), b.CreatedDateTime1, 111) AS [SO/PKB_Date],
        CASE WHEN g.ZCustPartType IN ('Partshop','BMI') THEN 'Indirect' ELSE 'Direct' END AS Tipe,
        c.ItemGroupId, b.ItemNumber, f.NameAlias, 
        b.SalesQty, ISNULL(d.QTY, 0), b.LineAmount,
        CASE WHEN d.InvoiceId IS NULL THEN '1900-01-01' ELSE CONVERT(VARCHAR(10), d.InvoiceDate, 111) END AS Invoice_Date,
        a.dataAreaId AS Kode_Dealer, e.ZDealerAfterSales AS Dealer,
        a.InventSiteId AS Kode_Outlet, e.Name AS Outlet,
        e.AreaCode + '-' + e.ZIAMIArea AS Area,
        CASE
            WHEN d.InvoiceId IS NULL AND DATEDIFF(DAY, b.CreatedDateTime1, GETDATE()) < 2 AND b.SalesQty - d.QTY = 0 THEN ''
            WHEN d.InvoiceId IS NOT NULL AND DATEDIFF(DAY, b.CreatedDateTime1, d.InvoiceDate) < 2 AND b.SalesQty - d.QTY = 0 THEN 'First Full'
            ELSE 'Not First Full'
        END AS Remarks,
        GETDATE(), 'NON-AI', m.MaskedName, '', b.RecordId
    FROM SILVER_WAREHOUSE.dbo.ZSalesOrderHeader a
    INNER JOIN SILVER_WAREHOUSE.dbo.ZSalesOrderLine b ON LOWER(b.SalesOrderNumber) = LOWER(a.SalesId) AND LOWER(b.SalesOrderLineStatus) != 'canceled'
    INNER JOIN SILVER_WAREHOUSE.dbo.InventItemGroupItem c ON LOWER(c.ItemDataAreaId) = LOWER(b.dataAreaId) AND LOWER(c.ItemId) = LOWER(b.ItemNumber) AND LOWER(c.ItemGroupId) = 'sp01'
    LEFT JOIN (
        SELECT a.SalesId, a.ItemId, MAX(a.InvoiceId) InvoiceId, MAX(a.InvoiceDate) InvoiceDate, SUM(a.Qty) QTY
        FROM SILVER_WAREHOUSE.dbo.ZCustInvoiceTrans a
        INNER JOIN SILVER_WAREHOUSE.dbo.InventItemGroupItem b ON LOWER(b.ItemDataAreaId) = LOWER(a.dataAreaId) AND LOWER(b.ItemId) = LOWER(a.ItemId) AND LOWER(b.ItemGroupId) = 'sp01'
        GROUP BY a.SalesId, a.ItemId
    ) d ON d.SalesId = b.SalesOrderNumber AND d.ItemId = b.ItemNumber
    LEFT JOIN SILVER_WAREHOUSE.dbo.ZInventSites e ON LOWER(e.SiteId) = LOWER(a.InventSiteId)
    LEFT JOIN SILVER_WAREHOUSE.dbo.ZInventTables f ON LOWER(f.ItemId) = LOWER(b.ItemNumber) AND LOWER(f.dataAreaId) = LOWER(b.dataAreaId)
    LEFT JOIN SILVER_WAREHOUSE.dbo.ZCustomers g ON LOWER(g.AccountNum) = LOWER(a.CustAccount) AND LOWER(g.dataAreaId) = LOWER(a.dataAreaId)
    LEFT JOIN SILVER_WAREHOUSE.dbo.DirPartyTable h ON LOWER(h.RecordId) = LOWER(g.Party)
	CROSS APPLY SILVER_WAREHOUSE.dbo.name_masking_function(h.Name) as m
    WHERE LOWER(a.SalesOrderPoolId) IN ('sp') AND LOWER(a.ZSalesType) != 'klaim'
      AND CAST(b.CreatedDateTime1 AS DATE) BETWEEN @StarDate AND @MaxDate

    UNION ALL

    -- Insert Journal Transfer
    SELECT
        c.CustAccount, d1.Name,
        a.ZProjectId, a.ZProjectId, 'SV', a.JournalId,
        CAST(b.TransDate AS DATE),
        'Direct',
        e.ItemGroupId, b.ItemId, f.NameAlias,
        ABS(b.Qty), ABS(b.Qty), ABS(b.Qty) * b.CostPrice,
        CAST(a.PostedDateTime AS DATE),
        a.dataAreaId, g.ZDealerAfterSales, c.ZInventSiteId, g.Name,
        g.AreaCode + '-' + g.ZIAMIArea,
        CASE
            WHEN CAST(a.PostedDateTime AS DATE) = '1900-01-01' AND DATEDIFF(DAY, a.PostedDateTime, b.TransDate) = 0 THEN ''
            WHEN CAST(a.PostedDateTime AS DATE) > '1900-01-01' AND DATEDIFF(DAY, a.PostedDateTime, b.TransDate) = 0 THEN 'First Full'
            ELSE 'Not First Full'
        END,
        GETDATE(), 'NON-AI', m.MaskedName, '', b.RecordId
    FROM SILVER_WAREHOUSE.dbo.InventJournalTable a
    INNER JOIN SILVER_WAREHOUSE.dbo.InventJournalTrans b ON LOWER(b.JournalId) = LOWER(a.JournalId)
    INNER JOIN SILVER_WAREHOUSE.dbo.CaseTable c ON LOWER(c.CaseId) = LOWER(a.ZProjectId)
    INNER JOIN SILVER_WAREHOUSE.dbo.ZCustomers d ON LOWER(d.AccountNum) = LOWER(c.CustAccount) AND LOWER(d.dataAreaId) = LOWER(c.dataAreaId)
    LEFT JOIN SILVER_WAREHOUSE.dbo.DirPartyTable d1 ON LOWER(d1.RecordId) = LOWER(d.Party)
    INNER JOIN SILVER_WAREHOUSE.dbo.InventItemGroupItem e ON LOWER(e.ItemId) = LOWER(b.ItemId) AND LOWER(e.ItemDataAreaId) = LOWER(b.dataAreaId) AND LOWER(e.ItemGroupId) = 'sp01'
    LEFT JOIN SILVER_WAREHOUSE.dbo.ZInventTables f ON LOWER(f.ItemId) = LOWER(b.ItemId) AND LOWER(f.dataAreaId) = LOWER(b.dataAreaId)
    LEFT JOIN SILVER_WAREHOUSE.dbo.ZInventSites g ON LOWER(g.SiteId) = LOWER(c.ZInventSiteId)
	CROSS APPLY SILVER_WAREHOUSE.dbo.name_masking_function(d1.Name) as m
    WHERE a.ZProjectId != ''
      AND CAST(b.TransDate AS DATE) BETWEEN @StarDate AND @MaxDate;

    -- Hapus row yg sudah diproses
    DELETE FROM #TempYearMonthReport34 WHERE YearMonth = @YearMonth;
END

DROP TABLE #TempYearMonthReport34;