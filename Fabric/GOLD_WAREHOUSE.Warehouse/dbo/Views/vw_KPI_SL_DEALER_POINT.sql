-- Auto Generated (Do not modify) 6826F560C60E71B6E48D12EE1B940E97D42EA0C304C8A2494429CE7D54DA58B6
CREATE VIEW [dbo].[vw_KPI_SL_DEALER_POINT]
AS
WITH dealeractual AS (SELECT        a.Yearmonth, a.year, a.month, b.DealerCode, b.DealerName, a.Series, SUM(a.begin_stock) AS begin_stock, SUM(a.net_eus) AS net_eus, SUM(a.endstock) AS endstock, SUM(a.eus) AS eus, 
                                                                           SUM(a.eus_1) AS eus_1, SUM(a.eus_2) AS eus_2, CASE WHEN (SUM(a.eus) + SUM(a.eus_1) + SUM(a.eus_2)) = 0 THEN 0 ELSE ROUND(SUM(a.endstock) / ((SUM(a.eus) + SUM(a.eus_1) 
                                                                           + SUM(a.eus_2)) / 3.0), 2) END AS stock_level_actual
                                                 FROM            dbo.KPI_SL_OUTLET_POINT AS a LEFT OUTER JOIN
                                                                           dbo.vw_zInventSite AS b ON a.kode_outlet = b.OutletCode
                                                 GROUP BY b.DealerCode, a.Series, b.DealerName, a.Yearmonth, a.year, a.month)
    SELECT        a.Yearmonth, a.year, a.month, a.DealerCode, a.DealerName, a.Series, a.begin_stock, a.net_eus, a.endstock, a.eus, a.eus_1, a.eus_2, a.stock_level_actual, b.Value AS Stock_level_Target, 
                              CASE WHEN a.stock_level_actual < 1.1 THEN 1 WHEN a.stock_level_actual >= 1.4 THEN 5 ELSE 3 END AS stock_level_point, GETDATE() AS last_update, ROUND(a.stock_level_actual / b.Value, 4) 
                              AS Achievement
     FROM            dealeractual AS a LEFT OUTER JOIN
                              dbo.STG_STOCKLEVEL_DEALER_TARGET_pbi AS b ON a.DealerCode = b.KodeDealer AND a.Series = b.Series AND a.year = b.Tahun AND a.month = b.Month