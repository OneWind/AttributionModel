select dropif('a', 'feng_au_visit_tv_signup_tmp')
go

select tb1.*
     , tvcount
into a.feng_au_visit_tv_signup_tmp
from a.feng_au_visitandsignup tb1
    left join (select ucdmid, servertimemst, rdnum, sum(tvindicator) tvcount
               from a.feng_au2015_visitandtv
               group by ucdmid, servertimemst, rdnum
               having sum(tvindicator) > 0) tb2 
        on tb1.ucdmid = tb2.ucdmid 
            and tb1.servertimemst = tb2.servertimemst
            and tb1.rdnum = tb2.rdnum
go


select dropif('a', 'feng_au_visit_tv_signup_tmp2')
go

select tb1.*
     , tb2.tvbrandpaidnsw, tb2.tvbrandorganicnsw
     , tb2.tvnonbrandpaidnsw, tb2.tvnonbrandorganicnsw
     , tb2.tvdirecthpnsw, tb2.tvdirectnonhpnsw
into a.feng_au_visit_tv_signup_tmp2
from a.feng_au_visit_tv_signup_tmp tb1
    left join (select *, 'NSW' autimezone 
               from a.feng_autv_weights_nsw) tb2
        on (substr(cast(tb1.servertimemst as varchar(100)), 1, 16) = substr(cast(tb2.datetime as varchar(100)), 1, 16)
            and tb1.autimezone = tb2.autimezone)
go

select dropif('a', 'feng_au_visit_tv_signup_tmp3')
go

select tb1.*
     , tb2.tvbrandpaidsouth, tb2.tvbrandorganicsouth
     , tb2.tvnonbrandpaidsouth, tb2.tvnonbrandorganicsouth
     , tb2.tvdirecthpsouth, tb2.tvdirectnonhpsouth
into a.feng_au_visit_tv_signup_tmp3
from a.feng_au_visit_tv_signup_tmp2 tb1
    left join (select *, 'South' autimezone 
               from a.feng_autv_weights_south) tb2
        on (substr(cast(tb1.servertimemst as varchar(100)), 1, 16) = substr(cast(tb2.datetime as varchar(100)), 1, 16)
            and tb1.autimezone = tb2.autimezone)
go

select dropif('a', 'feng_au_visit_tv_signup_tmp4')
go

select tb1.*
     , tb2.tvbrandpaidwest, tb2.tvbrandorganicwest
     , tb2.tvnonbrandpaidwest, tb2.tvnonbrandorganicwest
     , tb2.tvdirecthpwest, tb2.tvdirectnonhpwest
into a.feng_au_visit_tv_signup_tmp4
from a.feng_au_visit_tv_signup_tmp3 tb1
    left join (select *, 'West' autimezone 
               from a.feng_autv_weights_west) tb2
        on (substr(cast(tb1.servertimemst as varchar(100)), 1, 16) = substr(cast(tb2.datetime as varchar(100)), 1, 16)
            and tb1.autimezone = tb2.autimezone)
go

select dropif('a', 'feng_au_visit_tv_signup_tmp5')
go

select tb1.*
     , tb2.tvbrandpaidqueensland, tb2.tvbrandorganicqueensland
     , tb2.tvnonbrandpaidqueensland, tb2.tvnonbrandorganicqueensland
     , tb2.tvdirecthpqueensland, tb2.tvdirectnonhpqueensland
into a.feng_au_visit_tv_signup_tmp5
from a.feng_au_visit_tv_signup_tmp4 tb1
    left join (select *, 'Queensland' autimezone 
               from a.feng_autv_weights_queensland) tb2
        on (substr(cast(tb1.servertimemst as varchar(100)), 1, 16) = substr(cast(tb2.datetime as varchar(100)), 1, 16)
            and tb1.autimezone = tb2.autimezone)
go

select dropif('a', 'feng_au_visit_tv_signup_tmp6')
go

select tb1.*
     , tb2.tvbrandpaidtasmania, tb2.tvbrandorganictasmania
     , tb2.tvnonbrandpaidtasmania, tb2.tvnonbrandorganictasmania
     , tb2.tvdirecthptasmania, tb2.tvdirectnonhptasmania
into a.feng_au_visit_tv_signup_tmp6
from a.feng_au_visit_tv_signup_tmp5 tb1
    left join (select *, 'Tasmania' autimezone 
               from a.feng_autv_weights_tasmania) tb2
        on (substr(cast(tb1.servertimemst as varchar(100)), 1, 16) = substr(cast(tb2.datetime as varchar(100)), 1, 16)
            and tb1.autimezone = tb2.autimezone)
go


select dropif('a', 'feng_au_visit_tv_signup')
go

