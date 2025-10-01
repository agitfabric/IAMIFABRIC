CREATE   PROCEDURE  [dbo].[SP_REPORT_28]

AS
BEGIN

	SET NOCOUNT ON;

	--DECLARE @maxdate NVARCHAR(30)
	--set @maxdate = (select convert(varchar,max(Date),23) as maxdate  from Report_42);

	Delete from Report_28 where Left(Convert(varchar,Tanggal,23),10) = convert(varchar,GETDATE()-1,23);

	with Report25NoAdo as (SELECT 
                DatePhysical as Tanggal,
                [CV/LCV],
                Series,
                Type_Description as [Type],
                ItemId,
                                     wholesale,
                                     EUS,
                                     TransferIn,
                                     TransferOut,
                                     Transactions,
                                     Beginstock,
                          Endstock as Dealer,
						  'Report_25' as Source,
                                    0 as IAMI,
                                    0 as AI FROM Report_25noADO where Left(Convert(varchar,DatePhysical,23),10) = convert(varchar,GETDATE()-1,23)),
		EndStockIamiSSIS as (
		select 
		DISTINCT 
		a.CV_LCV,
		case when a.Series = 'N-SERIES' then 'ELF' 
         	when a.Series = 'P-SERIES' then 'TRAGA'
         	when a.Series = 'F-SERIES' then 'GIGA'
         	when a.Series = 'G-SERIES' then 'GIGA'
		else a.Series end Series, 
		a.SDA_Item_No as ItemId,
		b.Type_Description as Type,
			--a.Status,
			--a.Tahun_VIN_NIK,
		a.Tanggal,
			--0 as wholesale,
			--0 as EUS,
			--0 as TransferIn,
			--0 as TransferOut,
			--0 as Transactions,
			--0 as Beginstock,
			--0 as Dealer,
			a.End_Stock as IAMI
			--0 as AI
			--'SAP' as Source
			from SILVER_WAREHOUSE.dbo.End_Stock_IAMI_SSIS a
			left join Report_25noADO b on LOWER(a.SDA_Item_No)  = LOWER(b.ItemId)
			where Left(Convert(varchar,Tanggal,23),10) = convert(varchar,GETDATE()-1,23)--'2025-06-17'
		), sumx as (select Tanggal,Series,Type,ItemId,CV_LCV,sum(IAMI) as IAMI from EndStockIamiSSIS group by Tanggal,Series,Type,ItemId,CV_LCV)
		,temp as (select *,0 as wholesale,
			0 as EUS,
			0 as TransferIn,
			0 as TransferOut,
			0 as Transactions,
			0 as Beginstock,
			0 as Dealer,
			0 as AI,
			'SAP' as Source from sumx)
		,uniontemp as (
		select * from Report25NoAdo union all select * from temp
		) 
	insert into Report_28 (Tanggal,[CV/LCV],Series,ItemId,Dealer,AI,IAMI,Type_Description,Source,wholesale,EUS,TransferIn,TransferOut,Transactions,Beginstock)
	select Tanggal,[CV/LCV],Series,ItemId,Dealer,AI,IAMI,Type,Source,wholesale,EUS,TransferIn,TransferOut,Transactions,Beginstock from uniontemp
	
END