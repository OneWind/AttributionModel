library(dplyr)
library(caTools)

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




data <- data[1:(14 * 24*60), ]

### daily minimum ###
daily.min <- group_by(data[, c("visitstv", "date.char")], date.char) %>%
  summarise(mn = sort(visitstv)[11]) ### it is ACTUALLY is 11th lowest point
data$daily.min <- rep(daily.min$mn, each=24*60)
data$visitstv.remove.daily.min <- data$visitstv - data$daily.min
#data$visitstv.remove.daily.min <- pmax(data$visitstv - data$daily.min, 0)
#data$visitstv.correction <- pmax(data$daily.min - data$visitstv, 0)  ### for lowest 10 points

data$visitstv.moving.median <- runmed(data$visitstv.remove.daily.min, k=91)
data$visitstv.remaining <- data$visitstv.remove.daily.min - data$visitstv.moving.median


remaining.baseline <- runquantile(data$visitstv.remaining, k=61, probs=0.5)
remaining.baseline <- stats::filter(remaining.baseline, 
                                    filter = c(1/12, 1/8, 1/6, 1/4, 1/6, 1/8, 1/12), sides=2)
data$visitstv.baseline0 <- data$visitstv.moving.median + remaining.baseline
data$visitstv.baseline <- data$visitstv.baseline0 + data$daily.min

plot(data$visitstv, type="l")
lines(data$visitstv.baseline, col="red", lwd=3)

par(mfrow=c(2, 2), mar=c(2, 2, 0, 0))
plot(data$visitstv[(1+1440*0):(1440*1)], type="l", ylab="visits", xlab="")
lines(data$visitstv.baseline[(1+1440*0):(1440*1)], col="red", lwd=2)
plot(data$visitstv[(1+1440*1):(1440*2)], type="l", ylab="visits", xlab="")
lines(data$visitstv.baseline[(1+1440*1):(1440*2)], col="red", lwd=2)
plot(data$visitstv[(1+1440*2):(1440*3)], type="l")
lines(data$visitstv.baseline[(1+1440*2):(1440*3)], col="red", lwd=2)
plot(data$visitstv[(1+1440*3):(1440*4)], type="l", ylab="visits", xlab="")
lines(data$visitstv.baseline[(1+1440*3):(1440*4)], col="red", lwd=2)
plot(data$visitstv[(1+1440*4):(1440*5)], type="l", ylab="visits", xlab="")
lines(data$visitstv.baseline[(1+1440*4):(1440*5)], col="red", lwd=2)
plot(data$visitstv[(1+1440*5):(1440*6)], type="l", ylab="visits", xlab="")
lines(data$visitstv.baseline[(1+1440*5):(1440*6)], col="red", lwd=2)
plot(data$visitstv[(1+1440*6):(1440*7)], type="l", ylab="visits", xlab="")
lines(data$visitstv.baseline[(1+1440*6):(1440*7)], col="red", lwd=2)
plot(data$visitstv[(1+1440*7):(1440*8)], type="l", ylab="visits", xlab="")
lines(data$visitstv.baseline[(1+1440*7):(1440*8)], col="red", lwd=2)


library(fitdistrplus)
f1 <- fitdist(as.numeric(data$visitstv.remaining), "norm")
tmp <- sort(data$visitstv.remaining)
tmp <- tmp[tmp > -100]
visitstv.remaining.cen <- data.frame(left = tmp, right = tmp)
visitstv.remaining.cen$right[visitstv.remaining.cen$right > quantile(data$visitstv.remaining, 0.9)] <- NA
f2 <- fitdistcens(visitstv.remaining.cen, "norm")

### big question: how to filter out noise ###

### no seasonality and trends until long-term effect ###
