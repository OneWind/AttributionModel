--------------------------------------------------------------------------------
----------------- select all ucdmids matching some constraints -----------------
-- 1. visit time between 01/01/2014 and 10/01/2014                            --
-- 2. non-zero ucdmid                                                         --
-- 3. has either freetrial or hardoffer order within 24 hours from some visit --
--------------------------------------------------------------------------------
select dropif('a', 'feng_us_ucdmidpool')
go

select distinct tb1.ucdmid
into a.feng_us_ucdmidpool
from a.feng_us_factvisits_ucdmid_bwfill tb1
    left join p.fact_subscription tb2 on tb1.ucdmid = tb2.ucdmid
where trunc(servertimemst) between '2015-01-01' and '2015-06-30'
    and tb1.ucdmid != '00000000-0000-0000-0000-000000000000'
--    and siteid = 3709
    and (freetrialorders > 0 or hardofferorders > 0)
    and datediff(hour, servertimemst, signupcreatedate) <= 24
go

--------------------------------------------------------------------------------
-- select all visits data with ucdmid in the pre-selected pool                --
--------------------------------------------------------------------------------
select dropif('a', 'feng_us_factvisitsample')
go

select servertimemst
     , ucdmid
     , visitorid
     , orderid
     , freetrialorders
     , hardofferorders
     , subchannel
     , devicegroupdescription
     , browserdescription
     , operatingsystemdescription
into a.feng_us_factvisitsample
from (select * from a.feng_us_factvisits_ucdmid_bwfill
      where ucdmid in (select ucdmid from a.feng_us_ucdmidpool))  tb1
go

--------------------------------------------------------------------------------
-- matching ucdmid, keep visits only with 30 days of signup                   --
-- use servertime of the visit as proxy of freetrial/hardoffer oder time when --
-- freetrialorders = 1 or hardofferorders = 1                                 --
-- ONLY KEEP subscription with programin = 'New'                              --
--------------------------------------------------------------------------------
-- there are some records of freetrialorders and hardofferorders are off      --
-- in fact_visits table. Keep them as 1 only if a signup record matching the  --
-- date can be found in fact_subscription table                               --
--------------------------------------------------------------------------------
select dropif('a', 'feng_us_visitandsignup_tmp0')
go

select tb1.ucdmid
     , tb1.servertimemst
     , tb4.signupcreatedate
     , tb1.visitorid
     , tb1.subchannel
     , case when datediff(day, tb1.servertimemst, tb4.signupcreatedate) < 1 
                 and tb1.freetrialorders = 1 then 1 else 0 end as new_freetrialorders
     , case when datediff(day, tb1.servertimemst, tb4.signupcreatedate) < 1 
                 and tb1.hardofferorders = 1 then 1 else 0 end as new_hardofferorders
     , tb1.devicegroupdescription
     , tb1.browserdescription
     , tb1.operatingsystemdescription
     , tb1.orderid
     , tb4.signupordernumber
into a.feng_us_visitandsignup_tmp0
from a.feng_us_factvisitsample tb1
    join (select tb2.ucdmid, tb2.signupcreatedate, tb2.signupordernumber
          from p.fact_subscription tb2
              join p.dim_programin tb3 on tb2.programinid = tb3.programinid
          where tb3.programinparentdescription = 'New'
              and trunc(tb2.signupcreatedate) between '2015-01-01' and '2015-06-30'
         )tb4
        on (tb1.ucdmid = tb4.ucdmid 
            and tb1.servertimemst between dateadd(day, -30, tb4.signupcreatedate) and tb4.signupcreatedate)
go

select dropif('a', 'feng_us_sutmp')
go

select ucdmid, signupcreatedate
into a.feng_us_sutmp
from a.feng_us_visitandsignup_tmp0
where orderid = signupordernumber
go

select dropif('a', 'feng_us_visitandsignup_tmp1')
go

select tb1.*
into a.feng_us_visitandsignup_tmp1
from a.feng_us_visitandsignup_tmp0 tb1
    join a.feng_us_sutmp tb2 on (tb1.ucdmid = tb2.ucdmid and tb1.signupcreatedate = tb2.signupcreatedate)
go

select count(*) from a.feng_us_visitandsignup_tmp1
go

