
--------------------------------------------------------------------------------
------------------------------ fact visits for uk ------------------------------
--------------------------------------------------------------------------------
-- data saved in: a.feng_us_factvisits_tmp                                    --
-- use useragentstring to retrieve browser, operating system and device group --
--------------------------------------------------------------------------------
select dropif('a', 'feng_us_factvisits_tmp')
go

select tb1.servertimemst
     , tb1.ucdmid
     , tb1.prospectid
     , tb1.visitorid
     , tb1.freetrialorders
     , tb1.hardofferorders
     , tb1.dnaorders
     , tb1.siteid
     , tb1.orderid
     , tb4.browserdescription
     , tb4.operatingsystemdescription
     , tb4.devicegroupdescription
     , tb1.promotionid
     , tb1.subscriptionid
     , tb1.durationid
     , tb1.netbillthroughquantity
     , tb3.promocodedescription
     , case when ((lower(tb1.visitreferrer) like '%google%'
                  or lower(tb1.visitreferrer) like '%bing%'
                  or lower(tb1.visitreferrer) like '%yahoo%')
                 and tb2.entrypagenamedescription like '%: home%'
                 and lower(tb3.subchannel) = 'unknown') then 'Organic Brand'
            when ((lower(tb1.visitreferrer) like '%google%'
                  or lower(tb1.visitreferrer) like '%bing%'
                  or lower(tb1.visitreferrer) like '%yahoo%')
                 and tb2.entrypagenamedescription not like '%: home%'
                 and lower(tb3.subchannel) = 'unknown') then 'Organic NonBrand'
            when ((lower(tb1.visitreferrer) like '%facebook%'
                  or lower(tb1.visitreferrer) like '%twitter%')
                 and lower(tb3.subchannel) = 'unknown') then 'Social Media Organic'
            when (lower(tb1.visitreferrer) not like '%google%'
                 and lower(tb1.visitreferrer) not like '%bing%'
                 and lower(tb1.visitreferrer) not like '%yahoo%'
                 and lower(tb1.visitreferrer) not like '%facebook%'
                 and lower(tb1.visitreferrer) not like '%twitter%'
                 and lower(tb1.visitreferrer) like '%ancestry.com%'
                 and lower(tb1.visitreferrer) not like '%ancestry.com.au%'
                 and tb1.visitreferrer != '0' --- double check
                 and lower(tb3.subchannel) = 'unknown') then 'Internal Referrals'
            when (lower(tb1.visitreferrer) not like '%google%'
                 and lower(tb1.visitreferrer) not like '%bing%'
                 and lower(tb1.visitreferrer) not like '%yahoo%'
                 and lower(tb1.visitreferrer) not like '%facebook%'
                 and lower(tb1.visitreferrer) not like '%twitter%'
                 and not (lower(tb1.visitreferrer) like '%ancestry.com%'
                 and lower(tb1.visitreferrer) not like '%ancestry.com.au%')
                 and tb1.visitreferrer != '0' --- double check
                 and lower(tb3.subchannel) = 'unknown') then 'Geo-Redirect'
            when (tb1.visitreferrer = '0'
                 and tb2.entrypagenamedescription like '%: home%'
                 and lower(tb3.subchannel) = 'unknown') then 'Direct Brand'
            when (tb1.visitreferrer = '0'
                 and tb2.entrypagenamedescription not like '%: home%'
                 and lower(tb3.subchannel) = 'unknown') then 'Dark Traffic'
            else tb3.subchannel end subchannel
into a.feng_us_factvisits_tmp
from p.fact_visits tb1
    join p.dim_entrypagename tb2 on tb1.entrypagenameid = tb2.entrypagenameid
    join p.dim_promotion tb3 on tb1.promotionid = tb3.promotionid
    left join p.dim_useragent tb4 on tb1.useragentstring = tb4.useragentstring
where tb1.siteid = 3713
go

select top 100 * from a.feng_us_factvisits_tmp
go

