-- Auto Generated (Do not modify) 778C91D8BD5D6FBA7948CEAD7DE1B958298672DFA189FB2F2260383E615C27E7
-- dbo.vw_Report_52_EUS source

CREATE VIEW [dbo].[vw_Report_52_EUS]    
AS  

SELECT distinct  c.InventSiteId AS 'Kode Outlet',
		a.InvoiceId,
		CAST(a.InvoiceDate AS DATE) AS 'Invoice Date', a.Qty, 
		c.ZSalesman, e.Name as SalesmanName, c.ZSupervisor, k.Name as SPVName, l.KACAB, 
		Case
			 when DATEDIFF(month,m.ValidFrom,a.InvoiceDate) <= 12 then 'Sales Trainee' 
			 when DATEDIFF(month,m.ValidFrom,a.InvoiceDate) > 12 and DATEDIFF(month,m.ValidFrom,a.InvoiceDate) <= 24 then 'Junior Sales'
			 when DATEDIFF(month,m.ValidFrom,a.InvoiceDate) > 25 and DATEDIFF(month,m.ValidFrom,a.InvoiceDate) <= 36 then 'Sales'
			 when DATEDIFF(month,m.ValidFrom,a.InvoiceDate) > 36 then 'Senior Sales' 
			 else 'Sales' end as Jenjang, i.NameAlias as Item_description,
		i.AMItemMinorGroupId Series, cast(m.ValidFrom as date) as PositionStartDate, cast(m.ValidTo as date) as PositionEndDate
		
FROM SILVER_WAREHOUSE.dbo.ZCustInvoiceTrans a
LEFT OUTER JOIN SILVER_WAREHOUSE.dbo.InventItemGroupItem AS b   ON LOWER(b.ItemId) = LOWER(a.ItemId)  AND LOWER(b.ItemDataAreaId) = LOWER(a.dataAreaId) 
LEFT OUTER JOIN SILVER_WAREHOUSE.dbo.ZSalesOrderHeader AS c  ON LOWER(c.SalesId) = LOWER(a.SalesId)  
LEFT OUTER JOIN SILVER_WAREHOUSE.dbo.Worker AS d  ON LOWER(d.PersonnelNumber) = LOWER(c.ZSalesman)  
LEFT OUTER JOIN SILVER_WAREHOUSE.dbo.DirPartyTable AS e ON LOWER(e.RecordId) = LOWER(d.Person1)  
LEFT OUTER JOIN SILVER_WAREHOUSE.dbo.Employment AS f on LOWER(f.PersonnelNumber) = LOWER(d.PersonnelNumber)
LEFT JOIN SILVER_WAREHOUSE.dbo.ZInventTables i ON LOWER(i.ItemId) = LOWER(a.ItemId) AND LOWER(i.dataAreaId) = LOWER(a.dataAreaId)
LEFT OUTER JOIN SILVER_WAREHOUSE.dbo.Worker AS j  ON LOWER(j.PersonnelNumber) = LOWER(c.ZSupervisor)  
LEFT OUTER JOIN SILVER_WAREHOUSE.dbo.DirPartyTable AS k ON LOWER(k.RecordId) = LOWER(j.Person1)  
LEFT OUTER  JOIN SILVER_WAREHOUSE.dbo.Report_53_BM AS l	ON LOWER(l.SITE) = LOWER(c.InventSiteId) and Left(l.RUNNINGDATE,6) = Left(convert(char,a.InvoiceDate,112),6)
LEFT OUTER JOIN (select PersonnelNumber, max(ValidFrom) ValidFrom, max(ValidTo) ValidTo, max(ModifiedDateTime1)  modifiedDateTime1
			from SILVER_WAREHOUSE.dbo.PositionWorkerAssignment where IsPrimaryPosition COLLATE Latin1_General_CI_AS = 'Yes' 
			Group by PersonnelNumber) m on LOWER(m.PersonnelNumber) = LOWER(c.ZSalesman)
WHERE (a.dataAreaId COLLATE Latin1_General_CI_AS <> 'KZU' COLLATE Latin1_General_CI_AS)  AND (b.ItemGroupId COLLATE Latin1_General_CI_AS = 'FU01' COLLATE Latin1_General_CI_AS) and i.AMItemMajorGroupId COLLATE Latin1_General_CI_AS = 'CV' and c.ZSalesman COLLATE Latin1_General_CI_AS != '';