select tb1.*
     , tb2.tvbrandpaidvictoria, tb2.tvbrandorganicvictoria
     , tb2.tvnonbrandpaidvictoria, tb2.tvnonbrandorganicvictoria
     , tb2.tvdirecthpvictoria, tb2.tvdirectnonhpvictoria
into a.feng_au_visit_tv_signup
from a.feng_au_visit_tv_signup_tmp6 tb1
    left join (select *, 'Victoria' autimezone 
               from a.feng_autv_weights_victoria) tb2
        on (substr(cast(tb1.servertimemst as varchar(100)), 1, 16) = substr(cast(tb2.datetime as varchar(100)), 1, 16)
            and tb1.autimezone = tb2.autimezone)
go

drop table a.feng_au_visit_tv_signup_tmp
go
drop table a.feng_au_visit_tv_signup_tmp2
go
drop table a.feng_au_visit_tv_signup_tmp3
go
drop table a.feng_au_visit_tv_signup_tmp4
go
drop table a.feng_au_visit_tv_signup_tmp5
go
drop table a.feng_au_visit_tv_signup_tmp6
go


alter table a.feng_au_visit_tv_signup add tvweights_ft float
go
alter table a.feng_au_visit_tv_signup add tvweights_lt float
go
alter table a.feng_au_visit_tv_signup add tvweights_mt float
go
alter table a.feng_au_visit_tv_signup add firsttouchweights_update float
go
alter table a.feng_au_visit_tv_signup add lasttouchweights_update float
go
alter table a.feng_au_visit_tv_signup add multitouchweights_update float
go


update a.feng_au_visit_tv_signup
set tvweights_ft = case when tvcount > 0 and autimezone = 'NSW' and subchannel = 'Paid Search – Brand' then firsttouchweights * tvbrandpaidnsw
                        when tvcount > 0 and autimezone = 'NSW' and subchannel = 'Organic Brand' then firsttouchweights * tvbrandorganicnsw
                        when tvcount > 0 and autimezone = 'NSW' and subchannel = 'Paid Search – NonBrand' then firsttouchweights * tvnonbrandpaidnsw
                        when tvcount > 0 and autimezone = 'NSW' and subchannel = 'Organic NonBrand' then firsttouchweights * tvnonbrandorganicnsw
                        when tvcount > 0 and autimezone = 'NSW' and subchannel = 'Direct Homepage' then firsttouchweights * tvdirecthpnsw
                        when tvcount > 0 and autimezone = 'NSW' and subchannel = 'Direct Non-Homepage' then firsttouchweights * tvdirectnonhpnsw
                        when tvcount > 0 and autimezone = 'South' and subchannel = 'Paid Search – Brand' then firsttouchweights * tvbrandpaidsouth
                        when tvcount > 0 and autimezone = 'South' and subchannel = 'Organic Brand' then firsttouchweights * tvbrandorganicsouth
                        when tvcount > 0 and autimezone = 'South' and subchannel = 'Paid Search – NonBrand' then firsttouchweights * tvnonbrandpaidsouth
                        when tvcount > 0 and autimezone = 'South' and subchannel = 'Organic NonBrand' then firsttouchweights * tvnonbrandorganicsouth
                        when tvcount > 0 and autimezone = 'South' and subchannel = 'Direct Homepage' then firsttouchweights * tvdirecthpsouth
                        when tvcount > 0 and autimezone = 'South' and subchannel = 'Paid Search – Brand' then firsttouchweights * tvbrandpaidsouth
                        when tvcount > 0 and autimezone = 'West' and subchannel = 'Organic Brand' then firsttouchweights * tvbrandorganicwest
                        when tvcount > 0 and autimezone = 'West' and subchannel = 'Paid Search – NonBrand' then firsttouchweights * tvnonbrandpaidwest
                        when tvcount > 0 and autimezone = 'West' and subchannel = 'Organic NonBrand' then firsttouchweights * tvnonbrandorganicwest
                        when tvcount > 0 and autimezone = 'West' and subchannel = 'Direct Homepage' then firsttouchweights * tvdirecthpwest
                        when tvcount > 0 and autimezone = 'West' and subchannel = 'Direct Non-Homepage' then firsttouchweights * tvdirectnonhpwest
                        when tvcount > 0 and autimezone = 'West' and subchannel = 'Direct Non-Homepage' then firsttouchweights * tvdirectnonhpwest
                        when tvcount > 0 and autimezone = 'Queensland' and subchannel = 'Paid Search – Brand' then firsttouchweights * tvbrandpaidqueensland
                        when tvcount > 0 and autimezone = 'Queensland' and subchannel = 'Organic Brand' then firsttouchweights * tvbrandorganicqueensland
                        when tvcount > 0 and autimezone = 'Queensland' and subchannel = 'Paid Search – NonBrand' then firsttouchweights * tvnonbrandpaidqueensland
                        when tvcount > 0 and autimezone = 'Queensland' and subchannel = 'Organic NonBrand' then firsttouchweights * tvnonbrandorganicqueensland
                        when tvcount > 0 and autimezone = 'Queensland' and subchannel = 'Direct Homepage' then firsttouchweights * tvdirecthpqueensland
                        when tvcount > 0 and autimezone = 'Queensland' and subchannel = 'Direct Non-Homepage' then firsttouchweights * tvdirectnonhpqueensland
                        when tvcount > 0 and autimezone = 'Tasmania' and subchannel = 'Paid Search – Brand' then firsttouchweights * tvbrandpaidtasmania
                        when tvcount > 0 and autimezone = 'Tasmania' and subchannel = 'Organic Brand' then firsttouchweights * tvbrandorganictasmania
                        when tvcount > 0 and autimezone = 'Tasmania' and subchannel = 'Paid Search – NonBrand' then firsttouchweights * tvnonbrandpaidtasmania
                        when tvcount > 0 and autimezone = 'Tasmania' and subchannel = 'Organic NonBrand' then firsttouchweights * tvnonbrandorganictasmania
                        when tvcount > 0 and autimezone = 'Tasmania' and subchannel = 'Direct Homepage' then firsttouchweights * tvdirecthptasmania
                        when tvcount > 0 and autimezone = 'Tasmania' and subchannel = 'Direct Non-Homepage' then firsttouchweights * tvdirectnonhptasmania
                        when tvcount > 0 and autimezone = 'Victoria' and subchannel = 'Paid Search – Brand' then firsttouchweights * tvbrandpaidvictoria
                        when tvcount > 0 and autimezone = 'Victoria' and subchannel = 'Organic Brand' then firsttouchweights * tvbrandorganicvictoria
                        when tvcount > 0 and autimezone = 'Victoria' and subchannel = 'Paid Search – NonBrand' then firsttouchweights * tvnonbrandpaidvictoria
                        when tvcount > 0 and autimezone = 'Victoria' and subchannel = 'Organic NonBrand' then firsttouchweights * tvnonbrandorganicvictoria
                        when tvcount > 0 and autimezone = 'Victoria' and subchannel = 'Direct Homepage' then firsttouchweights * tvdirecthpvictoria
                        when tvcount > 0 and autimezone = 'Victoria' and subchannel = 'Direct Non-Homepage' then firsttouchweights * tvdirectnonhpvictoria
                        else 0 end
