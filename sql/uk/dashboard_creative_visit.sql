--------------------------------------------------------------------------------
-- import tv creative data, one column for each creative, 1/0 to show if there is one spot at that minute --
--------------------------------------------------------------------------------

select dropif('a', 'feng_uktv_creative')
go

create table a.feng_uktv_creative (
    datetimemststr varchar(100),
    TravelWoman30FreeTrial int,
    Postman int,
    ComingHomefree14daytrial int,
    ComingHome int,
    PostmanFreeAccess int,
    TravelWoman int,
    FreeAccess int,
    WW1 int,
    WW1AlternativeCut int,
    Remembrance int,
    FollowTheLeaf int,
    InspiredJourneyDNA int,
    InspiredJourneyCore int
)
go

GRANT SELECT, INSERT, UPDATE, DELETE ON a.feng_uktv_creative TO group analysts
GO
GRANT SELECT, INSERT, UPDATE, DELETE ON a.feng_uktv_creative TO group biteam
GO
GRANT SELECT, INSERT, UPDATE, DELETE ON a.feng_uktv_creative TO group intlanalysts
GO
GRANT SELECT ON a.feng_uktv_creative TO tableau
GO

copy a.feng_uktv_creative from '/mnt/matrix/load/Feng/creative.csv' 
    delimiter',' 
    removequotes 
    maxerror 0
    ignoreheader 1
go

alter table a.feng_uktv_creative add datetimemst timestamp
go
update a.feng_uktv_creative
set datetimemst = cast(datetimemststr as timestamp)
from a.feng_uktv_creative
go

alter table a.feng_uktv_creative add Total int
go
update a.feng_uktv_creative
set Total = TravelWoman30FreeTrial +
    Postman +
    ComingHomefree14daytrial +
    ComingHome +
    PostmanFreeAccess +
    TravelWoman +
    FreeAccess +
    WW1 +
    WW1AlternativeCut +
    Remembrance +
    FollowTheLeaf +
    InspiredJourneyDNA +
    InspiredJourneyCore
from a.feng_uktv_creative
go

alter table a.feng_uktv_creative drop column datetimemststr
go

--------------------------------------------------------------------------------
-- join with attribution table --
--------------------------------------------------------------------------------

select dropif('a', 'feng_tmp_creative')
go

select tb1.*
     , tb2.*
into a.feng_tmp_creative
from (select *
      from a.feng_uk_visit_tv_signup
      where trunc(servertimemst) >= '2015-01-01' and trunc(servertimemst) < '2015-07-01'
          and subchannel in ('Paid Search – Brand', 'Paid Search – NonBrand', 'Organic Brand', 'Organic NonBrand', 'Direct Homepage', 'Direct Non-Homepage', 'Geo-Redirect')) tb1
    join (select *   ---  you can use left join to keep all data, now use "join" to include only TV related data
                 , dateadd(minute, 5, datetimemst) datetimeplus5min
--               , dateadd(second, 30, datetimemst) datetimeplus30s
--               , dateadd(second, 360, datetimemst) datetimeplus360s
          from a.feng_uktv_creative) tb2
        on (tb1.servertimemst < tb2.datetimeplus5min
            and tb1.servertimemst > tb2.datetimemst)
go

select dropif('a', 'feng_uk_tvcreative')
go


--------------------------------------------------------------------------------
-- one example to calculate monthly contribution from each creative using decaying rule --
-- here I don't include NonBrand search --
--------------------------------------------------------------------------------

select ucdmid, servertimemst, signupcreatedate, subchannel, 
       new_freetrialorders, new_hardofferorders,
       tvweights_ft_decay, tvweights_lt_decay, tvweights_mt_decay,
       firsttouchweights_update_decay, lasttouchweights_update_decay, multitouchweights_update_decay,
       travelwoman30freetrial, postman, cominghomefree14daytrial, cominghome, postmanfreeaccess, travelwoman, 
       freeaccess, ww1, ww1alternativecut, remembrance, followtheleaf, inspiredjourneydna, inspiredjourneycore, 
       total, datetimemst tvtimemst
into a.feng_uk_tvcreative
from a.feng_tmp_creative
where subchannel not in ('Paid Search – NonBrand', 'Organic NonBrand')
go

select top 10 * from a.feng_uk_tvcreative
go

select datepart(month, signupcreatedate) month_num
     , sum(tvweights_mt_decay * TravelWoman30FreeTrial / Total) TravelWoman30FreeTrial
     , sum(tvweights_mt_decay * Postman / Total) Postman
     , sum(tvweights_mt_decay * ComingHomefree14daytrial / Total) ComingHomefree14daytrial
     , sum(tvweights_mt_decay * ComingHome / Total) ComingHome
     , sum(tvweights_mt_decay * PostmanFreeAccess / Total) PostmanFreeAccess
     , sum(tvweights_mt_decay * TravelWoman / Total) TravelWoman
     , sum(tvweights_mt_decay * FreeAccess / Total) FreeAccess
     , sum(tvweights_mt_decay * WW1 / Total) WW1
     , sum(tvweights_mt_decay * WW1AlternativeCut / Total) WW1AlternativeCut
     , sum(tvweights_mt_decay * Remembrance / Total) Remembrance
     , sum(tvweights_mt_decay * FollowTheLeaf / Total) FollowTheLeaf
     , sum(tvweights_mt_decay * InspiredJourneyDNA / Total) InspiredJourneyDNA
     , sum(tvweights_mt_decay * InspiredJourneyCore / Total) InspiredJourneyCore
     , sum(tvweights_mt_decay) totalattribution
from a.feng_uk_tvcreative
group by 1
go
