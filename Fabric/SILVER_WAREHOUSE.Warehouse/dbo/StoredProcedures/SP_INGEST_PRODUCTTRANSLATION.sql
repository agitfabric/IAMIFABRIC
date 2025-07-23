CREATE PROCEDURE SP_INGEST_PRODUCTTRANSLATION
AS
BEGIN
    -- Update existing records
    UPDATE target
    SET
        target.Description = source.Description,
        target.Product = source.Product,
        target.ProductName = source.ProductName,
        target.ProductNumber = source.ProductNumber,
        target.RecordId = source.RecordId,
        target.Last_update = source.Last_Update,
        target.LanguageId = source.LanguageId
    FROM ProductTranslation AS target
    JOIN (
        SELECT DISTINCT *
        FROM BRONZE_LAKEHOUSE.dbo.temp_ProductTranslation
    ) AS source
    ON source.Product = target.Product
       AND source.ProductNumber = target.ProductNumber;

    -- Insert new records
    INSERT INTO ProductTranslation (
        Description,
        Product,
        ProductName,
        ProductNumber,
        RecordId,
        Last_update,
        LanguageId
    )
    SELECT
        source.Description,
        source.Product,
        source.ProductName,
        source.ProductNumber,
        source.RecordId,
        source.Last_Update,
        source.LanguageId
    FROM (
        SELECT DISTINCT *
        FROM BRONZE_LAKEHOUSE.dbo.temp_ProductTranslation
    ) AS source
    LEFT JOIN ProductTranslation AS target
        ON source.Product = target.Product
       AND source.ProductNumber = target.ProductNumber
    WHERE target.Product IS NULL;
END;

--select * into SILVER_WAREHOUSE.dbo.ProductTranslation from BRONZE_LAKEHOUSE.dbo.ProductTranslation