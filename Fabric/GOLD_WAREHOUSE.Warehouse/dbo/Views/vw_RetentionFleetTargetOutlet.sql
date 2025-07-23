-- Auto Generated (Do not modify) D9048D98E28C9FB1EB3FEE482487DD3590935CD35B656E93880F64024D44E59F
CREATE VIEW [dbo].[vw_RetentionFleetTargetOutlet] AS
(
	Select  month(a.Tanggal) Bulan, year(a.Tanggal) Tahun, a.Code_Outlet, SUBSTRING(a.Code_Outlet, 1, 3) Code_Dealer, 
	sum(a.P) P, sum(a.N) N, sum(a.F) F, sum(a.Revenue) Target
	FROM   vw_KPI_Retention_Target a
	group by month(a.Tanggal), year(a.Tanggal), a.Code_Outlet
)