CREATE PROCEDURE [dbo].[SP_REPORT_33_PSS]
AS
BEGIN
SET NOCOUNT ON;

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
	FROM Report_33 r
	JOIN DateRanges d ON CAST(r.Tanggal_SO AS date) BETWEEN d.StartDate AND d.EndDate
    WHERE r.DealerCategory = 'AI';

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
				LEFT JOIN SILVER_WAREHOUSE.dbo.sparepart_invoiceSO sis ON sso.data_items_itemNo = sis.data_items_item AND sso.data_site = sis.data_site AND sso.data_salesOrderNo = sis.data_salesOrderNo 
				LEFT JOIN SILVER_WAREHOUSE.dbo.site_mapping sm ON sm.SiteCodePSS = sso.data_site 
				LEFT JOIN SILVER_WAREHOUSE.dbo.ZAISITES z  ON z.SiteCode  = sm.SiteCode 
				LEFT JOIN SILVER_WAREHOUSE.dbo.InventItemGroupItem t on t.ItemId = sso.data_items_itemNo and t.ItemDataAreaId = 'zir'
				INNER JOIN DateRanges dr ON CAST(sso.data_createdTime AS date) BETWEEN dr.StartDate AND dr.EndDate
				CROSS APPLY SILVER_WAREHOUSE.dbo.name_masking_function(sso.data_name) as m
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
END