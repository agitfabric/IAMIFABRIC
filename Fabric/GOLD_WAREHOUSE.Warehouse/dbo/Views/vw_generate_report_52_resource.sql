-- Auto Generated (Do not modify) 4E7F122C9F49AC4D8269C63748843BED0BA6ED97238B98CB5C8425B3A760525E

CREATE view [dbo].[vw_generate_report_52_resource]  
as  
--Resource SalesMan/SalesGirl  

SELECT 
	E.ZDealerAfterSales DealerName
   ,E.SiteId OutletCode
   ,E.Name OutletName
   ,B.Person1 Person
   ,B.PersonnelNumber NPK
   ,B.Name Nama
   ,B.ZDepartment
   ,D.Affix Jenjang,f.ValidFrom,f.ValidTo  
FROM GroupLine A
LEFT JOIN Worker B
	ON A.UserIDSalesman = B.PersonnelNumber
LEFT JOIN DirPartyTable C
	ON B.Person1 = C.RecordId
LEFT JOIN NameAffix D
	ON D.RecordId = C.PersonalSuffix
LEFT JOIN ZInventSites E
	ON B.ZOutlet = E.SiteId
	LEFT join Employment f on f.Worker=B.RecordId
WHERE B.ZOutlet is not NULL