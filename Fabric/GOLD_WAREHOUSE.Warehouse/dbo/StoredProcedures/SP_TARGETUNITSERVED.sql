CREATE PROCEDURE [dbo].[SP_TARGETUNITSERVED]
AS
BEGIN

Delete TargetUnitServed
insert into TargetUnitServed
select * from SILVER_WAREHOUSE.dbo.TargetUnitServed

END