CREATE   PROCEDURE [dbo].[SP_REPORT_33_PSS]
AS

    DECLARE 
        @GetMaxRunningDate date = ISNULL(
            (SELECT MAX(CAST(Tanggal_SO AS date)) FROM Report_33 WHERE DealerCategory = 'AI'),
            '2019-09-01'
        ),
        @GetCurrentDate date = CAST(GETDATE() AS date);

    -- Generate all unique YearMonth values from InventTrans
    WITH YearMonths AS (
        SELECT DISTINCT LEFT(CONVERT(char, DatePhysical, 112), 6) AS YearMonth
        FROM SILVER_WAREHOUSE.dbo.InventTrans
        WHERE LOWER(dataAreaId) != 'kzu' 
          AND CAST(DatePhysical AS date) BETWEEN @GetMaxRunningDate AND @GetCurrentDate
    )SELECT * INTO #TempYearMonthReport33PSS FROM YearMonths;

-- Variabel loop
DECLARE @LoopYearMonth CHAR(6);
DECLARE @StartDate DATE;
DECLARE @MaxDate DATE;

-- Loop tiap bulan
WHILE EXISTS (SELECT TOP 1 1 FROM #TempYearMonthReport33PSS)
BEGIN
    SELECT TOP 1 @LoopYearMonth = YearMonth FROM #TempYearMonthReport33PSS ORDER BY YearMonth ASC;

    -- Hitung tanggal awal dan akhir untuk bulan yang sedang diproses
    SET @StartDate = DATEADD(MONTH, 1, DATEADD(YEAR, -1, DATEADD(MONTH, DATEDIFF(MONTH, '19000101', @LoopYearMonth + '01'), '19000101')));
    SET @MaxDate = DATEADD(DAY, -1, DATEADD(MONTH, 1, @LoopYearMonth + '01'));

    -- Hapus data lama untuk rentang tanggal & DealerCategory = 'AI'
    DELETE FROM Report_33 
    WHERE CAST(Tanggal_SO AS DATE) BETWEEN @StartDate AND @MaxDate 
      AND DealerCategory = 'AI';

   
    
    INSERT INTO Report_33
    SELECT	max(sis.data_invoiceNo) data_invoiceNo,
					cast(sso.data_createdTime as date) as Tanggal_SO,
					sso.data_createdTime,
					sso.data_customerAccount,
					sso.data_name,
					sso.data_salesOrderNo,
					t.ItemGroupId,
					sso.data_items_itemNo,
					sso.data_items_productName,
					isnull(sso.data_items_qty,0) 'Qty Demand',
					isnull(sso.data_items_qty,0) 'Qty Order',
					isnull(sso.data_items_qty,0) - isnull(sum(sis.data_items_qty),0) AS 'Qty Lose',
					isnull(sum(sis.data_items_qty),0) 'Qty Availability',	
					sso.data_items_unitPrice as unit_price, isnull(sum(sis.data_items_qty),0)*sso.data_items_unitPrice as lineamount,
					'Unavailable' AS IDReason,
					CONCAT(sso.data_items_reject, ', ',sso.data_cancellationReason)  AS Reason_Note,
					'User' AS CreateBy, 'AI' as DealerCategory,
					z.Dealer,
					z.SiteCode 'Outlet', z.SiteName,
					z.Area, getdate()  as last_Update,
					m.MaskedName MaskingName
				FROM SILVER_WAREHOUSE.dbo.sparepart_salesOrder sso 
				LEFT JOIN SILVER_WAREHOUSE.dbo.sparepart_invoiceSO sis ON LOWER(sso.data_items_itemNo) = LOWER(sis.data_items_item) AND LOWER(sso.data_site) = LOWER(sis.data_site) AND LOWER(sso.data_salesOrderNo) = LOWER(sis.data_salesOrderNo) 
				LEFT JOIN SILVER_WAREHOUSE.dbo.site_mapping sm ON LOWER(sm.SiteCodePSS) = LOWER(sso.data_site) 
				LEFT JOIN SILVER_WAREHOUSE.dbo.ZAISITES z  ON LOWER(z.SiteCode)  = LOWER(sm.SiteCode) 
				LEFT JOIN SILVER_WAREHOUSE.dbo.InventItemGroupItem t on LOWER(t.ItemId) = LOWER(sso.data_items_itemNo) and LOWER(t.ItemDataAreaId) = 'zir'
				CROSS APPLY SILVER_WAREHOUSE.dbo.name_masking_function(sso.data_name) as m
				WHERE CAST(sso.data_createdTime AS DATE) BETWEEN @StartDate AND @MaxDate
				--WHERE cast(sso.data_createdTime as date) between @StarDate and @MaxDate
				GROUP BY 
					sso.data_salesOrderNo,
					sso.data_createdTime,
					sso.data_customerAccount,
					sso.data_name,
					sso.data_items_itemNo,
					sso.data_items_productName,
					sso.data_items_qty ,
					sso.data_items_unitPrice,
					sso.data_items_reject,
					sso.data_cancellationReason,
					z.Dealer,
					z.SiteCode,
					z.Area, t.ItemGroupId,  z.SiteName,m.MaskedName
				Order by z.SiteCode, sso.data_createdTime
				    -- Buang yang sudah diproses
    DELETE FROM #TempYearMonthReport33PSS WHERE YearMonth = @LoopYearMonth;
END

-- Hapus temp table
DROP TABLE #TempYearMonthReport33PSS;