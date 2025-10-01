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
    inner join Report_Fakpol x 
        on LOWER(x.ChassisNumber) = LOWER(a.VIN) 
        and x.KodeOutlet is null
    left join SILVER_WAREHOUSE.dbo.ZInventSites b 
        on LOWER(b.SiteId) = LOWER(a.Site)
    left join SILVER_WAREHOUSE.dbo.ZGoodReceiptFakpol c 
        on LOWER(c.PengajuanFakpolNo) = LOWER(a.PengajuanFakpolNo)
    left join SILVER_WAREHOUSE.dbo.ZSalesOrderLine d  
        on LOWER(d.SalesOrderNumber) = LOWER(a.SalesOrderNo) 
        and LOWER(d.ItemNumber) = LOWER(a.ItemNo)
    left join SILVER_WAREHOUSE.dbo.ZSalesOrderHeader f 
        on LOWER(f.SalesId) = LOWER(a.SalesOrderNo)
    left join SILVER_WAREHOUSE.dbo.ZInventTables i 
        on LOWER(i.ItemId) = LOWER(a.ItemNo) 
        and LOWER(i.dataAreaId) = LOWER(a.dataAreaId)
    left join SILVER_WAREHOUSE.dbo.DeviceTableMasters j 
        on LOWER(j.MasterId) = LOWER(a.VIN)
    left join SILVER_WAREHOUSE.dbo.DeviceTable k 
        on LOWER(k.DeviceId) = LOWER(a.VIN) 
        and LOWER(k.dataAreaId) = LOWER(a.dataAreaId)
    left join SILVER_WAREHOUSE.dbo.DeviceClass l 
        on LOWER(l.ClassId) = LOWER(j.ClassId)
    left join SILVER_WAREHOUSE.dbo.ZCustomers n 
        on LOWER(n.AccountNum) = LOWER(f.ZLeasing) 
        and LOWER(n.dataAreaId) = LOWER(f.dataAreaId)
    left join SILVER_WAREHOUSE.dbo.DirPartyTable o 
        on LOWER(o.RecordId) = LOWER(n.Party)
    left join SILVER_WAREHOUSE.dbo.Worker p1 
        on LOWER(p1.PersonnelNumber) = LOWER(f.ZSupervisor)
    left join SILVER_WAREHOUSE.dbo.DirPartyTable p2 
        on LOWER(p2.RecordId) = LOWER(p1.Person1)
    left join SILVER_WAREHOUSE.dbo.Worker q1 
        on LOWER(q1.PersonnelNumber) = LOWER(f.ZSalesman)
    left join SILVER_WAREHOUSE.dbo.DirPartyTable q2 
        on LOWER(q2.RecordId) = LOWER(q1.Person1)
    left join SILVER_WAREHOUSE.dbo.ZGoodReceiptFakpol a2 
        on LOWER(a2.PengajuanFakpolNo) = LOWER(a.PengajuanFakpolNo)
    left join SILVER_WAREHOUSE.dbo.ZGoodReceiptSTNK a3 
        on LOWER(a3.PengajuanFakpolNo) = LOWER(a.PengajuanFakpolNo)
    left join SILVER_WAREHOUSE.dbo.ZGoodIssueSTNK a4 
        on LOWER(a4.PengajuanNoFakpol) = LOWER(a.PengajuanFakpolNo)
    left join SILVER_WAREHOUSE.dbo.ZGoodReceiptBPKB a5 
        on LOWER(a5.PengajuanFakpolNo) = LOWER(a.PengajuanFakpolNo)
    left join SILVER_WAREHOUSE.dbo.ZGoodIssueBPKB a6 
        on LOWER(a6.PengajuanFakpolNo) = LOWER(a.PengajuanFakpolNo)
    left join SILVER_WAREHOUSE.dbo.ZCustomers a7 
        on LOWER(a7.AccountNum) = LOWER(a.CustomerNo) 
        and LOWER(a7.dataAreaId) = LOWER(a.dataAreaId)
    left join SILVER_WAREHOUSE.dbo.DirPartyTable a8 
        on LOWER(a8.RecordId) = LOWER(a7.Party)


		-- Update data Fakpol yang status nya belum Printed
		Update Report_Fakpol
		set StatusFakpol =  b.StatusFakpol, 
			CreatedDate = b.CreatedDate,
			ApprovalDate = b.ApprovalDate,
			PrintedDate = b.PrintedDate, 
			TglFakpol = b.TglFakpol
		from Report_Fakpol a
			INNER JOIN AGITEFakpol b 
    ON LOWER(b.ChassisNumber) = LOWER(a.ChassisNumber) 
   AND LOWER(b.StatusFakpol) = LOWER('Printed')

		where LOWER(a.StatusFakpol) != LOWER('Printed')

		--Update NoFakpol yang kosong
		update Report_Fakpol
		set NoFakpol = isnull(b.NoFakpol,'')
		from Report_Fakpol a
			LEFT JOIN AGITEFakpol b 
    ON LOWER(b.ChassisNumber) = LOWER(a.ChassisNumber)

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
        inner join AdditionalFakpol a 
            on LOWER(x.ChassisNumber) = LOWER(a.ChassisNumber)
        inner join ZInventSites b 
            on LOWER(b.SiteId) = LOWER(a.KodeOutlet)
        left join DeviceTable c 
            on LOWER(c.DeviceId) = LOWER(a.ChassisNumber) 
            and LOWER(c.dataAreaId) = LOWER(LEFT(a.KodeOutlet,3))
        left join ZInventTables d 
            on LOWER(d.ItemId) = LOWER(c.ItemId) 
            and LOWER(d.dataAreaId) = LOWER(c.dataAreaId)
    WHERE LOWER(x.KodeOutlet) = LOWER('') 
       OR x.KodeOutlet IS NULL;

