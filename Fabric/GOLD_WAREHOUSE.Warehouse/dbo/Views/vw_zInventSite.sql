-- Auto Generated (Do not modify) 60CB0CCD142588AC4D98B8BAB84184010A5EA3CB87773F1BA88F51812E57B61C
CREATE   VIEW [dbo].[vw_zInventSite] AS
SELECT 
    'NON-AI' AS DealerCategory, 
    UPPER(a.dataAreaId) AS DealerCode, 
    e.Description AS DealerName, 
    a.SiteId AS OutletCode, 
    a.Name AS OutletName, 
    a.AreaCode + ' - ' + a.ZIAMIArea AS Area, 
    a.Group_Dealer, 
    d.Description AS City, 
    a.ZIAMIArea, 
    CASE 
        WHEN a.dataAreaId IN ('SAS', 'DWI', 'BUA') THEN '<5' 
        ELSE '>5' 
    END AS DealerRetentionPoint, 
    CASE 
        WHEN a.SiteId IN ('PRI01', 'ARM01', 'ARM04', 'SAS01', 'SAS02', 'DWI01', 'DWI02', 'JOL01', 
                          'JOL03', 'BUA01', 'BUA02', 'BUA03', 'BUA04', 'BUA05', 'BUA06', 'BUA07', 
                          'JUJ01', 'JUJ02', 'KAR02', 'BOR06', 'BOR07', 'BOR08', 'BOR10', 'BOR11') 
        THEN '<5' 
        ELSE '>5' 
    END AS OutletRetentionPoint, 
    a.SiteCategory
FROM SILVER_WAREHOUSE.dbo.ZInventSites a 
LEFT JOIN SILVER_WAREHOUSE.dbo.SiteLogisticLocation b 
    ON LOWER(b.Site) = LOWER(a.RecordId) 
   AND LOWER(b.IsPrimary) = LOWER('Yes')
LEFT JOIN SILVER_WAREHOUSE.dbo.ZLogisticsEntityPostalAddress c 
    ON LOWER(c.Location) = LOWER(b.Location) 
   AND GETDATE() BETWEEN c.ValidFrom AND c.ValidTo
LEFT JOIN SILVER_WAREHOUSE.dbo.AddressCity d 
    ON LOWER(d.Name) = LOWER(c.City)
LEFT JOIN SILVER_WAREHOUSE.dbo.Ledger e 
    ON LOWER(e.ChartOfAccounts) = LOWER(a.dataAreaId)
WHERE LOWER(a.dataAreaId) != 'kzu'

UNION ALL

SELECT 
    'AI' AS DealerCategory, 
    Dealer AS DealerCode, 
    DealerName, 
    SiteCode AS OutletCode, 
    SiteName AS OutletName, 
    Area, 
    GroupDealer, 
    City, 
    CASE  
        WHEN Area = 'R1 - JKT' THEN 'JKT'
        WHEN Area = 'R2 - Jabar' THEN 'Jabar'
        WHEN Area = 'R3 - Jateng' THEN 'Jateng'
        WHEN Area = 'R4 - Jatim' THEN 'Jatim'
        WHEN Area = 'R5 - Kalimantan' THEN 'Kalimantan'
        WHEN Area = 'R6 - Sumbagut' THEN 'Sumbagut'
        WHEN Area = 'R7 - Sumbagsel' THEN 'Sumbagsel'
        WHEN Area = 'R8 - Sul_IBT' THEN 'Sul_IBT'
        WHEN Area = 'R9 - JKT' THEN 'JKT'
        WHEN Area = 'R10 - Jatim' THEN 'Jatim'
        WHEN Area = 'R98 - GSO' THEN 'JKT'
        WHEN Area = 'R99 - Fleet' THEN 'JKT'
    END AS ZIAMIArea, 
    '' AS DealerRetentionPoint, 
    '' AS OutletRetentionPoint, 
    SiteCategory
FROM SILVER_WAREHOUSE.dbo.ZAISITES;