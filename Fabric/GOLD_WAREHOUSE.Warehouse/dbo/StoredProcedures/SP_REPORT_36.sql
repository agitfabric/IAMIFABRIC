CREATE PROCEDURE  [dbo].[SP_REPORT_36]
AS
BEGIN
	SET NOCOUNT ON;

DECLARE @GetMaxRunningDate DATE, @GetCurrentDate DATE
SELECT @GetMaxRunningDate =ISNULL(DATEADD(DAY,1,MAX(AbsensiDate)), '2019-09-01'), @GetCurrentDate = CAST(GETDATE() AS DATE)
FROM Report_36


-- Main query
insert into Report_36
SELECT
       y.DealerCategory,
       y.DealerCode,
       y.DealerName,
       x.Outlet,
       y.OutletName,
       x.ResourceNumber,
       x.ResourceName,
       x.ResourceLevel,
       x.Jabatan,
       x.AbsensiDate,
       1 AS Kehadiran,
       7 AS JT,
       SUM(x.UnitServed) AS UnitServed,
       SUM(x.UnitReturn) AS UnitReturn,
       SUM(ISNULL(FR, 0)) AS FR,
       SUM(ISNULL(ACT, 0)) AS ACT,
       SUM(ISNULL(Jasa, 0)) AS Jasa,
       SUM(ISNULL(Part, 0)) AS Part,
       SUM(ISNULL(Bahan, 0)) AS Bahan
FROM (
        SELECT b.ZOutlet Outlet,
               a.ResourceNumber,
               c.Name ResourceName,
               d.PersonPersonalSuffix ResourceLevel,
               f.TitleId Jabatan,
               CAST(a.AbsensiDate AS DATE) AbsensiDate,
               g.CaseId,
               CASE WHEN h.TypeId = 'RT' THEN 1 ELSE 0 END UnitReturn,
               SUM(ISNULL(FR, 0)) AS FR,
               SUM(ISNULL(ACT, 0)) AS ACT,
               CASE WHEN g.CaseId IS NOT NULL AND LEN(g.CaseId) < 20 THEN 1 ELSE 0 END AS UnitServed,
               SUM(ISNULL(Jasa, 0)) AS Jasa,
               SUM(ISNULL(Part, 0)) AS Part,
               SUM(ISNULL(Bahan, 0)) AS Bahan
        FROM SILVER_WAREHOUSE.dbo.ZInqAbsensiMekanikLine a
                 INNER JOIN SILVER_WAREHOUSE.dbo.Worker b ON b.PersonnelNumber = a.ResourceNumber
                 LEFT JOIN SILVER_WAREHOUSE.dbo.DirPartyTable c ON c.RecordId = b.Person1
                 LEFT JOIN SILVER_WAREHOUSE.dbo.DirPersonBaseEntity d ON d.PartyNumber = c.PartyNumber AND d.LanguageId= 'en-us'
                 LEFT JOIN SILVER_WAREHOUSE.dbo.ZHcmWorkerTitle e ON e.Worker = b.RecordId AND GETDATE() BETWEEN e.ValidFrom AND e.ValidTo
                 LEFT JOIN SILVER_WAREHOUSE.dbo.ZHcmTitle f ON f.RecordId = e.Title
                 LEFT JOIN (SELECT ZResourceId, ProjTransDate, CaseId FROM SILVER_WAREHOUSE.dbo.ZCaseTimeSheetTrans GROUP BY ZResourceId, ProjTransDate, CaseId) g ON g.ZResourceId = a.ResourceNumber AND CAST(g.ProjTransDate AS DATE) = CAST(a.AbsensiDate AS DATE)
                 LEFT JOIN SILVER_WAREHOUSE.dbo.CaseTable h ON h.CaseId = g.CaseId
                 LEFT JOIN (SELECT ProjId, ISNULL(SUM(Qty), 0) AS FR, ISNULL(SUM(LineAmount), 0) AS Jasa FROM SILVER_WAREHOUSE.dbo.ZProjInvoiceEmpl GROUP BY ProjId) i ON i.ProjId = g.CaseId
                 LEFT JOIN (SELECT CaseId, SUM(CASE WHEN StopTime > 0 THEN (DATEDIFF_BIG(SECOND, DATEADD(SECOND, StartTime, StartDate), DATEADD(SECOND, StopTime, StopDate))) / CAST(3600 AS FLOAT) ELSE 0 END) AS ACT FROM SILVER_WAREHOUSE.dbo.ZCaseTimeSheetTrans WHERE TransType = 'Summary' AND Adjusted = 'No' GROUP BY CaseId) j ON j.CaseId = g.CaseId
                 LEFT JOIN (SELECT ProjId, ISNULL(SUM(CASE WHEN CategoryId = 'SP01' THEN LineAmount END), 0) AS Part, ISNULL(SUM(CASE WHEN CategoryId = 'SP02' THEN LineAmount END), 0) AS Bahan FROM SILVER_WAREHOUSE.dbo.ProjInvoiceItem GROUP BY ProjId, CategoryId) k ON k.ProjId = g.CaseId
        WHERE CAST(a.AbsensiDate AS DATE) BETWEEN @GetMaxRunningDate AND @GetCurrentDate
          AND a.Absensi = 'Closed'
          AND b.ZDepartment = 'Service'
          AND f.TitleId IN ('Mechanic', 'Mechanic BIB')
          AND a.DataAreaId != 'kzu'
        GROUP BY b.ZOutlet,
                 a.ResourceNumber,
                 c.Name,
                 d.PersonPersonalSuffix,
                 f.TitleId,
                 CAST(a.AbsensiDate AS DATE),
                 g.CaseId,
                 h.TypeId
    ) x
         LEFT JOIN vw_zInventSite y ON y.OutletCode = x.Outlet
GROUP BY y.DealerCategory,
         y.DealerCode,
         y.DealerName,
         y.OutletName,
         x.Outlet,
         x.ResourceNumber,
         x.ResourceName,
         x.ResourceLevel,
         x.Jabatan,
         x.AbsensiDate
ORDER BY x.Outlet, x.ResourceNumber, x.AbsensiDate DESC

END