Update a
    set CustomerName = c.Name
from Report_Fakpol a
    left join ZCustomers b 
        on LOWER(b.AccountNum) = LOWER(a.CustomerID) 
        and LOWER(b.dataAreaId) = LOWER(a.KodeDealer)
    left join DirPartyTable c 
        on LOWER(c.RecordId) = LOWER(b.Party)
where a.CustomerName IS NULL;

Update a
    Set a.InvoiceDate = b.InvoiceDate
from Report_Fakpol a
    inner join AGITEFakpol b 
        on LOWER(b.ChassisNumber) = LOWER(a.ChassisNumber)
where a.InvoiceDate IS NULL;

delete Report_Fakpol
where LOWER(ChassisNumber) IN (LOWER('MHCFVR34PHJ000693'), LOWER('MHCPHR54CHJ329221'));

Update a	
    set a.Area = b.AreaCode+' - '+b.ZIAMIArea, 
        a.Group_Dealer = b.Group_Dealer
from Report_Fakpol a
    Inner join ZInventSites b 
        on LOWER(b.SiteId) = LOWER(a.KodeOutlet)
where LOWER(a.Area) LIKE LOWER('%None%') 
   OR a.Group_Dealer IS NULL;

Update a
    Set a.InvoiceDate = b.InvoiceDate
from Report_Fakpol a
    inner join AdditionalFakpol b 
        on LOWER(b.ChassisNumber) = LOWER(a.ChassisNumber)
where a.InvoiceDate IS NULL;

Update a
    set a.InvoiceNo = b.InvoiceNo
from Report_Fakpol a
    inner join AdditionalFakpol b 
        on LOWER(b.ChassisNumber) = LOWER(a.ChassisNumber)
where LOWER(a.InvoiceNo) = LOWER('') 
   OR a.InvoiceNo IS NULL;

update a
    set a.InvoiceNo = c.InvoiceNo
from Report_Fakpol a
    left join ZEFakpol c 
        on LOWER(c.VIN) = LOWER(a.ChassisNumber)
where (LOWER(a.InvoiceNo) = LOWER('') OR a.InvoiceNo IS NULL) 
  AND c.InvoiceNo IS NOT NULL;

Update a
    set a.InvoiceNo = c.InvoiceNo
from Report_Fakpol a
    left join AGITEFakpol c 
        on LOWER(c.ChassisNumber) = LOWER(a.ChassisNumber)
where (LOWER(a.InvoiceNo) = LOWER('') OR a.InvoiceNo IS NULL) 
  AND c.InvoiceNo IS NOT NULL;

update Report_Fakpol
    set CustomerName = LEFT(CustomerName, LEN(CustomerName)-1)
where LOWER(RIGHT(CustomerName,1)) = LOWER('-');

update Report_Fakpol
    set Alamat = LEFT(Alamat, LEN(Alamat)-1)
where LOWER(RIGHT(Alamat,1)) = LOWER('-');



END