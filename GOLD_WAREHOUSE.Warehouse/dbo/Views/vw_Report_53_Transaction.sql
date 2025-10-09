-- Auto Generated (Do not modify) 8B885C860211B874FBFDC4BBA9F60E8AE692178CD5DBF683BB6947F0B396A228
CREATE view [dbo].[vw_Report_53_Transaction]
as

SELECT top 1
	d.dataAreaId DealerCode
   ,d.ZDealerAfterSales DealerName
   ,c.InventSiteId OutletCode
   ,d.Name OutletName
   ,c.InventSiteId+' - '+d.Name Outlet
   , d.ZIAMIArea Area
   ,e1.Name SalesName
   ,e.ZDepartment Department
   ,e3.TitleId
   ,e4.Affix Jenjang
   ,f1.Name SpvName
   --,g.Name KacabName
   ,dirKaCab.Name KacabName
   ,c.SalesId
   ,a.InvoiceDate
   ,a.Qty AS QtyInvoice
   ,c.ZSalesman --into Report_53_Update--drop table Report_53_Update
    
FROM SILVER_WAREHOUSE.dbo.ZCustInvoiceTrans a
LEFT JOIN SILVER_WAREHOUSE.dbo.InventItemGroupItem b
	ON b.ItemId = a.ItemId
		AND b.ItemDataAreaId = a.dataAreaId
LEFT JOIN ZSalesOrderHeader c
	ON c.SalesId = a.SalesId
LEFT JOIN SILVER_WAREHOUSE.dbo.ZInventSites d
	ON d.SiteId = c.InventSiteId
left join SILVER_WAREHOUSE.dbo.SiteLogisticLocation invsl on invsl.Site = d.RecordId and invsl.IsPrimary = 'Yes'
left join SILVER_WAREHOUSE.dbo.ZLogisticsEntityPostalAddress invspa on invspa.Location = invsl.Location and (cast(GETDATE() as date) >= cast(invspa.ValidFrom as date) and cast(GETDATE() as date) <= cast(invspa.ValidTo as date)) 
left join SILVER_WAREHOUSE.dbo.AddressCity invsll on invsll.Name = invspa.City
	--SalesMan
LEFT JOIN
(
select PersonnelNumber, Person1, RecordId, ZDepartment from SILVER_WAREHOUSE.dbo.Worker
group by PersonnelNumber, Person1, RecordId, ZDepartment
) e ON e.PersonnelNumber = c.ZSalesman
--Worker e
--	ON e.PersonnelNumber = c.ZSalesman
LEFT JOIN SILVER_WAREHOUSE.dbo.DirPartyTable e1
	ON e1.RecordId = e.Person1
LEFT JOIN SILVER_WAREHOUSE.dbo.ZHcmWorkerTitle e2
	ON e2.Worker = e.RecordId
		AND GETDATE() BETWEEN e2.ValidFrom AND e2.ValidTo
LEFT JOIN SILVER_WAREHOUSE.dbo.ZHcmTitle e3
	ON e3.RecordId = e2.Title
LEFT JOIN NameAffix e4
	ON e4.RecordId = e1.PersonalSuffix
-- Supervisor
LEFT JOIN
(
select PersonnelNumber, Person1, RecordId, ZDepartment from SILVER_WAREHOUSE.dbo.Worker
group by PersonnelNumber, Person1, RecordId, ZDepartment
) f
ON f.PersonnelNumber = c.ZSupervisor
LEFT JOIN SILVER_WAREHOUSE.dbo.DirPartyTable f1
	ON f1.RecordId = f.Person1
LEFT JOIN SILVER_WAREHOUSE.dbo.HcmWorkerPrimaryPositionAssignmentView hcmWSpv
	ON hcmWSpv.Worker = f.RecordId
		AND GETDATE() BETWEEN hcmWSpv.ValidFrom AND hcmWSpv.ValidTo
		AND hcmWSpv.IsPrimaryPosition = 'Yes'
LEFT JOIN SILVER_WAREHOUSE.dbo.PositionDetails hcmPosDetSpv
	ON hcmPosDetSpv.PositionPublic = hcmWSpv.Position 
		AND GETDATE() BETWEEN hcmPosDetSpv.ValidFrom AND hcmPosDetSpv.ValidTo
LEFT JOIN SILVER_WAREHOUSE.dbo.DirPartyTable dirSpv
	ON dirSpv.RecordId = hcmPosDetSpv.DepartmentNumber
LEFT JOIN SILVER_WAREHOUSE.dbo.PositionHierarchy hcmPosSpv
	ON hcmPosSpv.Position = hcmPosDetSpv.PositionPublic
		AND GETDATE() BETWEEN hcmPosSpv.ValidFrom AND hcmPosSpv.ValidTo
LEFT JOIN SILVER_WAREHOUSE.dbo.HcmWorkerPrimaryPositionAssignmentView hcmPosWASpv
	ON hcmPosWASpv.Position = hcmPosSpv.ParentPosition
		AND GETDATE() BETWEEN hcmPosWASpv.ValidFrom AND hcmPosWASpv.ValidTo
------Kacab
--left join Worker KaCab on KaCab.RecordId = hcmPosWASpv.WORKER
LEFT JOIN
(
select PersonnelNumber, Person1, RecordId, ZDepartment from SILVER_WAREHOUSE.dbo.Worker
group by PersonnelNumber, Person1, RecordId, ZDepartment
) KaCab on KaCab.RecordId = hcmPosWASpv.Worker
left join SILVER_WAREHOUSE.dbo.DirPartyTable dirKaCab on dirKaCab.RecordId = KaCab.Person1	
WHERE b.ItemGroupId = 'FU01'
and d.dataAreaId<>'kzu'
--AND c.InventSiteId = 'ASC04'
--AND CONVERT(CHAR, a.InvoiceDate, 112) BETWEEN '20210101' AND '20210228'