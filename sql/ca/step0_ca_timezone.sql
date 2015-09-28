
select tb2.visitregionid, tb2.visitregiondescription, count(*) cnt
from p.fact_visits tb1
    join p.dim_visitregion tb2 on tb1.visitregionid = tb2.visitregionid
where visitcountryid = 95
group by tb2.visitregionid, tb2.visitregiondescription
go


select dropif('a', 'feng_ca_timezones')
go

create table a.feng_ca_timezones (
    visitregionid integer,
    visitregiondescription varchar(100),
    state varchar(100),
    catimezone varchar(100)
)
go


GRANT SELECT, INSERT, UPDATE, DELETE ON a.feng_ca_timezones TO group analysts
GO
GRANT SELECT, INSERT, UPDATE, DELETE ON a.feng_ca_timezones TO group biteam
GO
GRANT SELECT, INSERT, UPDATE, DELETE ON a.feng_ca_timezones TO group intlanalysts
GO
GRANT SELECT ON a.feng_ca_timezones TO tableau
GO

copy a.feng_ca_timezones from '/mnt/matrix/load/Feng/CAstates.csv' 
    delimiter ',' 
    maxerror 0
    removequotes
    ignoreheader 1
go

select * from a.feng_ca_timezones
go
