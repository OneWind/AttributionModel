select dropif('a', 'feng_us_unique_entrypagename')
go

select tb2.entrypagenamedescription, count(*) cnt
into a.feng_us_unique_entrypagename
from (select tmp1.*
           , case when tmp1.visitcountryid = 83 then tmp2.state else 'non-us' end as usstate
           , case when tmp1.visitcountryid = 83 then tmp2.timezone else 'non-us' end ustimezone
      from p.fact_visits tmp1
          left join (select cast(visitregionid as int) visitregionid, state, timezone 
                     from a.mb_us_timezones) tmp2
              on tmp1.visitregionid = tmp2.visitregionid
      where tmp1.siteid = 3713
          and trunc(tmp1.servertimemst) >= '2015-01-01'
     ) tb1
    join p.dim_entrypagename tb2 on tb1.entrypagenameid = tb2.entrypagenameid
    join p.dim_promotion tb3 on tb1.promotionid = tb3.promotionid
    left join p.dim_useragent tb4 on tb1.useragentstring = tb4.useragentstring
where (lower(tb1.visitreferrer) like '%google.%'
    or lower(tb1.visitreferrer) like '%bing.%'
    or lower(tb1.visitreferrer) like '%yahoo.%'
    or lower(tb1.visitreferrer) like '%xfinity.%'
    or lower(tb1.visitreferrer) like '%aol.com%'
    or lower(tb1.visitreferrer) like '%duckduckgo.com%'
    or lower(tb1.visitreferrer) like '%ask.com%'
    or lower(tb1.visitreferrer) like '%wow.com%')
    and lower(tb3.subchannel) = 'unknown'
group by tb2.entrypagenamedescription
go

select top 100 * from a.feng_us_unique_pageurl
where cnt > 10000
go

select dropif('a', 'feng_us_entrypage_pageurl')
go

select tb1.pageurl, tb2.entrypagenamedescription, count(*) cnt
into a.feng_us_entrypage_pageurl
from (select tmp1.*
           , case when tmp1.visitcountryid = 83 then tmp2.state else 'non-us' end as usstate
           , case when tmp1.visitcountryid = 83 then tmp2.timezone else 'non-us' end ustimezone
      from p.fact_visits tmp1
          left join (select cast(visitregionid as int) visitregionid, state, timezone 
                     from a.mb_us_timezones) tmp2
              on tmp1.visitregionid = tmp2.visitregionid
      where tmp1.siteid = 3713
          and trunc(tmp1.servertimemst) >= '2015-01-01'
     ) tb1
    join p.dim_entrypagename tb2 on tb1.entrypagenameid = tb2.entrypagenameid
    join p.dim_promotion tb3 on tb1.promotionid = tb3.promotionid
    left join p.dim_useragent tb4 on tb1.useragentstring = tb4.useragentstring
where (lower(tb1.visitreferrer) like '%google.%'
                  or lower(tb1.visitreferrer) like '%bing.%'
                  or lower(tb1.visitreferrer) like '%yahoo.%'
                  or lower(tb1.visitreferrer) like '%xfinity.%'
                  or lower(tb1.visitreferrer) like '%aol.com%'
                  or lower(tb1.visitreferrer) like '%duckduckgo.com%'
                  or lower(tb1.visitreferrer) like '%ask.com%'
                  or lower(tb1.visitreferrer) like '%wow.com%')
                 and tb2.entrypagenamedescription like '%: home%'
                 and lower(tb3.subchannel) = 'unknown'
group by 1, 2
go


select top 20 * from a.feng_us_entrypage_pageurl
order by cnt desc
go


select dropif('a', 'feng_us_entrypage_pageurl_non')
go

select tb1.pageurl, tb2.entrypagenamedescription, count(*) cnt
into a.feng_us_entrypage_pageurl_non
from (select tmp1.*
           , case when tmp1.visitcountryid = 83 then tmp2.state else 'non-us' end as usstate
           , case when tmp1.visitcountryid = 83 then tmp2.timezone else 'non-us' end ustimezone
      from p.fact_visits tmp1
          left join (select cast(visitregionid as int) visitregionid, state, timezone 
                     from a.mb_us_timezones) tmp2
              on tmp1.visitregionid = tmp2.visitregionid
      where tmp1.siteid = 3713
          and trunc(tmp1.servertimemst) >= '2015-01-01'
     ) tb1
    join p.dim_entrypagename tb2 on tb1.entrypagenameid = tb2.entrypagenameid
    join p.dim_promotion tb3 on tb1.promotionid = tb3.promotionid
    left join p.dim_useragent tb4 on tb1.useragentstring = tb4.useragentstring
