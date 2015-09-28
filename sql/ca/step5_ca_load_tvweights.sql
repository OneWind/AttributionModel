-- after running us_tv_baseline_bychannel.R --
-- get tv weights for relevant channels for east and west coast separately --
-- 1. Brand Search: Paid Search Brand + Organic Search Brand --
-- 2. NonBrand Search: Paid Search NonBrand + Organic Search NonBrand --
-- 3. Direct Homepage --
-- 4. Direct Non-Homepage --

select dropif('a', 'feng_catv_weights_east')
go

create table a.feng_catv_weights_east (
    datetime timestamp,
    TVBrandPaidEast float8,
    TVBrandOrganicEast float8,
    TVNonBrandPaidEast float8,
    TVNonBrandOrganicEast float8,
    TVDirectHPEast float8,
    TVDirectNonHPEast float8
)
go


GRANT SELECT, INSERT, UPDATE, DELETE ON a.feng_catv_weights_east TO group analysts
GO
GRANT SELECT, INSERT, UPDATE, DELETE ON a.feng_catv_weights_east TO group biteam
GO
GRANT SELECT, INSERT, UPDATE, DELETE ON a.feng_catv_weights_east TO group intlanalysts
GO
GRANT SELECT ON a.feng_catv_weights_east TO tableau
GO

copy a.feng_catv_weights_east from '/mnt/matrix/load/Feng/CATVweightsEast.csv' 
    delimiter',' 
    removequotes 
    maxerror 0
    ignoreheader 1
    timeformat 'yyyy-mm-dd hh24:mi:ss'
go


select top 50 * from a.feng_catv_weights_east
go




select dropif('a', 'feng_catv_weights_west')
go

create table a.feng_catv_weights_west (
    datetime timestamp,
    TVBrandPaidWest float8,
    TVBrandOrganicWest float8,
    TVNonBrandPaidWest float8,
    TVNonBrandOrganicWest float8,
    TVDirectHPWest float8,
    TVDIrectNonHPWest float8
)
go


GRANT SELECT, INSERT, UPDATE, DELETE ON a.feng_catv_weights_west TO group analysts
GO
GRANT SELECT, INSERT, UPDATE, DELETE ON a.feng_catv_weights_west TO group biteam
GO
GRANT SELECT, INSERT, UPDATE, DELETE ON a.feng_catv_weights_west TO group intlanalysts
GO
GRANT SELECT ON a.feng_catv_weights_west TO tableau
GO

copy a.feng_catv_weights_west from '/mnt/matrix/load/Feng/CATVweightsWest.csv' 
    delimiter',' 
    removequotes 
    maxerror 0
    ignoreheader 1
    timeformat 'yyyy-mm-dd hh24:mi:ss'
go


select top 50 * from a.feng_catv_weights_west
go


--select top 100 * from stl_load_errors
--order by starttime desc
--go



