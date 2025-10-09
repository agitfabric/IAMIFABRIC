-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- Exec Sp_Report_44_Daily
-- =============================================
CREATE   PROCEDURE [dbo].[Sp_Report_44_Daily]
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE 
        @YearMonth char(6),
        @Year char(4),
        @Month char(2),
        @MaxDate date;

    -- Ambil anchor MaxDate
    SELECT @MaxDate = DATEADD(DAY, -5, MAX(InvoiceDate))
    FROM Report_44_UnitServed;

    -- Siapkan daftar YearMonth (distinct) dari InventTrans
    IF OBJECT_ID('tempdb..#TempYearMonth_Report44') IS NOT NULL
        DROP TABLE #TempYearMonth_Report44;

    WITH YearMonths AS (
        SELECT DISTINCT LEFT(CONVERT(CHAR(8), DatePhysical, 112), 6) AS YearMonth
        FROM SILVER_WAREHOUSE.dbo.InventTrans
        WHERE CAST(DatePhysical AS date) BETWEEN @MaxDate AND CAST(DATEADD(HOUR, 7, GETDATE())-1 AS date)
    )
    SELECT * INTO #TempYearMonth_Report44 FROM YearMonths;

    -- Loop setiap YearMonth
    WHILE EXISTS (SELECT 1 FROM #TempYearMonth_Report44)
    BEGIN
        -- Ambil YearMonth terendah
        SELECT TOP (1) @YearMonth = YearMonth
        FROM #TempYearMonth_Report44
        ORDER BY YearMonth ASC;

        -- Split jadi Year dan Month
        SELECT 
            @Year  = LEFT(@YearMonth, 4),
            @Month = RIGHT(@YearMonth, 2);

        -- Eksekusi SP terkait
        EXEC SP_REPORT_44_UNITSERVED @Year, @Month;
        EXEC SP_REPORT_44_UNITSERVED_CLEANSING;
        EXEC SP_Report_44_Revenue @Year, @Month;

        -- Hapus YearMonth yang sudah diproses
        DELETE FROM #TempYearMonth_Report44 WHERE YearMonth = @YearMonth;
    END;

    -- Bersihkan temp table
    DROP TABLE #TempYearMonth_Report44;
END;