--------------------------------------------------------------------------------
select dropif('a', 'feng_us_dna_ucdmidpool')
go

select ucdmid, servertimemst as dnaorderdate
into a.feng_us_dna_ucdmidpool
from a.feng_us_factvisits_ucdmid_bwfill
where trunc(servertimemst) between '2015-01-01' and '2015-06-30'
    and ucdmid != '00000000-0000-0000-0000-000000000000'
    and dnaorders > 0
group by ucdmid, servertimemst
go

select dropif('a', 'feng_us_dna_nonmember')
go
-- 1. never subscriber
-- 2. not a subscriber 2 hours before DNA order visit

select *
into a.feng_us_dna_nonmember
from
    (
     (select *
      from (select tb1.ucdmid, tb1.dnaorderdate, min(tb2.signupcreatedate) firstsudate
            from a.feng_us_dna_ucdmidpool tb1
                join p.fact_subscription tb2 on tb1.ucdmid = tb2.ucdmid
            group by tb1.ucdmid, tb1.dnaorderdate)
      where dnaorderdate < dateadd(hour, 2, firstsudate))
     union
     (select tb3.ucdmid, tb3.dnaorderdate, tb4.signupcreatedate as firstsudate
      from a.feng_us_dna_ucdmidpool tb3
          left join p.fact_subscription tb4 on tb3.ucdmid = tb4.ucdmid
      where tb4.signupcreatedate is null)
    )
go

--------------------------------------------------------------------------------
-- select all visits data with ucdmid in the pre-selected pool                --
--------------------------------------------------------------------------------
select dropif('a', 'feng_us_dna_factvisitsample_nonmember')
go

select servertimemst
     , ucdmid
     , visitorid
     , orderid
     , dnaorders
     , subchannel
     , devicegroupdescription
     , browserdescription
     , operatingsystemdescription
into a.feng_us_dna_factvisitsample_nonmember
from (select * from a.feng_us_factvisits_ucdmid_bwfill
      where ucdmid in (select ucdmid from a.feng_us_dna_ucdmidpool))  tb1
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
select dropif('a', 'feng_us_dna_visitandsignup_tmp1')
go

select tb1.ucdmid
     , tb1.servertimemst
     , tb2.dnaorderdate
     , tb1.visitorid
     , tb1.subchannel
     , tb1.dnaorders
     , tb1.devicegroupdescription
     , tb1.browserdescription
     , tb1.operatingsystemdescription
     , tb1.orderid
into a.feng_us_dna_visitandsignup_tmp1
from a.feng_us_dna_factvisitsample tb1
    join a.feng_us_dna_nonmember tb2
        on (tb1.ucdmid = tb2.ucdmid 
            and tb1.servertimemst > dateadd(day, -30, tb2.dnaorderdate) 
            and tb1.servertimemst <= tb2.dnaorderdate)
go
--696,862

--------------------------------------------------------------------------------
-- one visit data could match multiple signupcreatedate                       --
-- if two signupcreatedate are very close                                     --
-- only keep the first signupcreatedate after visit time                      --
--------------------------------------------------------------------------------
select dropif('a', 'feng_us_dna_visitandsignup_tmp2')
go

select ucdmid, servertimemst, min(dnaorderdate) dnaorderdate, 
       subchannel, dnaorders, visitorid,
       devicegroupdescription, browserdescription, operatingsystemdescription
into a.feng_us_dna_visitandsignup_tmp2
from a.feng_us_dna_visitandsignup_tmp1
group by ucdmid, servertimemst, subchannel, dnaorders, visitorid,
         devicegroupdescription, browserdescription, operatingsystemdescription
go
-- 501,679

--------------------------------------------------------------------------------
-- add visitnumber                                                            --
--------------------------------------------------------------------------------
select dropif('a', 'feng_us_dna_visitandsignup_tmp3')
go

select tb1.*
     , row_number() over (partition by ucdmid, dnaorderdate order by servertimemst) as visitnumber
into a.feng_us_dna_visitandsignup_tmp3
from a.feng_us_dna_visitandsignup_tmp2 tb1
go

