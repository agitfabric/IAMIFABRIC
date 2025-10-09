-- Auto Generated (Do not modify) 2ECD1DDBC47490798CCA0851D98E359C707F8A8523750B5A45C8D85C3D74A9D8

CREATE VIEW [dbo].[vw_KPI_Retention_Target]
AS
Select x.*, b.Nama_Mapping
From
(
SELECT	a.Tanggal, a.Code_Outlet, 
		CASE WHEN (CHARINDEX('/', a.Code_Customer) > 0) THEN LEFT(a.Code_Outlet, 3) + SUBSTRING(a.Code_Customer, 1, CHARINDEX('/', a.Code_Customer) - 1) 
			ELSE LEFT(a.Code_Outlet, 3) + a.Code_Customer END AS CodeMapping, 
			a.P, a.N, a.F, 
             (a.P * p.Monthly_Revenue + a.N * n.Monthly_Revenue) + a.F * f.Monthly_Revenue AS Revenue
FROM   dbo.KPI_Retention_TargetQty AS a 
LEFT OUTER JOIN
    (SELECT Year, Monthly_Revenue
    FROM    dbo.KPI_Retention_TargetRevenue AS a
    WHERE (Series = 'P')) AS p ON p.Year = a.Year 
LEFT OUTER JOIN
    (SELECT Year, Monthly_Revenue
    FROM    dbo.KPI_Retention_TargetRevenue AS a
    WHERE (Series = 'N')) AS n ON n.Year = a.Year 
LEFT OUTER JOIN
    (SELECT Year, Monthly_Revenue
    FROM    dbo.KPI_Retention_TargetRevenue AS a
    WHERE (Series = 'F')) AS f ON f.Year = a.Year
)x
LEFT OUTER JOIN KPI_Retention_UserMapping b on b.Code_Dealer+b.No_Customer = x.CodeMapping