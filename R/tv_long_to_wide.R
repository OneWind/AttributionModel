query <- 'select * from a.feng_uktv_2014jan_2015jun'

data <- sqlQuery(.dwMatrix, query)

library(dplyr)
saleshouse <- data[, c("datetimemst", "saleshouse")]
saleshouse$count <- 1
saleshouse$datetimemst <- as.factor(as.character(saleshouse$datetimemst))
saleshouse2 <- group_by(saleshouse, datetimemst, saleshouse) %>% 
  summarise(count=n())


saleshouse.wide <-
  reshape(data.frame(saleshouse2), v.names="count", timevar="saleshouse",
          idvar="datetimemst", direction="wide")
saleshouse.wide[is.na(saleshouse.wide)] <- 0
saleshouse.wide$datetimemst <- 
  strptime(saleshouse.wide$datetimemst, "%Y-%m-%d %H:%M:%S")
names(saleshouse.wide)[2:ncol(saleshouse.wide)] <- 
  gsub("count.", "", names(saleshouse.wide)[2:ncol(saleshouse.wide)])
