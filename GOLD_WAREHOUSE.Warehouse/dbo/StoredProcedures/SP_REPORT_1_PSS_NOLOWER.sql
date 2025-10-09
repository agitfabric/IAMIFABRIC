CREATE PROCEDURE dbo.SP_REPORT_1_PSS_NOLOWER
AS 



-- REPORT 1

DECLARE
	@GetMaxRunningDate DATE,
	@GetCurrentDate DATE


select @GetMaxRunningDate = dateadd(month, datediff(month, 0, Isnull(cast(max(tanggal_EUS) as date),'2022-01-01')), 0), @GetCurrentDate = cast(getdate() as date) from Report_1 where dealer = 'AI'

Begin
		
	Delete Report_1 where cast(tanggal_EUS as date) >= @GetMaxRunningDate AND dealer = 'AI'

	Insert Into Report_1

	SELECT distinct
		Case when ISNULL(temp.data_qtyUnit, 0) < 0 then 1 else 0 end as IsReturn,
		temp.data_referenceType as sales_tipe, 
		t3.Dealer as dealer, t3.DealerName as nama_dealer, t3.GroupDealer as Group_Dealer, t3.SiteCode as Outlet, t3.SiteName as nama_outlet, t3.Area as area_dealer,
		case when sq.data_timestamp='1900-01-01 12:00:00' OR sq.data_timestamp LIKE '%0000-00-00%' then null else sq.data_timestamp end tanggal_Quotation,
		sq.data_quotationNo as no_quotation,
		case when temp.data_timestamp='1900-01-01 12:00:00' OR temp.data_timestamp LIKE '%0000-00-00%' then null else temp.data_timestamp end tanggal_SO,
		temp.data_salesOrderNo as nomer_SO, temp.data_statusSalesOrder as status_SO,
		case when temp.data_invoiceDate='1900-01-01' OR temp.data_invoiceDate='0000-00-00' then null else temp.data_invoiceDate end tanggal_EUS,
		temp.data_invoiceNo as nomer_EUS, 
		opty.data_npkSupervisor as kode_spv, opty.data_supervisor as nama_spv, opty.data_npkSalesman as kode_sales, opty.data_salesman as nama_salesman, opty.data_customerType as customer_type,
		NULL as jenis_customer, opty.data_prospectNo as customer_id, NULL as ktp,  NULL as Znpwp, 
		opty.data_namaProspect as nama_customer,  opty.data_segmentation as jenis_usaha, opty.data_segmentation as segmen, opty.data_goodType as jenis_angkutan,
		ISNULL(temp.data_qtyUnit, 0) as jumlah_unit,
		DM.MajorGroup as CV_LCV, DM.MinorGroup as Series, DM.Segment_Desc as device_class, DM.Item_Name as Type_Desc, DM.Item_Name as Material_Desc,
		sf.data_engineNo as engine_no, temp.data_deviceNo as ChassisNumber, temp.data_tahunProduksi as thn_produksi, opty.data_color as warna,
		temp.data_karoseries_karoseriType as jenis_aplikasi_karoseri,
		temp.data_karoseries_hargaKaroseriKeCustomer as biaya_karoseri,
		'FU01' as ItemGroupId,
		DM.ItemID as ItemId,
		DM.ItemID as ItemNumber,
		temp.data_tahunProduksi as tahun_pembuatan,
		sq.data_paymentType as payment_type,
		lm.ZLeasingType as jenis_leasing,
		lm.DosAccLeasingNumber as kode_leasing,
		sq.data_namaLeasing as nama_leasing,
		lm.CustClassificationGroup as group_leasing,
		sf.data_polisiNo as Polreg_number,
		NULL as Polreg_date,
		temp.data_totalDP as totalDP,
		case when EF.ApprovalDate='1900-01-01 12:00:00' OR EF.ApprovalDate LIKE '%0000-00-00%' then null else EF.ApprovalDate end approval_date,
		NULL as print_date,
		temp.data_namaFakpol as nama_fakpol,
		temp.data_bbnKotaKabupaten as area_BBN,
		temp.data_karoseries_karoseriType as aplikasi_bbn,
		temp.data_platType as jenis_plat,
		sq.data_statusPelanggaran as Status_pelanggaran,
		temp.data_pwNo as nomer_pelanggaran,
		sq.data_statusCSP as Status_CSP,
		sq.data_quotationNo as No_CSP,
		sq.data_isSDA as ZNeedSDA,
		sq.data_sdaNo as no_sda,
		NULL as sda_date, 
		temp.data_potonganSDA as Nilai_SDA_Approve,
		temp.data_potonganSDA as potongan_sda,
		temp.data_priceUnitType as priceUnitType,
		temp.data_priceList as ZPRICELIST,
		temp.data_priceUnitType as pricelistType,
		temp.data_hargaJual as Harga_Jual_ke_Cust,
		temp.data_dpMinimum as ZMinimumDP,
		NULL as TotalDisckeCust, 
		NULL as ZOtherDiscount, 
		NULL as ZProfitLoss, 
		NULL as ZAdjustmentUnit, 
		NULL as ZAksesoris, 
		NULL as ZDiskonBBN,
		temp.data_hargaJual as ZHargaJual,
		temp.data_hargaJual as ZHargaJualCust, 
		temp.data_hargaJual as ZHargaJualKendaraan, 
		NULL as ZHargaUnitExBiaya, 
		temp.data_bbnNotice as ZJasaBBN, 
		temp.data_karoseries_hargaKaroseriKeCustomer as ZKaroseri,
		temp.data_priceList as ZPriceUnitOnly,
		NULL as ZSelisihPriceUnit,
		temp.data_hargaJual as ZTotalHarga,
		temp.data_unitBBNNoticePrice as total_bbn,
		temp.data_bbnNotice as ZBBNNotice,
		NULL as ZBBNUnNotice,
		temp.data_bbnKotaKabupaten as ZBBNKotaKab,
		temp.data_biayaUbahBentuk as ZBiayaUbahBentuk,
		NULL as ZBungaTOP,
		NULL as Zkomisi,
		temp.data_ongkirIAMIKeDealer as ZOngkirIAMIDealer,
		temp.data_ongkirDealerKeCustomer as ZOngkirDealerCustomer,
		temp.data_alamatFakpol as alamatFakpol,
		temp.data_kotaFakpol as City,
		temp.data_provinsiFakpol as provinsi,
		NULL as npwp,
		temp.data_siup as ZSIUP,
		temp.data_tdp as ZTDP,
		NULL as Email,
		NULL as HP,
		NULL as Phone,
		NULL as Tlp_Kantor,
		NULL as Telp,
		opty.data_opportunityNo as No_sales_funneling,
		case when opty.data_timestamp='1900-01-01 12:00:00' OR opty.data_timestamp LIKE '%0000-00-00%' then null else opty.data_timestamp end Tgl_Funneling,
		opty.data_decisionMaker as ZDecisionMaker,
		opty.data_companyName as ZCompanyName,
		opty.data_department as ZDepartment,
		opty.data_goodType as ZGoodType,
		opty.data_goodType Barang_Yang_diangkut,
		opty.data_beratYangDiangkut as Berat_Yang_diangkut,
		NULL as CreatedBy,
		NULL as Kepemilikan_unit,
		opty.data_customerType as Katagori_customer,
		NULL as Status_Customer,
		NULL as Status,
		opty.data_npkSalesman as NPK_Salesman,
		opty.data_npkSupervisor as NPK_Supervisor,
		case when temp.data_karoseries_tglKirimKaroseri='1900-01-01' OR temp.data_karoseries_tglKirimKaroseri='0000-00-00' then null else temp.data_karoseries_tglKirimKaroseri end Tgl_Kirim_Karoseri,
		case when temp.data_tglKirimKeCustomer='1900-01-01' OR temp.data_tglKirimKeCustomer='0000-00-00' then null else temp.data_tglKirimKeCustomer end Tgl_Kirim_Customer,
		case when temp.data_tglSTNKSelesai='1900-01-01' OR temp.data_tglSTNKSelesai='0000-00-00' then null else temp.data_tglSTNKSelesai end Tgl_Jadi_STNK,
		sf.data_polisiNo as NO_Polisi,
		sf.data_stnkNo as No_STNK,
		case when sf.data_stnkDate='1900-01-01' OR sf.data_stnkDate='0000-00-00' then null else sf.data_stnkDate end STNK_Date,
		case when sf.data_grBPKBDate='1900-01-01' OR sf.data_grBPKBDate='0000-00-00' then null else sf.data_grBPKBDate end Tgl_Jadi_BPKB,
		sf.data_bpkbNo as No_BPKB,
		case when sf.data_bpkbDate='1900-01-01' OR sf.data_bpkbDate='0000-00-00' then null else sf.data_bpkbDate end BPKB_Date,
		NULL as Tanggal_Serah_terima_STNK,
		NULL as Tanggal_Serah_terima_BPKB, 
		Ok.data_shippingVendorNo as No_Vendor_Expedsi,
		Ok.data_shippingVendorName as Nama_Vendor_Expedsi,
		Ok.data_shippingVendorAddress as Alamat_vendor_Expedisi,
		KABBN.data_vendorNo as No_Vendor_BBn,
		KABBN.data_vendorName as Nama_vendor_BBn,
		NULL as alamat_vendor_bbn,
		KA.data_vendorNo as No_Vendor_Karoseri,
		KA.data_vendorName as Nama_vendor_Karoseri,
		NULL as alamat_vendor_karoseri,
		NULL as CreatedBy1,
		GETDATE() as CreatedDateTime1,
		---[dbo].name_masking_function(opty.data_namaProspect) MaskingName
		po.MaskedName as MaskingName

	FROM 
	(
		SELECT DISTINCT
		so.data_kodeOutlet, so.data_itemNo,
		so.data_salesOrderNo, so.data_quotationNo, so.data_timestamp, so.data_statusSalesOrder
		,CASE WHEN so.data_karoseries_karoseriType='-' THEN 'OTHERS' WHEN so.data_karoseries_karoseriType is null THEN null ELSE MK.Karoseri_Type_IAMI_DOS END AS data_karoseries_karoseriType
		,so.data_karoseries_namaKaroseri, so.data_tahunProduksi
		,so.data_namaLeasing, so.data_totalDP, so.data_namaFakpol
		,so.data_platType, so.data_pwNo, so.data_potonganSDA, so.data_priceUnitType, so.data_priceList
		,so.data_hargaJual, so.data_dpMinimum, so.data_karoseries_tglKirimKaroseri, so.data_tglKirimKeCustomer
		,so.data_opportunityNo, so.data_tglSTNKSelesai, so.data_bbnKotaKabupaten, so.data_biayaUbahBentuk
		,so.data_bbnNotice  --No Mapping
		,so.data_siup,  so.data_tdp
		,so.data_karoseries_hargaKaroseriKeCustomer 
		,so.data_deviceNo
		,soinv.data_invoiceDate
		,soinv.data_referenceType
		,soinv.data_invoiceNo
		,soinv.data_unitBBNNoticePrice
		,soinv.data_qtyUnit
		,so.data_ongkirIAMIKeDealer
		,so.data_ongkirDealerKeCustomer 
		,so.data_alamatFakpol 
		,so.data_kotaFakpol
		,so.data_provinsiFakpol
		,ROW_NUMBER() OVER (PARTITION BY soinv.data_referenceType,so.data_deviceNo ORDER BY soinv.data_referenceType,so.data_timestamp DESC) rn
		,ROW_NUMBER() OVER (PARTITION BY soinv.data_invoiceNo order by soinv.data_invoiceDate desc) rm
		FROM SILVER_WAREHOUSE.dbo.sales_invoiceSO soinv
		INNER JOIN SILVER_WAREHOUSE.dbo.sales_salesOrder so ON so.data_salesOrderNo=soinv.data_referenceNo
		LEFT JOIN SILVER_WAREHOUSE.dbo.AGIT_MAPPING_KAROSERI MK ON so.data_karoseries_karoseriType=MK.Karoseri_type_PSS
		WHERE cast(soinv.data_invoiceDate as date) between  @GetMaxRunningDate and @GetCurrentDate 
	) temp
	LEFT JOIN SILVER_WAREHOUSE.dbo.site_mapping sm ON sm.SiteCodePSS=temp.data_kodeOutlet
	LEFT JOIN SILVER_WAREHOUSE.dbo.ZAISITES t3 ON t3.SiteCode  = sm.SiteCode
	LEFT JOIN SILVER_WAREHOUSE.dbo.sales_quotation sq ON sq.data_quotationNo=temp.data_quotationNo
	LEFT JOIN SILVER_WAREHOUSE.dbo.sales_Opportunity opty ON sq.data_opportunityNo=opty.data_opportunityNo
	LEFT JOIN vw_DeviceModel_PSS DM on DM.ItemID = temp.data_itemNo  
	LEFT JOIN SILVER_WAREHOUSE.dbo.Leasing_mapping lm on temp.data_namaLeasing=lm.PSSLeasingName
			LEFT JOIN (Select * From
					(
					select  ROW_NUMBER() OVER (PARTITION BY sf.data_salesOrderNo order by sf.data_timestamp desc) rn,
							sf.data_salesOrderNo, sf.data_engineNo, sf.data_polisiNo, 
							sf.data_stnkNo, sf.data_stnkDate, sf.data_grBPKBDate,
							sf.data_bpkbNo,	sf.data_bpkbDate, sf.data_vin
					from SILVER_WAREHOUSE.dbo.sales_fakpol sf
					)x
				where x.rn = 1) sf on sf.data_salesOrderNo = temp.data_salesOrderNo
			left join SILVER_WAREHOUSE.dbo.AGITEFakpol EF on EF.ChassisNumber=sf.data_vin
			LEFT JOIN SILVER_WAREHOUSE.dbo.Leasing_mapping t6 ON t6.PSSLeasingName = sq.data_namaLeasing 
			left join SILVER_WAREHOUSE.dbo.sales_POKarAkse KA on KA.data_referenceNo = temp.data_salesOrderNo and KA.data_purchaseOrderType='Karoseri'
			left join SILVER_WAREHOUSE.dbo.sales_POKarAkse KABBN on KABBN.data_referenceNo = temp.data_salesOrderNo and KABBN.data_purchaseOrderType='BBN' and SUBSTRING(KABBN.data_transactionNo,5,3)='VBB' and KABBN.data_poStatus='Invoice'
			left join (Select *
						From
						(
							select  ROW_NUMBER() OVER (PARTITION BY ok.data_vin order by ok.data_vin desc) Okk, 
									ok.data_vin, ok.data_shippingVendorNo, ok.data_shippingVendorName, ok.data_shippingVendorAddress
							from SILVER_WAREHOUSE.dbo.sales_OKK ok
							Where ok.data_okkType = 'Outlet-Customer' and ok.data_okkStatus = 'Completed' 
						)y
						where y.Okk = 1)Ok on Ok.data_vin = temp.data_deviceNo
	CROSS APPLY SILVER_WAREHOUSE.dbo.name_masking_function(opty.data_namaProspect) as po
	WHERE temp.rn=1 and temp.rm = 1 
		
End