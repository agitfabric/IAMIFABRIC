CREATE   PROCEDURE [dbo].[SP_Report_30_PSS]
AS
BEGIN

	SET NOCOUNT ON;
	
	Delete Report_30 where left(kode_dealer_gr,3) = 'AII'
	insert into Report_30
	select 	c.DealerName as nama_dealer_billing_sap, b.SiteCode kode_dealer_billing_sap, data_billingSAPNo nomor_billing_sap, data_referenceNo as reference_doc,
			'No' as IsCanceled, data_billingDate as tanggal_billing_sap, 
			data_invoiceDate tanggal_terima_atau_tanggal_gr_dealer, null as gr_fisik, b.SiteCode kode_dealer_gr, c.DealerName as nama_dealer_gr, 
			c.DealerName as nama_dealer_posisi_stock_unit,
			b.SiteCode kode_dealer_posisi_stock_unit, c.SiteName Outlet, c.Area, 
			Case when d.AMItemMajorGroupId is not null then d.AMItemMajorGroupId else f.[CV/LCV] end  major_group, 
			Case when d.AMItemMinorGroupId is not null then d.AMItemMinorGroupId else f.Series end  types, 
			Case when e.ClassId is not null then e.ClassId else f.device_class end  device_class, 
			Case when d.NameAlias is not null then d.NameAlias else f.Type_Desc end  device_class, 
			data_itemDesc as material_description_sap, data_vin as chassis_number, data_engineNo as engine_number, '' kode_warna, data_colorDesc as color_desc, 
			case when f.nomer_SO = '' or f.nomer_SO is null then 1 else 0 end as Stock_Qty,
			null as reserved, f.nomer_SO as nomer_SO,tanggal_SO as tanggal_SO, f.nama_customer as nama_customer, 
			case when f.nomer_SO = '' or f.nomer_SO is null  then 'Belum terjual' else 'Terjual' end as Status,
			null as last_process, data_deliveryDate as tanggal_delivery_out_pdc, getdate() as last_update

	from SILVER_WAREHOUSE.dbo.sales_POUnit a
		left join SILVER_WAREHOUSE.dbo.site_mapping b on LOWER(b.SiteCodePSS) = LOWER(a.data_kodeOutlet)
		left join SILVER_WAREHOUSE.dbo.ZAISITES c on LOWER(c.SiteCode) = LOWER(b.SiteCode)
		left join SILVER_WAREHOUSE.dbo.ZInventTables d on LOWER(d.ItemId) = LOWER(a.data_itemNo) and LOWER(d.dataAreaId)= 'zir'
		left join SILVER_WAREHOUSE.dbo.DeviceModel e on LOWER(e.ModelId) = LOWER(a.data_itemNo) and LOWER(e.Stopped) = 'no'
		left join Report_1 f on LOWER(f.ChassisNumber) = LOWER(a.data_deviceNo) and LOWER(f.dealer) = 'ai' and LOWER(f.sales_tipe) = 'fu end-user order' 
	where lower(data_poStatus) = 'invoiced' --and a.data_deviceNo = 'MHCNLR55HMJ092356'

	Delete from Report_30 where UPPER(major_group) != 'CV' 

END