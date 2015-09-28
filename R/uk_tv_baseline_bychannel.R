tv.weight <- function(subchannel, name) {
  query1 <- 
    "select substr(cast(servertimemst as varchar(100)), 1, 16) || ':00' timetominstr, count(*) cnt
     from a.feng_uk2015_visitandtv
     where subchannel in ("
  query2 <- 
    ")
  group by 1"
  
  subchannel <- paste("'", subchannel, "'", sep="", collapse=", ")     
  
  query <- paste(query1, subchannel, query2, sep="")
  
  visit.data <- sqlQuery(.dwMatrix, query)
  #  visit.data <- visit.data[order(visit.data$timetominstr), ]
  visit.data$timetomin <- strptime(visit.data$timetominstr, "%Y-%m-%d %H:%M:%S")
  
  max.time <- sqlQuery(.dwMatrix, 
                       "select substr(cast(max(servertimemst) as varchar(100)), 1, 16) || ':00'
                        from a.feng_uk2015_visitandtv")
  min.time <- sqlQuery(.dwMatrix, 
                       "select substr(cast(min(servertimemst) as varchar(100)), 1, 16) || ':00'
                        from a.feng_uk2015_visitandtv")
  
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
tv.brand.paid <- tv.weight('Paid Search – Brand', "BrandPaid")

### Brand search - organic ###
tv.brand.organic <- tv.weight('Organic Brand', "BrandOrganic")

### NonBrand search - paid ###
tv.nonbrand.paid <- tv.weight('Paid Search – NonBrand', "NonBrandPaid")

### NonBrand search - organic ###
tv.nonbrand.organic <- tv.weight('Organic NonBrand', "NonBrandOrganic")

### Direct Homepage ###
tv.directHP <- tv.weight("Direct Homepage", "DirectHP")

### Direct Non-Homepage ###
tv.directNonHP <- tv.weight("Direct Non-Homepage", "DirectNonHP")


tv.weights <- data.frame(datetime = tv.brand.paid$datetime,
                              TVBrandPaid = tv.brand.paid$"BrandPaid-tv",
                              TVBrandOrganic = tv.brand.organic$"BrandOrganic-tv",
                              TVNonBrandPaid = tv.nonbrand.paid$"NonBrandPaid-tv",
                              TVNonBrandOrganic = tv.nonbrand.organic$"NonBrandOrganic-tv",
                              TVDirectHP = tv.directHP$"DirectHP-tv",
                              TVDIrectNonHP = tv.directNonHP$"DirectNonHP-tv")
tv.weights[is.na(tv.weights)] <- 0


write.csv(tv.weights, file="UK_TVweights.csv", row.names=F)
