tv.weight <- function(subchannel, coast, name) {
  if (coast == 'east') {
    tz = "'EST', 'CST'"
  } else if (coast == 'west') {
    tz = "'PST', 'MST'"
  } else stop("wrong coast: either 'east', or 'west'")
  query1 <- 
    "select substr(cast(servertimemst as varchar(100)), 1, 16) || ':00' timetominstr, count(*) cnt
   from a.feng_us2015_visitandtv
   where ustimezone in ("
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
  
  time <- data.frame(timestamp=seq(min(visit.data$timetomin, na.rm=T), 
                                   max(visit.data$timetomin, na.rm=T), 
                                   by=60))
  time$ts.char <- as.character(time$timestamp)
  data <- merge(visit.data, time, by.x="timetominstr", by.y="ts.char", all.y=T, all.x=T)
  data$cnt[!complete.cases(data[, 1:2])] <- 0
  data <- data[order(data$timestamp), ]
  #  tmp <- data.frame(group_by(data[, c(2,5)], date) %>% summarise(count=n()))
  ### pay attention: 03/08/2015 one hour loss ###
  data$baseline <- pmax(runmed(data$cnt, k=61), 0)
  data$tvweights <- pmax(pmin((data$cnt - data$baseline) / data$cnt, 1), 0)
  #  data$tvweights[data$cnt < 10] <- 0
  weights.by.min <- data.frame(datetime = data$timetominstr, 
                               tvweights = data$tvweights)
  names(weights.by.min)[2] <- paste(name, "-tv", sep="")
  list(visits=data, weights=weights.by.min)
}

plot.idx <- (1440*7+1):(1440*14)

paid.search.brand <- tv.weight("Paid Search – Brand", "east", "Paid Search Brand")
organic.search.brand <- tv.weight("Organic Brand", "east", "Organic Search Brand")
paid.search.nonbrand <- tv.weight("Paid Search – NonBrand", "east", "Paid Search NonBrand")
organic.search.nonbrand <- tv.weight("Organic NonBrand", "east", "Organic Search NonBrand")
direct.homepage <- tv.weight("Direct Homepage", "east", "Direct Homepage")
direct.nonhomepage <- tv.weight("Direct Non-Homepage", "east", "Direct Non-Homepage")

par(mfrow=c(3, 2), mar=c(2, 2, 2, 0.5))
plot(paid.search.brand$visits$timestamp[plot.idx], paid.search.brand$visits$cnt[plot.idx],
     type="l", main="Paid Search - Brand", ylab="visits", xlab="")
lines(paid.search.brand$visits$timestamp[plot.idx], paid.search.brand$visits$baseline[plot.idx],
      lwd=3, lty=1, col="red")
plot(paid.search.nonbrand$visits$timestamp[plot.idx], 
     paid.search.nonbrand$visits$cnt[plot.idx],
     type="l", main="Paid Search - NonBrand", ylab="visits", xlab="")
lines(paid.search.nonbrand$visits$timestamp[plot.idx], 
      paid.search.nonbrand$visits$baseline[plot.idx],
      lwd=3, lty=1, col="red")
plot(organic.search.brand$visits$timestamp[plot.idx], organic.search.brand$visits$cnt[plot.idx],
     type="l", main="Organic Search - Brand", ylab="visits", xlab="")
lines(organic.search.brand$visits$timestamp[plot.idx], organic.search.brand$visits$baseline[plot.idx],
      lwd=3, lty=1, col="red")
plot(organic.search.nonbrand$visits$timestamp[plot.idx], 
     organic.search.nonbrand$visits$cnt[plot.idx],
     type="l", main="Organic Search - NonBrand", ylab="visits", xlab="")
lines(organic.search.nonbrand$visits$timestamp[plot.idx], 
      organic.search.nonbrand$visits$baseline[plot.idx],
      lwd=3, lty=1, col="red")
plot(direct.homepage$visits$timestamp[plot.idx], 
     direct.homepage$visits$cnt[plot.idx],
     type="l", main="Direct Homepage", ylab="visits", xlab="")
lines(direct.homepage$visits$timestamp[plot.idx], 
      direct.homepage$visits$baseline[plot.idx],
      lwd=3, lty=1, col="red")
plot(direct.nonhomepage$visits$timestamp[plot.idx], 
     direct.nonhomepage$visits$cnt[plot.idx],
     type="l", main="Direct Non-Homepage", ylab="visits", xlab="")
lines(direct.nonhomepage$visits$timestamp[plot.idx], 
      direct.nonhomepage$visits$baseline[plot.idx],
      lwd=3, lty=1, col="red")

partner <- tv.weight("Partners", "east", "Partners")
internal.referral <- tv.weight("Internal Referrals", "east", "Internal Referrals")
content.marketing <- tv.weight("Content Marketing", "east", "Content Marketing")
email <- tv.weight(c("Email - Programs", "Email - Campaigns"), "east", "Email - Programs & Campaigns")

par(mfrow=c(2,2), mar=c(2, 2, 2, 0.5))
plot(partner$visits$timestamp[plot.idx], partner$visits$cnt[plot.idx],
     type="l", main="Partner", ylab="visits", xlab="")
lines(partner$visits$timestamp[plot.idx], partner$visits$baseline[plot.idx],
      lwd=3, lty=1, col="red")
plot(internal.referral$visits$timestamp[plot.idx], internal.referral$visits$cnt[plot.idx],
     type="l", main="Internal Referrals", ylab="visits", xlab="")
lines(internal.referral$visits$timestamp[plot.idx], internal.referral$visits$baseline[plot.idx],
      lwd=3, lty=1, col="red")
plot(content.marketing$visits$timestamp[plot.idx], content.marketing$visits$cnt[plot.idx],
     type="l", main="Content Marketing", ylab="visits", xlab="")
lines(content.marketing$visits$timestamp[plot.idx], content.marketing$visits$baseline[plot.idx],
      lwd=3, lty=1, col="red")
plot(email$visits$timestamp[plot.idx], email$visits$cnt[plot.idx],
     type="l", main="Email - Programs & Campaigns", ylab="visits", xlab="")
lines(email$visits$timestamp[plot.idx], email$visits$baseline[plot.idx],
      lwd=3, lty=1, col="red")