--------------------------------------------------------------------------------
-- calculate the maximum visitnumber for each ucdmid + signupcreatedate       --
--------------------------------------------------------------------------------
select dropif('a', 'feng_us_dna_maxvisitnumber')
go

select ucdmid, dnaorderdate, max(visitnumber) maxvisitnumber
into a.feng_us_dna_maxvisitnumber
from a.feng_us_dna_visitandsignup_tmp3
group by ucdmid, dnaorderdate
go

--------------------------------------------------------------------------------
-- generate visit and signup table with visit number and max visit number     --
--------------------------------------------------------------------------------
select dropif('a', 'feng_us_dna_visitandsignup')
go

select tb1.*, tb2.maxvisitnumber
into a.feng_us_dna_visitandsignup
from a.feng_us_dna_visitandsignup_tmp3 tb1
    join a.feng_us_dna_maxvisitnumber tb2 
        on (tb1.ucdmid = tb2.ucdmid and tb1.dnaorderdate = tb2.dnaorderdate)
go

select dropif('a', 'feng_us_dna_visitandsignup_tmp1')
go
select dropif('a', 'feng_us_dna_visitandsignup_tmp2')
go
select dropif('a', 'feng_us_dna_visitandsignup_tmp3')
go
select dropif('a', 'feng_us_dna_maxvisitnumber')
go

--------------------------------------------------------------------------------
-- calculate firsttouch, lasttouch, and multitouch weights                    --
--------------------------------------------------------------------------------
alter table a.feng_us_dna_visitandsignup add firsttouchweights float
go
alter table a.feng_us_dna_visitandsignup add lasttouchweights float
go
alter table a.feng_us_dna_visitandsignup add multitouchweights float
go

update a.feng_us_dna_visitandsignup
set firsttouchweights = case when visitnumber = 1 then 1 else 0 end 
from a.feng_us_dna_visitandsignup
go
update a.feng_us_dna_visitandsignup
set lasttouchweights = case when visitnumber = maxvisitnumber then 1 else 0 end
from a.feng_us_dna_visitandsignup
go
update a.feng_us_dna_visitandsignup
set multitouchweights = 1.0 / maxvisitnumber
from a.feng_us_dna_visitandsignup
go

--------------------------------------------------------------------------------
-- calculate attribution for each subchannel
--------------------------------------------------------------------------------
select dropif('a', 'feng_us_dna_attribution_3touches')
go

select subchannel
     , sum(firsttouchweights) firsttouch
     , sum(lasttouchweights) lasttouch
     , sum(multitouchweights) multitouch
into a.feng_us_dna_attribution_3touches
from a.feng_us_dna_visitandsignup
group by subchannel
go

select * from a.feng_us_dna_attribution_3touches
go

--------------------------------------------------------------------------------
-- freetrial orders and hardoffer orders group by visitnumber                 --
--------------------------------------------------------------------------------
select dropif('a', 'feng_us_dna_orderbyvisitnumber')
go

select visitnumber
     , sum(case when dnaorders > 0 then 1 else 0 end) dnaorders
into a.feng_us_dna_orderbyvisitnumber
from a.feng_us_dna_visitandsignup
where dnaorders > 0
group by visitnumber
order by visitnumber
go

select * from a.feng_us_dna_orderbyvisitnumber
go

select count(*)
from a.feng_us_dna_visitandsignup
where ucdmid = '014F2C6E-0001-0000-0000-000000000000'
go

select distinct(ucdmid)
from a.feng_us_dna_visitandsignup
where visitnumber > 10000
go
--- 014F2C6E-0001-0000-0000-000000000000
--- 0314BE69-0000-0000-0000-000000000000

-- 0090B564-0003-0000-0000-000000000000
-- 014F2C6E-0001-0000-0000-000000000000
-- 00F1C3A1-0006-0000-0000-000000000000
-- 011160F3-0002-0000-0000-000000000000
-- 0258CC65-0006-0000-0000-000000000000
-- 019ABE31-0003-0000-0000-000000000000
-- 03127AAB-0006-0000-0000-000000000000
-- 02FB6885-0006-0000-0000-000000000000
-- 01B1D6D9-0001-0000-0000-000000000000
-- 02FFA9AB-0006-0000-0000-000000000000
-- 005C09C1-0006-0000-0000-000000000000
-- 014B1CEF-0002-0000-0000-000000000000
-- 0314BE69-0000-0000-0000-000000000000
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

