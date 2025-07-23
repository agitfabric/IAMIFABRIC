-- Auto Generated (Do not modify) 1BBFD5F021D05AE2F78CFB6FC1737401E5A7F31434DBD137EA1A242F742641EB
CREATE view [dbo].[vw_ZSalesman]

as

SELECT 
	ZSalesman
   ,COUNT(ZSalesman) Penjualan
FROM SalesTable
WHERE SalesStatus = 'Invoiced'
GROUP BY ZSalesman