CREATE PROCEDURE [dbo].[SP_REPORT_33]
AS
BEGIN
SET NOCOUNT ON;

    DECLARE 
        @GetMaxRunningDate date = ISNULL(
            (SELECT MAX(CAST(Tanggal_SO AS date)) FROM Report_33 WHERE DealerCategory = 'NON-AI'),
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
    WHERE r.DealerCategory = 'NON-AI';

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
    Select  InvoiceId,
					Tanggal_SO,
					Tanggal_Create, 
					Customer_ID, Customer_Name, SO_no,
					ItemGroupId, Part_number, Part_Name, 
					isnull(Demand_Qty,Qty_Order) Demand_Qty,
					isnull(Qty_Order,0) as Qty_Order , 
					isnull(Qty_Order,0)-Isnull(Availability,0) as Qty_Lose, 
					isnull(Availability,0) as Availability, unit_price, isnull(LineAmount,0) as LineAmount, 
					Reason_ID, Reason_Note,
					Created_by, 'NON-AI' as DealerCategory,
					Dealer, 
					Outlet, Outlet_Name, Area, getdate() as Last_Update,
					Customer_Name as MaskingName
			--		into Report_33
			From
			(
			Select  
				c.InvoiceId,
				max(CONVERT(datetime, c.InvoiceDate, 111)) as Tanggal_SO,
				CONVERT(datetime,a.ZCreatedDateTime ,111) as Tanggal_Create,
				a.InvoiceAccount as Customer_ID,
				m.MaskedName as Customer_Name,
				a.SalesId SO_no,
				b.LineNum , h.LineNum Linenum1 ,
				i.ItemGroupId, b.ItemNumber as Part_number,
				b.Name as Part_Name,
				max(h.SalesQty) Demand_Qty,
				max(b.SalesQty) as Qty_Order,
				sum(d.Qty) as Availability,
				max(b.SalesPrice) unit_price, sum(d.LineAmount) as LineAmount, 
				Isnull(e.ZReasonId,'') as Reason_ID,
				Isnull(e.ZReasonNote,'') as Reason_Note,
				b.CreatedBy1 as Created_by,
				g.Description as Dealer ,
				a.InventSiteId as Outlet,
				f.Name as Outlet_Name,
				f.ZIAMIArea as Area
			from SILVER_WAREHOUSE.dbo.ZSalesOrderHeader a
				inner join SILVER_WAREHOUSE.dbo.ZSalesOrderLine b on b.SalesOrderNumber = a.SalesId and b.dataAreaId = a.dataAreaId
				inner join SILVER_WAREHOUSE.dbo.CustInvoiceJour c on c.SalesId= a.SalesId -- and c.invoiceid is not null
				left join SILVER_WAREHOUSE.dbo.ZCustInvoiceTrans d on d.InvoiceId = c.InvoiceId and d.ItemId = b.ItemNumber and d.LineNum = b.LineNum
				left join SILVER_WAREHOUSE.dbo.AMInventDemandTrans e on e.ZTransactionNumber = b.SalesOrderNumber and e.ItemId = b.ItemNumber and e.ZPosted = 'Yes'
				left join SILVER_WAREHOUSE.dbo.ZInventSites f on f.SiteId = a.InventSiteId
				left join SILVER_WAREHOUSE.dbo.Ledger g on a.dataAreaId = g.Name
				left join SILVER_WAREHOUSE.dbo.SalesQuotationLine h on h.SalesQuotationNumber = a.QuotationNumber and h.ItemNumber = b.ItemNumber and h.LineNum = b.LineNum 
				inner join SILVER_WAREHOUSE.dbo.InventItemGroupItem i on i.ItemDataAreaId = b.dataAreaId and i.ItemId = b.ItemNumber and i.ItemGroupId in ('SP01','SP02')
                INNER JOIN DateRanges dr ON CAST(c.InvoiceDate AS date) BETWEEN dr.StartDate AND dr.EndDate
				CROSS APPLY SILVER_WAREHOUSE.dbo.name_masking_function(a.SalesName) as m
			where   
						a.SalesOrderPoolId = 'SP'
			Group by 
					a.ZCreatedDateTime, 
					a.InvoiceAccount, m.MaskedName, a.SalesId, 
					a.InventSiteId, a.InventLocationId, c.InvoiceDate ,
					b.ItemNumber , b.Name, b.LineNum ,
					h.LineNum ,
					e.ZReasonId, e.ZReasonNote,
					b.CreatedBy1,
					f.Name,
					f.ZIAMIArea , 
					c.InvoiceId,
					g.Description,
					i.ItemGroupId
			) x
END