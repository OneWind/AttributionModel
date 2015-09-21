select dropif('a', 'feng_us_visit_tv_signup_tmp')
go

select tb1.*
     , tvcount
     , imps
     , case when ustimezone in ('EST', 'CST') then 'east'
            when ustimezone in ('PST', 'MST') then 'west'
            else 'non-us' end as coast
into a.feng_us_visit_tv_signup_tmp
from a.feng_us_visitandsignup tb1
    left join (select ucdmid, servertimemst, rdnum, sum(tvindicator) tvcount, sum(imps) imps
               from a.feng_us2015_visitandtv
               group by ucdmid, servertimemst, rdnum
               having sum(tvindicator) > 0) tb2 
        on tb1.ucdmid = tb2.ucdmid 
            and tb1.servertimemst = tb2.servertimemst
            and tb1.rdnum = tb2.rdnum
go

--select count(*) from a.feng_us_visit_tv_signup_tmp
--go
--2,753,769

select dropif('a', 'feng_us_visit_tv_signup_tmp2')
go

select tb1.*
     , tb2.tvbrandpaideast, tb2.tvbrandorganiceast
     , tb2.tvnonbrandpaideast, tb2.tvnonbrandorganiceast
     , tb2.tvdirecthpeast, tb2.tvdirectnonhpeast
into a.feng_us_visit_tv_signup_tmp2
from a.feng_us_visit_tv_signup_tmp tb1
    left join (select *, 'east' coast
               from a.feng_ustv_weights_east) tb2
        on (substr(cast(tb1.servertimemst as varchar(100)), 1, 16) = substr(cast(tb2.datetime as varchar(100)), 1, 16)
            and tb1.coast = tb2.coast)
go


select dropif('a', 'feng_us_visit_tv_signup')
go

select tb1.*
     , tb2.tvbrandpaidwest, tb2.tvbrandorganicwest
     , tb2.tvnonbrandpaidwest, tb2.tvnonbrandorganicwest
     , tb2.tvdirecthpwest, tb2.tvdirectnonhpwest
into a.feng_us_visit_tv_signup
from a.feng_us_visit_tv_signup_tmp2 tb1
    left join (select *, 'west' coast
               from a.feng_ustv_weights_west) tb2
        on (substr(cast(tb1.servertimemst as varchar(100)), 1, 16) = substr(cast(tb2.datetime as varchar(100)), 1, 16)
            and tb1.coast = tb2.coast)
go

drop table a.feng_us_visit_tv_signup_tmp
go
drop table a.feng_us_visit_tv_signup_tmp2
go


alter table a.feng_us_visit_tv_signup add tvweights_ft float
go
alter table a.feng_us_visit_tv_signup add tvweights_lt float
go
alter table a.feng_us_visit_tv_signup add tvweights_mt float
go
alter table a.feng_us_visit_tv_signup add firsttouchweights_update float
go
alter table a.feng_us_visit_tv_signup add lasttouchweights_update float
go
alter table a.feng_us_visit_tv_signup add multitouchweights_update float
go


update a.feng_us_visit_tv_signup
set tvweights_ft = case when tvcount > 0 and coast = 'east' and subchannel = 'Paid Search – Brand' then firsttouchweights * tvbrandpaideast
                        when tvcount > 0 and coast = 'east' and subchannel = 'Organic Brand' then firsttouchweights * tvbrandorganiceast
                        when tvcount > 0 and coast = 'east' and subchannel = 'Paid Search – NonBrand' then firsttouchweights * tvnonbrandpaideast
                        when tvcount > 0 and coast = 'east' and subchannel = 'Organic NonBrand' then firsttouchweights * tvnonbrandorganiceast
                        when tvcount > 0 and coast = 'east' and subchannel = 'Direct Homepage' then firsttouchweights * tvdirecthpeast
                        when tvcount > 0 and coast = 'east' and subchannel = 'Direct Non-Homepage' then firsttouchweights * tvdirectnonhpeast
                        when tvcount > 0 and coast = 'west' and subchannel = 'Paid Search – Brand' then firsttouchweights * tvbrandpaidwest
                        when tvcount > 0 and coast = 'west' and subchannel = 'Organic Brand' then firsttouchweights * tvbrandorganicwest
                        when tvcount > 0 and coast = 'west' and subchannel = 'Paid Search – NonBrand' then firsttouchweights * tvnonbrandpaidwest
                        when tvcount > 0 and coast = 'west' and subchannel = 'Organic NonBrand' then firsttouchweights * tvnonbrandorganicwest
                        when tvcount > 0 and coast = 'west' and subchannel = 'Direct Homepage' then firsttouchweights * tvdirecthpwest
                        when tvcount > 0 and coast = 'west' and subchannel = 'Direct Non-Homepage' then firsttouchweights * tvdirectnonhpwest
                        else 0 end
