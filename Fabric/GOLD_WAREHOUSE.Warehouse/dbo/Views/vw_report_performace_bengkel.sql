-- Auto Generated (Do not modify) 19B11D74EAC59644A14A1EFFBFA42CA46E8005659CFE0354902E746D6DE4E564


CREATE view [dbo].[vw_report_performace_bengkel]
as

With FL as (
select uni.InventSiteId,uni.InvoiceDate,uni.ProjId,uni.Stall_BIB,uni.Brand,uni.MajorGroup,uni.MinorGroupId,UnitServed_Qty qty,rev.revenue,rev.cost from Report_44_UnitServed uni
join
(select ProjID,sum(Revenue) revenue,sum(Cost) cost from Report_44_Revenue group by ProjID) rev 
on uni.ProjId = rev.ProjID
where uni.ParentId = ''
)
,FL_CON as (
select uni.InventSiteId,uni.InvoiceDate,uni.ProjId,uni.Stall_BIB,uni.Brand,uni.MajorGroup,uni.MinorGroupId,UnitServed_Qty qty,rev.revenue from Report_44_UnitServed uni
join
(select ProjID,sum(Revenue) revenue from Report_44_Revenue group by ProjID) rev 
on uni.ProjId = rev.ProjID
where uni.ParentId = '' and Contract_Qty > 0
)
,FL_CAT as (
select uni.InventSiteId,uni.InvoiceDate,uni.ProjId,uni.Stall_BIB,uni.Brand,uni.MajorGroup,uni.MinorGroupId,rev.Category_name,rev.ItemID,rev.revenue,rev.Cost from Report_44_UnitServed uni
join
(select ProjID,Category_name,ItemID,sum(Revenue) revenue,sum(Cost) Cost from Report_44_Revenue group by ProjID,Category_name,ItemID) rev
on uni.ProjId = rev.ProjID
where uni.ParentId = '' 
)

,FL_JL as (
select uni.InventSiteId,uni.InvoiceDate,uni.ProjId,uni.Stall_BIB,uni.Brand,uni.MajorGroup,uni.MinorGroupId,jbl.Joblist,jbl.qty,jbl.revenue from Report_44_UnitServed uni
join
(select ProjInvoiceProjId ProjId,Joblist,sum(UnitServedbyJoblist_Qty) qty,sum(Revenue) revenue from Report_44_Joblist group by ProjInvoiceProjId,Joblist) jbl
on uni.ProjId = jbl.ProjId
where uni.ParentId = '' 
)
,FL_T as (
select
Dealer
,[Kode Outlet]
,Target
,case 
when Target ='REVENUE LCV Target' THEN 'LCV'
when Target ='REVENUE CV Target' THEN 'CV'
when Target ='UNIT SERVED LCV Target' THEN 'LCV'
when Target ='UNIT SERVED  CV Target' THEN 'CV'
when Target ='DEMAND LCV' THEN 'LCV'
when Target ='DEMAND CV' THEN 'CV'
ELSE NULL END MajorGroup
,case 
when Target ='REVENUE LCV Target' THEN 'REVENUE'
when Target ='REVENUE CV Target' THEN 'REVENUE'
when Target ='UNIT SERVED LCV Target' THEN 'UNIT'
when Target ='UNIT SERVED  CV Target' THEN 'UNIT'
when Target ='DEMAND LCV' THEN 'DEMAND'
when Target ='DEMAND CV' THEN 'DEMAND'
ELSE NULL END Scenario
,Bulan
,case
  when Bulan = 'Jan' Then FORMAT(cast(Tahun+'-01-01' as date), 'yyyy-MM-dd')
  when Bulan = 'Feb' Then FORMAT(cast(Tahun+'-02-01' as date), 'yyyy-MM-dd')
  when Bulan = 'Mar' Then FORMAT(cast(Tahun+'-03-01' as date), 'yyyy-MM-dd')
  when Bulan = 'Apr' Then FORMAT(cast(Tahun+'-04-01' as date), 'yyyy-MM-dd')
  when Bulan = 'May' Then FORMAT(cast(Tahun+'-05-01' as date), 'yyyy-MM-dd')
  when Bulan = 'Jun' Then FORMAT(cast(Tahun+'-06-01' as date), 'yyyy-MM-dd')
  when Bulan = 'Jul' Then FORMAT(cast(Tahun+'-07-01' as date), 'yyyy-MM-dd')
  when Bulan = 'Aug' Then FORMAT(cast(Tahun+'-08-01' as date), 'yyyy-MM-dd')
  when Bulan = 'Sep' Then FORMAT(cast(Tahun+'-09-01' as date), 'yyyy-MM-dd')
  when Bulan = 'Oct' Then FORMAT(cast(Tahun+'-10-01' as date), 'yyyy-MM-dd')
  when Bulan = 'Nov' Then FORMAT(cast(Tahun+'-11-01' as date), 'yyyy-MM-dd')
  when Bulan = 'Dec' Then FORMAT(cast(Tahun+'-12-01' as date), 'yyyy-MM-dd')
  ELSE NULL END Date
,case when Target IN ('REVENUE LCV Target','REVENUE CV Target') THEN (Value * 1000) ELSE Value end Value
from [dbo].[TargetUnitServed]
)
,unit_served_total as 
(
select left(cast(FL.InvoiceDate as date),7) InvoiceDate,FL.InventSiteId,sum(qty) Value from FL
where Brand = 'Isuzu'
group by left(cast(FL.InvoiceDate as date),7),FL.InventSiteId
)
,unit_served_total_by_MajorGroup as 
(
select left(cast(FL.InvoiceDate as date),7) InvoiceDate,FL.InventSiteId,MajorGroup,sum(qty) Value from FL
where Brand = 'Isuzu'
group by left(cast(FL.InvoiceDate as date),7),FL.InventSiteId,MajorGroup
)
,revenue_served_total as 
(
select left(cast(FL.InvoiceDate as date),7) InvoiceDate,InventSiteId,sum(revenue) Value
from FL
where Brand = 'Isuzu'
group by left(cast(FL.InvoiceDate as date),7),FL.InventSiteId
)
,revenue_served_total_by_MajorGroup as 
(
select left(cast(FL.InvoiceDate as date),7) InvoiceDate,InventSiteId,MajorGroup,sum(revenue) Value
from FL
where Brand = 'Isuzu'
group by left(cast(FL.InvoiceDate as date),7),FL.InventSiteId,MajorGroup
)
,data_Outlet as 
(
select left(cast(Dates as date),7) InvoiceDate,Outlet,sum(JumlahHariKerja) JumlahHariKerja,sum(JamTersedia) JamTersedia,sum(JumlahMekanik) JumlahMekanik,sum(JamTerjual) JamTerjual 
,sum(JumlahStall) JumlahStall,sum(JumlahBIB) JumlahBIB
from Report_44_DatabyOutlet
group by left(cast(Dates as date),7),Outlet
)
,harga_jasa_perjam as (
select Dates,Outlet,HargaJasaPerJam,sum(Value) Value
from Report_44_DatabyOutlet
unpivot
(
  Value
  for HargaJasaPerJam in ([HJNSER],[HJFSER],[HJPSER],[HJTBSER],[HJTFSER],[HJBISON],[HJCESER],[HJFGSER],[HJKSCG],[HJLTSER],[HJUCSER])
) u
group by Dates,Outlet,HargaJasaPerJam
)
,unit_served_Target as 
(
select Date,[Kode Outlet],MajorGroup,sum(Value) Value from FL_T
where Scenario = 'UNIT'
group by Date,[Kode Outlet],MajorGroup
)
,revenue_Target as 
(
select Date,[Kode Outlet],MajorGroup,sum(Value) Value from FL_T
where Scenario = 'REVENUE'
group by Date,[Kode Outlet],MajorGroup
)

