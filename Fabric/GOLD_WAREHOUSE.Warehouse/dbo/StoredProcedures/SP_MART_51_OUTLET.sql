CREATE       PROCEDURE [dbo].[SP_MART_51_OUTLET]
AS
BEGIN
    SET NOCOUNT ON;

DECLARE @running_date varchar(6);


    SELECT * INTO #mart_51_outlet FROM (
    SELECT DISTINCT LEFT(CONVERT(char(8), a.CalendarDate, 112), 6) AS RunningDate
    FROM Calendar a
    WHERE CAST(a.CalendarDate AS date) >
          (
            SELECT ISNULL(CAST(MAX(runningdate) + '01' AS date), '2021-12-31')
            FROM mart_51_outlet
            WHERE LEFT(OutletCode, 3) != 'AII'
          )
      AND CAST(a.CalendarDate AS date) < CAST(GETDATE() AS date)
      AND DAY(a.CalendarDate) = 1) A



    -- == Single WHILE loop (pengganti OPEN/FETCH/WHILE/CLOSE cursor) ==
    WHILE EXISTS (SELECT TOP (1) 1 FROM #mart_51_outlet)
    BEGIN
        -- FETCH NEXT (manual): ambil RunningDate paling awal
        SELECT TOP (1) @running_date = RunningDate
        FROM #mart_51_outlet
        ORDER BY RunningDate ASC;

        
    Begin
            Delete mart_51_outlet where runningdate = @running_date and left(OutletCode,3) != 'AII'
            Insert into mart_51_outlet
            Select  x.DealerName, x.City, x.ZIAMIArea, 1 as jumlah_outlet, '202201', @running_date,
                    x.Area, x.SiteCode
            From
            (
                select b.DealerName, b.City, b.Area, 1 as jumlah_outlet, b.ZIAMIArea, ValidFrom, ValidTo, a.SiteCode
                from SILVER_WAREHOUSE.dbo.site_mappingMergerOutletSIS a
                inner join vw_zInventSite b on LOWER(b.OutletCode) = LOWER(a.SiteCode) and b.DealerCategory != 'AI' and b.SiteCategory = '3S'
                where cast(@running_date+'01' as date) between cast(ValidFrom as date) and cast(ValidTo as date)
        )x
            Group by x.DealerName, x.City, x.Area, x.ZIAMIArea, x.SiteCode		
        End
    -- Hapus baris yang baru diproses (pengganti DEALLOCATE satu per satu)
        DELETE FROM #mart_51_outlet
        WHERE RunningDate = @running_date;
    END

    DROP TABLE #mart_51_outlet;

END