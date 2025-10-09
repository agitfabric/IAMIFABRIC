CREATE PROCEDURE [dbo].[SP_REPORT_27_SCHDL]   

AS
BEGIN

	with temp as (SELECT
      Series
      ,SDA_Item_No
      ,[Type]
      ,COALESCE(Status, '') as Status
      ,End_Stock
      ,Tahun_VIN_NIK
      ,Tanggal as Dates
  FROM SILVER_WAREHOUSE.dbo.End_Stock_IAMI_SSIS
  WHERE Tanggal = CONVERT(VARCHAR(10), DATEADD(DAY, -1, GETDATE()), 120)
  )
,temp2 as (
    select Series
      ,SDA_Item_No
      ,[Type]
      ,Status
      ,sum(End_Stock) as [value]
      ,Tahun_VIN_NIK
      ,Dates
      ,case when RIGHT(Status,8) ='OKE-PARK' or RIGHT(Status,9) = 'BOOK-PARK' then 'Total Ready To Sales'
      Else 'Total Not Ready To Sales' END as Category
      from temp
      group by Series,SDA_Item_No,Type,Status,Tahun_VIN_NIK,Dates
      UNION 
      select Series
      ,SDA_Item_No
      ,[Type]
      ,'All Status' as Status
      ,sum(End_Stock) as [value]
      ,Tahun_VIN_NIK
      ,Dates
      ,'Total Stock IAMI'as Category
      from temp
      group by Series,SDA_Item_No,Type,Status,Tahun_VIN_NIK,Dates
) 
insert into Report_27 (Series,SDA_Item_no,type_description,Status,value,Tahun_VIN_NIK,Dates,Category)
select Series,SDA_Item_No,Type,Status,value,Tahun_VIN_NIK,Dates,Category from temp2 
	END