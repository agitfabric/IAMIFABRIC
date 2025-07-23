-- Auto Generated (Do not modify) 16DD44B05F555AA26F13DC8234322E61CCC1D7C8B1CC5719C8650BAC0DA0A1DD
CREATE VIEW [dbo].[vw_zInventSite] AS (SELECT        'NON-AI' AS DealerCategory, UPPER(dataAreaId) DealerCode, a.ZDealerAfterSales DealerName, SiteId OutletCode, a.Name OutletName, AreaCode + ' - ' + ZIAMIArea Area, Group_Dealer, d .Description City, ZIAMIArea, 
                         CASE WHEN dataAreaId IN ('SAS', 'DWI', 'BUA') THEN '<5' ELSE '>5' END AS DealerRetentionPoint, CASE WHEN SiteId IN ('PRI01', 'ARM01', 'ARM04', 'SAS01', 'SAS02', 'DWI01', 'DWI02', 'JOL01', 
                         'JOL03', 'BUA01', 'BUA02', 'BUA03', 'BUA04', 'BUA05', 'BUA06', 'BUA07', 'JUJ01', 'JUJ02', 'KAR02', 'BOR06', 'BOR07', 'BOR08', 'BOR10', 'BOR11') THEN '<5' ELSE '>5' END AS OutletRetentionPoint
FROM            SILVER_WAREHOUSE.dbo.ZInventSites a LEFT JOIN
                         SILVER_WAREHOUSE.dbo.SiteLogisticLocation b ON b.Site = a.RecordId AND b.IsPrimary = 'Yes' LEFT JOIN
                         SILVER_WAREHOUSE.dbo.ZLogisticsEntityPostalAddress c ON c.Location = b.Location AND GETDATE() BETWEEN ValidFrom AND ValidTo LEFT JOIN
                         SILVER_WAREHOUSE.dbo.AddressCity d ON d.Name = c.City
WHERE        lower(a.dataAreaId) != 'kzu'
UNION ALL
SELECT        'AI' AS DealerCategory, Dealer AS DealerCode, DealerName, SiteCode OutletCode, SiteName OutletName, Area, GroupDealer, City, 
                          case  when Area  = 'R1 - JKT' then 'JKT'
                                        when Area  = 'R2 - Jabar' then 'Jabar'
                                        when Area  = 'R3 - Jateng' then 'Jateng'
                                        when Area  = 'R4 - Jatim' then 'Jatim'
                                        when Area  = 'R5 - Kalimantan' then 'Kalimantan'
                                        when Area  = 'R6 - Sumbagut' then 'Sumbagut'
                                        when Area  = 'R7 - Sumbagsel' then 'Sumbagsel'
                                        when Area  = 'R8 - Sul_IBT' then 'Sul_IBT'
                                        when Area  = 'R9 - JKT' then 'JKT'
                                        when Area  = 'R10 - Jatim' then 'Jatim'
                                        when Area  = 'R98 - GSO' then 'JKT'
                                        when Area  = 'R99 - Fleet' then 'JKT'
                                end as ZIAMIArea, 
                          '' AS DealerRetentionPoint, '' AS OutletRetentionPoint
FROM            ZAISITES)