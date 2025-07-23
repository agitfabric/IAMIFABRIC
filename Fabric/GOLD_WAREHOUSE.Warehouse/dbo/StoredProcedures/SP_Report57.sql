CREATE procedure [dbo].[SP_Report57] as

truncate table Report_57;

insert into Report_57
select p.PositionId POSITION, 
		pa.PositionId PARENTPOSITION,
		case when e.ZIAMIArea = 'Sumbagut' then 'Sumatera bagian utara'
		when e.ZIAMIArea = 'Sumbagsel' then 'Sumatera bagian selatan'
		when e.ZIAMIArea = 'JKT' then 'DKI Jakarta'
		when e.ZIAMIArea = 'Jabar' then 'Jawa Barat'
		when e.ZIAMIArea = 'Jateng' then 'Jawa Tengah'
		when e.ZIAMIArea = 'Jatim' then 'Jawa Timur'
		when e.ZIAMIArea = 'Kalimantan' then 'Kalimantan'
		when e.ZIAMIArea = 'Sul_IBT' then 'Sulawesi & IBT'
		else e.ZIAMIArea end Area,
		e.DealerName dealer, 
		e.OutletName outlet,
		e.OutletCode kodeoutlet,
		a.PersonnelNumber npk,
		a.Name nama,
		a.ZDepartment dept,
		p.Description jabatan,
		pa.WorkerPersonnelNumber reportnpk, 
		pa.WorkerName reportnama, 
		pa.TitleId reportjabatan,
		p.WorkerAssignmentStart assignstart, 
		p.WorkerAssignmentEnd assignend
	
	from SILVER_WAREHOUSE.dbo.Worker a
	left join SILVER_WAREHOUSE.dbo.Position p on a.PersonnelNumber = p.WorkerPersonnelNumber and GETDATE() between p.WorkerAssignmentStart AND p.WorkerAssignmentEnd
	left join vw_zInventSite  e on e.OutletCode = p.ZInventSiteId 
	left join SILVER_WAREHOUSE.dbo.Position pa on pa.PositionId = p.ReportsToPositionid
	where GETDATE() between p.WorkerAssignmentStart AND p.WorkerAssignmentEnd and a.ZOutlet NOT LIKE '%KZU%'