CREATE   PROCEDURE [dbo].[SP_REPORT_28_PSS]
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE 
        @GetMaxRunningDate date,
        @GetCurrentDate    date,
        @CalendarDate      date,
        @ItemNo            char(25),
        @countdata         int;

    -- Anchor tanggal (mengikuti SP asli)
    SELECT 
        @GetMaxRunningDate = ISNULL(MAX(CAST(Tanggal AS date)), '2022-01-01'),
        @GetCurrentDate    = CAST(DATEADD(day, -1, GETDATE()) AS date)   -- cast(getdate()-1 as date)
    FROM Report_28
    WHERE Source = 'Report_25_PSS';

    ------------------------------------------------------------
    -- 1) Siapkan daftar tanggal (CalendarDate) ke #temp
    ------------------------------------------------------------
    IF OBJECT_ID('tempdb..#TempCalendar_SP_REPORT_28_PSS') IS NOT NULL
        DROP TABLE #TempCalendar_SP_REPORT_28_PSS;

    WITH Cal AS (
        SELECT CalendarDate
        FROM SILVER_WAREHOUSE.dbo.Calendar
        WHERE CalendarDate BETWEEN @GetMaxRunningDate AND @GetCurrentDate
    )
    SELECT * INTO #TempCalendar_SP_REPORT_28_PSS FROM Cal;

    ------------------------------------------------------------
    -- 2) Loop per CalendarDate
    ------------------------------------------------------------
    WHILE EXISTS (SELECT TOP (1) 1 FROM #TempCalendar_SP_REPORT_28_PSS)
    BEGIN
        SELECT TOP (1) @CalendarDate = CalendarDate
        FROM #TempCalendar_SP_REPORT_28_PSS
        ORDER BY CalendarDate ASC;

        -- Replace data Report_28 utk tanggal ini (sumber Report_25_PSS)
        DELETE FROM Report_28 
        WHERE CAST(Tanggal AS date) = @CalendarDate
          AND Source = 'Report_25_PSS';

        --------------------------------------------------------
        -- 2a) Siapkan daftar Item sebagai #temp, seperti cursor kedua
        --------------------------------------------------------
        IF OBJECT_ID('tempdb..#TempItemNo_SP_REPORT_28_PSS') IS NOT NULL
            DROP TABLE #TempItemNo_SP_REPORT_28_PSS;

        WITH Items AS (
            SELECT data_itemUnitNo
            FROM (
                SELECT data_itemUnitNo FROM SILVER_WAREHOUSE.dbo.sales_InvoicePOUnit
                UNION ALL
                SELECT data_itemUnitNo FROM SILVER_WAREHOUSE.dbo.sales_invoiceSO
            ) x
            LEFT JOIN SILVER_WAREHOUSE.dbo.ZInventTables y 
                 ON y.ItemId = x.data_itemUnitNo 
                AND y.dataAreaId = 'ZIR'
            WHERE x.data_itemUnitNo IS NOT NULL
              AND y.AMItemMajorGroupId = 'CV'
            GROUP BY data_itemUnitNo
        )
        SELECT * INTO #TempItemNo_SP_REPORT_28_PSS FROM Items;

        --------------------------------------------------------
        -- 2b) Loop per ItemNo
        --------------------------------------------------------
        WHILE EXISTS (SELECT TOP (1) 1 FROM #TempItemNo_SP_REPORT_28_PSS)
        BEGIN
            SELECT TOP (1) @ItemNo = data_itemUnitNo
            FROM #TempItemNo_SP_REPORT_28_PSS
            ORDER BY data_itemUnitNo ASC;

            -- Hitung @countdata sesuai SP asli
            SELECT @countdata = COUNT(*)
            FROM Report_25
            WHERE CAST(DatePhysical AS date) = @CalendarDate
              AND ItemId = @ItemNo
              AND kode_dealer = 'AI';

            -- Insert aggr dari Report_25 utk tanggal & item ini
            INSERT INTO Report_28
            SELECT 
                @CalendarDate AS Tanggal,
                [CV/LCV],
                Series,
                ItemId,
                0 AS Dealer,
                SUM(Endstock) AS AI,
                0 AS IAMI,
                Type_Description,
                'Report_25_PSS' AS source,
                CASE WHEN @countdata > 0 THEN SUM(wholesale)  ELSE 0 END AS wholesale,
                CASE WHEN @countdata > 0 THEN SUM(EUS)        ELSE 0 END AS EUS,
                CASE WHEN @countdata > 0 THEN SUM(TransferIn) ELSE 0 END AS TransferIn,
                CASE WHEN @countdata > 0 THEN SUM(TransferOut)ELSE 0 END AS TransferOut,
                CASE WHEN @countdata > 0 THEN SUM(Transactions)ELSE 0 END AS Transactions,
                CASE WHEN @countdata > 0 THEN SUM(Beginstock) ELSE SUM(Endstock) END AS Beginstock
            FROM Report_25
            WHERE CAST(DatePhysical AS date) <= @CalendarDate
              AND kode_dealer = 'AI'
              AND ItemId = @ItemNo
            GROUP BY [CV/LCV], Series, ItemId, Type_Description;

            -- Item ini selesai
            DELETE FROM #TempItemNo_SP_REPORT_28_PSS 
            WHERE data_itemUnitNo = @ItemNo;
        END

        -- Beres loop item: bersihkan temp item
        DROP TABLE #TempItemNo_SP_REPORT_28_PSS;

        -- Tanggal ini selesai
        DELETE FROM #TempCalendar_SP_REPORT_28_PSS 
        WHERE CalendarDate = @CalendarDate;
    END

    -- Beres loop tanggal: bersihkan temp calendar
    DROP TABLE #TempCalendar_SP_REPORT_28_PSS;
END;