tv.weight <- function(subchannel, coast, name) {
  if (coast == 'east') {
    tz = "'EST', 'CST', 'AST'"
  } else if (coast == 'west') {
    tz = "'PST', 'MST'"
  } else stop("wrong coast: either 'east', or 'west'")
  query1 <- 
    "select substr(cast(servertimemst as varchar(100)), 1, 16) || ':00' timetominstr, count(*) cnt
     from a.feng_ca2015_visitandtv
     where catimezone in ("
  query2 <-
    ") and subchannel in ("
  
  query3 <- 
    ")
  group by 1"
  
  subchannel <- paste("'", subchannel, "'", sep="", collapse=", ")     
  
  query <- paste(query1, tz, query2, subchannel, query3, sep="")
  
  visit.data <- sqlQuery(.dwMatrix, query)
  #  visit.data <- visit.data[order(visit.data$timetominstr), ]
  visit.data$timetomin <- strptime(visit.data$timetominstr, "%Y-%m-%d %H:%M:%S")
  
  max.time <- sqlQuery(.dwMatrix, 
                       "select substr(cast(max(servertimemst) as varchar(100)), 1, 16) || ':00'
                        from a.feng_ca2015_visitandtv")
  min.time <- sqlQuery(.dwMatrix, 
                       "select substr(cast(min(servertimemst) as varchar(100)), 1, 16) || ':00'
                       from a.feng_ca2015_visitandtv")
  
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
  tmp1 <- as.numeric(data$cnt) - as.numeric(data$baseline)
  tmp2 <- tmp1 / as.numeric(pmax(data$cnt, 1))
  tmp3 <- pmin(tmp2, 1)
  data$tvweights <- pmax(tmp3, 0)
#  data$tvweights <- pmax(pmin((data$cnt - data$baseline) / pmax(data$cnt, 1), 1), 0)
  #  data$tvweights[data$cnt < 10] <- 0
  weights.by.min <- data.frame(datetime = data$timetominstr, 
                               tvweights = data$tvweights)
  names(weights.by.min)[2] <- paste(name, "-tv", sep="")
  weights.by.min
}

setwd("c://Users//fyi/Desktop/")
### Brand search - paid ###
tv.brand.paid.east <- tv.weight('Paid Search - Brand', "east", "BrandPaid")
tv.brand.paid.west <- tv.weight('Paid Search - Brand€“', "west", "BrandPaid")

### Brand search - organic ###
tv.brand.organic.east <- tv.weight('Organic Brand', "east", "BrandOrganic")
tv.brand.organic.west <- tv.weight('Organic Brand', "west", "BrandOrganic")

### NonBrand search - paid ###
tv.nonbrand.paid.east <- tv.weight('Paid Search - NonBrand', "east", "NonBrandPaid")
tv.nonbrand.paid.west <- tv.weight('Paid Search - NonBrand€', "west", "NonBrandPaid")

### NonBrand search - organic ###
tv.nonbrand.organic.east <- tv.weight('Organic NonBrand', "east", "NonBrandOrganic")
tv.nonbrand.organic.west <- tv.weight('Organic NonBrand', "west", "NonBrandOrganic")

### Direct Homepage ###
tv.directHP.east <- tv.weight("Direct Homepage", "east", "DirectHP")
tv.directHP.west <- tv.weight("Direct Homepage", "west", "DirectHP")

### Direct Non-Homepage ###
tv.directNonHP.east <- tv.weight("Direct Non-Homepage", "east", "DirectNonHP")
tv.directNonHP.west <- tv.weight("Direct Non-Homepage", "west", "DirectNonHP")


tv.weights.east <- data.frame(datetime = tv.brand.paid.east$datetime,
                              TVBrandPaidEast = tv.brand.paid.east$"BrandPaid-tv",
                              TVBrandOrganicEast = tv.brand.organic.east$"BrandOrganic-tv",
                              TVNonBrandPaidEast = tv.nonbrand.paid.east$"NonBrandPaid-tv",
                              TVNonBrandOrganicEast = tv.nonbrand.organic.east$"NonBrandOrganic-tv",
                              TVDirectHPEast = tv.directHP.east$"DirectHP-tv",
                              TVDIrectNonHPEast = tv.directNonHP.east$"DirectNonHP-tv")
tv.weights.east[is.na(tv.weights.east)] <- 0

tv.weights.west <- data.frame(datetime = tv.brand.paid.west$datetime,
                              TVBrandPaidWest = tv.brand.paid.west$"BrandPaid-tv",
                              TVBrandOrganicWest = tv.brand.organic.west$"BrandOrganic-tv",
                              TVNonBrandPaidWest = tv.nonbrand.paid.west$"NonBrandPaid-tv",
                              TVNonBrandOrganicWest = tv.nonbrand.organic.west$"NonBrandOrganic-tv",
                              TVDirectHPWest = tv.directHP.west$"DirectHP-tv",
                              TVDIrectNonHPWest = tv.directNonHP.west$"DirectNonHP-tv")
tv.weights.west[is.na(tv.weights.west)] <- 0

write.csv(tv.weights.east, file="CATVweightsEast.csv", row.names=F)
write.csv(tv.weights.west, file="CATVweightsWest.csv", row.names=F)