where (lower(tb1.visitreferrer) like '%google.%'
                  or lower(tb1.visitreferrer) like '%bing.%'
                  or lower(tb1.visitreferrer) like '%yahoo.%'
                  or lower(tb1.visitreferrer) like '%xfinity.%'
                  or lower(tb1.visitreferrer) like '%aol.com%'
                  or lower(tb1.visitreferrer) like '%duckduckgo.com%'
                  or lower(tb1.visitreferrer) like '%ask.com%'
                  or lower(tb1.visitreferrer) like '%wow.com%')
                 and tb2.entrypagenamedescription not like '%: home%'
                 and lower(tb3.subchannel) = 'unknown'
group by 1, 2
go


select top 200 * from a.feng_us_entrypage_pageurl_non
order by cnt desc
go


select dropif('a', 'feng_us_entrypage_pageurl_non_short')
go

select tb1.pageurl, count(*) cnt
into a.feng_us_entrypage_pageurl_non_short
from (select tmp1.*
           , case when tmp1.visitcountryid = 83 then tmp2.state else 'non-us' end as usstate
           , case when tmp1.visitcountryid = 83 then tmp2.timezone else 'non-us' end ustimezone
      from p.fact_visits tmp1
          left join (select cast(visitregionid as int) visitregionid, state, timezone 
                     from a.mb_us_timezones) tmp2
              on tmp1.visitregionid = tmp2.visitregionid
      where tmp1.siteid = 3713
          and trunc(tmp1.servertimemst) >= '2015-01-01'
     ) tb1
    join p.dim_entrypagename tb2 on tb1.entrypagenameid = tb2.entrypagenameid
    join p.dim_promotion tb3 on tb1.promotionid = tb3.promotionid
    left join p.dim_useragent tb4 on tb1.useragentstring = tb4.useragentstring
where (lower(tb1.visitreferrer) like '%google.%'
                  or lower(tb1.visitreferrer) like '%bing.%'
                  or lower(tb1.visitreferrer) like '%yahoo.%'
                  or lower(tb1.visitreferrer) like '%xfinity.%'
                  or lower(tb1.visitreferrer) like '%aol.com%'
                  or lower(tb1.visitreferrer) like '%duckduckgo.com%'
                  or lower(tb1.visitreferrer) like '%ask.com%'
                  or lower(tb1.visitreferrer) like '%wow.com%')
                 and tb2.entrypagenamedescription not like '%: home%'
                 and lower(tb3.subchannel) = 'unknown'
                 and len(tb1.pageurl) - len(replace(tb1.pageurl, '/', '')) < 4
group by 1
go


select top 100 * from a.feng_us_entrypage_pageurl_non_short
order by cnt desc
go



select sum(cnt) from a.feng_us_entrypage_pageurl_non_short
go

select sum(cnt) from a.feng_us_entrypage_pageurl_non
go


select count(*) from a.feng_uk_factvisits_tmp
go

select count(*)
from p.fact_visits tb1
    join p.dim_entrypagename tb2 on tb1.entrypagenameid = tb2.entrypagenameid
    join p.dim_promotion tb3 on tb1.promotionid = tb3.promotionid
    left join p.dim_useragent tb4 on tb1.useragentstring = tb4.useragentstring
where tb1.siteid = 3709
    and trunc(tb1.servertimemst) >= '2015-01-01'
go

select count(*) from a.feng_us_factvisits_tmp
go

select count(*)
from p.fact_visits tb1
    join p.dim_entrypagename tb2 on tb1.entrypagenameid = tb2.entrypagenameid
    join p.dim_promotion tb3 on tb1.promotionid = tb3.promotionid
    left join p.dim_useragent tb4 on tb1.useragentstring = tb4.useragentstring
where tb1.siteid = 3713
    and trunc(tb1.servertimemst) >= '2015-01-01'
go




select tb2.visitregionid, tb2.visitregiondescription, count(*) cnt
from p.fact_visits tb1
    join p.dim_visitregion tb2 on tb1.visitregionid = tb2.visitregionid
where visitcountryid = 43
group by tb2.visitregionid, tb2.visitregiondescription
go

select top 20 * from a.feng_au_factvisits_tmp
go

select * from p.dim_visitcountry
go

select * from p.dim_site
go


select top 10000 * from a.feng_au_factvisits_tmp
where subchannel = 'Unknown'
go


select top 1000 * from a.feng_au_factvisits_ucdmid_bwfill
go

