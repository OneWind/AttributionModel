-- date from: '2015-01-01'
-- date to:   '2015-06-30'

select dropif('a', 'feng_tmp')
go

select tb2.datetimemst spotlogtime
     , 1 tvindicator
     , tb1.*
     , tb2.impactalladults
     , tb2.impactadults45plus
     , tb2.length
     , tb2.creative
     , tb2.saleshouse
     , tb2.channel
into a.feng_tmp
from (select *
      from a.feng_uk_factvisits_ucdmid_bwfill
      where trunc(servertimemst) >= '2015-01-01' and trunc(servertimemst) < '2015-07-01'
          and subchannel in ('Paid Search – Brand', 'Paid Search – NonBrand', 'Organic Brand', 'Organic NonBrand', 'Direct Homepage', 'Direct Non-Homepage', 'Geo-Redirect')) tb1
      join (select *
                 , dateadd(minute, 5, datetimemst) datetimeplus5min
            from a.feng_uktv_2014jan_2015jun
            where impactalladults > 0) tb2
      on (tb1.servertimemst < tb2.datetimeplus5min
          and tb1.servertimemst > tb2.datetimemst)
--    join (select *
--               , dateadd(second, 30, datetimemst) datetimeplus30s
--               , dateadd(second, 360, datetimemst) datetimeplus360s
--          from a.feng_uktv_2014jan_2015jun
--          where impactalladults > 0) tb2
--        on (tb1.servertimemst < tb2.datetimeplus360s
--            and tb1.servertimemst >= tb2.datetimeplus30s)
go

--select min(servertimemst - spotlogtime), max(servertimemst - spotlogtime) from a.feng_tmp
--go

select dropif('a', 'feng_uk2015_visitandtv')
go
select *
into a.feng_uk2015_visitandtv
from (
    (
        select cast('1900-01-01 00:00:00' as timestamp) spotlogtime
             , 0 tvindicator
             , *
             , -1 impactalladults
             , -1 impactadults45plus
             , -1 length
             , null creative
             , null saleshouse
             , null channel
        from a.feng_uk_factvisits_ucdmid_bwfill
        where rdnum not in (select rdnum from a.feng_tmp)
            and trunc(servertimemst) >= '2015-01-01' and trunc(servertimemst) < '2015-07-01'
    )
    union
    (
        select * from a.feng_tmp
    )
)
go


select subchannel, count(*) cnt
from a.feng_uk2015_visitandtv
where tvindicator > 0
group by subchannel
go