from a.feng_au_visit_tv_signup
go
update a.feng_au_visit_tv_signup
set tvweights_lt = case when tvcount > 0 and autimezone = 'NSW' and subchannel = 'Paid Search – Brand' then lasttouchweights * tvbrandpaidnsw
                        when tvcount > 0 and autimezone = 'NSW' and subchannel = 'Organic Brand' then lasttouchweights * tvbrandorganicnsw
                        when tvcount > 0 and autimezone = 'NSW' and subchannel = 'Paid Search – NonBrand' then lasttouchweights * tvnonbrandpaidnsw
                        when tvcount > 0 and autimezone = 'NSW' and subchannel = 'Organic NonBrand' then lasttouchweights * tvnonbrandorganicnsw
                        when tvcount > 0 and autimezone = 'NSW' and subchannel = 'Direct Homepage' then lasttouchweights * tvdirecthpnsw
                        when tvcount > 0 and autimezone = 'NSW' and subchannel = 'Direct Non-Homepage' then lasttouchweights * tvdirectnonhpnsw
                        when tvcount > 0 and autimezone = 'South' and subchannel = 'Paid Search – Brand' then lasttouchweights * tvbrandpaidsouth
                        when tvcount > 0 and autimezone = 'South' and subchannel = 'Organic Brand' then lasttouchweights * tvbrandorganicsouth
                        when tvcount > 0 and autimezone = 'South' and subchannel = 'Paid Search – NonBrand' then lasttouchweights * tvnonbrandpaidsouth
                        when tvcount > 0 and autimezone = 'South' and subchannel = 'Organic NonBrand' then lasttouchweights * tvnonbrandorganicsouth
                        when tvcount > 0 and autimezone = 'South' and subchannel = 'Direct Homepage' then lasttouchweights * tvdirecthpsouth
                        when tvcount > 0 and autimezone = 'South' and subchannel = 'Paid Search – Brand' then lasttouchweights * tvbrandpaidsouth
                        when tvcount > 0 and autimezone = 'West' and subchannel = 'Organic Brand' then lasttouchweights * tvbrandorganicwest
                        when tvcount > 0 and autimezone = 'West' and subchannel = 'Paid Search – NonBrand' then lasttouchweights * tvnonbrandpaidwest
                        when tvcount > 0 and autimezone = 'West' and subchannel = 'Organic NonBrand' then lasttouchweights * tvnonbrandorganicwest
                        when tvcount > 0 and autimezone = 'West' and subchannel = 'Direct Homepage' then lasttouchweights * tvdirecthpwest
                        when tvcount > 0 and autimezone = 'West' and subchannel = 'Direct Non-Homepage' then lasttouchweights * tvdirectnonhpwest
                        when tvcount > 0 and autimezone = 'West' and subchannel = 'Direct Non-Homepage' then lasttouchweights * tvdirectnonhpwest
                        when tvcount > 0 and autimezone = 'Queensland' and subchannel = 'Paid Search – Brand' then lasttouchweights * tvbrandpaidqueensland
                        when tvcount > 0 and autimezone = 'Queensland' and subchannel = 'Organic Brand' then lasttouchweights * tvbrandorganicqueensland
                        when tvcount > 0 and autimezone = 'Queensland' and subchannel = 'Paid Search – NonBrand' then lasttouchweights * tvnonbrandpaidqueensland
                        when tvcount > 0 and autimezone = 'Queensland' and subchannel = 'Organic NonBrand' then lasttouchweights * tvnonbrandorganicqueensland
                        when tvcount > 0 and autimezone = 'Queensland' and subchannel = 'Direct Homepage' then lasttouchweights * tvdirecthpqueensland
                        when tvcount > 0 and autimezone = 'Queensland' and subchannel = 'Direct Non-Homepage' then lasttouchweights * tvdirectnonhpqueensland
                        when tvcount > 0 and autimezone = 'Tasmania' and subchannel = 'Paid Search – Brand' then lasttouchweights * tvbrandpaidtasmania
                        when tvcount > 0 and autimezone = 'Tasmania' and subchannel = 'Organic Brand' then lasttouchweights * tvbrandorganictasmania
                        when tvcount > 0 and autimezone = 'Tasmania' and subchannel = 'Paid Search – NonBrand' then lasttouchweights * tvnonbrandpaidtasmania
                        when tvcount > 0 and autimezone = 'Tasmania' and subchannel = 'Organic NonBrand' then lasttouchweights * tvnonbrandorganictasmania
                        when tvcount > 0 and autimezone = 'Tasmania' and subchannel = 'Direct Homepage' then lasttouchweights * tvdirecthptasmania
                        when tvcount > 0 and autimezone = 'Tasmania' and subchannel = 'Direct Non-Homepage' then lasttouchweights * tvdirectnonhptasmania
                        when tvcount > 0 and autimezone = 'Victoria' and subchannel = 'Paid Search – Brand' then lasttouchweights * tvbrandpaidvictoria
                        when tvcount > 0 and autimezone = 'Victoria' and subchannel = 'Organic Brand' then lasttouchweights * tvbrandorganicvictoria
                        when tvcount > 0 and autimezone = 'Victoria' and subchannel = 'Paid Search – NonBrand' then lasttouchweights * tvnonbrandpaidvictoria
                        when tvcount > 0 and autimezone = 'Victoria' and subchannel = 'Organic NonBrand' then lasttouchweights * tvnonbrandorganicvictoria
                        when tvcount > 0 and autimezone = 'Victoria' and subchannel = 'Direct Homepage' then lasttouchweights * tvdirecthpvictoria
                        when tvcount > 0 and autimezone = 'Victoria' and subchannel = 'Direct Non-Homepage' then lasttouchweights * tvdirectnonhpvictoria
                        else 0 end