select count(*), sum(new_freetrialorders) + sum(new_hardofferorders),
       min(servertimemst), max(servertimemst), count(distinct ucdmid)
from a.feng_us_dna_visitandsignup
go

-- visit at least 5 times: ~ 21,845 --
select count(*), count(distinct ucdmid)
from a.feng_us_dna_visitandsignup
where visitnumber = 5
go

-- visit at least 1 times: ~ 196,383 --
select count(*)
from a.feng_us_dna_visitandsignup
where visitnumber = 1
go


-- visit 1 to visit 5 --
select datediff(day, tb1.servertimemst, tb2.servertimemst)
     , count(*) cnt
from a.feng_us_dna_visitandsignup tb1
    join a.feng_us_dna_visitandsignup tb2
        on (tb1.ucdmid = tb2.ucdmid
            and tb1.signupcreatedate = tb2.signupcreatedate
            and tb1.visitnumber = 1
            and tb2.visitnumber = 5)
group by datediff(day, tb1.servertimemst, tb2.servertimemst)
go

-- visits lead to free trial order --
select dropif('a', 'feng_us_dna_ft_visitandsignup')
go

select tb1.*
into a.feng_us_dna_ft_visitandsignup
from a.feng_us_dna_visitandsignup tb1
    join (select ucdmid, signupcreatedate
          from a.feng_us_dna_visitandsignup
          group by ucdmid, signupcreatedate
          having sum(new_freetrialorders) > 0) tb2
        on tb1.ucdmid = tb2.ucdmid 
            and tb1.signupcreatedate = tb2.signupcreatedate
go

select datediff(day, tb1.servertimemst, tb2.servertimemst)
     , count(*) cnt
from a.feng_us_dna_ft_visitandsignup tb1
    join a.feng_us_dna_ft_visitandsignup tb2
        on (tb1.ucdmid = tb2.ucdmid
            and tb1.signupcreatedate = tb2.signupcreatedate
            and tb1.visitnumber = 1
            and tb2.visitnumber = 5)
group by datediff(day, tb1.servertimemst, tb2.servertimemst)
go

-- visits lead to hard offer order --
select dropif('a', 'feng_us_dna_ho_visitandsignup')
go

select tb1.*
into a.feng_us_dna_ho_visitandsignup
from a.feng_us_dna_visitandsignup tb1
    join (select ucdmid, signupcreatedate
          from a.feng_us_dna_visitandsignup
          group by ucdmid, signupcreatedate
          having sum(new_hardofferorders) > 0) tb2
        on tb1.ucdmid = tb2.ucdmid 
            and tb1.signupcreatedate = tb2.signupcreatedate
go

select datediff(day, tb1.servertimemst, tb2.servertimemst)
     , count(*) cnt
from a.feng_us_dna_ho_visitandsignup tb1
    join a.feng_us_dna_ho_visitandsignup tb2
        on (tb1.ucdmid = tb2.ucdmid
            and tb1.signupcreatedate = tb2.signupcreatedate
            and tb1.visitnumber = 1
            and tb2.visitnumber = 5)
group by datediff(day, tb1.servertimemst, tb2.servertimemst)
go

--------------------------------------------------------------------------------
select daystosignup, count(*) counts
from (select ucdmid
           , dnaorderdate
           , min(servertimemst) firstvisittime
           , max(servertimemst) lastvisittime
           , datediff(day, firstvisittime, lastvisittime) daystosignup
      from a.feng_us_dna_visitandsignup
      group by ucdmid, dnaorderdate
      having sum(dnaorders) > 0)
group by daystosignup
go

select daystosignup, count(*) counts
from (select ucdmid
           , signupcreatedate
           , min(servertimemst) firstvisittime
           , max(servertimemst) lastvisittime
           , datediff(day, firstvisittime, lastvisittime) daystosignup
      from a.feng_us_dna_visitandsignup
      group by ucdmid, signupcreatedate
      having sum(new_hardofferorders) > 0)
group by daystosignup
go
