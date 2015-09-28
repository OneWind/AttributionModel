data <- read.csv("/Users/fyi/Desktop/AUTV2015.csv")
dt <- data[, c("Date", "Time", "Timezone", "Market", "Length", "Creative", "Impacts")]
dt$Date <- as.Date(dt$Date, "%m/%d/%y")
dt$datetimestr <- paste(as.character(dt$Date), dt$Time)
dt$datetime <- strptime(dt$datetimestr, "%Y-%m-%d %I:%M:%S %p")
dt$datetimestr <- as.character(dt$datetime)
dt$datetime <- NULL
dt$Date <- NULL
dt$Time <- NULL

dt$Creative <- gsub("[ ]+$", "", dt$Creative)
dt$Impacts <- gsub(",", "", dt$Impacts)
dt$Impacts <- as.numeric(as.character(dt$Impacts))


library(dplyr)
dt2 <- data.frame(group_by(dt, datetimestr, Timezone, Length, Creative) %>%
                    summarise(total.impact = sum(Impacts)))
dt3 <- data.frame(group_by(dt2, datetimestr, Timezone) %>% 
                    summarise(total.impact = sum(total.impact)))
dt3$Timezone <- as.character(dt3$Timezone)

dt3.lst <- split(dt3, rownames(dt3))
MSTtime <- sapply(dt3.lst, function(x) {
  localtime <- as.POSIXct(x$datetimestr, x$Timezone)
  MSTtime <- format(localtime, tz="US/Mountain")
})
dt3$MSTtime <- MSTtime[order(as.numeric(names(MSTtime)))]
dt3$Timezone <- gsub("[A-Za-z]+/", "", dt3$Timezone)

write.csv(dt3, file="autv.csv", row.names=F)
