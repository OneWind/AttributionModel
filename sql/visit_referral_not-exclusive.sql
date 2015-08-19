select top 100 tb1.visitreferrer, tb2.entrypagecategorydescription, tb2.entrypagenamedescription, tb3.subchannel
from p.fact_visits tb1
    join p.dim_entrypagename tb2 on tb1.entrypagenameid = tb2.entrypagenameid
    join p.dim_promotion tb3 on tb1.promotionid = tb3.promotionid
where lower(tb3.subchannel) = 'unknown'
    and lower(tb1.visitreferrer) like '%.google.%'
    and lower(tb1.visitreferrer) like '%facebook%'
go

select top 100 tb1.visitreferrer, tb2.entrypagecategorydescription, tb2.entrypagenamedescription, tb3.subchannel
from p.fact_visits tb1
    join p.dim_entrypagename tb2 on tb1.entrypagenameid = tb2.entrypagenameid
    join p.dim_promotion tb3 on tb1.promotionid = tb3.promotionid
where lower(tb3.subchannel) = 'unknown'
    and lower(tb1.visitreferrer) like '%.google.%'
    and lower(tb1.visitreferrer) like '%ancestry.co.uk%'
go

select top 100 tb1.visitreferrer, tb2.entrypagecategorydescription, tb2.entrypagenamedescription, tb3.subchannel
from p.fact_visits tb1
    join p.dim_entrypagename tb2 on tb1.entrypagenameid = tb2.entrypagenameid
    join p.dim_promotion tb3 on tb1.promotionid = tb3.promotionid
where lower(tb3.subchannel) = 'unknown'
    and lower(tb1.visitreferrer) like '%facebook%'
    and lower(tb1.visitreferrer) like '%ancestry.co.uk%'
go
