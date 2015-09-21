select dropif('a', 'feng_us_visit_tv_signup')
go

select tb1.*, tvcount, imps
into a.feng_us_visit_tv_signup
from a.feng_us_visitandsignup tb1
    left join (select ucdmid, servertimemst, rdnum, sum(tvindicator) tvcount, sum(imps) imps
               from a.feng_us2015_visitandtv
               group by ucdmid, servertimemst, rdnum
               having sum(tvindicator) > 0) tb2 
        on tb1.ucdmid = tb2.ucdmid 
            and tb1.servertimemst = tb2.servertimemst
            and tb1.rdnum = tb2.rdnum
go

alter table a.feng_us_visit_tv_signup add tvweights_ft_decay float
go
alter table a.feng_us_visit_tv_signup add tvweights_lt_decay float
go
alter table a.feng_us_visit_tv_signup add tvweights_mt_decay float
go
alter table a.feng_us_visit_tv_signup add firsttouchweights_update_decay float
go
alter table a.feng_us_visit_tv_signup add lasttouchweights_update_decay float
go
alter table a.feng_us_visit_tv_signup add multitouchweights_update_decay float
go

alter table a.feng_us_visit_tv_signup add tvweights_ft_trump float
go
alter table a.feng_us_visit_tv_signup add tvweights_lt_trump float
go
alter table a.feng_us_visit_tv_signup add tvweights_mt_trump float
go
alter table a.feng_us_visit_tv_signup add firsttouchweights_update_trump float
go
alter table a.feng_us_visit_tv_signup add lasttouchweights_update_trump float
go
alter table a.feng_us_visit_tv_signup add multitouchweights_update_trump float
go

alter table a.feng_us_visit_tv_signup add tvweights_ft_decay_invisit float
go
alter table a.feng_us_visit_tv_signup add tvweights_lt_decay_invisit float
go
alter table a.feng_us_visit_tv_signup add tvweights_mt_decay_invisit float
go
alter table a.feng_us_visit_tv_signup add firsttouchweights_update_decay_invisit float
go
alter table a.feng_us_visit_tv_signup add lasttouchweights_update_decay_invisit float
go
alter table a.feng_us_visit_tv_signup add multitouchweights_update_decay_invisit float
go

alter table a.feng_us_visit_tv_signup add tvweights_ft_trump_invisit float
go
alter table a.feng_us_visit_tv_signup add tvweights_lt_trump_invisit float
go
alter table a.feng_us_visit_tv_signup add tvweights_mt_trump_invisit float
go
alter table a.feng_us_visit_tv_signup add firsttouchweights_update_trump_invisit float
go
alter table a.feng_us_visit_tv_signup add lasttouchweights_update_trump_invisit float
go
alter table a.feng_us_visit_tv_signup add multitouchweights_update_trump_invisit float
go

update a.feng_us_visit_tv_signup
set tvweights_ft_decay = case when tvcount > 0 then firsttouchweights / ( 1 + exp(visitnumber - 4) ) else 0 end 
from a.feng_us_visit_tv_signup
go
update a.feng_us_visit_tv_signup
set tvweights_lt_decay = case when tvcount > 0 then lasttouchweights / ( 1 + exp(visitnumber - 4) ) else 0 end 
from a.feng_us_visit_tv_signup
go
update a.feng_us_visit_tv_signup
set tvweights_mt_decay = case when tvcount > 0 then multitouchweights / ( 1 + exp(visitnumber - 4) ) else 0 end 
from a.feng_us_visit_tv_signup
go
update a.feng_us_visit_tv_signup
set firsttouchweights_update_decay = firsttouchweights - tvweights_ft_decay
from a.feng_us_visit_tv_signup
go
update a.feng_us_visit_tv_signup
set lasttouchweights_update_decay = lasttouchweights - tvweights_lt_decay
from a.feng_us_visit_tv_signup
go
update a.feng_us_visit_tv_signup
set multitouchweights_update_decay = multitouchweights - tvweights_mt_decay
from a.feng_us_visit_tv_signup
go

update a.feng_us_visit_tv_signup
set tvweights_ft_trump = case when tvcount > 0 then firsttouchweights else 0 end 
from a.feng_us_visit_tv_signup
go
update a.feng_us_visit_tv_signup
set tvweights_lt_trump = case when tvcount > 0 then lasttouchweights else 0 end 
from a.feng_us_visit_tv_signup
go
update a.feng_us_visit_tv_signup
set tvweights_mt_trump = case when tvcount > 0 then multitouchweights else 0 end 
from a.feng_us_visit_tv_signup
go
update a.feng_us_visit_tv_signup
set firsttouchweights_update_trump = firsttouchweights - tvweights_ft_trump
from a.feng_us_visit_tv_signup
go
update a.feng_us_visit_tv_signup
set lasttouchweights_update_trump = lasttouchweights - tvweights_lt_trump
from a.feng_us_visit_tv_signup
go
update a.feng_us_visit_tv_signup
set multitouchweights_update_trump = multitouchweights - tvweights_mt_trump
from a.feng_us_visit_tv_signup
go

