CREATE FUNCTION [dbo].[name_masking_function_sql_server](
    @var_name VARCHAR(100)
) RETURNS VARCHAR(100)
AS
BEGIN
    DECLARE @new_name VARCHAR(100); 
    SET @var_name = REPLACE(@var_name,'PT.','PT. ')
    SET @var_name = REPLACE(@var_name,'PT,','PT, ')
    SET @var_name = REPLACE(@var_name,'CV.','CV. ')
    SET @var_name = REPLACE(@var_name,'  ',' ')
    
    SELECT @new_name =
        COALESCE(@new_name + ' ', '')  + 
        CASE 
            WHEN value LIKE '%PT.%' OR value LIKE '%PT,%' OR value LIKE '%PT %' OR value LIKE '%CV.%' THEN value
            WHEN LEN(value) = 3 THEN STUFF(value, LEN(value)/2+2, LEN(value) - LEN(value)/2-1, REPLICATE('*', LEN(value) - LEN(value)/2 - 1))
            WHEN LEN(value) > 3 THEN STUFF(value, LEN(value)/2+1, LEN(value) - LEN(value)/2, REPLICATE('*', LEN(value) - LEN(value)/2))
            ELSE value
        END
    FROM STRING_SPLIT(@var_name, ' ')    

    RETURN @new_name;  
END;