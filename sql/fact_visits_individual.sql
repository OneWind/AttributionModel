select top 20 * from a.feng_uk_factvisits
go

select count(*) from a.feng_uk_factvisits
go
--------------------------------------------------------------------------------

select dropif('a', 'feng_10000ucdmidpool')
go

select top 10000 distinct ucdmid
into a.feng_10000ucdmidpool
from p.fact_visits
where trunc(servertimemst) between '2014-01-01' and '2014-10-01'
    and ucdmid != '00000000-0000-0000-0000-000000000000'
    and siteid = 3709
    and (freetrialorders > 0 or hardofferorders > 0)
go

--select count(distinct ucdmid) from a.feng_10000ucdmidpool
--go
--select top 100 * from a.feng_10000ucdmidpool
--go

--------------------------------------------------------------------------------
select dropif('a', 'feng_factvisitsample')
go

select servertimemst
     , ucdmid
     , prospectid
     , visitorid
     , tb4.channel
     , tb4.subchannel
     , tb2.subscriptiongroup
     , tb3.durationdescription
     , tb4.promocodedescription
     , freetrialorders
     , hardofferorders
into a.feng_factvisitsample
from (select * from p.fact_visits 
      where ucdmid in (select ucdmid from a.feng_10000ucdmidpool)
          and siteid = 3709)  tb1
    left join p.dim_subscription tb2 on tb1.subscriptionid = tb2.subscriptionid
    left join p.dim_duration tb3 on tb1.durationid = tb3.durationid
    left join p.dim_promotion tb4 on tb1.promotionid = tb4.promotionid
go

--select count(*) from a.feng_factvisitsample
--go

--select top 20 * from a.feng_factvisitsample
--go

--------------------------------------------------------------------------------
select dropif('a', 'feng_visitandsignup_tmp')
go

select tb1.*, tb2.signupcreatedate
     , row_number() over (partition by tb1.ucdmid, tb2.signupcreatedate order by servertimemst) as visitnumber
into a.feng_visitandsignup_tmp
from a.feng_factvisitsample tb1
    join p.fact_subscription tb2
        on (tb1.ucdmid = tb2.ucdmid 
            and tb1.servertimemst between dateadd(day, -30, tb2.signupcreatedate) and tb2.signupcreatedate)
go

select dropif('a', 'feng_maxvisitnumber')
go

select ucdmid, signupcreatedate, max(visitnumber) maxvisitnumber
into a.feng_maxvisitnumber
from a.feng_visitandsignup_tmp
group by ucdmid, signupcreatedate
go

select dropif('a', 'feng_visitandsignup')
go

select tb1.*, tb2.maxvisitnumber
into a.feng_visitandsignup
from a.feng_visitandsignup_tmp tb1
    join a.feng_maxvisitnumber tb2 on (tb1.ucdmid = tb2.ucdmid and tb1.signupcreatedate = tb2.signupcreatedate)
go

--------------------------------------------------------------------------------

alter table a.feng_visitandsignup add firsttouchweights float
go
alter table a.feng_visitandsignup add lasttouchweights float
go
alter table a.feng_visitandsignup add multitouchweights float
go

update a.feng_visitandsignup
set firsttouchweights = case when visitnumber = 1 then 1 else 0 end 
from a.feng_visitandsignup
go
update a.feng_visitandsignup
set lasttouchweights = case when visitnumber = maxvisitnumber then 1 else 0 end
from a.feng_visitandsignup
go
update a.feng_visitandsignup
set multitouchweights = 1.0 / maxvisitnumber
from a.feng_visitandsignup
go

--select top 1000 * from a.feng_visitandsignup
--go

--------------------------------------------------------------------------------

select subchannel
     , sum(firsttouchweights) firsttouch
     , sum(lasttouchweights) lasttouch
     , sum(multitouchweights) multitouch
from a.feng_visitandsignup
group by subchannel
go

--select count(*) from a.feng_visitandsignup
--go

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
