CREATE PROCEDURE [dbo].[SP_Report_34_PSS]
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @GetMaxRunningDate date

	Select @GetMaxRunningDate = cast(dateadd(dd,-2,max([SO/PKB_Date])) as date) from Report_34
	Where DealerCategory = 'AI'

	Delete Report_34 where cast([SO/PKB_Date] as date) >= @GetMaxRunningDate and DealerCategory = 'AI'

	Insert into Report_34

	Select *
	From
	(
	SELECT  swo.data_customerAccount Customer_ID,  swo.data_name customer_Name,
			swo.data_workOrderNo 'SO/PKB_no',  swo.data_workOrderNo PKB_no, 
			'SP' as SalesOrderPoolId, siw.data_invoiceNo invoiceID,
			TRY_CAST(swo.data_workOrderDateFrom as date) 'SO/PKB_Date', 
			'Direct'  Tipe, 'SP01' as ItemGroupID, swo.data_operations_parts_partNo part_number, 
			swo.data_operations_parts_partDesc Part_Name,
			swo.data_operations_parts_qty SalesQty, siw.data_parts_qty Qty, 
			0 as amount,
			TRY_CAST(siw.data_invoiceDate as date) 'Invoice_Date', 
			d.Dealer Kode_dealer, d.DealerName Dealer, 
			d.SiteCode Kode_Outlet, d.SiteName Outlet, d.Area Area, 
			Case When siw.data_invoiceNo is null and DATEDIFF(day, TRY_CAST(swo.data_workOrderDateFrom as date), GETDATE()) <2 then ''
				 When siw.data_invoiceNo is not null and Datediff(day, TRY_CAST(swo.data_workOrderDateFrom as Date), TRY_CAST(siw.data_invoiceDate as Date)) < 2 
						and swo.data_operations_parts_qty-siw.data_parts_qty = 0 then 'First Full' else 'Not First Full' end as Remarks,
			Getdate() LastUpdate, 'AI' as DealerCategory, m.MaskedName MaskingName,null as FlagDelete,null as RecordId
	FROM SILVER_WAREHOUSE.dbo.service_workOrder swo 
		left join (select data_workOrderNo, data_parts_partNo, data_parts_partItemNo, data_parts_qty,
							max(data_invoiceNo) data_invoiceNo, max(TRY_CAST(data_invoiceDate AS DATE)) data_invoiceDate
					from SILVER_WAREHOUSE.dbo.service_invoiceWO 
					where data_parts_qty > 0 
					Group by data_workOrderNo, data_parts_partNo, data_parts_partItemNo, data_parts_qty ) siw 
					on siw.data_workOrderNo = swo.data_workOrderNo 
						and siw.data_parts_partNo = swo.data_operations_parts_partNo
		inner join SILVER_WAREHOUSE.dbo.site_mapping c on c.SiteCodePSS = swo.data_site
		inner join SILVER_WAREHOUSE.dbo.ZAISITES d on d.SiteCode = c.SiteCode
		CROSS APPLY SILVER_WAREHOUSE.dbo.name_masking_function(swo.data_name) as m
	WHERE swo.data_operations_parts_partNo is not null and swo.data_workOrderStatus is not null AND swo.data_lineProperties = 'Billable'
	  and TRY_CAST(swo.data_workOrderDateFrom as date) >= @GetMaxRunningDate
	  and data_operations_parts_flagDeletion = 0
	Group by swo.data_customerAccount,  swo.data_workOrderNo,  swo.data_workOrderDateFrom,
		swo.data_operations_parts_partItemNo, swo.data_operations_parts_partNo,
		swo.data_operations_parts_partDesc,	swo.data_operations_parts_qty, swo.data_site, siw.data_parts_qty, TRY_CAST(siw.data_invoiceDate as date), 
		swo.data_name, siw.data_invoiceNo, d.Dealer, d.DealerName, d.SiteCode, d.SiteName, d.Area,m.MaskedName

	Union All

	select a.data_customerAccount Customer_ID, a.data_name Customer_Name, 
			a.data_salesOrderNo SO_PKB_No, '' PKB_No, 
			a.data_pool as SalesOrderPoolId, max(b.data_invoiceNo) InvoiceID, 
			TRY_CAST(a.data_createdTime as date) SO_PKB_Date, 'Indirect' Tipe,
			a.data_items_itemGroup ItemGroupID, a.data_items_itemNo Part_number, a.data_items_productName  Part_Name,
			max(a.data_items_qty) SalesQty, Isnull(sum(b.data_items_qty),0) Qty, max(a.data_items_qty) * max(a.data_items_unitPrice) as Amount,
			max(TRY_CAST(b.data_invoiceDate as date)) InvoiceDate, 
			d.Dealer Kode_dealer, d.DealerName Dealer, 
			d.SiteCode Kode_Outlet, d.SiteName Outlet, d.Area Area, 
			Case when max(b.data_invoiceNo) is null and DATEDIFF(day, TRY_CAST(a.data_createdTime as date), GETDATE()) <2 then ''
				 when max(b.data_invoiceNo) is not null and DATEDIFF(day, TRY_CAST(a.data_createdTime as date), max(TRY_CAST(b.data_invoiceDate AS DATE))) <2 
						and max(a.data_items_qty) = Isnull(sum(b.data_items_qty),0) 
						then 'FIRST FULL' else 'NOT FIRST FULL' end  Remarks, 
			Getdate() as Last_Update, 'AI' as DealerCategory, m.MaskedName,null as FlagDelete,null as RecordId
	from SILVER_WAREHOUSE.dbo.sparepart_salesOrder a	
		left join SILVER_WAREHOUSE.dbo.sparepart_invoiceSO b on b.data_salesOrderNo = a.data_salesOrderNo and b.data_items_item = a.data_items_itemNo
		inner join SILVER_WAREHOUSE.dbo.site_mapping c on c.SiteCodePSS = a.data_site
		inner join SILVER_WAREHOUSE.dbo.ZAISITES d on d.SiteCode = c.SiteCode
		CROSS APPLY SILVER_WAREHOUSE.dbo.name_masking_function(a.data_name) as m
	where a.data_items_itemGroup = 'SP01' and a.data_salesOrderStatus != 'Cancelled' and data_items_flagDeletion = 0
	  and TRY_CAST(a.data_createdTime as date) >= @GetMaxRunningDate

	Group by a.data_customerAccount, a.data_name, a.data_salesOrderNo, a.data_pool, 
			TRY_CAST(a.data_createdTime as date), a.data_items_itemGroup, a.data_items_itemNo, a.data_items_productName,
			d.Dealer, d.DealerName, d.SiteCode, d.SiteName, d.Area,m.MaskedName
	)x
	Where part_number is not null and part_number != ''
	Order by 'SO/PKB_no', part_number

END