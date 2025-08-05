CREATE PROCEDURE [dbo].[SP_Report_Fakpol_PSS]
AS



DECLARE
	@GetMaxRunningDate DATE,
	@GetCurrentDate DATE
	

select @GetMaxRunningDate = dateadd(month, datediff(month, 0, Isnull(cast(max(ApprovalDate) as date),'2022-01-01')), 0), @GetCurrentDate = cast(getdate() as date) from GOLD_WAREHOUSE.dbo.Report_Fakpol where DealerCategory = 'AI'


Begin

	Delete Report_Fakpol where cast(ApprovalDate as date) >= @GetMaxRunningDate AND DealerCategory = 'AI'

	Insert Into Report_Fakpol
	
	SELECT DealerCategory, KodeDealer, DealerName, Group_Dealer, KodeOutlet, OutletName, Area,	
		InvoiceDate, InvoiceNo,	CustomerID,	CustomerName,	
		Nama_STNK_BPKB,	KTP, TDP, Alamat, City,	Province, 
		TanggalPengajuanFakpol,	NoPengajuanFakpol, CreatedDate,	ApprovalDate, PrintedDate, 
		TglFakpol, NoFakpol, Jenis_Plat, StatusFakpol, NamaFakpol, AlamatFakpol, ProvinsiFakpol, CityFakpol, KecamatanFakpol, KelurahanFakpol, KodePosFakpol,	
		Phone, Email,	
		CV_LCV,	Series,	tipe_series, Segment_Desc, Type_Desc, Color, ChassisNumber,	 Engine_Number,	
		Leasing_Group, Nama_Leasing, Leasing_ID, Aplikasi_Karoseri,	
		Supervisor,	Nama_Supervisor, Salesman, Nama_Salesman,	
		GR_FakpolID, GR_FakpolDate,	GR_STNKID, GR_STNKDate,	
		GoodIssueStnkNo, GoodIssueStnkDate,	
		Nama_Penerima_STNK,	KTP_Penerima_STNK, Alamat_Penerima_STNK,	
		GR_BPKBID, GR_BPKBDate,	GI_BPKBID, GI_BPKBDate,	
		Nama_Penerima_BPKB,	KTP_Penerima_BPKB,	Alamat_Penerima_BPKB, ItemNo, Last_Update, Source,
		[dbo].name_masking_function(CustomerName) MaskingName
	
	FROM		
	(		
	SELECT DISTINCT						
		aef.DealerCategory as DealerCategory,	
		CASE 	
			WHEN aef.DealerCategory = 'AI' THEN 'AI'
		END as KodeDealer,	
		CASE 	
			WHEN aef.DealerCategory = 'AI' THEN 'PT. AI-ISUZU SALES OPERATION'
		END as DealerName,	
		CASE 	
			WHEN aef.DealerCategory = 'AI' THEN 'PT. AI-ISUZU SALES OPERATION'
		END as Group_Dealer,	
		CASE	
			WHEN sm2.SiteCode is null THEN sm3.SiteCode
			ELSE sm2.SiteCode
		END as KodeOutlet,	
		CASE 	
			WHEN st2.SiteName is null THEN st3.SiteName
			ELSE st2.SiteName
		END as OutletName,	
		CASE 	
			WHEN st2.Area is null THEN st3.Area
			ELSE st2.Area
		END as Area,	
		case when aef.InvoiceDate='1900-01-01 12:00:00' OR aef.InvoiceDate LIKE '%0000-00-00%' then null else aef.InvoiceDate end AS InvoiceDate,	
		CASE	
			WHEN sio.data_invoiceNo is null THEN sio2.data_invoiceNo
			ELSE sio.data_invoiceNo
		END AS InvoiceNo,	
		CASE	
			WHEN sf.data_kodeCustomer is null THEN op.data_prospectNo
			ELSE sf.data_kodeCustomer
		END AS CustomerID,	
		aef.CustomerName as CustomerName,	
		sf.data_namaSTNKBPKB as Nama_STNK_BPKB,	
		aef.ktp as KTP,	
		aef.tdp as TDP,	
		aef.alamat as Alamat,	
		aef.city as City,	
		sf.data_state as Province,	
		aef.TanggalPengajuanFakpol as TanggalPengajuanFakpol,	
		aef.NoPengajuanFakpol as NoPengajuanFakpol,	
		case when aef.CreatedDate='1900-01-01 12:00:00' OR aef.CreatedDate LIKE '%0000-00-00%' then null else aef.CreatedDate end AS CreatedDate,	
		case when aef.ApprovalDate='1900-01-01 12:00:00' OR aef.ApprovalDate LIKE '%0000-00-00%' then null else aef.ApprovalDate end AS ApprovalDate,	
		case when aef.PrintedDate='1900-01-01 12:00:00' OR aef.PrintedDate LIKE '%0000-00-00%' then null else aef.PrintedDate end AS PrintedDate,	
		case when aef.TglFakpol='1900-01-01 12:00:00' OR aef.TglFakpol LIKE '%0000-00-00%' then null else aef.TglFakpol end AS TglFakpol,	
		aef.NoFakpol as NoFakpol,	
		sso.data_platType as Jenis_Plat,	
		aef.StatusFakpol as StatusFakpol,	
		aef.NamaFakpol as NamaFakpol,	
		aef.AlamatFakpol as AlamatFakpol,	
		sf.data_state as ProvinsiFakpol,	
		aef.CityFakpol as CityFakpol,	
		aef.KecamatanFakpol as KecamatanFakpol,	
		aef.KelurahanFakpol as KelurahanFakpol,	
		aef.KodePosFakpol as KodePosFakpol,	
		sf.data_phoneNo as Phone,	
		aef.Email as Email,	
		CASE	
			WHEN ZIT1.AMItemMajorGroupId  is null THEN ZIT2.AMItemMajorGroupId 
			ELSE ZIT1.AMItemMajorGroupId 
		END AS CV_LCV,	
		CASE	
			WHEN ZIT1.AMItemMinorGroupId  is null THEN ZIT2.AMItemMinorGroupId 
			ELSE ZIT1.AMItemMinorGroupId 
		END AS Series,	
		CASE	
			WHEN ZIT1.ZSeriesType  is null THEN ZIT2.ZSeriesType 
			ELSE ZIT1.ZSeriesType 
		END AS tipe_series,	
		CASE	
			WHEN DM1.ClassId  is null THEN DM2.ClassId 
			ELSE DM1.ClassId 
		END AS Segment_Desc,	
		CASE	
			WHEN DM1.Name is null THEN DM2.Name
			ELSE DM1.Name
		END AS Type_Desc,	
		aef.Color as Color,	
		aef.ChassisNumber as ChassisNumber,	
		aef.Engine_Number as Engine_Number,	
		t6.CustClassificationGroup as Leasing_Group,	
		sso.data_namaLeasing as Nama_Leasing,	
		t6.DosAccLeasingNumber as Leasing_ID,	
		CASE	
			WHEN sso.data_karoseries_karoseriType = '-' THEN 'OTHERS'
			ELSE sso.data_karoseries_karoseriType
		END AS Aplikasi_Karoseri,	
		op.data_NPKSupervisor as Supervisor,	
		op.data_Supervisor as Nama_Supervisor,	
		op.data_NPKSalesman as Salesman,	
		op.data_Salesman as Nama_Salesman,	
		sf.data_grFakpolNo  as GR_FakpolID,	
		case when sf.data_grFakpolDate='1900-01-01 12:00:00' OR sf.data_grFakpolDate LIKE '%0000-00-00%' then null else sf.data_grFakpolDate end AS GR_FakpolDate,	
		sf.data_grSTNKNo as  GR_STNKID,	
		case when sf.data_stnkDate='1900-01-01 12:00:00' OR sf.data_stnkDate LIKE '%0000-00-00%' then null else sf.data_stnkDate end AS GR_STNKDate,	
		'' as GoodIssueStnkNo,--ada perbedaan nama field dengan di table 	
		'' as GoodIssueStnkDate,--ada perbedaan nama field dengan di table	
		sf.data_namaPenerimaSTNK as Nama_Penerima_STNK,	
		sf.data_ktpPenerimaSTNK as KTP_Penerima_STNK,	
		sf.data_alamatPenerimaSTNK as Alamat_Penerima_STNK,	
		sf.data_grBPKBNo as GR_BPKBID,	
		case when sf.data_grBPKBDate='1900-01-01 12:00:00' OR sf.data_grBPKBDate LIKE '%0000-00-00%' then null else sf.data_grBPKBDate end AS GR_BPKBDate,	
		sf.data_bpkbNo as GI_BPKBID,	
		case when sf.data_bpkbDate='1900-01-01 12:00:00' OR sf.data_bpkbDate LIKE '%0000-00-00%' then null else sf.data_bpkbDate end AS GI_BPKBDate,	
		sf.data_namaPenerimaBPKB as Nama_Penerima_BPKB,	
		sf.data_ktpPenerimaBPKB as KTP_Penerima_BPKB,	
		sf.data_alamatPenerimaBPKB as Alamat_Penerima_BPKB,	
		CASE	
			WHEN sf.data_itemNo is null THEN sso.data_itemNo
			ELSE sf.data_itemNo
		END AS ItemNo,	
		GETDATE() as Last_Update,	
		'WEB' as Source,
		data_karoseries_namaKaroseri as 'KaroseriDescription',	
		Convert(int, ROW_NUMBER() OVER(PARTITION BY aef.ChassisNumber ORDER BY aef.CreatedDate DESC)) AS rn
		FROM SILVER_WAREHOUSE.dbo.AGITEFakpol aef	
		LEFT JOIN SILVER_WAREHOUSE.dbo.sales_fakpol sf ON sf.data_vin=aef.ChassisNumber	
		LEFT JOIN SILVER_WAREHOUSE.dbo.DeviceModel DM1 on DM1.ModelId=sf.data_itemNo	
		LEFT JOIN SILVER_WAREHOUSE.dbo.ZInventTables ZIT1 on ZIT1.ItemId = sf.data_itemNo and ZIT1.dataAreaId = 'zir'	
		LEFT JOIN SILVER_WAREHOUSE.dbo.site_mapping sm2 ON sm2.SiteCodePSS = sf.data_kodeOutlet	
		LEFT JOIN SILVER_WAREHOUSE.dbo.ZAISITES st2 ON st2.SiteCode  = sm2.SiteCode	
		LEFT JOIN SILVER_WAREHOUSE.dbo.sales_invoiceSO sio ON sio.data_referenceNo = sf.data_salesOrderNo	
		LEFT JOIN SILVER_WAREHOUSE.dbo.sales_salesOrder sso ON sso.data_deviceNo=aef.ChassisNumber	
		LEFT JOIN SILVER_WAREHOUSE.dbo.DeviceModel DM2 on DM2.ModelId=sso.data_itemNo	
		LEFT JOIN SILVER_WAREHOUSE.dbo.ZInventTables ZIT2 on ZIT2.ItemId = sso.data_itemNo	 and ZIT2.dataAreaId = 'zir'
		LEFT JOIN SILVER_WAREHOUSE.dbo.site_mapping sm3 ON sm3.SiteCodePSS = sso.data_kodeOutlet	
		LEFT JOIN SILVER_WAREHOUSE.dbo.ZAISITES st3 ON st3.SiteCode  = sm3.SiteCode	
		LEFT JOIN SILVER_WAREHOUSE.dbo.sales_invoiceSO sio2 ON sio2.data_referenceNo = sso.data_salesOrderNo	
		LEFT JOIN SILVER_WAREHOUSE.dbo.Leasing_mapping t6 ON t6.PSSLeasingName = sso.data_namaLeasing	
		LEFT JOIN SILVER_WAREHOUSE.dbo.sales_Opportunity op ON op.data_opportunityNo = sso.data_opportunityNo	
		WHERE aef.DealerCategory = 'AI' AND	
		cast(aef.ApprovalDate as date) between @GetMaxRunningDate and @GetCurrentDate	
	) AS TempReportFakpolPSS			
	WHERE rn = 1
		
	End