from a.feng_au_visit_tv_signup
go
update a.feng_au_visit_tv_signup
set tvweights_mt = case when tvcount > 0 and autimezone = 'NSW' and subchannel = 'Paid Search – Brand' then multitouchweights * tvbrandpaidnsw
                        when tvcount > 0 and autimezone = 'NSW' and subchannel = 'Organic Brand' then multitouchweights * tvbrandorganicnsw
                        when tvcount > 0 and autimezone = 'NSW' and subchannel = 'Paid Search – NonBrand' then multitouchweights * tvnonbrandpaidnsw
                        when tvcount > 0 and autimezone = 'NSW' and subchannel = 'Organic NonBrand' then multitouchweights * tvnonbrandorganicnsw
                        when tvcount > 0 and autimezone = 'NSW' and subchannel = 'Direct Homepage' then multitouchweights * tvdirecthpnsw
                        when tvcount > 0 and autimezone = 'NSW' and subchannel = 'Direct Non-Homepage' then multitouchweights * tvdirectnonhpnsw
                        when tvcount > 0 and autimezone = 'South' and subchannel = 'Paid Search – Brand' then multitouchweights * tvbrandpaidsouth
                        when tvcount > 0 and autimezone = 'South' and subchannel = 'Organic Brand' then multitouchweights * tvbrandorganicsouth
                        when tvcount > 0 and autimezone = 'South' and subchannel = 'Paid Search – NonBrand' then multitouchweights * tvnonbrandpaidsouth
                        when tvcount > 0 and autimezone = 'South' and subchannel = 'Organic NonBrand' then multitouchweights * tvnonbrandorganicsouth
                        when tvcount > 0 and autimezone = 'South' and subchannel = 'Direct Homepage' then multitouchweights * tvdirecthpsouth
                        when tvcount > 0 and autimezone = 'South' and subchannel = 'Paid Search – Brand' then multitouchweights * tvbrandpaidsouth
                        when tvcount > 0 and autimezone = 'West' and subchannel = 'Organic Brand' then multitouchweights * tvbrandorganicwest
                        when tvcount > 0 and autimezone = 'West' and subchannel = 'Paid Search – NonBrand' then multitouchweights * tvnonbrandpaidwest
                        when tvcount > 0 and autimezone = 'West' and subchannel = 'Organic NonBrand' then multitouchweights * tvnonbrandorganicwest
                        when tvcount > 0 and autimezone = 'West' and subchannel = 'Direct Homepage' then multitouchweights * tvdirecthpwest
                        when tvcount > 0 and autimezone = 'West' and subchannel = 'Direct Non-Homepage' then multitouchweights * tvdirectnonhpwest
                        when tvcount > 0 and autimezone = 'West' and subchannel = 'Direct Non-Homepage' then multitouchweights * tvdirectnonhpwest
                        when tvcount > 0 and autimezone = 'Queensland' and subchannel = 'Paid Search – Brand' then multitouchweights * tvbrandpaidqueensland
                        when tvcount > 0 and autimezone = 'Queensland' and subchannel = 'Organic Brand' then multitouchweights * tvbrandorganicqueensland
                        when tvcount > 0 and autimezone = 'Queensland' and subchannel = 'Paid Search – NonBrand' then multitouchweights * tvnonbrandpaidqueensland
                        when tvcount > 0 and autimezone = 'Queensland' and subchannel = 'Organic NonBrand' then multitouchweights * tvnonbrandorganicqueensland
                        when tvcount > 0 and autimezone = 'Queensland' and subchannel = 'Direct Homepage' then multitouchweights * tvdirecthpqueensland
                        when tvcount > 0 and autimezone = 'Queensland' and subchannel = 'Direct Non-Homepage' then multitouchweights * tvdirectnonhpqueensland
                        when tvcount > 0 and autimezone = 'Tasmania' and subchannel = 'Paid Search – Brand' then multitouchweights * tvbrandpaidtasmania
                        when tvcount > 0 and autimezone = 'Tasmania' and subchannel = 'Organic Brand' then multitouchweights * tvbrandorganictasmania
                        when tvcount > 0 and autimezone = 'Tasmania' and subchannel = 'Paid Search – NonBrand' then multitouchweights * tvnonbrandpaidtasmania
                        when tvcount > 0 and autimezone = 'Tasmania' and subchannel = 'Organic NonBrand' then multitouchweights * tvnonbrandorganictasmania
                        when tvcount > 0 and autimezone = 'Tasmania' and subchannel = 'Direct Homepage' then multitouchweights * tvdirecthptasmania
                        when tvcount > 0 and autimezone = 'Tasmania' and subchannel = 'Direct Non-Homepage' then multitouchweights * tvdirectnonhptasmania
                        when tvcount > 0 and autimezone = 'Victoria' and subchannel = 'Paid Search – Brand' then multitouchweights * tvbrandpaidvictoria
                        when tvcount > 0 and autimezone = 'Victoria' and subchannel = 'Organic Brand' then multitouchweights * tvbrandorganicvictoria
                        when tvcount > 0 and autimezone = 'Victoria' and subchannel = 'Paid Search – NonBrand' then multitouchweights * tvnonbrandpaidvictoria
                        when tvcount > 0 and autimezone = 'Victoria' and subchannel = 'Organic NonBrand' then multitouchweights * tvnonbrandorganicvictoria
                        when tvcount > 0 and autimezone = 'Victoria' and subchannel = 'Direct Homepage' then multitouchweights * tvdirecthpvictoria
                        when tvcount > 0 and autimezone = 'Victoria' and subchannel = 'Direct Non-Homepage' then multitouchweights * tvdirectnonhpvictoria
                        else 0 end
