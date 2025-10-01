CREATE PROCEDURE [dbo].[SP_REPORT_52_SPVSALESMAN] 
AS
BEGIN

    SET NOCOUNT ON;
       
    DECLARE @RunningDate CHAR(6);

    -- contoh set otomatis, offset ke Jakarta
    --SET @RunningDate = FORMAT(DATEADD(HOUR,7,GETDATE()), 'yyyyMM');

    Update Report_52_SPVSalesman
    Set LastSales = Case 
            when FirstDateOutlet < JoinDate 
                then ISNULL(c.LastSales, a.JoinDate) 
            else ISNULL(c.LastSales, b.FirstDateOutlet) 
        end,
        Idle = Case 
            when FirstDateOutlet < JoinDate 
                then DATEDIFF(month, ISNULL(c.LastSales, a.JoinDate), @RunningDate + '01') 
            else DATEDIFF(month, ISNULL(c.LastSales, b.FirstDateOutlet), @RunningDate + '01') 
        end
    From Report_52_SPVSalesman a
        Left join (
            select MIN(DATEADD(d, 1, EOMONTH(DatePhysical))) FirstDateOutlet, 
                   b.InventSiteId
            from SILVER_WAREHOUSE.dbo.InventTrans a
                left join SILVER_WAREHOUSE.dbo.Dim b 
                    on LOWER(b.inventDimId) COLLATE Latin1_General_CI_AS = LOWER(a.inventDimId) COLLATE Latin1_General_CI_AS
            where cast(DatePhysical as date) > '1900-01-01' 
            group by b.InventSiteId
        ) b 
            on b.InventSiteId COLLATE Latin1_General_CI_AS = a.Outlet COLLATE Latin1_General_CI_AS
        Left join (
            select CAST(MAX(a.InvoiceDate) as Date) LastSales, 
                   ZSalesman
            from SILVER_WAREHOUSE.dbo.ZCustInvoiceTrans a
                left outer join SILVER_WAREHOUSE.dbo.InventItemGroupItem b   
                    on LOWER(b.ItemId) COLLATE Latin1_General_CI_AS = LOWER(a.ItemId) COLLATE Latin1_General_CI_AS  
                   and LOWER(b.ItemDataAreaId) COLLATE Latin1_General_CI_AS = LOWER(a.dataAreaId) COLLATE Latin1_General_CI_AS
                left outer join SILVER_WAREHOUSE.dbo.ZSalesOrderHeader c  
                    on LOWER(c.SalesId) COLLATE Latin1_General_CI_AS = LOWER(a.SalesId) COLLATE Latin1_General_CI_AS
            where a.dataAreaId COLLATE Latin1_General_CI_AS <> 'kzu'
              and c.ZSalesType COLLATE Latin1_General_CI_AS = 'FU'
              and b.ItemGroupId COLLATE Latin1_General_CI_AS = 'FU01'
              and LEFT(CONVERT(char, a.InvoiceDate, 112), 6) <= @RunningDate
            group by ZSalesman
        ) c 
            on LOWER(c.ZSalesman) COLLATE Latin1_General_CI_AS = LOWER(a.USERIDSALESMAN) COLLATE Latin1_General_CI_AS
    where RunningDate COLLATE Latin1_General_CI_AS = @RunningDate COLLATE Latin1_General_CI_AS;

END