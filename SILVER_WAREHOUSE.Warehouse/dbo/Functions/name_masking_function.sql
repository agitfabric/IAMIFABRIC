CREATE FUNCTION dbo.name_masking_function (
    @var_name VARCHAR(100)
)
RETURNS TABLE
AS
RETURN
WITH cleaned AS (
    SELECT 
        REPLACE(REPLACE(REPLACE(REPLACE(@var_name, 'PT.', 'PT. '), 'PT,', 'PT, '), 'CV.', 'CV. '), '  ', ' ') AS cleaned_text
),
split_words AS (
    SELECT value
    FROM cleaned
    CROSS APPLY STRING_SPLIT(cleaned_text, ' ')
),
masked AS (
    SELECT 
        CASE 
            WHEN value LIKE '%PT.%' OR value LIKE '%PT,%' OR value LIKE '%PT %' OR value LIKE '%CV.%' THEN value
            WHEN LEN(value) = 3 THEN STUFF(value, LEN(value)/2+2, LEN(value) - LEN(value)/2-1, REPLICATE('*', LEN(value) - LEN(value)/2 - 1))
            WHEN LEN(value) > 3 THEN STUFF(value, LEN(value)/2+1, LEN(value) - LEN(value)/2, REPLICATE('*', LEN(value) - LEN(value)/2))
            ELSE value
        END AS MaskedWord
    FROM split_words
)
SELECT STRING_AGG(MaskedWord, ' ') AS MaskedName
FROM masked;