from a.feng_au_visit_tv_signup
go
update a.feng_au_visit_tv_signup
set firsttouchweights_update = firsttouchweights - tvweights_ft
go
update a.feng_au_visit_tv_signup
set lasttouchweights_update = lasttouchweights - tvweights_lt
go
update a.feng_au_visit_tv_signup
set multitouchweights_update = multitouchweights - tvweights_mt
go






alter table a.feng_au_visit_tv_signup add tvweights_ft_invisit float
go
alter table a.feng_au_visit_tv_signup add tvweights_lt_invisit float
go
alter table a.feng_au_visit_tv_signup add tvweights_mt_invisit float
go



update a.feng_au_visit_tv_signup
set tvweights_ft_invisit = case when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'NSW' and subchannel = 'Paid Search – Brand' then firsttouchweights * tvbrandpaidnsw
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'NSW' and subchannel = 'Organic Brand' then firsttouchweights * tvbrandorganicnsw
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'NSW' and subchannel = 'Paid Search – NonBrand' then firsttouchweights * tvnonbrandpaidnsw
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'NSW' and subchannel = 'Organic NonBrand' then firsttouchweights * tvnonbrandorganicnsw
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'NSW' and subchannel = 'Direct Homepage' then firsttouchweights * tvdirecthpnsw
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'NSW' and subchannel = 'Direct Non-Homepage' then firsttouchweights * tvdirectnonhpnsw
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'South' and subchannel = 'Paid Search – Brand' then firsttouchweights * tvbrandpaidsouth
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'South' and subchannel = 'Organic Brand' then firsttouchweights * tvbrandorganicsouth
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'South' and subchannel = 'Paid Search – NonBrand' then firsttouchweights * tvnonbrandpaidsouth
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'South' and subchannel = 'Organic NonBrand' then firsttouchweights * tvnonbrandorganicsouth
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'South' and subchannel = 'Direct Homepage' then firsttouchweights * tvdirecthpsouth
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'South' and subchannel = 'Direct Non-Homepage' then firsttouchweights * tvdirectnonhpsouth
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'West' and subchannel = 'Paid Search – Brand' then firsttouchweights * tvbrandpaidwest
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'West' and subchannel = 'Organic Brand' then firsttouchweights * tvbrandorganicwest
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'West' and subchannel = 'Paid Search – NonBrand' then firsttouchweights * tvnonbrandpaidwest
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'West' and subchannel = 'Organic NonBrand' then firsttouchweights * tvnonbrandorganicwest
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'West' and subchannel = 'Direct Homepage' then firsttouchweights * tvdirecthpwest
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'West' and subchannel = 'Direct Non-Homepage' then firsttouchweights * tvdirectnonhpwest
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'Queensland' and subchannel = 'Paid Search – Brand' then firsttouchweights * tvbrandpaidqueensland
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'Queensland' and subchannel = 'Organic Brand' then firsttouchweights * tvbrandorganicqueensland
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'Queensland' and subchannel = 'Paid Search – NonBrand' then firsttouchweights * tvnonbrandpaidqueensland
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'Queensland' and subchannel = 'Organic NonBrand' then firsttouchweights * tvnonbrandorganicqueensland
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'Queensland' and subchannel = 'Direct Homepage' then firsttouchweights * tvdirecthpqueensland
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'Queensland' and subchannel = 'Direct Non-Homepage' then firsttouchweights * tvdirectnonhpqueensland
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'Tasmania' and subchannel = 'Paid Search – Brand' then firsttouchweights * tvbrandpaidtasmania
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'Tasmania' and subchannel = 'Organic Brand' then firsttouchweights * tvbrandorganictasmania
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'Tasmania' and subchannel = 'Paid Search – NonBrand' then firsttouchweights * tvnonbrandpaidtasmania
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'Tasmania' and subchannel = 'Organic NonBrand' then firsttouchweights * tvnonbrandorganictasmania
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'Tasmania' and subchannel = 'Direct Homepage' then firsttouchweights * tvdirecthptasmania
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'Tasmania' and subchannel = 'Direct Non-Homepage' then firsttouchweights * tvdirectnonhptasmania
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'Victoria' and subchannel = 'Paid Search – Brand' then firsttouchweights * tvbrandpaidvictoria
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'Victoria' and subchannel = 'Organic Brand' then firsttouchweights * tvbrandorganicvictoria
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'Victoria' and subchannel = 'Paid Search – NonBrand' then firsttouchweights * tvnonbrandpaidvictoria
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'Victoria' and subchannel = 'Organic NonBrand' then firsttouchweights * tvnonbrandorganicvictoria
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'Victoria' and subchannel = 'Direct Homepage' then firsttouchweights * tvdirecthpvictoria
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'Victoria' and subchannel = 'Direct Non-Homepage' then firsttouchweights * tvdirectnonhpvictoria
                                else 0 end
