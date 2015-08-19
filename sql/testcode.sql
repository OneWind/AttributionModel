select count(*)
from a.feng_us_factvisits_tmp
go

select count(*)
from a.feng_us_factvisits_ucdmid_bwfill
go

select subchannel, count(*) cnt from a.feng_us_factvisits_tmp
group by subchannel
go

select subchannel, count(*) cnt from a.feng_us_factvisits_ucdmid_bwfill
group by subchannel
go

select top 10000 tb2.entrypagenamedescription, tb2.entrypagecategorydescription, tb1.pageurl
from p.fact_visits tb1
    join p.dim_entrypagename tb2 on tb1.entrypagenameid = tb2.entrypagenameid
    join p.dim_promotion tb3 on tb1.promotionid = tb3.promotionid
where tb1.visitreferrer = '0'
    and lower(tb3.subchannel) = 'unknown'
    and siteid = '3713'
    and freetrialorders = 1
    and tb1.servertimemst >= '2015-06-01'
    and tb2.entrypagenamedescription not like '%home%'
    and len(tb1.pageurl) - len(replace(tb1.pageurl, '/', '')) < 4
--    and tb1.pageurl like 'http://%/%/'
--    and (tb1.pageurl = 'http://www.ancestry.com/' or tb1.pageurl = 'http://dna.ancestry.com/')
--group by entrypagenamedescription
go

select top 1000 tb2.entrypagenamedescription, tb2.entrypagecategorydescription, tb1.entrypagenameid,
                tb1.pageurl, tb1.visitreferrer
from p.fact_visits tb1
    join p.dim_entrypagename tb2 on tb1.entrypagenameid = tb2.entrypagenameid
    join p.dim_promotion tb3 on tb1.promotionid = tb3.promotionid
where lower(tb3.subchannel) = 'unknown'
    and tb2.entrypagenamedescription not like '%home%'
--    and tb1.pageurl like '%dna.ancestry.com%'
    and siteid = '3713'
    and tb1.visitreferrer = '0'
--    and tb1.servertimemst >= '2015-06-01'
--    and tb1.visitreferrer like '%my.xfinity.com%'
--    and tb1.visitreferrer like '%search.aol.com%'
--    and tb1.visitreferrer like '%us.wow.com%'
--    and tb2.entrypagenamedescription like '%home%'
go