select subchannel, count(*) cnt from a.feng_us_factvisits_tmp
group by subchannel
go
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
------------------ UCDMID backward fill for same visitor id --------------------
--------------------------------------------------------------------------------
-- data saved in: a.feng_us_factvisits_ucdmid_bwfill                          --
--------------------------------------------------------------------------------
select dropif('a', 'feng_us_factvisits_tmp2')
go

-- for any visitorid, if is has at least one record with none-zero ucdmid,    --
-- save all records with that visitorid                                       --
select servertimemst, ucdmid, visitorid, orderid,
       freetrialorders, hardofferorders, dnaorders, subchannel,
       devicegroupdescription, browserdescription, operatingsystemdescription
into a.feng_us_factvisits_tmp2
from a.feng_us_factvisits_tmp
where visitorid in (select visitorid
                    from a.feng_us_factvisits_tmp
                    where ucdmid != '00000000-0000-0000-0000-000000000000')
go

select dropif('a', 'feng_us_factvisits_ucdmid_bwfill')
go

select servertimemst
     , case when ucdmid != '00000000-0000-0000-0000-000000000000' then ucdmid
            else newucdmid
       end as ucdmid
     , visitorid
     , orderid
     , freetrialorders
     , hardofferorders
     , dnaorders
     , subchannel
     , devicegroupdescription
     , browserdescription
     , operatingsystemdescription
into a.feng_us_factvisits_ucdmid_bwfill
from 
    (
     select orgucdmid as ucdmid
          , orgservertimemst as servertimemst
          , visitorid
          , orderid
          , freetrialorders
          , hardofferorders
          , dnaorders
          , subchannel
          , devicegroupdescription
          , browserdescription
          , operatingsystemdescription
          , case when forucdmid is not null then substr(forucdmid, 21)
                 else orgucdmid
            end as newucdmid
     from
         (select orgucdmid
               , orgservertimemst
               , visitorid
               , orderid
               , freetrialorders
               , hardofferorders
               , dnaorders
               , subchannel
               , devicegroupdescription
               , browserdescription
               , operatingsystemdescription
               , min(forucdmid) forucdmid
               -- find the earliest matching record
               -- forucdmid starts with timestamp as character, ends with 
               -- corresponding non-zero ucdmid
          from (-- be careful: there could be multiple ucdmid matching same visitorid
                -- for each matching ucdmid, find the earlist servertime
                -- satifying the visitorid and servertime constraintss
                select tb1.ucdmid orgucdmid
                     , tb1.servertimemst orgservertimemst
                     , tb1.visitorid
                     , tb1.orderid
                     , tb1.freetrialorders
                     , tb1.hardofferorders
                     , tb1.dnaorders
                     , tb1.subchannel
                     , tb1.devicegroupdescription
                     , tb1.browserdescription
                     , tb1.operatingsystemdescription
                     , cast(min(tb2.servertimemst) as varchar(100)) || '*' || tb2.ucdmid as forucdmid
                     -- if forucdmid is null, it means for that visitorid,
                     -- all records have zero ucdmid, 
                     -- or non-zero ucdmid does not satisfy time constraints
                     -- we only do backward fill, not forward fill
                from a.feng_us_factvisits_tmp2 tb1
                    left join (select *
                               from a.feng_us_factvisits_tmp2
                               where ucdmid != '00000000-0000-0000-0000-000000000000') tb2
                        on (tb1.visitorid = tb2.visitorid 
                            and tb1.servertimemst < tb2.servertimemst
                            and datediff(day, tb1.servertimemst, tb2.servertimemst) <= 30)
                group by tb1.ucdmid, tb1.servertimemst, tb2.ucdmid, tb1.visitorid, tb1.orderid,
                         tb1.freetrialorders, tb1.hardofferorders, tb1.dnaorders, tb1.subchannel,
                         tb1.devicegroupdescription, tb1.browserdescription, tb1.operatingsystemdescription
               )
          group by orgucdmid, orgservertimemst, visitorid, orderid, freetrialorders, hardofferorders, dnaorders,
                   subchannel, devicegroupdescription, browserdescription, operatingsystemdescription
         )
    ) 
go


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