from a.feng_au_visit_tv_signup
go
update a.feng_au_visit_tv_signup
set tvweights_lt_invisit = case when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'NSW' and subchannel = 'Paid Search – Brand' then lasttouchweights * tvbrandpaidnsw
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'NSW' and subchannel = 'Organic Brand' then lasttouchweights * tvbrandorganicnsw
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'NSW' and subchannel = 'Paid Search – NonBrand' then lasttouchweights * tvnonbrandpaidnsw
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'NSW' and subchannel = 'Organic NonBrand' then lasttouchweights * tvnonbrandorganicnsw
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'NSW' and subchannel = 'Direct Homepage' then lasttouchweights * tvdirecthpnsw
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'NSW' and subchannel = 'Direct Non-Homepage' then lasttouchweights * tvdirectnonhpnsw
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'South' and subchannel = 'Paid Search – Brand' then lasttouchweights * tvbrandpaidsouth
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'South' and subchannel = 'Organic Brand' then lasttouchweights * tvbrandorganicsouth
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'South' and subchannel = 'Paid Search – NonBrand' then lasttouchweights * tvnonbrandpaidsouth
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'South' and subchannel = 'Organic NonBrand' then lasttouchweights * tvnonbrandorganicsouth
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'South' and subchannel = 'Direct Homepage' then lasttouchweights * tvdirecthpsouth
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'South' and subchannel = 'Paid Search – Brand' then lasttouchweights * tvbrandpaidsouth
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'West' and subchannel = 'Organic Brand' then lasttouchweights * tvbrandorganicwest
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'West' and subchannel = 'Paid Search – NonBrand' then lasttouchweights * tvnonbrandpaidwest
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'West' and subchannel = 'Organic NonBrand' then lasttouchweights * tvnonbrandorganicwest
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'West' and subchannel = 'Direct Homepage' then lasttouchweights * tvdirecthpwest
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'West' and subchannel = 'Direct Non-Homepage' then lasttouchweights * tvdirectnonhpwest
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'West' and subchannel = 'Direct Non-Homepage' then lasttouchweights * tvdirectnonhpwest
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'Queensland' and subchannel = 'Paid Search – Brand' then lasttouchweights * tvbrandpaidqueensland
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'Queensland' and subchannel = 'Organic Brand' then lasttouchweights * tvbrandorganicqueensland
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'Queensland' and subchannel = 'Paid Search – NonBrand' then lasttouchweights * tvnonbrandpaidqueensland
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'Queensland' and subchannel = 'Organic NonBrand' then lasttouchweights * tvnonbrandorganicqueensland
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'Queensland' and subchannel = 'Direct Homepage' then lasttouchweights * tvdirecthpqueensland
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'Queensland' and subchannel = 'Direct Non-Homepage' then lasttouchweights * tvdirectnonhpqueensland
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'Tasmania' and subchannel = 'Paid Search – Brand' then lasttouchweights * tvbrandpaidtasmania
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'Tasmania' and subchannel = 'Organic Brand' then lasttouchweights * tvbrandorganictasmania
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'Tasmania' and subchannel = 'Paid Search – NonBrand' then lasttouchweights * tvnonbrandpaidtasmania
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'Tasmania' and subchannel = 'Organic NonBrand' then lasttouchweights * tvnonbrandorganictasmania
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'Tasmania' and subchannel = 'Direct Homepage' then lasttouchweights * tvdirecthptasmania
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'Tasmania' and subchannel = 'Direct Non-Homepage' then lasttouchweights * tvdirectnonhptasmania
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'Victoria' and subchannel = 'Paid Search – Brand' then lasttouchweights * tvbrandpaidvictoria
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'Victoria' and subchannel = 'Organic Brand' then lasttouchweights * tvbrandorganicvictoria
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'Victoria' and subchannel = 'Paid Search – NonBrand' then lasttouchweights * tvnonbrandpaidvictoria
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'Victoria' and subchannel = 'Organic NonBrand' then lasttouchweights * tvnonbrandorganicvictoria
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'Victoria' and subchannel = 'Direct Homepage' then lasttouchweights * tvdirecthpvictoria
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'Victoria' and subchannel = 'Direct Non-Homepage' then lasttouchweights * tvdirectnonhpvictoria
                                else 0 end
