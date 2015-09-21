select dropif('a', 'feng_uk_visit_tv_signup_tmp')
go

select tb1.*, tvcount, impactalladults
into a.feng_uk_visit_tv_signup_tmp
from a.feng_uk_visitandsignup tb1
    left join (select ucdmid, servertimemst, rdnum, sum(tvindicator) tvcount, sum(impactalladults) impactalladults
               from a.feng_uk2015_visitandtv
               group by ucdmid, servertimemst, rdnum
               having sum(tvindicator) > 0) tb2 
        on tb1.ucdmid = tb2.ucdmid 
            and tb1.servertimemst = tb2.servertimemst
            and tb1.rdnum = tb2.rdnum
go


select dropif('a', 'feng_uk_visit_tv_signup')
go

select tb1.*
     , tb2.tvbrandpaid, tb2.tvbrandorganic
     , tb2.tvnonbrandpaid, tb2.tvnonbrandorganic
     , tb2.tvdirecthp, tb2.tvdirectnonhp
into a.feng_uk_visit_tv_signup
from a.feng_uk_visit_tv_signup_tmp tb1
    left join a.feng_uktv_weights tb2
        on substr(cast(tb1.servertimemst as varchar(100)), 1, 16) = substr(cast(tb2.datetime as varchar(100)), 1, 16)
go

drop table a.feng_uk_visit_tv_signup_tmp
go


alter table a.feng_uk_visit_tv_signup add tvweights_ft float
go
alter table a.feng_uk_visit_tv_signup add tvweights_lt float
go
alter table a.feng_uk_visit_tv_signup add tvweights_mt float
go
alter table a.feng_uk_visit_tv_signup add firsttouchweights_update float
go
alter table a.feng_uk_visit_tv_signup add lasttouchweights_update float
go
alter table a.feng_uk_visit_tv_signup add multitouchweights_update float
go


update a.feng_uk_visit_tv_signup
set tvweights_ft = case when tvcount > 0 and subchannel = 'Paid Search – Brand' then firsttouchweights * tvbrandpaid
                        when tvcount > 0 and subchannel = 'Organic Brand' then firsttouchweights * tvbrandorganic
                        when tvcount > 0 and subchannel = 'Paid Search – NonBrand' then firsttouchweights * tvnonbrandpaid
                        when tvcount > 0 and subchannel = 'Organic NonBrand' then firsttouchweights * tvnonbrandorganic
                        when tvcount > 0 and subchannel = 'Direct Homepage' then firsttouchweights * tvdirecthp
                        when tvcount > 0 and subchannel = 'Direct Non-Homepage' then firsttouchweights * tvdirectnonhp
                        else 0 end
from a.feng_uk_visit_tv_signup
go
update a.feng_uk_visit_tv_signup
set tvweights_lt = case when tvcount > 0 and subchannel = 'Paid Search – Brand' then lasttouchweights * tvbrandpaid
                        when tvcount > 0 and subchannel = 'Organic Brand' then lasttouchweights * tvbrandorganic
                        when tvcount > 0 and subchannel = 'Paid Search – NonBrand' then lasttouchweights * tvnonbrandpaid
                        when tvcount > 0 and subchannel = 'Organic NonBrand' then lasttouchweights * tvnonbrandorganic
                        when tvcount > 0 and subchannel = 'Direct Homepage' then lasttouchweights * tvdirecthp
                        when tvcount > 0 and subchannel = 'Direct Non-Homepage' then lasttouchweights * tvdirectnonhp
                        else 0 end
from a.feng_uk_visit_tv_signup
go
update a.feng_uk_visit_tv_signup
set tvweights_mt = case when tvcount > 0 and subchannel = 'Paid Search – Brand' then multitouchweights * tvbrandpaid
                        when tvcount > 0 and subchannel = 'Organic Brand' then multitouchweights * tvbrandorganic
                        when tvcount > 0 and subchannel = 'Paid Search – NonBrand' then multitouchweights * tvnonbrandpaid
                        when tvcount > 0 and subchannel = 'Organic NonBrand' then multitouchweights * tvnonbrandorganic
                        when tvcount > 0 and subchannel = 'Direct Homepage' then multitouchweights * tvdirecthp
                        when tvcount > 0 and subchannel = 'Direct Non-Homepage' then multitouchweights * tvdirectnonhp
                        else 0 end
