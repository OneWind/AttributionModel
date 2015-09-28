
--------------------------------------------------------------------------------
------------------------------ fact visits for au ------------------------------
--------------------------------------------------------------------------------
-- data saved in: a.feng_au_factvisits_tmp                                    --
-- use useragentstring to retrieve browser, operating system and device group --
--------------------------------------------------------------------------------

-- date lower end: '2015-01-01'

select dropif('a', 'feng_au_factvisits_tmp')
go

select tb1.servertimemst
     , tb1.austate
     , tb1.autimezone
     , tb1.ucdmid
     , tb1.prospectid
     , tb1.visitorid
     , tb1.freetrialorders
     , tb1.hardofferorders
--     , tb1.dnaorders
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
     , tb1.visitreferrer
     , tb1.pageurl
     , case when ((lower(tb1.visitreferrer) like '%google.%'
                  or lower(tb1.visitreferrer) like '%bing.%'
                  or lower(tb1.visitreferrer) like '%yahoo.%'
                  or lower(tb1.visitreferrer) like '%xfinity.%'
                  or lower(tb1.visitreferrer) like '%aol.com%'
                  or lower(tb1.visitreferrer) like '%duckduckgo.com%'
                  or lower(tb1.visitreferrer) like '%ask.com%'
                  or lower(tb1.visitreferrer) like '%wow.com%')
                 and tb2.entrypagenamedescription like '%: home%'
                 and lower(tb3.subchannel) = 'unknown') then 'Organic Brand'
            when ((lower(tb1.visitreferrer) like '%google.%'
                  or lower(tb1.visitreferrer) like '%bing.%'
                  or lower(tb1.visitreferrer) like '%yahoo.%'
                  or lower(tb1.visitreferrer) like '%xfinity.%'
                  or lower(tb1.visitreferrer) like '%aol.com%'
                  or lower(tb1.visitreferrer) like '%duckduckgo.com%'
                  or lower(tb1.visitreferrer) like '%ask.com%'
                  or lower(tb1.visitreferrer) like '%wow.com%')
                 and tb2.entrypagenamedescription not like '%: home%'
                 and lower(tb3.subchannel) = 'unknown') then 'Organic NonBrand'
            when ((lower(tb1.visitreferrer) not like '%google.%'
                 and lower(tb1.visitreferrer) not like '%bing.%'
                 and lower(tb1.visitreferrer) not like '%yahoo.%'
                 and lower(tb1.visitreferrer) not like '%xfinity.%'
                 and lower(tb1.visitreferrer) not like '%aol.com%'
                 and lower(tb1.visitreferrer) not like '%duckduckgo.com%'
                 and lower(tb1.visitreferrer) not like '%ask.com%'
                 and lower(tb1.visitreferrer) not like '%wow.com%')
                 and (lower(tb1.visitreferrer) like '%facebook.%'
                  or lower(tb1.visitreferrer) like '%twitter.%'
                  or lower(tb1.visitreferrer) like '%youtube.%')
                 and lower(tb3.subchannel) = 'unknown') then 'Social Media Organic'
            when (lower(tb1.visitreferrer) not like '%google.%'
                 and lower(tb1.visitreferrer) not like '%bing.%'
                 and lower(tb1.visitreferrer) not like '%yahoo.%'
                 and lower(tb1.visitreferrer) not like '%xfinity.%'
                 and lower(tb1.visitreferrer) not like '%aol.com%'
                 and lower(tb1.visitreferrer) not like '%duckduckgo.com%'
                 and lower(tb1.visitreferrer) not like '%ask.com%'
                 and lower(tb1.visitreferrer) not like '%wow.com%'
                 and lower(tb1.visitreferrer) not like '%facebook.%'
                 and lower(tb1.visitreferrer) not like '%twitter.%'
                 and lower(tb1.visitreferrer) not like '%youtube.%'
                 and (lower(tb1.visitreferrer) like '%familytreemaker.com%'
                  or lower(tb1.visitreferrer) like '%findagrave.com%'
                  or lower(tb1.visitreferrer) like '%fold3.com%'
                  or lower(tb1.visitreferrer) like '%genealogy.com%' 
                  or lower(tb1.visitreferrer) like '%newspapers.com%'
                  or lower(tb1.visitreferrer) like '%progenealogists.com%'
                  or lower(tb1.visitreferrer) like '%archives.com%'
                  or (lower(tb1.visitreferrer) like '%ancestry.com.au%'
                      and lower(tb1.visitreferrer) not like '%ancestry.ca%'
--                      and lower(tb1.visitreferrer) not like '%ancestry.com%'
                      and lower(tb1.visitreferrer) not like '%ancestry.de%'
                      and lower(tb1.visitreferrer) not like '%ancestry.se%'
                      and lower(tb1.visitreferrer) not like '%ancestry.mx%'
                      and lower(tb1.visitreferrer) not like '%ancestry.it%'
                      and lower(tb1.visitreferrer) not like '%ancestry.fr%'
                      and lower(tb1.visitreferrer) not like '%ancestry.co.uk%'))
                 and lower(tb3.subchannel) = 'unknown') then 'Internal Referrals'
            when ((lower(tb1.visitreferrer) not like '%google.%'
                 and lower(tb1.visitreferrer) not like '%bing.%'
                 and lower(tb1.visitreferrer) not like '%yahoo.%'
                 and lower(tb1.visitreferrer) not like '%xfinity.%'
                 and lower(tb1.visitreferrer) not like '%aol.com%'
                 and lower(tb1.visitreferrer) not like '%duckduckgo.com%'
                 and lower(tb1.visitreferrer) not like '%ask.com%'
                 and lower(tb1.visitreferrer) not like '%wow.com%'
                 and lower(tb1.visitreferrer) not like '%facebook.%'
                 and lower(tb1.visitreferrer) not like '%twitter.%'
                 and lower(tb1.visitreferrer) not like '%youtube.%'
                 and lower(tb1.visitreferrer) not like '%familytreemaker.com%'
                 and lower(tb1.visitreferrer) not like '%findagrave.com%'
                 and lower(tb1.visitreferrer) not like '%fold3.com%'
                 and lower(tb1.visitreferrer) not like '%genealogy.com%' 
                 and lower(tb1.visitreferrer) not like '%newspapers.com%'
                 and lower(tb1.visitreferrer) not like '%progenealogists.com%'
                 and lower(tb1.visitreferrer) not like '%archives%')
                 and (lower(tb1.visitreferrer) like '%ancestry.co.uk%'
                  or (lower(tb1.visitreferrer) like '%ancestry.com%' 
                      and lower(tb1.visitreferrer) not like '%ancestry.com.au%')
                  or lower(tb1.visitreferrer) like '%ancestry.de%'
                  or lower(tb1.visitreferrer) like '%ancestry.se%'
                  or lower(tb1.visitreferrer) like '%ancestry.mx%'
                  or lower(tb1.visitreferrer) like '%ancestry.it%'
                  or lower(tb1.visitreferrer) like '%ancestry.fr%'
                  or lower(tb2.entrypagenamedescription) like '%geo redirect%')
                 and lower(tb3.subchannel) = 'unknown') then 'Geo-Redirect'
            when ((lower(tb1.visitreferrer) not like '%google.%'
                 and lower(tb1.visitreferrer) not like '%bing.%'
                 and lower(tb1.visitreferrer) not like '%yahoo.%'
                 and lower(tb1.visitreferrer) not like '%xfinity.%'
                 and lower(tb1.visitreferrer) not like '%aol.com%'
                 and lower(tb1.visitreferrer) not like '%duckduckgo.com%'
                 and lower(tb1.visitreferrer) not like '%ask.com%'
                 and lower(tb1.visitreferrer) not like '%wow.com%'
                 and lower(tb1.visitreferrer) not like '%facebook.%'
                 and lower(tb1.visitreferrer) not like '%twitter.%'
                 and lower(tb1.visitreferrer) not like '%youtube.%'
                 and lower(tb1.visitreferrer) not like '%familytreemaker.com%'
                 and lower(tb1.visitreferrer) not like '%findagrave.com%'
                 and lower(tb1.visitreferrer) not like '%fold3.com%'
                 and lower(tb1.visitreferrer) not like '%genealogy.com%' 
                 and lower(tb1.visitreferrer) not like '%newspapers.com%'
                 and lower(tb1.visitreferrer) not like '%progenealogists.com%'
                 and lower(tb1.visitreferrer) not like '%archives%'
                 and lower(tb1.visitreferrer) not like '%ancestry%')
                 and tb1.visitreferrer != '0'
                 and lower(tb3.subchannel) = 'unknown') then 'External Referrals'
            when (tb1.visitreferrer = '0'
                 and (tb2.entrypagenamedescription like '%: home%'
                  or len(tb1.pageurl) - len(replace(tb1.pageurl, '/', '')) < 4)
                 and lower(tb3.subchannel) = 'unknown') then 'Direct Homepage'
            when (tb1.visitreferrer = '0'
                 and not (tb2.entrypagenamedescription like '%: home%'
                     or len(tb1.pageurl) - len(replace(tb1.pageurl, '/', '')) < 4)
                 and lower(tb3.subchannel) = 'unknown') then 'Direct Non-Homepage'
            else tb3.subchannel end subchannel
