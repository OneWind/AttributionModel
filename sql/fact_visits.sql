select top 50 * from (
select servertimemst,
       ucdmid, visitorid, orderid, visitnumber, 
       freetrialorders, hardofferorders,
       tb2.subchannelgroup, tb3.devicetypedesc
from p.fact_visits tb1
    join p.dim_promotion tb2 on tb1.promotionid = tb2.promotionid
    join p.dim_devicetype tb3 on tb1.devicetypeid = tb3.devicetypeid
where visitcountryid = 55 
    and ucdmid != '00000000-0000-0000-0000-000000000000'
--    and ucdmid = '0016E94E-0006-0000-0000-000000000000'
    and trunc(servertimemst) >= '2015-01-01'
    and devicetypedesc != 'Other'
order by ucdmid, visitorid, visitnumber)
go

select trunc(servertimemst), count(*)
from p.fact_visits
where visitcountryid = 55
group by trunc(servertimemst)
go

select * from p.fact_visits limit 20
go
