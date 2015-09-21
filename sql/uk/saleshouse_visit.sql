select dropif('a', 'feng_uktv_saleshouse')
go

create table a.feng_uktv_saleshouse (
    datetimemststr varchar(100),
    SKY int,
    C4DIGITAL int,
    ITVDIGITAL int,
    ITV int,
    CHANNEL5 int,
    C5DIGITAL int,
    CHANNEL4 int,
    ITVBREAKFAST int
)
go

GRANT SELECT, INSERT, UPDATE, DELETE ON a.feng_uktv_saleshouse TO group analysts
GO
GRANT SELECT, INSERT, UPDATE, DELETE ON a.feng_uktv_saleshouse TO group biteam
GO
GRANT SELECT, INSERT, UPDATE, DELETE ON a.feng_uktv_saleshouse TO group intlanalysts
GO
GRANT SELECT ON a.feng_uktv_saleshouse TO tableau
GO

copy a.feng_uktv_saleshouse from '/mnt/matrix/load/Feng/saleshouse.csv' 
    delimiter',' 
    removequotes 
    maxerror 0
    ignoreheader 1
go

alter table a.feng_uktv_saleshouse add datetimemst timestamp
go
update a.feng_uktv_saleshouse
set datetimemst = cast(datetimemststr as timestamp)
from a.feng_uktv_saleshouse
go

alter table a.feng_uktv_saleshouse add Total int
go
update a.feng_uktv_saleshouse
set Total = sky + c4digital + itvdigital + itv + channel5 + c5digital + channel4 + itvbreakfast
from a.feng_uktv_saleshouse
go

alter table a.feng_uktv_saleshouse drop column datetimemststr
go

select * from a.feng_uktv_saleshouse
go


select dropif('a', 'feng_tmp_saleshouse')
go

select tb1.*
     , tb2.*
into a.feng_tmp_saleshouse
from (select *
      from a.feng_uk_visit_tv_signup
      where trunc(servertimemst) >= '2015-01-01' and trunc(servertimemst) < '2015-07-01'
          and subchannel in ('Paid Search – Brand', 'Paid Search – NonBrand', 'Organic Brand', 'Direct Homepage', 'Direct Non-Homepage', 'Geo-Redirect')) tb1
    join (select *
               , dateadd(second, 30, datetimemst) datetimeplus30s
               , dateadd(second, 360, datetimemst) datetimeplus360s
          from a.feng_uktv_saleshouse) tb2
        on (tb1.servertimemst < tb2.datetimeplus360s
            and tb1.servertimemst >= tb2.datetimeplus30s)
go


select sum(tvweights_mt_decay * SKY / Total) sky
     , sum(tvweights_mt_decay * C4DIGITAL / Total) c4digital
     , sum(tvweights_mt_decay * ITVDIGITAL / Total) itvdigital
     , sum(tvweights_mt_decay * ITV / Total) itv
     , sum(tvweights_mt_decay * CHANNEL5 / Total) channel5
     , sum(tvweights_mt_decay * C5DIGITAL / Total) c5digital
     , sum(tvweights_mt_decay * CHANNEL4 / Total) channel4
     , sum(tvweights_mt_decay * ITVBREAKFAST / Total) itvbreakfast
     , sum(tvweights_mt_decay)
from a.feng_tmp_saleshouse
go

select sum(tvweights_mt_decay * SKY / Total) / case when sum(sky) > 0 then sum(sky) else 1 end sky
     , sum(tvweights_mt_decay * C4DIGITAL / Total) / case when sum(c4digital) > 0 then sum(c4digital) else 1 end c4digital
     , sum(tvweights_mt_decay * ITVDIGITAL / Total) / case when sum(itvdigital) > 0 then sum(itvdigital) else 1 end itvdigital
     , sum(tvweights_mt_decay * ITV / Total) / case when sum(itv) > 0 then sum(itv) else 1 end itv
     , sum(tvweights_mt_decay * CHANNEL5 / Total) / case when sum(channel5) > 0 then sum(channel5) else 1 end channel5
     , sum(tvweights_mt_decay * C5DIGITAL / Total) / case when sum(c5digital) > 0 then sum(c5digital) else 1 end c5digital
     , sum(tvweights_mt_decay * CHANNEL4 / Total) / case when sum(channel4) > 0 then sum(channel4) else 1 end channel4
     , sum(tvweights_mt_decay * ITVBREAKFAST / Total) / case when sum(itvbreakfast) > 0 then sum(itvbreakfast) else 1 end itvbreakfast
     , sum(tvweights_mt_decay) / sum(total) Average
from a.feng_tmp_saleshouse
go

