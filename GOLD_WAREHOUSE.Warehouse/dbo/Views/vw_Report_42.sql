-- Auto Generated (Do not modify) F8162B7BE6965BD065B95D78F93BFD9EF8F36EC5BD156C6E1618C061E61888AC
CREATE view [dbo].[vw_Report_42]  
as  


--Select AbsensiDate Date, ZInqAbsensiMekanikLine.DataAreaId Dealer, invSt.ZDealerAfterSales NamaDealer,ZOutlet Outlet, invSt.Name OutletName,
--		invSt.AreaCode+' - '+invSt.zIAMIArea as Area,
--		case when dt.Stall is null then ZOutlet else dt.Stall end as Stall, 
--		case when dt.Stall is null then '' else dt.TipeStall end as TipeStall, 
--		--case when AbsensiDate is not null then 1 when AbsensiDate is null and count(dt.CaseId) > 0 then 1 else 0 end as 'JumlahHarikerja', 
--		1 as JumlahHarikerja, count(dt.UnitServed) as UnitServed
--from ZInqAbsensiMekanikLine
--	left join worker on PersonnelNumber = ResourceNumber
--	left join ZInventSites invSt on invSt.SiteId = ZOutlet
--	left join
--	(
--		select Convert(char,amc.CreatedDateTime1,101) 'Date', amc.ZInventSiteId, wrkCtr.WRKCTRID Stall, '' as 'TipeStall' , count(amc.CaseId) as UnitServed
--		from CASETABLE amc  
--		left join WRKCTRTABLE wrkCtr on wrkCtr.WRKCTRID = amc.WRKCTRID  
--		where lower(amc.Status) not in ('Created', 'InProcess', 'Cancelled') and lower(amc.DataAreaId) not in ('KZU', 'DAT')
--		  and amc.INVENTSITEID != '' 
--		  and (amc.PARENTID is null or amc.PARENTID = '') 
--		Group by Convert(char,amc.CreatedDateTime1,101), amc.ZInventSiteId, wrkCtr.WRKCTRID
--	)dt on cast(dt.Date as date) = cast(AbsensiDate as date) and  dt.ZInventSiteId = ZOutlet 
----where cast(AbsensiDate as date) = '2021-01-02'
--where ZOutlet is not null and ZInqAbsensiMekanikLine.DataAreaId not in ('KZU', 'DAT')
--group by AbsensiDate, ZInqAbsensiMekanikLine.DataAreaId, ZOutlet, dt.Date, dt.Stall, dt.TipeStall, invSt.ZDealerAfterSales, invSt.Name,
--		invSt.AreaCode, invSt.zIAMIArea
			
  
select Cast(amc.CreatedDateTime1 as date) 'Date', invSt.SiteId 'Outlet', invSt.Name 'OutletName', amc.dataAreaId 'Dealer',invSt.ZDealerSales 'DealerName', 
	invSt.AreaCode+' - '+ invSt.ZIAMIAreas Area, wrkCtr.WrkCtrId Stall,  
		'' as 'TipeStall', count(amc.CaseId) UnitServed
from  SILVER_WAREHOUSE.dbo.CaseTable amc  
left join SILVER_WAREHOUSE.dbo.ZInventSites invSt on invSt.SiteId = amc.InventSiteId
left join SILVER_WAREHOUSE.dbo.WRKCTRTABLE wrkCtr on wrkCtr.WrkCtrId = amc.WrkCtrId  
where lower(amc.Status)  in ('Invoiced', 'Closed')
  and amc.InventSiteId != ''
  and invSt.ZIAMIAreas != ''
  and (amc.ParentId is null or amc.ParentId = '')
  and lower(amc.dataAreaId) not in ('KZU','DAT')
  and lower(SUBSTRING(wrkCtr.WrkCtrId,7,1)) = 'S'
Group by Cast(amc.CreatedDateTime1 as date), invSt.SiteId, invSt.Name, invSt.ZDealerSales, invSt.ZIAMIAreas, wrkCtr.WrkCtrId, invSt.AreaCode, 
			amc.dataAreaId