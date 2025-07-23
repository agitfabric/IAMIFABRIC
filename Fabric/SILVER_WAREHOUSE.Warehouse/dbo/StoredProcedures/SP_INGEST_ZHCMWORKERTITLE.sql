CREATE PROCEDURE SP_INGEST_ZHCMWORKERTITLE
AS
BEGIN
    -- Update existing records
    UPDATE T
SET
    T.AgitTitleLevel               = S.AgitTitleLevel,
    T.AnniversaryDateTime          = S.AnniversaryDateTime,
    T.CreatedDateTime              = S.CreatedDateTime,
    T.Location                     = S.Location,
    T.ModifiedDateTime             = S.ModifiedDateTime,
    T.OfficeLocation               = S.OfficeLocation,
    T.OriginalHireDateTime         = S.OriginalHireDateTime,
    T.RecId                        = S.RecId,
    T.SeniorityDate                = S.SeniorityDate,
    T.SeniorityDateInUserTimeZona = S.SeniorityDateInUserTimeZona,
    T.Title                        = S.Title,
    T.ValidFrom                    = S.ValidFrom,
    T.ValidTo                      = S.ValidTo,
    T.Worker                       = S.Worker,
    T.WorksFromHome                = S.WorksFromHome
FROM ZHcmWorkerTitle AS T
JOIN (
    SELECT DISTINCT *
    FROM bronze_lakehouse.dbo.temp_ZHcmWorkerTitle
) AS S ON S.RecId = T.RecId;




    -- Insert new records
    INSERT INTO ZHcmWorkerTitle (
    AgitTitleLevel,
    AnniversaryDateTime,
    CreatedDateTime,
    Location,
    ModifiedDateTime,
    OfficeLocation,
    OriginalHireDateTime,
    RecId,
    SeniorityDate,
    SeniorityDateInUserTimeZona,
    Title,
    ValidFrom,
    ValidTo,
    Worker,
    WorksFromHome
)
SELECT 
    S.AgitTitleLevel,
    S.AnniversaryDateTime,
    S.CreatedDateTime,
    S.Location,
    S.ModifiedDateTime,
    S.OfficeLocation,
    S.OriginalHireDateTime,
    S.RecId,
    S.SeniorityDate,
    S.SeniorityDateInUserTimeZona,
    S.Title,
    S.ValidFrom,
    S.ValidTo,
    S.Worker,
    S.WorksFromHome
FROM (
    SELECT DISTINCT *
    FROM bronze_lakehouse.dbo.temp_ZHcmWorkerTitle
) AS S
LEFT JOIN ZHcmWorkerTitle AS T ON S.RecId = T.RecId
WHERE T.RecId IS NULL;

END;

--select * into SILVER_WAREHOUSE.dbo.ZHcmWorkerTitle from bronze_lakehouse.dbo.ZHcmWorkerTitle