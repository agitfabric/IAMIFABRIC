-- Auto Generated (Do not modify) 4E3E8BC875AAE5D415A27BF753BB9B3D0ECD99B88E0DD2BD4D2F490372B8D7A9
CREATE view [dbo].[vw_OutletProductivity]
as
select  a.dataAreaId kode_dealer, 
        d.ZDealerSales nama_dealer, 
        c.InventSiteId kode_outlet, 
        d.Name nama_outlet, 
        a.InvoiceDate tanggal_invoice,
        c.SalesPoolIdPublic pool, 
        c.ZSalesType tipe_sales,
        b.ItemId item, 
        f.NameAlias nama_item, 
        b.Qty 
from CustInvoiceJour a
    left join ZCustInvoiceTrans b on b.InvoiceId = a.InvoiceId
    left join SalesTable c on c.SalesId = a.SalesId
    left join ZInventSites d on d.SiteId = c.InventSiteId
    left join InventItemGroupItem e on e.ItemId = b.ItemId and e.ItemDataAreaId = b.dataAreaId
    left join ZInventTables f on f.ItemId = b.ItemId and f.dataAreaId = b.dataAreaId
Where a.dataAreaId = 'ZIR' and e.ItemGroupId = 'FU01' and left(convert(char,a.InvoiceDate,112),6) = '202102'
--order by a.DATAAREAID, c.INVENTSITEID, a.INVOICEDATE