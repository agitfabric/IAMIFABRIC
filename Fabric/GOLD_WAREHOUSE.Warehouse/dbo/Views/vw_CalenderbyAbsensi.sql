-- Auto Generated (Do not modify) 96901DCE3CA5730E2572AAFE3430EEF95FD4906EFCC8EA090E432A522A0FB397
CREATE     VIEW [dbo].[vw_CalenderbyAbsensi]
AS
SELECT TOP (100) PERCENT DataAreaId, CAST(AbsensiDate AS date) AS Date, 1 AS Jumlah
FROM     SILVER_WAREHOUSE.dbo.ZInqAbsensiMekanikLine
WHERE  (LOWER(Absensi) = 'closed') AND (Lower(DataAreaId) NOT IN ('dat', 'kzu'))
GROUP BY DataAreaId, CAST(AbsensiDate AS date)
ORDER BY DataAreaId, Date