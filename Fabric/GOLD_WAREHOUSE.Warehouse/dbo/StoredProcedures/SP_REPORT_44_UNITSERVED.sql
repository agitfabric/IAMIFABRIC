CREATE   PROCEDURE [dbo].[SP_REPORT_44_UNITSERVED]  @Year char(4), @month char(2)
AS
BEGIN

    SET NOCOUNT ON;
    
    DECLARE @FirstDOM date, @LastDOM date

    Set @FirstDOM = CAST(DATEADD(mm, DATEDIFF(mm, 0, @year + @month + '01' ), 0) AS Date) 
    Set @LastDOM = (select dateadd(s,-1,dateadd(mm,datediff(m,0,@FirstDOM)+1,0))) 

    Delete Report_44_UnitServed where Year(InvoiceDate) = @Year and Month(InvoiceDate) = @month

    Insert into Report_44_UnitServed
            
        Select x.dataAreaId, 
               x.InventSiteId, 
               x.InvoiceDate, 
               x.ProjId, 
               x.DeviceId, 
               c.ItemId, 
               d.NameAlias Item_Description, 
               Case 
                   when c.ItemId COLLATE Latin1_General_CI_AS = '9999999999' then 'Merk Lain' 
                   else 'Isuzu' 
               end as Brand,
               d.AMItemMajorGroupId MajorGroup, 
               case 
                   when d.AMItemMinorGroupId COLLATE Latin1_General_CI_AS = '' 
                        and d.AMItemMajorGroupId COLLATE Latin1_General_CI_AS = 'LCV' then 'LCV'
                   when d.AMItemMinorGroupId COLLATE Latin1_General_CI_AS = '' 
                        and d.AMItemMajorGroupId COLLATE Latin1_General_CI_AS = 'CV' then 'CV'
                   else d.AMItemMinorGroupId 
               end as MinorGroupId, 
               case 
                   when x.GroupId COLLATE Latin1_General_CI_AS = 'SM003' 
                        or SUBSTRING(x.WrkCtrId,7,1) COLLATE Latin1_General_CI_AS = 'B' then 'BIB' 
                   else 'Stall' 
               end Stall_BIB,  
               x.GroupId, 
               x.ParentId,  
               case 
                   when x.GroupId COLLATE Latin1_General_CI_AS = 'SM005' 
                        and x.ParentId COLLATE Latin1_General_CI_AS = '' then 1 
                   else 0 
               end as Contract_Qty, 
               case 
                   when x.ParentId COLLATE Latin1_General_CI_AS != '' then 0 
                   else 1 
               end as UnitServed_Qty, 
               x.ProjInvoiceId

    From
    (
        select  a.dataAreaId, 
                left(a.ProjInvoiceProjId,5) as InventSiteId, 
                cast(a.InvoiceDate as date) InvoiceDate, 
                a.ProjInvoiceProjId as ProjId, 
                b.DeviceId, 
                sum(a.qty) as qty, 
                sum(a.InvoiceAmount) InvoiceAmount,
                b.GroupId, 
                b.ParentId, 
                b.WrkCtrId, 
                a.ProjInvoiceId
        from SILVER_WAREHOUSE.dbo.ProjInvoiceJour a
            inner join SILVER_WAREHOUSE.dbo.CaseTable b 
                on b.CaseId COLLATE Latin1_General_CI_AS = a.ProjInvoiceProjId COLLATE Latin1_General_CI_AS
            left join SILVER_WAREHOUSE.dbo.DeviceTable c 
                on c.DeviceId COLLATE Latin1_General_CI_AS = b.DeviceId COLLATE Latin1_General_CI_AS 
               and c.dataAreaId COLLATE Latin1_General_CI_AS = b.dataAreaId COLLATE Latin1_General_CI_AS
        where cast(a.InvoiceDate as date) between @FirstDOM and @LastDOM
          and a.dataAreaId COLLATE Latin1_General_CI_AS <> 'kzu'
        Group by a.dataAreaId, a.ProjInvoiceProjId, b.DeviceId, b.GroupId, b.ParentId, 
                 b.WrkCtrId, cast(a.InvoiceDate as date), a.ProjInvoiceId
    )x
        left join SILVER_WAREHOUSE.dbo.DeviceTable c 
            on c.DeviceId COLLATE Latin1_General_CI_AS = x.DeviceId COLLATE Latin1_General_CI_AS
           and c.dataAreaId COLLATE Latin1_General_CI_AS = x.dataAreaId COLLATE Latin1_General_CI_AS
        left join SILVER_WAREHOUSE.dbo.ZInventTables d 
            on d.ItemId COLLATE Latin1_General_CI_AS = c.ItemId COLLATE Latin1_General_CI_AS
           and d.dataAreaId COLLATE Latin1_General_CI_AS = c.dataAreaId COLLATE Latin1_General_CI_AS
    Where x.InvoiceAmount != 0 
      and c.ItemId COLLATE Latin1_General_CI_AS != ''
    Order by x.ProjId   	 	 

END