--=== Target ===---

select Date,[Kode Outlet],RF.Code,sum(Value) Value,'Target - Unit' as src
from FL_T
join [dbo].[ReportFormat] RF on FL_T.Scenario = RF.Scenario and ReportCode = 'TU'
group by 
Date,[Kode Outlet],RF.Code
union all
select Date,[Kode Outlet],RF.Code,sum(Value) Value,'Target - Unit CV/LCV' as src
from FL_T
join [dbo].[ReportFormat] RF on FL_T.Scenario = RF.Scenario and ReportCode = 'TUD' and FL_T.MajorGroup = RF.MajorGroupId
group by 
Date,[Kode Outlet],RF.Code
union all
select Date,[Kode Outlet],RF.Code,sum(Value) Value,'Target - Revenue' as src
from FL_T
join [dbo].[ReportFormat] RF on FL_T.Scenario = RF.Scenario and ReportCode = 'TR'
group by 
Date,[Kode Outlet],RF.Code
--add by oji 2022-08-16
union all
select Date,[Kode Outlet],RF.Code,sum(Value) Value,'Target - Revenue CV/LCV' as src
from FL_T
join [dbo].[ReportFormat] RF on FL_T.Scenario = RF.Scenario and ReportCode = 'TRD' and FL_T.MajorGroup = RF.MajorGroupId
group by 
Date,[Kode Outlet],RF.Code
-- Achievement Unit
union all
select FL_T.Date,[Kode Outlet],RF.Code,IIF(sum(cast(FL_T.Value as decimal (8,2)))=0,0,(cast(sum(UST.Value)as decimal (8,2))/cast(sum(FL_T.Value)as decimal (8,2))))*100 Value,'Target - Achievement Unit ' as src
from unit_served_Target FL_T
join [dbo].[ReportFormat] RF on ReportCode = 'TUP' 
join unit_served_total_by_MajorGroup UST on FL_T.[Kode Outlet] = UST.InventSiteId and LEFT(FL_T.Date,7) = InvoiceDate and FL_T.MajorGroup = UST.MajorGroup
group by 
FL_T.Date,[Kode Outlet],RF.Code
union all
select FL_T.Date,[Kode Outlet],RF.Code,IIF(sum(cast(FL_T.Value as decimal (8,2)))=0,0,(cast(sum(UST.Value)as decimal (8,2))/cast(sum(FL_T.Value)as decimal (8,2))))*100 Value,'Target - Achievement Unit ' as src
from unit_served_Target FL_T
join [dbo].[ReportFormat] RF on ReportCode = 'TUPD' and FL_T.MajorGroup = RF.MajorGroupId
join unit_served_total_by_MajorGroup UST on FL_T.[Kode Outlet] = UST.InventSiteId and LEFT(FL_T.Date,7) = InvoiceDate and FL_T.MajorGroup = UST.MajorGroup
group by 
FL_T.Date,[Kode Outlet],RF.Code
-- Achievement Revenue
union all
select FL_T.Date,[Kode Outlet],RF.Code,IIF(sum(FL_T.Value)=0,0,(sum(RST.Value)/sum(FL_T.Value)))*100 Value,'Target - Achievement Revenue' as src
from revenue_Target FL_T
join [dbo].[ReportFormat] RF on ReportCode = 'TRP'
join revenue_served_total_by_MajorGroup RST on FL_T.[Kode Outlet] = RST.InventSiteId and LEFT(FL_T.Date,7) = InvoiceDate and FL_T.MajorGroup = RST.MajorGroup
group by 
FL_T.Date,[Kode Outlet],RF.Code

union all
select FL_T.Date,[Kode Outlet],RF.Code,IIF(sum(FL_T.Value)=0,0,(sum(RST.Value)/sum(FL_T.Value)))*100 Value,'Target - Achievement Revenue' as src
from revenue_Target FL_T
join [dbo].[ReportFormat] RF on ReportCode = 'TRPD' and FL_T.MajorGroup = RF.MajorGroupId
join revenue_served_total_by_MajorGroup RST on FL_T.[Kode Outlet] = RST.InventSiteId and LEFT(FL_T.Date,7) = InvoiceDate and FL_T.MajorGroup = RST.MajorGroup
group by 
FL_T.Date,[Kode Outlet],RF.Code

--=== Data Outlet ===---
-- jumlah hari kerja
union all
Select Dates date,Outlet [Kode Outlet],RF.Code,sum(JumlahHariKerja) Value,'Jumlah Hari Kerja' SRC  From Report_44_DatabyOutlet DO
join [dbo].[ReportFormat] RF on ReportCode = 'JHK'
group by Dates,Outlet,RF.Code

-- Jumlah Mekanik
union all
Select Dates date,Outlet [Kode Outlet],RF.Code,sum(JumlahMekanik) Value,'Jumlah Mekanik' SRC  From Report_44_DatabyOutlet DO
join [dbo].[ReportFormat] RF on ReportCode = 'JM'
group by Dates,Outlet,RF.Code

-- Jumlah STALL
union all
Select Dates date,Outlet [Kode Outlet],RF.Code,sum(JumlahStall) Value,'Jumlah Stall' SRC  From Report_44_DatabyOutlet DO
join [dbo].[ReportFormat] RF on ReportCode = 'JMS'
group by Dates,Outlet,RF.Code

