select tb2.visitregionid, tb2.visitregiondescription, count(*)
from 
(select *
from p.fact_visits
where visitcountryid = 95 and siteid = 3717) tb1
    join p.dim_visitregion tb2 on tb1.visitregionid = tb2.visitregionid
group by 1, 2



select dropif('a', 'feng_ca_timezones')
go

create table a.feng_ca_timezones (
    visitregionid integer,
    visitregiondescription varchar(100),
    states varchar(100),
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
