data <- read.csv("/Users/fyi/Desktop/Attribution output/2014_2015 Spot Log Master Database Ancestry Canada_dat.csv",
                 stringsAsFactors=F)
data <- data[data$Clearance == "Cleared" & data$Creative != 'uncleared', 
             c("Network", "Property", "Length", "Imps..000.", "Date", "Time", "ISCI", "Creative")]
names(data)[4] <- "Imps"
row.names(data) <- 1:nrow(data)

data$Imps <- gsub("[^0-9]+", "", data$Imps)
data$Imps <- as.numeric(data$Imps)
data$Imps[is.na(data$Imps)] <- 0


data$Time <- gsub("^[ ]+|[ ]+$", "", data$Time)
time.with.second <- which(nchar(data$Time) > 8)
if (length(time.with.second) > 0) {
  for (i in time.with.second) {
    data$Time[i] <- paste(substr(data$Time[i], 1, nchar(data$Time[i])-6),
                          substr(data$Time[i], nchar(data$Time[i])-1, nchar(data$Time[i])))
  }
}

data$datetimestr <- paste(data$Date, data$Time)
data$datetime <- as.POSIXct(data$datetimestr, "%d-%b-%y %I:%M %p", tz="Canada/Eastern")

invalidtime <- which(is.na(data$datetime))
data$datetimestr[invalidtime] <- gsub("2:", "3:", data$datetimestr[invalidtime])
data$datetime[invalidtime]<- as.POSIXct(data$datetimestr[invalidtime], 
                                        "%d-%b-%y %I:%M %p", tz="Canada/Eastern")

datetimemst <- format(data$datetime, tz="US/Mountain")
data$datetimemst <- datetimemst
data$datetime <- as.character(data$datetime)
data$datetimestr <- NULL
data$Date <- NULL
data$Time <- NULL

data$Length <- as.numeric(gsub("[^0-9]+", "", data$Length))
write.csv(data, file="catv.csv", row.names=F)
