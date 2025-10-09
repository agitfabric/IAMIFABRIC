CREATE PROCEDURE dbo.SP_REPORT_1_NOLOWER

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


-- Inisialisasi tanggal
DECLARE @GetMaxRunningDate DATE = ISNULL((SELECT MAX(CAST(tanggal_EUS AS DATE)) FROM Report_1 WHERE dealer != 'AI'), '2019-09-01');
DECLARE @GetCurrentDate DATE = CAST(GETDATE() AS DATE);

-- Ambil daftar YearMonth
WITH YearMonths AS (
    SELECT DISTINCT LEFT(CONVERT(CHAR(8), DatePhysical, 112), 6) AS YearMonth
    FROM SILVER_WAREHOUSE.dbo.InventTrans
    WHERE dataAreaId != 'kzu'
      AND CAST(DatePhysical AS DATE) BETWEEN @GetMaxRunningDate AND @GetCurrentDate
)
SELECT * INTO #TempYearMonth_SP_REPORT_1 FROM YearMonths;

-- Loop YearMonth satu per satu
DECLARE @LoopYearMonth CHAR(6);
DECLARE @StarDate DATE;
DECLARE @MaxDate DATE;

WHILE EXISTS (SELECT TOP 1 1 FROM #TempYearMonth_SP_REPORT_1)
BEGIN
    SELECT TOP 1 @LoopYearMonth = YearMonth FROM #TempYearMonth_SP_REPORT_1 ORDER BY YearMonth ASC;

    SET @StarDate = DATEADD(MONTH, 1, DATEADD(YEAR, -1, DATEADD(MONTH, DATEDIFF(MONTH, '19000101', @LoopYearMonth + '01'), '19000101')));
    SET @MaxDate  = DATEADD(DAY, -1, DATEADD(MONTH, 1, @LoopYearMonth + '01'));

    DELETE FROM Report_1 
    WHERE CAST(tanggal_EUS AS DATE) BETWEEN @StarDate AND @MaxDate
      AND dealer != 'AI';

    INSERT INTO Report_1  
    SELECT DISTINCT 
        -- << Full original SELECT body >>
        0 as IsReturn,
        a.ZSalesType sales_tipe, a.dataAreaId dealer,
        l1.Description nama_dealer, r.Group_Dealer Group_Dealer,
        a.InventSiteId Outlet,
        r.Name nama_outlet, CONCAT(r.AreaCode,'-',r.ZIAMIArea) area_dealer,
        d.CreatedDateTime1 tanggal_Quotation, d.SalesQuotationNumber no_quotation,
        a.ZCreatedDateTime tanggal_SO, a.SalesId nomer_SO,
        a.SalesStatus status_SO,
        e.InvoiceDate tanggal_EUS, e.InvoiceId nomer_EUS,
        a.ZSupervisor kode_spv, ac2.Name nama_spv,
        a.ZSalesman kode_sales, ad2.Name nama_salesman,
        f0.ZCustType customer_type,
        CASE WHEN f2.PartyNumber IS NULL THEN 'Organization' ELSE f2.PartyType END jenis_customer,
        a.CustAccount customer_id,
        f.ZIdentityId ktp, f.ZNPWP Znpwp, a.SalesName nama_customer,
        g.ZSegmentation jenis_usaha, g.ZSegmentation segmen,
        g.ZGoodType jenis_angkutan, e.Qty jumlah_unit,
        h.AMItemMajorGroupId [CV/LCV], h.AMItemMinorGroupId Series,
        DM.ClassId,
        h1.ProductName Type_Desc,
        j.DeviceName Material_Desc,
        j.EngineNumber engine_no, j.MasterId as ChassisNumber,
        j.ModelYear thn_produksi, l.Name as warna,
        b.ZKaroseriType jenis_aplikasi_karoseri,
        n.LineAmountMST biaya_karoseri, c.ItemGroupId, c.ItemId, b.ItemNumber,
        j.ModelYear tahun_pembuatan,
        a.ZPaymentType payment_type,
        CASE WHEN f.ZLeasingType = 'None' THEN 'NonMOU' ELSE f.ZLeasingType END jenis_leasing,
        a.ZLeasing kode_leasing, ff.Name nama_leasing, f.CustClassificationId group_leasing,
        t.FakpolNo Polreg_number, t.CreatedDateTime1 Polreg_date,
        a.ZTotalDP totalDP,
        CASE WHEN t.ApprovedDate = '1900-01-01 12:00:00' THEN NULL ELSE t.ApprovedDate END approval_date,
        CASE WHEN t.PrintedDate = '1900-01-01 12:00:00' THEN NULL ELSE t.PrintedDate END print_date,
        a.ZFakpolName nama_fakpol, a.ZBBNKotaKab area_BBN, b.ZKaroseriType aplikasi_bbn, b.ZPlatType jenis_plat,
        a.ZStatusPelanggaran Status_pelanggaran,
        a.ZPWNo nomer_pelanggaran,
        a.ZStatusCSP Status_CSP,
        a.QuotationNumber No_CSP, a.ZNeedSDA, b.ZSDANo no_sda,
        z.SDADate sda_date, b.LineAmount Nilai_SDA_Approve,
        b.ZDiscSDA potongan_sda,
        a.ZPriceUnitType priceUnitType,
        a.ZPriceList, a.ZPriceUnitType pricelistType,
        a.ZHargaJualCust Harga_Jual_ke_Cust, a.ZMinimumDP, a.ZTotalPotHarga TotalDisckeCust,
        b.ZOtherDiscount, a.ZProfitLoss,
        a.ZAdjustmentUnit, a.ZAksesoris, a.ZDiskonBBN, a.ZHargaJual, a.ZHargaJualCust,
        a.ZHargaJualKendaraan, a.ZHargaUnitExBiaya, a.ZJasaBBN, a.ZKaroseri,
        a.ZPriceUnitOnly, a.ZSelisihPriceUnit, a.ZTotalHarga,
        a.ZTotalBiaya total_bbn, a.ZBBNNotice, a.ZBBNUnNotice, a.ZBBNKotaKab,
        a.ZBiayaUbahBentuk, a.ZBungaTOP, a.ZKomisi, a.ZOngkirIAMIDealer, a.ZOngkirDealerCustomer,
        a.ZFakpolAddress alamatFakpol, a.City, a.State provinsi,
        a.VATNum npwp, a.ZSIUP, a.ZTDP, a.Email,
        a.ZFakpolPhoneNum HP, a.ZFakpolPhoneNum Phone,
        a.ZFakpolPhoneNum Tlp_Kantor, a.ZFakpolPhoneNum Telp,
        d.OpportunityId No_sales_funneling, g.CreatedDateTime1 Tgl_Funneling,
        g.ZDecisionMaker, g.ZCompanyName, g.ZDepartment, g.ZGoodType,
        g.ZGoodType Barang_Yang_diangkut, g.ZWeightOfGood Berat_Yang_diangkut,
        g.CreatedBy1 CreatedBy,
        aa.ZQTY Kepemilikan_unit,
        ab.ZCustType Katagori_customer,
        ab.BusRelTypeId Status_Customer,
        g.Status, a.ZSalesman NPK_Salesman, a.ZSupervisor NPK_Supervisor,
        CASE WHEN a.ZKirimKaroseri = '1900-01-01 12:00:00' THEN NULL ELSE a.ZKirimKaroseri END Tgl_Kirim_Karoseri,
        a.ZKirimCustomer Tgl_Kirim_Customer,
        CASE WHEN a.ZSTNKSelesai = '1900-01-01 12:00:00' THEN NULL ELSE a.ZSTNKSelesai END Tgl_Jadi_STNK,
        u.PoliceNo NO_Polisi, u.STNKNo No_STNK, u.STNKDate STNK_Date,
        v.BPKBFinisihedDate Tgl_Jadi_BPKB, v.BPKBNo No_BPKB, v.BPKBFinisihedDate BPKB_Date,
        w.[Date] Tanggal_Serah_terima_STNK, x.[Date] Tanggal_Serah_terima_BPKB,
        a.ZEkspedisi No_Vendor_Expedsi, y.Name Nama_Vendor_Expedsi, y.AddressLine Alamat_vendor_Expedisi,
        z1.OrderAccount No_Vendor_BBn, z1.PurchName Nama_vendor_BBn, z4.Address alamat_vendor_bbn,
        m1.OrderAccount No_Vendor_Karoseri, m1.PurchName Nama_vendor_Karoseri, m4.Address alamat_vendor_karoseri,
        a.ZCreatedBy CreatedBy1, e.CreatedDateTime1,
        po.MaskedName as MaskingName 
    FROM SILVER_WAREHOUSE.dbo.ZCustInvoiceTrans e
       			inner join SILVER_WAREHOUSE.dbo.InventItemGroupItem c  on c.ItemId = e.ItemId and c.ItemDataAreaId = e.dataAreaId and c.ItemGroupId ='FU01'
			inner join SILVER_WAREHOUSE.dbo.ZSalesOrderHeader a on a.SalesId = e.SalesId and a.ZSalesType in ('FU','Return FU')
			LEFT join SILVER_WAREHOUSE.dbo.DeviceModel DM on c.ItemId=DM.ModelId
			left join SILVER_WAREHOUSE.dbo.ZSalesOrderLine b on b.SalesOrderNumber = a.SalesId and b.dataAreaId = a.dataAreaId and b.ItemNumber = e.ItemId
			left join SILVER_WAREHOUSE.dbo.ZInventTables h on h.ItemId = e.ItemId and h.dataAreaId = e.dataAreaId
			left join SILVER_WAREHOUSE.dbo.ProductTranslation h1 on h1.Product = h.Product

			left join SILVER_WAREHOUSE.dbo.SalesQuotationTable d on d.SalesQuotationNumber = a.QuotationNumber	
			left join SILVER_WAREHOUSE.dbo.ZCustomers f on f.AccountNum = a.ZLeasing and f.dataAreaId = a.dataAreaId 
			left join SILVER_WAREHOUSE.dbo.DirPartyTable ff on ff.RecordId  = f.Party 
			left join SILVER_WAREHOUSE.dbo.ZCustomers f0 on f0.AccountNum = a.CustAccount and f0.dataAreaId = a.dataAreaId
			left join SILVER_WAREHOUSE.dbo.DirPartyTable f1 on f1.RecordId  = f0.Party 
			left join SILVER_WAREHOUSE.dbo.DirPersonBaseEntity f2 on f2.PartyNumber = f1.PartyNumber 
			left join SILVER_WAREHOUSE.dbo.OpportunityTable g on g.OpportunityId = d.OpportunityId and g.dataAreaId = d.dataAreaId    
			left join SILVER_WAREHOUSE.dbo.Dim i on i.inventDimId = e.InventDimId and i.dataAreaId = e.dataAreaId 
			left join SILVER_WAREHOUSE.dbo.DeviceTableMasters j on j.MasterId = i.InventDimension1

			left Join SILVER_WAREHOUSE.dbo.DeviceTable k on k.DeviceId = i.InventDimension1 and k.dataAreaId = i.dataAreaId 
			left join SILVER_WAREHOUSE.dbo.DeviceGroup l on l.DeviceGroupId = k.DeviceGroupId and l.dataAreaId = k.dataAreaId 

			left join (Select distinct x.*, b.OrderAccount, b.PurchName
						From 
							(
							select a.InventRefId, a.ItemNumber,max(a.PurchaseOrderNumber) PurchaseOrderNumber,a.dataAreaId
							from SILVER_WAREHOUSE.dbo.PurchaseOrderLineV2 a
							where a.InventRefId != ''
							group by a.InventRefId, a.ItemNumber, a.dataAreaId
							)x
						inner join SILVER_WAREHOUSE.dbo.PurchaseOrderHeaderV2 b on b.PurchId = x.PurchaseOrderNumber and b.dataAreaId = x.dataAreaId) m1 
						on m1.InventRefId = e.SalesId and left(m1.ItemNumber ,4) in ('FU02') 

			left join SILVER_WAREHOUSE.dbo.VendTable m3 on m3.VendorAccountNumber = m1.OrderAccount and m3.dataAreaId = m1.dataAreaId 
			left join SILVER_WAREHOUSE.dbo.DirPartyPostalAddressView m4 on m4.Party = m3.Party and m4.ValidTo >= getdate() and m4.IsPrimary = 'Yes'

			left join SILVER_WAREHOUSE.dbo.ZCustInvoiceTrans n on n.SalesId = e.SalesId and left(n.ItemId ,4) in ('FU02')
			left join SILVER_WAREHOUSE.dbo.ZInventSites r on r.SiteId = i.InventSiteId 
			left join SILVER_WAREHOUSE.dbo.ZClaimDASLine s on s.ClaimId = e.SalesId  
			left join ( select a.* from SILVER_WAREHOUSE.dbo.ZEFakpol a
						inner join (select VIN ,min(RecordId) RecordId 
						from SILVER_WAREHOUSE.dbo.ZEFakpol where ApprovedDate >  '1900-01-01'  group by VIN) b on b.VIN = a.VIN and b.RecordId = a.RecordId and ApprovedDate >  '1900-01-01' ) t 
						on t.SalesOrderNo = e.SalesId and t.ApprovedDate> '1900-01-01'  and t.dataAreaId = e.dataAreaId
			left join SILVER_WAREHOUSE.dbo.ZGoodReceiptSTNK u on u.GoodReceiptSTNKNo = t.GRSTNKNo 
			left join SILVER_WAREHOUSE.dbo.ZGoodReceiptBPKB v on v.GoodReceiptBPKB = t.GRBPKBNo 
			left join SILVER_WAREHOUSE.dbo.ZGoodIssueSTNK w on w.GoodIssueSTNK = t.GISTNKNo 
			left join SILVER_WAREHOUSE.dbo.ZGoodIssueBPKB x on x.GoodIssueBPKB = t.GIBPKBNo 
			left join SILVER_WAREHOUSE.dbo.ZEkspedisi y on y.Code = a.ZEkspedisi and y.dataAreaId = a.dataAreaId 
			left join (Select distinct x.*, b.OrderAccount, b.PurchName
						From 
							(
							select a.InventRefId, a.ItemNumber,max(a.PurchaseOrderNumber) PurchaseOrderNumber,a.dataAreaId
							from SILVER_WAREHOUSE.dbo.PurchaseOrderLineV2 a
							where a.InventRefId != ''
							group by a.InventRefId, a.ItemNumber, a.dataAreaId
							)x
						inner join SILVER_WAREHOUSE.dbo.PurchaseOrderHeaderV2 b on b.PurchId = x.PurchaseOrderNumber and b.dataAreaId = x.dataAreaId) z1 
						on z1.InventRefId = e.SalesId and left(z1.ItemNumber ,4) in ('FU04') --vendor BBN Notice

			left join SILVER_WAREHOUSE.dbo.VendTable z3 on z3.VendorAccountNumber = z1.OrderAccount and z3.dataAreaId = z1.dataAreaId 
			left join SILVER_WAREHOUSE.dbo.DirPartyPostalAddressView z4 on z4.Party = z3.Party and z4.ValidTo >= getdate() and z4.IsPrimary = 'Yes'
			left join (Select RefRecId , sum(ZQty) ZQTY from SILVER_WAREHOUSE.dbo.smmQuotationCompetitors group by RefRecId) aa on aa.RefRecId = g.RecordId
			left join SILVER_WAREHOUSE.dbo.smmBusRelTable ab on ab.BusRelAccount = a.CustAccount and ab.dataAreaId = a.dataAreaId and ab.BusRelTypeId ='Customer'
			left join SILVER_WAREHOUSE.dbo.Worker ac1 on ac1.PersonnelNumber = a.ZSupervisor 
			left join SILVER_WAREHOUSE.dbo.DirPartyTable ac2 on ac2.RecordId = ac1.Person1 
			left join SILVER_WAREHOUSE.dbo.Worker ad1 on ad1.PersonnelNumber = a.ZSalesman 
			left join SILVER_WAREHOUSE.dbo.DirPartyTable ad2 on ad2.RecordId = ad1.Person1 
			left join SILVER_WAREHOUSE.dbo.Ledger l1 on l1.Name = a.dataAreaId 
			left join SILVER_WAREHOUSE.dbo.TabelSDA z on b.ZSDANo = z.SDANumber 
      CROSS APPLY SILVER_WAREHOUSE.dbo.name_masking_function(a.SalesName) as po
    WHERE e.dataAreaId != 'kzu'
      AND CAST(e.InvoiceDate AS DATE) BETWEEN @StarDate AND @MaxDate;

    DELETE FROM #TempYearMonth_SP_REPORT_1 WHERE YearMonth = @LoopYearMonth;
END

DROP TABLE #TempYearMonth_SP_REPORT_1;

END