-- Jumlah BIB
union all
Select Dates date,Outlet [Kode Outlet],RF.Code,sum(JumlahBIB) Value,'Jumlah BIB' SRC  From Report_44_DatabyOutlet DO
join [dbo].[ReportFormat] RF on ReportCode = 'JMB'
group by Dates,Outlet,RF.Code

-- harga jasa perjam
union all
Select Dates date,Outlet [Kode Outlet],RF.Code,sum(Value) Value,'Harga Jasa Perjam' SRC  From harga_jasa_perjam HJP
join [dbo].[ReportFormat] RF on HJP.HargaJasaPerJam = RF.HargaJasaPerjam and ReportCode = 'HJPJ'
group by Dates,Outlet,RF.Code

-- Jam Tersedia
union all
Select Dates date,Outlet [Kode Outlet],RF.Code,sum(JamTersedia) Value,'Jam Tersedia' SRC  From Report_44_DatabyOutlet DO
join [dbo].[ReportFormat] RF on ReportCode = 'JT'
group by Dates,Outlet,RF.Code

-- Jam Aktual
union all
Select Dates date,Outlet [Kode Outlet],RF.Code,sum(JamTerjual) Value,'Jam Terjual' SRC  From Report_44_DatabyOutlet DO
join [dbo].[ReportFormat] RF on ReportCode = 'JTFR'
group by Dates,Outlet,RF.Code

-- Jam Aktual
union all
Select Dates date,Outlet [Kode Outlet],RF.Code,sum(JamAktual) Value,'Jam Terjual' SRC  From Report_44_DatabyOutlet DO
join [dbo].[ReportFormat] RF on ReportCode = 'JA'
group by Dates,Outlet,RF.Code

-- Jumlah Customer
union all
Select Dates date,Outlet [Kode Outlet],RF.Code,sum(CustomerAll) Value,'Jumlah Customer' SRC  From Report_44_DatabyOutlet DO
join [dbo].[ReportFormat] RF on ReportCode = 'JC'
group by Dates,Outlet,RF.Code

-- Jumlah Customer Contract
union all
Select Dates date,Outlet [Kode Outlet],RF.Code,sum(CustomerContract) Value,'Jumlah Customer' SRC  From Report_44_DatabyOutlet DO
join [dbo].[ReportFormat] RF on ReportCode = 'JCSK'
group by Dates,Outlet,RF.Code

-- REVENUE PART NOTA KONTAN (INDIRECT)
union all
Select Dates date,Outlet [Kode Outlet],RF.Code,sum(RevenuePartNotaKontan) Value,'Jumlah Customer' SRC  From Report_44_DatabyOutlet DO
join [dbo].[ReportFormat] RF on ReportCode = 'RPNK'
group by Dates,Outlet,RF.Code

-- REVENUE PART NOTA KONTAN (DIRECT)
union all
Select Dates date,Outlet [Kode Outlet],RF.Code,sum(RevenuePartNotaKontanDirect) Value,'Jumlah Customer' SRC  From Report_44_DatabyOutlet DO
join [dbo].[ReportFormat] RF on ReportCode = 'RPNKD'
group by Dates,Outlet,RF.Code

--=== Revenue per Unit ===---
--Revenue per unit
union all
select cast(cast(year(InvoiceDate)as varchar(255))+'/'+cast(month(InvoiceDate) as varchar(255))+'/'+'01' as date) date,InventSiteId,RF.Code report_id,IIF(sum(qty)=0,0,sum(revenue)/sum(qty)) Value,'revenue per unit' as src
from FL
join [dbo].[ReportFormat] RF on FL.Brand = RF.Brand and FL.MajorGroup = RF.MajorGroupId and FL.MinorGroupId = RF.MinorGroupId and ReportCode = 'RPU'
group by cast(cast(year(InvoiceDate)as varchar(255))+'/'+cast(month(InvoiceDate) as varchar(255))+'/'+'01' as date),FL.InventSiteId,RF.Code
-- Revenue per unit MajorGroup total
union all
select cast(cast(year(InvoiceDate)as varchar(255))+'/'+cast(month(InvoiceDate) as varchar(255))+'/'+'01' as date) date,InventSiteId,RF.Code report_id,IIF(sum(qty)=0,0,sum(revenue)/sum(qty)) Value,'revenue per unit' as src
from FL
join [dbo].[ReportFormat] RF on FL.Brand = RF.Brand and FL.MajorGroup = RF.MajorGroupId and ReportCode = 'RPUH'
group by cast(cast(year(InvoiceDate)as varchar(255))+'/'+cast(month(InvoiceDate) as varchar(255))+'/'+'01' as date),FL.InventSiteId,RF.Code
-- Revenue per unit Brand total
union all
select cast(cast(year(InvoiceDate)as varchar(255))+'/'+cast(month(InvoiceDate) as varchar(255))+'/'+'01' as date) date,InventSiteId,RF.Code report_id,IIF(sum(qty)=0,0,sum(revenue)/sum(qty)) Value,'revenue per unit' as src
from FL
join [dbo].[ReportFormat] RF on FL.Brand = RF.Brand and ReportCode = 'RPU' and IsTotal = 'BT'
group by cast(cast(year(InvoiceDate)as varchar(255))+'/'+cast(month(InvoiceDate) as varchar(255))+'/'+'01' as date),FL.InventSiteId,RF.Code
-- Revenue per unit grand total
union all
select cast(cast(year(InvoiceDate)as varchar(255))+'/'+cast(month(InvoiceDate) as varchar(255))+'/'+'01' as date) date,InventSiteId,RF.Code report_id,IIF(sum(qty)=0,0,sum(revenue)/sum(qty)) Value,'revenue per unit' as src
from FL
join [dbo].[ReportFormat] RF on ReportCode = 'RPU' and IsTotal = 'GT'
group by cast(cast(year(InvoiceDate)as varchar(255))+'/'+cast(month(InvoiceDate) as varchar(255))+'/'+'01' as date),FL.InventSiteId,RF.Code

