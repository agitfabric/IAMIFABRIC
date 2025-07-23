-- Auto Generated (Do not modify) 0F5C4542C6C7D462E4E916FFB97A9CCB1DCB2F5650BAAC8F70B3BB84EC61EFE4
CREATE VIEW [dbo].[vw_Report_29_2]
AS
SELECT        Format(a.DatePhysical, 'yyyy-MM') AS DatePhysical,a.Nama_Dealer, a.Series, a.Type_Description, a.[CV/LCV], SUM(CASE WHEN a.Type_Description = a.Series THEN NULL ELSE a.wholesale END) AS Wholesale, 
                         SUM(CASE WHEN a.Type_Description = a.Series THEN NULL ELSE CASE WHEN a.EUS < 0 THEN a.EUS * - 1 ELSE a.EUS * - 1 END END) AS Retail, 
                         CASE WHEN a.Type_Description = a.Series THEN b.Total_Target ELSE NULL END AS Total_Target
FROM            Report_25 AS a LEFT JOIN
                             (SELECT        Format(TargetDate, 'yyyy-MM') AS TargetDate, SUM(Target) AS Total_Target, MinorGroupId,ZDealerAfterSales
                               FROM            vw_TestTargetPenjualan
                               GROUP BY Format(TargetDate, 'yyyy-MM'), MinorGroupId,ZDealerAfterSales) AS b ON a.Series = b.MinorGroupId AND Format(a.DatePhysical, 'yyyy-MM') = b.TargetDate and a.Nama_Dealer = b.ZDealerAfterSales
GROUP BY Format(a.DatePhysical, 'yyyy-MM'), a.Series, a.Type_Description, b.Total_Target, a.[CV/LCV],a.Nama_Dealer
UNION ALL
SELECT        Format(a.DatePhysical, 'yyyy-MM') AS DatePhysical,a.Nama_Dealer, a.Series, a.Series AS Type_Desc, a.[CV/LCV], NULL AS Wholesale, NULL AS Retail, b.Total_Target
FROM            Report_25 AS a LEFT JOIN
                             (SELECT        Format(TargetDate, 'yyyy-MM') AS TargetDate, SUM(Target) AS Total_Target, MinorGroupId,ZDealerAfterSales
                               FROM            vw_TargetPenjualan
                               GROUP BY Format(TargetDate, 'yyyy-MM'), MinorGroupId,ZDealerAfterSales) AS b ON a.Series = b.MinorGroupId AND Format(a.DatePhysical, 'yyyy-MM') = b.TargetDate and a.Nama_Dealer = b.ZDealerAfterSales
GROUP BY Format(a.DatePhysical, 'yyyy-MM'), a.Series, b.Total_Target, a.[CV/LCV],a.Nama_Dealer