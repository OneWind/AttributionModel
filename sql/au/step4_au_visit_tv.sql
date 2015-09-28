select dropif('a', 'feng_tmp_nsw')
go

select tb2.datetimemst spotlogtime
     , 1 tvindicator
     , tb1.*
into a.feng_tmp_nsw
from (select *
      from a.feng_au_factvisits_ucdmid_bwfill
      where trunc(servertimemst) >= '2015-01-01' and trunc(servertimemst) < '2015-08-01'
          and subchannel in ('Paid Search – Brand', 'Paid Search – NonBrand', 'Organic Brand', 'Organic NonBrand', 'Direct Homepage', 'Direct Non-Homepage', 'Geo-Redirect')
          and autimezone = 'NSW') tb1
      join (select *, dateadd(minute, 5, datetimemst) datetimeplus5min
            from a.feng_autv_2015jan_2015aug
            where trunc(datetimemst) >= '2015-01-01' and trunc(datetimemst) < '2015-08-01'
                and timezone = 'NSW') tb2
      on (tb1.servertimemst < tb2.datetimeplus5min
          and tb1.servertimemst > tb2.datetimemst)
go

select dropif('a', 'feng_tmp_south')
go

select tb2.datetimemst spotlogtime
     , 1 tvindicator
     , tb1.*
into a.feng_tmp_south
from (select *
      from a.feng_au_factvisits_ucdmid_bwfill
      where trunc(servertimemst) >= '2015-01-01' and trunc(servertimemst) < '2015-08-01'
          and subchannel in ('Paid Search – Brand', 'Paid Search – NonBrand', 'Organic Brand', 'Organic NonBrand', 'Direct Homepage', 'Direct Non-Homepage', 'Geo-Redirect')
          and autimezone = 'South') tb1
      join (select *, dateadd(minute, 5, datetimemst) datetimeplus5min
            from a.feng_autv_2015jan_2015aug
            where trunc(datetimemst) >= '2015-01-01' and trunc(datetimemst) < '2015-08-01'
                and timezone = 'South') tb2
      on (tb1.servertimemst < tb2.datetimeplus5min
          and tb1.servertimemst > tb2.datetimemst)
go


select dropif('a', 'feng_tmp_west')
go

select tb2.datetimemst spotlogtime
     , 1 tvindicator
     , tb1.*
into a.feng_tmp_west
from (select *
      from a.feng_au_factvisits_ucdmid_bwfill
      where trunc(servertimemst) >= '2015-01-01' and trunc(servertimemst) < '2015-08-01'
          and subchannel in ('Paid Search – Brand', 'Paid Search – NonBrand', 'Organic Brand', 'Organic NonBrand', 'Direct Homepage', 'Direct Non-Homepage', 'Geo-Redirect')
          and autimezone = 'West') tb1
      join (select *, dateadd(minute, 5, datetimemst) datetimeplus5min
            from a.feng_autv_2015jan_2015aug
            where trunc(datetimemst) >= '2015-01-01' and trunc(datetimemst) < '2015-08-01'
                and timezone = 'West') tb2
      on (tb1.servertimemst < tb2.datetimeplus5min
          and tb1.servertimemst > tb2.datetimemst)
go

select dropif('a', 'feng_tmp_queensland')
go

select tb2.datetimemst spotlogtime
     , 1 tvindicator
     , tb1.*
into a.feng_tmp_queensland
from (select *
      from a.feng_au_factvisits_ucdmid_bwfill
      where trunc(servertimemst) >= '2015-01-01' and trunc(servertimemst) < '2015-08-01'
          and subchannel in ('Paid Search – Brand', 'Paid Search – NonBrand', 'Organic Brand', 'Organic NonBrand', 'Direct Homepage', 'Direct Non-Homepage', 'Geo-Redirect')
          and autimezone = 'Queensland') tb1
      join (select *, dateadd(minute, 5, datetimemst) datetimeplus5min
            from a.feng_autv_2015jan_2015aug
            where trunc(datetimemst) >= '2015-01-01' and trunc(datetimemst) < '2015-08-01'
                and timezone = 'Queensland') tb2
      on (tb1.servertimemst < tb2.datetimeplus5min
          and tb1.servertimemst > tb2.datetimemst)
