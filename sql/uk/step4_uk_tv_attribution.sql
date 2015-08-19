select dropif('a', 'feng_uk_visit_tv_signup')
go

select tb1.*, tvcount
into a.feng_uk_visit_tv_signup
from a.feng_uk_visitandsignup tb1
    left join (select ucdmid, servertimemst, rdnum, sum(tvindicator) tvcount
               from a.feng_uk2015_visitandtv
               group by ucdmid, servertimemst, rdnum
               having sum(tvindicator) > 0) tb2 
        on tb1.ucdmid = tb2.ucdmid 
            and tb1.servertimemst = tb2.servertimemst
            and tb1.rdnum = tb2.rdnum
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
--set tvweights_ft = case when tvcount > 0 then firsttouchweights / ( 1 + exp(visitnumber - 4) ) else 0 end 
set tvweights_ft = case when tvcount > 0 then firsttouchweights else 0 end 
from a.feng_uk_visit_tv_signup
go
update a.feng_uk_visit_tv_signup
--set tvweights_lt = case when tvcount > 0 then lasttouchweights / ( 1 + exp(visitnumber - 4) ) else 0 end 
set tvweights_lt = case when tvcount > 0 then lasttouchweights else 0 end 
from a.feng_uk_visit_tv_signup
go
update a.feng_uk_visit_tv_signup
--set tvweights_mt = case when tvcount > 0 then multitouchweights / ( 1 + exp(visitnumber - 4) ) else 0 end 
set tvweights_mt = case when tvcount > 0 then multitouchweights else 0 end 
from a.feng_uk_visit_tv_signup
go

update a.feng_uk_visit_tv_signup
set firsttouchweights_update = firsttouchweights - tvweights_ft
from a.feng_uk_visit_tv_signup
go
update a.feng_uk_visit_tv_signup
set lasttouchweights_update = lasttouchweights - tvweights_lt 
from a.feng_uk_visit_tv_signup
go
update a.feng_uk_visit_tv_signup
set multitouchweights_update = multitouchweights - tvweights_mt
from a.feng_uk_visit_tv_signup
go


select subchannel
     , sum(firsttouchweights) firsttouch
     , sum(firsttouchweights_update) fisttouch_update
     , sum(lasttouchweights) lastitouch
     , sum(lasttouchweights_update) lasttitouch_update
     , sum(multitouchweights) multitouch
     , sum(multitouchweights_update) multitouch_update
from a.feng_uk_visit_tv_signup
group by subchannel
go

select sum(tvweights_ft), sum(tvweights_lt), sum(tvweights_mt)
from a.feng_uk_visit_tv_signup
go
