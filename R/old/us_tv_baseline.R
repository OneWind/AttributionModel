library(dplyr)

### read data ###
visits.by.min <- read.csv("/Users/fyi/Desktop/us_visits_bymin_2015.csv", header=F)
names(visits.by.min) <- c("timestamp", "visits", "visitsnotv")
visits.by.min$timestamp <- strptime(visits.by.min$timestamp, "%Y-%m-%d %H:%M:%S")
#visits.by.min <- visits.by.min[order(visits.by.min$timestamp), ]
visits.by.min$ts.char <- as.character(visits.by.min$timestamp)
visits.by.min$date.char <- substr(visits.by.min$ts.char, 1, 10)
visits.by.min$min.char <- substr(visits.by.min$ts.char, 12, 19)

### median visits by min ###
visits.by.min$visits <- as.numeric(visits.by.min$visits)
visits.by.min$visitsnotv <- as.numeric(visits.by.min$visitsnotv)
median.visits.by.min <- group_by(visits.by.min[, c("visits", "min.char")], min.char) %>%
  summarise(visits=median(visits))
median.visitsnotv.by.min <- group_by(visits.by.min[, c("visitsnotv", "min.char")], min.char) %>%
  summarise(visitsnotv=median(visitsnotv))

### fill 2015-03-08 02:00 - 03:00 due to day time saving ###
min60 <- as.character(0:59)
min60[1:10] <- paste("0", min60[1:10], sep="")
min.of.2am <- paste("02:", min60, ":00", sep="")
tmp <- data.frame(ts.char=paste("2015-03-08", min.of.2am),
                  timestamp=rep(NA, 60),
#                  visits=median.visits.by.min$median.visit,
#                  visitsnotv=median.visitsnotv.by.min$median.visitnotv,
                  date.char="2015-03-08",
                  min.char=min.of.2am, stringsAsFactors=F)
tmp <- merge(tmp, median.visits.by.min)
tmp <- merge(tmp, median.visitsnotv.by.min)
tmp <- tmp[, names(visits.by.min)]
visits.by.min <- rbind(visits.by.min, tmp)


time <- data.frame(ts.char=seq(min(visits.by.min$timestamp, na.rm=T), 
                               max(visits.by.min$timestamp, na.rm=T), 
                               by=60))
time$ts.char <- as.character(time$ts.char)
data <- merge(visits.by.min, time, by.x="ts.char", by.y="ts.char", all.y=T, all.x=T)

missing.idx <- which(is.na(data$visits))
data$timestamp[missing.idx] <- strptime(data$ts.char[missing.idx], "%Y-%m-%d %H:%M:%S")
data$visits[missing.idx] <- 0
data$visitsnotv[missing.idx] <- 0

data$visitstv <- data$visits - data$visitsnotv
data$date.char <- substr(data$ts.char, 1, 10)
data$min.char <- substr(data$ts.char, 12, 19)



data <- data[1:(100 * 24*60), ]


counts.by.day <- group_by(data[, 3:ncol(data)], date.char) %>%
  summarise(count=n())
counts.by.day[counts.by.day$count != 1440, ]

#library(TTR)
visitstv.smoothed <- runmed(data$visitstv, 61)
data$visitstv.nooutlier <- data$visitstv
over2000 <- which(data$visitstv > 2000)
data$visitstv.nooutlier[over2000] <- visitstv.smoothed[over2000]

tv.visits <- ts(data$visitstv.nooutlier, frequency=24*60)
tv.visits.comp <- decompose(tv.visits)
plot(tv.visits.comp)

#tv.visits.2 <- tv.visits  - tv.visits.comp$seasonal - tv.visits.comp$random
#tv.visits.2 <- tv.visits.comp$trend
#tv.tmp <- data.frame(date=data$date.char, visits2=as.numeric(tv.visits.2))
#tv.by.day <- group_by(tv.tmp, date) %>%
#  summarise(visits2=sum(visits2))

#tv.by.day.ts <- ts(tv.by.day$visits2, frequency=7)
#tv.by.day.comp <- decompose(tv.by.day.ts)
#plot(tv.by.day.comp)

#seasonal.weekly <- rep(tv.by.day.comp$seasonal / (24*60), each=24*60)
seasonal.minutely <- tv.visits.comp$seasonal
#lift.weekly <- min(min(tv.by.day.comp$trend, na.rm=T), abs(min(tv.by.day.comp$random, na.rm=T)))
#trends.weekly <- rep(tv.by.day.comp$trend / (24*60), each=24*60) - rep(lift.weekly / (24*60), (24 * 60))
lift.minutely <- min(min(tv.visits.comp$trend, na.rm=T), abs(min(tv.visits.comp$random, na.rm=T)))
trends.minutely <- tv.visits.comp$trend - lift.minutely
#random.weekly <- pmax(rep(tv.by.day.comp$random / (24*60), each=24*60) + rep(lift.weekly / (24*60), (24 * 60)), 0)
random.minutely <- pmax(tv.visits.comp$random + lift.minutely, 0)

baseline <- pmax(data$visitsnotv + seasonal.minutely + trends.minutely, 0)
plot(baseline, type="l")

data$visitstv.baseline <- baseline
data$tvratio <- pmin(pmax(data$visits - data$visitstv.baseline, 0) / data$visits, 1)
hist(data$tvratio, main="TV visits / Total visits ratio")
