CREATE PROCEDURE [dbo].[SP_REPORT_FAKPOL_CLEANSING]

AS
BEGIN

	SET NOCOUNT ON;

	--Update data WEB Fakpol Outlet kosong dengan data DOS
	Update Report_Fakpol
	set KodeDealer = a.dataAreaId, DealerName = b.ZDealerSales, Group_Dealer = b.Group_Dealer, KodeOutlet = a.Site, OutletName = b.Name, Area = b.AreaCode +' - '+b.ZIAMIArea,
		InvoiceDate = a.InvoiceDate, InvoiceNo = a.InvoiceNo, CustomerID = a.CustomerNo, CustomerName = a8.Name,
		Nama_STNK_BPKB = a.STNKBPKBName, TDP = a.TDP, Province = a.State, ProvinsiFakpol = a.State, 
		TanggalPengajuanFakpol = a.CreatedDateTime1, NoPengajuanFakpol = a.PengajuanFakpolNo, 
		Jenis_Plat = d.ZPlatType, Phone = a.ZFakpolPhoneNum, 
		CV_LCV = i.AMItemMajorGroupId, Series = a.Type, tipe_series = i.ZSeriesType, Type_Desc = a.ItemName, 
		Leasing_Group = n.CustClassificationId, Nama_Leasing = o.Name, Leasing_ID = n.AccountNum, Aplikasi_Karoseri = d.ZKaroseriType,
		Supervisor = f.ZSupervisor, Nama_Supervisor = p2.Name, Salesman = f.ZSalesman, Nama_Salesman = q2.Name, 
		GR_FakpolID = a.GRFakpolNo, GR_FakpolDate = a2.ReceiptDate,	GR_STNKID = a.GRSTNKNo, GR_STNKDate = a3.STNKFinishedDate, GI_STNKID = a.GISTNKNo, GI_STNKDate = a4.[Date], 
		Nama_Penerima_STNK = a4.Name, KTP_Penerima_STNK = a4.KTP, Alamat_Penerima_STNK = a4.Address, GR_BPKBID = a.GRBPKBNo, GR_BPKBDate = a5.BPKBFinisihedDate,
		GI_BPKBID = a.GIBPKBNo, GI_BPKBDate = a6.[Date], Nama_Penerima_BPKB = a6.Name, KTP_Penerima_BPKB = a6.KTP, Alamat_Penerima_BPKB = a6.Address, ItemNo = a.ItemNo
	from SILVER_WAREHOUSE.dbo.ZEFakpol a
		inner join Report_Fakpol x on x.ChassisNumber = a.VIN and x.KodeOutlet is null
		left join SILVER_WAREHOUSE.dbo.ZInventSites b on b.SiteId = a.Site
		left join SILVER_WAREHOUSE.dbo.ZGoodReceiptFakpol c on c.PengajuanFakpolNo = a.PengajuanFakpolNo
		left join SILVER_WAREHOUSE.dbo.ZSalesOrderLine  d  on d.SalesOrderNumber  = a.SalesOrderNo and d.ItemNumber = a.ItemNo 
		left join SILVER_WAREHOUSE.dbo.ZSalesOrderHeader  f on f.SalesId  = a.SalesOrderNo 
		left join SILVER_WAREHOUSE.dbo.ZInventTables  i on i.ItemId = a.ItemNo and i.dataAreaId = a.dataAreaId
		left join SILVER_WAREHOUSE.dbo.DeviceTableMasters j on j.MasterId = a.VIN 
		left join SILVER_WAREHOUSE.dbo.DeviceTable k on k.DeviceId = a.VIN and k.dataAreaId = a.dataAreaId
		left join SILVER_WAREHOUSE.dbo.DeviceClass l on l.ClassId = j.ClassId
		left join SILVER_WAREHOUSE.dbo.ZCustomers n on n.AccountNum = f.ZLeasing and n.dataAreaId = f.dataAreaId
		left join SILVER_WAREHOUSE.dbo.DirPartyTable o on o.RecordId = n.Party 
		left join SILVER_WAREHOUSE.dbo.Worker p1 on p1.PersonnelNumber = f.ZSupervisor
		left join SILVER_WAREHOUSE.dbo.DirPartyTable p2 on p2.RecordId = p1.Person1
		left join SILVER_WAREHOUSE.dbo.Worker q1 on q1.PersonnelNumber = f.ZSalesman
		left join SILVER_WAREHOUSE.dbo.DirPartyTable q2 on q2.RecordId = q1.Person1
		left join SILVER_WAREHOUSE.dbo.ZGoodReceiptFakpol a2 on a2.PengajuanFakpolNo = a.PengajuanFakpolNo
		left join SILVER_WAREHOUSE.dbo.ZGoodReceiptSTNK a3 on a3.PengajuanFakpolNo = a.PengajuanFakpolNo
		left join SILVER_WAREHOUSE.dbo.ZGoodIssueSTNK a4 on a4.PengajuanNoFakpol = a.PengajuanFakpolNo
		left join SILVER_WAREHOUSE.dbo.ZGoodReceiptBPKB a5 on a5.PengajuanFakpolNo = a.PengajuanFakpolNo
		left join SILVER_WAREHOUSE.dbo.ZGoodIssueBPKB a6 on a6.PengajuanFakpolNo = a.PengajuanFakpolNo
		left join SILVER_WAREHOUSE.dbo.ZCustomers a7 on a7.AccountNum = a.CustomerNo and a7.dataAreaId = a.dataAreaId
		left join SILVER_WAREHOUSE.dbo.DirPartyTable a8 on a8.RecordId = a7.Party  

		-- Update data Fakpol yang status nya belum Printed
		Update Report_Fakpol
		set StatusFakpol =  b.StatusFakpol, 
			CreatedDate = b.CreatedDate,
			ApprovalDate = b.ApprovalDate,
			PrintedDate = b.PrintedDate, 
			TglFakpol = b.TglFakpol
		from Report_Fakpol a
			inner join AGITEFakpol b on b.ChassisNumber = a.ChassisNumber and b.StatusFakpol = 'Printed'
		where a.StatusFakpol != 'Printed'

		--Update NoFakpol yang kosong
		update Report_Fakpol
		set NoFakpol = isnull(b.NoFakpol,'')
		from Report_Fakpol a
			left join AGITEFakpol b on b.ChassisNumber = a.ChassisNumber
		where a.NoFakpol = ''

		--Additional Fakpol
		Update Report_Fakpol
		set DealerCategory = 'Non AI',
			KodeDealer = b.dataAreaId,
			DealerName = b.ZDealerAfterSales,
			KodeOutlet = a.KodeOutlet,
			OutletName = b.Name,
			CV_LCV = d.AMItemMajorGroupId,
			Series = d.AMItemMinorGroupId,
			tipe_series = d.ZSeriesType,
			Type_Desc = d.NameAlias,
			Area = b.AreaCode+'-'+b.ZIAMIArea
		FROM Report_Fakpol x
			inner join AdditionalFakpol a on x.ChassisNumber = a.ChassisNumber
			inner join ZInventSites b on b.SiteId = a.KodeOutlet
			left join DeviceTable c on c.DeviceId = a.ChassisNumber and c.dataAreaId = left(a.KodeOutlet,3)
			left join ZInventTables d on d.ItemId = c.ItemId and d.dataAreaId = c.dataAreaId
		Where x.KodeOutlet = '' or x.KodeOutlet is null

		Update a
		set CustomerName = c.Name
		from Report_Fakpol a
			left join ZCustomers b on b.AccountNum = a.CustomerID and b.dataAreaId = a.KodeDealer
			left join DirPartyTable c on c.RecordId = b.Party
		where CustomerName is null

		Update a
		Set a.InvoiceDate = b.InvoiceDate
		from Report_Fakpol a
			inner join AGITEFakpol b on b.ChassisNumber = a.ChassisNumber
		where a.InvoiceDate is null

		delete Report_Fakpol
		where ChassisNumber in ('MHCFVR34PHJ000693','MHCPHR54CHJ329221')

		Update a	
		set a.Area = b.AreaCode+' - '+b.ZIAMIArea, 
			a.Group_Dealer = b.Group_Dealer
		from Report_Fakpol a
			Inner join ZInventSites b on b.SiteId = a.KodeOutlet
		where a.Area like '%None%' or a.Group_Dealer is null

		Update a
		Set a.InvoiceDate = b.InvoiceDate
		from Report_Fakpol a
			inner join AdditionalFakpol b on b.ChassisNumber = a.ChassisNumber
		where a.InvoiceDate is null

		Update a
		set a.InvoiceNo = b.InvoiceNo
		from Report_Fakpol a
			inner join AdditionalFakpol b on b.ChassisNumber = a.ChassisNumber
		where a.InvoiceNo  = '' or a.InvoiceNo is null  

		update a
		set a.InvoiceNo = c.InvoiceNo
		from Report_Fakpol a
			left join ZEFakpol c on c.VIN = a.ChassisNumber
		where a.InvoiceNo  = '' or a.InvoiceNo is null and c.InvoiceNo is not null

		Update a
		set a.InvoiceNo = c.InvoiceNo
		from Report_Fakpol a
			left join AGITEFakpol c on c.ChassisNumber = a.ChassisNumber
		where a.InvoiceNo  = '' or a.InvoiceNo is null and c.InvoiceNo is not null

		update Report_Fakpol
		set CustomerName = left(CustomerName, len(CustomerName)-1)
		where right(CustomerName,1) = '-'

		update Report_Fakpol
		set Alamat = left(Alamat, len(Alamat)-1)
		where right(Alamat,1) = '-'


END