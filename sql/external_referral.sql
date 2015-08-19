select dropif('a', 'feng_us_external_referral')
go

select tb1.visitreferrer, tb2.entrypagecategorydescription, tb2.entrypagenamedescription, tb3.subchannel
into a.feng_us_external_referral
from p.fact_visits tb1
    join p.dim_entrypagename tb2 on tb1.entrypagenameid = tb2.entrypagenameid
    join p.dim_promotion tb3 on tb1.promotionid = tb3.promotionid
where lower(tb1.visitreferrer) not like '%google.%'
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
      and lower(tb1.visitreferrer) not like '%ancestry%'
      and tb1.visitreferrer != '0'
      and lower(tb3.subchannel) = 'unknown'
      and tb1.siteid = 3713
      and trunc(tb1.servertimemst) >= '2015-01-01'
go

select count(*) from a.feng_us_external_referral
go

select count(*) from p.fact_visits
go

unload ('select * from a.feng_us_external_referral') to '/mnt/matrix/load/Feng/externalRef2015.csv' leader delimiter ',' addquotes
go



select dropif('a', 'feng_us_direct_nohp')
go

select tb1.pageurl, tb2.entrypagecategorydescription, tb2.entrypagenamedescription
into a.feng_us_direct_nohp
from p.fact_visits tb1
    join p.dim_entrypagename tb2 on tb1.entrypagenameid = tb2.entrypagenameid
    join p.dim_promotion tb3 on tb1.promotionid = tb3.promotionid
where tb1.visitreferrer = '0'
     and not (tb2.entrypagenamedescription like '%: home%'
            or len(tb1.pageurl) - len(replace(tb1.pageurl, '/', '')) < 4)
     and lower(tb3.subchannel) = 'unknown'
     and tb1.siteid = 3713
     and trunc(tb1.servertimemst) >= '2015-01-01'
go

select entrypagenamedescription, count(*) cnt
from a.feng_us_direct_nohp
group by entrypagenamedescription
go

unload ('select * from a.feng_us_direct_nohp') to '/mnt/matrix/load/Feng/directnohp2015.csv' leader delimiter ',' addquotes
go



select dropif('a', 'feng_us_internal_referral')
go

select tb1.visitreferrer, tb2.entrypagecategorydescription, tb2.entrypagenamedescription, tb3.subchannel
into a.feng_us_internal_referral
from p.fact_visits tb1
    join p.dim_entrypagename tb2 on tb1.entrypagenameid = tb2.entrypagenameid
    join p.dim_promotion tb3 on tb1.promotionid = tb3.promotionid
            where (lower(tb1.visitreferrer) not like '%google.%'
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
                  or (lower(tb1.visitreferrer) like '%ancestry%'
                      and lower(tb1.visitreferrer) not like '%ancestry.co.uk%'
                      and lower(tb1.visitreferrer) not like '%ancestry.ca%'
                      and lower(tb1.visitreferrer) not like '%ancestry.de%'
                      and lower(tb1.visitreferrer) not like '%ancestry.se%'
                      and lower(tb1.visitreferrer) not like '%ancestry.mx%'
                      and lower(tb1.visitreferrer) not like '%ancestry.it%'
                      and lower(tb1.visitreferrer) not like '%ancestry.fr%'
                      and lower(tb1.visitreferrer) not like '%ancestry.com.au%'))
      and lower(tb3.subchannel) = 'unknown')
      and tb1.siteid = 3713
      and trunc(tb1.servertimemst) >= '2015-01-01'
go

select count(*) from a.feng_us_internal_referral
go

unload ('select * from a.feng_us_internal_referral') to '/mnt/matrix/load/Feng/internalRef2015.csv' leader delimiter ',' addquotes
go


