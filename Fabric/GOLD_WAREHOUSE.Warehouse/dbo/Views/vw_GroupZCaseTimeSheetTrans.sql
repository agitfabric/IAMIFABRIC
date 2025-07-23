-- Auto Generated (Do not modify) AA0286321F78888402C474B2AF13D1CB20B4572D65739D8F62BBB5FF5CD4B8A1
 
CREATE view [dbo].[vw_GroupZCaseTimeSheetTrans]    
as    
SELECT    
 ZResourceId PersonnelNumber    
   ,ProjTransDate AbsensiDate    
   ,cast(CaseId as varchar(255)) ProjId    
FROM SILVER_WAREHOUSE.dbo.ZCaseTimeSheetTrans    
WHERE CaseId IS NOT NULL    
GROUP BY ZResourceId    
  ,ProjTransDate    
  ,CaseId