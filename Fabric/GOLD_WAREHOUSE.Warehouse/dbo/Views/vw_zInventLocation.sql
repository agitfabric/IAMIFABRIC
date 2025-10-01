-- Auto Generated (Do not modify) 3534CB6AD43188CE9BD099556859DE61F9ADB9817CA016636350959BDE8EF30E
/****** Object:  View [dbo].[vw_zInventLocation]    Script Date: 24/09/2025 12:29:52 ******/
CREATE   VIEW [dbo].[vw_zInventLocation]
AS
SELECT a.InventLocationID AS warehouse, a.InventSiteID AS outletCode, b.Name AS OutletName, b.dataAreaId AS dealerCode, g.Description AS dealerName, b.Group_Dealer, b.AreaCode + ' - ' + b.ZIAMIArea AS Area, 
                  e.Description AS City
FROM     dbo.InventLocation AS a 
LEFT OUTER JOIN
                  SILVER_WAREHOUSE.dbo.ZInventSites AS b ON LOWER(b.SiteId) = LOWER(a.InventSiteID) 
				  LEFT JOIN
				  SILVER_WAREHOUSE.dbo.Ledger g on LOWER(g.ChartOfAccounts) = LOWER(b.dataAreaId)
				  LEFT OUTER JOIN
                  SILVER_WAREHOUSE.dbo.SiteLogisticLocation AS c ON LOWER(c.Site) = LOWER(b.RecordId) AND LOWER(c.IsPrimary) = 'yes' 
				  LEFT OUTER JOIN
                  SILVER_WAREHOUSE.dbo.ZLogisticsEntityPostalAddress AS d ON LOWER(d.Location) = LOWER(c.Location) AND DATEADD(HOUR, 7, GETDATE()) BETWEEN d.ValidFrom AND d.ValidTo 
				  LEFT OUTER JOIN
                  SILVER_WAREHOUSE.dbo.AddressCity AS e ON LOWER(e.Name) = LOWER(d.City) 
				  INNER JOIN 
				  SILVER_WAREHOUSE.dbo.ForecastModel AS F ON LOWER(F.Warehouse) = LOWER(a.InventLocationID) and LOWER(F.dataAreaId) != 'kzu'