CREATE PROCEDURE [dbo].[SPKPIFakpol]
AS

BEGIN

DECLARE @Year int
SET @Year = YEAR(DATEADD(HOUR, 7, GETDATE()))

--OUTLET
		DELETE FROM GOLD_WAREHOUSE.dbo.KPIFakpolOutlet WHERE YEAR(Date) = @Year

		INSERT INTO GOLD_WAREHOUSE.dbo.KPIFakpolOutlet
		SELECT 
		DWDateKey Date, Site Outlet, MinorGroupId Series, SUM(Target) Target, 0, 0, 0
		FROM GOLD_WAREHOUSE.dbo.DimDate C
		JOIN GOLD_WAREHOUSE.dbo.vw_TargetPenjualan
		ON MONTH(DWDateKey) = MONTH(TargetDate)
		AND YEAR(DWDateKey) = YEAR(TargetDate)
		AND Site COLLATE Latin1_General_CI_AS NOT LIKE '%AII%' COLLATE Latin1_General_CI_AS
		WHERE YEAR(DWDateKey) = @Year
		GROUP BY DWDateKey, Site, MinorGroupId
			   
		TRUNCATE TABLE GOLD_WAREHOUSE.dbo.KPIFakpolActual
		INSERT INTO GOLD_WAREHOUSE.dbo.KPIFakpolActual
		SELECT
			CONVERT(CHAR(10), A.ApprovalDate, 126) ApprovalDate,
			KodeOutlet,
			Series  
			,COUNT(DISTINCT ChassisNumber) Actual
		FROM GOLD_WAREHOUSE.dbo.[Report_Fakpol] A 
		WHERE ApprovalDate != '1900-01-01 12:00:00.000'
		AND YEAR(ApprovalDate) = @Year
		GROUP BY
			CONVERT(CHAR(10), A.ApprovalDate, 126),
			Series,
			KodeOutlet

		UPDATE d
		SET d.Actual = a.Actual
		FROM GOLD_WAREHOUSE.dbo.KPIFakpolOutlet d
		JOIN GOLD_WAREHOUSE.dbo.KPIFakpolActual a
		ON d.Date = a.ApprovalDate
		AND d.Series COLLATE Latin1_General_CI_AS = a.Series COLLATE Latin1_General_CI_AS
		AND d.Outlet COLLATE Latin1_General_CI_AS = a.KodeOutlet COLLATE Latin1_General_CI_AS
		  
		UPDATE GOLD_WAREHOUSE.dbo.KPIFakpolOutlet SET Achievement = CONVERT(FLOAT,Actual)/CONVERT(FLOAT,Target) WHERE Target > 0 AND YEAR(Date) = @Year
		UPDATE GOLD_WAREHOUSE.dbo.KPIFakpolOutlet SET Point = 15 WHERE Achievement >= 1 AND YEAR(Date) = @Year
		UPDATE GOLD_WAREHOUSE.dbo.KPIFakpolOutlet SET Point = 12 WHERE Achievement <= 0.99 AND YEAR(Date) = @Year
		UPDATE GOLD_WAREHOUSE.dbo.KPIFakpolOutlet SET Point = 9 WHERE Achievement <= 0.84 AND YEAR(Date) = @Year
		UPDATE GOLD_WAREHOUSE.dbo.KPIFakpolOutlet SET Point = 6 WHERE Achievement <= 0.69 AND YEAR(Date) = @Year
 

