--- not all spot time ends with 00 --


select dropif('a', 'feng_catv_2014jan_2015jul')
go

create table a.feng_catv_2014jan_2015jul (
    Network varchar(100),
    Property varchar(100),
    Length int,
    Imps float8,
    ISCI varchar(100),
    Creative varchar(100),
    Datetime timestamp,
    Datetimemst timestamp
)
GO

GRANT SELECT, INSERT, UPDATE, DELETE ON a.feng_catv_2014jan_2015jul TO group analysts
GO
GRANT SELECT, INSERT, UPDATE, DELETE ON a.feng_catv_2014jan_2015jul TO group biteam
GO
GRANT SELECT, INSERT, UPDATE, DELETE ON a.feng_catv_2014jan_2015jul TO group intlanalysts
GO
GRANT SELECT ON a.feng_catv_2014jan_2015jul TO tableau
GO

copy a.feng_catv_2014jan_2015jul from '/mnt/matrix/load/Feng/catv.csv' 
    delimiter',' 
    removequotes 
    maxerror 0
    ignoreheader 1
    timeformat 'yyyy-mm-dd hh24:mi:ss'
go

select top 100 * from stl_load_errors
order by starttime desc
go


select top 20 *
from a.feng_catv_2014jan_2015jul
go

