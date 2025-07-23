-- Auto Generated (Do not modify) 1B0C87C84E747304F01C8A14BE8918F505B7566FC6233EFFE58DA72A4E10BBB9
CREATE VIEW [dbo].[vw_Report_52_Salesman]    
AS    
SELECT b.PersonnelNumber NPK,b.RecordId WorkerId,b.ZOutlet,e.ValidFrom,e.ValidTo, CASE WHEN d .Affix IS NULL OR    
                  d .Affix = 'Sales' OR    
                  d .Affix = '-' THEN 'Sales' ELSE d .Affix END AS 'Jenjang',  1 as JumlahSalesman
				  
FROM     dbo.GroupLine AS a LEFT OUTER JOIN    
                  SILVER_WAREHOUSE.dbo.Worker AS b ON b.PersonnelNumber = a.UserIDSalesman LEFT OUTER JOIN    
                  SILVER_WAREHOUSE.dbo.DirPartyTable AS c ON c.RecordId = b.Person1 LEFT OUTER JOIN    
                  SILVER_WAREHOUSE.dbo.NameAffix AS d ON d.RecordId = c.PersonalSuffix    
				  LEFT join SILVER_WAREHOUSE.dbo.Employment as e on e.Worker=b.RecordId
WHERE  (a.dataAreaId <> 'kzu') AND (b.ZOutlet IS NOT NULL) AND (b.ZOutlet <> '') and lower(b.ZDepartment)='sales'