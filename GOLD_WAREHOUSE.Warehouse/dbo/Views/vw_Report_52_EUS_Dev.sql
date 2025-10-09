-- Auto Generated (Do not modify) 15A192A0DAA25D1EF2F638141345DA2D09960D122C6A20238FB74D439F9237BB
-- dbo.vw_Report_52_EUS_Dev source
-- awalnya validform pake f (diubah jadi pakai m agar nilainya sama dengan exisisting)
CREATE VIEW [dbo].[vw_Report_52_EUS_Dev]
AS

SELECT c.InventSiteId AS 'Kode Outlet',
CAST(a.InvoiceDate AS DATE) AS 'Invoice Date', a.Qty,
c.ZSalesman, e.Name as SalesmanName, c.ZSupervisor, k.Name as SPVName, l.KACAB,
pwa.Name as 'NameKacab',
CASE
WHEN DATEDIFF(month,m.ValidFrom,a.InvoiceDate) <= 12 THEN 'Sales Trainee'
WHEN DATEDIFF(month,m.ValidFrom,a.InvoiceDate) > 12 AND DATEDIFF(month,m.ValidFrom,a.InvoiceDate) <= 24 THEN 'Junior Sales'
WHEN DATEDIFF(month,m.ValidFrom,a.InvoiceDate) > 25 AND DATEDIFF(month,m.ValidFrom,a.InvoiceDate) <= 36 THEN 'Sales'
WHEN DATEDIFF(month,m.ValidFrom,a.InvoiceDate) > 36 THEN 'Senior Sales'
ELSE 'Sales' END as Jenjang, i.NameAlias as Item_description,
i.AMItemMinorGroupId Series, CAST(m.ValidFrom as date) as PositionStartDate, CAST(m.ValidTo as date) as PositionEndDate

FROM SILVER_WAREHOUSE.dbo.ZCustInvoiceTrans a
LEFT OUTER JOIN SILVER_WAREHOUSE.dbo.InventItemGroupItem AS b 
    ON b.ItemId COLLATE Latin1_General_CI_AS = a.ItemId COLLATE Latin1_General_CI_AS 
    AND b.ItemDataAreaId COLLATE Latin1_General_CI_AS = a.dataAreaId COLLATE Latin1_General_CI_AS
LEFT OUTER JOIN SILVER_WAREHOUSE.dbo.ZSalesOrderHeader AS c 
    ON c.SalesId COLLATE Latin1_General_CI_AS = a.SalesId COLLATE Latin1_General_CI_AS
LEFT OUTER JOIN SILVER_WAREHOUSE.dbo.Worker AS d 
    ON d.PersonnelNumber COLLATE Latin1_General_CI_AS = c.ZSalesman COLLATE Latin1_General_CI_AS
LEFT OUTER JOIN SILVER_WAREHOUSE.dbo.DirPartyTable AS e ON e.RecordId = d.Person1
LEFT OUTER JOIN SILVER_WAREHOUSE.dbo.Employment AS f 
    on f.PersonnelNumber COLLATE Latin1_General_CI_AS = d.PersonnelNumber COLLATE Latin1_General_CI_AS
LEFT JOIN SILVER_WAREHOUSE.dbo.ZInventTables i 
    ON i.ItemId COLLATE Latin1_General_CI_AS = a.ItemId COLLATE Latin1_General_CI_AS 
    AND i.dataAreaId COLLATE Latin1_General_CI_AS = a.dataAreaId COLLATE Latin1_General_CI_AS
LEFT OUTER JOIN SILVER_WAREHOUSE.dbo.Worker AS j 
    ON j.PersonnelNumber COLLATE Latin1_General_CI_AS = c.ZSupervisor COLLATE Latin1_General_CI_AS
LEFT OUTER JOIN SILVER_WAREHOUSE.dbo.DirPartyTable AS k ON k.RecordId = j.Person1
LEFT OUTER JOIN dbo.vw_Kacab AS pwa 
    on pwa.PersonnelNumber COLLATE Latin1_General_CI_AS = c.ZSupervisor COLLATE Latin1_General_CI_AS
LEFT OUTER JOIN dbo.Report_53_BM AS l 
    ON l.SITE COLLATE Latin1_General_CI_AS = c.InventSiteId COLLATE Latin1_General_CI_AS 
    and LEFT(l.RUNNINGDATE,6) = LEFT(convert(char,a.InvoiceDate,112),6)
LEFT OUTER JOIN (select PersonnelNumber, max(ValidFrom) ValidFrom, max(ValidTo) ValidTo, max(ModifiedDateTime1) modifiedDateTime1
from SILVER_WAREHOUSE.dbo.PositionWorkerAssignment 
where IsPrimaryPosition COLLATE Latin1_General_CI_AS = 'Yes' COLLATE Latin1_General_CI_AS
Group by PersonnelNumber) m 
on m.PersonnelNumber COLLATE Latin1_General_CI_AS = c.ZSalesman COLLATE Latin1_General_CI_AS
WHERE (a.dataAreaId COLLATE Latin1_General_CI_AS <> 'KZU' COLLATE Latin1_General_CI_AS) 
AND (b.ItemGroupId COLLATE Latin1_General_CI_AS = 'FU01' COLLATE Latin1_General_CI_AS) 
and i.AMItemMajorGroupId COLLATE Latin1_General_CI_AS = 'CV' COLLATE Latin1_General_CI_AS 
and c.ZSalesman COLLATE Latin1_General_CI_AS != '' COLLATE Latin1_General_CI_AS;