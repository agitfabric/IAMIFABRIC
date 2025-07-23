CREATE PROCEDURE [dbo].[SP_REPORT_52_SPVSALESMAN] 

AS
BEGIN

	SET NOCOUNT ON;
	   
	   
	DECLARE @RunningDate CHAR(6)

-- contoh set manual, atau ini dipanggil dari luar
-- SET @RunningDate = FORMAT(GETDATE(), 'yyyyMM')
	
	Update Report_52_SPVSalesman
	Set LastSales = Case 
			when FirstDateOutlet < JoinDate then Isnull(c.LastSales, a.JoinDate) 
			else Isnull(c.LastSales, b.FirstDateOutlet) 
		end,
		Idle = Case 
			when FirstDateOutlet < JoinDate then DATEDIFF(month, Isnull(c.LastSales, a.JoinDate), @RunningDate+'01') 
			else DATEDIFF(month, Isnull(c.LastSales, b.FirstDateOutlet), @RunningDate+'01') 
		end

	From Report_52_SPVSalesman a
		Left join (select  Min(DATEADD(d, 1, EOMONTH(DatePhysical))) FirstDateOutlet , b.InventSiteId
					from SILVER_WAREHOUSE.dbo.InventTrans a
						left join SILVER_WAREHOUSE.dbo.Dim b on b.inventDimId = a.inventDimId
					Where cast(DatePhysical as date) > '1900-01-01' 
					Group by b.InventSiteId)b on b.InventSiteId = a.OUTLET
		Left join (SELECT Cast(Max(a.InvoiceDate) as Date) LastSales, ZSalesman
				FROM SILVER_WAREHOUSE.dbo.ZCustInvoiceTrans a
				LEFT OUTER JOIN SILVER_WAREHOUSE.dbo.InventItemGroupItem AS b   ON b.ItemId = a.ItemId  AND b.ItemDataAreaId = a.dataAreaId 
				LEFT OUTER JOIN SILVER_WAREHOUSE.dbo.ZSalesOrderHeader AS c  ON c.SalesId = a.SalesId  
				WHERE lower(a.dataAreaId) <> 'kzu'  
					and c.ZSalesType = 'FU'	and b.ItemGroupId = 'FU01'
					and Left(convert(char,a.InvoiceDate,112),6) <= @RunningDate 
					Group by ZSalesman) c on c.ZSalesman = a.USERIDSALESMAN
	Where RunningDate = @RunningDate 
	   
END