go

select dropif('a', 'feng_tmp_tasmania')
go

select tb2.datetimemst spotlogtime
     , 1 tvindicator
     , tb1.*
into a.feng_tmp_tasmania
from (select *
      from a.feng_au_factvisits_ucdmid_bwfill
      where trunc(servertimemst) >= '2015-01-01' and trunc(servertimemst) < '2015-08-01'
          and subchannel in ('Paid Search – Brand', 'Paid Search – NonBrand', 'Organic Brand', 'Organic NonBrand', 'Direct Homepage', 'Direct Non-Homepage', 'Geo-Redirect')
          and autimezone = 'Tasmania') tb1
      join (select *, dateadd(minute, 5, datetimemst) datetimeplus5min
            from a.feng_autv_2015jan_2015aug
            where trunc(datetimemst) >= '2015-01-01' and trunc(datetimemst) < '2015-08-01'
                and timezone = 'Tasmania') tb2
      on (tb1.servertimemst < tb2.datetimeplus5min
          and tb1.servertimemst > tb2.datetimemst)
go


select dropif('a', 'feng_tmp_victoria')
go

select tb2.datetimemst spotlogtime
     , 1 tvindicator
     , tb1.*
into a.feng_tmp_victoria
from (select *
      from a.feng_au_factvisits_ucdmid_bwfill
      where trunc(servertimemst) >= '2015-01-01' and trunc(servertimemst) < '2015-08-01'
          and subchannel in ('Paid Search – Brand', 'Paid Search – NonBrand', 'Organic Brand', 'Organic NonBrand', 'Direct Homepage', 'Direct Non-Homepage', 'Geo-Redirect')
          and autimezone = 'Victoria') tb1
      join (select *, dateadd(minute, 5, datetimemst) datetimeplus5min
            from a.feng_autv_2015jan_2015aug
            where trunc(datetimemst) >= '2015-01-01' and trunc(datetimemst) < '2015-08-01'
                and timezone = 'Victoria') tb2
      on (tb1.servertimemst < tb2.datetimeplus5min
          and tb1.servertimemst > tb2.datetimemst)
go



select dropif('a', 'feng_au2015_visitandtv')
go
select *
into a.feng_au2015_visitandtv
from (
    (
        select cast('1900-01-01 00:00:00' as timestamp) spotlogtime
             , 0 tvindicator
             , *
        from a.feng_au_factvisits_ucdmid_bwfill
        where rdnum not in (select rdnum from a.feng_tmp_nsw)
            and rdnum not in (select rdnum from a.feng_tmp_south)
            and rdnum not in (select rdnum from a.feng_tmp_west)
            and rdnum not in (select rdnum from a.feng_tmp_queensland)
            and rdnum not in (select rdnum from a.feng_tmp_tasmania)
            and rdnum not in (select rdnum from a.feng_tmp_victoria)
            and trunc(servertimemst) >= '2015-01-01' and trunc(servertimemst) < '2015-08-01'
    )
    union
    (
        select * from a.feng_tmp_nsw
    )
    union
    (
        select * from a.feng_tmp_south
    )
    union
    (
        select * from a.feng_tmp_west
    )
    union
    (
        select * from a.feng_tmp_queensland
    )
    union
    (
        select * from a.feng_tmp_tasmania
    )
    union
    (
        select * from a.feng_tmp_victoria
    )
)
go



select count(*) from a.feng_au2015_visitandtv
where subchannel in ('Paid Search – Brand', 'Paid Search – NonBrand', 'Organic Brand', 'Organic NonBrand', 'Direct Homepage', 'Direct Non-Homepage', 'Geo-Redirect')
    and tvindicator = 0
go

select count(*) from a.feng_au2015_visitandtv
where subchannel in ('Paid Search – Brand', 'Paid Search – NonBrand', 'Organic Brand', 'Organic NonBrand', 'Direct Homepage', 'Direct Non-Homepage', 'Geo-Redirect')
    and tvindicator > 0
go

select distinct timezone
from a.feng_autv_2015jan_2015aug
go
