CREATE PROCEDURE dbo.SP_FAKPOL_NON_AI_NOLOWER
AS 
BEGIN

	SET NOCOUNT ON;

	DECLARE @DateFrom date, @DateTo date
	
	SELECT @DateFrom = DATEADD(DAY, -30, DATEADD(HOUR, 7, GETDATE()));
	SELECT @DateTo   = DATEADD(DAY,  0, DATEADD(HOUR, 7, GETDATE()));

	Delete Report_Fakpol Where ApprovalDate between @DateFrom and @DateTo
	
    insert into Report_Fakpol
    select distinct
	'Non AI' DealerCategory, 
		a.dataAreaId KodeDealer,
		b1.Description DealerName,
		b.Group_Dealer,
		a.Site KodeOutlet, 
		b.Name OutletName, 
		b.AreaCode +' - '+b.ZIAMIArea Area,
		a.InvoiceDate, 
		a.InvoiceNo, 
		a.CustomerNo CustomerID, 
		a8.Name CustomerName,
		a.STNKBPKBName Nama_STNK_BPKB, 
		a.KTP, 
		a.TDP, 
		a.Address1 Alamat, 
		a.City, 
		a.State Province, 
		a.CreatedDateTime1 TanggalPengajuanFakpol, 
		a.PengajuanFakpolNo NoPengajuanFakpol, 
		Isnull(s.CreatedDate,a.CreatedDateTime1) CreatedDate,
		Isnull(s.ApprovalDate,a.ApprovedDate) ApprovalDate,
		Isnull(s.PrintedDate,a.PrintedDate) PrintedDate,
		Isnull(s.TglFakpol,a.ReceiptDate) as TglFakpol, 
		a.FakpolNo NoFakpol,
		d.ZPlatType Jenis_Plat,
		a.Status StatusFakpol,
		a.STNKBPKBName NamaFakpol, 
		a.Address1 AlamatFakpol, 
		a.State ProvinsiFakpol, 
		a.City CityFakpol, 
		a.Kecamatan KecamatanFakpol, 
		a.Kelurahan KelurahanFakpol, 
		a.KodePos KodePosFakpol, 
		a.ZFakpolPhoneNum Phone, 
		a.ZFakpolEmail Email,  
		i.AMItemMajorGroupId CV_LCV, 
		i.AMItemMinorGroupId Series, i.ZSeriesType tipe_series,
		DM.ClassId Segment_Desc,
		a.ItemName Type_Desc,  
		a.Color,
		a.VIN ChassisNumber,
		a.EngineNo Engine_Number,
		n.CustClassificationId Leasing_Group,
		o.Name Nama_Leasing, n.AccountNum Leasing_ID,
		d.ZKaroseriType Aplikasi_Karoseri,
		f.ZSupervisor Supervisor, 
		p2.Name Nama_Supervisor,
		f.ZSalesman Salesman, 
		q2.Name Nama_Salesman,
		a.GRFakpolNo GR_FakpolID, 
		a2.ReceiptDate GR_FakpolDate,
		a.GRSTNKNo GR_STNKID, 
		a3.STNKFinishedDate  GR_STNKDate, 
		a.GISTNKNo GI_STNKID, 
		a4.[Date] GI_STNKDate, 
		a4.Name Nama_Penerima_STNK, 
		a4.KTP KTP_Penerima_STNK, 
		a4.Address Alamat_Penerima_STNK,
		a.GRBPKBNo GR_BPKBID, 
		a5.BPKBFinisihedDate GR_BPKBDate,
		a.GIBPKBNo GI_BPKBID, 
		a6.[Date] GI_BPKBDate, 
		a6.Name Nama_Penerima_BPKB, 
		a6.KTP KTP_Penerima_BPKB, 
		a6.Address Alamat_Penerima_BPKB, a.ItemNo, getdate() Last_Update,'DOS',
		m.MaskedName
		from SILVER_WAREHOUSE.dbo.ZEFakpol a
				left join SILVER_WAREHOUSE.dbo.ZInventSites b on LOWER(b.SiteId) = LOWER(a.Site)
				left join SILVER_WAREHOUSE.dbo.Ledger b1 on LOWER(b1.LegalEntityId) = LOWER(b.dataAreaId)
				left join SILVER_WAREHOUSE.dbo.ZGoodReceiptFakpol c on LOWER(c.PengajuanFakpolNo) = LOWER(a.dataAreaId)
				left join SILVER_WAREHOUSE.dbo.ZSalesOrderLine  d  on LOWER(d.SalesOrderNumber)  = LOWER(a.SalesOrderNo) and LOWER(d.ItemNumber) = LOWER(a.ItemNo) 
				left join SILVER_WAREHOUSE.dbo.ZSalesOrderHeader  f on LOWER(f.SalesId)  = LOWER(a.SalesOrderNo) 
				left join SILVER_WAREHOUSE.dbo.ZInventTables  i on LOWER(i.ItemId) = LOWER(a.ItemNo) and LOWER(i.dataAreaId) = LOWER(a.dataAreaId)
				left join SILVER_WAREHOUSE.dbo.DeviceModel DM on LOWER(DM.ModelId)=LOWER(i.ItemId)
				left join SILVER_WAREHOUSE.dbo.DeviceTable k on LOWER(k.DeviceId) = LOWER(a.VIN) and LOWER(k.dataAreaId) = LOWER(a.dataAreaId)
				left join SILVER_WAREHOUSE.dbo.ZCustomers n on n.AccountNum = LOWER(f.ZLeasing) and LOWER(n.dataAreaId) = LOWER(f.dataAreaId)
				left join SILVER_WAREHOUSE.dbo.DirPartyTable o on LOWER(o.RecordId) = LOWER(n.Party)
				left join SILVER_WAREHOUSE.dbo.Worker p1 on LOWER(p1.PersonnelNumber) = LOWER(f.ZSupervisor)
				left join SILVER_WAREHOUSE.dbo.DirPartyTable p2 on LOWER(p2.RecordId) = LOWER(p1.Person1)
				left join SILVER_WAREHOUSE.dbo.Worker q1 on LOWER(q1.PersonnelNumber) = LOWER(f.ZSalesman)
				left join SILVER_WAREHOUSE.dbo.DirPartyTable q2 on LOWER(q2.RecordId) = LOWER(q1.Person1)
				left join SILVER_WAREHOUSE.dbo.ZGoodReceiptFakpol a2 on LOWER(a2.PengajuanFakpolNo) = LOWER(a.PengajuanFakpolNo)
				left join SILVER_WAREHOUSE.dbo.ZGoodReceiptSTNK a3 on LOWER(a3.PengajuanFakpolNo) = LOWER(a.PengajuanFakpolNo)
				left join SILVER_WAREHOUSE.dbo.ZGoodIssueSTNK a4 on LOWER(a4.PengajuanNoFakpol) = LOWER(a.PengajuanFakpolNo)
				left join SILVER_WAREHOUSE.dbo.ZGoodReceiptBPKB a5 on LOWER(a5.PengajuanFakpolNo) = LOWER(a.PengajuanFakpolNo)
				left join SILVER_WAREHOUSE.dbo.ZGoodIssueBPKB a6 on LOWER(a6.PengajuanFakpolNo) = LOWER(a.PengajuanFakpolNo)
				left join SILVER_WAREHOUSE.dbo.ZCustomers a7 on LOWER(a7.AccountNum) = LOWER(a.CustomerNo) and LOWER(a7.dataAreaId) = LOWER(a.dataAreaId)
				left join SILVER_WAREHOUSE.dbo.DirPartyTable a8 on LOWER(a8.RecordId) = LOWER(a7.Party) 
				inner join (select VIN , Min(PrintedDate) PRINTEDDATE, min(RecordId) RecordId 
							from SILVER_WAREHOUSE.dbo.ZEFakpol where ApprovedDate > '1900-01-01 12:00:00.000' group by VIN) r on r.RecordId = a.RecordId
				left join SILVER_WAREHOUSE.dbo.AGITEFakpol s on s.ChassisNumber = a.VIN
				CROSS APPLY SILVER_WAREHOUSE.dbo.name_masking_function(a8.Name) as m
		where a.ApprovedDate > '1900-01-01 12:00:00.000' 
		  and (a.ApprovedDate between @DateFrom and @DateTo)

		union all
		Select 
		x.DealerCategory, 
		x.KodeDealer, 
		x.DealerName, 
		x.Group_Dealer, 
		x.KodeOutlet, 
		x.OutletName, 
		x.Area,
		x.InvoiceDate, 
		x.InvoiceNo, 
		x.CustomerID, 
		x.CustomerName,
		x.Nama_STNK_BPKB, 
		x.KTP, 
		x.TDP, 
		x.Alamat, 
		x.City, 
		x.Province,
		x.TanggalPengajuanFakpol, 
		x.NoPengajuanFakpol, 
		x.CreatedDate, 
		x.ApprovalDate, 
		x.PrintedDate, 
		x.TglFakpol, 
		x.NoFakpol, 
		x.Jenis_Plat,
		x.StatusFakpol, 
		x.NamaFakpol, 
		x.AlamatFakpol, 
		x.ProvinsiFakpol, 
		x.CityFakpol, 
		x.KecamatanFakpol, 
		x.KelurahanFakpol, 
		x.KodePosFakpol,
		x.Phone, 
		x.Email,
		e.AMItemMajorGroupId CV_LCV, 
		e.AMItemMinorGroupId Series, 
		e.ZSeriesType tipe_series, 
		x.Segment_Desc, 
		e.NameAlias Type_desc, 
		x.Color,
		x.ChassisNumber, 
		x.Engine_Number, 
		x.Leasing_Group, 
		x.Nama_Leasing, 
		x.Leasing_ID, 
		x.Aplikasi_Karoseri,
		x.Supervisor, 
		x.Nama_Supervisor, 
		x.Salesman, 
		x.Nama_Salesman,
		x.GR_FakpolID, 
		x.GR_FakpolDate, 
		x.GR_STNKID, 
		x.GR_STNKDate, 
		x.GI_STNKID, 
		x.GI_STNKDate,
		x.Nama_Penerima_STNK, 
		x.KTP_Penerima_STNK, 
		x.Alamat_Penerima_STNK, 
		x.GR_BPKBID, 
		x.GR_BPKBDate, 
		x.GI_BPKBID, 
		x.GI_BPKBDate, 
		x.Nama_Penerima_BPKB,
		x.KTP_Penerima_BPKB, 
		x.Alamat_Penerima_BPKB, 
		x.ItemNo, 
		GETDATE() Last_Update,
		'WEB',
		m.MaskedName
	from
	(
	select  
	d1.SalesId,
	a.DealerCategory, 
	m.dataAreaId KodeDealer, 
	led.Description DealerName, 
	m.Group_Dealer,
	Isnull(Isnull(a.KodeOutlet,c.KodeOutlet),
	left(PurchInventRefId,5)) as KodeOutlet,
	m.Name OutletName, 
	m.AreaCode+' - '+m.ZIAMIArea Area,
	Cast(Isnull(d1.InvoiceDate,c.TglEUS) as Date) InvoiceDate, 
	Isnull(b.SalesInvoiceId,c.NoEUS) InvoiceNo, 
	d1.OrderAccount CustomerID, 
	isnull(g.Name, a.CustomerName) CustomerName,
	NULL Nama_STNK_BPKB, 
	a.KTP, 
	a.TDP, 
	a.Alamat, 
	a.City, 
	NULL Province,
	a.TanggalPengajuanFakpol, 
	a.NoPengajuanFakpol, 
	a.CreatedDate, 
	a.ApprovalDate, 
	a.PrintedDate, 
	a.TglFakpol, 
	a.NoFakpol, 
	NULL Jenis_Plat,
	a.StatusFakpol, 
	a.NamaFakpol, 
	a.AlamatFakpol, 
	NULL ProvinsiFakpol, 
	a.CityFakpol, 
	a.KecamatanFakpol, 
	a.KelurahanFakpol, 
	a.KodePosFakpol,
	NULL Phone, 
	a.Email, 
	DM.ClassId Segment_Desc,
	a.Color,  
	a.ChassisNumber, 
	a.Engine_Number, 
	NULL Leasing_Group, 
	NULL Nama_Leasing, 
	NULL Leasing_ID, 
	NULL Aplikasi_Karoseri,
	NULL Supervisor, 
	c.Supervisor Nama_Supervisor, 
	NULL Salesman, 
	c.Sales Nama_Salesman,
	NULL GR_FakpolID, 
	NULL GR_FakpolDate, 
	NULL GR_STNKID, 
	NULL GR_STNKDate, 
	NULL GI_STNKID, 
	NULL GI_STNKDate,
	NULL Nama_Penerima_STNK, 
	NULL KTP_Penerima_STNK, 
	NULL Alamat_Penerima_STNK, 
	NULL GR_BPKBID, 
	NULL GR_BPKBDate, 
	NULL GI_BPKBID, 
	NULL GI_BPKBDate, 
	NULL Nama_Penerima_BPKB,
	NULL KTP_Penerima_BPKB, 
	NULL Alamat_Penerima_BPKB,	
	Isnull(b.ItemId, c.SDAItemNumber) ItemNo 
	from SILVER_WAREHOUSE.dbo.AGITEFakpol a	
		left join SILVER_WAREHOUSE.dbo.DeviceTableMasters k on LOWER(k.MasterId) = LOWER(a.ChassisNumber)
		left join SILVER_WAREHOUSE.dbo.DeviceTable b on LOWER(b.DeviceId) = LOWER(a.ChassisNumber) and LOWER(b.PurchInventRefId) != '' and lower(b.dataAreaId) != 'kzu' and LOWER(b.SalesInvoiceId) != ''
		left join SILVER_WAREHOUSE.dbo.ZTempFakpol c on LOWER(c.NoRangka) = LOWER(a.ChassisNumber)
		left join SILVER_WAREHOUSE.dbo.ZCustInvoiceTrans d on LOWER(d.InvoiceId) = LOWER(b.SalesInvoiceId) and LOWER(d.ItemId) = LOWER(k.ModelId)
		left join SILVER_WAREHOUSE.dbo.CustInvoiceJour d1 on LOWER(d1.InvoiceId) = LOWER(d.InvoiceId)
		left join SILVER_WAREHOUSE.dbo.ZCustomers f on f.AccountNum = d1.OrderAccount and f.dataAreaId = left(Isnull(Isnull(a.KodeOutlet,c.KodeOutlet),left(SalesInvoiceId,5)),3)
		left join SILVER_WAREHOUSE.dbo.DirPartyTable g on g.RecordId = f.Party
		left join SILVER_WAREHOUSE.dbo.ZInventSites m on m.SiteId = Isnull(Isnull(a.KodeOutlet,c.KodeOutlet),left(PurchInventRefId,5))
		left join SILVER_WAREHOUSE.dbo.ZInventTables e on e.dataAreaId = m.dataAreaId and e.ItemId = Isnull(b.ItemId, c.SDAItemNumber)
		left join SILVER_WAREHOUSE.dbo.DeviceModel DM on DM.ModelId = Isnull(b.ItemId, c.SDAItemNumber)
		left join SILVER_WAREHOUSE.dbo.Ledger led on LOWER(led.LegalEntityId) = m.dataAreaId
	where DealerCategory = 'Non AI' 
		and convert(char,a.ApprovalDate,112) > '20200101' 
		and (a.ApprovalDate between @DateFrom and @DateTo)
		--and a.ChassisNumber in ('MHCNMR71HKJ112844','MHCN1R71LLJ113514')
		and a.ChassisNumber not in (select VIN from SILVER_WAREHOUSE.dbo.ZEFakpol where ApprovedDate > '1900-01-01 12:00:00.000' group by VIN)
	)x
		left join SILVER_WAREHOUSE.dbo.ZInventTables e on e.dataAreaId = x.KodeDealer and e.ItemId = x.ItemNo
		CROSS APPLY SILVER_WAREHOUSE.dbo.name_masking_function(x.CustomerName) as m
	END