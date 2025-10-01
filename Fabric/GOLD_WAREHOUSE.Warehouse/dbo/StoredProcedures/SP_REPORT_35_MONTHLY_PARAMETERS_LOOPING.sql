CREATE PROCEDURE [dbo].[SP_REPORT_35_MONTHLY_PARAMETERS_LOOPING]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	WITH YearMonths AS (
	SELECT DISTINCT LEFT(CONVERT(CHAR(8), DatePhysical, 112), 6) AS YearMonth
	FROM SILVER_WAREHOUSE.dbo.InventTrans
	WHERE CAST(DatePhysical AS DATE) >= '2020-01-01'
)
SELECT * INTO #TempYearMonthReport35 FROM YearMonths;

-- Deklarasi variabel loop
DECLARE @YearMonth CHAR(6);
DECLARE @Year CHAR(4), @Month CHAR(2);

WHILE EXISTS (SELECT TOP 1 1 FROM #TempYearMonthReport35)
BEGIN
	-- Ambil bulan tertua untuk diproses
	SELECT TOP 1 @YearMonth = YearMonth FROM #TempYearMonthReport35 ORDER BY YearMonth;

	-- Pisahkan Tahun dan Bulan
	SELECT @Year = LEFT(@YearMonth, 4), @Month = RIGHT(@YearMonth, 2);

	-- Eksekusi prosedur bulanan
	EXEC SP_REPORT_35_MONTHLY_PARAMETERS @Year, @Month;

	-- Hapus row yang sudah diproses
	DELETE FROM #TempYearMonthReport35 WHERE YearMonth = @YearMonth;
END

-- Cleanup
DROP TABLE #TempYearMonthReport35;
END