-- date from: '2015-01-01'
-- date to:   '2015-07-31'

select dropif('a', 'feng_tmp_eastcoast')
go

select tb2.datetimemst spotlogtime
     , 1 tvindicator
     , tb1.*
     , tb2.imps
     , tb2.length
     , tb2.creative
     , tb2.network
     , tb2.property
into a.feng_tmp_eastcoast
from (select *
      from a.feng_us_factvisits_ucdmid_bwfill
      where trunc(servertimemst) >= '2015-01-01' and trunc(servertimemst) < '2015-08-01'
          and subchannel in ('Paid Search – Brand', 'Paid Search – NonBrand', 'Organic Brand', 'Organic NonBrand', 'Direct Homepage', 'Direct Non-Homepage', 'Geo-Redirect')
          and (ustimezone = 'EST' or ustimezone = 'CST')) tb1
      join (select *, dateadd(minute, 5, datetimemst) datetimeplus5min
            from a.feng_ustv_2014jan_2015jul
            where trunc(datetimemst) >= '2015-01-01') tb2
      on (tb1.servertimemst < tb2.datetimeplus5min
          and tb1.servertimemst > tb2.datetimemst)
--    join (select *
--               , dateadd(second, 30, datetimemst) datetimeplus30s
--               , dateadd(second, 360, datetimemst) datetimeplus360s
--          from a.feng_ustv_2014jan_2015jul
--          where celebrity = ''
--              and trunc(datetimemst) >= '2015-01-01') tb2
--        on (tb1.servertimemst < tb2.datetimeplus360s
--            and tb1.servertimemst >= tb2.datetimeplus30s)
go


select dropif('a', 'feng_tmp_westcoast')
go

select tb2.datetimemst spotlogtime
     , 1 tvindicator
     , tb1.*
     , tb2.imps
     , tb2.length
     , tb2.creative
     , tb2.network
     , tb2.property
into a.feng_tmp_westcoast
from (select *
      from a.feng_us_factvisits_ucdmid_bwfill
      where trunc(servertimemst) >= '2015-01-01' and trunc(servertimemst) < '2015-08-01'
          and subchannel in ('Paid Search – Brand', 'Paid Search – NonBrand', 'Organic Brand', 'Organic NonBrand', 'Direct Homepage', 'Direct Non-Homepage', 'Geo-Redirect')
          and (ustimezone = 'PST' or ustimezone = 'MST')) tb1
      join (select *, dateadd(minute, 5, datetimemst) datetimeplus5min
            from a.feng_ustv_2014jan_2015jul
            where trunc(datetimemst) >= '2015-01-01') tb2
      on (tb1.servertimemst < tb2.datetimeplus5min
          and tb1.servertimemst > tb2.datetimemst)
--    join (select *
--               , dateadd(second, 30, dateadd(hour, 1, datetimemst)) datetimeplus30s
--               , dateadd(second, 360, dateadd(hour, 1, datetimemst)) datetimeplus360s
--          from a.feng_ustv_2014jan_2015jul
--          where celebrity = ''
--              and trunc(datetimemst) >= '2015-01-01') tb2
--        on (tb1.servertimemst < tb2.datetimeplus360s
--            and tb1.servertimemst >= tb2.datetimeplus30s)
go




select dropif('a', 'feng_us2015_visitandtv')
go
select *
into a.feng_us2015_visitandtv
from (
    (
        select cast('1900-01-01 00:00:00' as timestamp) spotlogtime
             , 0 tvindicator
             , *
             , -1 imps
             , -1 length
             , null creative
             , null "network"
             , null property
        from a.feng_us_factvisits_ucdmid_bwfill
        where rdnum not in (select rdnum from a.feng_tmp_eastcoast)
            and rdnum not in (select rdnum from a.feng_tmp_westcoast)
            and trunc(servertimemst) >= '2015-01-01' and trunc(servertimemst) < '2015-08-01'
    )
    union
    (
        select * from a.feng_tmp_eastcoast
    )
    union
    (
        select * from a.feng_tmp_westcoast
    )
)
go


--------------------------------------------------------------------------------

select count(*) from a.feng_us2015_visitandtv
where subchannel in ('Paid Search – Brand', 'Paid Search – NonBrand', 'Organic Brand', 'Organic NonBrand', 'Direct Homepage', 'Direct Non-Homepage', 'Geo-Redirect')
    and tvindicator = 0
go

select count(*) from a.feng_us2015_visitandtv
where subchannel in ('Paid Search – Brand', 'Paid Search – NonBrand', 'Organic Brand', 'Organic NonBrand', 'Direct Homepage', 'Direct Non-Homepage', 'Geo-Redirect')
    and tvindicator > 0
go

select subchannel, count(*) cnt
from a.feng_us2015_visitandtv
where tvindicator > 0
group by subchannel
go
 