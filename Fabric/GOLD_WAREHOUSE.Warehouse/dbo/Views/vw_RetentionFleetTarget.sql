-- Auto Generated (Do not modify) 1CCBB431381A3058E3873064285AABC1C113FD60E8414AECBB808EF01A18DC00
CREATE VIEW [dbo].[vw_RetentionFleetTarget] AS
(
	Select  month(a.Tanggal) Bulan, year(a.Tanggal) Tahun, a.Code_Outlet, SUBSTRING(a.Code_Outlet, 1, 3) Code_Dealer, a.CodeMapping Code_Mapping, a.Nama_Mapping, 
	sum(a.P) P, sum(a.N) N, sum(a.F) F, sum(a.Revenue) Target
	FROM   vw_KPI_Retention_Target a
	group by month(a.Tanggal), year(a.Tanggal), a.Code_Outlet, a.CodeMapping, a.Nama_Mapping
)