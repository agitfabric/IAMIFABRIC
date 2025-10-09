-- Auto Generated (Do not modify) 8F150AFD935069913BD9E7747721413E0473B9EF93490B485E000F36120DFA6E
CREATE VIEW [dbo].[vw_Salesman] AS
SELECT c.ZOutlet as OUTLET, d.Name as NAME, a.SalesGroupId as SALESGROUPID, 
b.Description as SPVNAME, a.UserIdSalesman as USERIDSALESMAN, a.Description as SALESMAN, 1 as Jumlah
FROM ZSalesGroupLine a 
LEFT Join ZSalesGroupTable b on a.SalesGroupId = b.SalesGroupId
LEFT JOIN Worker c on a.UserIdSalesman = c.PersonnelNumber
LEFT JOIN ZInventSites d on c.ZOutlet = d.SiteId
WHERE a.DataAreaId != 'kzu' and c.ZOutlet IS NOT NULL