--=== Unit Served ===---
-- UNIT SERVED
union all
select InvoiceDate date,InventSiteId,RF.Code report_id,sum(qty) Value,'unit served - qty' as src
from FL
join [dbo].[ReportFormat] RF on FL.Brand = RF.Brand and FL.MajorGroup = RF.MajorGroupId and FL.MinorGroupId = RF.MinorGroupId and ReportCode = 'US'
group by FL.InvoiceDate,FL.InventSiteId,RF.Code
-- MajorGroup total
union all
select FL.InvoiceDate,FL.InventSiteId,RF.Code report_id,sum(qty) Value,'unit served - qty' as src
from FL
join [dbo].[ReportFormat]  RF on FL.Brand = RF.Brand and FL.MajorGroup = RF.MajorGroupId and ReportCode = 'USH'
group by FL.InvoiceDate,FL.InventSiteId,RF.Code
-- Brand total
union all
select FL.InvoiceDate,FL.InventSiteId,RF.Code report_id,sum(qty) Value,'unit served - qty' as src
from FL
join [dbo].[ReportFormat]  RF on FL.Brand = RF.Brand and IsTotal = 'BT' and ReportCode = 'US'
group by FL.InvoiceDate,FL.InventSiteId,RF.Code
-- Grand Total
union all
select FL.InvoiceDate,FL.InventSiteId,RF.Code report_id,sum(qty) Value,'unit served - qty' as src
from FL
join [dbo].[ReportFormat]  RF on IsTotal = 'GT' and ReportCode = 'US'
group by FL.InvoiceDate,FL.InventSiteId,RF.Code

-- Unit Served BIB
union all
select InvoiceDate date,InventSiteId,RF.Code report_id,sum(qty) Value,'unit served - qty' as src
from FL
join [dbo].[ReportFormat] RF on FL.Stall_BIB = RF.Stall_BIB and FL.Brand = RF.Brand and FL.MajorGroup = RF.MajorGroupId and FL.MinorGroupId = RF.MinorGroupId and ReportCode = 'USB'
group by FL.InvoiceDate,FL.InventSiteId,RF.Code
-- MajorGroup Total BIB
union all
select FL.InvoiceDate,FL.InventSiteId,RF.Code report_id,sum(qty) Value,'unit served - qty' as src
from FL
join [dbo].[ReportFormat]  RF on FL.Stall_BIB = RF.Stall_BIB and FL.Brand = RF.Brand and FL.MajorGroup = RF.MajorGroupId and ReportCode = 'USBH'
group by FL.InvoiceDate,FL.InventSiteId,RF.Code
-- Brand Total BIB
union all
select FL.InvoiceDate,FL.InventSiteId,RF.Code report_id,sum(qty) Value,'unit served - qty' as src
from FL
join [dbo].[ReportFormat]  RF on FL.Stall_BIB = RF.Stall_BIB and FL.Brand = RF.Brand and IsTotal = 'BT' and ReportCode = 'USB'
group by FL.InvoiceDate,FL.InventSiteId,RF.Code
-- Grand Total BIB
union all
select FL.InvoiceDate,FL.InventSiteId,RF.Code report_id,sum(qty) Value,'unit served - qty' as src
from FL
join [dbo].[ReportFormat]  RF on FL.Stall_BIB = RF.Stall_BIB and IsTotal = 'GT' and ReportCode = 'USB'
group by FL.InvoiceDate,FL.InventSiteId,RF.Code
-- Unit Served Service Contract
union all
select FL.InvoiceDate,FL.InventSiteId,RF.Code report_id,sum(qty) Value,'unit served - qty' as src
from FL_CON FL
join [dbo].[ReportFormat]  RF on ReportCode = 'USSC'
group by FL.InvoiceDate,FL.InventSiteId,RF.Code

--=== Revenue ===---
-- Revenue
union all
select InvoiceDate date,InventSiteId,RF.Code report_id,sum(revenue) Value,'revenue - qty' as src
from FL
join [dbo].[ReportFormat] RF on FL.Brand = RF.Brand and FL.MajorGroup = RF.MajorGroupId and FL.MinorGroupId = RF.MinorGroupId and ReportCode = 'USR'
group by FL.InvoiceDate,FL.InventSiteId,RF.Code
-- MajorGroup total
union all
select FL.InvoiceDate,FL.InventSiteId,RF.Code report_id,sum(revenue) Value,'revenue - qty' as src
from FL
join [dbo].[ReportFormat]  RF on FL.Brand = RF.Brand and FL.MajorGroup = RF.MajorGroupId and ReportCode = 'USRH'
group by FL.InvoiceDate,FL.InventSiteId,RF.Code
-- Brand total
union all
select FL.InvoiceDate,FL.InventSiteId,RF.Code report_id,sum(revenue) Value,'revenue - qty' as src
from FL
join [dbo].[ReportFormat]  RF on FL.Brand = RF.Brand and IsTotal = 'BT' and ReportCode = 'USR'
group by FL.InvoiceDate,FL.InventSiteId,RF.Code
-- Grand Total
union all
select FL.InvoiceDate,FL.InventSiteId,RF.Code report_id,sum(revenue) Value,'revenue - qty' as src
from FL
join [dbo].[ReportFormat]  RF on IsTotal = 'GT' and ReportCode = 'USR'
group by FL.InvoiceDate,FL.InventSiteId,RF.Code
-- revenue BIB
union all
select InvoiceDate date,InventSiteId,RF.Code report_id,sum(revenue) Value,'revenue - qty' as src
from FL
join [dbo].[ReportFormat] RF on FL.Stall_BIB = RF.Stall_BIB and FL.Brand = RF.Brand and FL.MajorGroup = RF.MajorGroupId and FL.MinorGroupId = RF.MinorGroupId and ReportCode = 'USRB'
group by FL.InvoiceDate,FL.InventSiteId,RF.Code
-- MajorGroup total BIB
union all
select FL.InvoiceDate,FL.InventSiteId,RF.Code report_id,sum(revenue) Value,'revenue - qty' as src
from FL
join [dbo].[ReportFormat]  RF on FL.Stall_BIB = RF.Stall_BIB and FL.Brand = RF.Brand and FL.MajorGroup = RF.MajorGroupId and ReportCode = 'USRBH'
group by FL.InvoiceDate,FL.InventSiteId,RF.Code
-- Brand total BIB
union all
select FL.InvoiceDate,FL.InventSiteId,RF.Code report_id,sum(revenue) Value,'revenue - qty' as src
from FL
join [dbo].[ReportFormat]  RF on FL.Stall_BIB = RF.Stall_BIB and FL.Brand = RF.Brand and IsTotal = 'BT' and ReportCode = 'USRB'
group by FL.InvoiceDate,FL.InventSiteId,RF.Code
-- Grand Total BIB
union all
select FL.InvoiceDate,FL.InventSiteId,RF.Code report_id,sum(revenue) Value,'revenue - qty' as src
from FL
join [dbo].[ReportFormat]  RF on FL.Stall_BIB = RF.Stall_BIB and IsTotal = 'GT' and ReportCode = 'USRB'
group by FL.InvoiceDate,FL.InventSiteId,RF.Code
-- Revenue Service Contract
union all
select FL.InvoiceDate,FL.InventSiteId,RF.Code report_id,sum(revenue) Value,'revenue - qty' as src
from FL_CON FL
join [dbo].[ReportFormat]  RF on ReportCode = 'RSC'
group by FL.InvoiceDate,FL.InventSiteId,RF.Code


