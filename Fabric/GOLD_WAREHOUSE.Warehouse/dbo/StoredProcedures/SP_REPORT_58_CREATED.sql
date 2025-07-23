CREATE PROCEDURE [dbo].[SP_REPORT_58_CREATED]

AS
BEGIN

	SET NOCOUNT ON;

	DELETE from Report_58 where WONumber in (SELECT WONumber from SILVER_WAREHOUSE.dbo.ZReportService)

	INSERT INTO Report_58
	SELECT 
		IIF(YEAR(a.PKBDate)=1900, NULL, cast(a.PKBDate as date)) as 'Tgl Unit Entry',
		Isnull(convert(date, a.TglSIKK, 105),'1900-01-01') as 'Tgl SIKK',
		--IIF(YEAR(convert(date,a.TglSIKK,105))=1900, NULL, convert(date,a.TglSIKK,105)) as 'Tgl SIKK',
		a.WONumber, a.WOStatus as 'Status WO', 
		IIF(YEAR(a.PKBDate)=1900, NULL, cast(a.PKBDate as date)) as 'PKB Date', 
		a.DeviceNumber as 'Device Number', 
		a.NoPolisi as 'No Polisi',
		a.CustomerAccount as 'Customer Account', a.CustomerName as 'Customer Name', a.NPWP as NPWP, 
		a.Phone Phone, a.Address Alamat,
		a.Site as 'Site', a.Outlet as Outlet, a.ItemNumber as 'Item number', a.ProductName as 'Product Name', 
		a.Warehouse as Warehouse, a.Location as 'Location',
		a.SalesQty as Quantity, 
		a.LineProperty LineProperty, 
		REPLACE(REPLACE(a.LineStatus,'None',''),'Backorder','Open order') as 'Line Status',
		IIF(YEAR(a.ReceiptDateRequested)=1900, NULL, cast(a.ReceiptDateRequested as date)) as 'Receipt Date Requested',
		a.Category Category,
		a.Unit as Unit, a.SalesPrice as 'Sales price', a.Disc as Discount, a.DiscPercent as 'Discount persen', 
		a.PPN PPN, 
		a.NetAmount as 'Net Amount', 
		a.StandardCost,
		a.ProductName as 'Product Name',
		ISNULL(a.BU,''), 
		a.Resource as 'Resource', a.ResourceName as 'Resource name',
		a.WOGroup as WOGroup, a.WODescription as 'WODescription', 
		a.InvoiceNo as InvoiceID, a.InvoiceAccount, 		
		IIF(YEAR(a.InvoiceDate)=1900, NULL, cast(a.InvoiceDate as date)) as 'Invoice Date',
		a.Voucher as Voucher,
		a.KM as KM, a.EngineNumber as 'Engine number', a.VehicleTypeName as 'Vehicle Type Name', 
		a.VehicleModelName as 'Vehicle Model Name', a.VehicleColorName as 'Vehicle Color Name', 
		a.VehicleYear as 'Vehicle Year', a.VehicleGroupName as 'Vehicle Group Name', 
		a.CreateBy as CreatedBy, 		
		a.AMItemMinorGroup as MinorGroup,
		a.AMItemMajorGroup as MajorGroup,
		m.MaskedName as MaskingName, 0, 'Yes', GETDATE()
	FROM SILVER_WAREHOUSE.dbo.ZReportService a
	CROSS APPLY SILVER_WAREHOUSE.dbo.name_masking_function(a.CustomerName) as m
	END