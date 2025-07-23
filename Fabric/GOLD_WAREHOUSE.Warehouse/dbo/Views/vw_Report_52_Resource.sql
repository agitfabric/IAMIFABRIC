-- Auto Generated (Do not modify) 4DC4ECB61004EED598C90326DD8D8D9700D84CFC0C954103D281DD581E70B958
CREATE view [dbo].[vw_Report_52_Resource]                      
as                  
WITH Resources            
AS            
(SELECT            
  DealerName            
    ,OutletCode            
    ,OutletCode + ' - ' + OutletName [OutletName]            
    ,ISNULL(Jenjang, 'Other') [Jenjang]            
    ,COUNT(*) ManPower           
    ,NPK  
	,ActiveResource
 --,JoinDate          
 --,EndofContract          
 FROM SILVER_WAREHOUSE.dbo.Report_52_Resource             
 GROUP BY DealerName            
   ,OutletCode            
   ,OutletName            
   ,Jenjang            
   ,NPK 
   ,ActiveResource
   --,joinDate          
   --,EndofContract        
   )            
SELECT            
 a.*            
   --,ISNULL(b.UnitSales, 0) [UnitSales]            
   --,b.City            
FROM Resources a