into a.feng_au_factvisits_tmp
from (select tmp1.*
           , case when tmp1.visitcountryid = 43 then tmp2.visitregiondescription else 'non-au' end as austate
           , case when tmp1.visitcountryid = 43 then tmp2.autimezone else 'non-au' end autimezone
      from p.fact_visits tmp1
          left join (select visitregionid, visitregiondescription, autimezone 
                     from a.feng_au_timezones) tmp2
              on tmp1.visitregionid = tmp2.visitregionid
      where tmp1.siteid = 3718
          and trunc(tmp1.servertimemst) >= '2015-01-01'
     ) tb1
    join p.dim_entrypagename tb2 on tb1.entrypagenameid = tb2.entrypagenameid
    join p.dim_promotion tb3 on tb1.promotionid = tb3.promotionid
    left join p.dim_useragent tb4 on tb1.useragentstring = tb4.useragentstring
go


--select subchannel, count(*) cnt from a.feng_au_factvisits_tmp
--group by subchannel
--go
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
------------------ UCDMID backward fill for same visitor id --------------------
--------------------------------------------------------------------------------
-- data saved in: a.feng_au_factvisits_ucdmid_bwfill                          --
--------------------------------------------------------------------------------
select dropif('a', 'feng_au_factvisits_tmp2')
go