--------------------------------------------------------------------------------
-- one visit data could match multiple signupcreatedate                       --
-- if two signupcreatedate are very close                                     --
-- only keep the first signupcreatedate after visit time                      --
--------------------------------------------------------------------------------
select dropif('a', 'feng_us_visitandsignup_tmp2')
go

select ucdmid, servertimemst, min(signupcreatedate) signupcreatedate, 
       subchannel, new_freetrialorders, new_hardofferorders, visitorid,
       devicegroupdescription, browserdescription, operatingsystemdescription
into a.feng_us_visitandsignup_tmp2
from a.feng_us_visitandsignup_tmp1
group by ucdmid, servertimemst, subchannel, 
         new_freetrialorders, new_hardofferorders, visitorid,
         devicegroupdescription, browserdescription, operatingsystemdescription
go

--------------------------------------------------------------------------------
-- add visitnumber                                                            --
--------------------------------------------------------------------------------
select dropif('a', 'feng_us_visitandsignup_tmp3')
go

select tb1.*
     , row_number() over (partition by ucdmid, signupcreatedate order by servertimemst) as visitnumber
into a.feng_us_visitandsignup_tmp3
from a.feng_us_visitandsignup_tmp2 tb1
go

--------------------------------------------------------------------------------
-- calculate the maximum visitnumber for each ucdmid + signupcreatedate       --
--------------------------------------------------------------------------------
select dropif('a', 'feng_us_maxvisitnumber')
go

select ucdmid, signupcreatedate, max(visitnumber) maxvisitnumber
into a.feng_us_maxvisitnumber
from a.feng_us_visitandsignup_tmp3
group by ucdmid, signupcreatedate
go

--------------------------------------------------------------------------------
-- generate visit and signup table with visit number and max visit number     --
--------------------------------------------------------------------------------
select dropif('a', 'feng_us_visitandsignup')
go

select tb1.*, tb2.maxvisitnumber
into a.feng_us_visitandsignup
from a.feng_us_visitandsignup_tmp3 tb1
    join a.feng_us_maxvisitnumber tb2 
        on (tb1.ucdmid = tb2.ucdmid and tb1.signupcreatedate = tb2.signupcreatedate)
go

select dropif('a', 'feng_us_visitandsignup_tmp0')
go
select dropif('a', 'feng_us_visitandsignup_tmp1')
go
select dropif('a', 'feng_us_visitandsignup_tmp2')
go
select dropif('a', 'feng_us_visitandsignup_tmp3')
go
select dropif('a', 'feng_us_maxvisitnumber')
go
select dropif('a', 'feng_us_sutmp')
go

--------------------------------------------------------------------------------
-- calculate firsttouch, lasttouch, and multitouch weights                    --
--------------------------------------------------------------------------------
alter table a.feng_us_visitandsignup add firsttouchweights float
go
alter table a.feng_us_visitandsignup add lasttouchweights float
go
alter table a.feng_us_visitandsignup add multitouchweights float
go

update a.feng_us_visitandsignup
set firsttouchweights = case when visitnumber = 1 then 1 else 0 end 
from a.feng_us_visitandsignup
go
update a.feng_us_visitandsignup
set lasttouchweights = case when visitnumber = maxvisitnumber then 1 else 0 end
from a.feng_us_visitandsignup
go
update a.feng_us_visitandsignup
set multitouchweights = 1.0 / maxvisitnumber
from a.feng_us_visitandsignup
go

--------------------------------------------------------------------------------
-- calculate attribution for each subchannel
--------------------------------------------------------------------------------
select dropif('a', 'feng_us_attribution_3touches')
go

select subchannel
     , sum(firsttouchweights) firsttouch
     , sum(lasttouchweights) lasttouch
     , sum(multitouchweights) multitouch
into a.feng_us_attribution_3touches
from a.feng_us_visitandsignup
group by subchannel
go

select * from a.feng_us_attribution_3touches
go


select dropif('a', 'feng_us_attribution_3touches_monthly')
go

select subchannel, datepart(month, signupcreatedate) as month
     , sum(firsttouchweights) firsttouch
     , sum(lasttouchweights) lasttouch
     , sum(multitouchweights) multitouch
into a.feng_us_attribution_3touches_monthly
from a.feng_us_visitandsignup
group by subchannel, datepart(month, signupcreatedate)
go
--------------------------------------------------------------------------------
-- freetrial orders and hardoffer orders group by visitnumber                 --
--------------------------------------------------------------------------------
select dropif('a', 'feng_us_orderbyvisitnumber')
go