from a.feng_uk_visit_tv_signup
go
update a.feng_uk_visit_tv_signup
set firsttouchweights_update = firsttouchweights - tvweights_ft
go
update a.feng_uk_visit_tv_signup
set lasttouchweights_update = lasttouchweights - tvweights_lt
go
update a.feng_uk_visit_tv_signup
set multitouchweights_update = multitouchweights - tvweights_mt
go




alter table a.feng_uk_visit_tv_signup add tvweights_ft_invisit float
go
alter table a.feng_uk_visit_tv_signup add tvweights_lt_invisit float
go
alter table a.feng_uk_visit_tv_signup add tvweights_mt_invisit float
go



update a.feng_uk_visit_tv_signup
set tvweights_ft_invisit = case when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and subchannel = 'Paid Search – Brand' then firsttouchweights * tvbrandpaid
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and subchannel = 'Organic Brand' then firsttouchweights * tvbrandorganic
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and subchannel = 'Paid Search – NonBrand' then firsttouchweights * tvnonbrandpaid
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and subchannel = 'Organic NonBrand' then firsttouchweights * tvnonbrandorganic
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and subchannel = 'Direct Homepage' then firsttouchweights * tvdirecthp
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and subchannel = 'Direct Non-Homepage' then firsttouchweights * tvdirectnonhp
                                else 0 end
from a.feng_uk_visit_tv_signup
go
update a.feng_uk_visit_tv_signup
set tvweights_lt_invisit = case when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and subchannel = 'Paid Search – Brand' then lasttouchweights * tvbrandpaid
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and subchannel = 'Organic Brand' then lasttouchweights * tvbrandorganic
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and subchannel = 'Paid Search – NonBrand' then lasttouchweights * tvnonbrandpaid
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and subchannel = 'Organic NonBrand' then lasttouchweights * tvnonbrandorganic
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and subchannel = 'Direct Homepage' then lasttouchweights * tvdirecthp
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and subchannel = 'Direct Non-Homepage' then lasttouchweights * tvdirectnonhp
                                else 0 end
from a.feng_uk_visit_tv_signup
go
update a.feng_uk_visit_tv_signup
set tvweights_mt_invisit = case when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and subchannel = 'Paid Search – Brand' then multitouchweights * tvbrandpaid
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and subchannel = 'Organic Brand' then multitouchweights * tvbrandorganic
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and subchannel = 'Paid Search – NonBrand' then multitouchweights * tvnonbrandpaid
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and subchannel = 'Organic NonBrand' then multitouchweights * tvnonbrandorganic
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and subchannel = 'Direct Homepage' then multitouchweights * tvdirecthp
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and subchannel = 'Direct Non-Homepage' then multitouchweights * tvdirectnonhp
                                else 0 end
from a.feng_uk_visit_tv_signup
go


(
select 'TV - invisit' as subchannel
     , 0 as firsttouch, 0 as lasttouch, 0 as multitouch
     , sum(tvweights_ft_invisit) ft_update, sum(tvweights_lt_invisit) lt_update, sum(tvweights_mt_invisit) mt_update
from a.feng_uk_visit_tv_signup
)
union
(
select 'TV - 5 min' as subchannel
     , 0 as firsttouch, 0 as lasttouch, 0 as multitouch
     , sum(tvweights_ft) ft_update, sum(tvweights_lt) lt_update, sum(tvweights_mt) mt_update
from a.feng_uk_visit_tv_signup
)
union
(
select subchannel
     , sum(firsttouchweights) firsttouch, sum(lasttouchweights) lastitouch, sum(multitouchweights) multitouch
     , sum(firsttouchweights_update) ft_update, sum(lasttouchweights_update) lt_update, sum(multitouchweights_update) mt_update
from a.feng_uk_visit_tv_signup
group by subchannel
)
go


