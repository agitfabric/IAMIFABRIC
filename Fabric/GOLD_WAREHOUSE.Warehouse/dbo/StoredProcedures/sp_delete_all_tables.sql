CREATE PROCEDURE sp_delete_all_tables
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @sql NVARCHAR(MAX) = N'';

    
    SELECT @sql += 'DELETE FROM [' + s.name + '].[' + t.name + '];' + CHAR(13)
    FROM sys.tables t
    JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE s.name = 'dbo';  

    
    EXEC sp_executesql @sql;
END;