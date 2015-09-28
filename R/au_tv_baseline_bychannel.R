tv.weight <- function(subchannel, tz, name) {
  
  if (!(tz %in% c("NSW", "South", "West", "Queensland", "Tasmania", "Victoria"))) 
    stop("wrong coast: either 'east', or 'west'")

  query1 <- 
    "select substr(cast(servertimemst as varchar(100)), 1, 16) || ':00' timetominstr, count(*) cnt
     from a.feng_au2015_visitandtv
     where autimezone = '"
  query2 <-
    "' and subchannel = '"  
  query3 <- 
    "'  group by 1"
  
  query <- paste(query1, tz, query2, subchannel, query3, sep="")
  
  visit.data <- sqlQuery(.dwMatrix, query)
  #  visit.data <- visit.data[order(visit.data$timetominstr), ]
  visit.data$timetomin <- strptime(visit.data$timetominstr, "%Y-%m-%d %H:%M:%S")

  max.time <- sqlQuery(.dwMatrix, 
                       "select substr(cast(max(servertimemst) as varchar(100)), 1, 16) || ':00'
                        from a.feng_au2015_visitandtv")
  min.time <- sqlQuery(.dwMatrix, 
                       "select substr(cast(min(servertimemst) as varchar(100)), 1, 16) || ':00'
                        from a.feng_au2015_visitandtv")
  
  time <- data.frame(timestamp=seq(strptime(min.time[1, 1], "%Y-%m-%d %H:%M:%S"), 
                                   strptime(max.time[1, 1], "%Y-%m-%d %H:%M:%S"), 
                                   by=60))
  
  time$ts.char <- as.character(time$timestamp)
  data <- merge(visit.data, time, by.x="timetominstr", by.y="ts.char", all.y=T, all.x=T)
  data$cnt[!complete.cases(data[, 1:2])] <- 0
  data <- data[order(data$timestamp), ]
  #  tmp <- data.frame(group_by(data[, c(2,5)], date) %>% summarise(count=n()))
  ### pay attention: 03/08/2015 one hour loss ###
  data$baseline <- pmax(runmed(data$cnt, k=61), 0)
  data$tvweights <- pmax(pmin((data$cnt - data$baseline) / pmax(data$cnt, 1), 1), 0)
  #  data$tvweights[data$cnt < 10] <- 0
  weights.by.min <- data.frame(datetime = data$timetominstr, 
                               tvweights = data$tvweights)
  names(weights.by.min)[2] <- paste(name, "-tv", sep="")
  weights.by.min
}

setwd("c://Users//fyi/Desktop/")
### Brand search - paid ###
tv.brand.paid.nsw <- tv.weight('Paid Search – Brand', "NSW", "BrandPaid")
tv.brand.paid.south <- tv.weight('Paid Search – Brand', "South", "BrandPaid")
tv.brand.paid.west <- tv.weight('Paid Search – Brand', "West", "BrandPaid")
tv.brand.paid.queensland <- tv.weight('Paid Search – Brand', "Queensland", "BrandPaid")
tv.brand.paid.tasmania <- tv.weight('Paid Search – Brand', "Tasmania", "BrandPaid")
tv.brand.paid.victoria <- tv.weight('Paid Search – Brand', "Victoria", "BrandPaid")

### NonBrand search - paid ###
tv.nonbrand.paid.nsw <- tv.weight('Paid Search – NonBrand', "NSW", "NonBrandPaid")
tv.nonbrand.paid.south <- tv.weight('Paid Search – NonBrand', "South", "NonBrandPaid")
tv.nonbrand.paid.west <- tv.weight('Paid Search – NonBrand', "West", "NonBrandPaid")
tv.nonbrand.paid.queensland <- tv.weight('Paid Search – NonBrand', "Queensland", "NonBrandPaid")
tv.nonbrand.paid.tasmania <- tv.weight('Paid Search – NonBrand', "Tasmania", "NonBrandPaid")
tv.nonbrand.paid.victoria <- tv.weight('Paid Search – NonBrand', "Victoria", "NonBrandPaid")

### Brand search - organic ###
tv.brand.organic.nsw <- tv.weight('Organic Brand', "NSW", "BrandOrganic")
tv.brand.organic.south <- tv.weight('Organic Brand', "South", "BrandOrganic")
tv.brand.organic.west <- tv.weight('Organic Brand', "West", "BrandOrganic")
tv.brand.organic.queensland <- tv.weight('Organic Brand', "Queensland", "BrandOrganic")
tv.brand.organic.tasmania <- tv.weight('Organic Brand', "Tasmania", "BrandOrganic")
tv.brand.organic.victoria <- tv.weight('Organic Brand', "Victoria", "BrandOrganic")

### NonBrand search - organic ###
tv.nonbrand.organic.nsw <- tv.weight('Organic NonBrand', "NSW", "NonBrandOrganic")
tv.nonbrand.organic.south <- tv.weight('Organic NonBrand', "South", "NonBrandOrganic")
tv.nonbrand.organic.west <- tv.weight('Organic NonBrand', "West", "NonBrandOrganic")
tv.nonbrand.organic.queensland <- tv.weight('Organic NonBrand', "Queensland", "NonBrandOrganic")
tv.nonbrand.organic.tasmania <- tv.weight('Organic NonBrand', "Tasmania", "NonBrandOrganic")
tv.nonbrand.organic.victoria <- tv.weight('Organic NonBrand', "Victoria", "NonBrandOrganic")

### Direct Homepage ###
tv.directHP.nsw <- tv.weight('Direct Homepage', "NSW", "DirectHP")
tv.directHP.south <- tv.weight('Direct Homepage', "South", "DirectHP")
tv.directHP.west <- tv.weight('Direct Homepage', "West", "DirectHP")
tv.directHP.queensland <- tv.weight('Direct Homepage', "Queensland", "DirectHP")
tv.directHP.tasmania <- tv.weight('Direct Homepage', "Tasmania", "DirectHP")
tv.directHP.victoria <- tv.weight('Direct Homepage', "Victoria", "DirectHP")

### Direct Homepage ###
tv.directNonHP.nsw <- tv.weight('Direct Non-Homepage', "NSW", "DirectNonHP")
tv.directNonHP.south <- tv.weight('Direct Non-Homepage', "South", "DirectNonHP")
tv.directNonHP.west <- tv.weight('Direct Non-Homepage', "West", "DirectNonHP")
tv.directNonHP.queensland <- tv.weight('Direct Non-Homepage', "Queensland", "DirectNonHP")
tv.directNonHP.tasmania <- tv.weight('Direct Non-Homepage', "Tasmania", "DirectNonHP")
tv.directNonHP.victoria <- tv.weight('Direct Non-Homepage', "Victoria", "DirectNonHP")


tv.weights.nsw <- data.frame(datetime = tv.brand.paid.nsw$datetime,
                             TVBrandPaidNSW = tv.brand.paid.nsw$"BrandPaid-tv",
                             TVBrandOrganicNSW = tv.brand.organic.nsw$"BrandOrganic-tv",
                             TVNonBrandPaidNSW = tv.nonbrand.paid.nsw$"NonBrandPaid-tv",
                             TVNonBrandOrganicNSW = tv.nonbrand.organic.nsw$"NonBrandOrganic-tv",
                             TVDirectHPNSW = tv.directHP.nsw$"DirectHP-tv",
                             TVDIrectNonHPNSW = tv.directNonHP.nsw$"DirectNonHP-tv")
tv.weights.nsw[is.na(tv.weights.nsw)] <- 0

tv.weights.south <- data.frame(datetime = tv.brand.paid.south$datetime,
                             TVBrandPaidSouth = tv.brand.paid.south$"BrandPaid-tv",
                             TVBrandOrganicSouth = tv.brand.organic.south$"BrandOrganic-tv",
                             TVNonBrandPaidSouth = tv.nonbrand.paid.south$"NonBrandPaid-tv",
                             TVNonBrandOrganicSouth = tv.nonbrand.organic.south$"NonBrandOrganic-tv",
                             TVDirectHPSouth = tv.directHP.south$"DirectHP-tv",
                             TVDIrectNonHPSouth = tv.directNonHP.south$"DirectNonHP-tv")
tv.weights.south[is.na(tv.weights.south)] <- 0
                               
tv.weights.west <- data.frame(datetime = tv.brand.paid.west$datetime,
                              TVBrandPaidWest = tv.brand.paid.west$"BrandPaid-tv",
                              TVBrandOrganicWest = tv.brand.organic.west$"BrandOrganic-tv",
                              TVNonBrandPaidWest = tv.nonbrand.paid.west$"NonBrandPaid-tv",
                              TVNonBrandOrganicWest = tv.nonbrand.organic.west$"NonBrandOrganic-tv",
                              TVDirectHPWest = tv.directHP.west$"DirectHP-tv",
                              TVDIrectNonHPWest = tv.directNonHP.west$"DirectNonHP-tv")
tv.weights.west[is.na(tv.weights.west)] <- 0

tv.weights.queensland <- data.frame(datetime = tv.brand.paid.queensland$datetime,
                                    TVBrandPaidQueensland = tv.brand.paid.queensland$"BrandPaid-tv",
                                    TVBrandOrganicQueensland = tv.brand.organic.queensland$"BrandOrganic-tv",
                                    TVNonBrandPaidQueensland = tv.nonbrand.paid.queensland$"NonBrandPaid-tv",
                                    TVNonBrandOrganicQueensland = tv.nonbrand.organic.queensland$"NonBrandOrganic-tv",
                                    TVDirectHPQueensland = tv.directHP.queensland$"DirectHP-tv",
                                    TVDIrectNonHPQueensland = tv.directNonHP.queensland$"DirectNonHP-tv")
tv.weights.queensland[is.na(tv.weights.queensland)] <- 0

tv.weights.tasmania <- data.frame(datetime = tv.brand.paid.tasmania$datetime,
                                  TVBrandPaidTasmania = tv.brand.paid.tasmania$"BrandPaid-tv",
                                  TVBrandOrganicTasmania = tv.brand.organic.tasmania$"BrandOrganic-tv",
                                  TVNonBrandPaidTasmania = tv.nonbrand.paid.tasmania$"NonBrandPaid-tv",
                                  TVNonBrandOrganicTasmania = tv.nonbrand.organic.tasmania$"NonBrandOrganic-tv",
                                  TVDirectHPTasmania = tv.directHP.tasmania$"DirectHP-tv",
                                  TVDIrectNonHPTasmania = tv.directNonHP.tasmania$"DirectNonHP-tv")
tv.weights.tasmania[is.na(tv.weights.tasmania)] <- 0

tv.weights.victoria <- data.frame(datetime = tv.brand.paid.victoria$datetime,
                                  TVBrandPaidVictoria = tv.brand.paid.victoria$"BrandPaid-tv",
                                  TVBrandOrganicVictoria = tv.brand.organic.victoria$"BrandOrganic-tv",
                                  TVNonBrandPaidVictoria = tv.nonbrand.paid.victoria$"NonBrandPaid-tv",
                                  TVNonBrandOrganicVictoria = tv.nonbrand.organic.victoria$"NonBrandOrganic-tv",
                                  TVDirectHPVictoria = tv.directHP.victoria$"DirectHP-tv",
                                  TVDIrectNonHPVictoria = tv.directNonHP.victoria$"DirectNonHP-tv")
tv.weights.victoria[is.na(tv.weights.victoria)] <- 0


write.csv(tv.weights.nsw, file="AUTVweightsNSW.csv", row.names=F)
write.csv(tv.weights.south, file="AUTVweightsSouth.csv", row.names=F)
write.csv(tv.weights.west, file="AUTVweightsWest.csv", row.names=F)
write.csv(tv.weights.queensland, file="AUTVweightsQueensland.csv", row.names=F)
write.csv(tv.weights.tasmania, file="AUTVweightsTasmania.csv", row.names=F)
write.csv(tv.weights.victoria, file="AUTVweightsVictoria.csv", row.names=F)
