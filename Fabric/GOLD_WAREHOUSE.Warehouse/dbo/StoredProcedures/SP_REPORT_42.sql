CREATE PROCEDURE  [dbo].[SP_REPORT_42]

AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @maxdate NVARCHAR(30)
	set @maxdate = (select convert(varchar,max(Date),23) as maxdate  from Report_42);

	DELETE from Report_42 where convert(varchar,Date,23) = @maxdate;

	with CaseTable1 as (Select
	Cast(CreatedDateTime1 as date) AS Date,
	dataAreaId AS Dealer,
	CaseId AS UnitServed,
	InventSiteId as INVENTSITEID_CaseTable,
	WrkCtrId as WRKCTRID_CaseTable
	from  SILVER_WAREHOUSE.dbo.CaseTable
	where lower(Status) in ('invoiced', 'closed')
	and InventSiteId != ''
	and (ParentId is null or ParentId = '')
	and lower(dataAreaId) not in ('kzu','dat')
	and Left(Convert(varchar,CreatedDateTime1,23),10) >= @maxdate),

	ZinventSites1 as (
	Select
	SiteId AS Outlet,
	Name AS OutletName,
	ZDealerSales AS DealerName,
	Concat(AreaCode,' - ',ZIAMIAreas) AS Area
	from SILVER_WAREHOUSE.dbo.ZInventSites
	where ZIAMIAreas != ''),

	temp as (select * from CaseTable1 a left join ZinventSites1 b on a.INVENTSITEID_CaseTable = b.Outlet where b.Outlet is not null),
	temp2 as (Select a.*,getdate() as Last_Update,'' as TipeStall,
	b.WrkCtrId  AS Stall
	from temp a left join SILVER_WAREHOUSE.dbo.WRKCTRTABLE b on a.WRKCTRID_CaseTable = b.WrkCtrId
	where lower(SUBSTRING(b.WrkCtrId,7,1)) = 's' and b.WrkCtrId is not null
	) 
	insert into Report_42 (UnitServed,Date,Dealer,Outlet,OutletName,DealerName,Area,Stall,TipeStall)
	select count(UnitServed) as UnitServed,Date,Dealer,Outlet,OutletName,DealerName,Area,Stall,TipeStall from temp2
	group by Date,Dealer,Outlet,OutletName,DealerName,Area,Stall,TipeStall 
	END