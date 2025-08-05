CREATE PROCEDURE [dbo].[SPKPIFakpol]
AS

BEGIN

DECLARE @Year int
SET @Year = YEAR(GETDATE())

--OUTLET
		DELETE FROM GOLD_WAREHOUSE.dbo.KPIFakpolOutlet WHERE YEAR(Date) = @Year

		insert into GOLD_WAREHOUSE.dbo.KPIFakpolOutlet
		select 
		DWDateKey Date, Site Outlet, MinorGroupId Series, sum(Target) Target, 0, 0, 0
		from  GOLD_WAREHOUSE.dbo.DimDate C
		JOIN GOLD_WAREHOUSE.dbo.vw_TargetPenjualan
		ON MONTH(DWDateKey) = month(TargetDate)
		AND YEAR(DWDateKey) = year(TargetDate)
		and Site not like '%AII%'
		WHERE YEAR(DWDateKey) = @Year
		group by DWDateKey, Site, MinorGroupId
			   
		  truncate table GOLD_WAREHOUSE.dbo.KPIFakpolActual
		  insert into GOLD_WAREHOUSE.dbo.KPIFakpolActual
		  SELECT
			  CONVERT(char(10), A.ApprovalDate, 126) ApprovalDate,
			  KodeOutlet,
			  Series  
			  ,COUNT(distinct ChassisNumber) Actual
		  FROM GOLD_WAREHOUSE.dbo.[Report_Fakpol] A 
		  WHERE ApprovalDate != '1900-01-01 12:00:00.000'
		  and year(ApprovalDate) = @Year
		  GROUP BY
			  CONVERT(char(10), A.ApprovalDate, 126),
			  Series,
			  KodeOutlet

		  update d
		  set d.Actual=a.Actual
		  from GOLD_WAREHOUSE.dbo.KPIFakpolOutlet d
		  join GOLD_WAREHOUSE.dbo.KPIFakpolActual a
		  on d.Date = a.ApprovalDate
		  and d.Series = a.Series
		  and d.Outlet = a.KodeOutlet
		  
		  update GOLD_WAREHOUSE.dbo.KPIFakpolOutlet set Achievement=convert(float,Actual)/convert(float,Target) where Target > 0 AND YEAR(Date) = @Year
		  update GOLD_WAREHOUSE.dbo.KPIFakpolOutlet set Point=15 where Achievement >= 1 AND YEAR(Date) = @Year
		  update GOLD_WAREHOUSE.dbo.KPIFakpolOutlet set Point=12 where Achievement <= 0.99 AND YEAR(Date) = @Year
		  update GOLD_WAREHOUSE.dbo.KPIFakpolOutlet set Point=9 where Achievement <= 0.84 AND YEAR(Date) = @Year
		  update GOLD_WAREHOUSE.dbo.KPIFakpolOutlet set Point=6 where Achievement <= 0.69 AND YEAR(Date) = @Year
 

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
			  HAVING SUBSTRING(Outlet, 1, 3) not in ('bah','sas','jol','per')

			  
			  INSERT INTO GOLD_WAREHOUSE.dbo.KPIFakpolDealer
			  SELECT Date, 
					SUBSTRING(Outlet, 1, 3) Dealer, 
					CASE WHEN Series = 'GIGA' THEN 'ELF' ELSE Series END AS Series,
					0,
					SUM(Actual) Actual 
  					,0 Achievement
					,0 Point
			  FROM GOLD_WAREHOUSE.dbo.[KPIFakpolOutlet]
			  WHERE YEAR(Date) = @Year 
			  GROUP BY Date, CASE WHEN Series = 'GIGA' THEN 'ELF' ELSE Series END, SUBSTRING(Outlet, 1, 3)
			  HAVING SUBSTRING(Outlet, 1, 3) in ('bah','sas','jol','per')

			  truncate table GOLD_WAREHOUSE.dbo.KPIFakpolTarget2
			  insert  into GOLD_WAREHOUSE.dbo.KPIFakpolTarget2
				SELECT DISTINCT YEAR(Date) Tahun, 
					MONTH(Date) Bulan, 
					Outlet,
					Series, 
					Target
			  FROM GOLD_WAREHOUSE.dbo.[KPIFakpolOutlet]
			  WHERE YEAR(Date) = @Year

			  
			  --Dealer GIGA
			  truncate table KPIFakpolTarget
			  insert  into KPIFakpolTarget
				  SELECT Tahun, Bulan, 
					SUBSTRING(Outlet, 1, 3) Dealer, 
					Series, 
					SUM(Target) Target 
			  FROM GOLD_WAREHOUSE.dbo.KPIFakpolTarget2
			  GROUP BY Tahun, Bulan, Series, SUBSTRING(Outlet, 1, 3)
			  HAVING SUBSTRING(Outlet, 1, 3) not in ('bah','sas','jol','per')
  
  
			  --Dealer NON GIGA
			  insert  into KPIFakpolTarget
				  SELECT Tahun, Bulan, 
					SUBSTRING(Outlet, 1, 3) Dealer, 
					CASE WHEN Series = 'GIGA' THEN 'ELF' ELSE Series END AS Series,
					SUM(Target) Target 
			  FROM GOLD_WAREHOUSE.dbo.KPIFakpolTarget2
			  GROUP BY Tahun, Bulan, CASE WHEN Series = 'GIGA' THEN 'ELF' ELSE Series END, SUBSTRING(Outlet, 1, 3)
			  HAVING SUBSTRING(Outlet, 1, 3) in ('bah','sas','jol','per')

			  update d
			  set d.Target=t.Target
			  from GOLD_WAREHOUSE.dbo.KPIFakpolDealer d
			  join GOLD_WAREHOUSE.dbo.KPIFakpolTarget t
			  on year(d.Date) = t.Tahun 
			  and MONTH(d.Date) = t.Bulan
			  and d.Series = t.Series
			  and d.Dealer = t.Dealer

			  --Dealer GIGA
			  update GOLD_WAREHOUSE.dbo.KPIFakpolDealer set Achievement=convert(float,Actual)/convert(float,Target) where Target > 0 AND YEAR(Date) = @Year
			  update GOLD_WAREHOUSE.dbo.KPIFakpolDealer set Point=10 where Achievement >= 1 AND YEAR(Date) = @Year
			  update GOLD_WAREHOUSE.dbo.KPIFakpolDealer set Point=8 where Achievement <= 0.99 AND YEAR(Date) = @Year
			  update GOLD_WAREHOUSE.dbo.KPIFakpolDealer set Point=6 where Achievement <= 0.84 AND YEAR(Date) = @Year
			  update GOLD_WAREHOUSE.dbo.KPIFakpolDealer set Point=3 where Achievement <= 0.69 AND YEAR(Date) = @Year
    

			  --Dealer NON GIGA
			  update GOLD_WAREHOUSE.dbo.KPIFakpolDealer set Achievement=convert(float,Actual)/convert(float,Target) where Target > 0 and Dealer in ('bah','sas','jol','per') AND YEAR(Date) = @Year
			  update GOLD_WAREHOUSE.dbo.KPIFakpolDealer set Point=15 where Achievement >= 1 and Dealer in ('BAH','SAS','JOL','PER') AND YEAR(Date) = @Year
			  update GOLD_WAREHOUSE.dbo.KPIFakpolDealer set Point=12 where Achievement <= 0.99 and Dealer in ('bah','sas','jol','per') AND YEAR(Date) = @Year
			  update GOLD_WAREHOUSE.dbo.KPIFakpolDealer set Point=9 where Achievement <= 0.84 and Dealer in ('bah','sas','jol','per') AND YEAR(Date) = @Year
			  update GOLD_WAREHOUSE.dbo.KPIFakpolDealer set Point=6 where Achievement <= 0.69 and Dealer in ('bah','sas','jol','per') AND YEAR(Date) = @Year


END