--=== Unit Served by Joblist ===---
-- unit served Joblist
union all
select InvoiceDate date,InventSiteId,RF.Code report_id,sum(qty) Value,'Unit Served by Joblist - qty' as src
from FL_JL
join [dbo].[ReportFormat] RF on FL_JL.Brand = RF.Brand and FL_JL.MajorGroup = RF.MajorGroupId and FL_JL.MinorGroupId = RF.MinorGroupId and FL_JL.Joblist = RF.Joblist 
and ReportCode = 'USJL'
group by FL_JL.InvoiceDate,FL_JL.InventSiteId,RF.Code
-- unit served minorgroup total
union all
select InvoiceDate date,InventSiteId,RF.Code report_id,sum(qty) Value,'Unit Served by Joblist - qty' as src
from FL_JL
join [dbo].[ReportFormat] RF on FL_JL.Brand = RF.Brand and FL_JL.MajorGroup = RF.MajorGroupId and FL_JL.MinorGroupId = RF.MinorGroupId
and ReportCode = 'USJLH'
group by FL_JL.InvoiceDate,FL_JL.InventSiteId,RF.Code
-- unit served MajorGroup header total
union all
select InvoiceDate date,InventSiteId,RF.Code report_id,sum(qty) Value,'Unit Served by Joblist - qty' as src
from FL_JL
join [dbo].[ReportFormat] RF on FL_JL.Brand = RF.Brand and FL_JL.MajorGroup = RF.MajorGroupId 
and ReportCode = 'USJLH' and IsTotal = 'MT'
group by FL_JL.InvoiceDate,FL_JL.InventSiteId,RF.Code
-- unit served MajorGroup total
union all
select InvoiceDate date,InventSiteId,RF.Code report_id,sum(qty) Value,'Unit Served by Joblist - qty' as src
from FL_JL
join [dbo].[ReportFormat] RF on FL_JL.Brand = RF.Brand and FL_JL.MajorGroup = RF.MajorGroupId and FL_JL.Joblist = RF.Joblist
and ReportCode = 'USJL' and IsTotal = 'MT'
group by FL_JL.InvoiceDate,FL_JL.InventSiteId,RF.Code
-- unit served Brand header total
union all
select InvoiceDate date,InventSiteId,RF.Code report_id,sum(qty) Value,'Unit Served by Joblist - qty' as src
from FL_JL
join [dbo].[ReportFormat] RF on FL_JL.Brand = RF.Brand
and ReportCode = 'USJLH' and IsTotal = 'BT'
group by FL_JL.InvoiceDate,FL_JL.InventSiteId,RF.Code
-- unit served Brand total
union all
select InvoiceDate date,InventSiteId,RF.Code report_id,sum(qty) Value,'Unit Served by Joblist - qty' as src
from FL_JL
join [dbo].[ReportFormat] RF on FL_JL.Brand = RF.Brand and FL_JL.Joblist = RF.Joblist
and ReportCode = 'USJL' and IsTotal = 'BT'
group by FL_JL.InvoiceDate,FL_JL.InventSiteId,RF.Code
-- unit served Joblist header total
union all
select InvoiceDate date,InventSiteId,RF.Code report_id,sum(qty) Value,'Unit Served by Joblist - qty' as src
from FL_JL
join [dbo].[ReportFormat] RF on IsTotal = 'GT' and ReportCode = 'USJLH'
group by FL_JL.InvoiceDate,FL_JL.InventSiteId,RF.Code
-- unit served Joblist total
union all
select InvoiceDate date,InventSiteId,RF.Code report_id,sum(qty) Value,'Unit Served by Joblist - qty' as src
from FL_JL
join [dbo].[ReportFormat] RF on FL_JL.Joblist = RF.Joblist and IsTotal = 'GT' and ReportCode = 'USJL'
group by FL_JL.InvoiceDate,FL_JL.InventSiteId,RF.Code


