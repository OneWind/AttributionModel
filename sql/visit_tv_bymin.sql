select count(*) from a.feng_uk_visit_tv_signup
go

select dropif('a', 'feng_uk_visitbymin_subchannel')
go

select tominute visittime, subchannel, count(*)
into a.feng_uk_visitbymin_subchannel
from (select cast(substr(cast(dateadd(second, 0, servertimemst) as text), 1, 17) || '00' as timestamp) tominute, *
      from a.feng_uk_visit_tv_signup)
group by tominute, subchannel
go

unload ('select * from a.feng_uk_visitbymin_subchannel') to '/mnt/matrix/load/Feng/uk_visitbymin_subchannel.csv' leader delimiter ',' addquotes
go

select dropif('a', 'feng_uk_tvbymin')
go

select tominute visittime, sum(impactalladults) tvimpact
into a.feng_uk_tvbymin
from (select cast(substr(cast(dateadd(second, 0, servertimemst) as text), 1, 17) || '00' as timestamp) tominute, * 
      from a.feng_uk_visit_tv_signup
      where tvcount > 0)
group by tominute
go

unload ('select * from a.feng_uk_tvbymin') to '/mnt/matrix/load/Feng/uk_tvbymin.csv' leader delimiter ',' addquotes
go


select count(*) from a.feng_uk_visitandsignup
go
