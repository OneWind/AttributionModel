-----------------   NSW ---------------------
select dropif('a', 'feng_autv_weights_nsw')
go

create table a.feng_autv_weights_nsw (
    datetime timestamp,
    TVBrandPaidNSW float8,
    TVBrandOrganicNSW float8,
    TVNonBrandPaidNSW float8,
    TVNonBrandOrganicNSW float8,
    TVDirectHPNSW float8,
    TVDirectNonHPNSW float8
)
go


GRANT SELECT, INSERT, UPDATE, DELETE ON a.feng_autv_weights_nsw TO group analysts
GO
GRANT SELECT, INSERT, UPDATE, DELETE ON a.feng_autv_weights_nsw TO group biteam
GO
GRANT SELECT, INSERT, UPDATE, DELETE ON a.feng_autv_weights_nsw TO group intlanalysts
GO
GRANT SELECT ON a.feng_autv_weights_nsw TO tableau
GO

copy a.feng_autv_weights_nsw from '/mnt/matrix/load/Feng/AUTVweightsNSW.csv' 
    delimiter',' 
    removequotes 
    maxerror 0
    ignoreheader 1
    timeformat 'yyyy-mm-dd hh24:mi:ss'
go

--------------------- South ------------------------
select dropif('a', 'feng_autv_weights_south')
go

create table a.feng_autv_weights_south (
    datetime timestamp,
    TVBrandPaidSouth float8,
    TVBrandOrganicSouth float8,
    TVNonBrandPaidSouth float8,
    TVNonBrandOrganicSouth float8,
    TVDirectHPSouth float8,
    TVDirectNonHPSouth float8
)
go


GRANT SELECT, INSERT, UPDATE, DELETE ON a.feng_autv_weights_south TO group analysts
GO
GRANT SELECT, INSERT, UPDATE, DELETE ON a.feng_autv_weights_south TO group biteam
GO
GRANT SELECT, INSERT, UPDATE, DELETE ON a.feng_autv_weights_south TO group intlanalysts
GO
GRANT SELECT ON a.feng_autv_weights_south TO tableau
GO

copy a.feng_autv_weights_south from '/mnt/matrix/load/Feng/AUTVweightsSouth.csv' 
    delimiter',' 
    removequotes 
    maxerror 0
    ignoreheader 1
    timeformat 'yyyy-mm-dd hh24:mi:ss'
go

-----------------------  West   ----------------------------------
select dropif('a', 'feng_autv_weights_west')
go

create table a.feng_autv_weights_west (
    datetime timestamp,
    TVBrandPaidWest float8,
    TVBrandOrganicWest float8,
    TVNonBrandPaidWest float8,
    TVNonBrandOrganicWest float8,
    TVDirectHPWest float8,
    TVDirectNonHPWest float8
)
go


GRANT SELECT, INSERT, UPDATE, DELETE ON a.feng_autv_weights_west TO group analysts
GO
GRANT SELECT, INSERT, UPDATE, DELETE ON a.feng_autv_weights_west TO group biteam
GO
GRANT SELECT, INSERT, UPDATE, DELETE ON a.feng_autv_weights_west TO group intlanalysts
GO
GRANT SELECT ON a.feng_autv_weights_west TO tableau
GO

copy a.feng_autv_weights_west from '/mnt/matrix/load/Feng/AUTVweightsWest.csv' 
    delimiter',' 
    removequotes 
    maxerror 0
    ignoreheader 1
    timeformat 'yyyy-mm-dd hh24:mi:ss'
go


---------------------------------- Queensland  --------------------------------

select dropif('a', 'feng_autv_weights_queensland')
go

create table a.feng_autv_weights_queensland (
    datetime timestamp,
    TVBrandPaidQueensland float8,
    TVBrandOrganicQueensland float8,
    TVNonBrandPaidQueensland float8,
    TVNonBrandOrganicQueensland float8,
    TVDirectHPQueensland float8,
    TVDirectNonHPQueensland float8
)
go


GRANT SELECT, INSERT, UPDATE, DELETE ON a.feng_autv_weights_queensland TO group analysts
GO
GRANT SELECT, INSERT, UPDATE, DELETE ON a.feng_autv_weights_queensland TO group biteam
GO
GRANT SELECT, INSERT, UPDATE, DELETE ON a.feng_autv_weights_queensland TO group intlanalysts
GO
GRANT SELECT ON a.feng_autv_weights_queensland TO tableau
GO

copy a.feng_autv_weights_queensland from '/mnt/matrix/load/Feng/AUTVweightsQueensland.csv' 
    delimiter',' 
    removequotes 
    maxerror 0
    ignoreheader 1
    timeformat 'yyyy-mm-dd hh24:mi:ss'
go




--------------------- Tasmania  ---------------------------------

select dropif('a', 'feng_autv_weights_tasmania')
go

create table a.feng_autv_weights_tasmania (
    datetime timestamp,
    TVBrandPaidTasmania float8,
    TVBrandOrganicTasmania float8,
    TVNonBrandPaidTasmania float8,
    TVNonBrandOrganicTasmania float8,
    TVDirectHPTasmania float8,
    TVDirectNonHPTasmania float8
)
go


GRANT SELECT, INSERT, UPDATE, DELETE ON a.feng_autv_weights_tasmania TO group analysts
GO
GRANT SELECT, INSERT, UPDATE, DELETE ON a.feng_autv_weights_tasmania TO group biteam
GO
GRANT SELECT, INSERT, UPDATE, DELETE ON a.feng_autv_weights_tasmania TO group intlanalysts
GO
GRANT SELECT ON a.feng_autv_weights_tasmania TO tableau
GO

copy a.feng_autv_weights_tasmania from '/mnt/matrix/load/Feng/AUTVweightsTasmania.csv' 
    delimiter',' 
    removequotes 
    maxerror 0
    ignoreheader 1
    timeformat 'yyyy-mm-dd hh24:mi:ss'
go




----------------------  Victoria  ----------------------------------


select dropif('a', 'feng_autv_weights_victoria')
go

create table a.feng_autv_weights_victoria (
    datetime timestamp,
    TVBrandPaidVictoria float8,
    TVBrandOrganicVictoria float8,
    TVNonBrandPaidVictoria float8,
    TVNonBrandOrganicVictoria float8,
    TVDirectHPVictoria float8,
    TVDirectNonHPVictoria float8
)
go


GRANT SELECT, INSERT, UPDATE, DELETE ON a.feng_autv_weights_victoria TO group analysts
GO
GRANT SELECT, INSERT, UPDATE, DELETE ON a.feng_autv_weights_victoria TO group biteam
GO
GRANT SELECT, INSERT, UPDATE, DELETE ON a.feng_autv_weights_victoria TO group intlanalysts
GO
GRANT SELECT ON a.feng_autv_weights_victoria TO tableau
GO

copy a.feng_autv_weights_victoria from '/mnt/matrix/load/Feng/AUTVweightsVictoria.csv' 
    delimiter',' 
    removequotes 
    maxerror 0
    ignoreheader 1
    timeformat 'yyyy-mm-dd hh24:mi:ss'
go

