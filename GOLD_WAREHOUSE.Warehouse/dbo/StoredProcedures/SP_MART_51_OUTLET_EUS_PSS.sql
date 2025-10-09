CREATE PROCEDURE [dbo].[SP_MART_51_OUTLET_EUS_PSS] 
AS

DECLARE @running_date date

---Select @running_date =  cast(Isnull(max(tanggal_invoice)-2,'2022-01-01') as date) from mart_51_outlet_eus where kode_dealer = 'AI'

SELECT @running_date = CAST(ISNULL(DATEADD(DAY, -2, MAX(tanggal_invoice)), '2022-01-01') AS date) from mart_51_outlet_eus where kode_dealer = 'AI'

Delete mart_51_outlet_eus where tanggal_invoice >= @running_date and kode_dealer = 'AI'

Insert into mart_51_outlet_eus
select  'AI' as kode_dealer, a.nama_dealer, a.Outlet, a.nama_outlet, a.tanggal_EUS, a.sales_tipe as Pool, a.sales_tipe as tipe_sales,
		a.area_dealer, a.Group_Dealer, b.City, a.ItemId, a.Type_Desc, a.jumlah_unit, a.nomer_EUS
from Report_1 a
	inner join vw_zInventSite b on LOWER(b.OutletCode) = LOWER(a.Outlet) and b.SiteCategory = '3S'
	where DealerCategory = 'AI'
		and a.tanggal_EUS >= @running_date
Order by a.tanggal_EUS