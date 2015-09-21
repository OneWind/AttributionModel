select dropif ('a', 'feng_us_visits_bymin_2015')
go

select cast(substr(cast(servertimemst as varchar(100)), 1, 17) || '00' as timestamp)
     , count(*) visits
     , sum(case when subchannel in ('Direct', 'Direct Homepage', 'Direct Non-Homepage', 'Geo-Redirect', 'Organic Brand', 
                                    'Organic NonBrand', 'Paid Search – Brand', 'Paid Search – NonBrand') 
                then 0 else 1 end) nontv_visits
into a.feng_us_visits_bymin_2015
--from a.feng_us_factvisits_ucdmid_bwfill
from a.feng_us_factvisits_tmp
where trunc(servertimemst) >= '2014-12-28' and trunc(servertimemst) <= '2015-07-04'
group by 1
go

unload ('select * from a.feng_us_visits_bymin_2015') to '/mnt/matrix/load/Feng/us_visits_bymin_2015.csv' leader delimiter ',' addquotes
go

select distinct subchannel from a.feng_us_factvisits_ucdmid_bwfill
go
