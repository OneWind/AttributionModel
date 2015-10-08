subchannel <- "Organic Brand"
tz <- "'EST', 'CST'"
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

max.time <- sqlQuery(.dwMatrix, 
                     "select substr(cast(max(servertimemst) as varchar(100)), 1, 16) || ':00'
                     from a.feng_us2015_visitandtv")
min.time <- sqlQuery(.dwMatrix, 
                     "select substr(cast(min(servertimemst) as varchar(100)), 1, 16) || ':00'
                     from a.feng_us2015_visitandtv")

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


data$date <- substr(data$timetominstr, 1, 10)
library(dplyr)
visits <- group_by(data[, c("date", "cnt")], date) %>%
  summarise(dailyvisits=sum(cnt))
visits$date <- as.Date(visits$date)
bl <- group_by(data[, c("date", "baseline")], date) %>%
  summarise(dailybaseline=sum(baseline))
bl$date <- as.Date(bl$date)
plot(visits$date, visits$dailyvisits, type="l", col="blue", lwd=2,
     xlab="day", ylab="visits", main="dailyvisits")
lines(bl$date, bl$dailybaseline, col="red", lwd=2)


jan27 <- data[data$date %in% c('2015-01-25', '2015-01-26', '2015-01-27', 
                               '2015-01-28', '2015-01-29'), ]
feb01 <- data[data$date %in% c('2015-01-30', '2015-01-31', '2015-02-01', 
                               '2015-02-02', '2015-02-03'), ]
plot(jan27$timestamp, jan27$cnt, type="l", xlab="day", ylab="visits", main="2015-01-27")
lines(jan27$timestamp, jan27$baseline, col="red", lwd=2)
plot(feb01$timestamp, feb01$cnt, type="l", xlab="day", ylab="visits", main="2015-02-01")
lines(feb01$timestamp, feb01$baseline, col="red", lwd=2)


apr15 <- data[data$date %in% c('2015-04-13', '2015-04-14', '2015-04-15',
                               '2015-04-16', '2015-04-17'), ]
plot(apr15$timestamp, apr15$cnt, type="l", xlab="day", ylab="visits", main="2015-04-15")
lines(apr15$timestamp, apr15$baseline, col="red", lwd=2)