from a.feng_us_visit_tv_signup
go
update a.feng_us_visit_tv_signup
set tvweights_lt = case when tvcount > 0 and coast = 'east' and subchannel = 'Paid Search – Brand' then lasttouchweights * tvbrandpaideast
                        when tvcount > 0 and coast = 'east' and subchannel = 'Organic Brand' then lasttouchweights * tvbrandorganiceast
                        when tvcount > 0 and coast = 'east' and subchannel = 'Paid Search – NonBrand' then lasttouchweights * tvnonbrandpaideast
                        when tvcount > 0 and coast = 'east' and subchannel = 'Organic NonBrand' then lasttouchweights * tvnonbrandorganiceast
                        when tvcount > 0 and coast = 'east' and subchannel = 'Direct Homepage' then lasttouchweights * tvdirecthpeast
                        when tvcount > 0 and coast = 'east' and subchannel = 'Direct Non-Homepage' then lasttouchweights * tvdirectnonhpeast
                        when tvcount > 0 and coast = 'west' and subchannel = 'Paid Search – Brand' then lasttouchweights * tvbrandpaidwest
                        when tvcount > 0 and coast = 'west' and subchannel = 'Organic Brand' then lasttouchweights * tvbrandorganicwest
                        when tvcount > 0 and coast = 'west' and subchannel = 'Paid Search – NonBrand' then lasttouchweights * tvnonbrandpaidwest
                        when tvcount > 0 and coast = 'west' and subchannel = 'Organic NonBrand' then lasttouchweights * tvnonbrandorganicwest
                        when tvcount > 0 and coast = 'west' and subchannel = 'Direct Homepage' then lasttouchweights * tvdirecthpwest
                        when tvcount > 0 and coast = 'west' and subchannel = 'Direct Non-Homepage' then lasttouchweights * tvdirectnonhpwest
                        else 0 end
from a.feng_us_visit_tv_signup
go
update a.feng_us_visit_tv_signup
set tvweights_mt = case when tvcount > 0 and coast = 'east' and subchannel = 'Paid Search – Brand' then multitouchweights * tvbrandpaideast
                        when tvcount > 0 and coast = 'east' and subchannel = 'Organic Brand' then multitouchweights * tvbrandorganiceast
                        when tvcount > 0 and coast = 'east' and subchannel = 'Paid Search – NonBrand' then multitouchweights * tvnonbrandpaideast
                        when tvcount > 0 and coast = 'east' and subchannel = 'Organic NonBrand' then multitouchweights * tvnonbrandorganiceast
                        when tvcount > 0 and coast = 'east' and subchannel = 'Direct Homepage' then multitouchweights * tvdirecthpeast
                        when tvcount > 0 and coast = 'east' and subchannel = 'Direct Non-Homepage' then multitouchweights * tvdirectnonhpeast
                        when tvcount > 0 and coast = 'west' and subchannel = 'Paid Search – Brand' then multitouchweights * tvbrandpaidwest
                        when tvcount > 0 and coast = 'west' and subchannel = 'Organic Brand' then multitouchweights * tvbrandorganicwest
                        when tvcount > 0 and coast = 'west' and subchannel = 'Paid Search – NonBrand' then multitouchweights * tvnonbrandpaidwest
                        when tvcount > 0 and coast = 'west' and subchannel = 'Organic NonBrand' then multitouchweights * tvnonbrandorganicwest
                        when tvcount > 0 and coast = 'west' and subchannel = 'Direct Homepage' then multitouchweights * tvdirecthpwest
                        when tvcount > 0 and coast = 'west' and subchannel = 'Direct Non-Homepage' then multitouchweights * tvdirectnonhpwest
                        else 0 end
from a.feng_us_visit_tv_signup
go
update a.feng_us_visit_tv_signup
set firsttouchweights_update = firsttouchweights - tvweights_ft
go
update a.feng_us_visit_tv_signup
set lasttouchweights_update = lasttouchweights - tvweights_lt
go
update a.feng_us_visit_tv_signup
set multitouchweights_update = multitouchweights - tvweights_mt
go




alter table a.feng_us_visit_tv_signup add tvweights_ft_invisit float
go
alter table a.feng_us_visit_tv_signup add tvweights_lt_invisit float
go
alter table a.feng_us_visit_tv_signup add tvweights_mt_invisit float
go



