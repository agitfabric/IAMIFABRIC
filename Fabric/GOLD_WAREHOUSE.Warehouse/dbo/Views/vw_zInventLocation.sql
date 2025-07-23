-- Auto Generated (Do not modify) 3534CB6AD43188CE9BD099556859DE61F9ADB9817CA016636350959BDE8EF30E
CREATE VIEW [dbo].[vw_zInventLocation]
AS
SELECT a.InventLocationID AS warehouse, a.InventSiteID AS outletCode, b.Name AS OutletName, b.dataAreaId AS dealerCode, g.Description AS dealerName, b.Group_Dealer, b.AreaCode + ' - ' + b.ZIAMIArea AS Area, 
                  e.Description AS City
FROM     dbo.InventLocation AS a 
LEFT OUTER JOIN
                  dbo.ZInventSites AS b ON b.SiteId = a.InventSiteID 
				  LEFT JOIN
				  Ledger g on g.ChartOfAccounts = b.dataAreaId
				  LEFT OUTER JOIN
                  dbo.SiteLogisticsLocation AS c ON c.Site = b.RecordId AND c.IsPrimary = 'Yes' 
				  LEFT OUTER JOIN
                  dbo.ZLogisticsEntityPostalAddress AS d ON d.Location = c.Location AND GETDATE() BETWEEN d.ValidFrom AND d.ValidTo 
				  LEFT OUTER JOIN
                  dbo.AddressCity AS e ON e.Name = d.City 
				  INNER JOIN 
				  dbo.ForecastModel AS F ON F.Warehouse = a.InventLocationID and F.dataAreaId != 'kzu'