CREATE PROCEDURE [dbo].[SP_REPORT_52_SALESMAN]
AS
BEGIN
	
	Declare @Year char(4), @month char(2)
    
	Select @Year = Left(Convert(char,getdate()-1,112),4), @month = SUBSTRING(Convert(char,getdate()-1,112),5,2)

	Delete Report_52_SPVSalesman where RunningDate = @Year+@month

	Insert into Report_52_SPVSalesman 
	
	--SELECT *,  @Year+@month as RunningDate, 
	--'1900-01-01' as JoinDate, Null as Jenjang, '1900-01-01' as LastSales, 0 as Idle
	--FROM vw_Salesman

	SELECT d.ZInventSiteId as OUTLET, e.Name as NAME, a.SalesGroupId as SALESGROUPID, 
	b.Description as SPVNAME, a.UserIdSalesman as USERIDSALESMAN, a.Description as SALESMAN, 1 as Jumlah, 
	@Year+@month as RunningDate, d.WorkerAssignmentStart as JoinDate,
	Case
			 when DATEDIFF(month,cast(d.WorkerAssignmentStart as Date),cast(@Year+@month+'01' as Date)) <= 12 then 'Sales Trainee' 
			 when DATEDIFF(month,cast(d.WorkerAssignmentStart as Date),cast(@Year+@month+'01' as Date)) > 12 and DATEDIFF(month,cast(d.WorkerAssignmentStart as Date),cast(@Year+@month+'01' as Date)) <=24 then 'Junior Sales'
			 when DATEDIFF(month,cast(d.WorkerAssignmentStart as Date),cast(@Year+@month+'01' as Date)) > 25 and DATEDIFF(month,cast(d.WorkerAssignmentStart as Date),cast(@Year+@month+'01' as Date)) <=36 then 'Sales'
			 when DATEDIFF(month,cast(d.WorkerAssignmentStart as Date),cast(@Year+@month+'01' as Date)) > 36 then 'Senior Sales' 
			 else 'Sales' end as Jenjang, '1900-01-01' as LastSales, 0 as Idle
	FROM SILVER_WAREHOUSE.dbo.ZSalesGroupLine a 
	LEFT Join SILVER_WAREHOUSE.dbo.ZSalesGroupTable b on a.SalesGroupId = b.SalesGroupId
	LEFT JOIN SILVER_WAREHOUSE.dbo.Worker c on a.UserIdSalesman = c.PersonnelNumber
	LEFT OUTER JOIN SILVER_WAREHOUSE.dbo.Position d on d.WorkerPersonnelNumber = c.PersonnelNumber
	LEFT JOIN SILVER_WAREHOUSE.dbo.ZInventSites e on d.ZInventSiteId = e.SiteId
	WHERE a.DataAreaId != 'kzu' and d.ZInventSiteId IS NOT NULL and e.Name IS NOT NULL and b.Description IS NOT NULL


	Update Report_52_SPVSalesman
		Set 
			LastSales = ISNULL(
				CASE 
					WHEN FirstDateOutlet < JoinDate THEN ISNULL(c.LastSales, a.JoinDate) 
					ELSE ISNULL(c.LastSales, b.FirstDateOutlet) 
				END, '1900-01-01'),

			Idle = ISNULL(
				CASE 
					WHEN FirstDateOutlet < JoinDate THEN 
						DATEDIFF(month, ISNULL(c.LastSales, a.JoinDate), CAST(@Year+@month+'01' AS DATE)) 
					ELSE 
						DATEDIFF(month, ISNULL(c.LastSales, b.FirstDateOutlet), CAST(@Year+@month+'01' AS DATE)) 
				END, 0)
		From Report_52_SPVSalesman a
		LEFT JOIN (
			SELECT MIN(DATEADD(DAY, 1, EOMONTH(DatePhysical))) AS FirstDateOutlet, b.InventSiteId
			FROM SILVER_WAREHOUSE.dbo.InventTrans a
			LEFT JOIN SILVER_WAREHOUSE.dbo.Dim b ON b.inventDimId = a.inventDimId
			WHERE CAST(DatePhysical AS DATE) > '1900-01-01'
			GROUP BY b.InventSiteId
		) b ON b.InventSiteId = a.OUTLET
		LEFT JOIN (
			SELECT CAST(MAX(a.InvoiceDate) AS DATE) AS LastSales, ZSalesman
			FROM SILVER_WAREHOUSE.dbo.ZCustInvoiceTrans a
			LEFT JOIN SILVER_WAREHOUSE.dbo.InventItemGroupItem b ON b.ItemId = a.ItemId AND b.ItemDataAreaId = a.dataAreaId 
			LEFT JOIN SILVER_WAREHOUSE.dbo.ZSalesOrderHeader c ON c.SalesId = a.SalesId  
			WHERE LOWER(a.dataAreaId) <> 'kzu'  
				AND c.ZSalesType = 'FU' 
				AND b.ItemGroupId = 'FU01'
				AND LEFT(CONVERT(CHAR, a.InvoiceDate, 112), 6) <= @Year+@month 
			GROUP BY ZSalesman
		) c ON c.ZSalesman = a.USERIDSALESMAN
		WHERE RunningDate = @Year+@month 
 

	SELECT MAX(RunningDate) as LastRunningDate FROM Report_52_SPVSalesman
END