-- for any visitorid, if is has at least one record with none-zero ucdmid,    --
-- save all records with that visitorid                                       --
select servertimemst, ucdmid, visitorid, orderid, visitreferrer, pageurl,
       freetrialorders, hardofferorders, 
--       dnaorders, 
       subchannel, austate, autimezone,
       devicegroupdescription, browserdescription, operatingsystemdescription
into a.feng_au_factvisits_tmp2
from a.feng_au_factvisits_tmp
where visitorid in (select visitorid
                    from a.feng_au_factvisits_tmp
                    where ucdmid != '00000000-0000-0000-0000-000000000000')
go

select dropif('a', 'feng_au_factvisits_ucdmid_bwfill')
go

select servertimemst
     , austate
     , autimezone
     , case when ucdmid != '00000000-0000-0000-0000-000000000000' then ucdmid
            else newucdmid
       end as ucdmid
     , visitorid
     , orderid
     , freetrialorders
     , hardofferorders
--     , dnaorders
     , subchannel
     , devicegroupdescription
     , browserdescription
     , operatingsystemdescription
     , visitreferrer
     , pageurl
     , row_number() over (order by servertimemst) rdnum
into a.feng_au_factvisits_ucdmid_bwfill
from 
    (
     select orgucdmid as ucdmid
          , orgservertimemst as servertimemst
          , austate
          , autimezone
          , visitorid
          , orderid
          , freetrialorders
          , hardofferorders
--          , dnaorders
          , subchannel
          , devicegroupdescription
          , browserdescription
          , operatingsystemdescription
          , visitreferrer
          , pageurl
          , case when forucdmid is not null then substr(forucdmid, 21)
                 else orgucdmid
            end as newucdmid
     from
         (select orgucdmid
               , orgservertimemst
               , austate
               , autimezone
               , visitorid
               , orderid
               , freetrialorders
               , hardofferorders
--               , dnaorders
               , subchannel
               , devicegroupdescription
               , browserdescription
               , operatingsystemdescription
               , visitreferrer
               , pageurl
               , min(forucdmid) forucdmid
               -- find the earliest matching record
               -- forucdmid starts with timestamp as character, ends with 
               -- corresponding non-zero ucdmid
          from (-- be careful: there could be multiple ucdmid matching same visitorid
                -- for each matching ucdmid, find the earlist servertime
                -- satifying the visitorid and servertime constraintss
                select tb1.ucdmid orgucdmid
                     , tb1.servertimemst orgservertimemst
                     , tb1.austate
                     , tb1.autimezone
                     , tb1.visitorid
                     , tb1.orderid
                     , tb1.freetrialorders
                     , tb1.hardofferorders
--                     , tb1.dnaorders
                     , tb1.subchannel
                     , tb1.devicegroupdescription
                     , tb1.browserdescription
                     , tb1.operatingsystemdescription
                     , tb1.visitreferrer
                     , tb1.pageurl
                     , cast(min(tb2.servertimemst) as varchar(100)) || '*' || tb2.ucdmid as forucdmid
                     -- if forucdmid is null, it means for that visitorid,
                     -- all records have zero ucdmid, 
                     -- or non-zero ucdmid does not satisfy time constraints
                     -- we only do backward fill, not forward fill
                from a.feng_au_factvisits_tmp2 tb1
                    left join (select *
                               from a.feng_au_factvisits_tmp2
                               where ucdmid != '00000000-0000-0000-0000-000000000000') tb2
                        on (tb1.visitorid = tb2.visitorid 
                            and tb1.servertimemst < tb2.servertimemst
                            and datediff(day, tb1.servertimemst, tb2.servertimemst) <= 30)
                group by tb1.ucdmid, tb1.servertimemst, tb2.ucdmid, tb1.visitorid, tb1.orderid,
                         tb1.freetrialorders, tb1.hardofferorders, 
--                         tb1.dnaorders, 
                         tb1.subchannel, tb1.austate, tb1.autimezone,
                         tb1.devicegroupdescription, tb1.browserdescription, tb1.operatingsystemdescription,
                         tb1.visitreferrer, tb1.pageurl
               )
          group by orgucdmid, orgservertimemst, visitorid, orderid, freetrialorders, hardofferorders, 
--                   dnaorders,
                   subchannel, devicegroupdescription, browserdescription, operatingsystemdescription,
                   visitreferrer, pageurl, austate, autimezone
         )
    ) 
go

select subchannel, count(*) cnt 
from a.feng_au_factvisits_ucdmid_bwfill
group by subchannel
go

--select subchannel
--     , sum(case when freetrialorders + hardofferorders + dnaorders > 0 then 1.0 else 0.0 end) / count(*) orderratio
--     , count(*) totalvisits
--from a.feng_au_factvisits_ucdmid_bwfill
--group by subchannel
--having count(*) > 100000
--go

select dropif('a', 'feng_au_factvisits_tmp')
go
select dropif('a', 'feng_au_factvisits_tmp2')
go