update a.feng_us_visit_tv_signup
set tvweights_ft_invisit = case when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and coast = 'east' and subchannel = 'Paid Search – Brand' then firsttouchweights * tvbrandpaideast
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and coast = 'east' and subchannel = 'Organic Brand' then firsttouchweights * tvbrandorganiceast
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and coast = 'east' and subchannel = 'Paid Search – NonBrand' then firsttouchweights * tvnonbrandpaideast
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and coast = 'east' and subchannel = 'Organic NonBrand' then firsttouchweights * tvnonbrandorganiceast
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and coast = 'east' and subchannel = 'Direct Homepage' then firsttouchweights * tvdirecthpeast
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and coast = 'east' and subchannel = 'Direct Non-Homepage' then firsttouchweights * tvdirectnonhpeast
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and coast = 'west' and subchannel = 'Paid Search – Brand' then firsttouchweights * tvbrandpaidwest
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and coast = 'west' and subchannel = 'Organic Brand' then firsttouchweights * tvbrandorganicwest
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and coast = 'west' and subchannel = 'Paid Search – NonBrand' then firsttouchweights * tvnonbrandpaidwest
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and coast = 'west' and subchannel = 'Organic NonBrand' then firsttouchweights * tvnonbrandorganicwest
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and coast = 'west' and subchannel = 'Direct Homepage' then firsttouchweights * tvdirecthpwest
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and coast = 'west' and subchannel = 'Direct Non-Homepage' then firsttouchweights * tvdirectnonhpwest
                                else 0 end
from a.feng_us_visit_tv_signup
go
update a.feng_us_visit_tv_signup
set tvweights_lt_invisit = case when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and coast = 'east' and subchannel = 'Paid Search – Brand' then lasttouchweights * tvbrandpaideast
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and coast = 'east' and subchannel = 'Organic Brand' then lasttouchweights * tvbrandorganiceast
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and coast = 'east' and subchannel = 'Paid Search – NonBrand' then lasttouchweights * tvnonbrandpaideast
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and coast = 'east' and subchannel = 'Organic NonBrand' then lasttouchweights * tvnonbrandorganiceast
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and coast = 'east' and subchannel = 'Direct Homepage' then lasttouchweights * tvdirecthpeast
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and coast = 'east' and subchannel = 'Direct Non-Homepage' then lasttouchweights * tvdirectnonhpeast
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and coast = 'west' and subchannel = 'Paid Search – Brand' then lasttouchweights * tvbrandpaidwest
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and coast = 'west' and subchannel = 'Organic Brand' then lasttouchweights * tvbrandorganicwest
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and coast = 'west' and subchannel = 'Paid Search – NonBrand' then lasttouchweights * tvnonbrandpaidwest
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and coast = 'west' and subchannel = 'Organic NonBrand' then lasttouchweights * tvnonbrandorganicwest
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and coast = 'west' and subchannel = 'Direct Homepage' then lasttouchweights * tvdirecthpwest
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and coast = 'west' and subchannel = 'Direct Non-Homepage' then lasttouchweights * tvdirectnonhpwest
                                else 0 end
from a.feng_us_visit_tv_signup
go
update a.feng_us_visit_tv_signup
set tvweights_mt_invisit = case when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and coast = 'east' and subchannel = 'Paid Search – Brand' then multitouchweights * tvbrandpaideast
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and coast = 'east' and subchannel = 'Organic Brand' then multitouchweights * tvbrandorganiceast
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and coast = 'east' and subchannel = 'Paid Search – NonBrand' then multitouchweights * tvnonbrandpaideast
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and coast = 'east' and subchannel = 'Organic NonBrand' then multitouchweights * tvnonbrandorganiceast
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and coast = 'east' and subchannel = 'Direct Homepage' then multitouchweights * tvdirecthpeast
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and coast = 'east' and subchannel = 'Direct Non-Homepage' then multitouchweights * tvdirectnonhpeast
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and coast = 'west' and subchannel = 'Paid Search – Brand' then multitouchweights * tvbrandpaidwest
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and coast = 'west' and subchannel = 'Organic Brand' then multitouchweights * tvbrandorganicwest
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and coast = 'west' and subchannel = 'Paid Search – NonBrand' then multitouchweights * tvnonbrandpaidwest
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and coast = 'west' and subchannel = 'Organic NonBrand' then multitouchweights * tvnonbrandorganicwest
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and coast = 'west' and subchannel = 'Direct Homepage' then multitouchweights * tvdirecthpwest
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and coast = 'west' and subchannel = 'Direct Non-Homepage' then multitouchweights * tvdirectnonhpwest
                                else 0 end
from a.feng_us_visit_tv_signup
go


(
select 'TV - invisit' as subchannel
     , 0 as firsttouch, 0 as lasttouch, 0 as multitouch
     , sum(tvweights_ft_invisit) ft_update, sum(tvweights_lt_invisit) lt_update, sum(tvweights_mt_invisit) mt_update
from a.feng_us_visit_tv_signup
)
union
(
select 'TV - 5 min' as subchannel
     , 0 as firsttouch, 0 as lasttouch, 0 as multitouch
     , sum(tvweights_ft) ft_update, sum(tvweights_lt) lt_update, sum(tvweights_mt) mt_update
from a.feng_us_visit_tv_signup
)
union
(
select subchannel
     , sum(firsttouchweights) firsttouch, sum(lasttouchweights) lastitouch, sum(multitouchweights) multitouch
     , sum(firsttouchweights_update) ft_update, sum(lasttouchweights_update) lt_update, sum(multitouchweights_update) mt_update
from a.feng_us_visit_tv_signup
group by subchannel
)
go


