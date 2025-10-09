CREATE PROCEDURE [dbo].[SP_DEVICEMODEL]
AS
BEGIN

Delete DeviceModel
insert into DeviceModel
select * from SILVER_WAREHOUSE.dbo.DeviceModel

END