-- unit served Joblist BIB
union all
select InvoiceDate date,InventSiteId,RF.Code report_id,sum(qty) Value,'Unit Served by Joblist - qty' as src
from FL_JL
join [dbo].[ReportFormat] RF on FL_JL.Stall_BIB = RF.Stall_BIB and  FL_JL.Brand = RF.Brand and FL_JL.MajorGroup = RF.MajorGroupId and FL_JL.MinorGroupId = RF.MinorGroupId and FL_JL.Joblist = RF.Joblist 
and ReportCode = 'USJLB'
group by FL_JL.InvoiceDate,FL_JL.InventSiteId,RF.Code
-- unit served minorgroup total BIB
union all
select InvoiceDate date,InventSiteId,RF.Code report_id,sum(qty) Value,'Unit Served by Joblist - qty' as src
from FL_JL
join [dbo].[ReportFormat] RF on FL_JL.Stall_BIB = RF.Stall_BIB and  FL_JL.Brand = RF.Brand and FL_JL.MajorGroup = RF.MajorGroupId and FL_JL.MinorGroupId = RF.MinorGroupId 
and ReportCode = 'USJLBH'
group by FL_JL.InvoiceDate,FL_JL.InventSiteId,RF.Code
-- unit served minorgroup header total BIB
union all
select InvoiceDate date,InventSiteId,RF.Code report_id,sum(qty) Value,'Unit Served by Joblist - qty' as src
from FL_JL
join [dbo].[ReportFormat] RF on FL_JL.Stall_BIB = RF.Stall_BIB and  FL_JL.Brand = RF.Brand and FL_JL.MajorGroup = RF.MajorGroupId
and ReportCode = 'USJLBH' and IsTotal = 'MT' 
group by FL_JL.InvoiceDate,FL_JL.InventSiteId,RF.Code
-- unit served MajorGroup total BIB
union all
select InvoiceDate date,InventSiteId,RF.Code report_id,sum(qty) Value,'Unit Served by Joblist - qty' as src
from FL_JL
join [dbo].[ReportFormat] RF on FL_JL.Stall_BIB = RF.Stall_BIB and  FL_JL.Brand = RF.Brand and FL_JL.MajorGroup = RF.MajorGroupId and FL_JL.Joblist = RF.Joblist
and ReportCode = 'USJLB' and IsTotal = 'MT'
group by FL_JL.InvoiceDate,FL_JL.InventSiteId,RF.Code
-- unit served Brand header total BIB
union all
select InvoiceDate date,InventSiteId,RF.Code report_id,sum(qty) Value,'Unit Served by Joblist - qty' as src
from FL_JL
join [dbo].[ReportFormat] RF on FL_JL.Stall_BIB = RF.Stall_BIB and FL_JL.Brand = RF.Brand
and ReportCode = 'USJLBH' and IsTotal = 'BT'
group by FL_JL.InvoiceDate,FL_JL.InventSiteId,RF.Code
-- unit served Brand total BIB
union all
select InvoiceDate date,InventSiteId,RF.Code report_id,sum(qty) Value,'Unit Served by Joblist - qty' as src
from FL_JL
join [dbo].[ReportFormat] RF on FL_JL.Stall_BIB = RF.Stall_BIB and  FL_JL.Brand = RF.Brand and FL_JL.Joblist = RF.Joblist
and ReportCode = 'USJLB' and IsTotal = 'BT'
group by FL_JL.InvoiceDate,FL_JL.InventSiteId,RF.Code
-- unit served Joblist total header BIB
union all
select InvoiceDate date,InventSiteId,RF.Code report_id,sum(qty) Value,'Unit Served by Joblist - qty' as src
from FL_JL
join [dbo].[ReportFormat] RF on FL_JL.Stall_BIB = RF.Stall_BIB and IsTotal = 'GT' and ReportCode = 'USJLBH'
group by FL_JL.InvoiceDate,FL_JL.InventSiteId,RF.Code
-- unit served Joblist total BIB
union all
select InvoiceDate date,InventSiteId,RF.Code report_id,sum(qty) Value,'Unit Served by Joblist - qty' as src
from FL_JL
join [dbo].[ReportFormat] RF on FL_JL.Stall_BIB = RF.Stall_BIB and FL_JL.Joblist = RF.Joblist and IsTotal = 'GT' and ReportCode = 'USJLB'
group by FL_JL.InvoiceDate,FL_JL.InventSiteId,RF.Code

---=== Revenue by category  ===---
-- revenue by category
union all
select InvoiceDate date,InventSiteId,RF.Code report_id,sum(revenue) Value,'revenue per category - revenue' as src
from FL_CAT
join [dbo].[ReportFormat] RF on FL_CAT.Brand = RF.Brand and FL_CAT.MajorGroup = RF.MajorGroupId and FL_CAT.MinorGroupId = RF.MinorGroupId and FL_CAT.Category_name = RF.CategoryName 
and ReportCode = 'REV'
group by FL_CAT.InvoiceDate,FL_CAT.InventSiteId,RF.Code
-- revenue header by category
union all
select InvoiceDate date,InventSiteId,RF.Code report_id,sum(revenue) Value,'revenue per category - revenue' as src
from FL_CAT
join [dbo].[ReportFormat] RF on FL_CAT.Brand = RF.Brand and FL_CAT.MajorGroup = RF.MajorGroupId and FL_CAT.MinorGroupId = RF.MinorGroupId 
and ReportCode = 'REVH'
group by FL_CAT.InvoiceDate,FL_CAT.InventSiteId,RF.Code
-- revenue MajorGroup by category
union all
select InvoiceDate date,InventSiteId,RF.Code report_id,sum(revenue) Value,'revenue per category - revenue' as src
from FL_CAT
join [dbo].[ReportFormat] RF on FL_CAT.Brand = RF.Brand and FL_CAT.MajorGroup = RF.MajorGroupId and FL_CAT.Category_name = RF.CategoryName 
and ReportCode = 'REV' and IsTotal = 'MT'
group by FL_CAT.InvoiceDate,FL_CAT.InventSiteId,RF.Code
-- revenue MajorGroup header by category
union all
select InvoiceDate date,InventSiteId,RF.Code report_id,sum(revenue) Value,'revenue per category - revenue' as src
from FL_CAT
join [dbo].[ReportFormat] RF on FL_CAT.Brand = RF.Brand and FL_CAT.MajorGroup = RF.MajorGroupId
and ReportCode = 'REVH' and IsTotal = 'MT'
group by FL_CAT.InvoiceDate,FL_CAT.InventSiteId,RF.Code
-- revenue Brand by category
union all
select InvoiceDate date,InventSiteId,RF.Code report_id,sum(revenue) Value,'revenue per category - revenue' as src
from FL_CAT
join [dbo].[ReportFormat] RF on FL_CAT.Brand = RF.Brand and FL_CAT.Category_name = RF.CategoryName 
and ReportCode = 'REV' and IsTotal = 'BT'
group by FL_CAT.InvoiceDate,FL_CAT.InventSiteId,RF.Code
-- revenue Brand header by category
union all
select InvoiceDate date,InventSiteId,RF.Code report_id,sum(revenue) Value,'revenue per category - revenue' as src
from FL_CAT
join [dbo].[ReportFormat] RF on FL_CAT.Brand = RF.Brand
and ReportCode = 'REVH' and IsTotal = 'BT'
group by FL_CAT.InvoiceDate,FL_CAT.InventSiteId,RF.Code
-- revenue by category grand total
union all
select InvoiceDate date,InventSiteId,RF.Code report_id,sum(revenue) Value,'revenue per category - revenue' as src
from FL_CAT
join [dbo].[ReportFormat] RF on FL_CAT.Category_name = RF.CategoryName  and IsTotal = 'GT' and ReportCode = 'REV'
group by FL_CAT.InvoiceDate,FL_CAT.InventSiteId,RF.Code
-- revenue by category header grand total
union all
select InvoiceDate date,InventSiteId,RF.Code report_id,sum(revenue) Value,'revenue per category - revenue' as src
from FL_CAT
join [dbo].[ReportFormat] RF on IsTotal = 'GT' and ReportCode = 'REVH'
group by FL_CAT.InvoiceDate,FL_CAT.InventSiteId,RF.Code

