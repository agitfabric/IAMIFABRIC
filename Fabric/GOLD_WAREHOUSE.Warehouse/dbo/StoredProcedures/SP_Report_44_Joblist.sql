CREATE PROCEDURE [dbo].[SP_Report_44_Joblist]  @Year char(4), @month char(2)

AS
BEGIN


	DECLARE @FirstDOM date, @LastDOM date

	Set @FirstDOM = CAST(DATEADD(mm, DATEDIFF(mm, 0, @year + @month + '01' ), 0) AS Date) 
	Set @LastDOM = (select dateadd(s,-1,dateadd(mm,datediff(m,0,@FirstDOM)+1,0))) 

	Delete Report_44_Joblist where ProjInvoiceProjId in  (Select ProjId From Report_44_UnitServed where Year(InvoiceDate) = @Year and Month(InvoiceDate) = @month Group by ProjId)

	Insert into Report_44_Joblist
			
	Select  a.dataAreaId, a.InventSiteID, a.ProjID, b.ActivityNumber, b.Txt, a.CategoryId, a.GroupID as GroupID, Substring(c.OriginJobListId,5,4) OriginJoblistID,
			case when Substring(c.OriginJobListId,5,5) in ('KACAA') or left(a.CategoryId,3) = 'KSG' then 'KSG'
				when a.GroupID = 'SM007' then 'Warranty' 
				when a.CategoryId = 'SV02' then 'OPL'
				when Substring(c.OriginJobListId,5,3) in ('KAA') then 'Service Berkala' 	
				when Substring(c.OriginJobListId,5,5) in ('KADAA') then 'Free Service' 
				when Substring(c.OriginJobListId,5,4) in ('AKLD','BKLD','CKMD','DKMD','EKHD','FKLD','GKLD','HKLD','KAFA') and e.Hours >= 6.5 then 'Heavy Repair' 
					else 'General Repair' end as Joblist,
				a.ParentId, Isnull(b.LineAmount,0) LineAmount,
				case when Isnull(b.LineAmount,0) < 0 then -1 else 1 end as Qty, Isnull(e.Hours,0) as Hours
	from Report_44_Revenue a
		left join SILVER_WAREHOUSE.[dbo].ZProjInvoiceEmpl b on LOWER(b.ProjId) = LOWER(a.ProjID) and LOWER(b.CategoryId) = LOWER(a.CategoryId)
		left join SILVER_WAREHOUSE.[dbo].CaseJoblistTable c on LOWER(c.JobListRelation) = LOWER(b.ProjId) and LOWER(c.ActivityNumber) = LOWER(b.ActivityNumber) and c.JobListRelation != ''
		left join SILVER_WAREHOUSE.[dbo].CaseJoblistHour d on LOWER(d.JobListId) = LOWER(c.JobListId) and LOWER(d.dataAreaId) = LOWER(c.dataAreaId)
		left join SILVER_WAREHOUSE.[dbo].CaseOprTable e on LOWER(e.OprId) = LOWER(d.OprId) and LOWER(e.dataAreaId) = LOWER(d.dataAreaId)
	Where a.CategoryId not in ('SP01', 'SP02') and cast(b.InvoiceDate as date) between @FirstDOM and @LastDOM
	Order by a.ProjID
	
END