select visitnumber
     , sum(case when new_freetrialorders > 0 then 1 else 0 end) ftorders
     , sum(case when new_hardofferorders > 0 then 1 else 0 end) hoorders
into a.feng_us_orderbyvisitnumber
from a.feng_us_visitandsignup
where new_freetrialorders > 0 or new_hardofferorders > 0
group by visitnumber
order by visitnumber
go

select * from a.feng_us_orderbyvisitnumber
go
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

select count(*), sum(new_freetrialorders) + sum(new_hardofferorders),
       min(servertimemst), max(servertimemst), count(distinct ucdmid)
from a.feng_us_visitandsignup
go

-- visit at least 5 times: ~ 21,845 --
select count(*), count(distinct ucdmid)
from a.feng_us_visitandsignup
where visitnumber = 5
go

-- visit at least 1 times: ~ 196,383 --
select count(*)
from a.feng_us_visitandsignup
where visitnumber = 1
go


-- visit 1 to visit 5 --
select datediff(day, tb1.servertimemst, tb2.servertimemst)
     , count(*) cnt
from a.feng_us_visitandsignup tb1
    join a.feng_us_visitandsignup tb2
        on (tb1.ucdmid = tb2.ucdmid
            and tb1.signupcreatedate = tb2.signupcreatedate
            and tb1.visitnumber = 1
            and tb2.visitnumber = 5)
group by datediff(day, tb1.servertimemst, tb2.servertimemst)
go

-- visits lead to free trial order --
select dropif('a', 'feng_us_ft_visitandsignup')
go

select tb1.*
into a.feng_us_ft_visitandsignup
from a.feng_us_visitandsignup tb1
    join (select ucdmid, signupcreatedate
          from a.feng_us_visitandsignup
          group by ucdmid, signupcreatedate
          having sum(new_freetrialorders) > 0) tb2
        on tb1.ucdmid = tb2.ucdmid 
            and tb1.signupcreatedate = tb2.signupcreatedate
go

select datediff(day, tb1.servertimemst, tb2.servertimemst)
     , count(*) cnt
from a.feng_us_ft_visitandsignup tb1
    join a.feng_us_ft_visitandsignup tb2
        on (tb1.ucdmid = tb2.ucdmid
            and tb1.signupcreatedate = tb2.signupcreatedate
            and tb1.visitnumber = 1
            and tb2.visitnumber = 5)
group by datediff(day, tb1.servertimemst, tb2.servertimemst)
go

-- visits lead to hard offer order --
select dropif('a', 'feng_us_ho_visitandsignup')
go

select tb1.*
into a.feng_us_ho_visitandsignup
from a.feng_us_visitandsignup tb1
    join (select ucdmid, signupcreatedate
          from a.feng_us_visitandsignup
          group by ucdmid, signupcreatedate
          having sum(new_hardofferorders) > 0) tb2
        on tb1.ucdmid = tb2.ucdmid 
            and tb1.signupcreatedate = tb2.signupcreatedate
go

select datediff(day, tb1.servertimemst, tb2.servertimemst)
     , count(*) cnt
from a.feng_us_ho_visitandsignup tb1
    join a.feng_us_ho_visitandsignup tb2
        on (tb1.ucdmid = tb2.ucdmid
            and tb1.signupcreatedate = tb2.signupcreatedate
            and tb1.visitnumber = 1
            and tb2.visitnumber = 5)
group by datediff(day, tb1.servertimemst, tb2.servertimemst)
go

--------------------------------------------------------------------------------
select daystosignup, count(*) counts
from (select ucdmid
           , signupcreatedate
           , min(servertimemst) firstvisittime
           , max(servertimemst) lastvisittime
           , datediff(day, firstvisittime, lastvisittime) daystosignup
      from a.feng_us_visitandsignup
      group by ucdmid, signupcreatedate
      having sum(new_freetrialorders) > 0)
group by daystosignup
go

select daystosignup, count(*) counts
from (select ucdmid
           , signupcreatedate
           , min(servertimemst) firstvisittime
           , max(servertimemst) lastvisittime
           , datediff(day, firstvisittime, lastvisittime) daystosignup
      from a.feng_us_visitandsignup
      group by ucdmid, signupcreatedate
      having sum(new_hardofferorders) > 0)
group by daystosignup
go

