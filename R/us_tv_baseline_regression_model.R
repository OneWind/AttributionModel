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


ustv <- read.csv("/Users/fyi/Desktop/ustv.csv", stringsAsFactors=F)


full.data <- merge(data, ustv, by.x="ts.char", by.y="datetimemst", all.x=T)

full.data[(ncol(data)+1):ncol(full.data)][is.na(full.data[(ncol(data)+1):ncol(full.data)])] <- 0
spots100 <- which(colSums(full.data[(ncol(data)+1):ncol(full.data)]) >= 100) + ncol(data)
final.data <- full.data[, c(1:ncol(data), spots100)]
#final.data$fivemin.tv.visits <- 0
#for (i in 1:nrow(final.data)) {
#  final.data$fivemin.tv.visits <- sum(final.data$visitstv[i:min(i+4, nrow(final.data))])
#}

formula <- paste("visitstv ~ ", paste(names(final.data)[(ncol(data)+1):(ncol(final.data))], collapse = " + "))
m1 <- lm(formula, data=final.data)

library(mgcv)
set.seed(100)
M <- list(X = matrix(0, nrow(final.data), ncol(final.data) - ncol(data) + 2),
          p = runif(ncol(final.data) - ncol(data) + 2, 0, 1) * 100,
          off = array(0, 0),
          S = list(),
          Ain = diag(c(0, rep(1, 1, ncol(final.data) - ncol(data)), 0)),
          bin = rep(0, ncol(final.data) - ncol(data) + 2),
          C = matrix(0, 0, 0),
          sp = array(0, 0),
          y = final.data$visitstv,
          w = final.data$visitstv * 0 + 1)
M$X[, 1] <- 1
M$X[, 2:(ncol(final.data) - ncol(data) + 1)] <- as.matrix.data.frame(final.data[, (ncol(data)+1):(ncol(final.data))])
tmp <- runmed(final.data$visitstv, k=61)
M$X[, (ncol(final.data) - ncol(data) + 2)] <- rep(tmp)

pcls(M) -> M$p

y.bl <- cbind(1, tmp) %*% M$p[c(1, length(M$p))]
plot(final.data$visitstv[1:(1440*3)], type="l")
lines(y.bl[1:(1440*3)], col="red", lwd=2)
