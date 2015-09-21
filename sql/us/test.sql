select datetimemst, count(*) cnt
from a.feng_uktv_2014jan_2015jun
where trunc(datetimemst) = '2015-01-05'
group by datetimemst
go


select top 2000 * 
from a.feng_us2015_visitandtv
where ustimezone = 'non-us'
go


select top 1000 substr(cast(servertimemst as varchar(100)), 1, 17) || '00', *
from a.feng_us_factvisits_ucdmid_bwfill
go

select ustimezone, count(*)
from a.feng_tmp_eastcoast
group by ustimezone
go


select count(distinct dt)
from (
( select datetime dt from a.feng_ustv_2014jan_2015jul
  where trunc(datetime) >= '2015-02-01' and trunc(datetime) <= '2015-07-31')
union
( select dateadd(min, 1, datetime) dt from a.feng_ustv_2014jan_2015jul
  where trunc(datetime) >= '2015-02-01' and trunc(datetime) <= '2015-07-31')
union
( select dateadd(min, 2, datetime) dt from a.feng_ustv_2014jan_2015jul
  where trunc(datetime) >= '2015-02-01' and trunc(datetime) <= '2015-07-31')
union
( select dateadd(min, 3, datetime) dt from a.feng_ustv_2014jan_2015jul
  where trunc(datetime) >= '2015-02-01' and trunc(datetime) <= '2015-07-31')
union
( select dateadd(min, 4, datetime) dt from a.feng_ustv_2014jan_2015jul
  where trunc(datetime) >= '2015-02-01' and trunc(datetime) <= '2015-07-31')
)
go

select dateadd(min, 1, datetime)
from a.feng_ustv_2014jan_2015jul
where trunc(datetime) >= '2015-02-01'
    and trunc(datetime) <= '2015-07-31'
go


select servertimemst, ucdmid, visitorid
from a.feng_uk_factvisits_ucdmid_bwfill
where visitorid = 725894793
go



select distinct subchannel
into a.feng_tvchannel
from a.feng_us2015_visitandtv
where tvindicator > 0
go

select dropif('a', 'feng_tvchannel_visitbymin')
go

select tvindicator, timeuptominstr, count(*) cnt
into a.feng_tvchannel_visitbymin
from
    ( select substr(cast(servertimemst as varchar(100)), 1, 17) || '00' timeuptominstr
           , *
      from a.feng_us2015_visitandtv
      where subchannel in (select subchannel from a.feng_tvchannel)
        and ustimezone in ('EST', 'CST')
    )
group by tvindicator, timeuptominstr
go
