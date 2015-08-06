select dropif('a', 'feng_uktv_2014jan_2015jun')
go

create table a.feng_uktv_2014jan_2015jun (
    datetimemst timestamp,
    Date varchar(100),
    Time varchar(100),
    TimeZone varchar(100),
    Day varchar(100),
    DayPart varchar(100),
    Market varchar(100),
    Platform varchar(100),
    SalesHouse varchar(100),
    Channel varchar(100),
    Programme varchar(100),
    Product varchar(100),
    LinkKey varchar(100),
    Length int,
    Position varchar(100),
    AdGroup varchar(100),
    Creative varchar(100),
    GrossCost float8,
    ClientCost float8,
    ImpactAllAdults int,
    ImpactAdults45Plus int
)
GO

GRANT SELECT, INSERT, UPDATE, DELETE ON a.feng_uktv_2014jan_2015jun TO group analysts
GO
GRANT SELECT, INSERT, UPDATE, DELETE ON a.feng_uktv_2014jan_2015jun TO group biteam
GO
GRANT SELECT, INSERT, UPDATE, DELETE ON a.feng_uktv_2014jan_2015jun TO group intlanalysts
GO
GRANT SELECT ON a.feng_uktv_2014jan_2015jun TO tableau
GO

copy a.feng_uktv_2014jan_2015jun from '/mnt/matrix/load/Feng/UKTV_2014Jan_2015Jun_MST.csv' 
    delimiter',' 
    removequotes 
    maxerror 0
go

select top 100 * from stl_load_errors
order by starttime desc
go

select count(*) from a.feng_uktv_2014jan_2015jun
go
select top 100 * from a.feng_uktv_2014jan_2015jun
go

--------------------------------------------------------------------------------

select dropif('a', 'feng_uktv_2014jan_2015jun_populated')
go

create table a.feng_uktv_2014jan_2015jun_populated (
    datetimemst timestamp,
    PF_Satellite int,
    PF_Terrestria int,
    SH_C4Digital int,
    SH_SKY int,
    SH_ITVDigital int,
    SH_C5Digital int,
    SH_ITV int,
    SH_ITVBreakfast int,
    SH_Channel4 int,
    SH_Channel5 int,
    LT_20 int,
    LT_30 int,
    CT_WW1AlternativeCut int,
    CT_WW1 int,
    CT_Postman int,
    CT_FollowTheLeaf int,
    CT_TravelWoman int,
    CT_FreeAccess int,
    CT_Remembrance int,
    CT_TravelWoman30FreeTrial int,
    CT_PostmanFreeAccess int,
    CT_ComingHomeFree14DayTrial int,
    CT_ComingHome int
)
GO

GRANT SELECT, INSERT, UPDATE, DELETE ON a.feng_uktv_2014jan_2015jun_populated TO group analysts
GO
GRANT SELECT, INSERT, UPDATE, DELETE ON a.feng_uktv_2014jan_2015jun_populated TO group biteam
GO
GRANT SELECT, INSERT, UPDATE, DELETE ON a.feng_uktv_2014jan_2015jun_populated TO group intlanalysts
GO
GRANT SELECT ON a.feng_uktv_2014jan_2015jun_populated TO tableau
GO

copy a.feng_uktv_2014jan_2015jun_populated from '/mnt/matrix/load/Feng/UKTV_2014Jan_2015Jun_Populated.csv' 
    delimiter',' 
    removequotes 
    ignoreheader 1
    maxerror 0
go

select count(*) from a.feng_uktv_2014jan_2015jun_populated
go
select sum(pf_satellite) + sum(pf_terrestria), sum(lt_20) + sum(lt_30)
from a.feng_uktv_2014jan_2015jun_populated
go

select * from a.feng_uktv_2014jan_2015jun_populated
where trunc(datetimemst) = '2015-05-01'
go

alter table a.feng_uktv_2014jan_2015jun_populated add tv int
go
update a.feng_uktv_2014jan_2015jun_populated
set tv = case when pf_satellite + pf_terrestria > 0 then 1 else 0 end 
from a.feng_uktv_2014jan_2015jun_populated
go




---------------------------------------------------------------------------------
select dropif('a', 'feng_uktv_2014jan_2015jun_expand')
go

create table a.feng_uktv_2014jan_2015jun_expand (
    datetimemst timestamp,
    Date varchar(100),
    Time varchar(100),
    TimeZone varchar(100),
    Day varchar(100),
    DayPart varchar(100),
    Market varchar(100),
    Platform varchar(100),
    SalesHouse varchar(100),
    Channel varchar(100),
    Programme varchar(100),
    Product varchar(100),
    LinkKey varchar(100),
    Length int,
    Position varchar(100),
    AdGroup varchar(100),
    Creative varchar(100),
    GrossCost float8,
    ClientCost float8,
    ImpactAllAdults int,
    ImpactAdults45Plus int
)
GO

GRANT SELECT, INSERT, UPDATE, DELETE ON a.feng_uktv_2014jan_2015jun_expand TO group analysts
GO
GRANT SELECT, INSERT, UPDATE, DELETE ON a.feng_uktv_2014jan_2015jun_expand TO group biteam
GO
GRANT SELECT, INSERT, UPDATE, DELETE ON a.feng_uktv_2014jan_2015jun_expand TO group intlanalysts
GO
GRANT SELECT ON a.feng_uktv_2014jan_2015jun_expand TO tableau
GO

copy a.feng_uktv_2014jan_2015jun_expand from '/mnt/matrix/load/Feng/UKTV_2014Jan_2015Jun_MST_expand.csv' 
    delimiter',' 
    removequotes 
    maxerror 0
go

select top 100 * from stl_load_errors
order by starttime desc
go

select count(*) from a.feng_uktv_2014jan_2015jun_expand
go
select top 100 * from a.feng_uktv_2014jan_2015jun_expand
go

select count(distinct datetimemst)
from a.feng_uktv_2014jan_2015jun_expand
where trunc(datetimemst) = '2015-01-01'
go