--DEALER
  
		DELETE GOLD_WAREHOUSE.dbo.KPIFakpolDealer WHERE YEAR(Date) = @Year

		INSERT INTO GOLD_WAREHOUSE.dbo.KPIFakpolDealer
		SELECT Date, 
			SUBSTRING(Outlet, 1, 3) Dealer, 
			Series, 
			0,
			SUM(Actual) Actual 
			,0 Achievement
			,0 Point
		FROM GOLD_WAREHOUSE.dbo.[KPIFakpolOutlet]
		WHERE YEAR(Date) = @Year
		GROUP BY Date, Series, SUBSTRING(Outlet, 1, 3)
		HAVING SUBSTRING(Outlet, 1, 3) COLLATE Latin1_General_CI_AS NOT IN ('bah','sas','jol','per')

		INSERT INTO GOLD_WAREHOUSE.dbo.KPIFakpolDealer
		SELECT Date, 
			SUBSTRING(Outlet, 1, 3) Dealer, 
			CASE WHEN Series COLLATE Latin1_General_CI_AS = 'GIGA' COLLATE Latin1_General_CI_AS THEN 'ELF' ELSE Series END AS Series,
			0,
			SUM(Actual) Actual 
			,0 Achievement
			,0 Point
		FROM GOLD_WAREHOUSE.dbo.[KPIFakpolOutlet]
		WHERE YEAR(Date) = @Year 
		GROUP BY Date, CASE WHEN Series COLLATE Latin1_General_CI_AS = 'GIGA' COLLATE Latin1_General_CI_AS THEN 'ELF' ELSE Series END, SUBSTRING(Outlet, 1, 3)
		HAVING SUBSTRING(Outlet, 1, 3) COLLATE Latin1_General_CI_AS IN ('bah','sas','jol','per')

		TRUNCATE TABLE GOLD_WAREHOUSE.dbo.KPIFakpolTarget2
		INSERT INTO GOLD_WAREHOUSE.dbo.KPIFakpolTarget2
		SELECT DISTINCT YEAR(Date) Tahun, 
			MONTH(Date) Bulan, 
			Outlet,
			Series, 
			Target
		FROM GOLD_WAREHOUSE.dbo.[KPIFakpolOutlet]
		WHERE YEAR(Date) = @Year

		--Dealer GIGA
		TRUNCATE TABLE KPIFakpolTarget
		INSERT INTO KPIFakpolTarget
		SELECT Tahun, Bulan, 
			SUBSTRING(Outlet, 1, 3) Dealer, 
			Series, 
			SUM(Target) Target 
		FROM GOLD_WAREHOUSE.dbo.KPIFakpolTarget2
		GROUP BY Tahun, Bulan, Series, SUBSTRING(Outlet, 1, 3)
		HAVING SUBSTRING(Outlet, 1, 3) COLLATE Latin1_General_CI_AS NOT IN ('bah','sas','jol','per')

		--Dealer NON GIGA
		INSERT INTO KPIFakpolTarget
		SELECT Tahun, Bulan, 
			SUBSTRING(Outlet, 1, 3) Dealer, 
			CASE WHEN Series COLLATE Latin1_General_CI_AS = 'GIGA' COLLATE Latin1_General_CI_AS THEN 'ELF' ELSE Series END AS Series,
			SUM(Target) Target 
		FROM GOLD_WAREHOUSE.dbo.KPIFakpolTarget2
		GROUP BY Tahun, Bulan, CASE WHEN Series COLLATE Latin1_General_CI_AS = 'GIGA' COLLATE Latin1_General_CI_AS THEN 'ELF' ELSE Series END, SUBSTRING(Outlet, 1, 3)
		HAVING SUBSTRING(Outlet, 1, 3) COLLATE Latin1_General_CI_AS IN ('bah','sas','jol','per')

		UPDATE d
		SET d.Target = t.Target
		FROM GOLD_WAREHOUSE.dbo.KPIFakpolDealer d
		JOIN GOLD_WAREHOUSE.dbo.KPIFakpolTarget t
		ON YEAR(d.Date) = t.Tahun 
		AND MONTH(d.Date) = t.Bulan
		AND d.Series COLLATE Latin1_General_CI_AS = t.Series COLLATE Latin1_General_CI_AS
		AND d.Dealer COLLATE Latin1_General_CI_AS = t.Dealer COLLATE Latin1_General_CI_AS

		--Dealer GIGA
		UPDATE GOLD_WAREHOUSE.dbo.KPIFakpolDealer SET Achievement = CONVERT(FLOAT,Actual)/CONVERT(FLOAT,Target) WHERE Target > 0 AND YEAR(Date) = @Year
		UPDATE GOLD_WAREHOUSE.dbo.KPIFakpolDealer SET Point = 10 WHERE Achievement >= 1 AND YEAR(Date) = @Year
		UPDATE GOLD_WAREHOUSE.dbo.KPIFakpolDealer SET Point = 8 WHERE Achievement <= 0.99 AND YEAR(Date) = @Year
		UPDATE GOLD_WAREHOUSE.dbo.KPIFakpolDealer SET Point = 6 WHERE Achievement <= 0.84 AND YEAR(Date) = @Year
		UPDATE GOLD_WAREHOUSE.dbo.KPIFakpolDealer SET Point = 3 WHERE Achievement <= 0.69 AND YEAR(Date) = @Year

		--Dealer NON GIGA
		UPDATE GOLD_WAREHOUSE.dbo.KPIFakpolDealer SET Achievement = CONVERT(FLOAT,Actual)/CONVERT(FLOAT,Target) WHERE Target > 0 AND Dealer COLLATE Latin1_General_CI_AS IN ('bah','sas','jol','per') AND YEAR(Date) = @Year
		UPDATE GOLD_WAREHOUSE.dbo.KPIFakpolDealer SET Point = 15 WHERE Achievement >= 1 AND Dealer COLLATE Latin1_General_CI_AS IN ('BAH','SAS','JOL','PER') AND YEAR(Date) = @Year
		UPDATE GOLD_WAREHOUSE.dbo.KPIFakpolDealer SET Point = 12 WHERE Achievement <= 0.99 AND Dealer COLLATE Latin1_General_CI_AS IN ('bah','sas','jol','per') AND YEAR(Date) = @Year
		UPDATE GOLD_WAREHOUSE.dbo.KPIFakpolDealer SET Point = 9 WHERE Achievement <= 0.84 AND Dealer COLLATE Latin1_General_CI_AS IN ('bah','sas','jol','per') AND YEAR(Date) = @Year
		UPDATE GOLD_WAREHOUSE.dbo.KPIFakpolDealer SET Point = 6 WHERE Achievement <= 0.69 AND Dealer COLLATE Latin1_General_CI_AS IN ('bah','sas','jol','per') AND YEAR(Date) = @Year

END