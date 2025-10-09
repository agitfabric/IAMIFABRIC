-- Auto Generated (Do not modify) FF58BFDA40F2280A2BB6C6E2401A93C85D69141D7AC3D9E61614BE0BDE00BFE2

CREATE VIEW [dbo].[vw_KPI_Retention_Fleet_Target]
AS
--Select x.*, b.Nama_Mapping
--From
--(
--select  a.Year, a.Code_Outlet, 
--		CASE WHEN (CHARINDEX('/', a.Code_Customer) > 0) THEN LEFT(a.Code_Outlet, 3) + SUBSTRING(a.Code_Customer, 1, CHARINDEX('/', a.Code_Customer) - 1) 
--			ELSE LEFT(a.Code_Outlet, 3) + a.Code_Customer END AS CodeMapping, a.P, a.N, a.F,
--			(a.P * p.Monthly_Revenue + a.N * n.Monthly_Revenue) + a.F * f.Monthly_Revenue AS Revenue
--from KPI_Retention_Fleet_Qty a
--LEFT OUTER JOIN
--    (SELECT Year, Monthly_Revenue
--    FROM    dbo.KPI_Retention_TargetRevenue AS a
--    WHERE (Series = 'P')) AS p ON p.Year = a.Year 
--LEFT OUTER JOIN
--    (SELECT Year, Monthly_Revenue
--    FROM    dbo.KPI_Retention_TargetRevenue AS a
--    WHERE (Series = 'N')) AS n ON n.Year = a.Year 
--LEFT OUTER JOIN
--    (SELECT Year, Monthly_Revenue
--    FROM    dbo.KPI_Retention_TargetRevenue AS a
--    WHERE (Series = 'F')) AS f ON f.Year = a.Year
--)x
--LEFT OUTER JOIN KPI_Retention_UserMapping b on b.Code_Dealer+b.No_Customer = x.CodeMapping

Select x.*, b.Nama_Mapping
From
(
select  a.Year, a.Code_Outlet, 
		CASE WHEN (CHARINDEX('/', a.Code_Customer) > 0) THEN LEFT(a.Code_Outlet, 3) + SUBSTRING(a.Code_Customer, 1, CHARINDEX('/', a.Code_Customer) - 1) 
			ELSE LEFT(a.Code_Outlet, 3) + a.Code_Customer END AS CodeMapping, a.P, a.N, a.F,
			(a.P * p.Monthly_Revenue + a.N * n.Monthly_Revenue) + a.F * f.Monthly_Revenue AS Revenue
From STG_RETENTION_QTY_TARGET a
--from KPI_Retention_Fleet_Qty a
LEFT OUTER JOIN
    (SELECT Year, Monthly_Revenue
    FROM    STG_RETENTION_REVENUE_TARGET AS a
    WHERE (Series = 'P')) AS p ON p.Year = a.Year 
LEFT OUTER JOIN
    (SELECT Year, Monthly_Revenue
    FROM    STG_RETENTION_REVENUE_TARGET AS a
    WHERE (Series = 'N')) AS n ON n.Year = a.Year 
LEFT OUTER JOIN
    (SELECT Year, Monthly_Revenue
    FROM    dbo.STG_RETENTION_REVENUE_TARGET AS a
    WHERE (Series = 'F')) AS f ON f.Year = a.Year
)x
LEFT OUTER JOIN STG_RETENTION_CUSTOMER_MAPPING b on b.Code_Dealer+b.No_Customer = x.CodeMapping