from a.feng_au_visit_tv_signup
go
update a.feng_au_visit_tv_signup
set tvweights_mt_invisit = case when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'NSW' and subchannel = 'Paid Search – Brand' then multitouchweights * tvbrandpaidnsw
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'NSW' and subchannel = 'Organic Brand' then multitouchweights * tvbrandorganicnsw
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'NSW' and subchannel = 'Paid Search – NonBrand' then multitouchweights * tvnonbrandpaidnsw
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'NSW' and subchannel = 'Organic NonBrand' then multitouchweights * tvnonbrandorganicnsw
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'NSW' and subchannel = 'Direct Homepage' then multitouchweights * tvdirecthpnsw
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'NSW' and subchannel = 'Direct Non-Homepage' then multitouchweights * tvdirectnonhpnsw
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'South' and subchannel = 'Paid Search – Brand' then multitouchweights * tvbrandpaidsouth
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'South' and subchannel = 'Organic Brand' then multitouchweights * tvbrandorganicsouth
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'South' and subchannel = 'Paid Search – NonBrand' then multitouchweights * tvnonbrandpaidsouth
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'South' and subchannel = 'Organic NonBrand' then multitouchweights * tvnonbrandorganicsouth
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'South' and subchannel = 'Direct Homepage' then multitouchweights * tvdirecthpsouth
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'South' and subchannel = 'Direct Non-Homepage' then multitouchweights * tvdirectnonhpsouth
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'West' and subchannel = 'Paid Search – Brand' then multitouchweights * tvbrandpaidwest
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'West' and subchannel = 'Organic Brand' then multitouchweights * tvbrandorganicwest
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'West' and subchannel = 'Paid Search – NonBrand' then multitouchweights * tvnonbrandpaidwest
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'West' and subchannel = 'Organic NonBrand' then multitouchweights * tvnonbrandorganicwest
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'West' and subchannel = 'Direct Homepage' then multitouchweights * tvdirecthpwest
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'West' and subchannel = 'Direct Non-Homepage' then multitouchweights * tvdirectnonhpwest
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'Queensland' and subchannel = 'Paid Search – Brand' then multitouchweights * tvbrandpaidqueensland
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'Queensland' and subchannel = 'Organic Brand' then multitouchweights * tvbrandorganicqueensland
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'Queensland' and subchannel = 'Paid Search – NonBrand' then multitouchweights * tvnonbrandpaidqueensland
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'Queensland' and subchannel = 'Organic NonBrand' then multitouchweights * tvnonbrandorganicqueensland
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'Queensland' and subchannel = 'Direct Homepage' then multitouchweights * tvdirecthpqueensland
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'Queensland' and subchannel = 'Direct Non-Homepage' then multitouchweights * tvdirectnonhpqueensland
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'Tasmania' and subchannel = 'Paid Search – Brand' then multitouchweights * tvbrandpaidtasmania
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'Tasmania' and subchannel = 'Organic Brand' then multitouchweights * tvbrandorganictasmania
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'Tasmania' and subchannel = 'Paid Search – NonBrand' then multitouchweights * tvnonbrandpaidtasmania
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'Tasmania' and subchannel = 'Organic NonBrand' then multitouchweights * tvnonbrandorganictasmania
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'Tasmania' and subchannel = 'Direct Homepage' then multitouchweights * tvdirecthptasmania
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'Tasmania' and subchannel = 'Direct Non-Homepage' then multitouchweights * tvdirectnonhptasmania
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'Victoria' and subchannel = 'Paid Search – Brand' then multitouchweights * tvbrandpaidvictoria
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'Victoria' and subchannel = 'Organic Brand' then multitouchweights * tvbrandorganicvictoria
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'Victoria' and subchannel = 'Paid Search – NonBrand' then multitouchweights * tvnonbrandpaidvictoria
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'Victoria' and subchannel = 'Organic NonBrand' then multitouchweights * tvnonbrandorganicvictoria
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'Victoria' and subchannel = 'Direct Homepage' then multitouchweights * tvdirecthpvictoria
                                when tvcount > 0 and new_freetrialorders + new_hardofferorders > 0 and autimezone = 'Victoria' and subchannel = 'Direct Non-Homepage' then multitouchweights * tvdirectnonhpvictoria
                                else 0 end
