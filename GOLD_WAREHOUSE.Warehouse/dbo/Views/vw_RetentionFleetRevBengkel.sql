-- Auto Generated (Do not modify) C06BC8754FCCD4D188407A894AFE074E0B35BD0B632DFB540BB547F1743B6460

CREATE VIEW [dbo].[vw_RetentionFleetRevBengkel] AS
(
	SELECT  month(CAST(d.InvoiceDate AS DATE)) AS 'Bulan', 
		year(CAST(d.InvoiceDate AS DATE)) AS 'Tahun', 
        a.InventSiteId AS 'Code_Outlet', 
        a.dataAreaId+a.CustAccount AS 'Code_Mapping', 
        sum (d.InvoiceAmount) AS 'Revenue_Bengkel'
    FROM SILVER_WAREHOUSE.dbo.CaseTable a
    INNER JOIN SILVER_WAREHOUSE.dbo.DeviceTable b ON b.DeviceId = a.DeviceId AND b.dataAreaId = a.dataAreaId
    INNER JOIN SILVER_WAREHOUSE.dbo.ZInventTables c ON c.ItemId = b.ItemId AND c.dataAreaId = b.dataAreaId
    INNER JOIN SILVER_WAREHOUSE.dbo.ProjInvoiceJour d ON d.ProjInvoiceProjId = a.CaseId 
    WHERE a.Status in ('Invoiced', 'Closed')
      AND c.AMItemMajorGroupId = 'CV' and a.GroupId not in('SM002','SM004','SM006') and year(CAST(d.InvoiceDate AS DATE)) = 2024
	GROUP BY month(CAST(d.InvoiceDate AS DATE)), 
		year(CAST(d.InvoiceDate AS DATE)), 
        a.InventSiteId, 
        a.dataAreaId+a.CustAccount
)