-- Auto Generated (Do not modify) A6F667E2832F5FC2AA728886D246ADEF1E50C4F3D71BA0649DBC678E57FFBB00
CREATE view [dbo].[vw_Report_52_Trans]                    
as    
WITH CTE    
AS    
(SELECT    
  DealerName    
    ,DealerCode    
    ,OutletCode    
    ,OutletCode + ' - ' + OutletName [OutletName]    
    ,ISNULL(Jenjang, 'Other') Jenjang    
    ,InvoiceDate    
    ,SUM(Qty) UnitSales    
    ,CITY    
    ,NPK    
    ,Series    
 FROM SILVER_WAREHOUSE.dbo.Report_52_Trans    
 GROUP BY DealerName    
   ,DealerCode    
   ,OutletCode    
   ,OutletName    
   ,Jenjang    
   ,InvoiceDate    
   ,CITY    
   ,NPK    
   ,Series)    
SELECT    
 a.*    
   ,(SELECT    
   SUM(b.ManPower)    
  FROM vw_Report_52_Resource b    
  WHERE MONTH(a.InvoiceDate) = MONTH(b.ActiveResource)    
  AND YEAR(a.InvoiceDate) = YEAR(b.ActiveResource)    
  AND a.OutletCode = b.OutletCode    
  AND a.Jenjang = b.Jenjang  
  )    
 ManPower    
FROM CTE a