-- revenue category BIB
union all
select InvoiceDate date,InventSiteId,RF.Code report_id,sum(revenue) Value,'revenue per category - revenue' as src
from FL_CAT
join [dbo].[ReportFormat] RF on FL_CAT.Stall_BIB = RF.Stall_BIB and FL_CAT.Brand = RF.Brand and FL_CAT.MajorGroup = RF.MajorGroupId and FL_CAT.MinorGroupId = RF.MinorGroupId and FL_CAT.Category_name = RF.CategoryName 
and ReportCode = 'REVB'
group by FL_CAT.InvoiceDate,FL_CAT.InventSiteId,RF.Code
-- revenue header by category BIB
union all
select InvoiceDate date,InventSiteId,RF.Code report_id,sum(revenue) Value,'revenue per category - revenue' as src
from FL_CAT
join [dbo].[ReportFormat] RF on FL_CAT.Stall_BIB = RF.Stall_BIB and FL_CAT.Brand = RF.Brand and FL_CAT.MajorGroup = RF.MajorGroupId and FL_CAT.MinorGroupId = RF.MinorGroupId 
and ReportCode = 'REVBH'
group by FL_CAT.InvoiceDate,FL_CAT.InventSiteId,RF.Code
-- revenue MajorGroup by category BIB
union all
select InvoiceDate date,InventSiteId,RF.Code report_id,sum(revenue) Value,'revenue per category - revenue' as src
from FL_CAT
join [dbo].[ReportFormat] RF on FL_CAT.Stall_BIB = RF.Stall_BIB and FL_CAT.Brand = RF.Brand and FL_CAT.MajorGroup = RF.MajorGroupId and FL_CAT.Category_name = RF.CategoryName 
and ReportCode = 'REVB' and IsTotal = 'MT'
group by FL_CAT.InvoiceDate,FL_CAT.InventSiteId,RF.Code
-- revenue MajorGroup header by category BIB
union all
select InvoiceDate date,InventSiteId,RF.Code report_id,sum(revenue) Value,'revenue per category - revenue' as src
from FL_CAT
join [dbo].[ReportFormat] RF on FL_CAT.Stall_BIB = RF.Stall_BIB and FL_CAT.Brand = RF.Brand and FL_CAT.MajorGroup = RF.MajorGroupId
and ReportCode = 'REVBH' and IsTotal = 'MT'
group by FL_CAT.InvoiceDate,FL_CAT.InventSiteId,RF.Code
-- revenue Brand by category BIB
union all
select InvoiceDate date,InventSiteId,RF.Code report_id,sum(revenue) Value,'revenue per category - revenue' as src
from FL_CAT
join [dbo].[ReportFormat] RF on FL_CAT.Stall_BIB = RF.Stall_BIB and FL_CAT.Brand = RF.Brand and FL_CAT.Category_name = RF.CategoryName 
and ReportCode = 'REVB' and IsTotal = 'BT'
group by FL_CAT.InvoiceDate,FL_CAT.InventSiteId,RF.Code
-- revenue Brand header by category BIB
union all
select InvoiceDate date,InventSiteId,RF.Code report_id,sum(revenue) Value,'revenue per category - revenue' as src
from FL_CAT
join [dbo].[ReportFormat] RF on FL_CAT.Stall_BIB = RF.Stall_BIB and FL_CAT.Brand = RF.Brand
and ReportCode = 'REVBH' and IsTotal = 'BT'
group by FL_CAT.InvoiceDate,FL_CAT.InventSiteId,RF.Code
-- revenue by category grand total BIB
union all
select InvoiceDate date,InventSiteId,RF.Code report_id,sum(revenue) Value,'revenue per category - revenue' as src
from FL_CAT
join [dbo].[ReportFormat] RF on FL_CAT.Stall_BIB = RF.Stall_BIB and FL_CAT.Category_name = RF.CategoryName  and IsTotal = 'GT' and ReportCode = 'REVB'
group by FL_CAT.InvoiceDate,FL_CAT.InventSiteId,RF.Code
-- revenue by category header grand total BIB
union all
select InvoiceDate date,InventSiteId,RF.Code report_id,sum(revenue) Value,'revenue per category - revenue' as src
from FL_CAT
join [dbo].[ReportFormat] RF on FL_CAT.Stall_BIB = RF.Stall_BIB and IsTotal = 'GT' and ReportCode = 'REVBH'
group by FL_CAT.InvoiceDate,FL_CAT.InventSiteId,RF.Code


----=== Revenue by Joblist ===---
---- revenue Joblist
--union all
--select InvoiceDate date,InventSiteId,RF.Code report_id,sum(revenue) Value,'revenue by Joblist - revenue' as src
--from FL_JL
--join [dbo].[ReportFormat] RF on FL_JL.Brand = RF.Brand and FL_JL.MajorGroup = RF.MajorGroupId and FL_JL.MinorGroupId = RF.MinorGroupId and FL_JL.Joblist = RF.Joblist 
--and ReportCode = 'USJLR'
--group by FL_JL.InvoiceDate,FL_JL.InventSiteId,RF.Code
---- revenue Joblist total
--union all
--select InvoiceDate date,InventSiteId,RF.Code report_id,sum(revenue) Value,'revenue by Joblist - revenue' as src
--from FL_JL
--join [dbo].[ReportFormat] RF on FL_JL.Joblist = RF.Joblist and IsTotal = 'GT' and ReportCode = 'USJLR'
--group by FL_JL.InvoiceDate,FL_JL.InventSiteId,RF.Code
----revenue Joblist BIB
--union all
--select InvoiceDate date,InventSiteId,RF.Code report_id,sum(revenue) Value,'revenue by Joblist - revenue' as src
--from FL_JL
--join [dbo].[ReportFormat] RF on FL_JL.Stall_BIB = RF.Stall_BIB and  FL_JL.Brand = RF.Brand and FL_JL.MajorGroup = RF.MajorGroupId and FL_JL.MinorGroupId = RF.MinorGroupId and FL_JL.Joblist = RF.Joblist 
--and ReportCode = 'USJLRB'
--group by FL_JL.InvoiceDate,FL_JL.InventSiteId,RF.Code
---- revenue Joblist total BIB
--union all
--select InvoiceDate date,InventSiteId,RF.Code report_id,sum(revenue) Value,'revenue Joblist - revenue' as src
--from FL_JL
--join [dbo].[ReportFormat] RF on FL_JL.Stall_BIB = RF.Stall_BIB and FL_JL.Joblist = RF.Joblist and IsTotal = 'GT' and ReportCode = 'USJLRB'
--group by FL_JL.InvoiceDate,FL_JL.InventSiteId,RF.Code