from a.feng_au_visit_tv_signup
go


(
select 'TV - invisit' as subchannel
     , 0 as firsttouch, 0 as lasttouch, 0 as multitouch
     , sum(tvweights_ft_invisit) ft_update, sum(tvweights_lt_invisit) lt_update, sum(tvweights_mt_invisit) mt_update
from a.feng_au_visit_tv_signup
)
union
(
select 'TV - 5 min' as subchannel
     , 0 as firsttouch, 0 as lasttouch, 0 as multitouch
     , sum(tvweights_ft) ft_update, sum(tvweights_lt) lt_update, sum(tvweights_mt) mt_update
from a.feng_au_visit_tv_signup
)
union
(
select subchannel
     , sum(firsttouchweights) firsttouch, sum(lasttouchweights) lastitouch, sum(multitouchweights) multitouch
     , sum(firsttouchweights_update) ft_update, sum(lasttouchweights_update) lt_update, sum(multitouchweights_update) mt_update
from a.feng_au_visit_tv_signup
group by subchannel
)
go


select dropif('a', 'feng_au_attribution_phase1')
go

select tb2.visitreferrer, tb2.pageurl, tb1.*
into a.feng_au_attribution_phase1
from a.feng_au_visit_tv_signup tb1
    join a.feng_au_factvisits_ucdmid_bwfill tb2 on tb1.rdnum = tb2.rdnum
go
