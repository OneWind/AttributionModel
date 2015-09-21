-- after running us_tv_baseline_bychannel.R --
-- get tv weights for relevant channels --
-- 1. Brand Search: Paid Search Brand + Organic Search Brand --
-- 2. NonBrand Search: Paid Search NonBrand + Organic Search NonBrand --
-- 3. Direct Homepage --
-- 4. Direct Non-Homepage --

select dropif('a', 'feng_uktv_weights')
go

create table a.feng_uktv_weights (
    datetime timestamp,
    TVBrandPaid float8,
    TVBrandOrganic float8,
    TVNonBrandPaid float8,
    TVNonBrandOrganic float8,
    TVDirectHP float8,
    TVDirectNonHP float8
)
go


GRANT SELECT, INSERT, UPDATE, DELETE ON a.feng_uktv_weights TO group analysts
GO
GRANT SELECT, INSERT, UPDATE, DELETE ON a.feng_uktv_weights TO group biteam
GO
GRANT SELECT, INSERT, UPDATE, DELETE ON a.feng_uktv_weights TO group intlanalysts
GO
GRANT SELECT ON a.feng_uktv_weights TO tableau
GO

copy a.feng_uktv_weights from '/mnt/matrix/load/Feng/TVweightsEast.csv' 
    delimiter',' 
    removequotes 
    maxerror 0
    ignoreheader 1
    timeformat 'yyyy-mm-dd hh24:mi:ss'
go


select top 50 * from a.feng_uktv_weights
go
