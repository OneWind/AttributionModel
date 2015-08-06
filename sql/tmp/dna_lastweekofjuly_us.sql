select top 10 * from p.fact_visits
go

select trunc(servertimemst) date, count(*) cnt
from p.fact_visits
where servertimemst >= '2015-01-01' and siteid = 3713
group by trunc(servertimemst)
go


select dropif('a', 'feng_us_visits_lastweekofjuly')
go

select *
into a.feng_us_visits_lastweekofjuly
from p.fact_visits
where trunc(servertimemst) >= '2015-07-26' and trunc(servertimemst) <= '2015-08-01'
    and siteid = 3713
go

select count(*), sum(dnaorders)
from a.feng_us_visits_lastweekofjuly
go

select dropif('a', 'feng_us_visits_lastweekofjuly_dna')
go

select tb1.*, tb2.servertimemst dnaorderdate
into a.feng_us_visits_lastweekofjuly_dna
from a.feng_us_visits_lastweekofjuly tb1
    join (select servertimemst, visitorid
          from a.feng_us_visits_lastweekofjuly
          where dnaorders > 0) tb2
        on tb1.visitorid = tb2.visitorid
            and tb1.servertimemst < tb2.servertimemst
go


select dropif('a', 'feng_us_visits_lastweekofjuly_dna_visitnumber')
go

select *
     , row_number() over (partition by visitorid, dnaorderdate order by servertimemst) as visitnumber
into a.feng_us_visits_lastweekofjuly_dna_visitnumber
from a.feng_us_visits_lastweekofjuly_dna
go

select 
from a.feng_us_visits_lastweekofjuly_dna_visitnumber

go