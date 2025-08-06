CREATE PROCEDURE [dbo].[SP_REPORT_40_SERVICESHARE_UNITSERVED]
AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


-- Inisialisasi tanggal
   DECLARE @GetMaxRunningDate date, @GetCurrentDate date

	select @GetMaxRunningDate = Isnull(cast(max(RunningDate)+'01' as date),'2019-09-01'), @GetCurrentDate = cast(getdate() as date) from Report_44_UnitServed_ServiceShare

-- Ambil daftar YearMonth
;WITH YearMonths AS (
    SELECT DISTINCT LEFT(CONVERT(CHAR(8), DatePhysical, 112), 6) AS YearMonth
    FROM InventTrans
    WHERE dataAreaId != 'kzu'
      AND CAST(DatePhysical AS DATE) BETWEEN @GetMaxRunningDate AND @GetCurrentDate
)
SELECT * INTO #TempYearMonth FROM YearMonths;

-- Loop YearMonth satu per satu
DECLARE @LoopYearMonth CHAR(6);
DECLARE @StarDate DATE;
DECLARE @MaxDate DATE;

WHILE EXISTS (SELECT TOP 1 1 FROM #TempYearMonth)
BEGIN
    SELECT TOP 1 @LoopYearMonth = YearMonth FROM #TempYearMonth ORDER BY YearMonth ASC;

    -- Hitung periode
    SET @StarDate = DATEADD(MONTH, 1, DATEADD(YEAR, -1, DATEADD(MONTH, DATEDIFF(MONTH, '19000101', @LoopYearMonth + '01'), '19000101')));
    SET @MaxDate  = DATEADD(DAY, -1, DATEADD(MONTH, 1, @LoopYearMonth + '01'));

    -- Hapus data existing
    DELETE FROM Report_44_UnitServed_ServiceShare
    WHERE RunningDate = @LoopYearMonth;

    -- Insert data baru
    INSERT INTO Report_44_UnitServed_ServiceShare
    SELECT
        RunningDate,
        Brand,
        InventSiteId,
        MajorGroup,
        SUM(ServiceShared_Monthly) AS ServiceShared_Monthly,
        SUM(ServiceShared_Yearly) AS ServiceShared_Yearly,
        InventSiteId_Merger,
        Stall_BIB
    FROM (
        -- Data Yearly
        SELECT
            @LoopYearMonth AS RunningDate,
            Brand,
            InventSiteId,
            MajorGroup,
            UnitServed_Qty AS ServiceShared_Yearly,
            0 AS ServiceShared_Monthly,
            CASE
                WHEN InventSiteId IN ('ASC01','ASC03') AND LEFT(@LoopYearMonth, 4) >= '2022' THEN 'ASC02'
                WHEN InventSiteId = 'AUT02' AND LEFT(@LoopYearMonth, 4) >= '2022' THEN 'AUT01'
                ELSE InventSiteId
            END AS InventSiteId_Merger,
            Stall_BIB
        FROM Report_44_UnitServed
        WHERE InvoiceDate BETWEEN @StarDate AND @MaxDate

        UNION ALL

        -- Data Monthly
        SELECT
            @LoopYearMonth AS RunningDate,
            Brand,
            InventSiteId,
            MajorGroup,
            0 AS ServiceShared_Yearly,
            UnitServed_Qty AS ServiceShared_Monthly,
            CASE
                WHEN InventSiteId IN ('ASC01','ASC03') AND LEFT(@LoopYearMonth, 4) >= '2022' THEN 'ASC02'
                WHEN InventSiteId = 'AUT02' AND LEFT(@LoopYearMonth, 4) >= '2022' THEN 'AUT01'
                ELSE InventSiteId
            END AS InventSiteId_Merger,
            Stall_BIB
        FROM Report_44_UnitServed
        WHERE LEFT(CONVERT(CHAR(8), InvoiceDate, 112), 6) = @LoopYearMonth
    ) x
    GROUP BY RunningDate, Brand, InventSiteId, MajorGroup, InventSiteId_Merger, Stall_BIB;

    -- Hapus yang sudah diproses
    DELETE FROM #TempYearMonth WHERE YearMonth = @LoopYearMonth;
END

-- Cleanup
DROP TABLE #TempYearMonth

END