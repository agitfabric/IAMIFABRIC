-- Auto Generated (Do not modify) 9172E774C16E9312C0AF6926DB3F853FB24AA0E75A6CD3FF701BCECACB0C501E
CREATE VIEW [dbo].[vw_KPI_Retention] AS
SELECT 
    '2023-01-01' as Tanggal,
	a.Code_Dealer,
	a.No_Customer,
	b.Code_Outlet as Outlet,
    a.Nama_Mapping as Mapping,
    b.P as Elf,
    b.N as Traga,
    b.F as Giga,
    SUM(CASE
            WHEN r.Series = 'P' THEN CAST(b.P AS BIGINT) * r.Monthly_Revenue
            WHEN r.Series = 'N' THEN CAST(b.N AS BIGINT) * r.Monthly_Revenue
            WHEN r.Series = 'F' THEN CAST(b.F AS BIGINT) * r.Monthly_Revenue
            ELSE 0
        END) AS Target
FROM 
    KPI_Retention_UserMapping AS a
INNER JOIN 
    KPI_Retention_TargetQty AS b ON b.Code_Customer = a.No_Customer
LEFT JOIN 
    KPI_Retention_TargetRevenue AS r ON r.Year = b.Year
GROUP BY 
    a.Code_Dealer, 
    a.Nama_Mapping,
    b.Code_Outlet,
	a.No_Customer,
    b.P,
    b.N,
    b.F;