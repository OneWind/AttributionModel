select dropif('a', 'feng_tmp1')
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
into a.feng_tmp1
from (select *, cast(substr(cast(dateadd(second, 0, servertimemst) as text), 1, 17) || '00' as timestamp) tominute
      from a.feng_uk_factvisits_ucdmid_bwfill
      where trunc(servertimemst) >= '2015-01-01' and trunc(servertimemst) < '2015-06-01'
          and subchannel in ('Paid Search – Brand', 'Organic Brand', 'Direct Brand')) tb1
    join (select * from a.feng_uktv_2014jan_2015may where impactalladults > 0) tb2
        on tb1.tominute = tb2.datetimemst
where datediff(second, tb2.datetimemst, tb1.servertimemst) >= 30
go
alter table a.feng_tmp1
drop column tominute
go

select dropif('a', 'feng_tmp2')
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
into a.feng_tmp2
from (select *, cast(substr(cast(dateadd(second, -60, servertimemst) as text), 1, 17) || '00' as timestamp) tominute
      from a.feng_uk_factvisits_ucdmid_bwfill
      where trunc(servertimemst) >= '2015-01-01' and trunc(servertimemst) < '2015-06-01'
          and subchannel in ('Paid Search – Brand', 'Organic Brand', 'Direct Brand')) tb1
    join (select * from a.feng_uktv_2014jan_2015may where impactalladults > 0) tb2
        on tb1.tominute = tb2.datetimemst
go
alter table a.feng_tmp2
drop column tominute
go

select dropif('a', 'feng_tmp3')
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
into a.feng_tmp3
from (select *, cast(substr(cast(dateadd(second, -120, servertimemst) as text), 1, 17) || '00' as timestamp) tominute
      from a.feng_uk_factvisits_ucdmid_bwfill
      where trunc(servertimemst) >= '2015-01-01' and trunc(servertimemst) < '2015-06-01'
          and subchannel in ('Paid Search – Brand', 'Organic Brand', 'Direct Brand')) tb1
    join (select * from a.feng_uktv_2014jan_2015may where impactalladults > 0) tb2
        on tb1.tominute = tb2.datetimemst
go
alter table a.feng_tmp3
drop column tominute
go

select dropif('a', 'feng_tmp4')
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
into a.feng_tmp4
from (select *, cast(substr(cast(dateadd(second, -180, servertimemst) as text), 1, 17) || '00' as timestamp) tominute
      from a.feng_uk_factvisits_ucdmid_bwfill
      where trunc(servertimemst) >= '2015-01-01' and trunc(servertimemst) < '2015-06-01'
          and subchannel in ('Paid Search – Brand', 'Organic Brand', 'Direct Brand')) tb1
    join (select * from a.feng_uktv_2014jan_2015may where impactalladults > 0) tb2
        on tb1.tominute = tb2.datetimemst
go
alter table a.feng_tmp4
drop column tominute
go

select dropif('a', 'feng_tmp5')
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
into a.feng_tmp5
from (select *, cast(substr(cast(dateadd(second, -240, servertimemst) as text), 1, 17) || '00' as timestamp) tominute
      from a.feng_uk_factvisits_ucdmid_bwfill
      where trunc(servertimemst) >= '2015-01-01' and trunc(servertimemst) < '2015-06-01'
          and subchannel in ('Paid Search – Brand', 'Organic Brand', 'Direct Brand')) tb1
    join (select * from a.feng_uktv_2014jan_2015may where impactalladults > 0) tb2
        on tb1.tominute = tb2.datetimemst
go
alter table a.feng_tmp5
drop column tominute
go

select dropif('a', 'feng_tmp5')
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
into a.feng_tmp5
from (select *, cast(substr(cast(dateadd(second, -300, servertimemst) as text), 1, 17) || '00' as timestamp) tominute
      from a.feng_uk_factvisits_ucdmid_bwfill
      where trunc(servertimemst) >= '2015-01-01' and trunc(servertimemst) < '2015-06-01'
          and subchannel in ('Paid Search – Brand', 'Organic Brand', 'Direct Brand')) tb1
    join (select * from a.feng_uktv_2014jan_2015may where impactalladults > 0) tb2
        on tb1.tominute = tb2.datetimemst
go
alter table a.feng_tmp5
drop column tominute
go

select dropif('a', 'feng_tmp6')
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
into a.feng_tmp6
from (select *, cast(substr(cast(dateadd(second, -360, servertimemst) as text), 1, 17) || '00' as timestamp) tominute
      from a.feng_uk_factvisits_ucdmid_bwfill
      where trunc(servertimemst) >= '2015-01-01' and trunc(servertimemst) < '2015-06-01'
          and subchannel in ('Paid Search – Brand', 'Organic Brand', 'Direct Brand')) tb1
    join (select * from a.feng_uktv_2014jan_2015may where impactalladults > 0) tb2
        on tb1.tominute = tb2.datetimemst
go
alter table a.feng_tmp6
drop column tominute
go


select dropif('a', 'feng_uk2015_visitandtv_tmp')
go
select *
into a.feng_uk2015_visitandtv_tmp
from 
(
    select * from a.feng_tmp1
    union
    select * from a.feng_tmp2
    union
    select * from a.feng_tmp3
    union
    select * from a.feng_tmp4
    union
    select * from a.feng_tmp5
    union
    select * from a.feng_tmp6
)
go


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
        where rdnum not in (select rdnum from a.feng_uk2015_visitandtv_tmp)
            and trunc(servertimemst) >= '2015-01-01' and trunc(servertimemst) < '2015-06-01'
    )
    union
    (
        select * from a.feng_uk2015_visitandtv_tmp
    )
)
go


--------------------------------------------------------------------------------


select dropif('a', 'feng_tmp1')
go
select dropif('a', 'feng_tmp2')
go
select dropif('a', 'feng_tmp3')
go
select dropif('a', 'feng_tmp4')
go
select dropif('a', 'feng_tmp5')
go
select dropif('a', 'feng_tmp6')
go
select dropif('a', 'feng_uk2015_visitandtv_tmp')
go

select subchannel, count(*)
from a.feng_uk2015_visitandtv
where tvindicator > 0
group by subchannel
go
select count(*) from (
select servertimemst, visitorid, subchannel
from a.feng_uk2015_visitandtv
group by servertimemst, visitorid, subchannel)
go
select count(distinct rdnum) from a.feng_uk2015_visitandtv
go
select count(*) from a.feng_uk2015_visitandtv
go
select top 10000 * from a.feng_uk2015_visitandtv
where length > 0
go
select count(distinct rdnum), count(*)
from a.feng_uk_factvisits_ucdmid_bwfill
where trunc(servertimemst) >= '2015-01-01' and trunc(servertimemst) <= '2015-02-01'
go
--------------------------------------------------------------------------------
