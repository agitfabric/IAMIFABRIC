-- Auto Generated (Do not modify) A61C47FD321D55064FB34FCD669A16A19CFEBD7D13B3CDD87CCEFD56D616F5B9
CREATE view [dbo].[vw_OutletOrgChart]
as
select   a.ZOutlet Kode_Outlet, e.Name Nama_Outlet, e.ZDealerSales Dealer, m.TitleId Title --jabatan
		, c.Position Position_id, e.Group_Dealer, d.Description Position_name --position
		, b.Name Employee_Name, concat (e.AreaCode,' - ',e.ZIAMIArea) as Area,
		--case when e.ZIAMIAREA = 'Sumbagut' then 'Sumatera bagian utara'
		--	 when e.ZIAMIAREA = 'Sumbagsel' then 'Sumatera bagian selatan'
		--	 when e.ZIAMIAREA = 'JKT' then 'DKI Jakarta'
		--	 when e.ZIAMIAREA = 'Jabar' then 'Jawa Barat'
		--	 when e.ZIAMIAREA = 'Jateng' then 'Jawa Tengah'
		--	 when e.ZIAMIAREA = 'Jatim' then 'Jawa Timur'
		--	 when e.ZIAMIAREA = 'Kalimantan' then 'Kalimantan'
		--	 when e.ZIAMIAREA = 'Sul_IBT' then 'Sulawesi & IBT'
		--else e.ZIAMIAREA end Area,
		--e.ZIAMIAREA area, 
			 case when a.ZDepartment= 'SALES' then 'Sales'
			 else a.ZDepartment end ZDepartment 
			 ,g.ParentPosition Report_To_Position, j.Name as Report_To_Employee_Name
from SILVER_WAREHOUSE.dbo.Worker a
	left join SILVER_WAREHOUSE.dbo.DirPartyTable b on b.RecordId = a.Person1
	left join SILVER_WAREHOUSE.dbo.PositionWorkerAssignment c on c.Worker = a.RecordId and GETDATE() between c.ValidFrom AND c.ValidTo 
	left JOIN SILVER_WAREHOUSE.dbo.PositionDetails d ON c.Position =  d.PositionPublic and GETDATE() between d.ValidFrom AND d.ValidTo 
	left join SILVER_WAREHOUSE.dbo.ZInventSites e on e.SiteId = a.ZOutlet
	left join SILVER_WAREHOUSE.dbo.PositionHierarchy g on g.Position = c.Position and GETDATE() between g.ValidFrom AND g.ValidTo
	left join SILVER_WAREHOUSE.dbo.PositionWorkerAssignment h on h.Position = g.ParentPosition and GETDATE() between h.ValidFrom AND h.ValidTo
	left join SILVER_WAREHOUSE.dbo.Worker i on i.RecordId = h.Worker
	left join SILVER_WAREHOUSE.dbo.DirPartyTable j on j.RecordId = i.Person1	 
	left join SILVER_WAREHOUSE.dbo.Employment k on k.Worker = a.RecordId 
	left join SILVER_WAREHOUSE.dbo.ZHcmWorkerTitle l on l.Worker = a.RecordId and GETDATE() between l.ValidFrom AND l.ValidTo 
	left join SILVER_WAREHOUSE.dbo.ZHcmTitle m on m.RecordId = l.Title
	
where GETDATE() between k.ValidFrom AND k.ValidTo  and a.ZOutlet != ''
  and a.ZDepartment = 'Sales' and c.Position is not null
  --order by e.DATAAREAID,  a.ZOUTLET