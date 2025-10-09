CREATE   PROCEDURE [dbo].[SP_REPORT_25_UPDATE_PSS]
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @outlet char(5), @date date, @itemId char(10), @beginstock int;

    -- Gantikan cursor source dengan #temp yang isinya persis hasil SELECT cursor
    IF OBJECT_ID('tempdb..#Report_25_pss') IS NOT NULL
        DROP TABLE #Report_25_pss;

    SELECT DatePhysical, kode_outlet, ItemId
    INTO #Report_25_pss
    FROM (
        SELECT top 10 DatePhysical, kode_outlet, ItemId
        FROM Report_25
        WHERE Beginstock = 0
          AND Endstock   = 0
          AND kode_dealer = 'AI'
        GROUP BY kode_outlet, DatePhysical, ItemId
    ) s;

    -- === Single WHILE loop ===
    WHILE EXISTS (SELECT TOP (1) 1 FROM #Report_25_pss)
    BEGIN
        -- "FETCH NEXT" pengganti (urutannya sama seperti cursor asli)
        SELECT TOP (1)
            @date   = DatePhysical,
            @outlet = kode_outlet,
            @itemId = ItemId
        FROM #Report_25_pss
        ORDER BY kode_outlet, DatePhysical, ItemId;

        -- Ambil beginstock sebelumnya (Endstock terakhir sebelum @date)
        SELECT TOP (1) @beginstock = ISNULL(Endstock, 0)
        FROM Report_25
        WHERE kode_outlet  = @outlet
          AND DatePhysical < @date
          AND ItemId       = @itemId
          AND kode_dealer  = 'AI'
        ORDER BY DatePhysical DESC;

        -- Update baris target untuk @date
        UPDATE Report_25
        SET Beginstock = ISNULL(@beginstock, 0),
            Endstock   = ISNULL(@beginstock, 0) + wholesale + EUS + TransferIn + TransferOut + Transactions
        WHERE kode_outlet  = @outlet
          AND DatePhysical = @date
          AND ItemId       = @itemId
          AND kode_dealer  = 'AI';

        -- Hapus baris yang sudah diproses (siap ambil TOP 1 berikutnya)
        DELETE FROM #Report_25_pss
        WHERE kode_outlet  = @outlet
          AND DatePhysical = @date
          AND ItemId       = @itemId;
    END

    DROP TABLE #Report_25_pss;
END;