-- Auto Generated (Do not modify) 9D658925F21DF1C6657EA56556D9192DA44DBBF8E7EE617C027F5411A9A8DBB2
CREATE VIEW [dbo].[vw_RetentionFleetTargetDealer] AS
(
	Select  month(a.Tanggal) Bulan, year(a.Tanggal) Tahun, SUBSTRING(a.Code_Outlet, 1, 3) Code_Dealer, 
	sum(a.P) P, sum(a.N) N, sum(a.F) F, sum(a.Revenue) Target
	FROM   vw_KPI_Retention_Target a
	group by month(a.Tanggal), year(a.Tanggal), SUBSTRING(a.Code_Outlet, 1, 3)
)