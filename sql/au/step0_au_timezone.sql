
select tb2.visitregionid, tb2.visitregiondescription, count(*) cnt
from p.fact_visits tb1
    join p.dim_visitregion tb2 on tb1.visitregionid = tb2.visitregionid
where visitcountryid = 43
group by tb2.visitregionid, tb2.visitregiondescription
go


select dropif('a', 'feng_au_timezones')
go

create table a.feng_au_timezones (
    visitregionid integer,
    visitregiondescription varchar(100),
    cnt integer,
    fulldescription varchar(100),
    autimezone varchar(100)
)
go


GRANT SELECT, INSERT, UPDATE, DELETE ON a.feng_au_timezones TO group analysts
GO
GRANT SELECT, INSERT, UPDATE, DELETE ON a.feng_au_timezones TO group biteam
GO
GRANT SELECT, INSERT, UPDATE, DELETE ON a.feng_au_timezones TO group intlanalysts
GO
GRANT SELECT ON a.feng_au_timezones TO tableau
GO

copy a.feng_au_timezones from '/mnt/matrix/load/Feng/AUstates.csv' 
    delimiter ',' 
    maxerror 0
    removequotes
    ignoreheader 1
go

select * from a.feng_au_timezones
go
