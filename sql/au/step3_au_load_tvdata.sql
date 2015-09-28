select dropif('a', 'feng_autv_2015jan_2015aug')
go

create table a.feng_autv_2015jan_2015aug (
    Datetimelocal timestamp,
    Timezone varchar(100),
    Impacts int,
    datetimemst timestamp
)
GO

GRANT SELECT, INSERT, UPDATE, DELETE ON a.feng_autv_2015jan_2015aug TO group analysts
GO
GRANT SELECT, INSERT, UPDATE, DELETE ON a.feng_autv_2015jan_2015aug TO group biteam
GO
GRANT SELECT, INSERT, UPDATE, DELETE ON a.feng_autv_2015jan_2015aug TO group intlanalysts
GO
GRANT SELECT ON a.feng_autv_2015jan_2015aug TO tableau
GO

copy a.feng_autv_2015jan_2015aug from '/mnt/matrix/load/Feng/autv.csv' 
    delimiter',' 
    removequotes 
    maxerror 0
    ignoreheader 1
    timeformat 'yyyy-mm-dd hh24:mi:ss'
go

--select top 100 * from stl_load_errors
--order by starttime desc
--go

select top 20 * from a.feng_autv_2015jan_2015aug
go
