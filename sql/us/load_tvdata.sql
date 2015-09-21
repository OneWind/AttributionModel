select dropif('a', 'feng_ustv_2014jan_2015jul')
go

create table a.feng_ustv_2014jan_2015jul (
    Property varchar(100),
    Length int,
    FullRate float8,
    Rate float8,
    Imps float8,
    Network varchar(100),
    UniformNetwork varchar(100),
    ISCI varchar(100),
    ISCIAdjusted varchar(100),
    Creative varchar(100),
    Datetime timestamp
)
GO

GRANT SELECT, INSERT, UPDATE, DELETE ON a.feng_ustv_2014jan_2015jul TO group analysts
GO
GRANT SELECT, INSERT, UPDATE, DELETE ON a.feng_ustv_2014jan_2015jul TO group biteam
GO
GRANT SELECT, INSERT, UPDATE, DELETE ON a.feng_ustv_2014jan_2015jul TO group intlanalysts
GO
GRANT SELECT ON a.feng_ustv_2014jan_2015jul TO tableau
GO

copy a.feng_ustv_2014jan_2015jul from '/mnt/matrix/load/Feng/ustv.csv' 
    delimiter',' 
    removequotes 
    maxerror 0
    ignoreheader 1
    timeformat 'mm/dd/yy hh12:mi AM'
go

select top 100 * from stl_load_errors
order by starttime desc
go

select count(*) from a.feng_ustv_2014jan_2015jul
go
select * from a.feng_ustv_2014jan_2015jul
where network = 'Discovery Family'
go

select distinct(celebrity)
from a.feng_ustv_2014jan_2015jul
go

alter table a.feng_ustv_2014jan_2015jul add datetimemst timestamp
go
update a.feng_ustv_2014jan_2015jul
set datetimemst = dateadd(hour, -2, datetime)
from a.feng_ustv_2014jan_2015jul
go