---=== Cost per Category ===---
-- cost per category
union all
select InvoiceDate date,InventSiteId,RF.Code report_id,sum(Cost) Value,'cost per category' as src
from FL_CAT
join [dbo].[ReportFormat] RF on 
FL_CAT.Category_name = RF.CategoryName 
and ReportCode = 'CPC'
group by FL_CAT.InvoiceDate,FL_CAT.InventSiteId,RF.Code
-- cost per category header
union all
select InvoiceDate date,InventSiteId,RF.Code report_id,sum(Cost) Value,'cost per category' as src
from FL_CAT
join [dbo].[ReportFormat] RF on ReportCode = 'CPCH'
group by FL_CAT.InvoiceDate,FL_CAT.InventSiteId,RF.Code

-- cost per category bib
union all
select InvoiceDate date,InventSiteId,RF.Code report_id,sum(Cost) Value,'cost per category bib' as src
from FL_CAT
join [dbo].[ReportFormat] RF on FL_CAT.Stall_BIB = RF.Stall_BIB and FL_CAT.Category_name = RF.CategoryName and ReportCode = 'CPCB'
group by FL_CAT.InvoiceDate,FL_CAT.InventSiteId,RF.Code
-- cost per category bib header
union all
select InvoiceDate date,InventSiteId,RF.Code report_id,sum(Cost) Value,'cost per category bib' as src
from FL_CAT
join [dbo].[ReportFormat] RF on FL_CAT.Stall_BIB = RF.Stall_BIB and ReportCode = 'CPCBH'
group by FL_CAT.InvoiceDate,FL_CAT.InventSiteId,RF.Code

---=== Rumus ===---
-- Productivity Mekanik
union all
select 
cast(left(ust.InvoiceDate,4)+'/'+right(ust.InvoiceDate,2)+'/01' as date)InvoiceDate,ust.InventSiteId,RF.Code report_id,
IIF(cast(do.JumlahHariKerja as decimal(8,2))=0,0,cast(ust.Value as decimal(8,2))/cast(do.JumlahMekanik as decimal(8,2))/cast(do.JumlahHariKerja as decimal(8,2))) Value,
'Productivity Mekanik' as src 
from unit_served_total ust
join data_Outlet do on ust.InvoiceDate = do.InvoiceDate and ust.InventSiteId = do.Outlet 
join [dbo].[ReportFormat] RF on RF.ReportCode = 'PM'

-- Productivity Bengkel (Stall & BIB)
union all
select cast(left(ust.InvoiceDate,4)+'/'+right(ust.InvoiceDate,2)+'/01' as date)InvoiceDate,ust.InventSiteId,RF.Code report_id, 

IIF(cast(do.JumlahHariKerja as decimal(8,2))=0 or cast(do.JumlahStall as decimal(8,2)) + cast(do.JumlahBIB as decimal(8,2)) = 0,0,cast(ust.Value as decimal(8,2))/cast(do.JumlahHariKerja as decimal(8,2))/(cast(do.JumlahStall as decimal(8,2)) + cast(do.JumlahBIB as decimal(8,2)))) Value,
'Productivity Bengkel (Stall & BIB)' as src 

from unit_served_total ust
join data_Outlet do on ust.InvoiceDate = do.InvoiceDate and ust.InventSiteId = do.Outlet 
join [dbo].[ReportFormat] RF on RF.ReportCode = 'PBE'

-- Productivity BIB
union all
select cast(left(ust.InvoiceDate,4)+'/'+right(ust.InvoiceDate,2)+'/01' as date)InvoiceDate,ust.InventSiteId,RF.Code report_id,
IIF((IIF(do.JumlahHariKerja=0,0,(do.JumlahBIB/do.JumlahHariKerja)))=0,0,ust.Value/(IIF(do.JumlahHariKerja=0,0,(do.JumlahBIB/do.JumlahHariKerja)))) Value,
--0 as Value,
'Productivity BIB' as src 
from unit_served_total ust
join data_Outlet do on ust.InvoiceDate = do.InvoiceDate and ust.InventSiteId = do.Outlet 
join [dbo].[ReportFormat] RF on RF.ReportCode = 'PBI'

-- REVENUE PART DIRECT
union all
select InvoiceDate date,InventSiteId,RF.Code report_id,sum(revenue) Value,'Revenue part direct' as src
from FL_CAT
join [dbo].[ReportFormat] RF on ReportCode = 'RPD'
where FL_CAT.Category_name = 'Part'
group by FL_CAT.InvoiceDate,FL_CAT.InventSiteId,RF.Code

-- REVENUE PART BAHAN
union all
select InvoiceDate date,InventSiteId,RF.Code report_id,sum(revenue) Value,'Revenue part bahan' as src
from FL_CAT
join [dbo].[ReportFormat] RF on ReportCode = 'RPB'
where FL_CAT.Category_name = 'Bahan' and RIGHT(ItemID,2) = 'AA'
group by FL_CAT.InvoiceDate,FL_CAT.InventSiteId,RF.Code

-- Gross Profit
union all
select FL.InvoiceDate,FL.InventSiteId,RF.Code report_id,(sum(revenue)-sum(cost)) Value,'Gross Profit' as src
from FL
join [dbo].[ReportFormat]  RF on ReportCode = 'GP'
group by FL.InvoiceDate,FL.InventSiteId,RF.Code

-- Gross Profit Margin
union all
select (left(InvoiceDate,7)+'-01') InvoiceDate,FL.InventSiteId,RF.Code report_id,IIF(sum(revenue)=0,0,(sum(revenue)-sum(cost))/sum(revenue))*100 Value,'Gross Profit Margin' as src
from FL
join [dbo].[ReportFormat]  RF on ReportCode = 'GPM'
group by (left(InvoiceDate,7)+'-01'),FL.InventSiteId,RF.Code

-- Gross Profit BIB
union all
select FL.InvoiceDate,FL.InventSiteId,RF.Code report_id,(sum(revenue)-sum(cost)) Value,'Gross Profit' as src
from FL
join [dbo].[ReportFormat]  RF on ReportCode = 'GPB'
where FL.Stall_BIB = 'BIB'
group by FL.InvoiceDate,FL.InventSiteId,RF.Code

-- Gross Profit Margin BIB
union all
select (left(InvoiceDate,7)+'-01') InvoiceDate,FL.InventSiteId,RF.Code report_id,IIF(sum(revenue)=0,0,(sum(revenue)-sum(cost))/sum(revenue))*100 Value,'Gross Profit Margin' as src
from FL
join [dbo].[ReportFormat]  RF on ReportCode = 'GPMB'
where FL.Stall_BIB = 'BIB'
group by (left(InvoiceDate,7)+'-01'),FL.InventSiteId,RF.Code