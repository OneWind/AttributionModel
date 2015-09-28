### step 1: xlsx saved as csv ###
# in excel #

### step 2: only keep the data with clearance = 'cleared' ###
data.org <- read.csv("2014_2015 Ancestry US Master Spot Log FINANCE2.csv")
data <- data.org[, c("Property", "Length", "Full.Rate", "Rate", "Imps..000.", "Date", "Time",
                     "Clearance", "Network", "Uniform.Network", "ISCI", "ISCI.Adjusted", "Creative.Title")]
data <- data[data$Clearance == 'Cleared', ]


### step 3: clean the data ###
# 1. 'Length': remove heading and tailing space, and convert to integer #
data$Length <- gsub("[^0-9]+", "", data$Length)

# 2. 'Full.Rate', 'Rate': remove "$" and ",", and convert to numeric #
data$Full.Rate <- gsub("[^0-9]+", "", data$Full.Rate)
data$Full.Rate <- as.numeric(data$Full.Rate)
data$Full.Rate[is.na(data$Full.Rate)] <- 0

data$Rate <- gsub("[^0-9]+", "", data$Rate)
data$Rate <- as.numeric(data$Rate)
data$Rate[is.na(data$Rate)] <- 0

# 3. "Imps..000." -> "Imps000", remove non-numeric characters, and convert to numeric #
names(data)[grep("Imps", names(data))] <- "Imps000"
data$Imps000 <- gsub("[^0-9]+", "", data$Imps000)
data$Imps000 <- as.numeric(data$Imps000)
data$Imps000[is.na(data$Imps000)] <- 0

# 4. create timestamp #
data$timestampstr <- paste(data$Date, data$Time)
data$timestamp <- strptime(data$timestampstr, "%m/%d/%y %I:%M:%S %p")

# 5. remove "Date", "Time", "Clearance"
data$Date <- NULL
data$Time <- NULL
data$Clearance <- NULL
data$timestampstr <- NULL

### step 4: split data into commercial and wdytya, using "wdytya" in "property" ###
#row.wdytya <- grep("wdytya", tolower(data$Property))
#WDYTYA <- data[row.wdytya, ]
#USTV <- data[setdiff(1:nrow(data), row.wdytya), ]


### save the data ###
#write.csv(WDYTYA, file="wdytya.csv", row.names=F, quote=1:ncol(WDYTYA))
#write.csv(USTV, file="ustv.csv", row.names=F, quote=1:ncol(USTV))
write.csv(data, file="ustv.csv", row.names=F, quote=1:ncol(data))
