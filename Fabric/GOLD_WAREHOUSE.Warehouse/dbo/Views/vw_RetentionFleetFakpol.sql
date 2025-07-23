-- Auto Generated (Do not modify) D05339703C2E7840A907B20E3E987735F83A381352886DAB24424288D7287258
CREATE VIEW [dbo].[vw_RetentionFleetFakpol] AS
(
		SELECT month(CAST(a.ApprovalDate AS DATE)) AS 'Bulan', 
		year(CAST(a.ApprovalDate AS DATE)) AS 'Tahun', 
		a.KodeOutlet AS 'Code_Outlet',
		a.KodeDealer+a.CustomerID  AS 'Code_Mapping', 
		count(a.KodeDealer+a.CustomerID) AS 'Jumlah_Fakpol' 
		FROM Report_Fakpol a
		WHERE year(CAST(a.ApprovalDate AS DATE)) = 2024
		GROUP BY month(CAST(a.ApprovalDate AS DATE)), 
				year(CAST(a.ApprovalDate AS DATE)), 
				a.KodeOutlet,
				a.KodeDealer+a.CustomerID
)