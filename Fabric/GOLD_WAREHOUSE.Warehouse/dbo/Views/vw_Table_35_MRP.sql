-- Auto Generated (Do not modify) C6A66A12CFC2447F13569AC9D826B48FC60960038D45656EB0E076E40D3B6C11
CREATE VIEW [dbo].[vw_Table_35_MRP]
AS
SELECT        a.dataAreaId, a.ZDemandMonth AS DemandMonth, a.ZDemandYear AS DemandYear, b.ZInventSiteId AS InventSiteId, b.ZInventLocationId AS InventLocationId, b.ZItemId AS ItemId, b.ZMRPABCCode AS ABCCode, 
                         b.ZQtyDemand AS QtyDemand1Month, (b.ZQtyDemand + b.ZQtyDemandPrev01 + b.ZQtyDemandPrev02 + b.ZQtyDemandPrev03 + b.ZQtyDemandPrev04 + b.ZQtyDemandPrev05) / 6 AS QtyDemand6Month, 
                         CASE WHEN a.ZDemandMonth = 'January' THEN CAST(a.ZDemandYear AS char(4)) + '1' WHEN a.ZDemandMonth = 'February' THEN CAST(a.ZDemandYear AS char(4)) 
                         + '2' WHEN a.ZDemandMonth = 'March' THEN CAST(a.ZDemandYear AS char(4)) + '3' WHEN a.ZDemandMonth = 'April' THEN CAST(a.ZDemandYear AS char(4)) 
                         + '4' WHEN a.ZDemandMonth = 'May' THEN CAST(a.ZDemandYear AS char(4)) + '5' WHEN a.ZDemandMonth = 'June' THEN CAST(a.ZDemandYear AS char(4)) 
                         + '6' WHEN a.ZDemandMonth = 'July' THEN CAST(a.ZDemandYear AS char(4)) + '7' WHEN a.ZDemandMonth = 'August' THEN CAST(a.ZDemandYear AS char(4)) 
                         + '8' WHEN a.ZDemandMonth = 'September' THEN CAST(a.ZDemandYear AS char(4)) + '9' WHEN a.ZDemandMonth = 'October' THEN CAST(a.ZDemandYear AS char(4)) 
                         + '10' WHEN a.ZDemandMonth = 'November' THEN CAST(a.ZDemandYear AS char(4)) + '11' WHEN a.ZDemandMonth = 'December' THEN CAST(a.ZDemandYear AS char(4)) + '12' END AS DemandYearMonth, 
                         CASE WHEN lower(b.ZMRPABCCode) IN ('a', 'b') THEN 'Fast Moving' WHEN lower(b.ZMRPABCCode) = 'c' THEN 'Medium Moving' WHEN lower(b.ZMRPABCCode) 
                         = 'c' THEN 'Slow Moving' WHEN lower(b.ZMRPABCCode) IN ('e', 'x', 'n') THEN 'No Moving' END AS ABCClassification
FROM            dbo.ZMRPDemandHeader AS a LEFT OUTER JOIN
                         dbo.ZMRPDemandLine AS b ON b.ZMRPDemandHeader1 = a.RecordId
WHERE        (b.ZInventSiteId IS NOT NULL) --AND (a.ZDemandYear = '2019')