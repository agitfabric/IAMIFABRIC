CREATE PROCEDURE [dbo].[SP_Mart_51_outlet_eus]
AS
BEGIN
    DECLARE @running_date DATE;

    SELECT @running_date = CAST(ISNULL(DATEADD(DAY, -2, MAX(tanggal_invoice)), '2022-01-01') AS DATE)
    FROM GOLD_WAREHOUSE.dbo.mart_51_outlet_eus;

    DELETE FROM GOLD_WAREHOUSE.dbo.mart_51_outlet_eus 
    WHERE tanggal_invoice >= @running_date;

    INSERT INTO GOLD_WAREHOUSE.dbo.mart_51_outlet_eus
    SELECT  
        a.dealer, 
        a.nama_dealer, 
        a.Outlet, 
        a.nama_outlet, 
        CAST(a.tanggal_EUS AS datetime2) AS tanggal_invoice, 
        a.sales_tipe AS Pool, 
        a.sales_tipe AS tipe_sales,
        a.area_dealer, 
        a.Group_Dealer, 
        b.City, 
        a.ItemId, 
        a.Type_Desc, 
        a.jumlah_unit, 
        a.nomer_EUS
    FROM GOLD_WAREHOUSE.dbo.Report_1 a
    LEFT JOIN GOLD_WAREHOUSE.dbo.vw_zInventSite b 
        ON b.OutletCode = a.Outlet
    WHERE DealerCategory != 'AI'
    ORDER BY a.tanggal_EUS;
END