select dropif('a', 'feng_tmp')
go

select tb2.datetimemst spotlogtime
     , case when tb2.datetimemst is null then 0 else 1 end
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
          and subchannel in ('Paid Search – Brand', 'Organic Brand', 'Direct Brand')) tb1
   left join (select *
                   , dateadd(second, 30, datetimemst) datetimeplus30s
                   , dateadd(second, 360, datetimemst) datetimeplus360s
              from a.feng_uktv_2014jan_2015may
              where impactalladults > 0) tb2
       on (tb1.servertimemst < tb2.datetimeplus360s
           and tb1.servertimemst >= tb2.datetimeplus30s)
go



select dropif('a', 'feng_uk2015_visitandtv_v2')
go
select *
into a.feng_uk2015_visitandtv_v2
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
            and trunc(servertimemst) >= '2015-01-01' and trunc(servertimemst) < '2015-06-01'
    )
    union
    (
        select * from a.feng_tmp
    )
)
go

select count(*), count(distinct rdnum) from a.feng_uk2015_visitandtv_v2
go
select count(*), count(distinct rdnum) from a.feng_uk2015_visitandtv
go

select subchannel, count(*) cnt
from a.feng_uk2015_visitandtv_v2
where tvindicator > 0
group by subchannel
go

select subchannel, count(*) cnt
from a.feng_uk2015_visitandtv
where tvindicator > 0
group by subchannel
go