update a.feng_us_visit_tv_signup
set tvweights_ft_decay_invisit = 
    case when tvcount > 0 
            and new_freetrialorders + new_hardofferorders > 0
    then firsttouchweights / ( 1 + exp(visitnumber - 4) ) else 0 end 
from a.feng_us_visit_tv_signup
go
update a.feng_us_visit_tv_signup
set tvweights_lt_decay_invisit = 
    case when tvcount > 0 
            and new_freetrialorders + new_hardofferorders > 0
    then lasttouchweights / ( 1 + exp(visitnumber - 4) ) else 0 end 
from a.feng_us_visit_tv_signup
go
update a.feng_us_visit_tv_signup
set tvweights_mt_decay_invisit = 
    case when tvcount > 0 
            and new_freetrialorders + new_hardofferorders > 0
    then multitouchweights / ( 1 + exp(visitnumber - 4) ) else 0 end 
from a.feng_us_visit_tv_signup
go
update a.feng_us_visit_tv_signup
set firsttouchweights_update_decay_invisit = firsttouchweights - tvweights_ft_decay_invisit
from a.feng_us_visit_tv_signup
go
update a.feng_us_visit_tv_signup
set lasttouchweights_update_decay_invisit = lasttouchweights - tvweights_lt_decay_invisit
from a.feng_us_visit_tv_signup
go
update a.feng_us_visit_tv_signup
set multitouchweights_update_decay_invisit = multitouchweights - tvweights_mt_decay_invisit
from a.feng_us_visit_tv_signup
go

update a.feng_us_visit_tv_signup
set tvweights_ft_trump_invisit = 
    case when tvcount > 0 
            and new_freetrialorders + new_hardofferorders > 0
    then firsttouchweights else 0 end 
from a.feng_us_visit_tv_signup
go
update a.feng_us_visit_tv_signup
set tvweights_lt_trump_invisit = 
    case when tvcount > 0 
            and new_freetrialorders + new_hardofferorders > 0
    then lasttouchweights else 0 end 
from a.feng_us_visit_tv_signup
go
update a.feng_us_visit_tv_signup
set tvweights_mt_trump_invisit = 
    case when tvcount > 0 
            and new_freetrialorders + new_hardofferorders > 0
    then multitouchweights else 0 end 
from a.feng_us_visit_tv_signup
go
update a.feng_us_visit_tv_signup
set firsttouchweights_update_trump_invisit = firsttouchweights - tvweights_ft_trump_invisit
from a.feng_us_visit_tv_signup
go
update a.feng_us_visit_tv_signup
set lasttouchweights_update_trump_invisit = lasttouchweights - tvweights_lt_trump_invisit
from a.feng_us_visit_tv_signup
go
update a.feng_us_visit_tv_signup
set multitouchweights_update_trump_invisit = multitouchweights - tvweights_mt_trump_invisit
from a.feng_us_visit_tv_signup
go


--alter table a.feng_us_visit_tv_signup add channel varchar(100)
--go

--update a.feng_us_visit_tv_signup
--set channel = 
--    case when lower(subchannel) = 'direct' then 'Direct Homepage'
--         when lower(subchannel) like '%email%' then 'Email'
--         when lower(subchannel) like '%app%' then 'Mobile'
--         when lower(subchannel) like '%pr' then 'PR'
--         else subchannel end
--from a.feng_us_visit_tv_signup
--go

(
select 'TV' as subchannel, 0 as firsttouch, 0 as lasttouch, 0 as multitouch,
       sum(tvweights_ft_decay) ft_decay, sum(tvweights_lt_decay) lt_decay, sum(tvweights_mt_decay) mt_decay,
       sum(tvweights_ft_trump) ft_trump, sum(tvweights_lt_trump) lt_trump, sum(tvweights_mt_trump) mt_trump,
       sum(tvweights_ft_decay_invisit) ft_decay_invisit, sum(tvweights_lt_decay_invisit) lt_decay_invisit, sum(tvweights_mt_decay_invisit) mt_decay_invisit,
       sum(tvweights_ft_trump_invisit) ft_trump_invisit, sum(tvweights_lt_trump_invisit) lt_trump_invisit, sum(tvweights_mt_trump_invisit) mt_trump_invisit
from a.feng_us_visit_tv_signup
)
union
(
select subchannel
     , sum(firsttouchweights) firsttouch, sum(lasttouchweights) lastitouch, sum(multitouchweights) multitouch
     , sum(firsttouchweights_update_decay) ft_decay, sum(lasttouchweights_update_decay) lt_decay, sum(multitouchweights_update_decay) mt_decay
     , sum(firsttouchweights_update_trump) ft_trump, sum(lasttouchweights_update_trump) lt_trump, sum(multitouchweights_update_trump) mt_trump
     , sum(firsttouchweights_update_decay_invisit) ft_decay_invisit, sum(lasttouchweights_update_decay_invisit) lt_decay_invisit, sum(multitouchweights_update_decay_invisit) mt_decay_invisit
     , sum(firsttouchweights_update_trump_invisit) ft_trump_invisit, sum(lasttouchweights_update_trump_invisit) lt_trump_invisit, sum(multitouchweights_update_trump_invisit) mt_trump_invisit
from a.feng_us_visit_tv_signup
group by subchannel
)
go

