CREATE PROCEDURE SP_INGEST_ZINVENTSITES
AS
BEGIN
    -- Update existing records
    UPDATE T
SET 
    T.AMDeviceAccessoryInventLocation           = S.AMDeviceAccessoryInventLocation,
    T.AreaCode                                  = S.AreaCode,
    T.dataAreaId                                = S.dataAreaId,
    T.DefaultInventStatusId                     = S.DefaultInventStatusId,
    T.IsReceivingWarehouseOverrideAllowed       = S.IsReceivingWarehouseOverrideAllowed,
    T.ModifiedDateTime1                         = S.ModifiedDateTime1,
    T.Name                                      = S.Name,
    T.OrderEntryDeadlineGroupId                 = S.OrderEntryDeadlineGroupId,
    T.RecordId                                  = S.RecordId,
    T.SiteId                                    = S.SiteId,
    T.TaxBranchRefRecId                         = S.TaxBranchRefRecId,
    T.Timezone                                  = S.Timezone,
    T.Z1S                                       = S.Z1S,
    T.Z3S                                       = S.Z3S,
    T.ZDealerAfterSales                         = S.ZDealerAfterSales,
    T.ZDealerSales                              = S.ZDealerSales,
    T.ZDeletionFlag                             = S.ZDeletionFlag,
    T.ZIAMIArea                                 = S.ZIAMIArea,
    T.ZIAMIAreas                                = S.ZIAMIAreas,
    T.ZNPWP                                     = S.ZNPWP,
    T.ZNPWPAfterSales                           = S.ZNPWPAfterSales,
    T.ZProvinsi                                 = S.ZProvinsi,
    T.ZTelp                                     = S.ZTelp,
    T.Last_update                               = GETDATE()
FROM ZInventSites AS T
JOIN (
    SELECT DISTINCT *
    FROM bronze_lakehouse.dbo.temp_ZInventSites
) AS S ON S.SiteId = T.SiteId;



    -- Insert new records
    INSERT INTO ZInventSites (
    AMDeviceAccessoryInventLocation,
    AreaCode,
    dataAreaId,
    DefaultInventStatusId,
    IsReceivingWarehouseOverrideAllowed,
    ModifiedDateTime1,
    Name,
    OrderEntryDeadlineGroupId,
    RecordId,
    SiteId,
    TaxBranchRefRecId,
    Timezone,
    Z1S,
    Z3S,
    ZDealerAfterSales,
    ZDealerSales,
    ZDeletionFlag,
    ZIAMIArea,
    ZIAMIAreas,
    ZNPWP,
    ZNPWPAfterSales,
    ZProvinsi,
    ZTelp,
    Last_update
)
SELECT 
    S.AMDeviceAccessoryInventLocation,
    S.AreaCode,
    S.dataAreaId,
    S.DefaultInventStatusId,
    S.IsReceivingWarehouseOverrideAllowed,
    S.ModifiedDateTime1,
    S.Name,
    S.OrderEntryDeadlineGroupId,
    S.RecordId,
    S.SiteId,
    S.TaxBranchRefRecId,
    S.Timezone,
    S.Z1S,
    S.Z3S,
    S.ZDealerAfterSales,
    S.ZDealerSales,
    S.ZDeletionFlag,
    S.ZIAMIArea,
    S.ZIAMIAreas,
    S.ZNPWP,
    S.ZNPWPAfterSales,
    S.ZProvinsi,
    S.ZTelp,
    GETDATE()
FROM (
    SELECT DISTINCT *
    FROM bronze_lakehouse.dbo.temp_ZInventSites
) AS S
LEFT JOIN ZInventSites AS T ON S.SiteId = T.SiteId
WHERE T.SiteId IS NULL;
Exec SP_CleansingInventSite;
END;

--select * into SILVER_WAREHOUSE.dbo.ZInventSites from bronze_lakehouse.dbo.ZInventSites