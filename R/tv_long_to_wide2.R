library(dplyr)
query <- "select * 
          from a.feng_uktv_2014jan_2015jun
          where impactalladults > 0
         "

uktv <- sqlQuery(.dwMatrix, query)
uktv$datetimemst <- as.character(uktv$datetimemst)

saleshouse0 <- uktv[, c("datetimemst", "saleshouse")]
saleshouse0$ind <- 1
saleshouse1 <- data.frame(group_by(saleshouse0, datetimemst, saleshouse) %>% summarise(count=sum(ind)))
saleshouse <- reshape(saleshouse1, v.names="count", timevar="saleshouse", 
                      idvar="datetimemst", direction="wide")
names(saleshouse)[2:ncol(saleshouse)] <- gsub("count.", "", names(saleshouse)[2:ncol(saleshouse)])
names(saleshouse)[2:ncol(saleshouse)] <- gsub(" ", "", names(saleshouse)[2:ncol(saleshouse)])
saleshouse[is.na(saleshouse)] <- 0

write.csv(saleshouse, "saleshouse.csv", row.names=F)



creative0 <- uktv[, c("datetimemst", "creative")]
creative0$ind <- 1
creative1 <- data.frame(group_by(creative0, datetimemst, creative) %>% summarise(count=sum(ind)))
creative <- reshape(creative1, v.names="count", timevar="creative", 
                      idvar="datetimemst", direction="wide")
names(creative)[2:ncol(creative)] <- gsub("count.", "", names(creative)[2:ncol(creative)])
names(creative)[2:ncol(creative)] <- gsub("[ ]+", "", names(creative)[2:ncol(creative)])
names(creative)[2:ncol(creative)] <- gsub("[-]+", "", names(creative)[2:ncol(creative)])
creative[is.na(creative)] <- 0

write.csv(creative, "creative.csv", row.names=F)
