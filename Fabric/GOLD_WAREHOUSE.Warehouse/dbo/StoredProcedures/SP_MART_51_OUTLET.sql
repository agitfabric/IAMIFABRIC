CREATE PROCEDURE [dbo].[SP_MART_51_OUTLET]
AS
BEGIN
    -- Get the latest runningdate in the destination table, or default to '202112'
    DECLARE @max_running_date VARCHAR(6)
    SELECT @max_running_date = ISNULL(MAX(runningdate), '202112') FROM iami_pss.dbo.mart_51_outlet

    -- Insert new records for months greater than the latest runningdate
    INSERT INTO iami_pss.dbo.mart_51_outlet (
        DealerName, City, ZIAMIArea, jumlah_outlet, [FixedPeriod], runningdate, Area, SiteCode
    )
    SELECT
        x.DealerName,
        x.City,
        x.ZIAMIArea,
        1 AS jumlah_outlet,
        '202201' AS FixedPeriod,
        x.RunningDate,
        x.Area,
        x.SiteCode
    FROM (
        SELECT 
            b.DealerName,
            b.City,
            b.ZIAMIArea,
            b.Area,
            a.SiteCode,
            LEFT(CONVERT(VARCHAR, cal.CalendarDate, 112), 6) AS RunningDate
        FROM 
            iami_prod.dbo.Calendar cal
        CROSS JOIN 
            PSS_PROD.dbo.site_mappingMergerOutletSIS a
        INNER JOIN 
            iami_pss.dbo.vw_zInventSite b 
            ON b.OutletCode = a.SiteCode 
            AND b.DealerCategory = 'AI' 
            AND b.SiteCategory = '3S'
        WHERE 
            cal.Day = 1
            AND cal.CalendarDate > CAST(@max_running_date + '01' AS DATE)
            AND cal.CalendarDate < CAST(GETDATE() AS DATE)
            AND CAST(cal.CalendarDate AS DATE) BETWEEN CAST(ValidFrom AS DATE) AND CAST(ValidTo AS DATE)
    ) x
    GROUP BY 
        x.DealerName, x.City, x.Area, x.ZIAMIArea, x.SiteCode, x.RunningDate
END