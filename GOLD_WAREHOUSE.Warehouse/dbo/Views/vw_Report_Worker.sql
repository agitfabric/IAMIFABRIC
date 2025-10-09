-- Auto Generated (Do not modify) F1BD47B247C52D5FFDB041513F89B2E29EE067C4395054B4BC9E3970D2A360FB
CREATE  view [dbo].[vw_Report_Worker]  
as  
SELECT  
 e1.Name  
   ,e.ZOutlet  
   ,e.PersonnelNumber  
   ,e.Person1  
   ,e.RecordId  
   ,e.ZDepartment  
FROM SILVER_WAREHOUSE.dbo.Worker e  
LEFT JOIN SILVER_WAREHOUSE.dbo.DirPartyTable e1  
 ON e1.RecordId = e.Person1  
LEFT JOIN SILVER_WAREHOUSE.dbo.ZHcmWorkerTitle e2  
 ON e2.Worker = e.RecordId  
  AND GETDATE() BETWEEN e2.ValidFrom AND e2.ValidTo  
LEFT JOIN SILVER_WAREHOUSE.dbo.ZHcmTitle e3  
 ON e3.RecordId = e2.Title  
GROUP BY e1.Name  
  ,e.ZOutlet  
  ,e.PersonnelNumber  
  ,e.Person1  
  ,e.RecordId  
   ,e.ZDepartment