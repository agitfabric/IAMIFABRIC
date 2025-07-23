-- Auto Generated (Do not modify) 72195E1B96F77BBA8D248BDACBD3A1014EAB49A304722E03E5B4891798D5A230
CREATE VIEW [dbo].[vw_TargetPenjualan]
AS
with TargetSaleslatest as ( 
SELECT *, ROW_NUMBER() OVER (PARTITION BY SiteCode, YearPeriod, MonthPeriod, FuncAreaId ORDER BY CreatedOn DESC) as rn from SILVER_WAREHOUSE.dbo.TargetSales)

select  c.DealerCategory, c.DealerCode as dataAreaId, c.DealerName as ZDealerAfterSales, c.OutletCode as Site, c.OutletName as Name, c.Area, 
	   case when MonthPeriod = 1 then Cast(Cast(YearPeriod as char(4)) + '0101' as Date)  
			when MonthPeriod = 2 then Cast(Cast(YearPeriod as char(4)) + '0201' as Date)
			when MonthPeriod = 3 then Cast(Cast(YearPeriod as char(4)) + '0301' as Date)
			when MonthPeriod = 4 then Cast(Cast(YearPeriod as char(4)) + '0401' as Date)
			when MonthPeriod = 5 then Cast(Cast(YearPeriod as char(4)) + '0501' as Date)
			when MonthPeriod = 6 then Cast(Cast(YearPeriod as char(4)) + '0601' as Date)
			when MonthPeriod = 7 then Cast(Cast(YearPeriod as char(4)) + '0701' as Date)
			when MonthPeriod = 8 then Cast(Cast(YearPeriod as char(4)) + '0801' as Date)
			when MonthPeriod = 9 then Cast(Cast(YearPeriod as char(4)) + '0901' as Date)
			when MonthPeriod = 10 then Cast(Cast(YearPeriod as char(4)) + '1001' as Date)
			when MonthPeriod = 11 then Cast(Cast(YearPeriod as char(4)) + '1101' as Date)
			when MonthPeriod = 12 then Cast(Cast(YearPeriod as char(4)) + '1201' as Date)  end as TargetDate,	
		ZSeriesTargetPenjualan as SeriesType,		
		b.MinorGroupId, a.TargetSales Target
from TargetSaleslatest a  
  inner join vw_zInventSite c on c.OutletCode = a.SiteCode
  left join SILVER_WAREHOUSE.dbo.InventItemMinorGroup b on b.ZSeriesTargetPenjualanValue = a.FuncAreaId and left(a.SiteCode,3) = b.dataAreaId and b.MinorGroupId != 'BISON'
  WHERE c.DealerCategory = 'NON-AI' and a.rn = 1