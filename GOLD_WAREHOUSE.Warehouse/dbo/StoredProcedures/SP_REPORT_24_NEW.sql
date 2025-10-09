CREATE PROCEDURE [dbo].[SP_REPORT_24_NEW]
AS
BEGIN
   

 
    -- Inisialisasi tanggal (UTC+7)
    DECLARE @DateFrom DATE = CAST(DATEADD(HOUR,7,GETDATE()) - 90 AS DATE);
    DECLARE @DateTo DATE   = CAST(DATEADD(HOUR,7,GETDATE()) AS DATE);

    -- Ambil daftar dataAreaId yang akan diproses
    WITH DataAreas AS (
        SELECT DISTINCT dataAreaId
        FROM SILVER_WAREHOUSE.dbo.ZInventSites
        WHERE dataAreaId COLLATE Latin1_General_CI_AS <> 'kzu'
    )
    SELECT * INTO #TempDataArea FROM DataAreas;

    -- Variabel untuk looping
    DECLARE @LoopDataArea CHAR(3);

    -- Mulai loop per dataAreaId
    WHILE EXISTS (SELECT TOP 1 1 FROM #TempDataArea)
    BEGIN
        SELECT TOP 1 @LoopDataArea = dataAreaId FROM #TempDataArea ORDER BY dataAreaId;

        DELETE FROM Report_24
        WHERE dataAreaId COLLATE Latin1_General_CI_AS = @LoopDataArea COLLATE Latin1_General_CI_AS
          AND TglFunneling BETWEEN @DateFrom AND @DateTo;

        INSERT INTO Report_24
        SELECT  
            a.OpportunityId AS No_Funneling, 
            e.SalesId,
            a.CreatedDateTime1 AS Tgl_Funneling, 
            a.dataAreaId AS Dealer, 
            ag.ZDealerAfterSales AS Dealer,
            a.ZSite AS cabang, 
            ag.Name AS Outlet, 
            ag.AreaCode + '-' + ag.ZIAMIArea AS Area,
            o.Name AS Spv,
            p.Name AS Salesman, 
            a.Subject AS NamaCustomer,
            a.ZDecisionMaker AS NamaPengambilKeputusan, 
            a.ZSegmentation AS Segmentasi,
            a.ZGoodType AS BarangYangDiangkut, 
            a.ZWeightOfGood AS BeratAngkutan,
            s.Locator AS NomorTelepon,
            r.Address AS Alamat, 
            a.SourceType AS Kategori_Customer,
            u.NameAlias AS Unit_yang_Ditawarkan, 
            u.AMItemMajorGroupId AS Kategori, 
            u.AMItemMinorGroupId AS tipe,
            a1.KaroseriType AS Aplikasi, 
            a1.Qty AS jumlah, 
            a1.PlatType AS plat, 
            a.ZPaymentType AS Credit_Cash,
            b.CreatedDateTime1 AS Tanggal_SPK, 
            b.SalesQuotationNumber AS No_SPK, 
            b.SalesQuotationStatus, 
            b.ZStatusPelanggaran, 
            b.ZNeedSDA,
            c.ZSDANo, 
            b.OpportunityId AS No_sales_funneling, 
            b.ZSalesman AS NPK_salesman,
            x.Name AS Nama_salesman, 
            b.ZSupervisor AS NPK_supervisor, 
            y.Name AS nama_supervisor,
            b.CustAccount, 
            aa.Address, 
            aa.City, 
            aa.State AS provinsi, 
            s.Type, 
            ab.Locator AS phone, 
            ac.Locator AS email,
            a3.AMItemMajorGroupId AS Item_major_group, 
            a3.AMItemMinorGroupId AS Item_minor_group,
            DM.ClassId, 
            a1.ItemID, 
            a3.NameAlias AS model_desription, 
            h4.Name AS colour,
            c.ZKaroseriType AS Aplikasi_karoseri, 
            b.ZLeasing AS No_leasing, 
            ae.Name AS nama_leasing,
            b.ZPriceUnitType AS Price_Unit_Type, 
            b.ZHargaJual, 
            b.ZMinimumDP, 
            e.ZCreatedBy, 
            f.InvoiceId, 
            f.InvoiceDate,
            af1.ZVehicleType AS vehicle_type, 
            af2.Name AS competitor, 
            af1.ZQty AS jumlah_kepemilikan, 
            DATEADD(HOUR,7,GETDATE()) AS Last_Update,
            po.MaskedName as MaskingName
        FROM SILVER_WAREHOUSE.dbo.OpportunityTable a
            LEFT JOIN SILVER_WAREHOUSE.dbo.OpportunityProduct a1 
                ON a1.OpportunityID COLLATE Latin1_General_CI_AS = a.OpportunityId COLLATE Latin1_General_CI_AS
            LEFT JOIN SILVER_WAREHOUSE.dbo.InventItemGroupItem a2 
                ON a2.ItemId COLLATE Latin1_General_CI_AS = a1.ItemID COLLATE Latin1_General_CI_AS 
               AND a2.ItemDataAreaId COLLATE Latin1_General_CI_AS = a.dataAreaId COLLATE Latin1_General_CI_AS 
               AND a2.ItemGroupId COLLATE Latin1_General_CI_AS = 'FU01'
            LEFT JOIN SILVER_WAREHOUSE.dbo.DeviceModel DM 
                ON a2.ItemId COLLATE Latin1_General_CI_AS = DM.ModelId COLLATE Latin1_General_CI_AS
            LEFT JOIN SILVER_WAREHOUSE.dbo.ZInventTables a3 
                ON a3.ItemId COLLATE Latin1_General_CI_AS = a1.ItemID COLLATE Latin1_General_CI_AS 
               AND a3.dataAreaId COLLATE Latin1_General_CI_AS = a1.dataAreaId COLLATE Latin1_General_CI_AS
            LEFT JOIN SILVER_WAREHOUSE.dbo.SalesQuotationTable b 
                ON b.OpportunityId COLLATE Latin1_General_CI_AS = a.OpportunityId COLLATE Latin1_General_CI_AS
            LEFT JOIN SILVER_WAREHOUSE.dbo.SalesQuotationLine c 
                ON c.SalesQuotationNumber COLLATE Latin1_General_CI_AS = b.SalesQuotationNumber COLLATE Latin1_General_CI_AS 
               AND c.ItemNumber COLLATE Latin1_General_CI_AS = a1.ItemID COLLATE Latin1_General_CI_AS      
            LEFT JOIN SILVER_WAREHOUSE.dbo.ZSalesOrderHeader e 
                ON e.QuotationNumber COLLATE Latin1_General_CI_AS = b.SalesQuotationNumber COLLATE Latin1_General_CI_AS
            LEFT JOIN SILVER_WAREHOUSE.dbo.CustInvoiceJour f 
                ON f.SalesId COLLATE Latin1_General_CI_AS = e.SalesId COLLATE Latin1_General_CI_AS
            LEFT JOIN SILVER_WAREHOUSE.dbo.ZSalesOrderLine h 
                ON h.SalesOrderNumber COLLATE Latin1_General_CI_AS = e.SalesId COLLATE Latin1_General_CI_AS 
               AND h.ItemNumber COLLATE Latin1_General_CI_AS = c.ItemNumber COLLATE Latin1_General_CI_AS
            LEFT JOIN SILVER_WAREHOUSE.dbo.Dim h1 
                ON h1.inventDimId COLLATE Latin1_General_CI_AS = h.InventDimId COLLATE Latin1_General_CI_AS
            LEFT JOIN SILVER_WAREHOUSE.dbo.DeviceTableMasters h2 
                ON h2.MasterId COLLATE Latin1_General_CI_AS = h1.InventDimension1 COLLATE Latin1_General_CI_AS
            LEFT JOIN SILVER_WAREHOUSE.dbo.DeviceTable h3 
                ON h3.DeviceId COLLATE Latin1_General_CI_AS = h1.InventDimension1 COLLATE Latin1_General_CI_AS 
               AND h3.dataAreaId COLLATE Latin1_General_CI_AS = h.dataAreaId COLLATE Latin1_General_CI_AS
            LEFT JOIN SILVER_WAREHOUSE.dbo.DeviceGroup h4 
                ON h4.DeviceGroupId COLLATE Latin1_General_CI_AS = h3.DeviceGroupId COLLATE Latin1_General_CI_AS 
               AND h4.dataAreaId COLLATE Latin1_General_CI_AS = h3.dataAreaId COLLATE Latin1_General_CI_AS
            LEFT JOIN SILVER_WAREHOUSE.dbo.Worker m 
                ON m.PersonnelNumber COLLATE Latin1_General_CI_AS = a.ZSalesman COLLATE Latin1_General_CI_AS
            LEFT JOIN SILVER_WAREHOUSE.dbo.Worker n 
                ON n.PersonnelNumber COLLATE Latin1_General_CI_AS = a.ZSupervisor COLLATE Latin1_General_CI_AS
            LEFT JOIN SILVER_WAREHOUSE.dbo.DirPartyTable o 
                ON o.RecordId = n.Person1
            LEFT JOIN SILVER_WAREHOUSE.dbo.DirPartyTable p 
                ON p.RecordId = m.Person1
            LEFT JOIN SILVER_WAREHOUSE.dbo.smmBusRelTable q 
                ON q.Party = a.Party 
               AND q.dataAreaId COLLATE Latin1_General_CI_AS = a.dataAreaId COLLATE Latin1_General_CI_AS 
            LEFT JOIN SILVER_WAREHOUSE.dbo.DirPartyTable q1 
                ON q1.RecordId = q.Party
            LEFT JOIN SILVER_WAREHOUSE.dbo.DirPartyPostalAddressView r 
                ON r.Party = q.Party 
               AND r.ValidTo >= DATEADD(HOUR,7,GETDATE()) 
               AND r.ModifiedDate = (
                    SELECT MAX(ModifiedDate) 
                    FROM SILVER_WAREHOUSE.dbo.DirPartyPostalAddressView 
                    WHERE Party = q.Party
               )
            LEFT JOIN SILVER_WAREHOUSE.dbo.LogisticsElectronicAddress s 
                ON s.PrivateForParty = q.Party 
               AND s.Type COLLATE Latin1_General_CI_AS = 'Phone'
            LEFT JOIN SILVER_WAREHOUSE.dbo.ZInventTables u 
                ON u.ItemId COLLATE Latin1_General_CI_AS = a1.ItemID COLLATE Latin1_General_CI_AS 
               AND u.dataAreaId COLLATE Latin1_General_CI_AS = a1.dataAreaId COLLATE Latin1_General_CI_AS
            LEFT JOIN SILVER_WAREHOUSE.dbo.Worker v 
                ON v.PersonnelNumber COLLATE Latin1_General_CI_AS = b.ZSalesman COLLATE Latin1_General_CI_AS
            LEFT JOIN SILVER_WAREHOUSE.dbo.Worker w 
                ON w.PersonnelNumber COLLATE Latin1_General_CI_AS = b.ZSupervisor COLLATE Latin1_General_CI_AS
            LEFT JOIN SILVER_WAREHOUSE.dbo.DirPartyTable x 
                ON x.RecordId = v.Person1
            LEFT JOIN SILVER_WAREHOUSE.dbo.DirPartyTable y 
                ON y.RecordId = w.Person1
            LEFT JOIN SILVER_WAREHOUSE.dbo.ZCustomers z 
                ON z.AccountNum COLLATE Latin1_General_CI_AS = b.CustAccount COLLATE Latin1_General_CI_AS 
               AND z.dataAreaId COLLATE Latin1_General_CI_AS = b.dataAreaId COLLATE Latin1_General_CI_AS 
               AND z.ModifiedDateTime1 = (
                    SELECT MAX(ModifiedDateTime1) 
                    FROM SILVER_WAREHOUSE.dbo.ZCustomers 
                    WHERE AccountNum COLLATE Latin1_General_CI_AS = b.CustAccount COLLATE Latin1_General_CI_AS
               )
            LEFT JOIN SILVER_WAREHOUSE.dbo.DirPartyTable z2 
                ON z2.RecordId = z.Party
            LEFT JOIN SILVER_WAREHOUSE.dbo.DirPartyPostalAddressView aa 
                ON aa.Party = z.Party 
               AND aa.ValidTo >= DATEADD(HOUR,7,GETDATE()) 
               AND aa.ModifiedDate = (
                    SELECT MAX(ModifiedDate) 
                    FROM SILVER_WAREHOUSE.dbo.DirPartyPostalAddressView 
                    WHERE Party = z.Party
               )
            LEFT JOIN SILVER_WAREHOUSE.dbo.DirPartyLocation z1 
                ON z1.Party = z.Party 
               AND z1.IsPostalAddress COLLATE Latin1_General_CI_AS = 'No'
            LEFT JOIN SILVER_WAREHOUSE.dbo.LogisticsElectronicAddress ab 
                ON ab.Location = z1.Location 
               AND ab.Type COLLATE Latin1_General_CI_AS = 'Phone' 
               AND ab.IsPrimary COLLATE Latin1_General_CI_AS = 'Yes'
            LEFT JOIN SILVER_WAREHOUSE.dbo.LogisticsElectronicAddress ac 
                ON ac.Location = z1.Location 
               AND ac.Type COLLATE Latin1_General_CI_AS = 'Email' 
               AND ac.IsPrimary COLLATE Latin1_General_CI_AS = 'Yes'
            LEFT JOIN SILVER_WAREHOUSE.dbo.ZCustomers ad 
                ON ad.AccountNum COLLATE Latin1_General_CI_AS = b.ZLeasing COLLATE Latin1_General_CI_AS 
               AND ad.dataAreaId COLLATE Latin1_General_CI_AS = b.dataAreaId COLLATE Latin1_General_CI_AS
            LEFT JOIN SILVER_WAREHOUSE.dbo.DirPartyTable ae 
                ON ae.RecordId = ad.Party
            LEFT JOIN SILVER_WAREHOUSE.dbo.smmQuotationCompetitors af1 
                ON af1.RefRecId = a.RecordId
            LEFT JOIN SILVER_WAREHOUSE.dbo.DirPartyTable af2 
                ON af2.RecordId = af1.Party
            LEFT JOIN SILVER_WAREHOUSE.dbo.ZInventSites ag 
                ON ag.SiteId COLLATE Latin1_General_CI_AS = a.ZSite COLLATE Latin1_General_CI_AS
            CROSS APPLY SILVER_WAREHOUSE.dbo.name_masking_function(a.Subject) as po
        WHERE a.dataAreaId COLLATE Latin1_General_CI_AS = @LoopDataArea COLLATE Latin1_General_CI_AS
          AND CAST(a.CreatedDateTime1 AS DATE) BETWEEN @DateFrom AND @DateTo;

        DELETE FROM #TempDataArea WHERE dataAreaId = @LoopDataArea;
    END

    DROP TABLE #TempDataArea;


END;